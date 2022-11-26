# frozen_string_literal: true

# Bash one liner! LOL
# while read x y; do ((x >655)) && x=$((2*655-x)); echo $x,$y; done < <(grep , 13.txt| tr , ' ') | sort -u | wc -l
# 795

#  Solve an https://adventofcode.com puzzle
class Puzzle
  # 6,10
  # 0,14
  #
  # fold along y=7
  # fold along x=5
  def process_file(filename)
    # find highest x, y values from file to initialise array
    max_x = 0
    max_y = 0
    fd = File.open(filename)
    loop do
      line = fd.readline.chomp
      break if line.length.zero?

      x, y = line.split(',').map(&:to_i)
      max_x = x if x > max_x
      max_y = y if y > max_y
    end

    map = Array.new(max_y + 1) { Array.new(max_x + 1, ' ') }

    # populate the map
    fd.rewind
    loop do
      line = fd.readline.chomp
      break if line.length.zero?

      x, y = line.split(',').map(&:to_i)
      map[y][x] = '#'
    end

    # perform each fold
    first_fold = true
    until fd.eof
      instruction = fd.readline.chomp
      fold_axis = instruction[11]
      fold_along = instruction.split('=')[1].to_i

      map = if fold_axis == 'y'
              fold_along_y(map, fold_along)
            else
              fold_along_x(map, fold_along)
            end

      if first_fold
        status("after first fold = #{instruction}", map)
        first_fold = false
      end
    end

    # Display the map
    puts 'Answer 2:'
    map.each { |row| puts row.join }
  end

  def status(msg, map)
    puts msg
    answer = 0
    map.each do |row|
      row.each do |char|
        answer += 1 if char == '#'
      end
    end
    puts "map size x=#{map[0].size}, y=#{map.size}, number of dots (aka answer 1)=#{answer}\n\n"
    # pp map
  end

  # Taking for granted that input is valid
  # If fold is at 7 then merge rows 6-0 with 8-15
  def fold_along_y(map, fold_along)
    max_row = map.size - 1
    num_col = map[0].size
    new_map = Array.new(fold_along) { Array.new(num_col, ' ') }
    (0..fold_along - 1).each { |row| new_map[row] = map[row] }
    (fold_along + 1..max_row).each do |row|
      target_row = fold_along - (row - fold_along)
      # puts "merge in #{row} into #{target_row}"
      map[row].each_with_index do |_value, idx|
        new_map[target_row][idx] = '#' if map[row][idx] == '#'
      end
    end
    new_map
  end

  # Taking for granted that input is valid
  # If fold is at 7 then merge cols 6-0 with 8-15
  def fold_along_x(map, fold_along)
    num_row = map.size
    new_map = Array.new(num_row) { Array.new(fold_along, ' ') }

    map.each_with_index do |_map_row, row|
      (0..fold_along - 1).each do |col|
        new_map[row][col] = '#' if map[row][col] == '#'
        # puts "merge in column #{2*fold_along-col} into #{col}"
        new_map[row][col] = '#' if map[row][(2 * fold_along) - col] == '#'
      end
    end
    new_map
  end

  def solve_it(filename)
    process_file(filename)
  end
end

filename = ARGV[0] || 'in13'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in13"
  exit
end

p = Puzzle.new
p.solve_it(filename)
