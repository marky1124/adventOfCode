# frozen_string_literal: true

require 'digest'

# ruby sol04.2.rb bgvyzdsv

key = ARGV[0]
i = 1
loop do
  if Digest::MD5.hexdigest(key + i.to_s)[0..5] == '000000'
    puts "The answer is #{i}. MD5.digest of #{key + i.to_s} is #{Digest::MD5.hexdigest(key + i.to_s)}"
    exit
  end
  i += 1
end
