# frozen_string_literal: true

answers = File.readlines(ARGV[0], chomp: true)
              .slice_when { |_a, b| b == '' }.map(&:join)

puts answers.map { |a| a.chars.uniq.length }.reduce(:+)

# pp answers
