# encoding: utf-8

center <<-EOS
  \e[1mCurso avanzado de ruby (wow!)\e[0m


  Roger Campos
  CTO at Camaloon

  Itnig 2013
EOS

block <<-EOS
    El Planning

      * Intensivo de teoría

      * 3-4 ejercicios prácticos

      * Descanso de 10' a las 12:00

      * Ejemplos prácticos de código, repo:
        https://github.com/rogercampos/advanced-ruby

      * Presentacion!
EOS

block <<-EOS

  Guión: 21/9

    * Ruby! (1.9.3)
    * Method lookup
    * Singleton class (o eigenclass)
    * Variables de instancia / clase
    * Modules y code blocks
    * \e[90mPráctica\e[0m: instance_eval & Crea una DSL

    -- 12:00, Descanso 10'

    * Loading code
    * Meta-programming
    * \e[90mPráctica\e[0m: Testing framework

EOS

block <<-EOS

  Guión: 28/9

    * Constants
    * Threads
    * \e[90mPráctica\e[0m: Usando threads con Celluloid

    -- 12:00, Descanso 10'

    * Excepciones
    * Memory leaks / debugging
    * Extender Ruby (C bindings, etc.)
    * Ruby 2.0 y 2.1

EOS

section "Ruby, veriones y Rubygems" do
  block <<-EOS
    * MRI y otras implementaciones

    * Caos! (ya no): 1.8.7 -> 1.9.0, 1.9.1 (donde?), 1.9.2, 1.9.3, 2.0

    * Patches no oficiales (railsexpress)

    * No hay un spec oficial, hay que seguir lo que dice MRI
  EOS

  block <<-EOS
    \e[1mRubygems\e[0m

      * Semantic versioning, ~>

      * Seguridad, rubygems.org hacking case.
        https://gist.github.com/titanous/d891e876c53e55bf0920

      * Investiga las gems que uses

      * Bundler (no sólo en Rails)
  EOS
end

section "Method lookup" do
  code <<-EOS
    * No hay llamadas a métodos, sino envio de mensajes
      entre objetos

    * Signatura de un metodo no incluye argumentos, y se
      pueden repetir

    ! ver method_lookup_1 !
  EOS

  code <<-EOS
    \e[1mMethod Lookup\e[0m

    * El método que termina invocandose se decide en tiempo de ejecución

    * Alrgoritmo de resolución tiene 5 + 5 niveles!

    * eigenclass -> modulos directos -> clase -> modulos de clase -> superclases

    ! ver method_lookup_2 !
  EOS

  code <<-EOS
    * Si no se encuentra candidato, se intenta llamar a method_missing
      siguiendo el mismo orden que antes

    * Bonus! Que hay acerca de modulos incluidos dentro de modulos?

    * PD: `send` invoca por defecto al método superior en la cadena de resolución
      con los mismos argumentos

    ! ver method_lookup_3 !
  EOS

  code <<-EOS
    Referencias:

      * http://blog.rubybestpractices.com/posts/gregory/030-issue-1-method-lookup.html
      * http://blog.rubybestpractices.com/posts/gregory/031-issue-2-method-lookup.html
  EOS
end

section "Singleton class" do
  block <<-EOS
    * En ruby todo son objetos, y las classes también

    * Si las clases también són objetos estos deben tener a su vez una clase,
      y esta es `Class`
  EOS

  code <<-EOS
    # Typical way to create a Class

    class Foo
    end

    # Another way...

    Foo = Class.new

    # More verbose:

    Foo = Class.new(FooSuperClass) do
      # regular class body
      def to_s
        "hello"
      end
    end
  EOS

  block <<-EOS
    * Un momento! Todas las clases són objetos?

    * Y cuál es la clase de la clase de la clase ?

    * La cadena no es infinita, claro, la clase de `Class` és ella misma
  EOS

  code <<-EOS
    1.9.3-p392 :004 > Class.class
     => Class
    1.9.3-p392 :005 > Class.object_id
     => 70126959583040
    1.9.3-p392 :006 > Class.class.object_id
     => 70126959583040
    1.9.3-p392 :007 > Class.class.class.class.class.object_id
     => 70126959583040
  EOS

  block <<-EOS
    * La función general de una clase és definir el comportamiento de sus
      instancias

    * Pero en ruby también se pueden definir métodos a nivel de instancia,
      llamados `singleton methods`, sin afectar ni a la clase original ni a las
      demás instancias que puedan existir de esa clase

    * Comportamiento específico por instancia! Y estos métodos tienen prioridad en la
      cadena de method lookup path (visto antes). Muy útil para crear frameworks de testing!
  EOS

  code <<-EOS
    fido = Dog.new
    snoopy = Dog.new

    def snoopy.alter_ego
      "Red Baron"
    end

    snoopy.alter_ego
    # => "Red Baron"

    fido.alter_ego
    # => NoMethodError: undefined method `alter_ego' for #<Dog:0x0000000190cee0>
  EOS

  block <<-EOS
    * Para permitir esta funcionalidad, cuando se aplican cambios de comportamiento como los
      vistos a nivel de instancia, Ruby crea una copia de la clase original, la asigna como
      nueva clase de la instancia y hace que ésta herede de la original

    * Los nuevos métodos són definidos en esta clase intermedia

    * Esta clase intermedia és la llamada "Singleton Class" o "Eigenclass"
  EOS

  code <<-EOS
    class Dog; end

    snoopy = Dog.new

    def snoopy.alter_ego; "Red Baron"; end

    # Class hierarchy

    snoopy -> (snoopy's Dog) -> Dog -> (regular ruby hierarchy, Object -> BasicObject)
  EOS

  block <<-EOS
    * La herencia de clases modificada es invisible, ruby intenta esconder este
      hecho por considerarlo un detalle de implementación interna:

      # snoopy.class #=> Dog
      # snoopy.class.ancestors #≈> [Dog, Object, Kernel, BasicObject]
      #
      # There is no snoopy's eigenclass !

    * Sin embargo la sintaxis `class << object` abre la eigenclass de "object" y nos permite
      tener acceso a ella


    ! ver eigenclass !
  EOS

  block <<-EOS
    * En ruby 1.9 añadieron una manera fácil de acceder a la eigenclass:

        Object#singleton_class

    * Tambien añadieron otros métodos utiles como "define_singleton_method" y otros
      parecidos que ahorran el trabajo manual de usar la syntaxis "class << self; ...; end"
  EOS

  code <<-EOS
    class Dog
    end

    snoopy = Dog.new
    => #<Dog:0x00000001c4a170>

    snoopy.singleton_class
    => #<Class:#<Dog:0x00000001c4a170>>
  EOS

  block <<-EOS
    # Resumen hasta aquí #

    * Todas las entidades en ruby son objetos

    * Como todo son objetos, todo tiene también una clase asociada

    * Os ayudará pensar de la siguiente forma:

      - Todo son objetos, por lo que cualquier cosa comparte las mismas propiedades
        que cualquier otra cosa y pueden ser tratados igual (#object_id, #class, etc.)

      - Ocurre que hay ciertos objetos que además tienen propiedades adicionales,
        y otras funciones. Por ejemplo las Clases o los Modulos. Se comportan como objetos,
        y tienen tratos especiales (#new, #ancestors, etc.)
  EOS

  block <<-EOS
    # Comparación instancia vs classe #

    # Desde el punto de vista de una instancia

    * Una instancia de una clase tiene (por lo menos) los métodos
      definidos en su clase

    * Pero todas las instancias de una determinada clase tienen los mismos
      métodos!
  EOS

  code <<-EOS
    class Dog
      def hello
        "hola"
      end
    end

    a = Dog.new
    a.hello

    b = Dog.new

    # a y b comparten funcionalidad
  EOS

  block <<-EOS
    # Comparación instancia vs classe #

    # Desde el punto de vista de una clase

    * Tratando una clase como instancia, igual que las instancias de antes,
      cuando se crean tienen los métodos que su clase les ha dado

    * Todas las clases (objetos) tienen los mismos métodos, ya que todas comparten
      la misma clase (Class)
  EOS

  code <<-EOS
    class Class
      def warf
        "Warf"
      end
    end

    A = Class.new
    B = Class.new

    # A y B comparten funcionalidad

    A.warf

    # Recordar que la manera más comun de hacer clases es con la notación implicita de Ruby,
    # pero que és equivalente a la usada anteriormente con Class.new:

    class C
    end

    # A, B y C comparten funcionalidad
  EOS

  block <<-EOS
    * Cómo definimos entonces funcionalidad concreta para las clases?

    * Queremos añadir un método a una clase pero sin afectar a las demás
  EOS

  code <<-EOS
    class A
    end

    A.my_method    # Como implementamos esto?

    # Hacemos un método sólo sobre A

    def A.my_method
    end
  EOS

  block <<-EOS
    * Hemos descubierto los métodos de clase!

    * Para hacer métodos de clase, hay que definirlos sobre esa instancia en particular.

    * Al hacer esto estamos usando el mismo mecanismo de eigenclass que explicamos antes,
      ruby hace una copia de la clase del objeto (hace una copia de Class), la asigna como
      nueva clase del objeto y la hace heredar de la clase original.
  EOS

  code <<-EOS
    class B
    end

    # inheritance tree of B (as an object)
    # B -> Class -> Object -> BasicObject

    def B.singleton_method
      "hello"
    end

    # New inheritance tree of B (as an object)
    # B -> (B's Class) -> Class -> Object -> BasicObject
  EOS

  block <<-EOS
    # Eigenclass de las Classes #

    * Como hemos visto, los llamados "métodos de clase" són en realidad singleton methods
      de la eigenclass de la clase

    * Veremos como funciona el concepto de Eigenclass en las clases, pensar en las clases en
      su dualidad Clase / instancia.

    * Hay todas estas manera de definir un método de clase!
  EOS

  code <<-EOS
    # Different ways to create class methods

    class Dog
      def self.closest_relative
        "wolf"
      end
    end

    class Dog
      class << self
        def closest_relative
          "wolf"
        end
      end
    end

    def Dog.closest_relative
      "wolf"
    end

    class << Dog
      def closest_relative
        "wolf"
      end
    end
  EOS

  block <<-EOS
    * Útima parte! Eigenclass y herencia de clases

    * Como funciona el method lookup path para metodos de clase con herencia, si estos metodos
      se definen a nivel de eigenclass?

    * Tratamos a una clase (p.e. Dog) como un objeto. Cuando intentamos llamar a un metodo
      de Dog, primero vemos si está definido en la eigenclass de Dog, luego si está definido
      en su clase (Class) y sinó seguimos mirando las superclasses de la clase.
  EOS

  code <<-EOS
    class Mammal
      def self.warm_blooded?
        true
      end
    end

    class Dog < Mammal
      def self.closest_relative
        "wolf"
      end
    end

    Dog.closest_relative
    # => "wolf"
    Dog.warm_blooded?
    # => true

    # Method lookup path "simple" para el objeto Dog:
    # (Dog's Class) -> Class -> Object -> BasicObject
    #
    # De dónde saca la definicion de `warm_blooded?` ?
    #
    # No confundir con el method lookup path de las instancias de Dog !

    a = Dog.new

    # (a's Dog) -> Dog -> Mammal -> Object -> BasicObject
  EOS

  block <<-EOS
    * Para hacer que la herencia de métodos de clase funcione en Ruby, el lenguage manipula la
      creación de eigenclasses de manera que siga la misma cadena de herencias a nivel de Clase.

    * Al crear la eigenclass de un objeto que és una Clase, se tiene en cuenta si esta clase tiene alguna
      superclase o subclases definida. Si és así, la nueva eigenclass se asigna como nueva superclase de la
      otra eigenclass, o bien se hace que las otras eigenclases tengan la nueva eigenclass como superclase.
  EOS

  code <<-EOS
    # Ejemplo creación de eigenclass:

    class Mammal
    end

    class Dog < Mammal
    end

    # Method lookup path para el objecto Mammal
    # Class -> Object -> BasicObject
    #
    # Method lookup path para el objeto Dog
    # Class -> Object -> BasicObject

    # Al definir un método en la clase Dog estamos creando una nueva eigenclass para ese objeto:

    def Dog.foo; "hello"; end

    # Nuevo method lookup path para el objeto Dog
    # (Dog's Class) -> Class -> Object -> BasicObject

    # Al definir un método en la clase Mammal, creamos su eigenclass, y también modificamos la
    # cadena de herencias de Dog !

    def Mammal.bar; "bar"; end

    # Nuevo method lookup path para el objeto Mammal
    # (Mammal's Class) -> Class -> Object -> BasicObject
    #
    # Nuevo method lookup path para el objeto Dog
    #
    # (Dog's Class) -> (Mammal's Class) -> Class -> Object -> BasicObject
  EOS

  center <<-EOS
    # Final de eigenclass! #

    Referencias:
    http://madebydna.com/all/code/2011/06/24/eigenclasses-demystified.html


    Preguntas?
  EOS
end

section "Variables de instancia y de clase" do
  block <<-EOS
    * Qué tipos de variables hay en ruby?

    * locales, de instancia, de clase, globales, constantes
  EOS

  code <<-EOS
    foo = 5

    @foo = 5

    @@foo = 5

    $foo = 5

    FOO = 5
  EOS

  block <<-EOS
    * Las variables locales y globales són bastante fáciles, alguna duda sobre ellas?

    * Las constantes són más curiosas, pero las veremos más adelante

    * Vamos a por las de instancia y de clase!
  EOS

  block <<-EOS
    * A menudo hay confusión entre estos tipos de variable, ya que muchas veces se usan varibales
      de instancia "de la clase" !

    * Como hemos visto antes, las clases también son objetos y instancias de la clase Class, así que
      pueden tener variables de instancia
  EOS

  code <<-EOS
    * Pensar que el código escrito dentro del contexto de las clases se evalua cuando se carga ese codigo,
      cuando se lee el archivo

    * Las variables de clase són unicas para toda la clase y subclasses. Sólo hay un valor posible.

    * Variables de instancia tienen un valor diferente para cada instancia. Si hablamos de una clase, su
      vairbale de instancia sera diferente para cada objeto Clase que haya (no importa herencia).

    * Muy útil para aislar comportamiento, por ejemplo estado intermedio dentro de un módulo.

    * Cuidado porque no es threadsafe!

    ! ver class_vars !
  EOS

  block <<-EOS
    Referencias:

    * http://web.archive.org/web/20080720172603/http://sporkmonger.com/2007/2/19/instance-variables-class-variables-and-inheritance-in-ruby
  EOS
end

section "Code blocks" do
  block <<-EOS
    * Los bloques de código en ruby son el equivalente al concepto closures de otros lenguajes (js, ...)

    * Los bloques són la esencia de Ruby. Cada lenguaje de programación modifica la forma que tienes de
      buscar soluciones a los problemas. Si usas bloques correctamente estarás resolviendo los problemas pensando
      en Ruby.

    * Ejemplos de casos de uso para bloques...
  EOS

  code <<-EOS
    # Pre y Post process

    # Without block
    file = File.open("foo.txt","w")
    file << "This is tedious"
    file.close

    # With block
    File.open("foo.txt","w") { |f| f << "This is sexy" }

    # ejemplo de implementacion
    def self.open(file, mode ="r")
      file = open(file, mode)
      yield(file)
      file.close
    end
  EOS

  code <<-EOS
    # Callbacks / hooks

    # Run the given code at specific time
    before_filter(only: :index) { puts "Runnig before each request to :index" }
  EOS

  code <<-EOS
    # Interface simplification

    Braintree::Configuration.configure do |config|
      config.environment = "production"
      config.merchant_id = "abc"
      config.public_key = "abc"
      config.private_key = "abc"
    end

    # alternative...

    Braintree::Configuration.config.environment = "production"
    Braintree::Configuration.config.merchant_id = "abc"
    Braintree::Configuration.config.public_key = "abc"
    Braintree::Configuration.config.private_key = "abc"
  EOS

  block <<-EOS
    * Podeis ser muy creativos en el uso de bloques de código!

    * Un par de ejemplos...
  EOS

  code <<-EOS
    # Mecanismo generico de retry

    def with_retry(n = 2, exception = Exception, &block)
      yield
    rescue exception
      n < 0 ? raise : with_retry(n - 1, &block)
    end

    # Uso
    with_retry do
      # Codigo ruby que puede fallar por algun motivo y hay que reintentar
      # (llamadas a apis externas, etc...)
    end
  EOS

  code <<-EOS
    # TAP !
    # 5.tap {|x| p x} #=> 5

    # Evita variables auxiliares
    price = cart.calculate_price(quantity: 4)

    show_warning if price > 5000
    number_to_currency(price)

    # with tap
    cart.calculate_price(quantity: 4).tap do |price|
      show_warning if price > 5000
      number_to_currency(price)
    end
  EOS

  block <<-EOS
    * Hay dos tipos generales de bloques, los implicitos y los explícitos

    * Bloques implicitos no son entidades como tal, siempre que se escriben es para ser usados en el contexto
      de llamada a un método como argumento de bloque implícito.

    * No puedes crear un bloque implicito y asignarlo a una variable (ambiguidad de syntax con Hash !)

    * Bloques explícitos sí son entidades, puedes asignarlos a variables, transferirlos entre métodos, guardarlos, etc.
      (pero no puedes serializarlos...)

    ! ver code_blocks_1 !
  EOS

  block <<-EOS
    * Como convertimos de un bloque explicito a uno implicito?

    * El operador & convierte el bloque dado de implicito a explicito o viceversa

    * El uso de este operador no es libre, sólo puede usarse al llamar a un método con un bloque explícito,
      o dentro de un método para recibir un bloque implícito y convertirlo en explícito

    ! ver code_blocks_2 !
  EOS

  block <<-EOS
    * Usar yield dentro de un método ejecutará el bloque implicito pasado

    * Podemos usar `block_given?` para saber si nos han pasado un bloque implicito desde el metodo

    * Usa `yield` si no necesitas usar el bloque, usa `&block` como útlimo argumento si tienes que manipular
      el bloque (pasarlo a otra funcion, etc)
  EOS

  block <<-EOS
    * BONUS: El operador & devolverá el resulto de ejectuar `to_proc` sobre el objeto si este no es un block/proc

    ! ver code_blocks_3 !
  EOS

  block <<-EOS
    * Diferencias entra Proc y lambda

    * Comprovacion de argumentos (ArgumentError vs NilError)

    * local return o no

    ! ver code_blocks_4 !
  EOS

  block <<-EOS
    # References:

    * http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby/
    * http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
  EOS
end

section "Modulos" do
  block <<-EOS
    * Los modulos son el componente de Ruby más raro a los programadores que vienen de otros lenguajes

    * Un módulo puede contener métodos de instancia o métodos de modulo

    * Los metodos de instancia no son accesibles directamente, tan sólo serán añadidos al objeto que incluya o
      extenda el modulo, como métodos de instancia del objeto o bien como métodos de instancia de la eigenclass del objeto.

    * Los metodos de modulo sin són usables directamente, y no son incluidos en el objeto que lo incluye o extiende

    * Para qué son utiles...?
  EOS

  block <<-EOS
    # Namespacing

    * Usar módulos es la unica manera de asegurar que diferentes componentes no colisionen entre sí por usar
      el mismo espacio de nombres
  EOS

  block <<-EOS
    # Augmentar clases

    * Abstraer funcionalidades comunes en modulos, ejemplo:

      class Cart < ActiveRecord::Base
        include DefaultValue

        default_value(:name) { "Valor por defecto de :name" }
      end
  EOS

  block <<-EOS
    # Descomponer clases en trozos pequeños?

    * Es usual usar modulos para "mover" lógica relacionada de una clase a un modulo, y añadir el modulo a la clase

    * Si bien esto sirve para organizar mejor el codigo en archivos, el resultado es el mismo, una clase grande

    * Si esto ocurre suele ser un síntoma de que hay que hacer nuevas abstracciones en el código y sacar nuevas clases
      ver: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
  EOS

  block <<-EOS
    * Generalmente la gente entiende que tienen que usar `include` para añadir métodos de instancia a una clase, y
      `extend` para añadir métodos de clase

    * Aunque esto claramente es cierto, el funcionamiento real de include y extend es diferente:

      - `extend` añadirá los metodos del modulo como singleton methods del default receiver
      - `include` añadirá los metodos del modulo como metodos de instancia del default receiver (solo puede ser una
        Clase o un Modulo)

    * Lo vemos en más detalle:
  EOS

  code <<-EOS
    # extend és en realidad un metodo de Object (no una keyword) y puede usarse en cualquier cosa

    module A
      def foo
        p "A#foo"
      end
    end

    a = "Random object"
    a.extend A
    a.foo #=> "A#foo"


    # Es equivalente a:
    def a.foo
      p "Test"
    end
  EOS

  code <<-EOS
    # include és en realidad un método de Module. Así que solo puede funcionar con modulos y clases
    # (Class hereda de Module).

    module M
      def foo
        p "A#foo"
      end
    end

    a = Class.new
    a.include M

    a.new.foo #=> "A#foo"
  EOS

  block <<-EOS
    * Ultimo uso recomendado para modulos: Extensión segura

    * En situaciones en que debemos sobreescribir métodos existentes, ruby nos da varias opciones.
      Podemos usar def, define_method o alias / alias_method_chain para crear un nuevo método con el
      mismo nombre y así reimplementar la lógica (lo veremos más adelante).

    * Pero esta solución es poco elegante y tiene problemas. Perdemos el acceso al nuevo método
      si es redefinido luego. Es mejor extender el objeto con un módulo que defina el metodo,
      así continua existiendo usando `super`

    ! ver modules_1 !
  EOS

  block <<-EOS
    # Referencias

    * Practicing Ruby 8 - 11
    * http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
  EOS
end

section "Practica 1: DSL" do
  block <<-EOS
    Ejercicio: Implementar una DSL simple

    * Las DSL es un tipico ejemplo de uso práctico y efectivo de Ruby, gracias a
      su uso de bloques y versatilidad de modificar el contexto de ejecución

    * Veremos el uso práctico de `instance_eval` para crear una DSL y implementaremos
      una de prueba.

  EOS

  block <<-EOS
    * `instance_eval` forma parte de la familia de metodos de evaluación de codigo junto con
      `eval` y `class_eval`. Los últimos los veremos después.

    * instance_eval ejecuta el bloque dado en el contexto del objeto en el cual se ejecuta.

    * Una descripción más clara es que és capaz de modificar el `self` dentro del bloque dado.
  EOS

  code <<-EOS
    class A
      def self.foo
        "Hello"
      end
    end

    A.instance_eval do
      p foo
    end

    #=> "Hello"

    str = "Hello world"
    str.instance_eval do
      p upcase
    end #=> "HELLO WORLD"
  EOS

  block <<-EOS
    * El codigo que hay en el bloque se ejecuta en un contexto donde `self` vale A.

    * Esto aplica a las llamadas a métodos (llamar a un metodo sin un receptor explicito va a usar self)

    * Las DSL usan instance_eval ya que pueden evaluar un código dado como bloque en otro contexto

    * También aplica al acceso a variables de instancia

    * Y si defines métodos, estos serán añadidos a este `self` como nuevos métodos de instancia
      del objeto
  EOS

  code <<-EOS
    class A
    end

    A.instance_eval do
      def foo
        "Hai"
      end
    end

    A.foo #=> "Hai"
  EOS

  code <<-EOS
    # API:

    q1 = question("Who is the president of Spain?") do
      wrong   "Rubalcaba", :a
      wrong   "Carmen de mairena", :b
      right   "A joke", :c
    end

    p q1.answer :c #=> Right!


    # Un esqueleto básico para empezar:
    # ____________________________________________________

    def question(name)
      Question.new(name)
    end

    class Question
      attr_accessor :title

      def initialize(title)
        @title = title
        @answers = []
      end

      def answer(letter)
        answer = @answers.find{|x| x.letter == letter}
        answer && answer.right? ? "Right!" : "Sorry, wrong"
      end
    end

    class Answer
      attr_accessor :title, :letter

      def initialize(rightness, title, letter)
        @right, @title, @letter = rightness, title, letter
      end

      def right?
        @right
      end

      def wrong?
        !right?
      end
    end
  EOS
end

section "Cargando codigo" do
  block <<-EOS
    * Hay diferentes maneras de cargar codigo ruby, a saber...

      - require
      - require_relative
      - load
      - autoload
  EOS

  block <<-EOS
    # Empezamos por load !

    * Muy simple, lee el archivo dado y evalua su contenido

    * Referencia el archivo por fullpath / relative al current dir (con extension)

    * Util para implementar auto-reloads (rails)
  EOS

  code <<-EOS
    >> load "file.rb"

    def fake_load(file)
      eval File.read(file)
      true
    end
  EOS

  block <<-EOS
    # Require

    * require 'file' es la manera más comun de cargar codigo en Ruby

    * como `load` pero guarda un index interno para no cargar dos veces
      el mismo archivo
  EOS

  block <<-EOS
    # Require relative

    * Igual que require pero los archivos son referenciados desde la carpeta
      donde está el archivo que hace el require_relative, en vez del current
      working directory
  EOS

  block <<-EOS
    # Autoload

    * Autoload permite añadir un "hook" basado en el acceso a una constante,
      y cargar un archivo dado cuando falle
  EOS

  code <<-EOS
    # file.rb
    class A
      def foo
        "Hola"
      end
    end

    # test.rb
    autoload(:A, "file.rb")

    defined?(A) #=> nil

    A.new.foo #=> "Hola"

    defined?(A) #=> "constant"
  EOS

  block <<-EOS
    * Autoload sirve en dos escenarios:

    1) Si tienes mucho código en la aplicación y quieres conseguir un boot time más rapido
      (rails), gracias al lazy load de partes del codigo (aunque Rails implementa su propio autoload)

    2) Si tienes dependencias opcionales y exclusivas entre ellas, y sólo una de muchas va a usarse
      en tiempo de ejecución
  EOS

  code <<-EOS
    $load_hooks = Hash.new

    module Kernel
      def fake_autoload(constant_name, file_name)
        $load_hooks[constant_name] = file_name
      end
    end

    def Object.const_missing(constant)
      load $load_hooks[constant]
      const_get(constant)
    end

    fake_autoload :A, "file.rb"
    defined?(A) #=> nil
    A
    defined?(A) #=> "constant"
  EOS

  code <<-EOS
    class A; end

    autoload :A, "file.rb"

    A # ??
  EOS

  block <<-EOS
    * En la práctica los casos de uso donde autoload és util son pocos

    * Pocos casos en que tengas tanto código que sea util el autoload por motivos
      de boot time, y aun así se implementan soluciones custom! (Rails)

    * Tiene problemas con thread safety
  EOS

  block <<-EOS
    # Referencias

    * https://practicingruby.com/articles/ways-to-load-code?u=dc2ab0f9bb
  EOS
end

section "Meta-programming" do
  block <<-EOS
    * La meta programación es la esencia del lenguaje !

    * Los dos mundos, "programming" y "meta-programming" se mezclan y estan al mismo nivel,
      no son dos universos separados

    * EL lenguaje expone muchas de sus funcionalidades internas al exterior, no hay una clara distinción
      entre qué es lenguaje y qué STDlib.

    * "Cosas" como `require`, `include` o `extend` són sólo metodos de objetos existentes al espacio de usuario
      del lenguaje, y pueden sobreescribirse sin problemas, permitiendo modificar aspectos clave del funcionamiento
      de Ruby (Rubygems con require).
  EOS

  block <<-EOS
    * En general casi cualquier cosa que se puede hacer "de manera normal" con Ruby tiene su equivalente
      dinámico.

    * Envio de mensajes entre objetos: "obj.upcase" vs "obj.send(:upcase)"

    * Creación de instancias: "class Foo; end" vs "Foo = Class.new" (igual para modulos)

    * Definición de metodos: "def foo(x); end" vs "define_method(:foo) { |x| ... }"

    * Evaluación de codigo: "a = 89" vs "eval('a = 89')"
  EOS

  block <<-EOS
    # Usos de la metaprogramación en ruby ?
  EOS

  center <<-EOS
    DRY de código similar
  EOS

  code <<-EOS
    class CacheDelegator
      def initialize(backend)
        @backend = backend
      end

      %w(read write).each do |method|
        define_method method do |*args, &block|
          if ActionController::Base.perform_caching
            @backend.send(method, *args, &block)
          end
        end
      end

      def fetch(*args, &block)
        if ActionController::Base.perform_caching
          @backend.fetch(*args, &block)
        else
          yield
        end
      end
    end
  EOS

  center <<-EOS
    Abstracciones

    - definir métodos dinamicamente es conveniente
  EOS

  code <<-EOS
    # La API es lo más importante en Ruby !
    class A
      attr_accessor :name
      extend Downcaseizer

      downcase :name
    end

    module Downcaseizer
      def downcase(attr)
        define_method(attr)
          super.to_s.downcase
        end
      end
    end
  EOS

  center <<-EOS
    Black Holes

    - method_missing permite responder a cualquier mensaje

    - util para implementar delegaciones a otros servicios / objetos
  EOS

  code <<-EOS
    class Decorator < SimpleDelegator
      def quantity
        10
      end
    end

    a = Decorator.new("Hola")
    a.quantity #=> 10
    a.upcase #=> "HOLA"

    # Tenemos un objecto 'a' que és igual que un String pero
    # con algunos comportamientos adicionales
  EOS

  block <<-EOS
    * La imaginación es el limite!

    * Vamos a ver la teoria más en detalle...
  EOS

  section "Familia de eval methods y binding" do
    block <<-EOS
      * Hay varios tipos de metodos capaces de evaluar codigo:

        - eval
        - instance_eval
        - class_eval (o module_eval, sinonimo)

      * Todos estos también tienen su correspondiente "instance_exec",
        "class_exec", etc...
    EOS

    block <<-EOS
      # eval

      * Es el más clasico, le pasas un String representando codigo ruby y lo evalua en el contexto
        actual, igual como si escribiras el codigo.

      * En la mayoría de los casos no debería usarse...
    EOS

    code <<-EOS
      a = "Hello"

      eval("a << ' world'; p a")
    EOS

    block <<-EOS
      * Como hemos visto eval ejecuta el codigo en el mismo contexto en que eval se ha llamado, pero
        esto puede cambiar

      * `eval` puede recibir un segundo argumento, un objeto "binding", que representa un contexto de ejecución en ruby
    EOS

    code <<-EOS
      class Demo
        def initialize(n)
          @secret = n
        end
        def get_binding
          return binding
        end
      end

      k1 = Demo.new(99)
      b1 = k1.get_binding
      k2 = Demo.new(-3)
      b2 = k2.get_binding

      eval("@secret", b1)   #=> 99
      eval("@secret", b2)   #=> -3
      eval("@secret")       #=> nil
    EOS

    block <<-EOS
      * Los bingins són utiles para recordar el contexto de ejecución en un momento dado

      * Los Procs / lambdas guardan automaticamente el binding donde han sido creados, ya que potencialmente necesitan
        acceder a esa memoria

      * Siempre que creas un binding estas conservando una referencia a ese contexto (incluyendo toda la memoria referenciada
        en ese momento). Cuidado con posibles memory leaks.
    EOS

    code <<-EOS
      class Foo
        attr_accessor :bar
        def initialize
          @bar = 42
        end

        def get_proc
          Proc.new {|x| @bar * x}
        end
      end

      a = Foo.new
      b = a.get_proc
      b.call(10) #=> 420

      a.bar = 4
      b.call(10) #=> 40

      # en este punto aunque 'a' no se utilize más, nunca será garbage colected
      # hasta que b se elimine, ya que ese Proc está conservando una referencia implicita
      # hacia la instancia 'a'
    EOS

    block <<-EOS
      * Un uso muy bueno para los bindings és el que da 'better_errors' con 'binding_of_caller'.

      * Es una gem para rails que proporciona una nueva pagina de error cuando se produce una excepción

      * Te abre un REPL y te pinta el stacktrace del error, pudiendo clicar en cada frame
        del backtrace y abriendo el REPL en cada contexto.
    EOS

    block <<-EOS
      # instance_eval

      * Lo hemos visto anteriormente "por encima", evalua el código dado cambiando `self` por el objeto
        sobre el que se invoca

      * Es un método de BasicObject, así que esta disponible para cualquier objeto

      * Si defines metodos dentro, estos metodos serán asociados al "objeto", igual como si hicieras:
        class << object; ||BLOQUE AQUI|| ; end

      * En vez de un bloque, instance_eval también admite un String (un codigo ruby en formato string).
    EOS

    code <<-EOS
      class Klass
        def initialize
          @secret = 99
        end
      end
      k = Klass.new
      k.instance_eval("@secret")    # => "99"
      k.instance_eval("@secret=42") # => "42"

      k.instance_eval("def hi() \"Hello there\" end")
      k.hi()  # => "Hello there"
    EOS

    block <<-EOS
      # class_eval / module_eval

      * Las dos versiones són iguales, una es alias de la otra

      * Són metodos de Module, por lo que sólo estan disponibles en modulos o clases, no en cualquier objeto!

      * Los métodos que definas usando esta tecnica quedaran integrados como métodos de instancia de las instancias
        de esa clase (igual como si definieras el método directamente dentro del scope de la Class)

      * Cualquier otro código será evaluado en un contexto donde self es la clase
    EOS

    code <<-EOS
      class A
        @var = "999"
      end

      A.class_eval do
        def hi
          "Hola"
        end
      end

      foo = A.new
      foo.hi #=> "Hola"

      A.class_eval do
        p @var
      end #=> "999"

      A.instance_eval do
        p @var
      end #=> "999"
    EOS

    block <<-EOS
      * Como veis la diferencia real entre uno y otro és qué pasa con los metodos definidos dentro

      * Evaluar otro codigo aparte de 'def...' será igual entre las dos versiones

      * class_eval es el equivalente también a reabrir la clase, pero esto puedes hacerlo dinamicamente
        (le pasas un bloque cualquiera)
    EOS

    block <<-EOS
      # instance_exec y compañia

      * Existen también instance_exec / class_exec

      * Estos métodos son equivalentes a los que acabamos de ver, pero sólo trabajan con un bloque (no strings)
        y adicionalmente pueden enviar argumentos al bloque
    EOS

    code <<-EOS
      class KlassWithSecret
        def initialize
          @secret = 5
        end
      end

      k = KlassWithSecret.new
      k.instance_exec(3) {|x| @secret + x }   #=> 8
    EOS

    block <<-EOS
      # Diferencias entre usar instance_eval / class_eval con un bloque o con un string ?

      * Hemos hablado antes de los bindings, usar estos metodos con un bloque crea un bloque (evidente)
        con un binding hacia el contexto exterior. El bloque siempre va a mantener una referencia a la memoria
        externa, por lo que puede suponer problemas de memory leaks en algun caso. La version string no tiene este problema.

      * Usar un string es en general más lento y consume más memoria, ya que ruby crea una parser y evuala el string desde 0
        en vez de reutilizar el mismo parser.

      * Hay diferencias en el constant lookup, pero esto lo veremos la semana siguiente.
    EOS
  end

  section "getter / setters dinamicos" do
    block <<-EOS
      * Existen getters / setters dinamicos para modificar estos tipos de variables:

      * const_get / const_set

      * instance_variable_get / set

      * class_variable_get / set

      * No existe para modificar variables locales! Es uno de los pocos casos en que usar
        'eval' és la unica solucion para hacerlo de manera dinamica
    EOS

    code <<-EOS
      class Foo
        @@var = 10
        @var = 5

        MAX = 99
      end

      Foo.instance_variable_get("@var") #=> 5
      Foo.class_variable_get("@@var") #=> 10
      Foo.const_get("MAX") #=> 99
    EOS
  end

  section "hooks" do
    block <<-EOS
      * Ruby tiene una serie de "hooks", métodos que puedes implementar y
        que serán llamados por ruby cuando ciertos eventos ocurran

      * El más tipico es "included". Puedes implementar este metodo en un modulo y será
        llamado siempre que el modulo sea incluido en alguna clase / modulo

      * Como argumento recibes la clase o modulo que ha incluido al modulo actual
    EOS

    code <<-EOS
      module A
        def self.included(base)
          puts "#{base} just included A"
        end
      end

      class Foo
        include A
      end

      #=> "Foo just included A"
    EOS

    block <<-EOS
      * Este truco és tipicamente usado para implementar include/extend de un modulo
        a la vez, es decir incluir un modulo y que este modulo sea capaz de añadir métodos
        de instancia y de clase a la vez.

      * Ejemplo !
    EOS

    code <<-EOS
      module A
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def singular
            "sing"
          end
        end

        def pay
          "pay"
        end
      end

      class Foo
        include A
      end

      Foo.singular #=> "sing"

      Foo.new.pay #=> "pay"
    EOS

    block <<-EOS
      * Tambien hay otros hooks ! ->

      * "extended", similar a included pero cuando el modulo es extendido

      * method_added / method_removed -> Llamados siempre que un metodo de instancia es
        definido o eliminado!
    EOS

    block <<-EOS
      * Por ultimo tenemos "inherited" !

      * Es un callback que se invoca siempre que se cree una subclase de la clase que tiene
        definido el hook.

      * (Nunca lo he usado, pero hay que saber que existe!)
    EOS

    code <<-EOS
      class Foo
         def self.inherited(subclass)
            puts "New subclass: #{subclass}"
         end
      end

      class Bar < Foo
      end

      class Baz < Bar
      end

      #=> New subclass: Bar
      #=> New subclass: Baz
    EOS
  end

  section "Introspección" do
    block <<-EOS
      * Ruby también tiene un monton de métodos para sacar información

      * methods, constants, ancestors, instance_variables

      * included_modules, instance_methods, method_defined?, defined?

      * protected_instance_methods, private_instance_methods, ...
    EOS
  end

  section "Definir métodos dinamicamente" do
    block <<-EOS
      * Existen dos metodos que podemos usar para crear métodos de manera dinamica:
        define_method / define_singleton_method

      * define_method creará un nuevo metodo de instancia sobre el receiver

      * define_singleton_method hará lo mismo sobre la singleton_class del receiver,
        es equivalente a hacer: class << self; define_method(...); end;
    EOS

    code <<-EOS
      class Foo
        define_method(:hi) do
          puts "Hello"
        end

        define_singleton_method(:hoo) do
          puts "Hoooo"
        end
      end

      Foo.new.hi #=> "Hello"
      Foo.hoo #=> "Hoooo"
    EOS

    block <<-EOS
      * Diferencias entre usar "def" y "define_method" ?

      1) def es una keyword del lenguaje, mientras define_method és un metodo de Module (puede hackearse!)

      2) def no crea un clojure, el codigo de dentro de un def no tiene acceso
        a las variables exteriores, mientras que usando define_method sí tienes este
        acceso. Creas un clojure que mantiene un binding con el context exterior.

      3) Las reglas que dicen dónde va a parar el nuevo método son distintas en las dos versiones. En el caso
        de define_method, el nuevo método siempre sera definido como metodo de instancia de la clase / modulo
        (recordemos, define_method solo existe para clases / modulos, no objetos)

        En el caso de "def", esto lo decide el lenguaje, y es una evaluación sintáctica, que se rige por
        otras reglas.

        Ejemplo...
    EOS

    code <<-EOS
      class Foo
        def bar
          def cuca
            puts "Called cuca"
          end

          puts "Called bar"
        end
      end

      a = Foo.new
      a.bar #=> "Called bar"
      a.cuca #=> "Called cuca"
    EOS

    block <<-EOS
      * Así como existen maneras de crear métodos de manera dinámica, tambien hay formas de eliminarlos.

      * undef / undef_method / remove_method
    EOS

    block <<-EOS
      # undef / undef_method

      * 'undef' es una keyword del lenguaje, NO un método

      * 'undef_method' en cambio sí es un método (de Class)

      * Las dos versiones hacen lo mismo, pero con "undef" debes usar un identificador
        explícito mientras que con 'undef_method' debes usar un símbolo (y es asi dinamico)

      * El resultado de usar undef o undef_method és que las instancias de la clase ya no
        respondrán más a ese mensaje, de ninguna forma, ni aunque pueda existir más allá en el
        method lookup path
    EOS

    block <<-EOS
      # remove_method

      * és un metodo de Class

      * Similar a undef_method, lo llamas con un simbolo, y lo que hará será eliminar el metodo
        indicado de la clase, sin afectar a nada más

      * Las instancias de la clase todavía pueden recibir llamadas con ese nombre y contestar correctamente
        si el método esta definido en superclases o modulos incluidos (o method_missing)
    EOS

    code <<-EOS
      class Parent
        def hello
          puts "In parent"
        end
      end
      class Child < Parent
        def hello
          puts "In child"
        end
      end

      c = Child.new
      c.hello

      class Child
        remove_method :hello  # remove from child, still in parent
      end
      c.hello

      class Child
        undef_method :hello   # prevent any calls to 'hello'
      end
      c.hello

      In child
      In parent
      prog.rb:23: undefined method `hello' for #<Child:0x401b3bb4> (NoMethodError)
    EOS
  end

  section "Tecnicas de alias" do
    block <<-EOS
      * El metodo del alias es el más antiguamente utilizado en ruby, y sirve para hacer un
        monkey patching directo

      * Es tan utilizado que ha dado lugar a la creación hasta de helpers como el
        "alias_method_chain" de rails
    EOS

    block <<-EOS
      * "alias" es una feature de ruby para duplicar métodos

      * Crea una copia del metodo anterior del metodo dado y le da un nuevo nombre

      * alias <nuevo_nombre> <metodo_actual>

      * alias és una keyword del lenguaje, NO es un método
    EOS

    code <<-EOS
      class Foo
        def hi; "Hello"; end

        alias ho hi
      end

      Foo.new.ho #=> "Hello"
    EOS

    block <<-EOS
      * Como muy convenientemente no crea un simple alias, sinó una copia, podemos hacer cosas como
        estas ...
    EOS

    code <<-EOS
      # This is what alias_method_chain does

      class Foo
        def hi; "Hello"; end

        def new_hi
          "The new hi"
        end

        alias old_hi hi
        alias hi new_hi
      end

      Foo.new.hi #=> "The new hi"
      Foo.new.old_hi #=> "Hello"
    EOS

    block <<-EOS
      * Como veis así podemos crear una especie de "herencia de metodos" custom...

      * Aunque le faltan muchas features, y para hacer esto es mucho mejor usar el
        mecanismo autentico de herencia, mixins, etc. que ya hemos visto.

      * El uso de esta técnica sin embargo sigue siendo muy extendido, ya que te permite
        modificar de manera precisa metodos concretos...
    EOS

    block <<-EOS
      * Cuando és util?

        - No lo uses para código nuevo, es una mala practica

        - Sin embargo es muy util cuando tienes que arreglar / modificar codigo viejo
          y quieres estas seguro de interferir lo mínimo posible

        - De manera similar, al hacer patches a grande codigos externos a tu aplicacion
          (como arreglar bugs de rails) esta es una buena manera


      * SIN EMBARGO! Monkeypatchear codigo externo, aunque necesario a veces, siempre es peligroso:

        - En cualquier update de esa gem el patch puede petar

        - Añade constraints estrictas a tu codigo para asegurar que se ejecuta con una determinada
          versión de esa gem:

          if CarrierWave::VERSION != "1.1.4"
            raise "you must review this patch, future developer, sorry for you"
          end
    EOS
  end

  block <<-EOS
    # Referencias

    * http://ruby-doc.org/core-1.9.3/Class.html
    * http://ruby-doc.org/core-1.9.3/Module.html

    * Preguntas?
  EOS
end

section "Practica 2: Framework de testing" do
  block <<-EOS
    * Vamos a usar técnicas de metaprogramacion para implementar una parte fundamental
      en un framework de testing

    * Implementaremos "stubs" y podremos hacer asserciones sobre la recepción de mensajes
      sobre objetos

    * El objetivo es saber si el objeto dado ha recibido el mensaje esperado, y volver "true"
      si el test fue satisfactorio o "false" sino
  EOS

  code <<-EOS
    module ExternalApi
      def self.sync
        # Work to sync data with external API
        sleep 10
      end
    end

    class A
      def complete
        # comenta y descomenta esta linia para provar que el resultado del test
        # es true / false
        ExternalApi.sync
      end
    end

    def test
      a = A.new

      assert_received(ExternalApi, :sync) do
        a.complete
      end
    end

    p test #=> true

    def assert_received(object, message)
      # TODO !
    end
  EOS
end
