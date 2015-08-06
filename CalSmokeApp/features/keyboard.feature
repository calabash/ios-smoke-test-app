@keyboard
Feature: Typing on the Keyboard
In order to enter text like a user
As an app tester
I want Calabash to provide a Keyboard API

Background: Navigate to the controls tab
  Given I see the controls tab

@travis
Scenario: I should be able to type something
  Then I type "Hello"

Scenario: Turn on auto correct
  And I turn on auto correct
  Then I touch the text field
  When I type "exictement" and touch done
  Then the text should be "excitement"

Scenario: Turn off auto correct
  And I turn off auto correct
  Then I touch the text field
  When I type "exictement" and touch done
  Then the text should be "exictement"

# You can tap the shift key, but don't be surprised if you
# have bad results.  There is no way to know if the shift
# key is active, inactive, or locked.
Scenario: Tapping the Shift key
  Then I touch the text field
  Then I tap the shift key
  When I tap the shift key
  When I double tap the shift key

