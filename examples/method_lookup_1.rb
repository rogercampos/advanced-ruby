class Foo
  def x
    puts "Called x"
  end

  #def x(name)
    #puts "Called x with #{name}"
  #end
end

Foo.new.x

Foo.new.send(:x)
