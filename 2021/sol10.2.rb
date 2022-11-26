# frozen_string_literal: true

require 'byebug'
# Solve a puzzle from https://adventofcode.com
class Puzzle
  def initialize
    @openers = '({[<'
    @closer = { '(' => ')', '{' => '}', '[' => ']', '<' => '>' }
    @score = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
    @scores = []
  end

  def solve_it(filename)
    fd = File.open(filename)
    until fd.eof
      line = fd.readline.chomp
      input = line.chars
      expect = []
      loop do
        c = input.shift
        if @openers.include?(c)
          expect.append(@closer[c])
        else
          c_should_be = expect.pop
          if c != c_should_be
            puts "line #{line} - Expected #{c_should_be}, but found #{c} instead"
            break
          end
        end
        next unless input.empty?

        # Found a valid but incomplete line, score it and move on
        score = 0
        expect.reverse.each do |e|
          score *= 5
          score += @score[e]
        end
        puts "line #{line} - Incomplete remaining should be #{expect.join.reverse} - scoring #{score}"
        @scores.append(score)
        break
      end
    end
    @scores.sort!
    puts "Scores = #{@scores}"
    puts "Answer is #{@scores[@scores.length / 2]}"
    fd.close
  end
end

filename = ARGV[0] || 'in10'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in10"
  exit
end

p = Puzzle.new
p.solve_it(filename)
