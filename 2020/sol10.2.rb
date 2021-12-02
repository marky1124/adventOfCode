# frozen_string_literal: true

require 'byebug'

# ruby sol10.2.rb m
# Answer is 8
# ruby sol10.2.rb in
# Answer is 19208
#
class Solve
  def initialize
    if ARGV[0].nil?
      puts "Usage: #{$PROGRAM_NAME} <file>"
      puts "  e.g: #{$PROGRAM_NAME} in10"
      exit
    end

    @jolts = File.readlines(ARGV[0], chomp: true).map(&:to_i).sort
    @end = @jolts.length
    @mem = Hash.new(Hash.new(nil))
    @meml = 0

    count = recurse(0, 0)

    puts "Answer is #{count}"
    puts "Hash length = #{@meml}"
  end

  def recurse(joltage, index)
    return @mem[joltage][index] unless @mem[joltage][index].nil?
    return 1 if index >= @end - 1

    ret = 0
    (0..2).each do |offset|
      ptr = index + offset
      next unless ptr < @end

      ret += recurse(@jolts[ptr], ptr + 1) if @jolts[ptr] <= (joltage + 3)
    end

    @mem[joltage][index] = ret
    @meml += 1
    ret
  end
end

Solve.new
