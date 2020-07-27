&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Executa programa de pesquisa, utilizado para retornar os valores de campos."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/ZoomFields.i
    Purpose    : Executa programa de pesquisa, utilizado para retornar os 
                 valores de campos

    Parameters : 
        &ProgramZoom   : nome do programa de pesquisa

        &FieldZoom1    : nome do campo a ser retornado
        &FieldScreen1  : nome do campo onde ser  incluso o valor retornado
        &Frame1        : nome da frame onde est  o campo {&FieldScreen1}
        &Browse1       : nome do browse onde est  o campo {&FieldScreen1}
        &FieldHandle1  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom2    : nome do campo a ser retornado
        &FieldScreen2  : nome do campo onde ser  incluso o valor retornado
        &Frame2        : nome da frame onde est  o campo {&FieldScreen2}
        &Browse2       : nome do browse onde est  o campo {&FieldScreen2}
        &FieldHandle2  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom3    : nome do campo a ser retornado
        &FieldScreen3  : nome do campo onde ser  incluso o valor retornado
        &Frame3        : nome da frame onde est  o campo {&FieldScreen3}
        &Browse3       : nome do browse onde est  o campo {&FieldScreen3}
        &FieldHandle3  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom4    : nome do campo a ser retornado
        &FieldScreen4  : nome do campo onde ser  incluso o valor retornado
        &Frame4        : nome da frame onde est  o campo {&FieldScreen4}
        &Browse4       : nome do browse onde est  o campo {&FieldScreen4}
        &FieldHandle4  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom5    : nome do campo a ser retornado
        &FieldScreen5  : nome do campo onde ser  incluso o valor retornado
        &Frame5        : nome da frame onde est  o campo {&FieldScreen5}
        &Browse5       : nome do browse onde est  o campo {&FieldScreen5}
        &FieldHandle5  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom6    : nome do campo a ser retornado
        &FieldScreen6  : nome do campo onde ser  incluso o valor retornado
        &Frame6        : nome da frame onde est  o campo {&FieldScreen6}
        &Browse6       : nome do browse onde est  o campo {&FieldScreen6}
        &FieldHandle6  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom7    : nome do campo a ser retornado
        &FieldScreen7  : nome do campo onde ser  incluso o valor retornado
        &Frame7        : nome da frame onde est  o campo {&FieldScreen7}
        &Browse7       : nome do browse onde est  o campo {&FieldScreen7}
        &FieldHandle7  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom8    : nome do campo a ser retornado
        &FieldScreen8  : nome do campo onde ser  incluso o valor retornado
        &Frame8        : nome da frame onde est  o campo {&FieldScreen8}
        &Browse8       : nome do browse onde est  o campo {&FieldScreen8}
        &FieldHandle8  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom9    : nome do campo a ser retornado
        &FieldScreen9  : nome do campo onde ser  incluso o valor retornado
        &Frame9        : nome da frame onde est  o campo {&FieldScreen9}
        &Browse9       : nome do browse onde est  o campo {&FieldScreen9}
        &FieldHandle9  : handle do campo onde ser  incluso o valor retornado

        &FieldZoom10   : nome do campo a ser retornado
        &FieldScreen10 : nome do campo onde ser  incluso o valor retornado
        &Frame10       : nome da frame onde est  o campo {&FieldScreen10}
        &Browse10      : nome do browse onde est  o campo {&FieldScreen10}
        &FieldHandle10 : handle do campo onde ser  incluso o valor retornado

        &RunMethod     : linha de comando, que cont‚m chamada a um m‚todo
                         do programa de pesquisa
                         a vari vel hProgramZoom cont‚m o handle do programa
                         de pesquisa
        &EnableImplant : indica se o botÆo Implantar ser  habilitado

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/*--- Cria preprocessador {&FieldNames} com os nomes dos campos a serem retornados
      pelo programa de pesquisa ---*/
&SCOPED-DEFINE FieldNames {&FieldZoom1}

&IF "{&FieldZoom2}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom2}
&ENDIF

&IF "{&FieldZoom3}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom3}
&ENDIF

&IF "{&FieldZoom4}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom4}
&ENDIF

&IF "{&FieldZoom5}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom5}
&ENDIF

&IF "{&FieldZoom6}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom6}
&ENDIF

&IF "{&FieldZoom7}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom7}
&ENDIF

&IF "{&FieldZoom8}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom8}
&ENDIF

&IF "{&FieldZoom9}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom9}
&ENDIF

&IF "{&FieldZoom10}":U <> "":U &THEN
    &SCOPED-DEFINE FieldNames {&FieldNames},{&FieldZoom10}
&ENDIF

/*--- Cria preprocessador {&FieldHandles} com os handles dos campos a serem retornados
      pelo programa de pesquisa ---*/
