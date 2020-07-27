/*****************************************/
/*                                       */
/* DECODE - Descriptografa fontes.       */
/*                                       */
/*****************************************/
/***************************************************************
**
** I-EPC049.I - EPC para Evento BEFORE-ASSIGN de Container 
** 
***************************************************************/ 

/* DPC */
if  c-nom-prog-dpc-mg97 <> "" then do:                  
    run value(c-nom-prog-dpc-mg97) (input "BEFORE-ASSIGN", 
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
        return error.
end.

/* APPC */
if  c-nom-prog-appc-mg97 <> "" then do:                  
    run value(c-nom-prog-appc-mg97) (input "BEFORE-ASSIGN", 
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
        return error.
end.

/* UPC */
if  c-nom-prog-upc-mg97 <> "" then do:                  
    run value(c-nom-prog-upc-mg97) (input "BEFORE-ASSIGN", 
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
        return error.
end.

/* I-EPC049.I */
