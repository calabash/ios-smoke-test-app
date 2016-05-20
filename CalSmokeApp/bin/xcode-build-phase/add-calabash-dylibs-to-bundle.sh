#!/usr/bin/env bash

# If you see an error like this:
#
# iPhone Developer: ambiguous (matches "iPhone Developer: Person A (2<snip>Q)"
#                                  and "iPhone Developer: Person B (8<snip>F)"
# in /Users/<snip>/Library/Keychains/login.keychain)
#
# Uncomment this line and update it with the correct credentials.
# CODE_SIGN_IDENTITY="iPhone Developer: Person B (8<snip>F)"

set -e

if [ "${CONFIGURATION}" = "Debug" ]; then
  cp "${SRCROOT}/libCalabashDynFAT.dylib" "${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}/libCalabashDynFAT.dylib"
  if [ -n "${CODE_SIGN_IDENTITY}" ]; then
    xcrun codesign -fs "${CODE_SIGN_IDENTITY}" "${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}/libCalabashDynFAT.dylib"
  fi
fi

