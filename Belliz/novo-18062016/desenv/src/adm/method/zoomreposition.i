&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Executa programa de pesquisa, utilizado para fazer o reposicionamento de registro - atrav‚s do m‚todo repositionRecord."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/ZoomReposition.i
    Purpose    : Executa programa de pesquisa, utilizado para fazer o 
                 reposicionamento de registro - atrav‚s do m‚todo 
                 repositionRecord

    Parameters : 
        &ProgramZoom : nome do programa de pesquisa

    Authors    : John Cleber Jaraceski, Sergio Weber

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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

/*--- Executa programa de pesquisa ---*/
RUN {&ProgramZoom} PERSISTENT SET hProgramZoom.

IF VALID-HANDLE(hProgramZoom) THEN DO:
    /*--- Seta, no programa de pesquisa, os campos que devem ser retornados
          Neste caso ser  retornado o ROWID do registro selecionado ---*/
    RUN setFieldNamesHandles IN hProgramZoom (INPUT "ROWID":U, INPUT STRING(THIS-PROCEDURE)).

    /*--- Inicializa programa de pesquisa ---*/
    RUN initializeInterface IN hProgramZoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


