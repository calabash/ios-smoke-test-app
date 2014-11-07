Feature:  Invalid query string

  Background: I should see the first view
    Given I see the first view
    And I see the text field

  Scenario:  Query string has a missing trailing single quote
    When I search for the text using a correctly formatted query
    Then I expect one text field result
    When I search for the text using a query with a missing trailing quote, I expect an exception
