&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont²m a implementa»’o para Servi»o de Autentica»’o."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/svc/autentic/autentic.i
    Purpose    : Include que cont²m a implementa»’o para Servi»o 
                 de Autentica»’o

    Parameters : 
        &vUserName              : variÿvel que irÿ˜ conter o nome do usuÿrio 
                                  corrente
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

&IF "{&SOSpecProd}":U <> "":U &THEN
    {{&SOSpecProd} {&*}}
&ENDIF

&IF "{&SOAutentic}":U <> "":U &THEN
    /*Altera‡Æo feita por Anderson (tech540) em 29/05/2001 para solucionar os erros       *
     *de "has no entry point for" causados pela mudan‡a de comportamento do progress 9 com*
     *rela‡Æo a reaproveitamento de handles                                               */
     IF NOT VALID-HANDLE(hSOAutentic) OR 
            hSOAutentic:TYPE <> "PROCEDURE":U OR    
            hSOAutentic:FILE-NAME <> "{&SOAutentic}":U THEN
            RUN {&SOAutentic} PERSISTENT SET hSOAutentic.
    /*Fim altera‡Æo Anderson*/
    &IF "{&vUserName}":U <> "":U &THEN
        RUN getUserName IN hSOAutentic (OUTPUT {&vUserName}).
    &ENDIF
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


