# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    answer = 0
    File.readlines(ARGV[0] || 'in03', chomp: true).each_slice(3) do |lines|
      letter = lines[0].chars.find { |l| lines[1].include?(l) && lines[2].include?(l) }
      answer += letter.ord >= 'a'.ord ? letter.ord - 'a'.ord + 1 : letter.ord - 'A'.ord + 27
    end
    puts "Answer = #{answer}"
  end
end

Solve.it
