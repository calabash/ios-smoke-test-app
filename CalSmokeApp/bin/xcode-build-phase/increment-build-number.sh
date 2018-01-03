#!/usr/bin/env bash

set -e

HEADER="${PROJECT_DIR}/${INFOPLIST_PREFIX_HEADER}"
PLIST="${PROJECT_DIR}/${INFOPLIST_FILE}"
touch "${PLIST}"

NEW_BUILD_NUMBER=$(date +%s | tr -d '\n')
NEW_BUILD_DATE=$(date | tr -d '\n')

cat > "${HEADER}" <<EOF
/*
DO NOT MANUALLY CHANGE THE CONTENTS OF THIS FILE

This file should not be added to version control.
*/

#define PRODUCT_BUILD_NUMBER ${NEW_BUILD_NUMBER}
#define PRODUCT_BUILD_DATE ${NEW_BUILD_DATE}
EOF
