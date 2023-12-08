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

  def map(seed_ranges)
    mapped_seeds = []
    seeds_to_check = []
    @mappings.each do |range_start, range_end, offset|
      seeds_to_check = []
      seed_ranges.each do |start_seed, end_seed|
        if end_seed < range_start
          seeds_to_check << [start_seed, end_seed]
        elsif start_seed > range_end
          seeds_to_check << [start_seed, end_seed]
        elsif start_seed >= range_start && end_seed <= range_end
          mapped_seeds << [start_seed + offset, end_seed + offset]
        elsif start_seed < range_start && end_seed > range_end
          seeds_to_check << [start_seed, range_start - 1]
          mapped_seeds << [range_start + offset, range_end + offset]
          seeds_to_check << [range_end + 1, end_seed]
        elsif start_seed < range_start && end_seed <= range_end
          seeds_to_check << [start_seed, range_start - 1]
          mapped_seeds << [range_start + offset, end_seed + offset]
        elsif start_seed >= range_start && end_seed > range_end
          mapped_seeds << [start_seed + offset, range_end + offset]
          seeds_to_check << [range_end + 1, end_seed]
        end
      end
      seed_ranges = seeds_to_check
    end
    mapped_seeds + seeds_to_check
  end
end

# Data structure for the whole almanac
# @maps['seed-to-soil'] = Map
# @maps['soil-to-plant'] = Map
# ...
# @maps['seed-to-soil'].map(98) => 50
#
# Map.new('seed-to-soil').add_range('50 98 2')
# @seed_ranges = [[79,92],[55,67]]
# Map.new('seed-to-soil').map(@seed_ranges) => [[81,94],[57,69]]

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @maps = Hash.new { |hash, key| hash[key] = [] }
    @map_names = []

    process_file(ARGV[0] || 'tin05')
    puts "Answer to part 1 = #{nearest_location}"
  end

  def nearest_location
    @map_names.each do |map_name|
      @seed_ranges = @maps[map_name].map(@seed_ranges)
    end
    @seed_ranges.sort! { |a, b| a.first <=> b.first }
    @seed_ranges.first.first
  end

  def process_file(file)
    name = nil
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^seeds: /
        seeds = line.gsub(/^seeds: /, '').split.map(&:to_i)
        seeds.each_slice(2) do |start, length|
          @seed_ranges ||= []
          @seed_ranges << [start, start + length - 1]
        end
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
