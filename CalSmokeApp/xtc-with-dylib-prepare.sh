#!/usr/bin/env bash

XCPRETTY=`gem list xcpretty -i`

if [ "${XCPRETTY}" = "false" ]; then gem install xcpretty; fi

if which rbenv > /dev/null; then
    RBENV_EXEC="rbenv exec"
else
    RBENV_EXEC=
fi

#${RBENV_EXEC} bundle install

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

mv "${PWD}/chou.app.dSYM" "${XAMARIN_DIR}"
mv "${PWD}/chou.ipa" "${XAMARIN_DIR}"

exit 0
