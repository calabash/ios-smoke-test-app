all:
	$(MAKE) ipa
	$(MAKE) ipa-calabash-embedded
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-calabash-embedded
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf Products
	rm -rf xtc-submit-*

  # Legacy
	rm -rf CalSmoke*.ipa
	rm -rf CalSmoke*.app.dSYM
	rm -rf CalSmoke*.app
	rm -rf xtc-staging

# Builds an ipa with no Calabash server.
#
# This ipa is suitable for testing dylib injection on physical
# devices.
#
# Dylib injection is not supported for ipas yet and is not
# supported on the Xamarin Test Cloud.
ipa:
	bin/make/ipa.sh Release

# Builds an ipa that loads an embedded Calabash dylib at runtime.
#
# This behaves exactly like the -cal target which links the
# calabash.framework during the link build phase.
#
# This kind of build is suitable for the Xamarin Test Cloud.
#
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)"
#
# See the README.md for more details about code signing.
ipa-calabash-embedded:
	bin/make/ipa.sh Debug

# Builds an app with no Calabash server.
#
# This app is suitable for testing dylib injection on iOS Simulators.
app:
	bin/make/app.sh Release

# Builds an app that loads an embedded Calabash dylib at runtime.
#
# This behaves exactly like the -cal target which links the
# calabash.framework during the link build phase.
#
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)"
#
# See the README.md for more details about code signing.
app-calabash-embedded:
	bin/make/app.sh Debug

# Builds an ipa from the CalSmoke-cal target.
#
# This ipa links the calabash.framework at during the build.
#
# This kind of build is suitable for the Xamarin Test Cloud.
ipa-cal:
	bin/make/ipa-cal.sh

# Builds an app from the CalSmoke-cal target.
#
# This app links the calabash.framework during the build.
app-cal:
	bin/make/app-cal.sh

# The following make rules are for project maintainers.
# At any given time, they may or may not work.

# For project maintainers only.
install_test_binaries:
	$(MAKE) clean
	$(MAKE) all
	bin/make/install-test-binaries.rb

tags:
	bin/make/vim-ctags.sh

new:
	mkdir -p calabash.framework
	bundle exec briar install calabash-server
	$(MAKE) app-cal
	bundle exec calabash-ios console
