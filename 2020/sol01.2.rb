# frozen_string_literal: true

# Given a file containing a list of numbers
# Find three numbers that added together = 2020
# Return the result of multiplying the three numbers

numbers = {}
File.readlines(ARGV[0]).each { |v| numbers[v.strip.to_i] = 1 }

numbers.keys.each_with_index do |k1, i1|
  numbers.keys.each_with_index do |k2, i2|
    next if i2 <= i1

    numbers.keys.each_with_index do |k3, i3|
      next if i3 <= i2

      puts "yes #{k1}+#{k2}+#{k3}=2020 answer=#{k1 * k2 * k3}" if (k1 + k2 + k3) == 2020
    end
  end
end
