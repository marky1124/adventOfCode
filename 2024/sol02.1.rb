# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @reports = []
    process_file(ARGV[0] || 'in02')
    @reports.select! { |report| safe_report?(report) }
    puts "Part 1 answer = #{@reports.count}"
  end

  def process_file(file)
    File.readlines(file, chomp: true).each do |line|
      @reports << line.split.map(&:to_i)
    end
  end

  def safe_report?(report)
    current_level = report[0]
    increasing = report[0] < report[1]
    report[1..].each do |level|
      return false if (current_level < level) != increasing
      return false if (current_level - level).abs < 1
      return false if (current_level - level).abs > 3

      current_level = level
    end
    true
  end
end

Solve.new
