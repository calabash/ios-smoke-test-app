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

Then(/^the keychain should be empty because I called clear_keychain$/) do
  accounts = keychain_accounts_for_service(keychain_service_name)

  # Locally, the Keychain is cleared.
  #
  # On the XTC, there is additional Keychain item created for all apps during
  # test execution that should not be cleared.  This keychain item is _always_
  # cleared when the device is reset: between Scenarios and between tests.
  # Put another way, this Keychain item will _never_ leak - it is always destroyed
  # between tests.  There is a Scenario that demonstrates this behavior.
  #
  # Waiting on iOS 10 change in XTC. When this starts failing, we know the XTC
  # has updated.
  #
  # https://github.com/xamarin/test-cloud-frontend/issues/2506
  if xamarin_test_cloud? && !ios10?
    if accounts.count != 1
      raise "Expected one keychain account on the XTC"
    end
  else
    if !accounts.empty?
      raise "Expected no accounts but found '#{accounts}'"
    end
  end
end

Then(/^the keychain should be empty because I reset the device$/) do
  accounts = keychain_accounts_for_service(keychain_service_name)
  if !accounts.empty?
    raise "Expected no accounts but found '#{accounts}'"
  end
end
