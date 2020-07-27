/*****************************************/
/*                                       */
/* DECODE - Descriptografa fontes.       */
/*                                       */
/*****************************************/
/***************************************************************
**
** I-EPC051.I - EPC para Evento DELETE de Container 
** 
***************************************************************/ 

/* DPC */
if  c-nom-prog-dpc-mg97 <> "" then do:                  
    run value(c-nom-prog-dpc-mg97) (input "DELETE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 
   
    if  return-value = "NOK" then
        return no-apply.
end.

/* APPC */
if  c-nom-prog-appc-mg97 <> "" then do:                  
    run value(c-nom-prog-appc-mg97) (input "DELETE", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                     input ?).
    &ELSE
                                     input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 

    if  return-value = "NOK" then
        return no-apply.
end.

/* UPC */
if  c-nom-prog-upc-mg97 <> "" then do:                  
    run value(c-nom-prog-upc-mg97) (input "DELETE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&ttTable}",
    &IF DEFINED(TT-TABLE) = 0 &THEN                                 
                                    input ?).
    &ELSE
                                    input (if  avail {&ttTable} then {&ttTable}.rRowid else ?)).    
    &ENDIF                                 

    if  return-value = "NOK" then
        return no-apply.
end.

/* I-EPC051.I */
