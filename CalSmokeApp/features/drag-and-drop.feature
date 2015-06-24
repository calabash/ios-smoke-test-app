@drag_and_drop
Feature: Drag and Drop
  In order to test the Calabash pan API
  As a Calabash developer
  I want to drag a view onto another view

  Background:  Get me to the third tab
   Given I see the third tab

  Scenario: Verify layout
    Then I expect to see the red box
    Then I expect to see the blue box
    Then I expect to see the green box
