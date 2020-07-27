  /***************************************************************
**
** I-EPC001.I - EPC para Evento INITIALIZE de SmartViewer 
** 
***************************************************************/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
if  valid-handle(widget-handle(c-container)) then do:
     /* APPC */
    run pi-retorna-appc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-appc-mg97 = return-value.
        run value(c-nom-prog-appc-mg97) (input "INITIALIZE":U, 
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
    else
        assign c-nom-prog-appc-mg97 = "".             
     /* UPC */
    run pi-retorna-upc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-upc-mg97 = return-value.
        run value(c-nom-prog-upc-mg97) (input "INITIALIZE":U, 
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
    else
        assign c-nom-prog-upc-mg97 = "".             
       /* DPC */
    run pi-retorna-dpc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-dpc-mg97 = return-value.
        run value(c-nom-prog-dpc-mg97) (input "INITIALIZE":U, 
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
    else
        assign c-nom-prog-dpc-mg97 = "".      
end.
/* I-EPC001.I */

