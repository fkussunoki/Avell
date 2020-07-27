
&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

    /* Tenta identificar pelo ADM-CONTAINER */
    &IF DEFINED(ADM-CONTAINER) &THEN
    
        &IF "{&ADM-CONTAINER}" = "Window" &THEN

            &GLOBAL-DEFINE WenIsWindow YES
        &ELSEIF "{&ADM-CONTAINER}" = "Dialog-Box" &THEN

            &GLOBAL-DEFINE WenIsDialog YES
        &ENDIF
        
    &ENDIF

    /* Se ainda n’o identificou se ² window ou dialog (Os ifs s’o feitos assim para n’o dar erro de sintaxe) */
    &IF DEFINED(WenIsWindow) &THEN
    &ELSE
    &IF DEFINED(WenIsDialog) &THEN
    &ELSE
        /* Tenta identificar pelo PROCEDURE-TYPE */
        &IF DEFINED(PROCEDURE-TYPE) &THEN
        
            &IF "{&PROCEDURE-TYPE}" = "Dialog-Box" OR
                "{&PROCEDURE-TYPE}" = "SmartVaPara" &THEN

                &GLOBAL-DEFINE WenIsDialog YES
                
            &ELSEIF "{&PROCEDURE-TYPE}" = "Window" OR
                "{&PROCEDURE-TYPE}" = "Zoom" OR
                "{&PROCEDURE-TYPE}" BEGINS "w-" &THEN

                &GLOBAL-DEFINE WenIsWindow YES
                
            &ENDIF
            
        &ENDIF
    &ENDIF    
    &ENDIF

    /* Se ainda n’o identificou se ² window ou dialog (Os ifs s’o feitos assim para n’o dar erro de sintaxe) */
    &IF DEFINED(WenIsWindow) &THEN
    &ELSE
    &IF DEFINED(WenIsDialog) &THEN
    &ELSE
        /* Tenta identificar pelo WINDOW-NAME */
        &IF DEFINED(WINDOW-NAME) &THEN
        
            &IF "{&WINDOW-NAME}" <> "CURRENT-WINDOW" &THEN

                &GLOBAL-DEFINE WenIsWindow YES
            &ENDIF
            
        &ENDIF
        
        &IF "{&FRAME-NAME}" BEGINS "f_dlg" &THEN

            &GLOBAL-DEFINE WenIsDialog YES
        &ENDIF

    &ENDIF
    &ENDIF
    
    /*
    &IF DEFINED(WenIsWindow) &THEN
        RUN registerWindow IN hWenController (THIS-PROCEDURE, CURRENT-WINDOW).
    &ELSEIF DEFINED(WenIsDialog) &THEN
        RUN registerWindow IN hWenController (THIS-PROCEDURE, CURRENT-WINDOW).
    &ENDIF
    */

    /* Se tem janela */
    &IF DEFINED(WenIsWindow) &THEN

        ON 'U9':U ANYWHERE
        DO:
            IF VALID-HANDLE(hWenController) THEN DO:
                RUN registerWindow IN hWenController (THIS-PROCEDURE, SELF).
            END.
        END.

    &ENDIF

    /* Se tem dialog */
    &IF DEFINED(WenIsDialog) &THEN

        ON 'U10':U ANYWHERE
        DO:
            IF VALID-HANDLE(hWenController) THEN DO:
                RUN registerWindow IN hWenController (THIS-PROCEDURE, SELF).
            END.
        END.

    &ENDIF

&ENDIF
