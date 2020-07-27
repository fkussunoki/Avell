OUTPUT TO c:\desenv\cst.txt.

DEFINE VAR h-prog AS HANDLE.
DEFINE VAR i-tot AS INTEGER.

RUN utp/ut-perc.p PERSISTENT SET h-prog.




FOR EACH sit-tribut-relacto FIELDS(sit-tribut-relacto.cdn-tribut sit-tribut-relacto.cdn-sit-tribut sit-tribut-relacto.idi-tip-docto
                                   sit-tribut-relacto.cod-ncm sit-tribut-relacto.dat-valid-inic) NO-LOCK WHERE sit-tribut-relacto.cdn-tribut = 2
                                    AND   sit-tribut-relacto.cdn-sit-tribut = 1 BREAK BY sit-tribut-relacto.cod-ncm + string(sit-tribut-relacto.idi-tip-docto):


    IF FIRST-OF(sit-tribut-relacto.cod-ncm + string(sit-tribut-relacto.idi-tip-docto)) THEN DO:
        
        ASSIGN i-tot = i-tot + 1.

        END.
END.


RUN pi-inicializar IN h-prog(INPUT "Vedo", i-tot).
FOR EACH sit-tribut-relacto FIELDS(sit-tribut-relacto.cdn-tribut sit-tribut-relacto.cdn-sit-tribut sit-tribut-relacto.idi-tip-docto
                                   sit-tribut-relacto.cod-ncm sit-tribut-relacto.dat-valid-inic) NO-LOCK WHERE sit-tribut-relacto.cdn-tribut = 2
                                    AND   sit-tribut-relacto.cdn-sit-tribut = 1 BREAK BY sit-tribut-relacto.cod-ncm + string(sit-tribut-relacto.idi-tip-docto):


    IF FIRST-OF(sit-tribut-relacto.cod-ncm + string(sit-tribut-relacto.idi-tip-docto)) THEN DO:
        RUN pi-acompanhar IN h-prog.

        PUT UNFORMATTED sit-tribut-relacto.cdn-tribut "|"
                        sit-tribut-relacto.cdn-sit-tribut "|"
                        sit-tribut-relacto.cod-ncm "|"
                        sit-tribut-relacto.dat-valid-inic "|"
                        sit-tribut-relacto.idi-tip-docto
                        SKIP.
    END.

END.

RUN pi-finalizar IN h-prog.
