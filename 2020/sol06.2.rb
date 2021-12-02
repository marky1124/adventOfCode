# frozen_string_literal: true

file = File.readlines(ARGV[0], chomp: true)
           .slice_when { |_a, b| b == '' }.map { |e| e.join(' ').strip }

unique_answer_count = file.map do |line|
  answers = line.split.uniq
  unique = answers[0].chars.uniq
  answers[1..].each { |a| unique &= a.chars.uniq }
  unique.length
end

puts unique_answer_count.reduce(:+)
