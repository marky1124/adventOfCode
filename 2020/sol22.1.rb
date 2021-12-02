# frozen_string_literal: true

require 'byebug'

# Player 1:
# 9
# 2
# 6
# 3
# 1
#
# Player 2:
# 5
# 8
# 4
# 7
# 10
#
#  ruby sol22.1.rb in22
class Solve
  RANGES = 1
  YOUR_TICKET = 2
  NEARBY_TICKETS = 3

  def initialize
    @cards = {}
  end

  def solve_it(filename)
    fd = File.open(filename)
    player = nil
    until fd.eof
      line = fd.readline.chomp
      case line
      when /^Player (\d):/
        player = Regexp.last_match(1)
        next
      when /^(\d+)$/
        @cards[player] = [] if @cards[player].nil?
        @cards[player].push(Regexp.last_match(1).to_i)
        next
      end
    end

    puts "@cards = #{@cards.inspect}"

    until @cards['1'].empty? || @cards['2'].empty?
      p1 = @cards['1'].shift
      p2 = @cards['2'].shift
      if p1 > p2
        @cards['1'].push(p1)
        @cards['1'].push(p2)
      else
        @cards['2'].push(p2)
        @cards['2'].push(p1)
      end
      puts "@cards = #{@cards.inspect}"
    end

    answer = 0
    cards = (@cards['1'].empty? ? @cards['2'] : @cards['1'])
    until cards.empty?
      answer += (cards[0] * cards.length)
      cards.shift
    end

    puts "Answer = #{answer}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in22"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress }
s.solve_it(filename)
