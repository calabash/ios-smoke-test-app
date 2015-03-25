#!/usr/bin/env ruby
require 'luffa'

working_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..'))

# noinspection RubyStringKeysInHashInspection
env_vars =
      {
            'TRAVIS' => '1',
      }

Dir.chdir working_dir do
  Luffa::Gem.uninstall_gem 'calabash-cucumber'
  Luffa.unix_command('script/ci/travis/bundle-install.rb', {:env_vars => env_vars})
  Luffa.unix_command('script/ci/travis/build-and-stage-app.sh', {:env_vars => env_vars})
  Luffa.unix_command('script/ci/travis/cucumber-ci.rb --tags ~@no_ci', {:env_vars => env_vars})
end
