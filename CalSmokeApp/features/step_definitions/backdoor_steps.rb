
And(/^I call backdoor with an unknown selector$/) do
  begin
    backdoor('unknownSelector:', '')
  rescue RuntimeError => e
    puts e
    @backdoor_raised_an_error = true
  end
end

Then(/^I should see a helpful error message$/) do
  expect(@backdoor_raised_an_error).to be == true
end
