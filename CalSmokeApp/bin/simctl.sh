#!/usr/bin/env bash

set +e

# Force Xcode 8 CoreSimulator env to be loaded so xcodebuild does not fail.

function ensure_valid_core_sim_service {
	for try in {1..4}; do
		xcrun simctl help &>/dev/null
		sleep 1.0
	done
}
