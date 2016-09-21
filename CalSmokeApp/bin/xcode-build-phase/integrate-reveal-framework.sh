#!/usr/bin/env bash

export REVEAL_SERVER_FILENAME="RevealServer.framework"

# Update this path to point to the location of RevealServer.framework in your project.
export REVEAL_SERVER_PATH="${SRCROOT}/${REVEAL_SERVER_FILENAME}"

# If configuration is not Debug, skip this script.
[ "${CONFIGURATION}" != "Debug" ] && exit 0

# If RevealServer.framework exists at the specified path, run code signing script.
if [ -d "${REVEAL_SERVER_PATH}" ]; then
	"${REVEAL_SERVER_PATH}/Scripts/copy_and_codesign_revealserver.sh"
else
	echo "Cannot find RevealServer.framework, so Reveal Server will not be started for your app."
fi
