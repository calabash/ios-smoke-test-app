#!/usr/bin/env bash

bundle

if [ ! -z "${1}" ]; then
  CAL_BUILD_CONFIG="${1}"
else
  CAL_BUILD_CONFIG=Debug
fi

TARGET_NAME="CalSmoke"
XC_PROJECT="ios-smoke-test-app.xcodeproj"
XC_SCHEME="${TARGET_NAME}"
CAL_BUILD_DIR="${PWD}/build"
rm -rf "${CAL_BUILD_DIR}"
mkdir -p "${CAL_BUILD_DIR}"

set +o errexit

if [ -z "${CODE_SIGN_IDENTITY}" ]; then
  xcrun xcodebuild \
    -SYMROOT="${CAL_BUILD_DIR}" \
    -derivedDataPath "${CAL_BUILD_DIR}" \
    ARCHS="i386 x86_64" \
    VALID_ARCHS="i386 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    -project "${XC_PROJECT}" \
    -scheme "${TARGET_NAME}" \
    -sdk iphonesimulator \
    -configuration "${CAL_BUILD_CONFIG}" \
    clean build | bundle exec xcpretty -c
else
  xcrun xcodebuild \
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
    -SYMROOT="${CAL_BUILD_DIR}" \
    -derivedDataPath "${CAL_BUILD_DIR}" \
    ARCHS="i386 x86_64" \
    VALID_ARCHS="i386 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    -project "${XC_PROJECT}" \
    -scheme "${TARGET_NAME}" \
    -sdk iphonesimulator \
    -configuration "${CAL_BUILD_CONFIG}" \
    clean build | bundle exec xcpretty -c
fi

RETVAL=${PIPESTATUS[0]}

set -o errexit

if [ $RETVAL != 0 ]; then
  echo "FAIL:  Could not build"
  exit $RETVAL
else
  echo "INFO: Successfully built"
fi


APP_BUNDLE_PATH="${CAL_BUILD_DIR}/Build/Products/${CAL_BUILD_CONFIG}-iphonesimulator/${TARGET_NAME}.app"
if [ "${CAL_BUILD_CONFIG}" = "Debug" ]; then
  APP="${TARGET_NAME}-Calabash-dylibs-embedded.app"
else
  APP="${TARGET_NAME}-no-Calabash-dylibs-embedded.app"
fi

mv "${APP_BUNDLE_PATH}" "${PWD}/${APP}"
echo "export APP=${PWD}/${APP}"

echo "INFO: Installing app on default simulator"
bundle exec run-loop simctl install --app "${PWD}/${APP}"

