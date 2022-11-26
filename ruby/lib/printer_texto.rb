class PrinterTexto
  def imprimir_tadspec(tadspec)
    tadspec.resultados_suites.map { |suite| suite.imprimir(self) }
    puts ""
    puts "==============="
    puts "REPORTE TADSPEC"
    puts "==============="
    puts ""
    puts "\t#{tadspec.cantidad_exitosos}/#{tadspec.cantidad} pasaron".green
    puts "\t#{tadspec.cantidad_fallidos}/#{tadspec.cantidad} fallaron".yellow
    puts "\t#{tadspec.cantidad_explotados}/#{tadspec.cantidad} explotaron".red
  end

  def imprimir_suite(suite)
    puts "#{suite.clase_suite}".colorize(:color => :black, :background => color_de_fondo(suite.resultado))
    suite.resultados_tests.map { |resultado| resultado.imprimir(self) }
    puts ""
  end

  def imprimir_test_exitoso(test)
    puts "\t\u{1F680} El test #{test.nombre} pasó exitosamente.".green
  end

  def imprimir_test_fallido(test)
    puts "\t\u{1F921} El test #{test.nombre} falló:".yellow
    puts "\t\tEsperaba #{test.no_paso_asercion.nombre} <#{test.no_paso_asercion.valor_esperado}> pero obtuvo <#{test.no_paso_asercion.valor_obtenido}>"
  end

  def imprimir_test_explotado(test)
    puts "\t\u{1F4A5} El test #{test.nombre} explotó con #{test.error.class}:".red
    puts "\t\t#{test.error.backtrace.join("\n\t\t")}"
  end

  private
  def color_de_fondo(resultado)
    case resultado
    when :exitoso
      :green
    when :fallido
      :yellow
    when :explotado
      :red
    else
      :white
    end
  end
end
