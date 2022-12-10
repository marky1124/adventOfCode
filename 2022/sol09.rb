# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, -1], [0, 1], [-1, 0], [1, 0]].freeze
  UP, DOWN, LEFT, RIGHT = (0..3).to_a
  DIR_PTR_MAP = { 'U' => 0, 'D' => 1, 'L' => 2, 'R' => 3 }.freeze
  MAX_NUMBER_OF_KNOTS = 10

  def self.it
    @knots = Array.new(MAX_NUMBER_OF_KNOTS) { Array.new([0, 0]) }
    visited_second = { pos_key(@knots[1]) => true }
    visited_last = { pos_key(@knots[1]) => true }

    File.readlines(ARGV[0] || 'in09', chomp: true).each do |line|
      direction, distance = line.split
      move_delta = DIRS[DIR_PTR_MAP[direction]]
      distance.to_i.times do
        @knots[0][0] += move_delta[0]
        @knots[0][1] += move_delta[1]
        update_knots
        visited_second[pos_key(@knots[1])] = true
        visited_last[pos_key(@knots.last)] = true
      end
    end
    puts "Answer to part 1 = #{visited_second.keys.count}"
    puts "Answer to part 2 = #{visited_last.keys.count}"
  end

  private_class_method def self.pos_key(cur_pos)
    "#{cur_pos[0]},#{cur_pos[1]}"
  end

  private_class_method def self.update_knots
    (1..@knots.length - 1).each do |kidx|
      next if (@knots[kidx][0] - @knots[kidx - 1][0]).abs <= 1 && (@knots[kidx][1] - @knots[kidx - 1][1]).abs <= 1

      @knots[kidx][0] += @knots[kidx - 1][0] > @knots[kidx][0] ? 1 : -1 if @knots[kidx - 1][0] != @knots[kidx][0]
      @knots[kidx][1] += @knots[kidx - 1][1] > @knots[kidx][1] ? 1 : -1 if @knots[kidx - 1][1] != @knots[kidx][1]
    end
  end
end

Solve.it