&IF "{&FieldScreen1}":U <> "":U &THEN
    &IF "{&Frame1}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles STRING({&FieldScreen1}:HANDLE IN FRAME {&Frame1})
    &ELSE
        &SCOPED-DEFINE FieldHandles STRING({&FieldScreen1}:HANDLE IN BROWSE {&Browse1})
    &ENDIF
&ELSEIF "{&FieldHandle1}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles STRING({&FieldHandle1})
&ENDIF

&IF "{&FieldScreen2}":U <> "":U &THEN
    &IF "{&Frame2}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen2}:HANDLE IN FRAME {&Frame2})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen2}:HANDLE IN BROWSE {&Browse2})
    &ENDIF
&ELSEIF "{&FieldHandle2}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle2})
&ENDIF

&IF "{&FieldScreen3}":U <> "":U &THEN
    &IF "{&Frame3}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen3}:HANDLE IN FRAME {&Frame3})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen3}:HANDLE IN BROWSE {&Browse3})
    &ENDIF
&ELSEIF "{&FieldHandle3}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle3})
&ENDIF

&IF "{&FieldScreen4}":U <> "":U &THEN
    &IF "{&Frame4}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen4}:HANDLE IN FRAME {&Frame4})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen4}:HANDLE IN BROWSE {&Browse4})
    &ENDIF
&ELSEIF "{&FieldHandle4}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle4})
&ENDIF

&IF "{&FieldScreen5}":U <> "":U &THEN
    &IF "{&Frame5}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen5}:HANDLE IN FRAME {&Frame5})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen5}:HANDLE IN BROWSE {&Browse5})
    &ENDIF
&ELSEIF "{&FieldHandle5}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle5})
&ENDIF

&IF "{&FieldScreen6}":U <> "":U &THEN
    &IF "{&Frame6}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen6}:HANDLE IN FRAME {&Frame6})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen6}:HANDLE IN BROWSE {&Browse6})
    &ENDIF
&ELSEIF "{&FieldHandle6}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle6})
&ENDIF

&IF "{&FieldScreen7}":U <> "":U &THEN
    &IF "{&Frame7}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen7}:HANDLE IN FRAME {&Frame7})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen7}:HANDLE IN BROWSE {&Browse7})
    &ENDIF
&ELSEIF "{&FieldHandle7}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle7})
&ENDIF

&IF "{&FieldScreen8}":U <> "":U &THEN
    &IF "{&Frame8}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen8}:HANDLE IN FRAME {&Frame8})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen8}:HANDLE IN BROWSE {&Browse8})
    &ENDIF
&ELSEIF "{&FieldHandle8}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle8})
&ENDIF

&IF "{&FieldScreen9}":U <> "":U &THEN
    &IF "{&Frame9}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen9}:HANDLE IN FRAME {&Frame9})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen9}:HANDLE IN BROWSE {&Browse9})
    &ENDIF
&ELSEIF "{&FieldHandle9}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle9})
&ENDIF

&IF "{&FieldScreen10}":U <> "":U &THEN
    &IF "{&Frame10}":U <> "":U &THEN
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen10}:HANDLE IN FRAME {&Frame10})
    &ELSE
        &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldScreen10}:HANDLE IN BROWSE {&Browse10})
    &ENDIF
&ELSEIF "{&FieldHandle10}":U <> "":U &THEN
    &SCOPED-DEFINE FieldHandles {&FieldHandles} + ",":U + STRING({&FieldHandle10})
&ENDIF

/*--- Executa programa de pesquisa ---*/
RUN {&ProgramZoom} PERSISTENT SET hProgramZoom.

IF VALID-HANDLE(hProgramZoom) THEN DO:
    /*--- Executa m‚todo definido pelo desenvolvedor atrav‚s do preprocessador 
          {&RunMethod} ---*/
    &IF "{&RunMethod}":U <> "":U &THEN
        {&RunMethod}
    &ENDIF

    /*--- Seta, no programa de pesquisa, os campos que devem ser retornados ---*/
    RUN setFieldNamesHandles IN hProgramZoom (INPUT "{&FieldNames}":U, INPUT {&FieldHandles}).

    /*--- Inicializa programa de pesquisa ---*/
    RUN initializeInterface IN hProgramZoom.

    &IF DEFINED(EnableImplant) <> 0 &THEN
        &IF "{&EnableImplant}":U = "YES":U &THEN
            /*--- Habilita botäes de implanta‡Æo ---*/
            RUN enableImplant IN hProgramZoom NO-ERROR.
        &ENDIF
    &ELSE
        /*--- Habilita botäes de implanta‡Æo ---*/
        RUN enableImplant IN hProgramZoom NO-ERROR.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


