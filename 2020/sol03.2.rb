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
# As before but check each slope
#
#    trees[0] slope 1: Right 1, down 1.
#    trees[1] slope 2: Right 3, down 1. (This is the slope you already checked.)
#    trees[2] slope 3: Right 5, down 1.
#    trees[3] slope 4: Right 7, down 1.
#    trees[4] slope 5: Right 1, down 2.
#
# Multiply each of the tree counts

trees = [0] * 5
map = File.readlines(ARGV[0], chomp: true)
map_even_lines_only = map.select.each_with_index { |_v, i| i.even? }
width = map[0].length

(map.count - 1).times { |i| trees[0] += 1 if map[i + 1][((i + 1)) % width] == '#' }
(map.count - 1).times { |i| trees[1] += 1 if map[i + 1][((i + 1) * 3) % width] == '#' }
(map.count - 1).times { |i| trees[2] += 1 if map[i + 1][((i + 1) * 5) % width] == '#' }
(map.count - 1).times { |i| trees[3] += 1 if map[i + 1][((i + 1) * 7) % width] == '#' }
(map_even_lines_only.count - 1).times { |i| trees[4] += 1 if map_even_lines_only[i + 1][((i + 1)) % width] == '#' }
puts "The number of trees encountered is #{trees}, answer = #{trees.reduce(:*)}"
