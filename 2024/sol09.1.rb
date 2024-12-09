# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in09')
    populate_disk_blocks
    defrag_disk_blocks
    calculate_checksum
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @disk_map = File.readlines(file, chomp: true).map(&:chars).flatten.map(&:to_i)
    @blocks = Array.new(@disk_map.sum)
  end

  def populate_disk_blocks
    file_id = 0
    block_ptr = 0
    examining_file = true
    @disk_map.each do |length|
      if examining_file
        length.times do
          @blocks[block_ptr] = file_id
          block_ptr += 1
        end
        file_id += 1
      else
        block_ptr += length
      end
      examining_file = !examining_file
    end
  end

  def defrag_disk_blocks
    free_space_ptr = @blocks.find_index(nil)
    block_ptr = @blocks.length
    loop do
      loop do
        block_ptr -= 1
        break unless @blocks[block_ptr].nil?
      end
      return if block_ptr <= free_space_ptr

      @blocks[free_space_ptr] = @blocks[block_ptr]
      @blocks[block_ptr] = nil
      loop do
        free_space_ptr += 1
        break if @blocks[free_space_ptr].nil?
      end
      return if block_ptr <= free_space_ptr
    end
  end

  def calculate_checksum
    @answer = 0
    @blocks.compact.each_with_index do |v, idx|
      @answer += (v * idx)
    end
  end
end

Solve.new
