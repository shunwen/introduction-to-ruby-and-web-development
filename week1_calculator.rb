puts "Simple calculator!"
print "Enter the first number: "
oprand1 = gets.chomp
print "Enter the second number: "
oprand2 = gets.chomp
print "Choose an operator 1) add 2) sub 3) multiply 4) div : "
operator = gets.chomp

result = case operator.to_i
  when 1 then oprand1.to_i + oprand2.to_i
  when 2 then oprand1.to_i - oprand2.to_i
  when 2 then oprand1.to_i * oprand2.to_i
  else
    oprand1.to_f / oprand2.to_f
end

puts "The answer is #{result}"
