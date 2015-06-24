module CalSmokeApp
  module Screenshots
    require 'fileutils'

    # SCREENSHOT_PATH for this project is set in the config/cucumber.yml
    #
    # The value is ./screenshots
    #
    # If the ./screenshots directory does not exist, the erb in the
    # config/cucumber.yml will create it.
    #
    # If the SCREENSHOT_PATH is undefined, screenshots will appear
    # in the ./ directory.
    #
    # http://calabashapi.xamarin.com/ios/file.ENVIRONMENT_VARIABLES.html#label-SCREENSHOT_PATH

    def screenshots_subdirectory
      path = File.join(ENV['SCREENSHOT_PATH'], 'scenario-screenshots')

      # Bad behavior - :prefix needs to have a trailing /
      "#{path}/"
    end
  end
end

World(CalSmokeApp::Screenshots)

And(/^I have cleared existing screenshots for this feature$/) do
  path = screenshots_subdirectory
  if File.exist?(path)
    FileUtils.rm_rf(path)
  end
end

And(/^the scenario\-screenshots subdirectory exists$/) do
  path = screenshots_subdirectory
  unless File.exist?(path)
    FileUtils.mkdir_p(path)
  end
end

When(/^I take a screenshot with the default screenshot method$/) do
  path = screenshots_subdirectory
  screenshot({:prefix => path, :name => 'my-screenshot'})
end

Then(/^the screenshot will have a number appended to the name$/) do
  dir = screenshots_subdirectory
  path = File.join(dir, 'my-screenshot_0.png')
  expect(File.exists?(path)).to be == true
end
