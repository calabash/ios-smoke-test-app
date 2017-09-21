#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

if [ ! -x "$(command -v greadlink)" ]; then
  error "This script requires greadlink which can be installed with homebrew"
  error "$ brew update"
  error "$ brew install coreutils"
  exit 1
fi

INSTALL_DIR="$(greadlink -f ../../../xtc/test-cloud-test-apps/uitest-test-apps/iOS)"

if [ ! -d $INSTALL_DIR ]; then
  error "Expected the test-cloud-test-apps repo to be installed here:"
  error "  $INSTALL_DIR"
  exit 1
fi

make app-cal
make ipa-cal

banner "Installing to UITest Apps"

install_with_ditto \
  "Products/app/CalSmoke-cal/CalSmoke-sim.app.zip" \
  "${INSTALL_DIR}/CalSmoke-sim.app.zip"

install_with_ditto \
  "Products/app/CalSmoke-cal/CalSmoke-sim.app.dSYM" \
  "${INSTALL_DIR}/CalSmoke-sim.app.dSYM"

install_with_ditto \
  "Products/ipa/CalSmoke-cal/CalSmoke-device.app.dSYM" \
  "${INSTALL_DIR}/CalSmoke-device.app.dSYM"

install_with_ditto \
  "Products/ipa/CalSmoke-cal/CalSmoke-device.app.zip" \
  "${INSTALL_DIR}/CalSmoke-device.app.zip"

install_with_ditto \
  "Products/ipa/CalSmoke-cal/CalSmoke-device.ipa" \
  "${INSTALL_DIR}/CalSmoke-device.ipa"
