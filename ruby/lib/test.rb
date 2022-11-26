require_relative './mockeable'

class Test
  def initialize(nombre, clase_suite)
    @nombre = nombre
    @clase_suite = clase_suite
  end

  def testear
    nombre = @nombre
    clase_suite = @clase_suite
    clase_suite.new.instance_eval do
      TADsPec.configurar_en self
      begin
        send("testear_que_#{nombre}")
        resultado = ResultadoExitoso.new(clase_suite, nombre)
      rescue AsercionNoPasoError => no_paso_asercion_error
        resultado = ResultadoFallido.new(clase_suite, nombre, no_paso_asercion_error)
      rescue StandardError => error
        resultado = ResultadoExplotado.new(clase_suite,nombre,error)
      end
      TADsPec.revertir
      resultado
    end
  end

  def imprimir(printer)
    printer.imprimir_suite(printer)
  end
end


class ResultadoExitoso
  attr_reader :clase_suite, :nombre

  def initialize(clase, nombre)
    @clase_suite = clase
    @nombre = nombre
  end

  def imprimir(printer)
    printer.imprimir_test_exitoso(self)
  end
end

class ResultadoFallido
  attr_reader :clase_suite, :nombre, :no_paso_asercion

  def initialize(clase_suite, nombre, no_paso_asercion)
    @clase_suite = clase_suite
    @nombre = nombre
    @no_paso_asercion = no_paso_asercion
  end

  def imprimir(printer)
    printer.imprimir_test_fallido(self)
  end
end

class ResultadoExplotado
  attr_reader :clase_suite, :nombre, :error

  def initialize(clase_suite, nombre, error)
    @clase_suite = clase_suite
    @nombre = nombre
    @error = error
  end

  def imprimir(printer)
    printer.imprimir_test_explotado(self)
  end
end
