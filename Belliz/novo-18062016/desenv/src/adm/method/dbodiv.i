&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library que cont‚m a defini‡Æo de m‚todos diversos."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dbodiv.i
    Purpose    : Method Library que cont‚m a defini‡Æo de m‚todos diversos

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-emptyRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowObject Method-Library 
PROCEDURE emptyRowObject :
/*------------------------------------------------------------------------------
  Purpose:     Limpa temptable RowObject
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowObject:
        DELETE RowObject.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowObjectAux) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowObjectAux Method-Library 
PROCEDURE emptyRowObjectAux :
/*------------------------------------------------------------------------------
  Purpose:     Limpa temptable RowObjectAux
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowObjectAux:
        DELETE RowObjectAux.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowRaw) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowRaw Method-Library 
PROCEDURE emptyRowRaw :
/*------------------------------------------------------------------------------
  Purpose:     Limpa temptable RowRaw
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowRaw EXCLUSIVE-LOCK:
        DELETE RowRaw.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAction Method-Library 
PROCEDURE getAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEF OUTPUT PARAM c-action AS CHAR NO-UNDO.

    ASSIGN c-action = cAction.

    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetBatchRecordsInHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetBatchRecordsInHandle Method-Library 
PROCEDURE GetBatchRecordsInHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    
    DEF INPUT PARAM rRowid AS ROWID NO-UNDO.
    DEF INPUT PARAM lNext AS LOGICAL NO-UNDO.
    DEF INPUT PARAM iMaxRows AS INT NO-UNDO.
    DEF OUTPUT PARAM iReturnedRows AS INT NO-UNDO.
    DEF OUTPUT PARAM h-RowObject AS HANDLE NO-UNDO.

    RUN getBatchRecords (INPUT rRowid,
                         INPUT lNext,
                         INPUT iMaxRows,
                         OUTPUT iReturnedRows,
                         OUTPUT TABLE RowObject).

    ASSIGN h-RowObject = BUFFER RowObject:HANDLE.

    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBOXMLExcludeFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOXMLExcludeFields Method-Library 
PROCEDURE getDBOXMLExcludeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEF OUTPUT PARAM c-DBOExcludeFields AS CHARACTER NO-UNDO.

    ASSIGN c-DBOExcludeFields = "{&DBOXMLExcludeFields}":U.

    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getExecuteUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getExecuteUpdate Method-Library 
PROCEDURE getExecuteUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Retornar se o DBO deve ou nÆo efetuar as atualiza‡äes no banco.
  Parameters:  Retorna valor l¢gico
  Notes:       Um valor FALSE indica que o DBO nÆo deve efetuar as atualiza‡äes
               no banco. Isso ocorre quando o DBO ‚ chamado a partir dos
               gatilhos do dicion rio.
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER lExecute AS LOGICAL NO-UNDO.

    ASSIGN lExecute = lExecuteUpdate.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQueryHandle Method-Library 
PROCEDURE getQueryHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM h-query AS HANDLE NO-UNDO.

    ASSIGN h-query = hQuery.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getRawRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawRecord Method-Library 
PROCEDURE getRawRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna vari vel do tipo RAW, contendo o registro corrente
  Parameters:  retorna vari vel do tipo RAW
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRaw AS RAW NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        /*--- Erro 2: Tabela de Comunica‡Æo nÆo dispon¡vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.

    /*--- Deve ser realizado tratamento de erro, pois a query pode ter sido definida
          com a op‡Æo FIELDS e neste caso ir  ocorrer erro ---*/
    RAW-TRANSFER RowObject TO pRaw NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                    &ErrorSubType="ERROR"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReceivingMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReceivingMessage Method-Library 
PROCEDURE getReceivingMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN    
    DEFINE OUTPUT PARAM lStatus AS LOGICAL NO-UNDO.
    ASSIGN lStatus = lReceivingMsg.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecord Method-Library 
PROCEDURE getRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna registro da temptable RowObject
  Parameters:  retorna temptable RowObject
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetRecordInHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetRecordInHandle Method-Library 
PROCEDURE GetRecordInHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM h-RowObject AS HANDLE NO-UNDO.

    RUN getRecord IN THIS-PROCEDURE
        (OUTPUT TABLE RowObject).

    ASSIGN h-RowObject = BUFFER RowObject:HANDLE.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrorsHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrorsHandle Method-Library 
PROCEDURE getRowErrorsHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    
    DEF OUTPUT PARAM h-RowErrors AS HANDLE NO-UNDO.

    ASSIGN h-RowErrors = BUFFER rowErrors:HANDLE.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getRowid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowid Method-Library 
