  /***************************************************************
**
** I-EPC008.I - EPC para Evento Before ENABLE de Container
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
    run value(c-nom-prog-dpc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF
end.
/* APPC */
if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "BEFORE-ENABLE":U, 
                                     input "CONTAINER":U,
                                     input this-procedure,
                                     input frame f-relat:handle,
                                     input "",
                                     input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "BEFORE-ENABLE":U, 
                                     input "CONTAINER":U,
                                     input this-procedure,
                                     input frame f-import:handle,
                                     input "",
                                     input ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input "BEFORE-ENABLE":U, 
                                     input "CONTAINER":U,
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "",
                                     input ?).    
&ENDIF
end.                                       
/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input "BEFORE-ENABLE":U, 
                                    input "CONTAINER":U,
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF
end.                                       
/* I-EPC008 */

