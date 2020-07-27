/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza¯ao de documentos ************/

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

DEF NEW GLOBAL SHARED VAR wh-ramo AS WIDGET-HANDLE NO-UNDO.
/*** Defini?’o de Variÿveis Globais ***/
Def New Global Shared Var wh-objeto       As Widget-Handle No-Undo.
Def New Global Shared Var wh-frame        As Widget-Handle No-Undo.
DEF NEW GLOBAL SHARED VAR wh-btImprimir   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whNumPedido     AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-edi AS WIDGET-HANDLE NO-UNDO.

/*** Defini?’o de Variÿveis Locais ***/
Def Var wgh-grupo As Widget-handle No-undo.
DEFINE VAR l-botao AS LOGICAL INITIAL NO.


/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").

IF  p-ind-event = "after-display"
AND p-ind-object = "container"
AND c-objeto     = "cc0300.w"
AND p-cod-table = "pedido-compr" THEN DO:


    CREATE BUTTON wh-ramo
        ASSIGN FRAME = p-wgh-frame
               WIDTH = 06.00
               HEIGHT = 02.00
               LABEL = "Executa"
               ROW = 02.90
               COL = 05.14
               FONT = ?
               VISIBLE = true
               SENSITIVE = true
            TRIGGERS:

        ON CHOOSE PERSISTENT RUN esp/esrcc0300.p(INPUT p-row-table).

    END TRIGGERS.
            wh-ramo:TAB-STOP = YES.  
            wh-ramo:LOAD-IMAGE-UP("image/im-mens.bmp").
            wh-ramo:LOAD-IMAGE("image/im-mens.bmp").
            wh-ramo:MOVE-TO-TOP().


     end.
	 
	 

IF p-ind-event = "AFTER-VALUE-CHANGED" AND
   p-cod-table = "ordem-compra" THEN DO: 
                                                       
    ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD             /* Pegando o Field-Group */
             wh-frame = wh-frame:FIRST-CHILD.             /* Pegando o 1o. Campo   */

    DO WHILE VALID-HANDLE(wh-frame):
        IF wh-frame:TYPE <> "FIELD-GROUP" THEN DO:
             IF wh-frame:NAME = "num-pedido" THEN ASSIGN whNumPedido = wh-frame.
             IF VALID-HANDLE(whNumPedido) THEN LEAVE.
             ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
        END.
        ELSE ASSIGN wh-frame = wh-frame:FIRST-CHILD.
    END.
END.


If p-ind-event = "AFTER-INITIALIZE"  Then Do:
   
    Assign wgh-grupo = p-wgh-frame:First-child.

    Do While Valid-handle(wgh-grupo):

        Assign wh-objeto = wgh-grupo:first-child. 
        
        Do While valid-handle(wh-objeto):
            IF wh-objeto:NAME = "btReportsJoins" THEN ASSIGN wh-btImprimir = wh-objeto.    
            IF VALID-HANDLE (wh-btImprimir) THEN LEAVE.
            Assign wh-objeto = wh-objeto:next-sibling no-error.
        END.

        On "choose" Of wh-btImprimir Persistent
            /*Run upc/upcc0300a.p.*/
            Run upc/upcc0300-r.w.

        Leave.
    END.

END.
	 
	
IF   (p-ind-event = "After-Value-Changed"
     OR   p-ind-event = "After-Open-Query")
     AND p-cod-table = "ordem-compra"
    
	 then do:


/* message "EVENTO" p-ind-event skip                       */
/*         "OBJETO" p-ind-object skip                      */
/*         "FRAME" p-wgh-frame skip                        */
/*         "TABELA" p-cod-table skip                       */
/*         "ROWID" string(p-row-table) view-as alert-box.  */
       
CREATE BUTTON wh-edi
        
        

    ASSIGN FRAME = p-wgh-frame
           WIDTH = 15.00
           HEIGHT = 01.00
           LABEL = "Anexa Docto"
           ROW = 13.18
           COL = 50
           FONT = ?
           VISIBLE = true
           SENSITIVE = true
        TRIGGERS:

    ON CHOOSE persistent RUN esp/escc0300.w(INPUT p-row-table).

END TRIGGERS.
        wh-edi:TAB-STOP = YES.  
/*         wh-edi:LOAD-IMAGE-UP("image/im-f-ldo.bmp"). */
/*         wh-edi:LOAD-IMAGE("image/im-f-ldo.bmp").    */
        wh-edi:MOVE-TO-TOP().

				
END.

	 
	 


