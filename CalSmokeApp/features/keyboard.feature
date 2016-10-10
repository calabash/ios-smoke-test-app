@keyboard
Feature: Typing on the Keyboard
In order to enter text like a user
As an app tester
I want Calabash to provide a Keyboard API

Background: Navigate to the controls tab
Given I see the controls tab

@travis
Scenario: I should be able to type something
Then I type "Hello"
And the first responder text is "Hello"
And I dismiss the keyboard by tapping the keyboard action key

Scenario: Interacting with non-UITextInput responders
Then I touch the CalTextField
And the first responder text is "CalTextField"
And I can append the text of the CalTextField
And I dismiss the keyboard that is attached to the CalTextField
