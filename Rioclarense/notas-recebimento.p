OUTPUT TO c:\temp\ERROs.txt.


DEFINE VAR h-prog AS HANDLE.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.
RUN pi-inicializar IN h-prog(INPUT "verificando").
FOR EACH docum-est NO-LOCK WHERE docum-est.dt-trans >= 01/01/2018
                           AND   docum-est.dt-trans <= 05/31/2018
                           AND   docum-est.cod-estabel >= "101"
                           AND   docum-est.cod-estabel <= "401"
                           :


    RUN pi-acompanhar IN h-prog(INPUT "Estab: " + docum-est.cod-estabel + " nf: " + docum-est.nro-docto + " data: " + string(docum-est.dt-trans)).
    FIND FIRST natur-oper NO-LOCK WHERE natur-oper.emite-duplic = no
                                  AND   natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.

    IF AVAIL natur-oper THEN DO:
        

        FIND FIRST movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel = docum-est.cod-estabel
                                       AND   movto-estoq.nro-docto   = docum-est.nro-docto
                                       AND   movto-estoq.serie-docto = docum-est.serie-docto
                                       AND   movto-estoq.cod-emitente = docum-est.cod-emitente
                                       NO-ERROR.

        IF AVAIL movto-estoq THEN DO:
            

            PUT UNFORMATTED movto-estoq.cod-estabel         ";"
                            movto-estoq.nro-docto           ";"
                            movto-estoq.serie-docto         ";"
                            movto-estoq.cod-emitente        ";"
                            movto-estoq.valor-mat-m[1]      ";"
                            movto-estoq.nat-operacao        ";"
                            movto-estoq.ct-codigo
                SKIP.






        END.


    END.
END.

RUN pi-finalizar IN h-prog.

MESSAGE "done" VIEW-AS ALERT-BOX.
