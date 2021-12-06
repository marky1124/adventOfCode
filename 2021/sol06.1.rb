# frozen_string_literal: true

# Given a list of numbers count the number of times the next one is bigger
class Solve
  def solve_it(filename, days)
    fish = File.readlines(filename, chomp: true)[0].split(',').map(&:to_i) # => [3,4,3,1,2]
    days.times do
      new_borns = fish.select(&:zero?).count
      fish.map! { |timer| timer.zero? ? 6 : timer - 1 }
      fish.concat([8] * new_borns)
    end
    puts "The answer is there are now #{fish.count} lantern fish"
  end
end

filename = ARGV[0]
days = ARGV[1].to_i
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file> <number_of_days>"
  puts "  e.g: #{$PROGRAM_NAME} in01 80"
  exit
end

s = Solve.new
s.solve_it(filename, days)
