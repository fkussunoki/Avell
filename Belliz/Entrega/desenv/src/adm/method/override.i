&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Executar m�todos sobrepostos (Before/After)."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/svc/override/override.i
    Purpose    : Executar m�todos sobrepostos (before/after)

    Parameters : 
        &Position   : indica a posi��o de execu��o, os valores aceitos s�o 
                      "Before" e "After"
        &Procedure  : nome gen�rico da procedure, ser� concatenado com o 
                      par�metro &Position
        &Parameters : par�metros a serem transferidos

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/*--- Executa m�todos sobrepostos (before/after) ---*/
IF THIS-PROCEDURE:GET-SIGNATURE("{&Position}{&Procedure}":U) <> "":U THEN DO:
    &IF "{&Parameters}":U <> "":U &THEN
        RUN {&Position}{&Procedure} IN THIS-PROCEDURE ({&Parameters}) NO-ERROR.
    &ELSE
        RUN {&Position}{&Procedure} IN THIS-PROCEDURE NO-ERROR.
    &ENDIF

    ASSIGN lOverrideExecuted = YES.
END.
ELSE
    ASSIGN lOverrideExecuted = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


