# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    answer = 0
    File.readlines(ARGV[0] || 'in03', chomp: true).each do |line|
      len = line.length / 2
      letter = line[0..len - 1].chars.find { |l| line[-len..].include?(l) }
      answer += letter.ord >= 'a'.ord ? letter.ord - 'a'.ord + 1 : letter.ord - 'A'.ord + 27
    end
    puts "Answer = #{answer}"
  end
end

Solve.it
