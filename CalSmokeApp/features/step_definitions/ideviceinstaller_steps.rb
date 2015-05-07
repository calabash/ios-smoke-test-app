module CalabashSmoke
  module IDeviceInstaller
    def path_to_ipa
      File.expand_path(File.join('xtc-staging', 'CalSmoke-cal.ipa'))
    end

    def ensure_ipa
      unless path_to_ipa
        system('make', 'ipa-cal')
      end
      path_to_ipa
    end
  end
end

World(CalabashSmoke::IDeviceInstaller)

Given(/^that I have created an instance of Calabash::IPA$/) do
  ipa_path = ensure_ipa
  unless File.exist?(ipa_path)
    system('make', 'ipa-cal')
  end
  expect(Calabash::IPA.new(ipa_path)).to be_a_kind_of Calabash::IPA
end


Then(/^I should be able to find its bundle identifier$/) do
  ipa = Calabash::IPA.new(ensure_ipa)
  expect(ipa.bundle_identifier).to be == 'com.xamarin.CalSmoke-cal'
end
