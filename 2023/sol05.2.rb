# frozen_string_literal: true

# Represents a whole almanac mapping, e.g. 'seed-to-soil'
class Map
  def initialize(name)
    @name = name
    @mappings = []
  end

  def add_range(line)
    (dest, min, count) = line.split.map(&:to_i)
    max = min + count - 1
    offset = dest - min
    @mappings << [min, max, offset]
  end

  def map(number)
    @mappings.each do |min, max, offset|
      return number + offset if number >= min && number <= max
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
      puts "#{Time.now} #{start} #{length}"
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
