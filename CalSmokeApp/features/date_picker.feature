@date_picker
Feature: Date Picker
In order quickly manipulate UIDatePickers
As a developer
I want a Date Picker API

Background: Navigate to the date picker tab
  Given I see the date picker tab

# Time can be anything parseable by Time.parse
Scenario: Setting the time
  Given I see the time picker
  Then I change the date picker time to "10:45"
  Then I change the date picker time to "12:45 AM"
  Then I change the date picker time to "19:35"
  Then I change the date picker time to "1:35"
  Then I change the date picker time to "6:45 PM"
  Then I change the date picker time to "6:45 AM"

# Date can be anything parseable by Date.parse
Scenario: Setting the date
  Given I see the date picker

  # Not automatically parseable by Date
  # Then I change the date picker date to "05/13/2000"
  # Then I change the date picker date to "05-13-2000"
  # Incorrectly parsed by Date
  # Then I change the date picker date to "05 13 2000"

  Then I change the date picker date to "July 28 2009"
  Then I change the date picker date to "Dec 31 3029"
  Then I change the date picker date to "1980-09-14"

  # Appears as Dec 31 2029
  Then I change the date picker date to "Dec 31 29"

  # Unexpected
  # NSDateFormatter parses this date to 'Fri Nov 2'
  Then I change the date picker date to "1492.11.11"

@wip
Scenario: Setting the date and time
  Given I see the date and time picker
  Then I change the date picker date to "July 28" at "15:23"
  Then I change the date picker date to "28 Aug" at "12:23 AM"
  Then I change the date picker date to "2013-03-14" at "12:23"

Scenario: Advancing the time by minutes
  Given I see the time picker
  Then I change the time on the picker to 20 minutes from now
  Then I change the time on the picker to 13 minutes before now

Scenario: Changing the minute interval
  Given I see the time picker


#Then /^I change the minute interval on the picker to (1|5|10|30) minutes?$/ do |target_interval|
# todo
