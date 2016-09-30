And(/^I see the pinching page$/) do
  query = "UITableViewCell marked:'pinching row'"

  options = wait_options(query)
  wait_for_element_exists(query, options)

  touch(query)

  wait_for_none_animating

  query = "view marked:'pinching page'"
  options = wait_options(query)
  wait_for_element_exists(query, options)
end

When(/^I pinch in on the box$/) do
  query = "UIView id:'box'"
  @pinch_box_width = query(query)[0]["rect"]["width"]
  pinch("in", query: query)
end

Then(/^the box shrinks$/) do
  query = "UIView id:'box'"
  new_width = query(query)[0]["rect"]["width"]
  fail "Box did not shrink" unless new_width < @pinch_box_width
  @pinch_box_width = new_width
end

When(/^I pinch out on the box$/) do
  query = "UIView id:'box'"
  pinch("out", query: query)
end

Then(/^the box grows$/) do
  query = "UIView id:'box'"
  new_width = query(query)[0]["rect"]["width"]
  fail "Box did not grow" unless new_width > @pinch_box_width
  @pinch_box_width = new_width
end


