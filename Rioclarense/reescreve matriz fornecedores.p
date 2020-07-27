DEF TEMP-TABLE tt-emitente
    FIELD ttv-cod-emitente AS INTEGER
    FIELD ttv-nom-abrev    AS CHARACTER
    FIELD ttv-cnpj         AS char.

DEF BUFFER b-emitente FOR emitente.
DEF VAR h-prog AS HANDLE.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Criando TT").

    FOR EACH b-emitente NO-LOCK WHERE SUBSTRING(b-emitente.cgc, 9, 4) = "0001"
                                AND   b-emitente.identific > 1:

        RUN pi-acompanhar IN h-prog (INPUT "Emitente " + string(b-emitente.cod-emitente)).
         CREATE tt-emitente.
         ASSIGN tt-emitente.ttv-cod-emitente = b-emitente.cod-emitente
                tt-emitente.ttv-nom-abrev    = b-emitente.nome-matriz
                tt-emitente.ttv-cnpj         = substring(b-emitente.cgc, 1, 8).



    END.

    OUTPUT TO c:\desenv\tt-emitente.txt.
    FOR EACH tt-emitente:

        PUT UNFORMATTED tt-emitente.ttv-cod-emitente ";"
                        tt-emitente.ttv-nom-abrev ";"
                        tt-emitente.ttv-cnpj
            SKIP.
    END.
    OUTPUT CLOSE.



    RUN utp/ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Criando TT").
    FOR EACH tt-emitente:


        FOR EACH emitente          WHERE substring(emitente.cgc, 1, 8 ) = tt-emitente.ttv-cnpj
                                    AND   emitente.cod-emitente          <> tt-emitente.ttv-cod-emitente
                                    AND   emitente.identific           > 1:



            RUN pi-acompanhar IN h-prog (INPUT "Emitente " + string(emitente.cod-emitente)).
            
            
            assign emitente.nome-matriz = tt-emitente.ttv-nom-abrev.
            
            
 run cdp/cd1608.p (input emitente.cod-emitente,
                  input  emitente.cod-emitente,
                  input emitente.identific,
                  input 1,
                  input 1,
                  input 0,
                  input "c:\desenv\erros-3-" + string(cod-emitente) + ".txt",
                  input "arquivo",
                  input "").
           


        END.

    END.

RUN pi-finalizar IN h-prog.





