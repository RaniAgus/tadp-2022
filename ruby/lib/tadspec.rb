require 'colorize'
require_relative './asercion'
require_relative './asercion_no_paso_error'
require_relative './aserciones'
require_relative './asertable'
require_relative './mockeable'
require_relative './printer_json'
require_relative './printer_texto'
require_relative './printer_xml'
require_relative './spy'
require_relative './test'
require_relative './test_suite'

module Cambios
  def self.guardar(metodo)
    @mocks ||= []
    @mocks << metodo
  end

  def self.revertir
    @mocks ||= []
    @mocks.each { |mock| mock.revertir }
    @mocks = []
  end
end

class TADsPec
  class << self
    def testear(clase = nil, *metodos)
      resultado = testear_silenciosamente(clase, *metodos)
      resultado.imprimir(PrinterTexto.new)
      resultado
    end

    def testear_json(clase = nil, *metodos)
      resultado = testear_silenciosamente(clase, *metodos)
      PrinterJson.new.imprimir_tadspec(resultado)
      resultado
    end

    def testear_xml(clase = nil, *metodos)
      resultado = testear_silenciosamente(clase, *metodos)
      PrinterXml.new.imprimir_tadspec(resultado)
      resultado
    end

    def testear_silenciosamente(clase = nil, *metodos)
      suites = clase.nil? ? todas_las_test_suites : [TestSuite.new(clase)]
      resultados = suites.map { |it| it.testear(*metodos) }
      ResultadoTADsPec.new(resultados)
    end

    def todas_las_test_suites
      ObjectSpace.each_object(Class)
                 .filter { |it| es_test_suite it }
                 .map { |it| TestSuite.new it }
    end

    def es_test_suite(clase)
      clase.instance_methods(false)
           .any? { |symbol| symbol.to_s.start_with? "testear_que" }
    end

    def configurar_en(contexto)
      contexto.singleton_class.include Aserciones, Espiable
      Object.define_method(:deberia, Asertable.instance_method(:deberia))
      Module.define_method(:mockear, Mockeable.instance_method(:mockear))
    end

    def revertir
      Cambios.revertir
      Object.remove_method(:deberia)
      Module.remove_method(:mockear)
    end
  end
end

class ResultadoTADsPec
  attr_reader :resultados_suites, :cantidad_exitosos, :cantidad_fallidos, :cantidad_explotados

  def initialize(resultados_suites)
    @resultados_suites = resultados_suites
  end

  def imprimir(printer = PrinterStdout.new)
    printer.imprimir_tadspec(self)
  end

  def cantidad
    @resultados_suites.sum { |elem| elem.cantidad }
  end

  def cantidad_exitosos
    @resultados_suites.sum { |elem| elem.cantidad_exitosos }
  end

  def cantidad_fallidos
    @resultados_suites.sum { |elem| elem.cantidad_fallidos }
  end

  def cantidad_explotados
    @resultados_suites.sum { |elem| elem.cantidad_explotados }
  end
end
