require 'tmpdir'
require 'fileutils'
require 'open3'
require 'run_loop'

module Calabash

  # A model of the an .ipa - a application binary for iOS devices.
  class IPA


    # The path to this .ipa.
    # @!attribute [r] path
    # @return [String] A path to this .ipa.
    attr_reader :path

    # The bundle identifier of this ipa.
    # @!attribute [r] bundle_identifier
    # @return [String] The bundle identifier of this ipa; obtained by inspecting
    #  the app's Info.plist.
    attr_reader :bundle_identifier

    # Create a new ipa instance.
    # @param [String] path_to_ipa The path the .ipa file.
    # @return [Calabash::IPA] A new ipa instance.
    # @raise [RuntimeError] If the file does not exist.
    # @raise [RuntimeError] If the file does not end in .ipa.
    def initialize(path_to_ipa)
      unless File.exist? path_to_ipa
        raise "Expected an ipa at '#{path_to_ipa}'"
      end

      unless path_to_ipa.end_with?('.ipa')
        raise "Expected '#{path_to_ipa}' to be"
      end
      @path = path_to_ipa
    end

    # @!visibility private
    def to_s
      "#<IPA: #{bundle_identifier}: '#{path}'>"
    end

    # The bundle identifier of this ipa.
    # @return [String] A string representation of this ipa's CFBundleIdentifier
    # @raise [RuntimeError] If ipa does not expand into a Payload/<app name>.app
    #  directory.
    # @raise [RuntimeError] If an Info.plist does exist in the .app.
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

  # A wrapper around the ideviceinstaller tool.
  #
  # @note libimobiledevice, ideviceinstaller, and homebrew are third-party
  #  tools.  Please don't report problems with these tools on the Calabash
  #  support channels.  We don't maintain them, we just use them.
  #
  # @see http://www.libimobiledevice.org/
  # @see https://github.com/libimobiledevice/libimobiledevice
  # @see https://github.com/libimobiledevice/ideviceinstaller
  # @see http://brew.sh/
  class IDeviceInstaller

    # The default Retriable and Timeout options.  ideviceinstaller is a good
    # tool.  Experience has shown that it takes no more than 2 tries to
    # install an ipa.  You can override these defaults by passing arguments
    # to the initializer.
    DEFAULT_RETRYABLE_OPTIONS =
          {
                :tries => 2,
                :interval => 1,
                :timeout => 10
          }
    # Raised when the ideviceinstaller binary cannot be found.
    class BinaryNotFound < RuntimeError; end

    # Raised when a IPA instance cannot be created.
    class CannotCreateIPA < RuntimeError; end

    # Raised when the specified device cannot be found.
    class DeviceNotFound < RuntimeError; end

    # Raised when there is a problem installing an ipa on the target device.
    class InstallError < RuntimeError; end

    # Raised when there is a problem uninstalling an ipa on the target device.
    class UninstallError < RuntimeError; end

    # Raised when the command line invocation of ideviceinstaller fails.
    class InvocationError < RuntimeError; end

    # The path to the ideviceinstaller binary.
    # @!attribute [r] binary
    # @return [String] A path to the ideviceinstaller binary.
    attr_reader :binary

    # The ipa to install.
    # @!attribute [r] ipa
    # @return [Calabash::IPA] The ipa to install.
    attr_reader :ipa

    # The udid of the device to install the ipa on.
    # @!attribute [r] udid
    # @return [String] The udid of the device to install the ipa on.
    attr_reader :udid

    # The number of times to try any ideviceinstaller command.  This is an
    # option for Retriable.retriable.
    # @!attribute [r] tries
    # @return [Numeric] The number of times to try any ideviceinstaller command.
    attr_reader :tries

    # How long to wait before retrying a failed ideviceinstaller command.  This
    # is an option for Retriable.retriable.
    # @!attribute [r] interval
    # @return [Numeric] How long to wait before retrying a failed
    #   ideviceinstaller command.
    attr_reader :interval

    # How long to wait for any ideviceinstaller command to complete before
    # timing out.  This is an option to Timeout.timeout.
    # @!attribute [r] timeout
    # @return [Numeric] How long to wait for any ideviceinstaller command to
    #   complete before timing out.
    attr_reader :timeout

    # Create an instance of an installer.
    #
    # The target device _must_ be connected via USB to the host machine.
    #
    # @param [String] path_to_ipa The path to ipa to install.
    # @param [String] udid_or_name The udid or name of the device to install
    #  the ipa on.
    # @param [Hash] options Options to control the behavior of the installer.
    #
    # @option options [Numeric] :tries (2) The number of times to retry a failed
    #  ideviceinstaller command.
    # @option options [Numeric] :interval (1.0) How long to wait before retrying
    #   a failed ideviceinstaller command.
    # @option options [Numeric] :timeout (10) How long to wait for any
    #   ideviceinstaller command to complete before timing out.
    # @option options [String] :path_to_binary (/usr/local/bin/ideviceinstaller)
    #   The full path the ideviceinstaller library.
    #
    # @return [Calabash::IDeviceInstaller] A new instance of IDeviceInstaller.
    #
    # @raise [BinaryNotFound] If no ideviceinstaller binary can be found on the
    #  system.
    # @raise [CannotCreateIPA] If an IPA instance cannot be created from the
    #  `path_to_ipa`.
    # @raise [DeviceNotFound] If the device specified by `udid_or_name` cannot
    #  be found.
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
    end

    # @!visibility private
    def to_s
      "#<Installer: #{binary} #{ipa.path} #{udid}>"
    end

    def app_installed?
      args = ['--udid', udid, '--list-apps']
      hash = execute_ideviceinstaller_cmd(args)
      hash[:out].split(/\s/).include? ipa.bundle_identifier
    end

    # Install the ipa on the target device.
    #
    # @note IMPORTANT If the app is already installed, uninstall it first.
    #   If you don't want to reinstall, use `ensure_app_installed` instead of
    #   this method.
    #
    # @note The 'ideviceinstaller --install' command does not overwrite an app
    #  if it is already installed on a device.
    #
    # @see Calabash::IDeviceInstaller#ensure_app_installed
    #
    # @return [Boolean] Return true if the app was installed.
    # @raise [InstallError] If the app was not installed.
    # @raise [UninstallError] If the app was not uninstalled.
    def install_app
      uninstall_app if app_installed?

      args = ['--udid', udid, '--install', ipa.path]
      execute_ideviceinstaller_cmd(args)

      unless app_installed?
        raise InstallError, "Could not install '#{ipa}' on '#{udid}'"
      end
      true
    end

    # Ensure the ipa has been installed on the device.  If the app is already
    # installed, do nothing.  Otherwise, install the app.
    #
    # @return [Boolean] Return true if the app was installed.
    # @raise [InstallError] If the app was not installed.
    def ensure_app_installed
      return true if app_installed?
      install_app
    end

    # Uninstall the ipa from the target_device.
    #
    # @return [Boolean] Return true if the app was uninstalled.
    # @raise [UninstallError] If the app was not uninstalled.
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

    # @!visibility private
    attr_reader :stdin, :stdout, :stderr, :pid

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

      on = [InvocationError]
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
        result = exec_with_open3(args)

        exit_status = result[:exit_status]
        if exit_status != 0
          raise InvocationError, "Could not execute:\n #{binary} #{args.join(' ')}"
        end
      end
      result
    end

    def exec_with_open3(args)
      begin
        @stdin, @stdout, out, @stderr, err, process_status, @pid, exit_status = nil
        Timeout.timeout(timeout, TimeoutError) do
          @stdin, @stdout, @stderr, process_status = Open3.popen3(binary, *args)

          @pid = process_status.pid
          exit_status = process_status.value.exitstatus

          err = @stderr.read.chomp
          if err && err != ''
            unless err[/iTunesMetadata.plist/,0] || err[/SC_Info/,0]
              puts "ERROR: #{err}"
            end
          end
          out = @stdout.read.chomp
        end
        {
              :err => err,
              :out => out,
              :pid => pid,
              :exit_status => exit_status
        }
      rescue StandardError => e
        raise InvocationError, e
      ensure
        stdin.close if stdin && !stdin.closed?
        stdout.close if stdout && !stdout.closed?
        stderr.close if stderr && !stderr.closed?

        if pid
          terminator = RunLoop::ProcessTerminator.new(pid, 'TERM', binary)
          unless terminator.kill_process
            terminator = RunLoop::ProcessTerminator.new(pid, 'KILL', binary)
            terminator.kill_process
          end
        end

        if process_status
          process_status.join
        end
      end
    end
  end
end
