module Calabash
  module IOS
    module KeychainSteps
      def keychain_service_name
        'calabash.smoke.test.app.service'
      end
    end
  end
end

World(Calabash::IOS::KeychainSteps)

When(/^I clear the keychain$/) do
  keychain_clear_accounts_for_service(keychain_service_name)
end

Given(/^that the keychain is clear$/) do
  keychain_clear_accounts_for_service(keychain_service_name)
end

Then(/^the keychain should contain the account password "(.*?)" for "(.*?)"$/) do |password, username|
  actual = keychain_password(keychain_service_name, username)
  if xamarin_test_cloud?
    if actual.nil?
      screenshot_and_raise "expected an entry for '#{username}' in the keychain"
    end
  else
    unless actual == password
      screenshot_and_raise "expected '#{password}' in keychain but found '#{actual}'"
    end
  end
end

Given(/^that the keychain contains the account password "(.*?)" for "(.*?)"$/) do |password, username|
  # app uses the first account/password pair it finds, so clear out
  # any preexisting saved passwords for our service
  keychain_clear_accounts_for_service(keychain_service_name)
  keychain_set_password(keychain_service_name, username, password)
end

Then(/^the keychain should be empty$/) do
  accounts = keychain_accounts_for_service(keychain_service_name)
  unless accounts.empty?
    raise "expected no accounts but found '#{accounts}'"
  end
end
