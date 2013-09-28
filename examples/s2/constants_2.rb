class Foo
  HOLA = "ola"
end

a = Foo.new

class << a
  TEST_1 = 1
end

Foo.class_eval do
  TEST_2 = 99
end

Foo.class_eval <<-EOS
  TEST_3 = 199
EOS

p a.singleton_class::TEST_1
p TEST_2                      # En ruby 1.9.1 esto no era cierto !!
p Foo::TEST_3

