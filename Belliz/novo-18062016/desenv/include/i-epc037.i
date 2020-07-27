/***************************************************************
**
** include/i-epc037.i - EPC para Evento DELETE de SmartBrowser 
** 
***************************************************************/ 

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF

/* DPC */
IF c-nom-prog-dpc-mg97 <> "":U and
   c-nom-prog-dpc-mg97 <> ? THEN DO:
    RUN VALUE(c-nom-prog-dpc-mg97) (INPUT "DELETE":U,
                                    INPUT "BROWSER":U,
                                    INPUT THIS-PROCEDURE,
                                    INPUT FRAME {&FRAME-NAME}:HANDLE,
                                    INPUT "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}":U,
                                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                    INPUT ?).
                                    &ELSE
                                    INPUT (IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
                                           THEN ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
                                           ELSE ?)).
                                    &ENDIF
    
    IF RETURN-VALUE = "NOK":U THEN
       UNDO, RETURN "ADM-ERROR":U.
END.

/* APPC */
IF c-nom-prog-appc-mg97 <> "":U and
   c-nom-prog-appc-mg97 <> ? THEN DO:
    RUN VALUE(c-nom-prog-appc-mg97) (INPUT "DELETE":U,
                                     INPUT "BROWSER":U,
                                     INPUT THIS-PROCEDURE,
                                     INPUT FRAME {&FRAME-NAME}:HANDLE,
                                     INPUT "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}":U,
                                     &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                     INPUT ?).
                                     &ELSE
                                     INPUT (IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
                                            THEN ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
                                            ELSE ?)).
                                     &ENDIF
    
    IF RETURN-VALUE = "NOK":U THEN
        UNDO, RETURN "ADM-ERROR":U.
END.

/* UPC */
IF c-nom-prog-upc-mg97 <> "":U and
   c-nom-prog-upc-mg97 <> ? THEN DO:
    RUN VALUE(c-nom-prog-upc-mg97) (INPUT "DELETE":U,
                                    INPUT "BROWSER":U,
                                    INPUT THIS-PROCEDURE,
                                    INPUT FRAME {&FRAME-NAME}:HANDLE,
                                    INPUT "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}":U,
                                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                    INPUT ?).
                                    &ELSE
                                    INPUT (IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
                                           THEN ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
                                           ELSE ?)).
                                    &ENDIF
    
    IF RETURN-VALUE = "NOK":U THEN
        UNDO, RETURN "ADM-ERROR":U.
END.

/* include/i-epc038.i */
