floor = 0
s = File.read(ARGV[0]).chomp
s.each_char.with_index do |c, i|
  floor += 1 if c == '('
  floor -= 1 if c == ')'
  if floor == -1
    puts "Answer: Entered the basement on character #{i + 1}"
    exit
  end
end
