# frozen_string_literal: true

#  Solve an https://adventofcode.com puzzle
class Puzzle
  def initialize
    @cubes = {} # true === active
    @cycle = 0
    @next_cubes = {} # Used when calculating the next cycle
    @starting_state_width = 0
  end

  def process_input(filename)
    z = 0
    w = 0
    lines = File.readlines(filename, chomp: true)
    @starting_state_width = lines[0].length
    lines.each_with_index do |line, lindex|
      line.chars.each_with_index do |char, cindex|
        @cubes["#{lindex},#{cindex},#{z},#{w}"] = char == '#'
      end
    end
  end

  def active_neighbours(pos)
    (x, y, z, w) = pos.split(',').map(&:to_i)
    # Start count at -1 if we are active, since we'll count ourselves in the loops &
    # this is quicker and more efficient than checking for x==tx && y==ty && z==tz
    count = @cubes[pos] ? -1 : 0
    (x - 1..x + 1).each do |tx|
      (y - 1..y + 1).each do |ty|
        (z - 1..z + 1).each do |tz|
          (w - 1..w + 1).each do |tw|
            count += 1 if @cubes["#{tx},#{ty},#{tz},#{tw}"]
          end
        end
      end
    end
    count
  end

  # For the sample 3x3x1x1 starting state:
  # cycle 0 = 3x3x1x1 (x-y-z-w) where x=0..2, y=0..2, z=0, w=0
  # cycle 1 = 5x5x3x3 where x=-1..3, y=-1..3, z=-1..1, w=-1..1
  # cycle 2 = 7x7x5x5 where x=-2..4, y=-2..4, z=-2..2, w=-1..1
  # For the main input 8x8x1 starting state:
  # cycle 0 = 8x8x1x1 (x-y-z-w) where x=0..7, y=0..7, z=0, w=0
  # cycle 1 = 10x10x3x3 (x-y-z-w) where x=-1..8, y=-1..8, z=-1..1, w=-1..1
  def return_empty_cubes_for_cycle(cycle)
    cubes = {}
    ((0 - cycle)..(@starting_state_width - 1 + cycle)).each do |nx|
      ((0 - cycle)..(@starting_state_width - 1 + cycle)).each do |ny|
        ((0 - cycle)..(0 + cycle)).each do |nz|
          ((0 - cycle)..(0 + cycle)).each do |nw|
            cubes["#{nx},#{ny},#{nz},#{nw}"] = false
          end
        end
      end
    end
    cubes
  end

  # Ref: https://www.reddit.com/r/adventofcode/comments/ker0wi/2020_day_17_part_1_sample_input_wrong/
  def calculate_next_generation
    @cycle += 1
    next_generation = return_empty_cubes_for_cycle(@cycle)
    next_generation.merge(@cubes)
    # Add the next expansion of the cubes (a layer of inactive surrounding the existing)
    next_generation.each do |pos, _active|
      neighbours = active_neighbours(pos)
      next_generation[pos] = if @cubes[pos]
                               (neighbours >= 2 and neighbours <= 3)
                             else
                               (neighbours == 3)
                             end
    end
    next_generation
  end

  def solve_it(filename)
    process_input(filename)
    puts "Cycle #{@cycle} = #{@cubes}"
    puts "Cycle #{@cycle} = count = #{@cubes.select { |x| @cubes[x] }.count}"

    6.times do
      @cubes = calculate_next_generation
      puts "Cycle #{@cycle} = count = #{@cubes.select { |x| @cubes[x] }.count}"
    end

    puts "Answer = #{@cubes.select { |x| @cubes[x] }.count}"
  end
end

filename = ARGV[0] || 'in17'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in17"
  exit
end

p = Puzzle.new
p.solve_it(filename)
