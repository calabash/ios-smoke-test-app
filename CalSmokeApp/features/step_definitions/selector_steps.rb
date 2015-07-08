module CalSmoke
  module Selectors

    def call_selector(hash_or_symbol)
      query("view marked:'first page'", hash_or_symbol)
    end

    def expect_selector_truthy(hash_or_symbol)
      res = call_selector(hash_or_symbol)
      expect(res.empty?).to be_falsey
      expect(res.first).to be == 1
    end
  end
end

World(CalSmoke::Selectors)

When(/^I call an unknown selector on a view$/) do
  result = query("view marked:'first page'", :unknownSelector)
  if result.empty?
    raise "Expected a query match for \"view marked:'first page'\""
  end
  @unknown_selector_result = result.first
end

Then(/^I expect to receive back "(.*?)"$/) do |expected|
  expect(@unknown_selector_result).to be == expected
end

Then(/^I call selector with pointer argument$/) do
  arg = [{takesPointer:'a string'}]
  expect_selector_truthy(arg)
end

Then(/^I call selector with (unsigned int|int) argument$/) do |signed|
  if signed == 'int'
    arg = [{takesInt:-1}];
  else
    arg = [{takesUnsignedInt:1}];
  end
  expect_selector_truthy(arg)
end

Then(/^I call selector with (unsigned short|short) argument$/) do |signed|
  if signed == 'short'
    arg = [{takesShort:-1}];
  else
    arg = [{takesUnsignedShort:1}];
  end
  expect_selector_truthy(arg)
end

Then(/^I call selector with (unsigned long|long) argument$/) do |signed|
  if signed == 'long'
    arg = [{takesLong:-1}];
  else
    arg = [{takesUnsignedLong:1}];
  end
  expect_selector_truthy(arg)
end

Then(/^I call selector with (unsigned long long|long long) argument$/) do |signed|
  if signed == 'long long'
    arg = [{takesLongLong:-1}];
  else
    arg = [{takesUnsignedLongLong:1}];
  end
  expect_selector_truthy(arg)
end

Then(/^I call selector with float argument$/) do
  arg = [{takesFloat:0.1}]
  expect_selector_truthy(arg)
end

Then(/^I call selector with (long double|double) argument$/) do |signed|
  if signed == 'double'
    arg = [{takesDouble:0.1}];
  else
    arg = [{takesLongDouble:Math::PI}];
  end
  expect_selector_truthy(arg)
end

Then(/^I call selector with (unsigned char|char) argument$/) do |signed|
  if signed == 'char'
    # Passed a string
    arg = [{takesChar:'a'}]
    expect_selector_truthy(arg)

    # Passed a number
    arg = [{takesChar:-22}]
    expect_selector_truthy(arg)
  else
    # Passed a string
    arg = [{takesUnsignedChar:'a'}]
    expect_selector_truthy(arg)

    # Passed a number
    arg = [{takesUnsignedChar:22}]
    expect_selector_truthy(arg)
  end
end

Then(/^I call selector with BOOL argument$/) do
  # true/false
  arg = [{takesBOOL:true}]
  expect_selector_truthy(arg)

  arg = [{takesBOOL:false}]
  expect_selector_truthy(arg)

  # YES/NO
  arg = [{takesBOOL:1}]
  expect_selector_truthy(arg)

  arg = [{takesBOOL:0}]
  expect_selector_truthy(arg)
end

Then(/I call selector with c string argument$/) do
  arg = [{takesCString:'a c string'}]
  expect_selector_truthy(arg)
end

Then(/I call selector with (point|rect) argument$/) do |type|
  if type == 'point'
    point = {x:5.0, y:10.2}
    arg = [{takesPoint:point}]
  else
    rect = {x:5, y:10, width:44, height:44}
    arg = [{takesRect:rect}]
  end
  expect_selector_truthy(arg)
end
