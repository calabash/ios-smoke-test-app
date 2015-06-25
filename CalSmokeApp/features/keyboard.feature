@travis
Feature: Typing on the Keyboard
  In order to enter text like a user
  As an app tester
  I want Calabash to provide a Keyboard API

  Scenario: I should be able to type something
    Given I see the first tab
    Then I type "Hello"
