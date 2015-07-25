
Then(/^I see the scrolling views table$/) do
  query = "UITableView marked:'table'"
  wait_for_element_exists(query)
end

And(/^I see rows for table, collection, scroll, web, and map views$/) do
  queries = ['table', 'collection', 'scroll', 'web', 'map'].map do |name|
    "UITableViewCell marked:'#{name} views row'"
  end

  wait_for_elements_exist(queries)
end

When(/^I rotate to landscape$/) do
  rotate_home_button_to 'right'
end

When(/^I touch the collection views row$/) do
  query = "UITableViewCell marked:'collection views row'"
  wait_for_elements_exist(query)

  touch(query)
  wait_for_none_animating
end

Then(/^I see the collection view page$/) do
  query = "view marked:'collection view page'"
  wait_for_elements_exist(query)
end
