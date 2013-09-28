begin
  # Codigo

rescue SomeExceptionClass => some_variable
  # Captura un tipo de excepciones

  raise if rescue_not_valid

rescue SomeOtherException => some_other_variable
  # Captura otra excepcion diferente

else
  # Codigo se ejecuta solo si no se ha capturado ninga excepcion

ensure
  # Siempre se ejecuta
end


def foo(x)
  begin
    1/0
  ensure
    "saved"
  end
end
