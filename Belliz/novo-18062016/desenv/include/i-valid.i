&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : i-valid.i 
    Purpose     : Executa a rotina de valida»’o em todas as viwers com 
                  Group-Assign-Target
    Syntax      :

    Description :

    Author(s)   : Ricardo de Lima Perdigao
    Created     : 14/03/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE VAR c_aux         AS CHARACTER NO-UNDO.
  DEFINE VAR i_aux         AS INTEGER   NO-UNDO.
  DEFINE VAR h_aux         AS HANDLE    NO-UNDO.
  DEFINE VAR c_page-viewer AS CHARACTER NO-UNDO.
  DEFINE VAR h_container   AS HANDLE    NO-UNDO.
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
                                                                        */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 
/* ***************************  Main Block  *************************** */

  RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure, INPUT "GROUP-ASSIGN-TARGET":U, OUTPUT c_aux).
  IF c_aux <> "" THEN DO: 
     RUN pi-validate IN THIS-PROCEDURE.
     IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U. 
  END.
  DO i_aux = 1 TO NUM-ENTRIES(c_aux) ON ERROR UNDO, RETURN "ADM-ERROR":U : 
     ASSIGN h_aux = WIDGET-HANDLE(ENTRY(i_aux,c_aux)).
     RUN pi-validate in h_aux.
     IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U.
  END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
