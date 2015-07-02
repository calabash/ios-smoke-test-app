
Then(/^I wait for all animations to stop$/) do
  timeout = 4
  message = "Waited #{timeout} seconds for all animations to stop"
  options = {timeout: timeout, timeout_message: message}

  # Test for:  https://github.com/calabash/calabash-ios-server/pull/142
  # When checking for no animation, ignore animations with trivially short durations
  wait_for_none_animating(options)
end
