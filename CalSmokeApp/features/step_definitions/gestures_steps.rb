
When(/^I double tap the box$/) do
  query = "view marked:'gestures box'"
  wait_for_element_exists query
  double_tap(query)
end

Then(/^the gesture descript changes to double tap$/) do
  query = "view marked:'last gesture'"
  text = nil
  wait_for do
    result = query(query)
    if result.empty?
      false
    else
      text = result.first['text']
      if text == 'Double tap'
        true
      else
        false
      end
    end
  end
end
