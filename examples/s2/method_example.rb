class Foo
  def initalize
    @var = 1
  end
  def hello
    "Hi you #{@var}"
  end
end

a = Foo.new

m = a.method(:hello) #=> Method<..>

# 'a' funciona aquí como un Proc object

p m.call #=> "Hi you"
