# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  def self.it
    answer1 = 0
    scenic_scores = []
    @trees = File.readlines(ARGV[0] || 'in08', chomp: true).map(&:chars)
    @trees.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        answer1 += 1 if visible_from_outside(row_idx, col_idx)
        scenic_scores << visible_from_tree_house(row_idx, col_idx)
      end
    end
    puts "Answer to part 1 = #{answer1}"
    puts "Answer to part 2 = #{scenic_scores.max}"
  end

  # Calculates whether the tree house is visible from the outside
  private_class_method def self.visible_from_outside(row, col)
    visible = false
    height = @trees[row][col]
    DIRS.each do |drow, dcol|
      tmp = row_of_trees(row, drow, col, dcol)
      visible = tmp.empty? || height > tmp.max
      break if visible
    end
    visible
  end

  # Calculates the scenic score of the trees seen from the tree house
  private_class_method def self.visible_from_tree_house(row, col)
    scenic_score = 1
    height = @trees[row][col]
    DIRS.each do |drow, dcol|
      tmp = row_of_trees(row, drow, col, dcol)
      visible_trees = 0
      tmp.each do |tree|
        visible_trees += 1
        break if tree >= height
      end
      scenic_score *= visible_trees
    end
    scenic_score
  end

  # Returns an array containing the trees encountered from the tree house
  # when moving in one of the cardinal directions
  private_class_method def self.row_of_trees(row, drow, col, dcol)
    row_of_trees = []
    last_in_row = @trees[row].length - 1
    last_in_col = @trees.length - 1
    loop do
      row += drow
      col += dcol
      break if row.negative? || (row > last_in_row) || col.negative? || (col > last_in_col)

      row_of_trees << @trees[row][col]
    end
    row_of_trees
  end
end

Solve.it
