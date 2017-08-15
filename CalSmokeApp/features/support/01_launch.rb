
module Calabash
  class Launchctl
    require "singleton"
    include Singleton

    require "calabash-cucumber/launcher"
    require "calabash-cucumber/environment"

    attr_reader :first_launch
    attr_reader :launcher

    def initialize
      @first_launch = true
      @launcher = Calabash::Cucumber::Launcher.new
    end

    def launch(options)
      launcher.relaunch(options)
      @first_launch = false
    end

    def launcher
      @launcher
    end

    def first_launch
      @first_launch
    end

    def shutdown(world)
      @first_launch = true
      world.calabash_exit
    end

    def maybe_exit_cucumber_on_failure(scenario, world)
      if scenario.failed?
        if RunLoop::Environment.xtc?
          ENV["RESET_BETWEEN_SCENARIOS"] = "1"
          shutdown(world)
          sleep(1.0)
        else
          exit!(1)
        end
      end
    end

    def maybe_pry_on_failure(scenario, world)
      if scenario.failed?
        if RunLoop::Environment.xtc?
          shutdown(world)
          sleep(1.0)
        else
          require "pry"
          binding.pry
        end
      end
    end

    def lp_server_running?
      begin
        running = launcher.ping_app
      rescue Errno::ECONNREFUSED => _
        running = false
      end

      running
    end

    def device_agent_running?
      if launcher.instruments?
        raise RuntimeError, "Don't call this method if you are running with Instruments"
      end

      if launcher.automator.nil?
        return false
      end

      launcher.automator.client.running?
    end

    def running?
      return false if first_launch
      return false if !launcher.run_loop
      return false if !launcher.automator

      return false if !lp_server_running?

      running = true

      if !launcher.instruments?
        device_agent_running?
      else
        running
      end
    end

    def xcode
      Calabash::Cucumber::Environment.xcode
    end

    def instruments
      Calabash::Cucumber::Environment.instruments
    end

    def simctl
      Calabash::Cucumber::Environment.simctl
    end

    def environment
      {
        :simctl => self.simctl,
        :instruments => self.instruments,
        :xcode => self.xcode
      }
    end

    def options
      if RunLoop::Environment.xtc?
        {}
      else
        environment
      end
    end

    def device
      @device ||= RunLoop::Device.detect_device({}, xcode, simctl, instruments)
    end

    def reset_simulator_lang_and_locale
      return if RunLoop::Environment.xtc?
      if device.physical_device?
        raise "Should only be called when target is a simulator"
      else
        RunLoop::CoreSimulator.erase(device, {:simctl => simctl})
        set_sim_locale_and_lang
      end
    end

    def maybe_clear_keychain(scenario, world)
      names = scenario.tags.map { |tag| tag.name }

      return if !names.include?("@reset_device_settings")

      world.send(:keychain_clear)
    end

    def ensure_app
      app_path = File.expand_path("Products/app/CalSmoke-cal/CalSmoke-cal.app")
      if !File.exist?(app_path)
        hash = RunLoop::Shell.run_shell_command(["make", "app-cal"], {:log_cmd => true})
        if hash[:exit_status] != 0
          RunLoop.log_error("Could not build app; run: 'make app-cal' to diagnose")
          exit hash[:exit_status]
        end
      end
      app_path
    end

    def ensure_ipa
      ipa_path = File.expand_path("Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa")
      if !File.exist?(ipa_path)
        hash = RunLoop::Shell.run_shell_command(["make", "ipa-cal"], {:log_cmd => true})
        if hash[:exit_status] != 0
          RunLoop.log_error("Could not build ipa; run: 'make ipa-cal' to diagnose")
          exit hash[:exit_status]
        end
      end
      ipa_path
    end

    def install_on_physical_device
      begin
        Calabash::IDeviceInstaller.new(ensure_ipa, device.udid).install_app
      rescue => e
        RunLoop.log_error(e.message)
        exit 9
      end
    end

    def ensure_app_installed_on_device
      ideviceinstaller = Calabash::IDeviceInstaller.new(ensure_ipa, device.udid)
      unless ideviceinstaller.app_installed?
        begin
          ideviceinstaller.install_app
        rescue => e
          RunLoop.log_error(e.message)
          exit 9
        end
      end
    end

    def app_locale
      @app_locale ||= ENV["APP_LOCALE"] || "en_US"
    end

    def app_locale=(locale)
      @app_locale = locale
    end

    def app_lang
      @app_lang ||= ENV["APP_LANG"] || "en-US"
    end

    def app_lang=(lang)
      @app_lang = lang
    end

    def clear_locale_and_lang!
      @app_lang = nil
      @app_locale = nil
    end

    def set_sim_locale_and_lang
      if device.physical_device?
        raise "Should only be called when target is a simulator"
      end

      RunLoop::CoreSimulator.set_locale(device, app_locale)
      RunLoop::CoreSimulator.set_language(device, app_lang)
    end
  end
