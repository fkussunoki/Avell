/*****************************************/
/*                                       */
/* DECODE - Descriptografa fontes.       */
/*                                       */
/*****************************************/
/******************************************************************
**
** I-EPC039.I - EPC para Evento DISPLAY de Container
** 
*******************************************************************/ 

/* DPC */
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:

&IF DEFINED(TT-TABLE) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97)  (input "DISPLAY", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&BO-TABLE}",
                                     input if  avail {&ttTable} then {&ttTable}.rRowid else ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input "DISPLAY", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.

/* APPC */
if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(TT-TABLE) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "DISPLAY", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&BO-TABLE}",
                                     input if  avail {&ttTable} then {&ttTable}.rRowid else ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input "DISPLAY", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "",
                                     input ?).    
&ENDIF

end.                                       

/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

&IF DEFINED(TT-TABLE) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97)  (input "DISPLAY", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "{&BO-TABLE}",
                                     input if  avail {&ttTable} then {&ttTable}.rRowid else ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input "DISPLAY", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.                                       

/* I-EPC040.I */

