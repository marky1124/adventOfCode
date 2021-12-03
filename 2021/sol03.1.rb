# frozen_string_literal: true

# require 'byebug'

#  ruby $0 <input-file>
class Solve
  def solve_it(filename)
    lines = File.readlines(filename, chomp: true) # => ["00100", "11110", "10110", ...]
    number_of_lines = lines.count # => 12
    input = lines.map { |line| line.chars.map(&:to_i) } # => [[0,0,1,0,0],...]
    number_of_ones_in_position = input.transpose.map(&:sum) # => [7,5,8,7,5]

    most_common_threshold = number_of_lines / 2
    gamma_rate = number_of_ones_in_position.map { |x| x > most_common_threshold ? '1' : '0' }.join # => "10110"
    epsilon_rate = number_of_ones_in_position.map { |x| x < most_common_threshold ? '1' : '0' }.join # => "01001"
    # or epsilon_rate = gamma_rate.chars.map{|c| (c=="1" ? "0" : "1")}.join # => "01001"

    puts "The answer is #{gamma_rate.to_i(2) * epsilon_rate.to_i(2)}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in03"
  exit
end

s = Solve.new
s.solve_it(filename)
