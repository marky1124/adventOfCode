# frozen_string_literal: true

require 'byebug'

#  ruby sol12.2.rb in12
class Solve
  EAST = 0
  SOUTH = 1
  WEST = 2
  NORTH = 3

  def initialize
    if ARGV[0].nil?
      puts "Usage: #{$PROGRAM_NAME} <file>"
      puts "  e.g: #{$PROGRAM_NAME} in12"
      exit
    end

    @directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    facing = EAST
    position = [0, 0]
    instructions = File.readlines(ARGV[0], chomp: true)
    instructions.each do |instruction|
      distance = instruction[1..].to_i
      case instruction[0]
      when 'N'
        position = move(position, NORTH, distance)
      when 'S'
        position = move(position, SOUTH, distance)
      when 'E'
        position = move(position, EAST, distance)
      when 'W'
        position = move(position, WEST, distance)
      when 'F'
        position = move(position, facing, distance)
      when 'R'
        facing = (facing + (distance / 90)) % @directions.length
      when 'L'
        facing = (facing - (distance / 90)) % @directions.length
      end
      # puts "Instruction #{instruction} -> #{position} (facing #{facing})"
    end
    puts "Final position is #{position}"
    puts "Answer = #{position[0].abs + position[1].abs}"
  end

  def move(position, direction, distance)
    position[0] = position[0] + (@directions[direction][0] * distance)
    position[1] = position[1] + (@directions[direction][1] * distance)
    position
  end
end

Solve.new
