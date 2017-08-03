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

XC_TARGET="CalSmoke-cal"
XC_PROJECT="ios-smoke-test-app.xcodeproj"
XC_BUILD_DIR="${PWD}/build/app/CalSmoke-cal"
XC_CONFIG=Debug

APP="${XC_TARGET}.app"
DSYM="${APP}.dSYM"

INSTALL_DIR="Products/app/CalSmoke-cal"
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

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building app failed."
  exit $EXIT_CODE
else
  info "Building app succeeded."
fi

banner "Installing"

install_with_ditto "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"

install_with_ditto "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"

ditto_to_zip "${INSTALLED_APP}" \
  "${INSTALL_DIR}/CalSmoke-sim.app.zip"
info "Installed ${INSTALL_DIR}/CalSmoke-sim.app.zip"

install_with_ditto "${BUILD_PRODUCTS_DSYM}" \
  "${INSTALL_DIR}/CalSmoke-sim.app.dSYM"

info "Done!"
