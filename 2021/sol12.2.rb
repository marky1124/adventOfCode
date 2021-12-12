# frozen_string_literal: true

#  Solve an https://adventofcode.com puzzle
class Puzzle
  def initialize
    @routes = Hash.new([]) # e.g. @routes['Start'] = [['A'], ['b']]
    @answer = 0
  end

  # {"start"=>["A", "b"], "A"=>["c", "b", "end"], "b"=>["d", "end"]}
  def find_routes(location, path, can_revisit)
    if location == 'end'
      puts path
      @answer += 1
      return

    end

    @routes[location].each do |next_location|
      next_can_revisit = can_revisit
      if next_location == next_location.downcase && (path[/-#{next_location}/])
        next unless can_revisit

        next_can_revisit = false
      end

      find_routes(next_location, path + "-#{next_location}", next_can_revisit)
    end
  end

  # start-A
  # start-b
  # A-c
  # A-b
  # b-d
  # A-end
  # b-end
  # Build the @routes structure
  def process_file(filename)
    fd = File.open(filename)
    until fd.eof
      line = fd.readline.chomp
      from, to = line.split('-')
      # NOTE: @routes = Hash.new([]) didn't work with @routes[start].append('b') hence this extra initialisation
      @routes[from] = [] if @routes[from].empty?
      @routes[from].append(to) if to != 'start'
      @routes[to] = [] if @routes[to].empty?
      @routes[to].append(from) if from != 'start'
    end
    p @routes
  end

  def solve_it(filename)
    process_file(filename)
    find_routes('start', 'start', true)
    puts "Answer = #{@answer}"
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
