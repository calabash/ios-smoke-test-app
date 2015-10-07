#!/usr/bin/env bash

rm -f ../.git/tags

ctags -V -R -f ../.git/tags \
  --exclude=*.png \
  --exclude=.screenshots \
  --exclude=build \
  --exclude=reports \
  --exclude=*.app \
  --exclude=*.dSYM \
  --exclude=xtc-staging \
  --exclude=*.framework \
  --exclude=.irb-history \
  --exclude=*.xcodeproj \
  --exclude=*.xcworkspace \
  --exclude=.idea \
  --exclude=*.plist
