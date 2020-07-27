&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : confdel.i
    Purpose     : Pedir confirma‡Æo de elimina‡Æo

    Syntax      : {include/confdel.i}

    Description : Pede a confirma‡Æo de uma elimina‡Æo

    Author(s)   : Vanei
    Created     : 13/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

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

DEFINE VARIABLE l-resposta  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE i-msgnumber AS INTEGER            NO-UNDO.
DEFINE VARIABLE c-msgparam  AS CHARACTER          NO-UNDO.

RUN get-attribute IN THIS-PROCEDURE (INPUT "MessageNum":U).
ASSIGN i-msgnumber = INTEGER(RETURN-VALUE).

IF i-msgnumber <> ? AND i-msgnumber <> 0 THEN DO:
    RUN get-attribute IN THIS-PROCEDURE (INPUT "MessageParam":U).
    ASSIGN c-msgparam = STRING(RETURN-VALUE).
    
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT i-msgnumber, INPUT c-msgparam).
END.
ELSE
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 550, INPUT "":U).

IF RETURN-VALUE = "YES":U THEN
    ASSIGN l-resposta = yes.
ELSE
    ASSIGN l-resposta = no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


