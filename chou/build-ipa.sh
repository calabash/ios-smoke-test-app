#!/usr/bin/env bash

if [ "${USER}" = "jenkins" ]; then
    echo "INFO: hey, you are jenkins!  loading ~/.bash_profile_ci"
    source ~/.bash_profile_ci
    hash -r
    rbenv rehash
fi

XCPRETTY=`gem list xcpretty -i`

if [ "${XCPRETTY}" = "false" ]; then gem install xcpretty; fi

if which rbenv > /dev/null; then
    RBENV_EXEC="rbenv exec"
else
    RBENV_EXEC=
fi

TARGET_NAME="chou"
XC_PROJECT="chou.xcodeproj"
XC_SCHEME="${TARGET_NAME}"

if [ ! -z "${1}" ]; then
  CONFIG="${1}"
else
  CONFIG=Debug
fi

CAL_DISTRO_DIR="${PWD}/build/ipa"
ARCHIVE_BUNDLE="${CAL_DISTRO_DIR}/chou.xcarchive"
APP_BUNDLE_PATH="${ARCHIVE_BUNDLE}/Products/Applications/${TARGET_NAME}.app"
DYSM_PATH="${ARCHIVE_BUNDLE}/dSYMs/${TARGET_NAME}.app.dSYM"
IPA_PATH="${CAL_DISTRO_DIR}/${TARGET_NAME}.ipa"


rm -rf "${CAL_DISTRO_DIR}"
mkdir -p "${CAL_DISTRO_DIR}"

set +o errexit


if [ -z "${XAM_SMOKE_SIGNING_IDENTITY}" ]; then
    xcrun xcodebuild archive \
        -SYMROOT="${CAL_DISTRO_DIR}" \
        -derivedDataPath "${CAL_DISTRO_DIR}" \
        -project "${XC_PROJECT}" \
        -scheme "${XC_SCHEME}" \
        -configuration "${CONFIG}" \
        -archivePath "${ARCHIVE_BUNDLE}" \
        ARCHS="armv7 armv7s arm64" \
        VALID_ARCHS="armv7 armv7s arm64" \
        ONLY_ACTIVE_ARCH=NO \
        -sdk iphoneos | xcpretty -c
   else
        xcrun xcodebuild archive \
        CODE_SIGN_IDENTITY="${XAM_SMOKE_SIGNING_IDENTITY}" \
        -SYMROOT="${CAL_DISTRO_DIR}" \
        -derivedDataPath "${CAL_DISTRO_DIR}" \
        -project "${XC_PROJECT}" \
        -scheme "${XC_SCHEME}" \
        -configuration "${CONFIG}" \
        -archivePath "${ARCHIVE_BUNDLE}" \
        ARCHS="armv7 armv7s arm64" \
        VALID_ARCHS="armv7 armv7s arm64" \
        ONLY_ACTIVE_ARCH=NO \
        -sdk iphoneos | xcpretty -c
   fi

RETVAL=${PIPESTATUS[0]}

set -o errexit

if [ $RETVAL != 0 ]; then
    echo "FAIL:  archive failed"
    exit $RETVAL
fi

set +o errexit


xcrun -sdk iphoneos PackageApplication -v "${APP_BUNDLE_PATH}" -o "${IPA_PATH}" > /dev/null

RETVAL=$?

set -o errexit

if [ $RETVAL != 0 ]; then
    echo "FAIL:  export archive failed"
    exit $RETVAL
fi

rm -rf "${PWD}/${TARGET_NAME}.ipa"
cp "${IPA_PATH}" "${PWD}/"
echo "Created ${PWD}/${TARGET_NAME}.ipa"

cp -r "${DYSM_PATH}" "${PWD}/"
echo "Created "${PWD}/${TARGET_NAME}.app.dSYM""

exit 0
