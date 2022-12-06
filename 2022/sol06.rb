# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    line = File.read(ARGV[0] || 'in06').chomp
    puts "Answer to part 1 = #{find_start_marker(line, 4)}"
    puts "Answer to part 2 = #{find_start_marker(line, 14)}"
  end

  private_class_method def self.find_start_marker(line, unique_length)
    line.chars.each_cons(unique_length).to_a.each_with_index do |letter_group, idx|
      return idx + unique_length if letter_group.uniq.length == unique_length
    end
    raise ArgumentError, 'No valid start marker found'
  end
end

Solve.it
