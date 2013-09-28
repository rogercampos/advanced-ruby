class Printer
  @messages = {}

  def self.print
    puts yield
  end

  def self.lazy_print(i, &block)
    @messages[i] = block
  end

  def self.print_all
    @messages.each do |block|
      puts block.call
    end
  end

  def self.remove_block(x)
    @messages.delete(x)
  end
end

class Foo
  def initialize(i)
    Printer.print { "hey #{i}" }
  end
end


class LeakyFoo
  def initialize(i)
    @var2 = 100
    Printer.lazy_print(i) { "hey #{@var2}" }
  end
end

10.times { |i|  Foo.new i }
10.times { |i|  LeakyFoo.new i }

GC.start
puts "Foo count = #{ObjectSpace.each_object(Foo).count}"		#=> Foo count = 0
puts "LeakyFoo count = #{ObjectSpace.each_object(LeakyFoo).count}"	#=> LeakyFoo count = 100
