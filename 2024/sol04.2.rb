# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    answer = 0
    process_file(ARGV[0] || 'in04')
    @word_search.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        answer += 1 if @word_search[row_idx][col_idx] == 'A' && found_x_mas(row_idx, col_idx)
      end
    end
    puts "Answer = #{answer}"
  end

  def process_file(file)
    @word_search = File.readlines(file, chomp: true).map(&:chars)
    @max_row = @word_search[0].length - 1
    @max_col = @word_search.length - 1
  end

  # Check if current location is in the centre of a S-M or M-S cross
  def found_x_mas(row, col)
    return false if out_of_bounds(row - 1, col - 1) || out_of_bounds(row + 1, col + 1)

    check_pair(@word_search[row - 1][col - 1], @word_search[row + 1][col + 1]) &&
      check_pair(@word_search[row - 1][col + 1], @word_search[row + 1][col - 1])
  end

  # Check a diagonal pair or either M-S or S-M
  def check_pair(char1, char2)
    (char1 == 'S' && char2 == 'M') || (char1 == 'M' && char2 == 'S')
  end

  def out_of_bounds(row, col)
    row.negative? || (row > @max_row) || col.negative? || (col > @max_col)
  end
end

Solve.new
