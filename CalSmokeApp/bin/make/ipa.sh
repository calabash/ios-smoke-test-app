#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh

ensure_valid_core_sim_service

set -e

if [ "${XCPRETTY}" = "0" ]; then
  USE_XCPRETTY=
else
  USE_XCPRETTY=`which xcpretty | tr -d '\n'`
fi

if [ ! -z ${USE_XCPRETTY} ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

XC_TARGET="CalSmoke"
XC_PROJECT="ios-smoke-test-app.xcodeproj"
XC_SCHEME="${XC_TARGET}"

if [ \( -z "${1}" \) -o \( "${1}" != "Debug" -a "${1}" != "Release" \) ]; then
  error "Script requires one argument - the Xcode build configuration"
  error "This can be either Debug or Release"
  error "  Debug: embeds Calabash dylibs in the app and loads them at runtime."
  error "Release: includes no Calabash libraries; suitable for testing dylib injection."
  exit 1
fi

XC_CONFIG="${1}"

if [ "${XC_CONFIG}" = "Release" ]; then
  XC_BUILD_DIR=build/ipa/CalSmoke/no-calabash
  INSTALL_DIR=Products/ipa/CalSmoke/no-calabash
else
  XC_BUILD_DIR="build/ipa/CalSmoke/embedded-calabash-dylib"
  INSTALL_DIR="Products/ipa/CalSmoke/embedded-calabash-dylib"
fi


APP="${XC_TARGET}.app"
DSYM="${APP}.dSYM"
IPA="${XC_TARGET}.ipa"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_IPA="${INSTALL_DIR}/${IPA}"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphoneos"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"

info "Prepared archive directory"

banner "Building ${IPA}"

if [ -z "${CODE_SIGN_IDENTITY}" ]; then
  COMMAND_LINE_BUILD=1 xcrun xcodebuild \
    -SYMROOT="${XC_BUILD_DIR}" \
    -derivedDataPath "${XC_BUILD_DIR}" \
    -project "${XC_PROJECT}" \
    -scheme "${XC_TARGET}" \
    -configuration "${XC_CONFIG}" \
    -sdk iphoneos \
    ARCHS="armv7 armv7s arm64" \
    VALID_ARCHS="armv7 armv7s arm64" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE
else
  COMMAND_LINE_BUILD=1 xcrun xcodebuild \
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
    -SYMROOT="${XC_BUILD_DIR}" \
    -derivedDataPath "${XC_BUILD_DIR}" \
    -project "${XC_PROJECT}" \
    -scheme "${XC_TARGET}" \
    -configuration "${XC_CONFIG}" \
    -sdk iphoneos \
    ARCHS="armv7 armv7s arm64" \
    VALID_ARCHS="armv7 armv7s arm64" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE
fi

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building ipa failed."
  exit $EXIT_CODE
else
  info "Building ipa succeeded."
fi

banner "Installing"

ditto_or_exit "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"
info "Installed ${INSTALLED_APP}"

PAYLOAD_DIR="${INSTALL_DIR}/Payload"
mkdir -p "${PAYLOAD_DIR}"

ditto_or_exit "${INSTALLED_APP}" "${PAYLOAD_DIR}/${APP}"

ditto_to_zip "${PAYLOAD_DIR}" "${INSTALLED_IPA}"

info "Installed ${INSTALLED_IPA}"

ditto_or_exit "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
info "Installed ${INSTALLED_DSYM}"

banner "Code Signing Details"

DETAILS=`xcrun codesign --display --verbose=2 ${INSTALLED_APP} 2>&1`

echo "$(tput setaf 4)$DETAILS$(tput sgr0)"

if [ "${XC_CONFIG}" = "Release" ]; then
  echo ""
  info "Done!"
  exit 0
fi

banner "Preparing for XTC Submit"

XTC_DIR="xtc-submit-calabash-embedded"
rm -rf "${XTC_DIR}"
mkdir -p "${XTC_DIR}"

ditto_or_exit features "${XTC_DIR}/features"
info "Copied features to ${XTC_DIR}/"

ditto_or_exit config/xtc-profiles.yml "${XTC_DIR}/cucumber.yml"
info "Copied config/xtc-profiles.yml to ${XTC_DIR}/"

ditto_or_exit "${INSTALLED_IPA}" "${XTC_DIR}/"
info "Copied ${IPA} to ${XTC_DIR}/"

ditto_or_exit "${INSTALLED_DSYM}" "${XTC_DIR}/${DSYM}"
info "Copied ${DSYM} to ${XTC_DIR}/"

info "Done!"

