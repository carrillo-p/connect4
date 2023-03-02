checkwinner <- function(board, move, max, min){
    win <- F #check de condicion de victoria
    winner <- F #check de jugador que ha ganado
    t <- board
    a <- rev(which(t[, 1:7] == 0))
    row <- move[1]
    col <- move[2]
    v_row <- t[row,]
    v_col <- t[,col]
    v_diag <- t[col(t)==row(t) + (col-row)]
    v_diag_inv <- t[cbind(7, col(t)[,nrow(col(t)):1])==row(t)+nrow(t)-row-col+2]
    if (check_vector(v_row, max, 4)|check_vector(v_col, max, 4)|check_vector(v_diag, max, 4)|check_vector(v_diag_inv, max, 4)){
        win <- T
        winner <- max
    }
    if (check_vector(v_row, min, 4)|check_vector(v_col, min, 4)|check_vector(v_diag, min, 4)|check_vector(v_diag_inv, min, 4)){
        win <- T
        winner <- min
    }
    if(winner == F & length(a) == 0){
        win <- T
        winner <- 0
    }
    if(winner == F & length(a) > 0){
        win <- F
        winner <- NULL
    }
    return(list(win, winner))
}

heuristico <- function(board, move, max, min){
    row <- move[1]
    col <- move[2]
    t <- board
    v_row <- t[row,]
    v_col <- t[,col]
    v_diag <- t[col(t)==row(t) + (col-row)]
    v_diag_inv <- t[cbind(7, col(t)[,nrow(col(t)):1])==row(t)+nrow(t)-row-col+2]
    score <- 0
    if(col == 4 & t[row, col] == max){
        score <- score + 4
    }
    if(check_vector(v_row, max, 2)|check_vector(v_col, max, 2)|check_vector(v_diag, max, 2)|check_vector(v_diag_inv, max, 2)){
        score <- score + 2
    }
    if(check_vector(v_row, max, 3)|check_vector(v_col, max, 3)|check_vector(v_diag, max, 3)|check_vector(v_diag_inv, max, 3)){
        score <- score + 6
    }
    if(col == 4 & t[row, col] == min){
        score <- score - 4
    }
    if (check_vector(v_row, min, 2)|check_vector(v_col, min, 2)|check_vector(v_diag, min, 2)|check_vector(v_diag_inv, min, 2)){
        score <- score - 2
    }
    if(check_vector(v_row, min, 3)|check_vector(v_col, min, 3)|check_vector(v_diag, min, 3)|check_vector(v_diag_inv, min, 3)){
        score <- score -100 #queremos asegurar que excepto en condicion de victoria siempre se bloqueen combinaciones de 3
    }
    return(score)
}


is_terminal_node <- function(board, move, maxplayer, minplayer){
    terminal_node <- F
    t <- board
    a <- rev(which(t[, 1:7] == 0))
    winner <- checkwinner(board, move, maxplayer, minplayer)[[1]]
    if(winner | length(a) == 0){ #si el movimiento no es legal o hay un ganador se ha llegado al nodo terminal
        terminal_node <- T
    }
    return(terminal_node)
}
