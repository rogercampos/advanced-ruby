class B
  def hello
    "OLA"
  end
end

# inheritance tree of B (as an object)
# B -> Class -> Object -> BasicObject

def B.singleton_method
  "hello"
end

class << B
  def another
    "OTRA"
  end
end

class B

  class << self
    def bla
      98
    end
  end

  def instance_method
    "99"
  end
end

b = B.new

p b.hello

p B.another

