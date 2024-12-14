# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DEPTH = 103 # 11 # 103
  WIDTH = 101 # 7 # 101
  STEPS = 100

  def initialize
    @answer = 0
    process_file(ARGV[0] || 'in14')
    walk_robots_onwards_by(STEPS)
    robots_per_quadrant
    puts "Answer = #{@quadrant.reduce(:*)}"
  end

  def process_file(file)
    @robot_pos = []
    @robot_vec = []
    File.readlines(file, chomp: true).each do |line|
      case line
      when /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/
        @robot_pos << [::Regexp.last_match(2).to_i, ::Regexp.last_match(1).to_i]
        @robot_vec << [::Regexp.last_match(4).to_i, ::Regexp.last_match(3).to_i]
      end
    end
  end

  def walk_robots_onwards_by(steps)
    @robot_pos.map!.with_index do |pos, idx|
      new_row = (pos[0] + (steps * @robot_vec[idx][0])) % DEPTH
      new_col = (pos[1] + (steps * @robot_vec[idx][1])) % WIDTH
      [new_row, new_col]
    end
  end

  def robots_per_quadrant
    @quadrant = Array.new(4, 0)
    mid_col = WIDTH / 2
    mid_row = DEPTH / 2
    @robot_pos.each do |pos|
      @quadrant[0] += 1 if pos[0] < mid_row && pos[1] < mid_col
      @quadrant[1] += 1 if pos[0] < mid_row && pos[1] > mid_col
      @quadrant[2] += 1 if pos[0] > mid_row && pos[1] < mid_col
      @quadrant[3] += 1 if pos[0] > mid_row && pos[1] > mid_col
    end
  end
end

Solve.new
