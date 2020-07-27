/*****************************************************************
***
*** EPC - Mostra os eventos de UPC das DBOÔs.
***
*****************************************************************/

{utp/ut-glob.i}
{include/i-epc200.i bodi159}

DEF VAR v-handle AS HANDLE.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
               
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

DEF VAR l-mostra-mensagem AS LOG.

DEFINE VARIABLE da-dt-entrega-aux  AS DATE        NO-UNDO.
DEFINE VARIABLE c-nome-abrev-aux   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-pedcli-aux    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-operacao-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cod-emitente-aux AS INTEGER     NO-UNDO.

IF PROGRAM-NAME(1) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(1) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(2) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(2) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(3) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(3) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(4) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(4) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(5) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(5) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(6) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(6) matches "*pi-btsaveorder pdp/pd4000*"     OR 
   PROGRAM-NAME(7) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(7) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(8) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(8) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(9) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(9) matches "*pi-btsaveorder pdp/pd4000*"     OR
   PROGRAM-NAME(10) matches "*pi-btCompleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(10) matches "*pi-btsaveorder pdp/pd4000*"     THEN 
   ASSIGN l-mostra-mensagem = YES.
ELSE
   ASSIGN l-mostra-mensagem = NO.

// NDS 62283 - INICIO - valida se data de entrega estava ou foi alterada para meses passados
IF p-ind-event       = "BeforeValidateRecord" AND
   l-mostra-mensagem = YES                    THEN DO: // Necess†rio para somente entrar pelo pd4000 -> caso contr†rio impede dsdv100r de implantar pedido!

    FIND FIRST tt-epc WHERE
               tt-epc.cod-parameter = "Table-Rowid" NO-ERROR.

    FIND FIRST ped-venda NO-LOCK WHERE
               ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

    FIND FIRST tt-epc WHERE
               tt-epc.cod-parameter = "Object-Handle" NO-ERROR.
    IF AVAIL ped-venda AND AVAIL tt-epc THEN DO:

        RUN getDateField IN WIDGET-HANDLE(tt-epc.val-parameter) (INPUT "dt-entrega"  , OUTPUT da-dt-entrega-aux).
        RUN getCharField IN WIDGET-HANDLE(tt-epc.val-parameter) (INPUT "nome-abrev"  , OUTPUT c-nome-abrev-aux).
        RUN getCharField IN WIDGET-HANDLE(tt-epc.val-parameter) (INPUT "nr-pedcli"   , OUTPUT c-nr-pedcli-aux).
        RUN getIntField  IN WIDGET-HANDLE(tt-epc.val-parameter) (INPUT "cod-emitente", OUTPUT i-cod-emitente-aux).
        RUN getCharField IN WIDGET-HANDLE(tt-epc.val-parameter) (INPUT "nat-operacao", OUTPUT c-nat-operacao-aux).

        // Necess†rio validar nome-abrev e nr-pedcli para n∆o impactar na criaá∆o!
        IF da-dt-entrega-aux <> ?                    AND
           da-dt-entrega-aux <> ped-venda.dt-entrega AND // bloqueia apenas alteraá∆o da data de entrega
           c-nome-abrev-aux   = ped-venda.nome-abrev AND
           c-nr-pedcli-aux    = ped-venda.nr-pedcli  THEN DO:

            IF c-nat-operacao-aux BEGINS "5922" OR
               c-nat-operacao-aux BEGINS "6922" THEN DO: // Chamado 81468
                RUN _insertErrorManual IN WIDGET-HANDLE(tt-epc.val-parameter)
                    (INPUT "17006",                                                                                                               /* cod erro */
                     INPUT "EMS":U,                                                                                                               /* tipo */
                     INPUT "ERROR":U,                                                                                                             /* subtipo */
                     INPUT "(upc-bodi159) Data de Entrega n∆o pode ser alterada.",                                                                /* descricao */
                     INPUT "(upc-bodi159) Data de Entrega n∆o pode ser alterada quando Natureza de Operaá∆o Ç de Remessa Futura (5922 ou 6922).", /* help */
                     INPUT "Data de Entrega n∆o pode ser alterada.").                                                                             /* parametros */
            END.
            
            IF ped-venda.dt-entrega <= (TODAY - DAY(TODAY)) THEN DO:
                IF ped-venda.tp-pedido <> "10" /* EXPORTACAO */          AND      
                   ped-venda.tp-pedido <> "11" /* PROFORMA EXPORTACAO */ THEN DO:  // Chamado 90703
                    FIND FIRST aux-libfat NO-LOCK WHERE
                               aux-libfat.cod-emitente = i-cod-emitente-aux  AND
                               aux-libfat.nr-pedcli    = ped-venda.nr-pedcli AND
                               aux-libfat.dt-libera   <> ?                   NO-ERROR.
                    IF AVAIL aux-libfat AND // se data est† no passado, bloqueia apenas se j† possuir aux-libfat
                       NOT (c-nat-operacao-aux BEGINS "6116" OR c-nat-operacao-aux BEGINS "5116") THEN // Chamado 80332 - Permite alterar data para naturezas de remessa futura, mas n∆o atualizar† aux-libfat
                        RUN _insertErrorManual IN WIDGET-HANDLE(tt-epc.val-parameter)
                            (INPUT "17006",                                                                                          /* cod erro */
                             INPUT "EMS":U,                                                                                          /* tipo */
                             INPUT "ERROR":U,                                                                                        /* subtipo */
                             INPUT "(upc-bodi159) Data de Entrega n∆o pode ser alterada.",                                           /* descricao */
                             INPUT "(upc-bodi159) Data de Entrega est† definida para um màs j† encerrado, e n∆o pode ser alterada.", /* help */
                             INPUT "Data de Entrega n∆o pode ser alterada.").                                                        /* parametros */
                END.
            END.
            ELSE IF da-dt-entrega-aux <= (TODAY - DAY(TODAY)) THEN DO:
                RUN _insertErrorManual IN WIDGET-HANDLE(tt-epc.val-parameter)
                    (INPUT "17006",                                                                         /* cod erro */
                     INPUT "EMS":U,                                                                         /* tipo */
                     INPUT "ERROR":U,                                                                       /* subtipo */
                     INPUT "(upc-bodi159) Data de Entrega inv†lida.",                                       /* descricao */
                     INPUT "(upc-bodi159) Data de Entrega n∆o pode ser alterada para um màs j† encerrado.", /* help */
                     INPUT "Data de Entrega inv†lida.").                                                    /* parametros */
            END.
        END.
        /* LEVUM */
        FOR FIRST lev-param NO-LOCK
            WHERE lev-param.cod-estabel = ped-venda.cod-estabel:

            IF LOOKUP(ped-venda.tp-pedido,lev-param.tp-pedido,",") > 0 THEN DO: /* verifica se pedido louáas aguardando armazÇm */
                FOR FIRST lev-edi-ped-venda NO-LOCK
                    WHERE lev-edi-ped-venda.nr-pedcli  = ped-venda.nr-pedcli
                      AND lev-edi-ped-venda.nome-abrev = ped-venda.nome-abrev:

                    IF CAN-FIND(FIRST lev-edi-ped-item NO-LOCK
                                WHERE lev-edi-ped-item.nr-pedcli  = lev-edi-ped-venda.nr-pedcli
                                  AND lev-edi-ped-item.nome-abrev = lev-edi-ped-venda.nome-abrev
                                  AND (  lev-edi-ped-item.ind-sit-item = 2 /* enviado EDI */
                                       OR (   lev-edi-ped-item.ind-sit-item = 3 /* separado armazem */
                                          AND lev-edi-ped-item.qt-recebida < lev-edi-ped-item.qt-solicitada))) /* nao retornou NF */ THEN 
                        RUN _insertErrorManual IN WIDGET-HANDLE(tt-epc.val-parameter)
                            (INPUT "17006",                                                                         /* cod erro */
                             INPUT "EMS":U,                                                                         /* tipo */
                             INPUT "ERROR":U,                                                                       /* subtipo */
                             INPUT "(upc-bodi159) Pedido em separaá∆o no ArmazÇm.",                                 /* descricao */
                             INPUT "(upc-bodi159) Pedido em separaá∆o no ArmazÇm n∆o pode ser alterado.",           /* help */
                             INPUT "Data de Entrega inv†lida.").                                                    /* parametros */
                END.
            END.
        END.

    END. // AVAIL ped-venda AND AVAIL tt-epc
