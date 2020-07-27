&IF DEFINED(EXCLUDE-default-enter-action) = 0 &THEN

DEFINE VARIABLE c_Aux-var AS CHARACTER NO-UNDO.

ON GO OF FRAME {&FRAME-NAME} OR ENTER OF FRAME {&FRAME-NAME} ANYWHERE DO:
    IF SELF:TYPE <> "editor":U OR 
       (SELF:TYPE = "editor":U AND KEYFUNCTION(LASTKEY) <> "RETURN":U) THEN DO:
        
        IF "{&ENABLED-FIELDS}":U <> "":U THEN DO:
            APPLY "LEAVE":U TO SELF.
            
            RUN get-link-handle IN adm-broker-hdl ( INPUT THIS-PROCEDURE,
                                                    INPUT "CONTAINER-SOURCE":U,
                                                   OUTPUT c_Aux-var).
            
            RUN pi-enter-go IN WIDGET-HANDLE(c_Aux-var) NO-ERROR.
            
            RETURN NO-APPLY.
        END.
    END.
    ELSE
        SELF:INSERT-STRING(CHR(10)).
END.

&ENDIF
