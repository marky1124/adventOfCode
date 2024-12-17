# frozen_string_literal: true

# Represents a node to be used with a variation of the A* algorithm
class Node
  attr_accessor :crow, :col, :letter, :cost_to_here_g, :cost_to_end_h, :parent, :facing

  def initialize(crow, col, letter, cost_to_here_g, cost_to_end_h, parent)
    @crow = crow
    @col = col
    @letter = letter
    @cost_to_here_g = cost_to_here_g
    @cost_to_end_h = cost_to_end_h
    @parent = parent
    @facing = nil
  end

  def total_cost_f
    @cost_to_here_g + @cost_to_end_h
  end

  def name
    "#{crow},#{col}"
  end

  def to_s
    "#{crow},#{col} facing=[#{facing}] cost_to_here=#{cost_to_here_g} cost_to_end=#{cost_to_end_h} parent=#{parent&.crow},#{parent&.col} letter=#{letter}"
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  DIRS = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }.freeze # up, down,     left, right

  def initialize
    @start = nil
    @end = nil
    @nodes = {}
    @openset = {}
    @closedset = {}

    process_file(ARGV[0] || 'in16')
    @openset["#{@start.crow},#{@start.col}"] = @start
    calculate_path_from_start_to_end(@start, @end)
    puts "Answer = #{@end.cost_to_here_g}"
  end

  # Use an A* style algorithm to find the shortest route from @start to @end
  def calculate_path_from_start_to_end(start, end_node)
    loop do
      lcn = lowest_cost_node
      break if lcn == end_node || lcn.nil?

      facing = lcn.facing
      @openset.delete(lcn.name)

      DIRS.each do |direction, offset_position|
        row = lcn.crow + offset_position[0]
        col = lcn.col + offset_position[1]
        next unless @nodes["#{row},#{col}"]

        neighbour = @nodes["#{row},#{col}"]
        next if neighbour.letter == '#'
        next if neighbour == start

        next_cost = direction == facing ? 1 : 1001
        if @closedset["#{row},#{col}"] || @openset["#{row},#{col}"]
          if lcn.cost_to_here_g + next_cost < neighbour.cost_to_here_g
            neighbour.cost_to_here_g = lcn.cost_to_here_g + next_cost
            neighbour.parent = lcn
          end
          next
        end

        neighbour.parent = lcn
        neighbour.facing = direction
        neighbour.cost_to_here_g = lcn.cost_to_here_g + next_cost
        neighbour.cost_to_end_h = cost_to_end_calc(end_node, neighbour)
        @openset[neighbour.name] = neighbour
      end
      @closedset[lcn.name] = lcn
    end
  end

  def cost_to_end_calc(end_node, current_position)
    turn_cost = if (end_node.crow == current_position.crow && current_position.facing == '^') ||
                   (end_node.col == current_position.col && current_position.facing == '>')
                  0
                elsif current_position.facing == '^'
                  1000
                else
                  2000
                end

    (end_node.crow - current_position.crow).abs + (end_node.col - current_position.col).abs + turn_cost
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

  def process_file(file)
    File.readlines(file, chomp: true).each_with_index do |line, row|
      line.chars.each_with_index do |letter, col|
        next if letter == '#'

        node = Node.new(row, col, letter, -1, -1, nil)
        case letter
        when 'S'
          @start = node
          @start.facing = '>'
          @start.cost_to_here_g = 0
        when 'E'
          @end = node
        end
        @nodes["#{row},#{col}"] = node
      end
    end
  end
end

Solve.new
