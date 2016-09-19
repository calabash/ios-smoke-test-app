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
