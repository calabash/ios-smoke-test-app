
When(/^I double tap the box$/) do
  query = "view marked:'gestures box'"
  wait_for_element_exists query
end
