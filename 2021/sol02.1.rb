# frozen_string_literal: true

# Given a file containing a list of commands such as 'forward 4', 'down 3', 'up 1'
#
#     forward X increases the horizontal position by X units.
#     down X increases the depth by X units.
#     up X decreases the depth by X units.
#
# Your horizontal position and depth both start at 0.
# Calculate the horizontal position and depth you would have after following the
# planned course.
# What do you get if you multiply your final horizontal position by your final depth?

#  ruby $0 <input-file>
class Solve
  def solve_it(filename)
    horizontal = 0
    depth = 0
    input = File.readlines(filename, chomp: true)
    input.each do |line|
      command, value = line.split(' ')
      horizontal += value.to_i if command == 'forward'
      depth += value.to_i if command == 'down'
      depth -= value.to_i if command == 'up'
      # puts "line = #{line}, horizontal = #{horizontal}, depth = #{depth}"
    end

    puts "Answer is #{horizontal * depth}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
s.solve_it(filename)
