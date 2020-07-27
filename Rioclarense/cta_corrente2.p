DEFINE TEMP-TABLE tt-conta
    FIELD cod-bco    AS char
    FIELD cod-agencia AS char
    FIELD dig-agencia AS char
    FIELD cta-corren  AS char
    FIELD dig-cta     AS char
    FIELD cgc         AS char
    FIELD detalhe     AS char.
DEF VAR h-prog AS HANDLE.


INPUT FROM c:\desenv\contas.txt.

REPEAT:
    CREATE tt-conta.
    IMPORT DELIMITER "|" tt-conta.
END.
INPUT CLOSE.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").

OUTPUT TO c:\desenv\fornec.txt.

FOR EACH tt-conta:


    FIND FIRST emitente NO-LOCK WHERE emitente.cgc = TRIM(tt-conta.cgc) NO-ERROR.
    RUN pi-acompanhar IN h-prog (INPUT "Emitente " + string(emitente.cod-emitente)).

    IF AVAIL emitente THEN DO:
        

PUT UNFORMATTED  tt-conta.cod-bco           "|"
                 tt-conta.cod-agencia       "|"
                 tt-conta.dig-agencia       "|"
                 tt-conta.cta-corren        "|"
                 tt-conta.dig-cta           "|"
                 tt-conta.cgc               "|"
                 emitente.cod-emitente      "|"
                 emitente.nome-emit
                 SKIP.
    
    .


    END.

END.
