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

@clear_text
Scenario: Clearing text
Then I clear the text in the text field using Objective-C selectors
Then I type "Hello" in the text field
Then I clear the text in the text field using Core#clear_text
Then I type "Hello" in the text field
Then I clear the text in the text field using device_agent#clear_text
And I dismiss the keyboard by tapping the keyboard action key

Then I clear the text in the numeric text field using Objective-C selectors
Then I type "123" in the numeric text field
Then I clear the text in the numeric text field using Core#clear_text
Then I type "123" in the numeric text field
Then I clear the text in the numeric text field using device_agent#clear_text
And I dismiss the keyboard by asking the numeric text field to resign first responder

Then I clear the text in the CalTextField using Objective-C selectors
Then I type "This is a not a TextInput field" in the CalTextField
Then I clear the text in the CalTextField using Core#clear_text
Then I type "This is not a TextInput field" in the CalTextField
But I cannot clear the text in the CalTextField using device_agent#clear_text
