# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in05')
    @print_list.reject! { |pl| valid_order(pl) }
    @print_list.map! { |pl| fix_print_list(pl) }
    calculate_answer
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @rules = {}
    @print_list = []
    File.readlines(file, chomp: true).each do |line|
      case line
      when /^(\d\d\|\d\d)$/
        @rules[::Regexp.last_match(1)] = true
      when /^\d\d,/
        @print_list << line.split(',').map(&:to_i)
      end
    end
  end

  def valid_order(print_list)
    print_list.each_with_index do |page, idx|
      print_list[idx + 1..].each do |second_page|
        return false if @rules["#{second_page}|#{page}"]
      end
    end
    true
  end

  def fix_print_list(print_list)
    print_list.reverse.each do |page|
      pidx = print_list.find_index(page)
      next if pidx.zero?

      print_list[0..pidx - 1].each_with_index do |second_page, spidx|
        next unless @rules["#{page}|#{second_page}"]

        print_list.delete(page)
        print_list.insert(spidx, page)
        break
      end
    end
    print_list
  end

  def calculate_answer
    @answer = 0
    @print_list.each { |list| @answer += list[(list.length - 1) / 2] }
  end
end

Solve.new
