/*****************************************************************
***
*** EPC - Mostra os eventos de UPC das DBOïs.
***
*****************************************************************/

{utp/ut-glob.i}
{include/i-epc200.i bodi159}
{utp/utapi019.i}
{cdp/cd0666.i}

DEFINE VARIABLE h-bo-cota-venda AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-aux           AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-erro-aux      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cancela-saldo AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-qt-aux        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-tipo-cota     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-qtde-cota     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-saldo-pedido  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-it-codigo-aux AS CHAR        NO-UNDO.
DEFINE VARIABLE l-estorna       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-consumiu-cota AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-cota-prev    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-produtos      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-codigo        AS INTEGER     NO-UNDO.
/* Include com defini»’o da temp-table RowErrors */
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

DEF BUFFER b-sdv-cota-segmento FOR sdv-cota-segmento.
DEF BUFFER b-sdv-cota          FOR sdv-cota.

DEFINE VARIABLE c-cod-mercado AS CHARACTER   NO-UNDO.

//insercao FKIS - Verba cooperativa:



def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".


DEFINE VARIABLE i-cod-canal   AS INTEGER NO-UNDO.

DEFINE VARIABLE v_cod_unid_negoc AS CHAR NO-UNDO.

DEFINE VARIABLE h-cd9500 AS HANDLE NO-UNDO.

DEFINE VARIABLE r-conta-ft AS ROWID NO-UNDO.





DEF VAR l-mostra-mensagem AS LOG.

IF PROGRAM-NAME(2) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(2) = "pi-btsaveorder pdp/pd4000.w"     OR
   PROGRAM-NAME(3) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(3) = "pi-btsaveorder pdp/pd4000.w"     OR
   PROGRAM-NAME(4) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(4) = "pi-btsaveorder pdp/pd4000.w"     OR
   PROGRAM-NAME(5) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(5) = "pi-btsaveorder pdp/pd4000.w"     OR
   PROGRAM-NAME(6) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(6) = "pi-btsaveorder pdp/pd4000.w"     OR 
   PROGRAM-NAME(7) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(7) = "pi-btsaveorder pdp/pd4000.w"     OR 
   PROGRAM-NAME(8) = "pi-btCompleteorder pdp/pd4000.w" OR 
   PROGRAM-NAME(8) = "pi-btsaveorder pdp/pd4000.w"     OR 
    
   PROGRAM-NAME(2) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(2) = "pi-btsaveorder pdp/pd4000.p"     OR
   PROGRAM-NAME(3) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(3) = "pi-btsaveorder pdp/pd4000.p"     OR
   PROGRAM-NAME(4) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(4) = "pi-btsaveorder pdp/pd4000.p"     OR
   PROGRAM-NAME(5) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(5) = "pi-btsaveorder pdp/pd4000.p"     OR
   PROGRAM-NAME(6) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(6) = "pi-btsaveorder pdp/pd4000.p"     OR 
   PROGRAM-NAME(7) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(7) = "pi-btsaveorder pdp/pd4000.p"     OR 
   PROGRAM-NAME(8) = "pi-btCompleteorder pdp/pd4000.p" OR 
   PROGRAM-NAME(8) = "pi-btsaveorder pdp/pd4000.p"     THEN 
   ASSIGN l-mostra-mensagem = YES.
ELSE
   ASSIGN l-mostra-mensagem = NO.






IF  PROGRAM-NAME(1) MATCHES "*dex017*" OR
    PROGRAM-NAME(2) MATCHES "*dex017*" OR
    PROGRAM-NAME(3) MATCHES "*dex017*" OR
    PROGRAM-NAME(4) MATCHES "*dex017*" OR
    PROGRAM-NAME(5) MATCHES "*dex017*" OR
    PROGRAM-NAME(6) MATCHES "*dex017*" OR
    PROGRAM-NAME(7) MATCHES "*dex017*" OR 
    PROGRAM-NAME(8) MATCHES "*dex017*" THEN 
    ASSIGN l-mostra-mensagem = YES.


     
