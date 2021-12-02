# frozen_string_literal: true

map = Hash.new(0)
x = y = 0
map["#{x},#{y}"] += 1
directions = File.read(ARGV[0]).chomp
directions.chars.each do |d|
  case d
  when '<'
    x -= 1
  when '>'
    x += 1
  when '^'
    y -= 1
  when 'v'
    y += 1
  else
    puts "Unrecognised instruction #{d}"
    exit
  end
  map["#{x},#{y}"] += 1
end

puts "Number of houses delivered to #{map.keys.length}"
