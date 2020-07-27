  /***************************************************************
**
** I-EPC013.I - EPC para Evento After CANCEL de SmartViewer 
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
    run value(c-nom-prog-dpc-mg97) (input "AFTER-CANCEL":U, 
                                    input "VIEWER":U,
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
    &ENDIF                                 
end.
/* APPC */
if  c-nom-prog-appc-mg97 <> "" and
    c-nom-prog-appc-mg97 <> ? then do:                  
    run value(c-nom-prog-appc-mg97) (input "AFTER-CANCEL":U, 
                                     input "VIEWER":U,
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                     input ?).
    &ELSE
                                     input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
    &ENDIF                                 
end.
/* UPC */
if  c-nom-prog-upc-mg97 <> "" and
    c-nom-prog-upc-mg97 <> ? then do:                  
    run value(c-nom-prog-upc-mg97) (input "AFTER-CANCEL":U, 
                                    input "VIEWER":U,
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
    &ENDIF                                 
end.
/* I-EPC013.I */