/***
IF PROGRAM-NAME(4) = "pi-btsaveorder pdp/pd4000.w" THEN DO:
    BLOCK:
    FOR EACH tt-epc :
       /* modifica‡Æo de pedidos */
       
       IF tt-epc.cod-event = "afterupdaterecord"
       AND tt-epc.cod-parameter = "table-rowid" THEN DO:
           FINd FIRST ped-venda
               WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
           IF AVAIL ped-venda THEN DO:
               RUN lepper/leupc/pd4000x.w (INPUT rowid(ped-venda)).
               /*LEAVE BLOCK.*/
           END.
       END.
    
       /*inclusÆo de pedidos */
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

// NDS 86516 - INICIO - estorna/valida/efetiva consumo de cora
IF p-ind-event = "beforeCompleteOrder" THEN DO:

    IF INDEX(PROGRAM-NAME(1), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(2), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(3), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(4), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(5), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(6), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(7), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(8), "pi-btCancelationOrder") > 0 OR
       INDEX(PROGRAM-NAME(9), "pi-btCancelationOrder") > 0 THEN
        ASSIGN l-cancela-saldo = YES.

    ASSIGN h-aux = ?.
    FOR FIRST tt-epc WHERE
              tt-epc.cod-parameter = "Object-Handle":
        ASSIGN h-aux = HANDLE(tt-epc.val-parameter).
    END.

    RUN dop/bo-cota-venda.p PERSISTENT SET h-bo-cota-venda.

    IF l-cancela-saldo = YES THEN DO: // Cancelando saldo do pedido - deve apenas estornar diferen‡a entre quantidade pedida e atendida
        FOR EACH tt-epc WHERE
                 tt-epc.cod-parameter = "Table-Rowid",
            FIRST ped-venda NO-LOCK WHERE
                  ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

            /* o estorno do saldo serve tamb‚m para pedidos oriundos do SDV
            FIND FIRST sdv-ped-venda NO-LOCK WHERE
                       sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
            IF AVAIL sdv-ped-venda THEN NEXT.*/
    
            FOR EACH ped-item OF ped-venda NO-LOCK WHERE
                     ped-item.qt-atendida > 0 AND
                     ped-item.qt-pedida   > ped-item.qt-atendida:

                ASSIGN i-qt-aux = INT(ped-item.qt-pedida > ped-item.qt-atendida).

                IF i-qt-aux <= 0 THEN NEXT.

                RUN estorna-consumo-cota IN h-bo-cota-venda(INPUT (ped-venda.nome-abrev          + CHR(2) +
                                                                   ped-venda.nr-pedcli           + CHR(2) +
                                                                   STRING(ped-item.nr-sequencia) + CHR(2) +
                                                                   ped-item.it-codigo),
                                                            INPUT "Estorno autom tico do saldo devido a cancelamento de pedido atendido parcial",
                                                            INPUT i-qt-aux). // quantidade informada pois cancelamento ‚ somente do saldo
            END.
        END. // EACH tt-epc, FIRST ped-venda
    END.
    ELSE DO:
        /* Primeiro desfaz consumo j  feito para o pedido.
        Isso pode ocorrer pois o pedido pode ser completado v rias vezes */
        
        controlecotas:
        DO TRANSACTION:
            FOR EACH tt-epc WHERE
                     tt-epc.cod-parameter = "Table-Rowid",
                FIRST ped-venda NO-LOCK WHERE
                      ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):
        
                /* deverá estornar mesmo se vier do SDV, porque pode haver altera‡äes de quantidade
                FIND FIRST sdv-ped-venda NO-LOCK WHERE
                           sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL sdv-ped-venda THEN NEXT.*/
        
                FOR EACH ped-item NO-LOCK OF ped-venda:
                    RUN estorna-consumo-cota IN h-bo-cota-venda(INPUT (ped-venda.nome-abrev          + CHR(2) +
                                                                       ped-venda.nr-pedcli           + CHR(2) +
                                                                       STRING(ped-item.nr-sequencia) + CHR(2) +
                                                                       ped-item.it-codigo),
                                                                INPUT "Estorno autom tico pois pedido foi completado",
                                                                INPUT 0). // quantidade autom tica, igual ao que foi previamente consumido).
                END.
            END. // EACH tt-epc, FIRST ped-venda
        
            /* Valida novo consumo de cota */
            ASSIGN l-erro = NO.
            FOR EACH tt-epc WHERE
                     tt-epc.cod-parameter = "Table-Rowid",
                FIRST ped-venda NO-LOCK WHERE
                      ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):
        
    /*             FIND FIRST sdv-ped-venda NO-LOCK WHERE                             */
    /*                        sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR. */
    /*             IF AVAIL sdv-ped-venda THEN NEXT.                                  */
                
                FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
                
                FIND FIRST sgv-seg-mercado NO-LOCK WHERE
                           sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
                FIND FIRST repres NO-LOCK WHERE
                           repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
                FIND FIRST dc-repres-gestor NO-LOCK WHERE
                           dc-repres-gestor.cod-rep     = repres.cod-rep              AND
                           dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
        
                FOR EACH ped-item NO-LOCK OF ped-venda:

                    RUN valida-cota IN h-bo-cota-venda(INPUT  ped-item.it-codigo,
                                                       INPUT  (IF AVAIL dc-repres-gestor THEN dc-repres-gestor.cod-gestor ELSE ""),
                                                       INPUT  emitente.cod-canal-venda,
                                                       INPUT  ped-item.qt-pedida,
                                                       INPUT  ped-venda.cgc,
                                                       OUTPUT d-qtde-cota,  
                                                       OUTPUT c-tipo-cota, 
                                                       OUTPUT l-erro-aux,
                                                       OUTPUT i-codigo).
                    IF l-erro-aux = YES AND VALID-HANDLE(h-aux) THEN DO:

                        ASSIGN l-erro = YES.

                        // Chamado 96220 - Modificada mensagem de bloqueio
                        RUN _insertErrorManual IN h-aux(INPUT 17006,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Item " + ped-item.it-codigo + " possui cota de vendas." + CHR(10) + "Saldo da Cota: " + TRIM(STRING(d-qtde-cota), "->>>,>>>,>>9") + CHR(10) + "Para necessidade acima do saldo da cota, consulte o ADM de Vendas (n§ cota " + STRING(i-codigo) + ").",
                                                        INPUT "Item " + ped-item.it-codigo + " possui cota de vendas." + CHR(10) + "Saldo da Cota: " + TRIM(STRING(d-qtde-cota), "->>>,>>>,>>9") + CHR(10) + "Para necessidade acima do saldo da cota, consulte o ADM de Vendas (n§ cota " + STRING(i-codigo) + ").",
                                                        INPUT "Item " + ped-item.it-codigo + " possui cota de vendas." + CHR(10) + "Saldo da Cota: " + TRIM(STRING(d-qtde-cota), "->>>,>>>,>>9") + CHR(10) + "Para necessidade acima do saldo da cota, consulte o ADM de Vendas (n§ cota " + STRING(i-codigo) + ").").

