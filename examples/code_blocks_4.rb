a = [1,2,3,4]

b = Proc.new {|x| x * 2}
c = lambda {|x| x * 2}

#b.call
#c.call

def foo(executor)
  executor.call(10)

  "Return from foo"
end


# p foo Proc.new {|x| return("Return from Proc with x = #{x}")}

p foo lambda {|x| return("Return from lambda with x= #{x}")}
