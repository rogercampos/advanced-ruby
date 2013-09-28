a = [1, 2, 3, 4]

b = a.map { |x| x * 2}

p b

#__END__

doubler = Proc.new {|x| x * 2 }


p doubler.call(3)
p doubler.call(10)
