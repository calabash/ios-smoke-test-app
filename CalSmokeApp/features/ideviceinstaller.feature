@ideviceinstaller
@no_ci
Feature: ideviceinstaller
  In order to install and uninstall ipas on physical iOS devices
  As a Calabash user
  I want a wrapper around ideviceinstaller

  Scenario: Create a Calabash::IPA
    Given that I have created an instance of Calabash::IPA
    Then I should be able to find its bundle identifier
