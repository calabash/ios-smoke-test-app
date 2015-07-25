@scroll
Feature: Testing scrolling

  Background: Navigate to the scrolls tab
    Given I see the scrolls tab

  @wip
  Scenario: Scrolling views table
    Then I see the scrolling views table
    And I see rows for table, collection, scroll, web, and map views
    When I rotate to landscape
    Then I see rows for table, collection, scroll, web, and map views

#  Scenario: It should be able to find first & last cells moving up & down
#    When I search for cell "cell 5" scrolling down
#    Then I should see cell 5
#
#    Given I see the cell 5
#    When I search for cell "cell 1" scrolling up
#    Then I should see cell 1
#
#  Scenario: It should be able to find last cell after trying to scroll down 5 times
#    When I scroll down for 5 times
#    Then I should see cell 5
#
#  Scenario: It should be able to find first cell after trying to scroll up 5 times
#    When I scroll up for 5 times
#    Then I should see cell 1
#
#  Scenario: It should be able to find first cell after trying to scroll left 5 times
#    When I scroll left for 5 times
#    Then I should see cell 1
#
#  Scenario: It should be able to find first cell after trying to scroll right 5 times
#    When I scroll right for 5 times
#    Then I should see cell 1
