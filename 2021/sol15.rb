# frozen_string_literal: true

# Represents a node to be used with a variation of the A* algorithm
class Node
  attr_accessor :row, :col, :risk, :cost_to_here_g, :cost_to_end_h, :parent

  def initialize(row, col, risk, cost_to_here_g, cost_to_end_h, parent)
    @row = row
    @col = col
    @risk = risk.to_i
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
    file = ARGV[0] || '../2021/in15'
    [1, 5].each_with_index do |expand_input, part|
      reset_class_variables
      process_file(file, expand_input)
      calculate_path_from_start_to_end(@start, @end)
      puts "Answer to part #{part + 1} = #{@end.cost_to_here_g}"
    end
  end

  def reset_class_variables
    @start = nil
    @end = nil
    @nodes = {}
    @openset = {}
    @closedset = {}
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
        next if neighbour == start

        if @closedset["#{row},#{col}"] || @openset["#{row},#{col}"]
          if lcn.cost_to_here_g + neighbour.risk < neighbour.cost_to_here_g
            neighbour.cost_to_here_g = lcn.cost_to_here_g + neighbour.risk
            neighbour.parent = lcn
          end
          next
        end

        neighbour.parent = lcn
        neighbour.cost_to_here_g = lcn.cost_to_here_g + neighbour.risk
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

  def process_file(file, expand_input)
    File.readlines(file, chomp: true).each_with_index do |line, row|
      col_size = line.length
      expand_input.times do |row_iteration|
        irow = row + (row_iteration * col_size)
        line.chars.each_with_index do |risk, col|
          expand_input.times do |col_iteration|
            icol = col + (col_iteration * col_size)
            node = Node.new(irow, icol, (risk.to_i - 1 + (row_iteration + col_iteration) * 1) % 9 + 1, -1, -1, nil)
            @nodes["#{irow},#{icol}"] = node
          end
        end
      end
    end
    @start = @nodes['0,0']
    @start.cost_to_here_g = 0
    @end = @nodes[@nodes.keys.last]
    @end.cost_to_here_g = 1_000_000_000
    @openset[@start.name] = @start
    @closedset[@end.name] = @end
  end
end

Solve.new
