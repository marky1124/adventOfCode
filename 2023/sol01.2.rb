# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  NUMBER_STRINGS = { 'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5,
                     'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9 }.freeze
  def self.it
    values = []
    File.readlines(ARGV[0] || 'in01', chomp: true).each do |line|
      # Use (?=...) positive lookahead to find overlapping matches e.g. twone is two, one
      numbers = line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|\d))/).flatten
      numbers.map! { |v| string_to_number(v) }
      values << (numbers.first * 10) + numbers.last
    end
    puts "Part 2 answer = #{values.sum}"
  end

  def self.string_to_number(number)
    return number.to_i if number.to_i.positive?

    NUMBER_STRINGS[number]
  end
end

Solve.it
