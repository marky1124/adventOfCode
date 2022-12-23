# frozen_string_literal: true

# Represents a node to be used with a variation of the A* algorithm
class Node
  attr_accessor :row, :col, :letter, :cost_to_here_g, :cost_to_end_h, :parent

  def initialize(row, col, letter, cost_to_here_g, cost_to_end_h, parent)
    @row = row
    @col = col
    @letter = letter
    @cost_to_here_g = cost_to_here_g
    @cost_to_end_h = cost_to_end_h
    @parent = parent
  end

  def total_cost_f
    @cost_to_here_g + @cost_to_end_h
  end

  def name
    "#{row},#{col}"
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @start = nil
    @end = nil
    @nodes = {}
    @openset = {}
    @closedset = {}
    @answer1 = 1_000_000_000
    @answer2 = 1_000_000_000

    process_file(ARGV[0] || 'in12')
    puts "There are #{@nodes.each_value.select { |node| node.letter == 'a' }.count} starting points"
    @nodes.each_value.select { |node| node.letter == 'a' }.each do |start|
      reset_nodes(start)
      calculate_path_from_start_to_end(start, @end)
      next if @end.parent.nil?

      route = determine_route_to(@end)
      if route.count < @answer2
        @answer2 = route.count
        puts "Shorter route of length #{@answer2} found"
      end
      @answer1 = route.count if start == @start
    end
    puts "Answer to part 1 = #{@answer1}"
    puts "Answer to part 2 = #{@answer2}"
  end

  def reset_nodes(start)
    @nodes.each_value do |node|
      node.cost_to_here_g = -1
      node.parent = nil
    end
    @closedset = {}
    @openset["#{start.row},#{start.col}"] = start
  end

  def determine_route_to(end_node)
    route = []
    node = end_node
    while node.parent
      route << node
      node = node.parent
    end
    # puts 'route:'
    # route.reverse.each do |position|
    #   puts "#{position.name} #{position.letter}"
    # end
    route
  end

  # Use an A* style algorithm to find the shortest route from @start to @end
  def calculate_path_from_start_to_end(start, end_node)
    loop do
      lcn = lowest_cost_node
      break if lcn.nil?

      @openset.delete(lcn.name)
      neighbours(lcn.row, lcn.col).each do |row, col|
        next unless @nodes["#{row},#{col}"]

        neighbour = @nodes["#{row},#{col}"]
        next if neighbour.letter.ord > lcn.letter.ord + 1
        next if neighbour == start

        if @closedset["#{row},#{col}"] || @openset["#{row},#{col}"]
          if lcn.cost_to_here_g + 1 < neighbour.cost_to_here_g
            neighbour.cost_to_here_g = lcn.cost_to_here_g + 1
            neighbour.parent = lcn
          end
          next
        end

        neighbour.parent = lcn
        neighbour.cost_to_here_g = lcn.cost_to_here_g + 1
        neighbour.cost_to_end_h = (end_node.row - neighbour.row).abs + (end_node.col - neighbour.col).abs
        @openset[neighbour.name] = neighbour unless neighbour == end_node
      end
      @closedset[lcn.name] = lcn
    end
  end

  def lowest_cost_node
    return nil if @openset.empty?

    lowest_total_cost_f = @openset.values.min_by(&:total_cost_f).total_cost_f
    lowest_cost_nodes = @openset.values.select { |n| n.total_cost_f == lowest_total_cost_f }
    return lowest_cost_nodes.first if lowest_cost_nodes.count == 1

    # If we have a tie break then pick node which is nearest the end
    lowest_cost_to_end_h = lowest_cost_nodes.min_by(&:cost_to_end_h).cost_to_end_h
    lowest_cost_nodes = lowest_cost_nodes.select { |n| n.cost_to_end_h == lowest_cost_to_end_h }
    return lowest_cost_nodes.first if lowest_cost_nodes.count == 1

    # Multiple identically lowest cost nodes found. Picking one.
    lowest_cost_nodes.first
  end

  def neighbours(row, col)
    [[row - 1, col], [row, col + 1], [row + 1, col], [row, col - 1]]
  end

  def process_file(file)
    File.readlines(file, chomp: true).each_with_index do |line, row|
      line.chars.each_with_index do |letter, col|
        node = Node.new(row, col, letter, -1, -1, nil)
        case letter
        when 'S'
          node.letter = 'a'
          @start = node
        when 'E'
          node.letter = 'z'
          @end = node
        end
        @nodes["#{row},#{col}"] = node
      end
    end
  end
end

Solve.new
