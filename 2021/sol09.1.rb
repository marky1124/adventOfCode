# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @hmap = []
    @lowpoints = []
  end

  def solve_it(filename)
    @hmap = File.readlines(filename, chomp: true).map { |l| l.chars.map(&:to_i) }
    # @hmap => [[2, 1, 9, 9, 9, 4, 3, 2, 1, 0], ...]
    @hmap.each_index do |row|
      @hmap[row].each_index do |col|
        neighbours = neighbours(row, col)
        @lowpoints.append([row, col]) if @hmap[row][col] < neighbours.min
      end
    end
    answer = 0
    @lowpoints.each { |row, col| answer += @hmap[row][col] + 1 }
    puts "Answer is #{answer}"
  end

  # Return the values of the horizontal and vertical neighbours
  def neighbours(row, col)
    neighbours = []
    [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |r, c|
      next if (row + r).negative? || row + r >= @hmap.length
      next if (col + c).negative? || col + c >= @hmap[0].length

      neighbours.append(@hmap[row + r][col + c])
    end
    neighbours
  end
end

filename = ARGV[0] || 'in09'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in09"
  exit
end

s = Solve.new
s.solve_it(filename)
