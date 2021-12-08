# frozen_string_literal: true

require 'set'

# 7 segment digital number
#
#   aaaa
#  b    c
#  b    c
#   dddd
#  e    f
#  e    f
#   gggg
#
# The wires (named a through g) have been jumbled differently for each line of input
# The input comprises of the wire groups for each of the ten digits
# Once it's been established which wire is connected to each segment then the
# extra four numbers at the end of the line can be decoded
#
# Logic for determining which wire is connected to which segment.
#
# 1) Find the wire group with two wires, this is for number 1, those two wires will be connected to segments c + f
#    Find the wire group with three wires, this is for number 7 and will be connected to segments a + c + f
#    So the extra wire is connected to segment a
#
# The ten sample wire groups represent the 10 numbers. Knowing that we can calculate the number of times
# each segment should be lit, e.g. segment e appears in the four numbers 0, 2, 6 & 8. So the wire that
# connects to segment e will appear in the wire groups list 4 times. This is the only segment that is
# lit four times.
#
# 2) Count the number of times each wire appears in a wire group
# 3) The wire that appears 4 times is connected to segment e
# 4) The wire that appears 6 times is connected to segment b
# 5) The wire that appears 9 times is connected to segment f
# 6) Two wires appear 8 times and are connected to segments a & c. We already know a, so the other one is c
# 7) The last two wires appear 7 times each and are connected to segments d & g
#
# 8) The wire group that has 4 wires represents the number 4 and connects to segments b,c,d,f
#    We have already identified the wires for segments b,c,f so the other one is connected to segment d
#
# 9) The last wire is connected to segment g

# Solve a puzzle from https://adventofcode.com
class Solve
  def solve_it(filename)
    answer = 0
    fd = File.open(filename)
    until fd.eof
      input = fd.readline.chomp

      wiregroups = input.split('|')[0].split.sort { |a, b| a.size <=> b.size }.map! { |w| w.chars.sort.join }
      # => ["ab", "abd", "abef", "bcdef", "acdfg", "abcdf", "abcdef", "bcdefg", "abcdeg", "abcdefg"]
      codes = input.split('|')[1].split.map! { |w| w.chars.sort.join }
      # => ["bcdef", "abcdf", "bcdef", "abcdf"]
      # puts "wiregroups = #{wiregroups}"
      # puts "codes = #{codes}"
      segment = {}
      wire = {}
      wirecount = {}

      # Logic to figure out which wires are joined to which segments:
      # Step 1) Look at first two wire groups ("ab", "abd") which represents a 1 and a 7.
      #         The extra letter is the top of the 7, which is segment 'a'
      segment['a'] = wiregroups[1].delete(wiregroups[0])
      wire[segment['a']] = 'a'

      # 2) Count the number of times each wire appears in a wire group
      allwires = wiregroups.join
      'abcdefg'.chars { |letter| wirecount[letter] = allwires.count(letter) }

      # 3) The wire that appears 4 times is connected to segment e
      segment['e'] = wirecount.select { |_k, v| v == 4 }.keys[0]
      wire[segment['e']] = 'e'

      # 4) The wire that appears 6 times is connected to segment b
      segment['b'] = wirecount.select { |_k, v| v == 6 }.keys[0]
      wire[segment['b']] = 'b'

      # 5) The wire that appears 9 times is connected to segment f
      segment['f'] = wirecount.select { |_k, v| v == 9 }.keys[0]
      wire[segment['f']] = 'f'

      # 6) Two wires appear 8 times and are connected to segments a & c. We already know a, so the other one is c
      segment['c'] = wirecount.select { |_k, v| v == 8 }.keys.join.delete(segment['a'])
      wire[segment['c']] = 'c'

      # 7) The last two wires appear 7 times each and are connected to segments d & g
      # 8) The wire group that has 4 wires represents the number 4 and connects to segments b,c,d,f
      #    We have already identified the wires for segments b,c,f so the other one is connected to segment d
      lasttwowires = wirecount.select { |_k, v| v == 7 }.keys.join
      fourwiregroup = wiregroups[2]
      segment['d'] = fourwiregroup.count(lasttwowires[0]) == 1 ? lasttwowires[0] : lasttwowires[1]
      wire[segment['d']] = 'd'

      # 9) The last wire is connected to segment g
      segment['g'] = lasttwowires.delete(segment['d'])
      wire[segment['g']] = 'g'

      # puts "segment = #{segment}"
      # puts "wire = #{wire}"
      # puts "wirecount = #{wirecount}"

      # Now build a hash where the key is the encoded wiregroup for each numeric value
      digit = {}
      digit[segments_to_wires('abcefg', segment)] = 0
      digit[segments_to_wires('cf', segment)] = 1
      digit[segments_to_wires('acdeg', segment)] = 2
      digit[segments_to_wires('acdfg', segment)] = 3
      digit[segments_to_wires('bcdf', segment)] = 4
      digit[segments_to_wires('abdfg', segment)] = 5
      digit[segments_to_wires('abdefg', segment)] = 6
      digit[segments_to_wires('acf', segment)] = 7
      digit[segments_to_wires('abcdefg', segment)] = 8
      digit[segments_to_wires('abcdfg', segment)] = 9

      # puts "digit = #{digit}"

      # Now find the number for each of the four encoded wiregroups
      value = 0
      codes.each { |c| value = (value * 10) + digit[c] }

      # puts "Value is #{value}"
      answer += value
    end
    puts "Answer is #{answer}"
    fd.close
  end

  def segments_to_wires(segments, segment)
    wires = ''
    segments.chars { |s| wires += segment[s] }
    wires.chars.sort.join
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
s.solve_it(filename)
