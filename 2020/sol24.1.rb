# frozen_string_literal: true

require 'byebug'

#       H   H          [-1,-1]   [-1,0]
#     H   H   H      [0,-1]  [0,0]   [0,1]
#       H   H           [1, 0]   [1, 1]
#
# NW = -1, -1
# NE = -1,  0
#  W =  0, -1
#  E =  0,  1
# SW =  1,  0
# SE =  1,  1
#
# e.g. NW W SW E E
# start at    0, 0
# move NW to -1,-1
# move  W to -1,-2
# move SW to  0,-2
# move  E to  0,-1
# move  E to  0, 0
#
#  ruby sol24.1.rb in24
class Solve
  def initialize
    @grid = Hash.new(0) # 0 = White, 1 = Black
  end

  def solve_it(filename)
    instruction_list = File.readlines(filename, chomp: true)
    instruction_list.each do |instruction|
      pos = [0, 0]
      ptr = 0
      while ptr < instruction.length
        # byebug
        case instruction[ptr]
        when /n/
          pos[0] -= 1
          pos[1] -= 1 if instruction[ptr + 1] == 'w'
          ptr += 2
        when /s/
          pos[0] += 1
          pos[1] += 1 if instruction[ptr + 1] == 'e'
          ptr += 2
        when /w/
          pos[1] -= 1
          ptr += 1
        when /e/
          pos[1] += 1
          ptr += 1
        end
      end
      @grid["#{pos[0]},#{pos[1]}"] = (1 - @grid["#{pos[0]},#{pos[1]}"])
    end
    puts "@grid = #{@grid.inspect}"

    puts "Answer is #{@grid.select { |k| @grid[k] == 1 }.length}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress }
s.solve_it(filename)
