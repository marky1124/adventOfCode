# frozen_string_literal: true

# Given a list of numbers count the number of times the next one is bigger
class Solve
  def solve_it(filename)
    previous = nil
    getting_deeper = 0
    File.readlines(filename, chomp: true).each do |line|
      depth = line.to_i
      getting_deeper += 1 if previous && (depth > previous)
      previous = depth
      # puts "previous = #{previous}, depth = #{depth}, getting_deeper=#{getting_deeper}"
    end

    puts "Answer is #{getting_deeper}"
  end
end

filename = ARGV[0] || 'in01'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in01"
  exit
end

s = Solve.new
s.solve_it(filename)
