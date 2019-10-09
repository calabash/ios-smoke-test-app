#!/usr/bin/env bash

set -eo pipefail

# $1 => SOURCE PATH
# $2 => TARGET NAME
function azupload {
  az storage blob upload \
    --container-name ios-device-agent \
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

# Evaluate git-sha value
GIT_SHA=$(git rev-parse --verify HEAD | tr -d '\n')

# Evaluate CalSmokeApp version (from Info.plist)
VERSION=$(plutil -p ${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal/CalSmoke-cal.app/Info.plist | grep CFBundleShortVersionString | grep -o '"[[:digit:].]*"' | sed 's/"//g')

az --version

# Upload `CalSmokeApp.app` (zipped)
APP_ZIP="${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal.app.zip"
zip_with_ditto "${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal.app" "${APP_ZIP}"
APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.zip"
azupload "${APP_ZIP}" "${APP_NAME}"

# Upload `CalSmokeApp.app.dSYM` (zipped)
APP_DSYM_ZIP="${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal.app.dSYM.zip"
zip_with_ditto "${WORKING_DIR}/CalSmokeApp/Products/app/CalSmoke-cal.app.dSYM" "${APP_DSYM_ZIP}"
APP_DSYM_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.dSYM.zip"
azupload "${APP_DSYM_ZIP}" "${APP_DSYM_NAME}"

# Upload `CalSmoke-cal.ipa`
# APP="${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa"
# APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa"
# azupload "${APP}" "${APP_NAME}"

# Zip and upload `CalSmoke-cal.ipa.dSYM`
# APP="${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa.dSYM"
# ditto_or_exit "${APP}" "${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa.dSYM.zip"
# APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa.dSYM.zip"
# azupload "${APP}" "${APP_NAME}"

