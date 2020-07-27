&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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

&GLOBAL-DEFINE SOMessageBroker mpp/mpapi021.p

&GLOBAL-DEFINE SmartObject YES

DEF VAR cAction AS CHAR NO-UNDO.
DEF VAR h-GenericAdapter AS HANDLE NO-UNDO.
DEF VAR h-oldBuffer AS HANDLE NO-UNDO.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR lReceivingMsg AS LOGICAL NO-UNDO.
DEF VAR cReturnValue AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-oldBuffer LIKE {&XMLTableName}.

{method/dbotterr.i}

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

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    /* DBO-XML-BEGIN */
    
    /*--- Include com definicao do mecanismo de MessageBroker ---*/
    {method/svc/mb/mbdefs.i}
    
    /*--- Include com inicializacao do mecanismo de MessageBroker ---*/
    {method/svc/mb/mbinit.i}
    /* DBO-XML-END */
        
    /* Inicia XML Parser */
    
    &IF ("{&XMLProducer}" = "YES":U AND
         "{&SOMessageBroker}" <> "":U) OR 
         "{&XMLReceiver}" = "YES":U &THEN
    
        DEF NEW GLOBAL SHARED VAR hXMLParser AS HANDLE NO-UNDO.
        IF NOT VALID-HANDLE(hXMLParser) OR 
           hXMLParser:TYPE      <> "PROCEDURE":U OR
           hXMLParser:FILE-NAME <> "utp/ut-xmlprs.p":U THEN
            RUN utp/ut-xmlprs.p PERSISTENT SET hXMLParser.
    
    &ENDIF
    
    /* DBO-XML-END */
    
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAction Include 
PROCEDURE getAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-action AS CHAR NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-action = cAction.
    
&ENDIF    



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOXMLExcludeFields Include 
PROCEDURE getDBOXMLExcludeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-DBOExcludeFields AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-DBOExcludeFields = "{&DBOXMLExcludeFields}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrorsHandle Include 
PROCEDURE getRowErrorsHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM h-RowErrors AS HANDLE NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN h-RowErrors = BUFFER rowErrors:HANDLE.

&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectHandle Include 
PROCEDURE getRowObjectHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM h-RowObject AS HANDLE NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN h-RowObject = BUFFER {&XMLTableName}:HANDLE.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableHandle Include 
PROCEDURE getTableHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM h-table AS HANDLE NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    
    IF cAction <> "UPDATE" THEN
        ASSIGN h-table = BUFFER {&XMLTableName}:HANDLE.
    ELSE
        ASSIGN h-table = h-oldBuffer.
        
&ENDIF        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLExcludeFields Include 
PROCEDURE getXMLExcludeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-ExcludeFields AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-ExcludeFields = "{&XMLExcludeFields}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLKeyFields Include 
PROCEDURE getXMLKeyFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-keyFields AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-keyFields = "{&XMLKeyFields}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLProducer Include 
PROCEDURE getXMLProducer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM l-XMLProducer AS LOGICAL NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    
    IF "{&XMLProducer}":U = "YES":U AND "{&SOMessageBroker}":U <> "":U THEN
        l-XMLProducer =  YES.
    ELSE l-XMLProducer = NO.
    
&ENDIF    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLPublicFields Include 
PROCEDURE getXMLPublicFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-publicFields AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-publicFields = "{&XMLPublicFields}":U.

&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLSender Include 
PROCEDURE getXMLSender :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-sender AS CHAR NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-sender = "{&XMLSender}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLTableName Include 
PROCEDURE getXMLTableName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-XMLTableName AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-XMLTableName = "{&XMLTableName}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLTopic Include 
PROCEDURE getXMLTopic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM c-XMLTopic AS CHARACTER NO-UNDO.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    ASSIGN c-XMLTopic = "{&XMLTopic}":U.
    
&ENDIF    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOldBufferHandle Include 
PROCEDURE setOldBufferHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN

    BUFFER-COPY {&XMLTableName} TO tt-oldBuffer.
    ASSIGN h-oldBuffer = BUFFER tt-oldBuffer:HANDLE.

&ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

