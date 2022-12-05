# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  PARSE_STACKS = 0
  PROCESS_MOVES = 1

  # stacks[1] = ['N', 'Z']
  # stacks[2] = ['D', 'C', 'M']
  # stacks[3] = ['P']
  def self.it
    stacks = Hash.new { |h, k| h[k] = [] }
    state = PARSE_STACKS
    File.readlines(ARGV[0] || 'in05', chomp: true).each do |line|
      next if line.empty?

      case state
      when PARSE_STACKS
        if line[1] == '1'
          state = PROCESS_MOVES
          next
        end
        (1..line.length).step(4).each_with_index do |line_index, stack_number|
          stacks[stack_number + 1].push line[line_index] unless line[line_index] == ' '
        end
      when PROCESS_MOVES
        number_to_move, from, to = /move (\d+) from (\d) to (\d)/.match(line).captures.map(&:to_i)
        tmp = stacks[from].shift(number_to_move)
        stacks[to].unshift(tmp).flatten!
      end
    end

    puts "Answer = #{stacks.keys.sort.map { |k| stacks[k][0] }.join}"
  end
end

Solve.it
