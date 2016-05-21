
Then(/^I see localized text "([^"]*)"$/) do |text|
  query = "* marked:'localized label'"
  wait_for do
    !query(query).empty?
  end

  actual = query(query).first["text"]
  unless actual == text
    fail(%Q[Expected text to be localized, but found:

  actual: #{actual}
expected: #{text}
])
  end
end
