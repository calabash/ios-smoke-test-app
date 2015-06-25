module CalSmokeApp
  module Keyboard

    CAPITALIZATION =
          {
           none: 0,      # UITextAutocapitalizationTypeNone
           words: 1,     # UITextAutocapitalizationTypeWords
           sentences: 2, # UITextAutocapitalizationTypeSentences
           all: 3        # UITextAutocapitalizationTypeAllCharacters
          }

    CORRECTION =
          {
                default: 0, # UITextAutocorrectionTypeDefault,
                no: 1,      # UITextAutocorrectionTypeNo,
                yes: 2      # UITextAutocorrectionTypeYes
          }

    def auto_capitalization_type
      query('UITextField', :autocapitalizationType).first
    end

    def set_auto_capitalization_type(name)
      if keyboard_visible?
        fail('Cannot set the capitalization type if the keyboard is visible')
      end

      type = CAPITALIZATION[name]

      unless type
        raise "Unknown capitalization type: '#{name}'. Valid names: :none, :words, :sentences, :all"
      end

      query('UITextField', [{setAutocapitalizationType:type}])
    end

    def auto_correct_type
      query('UITextField', :autocorrectionType).first
    end

    def set_auto_correct_type(name)
      type = CORRECTION[name]

      unless type
        raise "Unknown capitalization type: '#{name}'. Valid names: :default, :no, :yes"
      end

      query('UITextField', [{setAutocorrectionType:type}])
    end
  end
end

World(CalSmokeApp::Keyboard)

And(/^I turn off auto capitalization$/) do
  set_auto_capitalization_type :none
end

And(/^I turn on all caps$/) do
  set_auto_capitalization_type :all
end

And(/^I turn on capitalize sentences$/) do
  set_auto_capitalization_type :words
end

And(/^I turn on spell checking$/) do
  set_auto_correct_type(:yes)
end

Then(/^I touch the text field$/) do
  touch('UITextField')
  wait_for_keyboard
end

When(/^I type "([^"]*)", I should see "([^"]*)"$/) do |typed, expected|
  keyboard_enter_text typed
  actual = query('UITextField', :text).first
  expect(actual).to be == expected
end

When(/^I type "([^"]*)" and touch done$/) do |typed|
  keyboard_enter_text typed
  tap_keyboard_action_key
end

Then(/^the text should be "([^"]*)"$/) do |expected|
  actual = query('UITextField', :text).first
  expect(actual).to be == expected
end
