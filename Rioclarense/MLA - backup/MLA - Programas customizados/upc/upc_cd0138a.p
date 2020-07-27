

/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza»ao de documentos ************/

/* definicao de parametros */
Def Input Parameter p-ind-event         As Char             No-Undo.
Def Input Parameter p-ind-object        As Char             No-Undo.
Def Input Parameter p-wgh-object        As Handle           No-Undo.
Def Input Parameter p-wgh-frame         As Widget-Handle    No-Undo.
Def Input Parameter p-cod-table         As Char             No-Undo.
Def Input Parameter p-row-table         As Rowid            No-Undo.
DEFINE NEW global SHARED VAR wh-edi AS WIDGET-HANDLE.

  IF p-ind-event = "after-display" THEN DO:

 

/* message "EVENTO" p-ind-event skip                       */
/*         "OBJETO" p-ind-object skip                      */
/*         "FRAME" p-wgh-frame skip                        */
/*         "TABELA" p-cod-table skip                       */
/*         "ROWID" string(p-row-table) view-as alert-box.  */
        
CREATE BUTTON wh-edi
        
        

    ASSIGN FRAME = p-wgh-frame
           WIDTH = 04.00
           HEIGHT = 01.13
           LABEL = "Contas MLA"
           ROW = 01.08
           COL = 65.14
           FONT = ?
           VISIBLE = true
           SENSITIVE = true
        TRIGGERS:

    ON CHOOSE persistent RUN esp/cd0138a.w(INPUT p-row-table).

END TRIGGERS.
        wh-edi:TAB-STOP = YES.  
        wh-edi:LOAD-IMAGE-UP("image/im-f-ldo.bmp").
        wh-edi:LOAD-IMAGE("image/im-f-ldo.bmp").
        wh-edi:MOVE-TO-TOP().

