x = 1
20.times do
  case 
  when  x % 15.0 == 0
    puts "FizzBuzz"
  when  x % 3.0 == 0
    puts "Fizz"
  when  x % 5.0 == 0
    puts "Buzz"
  else 
    puts x
  end
  x += 1
end
      