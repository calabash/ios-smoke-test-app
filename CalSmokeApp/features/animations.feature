@animations
Feature:  Animations
  In order to demonstrate that Calabash works when there are animations
  As a Calabash maintainer
  I want some Scenarios with views that animate

  Background: Get me to the third tab
    Given I see the third tab

  Scenario: Start an animation and wait for it to finish
    And I have started an animation that lasts 4 seconds
    Then I can wait for the animation to stop
