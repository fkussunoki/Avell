 /*-------> Parametros <------------------------------------------------------*/
 DEFINE PARAM BUFFER b-p-table       FOR ordem-compra.
 DEFINE PARAM BUFFER b-p-old-table   FOR ordem-compra.

FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = b-p-table.num-pedido
                        NO-ERROR.

IF AVAIL pedido-compr THEN DO:
  
    ASSIGN pedido-compr.situacao = 1.

END.


