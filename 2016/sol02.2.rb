# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze
  UP, DOWN, LEFT, RIGHT = (0..3).to_a
  DIR_PTR_MAP = { 'U' => 0, 'D' => 1, 'L' => 2, 'R' => 3 }.freeze
  # KEYS = { '0,0' => 1, '0,1' => 2, '0,2' => 3,
  #          '1,0' => 4, '1,1' => 5, '1,2' => 6,
  #          '2,0' => 7, '2,1' => 8, '2,2' => 9 }.freeze
  KEYS = { '-1,3' => 1,
           '0,2' => '2', '0,3' => 3, '0,4' => 4,
           '1,1' => '5', '1,2' => '6', '1,3' => '7', '1,4' => '8', '1,5' => '9',
           '2,2' => 'A', '2,3' => 'B', '2,4' => 'C',
           '3,3' => 'D' }.freeze

  def self.it
    @cur_pos = [1, 1]
    answer = ''
    File.readlines(ARGV[0] || '../2016/in02', chomp: true).each do |line|
      line.chars.each do |letter|
        move_delta = DIRS[DIR_PTR_MAP[letter]]
        update_cur_pos(move_delta)
      end
      answer += KEYS[pos_key(@cur_pos)].to_s
    end
    puts "Answer to part 2 = #{answer}"
  end

  private_class_method def self.pos_key(position)
    "#{position[0]},#{position[1]}"
  end

  private_class_method def self.update_cur_pos(move_delta)
    new_pos = [@cur_pos[0] + move_delta[0], @cur_pos[1] + move_delta[1]]
    @cur_pos = new_pos if KEYS[pos_key(new_pos)]
  end
end

Solve.it
