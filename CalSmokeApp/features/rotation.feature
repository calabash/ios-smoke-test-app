@rotation
Feature: Rotation
In order test my app in all orientations
As a developer
I want Calabash to be able to rotate my app

# In order for Calabash to be able to rotate your app,
# your app's view controller must respond to orientation
# changes.
#
# Enumerating the various things you need to do to enable
# rotation for all the support iOS versions is beyond the
# scope of this documentation.
#
# This app supports rotation on at least one view controller.
#
# Rotation is exhaustively tested in the Briar iOS example.
# https://github.com/jmoody/briar-ios-example

Scenario: Controller does not respond to orientation changes
  Given I see the controls tab
  And I try to rotate the home button so it is on the left
  Then the orientation should be portrait

Scenario: Controller does respond to orientation changes
  Given I see the special tab
  And I try to rotate the home button so it is on the right
  Then the home button should be on the right

