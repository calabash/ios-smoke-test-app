Then(/^I can ask the server for its log level$/) do
  expect(server_log_level).to be == 'info'
end


And(/^I set the server log level to debug$/) do
  expect(set_server_log_level('debug')).to be == 'debug'
end

Then(/^the server log level should be debug$/) do
  expect(server_log_level).to be == 'debug'
end
