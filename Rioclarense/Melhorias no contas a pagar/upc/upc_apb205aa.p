/*******************************************************************************
**  Programa : upc_apb205aa.p
**  Objetivo : Implementar campos espec¡ficos na Consulta de T¡tulos em Aberto
**  Data     : 29/11/2017
**  Autor    : Leandro Okoti
*******************************************************************************/

DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID         NO-UNDO.

/*** Defini‡Æo de Vari veis Globais ***/
DEFINE NEW GLOBAL SHARED VAR whBrTable_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_apb205aa     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_apb205aa AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColCodEstab_apb205aa    As Widget-handle No-undo.
DEFINE New Global Shared Var WhColNumIdTitAp_apb205aa  As Widget-handle No-undo.
DEFINE New Global Shared Var WhColSituacao_apb205aa    As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_apb205aa     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_apb205aa         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_apb205aa    AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_corp_apb205aa           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_corp_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_corp_apb205aa    AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColCodEstab_corp_apb205aa       As Widget-handle No-undo.
DEFINE New Global Shared Var WhColNumIdTitAp_corp_apb205aa     As Widget-handle No-undo.
DEFINE New Global Shared Var WhColSituacao_corp_apb205aa       As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_corp_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_corp_apb205aa            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_corp_apb205aa       AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_un_apb205aa             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_un_apb205aa      AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColCodEstab_un_apb205aa         As Widget-handle No-undo.
DEFINE New Global Shared Var WhColNumIdTitAp_un_apb205aa       As Widget-handle No-undo.
DEFINE New Global Shared Var WhColSituacao_un_apb205aa         As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_un_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_un_apb205aa              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_un_apb205aa         AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_un_corp_apb205aa             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un_corp_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_un_corp_apb205aa      AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColCodEstab_un_corp_apb205aa         As Widget-handle No-undo.
DEFINE New Global Shared Var WhColNumIdTitAp_un_corp_apb205aa       As Widget-handle No-undo.
DEFINE New Global Shared Var WhColSituacao_un_corp_apb205aa         As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_un_corp_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_un_corp_apb205aa              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_un_corp_apb205aa         AS WIDGET-HANDLE NO-UNDO.






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
                    IF wh-objeto:NAME = "br_tit_ap_em_aberto"         THEN ASSIGN whBrTable_apb205aa         = wh-objeto.
                    IF wh-objeto:NAME = "br_tit_ap_em_aberto_corp"    THEN ASSIGN whBrTable_corp_apb205aa    = wh-objeto.
                    IF wh-objeto:NAME = "br_tit_ap_em_aberto_un"      THEN ASSIGN whBrTable_un_apb205aa      = wh-objeto.
                    IF wh-objeto:NAME = "br_tit_ap_em_aberto_un_corp" THEN ASSIGN whBrTable_un_corp_apb205aa = wh-objeto.
                END.
            END.
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING NO-ERROR.
        END.
        ASSIGN wh-frame = wh-frame:NEXT-SIBLING NO-ERROR.
    END.

    IF VALID-HANDLE(whBrTable_apb205aa) THEN DO:
        ASSIGN whColAutorizacao_apb205aa = whBrTable_apb205aa:ADD-CALC-COLUMN("CHAR", "x(40)", "", "Autoriza‡Æo")
               WhColSituacao_apb205aa    = whBrTable_apb205aa:add-calc-column("CHAR", "X(20)", "", "Situacao", 1)
               WhColBordero_apb205aa     = whBrTable_apb205aa:add-calc-column("Integer", "999999", "", "NumBord", 2)
               WhColDDA_apb205aa         = whBrTable_apb205aa:add-calc-column("Char", "x(4)", "", "C/Barras", 3)
               WhColPortador_apb205aa    = whBrTable_apb205aa:add-calc-column("Char", "x(8)", "", "Portador", 4)
               whQryBrTable_apb205aa     = whBrTable_apb205aa:QUERY.


        ON "row-display" OF whBrTable_apb205aa PERSISTENT RUN upc/upc_apb205aa-a.p(INPUT 1). /* "br_tit_ap_em_aberto"  */
    END. /* IF VALID-HANDLE(whBrTable_apb205aa) THEN DO: */

    IF VALID-HANDLE(whBrTable_corp_apb205aa) THEN DO:
        ASSIGN whColAutorizacao_corp_apb205aa      = whBrTable_corp_apb205aa:ADD-CALC-COLUMN("CHAR", "x(40)", "", "Autoriza‡Æo")
               WhColSituacao_corp_apb205aa         = whBrTable_corp_apb205aa:add-calc-column("CHAR", "X(20)", "", "Situacao", 1)
               WhColBordero_corp_apb205aa          = whBrTable_corp_apb205aa:add-calc-column("Integer", "999999", "", "NumBord", 2)
               WhColDDA_corp_apb205aa              = whBrTable_corp_apb205aa:add-calc-column("Char", "x(4)", "", "C/Barras", 3)
               WhColPortador_corp_apb205aa         = whBrTable_corp_apb205aa:add-calc-column("Char", "x(8)", "", "Portador", 4)
               whQryBrTable_corp_apb205aa     = whBrTable_corp_apb205aa:QUERY.
        ON "row-display" OF whBrTable_corp_apb205aa PERSISTENT RUN upc/upc_apb205aa-a.p(INPUT 2). /* "br_tit_ap_em_aberto_corp"  */
    END. /* IF VALID-HANDLE(whBrTable_corp_apb205aa) THEN DO: */




    IF VALID-HANDLE(whBrTable_un_apb205aa) THEN DO:
        ASSIGN whColAutorizacao_un_apb205aa      = whBrTable_un_apb205aa:ADD-CALC-COLUMN("CHAR", "x(40)", "", "Autoriza‡Æo")
               WhColSituacao_un_apb205aa         = whBrTable_un_apb205aa:add-calc-column("CHAR", "X(20)", "", "Situacao", 1)
               WhColBordero_un_apb205aa          = whBrTable_un_apb205aa:add-calc-column("Integer", "999999", "", "NumBord", 2)
               WhColDDA_un_apb205aa              = whBrTable_un_apb205aa:add-calc-column("Char", "x(4)", "", "C/Barras", 3)
               WhColPortador_un_apb205aa         = whBrTable_un_apb205aa:add-calc-column("Char", "x(8)", "", "Portador", 4)
               whQryBrTable_un_apb205aa     = whBrTable_un_apb205aa:QUERY.
        ON "row-display" OF whBrTable_un_apb205aa PERSISTENT RUN upc/upc_apb205aa-a.p(INPUT 3). /* "br_tit_ap_em_aberto_un" */
    END. /* IF VALID-HANDLE(whBrTable_un_apb205aa) THEN DO: */




    IF VALID-HANDLE(whBrTable_un_corp_apb205aa) THEN DO:
        ASSIGN whColAutorizacao_un_corp_apb205aa      = whBrTable_un_corp_apb205aa:ADD-CALC-COLUMN("CHAR", "x(40)", "", "Autoriza‡Æo")
               WhColSituacao_un_corp_apb205aa         = whBrTable_un_corp_apb205aa:add-calc-column("CHAR", "X(20)", "", "Situacao", 1)
               WhColBordero_un_corp_apb205aa          = whBrTable_un_corp_apb205aa:add-calc-column("Integer", "999999", "", "NumBord", 2)
               WhColDDA_un_corp_apb205aa              = whBrTable_un_corp_apb205aa:add-calc-column("Char", "x(4)", "", "C/Barras", 3)
               WhColPortador_un_corp_apb205aa         = whBrTable_un_corp_apb205aa:add-calc-column("Char", "x(8)", "", "Portador", 4)
               whQryBrTable_un_corp_apb205aa     = whBrTable_un_corp_apb205aa:QUERY.
        ON "row-display" OF whBrTable_un_corp_apb205aa PERSISTENT RUN upc/upc_apb205aa-a.p(INPUT 4). /* "br_tit_ap_em_aberto_un_corp" */
    END. /* IF VALID-HANDLE(whBrTable_un_corp_apb205aa) THEN DO: */
END.

RETURN 'OK':U.
