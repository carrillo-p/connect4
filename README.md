# Algoritmo MinMax para Conecta 4.
Algoritmo MinMax con poda alfa beta para resolver Conecta 4, realizado en R.

Se trata de un algoritmo que desarrollé en el marco de la asignatura Técnicas de Simulación del Máster en Metodologías del comportamiento y de la Salud. Publico a continuación tanto el código como la justificación para quién pueda interesarle, no se ha incluido teoría sobre el propio algoritmo ya que se entiende que el usuario tiene conocimientos sobre el mismo para poder implementarlo de forma correcta.

## Funciones auxiliares de tablero y jugada

En primer lugar, se parte de las funciones facilitadas por M. Ángel Castellanos para el desarrollo de este, pero con algunas modificaciones. La principal modificación ha sido que permita aplicarse a un tablero de 6x7 en lugar de un tablero 8x8, ya que son las medidas oficiales del juego. Si se quiere o necesita emplear otras medidas se puede modificar con facilidad. Además, para facilitar la visualización de la partida, se ha añadido un gráfico generado con ggplot2. Dentro del script "funciones auxiliares.R" se han incorporado las funciones para generar la partida (*nuevo_juego*), colocar ficha (*jugada*) y comprobación de vectores (*check_vector*), que se utiliza para evaluar si una jugada es ganadora. 

Dentro de la función *nuevo_juego* se incorpora una matriz de las medidas del tablero, y posteriormente se utiliza la función *melt* del paquete *reshape* para obtener una matriz en la que cada fila y columna lleve asociado un valor, que corresponderá al número de jugador que haya colocado ficha en dicha posición. El tablero de juego se genera con un array de 6x7, donde se colocarán las "fichas" indicadas según el número de jugador (1 o 2).

La función *jugada* toma como argumentos la partida creada con *nuevo_juego*, la columna donde se quiere colocar ficha, el número de jugador (en este caso está construido para admitir 1 para jugador 1 y 2 para jugador 2) y por defecto verbose se establece como TRUE.

Esta función evalúa si la jugada es legal, si la jugada es ganadora, y genera un gráfico mostrando las "fichas", rojas para el jugador 1 y amarillas para el jugador 2 (puede modificarse con facilidad). Por último, devuelve la partida con el tablero actualizado según la jugada, por lo que tendremos que reasignar a la variable que estemos usando para almacenar la partida el resultado. De lo contrario se perderán los avances.

## Funciones auxiliares del algoritmo

Antes de introducir y explicar el algoritmo hay que definir las funciones que este empleará para trabajar correctamente. Estas funciones se incorporan en el script "Funciones auxiliares algoritmo.R". Estas funciones toman como argumento el tablero de juego, el movimiento que se ha realizado (consistente de fila y columna de la matriz del tablero) y el número del jugador maximizador (max | maxplayer) y el del jugador minimizador (min | minplayer).

La función *checkwinner* determina si el movimiento que el algoritmo está probando lleva a una victoria. Para ello, evalúa en función de columna, fila y diagonales si hay una combinación de 4 para uno u otro jugador, y devuelve el jugador ganador y la condición de victoria. Se incluye también condiciones si no hay ganador, o si hay empate.

Esta función se utiliza para determinar si el algoritmo ha llegado a un nodo terminal, el cual se define como un nodo del árbol de decisiones en el que no hay más movimientos legales o que conlleva una victoria. Para ello se incluye dentro de la función *is_terminal_node* que devuelve T o F dependiendo de si es o no nodo terminal.

Por último, se incluye la función *heuristico* la cual puntúa diferentes jugadas realizadas en función de la situación de juego que se encuentre el tablero. Por teoría de juegos, sabemos que en conecta 4 la columna central (4) es una variable importante, en una partida realizada a la perfección, el jugador 1 colocaría la primera ficha en la columna central como condición para ganar la partida, por ello se le ha dado más valor que a realizar una combinación de 2 fichas seguidas. Obviamente, encadenar tres fichas es más importante que la columa central, por ello tiene más valor. 

Cuando se trata del jugador max (de maximizador) estos valores son positivos, ya que se busca obtener la puntuación más alta, y negativos para el jugador min. En este caso, hay que resaltar que las puntuaciones para combinación de 3 fichas son diferentes, esto es debido a que se ha querido asegurar que el algoritmo siempre bloquee combinaciones de tres del jugador contrario (a excepción de cuando se dispone de jugada ganadora), para hacerlo más defensivo. Estos valores pueden modificarse según lo que mejor se considere que vaya a funcionar.


## Algoritmo minmax con poda alfa-beta

La función con la que se inicia el algoritmo, *movimiento_algoritmo* toma como argumentos la partida, la profundidad a la que se quiere llegar (por defecto 4, pero puede aumentarse a costa de que tarde más tiempo en completarse), el jugador maximizador y el minimizador.

Esta función comienza el proceso estableciendo los valores de bestScore y alfa a -Inf, dado que al ser el jugador maximizador, se busca el valor más alto posible, por lo que se empieza por el valor más bajo posible. Para el valor de beta es el proceso inverso. El algoritmo evalúa todos los movimientos posibles, para ello tiene que pasar por todas las columnas disponibles. Dado que sabemos que las columnas centrales son más importantes, se especifica el orden de columnas para que estas se evaluen las primeras, y, al ser una poda alfa-beta que elimina aquellos caminos que no merece la pena evaluar, se recorta el tiempo de ejecución.

Se genera además una matriz que almacenará los movimientos calculados por el algoritmo, de tal forma que además de elegir el mejor movimiento en función de la puntuación obtenida, también lo elija en función del número de movimientos más pequeño.

La función *minimaxSP* se emplea para ejecutar el algoritmo recursivamente hasta llegar a un nodo terminal o hasta llegar a la profundidad máxima establecida (cada iteración del algoritmo reduce en 1 la profundidad). En el caso de obtener una victoria se añaden (o restan) una cantidad de puntos lo suficientemente amplia para que ninguna puntuación obtenida por *heuristico* la supere.

El argumento **isMaximizing** se emplea dentro de esta función para alternar los movimientos que el algoritmo calcula, ya que para el jugador maximizador se busca obtener la puntuación más alta y para el minimizador la más baja. Ambas condiciones incluyen un control si alfa es mayor o igual que beta, en ese caso el bucle se rompe, ya que no merece la pena evaluar el resto de posibilidades (principal objetivo de la poda alfa-beta) y se pasa al siguiente movimiento.

El resultado final es la obtención del número de columna en el que más optimo es colocar la ficha.


## Partida

Se ha incluido un script para automatizar el desarrollo de la partida, importa las funciones que se han mencionado anteriormente y genera la partida en función de la profundidad a la que se quiera trabajar (por defecto 5, ya que no tarda demasiado). 

Incluye además algunos elementos de control básicos, pero pueden modificarse para ser más complejos o concretos. 
