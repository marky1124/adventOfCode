# frozen_string_literal: true

#  ruby sol09.2.rb in09 25
class Solve
  def initialize
    if ARGV[0].nil? || ARGV[1].nil?
      puts "Usage: #{$PROGRAM_NAME} <file> <preamble-length>"
      puts "  e.g: #{$PROGRAM_NAME} in09 25"
      exit
    end

    numbers = File.readlines(ARGV[0], chomp: true).map(&:to_i)
    plen = ARGV[1].to_i
    ptr = plen

    ptr += 1 while numbers[ptr - plen..ptr - 1].combination(2).each.map(&:sum).include?(numbers[ptr])

    puts "Answer is that number #{ptr} (#{numbers[ptr]}) is not the sum of any two of the previous #{ARGV[1]} numbers"

    target = numbers[ptr]
    puts "Looking for a consecutive range that adds up to #{target}"
    # puts "#{array_of_ranges(numbers,4)}"
    size = 3
    while size < numbers.length
      array_of_ranges(numbers, size).each do |set|
        next unless set.sum == target

        puts "#{set} sums to #{target}"
        puts "Answer = #{set.min + set.max}"
        break
      end
      size += 1
    end
  end

  def array_of_ranges(arr, len)
    result = arr.each.with_index.map { |_v, i| arr[i..i + len - 1] if i < arr.length - (len - 1) }
    result.compact
  end
end

Solve.new
