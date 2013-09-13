module ExternalApi
  def self.sync
    # Work to sync data with external API

    puts "Doing big work, failed!"
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

def assert_received(object, message)
  success = nil

  object.define_singleton_method(message) do
    success = true
  end

  yield

  success
end

p test #=> true

