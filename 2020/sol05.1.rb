# frozen_string_literal: true

# Read in a file of coded strings where the letters
# can be re-interpreted to 0's and 1's of binary.
# Find the highest number in the list
#
# Ref: https://adventofcode.com/2020/day/5

highest = 0
File.readlines(ARGV[0]).each do |seat|
  seat_id = seat.gsub(/[BR]/, '1').gsub(/[FL]/, '0').to_i(2)
  highest = seat_id if seat_id > highest
end

puts "The highest seat id = #{highest}"
