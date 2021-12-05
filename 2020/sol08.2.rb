# frozen_string_literal: true

instructions = File.readlines(ARGV[0], chomp: true)
change = 0

loop do
  has_run = Array.new(instructions.length, false)
  ptr = 0
  acc = 0
  loop do
    if ptr == instructions.length
      puts "Finished using change=#{change}. The acc value is #{acc}"
      exit
    elsif has_run[ptr]
      break
    else
      has_run[ptr] = true
      instruction = instructions[ptr].clone

      if ptr == change
        case instruction[0..2]
        when 'nop'
          instruction.gsub!('nop', 'jmp')
        when 'jmp'
          instruction.gsub!('jmp', 'nop')
        end
      end

      case instruction
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
  change += 1
  puts "-- change=#{change}"
  if change == instructions.length
    puts 'Failed to find the solution'
    exit
  end
end
