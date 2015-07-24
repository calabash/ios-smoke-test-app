Given(/^I see the (first|second|third|tapping) tab$/) do |tab|
  wait_for_elements_exist('tabBarButton')
  case tab
    when 'first'
      index = 0
    when 'second'
      index = 1
    when 'third'
      index = 2
    when 'tapping'
      index = 3
  end
  touch("tabBarButton index:#{index}")
  expected_view = "#{tab} page"
  wait_for_elements_exist("view marked:'#{expected_view}'")
end

Then(/^I type "([^"]*)"$/) do |text_to_type|
  wait_for_elements_exist('textField', {:post_timeout => STEP_PAUSE})
  sleep 1.0 if uia_not_available?
  touch 'textField'
  sleep STEP_PAUSE if uia_not_available?
  wait_for_keyboard
  keyboard_enter_text text_to_type
end

When(/^I search for cell "([^"]*)" scrolling (up|down|left|right)$/) do |mark, direction|
  wait_poll({:until_exists => "collectionViewCell marked:'#{mark}'",
             :timeout => 10}) do
    scroll('collectionView', "#{direction}")
  end
end

When(/^I scroll (up|down|left|right) for (\d+) times$/) do |direction, times|
  wait_for_elements_exist('collectionView')
  (1..times.to_i).each do
    scroll('collectionView', "#{direction}")
    sleep STEP_PAUSE
  end
end

Then(/^I should see cell (\d+)$/) do |arg1|
  wait_for { !query("view marked:'cell #{arg1.to_i}'").empty? }
end

Given(/^I see the cell (\d+)$/) do |arg1|
  wait_for { !query("view marked:'cell #{arg1.to_i}'").empty? }
end

Given(/^the app has launched$/) do
  wait_for_elements_exist('tabBarButton')
end
