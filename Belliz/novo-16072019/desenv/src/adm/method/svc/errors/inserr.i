&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que insere erros na temp-table RowErrors."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/errors/inserr.i
    Purpose    : Include que insere erros na temp-table RowErrors

    Parameters : 
        &ErrorNumber      : n£mero do erro, nÆo h  necessidade de inform -lo 
                            quando o tipo do erro for PROGRESS
        &ErrorType        : tipo do erro, pode possuir os valores:
                            PROGRESS, INTERNAL ou OUTROS (indica uma descri‡Æo
                            do produto: HR ou EMS)
        &ErrorParameters  : parƒmetros para a mensagem de erro, utilizado 
                            quando o tipo do erro for OUTROS
        &ErrorSubType     : sub-tipo do erro, quando deseja-se incluir um error
                            manualmente, pode possuir os valores:
                            ERROR, INFORMATION ou WARNING
        &ErrorDescription : descri‡Æo do erro, pode ser informado quando 
                            deseja-se incluir um erro manualmente
        &ErrorHelp        : help do erro, pode ser informado quando deseja-se 
                            incluir um erro manualmente

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF "{&ErrorType}":U = "PROGRESS":U &THEN
    /*--- Tratamento para erros do tipo PROGRESS ---*/
    
    /*--- Executa m‚todo que inclui erros (_insertError) ---*/
    RUN _insertError IN THIS-PROCEDURE (INPUT 0,
                                        INPUT "PROGRESS":U,
                                        INPUT "{&ErrorSubType}":U,
                                        INPUT "":U).
&ELSEIF "{&ErrorType}":U = "INTERNAL":U &THEN
    /*--- Tratamento para erros do tipo INTERNAL ---*/
    
    /*--- Executa m‚todo que inclui erros (_insertError) ---*/
    RUN _insertError IN THIS-PROCEDURE (INPUT {&ErrorNumber},
                                        INPUT "INTERNAL":U,
                                        INPUT "{&ErrorSubType}":U,
                                        INPUT "":U).
&ELSE
    &IF "{&ErrorDescription}":U <> "":U &THEN
        /*--- Tratamento para erros manuais do tipo OUTROS ---*/
        
        /*--- Executa m‚todo que inclui erros manuais (_insertErrorManual) ---*/
        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT {&ErrorNumber},
                                                  INPUT "{&ErrorType}":U,
                                                  INPUT "{&ErrorSubType}":U,
                                                  INPUT "{&ErrorDescription}",
                                                  INPUT "{&ErrorHelp}",
        &IF "{&ErrorParameters}":U <> "":U &THEN
                                                  INPUT {&ErrorParameters}).
        &ELSE
                                                  INPUT "":U).
        &ENDIF
    &ELSE
        /*--- Tratamento para erros do tipo OUTROS ---*/

        /*--- Executa m‚todo que inclui erros do tipo OUTROS (_insertError) ---*/
        RUN _insertError IN THIS-PROCEDURE (INPUT {&ErrorNumber},
                                            INPUT "{&ErrorType}":U,
                                            INPUT ?,
        &IF "{&ErrorParameters}":U <> "":U &THEN
                                            INPUT {&ErrorParameters}).
        &ELSE
                                            INPUT "":U).
        &ENDIF
    &ENDIF
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


