# frozen_string_literal: true

require 'byebug'

# class: 1-3 or 5-7
# row: 6-11 or 33-44
# seat: 13-40 or 45-50
#
# your ticket:
# 7,1,14
#
# nearby tickets:
# 7,3,47
# 40,4,50
# 55,2,20
# 38,6,12
#
#  ruby sol16.2.rb in16
class Solve
  RANGES = 1
  YOUR_TICKET = 2
  NEARBY_TICKETS = 3

  def initialize
    @field_ranges = {}
    @position_values = Hash.new(nil)
    @your_ticket = []
  end

  def solve_it(filename)
    fd = File.open(filename)
    state = RANGES
    until fd.eof
      line = fd.readline.chomp
      case line
      when /^your ticket:/
        state = YOUR_TICKET
        next
      when /^nearby tickets:/
        state = NEARBY_TICKETS
        next
      when /^$/
        next
      end

      case state
      when RANGES
        puts "RANGE: #{line}"
        range_name = line.sub(/:.*/, '') # e.g. 'class'
        range_numbers = line.match(/.*: (\d+)-(\d+) or (\d+)-(\d+)/).captures.map(&:to_i).each_slice(2).to_a
        # => [[1, 3], [5, 7]]
        @field_ranges[range_name] = []
        range_numbers.each do |rn|
          @field_ranges[range_name].push(rn[0]..rn[1])
        end

      when YOUR_TICKET
        puts "YOUR TICKET: #{line}"
        line.split(',').to_a.map(&:to_i).each_with_index do |v, i|
          # puts "your ticket [#{i}]=#{v}"
          @position_values[i] = [] if @position_values[i].nil?
          @position_values[i].push(v)
          @your_ticket.push(v)
        end

      when NEARBY_TICKETS
        # Can we conclude this ticket is invalid?
        # byebug
        numbers = line.split(',').to_a.map(&:to_i)
        valid = false
        numbers.each do |n|
          @field_ranges.values.flatten.each do |r|
            valid = r.include?(n)
            break if valid
          end
          break unless valid
        end
        puts "NEARBY TICKETS: #{line} (valid=#{valid})"

        if valid
          line.split(',').to_a.map(&:to_i).each_with_index do |v, i|
            # puts "nearby ticket [#{i}]=#{v}"
            @position_values[i].push(v)
          end
        end
      end
    end

    puts "field_ranges = #{@field_ranges.inspect}"
    puts "position_values = #{@position_values.inspect}"
    puts "position_values[0] = #{@position_values[0].inspect}"
    puts "position_values[1] = #{@position_values[1].inspect}"
    puts "position_values[2] = #{@position_values[2].inspect}"

    puts 'Determining which the name of each field'
    # byebug
    @field_valid_classes = Hash.new(nil)
    @position_values.keys.sort.each do |position|
      @field_ranges.keys.sort.each do |field|
        valid = false
        @position_values[position].each do |number|
          @field_ranges[field].each do |range|
            valid = range.include?(number)
            break if valid
          end
          break unless valid
        end
        if valid
          @field_valid_classes[position] = [] if @field_valid_classes[position].nil?
          @field_valid_classes[position].push(field)
        end
      end
    end

    puts "@field_valid_classes = #{@field_valid_classes.inspect}"

    field_name = {}
    loop do
      known_fields = @field_valid_classes.keys.select { |k| @field_valid_classes[k].length == 1 }
      # puts "known_fields = #{known_fields}"
      break if known_fields.empty?

      known_fields.each do |position|
        field = @field_valid_classes[position][0]
        puts "position #{position} is #{field}"
        field_name[field] = position
        # Renove this field from all
        @field_valid_classes.each_key { |k| @field_valid_classes[k].delete(field) }
      end
    end

    puts "field_name = #{field_name}"

    departure_field_names = field_name.keys.grep(/departure/)
    puts "departure_field_names = #{departure_field_names}"

    puts "your_ticket = #{@your_ticket}"

    answer = 1
    departure_field_names.each do |field|
      puts "field <#{field}> is in position #{field_name[field]}, " \
           "on your ticket the value is #{@your_ticket[field_name[field]]}"
      answer *= @your_ticket[field_name[field]]
    end

    puts "Answer = #{answer}"
  end
end

filename = ARGV[0] || 'in16'
if filename.nil? || filename.length.zero?
  puts "Usage: #{$PROGRAM_NAME} <file>"
  puts "  e.g: #{$PROGRAM_NAME} in16"
  exit
end

s = Solve.new
Signal.trap('USR1') { puts s.display_progress }
Signal.trap('INFO') { puts s.display_progress } if RUBY_PLATFORM =~ /darwin/ # Reacts to CTRL-T on OS X (ArgumentError in Debian)
s.solve_it(filename)
