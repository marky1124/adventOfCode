# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in06')
    winning_combos = []
    @race_durations.each_index do |i|
      winning_combos << calc_number_of_wins(@race_durations[i], @race_distance_targets[i])
    end
    puts "Answer = #{winning_combos.reduce(:*)}"
  end

  def calc_number_of_wins(duration, distance_target)
    number_of_wins = 0
    (1..duration).each do |time|
      number_of_wins += 1 if (duration - time) * time > distance_target
    end
    number_of_wins
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^Time: /
        @race_durations = line.gsub(/^Time: /, '').split.map(&:to_i)
      when /^Distance:/
        @race_distance_targets = line.gsub(/^Distance: /, '').split.map(&:to_i)
      end
    end
  end
end

Solve.new
