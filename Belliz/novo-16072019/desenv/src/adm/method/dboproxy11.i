&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library que possui m‚todos proxy, para conversÆo dos BOs 1.1 para DBOs 2.0."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : method/dboproxy11.i
    Purpose     : Method Library que possui m‚todos proxy, para conversÆo 
                  dos BOs 1.1 para DBOs 2.0

    Author     : John Cleber Jaraceski

    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ****************************  Definitions  *************************** */

/*--- Defini‡Æo de vari veis utilizadas nos m‚todos de nageva‡Æo ---*/
DEFINE VARIABLE lIsFirst AS LOGICAL NO-UNDO.
DEFINE VARIABLE lIsLast  AS LOGICAL NO-UNDO.

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

&IF DEFINED(EXCLUDE-compareVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareVersion Method-Library 
PROCEDURE compareVersion :
/*------------------------------------------------------------------------------
  Purpose:     Compara versÆo passada como parƒmetro com a versÆo atual do DBO
  Parameters:  recebe versÆo
               retorna status do processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pVersion AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pStatus  AS LOGICAL   NO-UNDO.
    
    IF "{&DBOProtocol}":U = pVersion THEN
        ASSIGN pStatus = YES.
    ELSE
        ASSIGN pStatus = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endMethod) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endMethod Method-Library 
PROCEDURE endMethod :
/*------------------------------------------------------------------------------
  Purpose:     Disparada EPCs no ponto final dos m‚todos
  Parameters:  recebe m‚todo corrente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pMethod AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirst Method-Library 
PROCEDURE findFirst :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no primeiro registro da query
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Executa m‚todo "getFirst", que posiciona no primeiro registro ---*/
    RUN getFirst IN THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLast Method-Library 
PROCEDURE findLast :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no £ltimo registro da query
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Executa m‚todo "getLast", que posiciona no £ltimo registro ---*/
    RUN getLast IN THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNext Method-Library 
PROCEDURE findNext :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no pr¢ximo registro da query
  Parameters:  retorna texto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pText AS CHARACTER NO-UNDO.
    
    /*--- Seta vari veis de verifica‡Æo de posicionamento da query a fim de que 
          o DBO 2.0 e o BO 1.1 tenham o mesmo comportamento na navega‡Æo ---*/
    ASSIGN rFirstRowid = ?
           rLastRowid  = ?.
    
    /*--- Executa m‚todo "getNext", que posiciona no pr¢ximo registro ---*/
    RUN getNext IN THIS-PROCEDURE.
    
    /*--- Tratamento de erros ---*/
    IF RETURN-VALUE = "NOK":U AND
       CAN-FIND(FIRST RowErrors 
                WHERE (RowErrors.ErrorType = "INTERNAL":U) AND
                      (RowErrors.ErrorNumber = 10)) THEN
            ASSIGN pText   = "éltima ocorrˆncia da tabela".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrev Method-Library 
PROCEDURE findPrev :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no registro anterior da query
  Parameters:  retorna texto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pText AS CHARACTER NO-UNDO.
    
    /*--- Seta vari veis de verifica‡Æo de posicionamento da query a fim de que 
          o DBO 2.0 e o BO 1.1 tenham o mesmo comportamento na navega‡Æo ---*/
    ASSIGN rFirstRowid = ?
           rLastRowid  = ?.
    
    /*--- Executa m‚todo "getPrev", que posiciona no registro anterior ---*/
    RUN getPrev IN THIS-PROCEDURE.
    
    /*--- Tratamento de erros ---*/
    IF RETURN-VALUE = "NOK":U AND
       CAN-FIND(FIRST RowErrors 
                WHERE (RowErrors.ErrorType = "INTERNAL":U) AND
                      (RowErrors.ErrorNumber = 9)) THEN
            ASSIGN pText    = "Primeira ocorrˆncia da tabela".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRowid Method-Library 
PROCEDURE findRowid :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro
  Parameters:  recebe rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.
    
    /*--- Executa m‚todo "repositionRecord", que reposiciona a query ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowidShow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRowidShow Method-Library 
PROCEDURE findRowidShow :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro e retorna temptable RowObject
  Parameters:  recebe rowid
               retorna temptable RowObject
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
    
    /*--- Executa m‚todo "emptyRowObject", que limpa temptable RowObject ---*/
    RUN emptyRowObject IN THIS-PROCEDURE.
    
    /*--- Executa m‚todo "repositionRecord", que reposiciona a query ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrent Method-Library 
PROCEDURE getCurrent :
/*------------------------------------------------------------------------------
  Purpose:     Retorna temptable RowObject
  Parameters:  retorna temptable RowObject
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
    
    /*--- Executa m‚todo getRecord, que retorna temptable RowObject ---*/
    RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE RowObject).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getVersion Method-Library 
