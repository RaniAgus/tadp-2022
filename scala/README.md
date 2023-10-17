# Calabozos
> TAdeP - 2C 2022 - Trabajo Práctico Grupal: Objeto/Funcional

## Introducción

**IMPORTANTE:** Este trabajo práctico debe implementarse de manera que se
apliquen los principios del paradigma híbrido objeto-funcional enseñados en 
clase. No alcanza con hacer que el código funcione en objetos, hay que
aprovechar las herramientas funcionales, poder justificar las decisiones de
diseño y elegir el modo y lugar para usar conceptos de un paradigma u otro.

Se tendrán en cuenta para la corrección los siguientes aspectos:
- Uso de Inmutabilidad vs. Mutabilidad.
- Uso de Polimorfismo paramétrico (Pattern Matching) vs. Polimorfismo Ad-Hoc.
- Aprovechamiento del polimorfismo entre objetos y funciones y Orden Superior.
- Uso adecuado del sistema de tipos.
- Manejo de herramientas funcionales.
- Cualidades de Software.
- Diseño de interfaces y elección de tipos.

## Descripción General del Dominio

Tenemos grupos de aventureros que tienen como hobby recorrer calabozos en busca
de fama y tesoros.

Para simplificar el modelo, podemos pensar en un calabozo como un laberinto
compuesto de múltiples habitaciones conectadas por puertas. Cada puerta conduce
a una habitación, la cual, a su vez, puede tener otras puertas que conducen a
nuevas habitaciones. Todo calabozo tiene una única puerta de entrada que conduce
a su primera habitación.

## Los Héroes
Cada héroe tiene ciertas características que lo definen y reflejan su capacidad
(o falta de) para superar los peligros de un calabozo.

De cada aventurero conocemos sus tres características principales: **fuerza**, 
**velocidad** y **nivel**, representados de forma numérica. También conocemos su
**salud**, que es similar a las otras características pero, en caso de bajar a 
cero, significará la muerte del aventurero.

Los aventureros también tienen un **trabajo** o profesión, que determina el modo
en que pueden contribuir al grupo.

### Los Trabajos

Cada aventurero tiene un único trabajo que define su entrenamiento, talentos y
experiencia lidiando con distintas situaciones. Conocemos, de momento, los
siguientes tres trabajos (pero no descartamos la posibilidad de que en el futuro
surjan más):

#### Guerrero

Los guerreros son peleadores experimentados que acostumbran resolver todo a los
golpes. La fuerza de los guerreros es naturalmente mayor a la de otros 
aventureros, sumándole a la característica base un 20% por cada nivel del 
aventurero.

#### Ladrón

Los ladrones se caracterizan por ser ágiles y talentosos manipulando mecanismos.
Su talento para abrir cerraduras depende de la **habilidad de sus manos**, la 
cual tiene un valor base distinto para cada ladrón y aumenta en tres unidades 
por cada nivel.

#### Mago

Los magos son individuos excepcionales, capaces de manipular fuerzas
incomprensibles para otros hombres. Cada mago nace predestinado a aprender 
ciertos **hechizos** y desde el principio de su vida se conoce a qué nivel 
aprenderá cada uno de ellos. Una vez ganado el nivel para adquirir un hechizo,
el mago puede utilizarlo cuantas veces quiera.

### Los Grupos

Es peligroso ir solo... Los héroes siempre se organizan en grupos para recorrer 
calabozos y mejorar así sus chances de sobrevivir. Cada grupo funciona como una
pequeña cooperativa, donde cada aventurero ayuda con lo que puede a superar los
obstáculos encontrados y todos los ítems, armas y tesoros se comparten en un 
**cofre común** para que cualquiera pueda utilizarlo (y las ganancias puedan
repartirse una vez terminada la aventura).

Sólo aventureros vivos pueden formar parte de un grupo. Una vez que la **salud**
de un aventurero baja a cero, el individuo en cuestión es ~~tirado por ahí~~
apropiadamente dispuesto y el resto de los aventureros continúa sin él.