end

Before("@german") do
  # Will not run on device or XTC because of @simulator tag on Scenario
  Calabash::Launchctl.instance.shutdown(self)
  Calabash::Launchctl.instance.app_locale = "de"
  Calabash::Launchctl.instance.app_lang = "de"
  Calabash::Launchctl.instance.reset_simulator_lang_and_locale
end

Before("@reset_app_btw_scenarios") do
  if xamarin_test_cloud?
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
    Calabash::Launchctl.instance.shutdown(self)
  elsif Calabash::Launchctl.instance.device.simulator?
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
    Calabash::Launchctl.instance.shutdown(self)
  else
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
    Calabash::Launchctl.instance.shutdown(self)
    Calabash::Launchctl.instance.install_on_physical_device
  end
end

Before("@reset_device_settings") do
  if xamarin_test_cloud?
    ENV["RESET_BETWEEN_SCENARIOS"] = "1"
    Calabash::Launchctl.instance.shutdown(self)
  elsif Calabash::Launchctl.instance.device.simulator?
    Calabash::Launchctl.instance.shutdown(self)
    Calabash::Launchctl.instance.reset_simulator_lang_and_locale
  else
    Calabash::Launchctl.instance.shutdown(self)
    # Requires Settings.app > General > Reset > Reset Location and Privacy
    # Could be automated with DeviceAgent.
    Calabash::Launchctl.instance.install_on_physical_device
  end
end

Before do |scenario|

  if !xamarin_test_cloud?
    if Calabash::Launchctl.instance.device.physical_device?
      Calabash::Launchctl.instance.ensure_app_installed_on_device
    end

    options = Calabash::Launchctl.instance.environment
    options[:args] = [
      "-AppleLanguages", "(#{Calabash::Launchctl.instance.app_lang})",
      "-AppleLocale", Calabash::Launchctl.instance.app_locale,
    ]

    if Calabash::Launchctl.instance.first_launch
      if Calabash::Launchctl.instance.device.simulator?
        Calabash::Launchctl.instance.reset_simulator_lang_and_locale
      end

      Calabash::Launchctl.instance.launch(options)
    end
  else
    options = {}
    Calabash::Launchctl.instance.launch(options)
  end

  ENV["RESET_BETWEEN_SCENARIOS"] = "0"
  Calabash::Launchctl.instance.maybe_clear_keychain(scenario, self)
  rotate_home_button_to(:down)
  sleep(0.5)
end

After("@german") do
  # Will not run on device or XTC because of @simulator tag on Scenario
  Calabash::Launchctl.instance.shutdown(self)
  Calabash::Launchctl.instance.clear_locale_and_lang!
end

After do |scenario|
  case :default
    when :default
      Calabash::Launchctl.instance.maybe_exit_cucumber_on_failure(scenario, self)
    when :pry
      Calabash::Launchctl.instance.maybe_pry_on_failure(scenario, self)
    else
      RunLoop.log_error("Unknown action in After hook")
      Calabash::Launchctl.instance.maybe_exit_cucumber_on_failure(scenario, self)
  end
end

at_exit do

end
