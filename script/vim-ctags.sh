#!/usr/bin/env bash

ctags -R -f ./.git/tags \
  --exclude=*.png \
  --exclude=CalSmokeApp/build \
  --exclude=CalSmokeApp/reports \
  --exclude=CalSmokeApp/*.app \
  --exclude=CalSmokeApp/xtc-staging \
  --exclude=*.h \
  --exclude=*.plist
