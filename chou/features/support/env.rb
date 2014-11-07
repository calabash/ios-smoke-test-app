require 'calabash-cucumber/wait_helpers'
require 'calabash-cucumber/operations'
World(Calabash::Cucumber::Operations)

unless ENV['XAMARIN_TEST_CLOUD'] == '1'
  require 'pry'
end
