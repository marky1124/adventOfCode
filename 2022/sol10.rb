# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    @value_at_cycle = [1]
    x_register = 1
    File.readlines(ARGV[0] || 'in10', chomp: true).each do |line|
      @value_at_cycle << x_register
      if line.split.first == 'addx'
        x_register += line.split.last.to_i
        @value_at_cycle << x_register
      end
    end
    puts "Answer to part 1 = #{sum_signal_strengths}"
    puts "Answer to part 2 = #{generate_crt_image}"
  end

  private_class_method def self.sum_signal_strengths
    answer = 0
    (19..@value_at_cycle.length - 1).step(40).each_with_index { |i, j| answer += ((j * 40) + 20) * @value_at_cycle[i] }
    answer
  end

  private_class_method def self.generate_crt_image
    output = ''
    (0..239).each do |cycle|
      crt_pos = cycle % 40
      output += "\n" if crt_pos.zero?
      sprite_pos = @value_at_cycle[cycle]
      output += crt_pos >= sprite_pos - 1 && crt_pos <= sprite_pos + 1 ? '#' : ' '
    end
    output
  end
end

Solve.it
