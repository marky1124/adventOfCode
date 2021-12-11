# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Puzzle
  def initialize
    @octopus = []
  end

  def solve_it(filename)
    @octopus = File.readlines(filename, chomp: true).map { |l| l.chars.map(&:to_i) }
    # @octopus => [[5, 4, 8, 3, 1, 4, 3, 2, 2, 3], ...]
    step = 0
    loop do
      step += 1
      add_one
      flashed = [] # List of octopi that have flashed so far this cycle
      loop do
        (ready_to_flash_octopi - flashed).each do |location|
          neighbours(*location).each { |r, c| @octopus[r][c] += 1 }
          flashed.append(location)
        end
        break if (ready_to_flash_octopi - flashed).empty?
      end
      break if flashed.length == 100

      flashed.each { |r, c| @octopus[r][c] = 0 }
    end
    puts "Answer is #{step}"
  end

  # Increase the energy level of all octopus by 1
  def add_one
    @octopus.each_index do |row|
      @octopus[row].each_index do |col|
        @octopus[row][col] += 1
      end
    end
  end

  # Return the locations of all octopus with energy>9
  def ready_to_flash_octopi
    ready = []
    @octopus.each_index do |row|
      @octopus[row].each_index do |col|
        ready += [[row, col]] if @octopus[row][col] > 9
      end
    end
    ready
  end

  # Return the locations of all neighbours
  def neighbours(row, col)
    neighbours = []
    (-1..1).each do |r|
      (-1..1).each do |c|
        next if (row + r).negative? || row + r >= @octopus.length
        next if (col + c).negative? || col + c >= @octopus[0].length
        next if r.zero? && c.zero?

        neighbours.append([row + r, col + c])
      end
    end
    neighbours
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

p = Puzzle.new
p.solve_it(filename)
