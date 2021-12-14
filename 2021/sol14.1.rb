# frozen_string_literal: true

#  Solve an https://adventofcode.com puzzle
class Puzzle
  def initialize
    @polymer = ''
    @rules = {}
  end

  def do_insertions
    new_polymer = @polymer[0]
    @polymer.chars.each_cons(2) do |pair|
      new_polymer += @rules[pair.join] + pair[1]
    end
    puts new_polymer.length
    @polymer = new_polymer
  end

  # NNCB
  #
  # CH -> B
  # HH -> N
  def process_file(filename)
    fd = File.open(filename)
    @polymer = fd.readline.chomp
    @letters = @polymer.chars.uniq # => ["N", "C", "B"]
    _ = fd.readline
    until fd.eof
      pair, insert = fd.readline.chomp.split(' -> ')
      @rules[pair] = insert
    end
    p @rules
  end

  def calculate_answer
    scores = []
    @polymer.chars.uniq.each do |letter|
      puts "Letter #{letter} appears #{@polymer.count(letter)}"
      scores.append(@polymer.count(letter))
    end
    scores.max - scores.min
  end

  def solve_it(filename)
    process_file(filename)
    10.times { do_insertions }
    puts "Answer = #{calculate_answer}"
  end
end

filename = ARGV[0]
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in16"
  exit
end

p = Puzzle.new
p.solve_it(filename)
