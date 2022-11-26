require 'json'

class PrinterJson
  def imprimir_tadspec(tadspec)
    puts JSON.pretty_generate({
      tadspec: {
        cantidad_exitosos: tadspec.cantidad_exitosos,
        cantidad_fallidos: tadspec.cantidad_fallidos,
        cantidad_explotados: tadspec.cantidad_explotados,
        suites: tadspec.resultados_suites.map { |suite| suite.imprimir(self) }
      }
    })
  end

  def imprimir_suite(suite)
    {
      clase_suite: suite.clase_suite,
      resultados_tests: suite.resultados_tests.map { |resultado| resultado.imprimir(self) }
    }
  end

  def imprimir_test_exitoso(test)
    {
      nombre: test.nombre,
      resultado: {
        tipo: :exitoso
      }
    }
  end

  def imprimir_test_fallido(test)
    {
      nombre: test.nombre,
      resultado: {
        tipo: :fallido,
        nombre: test.no_paso_asercion.nombre,
        valor_esperado: test.no_paso_asercion.valor_esperado,
        valor_obtenido: test.no_paso_asercion.valor_obtenido
      }
    }
  end

  def imprimir_test_explotado(test)
    {
      nombre: test.nombre,
      resultado: {
        tipo: :explotado,
        error: test.error.class,
        backtrace: test.error.backtrace
      }
    }
  end
end
