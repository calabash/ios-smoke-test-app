describe 'Calabash IDeviceInstaller' do

  let(:ipa_path) {
    ipa_path = File.expand_path('./xtc-staging/CalSmoke-cal.ipa')
    unless File.exist?(ipa_path)
      system('make', 'ipa-cal')
    end
    ipa_path
  }

  let(:udid) { 'device udid' }

  let(:device) { RunLoop::Device.new('denis', '8.3', udid) }

  let(:fake_binary) {
    FileUtils.touch(File.join(Dir.mktmpdir, 'ideviceinstaller')).first
  }

  let(:options) { {:path_to_binary => fake_binary} }

  let(:installer) { Calabash::IDeviceInstaller.new(ipa_path, udid, options) }

  describe '.new' do
    describe 'raises an error when' do
      describe 'cannot find an ideviceinstaller binary' do
        it 'that was installed by homebrew' do
          expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return('/path/does/not/exist')
          expect {
            Calabash::IDeviceInstaller.new(nil, nil)
          }.to raise_error(Calabash::IDeviceInstaller::BinaryNotFound)
        end

        it 'that was passed as an optional argument' do
          expect {
            Calabash::IDeviceInstaller.new(nil, nil, {:path_to_binary => '/some/other/ideviceinstaller'})
          }.to raise_error(Calabash::IDeviceInstaller::BinaryNotFound)
        end

        it 'cannot find ideviceinstaller in the $PATH' do
          expect(Calabash::IDeviceInstaller).to receive(:binary_in_path).and_return(nil)
          expect(Calabash::IDeviceInstaller).to receive(:homebrew_binary).and_return('/path/does/not/exist')
          expect {
            Calabash::IDeviceInstaller.new(nil, nil)
          }.to raise_error(Calabash::IDeviceInstaller::BinaryNotFound)
        end
      end

      it 'cannot create an ipa' do
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(Calabash::IPA).to receive(:new).and_raise RuntimeError
        expect {
          Calabash::IDeviceInstaller.new(nil, nil)
        }.to raise_error(Calabash::IDeviceInstaller::CannotCreateIPA)
      end

      it 'cannot find a device with udid' do
        expect(File).to receive(:exist?).with('/usr/local/bin/ideviceinstaller').and_return(true)
        expect(Calabash::IPA).to receive(:new).and_return nil
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([])
        expect {
          Calabash::IDeviceInstaller.new(nil, nil)
        }.to raise_error(Calabash::IDeviceInstaller::DeviceNotFound)
      end
    end

    it 'sets it variables' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer.binary).to be == fake_binary
      expect(installer.tries).to be == Calabash::IDeviceInstaller::DEFAULT_RETRYABLE_OPTIONS[:tries]
      expect(installer.interval).to be == Calabash::IDeviceInstaller::DEFAULT_RETRYABLE_OPTIONS[:interval]
      expect(installer.ipa).to be_truthy
      expect(installer.udid).to be == device.udid
    end
  end

  it '#to_s' do
    expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
    expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
    expect { installer.to_s }.not_to raise_error
  end

  it '#binary' do
    expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
    expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
    expect(installer.instance_variable_get(:@binary)).to be == installer.binary
  end

  describe '#app_installed?' do
    it 'returns false when app is not installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({:out => ''})
      expect(installer.app_installed?).to be_falsey
    end

    it 'returns true when app is installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      out =
            {
                  :out =>
                        [
                              'Total: 3 apps',
                              'com.apple.itunesconnect.mobile - Connect 261',
                              'com.deutschebahn.navigator - DB Navigator 18',
                              'sh.calaba.CalSmoke-cal - CalSmoke 1.0'
                        ].join("\n")
            }
      expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return(out)
      expect(installer.app_installed?).to be_truthy
    end
  end

  describe '#install_app' do
    describe 'return true if app was successfully installed' do
      it 'was successfully installed' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(installer).to receive(:app_installed?).and_return(false, true)
        expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({})
        expect(installer.install_app).to be == true
      end
    end

    it 'raises error if app was not installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:app_installed?).and_return(false, false)
      expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({})
      expect { installer.install_app }.to raise_error(Calabash::IDeviceInstaller::InstallError)
    end

    it 'calls uninstall if the app is already installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:app_installed?).and_return(true, true)
      expect(installer).to receive(:uninstall_app).and_return(true)
      expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({})
      expect(installer.install_app).to be == true
    end
  end

  describe '#ensure_app_installed' do
    it 'returns true if app is installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:app_installed?).and_return(true)
      expect(installer.ensure_app_installed).to be == true
    end

    it 'calls install otherwise' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:app_installed?).and_return(false)
      expect(installer).to receive(:install_app).and_return(true)
      expect(installer.ensure_app_installed).to be == true
    end
  end

  describe '#uninstall_app' do
    describe 'return true if app' do
      it 'is not installed' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(installer).to receive(:app_installed?).and_return(false)
        expect(installer.uninstall_app).to be == true
      end

      it 'was successfully uninstalled' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(installer).to receive(:app_installed?).and_return(true, false)
        expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({})
        expect(installer.uninstall_app).to be == true
      end
    end

    it 'raises error if app was not installed' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer).to receive(:app_installed?).and_return(true, true)
      expect(installer).to receive(:execute_ideviceinstaller_cmd).and_return({})
      expect { installer.uninstall_app }.to raise_error(Calabash::IDeviceInstaller::UninstallError)
    end
  end

  describe 'private' do
    it '.homebrew_binary' do
      expect(Calabash::IDeviceInstaller.homebrew_binary).to be == '/usr/local/bin/ideviceinstaller'
    end

    describe '.binary_in_path' do
      it 'returns ideviceinstaller path if it is in $PATH' do
        expect(Calabash::IDeviceInstaller).to receive(:shell_out).and_return('/path/to/binary')
        expect(Calabash::IDeviceInstaller.binary_in_path).to be == '/path/to/binary'
      end

      it 'returns nil if ideviceinstaller is not in $PATH' do
        expect(Calabash::IDeviceInstaller).to receive(:shell_out).and_return('', nil)
        expect(Calabash::IDeviceInstaller.binary_in_path).to be == nil
        expect(Calabash::IDeviceInstaller.binary_in_path).to be == nil
      end
    end

    describe '.expect_binary' do
      describe 'raises error when' do
        it 'user supplies a binary that does not exist' do
          binary = '/path/does/not/exist'
          expect(Calabash::IDeviceInstaller).to receive(:select_binary).with(binary).and_return(binary)
          expect {
            Calabash::IDeviceInstaller.expect_binary(binary)
          }.to raise_error(Calabash::IDeviceInstaller::BinaryNotFound)
        end

        it 'binary cannot be found in $PATH or in the default location' do
          binary = 'path/does/not/exist'
          expect(Calabash::IDeviceInstaller).to receive(:homebrew_binary).and_return(binary)
          expect(Calabash::IDeviceInstaller).to receive(:binary_in_path).and_return(nil)
          expect {
            Calabash::IDeviceInstaller.expect_binary
          }.to raise_error(Calabash::IDeviceInstaller::BinaryNotFound)
        end
      end

      it 'returns the discovered binary path' do
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(Calabash::IDeviceInstaller.expect_binary).to be == fake_binary
      end
    end

    it '.available_devices' do
      devices = Calabash::IDeviceInstaller.available_devices
      expect(devices).to be_a_kind_of(Array)
      unless devices.empty?
        expect(devices.first).to be_a_kind_of(RunLoop::Device)
      end
    end

    it '#retriable_intervals' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer.send(:retriable_intervals)).to be_a_kind_of Array
    end

    it '#timeout' do
      expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
      expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
      expect(installer.send(:timeout)).to be_a_kind_of Numeric
    end

    describe '#exec_with_open3' do
      it 'raises InvocationError if it encounters an error' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        expect(Open3).to receive(:popen3).and_raise StandardError
        expect {
          installer.send(:exec_with_open3, [])
        }.to raise_error Calabash::IDeviceInstaller::InvocationError
      end
    end

    describe '#execute_ideviceinstaller_cmd' do
      it 'succeeds when exit status is 0' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        hash = { :exit_status => 0 }
        expect(installer).to receive(:exec_with_open3).and_return(hash)
        expect(installer.send(:execute_ideviceinstaller_cmd, [])).to be == hash
      end

      it 'retries if exit status in not 0' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        hashes = [ { :exit_status => 1 }, { :exit_status => 1 }, { :exit_status => 0, :pid => 2 } ]
        expect(installer).to receive(:retriable_intervals).and_return(Array.new(3, 0.1))
        expect(installer).to receive(:exec_with_open3).and_return(*hashes)
        expect(installer.send(:execute_ideviceinstaller_cmd, [])[:pid]).to be == 2
      end

      it 'retries if execution results in an error' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        hash = { :exit_status => 0, :pid => 2 }
        expect(installer).to receive(:retriable_intervals).and_return(Array.new(2, 0.1))
        expect(installer).to receive(:exec_with_open3).and_raise(Calabash::IDeviceInstaller::InvocationError)
        expect(installer).to receive(:exec_with_open3).and_return(hash)
        expect(installer.send(:execute_ideviceinstaller_cmd, [])[:pid]).to be == 2
      end

      it 'retries if execution exceeds timeout' do
        expect(Calabash::IDeviceInstaller).to receive(:available_devices).and_return([device])
        expect(Calabash::IDeviceInstaller).to receive(:select_binary).and_return(fake_binary)
        hash = { :exit_status => 0, :pid => 2 }
        expect(installer).to receive(:retriable_intervals).and_return(Array.new(2, 0.1))
        expect(installer).to receive(:exec_with_open3).and_raise(Calabash::IDeviceInstaller::InvocationError)
        expect(installer).to receive(:exec_with_open3).and_return(hash)
        expect(installer.send(:execute_ideviceinstaller_cmd, [])[:pid]).to be == 2
      end
    end
  end
end
