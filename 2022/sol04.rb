# frozen_string_literal: true

# Extend Range class to make solution nice and readable
class Range
  def subset_of?(range)
    range.all? { |v| include?(v) }
  end

  def overlap?(range)
    range.any? { |v| include?(v) }
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    answer1 = 0
    answer2 = 0
    File.readlines(ARGV[0] || 'in04', chomp: true).each do |line|
      range1, range2 = process_line(line)
      answer1 += 1 if range1.subset_of?(range2) || range2.subset_of?(range1)
      answer2 += 1 if range1.overlap?(range2)
    end
    puts "Answer to part 1 = #{answer1}"
    puts "Answer to part 2 = #{answer2}"
  end

  private_class_method def self.process_line(line)
    elf1, elf2 = line.split(',')
    sections = elf1.split('-').map(&:to_i)
    range1 = sections[0]..sections[1]
    sections = elf2.split('-').map(&:to_i)
    range2 = sections[0]..sections[1]
    [range1, range2]
  end
end

Solve.it
