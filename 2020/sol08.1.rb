# frozen_string_literal: true

instructions = File.readlines(ARGV[0], chomp: true)
has_run = Array.new(instructions.length, false)
ptr = 0
acc = 0

loop do
  if has_run[ptr]
    puts "Finished run on instruction #{ptr}, the acc value is #{acc}"
    exit
  else
    has_run[ptr] = true
    case instructions[ptr]
    when /^nop/
      puts "#{ptr + 1}: nop"
      ptr += 1
    when /^acc (.*)/
      acc += Regexp.last_match(1).to_s.to_i
      puts "#{ptr + 1}: acc #{Regexp.last_match(1)} => acc=#{acc}"
      ptr += 1
    when /^jmp (.*)/
      puts "#{ptr + 1}: jmp #{Regexp.last_match(1)}"
      ptr += Regexp.last_match(1).to_s.to_i
    else
      puts "Unexpected input <#{instructions[ptr]}>"
    end
  end
end
