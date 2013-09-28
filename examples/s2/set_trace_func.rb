set_trace_func proc { |event, file, line, id, binding, classname|
   STDERR.printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
}

@welcome  = "Hello"
separator = ", "
$object   = "world"
@@excl    = "!"
puts(@welcome + separator + $object + @@excl)

#
#     line examples/s2/set_trace_func.rb:5
#     line examples/s2/set_trace_func.rb:6
#     line examples/s2/set_trace_func.rb:7
#     line examples/s2/set_trace_func.rb:8
#     line examples/s2/set_trace_func.rb:9
#   c-call examples/s2/set_trace_func.rb:9        puts   Kernel
#   c-call examples/s2/set_trace_func.rb:9        puts       IO
#   c-call examples/s2/set_trace_func.rb:9       write       IO
# c-return examples/s2/set_trace_func.rb:9       write       IO
#   c-call examples/s2/set_trace_func.rb:9       write       IO
# c-return examples/s2/set_trace_func.rb:9       write       IO
# c-return examples/s2/set_trace_func.rb:9        puts       IO
# c-return examples/s2/set_trace_func.rb:9        puts   Kernel
