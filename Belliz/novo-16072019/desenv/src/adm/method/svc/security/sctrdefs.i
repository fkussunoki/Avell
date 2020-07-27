&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m defini‡äes para Servi‡o de Seguran‡a."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/security/defs.i
    Purpose    : Include que cont‚m defini‡äes para Servi‡o de Seguran‡a

    Parameters :

    Author     :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Defini‡Æo de vari vel que cont‚m o handle global dos SO de seguran‡a ---*/
DEFINE NEW GLOBAL SHARED VARIABLE hSOSecurity AS HANDLE NO-UNDO.

/*--- Defini‡Æo de vari vel que indicar  se a seguran‡a para o DBO est  OK ---*/
DEFINE VARIABLE lSecurityOK AS LOGICAL NO-UNDO. 

/*--- Defini‡Æo de vari vel que conter  a lista de fun‡äes com permissÆo de execu‡Æo ---*/
DEFINE VARIABLE cFunctionsPermited  AS CHARACTER NO-UNDO.

/*--- Defini‡Æo de vari vel que conter  o rowid do registro criado para armazenar o 
      log de execu‡Æo de programas ---*/
DEFINE VARIABLE rLog AS ROWID NO-UNDO.


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _canRunMethod Include 
PROCEDURE _canRunMethod :
/*------------------------------------------------------------------------------
  Purpose:     Verifica permissÆo de execu‡Æo para m‚todos
  Parameters:  recebe fun‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFunction AS CHARACTER NO-UNDO.

    IF LOOKUP(pFunction, cFunctionsPermited) <> 0 THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


