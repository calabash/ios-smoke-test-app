| master  |  [license](LICENSE) |
|---------|---------------------|
|[![Build Status](https://travis-ci.org/calabash/ios-smoke-test-app.svg?branch=master)](https://travis-ci.org/calabash/ios-smoke-test-app)| [![License](https://img.shields.io/badge/licence-MIT-blue.svg)](http://opensource.org/licenses/MIT) |

## CalSmoke Test App

Smoke testing for Calabash iOS and Calabash iOS Server.

This repo is very large because the Calabash binaries are updated often
during testing and debuging.  There is really no way around this.  You
can improve your experience by making a shallow clone using the
`--depth` flag.  Maintainers may need to make a much deeper clone.

```
$ git clone --depth 10 git@github.com:calabash/ios-smoke-test-app.git
$ cd ios-smoke-test-app/CalSmokeApp
```

We use this app to document, demonstrate, and test Calabash iOS.

You can use this app to explore Calabash and as an example for how to
configure your Xcode project and Calabash workflow.

If you have problems building or running, please see the **xcpretty**
and **Code Signing** sections below for how debug.

### Getting Started

```
$ git clone --depth 10 git@github.com:calabash/ios-smoke-test-app.git
$ cd ios-smoke-test-app/CalSmokeApp
$ bundle
$ make app-cal
```

Run your first cucumber test:

```
# A test that is run in Travis CI
$ bundle exec cucumber --tags @travis
```

Explore your app on from calabash console:

```
$ bundle exec calabash-ios console
> start_test_server_in_background
> query("UITextField")
> touch("UITextField")
> keyboard_enter_text("Hello!")
```

### xcpretty

https://github.com/supermarin/xcpretty

We use xcpretty to make builds faster and to reduce the amount of
logging.  Travis CI, for example, has a limit on the number of lines of
logging that can be generated; xcodebuild breaks this limit.

The only problem with xcpretty is that it does not report build errors
very well.  If you encounter an issue with any of the make rules, run
without xcpretty:

```
$ XCPRETTY=0 make ipa
```

### Code Signing

If you have multiple code signing identities, you might need to set the
`CODE_SIGN_IDENTITY` variable for the make scripts.  If you are running
with xcpretty, you might see output like this:

```
$ make ipa
** INSTALL FAILED **

The following build commands failed:
        PhaseScriptExecution Run\ Script\ Add\ Calabash\ dylibs\ to\ Bundle
<snip>/Debug-iphoneos/CalSmoke.build/Script-F51F2E8E1AB359A6002326D0.sh
```

Try again without xpretty to reveal the problem:

```
$ XCPRETTY=0 make ipa
iPhone Developer: ambiguous (matches "iPhone Developer: Some Developer
(89543FK9SZ)" and "iPhone Developer: Some Other Developer (7QJQJFT49Q)" in
/Users/moody/Library/Keychains/login.keychain)
Command /bin/sh failed with exit code 1

** INSTALL FAILED **
```

Fix this problem by telling Xcode which identity to use:

```
$ export CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (7QJQJFT49Q)"
$ make ipa
```

If you are building from Xcode and have code signing problems, you'll
need to update the `bin/xcode-build-phase/add-calabash-dylibs-to-bundle.sh`
with your identity details.

## Information for Maintainers (or the Curious)

### Make the -cal target

The -cal target links the calabash.framework.

This is the traditional way of getting the Calabash iOS Server into your
app.  It uses a separate application target as the test target; the -cal
target.  A separate -cal target means your production target will never
be linked with the calabash.framework.  This may be important to some
developers or organizations.

This approach is suitable for the Xamarin Test Cloud.

```
$ bundle install
$ make app-cal
$ export APP="Products/app/CalSmoke-cal/CalSmoke-cal.app"
$ bundle exec cucumber
```

To make an ipa from the -cal target:

```
$ make ipa-cal
```

### Embed dylibs in the CalSmoke Target

This method is provided to demonstrate an alternative Calabash setup.

The Debug configuration of the CalSmoke target (production) embeds the
Calabash dylibs in the app bundle.  These dylibs are loaded at runtime.
This only happens when the Xcode Build Configuration is Debug.

The script that does the embedding is here:

```
bin/xcode-build-phase/add-calabash-dylibs-to-bundle.sh
```

and depending on your environment, it may need to be update for codesigning.

This is _not_ dylib injection; the dylibs are embedded.  See Makefile for
rules to build an app suitable for testing dylib injection.

This approach is suitable for the Xamarin Test Cloud.

```
$ bundle install
$ make app-calabash-embedded
$ export APP="build/app/CalSmoke/embedded-calabash-dylib/CalSmokeApp.app"
$ bundle exec cucumber
```

To make an ipa with dylibs embedded in the production target:

```
$ make ipa-calabash-embedded

# Update the config/cucumber.yml
bundle_id:    BUNDLE_ID=sh.calaba.CalSmoke
```
