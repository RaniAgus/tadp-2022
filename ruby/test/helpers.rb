require_relative '../lib/tadspec'

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

  def joven?
    raise NoMethodError
  end
end

class DocenteTestsQueExplota
  def testear_que_un_test_explota
    nico = Docente.new(28)
    nico.deberia ser_joven
  end

  def testear_que_un_test_pasa
    nico = Docente.new(30)
    nico.deberia ser_viejo
  end

  def testear_que_un_test_falla
    nico = Docente.new(29)
    nico.deberia ser_viejo
  end

end

class DocenteTestsQueFalla
  def testear_que_un_test_pasa
    nico = Docente.new(30)
    nico.deberia ser_viejo
  end

  def testear_que_un_test_falla
    nico = Docente.new(29)
    nico.deberia ser_viejo
  end
end

class DocenteTestsQuePasa
  def testear_que_un_test_pasa
    nico = Docente.new(30)
    nico.deberia ser_viejo
  end
end

class DocenteTestsQueMockea
  def testear_que_un_test_mockea
    nico = Docente.new(30)

    Docente.mockear(:viejo?) do
      false
    end

    nico.viejo?.deberia ser false
  end
end