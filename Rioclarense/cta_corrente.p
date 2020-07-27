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

FOR EACH tt-conta:


    FIND FIRST emitente NO-LOCK WHERE emitente.cgc = TRIM(tt-conta.cgc) NO-ERROR.
    RUN pi-acompanhar IN h-prog (INPUT "Emitente " + string(emitente.cod-emitente)).

    IF AVAIL emitente THEN DO:
        

        CREATE cta_corren_fornec.
        ASSIGN cta_corren_fornec.cod_empresa = "1"
               cta_corren_fornec.cdn_fornecedor = emitente.cod-emitente
               cta_corren_fornec.cod_banco      = tt-conta.cod-bco
               cta_corren_fornec.cod_agenc_bcia = tt-conta.cod-agencia
               cta_corren_fornec.cod_digito_agenc_bcia = tt-conta.dig-agencia
               cta_corren_fornec.cod_cta_corren_bco = tt-conta.cta-corren
               cta_corren_fornec.cod_digito_cta_corren = tt-conta.dig-cta
               cta_corren_fornec.des_cta_corren = IF tt-conta.detalhe <> "" THEN tt-conta.detalhe ELSE "Conta Corrente - Planilha"
               cta_corren_fornec.log_cta_corren_prefer = YES
               .


    END.

END.
