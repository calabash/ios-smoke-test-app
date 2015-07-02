module CalSmoke
  module Alerts

    def alert_exists?(alert_id=nil)
      if alert_id.nil?
        res = uia('uia.alert() != null')
      else
        res = uia("uia.alert().name() == '#{alert_id}'")
      end

      if res['status'] == 'success'
        res['value']
      else
        false
      end
    end

  end
end

World(CalSmoke::Alerts)

When(/^I touch the show alert button$/) do
  wait_for_element_exists("view marked:'show alert'")
  touch("view marked:'show alert'")
end

Then(/^I see an alert$/) do
  timeout = 4
  message = "Waited #{timeout} seconds for an alert to appear"
  options = {timeout: timeout, timeout_message: message}

  wait_for(options) do
    alert_exists?
  end
end

Then(/^I should the "([^"]*)" alert$/) do |alert_id|
  timeout = 4
  message = "Waited #{timeout} seconds for an alert to appear"
  options = {timeout: timeout, timeout_message: message}

  wait_for(options) do
    alert_exists?(alert_id)
  end
end

And(/^I can dismiss the alert with the OK button$/) do
 pending
end


