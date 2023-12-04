# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  MAX_CUBES = Hash.new(0).merge('red' => 12, 'green' => 13, 'blue' => 14)

  def it
    answer = 0
    File.readlines(ARGV[0] || 'in02', chomp: true).each do |line|
      game_number = line.match(/^Game (\d+):/) { |match| match[1].to_i } || 0
      answer += game_number if valid_game(line)
    end
    puts "Part 1 answer = #{answer}"
  end

  private

  # Given a game line such as 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'
  # return True or False based on whether the number of cubes seen exceeds the numbers
  # found in MAX_CUBES
  def valid_game(line)
    valid = true
    line.gsub(/^.*: /, '').split(';').each do |group|
      cubes = cube_colours(group)
      cubes.each_key do |colour|
        valid = false if cubes[colour] > MAX_CUBES[colour]
        break unless valid
      end
      break unless valid
    end
    valid
  end

  # Given a cube colour group such as '8 green, 6 blue, 20 red'
  # Return a Hash where the keys are the colours and the values
  # are the number of cubes of that colour
  # e.g. cubes = {"green"=>8, "blue"=>6, "red"=>20}
  def cube_colours(group)
    cubes = {}
    group.split(', ').each do |cubes_of_a_colour|
      number, colour = cubes_of_a_colour.split
      cubes[colour] = number.to_i
    end
    cubes
  end
end

Solve.new.it
