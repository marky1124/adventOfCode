# frozen_string_literal: true

require 'set'

# Sensor at x=2, y=18: closest beacon is at x=-2, y=15
# Sensor at x=9, y=16: closest beacon is at x=10, y=16

# Solve a puzzle from https://adventofcode.com
class Solve
  ROW = 2_000_000

  def initialize
    @sensors = []
    @beacons = []
    @no_beacons_y = Set[]
    File.readlines(ARGV[0] || 'in15', chomp: true).each do |line|
      line[/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/]
      scol, srow, bcol, brow = Regexp.last_match.captures
      @sensors << [scol.to_i, srow.to_i]
      @beacons << [bcol.to_i, brow.to_i]
    end

    (0..@sensors.count - 1).each { |i| impact_on_row(*@sensors[i], *@beacons[i]) }

    (@sensors + @beacons).each do |col, row|
      @no_beacons_y.delete(col) if row == ROW
    end

    puts "Answer = #{@no_beacons_y.count}"
  end

  def impact_on_row(scol, srow, bcol, brow)
    manhattan_distance = (scol - bcol).abs + (srow - brow).abs
    # puts "Calculating impact of sensor #{scol},#{srow} and beacon #{bcol},#{brow}. Manhattan Distance = #{manhattan_distance}. Answer so far = #{@no_beacons_y.count}"
    return unless (srow - ROW).abs <= manhattan_distance

    # puts "Impacts y values #{scol - ((srow - ROW).abs - manhattan_distance)} to #{scol + ((srow - ROW).abs - manhattan_distance)}"
    if (scol - ((srow - ROW).abs - manhattan_distance)) >= scol + ((srow - ROW).abs - manhattan_distance)
      ((scol - ((srow - ROW).abs - manhattan_distance))..(scol + (srow - ROW).abs - manhattan_distance)).step(-1).each do |y|
        @no_beacons_y.add(y)
      end
    else
      ((scol + ((srow - ROW).abs - manhattan_distance))..(scol - (srow - ROW).abs - manhattan_distance)).step(1).each do |y|
        @no_beacons_y.add(y)
      end
    end
  end
end

Solve.new
