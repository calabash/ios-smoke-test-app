#!/usr/bin/env bash

set -e

if [ -z "${JENKINS_HOME}" ]; then
  echo "Only run this on Jenkins!!!"
fi

bundle install

bundle exec bin/ci/cucumber.rb
