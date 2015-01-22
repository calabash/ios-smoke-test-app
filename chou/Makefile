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

ipa:
	rm -rf chou.ipa
	./build-ipa.sh

ipa-cal:
	./xtc-prepare.sh
	cp xtc-staging/chou-cal.ipa ./
	cp -r xtc-staging/chou-cal.app.dSYM ./

app:
	rm -rf chou.app
	./build-sim.sh

app-cal:
	rm -rf chou-cal.app
	./build-sim-cal.sh

install_test_binaries:
	$(MAKE) all
	./install-test-binaries.rb

