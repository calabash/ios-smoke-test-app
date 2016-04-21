require 'calabash-cucumber/launcher'

module LaunchControl
  @@launcher = nil

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end

  def self.xcode
    Calabash::Cucumber::Environment.xcode
  end

  def self.instruments
    Calabash::Cucumber::Environment.instruments
  end

  def self.simctl
    Calabash::Cucumber::Environment.simctl
  end

  def self.environment
    {
      :simctl => self.simctl,
      :instruments => self.instruments,
      :xcode => self.xcode
    }
  end

  def self.target
    ENV['DEVICE_TARGET'] || RunLoop::Core.default_simulator
  end

  def self.target_is_simulator?
    self.launcher.simulator_target?
  end

  def self.target_is_physical_device?
    self.launcher.device_target?
  end

  def self.ensure_ipa
    ipa_path = File.expand_path("./xtc-submit-calabash-linked/CalSmoke-cal.ipa")
    unless File.exist?(ipa_path)
      system("make", "ipa-cal")
    end
    ipa_path
  end

  def self.install_on_physical_device
    Calabash::IDeviceInstaller.new(self.ensure_ipa, self.target).install_app
  end

  def self.ensure_app_installed_on_device
    ideviceinstaller = Calabash::IDeviceInstaller.new(self.ensure_ipa, self.target)
    unless ideviceinstaller.app_installed?
      ideviceinstaller.install_app
    end
  end
end

Before("@no_relaunch") do
  @no_relaunch = true
end

Before("@reset_app_btw_scenarios") do
  if xamarin_test_cloud? || LaunchControl.target_is_simulator?
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
  else
    LaunchControl.install_on_physical_device
  end
end

Before("@reset_device_settings") do
  if xamarin_test_cloud?
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
  elsif LaunchControl.target_is_simulator?
    target = LaunchControl.target
    device = RunLoop::Device.device_with_identifier(target, LaunchControl.environment)
    RunLoop::CoreSimulator.erase(device)
  else
    LaunchControl.install_on_physical_device
  end
end

Before do |scenario|
  launcher = LaunchControl.launcher

  options = {
    #:uia_strategy => :host
    #:uia_strategy => :shared_element
    #:uia_strategy => :preferences
  }

  relaunch = true

  if @no_relaunch
    begin
      launcher.ping_app
      attach_options = options.dup
      attach_options[:timeout] = 1
      launcher.attach(attach_options)
      relaunch = launcher.device == nil
    rescue => e
      RunLoop.log_info2("Tag says: don't relaunch, but cannot attach to the app.")
      RunLoop.log_info2("#{e.class}: #{e.message}")
      RunLoop.log_info2("The app probably needs to be launched!")
    end
  end

  if relaunch
    launcher.relaunch(options)
  end

  ENV["RESET_BETWEEN_SCENARIOS"] = "0"

  # Re-installing the app on a device does not clear the Keychain settings,
  # so we must clear them manually.
  if scenario.source_tag_names.include?("@reset_device_settings")
    if xamarin_test_cloud? || LaunchControl.target_is_physical_device?
      keychain_clear
    end
  end
end

After do |scenario|
  @no_relaunch = false

  # Calabash can shutdown the app cleanly by calling the app life cycle methods
  # in the UIApplicationDelegate.  This is really nice for CI environments, but
  # not so good for local development.
  #
  # See the documentation for NO_STOP for a nice debugging workflow
  #
  # http://calabashapi.xamarin.com/ios/file.ENVIRONMENT_VARIABLES.html#label-NO_STOP
  # http://calabashapi.xamarin.com/ios/Calabash/Cucumber/Core.html#console_attach-instance_method
  unless launcher.calabash_no_stop?
    calabash_exit
    sleep 1.0
  end
end

