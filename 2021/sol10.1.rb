# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Puzzle
  def initialize
    @openers = '({[<'
    @closer = { '(' => ')', '{' => '}', '[' => ']', '<' => '>' }
    @score = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }
  end

  def solve_it(filename)
    answer = 0
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
            answer += @score[c]
          end
        end
        break if input.empty?
      end
    end
    puts "Answer is #{answer}"
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
