
Then(/^I see the scrolling views table$/) do
  query = "UITableView marked:'table'"
  options = wait_options('Scrolling views table')
  wait_for_element_exists(query, options)
end

And(/^I see rows for table, collection, scroll, web, and map views$/) do
  queries = ['table', 'collection', 'scroll', 'web', 'map'].map do |name|
    "UITableViewCell marked:'#{name} views row'"
  end
  options = wait_options('Scrolling views rows')
  wait_for_elements_exist(queries, options)
end

When(/^I rotate to landscape$/) do
  rotate_home_button_to 'right'
  wait_for_none_animating
end

When(/^I touch the collection views row$/) do
  query = "UITableViewCell marked:'collection views row'"
  options = wait_options('Collection views row')
  wait_for_elements_exist(query, options)

  touch(query)
  wait_for_none_animating
end

Then(/^I see the collection view page$/) do
  query = "view marked:'collection view page'"
  options = wait_options('Collection view page')
  wait_for_elements_exist(query, options)
end
