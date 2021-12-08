# frozen_string_literal: true

require 'set'

# Solve a puzzle from https://adventofcode.com
class Solve
  def solve_it(filename)
    wires = File.readlines(filename, chomp: true).map { |l| l.split('|')[1].split }.flatten
    # => ["fdgacbe", "cefdb", "cefbgd", "gcbe",  ... ]
    unique_sizes = Set[2, 3, 4, 7]
    count = 0
    wires.each { |letters| count += 1 if unique_sizes.include?(letters.size) }
    puts "Answer is #{count}"
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
