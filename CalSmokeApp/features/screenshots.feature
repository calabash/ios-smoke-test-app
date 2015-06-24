@screenshots
Feature:  Screenshots
  In order to gain insights into my app
  As a tester
  I want a way to take a screenshot

  Background:  The app has launched
    Given the app has launched
    And I have cleared existing screenshots for this feature
    And the scenario-screenshots subdirectory exists

  Scenario: Default screenshot behavior
    When I take a screenshot with the default screenshot method
    Then the screenshot will have a number appended to the name

