# frozen_string_literal: true

# This algorithm can not scale to the full input data
# It is too memory hungry, it would need over 167 TB
# of memory :-)
#
# Sensor at x=2, y=18: closest beacon is at x=-2, y=15
# Sensor at x=9, y=16: closest beacon is at x=10, y=16

# Solve a puzzle from https://adventofcode.com
class Solve
  ROW = 2_000_000

  def initialize
    @answer = 0
    @sensors = []
    @beacons = []
    @file = ARGV[0] || 'in15'
    File.readlines(@file, chomp: true).each do |line|
      line[/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/]
      scol, srow, bcol, brow = Regexp.last_match.captures
      @sensors << [scol.to_i, srow.to_i]
      @beacons << [bcol.to_i, brow.to_i]
    end
    @min_col = (@sensors + @beacons).map(&:first).min
    @max_col = (@sensors + @beacons).map(&:first).max
    @min_row = (@sensors + @beacons).map(&:last).min
    @max_row = (@sensors + @beacons).map(&:last).max
    @col_offset = @min_col.abs + @max_col.abs
    @row_offset = @min_row.abs + @max_row.abs
    @map = '.' * ((@max_col + 1 + (@col_offset * 2)) * (1 + @max_row + (@row_offset * 2)))

    @sensors.each { |col, row| @map[col_row_to_index(col, row)] = 'S' }
    @beacons.each { |col, row| @map[col_row_to_index(col, row)] = 'B' }

    (0..@sensors.count - 1).each { |i| update_map(*@sensors[i], *@beacons[i]) }

    # Add corners of the part 2 square
    @map[col_row_to_index(0,0)] = 'X'
    @map[col_row_to_index(0,20)] = 'X'
    @map[col_row_to_index(20,0)] = 'X'
    @map[col_row_to_index(20,20)] = 'X'
    print_map
    puts "Row #{ROW}:"
    puts fetch_row(ROW)

    @answer = fetch_row(ROW).each_char.select { |c| c == '#' }.count

    puts "Answer = #{@answer}"
  end

  def update_map(scol, srow, bcol, brow)
    manhattan_distance = (scol - bcol).abs + (srow - brow).abs
    (0..manhattan_distance).each do |delta_col|
      (0..(manhattan_distance - delta_col)).each do |delta_row|
        @map[col_row_to_index(scol + delta_col, srow + delta_row)] = '#' if @map[col_row_to_index(scol + delta_col, srow + delta_row)] == '.'
        @map[col_row_to_index(scol - delta_col, srow + delta_row)] = '#' if @map[col_row_to_index(scol - delta_col, srow + delta_row)] == '.'
        @map[col_row_to_index(scol - delta_col, srow - delta_row)] = '#' if @map[col_row_to_index(scol - delta_col, srow - delta_row)] == '.'
        @map[col_row_to_index(scol + delta_col, srow - delta_row)] = '#' if @map[col_row_to_index(scol + delta_col, srow - delta_row)] == '.'
      end
    end
  end

  def col_row_to_index(col, row)
    (@max_col + 1 + (@col_offset * 2)) * (row + @row_offset) + col + @col_offset
  end

  def print_map
    @map.scan(/.{#{@max_col + 1 + (@col_offset * 2)}}/).each { |line| puts line }
  end

  def fetch_row(row)
    out = ''
    @map.scan(/.{#{@max_col + 1 + (@col_offset * 2)}}/).each_with_index { |line, index| out = line if (row + @row_offset) == index }
    out
  end
end

Solve.new
