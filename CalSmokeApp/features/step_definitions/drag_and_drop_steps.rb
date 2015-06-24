
Then(/^I expect to see the (red|blue|green) box$/) do |color|
  wait_for_elements_exist("view marked:'#{color}'")
  result = query("view marked:'#{color}'")
  expect(result.count).to be == 1
  view = result.first
  rect = view['rect']
  expect(rect['width']).to be == 88
  expect(rect['height']).to be == 88
end

Then(/^I expect to see a well on the (left|right)$/) do |side|
  query = "view marked:'#{side} well'"
  wait_for_elements_exist(query)
  result = query(query)
  expect(result.count).to be == 1
  view = result.first
  rect = view['rect']
  expect(rect['width']).to be == 132
  expect(rect['height']).to be == 132
end