Siendo los aventureros naturalmente competitivos, todos los grupos están siempre
jerarquizados: Podemos pensar en sus miembros como "ordenados" de mayor a menor
jerarquía donde el primer miembro del grupo (es decir, **el Líder**) es quien
toma todas las decisiones importantes a su gusto y criterio.

En el trágico caso de que el líder muriera el rol de líder quedaría en manos del
siguiente aventurero en el orden jerárquico del grupo.

## El Calabozo

Como sabemos, un calabozo se compone de múltiples habitaciones conectadas por
puertas. Los grupos de héroes que recorren el calabozo deben aventurarse de una
habitación a otra sin saber qué terrores les espera a continuación.

Cada vez que el grupo abre una nueva **Puerta** debe atravesarla, adentrándose
en una nueva **Habitación**, y enfrentando cualquier **Situación** que en ella
los espere.

El recorrido de un calabozo siempre empieza por su puerta principal, la cual
conduce a una primera habitación (y la situación que en ella se esconde).

### Puertas

Las puertas interconectan las habitaciones del calabazo, permitiendo a los héroes
moverse de un lugar a otro. ¡Pero no todo es tan fácil! Las puertas del calabozo
están plagadas de obstáculos que el grupo debe superar si desea atravesarlas.

Cada puerta puede verse afectada por una, varias o ninguna de las siguientes
dificultades:

#### Puerta Cerrada

Ahh... El viejo truco de cerrar la puerta. Este obstáculo simple pero efectivo
sólo puede ser superado en las siguientes condiciones:

- Cualquier héroe puede abrir una cerradura si el grupo tiene el ítem llave.
- Cualquier cerradura puede ser abierta por un **ladrón** si tiene una
  **habilidad** de al menos 10 o si el grupo tiene el ítem _ganzúas_.

#### Puerta Escondida

No podés abrir una puerta que no ves.
- Un **mago** puede encontrar una puerta escondida si conoce el hechizo
  _vislumbrar_.
- Un **ladrón** con habilidad de 6 o más puede encontrar cualquier puerta
  escondida.

#### Puerta Encantada

Las puertas encantadas son puertas sobre las que alguien lanzó un hechizo que
impide el paso a los aventureros. Un **mago** puede superar este obstáculo si
conoce el mismo hechizo con el cual fue encantada la puerta.

Independientemente de la dificultad, sabemos que un **ladrón** con una
**habilidad** de 20 o más puede abrir cualquier puerta.

Decimos que un grupo puede abrir una puerta cuando, para cada obstáculo de la
misma, alguno de los miembros del grupo puede superarlo.

## Habitaciones

Detrás de cada puerta hay una **habitación** que esconde peligros o tesoros.
Dentro de cada **habitación** hay siempre una única de las siguientes
**situaciones**: 

- **No pasa nada**: Algunos cuartos sólo están vacíos.
- **Tesoro perdido**: Un ítem tirado en el piso, listo para ser recolectado!
  El grupo puede sumarlo a su **cofre común**.
- **Muchos, muchos dardos**: La pared del cuarto dispara una nube de dardos y
  todos los integrantes pierden 10 puntos de salud.
- **Trampa de leones**: La habitación encerraba un león famélico. El
  integrante más lento del grupo muere automáticamente.
- **Encuentro**: el grupo se encuentra con un héroe perdido en el calabozo. Es
  una situación incómoda... Si el personaje encontrado y el líder del grupo se
  agradan, el nuevo héroe se suma al grupo (en último lugar de jerarquía), si
  no, deben pelear a muerte!

Todos los héroes tienen criterios diferentes con los cuales deciden si un grupo
les agrada o no. Algunos ejemplos son:

- los introvertidos, a quienes solo les agradan los grupos de hasta 3 miembros.
- los bigotes, que le caen bien los grupos donde no hay ladrones.
- los interesados, que se suman a un grupo solamente si tiene cierto objeto
  particular que le interesa.
- los loquitos, que siempre van a querer pelearse porque no les cae bien nadie.

Para saber si el líder del grupo y el extraño se agradan ambos deben aplicar
su criterio: el extraño sobre el **grupo actual** y el líder sobre
**el grupo con el nuevo integrante**. Si alguno de los dos falla el chequeo
la pelea es inevitable... 

