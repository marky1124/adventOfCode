# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    values = []
    File.readlines(ARGV[0] || 'in01', chomp: true).each do |line|
      numbers = line.scan(/\d/).map(&:to_i)
      values << (numbers.first * 10) + numbers.last
    end
    puts "Part 1 answer = #{values.sum}"
  end
end

Solve.it
