# frozen_string_literal: true

# See: https://adventofcode.com/2020/day/5
#
# Find a number in an array of numbers which is missing but
# the number before and after are there (-1 and +1)

seat_ids = []
File.readlines(ARGV[0], chomp: true).each do |seat|
  seat_ids << seat.gsub(/[BR]/, '1').gsub(/[FL]/, '0').to_i(2)
end
seat_ids.sort!

seat_ids.each_index do |idx|
  next if idx.zero?

  if (seat_ids[idx - 1] != seat_ids[idx] - 1) &&
     (seat_ids[idx] == seat_ids[idx - 1] + 2)
    puts "You are in seat #{seat_ids[idx - 1] + 1}"
  end
end
