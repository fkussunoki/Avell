OUTPUT TO c:\temp\ter.txt.


DEF VAR h-prog AS HANDLE.
DEF VAR i-tot AS INTEGER.


RUN utp/ut-perc.p PERSISTENT SET h-prog.

FOR EACH saldo-terc NO-LOCK:
ASSIGN i-tot = i-tot + 1.
END.


RUN pi-inicializar IN h-prog ("Gerando", i-tot).

FOR EACH saldo-terc NO-LOCK WHERE saldo-terc.quantidade <> 0:

FOR EACH componente USE-INDEX documento NO-LOCK WHERE componente.cod-emitente = saldo-terc.cod-emitente
                                                AND   componente.nro-docto    = saldo-terc.nro-docto
                                                AND   componente.serie-docto  = saldo-terc.serie-docto
                                                AND   componente.nat-operacao = saldo-terc.nat-operacao
                                                AND   componente.it-codigo    = saldo-terc.it-codigo
                                                AND   componente.sequencia    = saldo-terc.sequencia:



    RUN pi-acompanhar IN h-prog.
    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = componente.cod-emitente NO-ERROR.

    FIND FIRST ITEM     NO-LOCK WHERE ITEM.it-codigo = componente.it-codigo NO-ERROR.

    FIND FIRST it-doc-fisc NO-LOCK WHERE it-doc-fisc.serie        = componente.serie-docto
                                   AND   it-doc-fisc.cod-emitente = componente.cod-emitente
                                   AND   it-doc-fisc.it-codigo    = componente.it-codigo
                                   AND   it-doc-fisc.nat-operacao = componente.nat-operacao
                                   AND   it-doc-fisc.nr-doc-fis   = componente.nro-docto
                                   NO-ERROR.

    IF AVAIL it-doc-fisc THEN DO:
        

        PUT UNFORMATTED it-doc-fisc.cod-estabel "|".
    END.

    ELSE DO:
        PUT UNFORMATTED "" "|".
    END.


    PUT UNFORMATTED componente.dt-retorno       "|"
                    componente.cod-emitente     "|"
                    emitente.nome-emit          "|"
                    componente.nro-docto        "|"
                    componente.serie-docto      "|"
                    componente.nat-operacao     "|"
                    componente.it-codigo        "|"
                    item.descricao-1            "|"
                    componente.sequencia        "|"
                    componente.quantidade       "|"
                    componente.preco-total      "|"
                    componente.componente       "|"
                    
                    SKIP.
            

    END.
END.

RUN pi-finalizar IN h-prog.
