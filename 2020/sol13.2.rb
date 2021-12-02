# frozen_string_literal: true

require 'byebug'

# ruby sol13.2.rb in13 266204453798577
# Answer = 266204454441577
# ruby sol13.2.rb in13 <starting number>
class Solve
  @time = 0

  def solve_it(file)
    fd = File.open(file)
    @time = fd.readline.chomp.to_i # => 939 (ignored)

    # Read the second line in and produce an array of frequencies and offsets => [[7, 0], [13, 1], [59, 4], [31, 6], [19, 7]]
    schedule = fd.readline.chomp.split(',')
    max = schedule.map(&:to_i).max # => 59
    buses = schedule.each_with_index.map { |v, i| v == 'x' ? nil : [v.to_i, i] }.compact # => [[7, 0], ...]

    increment_bus = buses.select { |v| v[0] == max }.flatten # Bus with longest increment
    other_buses = buses.reject { |v| v[0] == max } # Remove longest running bus as that'll be our increment

    increment = increment_bus[0]
    # @time = increment_bus[0]-increment_bus[1]
    @time = ARGV[1].to_i
    # byebug
    #    @time = 100000000000386
    # 2020-12-13 14:07:01 +0000,  Time=117978734547374
    loop do
      @time += increment
      winner = true
      other_buses.each do |f, i|
        winner = ((@time + i) % f).zero?
        break unless winner
      end
      #      exit if @time > 1000000000
      next unless winner

      puts "Answer = #{@time}"
      exit
    end
  end

  def display_progress
    puts Time.now.to_s + ",  Time=#{@time}"
  end
end

file = ARGV[0]
if file.nil? || file.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in13"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress }
s.solve_it(file)
