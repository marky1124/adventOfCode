# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @answer = 0
    process_file(ARGV[0] || 'in07')
    calculate_answer
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @sums = []
    File.readlines(file, chomp: true).each do |line|
      total, rest = line.split(':')
      rest = rest.split.map(&:to_i)
      total = total.to_i
      @sums << [total, rest]
    end
  end

  def calculate_answer
    @answer = 0
    @sums.each do |total, rest|
      do_calc(total, rest[0], 1, rest)
    end
  end

  def do_calc(total, sum_so_far, idx, rest)
    return 1 if idx == rest.length

    if (idx == rest.length - 1) && (total == (sum_so_far + rest[idx]))
      @answer += total
      return 0 # To cease any further recursion
    end

    if (idx == rest.length - 1) && (total == (sum_so_far * rest[idx]))
      @answer += total
      return 0
    end

    if (idx == rest.length - 1) && !total.to_s.scan(/^#{sum_so_far}#{rest[idx]}$/).empty?
      @answer += total
      return 0
    end

    next_sum_so_far = sum_so_far + rest[idx]
    ret = do_calc(total, next_sum_so_far, idx + 1, rest) if next_sum_so_far <= total
    return 0 if ret&.zero?

    next_sum_so_far = sum_so_far * rest[idx]
    ret = do_calc(total, next_sum_so_far, idx + 1, rest) if next_sum_so_far <= total
    return 0 if ret&.zero?

    next_sum_so_far = (sum_so_far.to_s + rest[idx].to_s).to_i
    ret = do_calc(total, next_sum_so_far, idx + 1, rest) if next_sum_so_far <= total
    return 0 if ret&.zero?

    1
  end
end

Solve.new
