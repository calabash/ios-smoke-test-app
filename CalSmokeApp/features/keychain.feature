@resetting
@ideviceinstaller
@keychain
Feature:  iOS Keychain

# These tests are dependent on each other and must be run in a particular
# order. In general, this is a bad practice, but there are times when it is
# necessary.  In this case, we are testing the behavior of resetting an
# app's sandbox and re-installing.  The strict ordering is achieved by
# using the 'xx_< Scenario Name >' convention.
#
# When these tests are run on physical devices, the reset will be
# performed by re-installing the app.
#
# The Keychain API will removed in Calabash 2.0.  It will be replaced by a
# separate gem and a Calabash plug-in.
#
# These tests require ideviceinstaller.  You can install ideviceinstaller
# with brew.  We do not maintain the ideviceinstaller, libimobiledevice, or
# homebrew tools. These are third-party software. If you have issues with these
# tools, you are on your own. Please do not report problems with these tools
# on the Calabash channels.
Background: Navigate to the controls page
  Given I see the controls tab

# Demonstrate that the keychain API works.
Scenario: 00 I set the keychain item
  Given that the keychain contains the account password "pa$$w0rd" for "clever_user98"

Scenario: 01 I should see the keychain item exists in the next Scenario
  Then the keychain should contain the account password "pa$$w0rd" for "clever_user98"
  When I clear the keychain
  Then the keychain should be empty

# Demonstrate that resetting the simulator content and settings works using
# the keychain as proxy.
#
# Keychain items persist over app installs and sandbox resets on the
# iOS Simulator and physical devices.
#
# On the simulator, you can reset the simulator contents and settings to
# clear the keychain, but on devices re-installing does not clear the
# keychain.  You must call `keychain_clear` after the app is launched.
# See features/support/01_launch.rb to see how this is done in the Before hook.
@reset_device_settings
Scenario: 10 I set the keychain item
  Given that the keychain contains the account password "pa$$w0rd" for "clever_user98"

Scenario: 11 I should see the keychain item exists because I did not reset the device settings before this Scenario
  Then the keychain should contain the account password "pa$$w0rd" for "clever_user98"

@reset_device_settings
Scenario: 12 The keychain should be empty because I reset the device settings before this Scenario
  Then the keychain should be empty

