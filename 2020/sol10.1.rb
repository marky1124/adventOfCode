# frozen_string_literal: true

#  ruby sol10.2.rb in10
class Solve
  def initialize
    if ARGV[0].nil?
      puts "Usage: #{$PROGRAM_NAME} <file>"
      puts "  e.g: #{$PROGRAM_NAME} in10"
      exit
    end

    jolts = File.readlines(ARGV[0], chomp: true).map(&:to_i).sort
    jolts.unshift(0)
    jolts << (jolts.max + 3)
    off_by_one = jolts.each_cons(2).select { |x, y| y == x + 1 }.length
    off_by_three = jolts.each_cons(2).select { |x, y| y == x + 3 }.length

    puts "Answer is #{off_by_one * off_by_three} (#{off_by_one}*#{off_by_three})"
  end
end

Solve.new
