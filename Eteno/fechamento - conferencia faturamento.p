FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota >= 10/01/2019
                              AND   it-nota-fisc.dt-emis-nota <= 10/29/2019
                              AND   it-nota-fisc.dt-cancela = ?:
    FIND FIRST ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

    FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.

    IF natur-oper.emite-duplic = YES THEN DO:
        
    

    FIND FIRST grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo = ITEM.ge-codigo  NO-ERROR.

    FIND FIRST conta-ft NO-LOCK WHERE conta-ft.cod-estabel = it-nota-fisc.cod-estabel
                                AND   conta-ft.nat-operacao = it-nota-fisc.nat-operacao 
                                AND   conta-ft.ge-codigo    = ITEM.ge-codigo NO-ERROR.

    IF AVAIL conta-ft THEN DO:
        
        PUT UNFORMATTED  it-nota-fisc.dt-emis-nota ";"
                         conta-ft.ct-recven ";"
                        it-nota-fisc.cod-estabel ";"
                        it-nota-fisc.serie       ";"
                        it-nota-fisc.it-codigo   ";"
                        it-nota-fisc.nr-nota-fis ";"
                        it-nota-fisc.vl-tot-item ";"
                        item.ge-codigo   ";"
                        it-nota-fisc.nat-operacao ";"
                        natur-oper.cod-cfop
                        SKIP.
                        


    END.

    ELSE DO:
        
        FIND FIRST conta-ft NO-LOCK WHERE conta-ft.cod-estabel = it-nota-fisc.cod-estabel
                                    AND   conta-ft.ge-codigo   = item.ge-codigo
                                    AND   conta-ft.nat-operacao = ? NO-ERROR.


        PUT UNFORMATTED it-nota-fisc.dt-emis-nota ";" 
                        conta-ft.ct-recven ";"
                        it-nota-fisc.cod-estabel ";"
                        it-nota-fisc.serie       ";"
                        it-nota-fisc.it-codigo   ";"
                        it-nota-fisc.nr-nota-fis ";"
                        it-nota-fisc.vl-tot-item ";"
                        item.ge-codigo   ";"
            it-nota-fisc.nat-operacao ";"
            natur-oper.cod-cfop

                        SKIP.



    END.


END.
END.
