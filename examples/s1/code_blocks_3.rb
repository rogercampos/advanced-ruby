a = [1,2,3,4]

p a.map(&:monnngo)

p a.map{|x| x.to_s }


stringifier = :to_s.to_proc #=> #<Proc:0x007f9e0b69be40>

# => Proc.new {|x| x.to_s}

p a.map(&stringifier)

