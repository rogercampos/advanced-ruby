a = [1, 2, 3, 4]

doubler = Proc.new {|x| x * 10}

# This works
a.map{|x| x * 10}

# This works?

#a.map(doubler) # No.

# But this does

p a.map(&doubler)


def foo(x, &block)
  block.call "Hello"
end

foo(nil) do |x|
  p x.upcase
end

# The &block syntax is just optional, yield works also

def foo(x)
  yield("Hello")
end

