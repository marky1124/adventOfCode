# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def it
    answer = 0
    File.readlines(ARGV[0] || 'in02', chomp: true).each do |line|
      cubes = minimum_cubes(line)
      answer += cubes.values.reduce(:*)
    end
    puts "Part 2 answer = #{answer}"
  end

  private

  # Given a game line such as 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'
  # return a Hash containing the minimum number of cubes that could be valid
  # e.g. {"green"=>2, "blue"=>6, "red"=>4}
  def minimum_cubes(line)
    cubes = Hash.new(0)
    line.gsub(/^.*: /, '').split(';').each do |group|
      group.split(', ').each do |cubes_of_a_colour|
        number, colour = cubes_of_a_colour.split
        cubes[colour] = number.to_i if number.to_i > cubes[colour]
      end
    end
    cubes
  end
end

Solve.new.it
