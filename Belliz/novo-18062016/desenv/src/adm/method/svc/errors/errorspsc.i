&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont�m a implementa��o para  Servi�o de Erros."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/errors/errorspsc.i
    Purpose    : Include que cont�m a implementa��o para  Servi�o de Erros

    Parameters :

    Author     :

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

&IF "{&SOErrors}":U <> "":U &THEN
    IF NOT VALID-HANDLE(hSOErrors) OR
       hSOErrors:TYPE <> "PROCEDURE":U OR
       hSOErrors:FILE-NAME <> "{&SOErrors}":U THEN DO:
        RUN {&SOErrors} PERSISTENT SET hSOErrors.
    END.

    RUN getMessagePSCInformation IN hSOErrors ( INPUT {&ErrorNumber},
                                                INPUT {&ErrorMessage},
                                               OUTPUT {&vErrorDescription},
                                               OUTPUT {&vErrorHelp}).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


