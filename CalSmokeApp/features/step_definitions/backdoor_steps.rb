
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

And(/^I call backdoor on a method whose return type is void$/) do

end

And(/^I call backdoor on a method with no argument$/) do

end

And(/^I call backdoor on a method that doesn't return an NSString$/) do

end

And(/^I call backdoor on a method that takes an NSString as an argument$/) do

end

And(/^I should get back that string$/) do

end

And(/^I should get back that dictionary$/) do

end

And(/^I call backdoor on a method that takes an NSDictionary as an argument$/) do

end
