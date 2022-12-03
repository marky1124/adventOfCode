# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    elf = []
    cal = 0
    File.readlines(ARGV[0] || 'in01', chomp: true).each do |line|
      if line.empty?
        elf << cal
        cal = 0
      else
        cal += line.to_i
      end
    end
    elf << cal
    puts "Part 1 answer = #{elf.max}"
    puts "Part 2 answer = #{elf.sort.last(3).sum}"
  end
end

Solve.it
