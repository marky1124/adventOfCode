# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1]].freeze
  MATCH = 'XMAS'

  def initialize
    answer = 0
    process_file(ARGV[0] || 'in04')
    @word_search.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        answer += count_matches(row_idx, col_idx) if @word_search[row_idx][col_idx] == MATCH[0]
      end
    end
    puts "Answer = #{answer}"
  end

  def process_file(file)
    @word_search = File.readlines(file, chomp: true).map(&:chars)
    @max_row = @word_search[0].length - 1
    @max_col = @word_search.length - 1
  end

  # Check for a word match in each direction
  def count_matches(row, col)
    count = 0
    DIRS.each do |drow, dcol|
      count += 1 if word_match(row, drow, col, dcol)
    end
    count
  end

  # Given a start point and a direction check if we have a match
  def word_match(row, drow, col, dcol)
    MATCH.chars.each_with_index do |letter, idx|
      test_row = row + (drow * idx)
      test_col = col + (dcol * idx)
      return false if out_of_bounds(test_row, test_col)
      return false if letter != @word_search[test_row][test_col]
    end
    true
  end

  def out_of_bounds(row, col)
    row.negative? || (row > @max_row) || col.negative? || (col > @max_col)
  end
end

Solve.new
