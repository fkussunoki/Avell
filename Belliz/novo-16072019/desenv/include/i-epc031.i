  /***************************************************************
**
** I-EPC014.I - EPC para Evento After CHANGE-PAGE de Container 
** 
***************************************************************/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF
&IF DEFINED(PGIMP) <> 0  &THEN                                 
    
    &IF DEFINED(PAGINA-ATUAL) <> 0 &THEN
        &IF "{&PGSEL}" <> "" &THEN  
            if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-sel":U then do:
                 /* DPC */
                if  c-nom-prog-dpc-mg97 <> "" and
                    c-nom-prog-dpc-mg97 <> ? then do:                  
                    run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGSEL}:handle ,
                                                    input frame {&PGSEL}:handle,
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
                    run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                     input "CONTAINER":U,
                                                     input frame {&PGSEL}:handle ,
                                                     input frame {&PGSEL}:handle,
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
                    run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGSEL}:handle ,
                                                    input frame {&PGSEL}:handle,
                                                    input "{&FIRST-EXTERNAL-TABLE}",
                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN
                                                    input ?).
                    &ELSE
                                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                    &ENDIF                                 
                        
                end.
            end.  
        &ENDIF
         
        &IF "{&PGCLA}" <> "" &THEN  
            if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-cla":U  then do:
                 /* DPC */
                if  c-nom-prog-dpc-mg97 <> "" and
                    c-nom-prog-dpc-mg97 <> ? then do:                  
                    run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGCLA}:handle ,
                                                    input frame {&PGCLA}:handle,
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
                    run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                     input "CONTAINER":U,
                                                     input frame {&PGCLA}:handle ,
                                                     input frame {&PGCLA}:handle,
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
                    run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGCLA}:handle ,
                                                    input frame {&PGCLA}:handle,
                                                    input "{&FIRST-EXTERNAL-TABLE}",
                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                    input ?).
                    &ELSE
                                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                    &ENDIF                                 
                end.
            end.             
        &ENDIF    
        &IF "{&PGPAR}" <> "" &THEN  
            if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-par":U then do:
                 /* DPC */
                if  c-nom-prog-dpc-mg97 <> "" and
                    c-nom-prog-dpc-mg97 <> ? then do:                  
                    run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGPAR}:handle ,
                                                    input frame {&PGPAR}:handle,
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
                    run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                     input "CONTAINER":U,
                                                     input frame {&PGPAR}:handle ,
                                                     input frame {&PGPAR}:handle,
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
                    run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGPAR}:handle ,
                                                    input frame {&PGPAR}:handle,
                                                    input "{&FIRST-EXTERNAL-TABLE}",
                     &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                    input ?).
                     &ELSE
                                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                     &ENDIF                                 
                end.     
            end.           
        &ENDIF    
        &IF "{&PGDIG}" <> "" &THEN  
            if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-dig":U then do:
                 /* DPC */
                if  c-nom-prog-dpc-mg97 <> "" and
                    c-nom-prog-dpc-mg97 <> ? then do:                  
                    run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGDIG}:handle ,
                                                    input frame {&PGDIG}:handle,
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
                    run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                     input "CONTAINER":U,
                                                     input frame {&PGDIG}:handle ,
                                                     input frame {&PGDIG}:handle,
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
               
                    run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGDIG}:handle ,
                                                    input frame {&PGDIG}:handle,
                                                    input "{&FIRST-EXTERNAL-TABLE}",
                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                    input ?).
                    &ELSE
                                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                    &ENDIF                                 
                        
                end.
            end.  
        
        &ENDIF    
        &IF "{&PGIMP}" <> "" &THEN  
            if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-imp":U then do:
                 /* DPC */
                if  c-nom-prog-dpc-mg97 <> "" and
                    c-nom-prog-dpc-mg97 <> ? then do:                  
                    run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGIMP}:handle ,
                                                    input frame {&PGIMP}:handle,
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
                    run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                     input "CONTAINER":U,
                                                     input frame {&PGIMP}:handle ,
                                                     input frame {&PGIMP}:handle,
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
                    run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                    input "CONTAINER":U,
                                                    input frame {&PGIMP}:handle ,
                                                    input frame {&PGIMP}:handle,
                                                    input "{&FIRST-EXTERNAL-TABLE}",
                    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                    input ?).
                    &ELSE
                                                    input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                    &ENDIF                                 
                end.
            end.  
       &ENDIF     
    &ENDIF
    
