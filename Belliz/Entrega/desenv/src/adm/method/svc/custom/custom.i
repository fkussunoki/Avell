&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m a implementa‡Æo para Servi‡o de Customiza‡Æo."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/svc/custom/custom.i
    Purpose    : Include que cont‚m a implementa‡Æo para Servi‡o de 
                 Customiza‡Æo

    Parameters : 
        &Event : nome do evento

    Author     :

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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF "{&SOCustom}":U <> "":U &THEN
    IF NOT VALID-HANDLE(hSOCustom) OR
       hSOCustom:FILE-NAME <> "{&SOCustom}":U THEN
        RUN {&SOCustom} PERSISTENT SET hSOCustom.
    
    RUN publish IN hSOCustom (INPUT "{&Event}":U, 
                              INPUT THIS-PROCEDURE:HANDLE).
    
    ASSIGN lCustomExecuted = YES.
&ELSE
    ASSIGN lCustomExecuted = NO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


