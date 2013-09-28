# Las constantes se buscan por el arbol de definicion
module A
  MAX = 120

  module B; end

  module C
    MAX = 1

    module D
      p MAX
      p A::MAX
      p ::A::MAX
      p Module.nesting
    end
  end
end


# Module.nesting
module A
  module C
    module D
      Module.nesting #=> [A::C::D, A::C, A]
    end
  end
end


# Las constantes se buscan sólo por orden léxico !
module A
  B = 100
end

#module A::C
  #B
#end


module A
  module C
    p B
  end
end

# NameError: uninitialized constant A::C::B


# El segundo paso para buscar una constante es seguir la herencia de la
# current open class
class Baz
  #RES = "VERSION A"
end

class SuperClass
  RES = "VERSION B"
end

class HighClass < SuperClass
  class C < Baz
    p RES
  end
end
