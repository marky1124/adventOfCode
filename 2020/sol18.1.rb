# frozen_string_literal: true

#  Solve an https://adventofcode.com puzzle
class Puzzle
  # Given a string of sums with no brackets, calc value
  def calculate_string(sum)
    loop do
      next_sum = sum.match(/(\d+)\s*([*+])\s*(\d+)/)
      break unless next_sum

      num1 = next_sum.captures[0].to_i
      num2 = next_sum.captures[2].to_i
      answer = next_sum.captures[1] == '+' ? num1 + num2 : num1 * num2
      sum = sum.sub(/\d+\s*[*+]\s*\d+/, answer.to_s)
    end
    sum
  end

  # Grab each bracketted section and replace it with the
  # value of the sum it contains, repeat until no brackets
  # Then return the value of the remaining sum
  def process_line(line)
    # Process all the bracketted sections
    loop do
      match = line.match(/(\([^()]*\))/) # => (2 + 4 * 9)
      break unless match

      answer = calculate_string(match.captures[0][1..-2])
      line = line.sub(/\([^()]*\)/, answer)
    end

    calculate_string(line)
  end

  def solve_it(filename)
    answer = 0
    fd = File.open(filename)
    until fd.eof
      line = fd.readline.chomp
      line_sum = process_line(line).to_i
      puts "Line sum = #{line_sum}"
      answer += line_sum
    end

    puts "Answer = #{answer}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in16"
  exit
end

p = Puzzle.new
p.solve_it(filename)
