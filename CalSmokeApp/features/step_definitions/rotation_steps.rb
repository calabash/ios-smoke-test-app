
And(/^I try to rotate the home button so it is on the (left|right)$/) do |position|
  rotate_home_button_to position.to_sym
end

Then(/^the orientation should be portrait$/) do
  if ipad? && (ios11? || ios10? || ios9?)
    expect(landscape?).to be_truthy
  else
    expect(home_direction).to be == :down
  end
end

Then(/^the home button should be on the right$/) do
  expect(home_direction).to be == :right
end

