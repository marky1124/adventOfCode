# frozen_string_literal: true

require 'set'

# This algorithm will take 250 days
#
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

    (0..MAX_NUM).each do |col|
      (0..MAX_NUM).each do |row|
        found_it = true
        @sensors.each_with_index do |sensor, index|
          # puts "#{col},#{row} #{sensor} #{index}"
          manhattan_distance = (sensor.first - col).abs + (sensor.last - row).abs
          if manhattan_distance <= @manhattan_distances[index]
            found_it = false
            break
          end
        end
        if found_it
          puts "Answer = #{col},#{row}"
          exit
        end
      end
    end
  end
end

Solve.new
