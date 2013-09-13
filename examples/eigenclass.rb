class Foo
  def wau
    puts "Original wau"
  end
end

a = Foo.new

class << a
  def wau
    super
    puts "class << a; wau; end"
  end
end

def a.wau
  super
  puts "a.wau"
end

# - Different ways to add methods to the instance's eigenclass.
# - First definition on eigenclass respects super
# - Other declarations with the same name, overrides.

a.wau

#__END__

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
