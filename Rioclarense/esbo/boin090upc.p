/*: *******************************************************************************
** Autor: Flavio Kussunoki
** Empresa: FKIS Consultoria (47) 99230-5495
** Criacao: 12/04/2018
** Solicitante: Izael Uchoa
** Objetivo do programa: Efetuar validacao na RE1001 da natureza de operacao e
** confrontar com a tabela especifica ext-conta-ft, para preenchimento da conta 
** transitoria de fornecedor no caso de naturezas nao financeiras
*******************************************************************************/




{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
{esbo/boin090.i RowObject}

DEF INPUT PARAM p-ind-event AS CHAR   NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF VAR h-BO                AS HANDLE NO-UNDO.

IF  p-ind-event = "conta-transitoria" THEN DO:
    FIND FIRST tt-epc WHERE
         tt-epc.cod-event = p-ind-event AND
         tt-epc.cod-parameter = "" NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).

        RUN getRecord IN h-bo (OUTPUT TABLE RowObject).



        FIND FIRST RowObject EXCLUSIVE-LOCK NO-ERROR.

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao  = rowObject.nat-operacao NO-ERROR.

        IF natur-oper.emite-duplic = no THEN
            ASSIGN RowObject.ct-transit = "".

        FIND FIRST ext-conta-ft NO-LOCK WHERE ext-conta-ft.nat-operacao = rowObject.nat-operacao NO-ERROR.

        IF AVAIL ext-conta-ft THEN DO:
            
        
        ASSIGN RowObject.ct-transit = ext-conta-ft.ct-codigo
               rowObject.sc-transit = ext-conta-ft.sc-codigo.


        END.

        RUN setRecord IN h-bo (INPUT TABLE RowObject).
    END.
END.
