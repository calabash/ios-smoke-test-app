module CalSmokeApp
  module Keyboard

  end
end

World(CalSmokeApp::Keyboard)

Then(/^I type "([^"]*)"$/) do |text_to_type|
  query = "UITextField index:0"
  wait_for_view(query)
  touch(query)
  wait_for_keyboard

  keyboard_enter_text text_to_type
end


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

And(/^I dismiss the keyboard by asking the numeric text field to resign first responder$/) do
  # Do not do this unless absolutely necessary.
  # Your UI should provide a way for the user to dismiss a keyboard.
  query = "UITextField index:1"
  query(query, :resignFirstResponder)
  wait_for_no_keyboard
end

And(/^I dismiss the keyboard that is attached to the CalTextField$/) do
  # Do not do this unless absolutely necessary.
  # Your UI should provide a way for the user to dismiss a keyboard.
  tap_keyboard_action_key
  wait_for_no_keyboard
end

Then(/^I clear the text in the (CalTextField|text field|numeric text field) using Objective-C selectors$/) do |where|
  if where == "text field"
    query = "UITextField index:0"
  elsif where == "numeric text field"
    query = "UITextField index:1"
  else
    query = "* marked:'cal text field'"
  end

  wait_for_view(query)

  query(query, {setText:""})
  expect(query(query)[0]["text"]).to be == ""
end

Then(/^I type "([^"]*)" in the text field$/) do |string|
  query = "UITextField index:0"
  wait_for_view(query)
  touch(query)
  wait_for_keyboard
  keyboard_enter_text(string)
end

Then(/^I type "([^"]*)" in the numeric text field$/) do |string|
  query = "UITextField index:1"
  wait_for_view(query)
  touch(query)
  wait_for_keyboard
  keyboard_enter_text(string)
end

Then(/^I type "([^"]*)" in the CalTextField$/) do |string|
  query = "* marked:'cal text field'"
  wait_for_view(query)
  touch(query)
  wait_for_keyboard
  keyboard_enter_text(string)
end

Then(/^I clear the text in the (CalTextField|text field|numeric text field) using (Core|device_agent)#clear_text$/) do |where, api|
  if where == "text field"
    query = "UITextField index:0"
  elsif where == "numeric text field"
    query = "UITextField index:1"
  else
    query = "* marked:'cal text field'"
  end
  wait_for_view(query)

  if api == "Core" || uia_available?
    clear_text(query)
  else
    device_agent.clear_text
  end

  expect(query(query)[0]["text"]).to be == ""
end

But(/^I cannot clear the text in the CalTextField using device_agent#clear_text$/) do
  query = "* marked:'cal text field'"
  wait_for_view(query)

  # Nop
  return if uia_available?

  expect do
    device_agent.clear_text
  end.to raise_error RunLoop::DeviceAgent::Client::HTTPError,
    /Can not clear text: no element has focus/
end
