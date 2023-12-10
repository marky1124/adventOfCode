# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  CARD_SCORES = 'AKQT98765432J'.split('').zip(1..13).to_h
  TYPES_OF_HAND = %i[five_oa_kind four_oa_kind full_house three_oa_kind two_pair one_pair high].freeze

  def initialize
    @hands = {}
    @bets = {}
    @number_of_hands = 0

    TYPES_OF_HAND.each { |hand| @hands[hand] = [] }
    process_file(ARGV[0] || 'in07')
    TYPES_OF_HAND.each { |hand| sort_hand(@hands[hand]) }
    puts "Answer = #{score_hands}"
  end

  def score_hands
    score = 0
    rank = @number_of_hands
    TYPES_OF_HAND.each do |type_of_hand|
      @hands[type_of_hand].each do |hand|
        score += @bets[hand].to_i * rank
        rank -= 1
      end
    end
    score
  end

  def sort_hand(hands)
    hands.sort_by! do |hand|
      hand.split('').map { |card| CARD_SCORES[card] }
    end
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      hand, bet = line.split(' ')
      @bets[hand] = bet
      tally = hand.each_char.tally
      jacks = tally.delete('J') || 0
      type_of_hand = if tally.empty? # JJJJJ
                       :five_oa_kind
                     elsif tally.size == 1 # AAAAA
                       :five_oa_kind
                     elsif tally.size == 2 && tally.values.max == 4 && jacks.zero? # AKKKK
                       :four_oa_kind
                     elsif tally.size == 2 && tally.values.max == 3 && jacks.zero? # AAQQQ
                       :full_house
                     elsif tally.size == 2 && tally.values.max == 3 && jacks == 1 # AAAKJ
                       :four_oa_kind
                     elsif tally.size == 2 && tally.values.max == 2 && jacks == 1 # AAKKJ
                       :full_house
                     elsif tally.size == 2 && tally.values.max == 2 && jacks == 2 # AAKJJ
                       :four_oa_kind
                     elsif tally.size == 2 && jacks == 3 # AAJJJ
                       :four_oa_kind
                     elsif tally.size == 3 && tally.values.max == 3 && jacks.zero? # AAAKQ
                       :three_oa_kind
                     elsif tally.size == 3 && tally.values.max == 2 && jacks.zero? # AAKKQ
                       :two_pair
                     elsif tally.size == 3 && tally.values.max == 2 && jacks == 1 # AAKQJ
                       :three_oa_kind
                     elsif tally.size == 3 && tally.values.max == 1 && jacks == 2 # AQKJJ
                       :three_oa_kind
                     elsif tally.size == 4 && tally.values.max == 2 && jacks.zero? # AAKQT
                       :one_pair
                     elsif tally.size == 4 && tally.values.max == 1 && jacks == 1 # AQKJT
                       :one_pair
                     elsif tally.size == 5 && jacks.zero? # AKQT9
                       :high
                     else
                       puts tally.inspect
                       puts jacks
                       puts 1 / 0
                     end
      @number_of_hands += 1
      @hands[type_of_hand] << hand
    end
  end
end

Solve.new
