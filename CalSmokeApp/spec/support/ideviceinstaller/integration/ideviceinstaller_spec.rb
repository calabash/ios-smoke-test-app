module IDeviceId

  def self.binary
    binary = `which idevice_id`.strip
    if binary.nil? || binary.empty?
      nil
    else
      binary
    end
  end

  def self.idevice_id_bin_path
     self.binary || '/usr/local/bin/idevice_id'
  end

  def self.idevice_id_available?
    File.exist?(self.idevice_id_bin_path)
  end

  # Xcode 6 + iOS 8 - devices on the same network, whether development or
  # not, appear when calling $ xcrun instruments -s devices. For the
  # purposes of testing, we will only try to connect to devices that are
  # connected via USB.
  #
  # Also idevice_id, which ideviceinstaller relies on, will sometimes report
  # devices 2x which will cause ideviceinstaller to fail.
  def self.physical_devices_for_testing
    devices = Calabash::IDeviceInstaller.available_devices
    if self.idevice_id_available?
      white_list = `#{self.idevice_id_bin_path} -l`.strip.split("\n")
      devices.select do | device |
        white_list.include?(device.udid) && white_list.count(device.udid) == 1
      end
    else
      devices
    end
  end
end

describe 'Calabash IDeviceInstaller Integration' do

  if !File.exist?('/usr/local/bin/ideviceinstaller')
    it 'Skipping ideviceinstaller integration tests:  /usr/local/bin/ideviceinstaller does not exist' do

    end
  elsif IDeviceId.physical_devices_for_testing.empty?
    it 'Skipping ideviceinstaller integration tests:  no connected devices' do

    end
  else
    let(:options) { Calabash::IDeviceInstaller::DEFAULT_RETRYABLE_OPTIONS }
    let (:installer) {
      ipa_path = File.expand_path('./xtc-staging/CalSmoke-cal.ipa')
      unless File.exist?(ipa_path)
        system('make', 'ipa-cal')
      end
      udid = IDeviceId.physical_devices_for_testing.first.udid
      Calabash::IDeviceInstaller.new(ipa_path, udid, options)
    }

    it '#to_s' do
      capture_stdout do
        puts installer
      end
    end

    it '#install_app' do
      installer.install_app
    end

    it '#uninstall_app' do
      installer.uninstall_app
    end

    describe 'ensure popen3 exits cleanly' do
      let(:options) { {:timeout => 1, :tries => 2, :interval => 0.2} }
      it '#install_app' do
        expect {
          installer.install_app
        }.to raise_error(Calabash::IDeviceInstaller::InvocationError, 'execution expired')
        expect(installer.instance_variable_get(:@stdin).closed?).to be_truthy
        expect(installer.instance_variable_get(:@stdout).closed?).to be_truthy
        expect(installer.instance_variable_get(:@stderr).closed?).to be_truthy
        pid = installer.instance_variable_get(:@pid)
        terminator = RunLoop::ProcessTerminator.new(pid, 'TERM', 'ideviceinstaller')
        expect(terminator.process_alive?).to be == false
      end
    end
  end
end
