/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza¯ao de documentos ************/

/* definicao de parametros */
Def Input Parameter p-ind-event         As Char             No-Undo.
Def Input Parameter p-ind-object        As Char             No-Undo.
Def Input Parameter p-wgh-object        As Handle           No-Undo.
Def Input Parameter p-wgh-frame         As Widget-Handle    No-Undo.
Def Input Parameter p-cod-table         As Char             No-Undo.
Def Input Parameter p-row-table         As Recid            No-Undo.

/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.

DEFINE NEW GLOBAL SHARED VARIABLE whInf     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whOk     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_vinc_inf_banc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_fornec_financ AS RECID NO-UNDO.





/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").


IF p-ind-event  = 'display'   AND
   p-ind-object = 'viewer'       
THEN DO:

    
    FIND FIRST item_bord_ap NO-LOCK WHERE RECID(item_bord_ap) = p-row-table NO-ERROR.
    FIND FIRST fornec_financ NO-LOCK WHERE fornec_financ.cdn_fornecedor = item_bord_ap.cdn_fornecedor NO-ERROR.

    ASSIGN v_rec_fornec_financ = recid(fornec_financ).



      RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "button",    /*** Type ***/
                INPUT "bt_vinc_inf_banc",    /*** Name ***/
                INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                OUTPUT bt_vinc_inf_banc).


        CREATE BUTTON whInf



            ASSIGN FRAME = p-wgh-frame
                   WIDTH = bt_vinc_inf_banc:WIDTH 
                   HEIGHT = bt_vinc_inf_banc:HEIGHT
                   ROW = bt_vinc_inf_banc:ROW
                   COL = bt_vinc_inf_banc:COL
                   FONT = ?
                   VISIBLE = true
                   SENSITIVE = TRUE
            TRIGGERS:
            on 'choose':U 
                PERSISTENT RUN esp/esrc713.w.

           END TRIGGERS.
           whInf:LOAD-IMAGE-UP('image/im-calc.bmp').
           whInf:MOVE-TO-TOP().




END.




PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):             
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    RETURN "OK".
END PROCEDURE.


