/*******************************************************************************
**  Cliente  : RioClarense
**  Sistema  : EMS - 5.06
**  Programa : upc_acr212aa.p
**  Objetivo : Implementar campos espec¡ficos na Consulta de T¡tulos/Movimentos
**  Data     : 04/2017
**  Autor    : Joao Tagliatti - Consultor / Desenvolvedor
**  Versao   : 5.06.000
*******************************************************************************/

DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID         NO-UNDO.


/*** Defini‡Æo de Vari veis Locais ***/
DEFINE VARIABLE wh-objeto          AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-frame           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-botao           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE v-recid            AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_fornec_financ AS RECID NO-UNDO.


IF p-ind-event = "INITIALIZE" 
AND p-ind-object = "VIEWER" THEN DO:
    




CREATE BUTTON wh-botao
        
        

    ASSIGN FRAME = p-wgh-frame
           WIDTH = 04.00
           HEIGHT = 01.13
           LABEL = "Executa"
           ROW = 01.08
           COL = 58.14
           FONT = ?
           VISIBLE = true
           SENSITIVE = true
        TRIGGERS:
    
    ON CHOOSE PERSISTENT RUN esp/esrc713.w.

END TRIGGERS.
        wh-botao:TAB-STOP = YES.  
        wh-botao:LOAD-IMAGE-UP("image/im-autom.bmp").
        wh-botao:LOAD-IMAGE("image/im-autom.bmp").
        wh-botao:MOVE-TO-TOP().
        wh-botao:TOOLTIP = "Replica Impostos retidos".

END.

IF p-ind-event = "display"
AND p-ind-object = "viewer" THEN DO:

    ASSIGN v_rec_fornec_financ = p-rec-table.

END.
