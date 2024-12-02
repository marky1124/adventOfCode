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

  def safe_report?(report, allow_level_removal: true)
    current_level = report[0]
    increasing = report[0] < report[1]
    report.each_with_index do |level, idx|
      next if idx.zero?

      if ((current_level < level) != increasing) ||
         (current_level - level).abs < 1 ||
         (current_level - level).abs > 3
        return false unless allow_level_removal

        report.each_with_index do |_, remove_idx|
          dampened_report = report.reject.with_index { |_, idx| idx == remove_idx }
          return true if safe_report?(dampened_report, allow_level_removal: false)
        end

        return false
      end

      current_level = level
    end
    true
  end
end

Solve.new
