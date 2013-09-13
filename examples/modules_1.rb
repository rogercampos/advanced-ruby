#module A
  #def add_feature
    #m = Module.new do
      #define_method(:foo) do |x|
        #x.upcase
      #end
    #end

    #self.send :include, m
  #end
#end

module A
  def add_feature
    define_method(:foo) do |x|
      x.upcase
    end
  end
end

class Order
  extend A

  add_feature
end

a = Order.new
p a.foo "lower case string"

__END__

class Order
  def foo(x)
    "[ " + super(x) + " ]"
  end
end


p a.foo "lower case string"
