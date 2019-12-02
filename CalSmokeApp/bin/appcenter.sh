#!/usr/bin/env bash

source bin/log.sh

set -e

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set [DeviceAgent-SHA]

Examples:

$ bin/appcenter.sh App-Center-Test-Cloud/coordinator-experiment
$ SKIP_IPA_BUILD=1 SERIES='Args and env' bin/appcenter.sh \
  App-Center-Test-Cloud/coordinator-experiment
$ SERIES='DeviceAgent 2.0' bin/appcenter.sh \
  App-Center-Test-Cloud/coordinator-experiment \
  48d137d6228ccda303b2a71b0d09e1d0629bf980

The DeviceAgent-SHA optional argument allows tests to be run against any
DeviceAgent that has been uploaded to S3 rather than the current active
DeviceAgent for Test Cloud.

If you need to test local changes to run-loop or Calabash on Test Cloud,
use the BUILD_RUN_LOOP and BUILD_CALABASH env variables.

Responds to these env variables:

        SERIES: the Test Cloud series
SKIP_IPA_BUILD: iff 1, then skip re-building the ipa.
                'make test-ipa' will still be called, so changes in the
                features/ directory will be staged and sent to Test Cloud.
BUILD_RUN_LOOP: iff 1, then rebuild run-loop gem before uploading.
BUILD_RUN_LOOP: iff 1, then rebuild Calabash iOS gem before uploading.

"

  exit 64
fi

APPCENTER_TOKEN=$("${HOME}/.calabash/find-keychain-credential.sh" api-token)

if [ -z "${APPCENTER_TOKEN}" ]; then
  error "Failed to load appcenter token"
  exit 1
fi

# The uninstall/install dance is required to test changes in
# run-loop and calabash-cucumber in Test Cloud
if [ "${BUILD_RUN_LOOP}" = "1" ]; then
  gem uninstall -Vax --force --no-abort-on-dependent run_loop
  (cd ../run_loop; rake install)
fi

if [ "${BUILD_CALABASH}" = "1" ]; then
  gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber
  (cd ../calabash-ios/calabash-cucumber; rake install)
fi

PREPARE_XTC_ONLY="${SKIP_IPA_BUILD}" make ipa-cal

(cd testcloud-submit

rm -rf .xtc
mkdir -p .xtc

if [ "${2}" != "" ]; then
  echo "${2}" > .xtc/device-agent-sha
fi)

gem uninstall -Vax --force --no-abort-on-dependent
gem install bundler --version "1.17.3"

appcenter test run calabash \
  --app-path testcloud-submit/CalSmoke-cal.ipa \
  --app App-Center-Test-Cloud/iOSCalSmoke \
  --project-dir testcloud-submit \
  --token $APPCENTER_TOKEN \
  --devices "${1}" \
  --config-path cucumber.yml \
  --profile default \
  --include .xtc \
  --test-series ${SERIES} \
  --disable-telemetry
