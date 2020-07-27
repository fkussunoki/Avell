
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID         NO-UNDO.

DEF VAR v_nom_filename_import AS WIDGET-HANDLE.
DEF VAR wh-ramo AS WIDGET-HANDLE.
DEF VAR bt_teste AS WIDGET-HANDLE.

IF p-ind-event = "enable" THEN DO:


    
        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "editor",    /*** Type ***/
                  INPUT "v_nom_filename_import",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT v_nom_filename_import).


        CREATE BUTTON wh-ramo



            ASSIGN FRAME = p-wgh-frame
                   WIDTH = 04.00
                   HEIGHT = 01.1
                   LABEL = "Executa"
                   ROW = 03.50
                   COL = 56
                   FONT = ?
                   VISIBLE = true
                   SENSITIVE = true
                TRIGGERS:

            ON CHOOSE PERSISTENT RUN esp/esrc779ab.p(INPUT v_nom_filename_import).

        END TRIGGERS.
                wh-ramo:TAB-STOP = YES.  
                wh-ramo:LOAD-IMAGE-UP("image/im-sea2").
                wh-ramo:LOAD-IMAGE("image/im-sea2").
                wh-ramo:MOVE-TO-TOP().




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