/*                        IF d-qtde-cota <> 0 THEN                                                                                                                                                                                                                        */
/*                           RUN _insertErrorManual IN h-aux (INPUT 17006,                                                                                                                                                                                                */
/*                                                            INPUT "EMS",                                                                                                                                                                                                */
/*                                                            INPUT "ERROR",                                                                                                                                                                                              */
/*                                                            INPUT "Item do pedido sem Cota de Venda: " + ped-item.it-codigo + ".",                                                                                                                                      */
/*                                                            INPUT "Item do pedido sem Cota de Venda: " + ped-item.it-codigo + ", Tipo Cota: "+ c-tipo-cota + ", Qtde: " + STRING(d-qtde-cota) + "." + " NÆo ser  poss¡vel Efetivar o pedido. Consulte Adm. de Vendas!", */
/*                                                            INPUT "NÆo ser  poss¡vel Efetivar o pedido. Consulte Adm. de Vendas!").                                                                                                                                     */
/*                        ELSE                                                                                                                                                                                                                                            */
/*                           RUN _insertErrorManual IN h-aux(INPUT 17006,                                                                                                                                                                                                 */
/*                                                           INPUT "EMS",                                                                                                                                                                                                 */
/*                                                           INPUT "ERROR",                                                                                                                                                                                               */
/*                                                           INPUT "Item do pedido sem Cota de Venda: " + ped-item.it-codigo + ".",                                                                                                                                       */
/*                                                           INPUT "NÆo ser  poss¡vel Efetivar o pedido. Consulte Adm. de Vendas!",                                                                                                                                       */
/*                                                           INPUT "NÆo ser  poss¡vel Efetivar o pedido. Consulte Adm. de Vendas!").                                                                                                                                      */
    
                        UNDO controlecotas, LEAVE controlecotas.
                    END.
                END.
            END. // EACH tt-epc, FIRST ped-venda
        END. //DO Transaction
    
        /* Efetiva novo consumo de cota */
        IF l-erro = NO THEN DO:
            FOR EACH tt-epc WHERE
                     tt-epc.cod-parameter = "Table-Rowid",
                FIRST ped-venda NO-LOCK WHERE
                      ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):
        
