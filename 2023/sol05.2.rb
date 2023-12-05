# frozen_string_literal: true

# One of many number mappings, e.g. 98..99 maps to 50..51
class Mapping
  def initialize(dest, source, count)
    @source_range = (source..source + count - 1)
    @offset = dest - source
  end

  def include?(number)
    @source_range.include?(number)
  end

  def maps_to(number)
    number + @offset
  end
end

# Represents a whole almanac mapping, e.g. 'seed-to-soil'
class Map
  def initialize(name)
    @name = name
    @mappings = []
  end

  def add_range(line)
    @mappings << Mapping.new(*line.split.map(&:to_i))
  end

  def map(number)
    @mappings.each do |map|
      return map.maps_to(number) if map.include?(number)
    end
    number
  end
end

# Data structure for the whole almanac
# @maps['seed-to-soil'] = Map
# @maps['soil-to-plant'] = Map
# ...
# @maps['seed-to-soil'].map(98) => 50
#
# Map.new('seed-to-soil').add_range('50 98 2')
# Map.new('seed-to-soil').map(98) => 50

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @maps = Hash.new { |hash, key| hash[key] = [] }
    @map_names = []

    process_file(ARGV[0] || 'in05')
    puts "Answer to part 1 = #{nearest_location}"
  end

  def nearest_location
    nearest_location = nil
    @seeds.each_slice(2) do |start, length|
      (start..start + length - 1).each do |number|
        @map_names.each do |map_name|
          number = @maps[map_name].map(number)
        end
        nearest_location = number if nearest_location.nil? || number < nearest_location
      end
    end
    nearest_location
  end

  def process_file(file)
    name = nil
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^seeds: /
        @seeds = line.gsub(/^seeds: /, '').split.map(&:to_i)
      when /^.*map:/
        name = line.split.first
        @map_names << name
        @maps[name] = Map.new(name)
      when /^\d/
        @maps[name].add_range(line)
      end
    end
  end
end

Solve.new
