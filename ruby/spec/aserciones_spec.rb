require_relative './helpers'

class Docente
  def initialize(edad)
    @edad = edad
  end
  def edad
    @edad
  end
  def viejo?
    @edad > 29
  end
end


describe "Aserciones" do
  include Aserciones
  Asertable.incluir_en Object

  let(:nico) do
    Docente.new(30)
  end

  let(:leandro) do
    Docente.new(22)
  end

  context "deberia ser" do
    it "es exitoso si el objeto es el mismo" do
      resultado = 7.deberia ser 7
      expect(resultado).to be true
    end

    it "es exitoso si el objeto no es el mismo" do
      expect{ leandro.edad.deberia ser 22.0 }.to raise_error NoPasoAsercion
    end
  end

  context "deberia ser_igual" do
    it "es exitoso si el objeto es equivalente" do
      resultado = nico.edad.deberia ser_igual 30.0
      expect(resultado).to be true
    end

    it "no es exitoso si el objeto no es equivalente" do
      expect { nico.edad.deberia ser_igual 31 }.to raise_error NoPasoAsercion
    end
  end

  context "deberia ser mayor_a" do
    it "es exitoso si el valor es mayor a otro" do
      resultado = leandro.edad.deberia ser mayor_a 21
      expect(resultado).to be true
    end

    it "no es exitoso si el valor es igual o menor a otro" do
      expect { leandro.edad.deberia ser mayor_a 22 }.to raise_error NoPasoAsercion
    end
  end

  context "deberia ser menor_a" do
    it "es exitoso si el valor es menor a otro" do
      resultado = leandro.edad.deberia ser menor_a 23
      expect(resultado).to be true
    end

    it "no es exitoso si el valor es igual o mayor a otro" do
      expect { leandro.edad.deberia ser menor_a 22 }.to raise_error NoPasoAsercion
    end
  end

  context "deberia ser uno_de_estos" do
    it "es exitoso si recibe una lista y contiene alguno de los elementos" do
      resultado = leandro.edad.deberia ser uno_de_estos [7, 22, "hola"]
      expect(resultado).to be true
    end

    it "no es exitoso si recibe una lista y no contiene ninguno de los elementos" do
      expect { nico.edad.deberia ser uno_de_estos [7, 22, "hola"] }.to raise_error NoPasoAsercion
    end

    it "es exitoso si recibe varargs y contiene alguno de los argumentos" do
      resultado = leandro.edad.deberia ser uno_de_estos [7], 22, "hola"
      expect(resultado).to be true
    end

    it "no es exitoso si recibe varargs y no contiene ninguno de los argumentos" do
      expect { nico.edad.deberia ser uno_de_estos [30], 22, "hola" }.to raise_error NoPasoAsercion
    end
  end

  context "deberia ser_" do
    it "es exitoso si entiende la pregunta y devuelve true" do
      resultado = nico.deberia ser_viejo
      expect(resultado).to be true
    end

    it "no es exitoso si entiende la pregunta pero devuelve false" do
      expect { leandro.deberia ser_viejo }.to raise_error NoPasoAsercion
    end

    it "explota si no entiende la pregunta" do
      expect { leandro.deberia ser_joven }.to raise_error NameError
    end
  end

  context "deberia tener_" do
    it "es exitoso si entiende el mensaje y el retorno es igual al valor recibido" do
      resultado = leandro.deberia tener_edad 22
      expect(resultado).to be true
    end

    it "no es exitoso si entiende el mensaje pero el retorno no es igual al valor recibido" do
      expect { nico.deberia tener_edad 22 }.to raise_error NoPasoAsercion
    end

    it "no es exitoso si no entiende el mensaje y el valor recibido no es nil" do
      expect { nico.deberia tener_nombre "nico" }.to raise_error NoPasoAsercion
    end

    it "es exitoso si no entiende el mensaje pero el valor recibido es nil" do
      resultado = nico.deberia tener_nombre nil
      expect(resultado).to be true
    end

    it "es exitoso si entiende el mensaje y su valor de retorno cumple con la aserción recibida" do
      resultado = leandro.deberia tener_edad mayor_a 21
      expect(resultado).to be true
    end

    it "no es exitoso si entiende el mensaje pero su valor de retorno no cumple con la aserción recibida" do
      expect { leandro.deberia tener_edad menor_a 22 }.to raise_error NoPasoAsercion
    end
  end

  context "deberia entender" do
    it "es exitoso si entiende un mensaje propio" do
      resultado = leandro.deberia entender :viejo?
      expect(resultado).to be true
    end

    it "es exitoso si entiende un mensaje heredado" do
      resultado = leandro.deberia entender :class
      expect(resultado).to be true
    end

    it "no es exitoso si no entiende el mensaje" do
      expect { leandro.deberia entender :nombre }.to raise_error NoPasoAsercion
    end
  end

  context "deberia explotar" do
    it "es exitoso si arroja el error esperado" do
      resultado = en { leandro.nombre }.deberia explotar_con NoMethodError
      expect(resultado).to be true
    end

    it "es exitoso si arroja un error que es subclase del esperado" do
      resultado = en { leandro.nombre }.deberia explotar_con StandardError
      expect(resultado).to be true
    end

    it "falla si no tira error" do
      expect do
        en { leandro.edad }.deberia explotar_con NoMethodError
      end.to raise_error NoPasoAsercion
    end

    it "falla si tira otro error" do
      expect do
        en { 7 / 0 }.deberia explotar_con NoMethodError
      end.to raise_error NoPasoAsercion
    end
  end
end
