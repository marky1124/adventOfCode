# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1]].freeze

  def self.it
    @gears = Hash.new { |hash, key| hash[key] = [] }
    @schematic = File.readlines(ARGV[0] || 'in03', chomp: true).map(&:chars)
    @schematic.each_with_index do |row, row_idx|
      number = 0
      asterisks = []
      row.each_index do |col_idx|
        if @schematic[row_idx][col_idx].scan(/\d/).empty?
          asterisks.uniq!
          asterisks.each do |asterisk|
            @gears[asterisk] << number
          end
          asterisks = []
          number = 0
        else
          number *= 10
          number += @schematic[row_idx][col_idx].scan(/\d/)[0].to_i
          asterisks += adjacent_asterisks(row_idx, col_idx)
        end
      end
      next if number.zero?

      asterisks.uniq!
      asterisks.each do |asterisk|
        @gears[asterisk] << number
      end
    end

    answer1 = 0
    @gears.each_key do |key|
      next if @gears[key].length != 2

      answer1 += @gears[key][0] * @gears[key][1]
    end
    puts "Answer to part 1 = #{answer1}"
  end

  # Return array of asterisks next to this location
  private_class_method def self.adjacent_asterisks(row_idx, col_idx)
    asterisks = []
    last_in_row = @schematic[row_idx].length - 1
    last_in_col = @schematic.length - 1
    DIRS.each do |drow, dcol|
      row = row_idx + drow
      col = col_idx + dcol
      next if row.negative? || (row > last_in_row) || col.negative? || (col > last_in_col)

      asterisks << "#{row},#{col}" unless @schematic[row][col].scan(/\*/).empty?
    end
    asterisks
  end
end

Solve.it