END. // p-ind-event = "BeforeValidateRecord"
// NDS 62283 - FIM - valida se data de entrega estava ou foi alterada para meses passados

// NDS 62283 - INICIO - atualiza a dt-libera da aux-libfat conforme data de entrega do pedido, sempre para 1o dia do màs
IF p-ind-event = "endatualizapedido" THEN DO:
    FOR FIRST tt-epc WHERE
              tt-epc.cod-parameter = "rowid(ped-venda)",
        FIRST ped-venda NO-LOCK WHERE
              ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter) AND
              NOT (ped-venda.nat-operacao BEGINS "6116" OR ped-venda.nat-operacao BEGINS "5116"), // Chamado 80332 - Para naturezas de remessa futura n∆o atualiza aux-libfat
        EACH aux-libfat EXCLUSIVE-LOCK WHERE
             aux-libfat.cod-emitente = ped-venda.cod-emitente AND
             aux-libfat.nr-pedcli    = ped-venda.nr-pedcli:
        ASSIGN aux-libfat.dt-libera = DATE(MONTH(ped-venda.dt-entrega), 1, YEAR(ped-venda.dt-entrega)).
    END. // FIRST tt-epc, FIRST ped-venda, EACH aux-libfat
END. // p-ind-event = "endatualizapedido"
// NDS 62283 - FIM - atualiza a dt-libera da aux-libfat conforme data de entrega do pedido, sempre para 1o dia do màs

