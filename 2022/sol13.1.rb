# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    indices = []
    left = ''
    right = ''

    File.readlines(ARGV[0] || 'in13', chomp: true).each_with_index do |line, index|
      case index % 3
      when 0
        left = line
      when 1
        right = line
      when 2
        indices << index / 3 + 1 if correct_order?(left, right)
      end
    end

    puts "Answer = #{indices.sum}"
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
