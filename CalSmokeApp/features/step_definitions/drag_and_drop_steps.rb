
Then(/^I expect to see the (red|blue|green) box$/) do |color|
  query = "view marked:'#{color}'"
  wait_for_elements_exist(query)
  result = query(query)
  expect(result.count).to be == 1
  view = result.first
  rect = view['rect']
  expect(rect['width']).to be == 88
  expect(rect['height']).to be == 88
  case color
    when 'red'
      tag = 3030
    when 'blue'
      tag = 3031
    when 'green'
      tag = 3032
  end

  expect(query(query, :tag).first).to be == tag
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
