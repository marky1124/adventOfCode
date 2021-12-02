# frozen_string_literal: true

# Given a list of numbers take each consecutive overlapping group
# of three numbers and sum them, and then count the number of times
# that sum'd number is larger than the previous one.

#  ruby $0 <input-file>
class Solve
  def solve_it(filename)
    previous = nil
    getting_deeper = 0
    depths = File.readlines(filename, chomp: true).map(&:to_i)
    depths.each_cons(3) do |depth_array|
      depth = depth_array.sum
      getting_deeper += 1 if previous && (depth > previous)
      previous = depth
      # puts "previous = #{previous}, depth = #{depth}, getting_deeper=#{getting_deeper}"
    end

    puts "Answer is #{getting_deeper}"
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
