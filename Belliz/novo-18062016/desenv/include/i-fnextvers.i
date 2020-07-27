/************************************************************************************
**  Include.: /include/i-fnextvers.i
**  Objetivo: Imprime a funá∆o no extrato de vers∆o caso o mesmo esteja habilitado 
**  Data....: 20/10/2003
************************************************************************************/

if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    output to value(c-arquivo-log) append.
    put {1} at 1 {2} at 69 skip.
    output close.        
end.  
error-status:error = no.
