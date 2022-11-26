# frozen_string_literal: true

# Given a list of numbers count the number of times the next one is bigger
class Solve
  def initialize
    @shoal = {}
  end

  def solve_it(filename, days)
    fish = File.readlines(filename, chomp: true)[0].split(',').map(&:to_i) # => [3,4,3,1,2]
    @shoal = fish.group_by(&:itself) #=> {3=>[3, 3], 4=>[4], 1=>[1], 2=>[2]}
    @shoal.each { |timer, v| @shoal[timer] = v.count } #=> {3=>2, 4=>1, 1=>1, 2=>1}
    # shoal is a Hash where the values tell you how many lantern fish exist in the
    # shoal with that key, where the key is the timer.
    days.times { @shoal = calculate_next_shoal }
    count = 0
    @shoal.each_value { |quantity| count += quantity }
    puts "The answer is there are now #{count} lantern fish"
  end

  def calculate_next_shoal
    next_shoal = {}
    new_borns = @shoal[0]
    @shoal.each { |timer, quantity| next_shoal[timer - 1] = quantity }
    if next_shoal[-1]
      next_shoal[6] ||= 0
      next_shoal[6] += next_shoal.delete(-1) if next_shoal[-1]
    end
    next_shoal[8] = new_borns unless new_borns.nil?
    next_shoal
  end
end

filename = ARGV[0] || 'in06'
days = (ARGV[1] || 256).to_i
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file> <number_of_days>"
  puts "  e.g: #{$PROGRAM_NAME} in06 256"
  exit
end

s = Solve.new
s.solve_it(filename, days)
