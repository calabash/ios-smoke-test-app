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
                off: 1,     # UITextAutocorrectionTypeNo,
                on: 2       # UITextAutocorrectionTypeYes
          }

    SPELL_CHECKING =
          {
                default: 0, # UITextSpellCheckTypeDefault,
                off: 1,     # UITextSpellCheckTypeNo,
                on: 2       # UITextSpellCheckTypeYes
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
        raise "Unknown auto correct type: '#{name}'. Valid names: :default, :no, :yes"
      end

      query('UITextField', [{setAutocorrectionType:type}])
    end

    def spell_check_type
      query('UITextField', :spellCheckingType).first
    end

    def set_spell_check_type(name)
      type = SPELL_CHECKING[name]

      unless type
        raise "Unknown spell check type: '#{name}'. Valid names: :default, :no, :yes"
      end

      query('UITextField', [{setSpellCheckingType:type}])
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

And(/^I turn (on|off) auto correct$/) do |on_or_off|
  set_auto_correct_type(on_or_off.to_sym)
end

And(/^I turn (on|off) spell checking$/) do |on_or_off|
  set_spell_check_type(on_or_off.to_sym)
end

Then(/^the text should be marked as incorrect$/) do
  pending
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
