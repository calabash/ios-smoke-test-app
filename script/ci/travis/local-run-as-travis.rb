#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), 'ci-helpers'))

working_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..'))

ENV['TRAVIS'] = '1'

Dir.chdir working_dir do
  uninstall_gem 'calabash-cucumber'
  do_system('script/ci/travis/bundle-install.rb')
  do_system('script/ci/travis/build-and-stage-app.sh')
  do_system('script/ci/travis/cucumber-ci.rb --tags ~@no_ci')
end