IF PROGRAM-NAME(1) matches "*pi-btsaveorder pdp/pd4000*" OR
   PROGRAM-NAME(2) matches "*pi-btsaveorder pdp/pd4000*" OR
   PROGRAM-NAME(3) matches "*pi-btsaveorder pdp/pd4000*" OR
   PROGRAM-NAME(4) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(5) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(6) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(7) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(8) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(9) matches "*pi-btsaveorder pdp/pd4000*" OR 
   PROGRAM-NAME(10) matches "*pi-btsaveorder pdp/pd4000*" THEN DO:
       BLOCK:



       FOR EACH tt-epc :
          IF tt-epc.cod-event matches "beforeupdaterecord" AND tt-epc.cod-parameter matches "table-rowid" THEN DO:
              FINd FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
              IF AVAIL ped-venda THEN DO:
                  /*LEAVE BLOCK.*/
                  IF ped-venda.tp-pedido <> "10" THEN DO:
                      RUN doepc/pd4000x.p (INPUT rowid(ped-venda)).
                  END.
                  run pi-valida-levum. 
              END.
          END.

          /*
          IF tt-epc.cod-event matches "aftercreaterecord" AND tt-epc.cod-parameter matches "table-rowid" THEN DO:
              FINd FIRST ped-venda WHERE ROWID(ped-venda) matches to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
              IF AVAIL ped-venda AND ped-venda.tp-pedido matches "09" THEN DO:
                  RUN doepc/pd4000x.p (INPUT rowid(ped-venda)).
                  /*LEAVE BLOCK.*/
              END.
          END.
          */

       END.        
END. /* pdp/pd400.w */




FOR EACH tt-epc:
    IF (tt-epc.cod-event matches "afterupdaterecord" AND tt-epc.cod-parameter matches "table-rowid") THEN DO:
        FIND FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
           FIND FIRST dc-ped-venda WHERE dc-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
           RUN dop/dpd560.p (INPUT ped-venda.nome-abrev,
                             INPUT ped-venda.nr-pedcli,
                             INPUT dc-ped-venda.log-reativou-pedido, /* Reativacao */
                             INPUT l-mostra-mensagem). 
        END.
    END.
END.  /* for each tt-epc */



