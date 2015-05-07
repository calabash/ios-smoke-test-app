require 'tmpdir'
require 'fileutils'
require 'open3'
require 'run_loop'

module Calabash

  class IPA

    attr_reader :ipa_path
    attr_reader :bundle_identifier

    def initialize(path_to_ipa)
      unless File.exist? path_to_ipa
        raise "Expected an ipa at '#{path_to_ipa}'"
      end

      unless path_to_ipa.end_with?('.ipa')
        raise "Expected '#{path_to_ipa}' to be"
      end
      @ipa_path = path_to_ipa
    end

    def bundle_identifier
      unless File.exist?(bundle_dir)
        raise "Expected a '#{File.basename(ipa_path).split('.').first}.app'\nat path '#{payload_dir}'"
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
        FileUtils.cp(ipa_path, tmpdir)
        zip_path = File.join(tmpdir, File.basename(ipa_path))
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


  class DeviceInstaller

    def app_installed?

    end

    def install_app

    end

    def ensure_app_installed

    end
  end
end
