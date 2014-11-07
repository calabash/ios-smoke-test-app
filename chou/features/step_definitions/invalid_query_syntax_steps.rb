Given(/^I see the first view$/) do
  wait_for_elements_exist(["view marked:'first page'"])
end

And(/^I see the text field$/) do
  wait_for_elements_exist('textField')
end

When(/^I search for the text using a correctly formatted query$/) do
  @text_field_matches = query("textField marked:'text'").count
end

Then(/^I expect one text field result$/) do
  unless @text_field_matches == 1
    raise "expected only one matching result, but found '#{@text_field_matches}'"
  end
end

When(/^I search for the text using a query with a missing trailing quote, I expect an exception$/) do
  query_syntax_exception = nil
  begin
    # Note the missing trailing quote on `text`.
    query("textField marked:'text").count
  rescue Exception => e
    query_syntax_exception = e
  end

  unless query_syntax_exception
    raise "expected query string with missing ' to raise an exception"
  end
end
