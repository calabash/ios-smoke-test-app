
When(/^I pan left on the screen$/) do
  top_view = query('*').first
  rect = top_view['rect']

  from_x = 0
  from_y = rect['height'] * 0.5
  from_offset = {x: from_x, y: from_y}

  to_x = rect['width'] * 0.75
  to_y = from_y
  to_offset = {x: to_x, y: to_y}

  uia_pan_offset(from_offset, to_offset, {duration: 0.5})
  wait_for_none_animating
end

Then(/^I go back to the Scrolls page$/) do
  query = "view marked:'scrolls page'"
  options = wait_options(query)
  wait_for_element_exists(query, options)
end
