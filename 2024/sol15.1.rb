# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }.freeze # up, down, left, right

  def initialize
    process_file(ARGV[0] || 'in15')
    find_robot
    process_moves
    puts "Answer = #{calculate_answer}"
  end

  def process_file(file)
    @map = []
    @moves = []
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^#/
        @map << line.chars
      when /^.+$/
        @moves << line.chars
      end
    end
    @moves.flatten!
  end

  def find_robot
    @map.each_index do |row_idx|
      next unless (col_idx = @map[row_idx].find_index('@'))

      @robot_pos = [row_idx, col_idx]
      break
    end
  end

  def process_moves
    @moves.each do |dir|
      next_position = next_position(@robot_pos, dir)
      case @map.dig(*next_position)
      when '#'
        next
      when '.'
        @map[next_position[0]][next_position[1]] = '@'
        @map[@robot_pos[0]][@robot_pos[1]] = '.'
        @robot_pos = next_position
      when 'O'
        next unless (free_pos = free_space_location(dir))

        @map[free_pos[0]][free_pos[1]] = 'O'
        @map[next_position[0]][next_position[1]] = '@'
        @map[@robot_pos[0]][@robot_pos[1]] = '.'
        @robot_pos = next_position
      end
    end
  end

  def free_space_location(dir)
    pos = @robot_pos
    loop do
      pos = next_position(pos, dir)
      @map.dig(*pos)
      case @map.dig(*pos)
      when '#'
        return
      when '.'
        return pos
      end
    end
    raise 'Unexpected situation. The coder did not expect the code to get here'
  end

  def next_position(pos, dir)
    [pos[0] + DIRS[dir][0], pos[1] + DIRS[dir][1]]
  end

  def calculate_answer
    answer = 0
    @map.each_with_index do |row, row_idx|
      row.each_with_index do |value, col_idx|
        answer += (row_idx * 100) + col_idx if value == 'O'
      end
    end
    answer
  end
end

Solve.new
