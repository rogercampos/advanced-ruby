class Foo
  def wau
    puts "Original wau"
  end

  def wau
    puts "OLA"
  end
end

a = Foo.new

def a.wau
  super
  puts "a.wau"
end

#class << a
  #def wau
    #super
    #puts "class << a; wau; end"
  #end
#end

# - Different ways to add methods to the instance's eigenclass.
# - First definition on eigenclass respects super
# - Other declarations with the same name, overrides.

p a.singleton_class

#a.wau

__END__

# Simulación manual:

class Foo
  def wau
    puts "Original wau"
  end
end

class FooPrima < Foo
  def wau
    puts "Custom wau"
  end
end

a = FooPrima.new
a.wau
