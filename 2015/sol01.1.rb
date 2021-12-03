s = File.read(ARGV[0]).chomp
# puts "s<#{s}>"
puts "Floor number #{s.count('(') - s.count(')')}"
