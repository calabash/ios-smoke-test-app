
Then(/^I wait for all animations to stop$/) do
  timeout = 4
  message = "Waited #{timeout} seconds for all animations to stop"
  options = {timeout: timeout, timeout_message: message}

  # Test for:  https://github.com/calabash/calabash-ios-server/pull/142
  # When checking for no animation, ignore animations with trivially short durations
  wait_for_none_animating(options)
end

And(/^I have started an animation that lasts (\d+) seconds$/) do |duration|
  @last_animation_duration = duration.to_i
  timeout = 4
  query = "view marked:'animated view'"
  message = "Timed out waiting for #{query} after #{timeout} seconds"

  wait_for({timeout: 4, timeout_message: message}) { !query(query).empty? }

  backdoor('animateOrangeViewOnDragAndDropController:', duration)
end

Then(/^I can wait for the animation to stop$/) do
  timeout = @last_animation_duration + 1
  message = "Waited #{timeout} seconds for the animation to stop"
  options = {timeout: timeout, timeout_message: message}

  wait_for_none_animating(options)
end
