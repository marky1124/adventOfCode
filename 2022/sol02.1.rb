# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  BEATS = { 'A' => 'Y', 'B' => 'Z', 'C' => 'X' }.freeze
  PLAY_VALUE = { 'A' => 1, 'B' => 2, 'C' => 3, 'X' => 1, 'Y' => 2, 'Z' => 3 }.freeze
  def self.it
    score = 0
    File.readlines(ARGV[0] || 'in02', chomp: true).each do |line|
      opp, me = line.split
      score += PLAY_VALUE[me]
      score += 6 if me == BEATS[opp]
      score += 3 if PLAY_VALUE[me] == PLAY_VALUE[opp]
    end
    puts "Answer = #{score}"
  end
end

Solve.it
