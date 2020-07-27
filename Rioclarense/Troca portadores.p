DEF TEMP-TABLE TT-PORTADORES
    FIELD TTV-EMITENTE  AS INTEGER
    FIELD TTV-PORTADOR  AS INTEGER.

DEF TEMP-TABLE TT-ANTIGO
    FIELD TTV-EMITENTE AS INTEGER
    FIELD TTV-PORTADOR AS INTEGER
    FIELD TTV-MODALIDADE AS INTEGER.

DEF VAR h-prog AS HANDLE.



INPUT FROM C:\TEMP\PORTADOR.TXT.


REPEAT:
    CREATE TT-PORTADORES.
    IMPORT DELIMITER ";" TT-PORTADORES.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").
FOR EACH TT-PORTADORES:

    FIND FIRST EMITENTE WHERE EMITENTE.cod-emitente = TT-PORTADORES.TTV-EMITENTE NO-ERROR.

    IF AVAIL EMITENTE THEN DO:
    RUN pi-acompanhar IN h-prog (INPUT "Emitente " + EMITENTE.nome-abrev).    

        CREATE TT-ANTIGO.
        ASSIGN TT-ANTIGO.TTV-EMITENTE = EMITENTE.cod-emitente
               TT-ANTIGO.TTV-PORTADOR = EMITENTE.portador
               TT-ANTIGO.TTV-MODALIDADE = EMITENTE.modalidade.

        ASSIGN EMITENTE.portador = TT-PORTADORES.ttv-portador
               EMITENTE.modalidade = 1.


        run cdp/cd1608.p (input emitente.cod-emitente,
                         input  emitente.cod-emitente,
                         input emitente.identific,
                         input 1,
                         input 1,
                         input 0,
                         input "c:\temp\erros-3-" + string(cod-emitente) + ".txt",
                         input "arquivo",
                         input "").



    END.

END.
RUN pi-finalizar IN h-prog.

OUTPUT TO c:\temp\listagem-old.txt.

FOR EACH tt-antigo:
    EXPORT tt-antigo.
END.


OUTPUT CLOSE.


