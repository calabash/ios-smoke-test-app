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

    def initialize(path_to_ipa, udid_or_name, path_to_binary=nil)
      @binary = IDeviceInstaller.expect_binary(path_to_binary)

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

    def install_app
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
    end

    def self.available_devices
      @available_devices ||= RunLoop::XCTools.new.instruments(:devices)
    end

    def retriable_intervals
      Array.new(DEFAULT_RETRYABLE_OPTIONS[:tries],
                DEFAULT_RETRYABLE_OPTIONS[:interval])
    end

    def timeout
      DEFAULT_RETRYABLE_OPTIONS[:timeout]
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
        Timeout.timeout(timeout, TimeoutError) do
          result = exec_with_open3(args)
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
        Open3.popen3(binary, *args) do  |_, stdout,  stderr, process_status|
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
      end
    end
  end
end
