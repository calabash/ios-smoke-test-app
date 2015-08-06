@server_log_level
Feature:  Server Log Level
In order to gain insights about the server runtime
As a Calabash maintainer and application tester
I want a way to control the log level of the server

Scenario: Asking for the log level
  Given the app has launched
  Then I can ask the server for its log level

Scenario: Setting the log level
  Given the app has launched
  And I set the server log level to debug
  Then the server log level should be debug

