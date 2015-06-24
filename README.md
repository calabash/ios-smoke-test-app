| master  |  [license](LICENSE) |
|---------|---------------------|
|[![Build Status](https://travis-ci.org/calabash/ios-smoke-test-app.svg?branch=master)](https://travis-ci.org/calabash/ios-smoke-test-app)| [![License](https://img.shields.io/badge/licence-MIT-blue.svg)](http://opensource.org/licenses/MIT) |

## CalSmoke App

Smoke testing for Calabash iOS and Calabash iOS Server.


### Test the -cal target

The -cal target links the calabash.framework.

```
$ git clone git@github.com:calabash/ios-smoke-test-app.git
$ cd ios-smoke-test-app/CalSmokeApp
$ bundle install
$ make app-cal
$ export APP="${PWD}/CalSmoke-cal.app"
$ be cucumber
```

### Test the Debug configuration of production app

The Debug configuration loads the calabash dylibs at runtime.

```
$ git clone git@github.com:calabash/ios-smoke-test-app.git
$ cd ios-smoke-test-app/CalSmokeApp
$ bundle install
$ make app
$ export APP="${PWD}/CalSmoke.app"
# Update the BUNDLE_ID in the config/cucumber.yml to sh.calaba.CalSmokeApp
$ be cucumber
```


