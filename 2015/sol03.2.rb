# frozen_string_literal: true

# e.g. $ ruby $0 <input-file>
class Solve
  def deliver_presents(route)
    x = y = 0
    @map["#{x},#{y}"] += 1
    route.each do |d|
      case d
      when '<'
        x -= 1
      when '>'
        x += 1
      when '^'
        y -= 1
      when 'v'
        y += 1
      else
        puts "Unrecognised instruction #{d}"
        exit
      end
      @map["#{x},#{y}"] += 1
    end
  end

  def initialize
    @map = Hash.new(0)
    directions = File.read(ARGV[0]).chomp
    deliver_presents(directions.chars.select.each_with_index { |_e, i| i.even? })
    deliver_presents(directions.chars.select.each_with_index { |_e, i| i.odd? })
    puts "Number of houses delivered to #{@map.keys.length}"
  end
end

Solve.new
