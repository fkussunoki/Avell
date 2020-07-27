&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library que contÇm procedures de navegaá∆o para a tabela {&TableName}."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dbonav.i
    Purpose    : Method Library que contÇm procedures de navegaá∆o para a 
                 tabela {&TableName}

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/* DBO-XML-BEGIN */
/* Dynamic Query */
DEF VAR cDQWhereClause AS CHAR NO-UNDO.
DEF VAR cDQFieldList   AS CHAR NO-UNDO.
DEF VAR cDQBYClause    AS CHAR NO-UNDO.

DEF VAR isIndexedReposition AS LOGICAL INITIAL TRUE NO-UNDO.

/* DBO-XML-END */

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
         HEIGHT             = 2.71
         WIDTH              = 49.14.
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

&IF DEFINED(EXCLUDE-bringCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bringCurrent Method-Library 
PROCEDURE bringCurrent :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no registro corrente da query
  Parameters:  
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="bringCurrent"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Verificar se a tabela {&TableName} est† dispon°vel, a fim de evitar o
          erro PROGRESS 4114 (No query record is available.) ---*/
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Limpa temp-table RowObject ---*/
        RUN emptyRowObject IN THIS-PROCEDURE.
        
        /*--- Erro 3: Tabela {&TableName} n∆o dispon°vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Posiciona no registro corrente ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-CURRENT(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /*  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */

        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            FIND CURRENT {&TableName} NO-LOCK NO-ERROR.
        &ELSE
            GET CURRENT {&QueryName} NO-LOCK.
        &ENDIF
        */

        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded, "{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND CURRENT {&TableName} NO-LOCK NO-ERROR.
            END.
            ELSE
               GET CURRENT {&QueryName} NO-LOCK.
        &ELSE
            GET CURRENT {&QueryName} NO-LOCK.
        &ENDIF
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */        

/***********************************************/
    &ENDIF
    /* DBO-XML-END */
     
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Limpa temp-table RowObject ---*/
        RUN emptyRowObject IN THIS-PROCEDURE.
        
        /*--- Erro 3: Tabela {&TableName} n∆o dispon°vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="bringCurrent"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRecordOFRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRecordOFRowObject Method-Library 
PROCEDURE findRecordOFRowObject :
/*------------------------------------------------------------------------------
  Purpose:     Localizar o registro equivalente ao conte£do de RowObject
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    /* DBO-XML-BEGIN */
    DEFINE VARIABLE cReturnValue AS CHAR NO-UNDO.

    &IF DEFINED(KeyField1) = 0 &THEN
        FIND {&TableName} OF RowObject NO-LOCK NO-ERROR.
    &ELSE
        FIND {&TableName} 
            WHERE {&TableName}.{&KeyField1} = RowObject.{&KeyField1}
        &IF DEFINED(KeyField2) &THEN
            AND   {&TableName}.{&KeyField2} = RowObject.{&KeyField2}
        &ENDIF
        &IF DEFINED(KeyField3) &THEN
            AND   {&TableName}.{&KeyField3} = RowObject.{&KeyField3}
        &ENDIF
        &IF DEFINED(KeyField4) &THEN
            AND   {&TableName}.{&KeyField4} = RowObject.{&KeyField4}
        &ENDIF
        &IF DEFINED(KeyField5) &THEN
            AND   {&TableName}.{&KeyField5} = RowObject.{&KeyField5}
        &ENDIF
        &IF DEFINED(KeyField6) &THEN
            AND   {&TableName}.{&KeyField6} = RowObject.{&KeyField6}
        &ENDIF
        &IF DEFINED(KeyField7) &THEN
            AND   {&TableName}.{&KeyField7} = RowObject.{&KeyField7}
        &ENDIF
        &IF DEFINED(KeyField8) &THEN
            AND   {&TableName}.{&KeyField8} = RowObject.{&KeyField8}
        &ENDIF
        &IF DEFINED(KeyField9) &THEN
            AND   {&TableName}.{&KeyField9} = RowObject.{&KeyField9}
        &ENDIF
         NO-LOCK NO-ERROR.
    &ENDIF
    
    IF NOT AVAIL {&TableName} THEN DO:
        /* Erro interno registro nao existe */
        /*--- Erro 609: XML: Registro n∆o existe na Base de Dados ---*/
        {method/svc/errors/inserr.i &ErrorNumber="609"
                                    &ErrorType="XML"     
                                    &ErrorSubType="ERROR"}
        ASSIGN cReturnValue = "NOK":U.
    END.
    ELSE
        RUN repositionRecord IN THIS-PROCEDURE
            (ROWID({&TableName})).

    IF RETURN-VALUE = "NOK":U OR cReturnValue = "NOK":U THEN
        RETURN "NOK":U.

    &ENDIF
&ENDIF

END PROCEDURE.

/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRawRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRawRecords Method-Library 
PROCEDURE getBatchRawRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowRaw 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET NEXT
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowRaw
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowRaw.
    
    DEFINE VARIABLE rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.

&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowRaw ---*/
    RUN emptyRowRaw IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /*  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                END.
                ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ELSE
                &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                    qh = QUERY {&QueryName}:HANDLE.
                    RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                    IF RETURN-VALUE = "OK":U THEN
                        qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                &ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF

            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */

/***********************************************/
        &ENDIF
        /* DBO-XML-END */

        IF ERROR-STATUS:ERROR THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /*  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
        
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND NEXT {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                   GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowRaw ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
&ENDIF
    
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRawRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowRaw ---*/
        CREATE RowRaw.
        RAW-TRANSFER RowObject TO RowRaw.RawRecord.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRawRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND NEXT {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                   GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRawRecordsPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRawRecordsPrev Method-Library 
PROCEDURE getBatchRawRecordsPrev :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowRaw
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET PREV
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowRaw
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pPrev         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowRaw.

    DEFINE VARIABLE rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.

&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowRaw ---*/
    RUN emptyRowRaw IN THIS-PROCEDURE.
    
    /*--- Verifica se flag que indica se o registro atual foi reposicionado, em
          caso afirmativo somente permite a navegaá∆o quando o banco Ç igual a
          PROGRESS---*/
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        IF lRepositioned OR
           pRowid <> ? THEN DO:
            /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
            &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN
            /*--- Erro 5: Funá∆o n∆o dispon°vel para Banco de Dados Oracle ---*/
            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}                                        

            RETURN "NOK":U.
            &ENDIF
            /*Fim alteracao 02/10/2006*/
        END.
    &ENDIF

    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            &ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                END.
                ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ELSE                
                &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                    qh = QUERY {&QueryName}:HANDLE.
                    RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                    IF RETURN-VALUE = "OK":U THEN
                        qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                &ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF

            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
/***********************************************/
        &ENDIF
        /* DBO-XML-END */

        IF ERROR-STATUS:ERROR THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pPrev THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-PREV(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND PREV {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND PREV {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET PREV {&QueryName} NO-LOCK.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowRaw ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
        ASSIGN iNextSeq = iNextSeq - 1
               RowObject.RowNum = iNextSeq.
&ENDIF

        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRawRecordsPrev"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowRaw ---*/
        CREATE RowRaw.
        RAW-TRANSFER RowObject TO RowRaw.RawRecord.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRawRecordsPrev"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-PREV(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND PREV {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND PREV {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET PREV {&QueryName} NO-LOCK.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        

/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords Method-Library 
PROCEDURE getBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET NEXT
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.

    DEFINE VARIABLE rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.

    
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        

            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            &ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ENDIF
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                END.
                ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ELSE               
                &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                    qh = QUERY {&QueryName}:HANDLE.
                    RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                    IF RETURN-VALUE = "OK":U THEN
                        qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                &ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                                    
/***********************************************/
        &ENDIF
        /* DBO-XML-END */

         IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}":U = "YES":U &THEN
                /* DBO-XML-BEGIN */
                /* Se a Query Dinamica estiver habilitada, usa o handle dela */
                &IF {&DYNAMIC-QUERY-ENABLED} &THEN
                         hQuery:GET-FIRST(NO-LOCK).
                  ASSIGN pRowid = rowid({&TableName}).
                         hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
                &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
                    /*
                    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                        IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                            RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
                        ELSE
                            FIND FIRST {&TableName} NO-LOCK NO-ERROR.
                        
                        ASSIGN pRowid = ROWID({&TableName}).

                        IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                            RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                        ELSE
                            FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                    &ELSE
                        GET FIRST {&QueryName} NO-LOCK.         
                        ASSIGN pRowid = ROWID({&TableName}).    
                        REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                    &ENDIF
                    */
                    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                        /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                        IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                            IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                                RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
                            ELSE
                                FIND FIRST {&TableName} NO-LOCK NO-ERROR.

                            ASSIGN pRowid = ROWID({&TableName}).

                            IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                                RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                            ELSE
                                FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                        END.
                        ELSE DO:
                            GET FIRST {&QueryName} NO-LOCK.
                            ASSIGN pRowid = ROWID({&TableName}).
                            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                        END.
                    &ELSE
                        GET FIRST {&QueryName} NO-LOCK.
                        ASSIGN pRowid = ROWID({&TableName}).
                        &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                            qh = QUERY {&QueryName}:HANDLE.
                            RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                            IF RETURN-VALUE = "OK":U THEN
                                qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                        &ELSE
                            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                        &ENDIF
                    &ENDIF
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
/***********************************************/                    
                &ENDIF
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */            
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND NEXT {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                        
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
&ENDIF
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */ 
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND NEXT {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */ 
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRecordsPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsPrev Method-Library 
PROCEDURE getBatchRecordsPrev :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET PREV
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pPrev         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
    DEFINE VARIABLE rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.

&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    /*--- Verifica se flag que indica se o registro atual foi reposicionado, em
          caso afirmativo somente permite a navegaá∆o quando o banco Ç igual a 
          PROGRESS---*/
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        IF lRepositioned OR
           pRowid <> ? THEN DO:
            /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
            &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN
            /*--- Erro 5: Funá∆o n∆o dispon°vel para Banco de Dados Oracle ---*/
            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}

            RETURN "NOK":U.
            &ENDIF
            /*Fim alteracao 02/10/2006*/
        END.
    &ENDIF

    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */ 
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            &ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                END.
                ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ELSE          

                &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                    qh = QUERY {&QueryName}:HANDLE.
                    RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                    IF RETURN-VALUE = "OK":U THEN
                        qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                &ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF


            &ENDIF
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */             
/***********************************************/
        &ENDIF
        /* DBO-XML-END */

        IF ERROR-STATUS:ERROR THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */             
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
                END.
                ELSE
                    GET NEXT {&QueryName} NO-LOCK.
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF            

        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                         
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pPrev THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-PREV(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                         
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND PREV {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND PREV {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET PREV {&QueryName} NO-LOCK.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF            
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                                     
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
        
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
        ASSIGN iNextSeq = iNextSeq - 1
               RowObject.RowNum = iNextSeq.
&ENDIF

        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecordsPrev"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecordsPrev"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-PREV(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */ 
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND PREV {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND PREV {&TableName} NO-LOCK NO-ERROR.
                END.
                ELSE
                    GET PREV {&QueryName} NO-LOCK.
            &ELSE
                GET PREV {&QueryName} NO-LOCK.
            &ENDIF            
            
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */             
/***********************************************/
        &ENDIF
        /* DBO-XML-END */
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFirst Method-Library 
PROCEDURE getFirst :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no primeiro registro da query
  Parameters:  
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getFirst"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Posiciona no primeiro registro ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-FIRST(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */             
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND FIRST {&TableName} NO-LOCK NO-ERROR.
        &ELSE
            GET FIRST {&QueryName} NO-LOCK.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                IF THIS-PROCEDURE:GET-SIGNATURE("findFirst":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findFirst":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK NO-ERROR.
            END.
            ELSE
                GET FIRST {&QueryName} NO-LOCK.
        &ELSE
            GET FIRST {&QueryName} NO-LOCK.
        &ENDIF            
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                     
/***********************************************/
    &ENDIF
    
    /* DBO-XML-END */
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Limpa temp-table RowObject ---*/
        RUN emptyRowObject IN THIS-PROCEDURE.

        /*--- Erro 3: Tabela {&TableName} n∆o dispon°vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Erro 8: Query est† vazia ---*/
        {method/svc/errors/inserr.i &ErrorNumber="8"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Seta flags que indicam que a tabela n∆o possui registro ---*/
        ASSIGN rFirstRowid   = ?
               rLastRowid    = ?.
        
        RETURN "NOK":U.
    END.
    
    /*--- Seta flag que indica que est† no in°cio da tabela ---*/
    ASSIGN rFirstRowid   = ROWID({&TableName}).
    
    /*--- Seta flag indicando que o registro atual n∆o Ç mais o registros 
          reposicionado ---*/
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        ASSIGN lRepositioned = NO.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getFirst"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLast Method-Library 
PROCEDURE getLast :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no £ltimo registro da query
  Parameters:  
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
        
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /* Caso seja eliminado o ˙ltimo registro da query, apos um reposicionamento, 
       eh necess·rio o procedimento abaixo para evitar o erro de getPrev em banco diferente de Progress */
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        IF lRepositioned = YES AND
            r-reposition = ? THEN DO:
            ASSIGN lRepositioned = NO.
            RUN getFirst IN THIS-PROCEDURE.
            RUN getLast IN THIS-PROCEDURE.
            RETURN "OK":U.
        END.
    &ENDIF

    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getLast"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Posiciona no £ltimo registro ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-LAST(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                     
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            IF THIS-PROCEDURE:GET-SIGNATURE("findLast":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findLast":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND LAST {&TableName} NO-LOCK NO-ERROR.
        &ELSE
            GET LAST {&QueryName} NO-LOCK.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                IF THIS-PROCEDURE:GET-SIGNATURE("findLast":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findLast":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND LAST {&TableName} NO-LOCK NO-ERROR.
            END.
            ELSE
                GET LAST {&QueryName} NO-LOCK.
        &ELSE
            GET LAST {&QueryName} NO-LOCK.
        &ENDIF                    
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                             
/***********************************************/
    &ENDIF
    /* DBO-XML-END */

    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Limpa temp-table RowObject ---*/
        RUN emptyRowObject IN THIS-PROCEDURE.
        
        /*--- Erro 3: Tabela {&TableLabel} n∆o dispon°vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Erro 8: Query est† vazia ---*/
        {method/svc/errors/inserr.i &ErrorNumber="8"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Seta flags que indicam que a tabela n∆o possui registro ---*/
        ASSIGN rFirstRowid   = ?
               rLastRowid    = ?.
        
        RETURN "NOK":U.
    END.
    
    /*--- Seta flag que indica que est† no fim da tabela ---*/
    ASSIGN rLastRowid    = ROWID({&TableName}).
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getLast"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNext Method-Library 
PROCEDURE getNext :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no pr¢ximo registro da query
  Parameters:  
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getNext"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Posiciona no pr¢ximo registro ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-NEXT(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */  
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND NEXT {&TableName} NO-LOCK NO-ERROR.
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                IF THIS-PROCEDURE:GET-SIGNATURE("findNext":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findNext":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
            END.
            ELSE
                GET NEXT {&QueryName} NO-LOCK.
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF                            
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */          
/***********************************************/
    &ENDIF
    /* DBO-XML-END */

    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 10: Query est† posicionada no £ltimo registro ---*/
        {method/svc/errors/inserr.i &ErrorNumber="10"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Posiciona no £ltimo registro, quando h† falha ---*/
        RUN getLast IN THIS-PROCEDURE.
        
        RETURN "NOK":U.
    END.
    
    /*--- Seta flag indicando que o registro atual n∆o Ç mais o registros 
          reposicionado ---*/
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        IF r-reposition = ROWID({&TableName}) THEN
            lRepositioned = NO.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.

    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getNext"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK" THEN
        RETURN "NOK":U.
    
    /*--- Verifica se a query est† posicionada no £ltimo registro ---*/
    IF rLastRowid = ROWID({&TableName}) THEN DO:
        /*--- Erro 10: Query est† posicionada no £ltimo registro ---*/
        {method/svc/errors/inserr.i &ErrorNumber="10"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrev Method-Library 
PROCEDURE getPrev :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no registro anterior da query
  Parameters:  
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /* caso seja feita uma inclusao ou reposicionamento no ultimo registro da query 
       eh necessario cancelar o get prev e desabilitar o botao prev em oracle */
    &IF "{&DBType}":U = "ORACLE":U &THEN
        IF r-reposition = ROWID({&TableName}) AND lRepositioned = YES THEN DO:
            /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
            &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN
                /*--- Erro 5: Funá∆o n∆o dispon°vel para Banco de Dados diferente de Progress ---*/
                {method/svc/errors/inserr.i &ErrorNumber="5"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}
    
                RETURN "NOK":U.
            &ENDIF
            /*Fim alteracao 02/10/2006*/
        END.
    &ENDIF

    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="getPrev"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Posiciona no registro anterior ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-PREV(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */          
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND PREV {&TableName} NO-LOCK NO-ERROR.
        &ELSE
            GET PREV {&QueryName} NO-LOCK.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                IF THIS-PROCEDURE:GET-SIGNATURE("findPrev":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findPrev":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND PREV {&TableName} NO-LOCK NO-ERROR.
            END.
            ELSE
                GET PREV {&QueryName} NO-LOCK.
        &ELSE
            GET PREV {&QueryName} NO-LOCK.
        &ENDIF                                    
        /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                  
/***********************************************/
    &ENDIF
    

    /* DBO-XML-END */
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 9: Query est† posicionada no primeiro registro ---*/
        {method/svc/errors/inserr.i &ErrorNumber="9"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        /*--- Posiciona no primeiro registro, quando h† falha ---*/
        RUN getFirst IN THIS-PROCEDURE.
        
        RETURN "NOK":U.
    END.

    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="getPrev"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Verifica se a query est† posicionada no primeiro registro ---*/
    IF rFirstRowid = ROWID({&TableName}) THEN DO:
        /*--- Erro 9: Query est† posicionada no primeiro registro ---*/
        {method/svc/errors/inserr.i &ErrorNumber="9"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.

    /* Desabilitar o botao de Prev quando chegar no registro reposicionado. Somente para bancos ORACLE*/
    &IF "{&DBType}":U = "ORACLE":U &THEN
        IF r-reposition = ROWID({&TableName}) AND lRepositioned = YES THEN DO:
            /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
            &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN
                /*--- Erro 5: Funá∆o n∆o dispon°vel para Banco de Dados diferente de Progress ---*/
                {method/svc/errors/inserr.i &ErrorNumber="5"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}
    
                RETURN "NOK":U.
            &ENDIF
            /*Fim alteracao 02/10/2006*/
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQueryDynamic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDynamic Method-Library 
PROCEDURE openQueryDynamic :
/*------------------------------------------------------------------------------
  Purpose:     Abre uma Query Dinamica de acordo com parametrizaá‰es feitas em outros mÇtodos.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    DEF VAR cQueryPrepareClause AS CHAR   NO-UNDO.

    DEF VAR iMsgNumber          AS INTE   NO-UNDO.
    DEF VAR cBuffers            AS CHAR   NO-UNDO.
    DEF VAR iBuffers            AS INTE   NO-UNDO.
    DEF VAR hBuffer             AS HANDLE NO-UNDO.


    /* Prepara a string do Query-Prepare */
    RUN _QueryPrepare IN THIS-PROCEDURE
        (OUTPUT cQueryPrepareClause).

    /* Se hQuery for = QUERY {&QueryName}, entao garante que 
       hQuery seja uma query dinamica.
           O objeto QUERY nao tem o atributo DYNAMIC, por isso 
           somos obrigados a eliminar e criar novamente hQuery. */

    DELETE OBJECT hQuery NO-ERROR. 
    CREATE QUERY hQuery NO-ERROR. /* NO-ERROR apenas para limpar buffer de ERROR-STATUS */

    /* NO-ERROR nao esta gerando ERROR-STATUS:ERROR para QUERY-PREPARE */
    iMsgNumber = ERROR-STATUS:GET-NUMBER(1).

    /* Seta o Buffer da Query com a tabela do DBO */
    hQuery:SET-BUFFERS(BUFFER {&TableName}:HANDLE) NO-ERROR.

    hQuery:QUERY-PREPARE(cQueryPrepareClause) NO-ERROR.
    IF  iMsgNumber <> ERROR-STATUS:GET-NUMBER(1) THEN DO:
        /*--- Erro 610: N∆o foi possivel compilar a clausula da Query Dinamica ---*/
        {method/svc/errors/inserr.i &ErrorNumber="610"
                                    &ErrorType="XML"     
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=cQueryPrepareClause}

        {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.

    /* Abre a Query */
    hQuery:QUERY-OPEN() NO-ERROR.
    IF hQuery:IS-OPEN = NO /*ERROR-STATUS:ERROR*/ THEN DO:
        {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.

    /*--- Seta vari†vel que indica qual a query utiliza e seta vari†vel que indica
          que a query foi aberta ---*/
    ASSIGN cQueryUseded = "Dynamic":U /* Garante que o OpenQueryStatic seja redirecionado para este mÇtodo */
           lQueryOpened = YES
           rFirstRowid  = ?
           rLastRowid   = ?.
    
    /*--- Posiciona no primeiro registro da query ---*/
    RUN getFirst IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQueryStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryStatic Method-Library 
PROCEDURE openQueryStatic :
/*------------------------------------------------------------------------------
  Purpose:     Executa procedure para abertura de query
  Parameters:  recebe qual query deve ser aberta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pQuery AS CHARACTER NO-UNDO.
    
    /*--- Executa abertura de query ---*/
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                  
    /*
    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        /* Abertura È retirada pois ser· feito apenas um FIND FIRST, atravÈs do mÈtodo getFirst */
    &ELSE
        RUN VALUE("openQuery":U + pQuery) IN THIS-PROCEDURE.
    &ENDIF
    */


    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
        IF lookup(pQuery,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
            /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
        END.
        ELSE
            RUN VALUE("openQuery":U + pQuery) IN THIS-PROCEDURE.
    &ELSE
        RUN VALUE("openQuery":U + pQuery) IN THIS-PROCEDURE.
    &ENDIF

    /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                      
/***********************************************/
    
    /*--- Seta vari†vel que indica qual a query utiliza e seta vari†vel que indica
          que a query foi aberta ---*/
    ASSIGN cQueryUseded = pQuery
           lQueryOpened = YES
           rFirstRowid  = ?
           rLastRowid   = ?.
    

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
        /* DBO-XML-BEGIN */
        /* Handle da Query Estatica para uso pelos mÇtodos do DBO */
        IF pQuery <> "Dynamic":U THEN
            ASSIGN hQuery = QUERY {&QueryName}:HANDLE.
        /* DBO-XML-END */
        &ENDIF
    &ENDIF

    
    IF pQuery <> "TRIGGER":U THEN DO:
        /*--- Posiciona no primeiro registro da query ---*/
        RUN getFirst IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        ELSE DO: /* garantir que ser· feito posicionamento no primeiro registro */
            /*--- Posiciona no primeiro registro da query ---*/
            RUN getFirst IN THIS-PROCEDURE.
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
    &ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecord Method-Library 
PROCEDURE repositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    DEFINE VARIABLE rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.

    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Verifica se a query est† aberta ---*/
    IF NOT lQueryOpened THEN DO:
        /*--- Erro 6: Query est† fechada ---*/
        {method/svc/errors/inserr.i &ErrorNumber="6"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="repositionRecord"
                                    &Parameters="INPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                      
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
            ELSE
                FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
        &ELSE
            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        &ELSE
            &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                qh = QUERY {&QueryName}:HANDLE.
                RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                IF RETURN-VALUE = "OK":U THEN
                    qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
            &ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ENDIF
        
        &ENDIF
    /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */                              
/***********************************************/
    &ENDIF
    /* DBO-XML-END */

    IF ERROR-STATUS:ERROR THEN DO:
        /*--- A reabertura da query torna-se necessˇria devido ao fato de realizar-se um 
              reposicionamento de um registro rec≤m criado. Neste caso ≤ 
              retornado erro no comando REPOSITION, pois o registro 
              ainda nío esta no RESULT-LIST ---*/
        RUN OpenQueryStatic IN THIS-PROCEDURE (INPUT cQueryUseded).

        /*--- Tenta novo reposicionamento na query ---*/
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */  
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                    RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                ELSE
                    FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
            &ELSE
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN
                    IF THIS-PROCEDURE:GET-SIGNATURE("findRowid":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findRowid":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND FIRST {&TableName} NO-LOCK WHERE ROWID({&TableName}) = pRowid NO-ERROR.
                ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
            &ELSE
                &IF DEFINED(REPOSITION-PROCEDURE) > 0 &THEN
                    qh = QUERY {&QueryName}:HANDLE.
                    RUN {&REPOSITION-PROCEDURE} IN THIS-PROCEDURE (INPUT pRowid, OUTPUT rowid-array) .
                    IF RETURN-VALUE = "OK":U THEN
                        qh:REPOSITION-TO-ROWID(rowid-array) NO-ERROR.    
                &ELSE
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF
            
            &ENDIF       
    /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */              
/***********************************************/
        &ENDIF
        /* DBO-XML-END */

        IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}":U <> "YES":U &THEN
            /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
            {method/svc/errors/inserr.i &ErrorNumber="11"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}
            &ENDIF

            RETURN "NOK":U.
        END.
    END.
    
    /*--- ê necess†rio para o correto funcionamento do reposicionamento ---*/
    /* DBO-XML-BEGIN */
    /* Se a Query Dinamica estiver habilitada, usa o handle dela */
    &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:GET-NEXT(NO-LOCK).
    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/

    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */              
        /*
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        */
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            /*TECH14187 - FO 1489656 - correá∆o do teste para ver se usa FIND*/
            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                /* ê desnecess†ria a execuá∆o do comando NEXT, pois o FIND ê feito por ROWID */
            END.
            ELSE
                GET NEXT {&QueryName} NO-LOCK.
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF       
    /* Final Alteraá∆o -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryÔs com BY */              
/***********************************************/
    &ENDIF
    /* DBO-XML-END */
    
    /*--- Alteraá∆o feita por Eloi Rene Pscheidt (tech710) para resolver o problema
          de o registro j† ter sido deletado por outro usu†rio, quando tenta-se excluir
          um registro que j† foi exclu°do por outro usu†rio ---*/
    IF pRowid <> ROWID({&TableName}) THEN DO:

      IF EXTENT(cErrorList) > 33 THEN DO:
        /*---Erro 34: Registro eliminado por outro usu†rio*/
        {method/svc/errors/inserr.i &ErrorNumber="34"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
      END.                                              
      ELSE DO:
        /*--- Erro 3: Tabela {&TableLabel} n∆o dispon°vel ---*/    
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
      END.

      RETURN "NOK".
    END.
    /*--- fim da alteraá∆o Eloi ---*/

    /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
          reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
          retornado erro no comando REPOSITION, pois o reposicionamento da
          QUERY Ç processado com base no RESULT-LIST ---*/
    IF NOT AVAILABLE {&TableName} THEN DO:
        &IF "{&NewRecordOffQuery}":U <> "YES":U &THEN
        /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        &ENDIF
        RETURN "NOK":U.
    END.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        ASSIGN lRepositioned = YES
               r-reposition = ROWID({&TableName}).
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.

    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="repositionRecord"
                                    &Parameters="INPUT pRowid"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQueryParameters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetQueryParameters Method-Library 
PROCEDURE resetQueryParameters :
/*------------------------------------------------------------------------------
  Purpose:     Reseta para os valores default os parametros da query dinamica
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    /* DBO-XML-BEGIN */
    /* Dynamic Query */
    ASSIGN cDQWhereClause = "":U
           cDQFieldList   = "":U
           cDQBYClause    = "":U.
    &ENDIF
&ENDIF

END PROCEDURE.

/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQueryBy Method-Library 
PROCEDURE setQueryBy :
/*------------------------------------------------------------------------------
  Purpose:     Recebe e armazena o conte£do do BY que ser† usado na Query Dinamica
  Parameters:  pBYClause - Clausula do BY (com a palavra BY e separado por virgula se mais de um campo). 
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

/* DBO-XML-BEGIN */

    DEF INPUT PARAM pBYClause AS CHAR NO-UNDO.
    
    ASSIGN cDQBYClause = pBYClause.
    
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.
/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQueryFieldList Method-Library 
PROCEDURE setQueryFieldList :
/*------------------------------------------------------------------------------
  Purpose:     Recebe e armazena o conte£do de FIELDLIST que ser† usado na Query Dinamica
  Parameters:  pFieldList - Lista dos campos sem o nome da tabela e separados por espaáo em branco. 
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

/* DBO-XML-BEGIN */

    DEF INPUT PARAM pFieldList AS CHAR NO-UNDO.
    
    ASSIGN cDQFieldList = pFieldList.
    
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.
/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQueryWhere Method-Library 
PROCEDURE setQueryWhere :
/*------------------------------------------------------------------------------
  Purpose:     Recebe e armazena o conte£do do WHERE que ser† usado na Query Dinamica
  Parameters:  pWhereClause - Clausula do WHERE (sem a palavra WHERE). 
  Notes:       O nome da tabela deve ser substituido por &1, sendo substituido 
               posteriomente pelo mÇtodo OpenQueryDynamic()
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

/* DBO-XML-BEGIN */

    DEF INPUT PARAM pWhereClause AS CHAR NO-UNDO.
    
    ASSIGN cDQWhereClause = pWhereClause.
    
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.
/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_getTableName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getTableName Method-Library 
PROCEDURE _getTableName :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o conte£do de {&TableName} para ser usado em comandos 
               dinamicos como QueryDinamica
  Parameters:  pTableName 
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    /* DBO-XML-BEGIN */

    DEFINE OUTPUT PARAM pTableName AS CHAR NO-UNDO.

    ASSIGN pTableName = "{&TableName}":U.

    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.

/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_QueryPrepare) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _QueryPrepare Method-Library 
PROCEDURE _QueryPrepare :
/*------------------------------------------------------------------------------
  Purpose:     Monta o FOR EACH que ser† usado para a abertura da Query Dinamica
  Parameters:  OUTPUT pQueryPrepareClause - Clausula para ser usada no Query-Prepare()
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN    
    /* DBO-XML-BEGIN */

    DEF OUTPUT PARAM pQueryPrepareClause AS CHAR NO-UNDO.
    
    DEF VAR cTableName          AS CHAR NO-UNDO.
    DEF VAR cSecurityConstraint AS CHAR NO-UNDO.
    
    RUN _getTableName IN THIS-PROCEDURE
        (OUTPUT cTableName).
    
    /* Se nao existir _getSecurityConstraint continua da mesma forma */
    RUN getSecurityConstraint IN THIS-PROCEDURE
        (OUTPUT cSecurityConstraint) NO-ERROR.
    
    /* Prepara o FOR EACH */
    ASSIGN pQueryPrepareClause =
        /* FOR EACH -> Fixo */
        "FOR EACH &1 " +
        /* FIELD LIST  */
        (IF cDQFieldList = "":U THEN "":U
            ELSE "FIELDS (":U + cDQFieldList + ")":U) +
        /* WHERE Clause*/
        (IF cSecurityConstraint = "":U AND cDQWhereClause = "":U THEN ""
            /* WHERE */
            ELSE " WHERE ":U +
                /* SecurityConstraint */
                (IF cSecurityConstraint = "":U THEN "":U 
                    ELSE "(":U + cSecurityConstraint + ")":U +
                        (IF cDQWhereClause = "":U THEN "" ELSE " AND ")) +
                /* "Dynamic" Where Clause */
                (IF cDQWhereClause = "":U THEN "" 
                    ELSE "(":U + cDQWhereClause + ")":U)
        ) + " ":U +
        /* BY */
        cDQBYClause.

       IF isIndexedReposition THEN DO: 
            ASSIGN pQueryPrepareClause = pQueryPrepareClause + 
                    /* INDEXED-REPOSITION */ 
                    " INDEXED-REPOSITION":U. 
        END. 

    /* Troca &1 por {TableName} */
    ASSIGN pQueryPrepareClause = SUBSTITUTE(pQueryPrepareClause,cTableName).
        
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.

/* DBO-XML-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-setIndexedReposition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setIndexedReposition Method-Library 
PROCEDURE setIndexedReposition :
/*------------------------------------------------------------------------------
  Purpose:     Abre uma Query Dinamica de acordo com parametriza??es feitas em outros m?todos.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEFINE INPUT  PARAMETER indexRepo AS LOGICAL     NO-UNDO.

    isIndexedReposition = indexRepo.
    &ENDIF
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRowids Method-Library 
PROCEDURE getBatchRowids :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atrav?s da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execu??o de novo GET NEXT
               recebe n?mero de linhas a serem retornadas
               retorna n?mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN    
    /* DBO-XML-BEGIN */

    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    hQuery:GET-FIRST(NO-LOCK). 

    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        /*IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.*/
        
        /*--- Atualiza temptable RowObject ---*/
        /*RUN _copyRowidBuffer2TT IN THIS-PROCEDURE.*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
&ENDIF
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ENDIF
        /* DBO-XML-END */
    END.
    
    RETURN "OK":U.
    &ENDIF
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBatchRowidsInHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRowidsInHandle Method-Library 
PROCEDURE getBatchRowidsInHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
    
    DEF OUTPUT PARAM iReturnedRows AS INT NO-UNDO.
    DEF OUTPUT PARAM h-RowObject AS HANDLE NO-UNDO.
    
    RUN getBatchRowids  (OUTPUT iReturnedRows,
                         OUTPUT TABLE RowObject).
    
    ASSIGN h-RowObject = BUFFER RowObject:HANDLE.
    
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
