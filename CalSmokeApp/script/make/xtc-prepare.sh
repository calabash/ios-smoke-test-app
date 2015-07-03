#!/usr/bin/env bash

bundle

XAMARIN_DIR="${PWD}/xtc-staging"

echo "INFO: creating the ./xtc-staging directory"
rm -rf "${XAMARIN_DIR}"
mkdir -p "${XAMARIN_DIR}"

echo "INFO: copying features over to ${XAMARIN_DIR}"
cp -r features "${XAMARIN_DIR}/"

echo "INFO: installing config/xtc-profiles.yml to ${XAMARIN_DIR}/cucumber.yml"
cp "./config/xtc-profiles.yml" "${XAMARIN_DIR}/cucumber.yml"

TARGET_NAME="CalSmoke-cal"
XC_PROJECT="ios-smoke-test-app.xcodeproj"
XC_SCHEME="${TARGET_NAME}"
CONFIG="Debug"

CAL_DISTRO_DIR="build/xtc"
ARCHIVE_BUNDLE="${CAL_DISTRO_DIR}/${TARGET_NAME}.xcarchive"
APP_BUNDLE_PATH="${ARCHIVE_BUNDLE}/Products/Applications/${TARGET_NAME}.app"
DYSM_PATH="${ARCHIVE_BUNDLE}/dSYMs/${TARGET_NAME}.app.dSYM"
IPA_PATH="${CAL_DISTRO_DIR}/${TARGET_NAME}.ipa"

rm -rf "${CAL_DISTRO_DIR}"
mkdir -p "${CAL_DISTRO_DIR}"

set +o errexit

if [ -z "${CODE_SIGN_IDENTITY}" ]; then
  xcrun xcodebuild \
    archive \
    -project "${XC_PROJECT}" \
    -scheme "${XC_SCHEME}" \
    -configuration "${CONFIG}" \
    -archivePath "${ARCHIVE_BUNDLE}" \
    -SYMROOT="${CAL_DISTRO_DIR}" \
    -derivedDataPath "${CAL_DISTRO_DIR}" \
    ARCHS="armv7 armv7s arm64" \
    VALID_ARCHS="armv7 armv7s arm64" \
    ONLY_ACTIVE_ARCH=NO \
    -sdk iphoneos | bundle exec xcpretty -c
else
  xcrun xcodebuild \
    archive \
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
    -project "${XC_PROJECT}" \
    -scheme "${XC_SCHEME}" \
    -configuration "${CONFIG}" \
    -archivePath "${ARCHIVE_BUNDLE}" \
    -SYMROOT="${CAL_DISTRO_DIR}" \
    -derivedDataPath "${CAL_DISTRO_DIR}" \
    ARCHS="armv7 armv7s arm64" \
    VALID_ARCHS="armv7 armv7s arm64" \
    ONLY_ACTIVE_ARCH=NO \
    -sdk iphoneos | bundle exec xcpretty -c
fi

RETVAL=${PIPESTATUS[0]}

set -o errexit

if [ $RETVAL != 0 ]; then
  echo "FAIL:  archive failed"
  exit $RETVAL
fi

set +o errexit

PACKAGE_LOG="${CAL_DISTRO_DIR}/package.log"

xcrun \
  -sdk \
  iphoneos \
  PackageApplication \
  -v "${PWD}/${APP_BUNDLE_PATH}" \
  -o "${PWD}/${IPA_PATH}" > "${PACKAGE_LOG}"

RETVAL=$?

echo "INFO: Package Application Log: ${PACKAGE_LOG}"

set -o errexit

if [ $RETVAL != 0 ]; then
  echo "FAIL:  export archive failed"
  exit $RETVAL
fi

mv "${IPA_PATH}" "${XAMARIN_DIR}/"
mv "${DYSM_PATH}" "${XAMARIN_DIR}/${TARGET_NAME}.app.dSYM"

echo "Copied features/ to ${XAMARIN_DIR}"
echo "Copied config/xtc-profiles.yml to ${XAMARIN_DIR}/cucumber.yml"
echo "Created ${XAMARIN_DIR}/${TARGET_NAME}.ipa"
echo "Created ${XAMARIN_DIR}/${TARGET_NAME}.app.dSYM"
