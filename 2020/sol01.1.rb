# frozen_string_literal: true

# Given a file containing a list of numbers
# Find two numbers that added together = 2020
# Return the result of multiplying the two numbers

numbers = {}
File.readlines(ARGV[0]).each { |v| numbers[v.strip.to_i] = 1 }
numbers.each_key { |k| puts "#{k}+#{2020 - k}=2020 answer=#{k * (2020 - k)}" if numbers[2020 - k] }
