# frozen_string_literal: true

answer = 0
dimensions = File.readlines(ARGV[0], chomp: true)
dimensions.each do |d|
  l, w, h = d.split('x').map(&:to_i).sort
  answer += ((2 * l) + (2 * w)) + (l * w * h)
end

puts "Order #{answer} square meters of paper"
