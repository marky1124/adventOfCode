# frozen_string_literal: true

# require 'byebug'

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

  def fuel_needed_to_move_to(position)
    fuel = 0
    @crab_pos.each { |crab_pos| fuel += (crab_pos - position).abs }
    fuel
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }  # Reacts to kill -USR1 <PID>
Signal.trap('INFO') { puts s.display_progress }  # Reacts to CTRL-T
s.solve_it(filename)
