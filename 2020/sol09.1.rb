# frozen_string_literal: true

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
