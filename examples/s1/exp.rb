#class Foo
  #def hi
     #"ola"
  #end
#end

code = Proc.new {
  def hi
    "ola 3"
  end
}

Foo = Class.new do
  def hi
    "ola 2"
  end
end

Foo = Class.new(&code)

a = Foo.new

p a.hi
