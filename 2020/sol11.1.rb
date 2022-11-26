# frozen_string_literal: true

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
      puts "Seating arrangement #{reseat}:"
      # pp newseats
      # puts
      seats.each.with_index do |row, i|
        row.each.with_index do |c, j|
          neighbours = c == '.' ? 0 : count_neighbours(seats, i, j)
          newseats[i][j] = if c == 'L' && neighbours.zero?
                             '#'
                           elsif c == '#' && neighbours >= 4
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
    if target_i.positive?
      count += 1 if target_j.positive? && seats[target_i - 1][target_j - 1] == '#'
      count += 1 if seats[target_i - 1][target_j] == '#'
      count += 1 if target_j < seats[0].length - 1 && seats[target_i - 1][target_j + 1] == '#'
    end
    count += 1 if target_j.positive? && seats[target_i][target_j - 1] == '#'
    count += 1 if target_j < seats[0].length - 1 && seats[target_i][target_j + 1] == '#'
    if target_i < seats.length - 1
      count += 1 if target_j.positive? && seats[target_i + 1][target_j - 1] == '#'
      count += 1 if seats[target_i + 1][target_j] == '#'
      count += 1 if target_j < seats[0].length - 1 && seats[target_i + 1][target_j + 1] == '#'
    end
    count
  end
end

Solve.new
