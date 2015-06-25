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

  @no
  Scenario: Turn off auto capitalization
    And I turn off auto capitalization
    Then I touch the text field
    When I type "hello", I should see "hello"

  @no
  Scenario: Turn on ALL caps
    And I turn on all caps
    Then I touch the text field
    When I type "hello", I should see "HELLO"

  @no
  Scenario: Turn on cap sentences (default)
    And I turn on capitalize sentences
    Then I touch the text field
    When I type "hello. my name is.", I should see "Hello. My name is."

  Scenario: Turn on spell checking
    And I turn on spell checking
    Then I touch the text field
    When I type "exictement" and touch done
    Then the text should be "excitement"
