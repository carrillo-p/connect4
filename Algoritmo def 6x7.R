movimiento_algoritmo <- function(partida, depth, maxplayer, minplayer){
    bestScore <- -Inf
    alfa <- -Inf
    beta <- Inf
    t <- partida$tablero
    path <- matrix(0, 0, 3) #Matriz para almacenar los movimientos calculados por el algoritmo
    ordered_cols <- c(4, 5, 3, 6, 2, 7, 1) #Columnas ordenadas en función de prioridad basada en teoría de juegos
    for(col in ordered_cols){
        a <- rev(which(t[, col] == 0)) #Check de movimiento legal
        if(length(a) > 0){
            row <- a[1]
            board_copy <- t
            board_copy[row, col] <- maxplayer
            temp_move <- c(row, col)
            res <- minimaxSP(board_copy, depth, alfa, beta, FALSE, maxplayer,
                             minplayer, temp_move)
            score <- res[1]
            short_path <- res[2]
            if (score >= bestScore){
                bestScore <- score
                columna <- col
                camino <- short_path
                path <- rbind(path, 
                                c(bestScore, camino, columna)) 
                #se crea una tabla donde se guardan las variables
            }
        }
    }
    max_score <- path[path[, 1] == max(path[, 1]), ] #se selecciona el mejor resultado
    if(is.null(nrow(max_score))){ #si solo hay un resultado posible, se coge el ultimo valor del vector
        columna <- max_score[3]
    }
    else{ #si hay varios resultados posibles
        min_path <- max_score[max_score[, 2] == max(max_score[, 2]), ] 
        #se selecciona el menor numero de pasos
        if(is.null(nrow(min_path))){ 
            #si solo hay un resultado posible para mejor puntuacion con menor pasos
            columna <- min_path[3] #ultimo valor del vector, que corresponde a columna
        }
        else{
            columna <- min_path[1, 3] #si hay varios resultados, se coge el primero
        }
    }
    return(columna)
}

minimaxSP <- function(board, depth, alfa, beta, isMaximizing, maxplayer, minplayer, move){
    terminal_node <- is_terminal_node(board, move, maxplayer, minplayer)
    if(depth == 0 | terminal_node){
        if(terminal_node){
            result <- checkwinner(board, move, maxplayer, minplayer)[[2]] #check de jugador que ganaría la partida
            if(result == maxplayer){
                score <- 100000
                return(c(score, depth)) 
                #necesitamos devolver el valor de depth al que se llega
            }
            if(result == minplayer){
                score <- -100000
                return(c(score, depth))
            }
            if(result == 0){
                score <- 0
                return(c(score, depth))
            }
        }
        else{
            score <- heuristico(board, move, maxplayer, minplayer)
            return(c(score, depth))
        }
    }
    else{
        if(isMaximizing){
            bestScore <- -Inf
            shortest <- 0
            t <- board
            ordered_cols <- c(4, 5, 3, 6, 2, 7, 1)
            for(col in ordered_cols){
                a <- rev(which(t[, col] == 0))
                if (length(a) > 0){
                    row <- a[1]
                    board_copy <- t
                    board_copy[row, col] <- maxplayer
                    temp_move <- c(row, col)
                    res <- minimaxSP(board_copy, depth - 1, alfa, beta, F,
                                     maxplayer, minplayer, 
                                     move = temp_move)
                    score <- res[1]
                    path <- res[2]
                    bestScore <- max(score, bestScore)
                    alfa <- max(alfa, bestScore)
                }
                if(alfa >= beta){
                    break
                }
            }
            return(c(bestScore, path))
        }
        else{
            bestScore <- Inf
            shortest <- 5
            t <- board
            ordered_cols <- c(4, 5, 3, 6, 2, 7, 1)
            for(col in ordered_cols){
                a <- rev(which(t[, col] == 0))
                if (length(a) > 0){
                    row <- a[1]
                    board_copy <- t
                    board_copy[row, col] <- minplayer
                    temp_move <- c(row, col)
                    res <- minimaxSP(board_copy, depth-1, alfa, beta, T,
                                     maxplayer, minplayer, 
                                     move = temp_move)
                    score <- res[1]
                    path <- res[2]
                    bestScore <- min(score, bestScore)
                    beta <- min(beta, bestScore)
                }
                if(alfa >= beta){
                    break
                }
            }
            return(c(bestScore, path))
        }
    }
}