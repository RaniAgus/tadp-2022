class Spy
  def initialize(objeto_espiado)
    @mensajes_recibidos = []
    @metodos_originales = {}

    objeto_espiado.instance_variable_set("@spy", self)

    objeto_espiado.methods.map do |sym|
      @metodos_originales[sym] = objeto_espiado.method(sym)
    end

    objeto_espiado.methods.each do |simbolo|
      objeto_espiado.define_singleton_method(simbolo) do |*args, &bloque|
        @spy.enviar_mensaje(simbolo, *args, &bloque)
      end
    end
  end

  def method_missing(mensaje, *args, &bloque)
    @metodos_originales[:send].call(mensaje, *args, &bloque)
  end

  def respond_to_missing?(mensaje, include_private = false)
    @metodos_originales[:respond_to_missing?].call(mensaje, include_private)
  end

  def enviar_mensaje(mensaje, *args, &bloque)
    @mensajes_recibidos.push({ mensaje: mensaje, args: args })
    @metodos_originales[mensaje].call(*args, &bloque)
  end

  def recibio?(metodo)
    @mensajes_recibidos.any? { |mensaje| mensaje[:mensaje] == metodo }
  end

  def recibio_con_argumentos?(mensaje, *args)
    @mensajes_recibidos.any? { |m| m[:mensaje] == mensaje && m[:args] == args }
  end

  def recibio_n_veces?(mensaje, veces)
    @mensajes_recibidos.count { |m| m[:mensaje] == mensaje } == veces
  end

  def revertir
    @metodos_originales[:remove_instance_variable].call(:@spy)
    @metodos_originales.keys.each do |sym|
      @metodos_originales[:singleton_class].call.remove_method(sym)
    end
  end
end