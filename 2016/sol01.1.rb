# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  def self.it
    dir_ptr = 0
    cur_pos = [0, 0]
    line = File.read(ARGV[0] || 'in01', chomp: true)
    line.split(', ').each do |instruction|
      case instruction.chars.first
      when 'R'
        dir_ptr += 1
        dir_ptr = 0 if dir_ptr == DIRS.length
      when 'L'
        dir_ptr -= 1
        dir_ptr = DIRS.length - 1 if dir_ptr == -1
      else
        raise ArgumentError, 'Invalid data in input file'
      end

      distance = instruction[1..].to_i
      cur_pos[0] += (DIRS[dir_ptr][0] * distance)
      cur_pos[1] += (DIRS[dir_ptr][1] * distance)
    end
    puts "Answer for part 1 = #{cur_pos[0].abs + cur_pos[1].abs}"
  end
end

Solve.it
