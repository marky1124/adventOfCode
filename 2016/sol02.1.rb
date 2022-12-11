# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze
  UP, DOWN, LEFT, RIGHT = (0..3).to_a
  DIR_PTR_MAP = { 'U' => 0, 'D' => 1, 'L' => 2, 'R' => 3 }.freeze
  KEYS = { '0,0' => 1, '0,1' => 2, '0,2' => 3, '1,0' => 4, '1,1' => 5, '1,2' => 6, '2,0' => 7, '2,1' => 8, '2,2' => 9 }.freeze

  def self.it
    @cur_pos = [1, 1]
    answer = ''
    File.readlines(ARGV[0] || '../2016/in02', chomp: true).each do |line|
      line.chars.each do |letter|
        move_delta = DIRS[DIR_PTR_MAP[letter]]
        update_cur_pos(move_delta)
        # puts "letter #{letter}, cur_pos is now #{@cur_pos}"
      end
      # puts "Key at #{@cur_pos}, which is #{KEYS[pos_key]}"
      answer += KEYS[pos_key].to_s
    end
    puts "Answer to part 1 = #{answer}"
  end

  private_class_method def self.pos_key
    "#{@cur_pos[0]},#{@cur_pos[1]}"
  end

  private_class_method def self.update_cur_pos(move_delta)
    x, y = @cur_pos
    dx, dy = move_delta
    x -= 1 if dx.negative? && x.positive?
    x += 1 if dx.positive? && x < 2
    y -= 1 if dy.negative? && y.positive?
    y += 1 if dy.positive? && y < 2
    @cur_pos = [x, y]
  end
end

Solve.it
