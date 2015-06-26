@keyboard
Feature: Typing on the Keyboard
  In order to enter text like a user
  As an app tester
  I want Calabash to provide a Keyboard API

  Background:  Get me to the first tab
    Given I see the first tab

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

  Scenario: Touching the Shift key
    Then I touch the text field
    Then I tap the shift key
    When I tap the shift key
    When I double tap the shift key
