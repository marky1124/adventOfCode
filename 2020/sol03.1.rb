# frozen_string_literal: true

# Read in a file of text that represents empty & occupied locations.
# The file will have a set width, if movement goes further to the
# right, then act as though the input was repeated infinitely to
# the right.
#
#
# You make a map (your puzzle input) of the open squares (.) and trees
# (#) you can see. For example:
#
#        ..##.......
#        #...#...#..
#        .#....#..#.
#        ..#.#...#.#
#        .#...##..#.
#        ..#.##.....
#        .#.#.#....#
#        .#........#
#        #.##...#...
#        #...##....#
#        .#..#...#.#
#
# Auto expand to the right, e.g.
#
#        ..##.........##.........##.........##.......
#        #...#...#..#...#...#..#...#...#..#...#...#..
#        .#....#..#..#....#..#..#....#..#..#....#..#.
#        ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
#        .#...##..#..#...##..#..#...##..#..#...##..#.
#        ..#.##.......#.##.......#.##.......#.##.....
#        .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
#        .#........#.#........#.#........#.#........#
#        #.##...#...#.##...#...#.##...#...#.##...#...
#        #...##....##...##....##...##....##...##....#
#        .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#
#
# Starting in the top left, each turn you move to the
# position three-right and one-down from where you were.
# Keep moving in the same way until you move past the
# last row of input.
#
# How many trees(#'s) did you land on from top to bottom
#

tree = 0
map = File.readlines(ARGV[0], chomp: true)
width = map[0].length

(map.count - 1).times do |i|
  puts "Looking at line #{i + 1} => #{map[i + 1]}, column #{((i + 1) * 3) % width}"
  tree += 1 if map[i + 1][((i + 1) * 3) % width] == '#'
end

# (map.count-1).times { |i| tree += 1 if map[i+1][((i+1)*3)%width] == '#' }
puts "The number of trees encountered is #{tree}"
