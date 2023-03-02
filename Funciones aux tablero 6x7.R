check_vector <- function(row, value, n=4){
    b <- rle(row==value)
    w <- which(b$values)
    if(any(b$lengths[w]>=n)) T else F
}

nuevo_juego<-function(){
    library(ggplot2)
    board_m = matrix(nrow = 6, ncol = 7)
    board <- reshape::melt(board_m)
    colnames(board) <- c("Row", "Col", "value")
    board$value[is.na(board$value)] <- 0
    list(
        tablero = array(0,c(6,7)),
        status = T,
        winner = 0,
        board = board
    )
}

jugada <- function(p, col, player, verbose = T){
    t <- p$tablero
    board <- p$board
    
    #comprobar la jugada
    a <- rev(which(t[, col] == 0))
    if(!length(a)){
        if(verbose) cat(sprintf("\n\nERROR: Imposible poner en esa columna"))
        return(p)
    }
    row <- a[1]
    t[row, col] <- player
    
    for (i in 1:6){
        for(j in 1:7){
            if (t[i, j] == 1){
                board[(board$Row == i & board$Col == j), 3] <- "p1"
            }
            else if (t[i, j] == 2){
                board[(board$Row == i & board$Col == j), 3] <- "p2"
            }
            else{
                board[(board$Row == i & board$Col == j), 3] <- 0
            }
            
        }
    }
    # Comprueba si es jugada ganadora
    # extrae los 4 vectores: horizontal, vertical, diagonal y diagonal invertida
    v_row <- t[row,]
    v_col <- t[,col]
    v_diag <- t[col(t)==row(t) + (col-row)]
    v_diag_inv <- t[cbind(7, col(t)[, nrow(col(t)):1])==row(t)+nrow(t)-row-col+2]
    # comprueba si en alguno de los vectores hay 4 en linea
    win <- F # un flag para el control
    if (check_vector(v_row, player, 4)) win <- T
    if (check_vector(v_col, player, 4)) win <- T
    if (check_vector(v_diag, player, 4)) win <- T
    if (check_vector(v_diag_inv, player, 4)) win <- T
    if (win){
        if(verbose) cat(sprintf("\n\nJUGADOR %d HA GANADO!!\n\n", player))
        p$status = F
        p$winner = player
    }
    
    # Saca en pantalla y devuelve el tablero
    if(verbose) print(t)
    p$tablero = t
    
    plot <- ggplot(board, aes(x = Col, y = Row, fill = factor(value)))+
        geom_tile(color="black", width=1, height=1, size=2)+
        scale_fill_manual(values = c("p1" = "#EB143F","p2" = "#FFD300", "0" = "white"))+
        theme_bw()+
        theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank())+
        scale_y_reverse(breaks=seq(1,6,1))+
        scale_x_continuous(breaks=seq(1,7,1))
    
    
    print(plot)
    return(p)
}


 