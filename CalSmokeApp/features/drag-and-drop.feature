@drag_and_drop
Feature: Drag and Drop
  In order to test the Calabash pan API
  As a Calabash developer
  I want to drag a view onto another view

  Background:  Get me to the third tab
   Given I see the third tab

  Scenario: Drag the red box
    When I drag the red box to the left well
    Then the left well should change to red
    And I expect the red box to return to its original position
