#!/usr/bin/env bash

set -e

if [ -z "${JENKINS_HOME}" ]; then
  echo "Only run this on Jenkins!!!"
fi

gem install run_loop --no-document --env-shebang --no-prerelease
gem install luffa --no-document --env-shebang --no-prerelease

DEVELOPER_DIR=/Xcode/8.0/Xcode.app/Contents/Developer bin/ci/cucumber.rb --tags @travis

