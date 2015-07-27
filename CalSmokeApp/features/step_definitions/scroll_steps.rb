
Then(/^I see the scrolling views table$/) do
  query = "UITableView marked:'table'"
  options = wait_options('Scrolling views table')
  wait_for_element_exists(query, options)
end

When(/^I touch the (collection|table) views row$/) do |row_name|
  query = "UITableViewCell marked:'#{row_name} views row'"

  options = wait_options(query)
  wait_for_elements_exist(query, options)

  touch(query)
  wait_for_none_animating
end

Then(/^I see the (collection|table) views page$/) do |page_name|
  query = "view marked:'#{page_name} views page'"
  options = wait_options(query)
  wait_for_elements_exist(query, options)
end

Then(/^I scroll the logos collection to the steam icon by mark$/) do
  query = "UICollectionView marked:'logo gallery'"
  options = wait_options(query)
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
  options = wait_options(query)
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
  options = wait_options(query)
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
  options = wait_options(query)
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :top,
    :animated => true
  }

  scroll_to_collection_view_item(12, 4, options)
  wait_for_none_animating
end

Then(/^I scroll the logos table to the steam row by mark$/) do
  query = "UITableView marked:'logos'"
  options = wait_options(query)
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :middle,
    :animate => true
  }
  scroll_to_row_with_mark('steam', options)
  wait_for_none_animating
end

Then(/^I scroll the logos table to the github row by index$/) do
  query = "UITableView marked:'logos'"
  options = wait_options(query)
  wait_for_element_exists(query, options)

  options = {
    :query => query,
    :scroll_position => :middle,
    :animate => true
  }
  scroll_to_row(query, 13)
  wait_for_none_animating
end

Then(/^I scroll up on the logos table to the android row$/) do
  query = "UITableView marked:'logos'"
  options = wait_options(query)
  wait_for_element_exists(query, options)

  row_query = "UITableViewCell marked:'android'"

  visible = lambda {
    query(row_query).count == 1
  }

  count = 0
  loop do
    break if visible.call || count == 4;
    scroll(query, :up)
    wait_for_none_animating
    count = count + 1;
  end
  expect(query(row_query).count).to be == 1

end