Cuando el grupo pelea contra un personaje, se comparan sus fuerzas. Si la suma
de las fuerzas de todos los héroes del grupo es mayor a la fuerza del oponente,
el grupo gana y todos suben un nivel.

En caso de que el grupo pierda, recibe un daño igual a la fuerza del héroe.
Este daño se reparte entre todos los héroes del equipo equitativamente. Luego
de esto, el oponente escapa para nunca más volver.

## Recorriendo el Calabozo

Para poder llevar a cabo un recorrido eficiente el grupo lleva un registro de
**todas las puertas que ya visitó** y **todas las puertas que no abrieron**.
Dado esto, la manera en la que los grupos recorren es muy sencilla:

- Una vez **abierta** una **puerta**, el grupo
  **la agrega a la lista de puertas abiertas** y entra en la **habitación** a
  dónde conduce y lidia con la **situación** que allí los espera. Si la
  situación es demasiado para los héroes y **todo el grupo muere**,
  **la aventura ha fallado** y el recorrido termina acá.

- Si pudieron lidiar con la situación, los sobrevivientes revisan la habitación
  **y registran todas las nuevas puertas en su lista de puertas que no abrieron**. 

- Luego de esto el líder del grupo elige la siguiente puerta para abrir de entre
  **todas las puertas que todavía no abrieron**. No es necesario que elija una
  puerta de la habitación actual, puede decidir que prefiere volver atrás y
  visitar una puerta de una habitación anterior (esto
  _no vuelve a gatillar la situación de dicha habitación_).

- Si el grupo se queda sin puertas que puedan abrir **la aventura falló** y el
  recorrido termina. Si por el contrario el líder elige una puerta cuyos
  obstáculos pueden superar, **abren la puerta** y el recorrido continúa.

- Estos pasos se repiten hasta que la **aventura falle** o el equipo consiga
  abrir una puerta marcada como **"salida"**. Cuando esto pasa,
  **la aventura tuvo éxito**, el recorrido termina y los héroes vuelven a casa
  a celebrar.

### Eligiendo la siguiente puerta

El líder es quien toma la decisión de cuál puerta abrir una vez superada la
situación de un cuarto. El líder siempre elige la siguiente puerta de entre el
conjunto de **puertas encontradas que aún no fueron abiertas** y, obviamente,
**sólo considera aquellas puertas que el equipo puede abrir**.
 
Cada héroe tiene su propio criterio de cuál es la mejor siguiente puerta, y
queremos modelar algunos ejemplos de esos criterios:

- **los heroicos**: No les importa nada. Abren la primera puerta que haya. Yolo.
- **los ordenados**: No les gusta dejar puertas sin abrir, con lo cual
  prefieren priorizar las puertas de los cuartos anteriores cuando sea posible.
- **los videntes**: Los videntes pueden espiar tras la cortina del futuro y
  prefieren las puertas que van a dar "el mejor resultado". Vamos a simplificar
  su razonamiento arcano con la siguiente cuenta que determina el **puntaje**
  del grupo:

> cantidad de héroes vivos * 10 - cantidad de héroes muertos * 5 + cantidad de
> objetos en el cofre + el nivel más alto del grupo

## Requerimientos

Implementar el modelo descrito previamente de forma tal que sea posible
responder a las siguientes consultas:

1. Saber si un grupo puede abrir una puerta.
2. Informar el estado de un grupo tras visitar una habitación.
3. Cuál es el resultado (éxito/fallo) y estado final de un grupo que intenta
   recorrer un calabozo.
4. Cuál es el mejor grupo para un calabozo:
   Dados varios grupos y un calabozo, obtener aquel que puede salir con el
   mejor puntaje.
5. Cuántos niveles necesita subir un grupo para salir de un calabozo:
   Dado un grupo y un calabozo, es posible que el resultado de recorrerlo
   resulte en un fallo. Esto puede suceder, principalmente, cuando el equipo
   no era suficientemente experimentado para lidiar con las dificultades que
   iban a encontrarse.

Queremos saber cuál es el mínimo de veces (hasta un máximo de 20) que deberíamos hacerle ganar un nivel a **todos** los integrantes del grupo para que puedan superar el calabozo.
