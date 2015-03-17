#!/usr/bin/env bash

if [ "${USER}" = "jenkins" ]; then
    echo "INFO: hey, you are jenkins!  loading ~/.bash_profile_ci"
    source ~/.bash_profile_ci
    hash -r
    rbenv rehash
fi

if which rbenv > /dev/null; then
    RBENV_EXEC="rbenv exec"
else
    RBENV_EXEC=
fi

if [ ! -z "${1}" ]; then
  CAL_BUILD_CONFIG="${1}"
else
  CAL_BUILD_CONFIG=Debug
fi

TARGET_NAME="chou"
XC_PROJECT="chou.xcodeproj"
XC_SCHEME="${TARGET_NAME}"
CAL_BUILD_DIR="${PWD}/build"
rm -rf "${CAL_BUILD_DIR}"
mkdir -p "${CAL_BUILD_DIR}"

set +o errexit

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
    clean build | $RBENV_EXEC xcpretty -c

RETVAL=${PIPESTATUS[0]}

set -o errexit

if [ $RETVAL != 0 ]; then
    echo "FAIL:  could not build"
    exit $RETVAL
else
    echo "INFO: successfully built"
fi

rm -rf "${PWD}/${TARGET_NAME}.app"

APP_BUNDLE_PATH="${CAL_BUILD_DIR}/Build/Products/${CAL_BUILD_CONFIG}-iphonesimulator/${TARGET_NAME}.app"
cp -r "${APP_BUNDLE_PATH}" "${PWD}"
