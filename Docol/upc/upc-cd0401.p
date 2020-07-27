def input parameter p-ind-event  as char          no-undo.
def input parameter p-ind-object as char          no-undo.
def input parameter p-wgh-object as handle        no-undo.
def input parameter p-wgh-frame  as widget-handle no-undo.
def input parameter p-cod-table  as char          no-undo.
def input parameter p-row-table  as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-email-cd0401   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

IF p-ind-event = "validate" THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",    /*** Type ***/
                  INPUT "e-mail",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-email-cd0401).      
        


    IF VALID-HANDLE(wh-email-cd0401) THEN DO:
    
        IF wh-email-cd0401:SCREEN-VALUE MATCHES "*@*"
        AND LENGTH(wh-email-cd0401:SCREEN-VALUE) > 5 THEN NEXT.
    
        ELSE DO:
          MESSAGE "Obrigatorio informar um email" VIEW-AS ALERT-BOX.
          APPLY 'entry':U TO wh-email-cd0401.
          RETURN 'nok'.
        END.
    
    END.  
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
