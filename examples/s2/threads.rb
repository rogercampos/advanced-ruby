i = 0

t1 = Thread.new do
  50_000.times do
    i += 1
  end
end

t2 = Thread.new do
  50_000.times do
    i += 1
  end
end

t1.join
t2.join

puts i


#__END__

require 'celluloid'

class Counter
  include Celluloid
  attr_reader :i

  def initialize
    @i = 0
  end

  def inc_i
    @i += 1
  end
end


counter = Counter.new

t1 = Thread.new do
  50_000.times do
    counter.inc_i
  end
end
t2 = Thread.new do
  50_000.times do
    counter.inc_i
  end
end

t1.join
t2.join

puts counter.i
