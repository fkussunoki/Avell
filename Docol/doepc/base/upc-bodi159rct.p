/*****************************************************************
***
*** EPC - Mostra os eventos de UPC das DBOÔs.
***
*****************************************************************/

ON WRITE OF ped-venda OVERRIDE DO:

END.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

{utp/ut-glob.i}
{include/i-epc200.i bodi159}

DEF VAR v-handle AS HANDLE.

               
/* Include com definiªío da temp-table RowErrors */
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE RowObject NO-UNDO LIKE ped-item
    FIELD r-Rowid AS ROWID.

DEF INPUT PARAM  p-ind-event AS  CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.



    /*
MESSAGE PROGRAM-NAME(1)  SKIP
        PROGRAM-NAME(2)  SKIP
        PROGRAM-NAME(3)  SKIP
        PROGRAM-NAME(4)  SKIP
        PROGRAM-NAME(5)  SKIP
        PROGRAM-NAME(6)  SKIP
        PROGRAM-NAME(7)  SKIP
        PROGRAM-NAME(8)  SKIP
        VIEW-AS ALERT-BOX.
     */



/**    
MESSAGE "entrei (upc-bodi159rct)" VIEW-AS ALERT-BOX.
FOR EACH tt-epc:
        MESSAGE "p-ind-event -> " p-ind-event SKIP
                "tt-epc.cod-event -> " tt-epc.cod-event SKIP
                "tt-epc.cod-parameter -> " tt-epc.cod-parameter SKIP
                "tt-epc.val-parameter -> " tt-epc.val-parameter 
               VIEW-AS ALERT-BOX.
END.
**/





/***
IF PROGRAM-NAME(4) = "pi-btsaveorder pdp/pd4000.w" THEN DO:
    BLOCK:
    FOR EACH tt-epc :
       MESSAGE "tt-epc.cod-event -> " tt-epc.cod-event SKIP
               "tt-epc.cod-parameter -> " tt-epc.cod-parameter SKIP
               "tt-epc.val-parameter -> " tt-epc.val-parameter 
              VIEW-AS ALERT-BOX.

       /* modificaá∆o de pedidos */
       
       IF tt-epc.cod-event = "afterupdaterecord"
       AND tt-epc.cod-parameter = "table-rowid" THEN DO:
           FINd FIRST ped-venda
               WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
           IF AVAIL ped-venda THEN DO:
               RUN lepper/leupc/pd4000x.w (INPUT rowid(ped-venda)).
               /*LEAVE BLOCK.*/
           END.
       END.
    
       /*inclus∆o de pedidos */
        /*MESSAGE "passei inclusao" VIEW-AS ALERT-BOX.*/
       IF tt-epc.cod-event = "aftercreaterecord"
       AND tt-epc.cod-parameter = "table-rowid" THEN DO:
           FINd FIRST ped-venda
               WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
           IF AVAIL ped-venda THEN DO:
               RUN lepper/leupc/pd4000x.w (INPUT rowid(ped-venda)).
               /*LEAVE BLOCK.*/
           END.
       END.
    
    END.        
END.
***/

IF p-ind-event = "AfterReactivationOrder"  THEN DO:
    FOR EACH tt-epc:
        IF (tt-epc.cod-event = "AfterReactivationOrder" AND tt-epc.cod-parameter = "rowid-ped-venda") THEN DO:
            FIND FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL ped-venda THEN DO:
                FIND FIRST dc-ped-venda WHERE dc-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                ASSIGN dc-ped-venda.log-reativou-pedido = YES.
                ASSIGN ped-venda.completo               = NO.
                RUN dop/MESSAGE.p (INPUT userid("mgadm") + ", vocà deve Completar o Pedido!",
                                   INPUT "Atená∆o o Pedido N«O est† Completo! " + chr(10) + "Vocà deve Completar o Pedido!" + CHR(10) + CHR(10) + 
                                          "Usuario EMS: " + c-seg-usuario). 

                /*---------------------------------------------------------------------------------------------- 
                            Problema:
                            O usu†rio ira reativar para alterar algum campo.
                            Se o programa suspender ap¢s a reativaá∆o o usuario n∆o consegue alterar este campo
                  ---------------------------------------------------------------------------------------------
                ASSIGN dc-ped-venda.log-reativou-pedido = YES.
                RUN dop/dpd560.p (INPUT ped-venda.nome-abrev,
                                  INPUT ped-venda.nr-pedcli,
                                  INPUT dc-ped-venda.log-reativou-pedido, /* Reativacao */
                                  INPUT YES /* l-mostra-mensagem */). 
                -----------------------------------------------------------------*/

            END.
        END.
    END.  /* for each tt-epc */
END. /* if p-ind-event ... */





/* fim epc */
