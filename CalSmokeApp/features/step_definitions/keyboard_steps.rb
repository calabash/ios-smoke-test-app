module CalSmokeApp
  module Keyboard

  end
end

World(CalSmokeApp::Keyboard)

And(/^I dismiss the keyboard by tapping the keyboard action key$/) do
  tap_keyboard_action_key
end

Then(/^I touch the CalTextField$/) do
  query = "* marked:'cal text field'"
  wait_for_view(query)
  touch(query)
  wait_for_keyboard
end

And(/^the first responder text is "([^"]*)"$/) do |expected_text|
  # This is a private method.
  text = _text_from_first_responder
  expect(text).to be == expected_text
end

And(/^I can append the text of the CalTextField$/) do
  keyboard_enter_text(": a UITextInput")

  query = "* marked:'cal text field'"
  text = query(query, :text).first
  expect(text).to be == "CalTextField: a UITextInput"
end

And(/^I dismiss the keyboard that is attached to the CalTextField$/) do
  # Do not do this unless absolutely necessary.
  # Your UI should provide a way for the user to dismiss a keyboard.
  query = "* marked:'cal text field'"
  query(query, :resignFirstResponder)
  wait_for_no_keyboard
end
