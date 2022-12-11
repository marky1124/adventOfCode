# frozen_string_literal: true

# Represents a monkey conducting monkey business
class Monkey
  attr_reader :inspected
  attr_accessor :items, :operation, :op_value, :divisible_by, :true_monkey, :false_monkey

  def initialize(items)
    @items = items
    @inspected = 0
  end

  def recalculate_worry(product_of_divisors, worry_factor)
    @items.map! do |item|
      tmp = op_value == 'old' ? item : op_value.to_i
      item = operation == '+' ? item + tmp : item * tmp
      item /= worry_factor
      item % product_of_divisors
    end
    @inspected += @items.count
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  def self.it
    file = ARGV[0] || 'in11'
    puts "Answer to part 1 = #{calculate_answer(file, 20, 3)}"
    puts "Answer to part 2 = #{calculate_answer(file, 10_000, 1)}"
  end

  private_class_method def self.calculate_answer(file, number_of_rounds, worry_factor)
    process_file(file)
    product_of_divisors = @monkeys.each_value.map(&:divisible_by).reduce(:*)
    number_of_rounds.times { perform_a_round(product_of_divisors, worry_factor) }
    @monkeys.each_value.map(&:inspected).max(2).reduce(:*)
  end

  private_class_method def self.perform_a_round(product_of_divisors, worry_factor)
    @monkeys.each_value do |monkey|
      monkey.recalculate_worry(product_of_divisors, worry_factor)
      until monkey.items.empty?
        item = monkey.items.shift
        next_monkey = (item % monkey.divisible_by).zero? ? monkey.true_monkey : monkey.false_monkey
        @monkeys[next_monkey].items << item
      end
    end
  end

  private_class_method def self.process_file(file)
    @monkeys = {}
    monkey_number = nil
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^Monkey/
        monkey_number = line.split.last.to_i
      when /^  Starting items:/
        @monkeys[monkey_number] = Monkey.new(line.split[2..].map(&:to_i))
      when /^  Operation:/
        @monkeys[monkey_number].operation = line.split[4]
        @monkeys[monkey_number].op_value = line.split[5]
      when /^  Test:/
        @monkeys[monkey_number].divisible_by = line.split.last.to_i
      when /^\s+If true:/
        @monkeys[monkey_number].true_monkey = line.split.last.to_i
      when /^\s+If false:/
        @monkeys[monkey_number].false_monkey = line.split.last.to_i
      end
    end
  end
end

Solve.it
