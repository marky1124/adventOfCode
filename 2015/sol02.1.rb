# frozen_string_literal: true

answer = 0
dimensions = File.readlines(ARGV[0], chomp: true)
dimensions.each do |d|
  l, w, h = d.split('x').map(&:to_i)
  lw = l * w
  wh = w * h
  hl = h * l
  min = [lw, wh, hl].min
  answer += ((2 * lw) + (2 * wh) + (2 * hl) + min)
end

puts "Order #{answer} square meters of paper"
