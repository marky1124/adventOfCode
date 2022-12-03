# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  BEATS = { 'A' => 'Y', 'B' => 'Z', 'C' => 'X' }.freeze
  LOSES_TO = { 'C' => 'Y', 'A' => 'Z', 'B' => 'X' }.freeze
  DRAW = { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' }.freeze
  PLAY_VALUE = { 'A' => 1, 'B' => 2, 'C' => 3, 'X' => 1, 'Y' => 2, 'Z' => 3 }.freeze
  def self.it
    score = 0
    File.readlines(ARGV[0] || 'in02', chomp: true).each do |line|
      opp, aim = line.split
      case aim
      when 'X' # Aim to lose
        me = LOSES_TO[opp]
      when 'Y' # Aim to draw
        me = DRAW[opp]
      when 'Z' # Aim to win
        me = BEATS[opp]
      end
      score += PLAY_VALUE[me]
      score += 6 if me == BEATS[opp]
      score += 3 if PLAY_VALUE[me] == PLAY_VALUE[opp]
    end
    puts "Answer = #{score}"
  end
end

Solve.it
