&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEF INPUT  PARAM pReceiveMessage AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM pReturnMessage  AS HANDLE NO-UNDO.

    DEF VAR hXMLParser AS HANDLE  NO-UNDO.
    DEF VAR hIndParam  AS HANDLE  NO-UNDO.
    DEF VAR hDocument AS HANDLE  NO-UNDO.
    DEF VAR hNode  AS HANDLE  NO-UNDO.
    DEF VAR hBody      AS HANDLE  NO-UNDO.
    DEF VAR hMultTable AS HANDLE  NO-UNDO.
    DEF VAR hXMLReturn AS HANDLE  NO-UNDO.
    DEF VAR hErrors    AS HANDLE  NO-UNDO.
    DEF VAR cAction    AS CHAR    NO-UNDO.
    DEF VAR i          AS INTEGER NO-UNDO.

    RUN utp/ut-xmlprs.p PERSISTENT SET hXMLParser.

    RUN getElementValue IN hXMLParser (INPUT pReceiveMessage,
                                       INPUT 2,
                                       INPUT "ACTION":U,
                                       OUTPUT cAction).

    IF cAction = "API-SEND" THEN DO:


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


