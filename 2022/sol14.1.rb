# frozen_string_literal: true

# 2,3 -> 2,5 -> 6,5
# 4,0 -> 4,2 -> 1,2
#
#   0123456
# 0 ....#..     0..6
# 1 ....#..     7..13
# 2 .####..     14..20
# 3 ..#....     21..27
# 4 ..#....     28..34
# 5 ..#####     35..41
#
# @map = '....#......#...####....#......#......#####'
#         012345678911111111112222222222333333333344
#                   01234567890123456789012345678901

# Solve a puzzle from https://adventofcode.com
class Solve
  SAND = [500, 0].freeze

  def initialize
    @answer = 0
    @file = ARGV[0] || 'in14'
    input = File.read(@file).split(Regexp.union(/\n/, ',', '->'))
    @max_col = input.each_slice(2).map(&:first).map(&:to_i).max
    @max_row = input.each_slice(2).map(&:last).map(&:to_i).max
    @map = '.' * ((@max_col + 1) * (1 + @max_row))

    File.readlines(@file, chomp: true).each do |line|
      line.split('->').each_cons(2) do |point1, point2|
        generate_points_between(point1, point2).each do |col, row|
          @map[col_row_to_index(col, row)] = '#'
        end
      end
    end

    @map[col_row_to_index(*SAND)] = 'S'
    loop do
      break if add_sand(*SAND)

      @answer += 1
    end

    print_map

    puts "Answer = #{@answer}"
  end

  # Add a grain of sand and update @map with it's resting place
  # Returns true if the sand falls off the bottom of the map
  def add_sand(col, row)
    loop do
      if @map[col_row_to_index(col, row + 1)] == '.'
        row += 1
      elsif @map[col_row_to_index(col - 1, row + 1)] == '.'
        row += 1
        col -= 1
      elsif @map[col_row_to_index(col + 1, row + 1)] == '.'
        row += 1
        col += 1
      else
        break
      end
      return true if row + 1 > @max_row
    end

    @map[col_row_to_index(col, row)] = 'o'
    false
  end

  def col_row_to_index(col, row)
    ((@max_col + 1) * row) + col
  end

  def generate_points_between(point1, point2)
    pts = []
    p1_col, p1_row = point1.split(',').map(&:to_i)
    p2_col, p2_row = point2.split(',').map(&:to_i)
    if p1_col == p2_col
      (p1_row..p2_row).step(p1_row > p2_row ? -1 : 1).each { |row| pts << [p1_col, row] }
    else
      (p1_col..p2_col).step(p1_col > p2_col ? -1 : 1).each { |col| pts << [col, p1_row] }
    end
    pts
  end

  def print_map
    @map.scan(/.{#{@max_col + 1}}/).each { |line| puts line }
  end
end

Solve.new
