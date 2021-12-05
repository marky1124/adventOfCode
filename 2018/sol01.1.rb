puts "Answer=#{File.readlines('in01', chomp: true).map(&:to_i).sum}"
