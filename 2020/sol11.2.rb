# frozen_string_literal: true

require 'byebug'

#  ruby sol11.2.rb in11
class Solve
  def initialize
    if ARGV[0].nil?
      puts "Usage: #{$PROGRAM_NAME} <file>"
      puts "  e.g: #{$PROGRAM_NAME} in11"
      exit
    end

    reseat = 0
    seats = File.readlines(ARGV[0], chomp: true).map!(&:chars)
    newseats = seats.map(&:dup)
    loop do
      # puts "Seating arrangement #{reseat}:"
      # pp newseats
      # puts
      seats.each.with_index do |row, i|
        row.each.with_index do |c, j|
          # byebug if reseat == 0 && j == 6
          neighbours = c == '.' ? 0 : count_neighbours(seats, i, j)
          newseats[i][j] = if c == 'L' && neighbours.zero?
                             '#'
                           elsif c == '#' && neighbours >= 5
                             'L'
                           else
                             c
                           end
        end
      end
      reseat += 1
      break if seats == newseats

      seats = newseats.map(&:dup)
    end

    seated = seats.flatten.count('#')
    puts "Finished after shuffling #{reseat - 1} times"
    puts "Answer is #{seated} people sat down"
  end

  def count_neighbours(seats, target_i, target_j)
    count = 0
    directions = [[-1, -1], [-1, 0], [-1, 1],
                  [0, -1], [0, 1],
                  [1, -1], [1, 0], [1, 1]]
    directions.each do |d|
      i = target_i
      j = target_j
      loop do
        i += d[0]
        j += d[1]
        break if i.negative? || i >= seats.length || j.negative? || j >= seats[0].length

        if seats[i][j] == '#'
          count += 1
          break
        end
        break if seats[i][j] == 'L'
      end
    end
    count
  end
end

Solve.new