PROCEDURE getRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.

    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.

    /*--- Executa m²todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getRowid"
                                    &Parameters="INPUT-OUTPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    ASSIGN pRowid = ROWID({&TableName}).

    /*--- Executa m²todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getRowid"
                                    &Parameters="INPUT-OUTPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectHandle Method-Library 
PROCEDURE getRowObjectHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEF OUTPUT PARAM h-RowObject AS HANDLE NO-UNDO.

    ASSIGN h-RowObject = BUFFER rowObject:HANDLE.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableHandle Method-Library 
PROCEDURE getTableHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM h-table AS HANDLE NO-UNDO.

    ASSIGN h-table = BUFFER {&tablename}:HANDLE.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLExcludeFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLExcludeFields Method-Library 
PROCEDURE getXMLExcludeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEF OUTPUT PARAM c-ExcludeFields AS CHARACTER NO-UNDO.

    ASSIGN c-ExcludeFields = "{&XMLExcludeFields}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLKeyFields Method-Library 
PROCEDURE getXMLKeyFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-keyFields AS CHARACTER NO-UNDO.

    ASSIGN c-keyFields = "{&XMLKeyFields}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLProducer Method-Library 
PROCEDURE getXMLProducer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM l-XMLProducer AS LOGICAL NO-UNDO.

    IF "{&XMLProducer}":U = "YES":U AND "{&SOMessageBroker}":U <> "":U THEN
        l-XMLProducer =  YES.
    ELSE l-XMLProducer = NO.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLPublicFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLPublicFields Method-Library 
PROCEDURE getXMLPublicFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-publicFields AS CHARACTER NO-UNDO.

    ASSIGN c-publicFields = "{&XMLPublicFields}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLSender) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLSender Method-Library 
PROCEDURE getXMLSender :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-XMLSender AS CHARACTER NO-UNDO.

    ASSIGN c-XMLSender = "{&XMLSender}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLTableName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLTableName Method-Library 
PROCEDURE getXMLTableName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-XMLTableName AS CHARACTER NO-UNDO.

    ASSIGN c-XMLTableName = "{&XMLTableName}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLTableNameMult) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLTableNameMult Method-Library 
PROCEDURE getXMLTableNameMult :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-XMLTableNameMult AS CHAR NO-UNDO.

    ASSIGN c-XMLTableNameMult = "{&XMLTableNameMult}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLTopic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLTopic Method-Library 
PROCEDURE getXMLTopic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF OUTPUT PARAM c-XMLTopic AS CHARACTER NO-UNDO.

    ASSIGN c-XMLTopic = "{&XMLTopic}":U.
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-isAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isAvailable Method-Library 
PROCEDURE isAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se a tabela {&TableName} est  dispon¡vel
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE {&TableName} THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NewRecordOffQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecordOffQuery Method-Library 
PROCEDURE NewRecordOffQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER offQuery AS LOGICAL NO-UNDO.

    IF lQueryOpened = YES AND "{&newRecordOffQuery}":U = "YES":U THEN
        ASSIGN offQuery = YES.
    ELSE
        ASSIGN offQuery = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExecuteUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecuteUpdate Method-Library 
PROCEDURE setExecuteUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Informar se o DBO deve ou nÆo efetuar as atualiza‡äes no banco.
  Parameters:  Recebe valor l¢gico
  Notes:       Um valor FALSE indica que o DBO nÆo deve efetuar as atualiza‡äes
               no banco. Isso ocorre quando o DBO ‚ chamado a partir dos
               gatilhos do dicion rio.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER lExecute AS LOGICAL NO-UNDO.
    IF  lExecute = ? THEN
        RETURN.

    ASSIGN lExecuteUpdate = lExecute.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReceivingMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setReceivingMessage Method-Library 
PROCEDURE setReceivingMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEFINE INPUT PARAM lStatus AS LOGICAL NO-UNDO.

    ASSIGN lReceivingMsg = (lStatus = YES). /* Trata ? como NO */

    &Endif
&Endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-setRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecord Method-Library 
PROCEDURE setRecord :
/*------------------------------------------------------------------------------
  Purpose:     Seta registro na temptable RowObject
  Parameters:  recebe temptable RowObject
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObject.


    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="setRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Posiciona o registro para posteriormente utiliz -lo. E caso a temptable
          tenha mais de 1 (um) registro, somente o primeiro ser  utilizado ---*/
    FIND FIRST RowObject NO-ERROR.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="setRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_copyBuffer2TT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _copyBuffer2TT Method-Library 
PROCEDURE _copyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     Copia registro do Buffer para a temptable RowObject
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Limpa temptable RowObject ---*/
    RUN emptyRowObject IN THIS-PROCEDURE.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="copyBuffer2TT"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Cria registro na temptable RowObject ---*/
    CREATE RowObject.

    /* DBO-XML-BEGIN */
    /* Garante que todos os campos do registro estejam disponiveis
       no caso da query estar utilizando field-list */

    /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
    /** WBD: BEGIN_NULL_CODE **/
    FIND CURRENT {&TableName} NO-LOCK.
    /** WBD: END_NULL_CODE **/
    /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/

    /* DBO-XML-END */
    /*--- Transfere dados da tabela {&TableName} para a temptable RowObject ---*/
    /* DESATIVADO DEVIDO A BUG na V9.1B. Gera System-Error 130 quando
       utilizado BUFFER-COPY em um Buffer lido com field list
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        BUFFER RowObject:BUFFER-COPY((BUFFER {&TableName}:HANDLE)) NO-ERROR.
    &ELSE
        BUFFER-COPY {&TableName} TO RowObject.
    &ENDIF
    /* DBO-XML-END */
    */
    BUFFER-COPY {&TableName} TO RowObject
        ASSIGN RowObject.r-Rowid = ROWID({&TableName}).

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="copyBuffer2TT"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_copyTT2Buffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _copyTT2Buffer Method-Library 
PROCEDURE _copyTT2Buffer :
/*------------------------------------------------------------------------------
  Purpose:     Copia registro da temptable RowObject para o Buffer
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="copyTT2Buffer"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* DBO-XML-BEGIN */
    /* Garante que todos os campos do registro estejam disponiveis
       no caso da query estar utilizando field-list */
    /* FIND CURRENT {&TableName} EXCLUSIVE-LOCK. */
    /* DBO-XML-END */
    BUFFER-COPY RowObject TO {&TableName} NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="copyTT2Buffer"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

