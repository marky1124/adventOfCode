# frozen_string_literal: true

# Represents a line. Can return an array of all the points covered by the line
class Line
  attr_reader :points

  def initialize(points)
    @x1 = points[0][0].to_i
    @y1 = points[0][1].to_i
    @x2 = points[1][0].to_i
    @y2 = points[1][1].to_i
    @points = calculate_points
  end

  def calculate_points
    points = []
    if @x1 == @x2
      if @y1 <= @y2
        (@y1..@y2).each { |y| points.append([@x1, y]) }
      else
        (@y2..@y1).reverse_each { |y| points.append([@x1, y]) }
      end
    elsif @y1 == @y2
      if @x1 <= @x2
        (@x1..@x2).each { |x| points.append([x, @y1]) }
      else
        (@x2..@x1).reverse_each { |x| points.append([x, @y1]) }
      end
    else
      x_delta = @x1 <= @x2 ? 1 : -1
      y_delta = @y1 <= @y2 ? 1 : -1
      x_offset = 0
      y_offset = 0
      while @x1 + x_offset != @x2
        points.append([@x1 + x_offset, @y1 + y_offset])
        x_offset += x_delta
        y_offset += y_delta
      end
      points.append([@x1 + x_offset, @y1 + y_offset])
    end
    points
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @lines = []
  end

  def solve_it(filename)
    read_input(filename)
    points_covered = Hash.new(0)
    @lines.each { |line| line.points.each { |point| points_covered[point] += 1 } }
    points_covered.delete_if { |_key, value| value == 1 }
    puts "Answer is #{points_covered.count}"
  end

  def read_input(filename)
    fd = File.open(filename)
    until fd.eof
      input = fd.readline.chomp
      points = input.split(' -> ').map { |x| x.split(',') } # => [["0", "9"], ["5", "9"]]
      line = Line.new(points)
      @lines.append(line) unless line.points.empty?
    end
    fd.close
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in24"
  exit
end

s = Solve.new
s.solve_it(filename)