/*                 FIND FIRST sdv-ped-venda NO-LOCK WHERE                             */
/*                            sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR. */
/*                 IF AVAIL sdv-ped-venda THEN NEXT.                                  */

                FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    
                FIND FIRST sgv-seg-mercado NO-LOCK WHERE
                           sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
                FIND FIRST repres NO-LOCK WHERE
                           repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
                FIND FIRST dc-repres-gestor NO-LOCK WHERE
                           dc-repres-gestor.cod-rep     = repres.cod-rep              AND
                           dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
    
                FOR EACH ped-item NO-LOCK OF ped-venda: 
                 
                    RUN consome-cota IN h-bo-cota-venda(INPUT ped-item.it-codigo,
                                                        INPUT (IF AVAIL dc-repres-gestor THEN dc-repres-gestor.cod-gestor ELSE ""),
                                                        INPUT emitente.cod-canal-venda,
                                                        INPUT INT(ped-item.qt-pedida),
                                                        //INPUT INT(d-saldo-pedido),
                                                        INPUT (ped-venda.nome-abrev          + CHR(2) +
                                                               ped-venda.nr-pedcli           + CHR(2) +
                                                               STRING(ped-item.nr-sequencia) + CHR(2) +
                                                               ped-item.it-codigo),
                                                        INPUT "Pedido " + ped-venda.nr-pedcli + ", Item " + ped-item.it-codigo + ", Quantidade " + TRIM(STRING(INT(ped-item.qt-pedida))),
                                                        INPUT ped-venda.cgc).
                    
                END.
            END. // EACH tt-epc, FIRST ped-venda
        END. // l-erro = NO
    END. // l-cancela-saldo = NO

    DELETE PROCEDURE h-bo-cota-venda NO-ERROR.

END. // p-ind-event = "beforeCompleteOrder"
// NDS 86516 - FIM - estorna/valida/efetiva consumo de cora

