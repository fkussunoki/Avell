/***************************************************************
**
** i-epc036.i - EPC para Evento OPEN-QUERY de SmartBrowser
**
***************************************************************/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
if  valid-handle(widget-handle(c-container)) then do:
    
     /* DPC */
    run pi-retorna-dpc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-dpc-mg97 = return-value.
        if  c-nom-prog-dpc-mg97 <> "" then do:
            run value(c-nom-prog-dpc-mg97) (input "AFTER-OPEN-QUERY":U,
                                            input "BROWSER":U,
                                            input THIS-PROCEDURE,
                                            input frame {&FRAME-NAME}:handle,
                                            input "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}",
            &IF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) = 0 &THEN
                                            input ?).
            &ELSE
                                            input (if  avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) else ?)).
            &ENDIF
        end.
    end.
     /* APPC */
    run pi-retorna-appc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-appc-mg97 = return-value.
        if  c-nom-prog-appc-mg97 <> "" then do:
            run value(c-nom-prog-appc-mg97) (input "AFTER-OPEN-QUERY":U,
                                            input "BROWSER":U,
                                            input THIS-PROCEDURE,
                                            input frame {&FRAME-NAME}:handle,
                                            input "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}",
            &IF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) = 0 &THEN
                                            input ?).
            &ELSE
                                            input (if  avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) else ?)).
            &ENDIF
        end.
    end.
    
     /* UPC */
    run pi-retorna-upc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-upc-mg97 = return-value.
        if  c-nom-prog-upc-mg97 <> "" then do:
            run value(c-nom-prog-upc-mg97) (input "AFTER-OPEN-QUERY":U,
                                            input "BROWSER":U,
                                            input THIS-PROCEDURE,
                                            input frame {&FRAME-NAME}:handle,
                                            input "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}",
            &IF DEFINED(FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) = 0 &THEN
                                            input ?).
            &ELSE
                                            input (if  avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) else ?)).
            &ENDIF
        end.
    end.
end.
/* i-epc036.i */

