# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze # up, right, down, left
  STEP = %w[| - | -].freeze

  def initialize
    process_file(ARGV[0] || 'in06')
    walk_route
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @map = File.readlines(file, chomp: true).map(&:chars)
    @max_row = @map[0].length - 1
    @max_col = @map.length - 1
    @map.each_index do |row_idx|
      @position = [row_idx, @map[row_idx].find_index('^')] if @map[row_idx].find_index('^')
    end
    @direction = 0
    @answer = 1
  end

  def walk_route
    loop do
      break if next_step_out_of_bounds

      case @map[@new_row][@new_col]
      when '#'
        @direction = (@direction + 1) % 4
        @map[@position[0]][@position[1]] = '+'
      else
        @answer += 1 if @map[@new_row][@new_col] == '.'
        @map[@new_row][@new_col] = STEP[@direction]
        @position = [@new_row, @new_col]
      end
    end
  end

  def next_step_out_of_bounds
    @new_row = @position[0] + DIRS[@direction][0]
    @new_col = @position[1] + DIRS[@direction][1]

    @new_row.negative? || (@new_row > @max_row) || @new_col.negative? || (@new_col > @max_col)
  end
end

Solve.new
