# frozen_string_literal: true

# ruby sol25.1.rb 2947 3029

row = ARGV[0].to_i
col = ARGV[1].to_i
if row.zero? || col.zero?
  puts "Usage: #{$PROGRAM_NAME} $row $col"
  puts "  e.g: #{$PROGRAM_NAME} 2947 3029"
  exit
end

# Calculate the nubmer of iterations of code generation are required
iterations = (1..col).reduce(:+) + (col..col + row - 2).reduce(:+) - 1
code = 20_151_125
iterations.times { code = (code * 252_533) % 33_554_393 }
puts "Code at #{row},#{col} = #{code}"
