@keyboard
Feature: Typing on the Keyboard
  In order to enter text like a user
  As an app tester
  I want Calabash to provide a Keyboard API

  @travis
  Scenario: I should be able to type something
    Given I see the first tab
    Then I type "Hello"

  Scenario: Turning off Auto Capitalization
    Given I see the first tab
    And I turn off auto capitalization
    Then I touch the text field
    When I type "hello", I should see "hello"
