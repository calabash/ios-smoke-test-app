@pinch
Feature: Pinch
  In order to perform pinches
  As a developer
  I want a Pinch API

Background: Navigate to the pinch page
  Given I see the gestures tab
  And I see the pinching page

Scenario: A basic pinch on the box
  When I pinch in on the box
  Then the box grows
  When I pinch out on the box
  Then the box shrinks
