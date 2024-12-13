# frozen_string_literal: true

require 'matrix'

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @answer = 0
    process_file(ARGV[0] || 'in13')
    least_button_presses
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @claw_machines = []
    ax = ay = bx = by = tx = ty = nil
    File.readlines(file, chomp: true).each do |line|
      case line
      when /Button A: X\+(\d+), Y\+(\d+)/
        ax = ::Regexp.last_match(1).to_i
        ay = ::Regexp.last_match(2).to_i
      when /Button B: X\+(\d+), Y\+(\d+)/
        bx = ::Regexp.last_match(1).to_i
        by = ::Regexp.last_match(2).to_i
      when /Prize: X=(\d+), Y=(\d+)/
        tx = ::Regexp.last_match(1).to_i + 10_000_000_000_000
        ty = ::Regexp.last_match(2).to_i + 10_000_000_000_000
        @claw_machines << [ax, ay, bx, by, tx, ty]
      end
    end
  end

  def least_button_presses
    @claw_machines.each do |ax, ay, bx, by, tx, ty|
      # Ref: https://github.com/kovyrin/aoc2024/blob/main/day13/d13p2.rb
      coefficients = Matrix[[ax, bx], [ay, by]]
      constants = Vector[tx, ty]

      solution = coefficients.inverse * constants

      next unless solution.all? { |s| s.denominator == 1 }

      @answer += solution[0].to_i * 3 + solution[1].to_i
    end
  end
end

Solve.new
