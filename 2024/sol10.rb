# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze # up, right, down, left

  def initialize
    process_file(ARGV[0] || 'in10')
    find_routes
    puts "Answer to part 1 = #{@route_start_end.keys.count}"
    puts "Answer to part 2 = #{@answer2}"
  end

  def process_file(file)
    @map = []
    File.readlines(file, chomp: true).each do |line|
      @map << line.chars.map(&:to_i)
    end
    @max_row = @map[0].length - 1
    @max_col = @map.length - 1
    @trailheads = []
    @map.each_index do |row_idx|
      @map[row_idx].each_index do |col_idx|
        @trailheads << [row_idx, col_idx] if @map[row_idx][col_idx].zero?
      end
    end
  end

  def find_routes
    @answer2 = 0
    @route_start_end = {}
    @trailheads.each do |trailhead|
      find_route(trailhead, trailhead)
    end
  end

  def find_route(trailhead, position)
    next_height = @map[position[0]][position[1]] + 1
    DIRS.each do |direction|
      next unless (next_position = next_step_out_of_bounds(position, direction))

      if @map[next_position[0]][next_position[1]] == next_height
        if next_height == 9
          unless @route_start_end["#{trailhead},#{next_position}"]
            @route_start_end["#{trailhead},#{next_position}"] = true
          end
          @answer2 += 1
        else
          find_route(trailhead, next_position)
        end
      end
    end
  end

  def next_step_out_of_bounds(position, direction)
    new_row = position[0] + direction[0]
    new_col = position[1] + direction[1]

    out_of_bounds = new_row.negative? || (new_row > @max_row) || new_col.negative? || (new_col > @max_col)
    (out_of_bounds ? nil : [new_row, new_col])
  end
end

Solve.new
