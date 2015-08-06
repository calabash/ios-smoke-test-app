module CalSmokeApp
  module WaitForGesture

    def wait_for_gesture(expected_text)
      query = "label marked:'last gesture'"

      wait_for do
        result = query(query)

        if !result.empty? && result.first['text'] == expected_text
          true
        else
          false
        end
      end
    end
  end
end

World(CalSmokeApp::WaitForGesture)

And(/^I see the tapping page$/) do
  query = "UITableViewCell marked:'tapping row'"

  options = wait_options(query)
  wait_for_element_exists(query, options)

  touch(query)

  wait_for_none_animating

  query = "view marked:'tapping page'"
  options = wait_options(query)
  wait_for_element_exists(query, options)
end

When(/^I double tap the left box$/) do
  query = "view marked:'left box'"
  wait_for_element_exists query
  double_tap(query)
end

When(/^I long press the (left|right) box for (\d+) seconds?$/) do |which, duration|
  query = "view marked:'#{which} box'"
  wait_for_element_exists query
  touch_hold(query, {:duration => duration.to_i})
  @last_long_press_duration = duration.to_i
end

Then(/^the gesture description changes to (double tap|long press)$/) do |type|
  if type == 'double tap'
    expected = 'Double tap'
  else
    expected = "Long press: #{@last_long_press_duration} seconds"
  end

  wait_for_gesture(expected)
end
