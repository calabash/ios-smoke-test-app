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

  count = 0
  expected_view = "* marked:'#{tab} page'"

  # Touch is not always registering.
  # https://github.com/calabash/calabash-ios/issues/304
  begin
    touch("UITabBarButton index:#{index}")
    wait_for_view(expected_view, {:timeout => 4})
  rescue => e
    if count == 3
      fail(e.message)
    else
      count = count + 1
      retry
    end
  end
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
