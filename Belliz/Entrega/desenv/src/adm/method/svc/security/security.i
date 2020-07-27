&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont²m a implementa»’o para  Servi»o de Seguran»a."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/security/security.i
    Purpose    : Include que cont²m a implementa»’o para Servi»o de 
                 Seguran»a

    Parameters :

    Author     :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE VARIABLE cRetErro AS CHARACTER NO-UNDO.

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

/*--- Verifica seguran»a DBO ---*/

&IF "{&SOSecurity}":U <> "":U &THEN
    /*Altera‡Æo feita por Anderson (tech540) em 29/05/2001 para solucionar os erros       *
     *de "has no entry point for" causados pela mudan‡a de comportamento do progress 9 com*
     *rela‡Æo a reaproveitamento de handles                                               */
    IF NOT VALID-HANDLE(hSOSecurity) OR 
           hSOSecurity:TYPE <> "PROCEDURE":U OR
           hSOSecurity:FILE-NAME <> "{&SOSecurity}":U THEN
           /*Fim Altera‡Æo Anderson*/
        RUN {&SOSecurity} PERSISTENT SET hSOSecurity.

    RUN verifySecurity IN hSOSecurity ( INPUT THIS-PROCEDURE:HANDLE,
                                        OUTPUT cFunctionsPermited).    

    cRetErro = return-value.    

    IF cRetErro <> "OK":U AND
       cRetErro <> "":U THEN DO:
        /*--- N’o ² gravado erro na temp-table RowErrors porque o DBO pode ser˜ 
              destru­do, desta forma o programa chamador n’o poderÿ˜ retornar
              a temp-table RowErrors ---*/

        /*RUN destroy IN THIS-PROCEDURE.*/

        RETURN cRetErro.
    END.


&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