// NDS 66686 - INICIO - consumo de cota
IF p-ind-event = "beforeCompleteOrder" THEN DO:

    /* Primeiro desfaz consumo j  feito para o pedido.
       Isso pode ocorrer pois o pedido pode ser completado v rias vezes */
    FOR EACH tt-epc WHERE
             tt-epc.cod-parameter = "Table-Rowid",
        FIRST ped-venda NO-LOCK WHERE
              ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

        FIND FIRST sdv-ped-venda NO-LOCK WHERE
                   sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL sdv-ped-venda THEN NEXT.

        FOR EACH sdv-cota-hist-pedidos EXCLUSIVE-LOCK WHERE
                 sdv-cota-hist-pedidos.nome-abrev = ped-venda.nome-abrev AND
                 sdv-cota-hist-pedidos.nr-pedcli  = ped-venda.nr-pedcli:

            FIND FIRST sdv-cota EXCLUSIVE-LOCK WHERE
                       sdv-cota.cod-cota = sdv-cota-hist-pedidos.cod-cota NO-ERROR.
            ASSIGN sdv-cota.cota-cons = sdv-cota.cota-cons - ABSOLUTE(sdv-cota-hist-pedidos.cota-saldo-antes - sdv-cota-hist-pedidos.cota-saldo-depois).
            RELEASE sdv-cota NO-ERROR. // Chamado 95167

            DELETE sdv-cota-hist-pedidos.
        END.
    END.

    // Valida a cota
    ASSIGN h-aux = ?.
    FIND FIRST tt-epc WHERE
               tt-epc.cod-parameter = 'Object-Handle' AND
               tt-epc.val-parameter > ''              NO-ERROR.
    ASSIGN h-aux = HANDLE(tt-epc.val-parameter) WHEN AVAIL tt-epc NO-ERROR.
    IF VALID-HANDLE(h-aux) THEN DO:

        FOR EACH tt-epc WHERE
                 tt-epc.cod-parameter = "Table-Rowid",
            FIRST ped-venda NO-LOCK WHERE
                  ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

            FIND FIRST sdv-ped-venda NO-LOCK WHERE
                       sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
            IF AVAIL sdv-ped-venda THEN NEXT.

            FIND FIRST emitente NO-LOCK WHERE
                       emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

            FIND FIRST sgv-seg-mercado NO-LOCK WHERE
                       sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.

            FOR EACH sdv-cota NO-LOCK WHERE
                     sdv-cota.data-inicio <= TODAY AND
                     sdv-cota.data-fim    >= TODAY AND
                     sdv-cota.ativa        = YES   AND
                     sdv-cota.cod-mercado  = sgv-seg-mercado.cod-mercado:

                ASSIGN de-cota-prev = sdv-cota.cota-prev - sdv-cota.cota-cons
                       c-produtos   = "".

                FIND FIRST sdv-cota-segmento NO-LOCK WHERE
                           sdv-cota-segmento.cod-cota = sdv-cota.cod-cota NO-ERROR.
                FIND FIRST b-sdv-cota-segmento NO-LOCK WHERE
                           b-sdv-cota-segmento.cod-cota        = sdv-cota.cod-cota        AND
                           b-sdv-cota-segmento.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
                IF NOT AVAIL sdv-cota-segmento OR AVAIL b-sdv-cota-segmento THEN DO:

                    FOR EACH ped-item NO-LOCK WHERE
                             ped-item.nome-abrev = ped-venda.nome-abrev AND
                             ped-item.nr-pedcli  = ped-venda.nr-pedcli:

                        FIND FIRST sdv-cota-produto NO-LOCK WHERE
                                   sdv-cota-produto.cod-cota  = sdv-cota.cod-cota  AND
                                   sdv-cota-produto.it-codigo = ped-item.it-codigo NO-ERROR.
                        IF AVAIL sdv-cota-produto THEN DO:
                            IF c-produtos > "" THEN ASSIGN c-produtos = c-produtos + ", ".

                            ASSIGN de-cota-prev = de-cota-prev - INT(ped-item.qt-pedida)
                                   c-produtos   = c-produtos + ped-item.it-codigo.

                        END. // AVAIL sdv-cota-produto
                    END. // EACH sdv-ped-item
                END. // NOT AVAIL sdv-cota-segmento OR AVAIL b-sdv-cota-segmento

                IF de-cota-prev < 0  AND 
                   c-produtos   > "" THEN DO:

                    RUN _insertErrorManual IN h-aux('17006',
                                                    'EMS',
                                                    'ERROR',
                                                    "Itens do pedido com Cota Atingida! Cota Cod: " + STRING(sdv-cota.cod-cota) + ". NÆo ser  poss¡vel transmitir o pedido. Consulte Adm. de Vendas! Itens: " + c-produtos,
                                                    "Itens do pedido com Cota Atingida! Cota Cod: " + STRING(sdv-cota.cod-cota) + ". NÆo ser  poss¡vel transmitir o pedido. Consulte Adm. de Vendas! Itens: " + c-produtos,
                                                    "Itens do pedido com Cota Atingida! Cota Cod: " + STRING(sdv-cota.cod-cota) + ". NÆo ser  poss¡vel transmitir o pedido. Consulte Adm. de Vendas! Itens: " + c-produtos).
                    RETURN "NOK".
                END.
            END. // EACH sdv-cota
        END. // EACH tt-epc, FIRST ped-venda
    END. // VALID-HANDLE(h-aux)

    // Consome a cota
    FOR EACH tt-epc WHERE
             tt-epc.cod-parameter = "Table-Rowid",
        FIRST ped-venda NO-LOCK WHERE
              ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

        FIND FIRST sdv-ped-venda NO-LOCK WHERE
                   sdv-ped-venda.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL sdv-ped-venda THEN NEXT.

        FIND FIRST sgv-seg-mercado NO-LOCK WHERE
                   sgv-seg-mercado.cod-canal-venda = ped-venda.cod-canal-venda NO-ERROR.
        ASSIGN c-cod-mercado = IF AVAIL sgv-seg-mercado THEN sgv-seg-mercado.cod-mercado ELSE "".

        FOR EACH sdv-cota NO-LOCK WHERE
                 sdv-cota.data-inicio <= TODAY AND
                 sdv-cota.data-fim    >= TODAY AND
                 sdv-cota.ativa        = YES   AND
                 sdv-cota.cod-mercado  = c-cod-mercado:

            ASSIGN l-consumiu-cota = FALSE. // incluido em 07/11/2019

            FIND FIRST sdv-cota-segmento NO-LOCK WHERE
                       sdv-cota-segmento.cod-cota = sdv-cota.cod-cota NO-ERROR.
            FIND FIRST b-sdv-cota-segmento NO-LOCK WHERE
                       b-sdv-cota-segmento.cod-cota        = sdv-cota.cod-cota         AND
                       b-sdv-cota-segmento.cod-canal-venda = ped-venda.cod-canal-venda NO-ERROR.
            IF NOT AVAIL sdv-cota-segmento OR AVAIL b-sdv-cota-segmento THEN DO:

                FOR EACH ped-item NO-LOCK WHERE
                         ped-item.nome-abrev = ped-venda.nome-abrev AND
                         ped-item.nr-pedcli  = ped-venda.nr-pedcli:
                    FIND FIRST sdv-cota-produto NO-LOCK WHERE
                               sdv-cota-produto.cod-cota  = sdv-cota.cod-cota  AND
                               sdv-cota-produto.it-codigo = ped-item.it-codigo NO-ERROR.
                    IF AVAIL sdv-cota-produto THEN DO:

                        ASSIGN l-consumiu-cota = TRUE. // incluido em 07/11/2019

                        CREATE sdv-cota-hist-pedidos.
                        ASSIGN sdv-cota-hist-pedidos.cod-cota         = sdv-cota.cod-cota
                               sdv-cota-hist-pedidos.nome-abrev       = ped-venda.nome-abrev
                               sdv-cota-hist-pedidos.nr-pedcli        = ped-venda.nr-pedcli
                               sdv-cota-hist-pedidos.nr-sequencia     = ped-item.nr-sequencia
                               sdv-cota-hist-pedidos.it-codigo        = ped-item.it-codigo
                               sdv-cota-hist-pedidos.data-hora        = NOW
                               sdv-cota-hist-pedidos.cota-saldo-antes = sdv-cota.cota-prev - sdv-cota.cota-cons.

                        FIND FIRST b-sdv-cota EXCLUSIVE-LOCK WHERE // Chamado 95167
                                   ROWID(b-sdv-cota) = ROWID(sdv-cota) NO-ERROR.
                        ASSIGN b-sdv-cota.cota-cons = b-sdv-cota.cota-cons + INT(ped-item.qt-pedida).
                        ASSIGN sdv-cota-hist-pedidos.cota-saldo-depois = b-sdv-cota.cota-prev - b-sdv-cota.cota-cons.
                        RELEASE b-sdv-cota NO-ERROR.
        
                    END. // AVAIL sdv-cota-produto
                END. // EACH ped-item
            END. // NOT AVAIL sdv-cota-segmento OR AVAIL b-sdv-cota-segmento

            IF l-consumiu-cota = TRUE AND // incluido em 07/11/2019
               (sdv-cota.cota-prev - sdv-cota.cota-cons) <= sdv-cota.saldo-env-mail AND
               sdv-cota.emails-contato > "" THEN DO:

                RUN dop/email.p(INPUT "automatico@docol.com.br",
                                INPUT sdv-cota.emails-contato,
                                INPUT "Cota " + STRING(sdv-cota.cod-cota) + " '" + sdv-cota.desc-cota + "' Atingida.",
                                INPUT ("A Cota " + STRING(sdv-cota.cod-cota) + " Î '" + sdv-cota.desc-cota + "' foi atingida. NÆo ser  mais poss¡vel transmitir pedidos para o Mercado/Segmento da Cota."
                                      + CHR(10) + CHR(10)
                                      + "Cota Prevista: " + STRING(sdv-cota.cota-prev) + CHR(10)
                                      + "Cota Consumida: " + STRING(sdv-cota.cota-cons) + CHR(10)
                                      + "Saldo: " + STRING(sdv-cota.cota-prev - sdv-cota.cota-cons) + CHR(10)
                                      + "Verifique necessidade de remanejamento!"),
                                INPUT "",
                                OUTPUT TABLE tt-erros).
            END.
        END. // EACH sdv-cota
    END. // EACH tt-epc, FIRST ped-venda
