# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def it
    cards = Hash.new(1)
    File.readlines(ARGV[0] || 'in04', chomp: true).each_with_index do |line, idx|
      card_number = idx + 1
      cards[card_number] = 1 unless cards.keys.include?(card_number)

      (1..number_of_matches(line)).each do |delta|
        cards[card_number + delta] += cards[card_number]
      end
    end
    puts "Part 2 answer = #{cards.values.sum}"
  end

  private

  # Given a game line such as 'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'
  # The left list of numbers are winning numbers
  # The right list of numbers are your numbers
  # Return the number of winning numbers in your numbers
  def number_of_matches(line)
    number_lists = line.gsub(/^.*: /, '').split('|')
    winning_numbers = number_lists[0].split.map(&:to_i)
    card_numbers = number_lists[1].split.map(&:to_i)
    matching_numbers = winning_numbers & card_numbers
    matching_numbers.length
  end
end

Solve.new.it
