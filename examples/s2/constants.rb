class Foo
  MAX = 100
  HASH = {}
end

p Foo::MAX
p Foo::HASH

Foo::HASH[:a] = "hola"

p Foo::HASH

