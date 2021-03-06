  /***************************************************************
**
** I-EPC007.I - EPC para Evento AFTER-TIMEOUT de TIMEOUT
** 
***************************************************************/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
/* DPC */
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input ?,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input ?,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input ?,
                                    input "",
                                    input ?).    
&ENDIF
end.
/* APPC */
if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "AFTER-TIMEOUT":U, 
                                     input "TIMEOUT":U,
                                     input this-procedure,
                                     input frame f-relat:handle,
                                     input "",
                                     input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "AFTER-TIMEOUT":U, 
                                     input "TIMEOUT":U,
                                     input this-procedure,
                                     input ?,
                                     input "",
                                     input ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input "AFTER-TIMEOUT":U, 
                                     input "TIMEOUT":U,
                                     input this-procedure,
                                     input ?,
                                     input "",
                                     input ?).    
&ENDIF
end.                                       
/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input ?,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input "AFTER-TIMEOUT":U, 
                                    input "TIMEOUT":U,
                                    input this-procedure,
                                    input ?,
                                    input "",
                                    input ?).    
&ENDIF
end.                                       
/* I-EPC007.I */

