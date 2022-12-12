# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    valid = 0
    File.readlines(ARGV[0] || '../2016/in03', chomp: true).each do |line|
      sides = line.split.map(&:to_i)
      valid += 1 if sides[0] + sides[1] > sides[2] && sides[1] + sides[2] > sides[0] && sides[2] + sides[0] > sides[1]
    end
    puts "Answer to part 1 = #{valid}"
  end
end

Solve.it
