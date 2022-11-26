package calabozos

import calabozos.TestFactories.*
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.should.Matchers.*

class SituacionTest extends AnyFreeSpec {
  "La situacion " -{
    "en la que no pasa nada devuelve el mismo grupo" in {
        NoPasaNada(grupoCon(unLadron())) shouldBe grupoCon(unLadron())
    }

    "donde hay un tesoro perdido se lo agrega al cofre del grupo" in {
      TesoroPerdido(Llave)(grupoCon(unLadron())) shouldBe grupoCon(unLadron(), List(Llave))
    }

    "muchos dardos hace que todo el grupo pierda 10 de salud" in {
      val ladron = unLadron(salud = 20)

      MuchosDardos(grupoCon(ladron)) shouldBe grupoCon(unLadron(salud = 10))
    }

    "trampa de leones mata al mas lento" in {
      val ladron = unLadron(velocidadBase = 5)
      val ladronBuffeado = unLadron(velocidadBase = 6)

      TrampaDeLeones(grupoCon(List(ladron, ladronBuffeado))).heroesVivos shouldBe List(ladronBuffeado)
    }

    "encuentro " - {
        val mago = unMago(salud = 20, aprendizaje = Aprendizaje(Vislumbrar, 0), criterio = Heroico, personalidad = Bigote)

        "cuando se agradan el heroe encontrado se suma al grupo" in {
          val bigote = unGuerrero(personalidad = Bigote)
          val grupo = grupoCon(mago)

          Encuentro(bigote)(grupo).heroesVivos shouldBe grupoCon(List(mago, bigote)).heroesVivos
        }

        "cuando no se agradan pelean " - {
            "si el heroe encontrado es mas fuerte el grupo sufre daño" in {
              val guerrero = unGuerrero(fuerzaBase = 2, personalidad = Loquito)
              val grupo = grupoCon(mago)

              Encuentro(guerrero)(grupo).lider shouldBe mago.perderSalud(2)
            }

            "si el heroe encontrado es menos fuerte este escapa y el grupo sube un nivel " in {
              val guerrero = unGuerrero(fuerzaBase = 2)
              val grupo = grupoCon(guerrero)

              Encuentro(mago)(grupo) shouldBe grupoCon(guerrero.subirNivel())
            }
        }
    }

    "motin" - {
      "si el grupo tiene más de un héroe vivo, el héroe con mayor fuerza sale y se pelea con el resto" in {
        val mago = unMago(fuerzaBase = 2, salud = 20)
        val guerrero = unGuerrero(fuerzaBase = 3, salud = 20)
        val ladron = unLadron(fuerzaBase = 2, salud = 20)
        val grupo = grupoCon(List(mago, guerrero, ladron))

        Motin(grupo).heroesVivos shouldBe List(mago.subirNivel(), ladron.subirNivel())
      }

      "si el grupo tiene un solo héroe vivo, no pasa nada" in {
        val grupo = grupoCon(List(unLadron(), unLadron(salud = 0)))
        Motin(grupo) shouldBe grupo
      }
    }
  }
}