/*--- Somente o Usu†rio Super poder† ----*/
IF PROGRAM-NAME(1)  matches "*pi-btdeleteorder pdp/pd4000*" OR
   PROGRAM-NAME(2)  matches "*pi-btdeleteorder pdp/pd4000*" OR
   PROGRAM-NAME(3)  matches "*pi-btdeleteorder pdp/pd4000*" OR
   PROGRAM-NAME(4)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(5)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(6)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(7)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(8)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(9)  matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(10) matches "*pi-btdeleteorder pdp/pd4000*" OR 
   PROGRAM-NAME(11) matches "*pi-btdeleteorder pdp/pd4000*" THEN DO:


    FIND FIRST tt-epc
         WHERE tt-epc.cod-event matches "beforedeleterecord" 
           AND tt-epc.cod-parameter matches "table-rowid" NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        FIND FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF AVAIL ped-venda AND LOOKUP('sup',v_cod_grp_usuar_lst) = 0  THEN DO:
            FIND FIRST tt-epc WHERE tt-epc.cod-param matches "object-handle" NO-ERROR.
            IF AVAIL tt-epc THEN DO:
                IF AVAIL tt-epc THEN DO:
                            RUN _insertErrorManual IN widget-handle(tt-epc.val-parameter) 
                              ( INPUT "17006",                         /* cod erro */
                                INPUT "EMS":U,                    /* tipo */
                                INPUT "ERROR":U,                  /* subtipo */
                                INPUT "(upc-bodi159) Eliminaá∆o n∆o permitida!",     /* descricao */
                                INPUT "(upc-bodi159) Eliminaá∆o n∆o permitida!",                         /* help */
                                INPUT "Eliminaá∆o n∆o permitida!").                        /* parametros */
                 END. /* if not avail  */
            END.
            RETURN ERROR.
        END.
        IF AVAIL ped-venda THEN
            RUN pi-valida-levum.
    END.  /* for each tt-epc */
END.


PROCEDURE pi-valida-levum:
    DEF BUFFER bf-epc FOR tt-epc.

    FOR FIRST lev-param NO-LOCK
        WHERE lev-param.cod-estabel = ped-venda.cod-estabel:

        IF LOOKUP(ped-venda.tp-pedido,lev-param.tp-pedido,",") > 0 THEN DO: /* verifica se pedido louáas aguardando armazÇm */
            FOR FIRST lev-edi-ped-venda NO-LOCK
                WHERE lev-edi-ped-venda.nr-pedcli  = ped-venda.nr-pedcli
                  AND lev-edi-ped-venda.nome-abrev = ped-venda.nome-abrev:

                IF CAN-FIND(FIRST lev-edi-ped-item NO-LOCK
                            WHERE lev-edi-ped-item.nr-pedcli  = lev-edi-ped-venda.nr-pedcli
                              AND lev-edi-ped-item.nome-abrev = lev-edi-ped-venda.nome-abrev
                              AND (  lev-edi-ped-item.ind-sit-item = 2 /* enviado EDI */
                                   OR (   lev-edi-ped-item.ind-sit-item = 3 /* separado armazem */
                                      AND lev-edi-ped-item.qt-recebida < lev-edi-ped-item.qt-solicitada))) /* nao retornou NF */ THEN DO:

                    FOR FIRST bf-epc
                        WHERE bf-epc.cod-parameter = "Object-Handle":
                        RUN _insertErrorManual IN WIDGET-HANDLE(bf-epc.val-parameter)
                            (INPUT 17006,                                                                          /* cod erro */
                             INPUT "EMS":U,                                                                         /* tipo */
                             INPUT "ERROR":U,                                                                       /* subtipo */
                             INPUT "(upc-bodi159) Pedido em separaá∆o no ArmazÇm.",                                 /* descricao */
                             INPUT "(upc-bodi159) Pedido em separaá∆o no ArmazÇm n∆o pode ser alterado.",           /* help */
                             INPUT "Pedido em separaá∆o no ArmazÇm.").                                              /* parametros */
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.



/* fim epc */
