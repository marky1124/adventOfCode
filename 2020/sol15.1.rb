# frozen_string_literal: true

# require 'byebug'

#
# 0,3,6
#
#  ruby sol15.1.rb in15
class Solve
  def solve_it(filename)
    file = File.readlines(filename, chomp: true)
    starting_numbers = file[0].split(',').map(&:to_i)
    numbers = Hash.new(0)
    turn = 0
    spoken = 0
    first_time = true

    starting_numbers.each do |v|
      turn += 1
      first_time = numbers[v].zero?
      numbers[v] = turn
      spoken = v
    end

    # byebug
    while turn < 2020
      turn += 1
      if first_time
        numbers[spoken] = turn - 1
        spoken = 0
      else
        next_number = (turn - 1) - numbers[spoken]
        numbers[spoken] = turn - 1
        spoken = next_number
      end
      first_time = numbers[spoken].zero?
      # numbers[spoken] = turn
      # puts "#{turn}: #{spoken} (FT=#{first_time}, numbers=#{numbers}"
      puts "#{turn}: #{spoken} (FT=#{first_time})"
    end

    puts "Answer = #{spoken}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in15"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress }
s.solve_it(filename)
