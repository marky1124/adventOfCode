# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    memory = File.readlines(ARGV[0] || 'in03', chomp: true).join
    puts "Part 1 answer = #{calculate_part1_answer(memory)}"
    puts "Part 2 answer = #{calculate_part2_answer(memory)}"
  end

  def calculate_part1_answer(memory)
    answer = 0
    memory.scan(/mul\(\d{1,3},\d{1,3}\)/).each do |mul|
      answer += mul.scan(/\d{1,3},\d{1,3}/).first.split(',').map(&:to_i).reduce(:*)
    end
    answer
  end

  def calculate_part2_answer(memory)
    calculate_part1_answer(memory.gsub(/don't\(\).*?(do\(\)|\z)/, ''))
  end
end

Solve.new
