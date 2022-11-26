# frozen_string_literal: true

# Instead of storing the full polymer ('NNCB' -> 'NCNBCHB')
# store a count of the number of each pair
# Initially we have {'NN'=>1, 'NC'=>1, 'CB'=>1}
# Build the next set of pairs

#  Solve an https://adventofcode.com puzzle
class Puzzle
  def initialize
    @polymer = ''
    @pairs = {}
    @rules = {}
  end

  # @pairs = {"NN"=>1, "NC"=>1, "CB"=>1}
  # @rules = {"CH"=>"B", "HH"=>"N", "CB"=>"H", ...}
  # This code relies on the hash keys coming out in a consistent order until the hash is changed
  def do_insertions
    new_pairs = Hash.new(0)
    @pairs.each do |pair, value|
      insert_letter = @rules[pair]
      new_pairs[pair[0] + insert_letter] += value
      new_pairs[insert_letter + pair[1]] += value
    end
    # puts new_pairs
    @pairs = new_pairs
  end

  # NNCB
  #
  # CH -> B
  # HH -> N
  def process_file(filename)
    fd = File.open(filename)
    @polymer = fd.readline.chomp
    @polymer.chars.each_cons(2) { |pair| @pairs[pair.join] = 1 } # => {"NN"=>1, "NC"=>1, "CB"=>1}
    _ = fd.readline
    until fd.eof
      pair, insert = fd.readline.chomp.split(' -> ')
      @rules[pair] = insert
    end
  end

  def calculate_answer
    scores = Hash.new(0)

    # Count the first letter for all the keys
    @pairs.each do |pair, value|
      scores[pair[0]] += value
    end

    # Count the last letter that is always at the end
    scores[@polymer[-1]] += 1

    scores.values.max - scores.values.min
  end

  def solve_it(filename)
    process_file(filename)
    40.times { do_insertions }
    puts "Answer = #{calculate_answer}"
  end
end

filename = ARGV[0] || 'in14'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in14"
  exit
end

p = Puzzle.new
p.solve_it(filename)
