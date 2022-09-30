require_relative './helpers'

describe "Spies" do
  let(:pato) do
    Persona.new(30)
  end

  it "deberia poder espiar un metodo" do
    spy = Spy.new(pato)

    pato.viejo?

    expect(spy.recibio? :viejo?).to be true
  end

  it "deberia poder espiar un metodo llamado por otro usando self" do
    spy = Spy.new(pato)

    pato.viejo?

    expect(spy.recibio? :edad).to be true
  end

  it "deberia haber recibido el método con los argumentos" do
    spy = Spy.new(pato)

    pato.viejo?

    expect(spy.recibio_con_argumentos?(:viejo?)).to be true
  end

  it "no deberia haber recibido el método con los argumentos incorrectos" do
    spy = Spy.new(pato)

    pato.viejo?

    expect(spy.recibio_con_argumentos?(:viejo?, 30)).to be false
  end

  it "deberia haber recibido el método la cantidad de veces indicada" do
    spy = Spy.new(pato)

    pato.viejo?
    pato.viejo?

    expect(spy.recibio_n_veces?(:viejo?, 2)).to be true
  end

  it "no deberia haber recibido el método la cantidad de veces incorrecta" do
    spy = Spy.new(pato)

    pato.viejo?
    pato.viejo?

    expect(spy.recibio_n_veces?(:viejo?, 3)).to be false
  end

  it "se deberia poder dejar de espiar un metodo" do
    spy = Spy.new(pato)
    spy.revertir

    pato.viejo?

    expect(spy.recibio? :viejo?).to be false
  end
end