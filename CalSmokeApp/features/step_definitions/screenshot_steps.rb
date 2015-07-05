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
    #
    # On the Xamarin Test Cloud, we should not rely on SCREENSHOT_PATH
    # to be defined or to be set to directory we can write to.
    def screenshots_subdirectory
      if RunLoop::Environment.xtc?
        screenshot_dir = './screenshots'
      else
        screenshot_dir = ENV['SCREENSHOT_PATH']
      end

      unless File.exist?(screenshot_dir)
        FileUtils.mkdir_p(screenshot_dir)
      end

      path = File.join(screenshot_dir, 'scenario-screenshots')

      # Compensate for a bad behavior in Calabash.
      # :prefix needs to have a trailing /
      "#{path}/"
    end

    # By default, Calabash appends a number to the end of the screenshot
    # name.  There is no way to override this behavior.
    def un_numbered_screenshot(name, dir)
      res = http({:method => :get, :path => 'screenshot'})
      if File.extname(name).downcase == '.png'
        path = File.join(dir, name)
      else
        path = File.join(dir, "#{name}.png")
      end

      File.open(path, 'wb') do |f|
        f.write res
      end
      path
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
  begin
    count = Calabash::Cucumber::FailureHelpers.class_variable_get(:@@screenshot_count) - 1
  rescue NameError => _
    raise "Class variable @@screenshot_count is undefined.\nHas a screenshot been taken yet?"
  end
  path = File.join(dir, "my-screenshot_#{count}.png")
  expect(File.exists?(path)).to be == true
end

When(/^I take a screenshot with my un\-numbered screenshot method$/) do
  dir = screenshots_subdirectory
  un_numbered_screenshot('my-screenshot', dir)
end

Then(/^the screenshot will not have a number appended to the name$/) do
  dir = screenshots_subdirectory
  path = File.join(dir, 'my-screenshot.png')
  expect(File.exists?(path)).to be == true
end
