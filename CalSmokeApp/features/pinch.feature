@pinch
@gestures
Feature: Pinch
In order to perform pinches
As a developer
I want a Pinch API

Background: App has launched
Given the app has launched

Scenario: A basic pinch on the box
Given I see the gestures tab
And I see the pinching page
When I pinch in on the box
Then the box grows
When I pinch out on the box
Then the box shrinks

@map
Scenario: Full screen pinch on map
Given I see the scrolls tab
And I see the map page
Then I zoom in on the map by pinching out
Then I zoom out on the map by pinching in
