# Interpolaciones de strings no solo con #{}
class FastInterpolation
  attr_accessor :var

  def print
    p "Hola #@var"
  end
end

a = FastInterpolation.new
a.var = "Manuel"

a.print


#------------------------------------------------
# rescue no necesitan begin

class RescueEasy
  def blowup
    1/0
  rescue
    puts "Saved!"
  end
end

RescueEasy.new.blowup


#------------------------------------------------
# Splat operator

class Splat
  def process(*args)
    p args
  end
end

Splat.new.process "hola", 12, [:a, :b]

def print_pair(a,b,*)
  puts "#{a} and #{b}"
end

print_pair 1,2,3,:cake,7

def add(a,b)
  a + b
end

pair = [3,7]
add *pair

first, *list = [1,2,3,4]
first, *primeros, ultimo = [1,2,3,4,5]

p primeros

#------------------------------------------------
# Ignored arguments

def ignore_me(a, _, b)
  puts "Called with #{a} and #{b}"
end

ignore_me "Save", "The", "World"

{a: 1, b: 2}.each do |_, v|
  p v
end


#------------------------------------------------
# iteracion doble

result = {a: 4, b: 5}.each_with_object({}) do |(k, v), h|
  h[:res] = h[:res].to_i + v
  h
end

p result


#------------------------------------------------
# case statement

# 1) Ver ejemplo directo al final del binario bin/tkn.rb
#
# 2) Uso con ===

a = "XXX String asd"

case a

when 1..20
  puts "Entre 1 y 20"
when 25
  puts "Seguro es 25"
when /paco/
  puts "Es un string que hace matching con 'paco'"
when lambda {|x| x[0..2] == "XXX"}
  puts "Empieza por XXX"
when String
  puts "Es un string"
else
  puts "No es nada de lo anterior"
end


# Este uso es con un sólo parametro, y ruby ejecuta el metodo
# === con cada valor, ejemplo:  (1..20) === 14
#
# Tambien hay otra version sin argumento, donde los valores de "when" són
# true/false, que es el caso ya conocido de otros lenguajes de programación.


#------------------------------------------------
# Cualquier contexto es evaluable en ruby

def get_number
  99 / 4.0
end

def test(name, age = (12 * get_number))
  puts "Ejecutando test con age = #{age}"
end

test "Roger"


class Superclass; end
class Subclass < (Object.const_get("Superclass")); end
p Subclass.ancestors


