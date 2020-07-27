/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza»ao de documentos ************/

/* definicao de parametros */
Def Input Parameter p-ind-event         As Char             No-Undo.
Def Input Parameter p-ind-object        As Char             No-Undo.
Def Input Parameter p-wgh-object        As Handle           No-Undo.
Def Input Parameter p-wgh-frame         As Widget-Handle    No-Undo.
Def Input Parameter p-cod-table         As Char             No-Undo.
Def Input Parameter p-row-table         As Rowid            No-Undo.

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

/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").

    MESSAGE "Evento     " p-ind-event  SKIP         
            "Objeto     " p-ind-object SKIP         
            "nome obj   " c-objeto     SKIP         
            "Frame      " p-wgh-frame  SKIP         
            "Nome Frame " p-wgh-frame:NAME SKIP     
            "Tabela     " p-cod-table  SKIP         
            "ROWID      " STRING(p-row-table) SKIP  
            VIEW-AS ALERT-BOX INFORMATION.   
