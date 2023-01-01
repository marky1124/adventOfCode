# frozen_string_literal: true

require 'set'

# Sensor at x=2, y=18: closest beacon is at x=-2, y=15
# Sensor at x=9, y=16: closest beacon is at x=10, y=16

# Solve a puzzle from https://adventofcode.com
class Solve
  MAX_NUM = 4_000_000

  def initialize
    @sensors = []
    @beacons = []
    @manhattan_distances = []
    File.readlines(ARGV[0] || 'in15', chomp: true).each do |line|
      line[/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/]
      scol, srow, bcol, brow = Regexp.last_match.captures
      @sensors << [scol.to_i, srow.to_i]
      @beacons << [bcol.to_i, brow.to_i]
    end

    @sensors.each_with_index do |sensor, i|
      @manhattan_distances << (sensor.first - @beacons[i].first).abs + (sensor.last - @beacons[i].last).abs
    end

    (0..MAX_NUM).each do |row|
      ranges = []
      @sensors.each_with_index do |sensor, index|
        delta = (@manhattan_distances[index] - (sensor.last - row).abs)
        next if delta.negative?

        range = (sensor.first - delta)..(sensor.first + delta)
        ranges << range
      end
      ranges.sort! { |a, b| a.first <=> b.first }
      current = ranges[0]
      if current.first.positive?
        puts "There is a gap at the start, first range is #{current}"
        exit
      end
      ranges.each do |range|
        next if range.last < current.last      # This range is within the current one

        if range.first <= current.last + 1
          if range.last > current.last         # This range extends the previous one
            current = range
            next
          end
        else
          puts "We have found a gap between #{current} and #{range}"
          puts "No beacon at #{current.last + 1},#{row}"
          puts "Answer = #{(current.last + 1) * 4_000_000 + row}"
          exit
        end
      end
      if current.last < MAX_NUM
        puts "There is a gap at the end, last range is #{current}"
        exit
      end
    end
  end
end

Solve.new
