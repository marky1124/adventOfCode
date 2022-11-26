# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @crab_pos
  end

  def solve_it(filename)
    cost = []
    @crab_pos = File.readlines(filename, chomp: true)[0].split(',').map(&:to_i)
    min = @crab_pos.min
    max = @crab_pos.max
    (min..max).each do |position|
      fuel = fuel_needed_to_move_to(position)
      puts "Fuel to move crabs to #{position} is #{fuel}"
      cost.append(fuel)
    end

    puts "Answer is #{cost.min}"
  end

  # The fuel cost is now the sum of thw numbers from 1 to
  # the distance between them. This is a triangular number.
  # e.g 1+2+3=6. The formula for calculating the sum of the
  # triangular numbers from 1 to n is n(n+1)/2
  # Ref: https://math.stackexchange.com/questions/2435816/a-formula-for-the-sum-of-the-triangular-numbers
  def fuel_needed_to_move_to(position)
    fuel = 0
    @crab_pos.each do |crab_pos|
      diff = (crab_pos - position).abs
      fuel += (diff * (diff + 1)) / 2
    end
    fuel
  end
end

filename = ARGV[0] || 'in07'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in07"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress } # Reacts to kill -USR1 <PID>
Signal.trap('INFO') { puts s.display_progress } if RUBY_PLATFORM =~ /darwin/ # Reacts to CTRL-T on OS X (ArgumentError in Debian)
s.solve_it(filename)