PROCEDURE getVersion :
/*------------------------------------------------------------------------------
  Purpose:     Retorna versÆo da arquitetura do DBO
  Parameters:  retorna versÆo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pVersion AS CHARACTER NO-UNDO.
    
    ASSIGN pVersion = "{&DBOProtocol}":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverSendRows Method-Library 
PROCEDURE serverSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registro
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pStartRow     AS INTEGER   NO-UNDO.
    DEFINE  INPUT PARAMETER pRowid        AS CHARACTER NO-UNDO.
    DEFINE  INPUT PARAMETER pNext         AS LOGICAL   NO-UNDO.
    DEFINE  INPUT PARAMETER pRowsToReturn AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
    /*--- Executa reposicionamento de query por linha ---*/
    IF pStartRow <> ? AND pStartRow <> 0 THEN DO:
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        /*  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */
        /*
            IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND FIRST {&TableName} NO-LOCK NO-ERROR.
        */            
            /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                DEFINE VARIABLE iStartRow AS INTEGER NO-UNDO. /* contar número de linhas */

                IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK NO-ERROR.

        /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */

                ASSIGN iStartRow = iStartRow + 1.
    
                DO WHILE (AVAILABLE {&TableName}) AND (iStartRow < pStartRow): /* contar número de linhas até chegar pStartRow */
                    IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND NEXT {&TableName} NO-LOCK NO-ERROR.
                    
                    ASSIGN iStartRow = iStartRow + 1.
                END.
            END.   
        &ELSE
            REPOSITION {&QueryName} TO ROW pStartRow.
            
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
/***********************************************/
        
        IF AVAILABLE {&TableName} THEN
            /*--- Atualiza temp-table RowObject ---*/
            RUN _copyBuffer2TT IN THIS-PROCEDURE.
    END.
    
    /*--- Executa m‚todo getBatchRecords, que retorna faixa de registro ---*/
    RUN getBatchRecords IN THIS-PROCEDURE ( INPUT TO-ROWID(pRowid),
                                            INPUT pNext,
                                            INPUT pRowsToReturn,
                                           OUTPUT pRowsReturned,
                                           OUTPUT TABLE RowObjectAux).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCurrent Method-Library 
PROCEDURE setCurrent :
/*------------------------------------------------------------------------------
  Purpose:     Seta temptable RowObject com o registro corrente da query
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Executa m‚todo "_copyBuffer2TT", seta temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startMethod) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startMethod Method-Library 
PROCEDURE startMethod :
/*------------------------------------------------------------------------------
  Purpose:     Disparada EPCs no ponto inicial dos m‚todos
  Parameters:  recebe m‚todo corrente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pMethod AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreate Method-Library 
PROCEDURE validateCreate :
/*------------------------------------------------------------------------------
  Purpose:     Cria registro
  Parameters:  recebe temptable RowObject
               retorna temptable RowErrors
               retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
    
    FIND FIRST RowObject NO-ERROR.
    
    /*--- Limpa temptable RowErrors ---*/
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    /*--- Executa m‚todo "createRecord", cria/grava registro para tabela {&TableName} ---*/
    RUN createRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Executa m‚todo "getRowid", que retorna o rowid do registro atual ---*/
    RUN getRowid IN THIS-PROCEDURE (OUTPUT pRowid).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDelete Method-Library 
PROCEDURE validateDelete :
/*------------------------------------------------------------------------------
  Purpose:     Elimina registro
  Parameters:  recebe/retorna rowid
               retorna temptable RowErrors
  Notes:       Posiciona o registro a ser eliminado (repositionRecord)
               Posiciona no pr¢ximo registro (getNext)
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    DEFINE VARIABLE iSequence AS INTEGER NO-UNDO.
    
    /*--- Limpa temptable RowErrors ---*/
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    /*--- Executa m‚todo "repositionRecord", que reposiciona a query ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Executa m‚todo "deleteRecord", elimina o registro da tabela {&TableName} ---*/
    RUN deleteRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U AND
       NOT CAN-FIND(FIRST RowErrors 
           WHERE (RowErrors.ErrorType = "INTERNAL":U) AND
                 (RowErrors.ErrorNumber = 9)) THEN
        RETURN "NOK":U.
    
    /*--- Executa m‚todo "getRowid", que retorna o rowid do registro atual ---*/
    RUN getRowid IN THIS-PROCEDURE (OUTPUT pRowid).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdate Method-Library 
PROCEDURE validateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Cria/Grava registro
  Parameters:  recebe temptable RowObject
               recebe rowid
               retorna temptable RowErrors
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObject.
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    /*--- Limpa temptable RowErrors ---*/
    RUN emptyRowErrors IN THIS-PROCEDURE.

    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
        
    /*--- Cria/grava temptable RowObjectAux, que ser  utilizada para atualizar
          a temptable RowObject para o reposicionamento do registro ---*/
    /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
    /** WBD: BEGIN_NULL_CODE **/
    FIND FIRST RowObject.
    /** WBD: END_NULL_CODE **/
    /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
    
    CREATE RowObjectAux.
    BUFFER-COPY RowObject TO RowObjectAux.
    
    /*--- Executa m‚todo "repositionRecord", que reposiciona a query ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Executa m‚todo "setRecord", que seta temptable RowObject ---*/
    RUN setRecord (INPUT TABLE RowObjectAux).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Executa m‚todo "updateRecord", que grava o registro atual da tabela {&TableName} ---*/
    RUN updateRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

