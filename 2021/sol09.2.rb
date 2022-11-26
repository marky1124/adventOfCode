# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Puzzle
  def initialize
    @hmap = []
    @lowpoints = []
  end

  def solve_it(filename)
    @hmap = File.readlines(filename, chomp: true).map { |l| l.chars.map(&:to_i) }
    # @hmap => [[2, 1, 9, 9, 9, 4, 3, 2, 1, 0], ...]
    @hmap.each_index do |row|
      @hmap[row].each_index do |col|
        neighbours = neighbours(row, col)
        @lowpoints.append([row, col]) if @hmap[row][col] < neighbours.min
      end
    end

    basin_sizes = calculate_basin_sizes
    answer = basin_sizes.sort[-3..].reduce(:*)
    puts "Answer is #{answer}"
  end

  # For each lowpoint calculate it's basin size by using
  # it and it's cardinal neighbours (with values less than 9)
  # as a starting point, add these to an array of locations
  # to_check and maintain an array of locations that have
  # already been checked. Keep repeating this until all
  # basin locations have been checked.
  def calculate_basin_sizes
    basin_sizes = []
    @lowpoints.each do |lowrow, lowcol|
      basin = [[lowrow, lowcol]]
      to_check = [[lowrow, lowcol]]
      checked = []
      loop do
        row, col = to_check.shift
        neighbours = basin_neighbours(row, col)
        basin = (basin + neighbours).uniq
        checked += [[row, col]]
        to_check = (to_check + neighbours).uniq - checked
        break if to_check.empty?
      end
      # puts "Lowpoint #{lowrow},#{lowcol} - Basin neighbours: #{basin} (size=#{basin.count})"
      basin_sizes.append(basin.count)
    end
    basin_sizes
  end

  # Return the [row, col] locations of neighbours except those whose value==9
  def basin_neighbours(row, col)
    neighbours = []
    [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |r, c|
      next if (row + r).negative? || row + r >= @hmap.length
      next if (col + c).negative? || col + c >= @hmap[0].length

      neighbours.append([row + r, col + c]) if @hmap[row + r][col + c] != 9
    end
    neighbours
  end

  # Return the values of the horizontal and vertical neighbours
  def neighbours(row, col)
    neighbours = []
    [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |r, c|
      next if (row + r).negative? || row + r >= @hmap.length
      next if (col + c).negative? || col + c >= @hmap[0].length

      neighbours.append(@hmap[row + r][col + c])
    end
    neighbours
  end
end

filename = ARGV[0] || 'in09'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in09"
  exit
end

p = Puzzle.new
p.solve_it(filename)
