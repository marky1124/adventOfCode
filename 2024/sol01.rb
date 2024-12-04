# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @list1 = []
    @list2 = []
    process_file(ARGV[0] || 'in01')
    calculate_part1_answer
    calculate_part2_answer
    puts "Part 1 answer = #{@answer1}"
    puts "Part 2 answer = #{@answer2}"
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      num1, num2 = line.split.map(&:to_i)
      @list1 << num1
      @list2 << num2
    end
  end

  def calculate_part1_answer
    @list1.sort!
    @list2.sort!
    @answer1 = @list1.zip(@list2).map { |a, b| (a - b).abs }.sum
  end

  def calculate_part2_answer
    @answer2 = 0
    numbers_in_list2 = @list2.tally
    numbers_in_list2.default = 0
    @list1.each do |num|
      @answer2 += (num * numbers_in_list2[num])
    end
  end
end

Solve.new
