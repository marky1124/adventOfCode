# frozen_string_literal: true

# Given a list of binary numbers count the number of 1's in each character position
# Generate a gamma_rate binary value which comprises of the most common character
# found in each position
# Generate a epsilon_rate which is the opposite.
# The answer is the two values multiplied together in decimal
class Solve
  def solve_it(filename)
    lines = File.readlines(filename, chomp: true) # => ["00100", "11110", "10110", ...]
    input = lines.map { |line| line.chars.map(&:to_i) } # => [[0,0,1,0,0],...]

    oxygen_generator_rating = decode_binary(input, :select)
    puts "oxygen_generator_rating = #{oxygen_generator_rating.join.to_i(2)}"

    co2_scrubber_rating = decode_binary(input, :reject)
    puts "co2_scrubber_rating = #{co2_scrubber_rating.join.to_i(2)}"

    puts "The answer is #{oxygen_generator_rating.join.to_i(2) * co2_scrubber_rating.join.to_i(2)}"
  end

  def decode_binary(input, comparison_type)
    binary_list = input
    input[0].each_index do |ptr|
      number_of_ones_in_position = binary_list.transpose.map(&:sum) # => [7,5,8,7,5]
      most_common_threshold = binary_list.count / 2 # => 6

      if (most_common_threshold * 2 == binary_list.count) &&
         (number_of_ones_in_position[ptr] == most_common_threshold)
        number_of_ones_in_position[ptr] += 1
      end

      most_common_digit_list = # => [1,0,1,1,0]
        number_of_ones_in_position.map do |x|
          x > most_common_threshold ? 1 : 0
        end
      binary_list = binary_list.send(comparison_type) { |x| x[ptr] == most_common_digit_list[ptr] }
      break unless binary_list.length > 1
    end
    binary_list
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
