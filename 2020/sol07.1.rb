# frozen_string_literal: true

# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.

# ruby sol07.1.rb in07 "shiny gold"

if ARGV[0].nil? || ARGV[1].nil?
  puts "Usage: #{$PROGRAM_NAME} <file> <bag-type>"
  puts "  e.g: #{$PROGRAM_NAME} in07 'shiny gold'"
  exit
end

answers = []
containers = []

rules = File.readlines(ARGV[0], chomp: true)
first_bag = ARGV[1]
containers << first_bag

until containers.empty?
  next_set = []
  containers.each do |bag|
    next_set += rules.select { |r| r.match(/^(.*) bags contain.* \d+ #{bag}/) }
                     .map! { |b| b.gsub(/ bags.*/, '') }
    puts "bags that can contain #{bag} are #{next_set}"
  end
  next_set.uniq!
  containers = next_set
  answers += next_set
  answers.uniq!
end

puts '----'
puts "#{answers.length} bags can contain a #{first_bag} bag"
puts 'They are:'
pp answers
puts "Answer: #{answers.length}"
