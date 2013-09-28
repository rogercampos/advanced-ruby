class Worker
  def calculator(quantity)
    quantity.times do |x|
      throw(:lapse, "Found at: #{Time.now}") if x == 8
    end
  end

  def process(limit)
    calculator(limit)

    "Sorry, not found"
  end
end

result = catch(:lapse) do
  Worker.new.process(5)
end

p result
