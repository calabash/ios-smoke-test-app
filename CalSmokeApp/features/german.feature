@localization
@simulator
Feature: Can launch a simulator in German

@german
Scenario: Launch simulator in German and query for text
Given the app has launched
And I see the special tab
Then I see localized text "Beschriften mit lokalisiertem Text"

