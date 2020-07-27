  /***************************************************************
**
** i-epc015.i - EPC para Evento After DELETE de SmartViewer 
** 
***************************************************************/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
/* DPC */
if  c-nom-prog-dpc-mg97 <> "" and
    c-nom-prog-dpc-mg97 <> ? then do:
    run value(c-nom-prog-dpc-mg97) (input "AFTER-DELETE":U,
                                    input "VIEWER":U,
                                    input THIS-PROCEDURE,
                                    input frame {&FRAME-NAME}:HANDLE,
                                    input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                    input ?).
    &ELSE
                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).
    &ENDIF
    
    if RETURN-VALUE = "NOK":U then
       return error "ADM-ERROR":U.
end.
/* APPC */
if  c-nom-prog-appc-mg97 <> "" and
    c-nom-prog-appc-mg97 <> ? then do:
    run value(c-nom-prog-appc-mg97) (input "AFTER-DELETE":U,
                                     input "VIEWER":U,
                                     input THIS-PROCEDURE,
                                     input frame {&FRAME-NAME}:HANDLE,
                                     input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                     input ?).
    &ELSE
                                     input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).
    &ENDIF
    
    if RETURN-VALUE = "NOK":U then
       return error "ADM-ERROR":U.
end.
/* UPC */
if  c-nom-prog-upc-mg97 <> "" and
    c-nom-prog-upc-mg97 <> ? then do:
    run value(c-nom-prog-upc-mg97) (input "AFTER-DELETE":U,
                                    input "VIEWER":U,
                                    input THIS-PROCEDURE,
                                    input frame {&FRAME-NAME}:HANDLE,
                                    input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                    input ?).
    &ELSE
                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).
    &ENDIF
    
    if RETURN-VALUE = "NOK":U then
       return error "ADM-ERROR":U.
end.
/* i-epc015.i */
