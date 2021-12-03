# frozen_string_literal: true

# In addition to horizontal position and depth, you'll also need to track
# a third value, aim, which also starts at 0. The commands also mean
# something entirely different than you first thought:
#
#    down X increases your aim by X units.
#    up X decreases your aim by X units.
#    forward X does two things:
#        It increases your horizontal position by X units.
#        It increases your depth by your aim multiplied by X.
#
# The answer is the horizontal position multiplied by the depth
class Solve
  def initialize
    @horizontal = 0
    @depth = 0
    @aim = 0
  end

  def solve_it(filename)
    File.readlines(filename, chomp: true).each do |line|
      command, value = line.split
      if command == 'forward'
        @horizontal += value.to_i
        @depth += @aim * value.to_i
      end
      @aim += value.to_i if command == 'down'
      @aim -= value.to_i if command == 'up'
      # puts "line = #{line}, horizontal = #{@horizontal}, depth = #{@depth}, aim = #{@aim}"
    end

    puts "Answer is #{@horizontal * @depth}"
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
