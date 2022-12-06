# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    columns = File.read(ARGV[0] || 'in06').split.map(&:chars).transpose
    puts "Answer for part 1 = #{columns.map { |col| col.tally.max_by(&:last)[0] }.join}"
    puts "Answer for part 2 = #{columns.map { |col| col.tally.min_by(&:last)[0] }.join}"
  end
end

Solve.it
