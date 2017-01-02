module CalSmoke
  module Alerts

    def alert_view_query_str
      if ios7?
        "view:'_UIModalItemAlertContentView'"
      else
        "view:'_UIAlertControllerView'"
      end
    end

    def alert_view_button_query_str
      if ios7?
        "view:'_UIModalItemAlertContentView' descendant UITableView descendant label"
      else
        "view:'_UIAlertControllerActionView'"
      end
    end

    def alert_visible?(alert_title=nil)
      if alert_title.nil?
        return !query(alert_view_query_str).empty?
      end

      query = "#{alert_view_query_str} descendant label"
      results = query(query)

      results.detect do |element|
        element["text"] == alert_title
      end
    end

    def alert_button_exists?(button_title)
      if !alert_visible?
        fail('Expected an alert to be showing')
      end

      !query("#{alert_view_button_query_str} marked:'#{button_title}'").empty?
    end

    def wait_for_alert
      timeout = 30
      message = "Waited #{timeout} seconds for an alert to appear"
      bridge_wait_for(message, timeout: timeout) do
        alert_visible?
      end
    end

    def wait_for_no_alert
      timeout = 30
      message = "Waited #{timeout} seconds for all alerts to disappear"
      bridge_wait_for(message, timeout: timeout) do
        !alert_visible?
      end
    end

    def wait_for_alert_with_title(alert_title)
      timeout = 30
      message = "Waited #{timeout} seconds for an alert with title '#{alert_title}' to appear"
      bridge_wait_for(message, timeout: timeout) do
        alert_visible?(alert_title)
      end
    end

    def tap_alert_button(button_title)
      wait_for_alert
      touch("#{alert_view_button_query_str} marked:'#{button_title}'")
    end

    def button_views
      wait_for_alert
      query(alert_view_button_query_str)
    end

    def button_titles
      button_views.map { |res| res['label'] }.compact
    end

    def leftmost_button_title
      with_min_x = button_views.min_by do |res|
        res['rect']['x']
      end
      with_min_x['label']
    end

    def rightmost_button_title
      with_max_x = button_views.max_by do |res|
        res['rect']['x']
      end
      with_max_x['label']
    end

    def all_labels
      wait_for_alert
      query = "#{alert_view_query_str} descendant label"
      query(query)
    end

    def non_button_views
      titles = button_titles
      labels = all_labels
      labels.select do |res|
        !titles.include?(res['label']) &&
              res['label'] != nil
      end
    end

    def alert_message
      with_max_y = non_button_views.max_by do |res|
        res['rect']['y']
      end

      with_max_y['label']
    end

    def alert_title
      with_min_y = non_button_views.min_by do |res|
        res['rect']['y']
      end
      with_min_y['label']
    end
  end
end

World(CalSmoke::Alerts)

When(/^I touch the show alert button$/) do
  wait_for_element_exists("view marked:'show alert'")
  touch("view marked:'show alert'")
end

Then(/^I see an alert$/) do
  wait_for_alert
end

Then(/^I see the "([^"]*)" alert$/) do |alert_title|
  wait_for_alert_with_title(alert_title)
end

And(/^I can dismiss the alert with the OK button$/) do
  wait_for_animations
  tap_alert_button('OK')
  wait_for_no_alert
end

And(/^the title of the alert is "([^"]*)"$/) do |title|
  expect(alert_title).to be == title
end

And(/^the message of the alert is "([^"]*)"$/) do |message|
  expect(alert_message).to be == message
end

And(/^the (left|right) hand button is "([^"]*)"$/) do |position, title|
  if position == 'left'
    actual_title = leftmost_button_title
  else
    actual_title = rightmost_button_title
  end
  expect(actual_title).to be == title
end
