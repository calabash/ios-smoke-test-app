
When(/^I pan left-to-right on the screen$/) do
  points = Calabash::Cucumber::Automator::Coordinates.points_for_full_screen_pan(:right)

  points[:start][:x] = 0

  pan_coordinates(points[:start], points[:end], {duration: 0.5})
  wait_for_none_animating
end

Then(/^I go back to the Scrolls page$/) do
  query = "view marked:'scrolls page'"
  options = wait_options(query)
  wait_for_element_exists(query, options)
end
