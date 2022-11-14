package calabozos

class Puerta(obstaculos: List[Obstaculo], ubicacion: Ubicacion) {
  def serRecorridaPor(grupo: Grupo): Option[Grupo] = Option(grupo)
    .filter(puedeSerAbiertaPor)
    .map(_.quitarPuerta(this))
    .flatMap(ubicacion.serRecorridaPor)

  def hacerPasar(grupo: Grupo): Option[Grupo] = Option(grupo)
    .filter(puedeSerAbiertaPor)
    .map(ubicacion.hacerPasar)

  def puedeSerAbiertaPor(grupo: Grupo): Boolean = obstaculos.forall(_.puedeSerSuperadoPor(grupo))
}

trait Obstaculo {
  def puedeSerSuperadoPor(grupo: Grupo): Boolean = grupo.heroesVivos.exists(puedeSerSuperadoPorHeroe(_, grupo))

  private def puedeSerSuperadoPorHeroe(heroe: Heroe, grupo: Grupo): Boolean = heroe match {
    case ladron: Ladron if ladron.tieneHabilidad(20) => true
    case _ => puedeSerSuperadoPorHeroeSegunObstaculo(heroe, grupo)
  }

  protected def puedeSerSuperadoPorHeroeSegunObstaculo(heroe: Heroe, grupo: Grupo): Boolean
}

object Cerrada extends Obstaculo {
  override def puedeSerSuperadoPorHeroeSegunObstaculo(heroe: Heroe, grupo: Grupo): Boolean = heroe match {
    case ladron: Ladron if ladron.tieneHabilidad(10) || grupo.tieneItem(Ganzua) => true
    case _ => grupo.tieneItem(Llave)
  }
}

object Escondida extends Obstaculo {
  override def puedeSerSuperadoPorHeroeSegunObstaculo(heroe: Heroe, grupo: Grupo): Boolean = heroe match {
    case mago: Mago => mago.sabeHechizo(Vislumbrar)
    case ladron: Ladron => ladron.tieneHabilidad(6)
    case _ => false
  }
}

case class Encantada(hechizo: Hechizo) extends Obstaculo {
  override def puedeSerSuperadoPorHeroeSegunObstaculo(heroe: Heroe, grupo: Grupo): Boolean = heroe match {
    case mago: Mago => mago.sabeHechizo(hechizo)
    case _ => false
  }
}
