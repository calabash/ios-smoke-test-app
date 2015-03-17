all:
	$(MAKE) ipa
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf chou.ipa
	rm -rf chou.app.dSYM
	rm -rf chou.app
	rm -rf chou-cal.app
	rm -rf chou-cal.app.dSYM

# Builds an ipa with no Calabash server.
ipa:
	rm -rf chou.ipa
	./build-ipa.sh Release

# Builds an ipa that loads the Calabash dylib at runtime.
ipa-dylib:
	rm -rf chou.ipa
	./build-ipa.sh Debug

# Builds an ipa from the -cal target.
ipa-cal:
	./xtc-prepare.sh
	cp xtc-staging/chou-cal.ipa ./
	cp -r xtc-staging/chou-cal.app.dSYM ./

# Builds an app with no Calabash server.
app:
	rm -rf chou.app
	./build-sim.sh Release

# Builds an app that loads the Calabash dylib at runtime.
app-dylib:
	rm -rf chou.app
	./build-sim.sh Debug

# Builds an app from the -cal target.
app-cal:
	rm -rf chou-cal.app
	./build-sim-cal.sh

# For project maintainers only.
install_test_binaries:
	$(MAKE) all
	./install-test-binaries.rb

