# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in06')
    puts "Answer = #{calc_number_of_wins}"
  end

  def calc_number_of_wins
    number_of_wins = 0
    (1..@race_duration).each do |time|
      number_of_wins += 1 if (@race_duration - time) * time > @race_distance_target
    end
    number_of_wins
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^Time: /
        @race_duration = line.gsub(/^Time: /, '').gsub(/ /, '').to_i
      when /^Distance:/
        @race_distance_target = line.gsub(/^Distance: /, '').gsub(/ /, '').to_i
      end
    end
  end
end

Solve.new
