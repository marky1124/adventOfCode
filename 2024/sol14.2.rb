# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DEPTH = 103 # 11 # 103
  WIDTH = 101 # 7 # 101

  def initialize
    @answer = 0
    process_file(ARGV[0] || 'in14')
    walk_robots_onwards
  end

  def process_file(file)
    @robot_pos = []
    @robot_vec = []
    File.readlines(file, chomp: true).each do |line|
      case line
      when /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/
        @robot_pos << [::Regexp.last_match(2).to_i, ::Regexp.last_match(1).to_i]
        @robot_vec << [::Regexp.last_match(4).to_i, ::Regexp.last_match(3).to_i]
      end
    end
    @mid_col = WIDTH / 2
  end

  def walk_robots_onwards
    loop.with_index do |_, step_number|
      @robot_pos.map!.with_index do |pos, idx|
        new_row = (pos[0] + @robot_vec[idx][0]) % DEPTH
        new_col = (pos[1] + @robot_vec[idx][1]) % WIDTH
        [new_row, new_col]
      end
      display_map(step_number)
    end
  end

  # The lack of a known target picture means I first attempted to find
  # an image that was symmetrical around the middle column. That didn't
  # work after working through 100,000 permutations.
  # This working approach only displays images when all of the robots
  # are in unique positions. The first time this happens is the solution
  def display_map(step_number)
    puts "step_number = #{step_number}" if (step_number % 1000) == 0

    return unless @robot_pos.uniq.length == @robot_pos.length

    lines = []
    DEPTH.times do |row|
      line = ""
      WIDTH.times do |col|
        line += (@robot_pos.include?([row,col]) ? "*" : ".")
      end
      # left = line[0..@mid_col-1]
      # right = line[@mid_col+1..].reverse
      # return unless left == right
      lines << line
    end

    clear_screen
    puts "Robot positions after #{step_number + 1} step(s)"
    puts ""
    lines.each { |line| puts line }
    puts ""
    puts "Press ENTER to continue..."
    STDIN.gets
  end

  def clear_screen
    print "\e[H\e[2J"
  end

  def robots_per_quadrant
    @quadrant = Array.new(4, 0)
    mid_col = WIDTH / 2
    mid_row = DEPTH / 2
    @robot_pos.each do |pos|
      @quadrant[0] += 1 if pos[0] < mid_row && pos[1] < mid_col
      @quadrant[1] += 1 if pos[0] < mid_row && pos[1] > mid_col
      @quadrant[2] += 1 if pos[0] > mid_row && pos[1] < mid_col
      @quadrant[3] += 1 if pos[0] > mid_row && pos[1] > mid_col
    end
  end
end

Solve.new
