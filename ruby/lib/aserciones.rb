module Aserciones
  def ser(valor_esperado, texto = "ser")
    if valor_esperado.is_a? Asercion
      valor_esperado
    else
      Asercion.new do |valor_obtenido|
        unless valor_obtenido.equal? valor_esperado
          raise AsercionNoPasoError.new(texto, valor_esperado, valor_obtenido)
        end
      end
    end
  end

  def ser_igual(valor_esperado)
    Asercion.new do |valor_obtenido|
      unless valor_obtenido == valor_esperado
        raise AsercionNoPasoError.new("ser igual a", valor_esperado, valor_obtenido)
      end
    end
  end

  def menor_a(valor_esperado)
    Asercion.new do |valor_obtenido|
      unless valor_obtenido < valor_esperado
        raise AsercionNoPasoError.new("ser menor a", valor_esperado, valor_obtenido)
      end
    end
  end

  def mayor_a(valor_esperado)
    Asercion.new do |valor_obtenido|
      unless valor_obtenido > valor_esperado
        raise AsercionNoPasoError.new("ser mayor a", valor_esperado, valor_obtenido)
      end
    end
  end

  def polimorfico_con(modulo)
    Asercion.new do |valor_obtenido|
      unless modulo.instance_methods(false).all? { |it| valor_obtenido.respond_to? it }
        raise AsercionNoPasoError.new("ser polimorfico con", modulo, valor_obtenido)
      end
    end
  end

  def entender(valor_esperado)
    Asercion.new do |valor_obtenido|
      unless valor_obtenido.respond_to? valor_esperado
        raise AsercionNoPasoError.new("entender", valor_esperado, valor_obtenido)
      end
    end
  end

  def uno_de_estos(*valores_esperados)
    if valores_esperados[0].is_a? Array and valores_esperados.size == 1
      valores_esperados = valores_esperados[0]
    end
    Asercion.new do |valor_obtenido|
      unless valores_esperados.include? valor_obtenido
        raise AsercionNoPasoError.new("ser uno de", valores_esperados, valor_obtenido)
      end
    end
  end

  def en(&bloque)
    bloque
  end

  def explotar_con(error_esperado)
    Asercion.new do |proc|
      begin
        valor_obtenido = proc.call
        raise AsercionNoPasoError.new("explotar con", error_esperado, valor_obtenido)
      rescue StandardError => error_recibido
        unless error_recibido.is_a? error_esperado
          raise AsercionNoPasoError.new("explotar con", error_esperado, error_recibido)
        end
      end
    end
  end

  def haber_recibido(mensaje)
    AsercionSobreSpy.new(mensaje) do |spy|
      if ! spy.is_a? Spy
        raise AsercionNoPasoError.new("ser un", Spy, spy.class)
      elsif ! spy.recibio? mensaje
        raise AsercionNoPasoError.new("haber recibido", mensaje, false)
      end
      spy
    end
  end

  def method_missing(symbol, *args, &block)
    if symbol.start_with? "ser_"
      ser(true, "ser #{symbol.to_s.delete_prefix("ser_")}").desde do |it|
        it.send("#{symbol.to_s.delete_prefix("ser_")}?")
      end
    elsif symbol.start_with? "tener_"
      ser(args[0], "tener #{symbol.to_s.delete_prefix("tener_")}").desde do |it|
        it.instance_variable_get("@#{symbol.to_s.delete_prefix("tener_")}")
      end
    else
      super
    end
  end

  def respond_to_missing?(symbol, include_all = false)
    super or symbol.start_with?("ser_") or symbol.start_with?("tener_")
  end
end
