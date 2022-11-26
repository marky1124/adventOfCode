# frozen_string_literal: true

require 'byebug'

#  ruby sol13.2.rb in13
class Solve
  def initialize(file)
    fd = File.open(file)
    time = fd.readline.chomp.to_i # => 939
    frequency = fd.readline.chomp.split(',').reject { |v| v == 'x' }.map(&:to_i) # => [7, 13, 59, 31, 19]

    # Calculate the time until the next bus & return the minimum along with it's index => [5, 2]
    wait_time, i = frequency.map { |f| f - (time % f) }.each_with_index.min

    puts "Get on bus #{frequency[i]} in #{wait_time}. Answer = #{frequency[i] * wait_time}"
  end
end

filename = ARGV[0] || 'in13'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in13"
  exit
end

Solve.new(filename)
