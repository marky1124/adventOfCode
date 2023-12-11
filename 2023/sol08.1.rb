# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @nodes = {}
    process_file(ARGV[0] || 'in08')
    puts "Answer = #{steps_until_end}"
  end

  def steps_until_end
    cur = 'AAA'
    number_of_steps = 0
    loop do
      @instructions.each_char do |turn|
        cur = @nodes[cur][turn]
        number_of_steps += 1
        return number_of_steps if cur == 'ZZZ'
      end
    end
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      case line
      when /([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/
        @nodes[::Regexp.last_match(1)] = {}
        @nodes[::Regexp.last_match(1)]['L'] = ::Regexp.last_match(2)
        @nodes[::Regexp.last_match(1)]['R'] = ::Regexp.last_match(3)
      when /^[LR]+$/
        @instructions = line
      end
    end
  end
end

Solve.new
