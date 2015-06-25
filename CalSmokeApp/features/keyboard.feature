@travis
Feature: Interacting with the
  In order to enter text like a user
  As an app tester
  I want Calabash to provide a Keyboard API
Feature: say hello to the first view

  Scenario: I should be able to type something
    Given I see the first tab
    Then I type "Hello"
