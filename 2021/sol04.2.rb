# frozen_string_literal: true

require 'set' # Not required from Ruby 3.0

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @bingo_cards = []
    @numbers_to_be_called = []
    @numbers_called = Set[]
    @file_input = []
  end

  def solve_it(filename)
    read_input_file(filename)
    create_bingo_cards
    @numbers_to_be_called.each do |number|
      @numbers_called.add(number)
      next if @numbers_called.size < @bingo_cards[0].size # No point checking yet

      while (winning_card = check_for_winning_card)
        break if @bingo_cards.size == 1

        @bingo_cards.delete(winning_card)
      end
      next unless winning_card

      display_answer(winning_card, number)
      exit
    end
  end

  def read_input_file(filename)
    @file_input = File.readlines(filename, chomp: true)
    @numbers_to_be_called = @file_input.shift.split(',').map(&:to_i)
  end

  def display_answer(winning_card, number)
    puts "The last winning card is #{winning_card}"
    puts "The numbers called were #{@numbers_called}"
    puts "The last number called was #{number}"
    sum_of_unmarked_numbers = winning_card.flatten.reject { |num| @numbers_called.include?(num) }.sum
    puts "The sum of the unmarked numbers on the winning card was #{sum_of_unmarked_numbers}"
    puts "Answer = #{sum_of_unmarked_numbers * number}"
  end

  # Look for a complete row or column in the bingo cards
  # Return the card that has won or nil
  def check_for_winning_card
    @bingo_cards.each do |bingo_card|
      # Check rows
      bingo_card.each do |row|
        return bingo_card if row.reject { |num| @numbers_called.include?(num) }.empty?
      end

      # Check columns
      bingo_card.transpose.each do |col|
        return bingo_card if col.reject { |num| @numbers_called.include?(num) }.empty?
      end
    end
    nil
  end

  # Convert the file input into a two dimensional array of bingo cards
  # e.g.
  # [[[22, 13, 17, 11, 0], [8, 2, 23, 4, 24], [21, 9, 14, 16, 7], [6, 10, 3, 18, 5], [1, 12, 20, 15, 19]],
  #  [[3, 15, 0, 2, 22], [9, 18, 13, 17, 5], [19, 8, 7, 25, 23], [20, 11, 10, 24, 4], [14, 21, 16, 12, 6]],
  #  [[14, 21, 17, 24, 4], [10, 16, 15, 9, 19], [18, 8, 23, 26, 20], [22, 11, 13, 6, 5], [2, 0, 12, 3, 7]]]
  def create_bingo_cards
    @bingo_cards = []
    @file_input.each do |row|
      if row.empty?
        @bingo_cards.append([])
      else
        @bingo_cards.last.append(row.split.map(&:to_i))
      end
    end
  end
end

filename = ARGV[0] || 'in04'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in04"
  exit
end

s = Solve.new
s.solve_it(filename)