END. // p-ind-event = "beforeCompleteOrder"
// NDS 66686 - FIM - consumo de cota

FOR EACH tt-epc:
    IF (tt-epc.cod-event = "beforecompleteorder" AND tt-epc.cod-parameter = "table-rowid") THEN DO:
        FIND FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            /*---- Programa para Acerta a Natureza de Opera‡Æo no Ped-item ---*/
            RUN dop/dpd562.p (INPUT ped-venda.nome-abrev,
                              INPUT ped-venda.nr-pedcli).
            IF l-mostra-mensagem THEN DO:
               RUN doepc/pd4000x.p (INPUT rowid(ped-venda)).
            END.
        END.
    END.



    IF (tt-epc.cod-event = "aftercompleteorder" AND tt-epc.cod-parameter = "table-rowid") THEN DO:
        FIND FIRST ped-venda WHERE ROWID(ped-venda) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST dc-ped-venda WHERE dc-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            RUN dop/dpd560.p (INPUT ped-venda.nome-abrev,
                              INPUT ped-venda.nr-pedcli,
                              INPUT dc-ped-venda.log-reativou-pedido, /* Reativacao */
                              INPUT l-mostra-mensagem). 

            RUN pi-execucao-orctaria.

        END.
    END.
END.  /* for each tt-epc */


