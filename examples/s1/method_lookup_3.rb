class B
  def method_missing(name, *args)
    "Hello from B #method_missing\n"
  end
end

module X
  def method_missing(name, *args)
    "Hello from X #method_missing\n" + super
  end
end

class A < B
  #include X

  def method_missing(name, *args)
    "Hello from A #method_missing\n" + super
  end
end

puts A.new.foobar

__END__

module Utils
  def foo
    "foo from Utils\n" + super
  end
end

module ShippingUtils
  include Utils

  def foo
    "foo from ShippingUtils\n" + super
  end
end

class D
  def foo
    "foo from D"
  end
end

class C < D
  include ShippingUtils

  def foo
    "foo from C\n" + super
  end
end


puts C.new.foo
