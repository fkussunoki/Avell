  /***************************************************************
**
** I-EPC004.I - EPC para Evento ENABLE de SmartViewer 
** 
***************************************************************/
/* alteraá∆o feita para atender ao WebEnabler - Marcilene Oliveira - 18/12/2003 */

&IF DEFINED(WEN-CONTROLLER) &THEN /* est† verificaá∆o se faz necess†ria devido aos programas */
   {include/i-wenreg.i}           /* criados pelos DataViewer n∆o utilizarem a include i-prgvrs */ 
&ENDIF                            /* e dessa forma n∆o chamarem a include i-wendef.i que define essa veri†vel. */ 

/* fim da alateraá∆o */

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
/* APPC */
if  c-nom-prog-appc-mg97 <> "" and
    c-nom-prog-appc-mg97 <> ? then do:                  
    run value(c-nom-prog-appc-mg97) (input "ENABLE":U, 
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
    run value(c-nom-prog-upc-mg97) (input "ENABLE":U, 
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
/* DPC */
if  c-nom-prog-dpc-mg97 <> "" and
    c-nom-prog-dpc-mg97 <> ? then do:                  
    run value(c-nom-prog-dpc-mg97) (input "ENABLE":U, 
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
/* I-EPC004.I */

