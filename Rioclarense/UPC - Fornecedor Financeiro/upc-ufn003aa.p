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

DEFINE NEW GLOBAL SHARED VARIABLE whRecPedido AS WIDGET-HANDLE NO-UNDO.

/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").


IF p-ind-event  = 'display'   AND
   p-ind-object = 'viewer'       
THEN DO:

    CREATE TOGGLE-BOX whRecPedido
       ASSIGN FRAME         = p-wgh-frame
              LABEL         = "RE1001 s/ pedido"
              ROW           = 06.04       /*whOrgaoEstadual:ROW + 1*/
              COL           = 30.00 /*whOrgaoEstadual:COLUMNS*/
              CHECKED       = FALSE
              VISIBLE       = YES
              SENSITIVE     = NO
              TOOLTIP       = "Fornecedores que nao tramitam pelo RE1001"
              HELP          = "Fornecedores que nao tramitam pelo RE1001".



    FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ) = p-row-table NO-ERROR.

    ASSIGN whRecPedido:SCREEN-VALUE  = SUBSTRING(fornec_financ.cod_livre_2, 97, 100).

END.


