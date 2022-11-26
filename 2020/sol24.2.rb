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

    day = 0
    100.times do
      day += 1
      # Only keep the black tiles in the @grid hash
      @grid.select! { |k| @grid[k] == 1 }
      # puts "@grid = #{@grid.inspect}"
      # puts "Answer is #{@grid.length}"

      # Apply swapping rules, we only track black tiles
      flip_keys = []
      adjacent_whites = []
      @grid.each_key do |k|
        # We swap black tiles if they have 0 or 2+ adjacent black tiles
        n = count_adjacent(k, 1)
        flip_keys.push(k) if n.zero? || n > 2
        adjacents = return_adjacent(k)
        adjacents.select! { |ak| @grid[ak].zero? }
        adjacent_whites += adjacents unless adjacents.nil?
        # puts "#{k} => adjacent_whites += #{adjacents}"
      end

      # Look at each uniq white tile that is next to a black to decide whether to flip it
      adjacent_whites.uniq.each do |ak|
        n = count_adjacent(ak, 1)
        flip_keys.push(ak) if n == 2
      end

      # Now do the flips.
      flip_keys.each { |k| @grid[k] = 1 - @grid[k] }
      # Only keep the black tiles in the @grid hash
      @grid.select! { |k| @grid[k] == 1 }
      # puts "@grid = #{@grid.inspect}"
      puts "Day #{day}, Answer is #{@grid.length}"
    end
  end

  def count_adjacent(key, value)
    x, y = key.split(',').map(&:to_i)
    count = 0
    count += 1 if @grid["#{x - 1},#{y - 1}"] == value
    count += 1 if @grid["#{x - 1},#{y}"] == value
    count += 1 if @grid["#{x},#{y - 1}"] == value
    count += 1 if @grid["#{x},#{y + 1}"] == value
    count += 1 if @grid["#{x + 1},#{y}"] == value
    count += 1 if @grid["#{x + 1},#{y + 1}"] == value
    count
  end

  def return_adjacent(key)
    x, y = key.split(',').map(&:to_i)
    ret = []
    ret.push("#{x - 1},#{y - 1}")
    ret.push("#{x - 1},#{y}")
    ret.push("#{x},#{y - 1}")
    ret.push("#{x},#{y + 1}")
    ret.push("#{x + 1},#{y}")
    ret.push("#{x + 1},#{y + 1}")
    ret
  end
end

filename = ARGV[0] || 'in24'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress } if RUBY_PLATFORM =~ /darwin/ # Reacts to CTRL-T on OS X (ArgumentError in Debian)
s.solve_it(filename)
