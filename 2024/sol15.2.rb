# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }.freeze # up, down, left, right

  def initialize
    process_file(ARGV[0] || 'in15')
    find_robot
    # print_map
    process_moves
    # print_map
    puts "Answer = #{calculate_answer}"
  end

  def print_map
    @map.each { |m| puts m.join }
    nil
  end

  def process_file(file)
    @map = []
    @moves = []
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^#/
        @map << line.gsub('#', '##').gsub('.', '..').gsub('O', '[]').gsub('@', '@.').chars
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
      when '[', ']'
        if ['>', '<'].include?(dir)
          @robot_pos = next_position if push_horizontal(next_position, dir)
        elsif dir == '^'
          @locations_to_shift = []
          @robot_pos = next_position if push_up(@robot_pos, dir)
        else
          @locations_to_shift = []
          @robot_pos = next_position if push_down(@robot_pos, dir)
        end
      end
    end
  end

  def push_down(next_position, dir)
    return unless free_space_down(next_position, dir)

    shift_down
    true
  end

  def shift_down
    @locations_to_shift = @locations_to_shift.uniq.sort { |a, b| b[0] <=> a[0] }
    @locations_to_shift.each do |pos|
      pos_below = [pos[0] + 1, pos[1]]
      @map[pos_below[0]][pos_below[1]] = @map.dig(*pos)
      @map[pos[0]][pos[1]] = '.'
    end
  end

  def free_space_down(pos, dir)
    char = @map.dig(*pos)
    @locations_to_shift << pos if ['[', ']', '@'].include?(char)

    next_pos = next_position(pos, dir)
    next_char = @map.dig(*next_pos)

    return false if next_char == '#'
    return true if ['.', '@'].include?(next_char)

    return unless ['[', ']'].include?(next_char)

    offset = next_char == '[' ? 1 : -1
    free_space_down(next_pos, dir) && free_space_down([next_pos[0], next_pos[1] + offset], dir)
  end

  def push_up(next_position, dir)
    return unless free_space_up(next_position, dir)

    shift_up
    true
  end

  def shift_up
    @locations_to_shift = @locations_to_shift.uniq.sort { |a, b| a[0] <=> b[0] }
    @locations_to_shift.each do |pos|
      pos_above = [pos[0] - 1, pos[1]]
      @map[pos_above[0]][pos_above[1]] = @map.dig(*pos)
      @map[pos[0]][pos[1]] = '.'
    end
  end

  def free_space_up(pos, dir)
    char = @map.dig(*pos)
    @locations_to_shift << pos if ['[', ']', '@'].include?(char)

    next_pos = next_position(pos, dir)
    next_char = @map.dig(*next_pos)

    return false if next_char == '#'
    return true if ['.', '@'].include?(next_char)

    return unless ['[', ']'].include?(next_char)

    offset = next_char == '[' ? 1 : -1
    free_space_up(next_pos, dir) && free_space_up([next_pos[0], next_pos[1] + offset], dir)
  end

  def push_horizontal(next_position, dir)
    return unless (free_pos = free_space_horizontal(dir))

    @map[next_position[0]].tap { |m| m.delete_at(free_pos[1]) }.insert(@robot_pos[1], '.')
  end

  def free_space_horizontal(dir)
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
  end

  def next_position(pos, dir)
    [pos[0] + DIRS[dir][0], pos[1] + DIRS[dir][1]]
  end

  def calculate_answer
    answer = 0
    @map.each_with_index do |row, row_idx|
      row.each_with_index do |value, col_idx|
        answer += (row_idx * 100) + col_idx if value == '['
      end
    end
    answer
  end
end

Solve.new
