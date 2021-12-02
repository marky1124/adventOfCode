# frozen_string_literal: true

require 'byebug'

# class: 1-3 or 5-7
# row: 6-11 or 33-44
# seat: 13-40 or 45-50
#
# your ticket:
# 7,1,14
#
# nearby tickets:
# 7,3,47
# 40,4,50
# 55,2,20
# 38,6,12
#
#  ruby sol16.1.rb in16
class Solve
  RANGES = 1
  YOUR_TICKET = 2
  NEARBY_TICKETS = 3

  def initialize
    @valid_ranges = []
    @answer = 0
  end

  def solve_it(filename)
    fd = File.open(filename)
    state = RANGES
    until fd.eof
      line = fd.readline.chomp
      case line
      when /^your ticket:/
        state = YOUR_TICKET
        next
      when /^nearby tickets:/
        state = NEARBY_TICKETS
        next
      when /^$/
        next
      end

      case state
      when RANGES
        puts "RANGE: #{line}"
        range_numbers = line.match(/.*: (\d+)-(\d+) or (\d+)-(\d+)/).captures.map(&:to_i).each_slice(2).to_a
        # => [[1, 3], [5, 7]]
        range_numbers.each do |rn|
          @valid_ranges.push(rn[0]..rn[1])
        end

      when YOUR_TICKET
        puts "YOUR TICKET: #{line}"

      when NEARBY_TICKETS
        numbers = line.split(',').to_a.map(&:to_i)
        valid = false
        numbers.each do |n|
          @valid_ranges.each do |r|
            valid = r.include?(n)
            break if valid
          end
          unless valid
            @answer += n
            break
          end
        end
        puts "NEARBY TICKETS: #{line} - valid = #{valid}"
      end
    end

    puts "Answer = #{@answer}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in16"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress }
s.solve_it(filename)
