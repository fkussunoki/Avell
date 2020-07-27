/*******************************************************************************
**  Cliente  : RioClarense
**  Sistema  : EMS - 5.06
**  Programa : upc_acr240aa.p
**  Objetivo : Implementar campos espec¡ficos na Consulta de T¡tulos em Aberto
**  Data     : 10/2014
**  Autor    : Joao Tagliatti - Tauil Consultoria
**  Versao   : 5.06.000
*******************************************************************************/

DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID         NO-UNDO.

/*** Defini‡Æo de Vari veis Globais ***/
DEFINE NEW GLOBAL SHARED VAR whBrTable              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT      AS WIDGET-HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VAR whBrTable_proc              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_proc           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT_proc            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT_proc          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT_proc        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT_proc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT_proc   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT_proc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT_proc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT_proc    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT_proc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT_proc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT_proc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT_proc      AS WIDGET-HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VAR whBrTable_506               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_506            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT_506             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT_506           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT_506         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT_506       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT_506       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT_506     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT_506      AS WIDGET-HANDLE NO-UNDO.



DEFINE NEW GLOBAL SHARED VAR whBrTable_un                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT_un              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT_un            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT_un          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT_un        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT_un     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT_un       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT_un      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT_un    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT_un     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT_un      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT_un      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT_un      AS WIDGET-HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VAR whBrTable_un_506            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un_506         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT_un_506          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT_un_506        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT_un_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT_un_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT_un_506 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT_un_506       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT_un_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT_un_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT_un_506     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT_un_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT_un_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT_un_506      AS WIDGET-HANDLE NO-UNDO.


/*** Defini‡Æo de Vari veis Locais ***/
DEFINE VARIABLE wh-objeto          AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-frame           AS WIDGET-HANDLE NO-UNDO.

/* MESSAGE "p-ind-event   =  " p-ind-event             SKIP */
/*         "p-ind-object  =  " p-ind-object            SKIP */
/*         "p-wgh-object  =  " p-wgh-object            SKIP */
/*         "p-wgh-frame   =  " p-wgh-frame             SKIP */
/*         "p-cod-table   =  " p-cod-table             SKIP */
/*         "p-rec-table   =  " STRING(p-rec-table)     SKIP */
/*         "p-wgh-object  =  " p-wgh-object:FILE-NAME       */
/*         VIEW-AS ALERT-BOX.                               */

