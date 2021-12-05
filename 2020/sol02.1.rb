# frozen_string_literal: true

# For example, suppose you have the following list:
#
# 1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc
#
#
# In the above example, 2 passwords are valid. The middle password, cdefg,
# is not; it contains no instances of b, but needs at least 1. The first
# and third passwords are valid: they contain one a or nine c, both within
# the limits of their respective policies.
#
# How many passwords are valid according to their policies?

bad = 0
good = 0
File.readlines(ARGV[0]).each do |line|
  _dummy, min, max, letter, password = /^(\d+)-(\d+) (\w): (\w*)$/.match(line).to_a.flatten
  #  puts "#{min},#{max},#{letter},#{password}"
  letter_count = password.count letter
  if (letter_count < min.to_i) || (letter_count > max.to_i)
    bad += 1
    puts "Invalid password #{bad} => #{line}"
  else
    good += 1
  end
end

puts "The number of valid passwords is #{good}"
