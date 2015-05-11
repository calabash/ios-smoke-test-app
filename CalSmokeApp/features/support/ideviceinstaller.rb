require 'tmpdir'
require 'fileutils'
require 'open3'
require 'run_loop'

module Calabash

  class IPA

    attr_reader :path
    attr_reader :bundle_identifier

    def initialize(path_to_ipa)
      unless File.exist? path_to_ipa
        raise "Expected an ipa at '#{path_to_ipa}'"
      end

      unless path_to_ipa.end_with?('.ipa')
        raise "Expected '#{path_to_ipa}' to be"
      end
      @path = path_to_ipa
    end

    def to_s
      "#<IPA: #{bundle_identifier}: '#{path}'>"
    end

    def bundle_identifier
      unless File.exist?(bundle_dir)
        raise "Expected a '#{File.basename(path).split('.').first}.app'\nat path '#{payload_dir}'"
      end

      @bundle_identifier ||= lambda {
        info_plist_path = File.join(bundle_dir, 'Info.plist')
        unless File.exist? info_plist_path
          raise "Expected an 'Info.plist' at '#{bundle_dir}'"
        end
        pbuddy = RunLoop::PlistBuddy.new
        pbuddy.plist_read('CFBundleIdentifier', info_plist_path)
      }.call
    end

    private

    def tmpdir
      @tmpdir ||= Dir.mktmpdir
    end

    def payload_dir
      @payload_dir ||= lambda {
        FileUtils.cp(path, tmpdir)
        zip_path = File.join(tmpdir, File.basename(path))
        Dir.chdir(tmpdir) do
          system('unzip', *['-q', zip_path])
        end
        File.join(tmpdir, 'Payload')
      }.call
    end

    def bundle_dir
      @bundle_dir ||= lambda {
        Dir.glob(File.join(payload_dir, '*')).detect {|f| File.directory?(f) && f.end_with?('.app')}
      }.call
    end
  end

  class IDeviceInstaller

    DEFAULT_RETRYABLE_OPTIONS =
          {
                :tries => 2,
                :interval => 1,
                :timeout => 10
          }

    class BinaryNotFound < RuntimeError; end
    class CannotCreateIPA < RuntimeError; end
    class DeviceNotFound < RuntimeError; end
    class InstallError < RuntimeError; end
    class UninstallError < RuntimeError; end
    class InvocationError < RuntimeError; end

    attr_reader :binary
    attr_reader :ipa
    attr_reader :udid
    attr_reader :tries
    attr_reader :interval
    attr_reader :timeout

    def initialize(path_to_ipa, udid_or_name, options={})
      merged_opts = DEFAULT_RETRYABLE_OPTIONS.merge(options)

      @binary = IDeviceInstaller.expect_binary(merged_opts[:path_to_binary])

      begin
        @ipa = Calabash::IPA.new(path_to_ipa)
      rescue RuntimeError => e
        raise CannotCreateIPA, e
      end

      match = IDeviceInstaller.available_devices.detect do |device|
        device.udid == udid_or_name || device.name == udid_or_name
      end

      unless match
        raise DeviceNotFound, "Expected to find a device with name or udid '#{udid_or_name}'"
      end

      @udid = match.udid

      @tries = merged_opts[:tries]
      @interval = merged_opts[:interval]
      @timeout = merged_opts[:timeout]

      @mutex = Mutex.new
    end

    def binary
      @binary
    end

    def to_s
      "#<Installer: #{binary} #{ipa.path} #{udid}>"
    end

    def app_installed?
      args = ['--udid', udid, '--list-apps']
      hash = execute_ideviceinstaller_cmd(args)
      hash[:out].split(/\s/).include? ipa.bundle_identifier
    end

    # ideviceinstaller --install does not overwrite an existing app.
    def install_app
      uninstall_app if app_installed?

      args = ['--udid', udid, '--install', ipa.path]
      execute_ideviceinstaller_cmd(args)

      unless app_installed?
        raise InstallError, "Could not install '#{ipa}' on '#{udid}'"
      end
      true
    end

    def ensure_app_installed
      return true if app_installed?
      install_app
    end

    def uninstall_app
      return true unless app_installed?
      args = ['--udid', udid, '--uninstall', ipa.bundle_identifier]
      execute_ideviceinstaller_cmd(args)
      if app_installed?
        raise UninstallError, "Could not uninstall '#{ipa}' on '#{udid}'"
      end
      true
    end

    private

    def self.homebrew_binary
      '/usr/local/bin/ideviceinstaller'
    end

    def self.binary_in_path
      which = self.shell_out('which ideviceinstaller')
      if which.nil? || which.empty?
        nil
      else
        which
      end
    end

    def self.shell_out(cmd)
      `#{cmd}`.strip
    end

    def self.select_binary(user_supplied=nil)
      user_supplied || self.binary_in_path || self.homebrew_binary
    end

    def self.expect_binary(user_supplied=nil)
      binary = self.select_binary(user_supplied)
      unless File.exist?(binary)
        if user_supplied
          raise BinaryNotFound, "Expected binary at '#{user_supplied}'"
        else
          raise BinaryNotFound,
                ["Expected binary to be $PATH or '/usr/local/bin/ideviceinstaller'",
                 'You must install ideviceinstaller to use this class.',
                 'We recommend installing ideviceinstaller with homebrew'].join("\n")
        end
      end
      binary
    end

    # Expensive!  Avoid calling this more than 1x.  This cannot be memoized
    # into a class variable or class instance variable because the state will
    # change when devices attached/detached or join/leave the network.
    def self.available_devices
      RunLoop::XCTools.new.instruments(:devices)
    end

    def retriable_intervals
      Array.new(tries, interval)
    end

    def execute_ideviceinstaller_cmd(args)

      result = {}

      on = [Timeout::Error, InvocationError]
      on_retry = Proc.new do |_, try, elapsed_time, next_interval|
          puts "INFO: ideviceinstaller: attempt #{try} failed in '#{elapsed_time}'; will retry in '#{next_interval}'"
      end

      options =
            {
                  intervals: retriable_intervals,
                  on_retry: on_retry,
                  on: on
            }

      Retriable.retriable(options) do
        begin
          Timeout.timeout(timeout, TimeoutError) do
            result = exec_with_open3(args)
          end
        ensure
          ensure_popen3_clean_exit
        end

        exit_status = result[:exit_status]
        if exit_status != 0
          raise InvocationError, "Could not execute:\n #{binary} #{args.join(' ')}"
        end
      end
      result
    end

    def exec_with_open3(args)
      begin
        Open3.popen3(binary, *args) do  |stdin, stdout, stderr, process_status|
          @mutex.synchronize do
            @popen_pid = process_status.pid
            @popen_stdin = stdin
            @popen_stdout = stdout
            @popen_stderr = stderr
          end
          err = stderr.read.strip
          if err && err != ''
            unless err[/iTunesMetadata.plist/,0] || err[/SC_Info/,0]
              puts "ERROR: #{err}"
            end
          end
          {
                :err => err,
                :out => stdout.read.strip,
                :pid => process_status.pid,
                :exit_status => process_status.value.exitstatus
          }
        end
      rescue StandardError => e
        raise InvocationError, e
      ensure
        ensure_popen3_clean_exit
      end
    end

    def ensure_popen3_clean_exit
      @mutex.synchronize do
        @popen_stdin.close if @popen_stdin && !@popen_stdin.closed?
        @popen_stdout.close if @popen_stdout && !@popen_stdout.closed?
        @popen_stderr.close if @popen_stderr && !@popen_stderr.closed?

        if @popen_pid
          terminator = RunLoop::ProcessTerminator.new(@popen_pid, 'TERM', binary)
          unless terminator.kill_process
            terminator = RunLoop::ProcessTerminator.new(@popen_pid, 'KILL', binary)
            terminator.kill_process
          end
        end
      end
    end
  end
end
