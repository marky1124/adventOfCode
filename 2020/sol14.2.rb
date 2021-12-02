# frozen_string_literal: true

require 'byebug'

# mask = 000000000000000000000000000000X1001X
# mem[42] = 100
# mask = 00000000000000000000000000000000X0XX
# mem[26] = 1
#
# [0,1].repeated_permutation(3).to_a
# => [[0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 1, 1], [1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]
#
# > line = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
# > line.count('X')
# => 34
#
#  ruby sol14.2.rb in14
class Solve
  attr_accessor :mask, :mem

  def initialize
    @mem = {}
  end

  def solve_it(file)
    fd = File.open(file)
    until fd.eof
      line = fd.readline.chomp
      case line
      when /^mask/
        process_mask(line)
      when /^mem/
        process_mem(line)
      end
    end

    puts 'Finished processing.'
    puts "#{@mem.length} populated memory locations"
    puts 'First 10 memory locations:'
    puts '---------------------------'
    pp @mem.first(10)
    puts '---------------------------'

    puts "Answer = #{@mem.values.sum}"
  end

  def process_mask(line)
    @mask = line.split[2]
  end

  def process_mem(line)
    line.match(/mem\[(\d+)\] = (\d+)/)
    loc, value = line.match(/mem\[(\d+)\] = (\d+)/).captures
    value = value.to_i
    loc = loc.to_i.to_s(2).rjust(mask.length, '0')
    # For each '1' in mask, force to '1' in loc
    # For each 'X' in mask, force to 'X' in loc
    mask.chars.each_with_index do |mask_char, i|
      loc[i] = mask_char if (mask_char == '1') || (mask_char == 'X')
    end

    [0, 1].repeated_permutation(loc.count('X')).each do |bit_array|
      new_loc = loc.dup
      bit_array.each do |bit|
        new_loc.sub!('X', bit.to_s)
      end
      @mem[new_loc.to_i(2)] = value
    end
  end
end

file = ARGV[0]
if file.nil? || file.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in14"
  exit
end

s = Solve.new
s.solve_it(file)
