rm(list = ls())
source("Funciones aux tablero 6x7.R")
source("Funciones aux algoritmo 6x7.R")
source("Algoritmo def 6x7.R")

juego <- function(depth = 5){
    partida <- nuevo_juego()
    jugador <- readline(prompt = "Elige si quieres ir primero (1) o segundo (2): ")
    if(jugador == 1 | jugador == 2){
        while(partida$winner == 0){
            if (jugador == 1){
                x <- readline(prompt = "Elige columna (1-7)")
                if (x > 7){
                    print("El número tiene que ser entre 1 y 7, se te ha asignado un valor al azar")
                    x <- sample(1:7, 1)
                    partida <- jugada(partida, strtoi(x), 1)
                }
                else{
                    partida <- jugada(partida, strtoi(x), 1)
                    if (partida$winner != 0){
                        break
                    }
                }
                partida <- jugada(partida, movimiento_algoritmo(partida, depth, 2, 1), 2)
            }
            if (jugador == 2){
                partida <- jugada(partida, movimiento_algoritmo(partida, depth, 2, 1), 1)
                if (partida$winner != 0){
                    break
                }
                x <- readline(prompt = "Elige columna (1-7)")
                if(x > 7){
                    print("El número tiene que ser entre 1 y 7, se te ha asignado un valor al azar")
                    x <- sample(1:7, 1)
                    partida <- jugada(partida, strtoi(x), 2)
                }
                else{
                    partida <- jugada(partida, strtoi(x), 2)
                }
            }
        }
    }
    else{
        warning("Por favor introduce un valor válido (1 o 2)")
    }
}

juego(5)
