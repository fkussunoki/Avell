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
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
DEF NEW GLOBAL SHARED VAR c-cpf AS char NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-cpf AS LOGICAL NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-code AS recid.

DEFINE NEW GLOBAL SHARED VARIABLE whRecPedido AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whCPF       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whLabel     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whCorrente     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whOk     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_cta_fornec AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_sav        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_ok         AS WIDGET-HANDLE NO-UNDO.





/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").


IF p-ind-event  = 'initialize'   AND
   p-ind-object = 'viewer'       AND
   p-cod-table = 'fornec_financ'
THEN DO:


      RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "button",    /*** Type ***/
                INPUT "bt_cta_fornec",    /*** Name ***/
                INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                OUTPUT bt_cta_fornec).




END.


IF p-ind-event = "Display"     AND
   p-ind-object = "viewer"
THEN DO:

    CREATE BUTTON whCorrente



        ASSIGN FRAME = p-wgh-frame
               WIDTH = bt_cta_fornec:WIDTH 
               HEIGHT = bt_cta_fornec:HEIGHT
               LABEL = "Contas Correntes"
               ROW = bt_cta_fornec:ROW
               COL = bt_cta_fornec:COL
               FONT = ?
               VISIBLE = true
               SENSITIVE = TRUE
        TRIGGERS:
        on 'choose':U 
            persistent RUN esp/esrc713ea.w.

       END TRIGGERS.

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

