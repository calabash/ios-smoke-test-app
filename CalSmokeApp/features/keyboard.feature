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

#@not_xtc
#Scenario: I should be able to press a key by name
#  When I touch the text field
#  Then I type "123"
#  Then I press the "delete.key" key
#  Then the text should be "12"

@not_xtc
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
