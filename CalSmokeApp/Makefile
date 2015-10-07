all:
	$(MAKE) ipa
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf Products

  # Legacy
	rm -rf CalSmoke*.ipa
	rm -rf CalSmoke*.app.dSYM
	rm -rf CalSmoke*.app

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

# Builds an ipa from the -cal target.
ipa-cal:
	bin/make/xtc-prepare.sh


# Builds an app that loads the Calabash dylib at runtime.
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)"
app-dylib:
	rm -rf build
	rm -rf CalSmoke-Calabash-dylibs-embeded.app
	bin/make/make-app.sh Debug

# Builds an app from the -cal target.
app-cal:
	rm -rf CalSmoke-cal.app
	bin/make/make-app-cal.sh

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
	bundle exec cucumber -t @wip
