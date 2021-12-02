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
    position = [0, 0]
    waypoint = [10, -1]
    instructions = File.readlines(ARGV[0], chomp: true)
    instructions.each do |instruction|
      distance = instruction[1..].to_i
      case instruction[0]
      when 'N'
        waypoint = move(waypoint, @directions[NORTH], distance)
      when 'S'
        waypoint = move(waypoint, @directions[SOUTH], distance)
      when 'E'
        waypoint = move(waypoint, @directions[EAST], distance)
      when 'W'
        waypoint = move(waypoint, @directions[WEST], distance)
      when 'F'
        position = move(position, waypoint, distance)
      when 'R'
        waypoint = rotate_right(waypoint, distance / 90)
      when 'L'
        waypoint = rotate_left(waypoint, distance / 90)
      end
      puts "Instruction #{instruction} -> position=#{position}, waypoint=#{waypoint}"
    end
    puts "Final position is #{position}"
    puts "Answer = #{position[0].abs + position[1].abs}"
  end

  def rotate_left(waypoint, rotations)
    rotations.times do
      tmp = waypoint[0]
      waypoint[0] = waypoint[1]
      waypoint[1] = -tmp
    end
    waypoint
  end

  def rotate_right(waypoint, rotations)
    rotations.times do
      tmp = waypoint[0]
      waypoint[0] = -waypoint[1]
      waypoint[1] = tmp
    end
    waypoint
  end

  def move(position, vector, distance)
    position[0] = position[0] + (vector[0] * distance)
    position[1] = position[1] + (vector[1] * distance)
    position
  end
end

Solve.new
