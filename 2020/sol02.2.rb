# frozen_string_literal: true

# Each policy actually describes two positions in the password, where
# 1 means the first character, 2 means the second character, and so
# on. (Be careful; Toboggan Corporate Policies have no concept of
# "index zero"!) Exactly one of these positions must contain the given
# letter. Other occurrences of the letter are irrelevant for the purposes
# of policy enforcement.
#
# For example, suppose you have the following list:
#
# 1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc
#
#     1-3 a: abcde is valid: position 1 contains a and position 3 does not.
#     1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
#     2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
#
# How many passwords are valid according to the new interpretation of the policies?

bad = 0
good = 0
File.readlines(ARGV[0]).each do |line|
  _dummy, min, max, letter, password = /^(\d+)-(\d+) (\w): (\w*)$/.match(line).to_a.flatten
  #  puts "#{min},#{max},#{letter},#{password}"
  if ((password[min.to_i - 1] + password[max.to_i - 1]).count letter) != 1
    bad += 1
    puts "Invalid password #{bad} => #{line}"
  else
    good += 1
  end
end

puts "The number of valid passwords is #{good}"
