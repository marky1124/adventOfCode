# frozen_string_literal: true

# Reject lines if they don't have at least three vowels
# Reject lines if they don't have a double letter
# Reject lines if they contain 'ab', 'cd', 'pq' or 'xy'

nice = 0
File.readlines(ARGV[0], chomp: true).each do |line|
  next unless line.match(/(..).*\1/)
  next unless line.match(/(.).\1/)

  nice += 1
end

puts "The number of nice lines is #{nice}"
