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

When(/^I double tap the box$/) do
  query = "view marked:'gestures box'"
  wait_for_element_exists query
  double_tap(query)
end

When(/^I long press the box for (\d+) seconds?$/) do |duration|
  query = "view marked:'gestures box'"
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
