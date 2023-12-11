# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @nodes = {}
    process_file(ARGV[0] || 'in08')
    puts "Answer = #{find_answer}"
  end

  def find_answer
    steps_to_z = []
    starting_nodes = @nodes.keys.select { |k| k =~ /^..A/ }
    starting_nodes.each do |node|
      steps_to_z << steps_until_z(node)
    end
    steps_to_z.reduce(:lcm)
  end

  def steps_until_z(node)
    number_of_steps = 0
    loop do
      @instructions.each_char do |turn|
        node = @nodes[node][turn]
        number_of_steps += 1
        return number_of_steps if node =~ /^..Z/
      end
    end
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      case line
      when /([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)/
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
