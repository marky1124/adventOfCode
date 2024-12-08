# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze # up, right, down, left
  IN_A_LOOP = 3

  def initialize
    process_file(ARGV[0] || 'in06')
    @remember_map = Marshal.load(Marshal.dump(@map))
    walk_route(store_obstacles: true)
    test_routes_with_added_obstructions
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @map = File.readlines(file, chomp: true).map(&:chars)
    @max_row = @map[0].length - 1
    @max_col = @map.length - 1
    @map.each_index do |row_idx|
      @start_position = [row_idx, @map[row_idx].find_index('^')] if @map[row_idx].find_index('^')
    end
  end

  def test_routes_with_added_obstructions
    @answer = 0
    @obstruction_locations.uniq.each_with_index do |ob_pos, ob_idx|
      puts "Testing obstruction #{ob_idx} of #{@obstruction_locations.count - 1}" if (ob_idx % 500).zero?
      @map = Marshal.load(Marshal.dump(@remember_map))
      @map[ob_pos[0]][ob_pos[1]] = '#'
      @answer += 1 if walk_route(store_obstacles: false) == IN_A_LOOP
    end
  end

  def walk_route(store_obstacles:)
    @obstruction_locations = [] if store_obstacles
    @direction = 0
    @footsteps = {}
    position = @start_position
    loop do
      break if next_step_out_of_bounds(position, @direction)

      return IN_A_LOOP if @footsteps["#{position[0]},#{position[1]},#{@direction}"]

      @footsteps["#{position[0]},#{position[1]},#{@direction}"] = 1
      @obstruction_locations << [@new_row, @new_col] if store_obstacles

      case @map[@new_row][@new_col]
      when '#'
        @direction = (@direction + 1) % 4
        @map[position[0]][position[1]] = @direction
      else
        @map[@new_row][@new_col] = @direction
        position = [@new_row, @new_col]
      end
    end
  end

  def next_step_out_of_bounds(position, direction)
    @new_row = position[0] + DIRS[direction][0]
    @new_col = position[1] + DIRS[direction][1]

    @new_row.negative? || (@new_row > @max_row) || @new_col.negative? || (@new_col > @max_col)
  end
end

Solve.new
