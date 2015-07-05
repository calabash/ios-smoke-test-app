@backdoor
Feature:  Backdoors
  In order make UI testing faster and easier
  As a tester
  I want a way to get my app into a good shape for testing
  and to get some state from my app at runtime

  Background: The app has launched
    Given I see the first tab

  @wip
  Scenario: Unknown backdoor
    And I call backdoor with an unknown selector
    Then I should see a helpful error message

  Scenario: Backdoor with void return value
    And I call backdoor on a method whose return type is void
    Then I should see a helpful error message

  Scenario: Backdoor with no argument
    And I call backdoor on a method with no argument
    Then I should see a helpful error message

  Scenario: Backdoor that doesn't return NString
    And I call backdoor on a method that doesn't return an NSString
    Then I should see a helpful error message

  Scenario: Backdoor that takes an NSString argument
    And I call backdoor on a method that takes an NSString as an argument
    Then I should get back that string

  Scenario: Backdoor that takes an NSDictionary argument
    And I call backdoor on a method that takes an NSDictionary as an argument
    Then I should get back that dictionary
