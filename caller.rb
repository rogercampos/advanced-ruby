def foo(x)
  p caller
  p x
end

def bar(x)
  foo(x)
end

bar("ola")
