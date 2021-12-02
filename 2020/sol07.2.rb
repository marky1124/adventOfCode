# frozen_string_literal: true

# shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags.
# contains 2 of type dark violet - after ret=3     ret=2
# contains 2 of type dark blue - after ret=7
# contains 2 of type dark green - after ret=15
# contains 2 of type dark yellow - after ret=31
# contains 2 of type dark orange - after ret=63
# contains 2 of type dark red - after ret=127
# A shiny gold contains 127 other bags

# require 'byebug'

if ARGV[0].nil? || ARGV[1].nil?
  puts "Usage: #{$PROGRAM_NAME} <file> <bag-type>"
  puts "  e.g: #{$PROGRAM_NAME} in07 'shiny gold'"
  exit
end

# e.g. $ ruby sol07.2.rb in07 "shiny gold"
class Solve
  def initialize
    rules = File.readlines(ARGV[0], chomp: true)
    first_bag = ARGV[1]

    answer = containers_of(rules, first_bag) - 1
    puts "A #{first_bag} contains #{answer} other bags"
  end

  def containers_of(rules, container)
    ret = 0
    bag = container

    if rules.include?("#{bag} bags contain no other bags.")
      # byebug
      return 1
    end

    rules.select { |r| r.match(/#{bag} bags contain (.*)/) }
         .map! { |b| b.gsub(/ bags.*/, '') }

    r = rules.select do |rule|
          rule.match(/#{bag} bags contain (.*)/)
        end.map! { |b| b.gsub(/.* contain /, '') }[0].split(',')
    # e.g. => ["5 plaid bronze bags", " 4 bright fuchsia bags", " 2 light violet bags", " 1 clear plum bag."]

    r.map! { |x| x.match(/(\d+) (.*) bag/).captures }
    # e.g. => [["5", "plaid bronze"], ["4", "bright fuchsia"], ["2", "light violet"], ["1", "clear plum"]]

    r.each do |n, type|
      ret += (n.to_i * containers_of(rules, type))
    end

    ret + 1
  end
end

Solve.new
