INPUT FROM c:\desenv\ordens.txt.


DEFINE TEMP-TABLE tt-ordem
    FIELD num-ordem AS INTEGER.


REPEAT:
    CREATE tt-ordem.
    IMPORT tt-ordem.
END.


FOR EACH tt-ordem:

    FOR EACH ordem-compra WHERE ordem-compra.numero-ordem = tt-ordem.num-ordem
                          AND   ordem-compra.situacao     <= 3,
        EACH prazo-compra WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                          AND   prazo-compra.situacao     <= 3:


        ASSIGN prazo-compra.situacao = 4
               ordem-compra.situacao = 4.


    END.

    
END.
