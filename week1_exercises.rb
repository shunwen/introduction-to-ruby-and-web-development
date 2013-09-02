a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "Ex.1"
a.each { |x| puts x }

puts "Ex.2"
a.each { |x| puts x if x > 5 }

puts "Ex.3"
b = a.select { |x| x.odd? }
puts b

puts "Ex.4"
a << 11
a.unshift 0
puts a

puts "Ex.5"
a.delete 11
a << 3
puts a

puts "Ex.6"
a.uniq!
puts a

puts "Ex.7"
puts "http://stackoverflow.com/a/6097702/726819"

puts "Ex.8"
h = {a:1, b:2, c:3, d:4}
h = {:a => 1, :b => 2, :c => 3, :d => 4}

puts "Ex.9"
puts h[:b]

puts "Ex.10"
puts h[:e] = 5

puts "Ex.13"
puts h.reject! {|k,v| v < 3.5}

puts "Ex.14"
puts "Yes, #{{hash_val: [1,2,3]}}"
puts "Yes, #{['array_of_hash', {a:1}, {b:2}]}"

puts "Ex.15"
puts "http://api.rubyonrails.org/, because it's official"
