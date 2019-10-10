#!/usr/bin/env bash

set -eo pipefail

# $1 => SOURCE PATH
# $2 => TARGET NAME
function azupload {
  az storage blob upload \
    --container-name test-apps \
    --file "${1}" \
    --name "${2}"
  echo "${1} artifact uploaded with name ${2}"
}

function info {
  if [ "${TERM}" = "dumb" ]; then
    echo "INFO: $1"
  else
    echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
  fi
}

function zip_with_ditto {
  xcrun ditto \
  -ck --rsrc --sequesterRsrc --keepParent \
  "${1}" \
  "${2}"
  info "Installed ${2}"
}

# Pipeline Variables are set through the AzDevOps UI
# See also the ./azdevops-pipeline.yml
if [[ -z "${AZURE_STORAGE_ACCOUNT}" ]]; then
  echo "AZURE_STORAGE_ACCOUNT is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_KEY}" ]]; then
  echo "AZURE_STORAGE_KEY is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_CONNECTION_STRING}" ]]; then
  echo "AZURE_STORAGE_CONNECTION_STRING is required"
  exit 1
fi

WORKING_DIR="${BUILD_SOURCESDIRECTORY}"
PRODUCT_DIR="${WORKING_DIR}/Products/app/CalSmoke-cal"
INFO_PLIST="${PRODUCT_DIR}/CalSmoke-cal.app/Info.plist"

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ${INFO_PLIST})

# Evaluate git-sha value
GIT_SHA=$(git rev-parse --verify HEAD | tr -d '\n')

# Evaluate CalSmokeApp version (from Info.plist)
# VERSION=$(plutil -p ${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app/Info.plist | grep CFBundleShortVersionString | grep -o '"[[:digit:].]*"' | sed 's/"//g')

az --version

# Upload `CalSmokeApp.app` (zipped)
APP_ZIP="${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app.zip"
zip_with_ditto "${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app" "${APP_ZIP}"
APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.zip"
azupload "${APP_ZIP}" "${APP_NAME}"

# Upload `CalSmokeApp.app.dSYM` (zipped)
APP_DSYM_ZIP="${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app.dSYM.zip"
zip_with_ditto "${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app.dSYM" "${APP_DSYM_ZIP}"
APP_DSYM_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.dSYM.zip"
azupload "${APP_DSYM_ZIP}" "${APP_DSYM_NAME}"

# Upload `CalSmokeApp.ipa`
IPA="${WORKING_DIR}/CalSmokeApp/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa"
IPA_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa"
azupload "${IPA}" "${IPA_NAME}"

# # Upload `CalSmokeApp.ipa.dSYM` (zipped)
IPA_DSYM_ZIP="${WORKING_DIR}/CalSmokeApp/Products/ipa/CalSmoke-cal/CalSmoke-cal.app.dSYM.zip"
zip_with_ditto "${WORKING_DIR}/CalSmokeApp/Products/ipa/CalSmoke-cal/CalSmoke-cal.app.dSYM" "${IPA_DSYM_ZIP}"
IPA_DSYM_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa.dSYM.zip"
azupload "${IPA_DSYM_ZIP}" "${IPA_DSYM_NAME}"

