# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze # up, right, down, left

  def initialize
    process_file(ARGV[0] || 'in12')
    find_plots
    puts "Answer to part 1 = #{@answer1}"
    puts "Answer to part 2 = #{@answer2}"
  end

  def process_file(file)
    @map = []
    File.readlines(file, chomp: true).each do |line|
      @map << line.chars
    end
    @max_col = @map[0].length - 1
    @max_row = @map.length - 1
    @empty_map = Array.new(@max_row + 1) { Array.new(@max_col + 1, nil) }
  end

  def find_fence_sides
    @fences = @fences.sort.uniq
    sides = 0
    loop do
      fence = @fences.shift
      break if fence.nil?

      sides += 1
      delta_row = (fence[2][0].zero? ? 1 : 0)
      delta_col = (fence[2][1].zero? ? 1 : 0)
      count = 0
      loop do
        count += 1
        next_check = [fence[0] + (count * delta_row), fence[1] + (count * delta_col)]
        next_arg = [next_check[0], next_check[1], fence[2]]
        break unless @fences.include?(next_arg)

        # puts "Removing #{next_arg} as it's adjacent to #{fence}"
        @fences.delete(next_arg)
      end
      count = 0
      loop do
        count += 1
        next_check = [fence[0] + (count * delta_row), fence[1] + (count * delta_col)]
        next_arg = [next_check[0], next_check[1], fence[2]]
        break unless @fences.include?(next_arg)

        # puts "Removing #{next_arg} as it's adjacent to #{fence}"
        @fences.delete(next_arg)
      end
    end
    sides
  end

  def find_plots
    @answer1 = 0
    @answer2 = 0
    @total_plants = 0
    @total_fencing = 0

    @map.each_index do |row_idx|
      @map[row_idx].each_index do |col_idx|
        next if @empty_map[row_idx][col_idx]

        @plants = 0
        @fencing = 0
        @fences = []
        find_plot(row_idx, col_idx, @map[row_idx][col_idx])
        sides = find_fence_sides
        # puts "Plot #{@map[row_idx][col_idx]} has #{@plants} plants and needs #{@fencing} fencing, made up #{sides} sides"
        @answer1 += (@plants * @fencing)
        @answer2 += (@plants * sides)
        @total_plants += @plants
        @total_fencing += @fencing
      end
    end
  end

  def find_plot(row_idx, col_idx, plant)
    return if @empty_map[row_idx][col_idx]

    @plants += 1

    @empty_map[row_idx][col_idx] = true
    DIRS.each do |direction|
      if (next_position = next_step_out_of_bounds([row_idx, col_idx], direction)).nil?
        @fencing += 1
        @fences << [row_idx, col_idx, direction]
      elsif @empty_map[next_position[0]][next_position[1]].nil? &&
            @map[next_position[0]][next_position[1]] == plant
        find_plot(next_position[0], next_position[1], plant)
      elsif @map[next_position[0]][next_position[1]] != plant
        @fencing += 1
        @fences << [row_idx, col_idx, direction]
      end
    end
  end

  # Returns nil if out of bounds, otherwise returns next location [row, col]
  def next_step_out_of_bounds(position, direction)
    new_row = position[0] + direction[0]
    new_col = position[1] + direction[1]

    out_of_bounds = new_row.negative? || (new_row > @max_row) || new_col.negative? || (new_col > @max_col)
    (out_of_bounds ? nil : [new_row, new_col])
  end
end

Solve.new
