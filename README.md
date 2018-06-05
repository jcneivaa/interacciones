# Interacciones

## Integrantes

| Integrante | github nick |
|------------|-------------|
|Camilo Neiva|jcneivaa  |

## Objetivo

El objetivo principal de este trabajo es crear una implementacion 3D del [modelo](http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/) de flock of boids propuesto por Craig Reynolds, donde ademas los boids busquen huir de una presa, la cual es controlada por el usuario.

## Desarrollo

El trabajo se desarrollo sobre la [implementacion](https://github.com/VisualComputing/framesjs/tree/processing/examples/Advanced/FlockOfBoids) previa de boids hecha por [Jean Pierre Charalambos](https://github.com/nakednous), en esta se creo un nuevo agente el cual cumple el rol de predador sobre los boids. Sobre el predador se creo un movimiento con 5 grados de libertad (adelante, derecha, izquierda, arriba, abajo) a travez del entorno.
Para determinar el comportamiento de los boids en presencia de un predador se hizo uso de la regla de [evasion](https://www.red3d.com/cwr/papers/1999/gdc99steer.pdf)introducidad por el mismo Reynolds años despues de crear el modelo inicial.
El trabajo se realizo en [Processing](https://processing.org/) usando la libreria [Frames](https://github.com/VisualComputing/framesjs/releases).

## Dificultades

Durante el desarrollo del movimiento del predador se encontro la dificultad de mantener los controles constantes durante todo el movimiento, es decir, que el movimiento sea el mismo sin importar la rotacion del predador cuando dicho movimiento se realiza con translaciones activas (sobre las coordenadas del entorno). Para esto se creo un vector que me indicaba la direccion en la cual se movia el predador sobre cada uno de los ejes y se operaba sobre este.
Tambien se presento el problema de obtener una correcta visualizacion de la camara en primera persona, el cual aun sigue sin ser resuelto.

## Trabajo Futuro

Del presente trabajo se puede buscar la creacion de algun tipo de juego de combate aereo/espacial, donde el predador sea el jugador y los boids los enemigos, para esto se deberia implementar un patron de persecucion donde los boids busquen tambien atacar al predador ademas de un sistema de disparos y colision de unidades.

## Referencias

* [Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 1987.](http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/)
* [Reynolds, C. W. Steering Behaviors For Autonomous Characters. 1999.](http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/)
* [Jonsson, P., Ljungberg, L. Flocking as a Hunting Mechanic: Predator vs. Prey Simulations. 2017.](http://www.diva-portal.org/smash/get/diva2:1105912/FULLTEXT01.pdf)
* [Davison, A. Java Prog. Techniques for Games. 2003](https://fivedots.coe.psu.ac.th/~ad/jg/ch13/chap13.pdf)
* [Flock of Boids by Jean Pierre Charalambos](https://github.com/VisualComputing/framesjs/tree/processing/examples/Advanced/FlockOfBoids)
