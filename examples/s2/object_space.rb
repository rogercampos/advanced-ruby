class Foo
  def initialize
    @var = :hello
  end
end

10.times { Foo.new }
a = :symb

p ObjectSpace.each_object(Foo).count
p ObjectSpace.each_object(Symbol).count
p ObjectSpace.count_objects

p Symbol.all_symbols.count
