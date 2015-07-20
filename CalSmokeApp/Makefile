all:
	$(MAKE) ipa
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf CalSmoke*.ipa
	rm -rf CalSmoke*.app.dSYM
	rm -rf CalSmoke*.app

# Builds an ipa with no Calabash server.
ipa:
	rm -rf build
	rm -rf CalSmoke-no-Calabash-dylibs-embedded.ipa
	script/make/make-ipa.sh Release

# Builds an ipa that loads the Calabash dylib at runtime.
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)" make ipa-dylib
ipa-dylib:
	rm -rf build
	rm -rf CalSmoke-Calabash-dylibs-embedded.ipa
	script/make/make-ipa.sh Debug

# Builds an ipa from the -cal target.
ipa-cal:
	rm -rf build
	script/make/xtc-prepare.sh

# Builds an app with no Calabash server.
app:
	rm -rf build
	rm -rf CalSmoke-no-Calabash-dylibs-embedded.app
	script/make/make-app.sh Release

# Builds an app that loads the Calabash dylib at runtime.
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)" make app-dylib
app-dylib:
	rm -rf build
	rm -rf CalSmoke-Calabash-dylibs-embeded.app
	script/make/make-app.sh Debug

# Builds an app from the -cal target.
app-cal:
	rm -rf build
	rm -rf CalSmoke-cal.app
	script/make/make-app-cal.sh

# For project maintainers only.
install_test_binaries:
	$(MAKE) clean
	$(MAKE) all
	./script/make/install-test-binaries.rb

tags:
	script/make/vim-ctags.sh

new:
	mkdir -p calabash.framework
	bundle exec briar install calabash-server
	$(MAKE) app-cal
	bundle exec cucumber -t @wip
