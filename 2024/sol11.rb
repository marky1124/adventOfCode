# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @pebbles = File.read(ARGV[0] || 'in11').split.map(&:to_i)
    split_pebbles
  end

  def split_pebbles
    @cache = {}
    [25, 75].each do |blink_count|
      @answer = @pebbles.count
      @pebbles.each { |pebble| split_pebble(pebble, blink_count) }
      puts "Answer after #{blink_count} blinks = #{@answer}"
    end
  end

  def split_pebble(pebble, blinks)
    return if blinks.zero?

    if @cache["#{pebble},#{blinks}"]
      @answer += @cache["#{pebble},#{blinks}"]
      return
    end

    current_answer = @answer

    if pebble.zero?
      split_pebble(1, blinks - 1)

    elsif (pebble.to_s.length % 2).zero?
      pebble_string = pebble.to_s
      first_half = pebble_string[0..(pebble_string.length / 2) - 1]
      split_pebble(first_half.to_i, blinks - 1)
      second_half = pebble_string[(pebble_string.length / 2)..]
      split_pebble(second_half.to_i, blinks - 1)
      @answer += 1

    else
      split_pebble(pebble * 2024, blinks - 1)
    end

    @cache["#{pebble},#{blinks}"] = @answer - current_answer
  end
end

Solve.new
