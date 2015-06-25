module CalSmokeApp
  module DragAndDrop

    class Color
      attr_reader :red, :blue, :green

      def initialize(red, blue, green)
        @red = red,
        @blue = blue,
        @green = green
      end

      def to_s
        "#<Color #{red}, #{blue}, #{green}>"
      end

      def inspect
        to_s
      end

      def self.color_with_hash(hash)
        Color.new((hash['red'] * 256).to_i,
                  (hash['blue'] * 256).to_i,
                  (hash['green'] * 256).to_i)
      end

      def == (other)
        [red == other.red,
         blue == other.blue,
         green == other.green].all?
      end

      def self.red
        Color.new(153, 39, 39)
      end

      def self.blue
        Color.new(29, 90, 171)
      end

      def self.green
        Color.new(33, 128, 65)
      end
    end

    def frame_equal(a, b)
      [a['x'] == b['x'],
       a['y'] == b['y'],
       a['height'] == b['height'],
       a['width'] == b['width']].all?
    end
  end
end

World(CalSmokeApp::DragAndDrop)

Then(/^I expect to see the (red|blue|green) box$/) do |color|
  query = "view marked:'#{color}'"
  wait_for_elements_exist(query)
  result = query(query)
  expect(result.count).to be == 1
  view = result.first
  rect = view['rect']
  expect(rect['width']).to be == 88
  expect(rect['height']).to be == 88
  case color
    when 'red'
      tag = 3030
    when 'blue'
      tag = 3031
    when 'green'
      tag = 3032
  end

  expect(query(query, :tag).first).to be == tag
end

Then(/^I expect to see a well on the (left|right)$/) do |side|
  query = "view marked:'#{side} well'"
  wait_for_elements_exist(query)
  result = query(query)
  expect(result.count).to be == 1
  view = result.first
  rect = view['rect']
  expect(rect['width']).to be == 132
  expect(rect['height']).to be == 132
end

When(/^I drag the red box to the left well$/) do
  from_query = "UIImageView marked:'red'"
  to_query = "UIView marked:'left well'"

  wait_for_elements_exist([from_query, to_query])

  @red_box_frame = query(from_query).first['frame']

  pan(from_query, to_query, {duration: 1.0})
end

Then(/^the left well should change to red$/) do
  query = "UIView marked:'left well'"
  result = query(query, :backgroundColor)
  actual = CalSmokeApp::DragAndDrop::Color.color_with_hash(result.first)
  expected = CalSmokeApp::DragAndDrop::Color.red
  expect(actual).to be == expected
end

Then(/^I expect the red box to return to its original position$/) do
  timeout = 4
  message = "Waited #{timeout} seconds for red box to return to original position."
  options = {timeout: timeout, timeout_message: message}
  query = "UIImageView marked:'red'"
  wait_for(options) do
    result = query(query)
    if result.empty?
      false
    else
      actual = result.first['frame']
      frame_equal(actual, @red_box_frame)
    end
  end
end
