# frozen_string_literal: true

# Represents a directory
class Dir
  attr_reader :parent, :files, :name, :dirs

  def initialize(parent, name)
    @parent = parent
    @name = name
    @files = []
    @dirs = []
  end

  def add_file(file)
    @files << file
  end

  def add_dir(dir)
    @dirs << dir
  end

  def to_s
    name = "#{@name}: files:"
    @files.each { |f| name += " #{f}" }
    name += '  dirs:'
    @dirs.each { |d| name += " #{d.name}" }
    name
  end

  def size
    size = 0
    @files.each { |f| size += f.size }
    @dirs.each { |d| size += d.size }
    size
  end

  def path
    parent.nil? ? name : "#{parent.path}:#{name}"
  end
end

# Represents a file
class File
  attr_reader :size, :name

  def initialize(size, name)
    @size = size.to_i
    @name = name
  end

  def to_s
    @name
  end
end

# Solve a puzzle from https://adventofcode.com
class Solve
  TOTAL_FILESYSTEM_SIZE = 70_000_000
  REQUIRED_FREE_SPACE = 30_000_000

  # $ cd /
  # $ ls
  # dir a
  # 14848514 b.txt
  # $ cd ..
  def self.it
    cwd = Dir.new(nil, '/')
    dirs = { '/': cwd }
    File.readlines(ARGV[0] || 'in07', chomp: true).each do |line|
      next if ['$ cd /', '$ ls'].include?(line)

      case line
      when /dir/
        name = line.gsub(/^dir /, '')
        dir = Dir.new(cwd, name)
        cwd.add_dir(dir)
        dirs["#{cwd.path}:#{name}"] = dir
      when '$ cd ..'
        cwd = cwd.parent
      when /\$ cd /
        cwd = dirs["#{cwd.path}:#{line.split[2]}"]
      else
        cwd.add_file(File.new(*line.split))
      end
    end

    puts "Answer to part 1 = #{dirs.keys.map { |k| dirs[k].size <= 100_000 ? dirs[k].size : 0 }.sum}"

    current_unused_space = TOTAL_FILESYSTEM_SIZE - dirs[:/].size
    required_unused_space = REQUIRED_FREE_SPACE - current_unused_space
    puts "Answer to part 2 = #{dirs.keys.map { |k| dirs[k].size >= required_unused_space ? dirs[k].size : TOTAL_FILESYSTEM_SIZE }.min}"
  end
end

Solve.it
