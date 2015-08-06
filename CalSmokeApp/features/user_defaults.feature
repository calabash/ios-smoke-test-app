@resetting
@ideviceinstaller
@user_defaults
Feature:  NSUserDefaults

# These tests are dependent on each other and must be run in a particular
# order. In general, this is a bad practice, but there are times when it is
# necessary.  In this case, we are testing the behavior of resetting an
# app's sandbox and re-installing.  The strict ordering is achieved by
# using the 'xx_< Scenario Name >' convention.
#
# When these tests are run on physical devices, the reset will be
# performed by re-installing the app.
#
# These tests require ideviceinstaller.  You can install ideviceinstaller
# with brew.  We do not maintain the ideviceinstaller, libimobiledevice, or
# homebrew tools. These are third-party software. If you have issues with these
# tools, you are on your own. Please do not report problems with these tools
# on the Calabash channels.
Background: Navigate to the controls page
  Given I see the controls tab

# Demonstrate that resetting the app works using NSUserDefaults as proxy.  The
# on/off state of the switch on the first view is persisted in NSUserDefaults.
#
# NSUserDefaults are part of the app sandbox and so are deleted by
# `reset_app_sandbox`.
@reset_app_btw_scenarios
@backdoor
Scenario: 20 I turn the switch on the first view on
  And I drop some files in the sandbox
  Given I turn the switch on

@backdoor
Scenario: 21 The switch should be on because I did not reset the app before this Scenario
  Then I should see the files I put in the sandbox
  Then I should see the switch is on

@reset_app_btw_scenarios
@backdoor
Scenario: 22 The switch should be off because I did reset the app before this Scenario
  Then I should not see the files I put in the sandbox
  Then I should see the switch is off

