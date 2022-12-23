# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    lines = File.readlines(ARGV[0] || 'in13', chomp: true).reject { |line| line.empty? }
    lines << '[[2]]'
    lines << '[[6]]'
    lines.sort! { |a, b| correct_order?(a, b) ? -1 : 1 }
    answer = lines.each_with_index.select { |l, _i| %w[[[2]] [[6]]].include?(l) }.map { |v| v.last + 1 }.inject(:*)
    puts "Answer = #{answer}"
  end

  def correct_order?(left, right)
    if left[0] == '[' && right[0][/\d/]
      correct_order?(left, embracket_first_number(right))

    elsif left[0][/\d/] && right[0] == '['
      correct_order?(embracket_first_number(left), right)

    elsif left[0] == ']' && right[0] != ']'
      true

    elsif left[0] != ']' && right[0] == ']'
      false

    elsif left[0] == '[' && right[0] == '[' ||
          left[0] == ',' && right[0] == ',' ||
          left[0] == ']' && right[0] == ']'
      correct_order?(left[1..], right[1..])

    elsif left[/^\d+/].to_i < right[/^\d+/].to_i
      true

    elsif left[/^\d+/].to_i > right[/^\d+/].to_i
      false

    else
      correct_order?(remove_first_number(left), remove_first_number(right))
    end
  end

  def embracket_first_number(line)
    new_line = '['
    new_line += line[/^\d+/]
    new_line += ']'
    line[/^\d+(.*)/]
    new_line + Regexp.last_match(1)
  end

  def remove_first_number(line)
    line[/^\d+(.*)/]
    Regexp.last_match(1)
  end
end

Solve.new
