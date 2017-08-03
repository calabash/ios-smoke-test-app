#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh

ensure_valid_core_sim_service

set -e

banner "Preparing"

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

if [ \( -z "${1}" \) -o \( "${1}" != "Debug" -a "${1}" != "Release" \) ]; then
  error "Script requires one argument - the Xcode build configuration"
  error "This can be either Debug or Release"
  error "  Debug: embeds Calabash dylibs in the app and loads them at runtime."
  error "Release: includes no Calabash libraries; suitable for testing dylib injection."
  exit 1
fi

XC_CONFIG="${1}"

if [ "${XC_CONFIG}" = "Release" ]; then
  XC_BUILD_DIR=build/app/CalSmoke/no-calabash
  INSTALL_DIR=Products/app/CalSmoke/no-calabash
else
  XC_BUILD_DIR="build/app/CalSmoke/embedded-calabash-dylib"
  INSTALL_DIR="Products/app/CalSmoke/embedded-calabash-dylib"
fi


APP="${XC_TARGET}.app"
DSYM="${APP}.dSYM"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphonesimulator"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"

OBJECT_ROOT_DIR="${XC_BUILD_DIR}/Build/Intermediates/${XC_CONFIG}-iphonesimulator"

info "Prepared archive directory"

banner "Building ${APP}"

if [ -z "${CODE_SIGN_IDENTITY}" ]; then
  COMMAND_LINE_BUILD=1 xcrun xcodebuild \
    -SYMROOT="${XC_BUILD_DIR}" \
    OBJROOT="${OBJECT_ROOT_DIR}" \
    BUILT_PRODUCTS_DIR="${BUILD_PRODUCTS_DIR}" \
    TARGET_BUILD_DIR="${BUILD_PRODUCTS_DIR}" \
    DWARF_DSYM_FOLDER_PATH="${BUILD_PRODUCTS_DIR}" \
    -project "${XC_PROJECT}" \
    -target "${XC_TARGET}" \
    -configuration "${XC_CONFIG}" \
    -sdk iphonesimulator \
    ARCHS="i386 x86_64" \
    VALID_ARCHS="i386 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE
else
  COMMAND_LINE_BUILD=1 xcrun xcodebuild \
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
    -SYMROOT="${XC_BUILD_DIR}" \
    OBJROOT="${OBJECT_ROOT_DIR}" \
    BUILT_PRODUCTS_DIR="${BUILD_PRODUCTS_DIR}" \
    TARGET_BUILD_DIR="${BUILD_PRODUCTS_DIR}" \
    DWARF_DSYM_FOLDER_PATH="${BUILD_PRODUCTS_DIR}" \
    -project "${XC_PROJECT}" \
    -target "${XC_TARGET}" \
    -configuration "${XC_CONFIG}" \
    -sdk iphonesimulator \
    ARCHS="i386 x86_64" \
    VALID_ARCHS="i386 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE
fi

if [ ! -z ${USE_XCPRETTY} ]; then
  EXIT_CODE=${PIPESTATUS[0]}
else
  EXIT_CODE=$?
fi

if [ $EXIT_CODE != 0 ]; then
  error "Building app failed."
  exit $EXIT_CODE
else
  info "Building app succeeded."
fi

banner "Installing"

ditto_or_exit "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"
info "Installed ${INSTALLED_APP}"

ditto_or_exit "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
info "Installed ${INSTALLED_DSYM}"
info "Done!"

