/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE VARIABLE i-cont-cond-especif AS INTEGER    NO-UNDO.

IF pedido-compr.cod-cond-pag = 0 THEN DO:
    find first cond-especif
         where cond-especif.num-pedido = pedido-compr.num-pedido no-lock no-error.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc + "<br>".

    if  avail cond-especif then
    DO i-cont-cond-especif = 1 TO 12:
        IF data-pagto[i-cont-cond-especif] <> ? THEN
            ASSIGN tt-html.html-doc = tt-html.html-doc + string(i-cont-cond-especif) + CHR(170) + " - "
                                                       + string(data-pagto[i-cont-cond-especif],"99/99/9999") + " - "
                                                       + string(perc-pagto[i-cont-cond-especif],">>9") + "% - "
                                                       + substring(cond-especif.comentarios[i-cont-cond-especif],1,72) + "<br>".
    END.
END.

