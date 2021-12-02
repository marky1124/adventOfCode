# frozen_string_literal: true

require 'byebug'

# mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
# mem[8] = 11
# mem[7] = 101
# mem[8] = 0
#
#  ruby sol14.1.rb in14
class Solve
  attr_accessor :and_mask, :or_mask, :mem

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

    puts 'Finished processing. Mem = '
    puts '---------------------------'
    pp @mem
    puts '---------------------------'

    puts "Answer = #{@mem.values.sum}"
  end

  def process_mask(line)
    @and_mask = line.split[2].gsub('X', '1').to_i(2)
    @or_mask = line.split[2].gsub('X', '0').to_i(2)
  end

  def process_mem(line)
    line.match(/mem\[(\d+)\] = (\d+)/)
    loc, value = line.match(/mem\[(\d+)\] = (\d+)/).captures
    @mem[loc] = ((value.to_i & @and_mask) | @or_mask)
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
