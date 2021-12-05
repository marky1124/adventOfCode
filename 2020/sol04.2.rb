# 
# The expected fields are as follows:
# 
#     byr (Birth Year)
#     iyr (Issue Year)
#     eyr (Expiration Year)
#     hgt (Height)
#     hcl (Hair Color)
#     ecl (Eye Color)
#     pid (Passport ID)
#     cid (Country ID)
# 
# Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.
# 
# Here is an example batch file containing four passports:
# 
# ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
# byr:1937 iyr:2017 cid:147 hgt:183cm
# 
# iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
# hcl:#cfa07d byr:1929
# 
# hcl:#ae17e1 iyr:2013
# eyr:2024
# ecl:brn pid:760753108 byr:1931
# hgt:179cm
# 
# hcl:#cfa07d eyr:2025 pid:166559648
# iyr:2011 ecl:brn hgt:59in
# 
# The first passport is valid - all eight fields are present. The second
# passport is invalid - it is missing hgt (the Height field).
# 
# The third passport is interesting; the only missing field is cid,
# so it looks like data from North Pole Credentials, not a passport at
# all! Surely, nobody would mind if you made the system temporarily ignore
# missing cid fields. Treat this "passport" as valid.
# 
# The fourth passport is missing two fields, cid and byr. Missing cid is
# fine, but missing any other field is not, so this passport is invalid.
# 
# According to the above rules, your improved system would report 2 valid
# passports.
# 
# Count the number of valid passports - those that have all required
# fields. Treat cid as optional. In your batch file, how many passports
# are valid?
# 
# part 2:
#
# You can continue to ignore the cid field, but each other field has
# strict rules about what values are valid for automatic validation:
# 
#     byr (Birth Year) - four digits; at least 1920 and at most 2002.
#     iyr (Issue Year) - four digits; at least 2010 and at most 2020.
#     eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
#     hgt (Height) - a number followed by either cm or in:
#         If cm, the number must be at least 150 and at most 193.
#         If in, the number must be at least 59 and at most 76.
#     hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
#     ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
#     pid (Passport ID) - a nine-digit number, including leading zeroes.
#     cid (Country ID) - ignored, missing or not.
# 
# Your job is to count the passports where all required fields are both
# present and valid according to the above rules.
# 


passports = File.readlines(ARGV[0], chomp:true)
                .slice_when do |a, b| b=="" end.map {|e| e.join(' ').strip}

required_fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
required_fields.each {|field|
  passports.delete_if {|e| !e.match(field+':')}
}

# validate byr
passports.delete_if {|p|
  if matches = p.match(/byr:(\d{4})\b/)
    byr = matches.captures[0].to_i
    byr < 1920 || byr > 2002
  else
    true
  end
}

# validate iyr
passports.delete_if {|p|
  if matches = p.match(/iyr:(\d{4})\b/)
    iyr = matches.captures[0].to_i
    iyr < 2010 || iyr > 2020
  else
    true
  end
}

# validate eyr
passports.delete_if {|p|
  if matches = p.match(/eyr:(\d{4})\b/)
    eyr = matches.captures[0].to_i
    eyr < 2020 || eyr > 2030
  else
    true
  end
}

# validate hgt
passports.delete_if {|p|
  if matches = p.match(/hgt:(\d+)(cm|in)\b/)
    hgt = matches.captures[0].to_i
    unit = matches.captures[1]
    if unit == 'cm'
      hgt < 150 || hgt > 193
    elsif unit == 'in'
      hgt < 59 || hgt > 76
    else
      true
    end
  else
    true
  end
}

# validate hcl
passports.delete_if {|p| !p.match(/hcl:#[0-9a-f]{6}\b/) }

# validate ecl
passports.delete_if {|p| !p.match(/ecl:(amb|blu|brn|gry|grn|hzl|oth)\b/) }

# validate pid
passports.delete_if {|p| !p.match(/pid:\d{9}\b/) }

puts "Number of valid passports = #{passports.length}"
