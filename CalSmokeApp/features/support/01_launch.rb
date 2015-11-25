require 'calabash-cucumber/launcher'

module LaunchControl
  @@launcher = nil

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end

  def self.target
    ENV['DEVICE_TARGET'] || RunLoop::Core.default_simulator
  end

  def self.target_is_simulator?
    RunLoop::Core.simulator_target?({:device_target => self.target})
  end

  def self.target_is_physical_device?
    !self.target_is_simulator?
  end

  def self.ensure_ipa
    ipa_path = File.expand_path('./xtc-staging/CalSmoke-cal.ipa')
    unless File.exist?(ipa_path)
      system('make', 'ipa-cal')
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

Before('@reset_app_btw_scenarios') do
  if xamarin_test_cloud? || LaunchControl.target_is_simulator?
    ENV['RESET_BETWEEN_SCENARIOS'] = '1'
  else
    LaunchControl.install_on_physical_device
  end
end

Before('@reset_device_settings') do
  if xamarin_test_cloud?
    ENV['RESET_BETWEEN_SCENARIOS'] = '1'
  elsif LaunchControl.target_is_simulator?
    target = LaunchControl.target
    instruments = RunLoop::Instruments.new
    xcode = instruments.xcode
    device = instruments.simulators.find do |sim|
      sim.udid == target || sim.instruments_identifier(xcode) == target
    end

    RunLoop::CoreSimulator.erase(device)
  else
    LaunchControl.install_on_physical_device
  end
end

Before do |scenario|
  launcher = LaunchControl.launcher

  options = {
    :uia_strategy => :host
    #:uia_strategy => :shared_element
    #:uia_strategy => :preferences
  }

  launcher.relaunch(options)
  launcher.calabash_notify(self)

  ENV['RESET_BETWEEN_SCENARIOS'] = '0'

  # Re-installing the app on a device does not clear the Keychain settings,
  # so we must clear them manually.
  if scenario.source_tag_names.include?('@reset_device_settings')
    if xamarin_test_cloud? || LaunchControl.target_is_physical_device?
      keychain_clear
    end
  end
end

After do |_|

end