IF p-ind-event = "INITIALIZE" THEN DO:
   ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD.
   DO WHILE VALID-HANDLE(wh-frame):
      ASSIGN wh-objeto = wh-frame:FIRST-CHILD.
      DO WHILE VALID-HANDLE(wh-objeto):
         CASE wh-objeto:TYPE:
            WHEN "browse" THEN DO:
                IF wh-objeto:NAME = "br_tit_acr_em_aberto"        THEN ASSIGN whBrTable        = wh-objeto.
                IF wh-objeto:NAME = "br_tit_acr_em_aberto_proc"   THEN ASSIGN whBrTable_proc   = wh-objeto.
                IF wh-objeto:NAME = "br_tit_acr_em_aberto_506"    THEN ASSIGN whBrTable_506    = wh-objeto.
                IF wh-objeto:NAME = "br_tit_acr_em_aberto_un"     THEN ASSIGN whBrTable_un     = wh-objeto.
                IF wh-objeto:NAME = "br_tit_acr_em_aberto_un_506" THEN ASSIGN whBrTable_un_506 = wh-objeto.
               
            END.
         END.
         ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING NO-ERROR.
      END.
      ASSIGN wh-frame = wh-frame:NEXT-SIBLING NO-ERROR.
   END.
   IF VALID-HANDLE(whBrTable) THEN DO:
       ASSIGN whColUF_BrT            = whBrTable:ADD-CALC-COLUMN("CHAR", "x(2)", "", "UF", (whBrTable:NUM-COLUMNS + 1))
              whColCodRep_BrT        = whBrTable:ADD-CALC-COLUMN("INT", ">>>>>9", "", "Cod Rep", (whBrTable:NUM-COLUMNS + 2))
              whColPort_BrT          = whBrTable:ADD-CALC-COLUMN("CHAR", "x(6)", "", "Port", (whBrTable:NUM-COLUMNS + 3))
              whColTipoPgto_BrT      = whBrTable:ADD-CALC-COLUMN("CHAR", "x(10)", "", "Tipo Pagto", (whBrTable:NUM-COLUMNS + 4))
              whColTipoEntrega_BrT   = whBrTable:ADD-CALC-COLUMN("CHAR", "x(17)", "", "Sit.Pedido", (whBrTable:NUM-COLUMNS + 5))
              whColEmpenho_BrT       = whBrTable:Add-calc-column("Char", "x(12)", "", "Empenho", (whBrTable:NUM-COLUMNS + 6))
              whColPedTotvs_BrT      = whBrTable:Add-calc-column("Char", "x(9)", "", "PedTOTVS", (whBrTable:NUM-COLUMNS + 7))
              whColProcLicita_BrT    = whBrTable:Add-calc-column("Char", "x(30)", "", "Proc.Licitacao", (whBrTable:NUM-COLUMNS + 8))
              whColLicitacao_BrT     = whBrTable:Add-calc-column("Char", "x(17)", "", "Licitacao", (whBrTable:NUM-COLUMNS + 9))
              whColProcesso_BrT      = whBrTable:Add-calc-column("Char", "x(30)", "", "Processo", (whBrTable:NUM-COLUMNS + 10))
              whColVlTotPedido_Brt   = whBrTable:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pedido", (whBrTable:Num-Columns + 11))
              whColVlTotPendente_Brt = whBrTable:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pendente", (whBrTable:Num-Columns + 12))
              whQryBrTable      = whBrTable:QUERY.
       ON "row-display" OF whBrTable PERSISTENT RUN upc/upc_acr240aa-a.p.
   END. /* IF VALID-HANDLE(whBrTable) THEN DO: */
   IF VALID-HANDLE(whBrTable_proc) THEN DO:
       ASSIGN whColUF_BrT_proc            = whBrTable_proc:ADD-CALC-COLUMN("CHAR", "x(2)", "", "UF", (whBrTable_proc:NUM-COLUMNS + 1))
              whColCodRep_BrT_proc        = whBrTable_proc:ADD-CALC-COLUMN("INT", ">>>>>9", "", "Cod Rep", (whBrTable_proc:NUM-COLUMNS + 2))
              whColPort_BrT_proc          = whBrTable_proc:ADD-CALC-COLUMN("CHAR", "x(6)", "", "Port", (whBrTable_proc:NUM-COLUMNS + 3))
              whColTipoPgto_BrT_proc      = whBrTable_proc:ADD-CALC-COLUMN("CHAR", "x(10)", "", "Tipo Pagto", (whBrTable_proc:NUM-COLUMNS + 4))
              whColTipoEntrega_BrT_proc   = whBrTable_proc:ADD-CALC-COLUMN("CHAR", "x(17)", "", "Sit.Pedido", (whBrTable_proc:NUM-COLUMNS + 5))
              whColEmpenho_BrT_proc       = whBrTable_proc:Add-calc-column("Char", "x(12)", "", "Empenho", (whBrTable_proc:NUM-COLUMNS + 6))
              whColPedTotvs_BrT_proc      = whBrTable_proc:Add-calc-column("Char", "x(9)", "", "PedTOTVS", (whBrTable_proc:NUM-COLUMNS + 7))
              whColProcLicita_BrT_proc    = whBrTable_proc:Add-calc-column("Char", "x(30)", "", "Proc.Licitacao", (whBrTable_proc:NUM-COLUMNS + 8))
              whColLicitacao_BrT_proc     = whBrTable_proc:Add-calc-column("Char", "x(17)", "", "Licitacao", (whBrTable_proc:NUM-COLUMNS + 9))
              whColProcesso_BrT_proc      = whBrTable_proc:Add-calc-column("Char", "x(30)", "", "Processo", (whBrTable_proc:NUM-COLUMNS + 10))
              whColVlTotPedido_Brt_proc   = whBrTable_proc:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pedido", (whBrtable_proc:Num-Columns + 11))
              whColVlTotPendente_Brt_proc = whBrTable_proc:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pendente", (whBrtable_proc:Num-Columns + 12))
              whQryBrTable_proc         = whBrTable_proc:QUERY.
       ON "row-display" OF whBrTable_proc PERSISTENT RUN upc/upc_acr240aa-b.p.
   END. /* IF VALID-HANDLE(whBrTable) THEN DO: */
   IF VALID-HANDLE(whBrTable_506) THEN DO:
       ASSIGN whColUF_BrT_506            = whBrTable_506:ADD-CALC-COLUMN("CHAR", "x(2)", "", "UF", (whBrTable_506:NUM-COLUMNS + 1))
              whColCodRep_BrT_506        = whBrTable_506:ADD-CALC-COLUMN("INT", ">>>>>9", "", "Cod Rep", (whBrTable_506:NUM-COLUMNS + 2))
              whColPort_BrT_506          = whBrTable_506:ADD-CALC-COLUMN("CHAR", "x(6)", "", "Port", (whBrTable_506:NUM-COLUMNS + 3))
              whColTipoPgto_BrT_506      = whBrTable_506:ADD-CALC-COLUMN("CHAR", "x(10)", "", "Tipo Pagto", (whBrTable_506:NUM-COLUMNS + 4))
              whColTipoEntrega_BrT_506   = whBrTable_506:ADD-CALC-COLUMN("CHAR", "x(17)", "", "Sit.Pedido", (whBrTable_506:NUM-COLUMNS + 5)) 
              whColEmpenho_BrT_506       = whBrTable_506:Add-calc-column("Char", "x(12)", "", "Empenho", (whBrTable_506:NUM-COLUMNS + 6))
              whColPedTotvs_BrT_506      = whBrTable_506:Add-calc-column("Char", "x(9)", "", "PedTOTVS", (whBrTable_506:NUM-COLUMNS + 7))
              whColProcLicita_BrT_506    = whBrTable_506:Add-calc-column("Char", "x(30)", "", "Proc.Licitacao", (whBrTable_506:NUM-COLUMNS + 8))
              whColLicitacao_BrT_506     = whBrTable_506:Add-calc-column("Char", "x(17)", "", "Licitacao", (whBrTable_506:NUM-COLUMNS + 9))
              whColProcesso_BrT_506      = whBrTable_506:Add-calc-column("Char", "x(30)", "", "Processo", (whBrTable_506:NUM-COLUMNS + 10))
              whColVlTotPedido_Brt_506   = whBrTable_506:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pedido", (whBrtable_506:Num-Columns + 11))
              whColVlTotPendente_Brt_506 = whBrTable_506:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pendente", (whBrtable_506:Num-Columns + 12))
              whQryBrTable_506           = whBrTable_506:QUERY.
       ON "row-display" OF whBrTable_506 PERSISTENT RUN upc/upc_acr240aa-c.p.
   END. /* IF VALID-HANDLE(whBrTable) THEN DO: */
   IF VALID-HANDLE(whBrTable_un) THEN DO:
       ASSIGN whColUF_BrT_un            = whBrTable_un:ADD-CALC-COLUMN("CHAR", "x(2)", "", "UF", (whBrTable_un:NUM-COLUMNS + 1))
              whColCodRep_BrT_un        = whBrTable_un:ADD-CALC-COLUMN("INT", ">>>>>9", "", "Cod Rep", (whBrTable_un:NUM-COLUMNS + 2))
              whColPort_BrT_un          = whBrTable_un:ADD-CALC-COLUMN("CHAR", "x(6)", "", "Port", (whBrTable_un:NUM-COLUMNS + 3))
              whColTipoPgto_BrT_un      = whBrTable_un:ADD-CALC-COLUMN("CHAR", "x(10)", "", "Tipo Pagto", (whBrTable_un:NUM-COLUMNS + 4))
              whColTipoEntrega_BrT_un   = whBrTable_un:ADD-CALC-COLUMN("CHAR", "x(17)", "", "Sit.Pedido", (whBrTable_un:NUM-COLUMNS + 5)) 
              whColEmpenho_BrT_un       = whBrTable_un:Add-calc-column("Char", "x(12)", "", "Empenho", (whBrTable_un:NUM-COLUMNS + 6))
              whColPedTotvs_BrT_un      = whBrTable_un:Add-calc-column("Char", "x(9)", "", "PedTOTVS", (whBrTable_un:NUM-COLUMNS + 7))
              whColProcLicita_BrT_un    = whBrTable_un:Add-calc-column("Char", "x(30)", "", "Proc.Licitacao", (whBrTable_un:NUM-COLUMNS + 8))
              whColLicitacao_BrT_un     = whBrTable_un:Add-calc-column("Char", "x(17)", "", "Licitacao", (whBrTable_un:NUM-COLUMNS + 9))
              whColProcesso_BrT_un      = whBrTable_un:Add-calc-column("Char", "x(30)", "", "Processo", (whBrTable_un:NUM-COLUMNS + 10))
              whColVlTotPedido_Brt_un   = whBrTable_un:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pedido", (whBrtable_un:Num-Columns + 11))
              whColVlTotPendente_Brt_un = whBrTable_un:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pendente", (whBrtable_un:Num-Columns + 12))

              whQryBrTable_un  = whBrTable_un:QUERY.
       ON "row-display" OF whBrTable_un PERSISTENT RUN upc/upc_acr240aa-d.p.
   END. /* IF VALID-HANDLE(whBrTable) THEN DO: */
   IF VALID-HANDLE(whBrTable_un_506) THEN DO:
       ASSIGN whColUF_BrT_un_506            = whBrTable_un_506:ADD-CALC-COLUMN("CHAR", "x(2)", "", "UF", (whBrTable_un_506:NUM-COLUMNS + 1))
              whColCodRep_BrT_un_506        = whBrTable_un_506:ADD-CALC-COLUMN("INT", ">>>>>9", "", "Cod Rep", (whBrTable_un_506:NUM-COLUMNS + 2))
              whColPort_BrT_un_506          = whBrTable_un_506:ADD-CALC-COLUMN("CHAR", "x(6)", "", "Port", (whBrTable_un_506:NUM-COLUMNS + 3))
              whColTipoPgto_BrT_un_506      = whBrTable_un_506:ADD-CALC-COLUMN("CHAR", "x(10)", "", "Tipo Pagto", (whBrTable_un_506:NUM-COLUMNS + 4))
              whColTipoEntrega_BrT_un_506   = whBrTable_un_506:ADD-CALC-COLUMN("CHAR", "x(17)", "", "Sit.Pedido", (whBrTable_un_506:NUM-COLUMNS + 5)) 
              whColEmpenho_BrT_un_506       = whBrTable_un_506:Add-calc-column("Char", "x(12)", "", "Empenho", (whBrTable_un_506:NUM-COLUMNS + 6))
              whColPedTotvs_BrT_un_506      = whBrTable_un_506:Add-calc-column("Char", "x(9)", "", "PedTOTVS", (whBrTable_un_506:NUM-COLUMNS + 7))
              whColProcLicita_BrT_un_506    = whBrTable_un_506:Add-calc-column("Char", "x(30)", "", "Proc.Licitacao", (whBrTable_un_506:NUM-COLUMNS + 8))
              whColLicitacao_BrT_un_506     = whBrTable_un_506:Add-calc-column("Char", "x(17)", "", "Licitacao", (whBrTable_un_506:NUM-COLUMNS + 9))
              whColProcesso_BrT_un_506      = whBrTable_un_506:Add-calc-column("Char", "x(30)", "", "Processo", (whBrTable_un_506:NUM-COLUMNS + 10))
              whColVlTotPedido_Brt_un_506   = whBrTable_un_506:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pedido", (whBrtable_un_506:Num-Columns + 11))
              whColVlTotPendente_Brt_un_506 = whBrTable_un_506:ADD-CALC-COLUMN("Dec", "->>>,>>>,>>>,>>>.99", "", "Vl.Tot.Pendente", (whBrtable_un_506:Num-Columns + 12))

              whQryBrTable_un_506  = whBrTable_un_506:QUERY.
       ON "row-display" OF whBrTable_un_506 PERSISTENT RUN upc/upc_acr240aa-e.p.
   END. /* IF VALID-HANDLE(whBrTable) THEN DO: */

END.

RETURN 'OK':U.
