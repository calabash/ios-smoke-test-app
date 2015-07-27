@scroll
Feature: Testing scrolling

  Background: Navigate to the scrolls tab
    Given I see the scrolls tab
    Then I see the scrolling views table

  Scenario:  Collection views
    When I touch the collection views row
    Then I see the collection views page
    Then I scroll the logos collection to the steam icon by mark
    Then I scroll the logos collection to the github icon by index
    Then I scroll up on the logos collection to the android icon
    Then I scroll the colors collection to the middle of the purple boxes

  Scenario: Table views
    When I touch the table views row
    Then I see the table views page
    Then I scroll the logos table to the steam row by mark
    Then I scroll the logos table to the github row by index
    Then I scroll up on the logos table to the android row

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
