# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  def self.it
    dir_ptr = 0
    cur_pos = [0, 0]
    visited = {}
    line = File.read(ARGV[0] || 'in01', chomp: true)
    line.split(', ').each do |instruction|
      dir_ptr = new_dir_ptr(instruction.chars.first, dir_ptr)

      # puts "Turn #{instruction.chars.first} then #{instruction[1..].to_i} paces"
      instruction[1..].to_i.times do
        cur_pos[0] += DIRS[dir_ptr][0]
        cur_pos[1] += DIRS[dir_ptr][1]
        if visited.keys.include?(pos_key(cur_pos))
          puts "Answer = #{cur_pos[0].abs + cur_pos[1].abs} (#{cur_pos})"
          exit

        end
        visited[pos_key(cur_pos)] = true
      end
    end
  end

  private_class_method def self.pos_key(cur_pos)
    "#{cur_pos[0]},#{cur_pos[1]}"
  end

  private_class_method def self.new_dir_ptr(rotate, dir_ptr)
    dir_ptr += rotate == 'R' ? 1 : -1
    dir_ptr = 0 if dir_ptr == DIRS.length
    dir_ptr = DIRS.length - 1 if dir_ptr == -1
    dir_ptr
  end
end

Solve.it
