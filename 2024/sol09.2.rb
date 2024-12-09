# frozen_string_literal: true

require 'debug' # 8564936405055 is too high

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    process_file(ARGV[0] || 'in09')
    populate_disk_blocks
    puts "Blocks: #{@blocks}"
    puts "Spaces: #{@free_space_map}"
    defrag_files
    puts "Blocks: #{@blocks}"
    puts "Spaces: #{@free_space_map}"
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
    @free_space_map = []
    @file_map = []
    @disk_map.each do |length|
      if examining_file
        @file_map << [length, block_ptr, file_id]
        length.times do
          @blocks[block_ptr] = file_id
          block_ptr += 1
        end
        file_id += 1
      else
        @free_space_map << [length, block_ptr] unless length.zero?
        block_ptr += length
      end
      examining_file = !examining_file
    end
  end

  def defrag_files
    @file_map.reverse.each do |file_length, file_ptr, file_id|
      @free_space_map.each_with_index do |free_space, fsm_idx|
        free_space_length, free_space_block = free_space
        next if free_space_length < file_length
        next if free_space_block > file_ptr

        file_length.times do |count|
          @blocks[free_space_block + count] = file_id
          @blocks[file_ptr + count] = nil
        end
        @free_space_map[fsm_idx][0] -= file_length
        @free_space_map[fsm_idx][1] += file_length
        break
      end
    end
  end

  def calculate_checksum
    @answer = 0
    @blocks.each_with_index do |v, idx|
      next if v.nil?

      @answer += (v * idx)
    end
  end
end

Solve.new
