# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    valid = 0
    count = 0
    lines = []
    File.readlines(ARGV[0] || '../2016/in03', chomp: true).each do |line|
      lines << line.split.map(&:to_i)
      count += 1
      next unless (count % 3).zero?

      (0..2).each do |index|
        valid += 1 if valid_triangle(lines[0][index], lines[1][index], lines[2][index])
      end
      lines = []
    end
    puts "Answer to part 2 = #{valid}"
  end

  private_class_method def self.valid_triangle(side1, side2, side3)
    side1 + side2 > side3 && side2 + side3 > side1 && side3 + side1 > side2
  end
end

Solve.it
