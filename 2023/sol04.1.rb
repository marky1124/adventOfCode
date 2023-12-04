# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def it
    answer = 0
    File.readlines(ARGV[0] || 'in04', chomp: true).each do |line|
      answer += card_value(line)
    end
    puts "Part 1 answer = #{answer}"
  end

  private

  # Given a game line such as 'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'
  # The left list of numbers are winning numbers
  # The right list of numbers are your numbers
  # Card value is 2^(number_of_matching_numbers-1)
  def card_value(line)
    number_lists = line.gsub(/^.*: /, '').split('|')
    winning_numbers = number_lists[0].split.map(&:to_i)
    card_numbers = number_lists[1].split.map(&:to_i)
    matching_numbers = winning_numbers & card_numbers
    number_of_matches = matching_numbers.length
    if number_of_matches.positive?
      2**(number_of_matches - 1)
    else
      0
    end
  end
end

Solve.new.it