PROCEDURE pi-execucao-orctaria:

    ASSIGN i-cod-canal = ped-venda.cod-canal-venda.

    IF NOT VALID-HANDLE(h-cd9500) THEN
        RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

    FIND FIRST param-global NO-ERROR.
    EMPTY TEMP-TABLE tt_xml_input_1.

    FIND FIRST conta-ft NO-LOCK
         WHERE conta-ft.cod-estabel = ped-venda.cod-estabel
           AND conta-ft.nat-oper    = ped-venda.nat-oper
           AND conta-ft.cod-canal   = i-cod-canal NO-ERROR.
    IF NOT AVAIL conta-ft THEN DO: //TRANSACTION
        ASSIGN i-cod-canal = 0. /* Se nao zerar o canal de venda busca a conta errada no faturamento */
    END.

    FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST estabelecimento NO-LOCK WHERE estabelecimento.cod_estab = ped-venda.cod-estabel NO-ERROR.
    FOR EACH  unid-negoc-grp-usuar NO-LOCK
        WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
        EACH  unid-negoc-estab NO-LOCK
        WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
          AND unid-negoc-estab.cod-estabel     = estabelecimento.cod_estab
          AND unid-negoc-estab.dat-inic-valid <= TODAY
          AND unid-negoc-estab.dat-fim-valid  >= TODAY:

        ASSIGN v_cod_unid_negoc = unid-negoc-estab.cod-unid-negoc.
    END.



    /* Busca dados de Conta e Centro de Custo */
    RUN pi-cd9500 IN h-cd9500(INPUT  ped-venda.cod-estabel,
                              INPUT  emitente.cod-gr-cli,
                              INPUT  ?,
                              INPUT  ped-venda.nat-operacao,
                              INPUT  ?,
                              INPUT  "",
                              INPUT  i-cod-canal,
                              OUTPUT r-conta-ft).

    FIND FIRST conta-ft NO-LOCK
        WHERE ROWID(conta-ft)    = r-conta-ft
        AND   conta-ft.ct-cusven = "435362" NO-ERROR.


    IF avail conta-ft THEN DO:
        

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label       = "Fun‡Æo"
           tt_xml_input_1.tt_des_conteudo    = "Verifica"
           tt_xml_input_1.tt_num_seq_1_xml   = 1
           tt_xml_input_1.tt_num_seq_2_xml   = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label       = "Empresa"
           tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
           tt_xml_input_1.tt_num_seq_1_xml   = 1
           tt_xml_input_1.tt_num_seq_2_xml   = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label       = "Conta Cont bil"
           tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.ct-cusven)
           tt_xml_input_1.tt_num_seq_1_xml   = 1
           tt_xml_input_1.tt_num_seq_2_xml   = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
           tt_xml_input_1.tt_des_conteudo    = ped-venda.cod-estabel
           tt_xml_input_1.tt_num_seq_1_xml   = 1
           tt_xml_input_1.tt_num_seq_2_xml   = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
           tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.dt-entrega)
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
           tt_xml_input_1.tt_des_conteudo   = "0"
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
           tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.vl-liq-ped)
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
           tt_xml_input_1.tt_des_conteudo   = "1"
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
           tt_xml_input_1.tt_des_conteudo   = "92"
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
           tt_xml_input_1.tt_des_conteudo   = "Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
           tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
           tt_xml_input_1.tt_num_seq_1_xml  = 1
           tt_xml_input_1.tt_num_seq_2_xml  = 0.

    create tt_xml_input_1.
    assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
           tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.sc-cusven)
           tt_xml_input_1.tt_num_seq_1_xml   = 1
           tt_xml_input_1.tt_num_seq_2_xml   = 0.

    RUN prgfin/bgc/bgc700za.py (input 1,
                                input table tt_xml_input_1,
                                output table tt_log_erros) .  



    find first tt_log_erros no-lock no-error.
    if  avail tt_log_erros then do: 

        RUN dop/dpd557.p (INPUT ped-venda.nome-abrev, 
                          INPUT ped-venda.nr-pedcli,
                          INPUT tt_log_erros.ttv_des_ajuda,
                          OUTPUT TABLE tt-erro). /* programa que suspende o pedido */

               RUN dop/MESSAGE.p (INPUT "O Pedido ficou SUSPENSO Novamente!",
                                   INPUT "Motivo: " + tt_log_erros.ttv_des_ajuda).


               RETURN 'nok'.

    END.


    ELSE DO:
    FIND FIRST tt_xml_input_1 WHERE tt_xml_input_1.tt_cod_label       = "Funcao" NO-ERROR.
    ASSIGN  tt_xml_input_1.tt_des_conteudo = "Atualiza".
  
    RUN prgfin/bgc/bgc700za.py (input 1,
                                input table tt_xml_input_1,
                                output table tt_log_erros) .  
  
    END.

    END.

    IF VALID-HANDLE(h-cd9500) THEN
    DELETE WIDGET h-cd9500.

END PROCEDURE.



/* fim epc */




/* fim epc */





/* fim epc */
