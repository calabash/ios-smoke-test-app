
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
  query = "view marked:'collection views page'"
  options = wait_options('Collection views page')
  wait_for_elements_exist(query, options)
end

Then(/^I scroll the logos collection to the steam icon by mark$/) do
  query = "UICollectionView marked:'logo gallery'"
  options = wait_options('Logo gallery')
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :top,
    :animated => true
  }
  scroll_to_collection_view_item_with_mark('steam', options)
  wait_for_none_animating
end

Then(/^I scroll the logos collection to the github icon by index$/) do
  query = "UICollectionView marked:'logo gallery'"
  options = wait_options('Logo gallery')
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :center_vertical,
    :animated => false
  }
  scroll_to_collection_view_item(13, 0, options)
  wait_for_none_animating
end

Then(/^I scroll up on the logos collection to the android icon$/) do
  query = "UICollectionView marked:'logo gallery'"
  options = wait_options('Logo gallery')
  wait_for_element_exists(query, options)

  icon_query = "UICollectionViewCell marked:'android'"

  visible = lambda {
    query(icon_query).count == 1
  }

  count = 0
  loop do
    break if visible.call || count == 4;
    scroll(query, :up)
    wait_for_none_animating
    count = count + 1;
  end
  expect(query(icon_query).count).to be == 1
end

Then(/^I scroll the colors collection to the middle of the purple boxes$/) do
  query = "UICollectionView marked:'color gallery'"
  options = wait_options('Color gallery')
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :top,
    :animated => true
  }

  scroll_to_collection_view_item(12, 4, options)
  wait_for_none_animating
end

