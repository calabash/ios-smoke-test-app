module CalSmokeApp
  module Keyboard

    CAPITALIZATION =
          {
           none: 0,      # UITextAutocapitalizationTypeNone
           words: 1,     # UITextAutocapitalizationTypeWords
           sentences: 2, # UITextAutocapitalizationTypeSentences
           all: 3        # UITextAutocapitalizationTypeAllCharacters
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
      sleep 5
      ap "'#{name}' => #{auto_capitalization_type}"
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

Then(/^I touch the text field$/) do
  touch('UITextField')
  wait_for_keyboard
end

When(/^I type "([^"]*)", I should see "([^"]*)"$/) do |typed, expected|
  keyboard_enter_text typed
  actual = query('UITextField', :text).first
  expect(actual).to be == expected
end
