&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m a implementa‡Æo para  Servi‡o de Seguran‡a (permissÆo de m‚todos)."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/svc/security/permit.i
    Purpose    : Include que cont‚m a implementa‡Æo para  Servi‡o de 
                 Seguran‡a (permissÆo de m‚todos)

    Parameters : 
        &Method  : nome do m‚todo, nÆo h  necessidade de ser igual ao nome 
                   da procedure

    Author     : John Cleber Jaraceski

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ****************************  Definitions  *************************** */

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
         HEIGHT             = 1.93
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF "{&SOSecurity}":U <> "":U &THEN
    RUN _canRunMethod IN THIS-PROCEDURE (INPUT "{&Method}":U).

    IF RETURN-VALUE = "NOK":U THEN DO:
        /*--- Erro 1: Usu rio sem permissÆo para executar o m‚todo {&Method} ---*/
        {method/svc/errors/inserr.i &ErrorNumber="1"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


