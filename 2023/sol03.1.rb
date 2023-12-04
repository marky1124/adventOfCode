# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1]].freeze

  def self.it
    answer1 = 0
    @schematic = File.readlines(ARGV[0] || 'in03', chomp: true).map(&:chars)
    @schematic.each_with_index do |row, row_idx|
      number = 0
      adjacent_symbol_seen = false
      row.each_index do |col_idx|
        if @schematic[row_idx][col_idx].scan(/\d/).empty?
          answer1 += number if adjacent_symbol_seen
          number = 0
          adjacent_symbol_seen = false
        else
          number *= 10
          number += @schematic[row_idx][col_idx].scan(/\d/)[0].to_i
          adjacent_symbol_seen = true if adjacent_symbol(row_idx, col_idx)
        end
      end
    end
    puts "Answer to part 1 = #{answer1}"
  end

  # Is there a symbol adjacent to this location?
  private_class_method def self.adjacent_symbol(row_idx, col_idx)
    found_symbol = false
    last_in_row = @schematic[row_idx].length - 1
    last_in_col = @schematic.length - 1
    DIRS.each do |drow, dcol|
      row = row_idx + drow
      col = col_idx + dcol
      next if row.negative? || (row > last_in_row) || col.negative? || (col > last_in_col)

      if @schematic[row][col].scan(/\d|\./).empty?
        found_symbol = true
        break
      end
    end
    found_symbol
  end
end

Solve.it
