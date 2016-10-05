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

And(/^I see the map page$/) do
  query = "* marked:'map views row'"
  wait_for_view(query)
  wait_for_animations
  touch(query)

  query = "* marked:'map'"
  wait_for_view(query)

  # Cannot wait for animations because the beacon is animating
  sleep(0.5)
end

Then(/^I zoom in on the map by pinching out$/) do
  pinch(:out)
  # TODO Figure out how to test this
  sleep(1.0)
end

Then(/^I zoom out on the map by pinching in$/) do
  pinch(:in)
  # TODO Figure out how to test this
  sleep(1.0)
end
