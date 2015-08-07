require 'chronic'

Given(/^I see the (time|date|date and time) picker$/) do |id|
  case id
  when 'time'
   picker = 'show time picker'
  when 'date'
   picker = 'show date picker'
  when 'date and time'
   picker = 'show date and time picker'
  end

  query = "view marked:'#{picker}'"
  options = wait_options(query)

  wait_for_element_exists(query, options)
  touch(query)
  wait_for_none_animating
end

Then(/^I change the date picker time to "([^"]*)"$/) do |time_str|
  target_time = Time.parse(time_str)
  current_date = date_time_from_picker
  current_date = DateTime.new(current_date.year,
                              current_date.mon,
                              current_date.day,
                              target_time.hour,
                              target_time.min,
                              0,
                              target_time.gmt_offset)
  picker_set_date_time current_date
  wait_for_none_animating

  new_time = Chronic.parse(date_time_from_picker.to_s)

  label_date_string = query("UILabel marked:'time'", :text).first
  label_time = Chronic.parse("today at #{label_date_string}")

  expect(new_time.to_s).to be == label_time.to_s
end

Then(/^I change the date picker date to "([^"]*)"$/) do |date_str|
  target_date = Date.parse(date_str)
  current_time = date_time_from_picker
  date_time = DateTime.new(target_date.year,
                           target_date.mon,
                           target_date.day,
                           current_time.hour,
                           current_time.min,
                           0,
                           Time.now.sec,
                           current_time.offset)
  picker_set_date_time date_time
  wait_for_none_animating

  new_date_str = date_time_from_picker.strftime("%a %b %e %Y")
  label_date_string = query("UILabel marked:'time'", :text).first

  actual = Chronic.parse(new_date_str).to_s
  expected = Chronic.parse(label_date_string).to_s
  expect(actual).to be == expected
end

Then(/^I change the date picker date to "([^"]*)" at "([^"]*)"$/) do |date_str, time_str|
  target_time = Time.parse(time_str)
  target_date = Date.parse(date_str)
  current_time = date_time_from_picker
  date_time = DateTime.new(target_date.year,
                           target_date.mon,
                           target_date.day,
                           target_time.hour,
                           target_time.min,
                           0,
                           Time.now.sec,
                           current_time.offset)

  picker_set_date_time date_time
  wait_for_none_animating

  new_date_str = date_time_from_picker.strftime("%a %b %e %Y %I:%M")
  label_date_string = query("UILabel marked:'time'", :text).first

  actual = Chronic.parse(new_date_str).to_s
  expected = Chronic.parse(label_date_string).to_s
  expect(actual).to be == expected
end
