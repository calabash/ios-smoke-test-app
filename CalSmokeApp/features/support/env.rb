# Do not use Calabash pre-defined steps.
require 'calabash-cucumber/wait_helpers'
require 'calabash-cucumber/operations'
World(Calabash::Cucumber::Operations)

require 'rspec'
require 'chronic'

# Pry is not allowed on the Xamarin Test Cloud.  This will force a validation
# error if you mistakenly submit a binding.pry to the Test Cloud.
if !ENV['XAMARIN_TEST_CLOUD']
  require 'pry'
  Pry.config.history_file = '.pry-history'
  require 'pry-nav'
end
