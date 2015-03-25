#!/usr/bin/env bash

cd CalSmokeApp

if which rbenv > /dev/null; then
    RBENV_EXEC="rbenv exec"
else
    RBENV_EXEC=
fi

${RBENV_EXEC} bundle install

TARGET_NAME="CalSmoke-cal"
XC_PROJECT="ios-smoke-test-app.xcodeproj"
XC_SCHEME="${TARGET_NAME}"
CAL_BUILD_CONFIG=Debug
CAL_BUILD_DIR="${PWD}/build/ci"

rm -rf "${TARGET_NAME}.app"
rm -rf "${CAL_BUILD_DIR}"
mkdir -p "${CAL_BUILD_DIR}"

set +o errexit

xcrun xcodebuild \
    -derivedDataPath "${CAL_BUILD_DIR}" \
    -project "${XC_PROJECT}" \
    -scheme "${TARGET_NAME}" \
    -sdk iphonesimulator \
    -configuration "${CAL_BUILD_CONFIG}" \
    clean build | $RBENV_EXEC bundle exec xcpretty -c

RETVAL=${PIPESTATUS[0]}

set -o errexit

if [ $RETVAL != 0 ]; then
    echo "FAIL:  could not build"
    exit $RETVAL
else
    echo "INFO: successfully built"
fi

APP_BUNDLE_PATH="${CAL_BUILD_DIR}/Build/Products/${CAL_BUILD_CONFIG}-iphonesimulator/${TARGET_NAME}.app"

echo "INFO: copying ${TARGET_NAME}.app to ./"
cp -r "${APP_BUNDLE_PATH}" ./

bundle exec calabash-ios sim reset
