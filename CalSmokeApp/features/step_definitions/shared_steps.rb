Given(/^I see the (controls|gestures|scrolls|special|date picker) tab$/) do |tab|
  wait_for_element_exists("tabBarButton")
  case tab
  when 'controls'
    index = 0
  when 'gestures'
    index = 1
  when 'scrolls'
    index = 2
  when 'special'
    index = 3
  when 'date picker'
    index = 4
  end

  sleep(0.5)
  touch("UITabBarButton index:#{index}")
  wait_for_animations
  expected_view = "#{tab} page"
  wait_for_element_exists("view marked:'#{expected_view}'")
end

Then(/^I type "([^"]*)"$/) do |text_to_type|
  query = 'UITextField'
  options = wait_options(query)
  wait_for_element_exists(query, options)

  touch(query)
  wait_for_keyboard

  keyboard_enter_text text_to_type
end

When(/^I touch the back button$/) do
  query = "view marked:'Back'"
  options = wait_options('Navbar back button')
  wait_for_element_exists(query, options)

  touch(query)
  wait_for_none_animating
end

Given(/^the app has launched$/) do
  wait_for_elements_exist('tabBarButton')
end
