@gestures
Feature: Gestures
  In order to test taps, pans, and swipes
  As a developer
  I want a Gesture API

  Scenario:  Double tap
    Given I see the gestures tab
    When I double tap the box
    Then the gesture description changes to double tap

  Scenario:  Long press
    Given I see the gestures tab
    When I long press the box for 1 second
    Then the gesture description changes to long press
    When I long press the box for 2 seconds
    Then the gesture description changes to long press
