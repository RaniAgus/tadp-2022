require_relative '../lib/tadspec'

class PrinterXml
  def imprimir_tadspec(tadspec)
    puts '<?xml version="1.0" encoding="UTF-8"?>'
    puts '<tadspec>'
    tadspec.resultados_suites.each do |suite|
      imprimir_suite(suite)
    end
    puts '</tadspec>'
  end

  def imprimir_suite(suite)
    puts '  <suite>'
    puts "    <clase_suite>#{suite.clase_suite}</clase_suite>"
    suite.resultados_tests.each do |test|
      test.imprimir(self)
    end
    puts '  </suite>'
  end

  def imprimir_test(test)
    puts '    <test>'
    puts "      <nombre>#{test.nombre}</nombre>"
    test.imprimir(self)
    puts '    </test>'
  end

  def imprimir_test_exitoso(test)
    puts '      <resultado>'
    puts "        <nombre>#{test.nombre}</nombre>"
    puts '        <tipo>exitoso</tipo>'
    puts '      </resultado>'
  end

  def imprimir_test_fallido(test)
    puts '      <resultado>'
    puts "        <nombre>#{test.nombre}</nombre>"
    puts '        <tipo>fallido</tipo>'
    puts "        <valor_esperado>#{test.no_paso_asercion.valor_esperado}</valor_esperado>"
    puts "        <valor_obtenido>#{test.no_paso_asercion.valor_obtenido}</valor_obtenido>"
    puts '      </resultado>'
  end

  def imprimir_test_explotado(test)
    puts '      <resultado>'
    puts "        <nombre>#{test.nombre}</nombre>"
    puts '        <tipo>explotado</tipo>'
    puts "        <error>#{test.error.class}</error>"
    puts "        <backtrace>"
    test.error.backtrace.each do |linea|
      puts "          <linea>#{linea}</linea>"
    end
    puts "        </backtrace>"
    puts '      </resultado>'
  end
end
