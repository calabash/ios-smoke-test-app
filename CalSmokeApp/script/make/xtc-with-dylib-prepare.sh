#!/usr/bin/env bash

XAMARIN_DIR="${PWD}/xtc-staging"

echo "INFO: creating the ./xtc-staging directory"
rm -rf "${XAMARIN_DIR}"
mkdir -p "${XAMARIN_DIR}"

echo "INFO: copying features over to ${XAMARIN_DIR}"
cp -r features "${XAMARIN_DIR}/"

echo "INFO: installing config/xtc-profiles.yml to ${XAMARIN_DIR}/cucumber.yml"
cp "./config/xtc-profiles.yml" "${XAMARIN_DIR}/cucumber.yml"

echo "INFO: making the .ipa"
make ipa-dylib

IPA="CalSmoke-Calabash-dylibs-embedded.ipa"
IPA_DSYM="CalSmoke-Calabash-dylibs-embedded.app.dSYM"

mv "${PWD}/${IPA_DSYM}}" "${XAMARIN_DIR}"
mv "${PWD}/${IPA}" "${XAMARIN_DIR}"
