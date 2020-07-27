/*****************************************/
/*                                       */
/* DECODE - Descriptografa fontes.       */
/*                                       */
/*****************************************/
/***************************************************************
**
** I-EPC052.I - EPC para Evento AFTER-DELETE de Container 
** 
***************************************************************/ 

/* DPC */
if  c-nom-prog-dpc-mg97 <> "" then do:                  
    run value(c-nom-prog-dpc-mg97) (input "AFTER-DELETE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 
   
end.

/* APPC */
if  c-nom-prog-appc-mg97 <> "" then do:                  
    run value(c-nom-prog-appc-mg97) (input "AFTER-DELETE", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                     input ?).
    &ELSE
                                     input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 

end.

/* UPC */
if  c-nom-prog-upc-mg97 <> "" then do:                  
    run value(c-nom-prog-upc-mg97) (input "AFTER-DELETE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 

end.

/* I-EPC052.I */