&ELSE 
    &IF DEFINED(PGLOG) <> 0  &THEN                                 
        &IF DEFINED(PAGINA-ATUAL) <> 0 &THEN
            &IF "{&PGSEL}" <> "" &THEN  
                if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-sel":U then do:
                            /* DPC */
                    if  c-nom-prog-dpc-mg97 <> "" and
                        c-nom-prog-dpc-mg97 <> ? then do:                  
                        run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGSEL}:handle ,
                                                        input frame {&PGSEL}:handle,
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
                        run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                         input "CONTAINER":U,
                                                         input frame {&PGSEL}:handle ,
                                                         input frame {&PGSEL}:handle,
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
                        run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGSEL}:handle ,
                                                        input frame {&PGSEL}:handle,
                                                        input "{&FIRST-EXTERNAL-TABLE}",
                        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                        input ?).
                        &ELSE
                                                        input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                        &ENDIF                                 
                
                    end.
                end.  
            &ENDIF
            &IF "{&PGLOG}" <> "" &THEN  
                if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-cla":U then do:
                     /* DPC */
                    if  c-nom-prog-dpc-mg97 <> "" and
                        c-nom-prog-dpc-mg97 <> ? then do:                  
                        run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGLOG}:handle ,
                                                        input frame {&PGLOG}:handle,
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
                        run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                         input "CONTAINER":U,
                                                         input frame {&PGLOG}:handle ,
                                                         input frame {&PGLOG}:handle,
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
                        run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGLOG}:handle ,
                                                        input frame {&PGLOG}:handle,
                                                        input "{&FIRST-EXTERNAL-TABLE}",
                        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                        input ?).
                        &ELSE
                                                        input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                        &ENDIF                                 
                
                    end.
                end.             
            &ENDIF    
            &IF "{&PGPAR}" <> "" &THEN  
                if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-par":U then do:
                     /* DPC */
                    if  c-nom-prog-dpc-mg97 <> "" and
                        c-nom-prog-dpc-mg97 <> ? then do:                  
                        run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGPAR}:handle ,
                                                        input frame {&PGPAR}:handle,
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
                        run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                         input "CONTAINER":U,
                                                         input frame {&PGPAR}:handle ,
                                                         input frame {&PGPAR}:handle,
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
                        run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGPAR}:handle ,
                                                        input frame {&PGPAR}:handle,
                                                        input "{&FIRST-EXTERNAL-TABLE}",
                        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                        input ?).
                        &ELSE
                                                        input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                        &ENDIF                                 
                    end.     
                end.           
           &ENDIF   
           &IF "{&PGLAY}" <> "" &THEN  
               if  entry({&PAGINA-ATUAL},c-list-folders,",") = "im-pg-lay":U then do:
                    /* DPC */
                   if  c-nom-prog-dpc-mg97 <> "" and
                       c-nom-prog-dpc-mg97 <> ? then do:                  
                       run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                       input "CONTAINER":U,
                                                       input frame {&PGLAY}:handle ,
                                                       input frame {&PGLAY}:handle,
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
                       run value(c-nom-prog-appc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                        input "CONTAINER":U,
                                                        input frame {&PGLAY}:handle ,
                                                        input frame {&PGLAY}:handle,
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
                       run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                                       input "CONTAINER":U,
                                                       input frame {&PGLAY}:handle ,
                                                       input frame {&PGLAY}:handle,
                                                       input "{&FIRST-EXTERNAL-TABLE}",
                       &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                       input ?).
                       &ELSE
                                                       input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                       &ENDIF                                 
                   end.
               end.  
           &ENDIF       
        &ENDIF   
    &ELSE    
        run get-attribute('current-page':U). 
         /* DPC */
        if  c-nom-prog-dpc-mg97 <> "" and
            c-nom-prog-dpc-mg97 <> ? then do:                  
            run value(c-nom-prog-dpc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                            input "CONTAINER":U,
                                            input h-ctrl-tab,
                                            input frame {&FRAME-NAME}:handle  ,
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
            run value(c-nom-prog-appc-mg97)  (input "AFTER-CHANGE-PAGE":U, 
                                             input "CONTAINER":U,
                                             input h-ctrl-tab,
                                             input frame {&FRAME-NAME}:handle  ,
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
            run value(c-nom-prog-upc-mg97) (input "AFTER-CHANGE-PAGE":U, 
                                            input "CONTAINER":U,
                                            input h-ctrl-tab,
                                            input  frame {&FRAME-NAME}:handle,
                                            input "{&FIRST-EXTERNAL-TABLE}",
            &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                            input ?).
            &ELSE
                                            input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
            &ENDIF                                 
        end. 
    &ENDIF
&ENDIF    
/* I-EPC014.I */
