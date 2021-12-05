changes = File.readlines(ARGV[0], chomp: true).map(&:to_i)
known_frequencies = Hash.new(0)

frequency = 0
loop do
  changes.each do |c|
    known_frequencies[frequency] = 1
    frequency += c
    if known_frequencies[frequency] == 1
      puts "Answer is #{frequency}"
      exit
    end
  end
end
