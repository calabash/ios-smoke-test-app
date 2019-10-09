#!/usr/bin/env bash

set -eo pipefail
echo "Run az-publish.sh"
# $1 => SOURCE PATH
# $2 => TARGET NAME
function azupload {
  # az storage blob upload \
  #   --container-name ios-device-agent \
  #   --file "${1}" \
  #   --name "${2}"
  echo "${1} artifact uploaded with name ${2}"
}

function ditto_or_exit {
  xcrun ditto "${1}" "${2}"
  if [ "$?" != 0 ]; then
    echo "Could not copy:"
    echo "  source: ${1}"
    echo "  target: ${2}"
    if [ ! -e "${1}" ]; then
      echo "The source file does not exist"
      echo "Did a previous xcodebuild step fail?"
    fi
    echo "Exiting 1"
    exit 1
  fi
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

# Evaluate git-sha value
GIT_SHA=$(git rev-parse --verify HEAD | tr -d '\n')
echo "Git sha: ${GIT_SHA}"

# Evaluate CalSmokeApp version (from Info.plist)
VERSION=$(plutil -p ./Products/app/CalSmoke-cal/CalSmoke-cal.app/Info.plist | grep CFBundleShortVersionString | grep -o '"[[:digit:].]*"' | sed 's/"//g')
echo "App version: ${VERSION}"

# Evaluate the Xcode version used to build artifacts
XC_VERSION=$(xcode_version)
echo "Xcode version: ${XC_VERSION}"

az --version

WORKING_DIR="${BUILD_SOURCESDIRECTORY}"
echo "Working dir: ${WORKING_DIR}"

# Upload `CalSmoke-cal.app`
APP="${WORKING_DIR}/Products/app/CalSmoke-cal/CalSmoke-cal.app"
APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app"
azupload "${APP}" "${APP_NAME}"

# Zip and upload `CalSmoke-cal.app.dSYM`
APP="${WORKING_DIR}/Products/app/CalSmoke-cal/CalSmoke-cal.app.dSYM"
ditto_or_exit "${APP}" "${WORKING_DIR}/Products/app/CalSmoke-cal/CalSmoke-cal.app.dSYM.zip"
APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.dSYM.zip"
azupload "${APP}" "${APP_NAME}"

# Upload `CalSmoke-cal.ipa`
# APP="${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa"
# APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa"
# azupload "${APP}" "${APP_NAME}"

# Zip and upload `CalSmoke-cal.ipa.dSYM`
# APP="${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa.dSYM"
# ditto_or_exit "${APP}" "${WORKING_DIR}/Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa.dSYM.zip"
# APP_NAME="CalSmoke-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa.dSYM.zip"
# azupload "${APP}" "${APP_NAME}"

