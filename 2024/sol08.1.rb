# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in08')
    find_antennas
    calculate_antinodes
    puts "Answer = #{@antinodes.count}"
  end

  def process_file(file)
    @map = File.readlines(file, chomp: true).map(&:chars)
    @max_row = @map[0].length - 1
    @max_col = @map.length - 1
  end

  def find_antennas
    @antennas = Hash.new { |hash, key| hash[key] = [] }
    @map.each_with_index do |row, ridx|
      row.each_with_index do |char, cidx|
        @antennas[char] << [ridx, cidx] unless char == '.'
      end
    end
  end

  def calculate_antinodes
    @antinodes = []
    @antennas.each_value do |locations|
      locations.combination(2).each do |location1, location2|
        delta_row = location1[0] - location2[0]
        delta_col = location1[1] - location2[1]
        antinode1 = [location1[0] + delta_row, location1[1] + delta_col]
        antinode2 = [location2[0] - delta_row, location2[1] - delta_col]
        @antinodes << antinode1 unless out_of_bounds(antinode1)
        @antinodes << antinode2 unless out_of_bounds(antinode2)
      end
    end
    @antinodes.uniq!
  end

  def out_of_bounds(location)
    location[0].negative? || (location[0] > @max_row) || location[1].negative? || (location[1] > @max_col)
  end
end

Solve.new
