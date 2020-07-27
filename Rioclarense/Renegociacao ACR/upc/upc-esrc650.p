
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as recid         no-undo.

DEF NEW GLOBAL SHARED VAR wh-edi AS WIDGET-HANDLE NO-UNDO.
def new global shared var num as recid no-undo.
def new global shared var num_bord as recid no-undo.

IF p-ind-event = "display" THEN DO:

assign num = recid(bord_ap).
        
CREATE BUTTON wh-edi
        
        

    ASSIGN FRAME = p-wgh-frame
           WIDTH = 04.00
           HEIGHT = 01.13
           LABEL = "Executa"
           ROW = 01.08
           COL = 55.14
           FONT = ?
           VISIBLE = true
           SENSITIVE = true
        TRIGGERS:

    ON CHOOSE PERSISTENT RUN ESP/esrc650.p(input p-row-table).

END TRIGGERS.
        wh-edi:TAB-STOP = YES.  
        wh-edi:LOAD-IMAGE-UP("image/ii-lista.ico").
        wh-edi:LOAD-IMAGE("image/ii-lista.ico").
        wh-edi:MOVE-TO-TOP().

				
END.


