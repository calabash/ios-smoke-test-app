#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

set -e

CALABASH_BASE_DIR="$(greadlink -f ../../calabash-ios/calabash-cucumber)"

if [ ! -d "${CALABASH_BASE_DIR}" ]; then
  error "Expected the calabash-ios gem directory to be here:"
  error "  ${CALABASH_BASE_DIR}"
  exit 1
fi

RUNLOOP_INSTALL_DIR="$(greadlink -f ../../run_loop/spec/resources)"

if [ ! -d "${RUNLOOP_INSTALL_DIR}" ]; then
  error "Expected the run_loop/spec/resources to be installed here:"
  error "  ${RUNLOOP_INSTALL_DIR}"
  exit 1
fi

make app
make app-cal
make ipa
make ipa-cal

function install_product {
  if [ -e "${2}" ]; then
    rm -rf "${2}"
  else
    error "Tried to delete the wrong item"
    error "  ${2}"
    exit 1
  fi
  install_with_ditto "${1}" "${2}"
}

banner "Installing to Calabash iOS gem"

RSPEC="${CALABASH_BASE_DIR}/spec/resources"

install_product \
  "Products/app/CalSmoke-cal/CalSmoke-cal.app" \
  "${RSPEC}/CalSmoke-cal.app"

install_product \
  "Products/app/CalSmoke/no-calabash/CalSmoke.app" \
  "${RSPEC}/CalSmoke.app"

CUCUMBER="${CALABASH_BASE_DIR}/test/xtc"

install_product \
  "Products/ipa/CalSmoke-cal/CalSmoke-cal.ipa" \
  "${CUCUMBER}/CalSmoke-cal.ipa"

install_product \
  "Products/ipa/CalSmoke-cal/CalSmoke-cal.app.dSYM" \
  "${CUCUMBER}/CalSmoke-cal.app.dSYM"
