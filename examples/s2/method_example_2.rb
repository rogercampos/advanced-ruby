class Foo
  def initialize
    @array = [1,2,3,4,5]
  end

  def process(x)
    x * 10
  end

  def run_ugly
    @array.map {|x| x * 10 }
  end

  def run_nice
    @array.map(&method(:process))
  end
end

a = Foo.new

p a.run_ugly
p a.run_nice

#__END__

# Muy similar a la sintaxis map(&:to_s)

a = [1, 2, 3, 4]

p a.map(&:to_s)

# Crea un objeto Proc a partir del simbolo :to_s
# proc = Proc.new { |x| x.to_s }

# Pero a veces no quieres llamar un método de cada elmeneto de la colección,
# sinó llamar a un metodo externo pasándole como parámetro cada elemento de la colección.

def double_stringify(x)
  (x * 2).to_s # Más logica que no podría conseguirse solo con llamar a un método de un integer
end

p a.map(&method(:double_stringify))

