&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library que cont‚m procedures de tratamento de registro para tabela {&TableName}."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dboupd.i
    Purpose    : Method Library que cont‚m procedures de tratamento de 
                 registro para tabela {&TableName}

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
    DEFINE VARIABLE rCurrent AS ROWID   NO-UNDO.
    DEFINE VARIABLE rCurrentAux AS ROWID   NO-UNDO.

    /* DBO-XML-BEGIN */
    DEF VAR lReceivingMsg AS LOGICAL NO-UNDO.
    DEF VAR h-genericadapter AS HANDLE NO-UNDO.
    DEF VAR cAction AS CHAR NO-UNDO.
    &GLOBAL-DEFINE DBOXMLExcludeFields r-rowid
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
         HEIGHT             = 2
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

&IF DEFINED(EXCLUDE-createRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRecord Method-Library 
PROCEDURE createRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cria e grava registro
  Parameters:  
  Notes:       Executa valida‡äes (validateRecord)
               Abre query (openQuery)
               Reposiciona registro rec‚m criado (repositionRecord)
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLockAgain AS INTEGER NO-UNDO.
    DEFINE VARIABLE lExecute AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cReturnValue AS CHARACTER NO-UNDO INIT "OK":U.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        &IF ("{&XMLProducer}":U = "YES":U AND
                 "{&SOMessageBroker}":U <> "":U) OR 
                 "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */
            {method/xmldef.i}

            {method/xmlini.i ADD}
            /* DBO-XML-END */
        &ENDIF
    &ENDIF

    DO  iCounter = 2 TO 10:
        IF INDEX(PROGRAM-NAME(iCounter), THIS-PROCEDURE:FILE-NAME) <> 0 THEN
            RUN emptyRowErrors IN THIS-PROCEDURE.    
    END.

    /* --- Verifica se o DBO deve efetuar as atualiza‡äes --- */
    RUN getExecuteUpdate (OUTPUT lExecute).

    /*--- Verifica a existˆncia de m‚todo de sobreposi‡Æo ---*/
    IF THIS-PROCEDURE:GET-SIGNATURE("createRecordOver":U) <> "":U THEN DO:
        RUN createRecordOver IN THIS-PROCEDURE.

        RETURN RETURN-VALUE.
    END.

    /*--- Verifica permissÆo de execu‡Æo ---*/
    {method/svc/security/permit.i &Method="Create"}

    /*--- Executa valida‡äes (validateRecord) ---*/
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Guardar rowid atual para reposicionamento
          caso ocorra erro na inclusÆo do novo registro ---*/
    IF AVAIL {&TableName} THEN DO:
        RUN getRowid IN THIS-PROCEDURE (output rCurrentAux).
    END.

    &IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
        DEFINE VARIABLE hProgramDisable AS HANDLE NO-UNDO.
        RUN {&TRIGGER-DISABLE-PROGRAM} PERSISTENT SET hProgramDisable.
    &ENDIF

    TRANS_BLOCK:
    DO TRANSACTION:
        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="Before"
                                        &Procedure="createRecord"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="beforecreateRecord"}
        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Verifica se a temptable RowObject est  avaliada ---*/
        IF NOT AVAILABLE RowObject THEN DO:
            /*--- Erro 2: Tabela de Comunica‡Æo nÆo dispon¡vel ---*/
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}

            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        IF  lExecute THEN DO:
            /*--- Cria registro ---*/
            CREATE {&TableName} NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
        END.
        ELSE DO:
            /*--- Marca registro com exclusive-lock ---*/
            /* DBO-XML-BEGIN */
            /* Se a Query Dinamica estiver habilitada, usa o handle dela */

            &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
                hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
            &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/

        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */
                /*
                &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                    FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                &ELSE
                    GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ENDIF
                */

                &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                    /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                    IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                        IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                            RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                        ELSE
                            FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                    END.
                    ELSE
                        GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ELSE
                    GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ENDIF
        /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */        

/***********************************************/
            &ENDIF

            /* DBO-XML-END */

            /*--- Execu‡Æo de N (inicialmente 5) tentativas a fim de esperar o 
                  registro corrente ser desbloqueado ---*/
            DO WHILE LOCKED {&TableName}:
                IF LOCKED {&TableName} THEN
                    /* DBO-XML-BEGIN */
                    /* Se a Query Dinamica estiver habilitada, usa o handle dela */

                    &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
                        hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
                    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */        
                        /*
                        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                            FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                        &ELSE
                            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ENDIF
                        */

                        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                            /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                                IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                                    RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                                ELSE
                                    FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                            END.
                            ELSE
                                GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ELSE
                            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ENDIF
        /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */                        
/***********************************************/
                    &ENDIF


                    /* DBO-XML-END */

                IF (NOT LOCKED {&TableName} AND NOT AVAILABLE {&TableName}) OR
                   (AVAILABLE {&TableName} AND NOT LOCKED {&TableName}) OR
                   (iLockAgain >= 5) THEN
                    LEAVE.

                ASSIGN iLockAgain = iLockAgain + 1.
            END.

            IF NOT AVAILABLE {&TableName} THEN DO:
                /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/
                {method/svc/errors/inserr.i &ErrorNumber="3"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
            ELSE IF LOCKED {&TableName} THEN DO:
                /*--- Erro 4: Registro da tabela {&TableLabel} est  bloqueado 
                              por outro usu rio ---*/
                {method/svc/errors/inserr.i &ErrorNumber="4"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
            ELSE IF CURRENT-CHANGED {&TableName} THEN DO:
                /*--- Erro 12: Registro corrente j  foi alterado por outro usu rio ---*/
                {method/svc/errors/inserr.i &ErrorNumber="12"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
        END.

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */
            /* Gera o documento XML para ser enviado pelo MessageBroker ---*/
            
            {method/xmlprp.i}

            /* DBO-XML-END */
            &ENDIF
        &ENDIF

        /*--- Copia o registro da temptable RowObject para a tabela 
              {&TableName} (_copyTT2Buffer) ---*/

        RUN _copyTT2Buffer IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Alterado por Paulo H. Lazzarotti em 17/05/2003 
              Tratamento de unique-constraint violada para banco diferente de PROGRESS ---*/

        &IF "{&DBType}":U <> "PROGRESS":U &THEN
            ASSIGN rCurrent = ROWID({&TableName}) NO-ERROR.

            /*altera‡Æo valdir - 10/06/2004 - Atividade 114576*/
            IF ERROR-STATUS:NUM-MESSAGES > 0 THEN  DO:  /*se ocorreu algum erro*/
               DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO.
               DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*la‡o para todos os erros*/
                   CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                       WHEN 132 OR /* registro j  existe */
                       WHEN 1502 THEN DO: /* registro deu erro no oracle, nÆo no progress*/
                            /*--- Erro 35: Registro j  cadastrado na tabela ---*/
                               {method/svc/errors/inserr.i
                                                  &ErrorNumber="35"
                                                  &ErrorType="INTERNAL"
                                                  &ErrorSubType="ERROR"}
                            ASSIGN cReturnValue = "NOK":U.
                            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                       END.

                       WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                            /*--- Erro 36: Valor do campo maior que o permitido. Consulte o 
                                  arquivo Dataserv.lg para descobrir a tabela e o campo envolvidos. ---*/
                               {method/svc/errors/inserr.i
                                                  &ErrorNumber="36"
                                                  &ErrorType="INTERNAL"
                                                  &ErrorSubType="ERROR"}
                            ASSIGN cReturnValue = "NOK":U.
                            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                       END.

                       OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                            /*--- Erro 37: Ocorreu um erro no dataserver: &1 ---*/
                               {method/svc/errors/inserr.i
                                                  &ErrorNumber="37"
                                                  &ErrorType="INTERNAL"
                                                  &ErrorSubType="ERROR"
                                                  &ErrorParameters=ERROR-STATUS:GET-MESSAGE(iNumErro)}
                            ASSIGN cReturnValue = "NOK":U.
                            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                       END.
                   END CASE.
               END.
            END.
            /*fim altera‡Æo valdir - 10/06/2004 - Atividade 114576*/
        &ELSE
            ASSIGN rCurrent = ROWID({&TableName}).
        &ENDIF


        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="After"
                                        &Procedure="createRecord"}

        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="aftercreateRecord"}

        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Atualiza registro na query ---*/
        RUN OpenQueryStatic IN THIS-PROCEDURE (INPUT cQueryUseded).

        /*--- Seta registro corrente ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rCurrent).

        &IF "{&NewRecordOffQuery}":U <> "YES":U &THEN
            IF RETURN-VALUE = "NOK":U THEN
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        &ENDIF


        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */
            /* Envia a Mensagem XML */
            /* Apos todas as validacoes locais, 
               envia mensagem para outros componentes via Message Broker 
               e desfaz a transa‡Æo se houver erro */
    
            {method/xmlsnd.i}

            /* DBO-XML-END */
            &ENDIF
        &ENDIF

    END /* TRANS_BLOCK */.

    &IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
        IF  VALID-HANDLE(hProgramDisable) THEN.
            DELETE PROCEDURE hProgramDisable.
    &ENDIF

    IF  cReturnValue = "NOK":U THEN
        RETURN "NOK":U.

    IF RETURN-VALUE = "NOK":U 

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */    
            OR lRepositionOldRecord 
            /* DBO-XML-END */
        &ENDIF
    &ENDIF
        THEN DO:
        /*--- Seta registro anterior ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rCurrentAux).
        &IF "{&NewRecordOffQuery}":U = "YES":U &THEN
            RETURN "OK":U.
        &ELSE
            RETURN "NOK":U.    
        &ENDIF
    END.

    /*--- Guarda rowid do £ltimo registro inclu¡do com sucesso 
          para reposicionamento, caso ocorra erro na inclusÆo 
          do pr¢ximo registro ---*/
    ASSIGN rCurrentAux = rCurrent.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Method-Library 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Elimina registro
  Parameters:  
  Notes:       Posiciona no pr¢ximo registro (getNext)
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLockAgain AS INTEGER NO-UNDO.
    DEFINE VARIABLE lExecute AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cReturnValue AS CHARACTER NO-UNDO INIT "OK":U.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        &IF ("{&XMLProducer}":U = "YES":U AND
                 "{&SOMessageBroker}":U <> "":U) OR 
                 "{&XMLReceiver}":U = "YES":U &THEN
        /* DBO-XML-BEGIN */
        
        {method/xmldef.i}

        {method/xmlini.i DELETE}

        /* DBO-XML-END */
        &ENDIF
    &ENDIF


    DO  iCounter = 2 TO 10:
        IF  INDEX(PROGRAM-NAME(iCounter), THIS-PROCEDURE:FILE-NAME) <> 0 THEN
            RUN emptyRowErrors IN THIS-PROCEDURE.    
    END.

    /* --- Verifica se o DBO deve efetuar as atualiza‡äes --- */
    RUN getExecuteUpdate (OUTPUT lExecute).

    /*--- Verifica a existˆncia de m‚todo de sobreposi‡Æo ---*/
    IF THIS-PROCEDURE:GET-SIGNATURE("deleteRecordOver":U) <> "":U THEN DO:
        RUN deleteRecordOver IN THIS-PROCEDURE.

        RETURN RETURN-VALUE.
    END.

    /*--- Verifica permissÆo de execu‡Æo ---*/
    {method/svc/security/permit.i &Method="Delete"}

    /*--- Executa valida‡äes (validateRecord) ---*/
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Delete":U).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

&IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
    DEFINE VARIABLE hProgramDisable AS HANDLE NO-UNDO.
    RUN {&TRIGGER-DISABLE-PROGRAM} PERSISTENT SET hProgramDisable.
&ENDIF
    TRANS_BLOCK:
    DO TRANSACTION:
        IF  lExecute THEN DO:
            /*--- Marca registro com exclusive-lock ---*/
            /* DBO-XML-BEGIN */
            /* Se a Query Dinamica estiver habilitada, usa o handle dela */

            &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
                hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
            &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
                /*
                &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                    FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                &ELSE
                    GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ENDIF
                */

                &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                    /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                    IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                        IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                            RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                        ELSE
                            FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                    END.
                    ELSE
                        GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ELSE
                    GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                &ENDIF
        /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */                        
/***********************************************/
            &ENDIF
            /* DBO-XML-END */

            /*--- Execu‡Æo de N (inicialmente 5) tentativas a fim de esperar o 
                  registro corrente ser desbloqueado ---*/
            DO WHILE LOCKED {&TableName}:
                IF LOCKED {&TableName} THEN
                    /* DBO-XML-BEGIN */
                    /* Se a Query Dinamica estiver habilitada, usa o handle dela */

                    &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
                        hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
                    &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
                /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
                        /*
                        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                            FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                        &ELSE
                            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ENDIF
                        */
                        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                            /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                            IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                                IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                                    RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                                ELSE
                                    FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                            END.
                            ELSE
                                GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ELSE
                            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                        &ENDIF
                /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
/***********************************************/
                    &ENDIF
                    /* DBO-XML-END */

                IF (NOT LOCKED {&TableName} AND NOT AVAILABLE {&TableName}) OR
                   (AVAILABLE {&TableName} AND NOT LOCKED {&TableName}) OR
                   (iLockAgain >= 5) THEN
                    LEAVE.

                ASSIGN iLockAgain = iLockAgain + 1.
            END.

            IF NOT AVAILABLE {&TableName} THEN DO:
                /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/
                {method/svc/errors/inserr.i &ErrorNumber="3"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
            ELSE IF LOCKED {&TableName} THEN DO:
                /*--- Erro 4: Registro da tabela {&TableLabel} est  bloqueado 
                              por outro usu rio ---*/
                {method/svc/errors/inserr.i &ErrorNumber="4"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
        END.

        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="Before"
                                        &Procedure="deleteRecord"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="beforedeleteRecord"}
        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN DO:
                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */
            /* Gera o documento XML para ser enviado pelo MessageBroker ---*/
            
            {method/xmlprp.i}

            /* DBO-XML-END */
            &ENDIF
        &ENDIF

        /* Caso o registro que esta sendo eliminado tenha sido reposicionado,
           eh necessario considerar o rowid do proximo registro como sendo o registro reposicionado */
        &IF "{&DBType}":U <> "PROGRESS":U &THEN
            IF lRepositioned = YES AND 
               r-reposition = ROWID({&TableName}) THEN
                ASSIGN r-reposition = ?.
        &ENDIF

        IF  lExecute THEN DO:
            /*--- Elimina registro ---*/
            DELETE {&TableName} NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {method/svc/errors/inserr.i &ErrorType="PROGRESS"
                                            &ErrorSubType="ERROR"}

                ASSIGN cReturnValue = "NOK":U.
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            END.
        END.

        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="After"
                                        &Procedure="deleteRecord"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="afterdeleteRecord"}
        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN
            UNDO, RETURN "NOK":U.

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN
            /* DBO-XML-BEGIN */
            /* Envia a Mensagem XML */
            /* Apos todas as validacoes locais, 
               envia mensagem para outros componentes via Message Broker 
               e desfaz a transa‡Æo se houver erro */
            
            {method/xmlsnd.i}

            /* DBO-XML-END */
            &ENDIF
        &ENDIF

    END /* TRANS_BLOCK */.
&IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
    IF  VALID-HANDLE(hProgramDisable) THEN.
        DELETE PROCEDURE hProgramDisable.
&ENDIF
    IF  cReturnValue = "NOK":U THEN
        RETURN "NOK":U.

    IF  lExecuteUpdate THEN DO:
        /*--- Posiciona no pr¢ximo registro ---*/
        RUN getNext IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.

    /* Caso o registro que esta sendo eliminado tenha sido reposicionado,
       eh necessario considerar o rowid do proximo registro como sendo o registro reposicionado */
    &IF "{&DBType}":U <> "PROGRESS":U &THEN
        IF lRepositioned = YES AND
           r-reposition = ? THEN
             ASSIGN r-reposition = ROWID({&TableName}).
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newRecord Method-Library 
PROCEDURE newRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cria registro, na temptable, com valores iniciais
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Limpa temptable RowObject ---*/
    RUN emptyRowObject IN THIS-PROCEDURE.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="Before"
                                    &Procedure="newRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Cria registro para temptable RowObject ---*/
    CREATE RowObject.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="After"
                                    &Procedure="newRecord"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Method-Library 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose:     Recebe uma mensagem XML do tipo DATASUL-MESSAGE e a efetiva
  Parameters:  pReceiveMessage  -> Mensagem sendo enviada
               pReturnMessage   -> Mensagem de retorno
  Notes:       
------------------------------------------------------------------------------*/
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
             "{&SOMessageBroker}":U <> "":U) OR 
             "{&XMLReceiver}":U = "YES":U &THEN

    DEF INPUT  PARAM pReceiveMessage AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM pReturnMessage  AS HANDLE NO-UNDO.
    DEF VAR h-genericAdapter AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-genericadapter) OR 
       h-genericadapter:TYPE      <> "PROCEDURE":U OR
       h-genericadapter:FILE-NAME <> "utp/ut-genadp.p":U OR
       h-genericadapter:FILE-NAME <> "utp/ut-genadp.r":U THEN
       RUN utp/ut-genadp.p PERSISTENT SET h-genericadapter.
    RUN setSource IN h-genericadapter (INPUT THIS-PROCEDURE).

    RUN receiveXMLMessage IN h-genericadapter (INPUT pReceiveMessage,
                                           OUTPUT pReturnMessage).
    &ENDIF
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Method-Library 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Grava registro
  Parameters:  
  Notes:       Executa valida‡äes (validateRecord)
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLockAgain AS INTEGER NO-UNDO.
    DEFINE VARIABLE cReturnValue AS CHARACTER NO-UNDO INIT "OK":U.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        &IF ("{&XMLProducer}":U = "YES":U AND
                 "{&SOMessageBroker}":U <> "":U) OR 
                 "{&XMLReceiver}":U = "YES":U &THEN
        /* DBO-XML-BEGIN */
    
        {method/xmldef.i}

        {method/xmlini.i UPDATE}

        /* DBO-XML-END */
        &ENDIF
    &ENDIF    
    DO  iCounter = 2 TO 10:
        IF  INDEX(PROGRAM-NAME(iCounter), THIS-PROCEDURE:FILE-NAME) <> 0 THEN
            RUN emptyRowErrors IN THIS-PROCEDURE.    
    END.

    /*--- Verifica a existˆncia de m‚todo de sobreposi‡Æo ---*/
    IF THIS-PROCEDURE:GET-SIGNATURE("updateRecordOver":U) <> "":U THEN DO:
        RUN updateRecordOver IN THIS-PROCEDURE.

        RETURN RETURN-VALUE.
    END.

    /*--- Verifica permissÆo de execu‡Æo ---*/
    {method/svc/security/permit.i &Method="Update"}

    /*--- Executa valida‡äes (validateRecord) ---*/
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Update":U).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Grava registro ---*/
&IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
    DEFINE VARIABLE hProgramDisable AS HANDLE NO-UNDO.
    RUN {&TRIGGER-DISABLE-PROGRAM} PERSISTENT SET hProgramDisable.
&ENDIF
    TRANS_BLOCK:
    DO TRANSACTION:
        /*--- Marca registro com exclusive-lock ---*/
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */

        &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
            hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            &ELSE
                GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
            &ENDIF
            */

            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                    IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                        RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                    ELSE
                        FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                END.
                ELSE
                    GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
            &ELSE
                GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
            &ENDIF
    /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
/***********************************************/
        &ENDIF
        /* DBO-XML-END */

        /*--- Execu‡Æo de N (inicialmente 5) tentativas a fim de esperar o 
              registro corrente ser desbloqueado ---*/
        DO WHILE LOCKED {&TableName}:
            IF LOCKED {&TableName} THEN
                /* DBO-XML-BEGIN */
                /* Se a Query Dinamica estiver habilitada, usa o handle dela */

                &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
                    hQuery:GET-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
                &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
            /*
                    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                        FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                    &ELSE
                        GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                    &ENDIF
            */        
                    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                        /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                        IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
                            IF THIS-PROCEDURE:GET-SIGNATURE("findCurrent":U + cQueryUseded) <> "":U THEN
                                RUN VALUE("findCurrent":U + cQueryUseded) IN THIS-PROCEDURE.
                            ELSE
                                FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                        END.
                        ELSE
                            GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                    &ELSE
                        GET CURRENT {&QueryName} EXCLUSIVE-LOCK NO-WAIT.
                    &ENDIF
    /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */                      
/***********************************************/
                &ENDIF

                /* DBO-XML-END */

            IF (NOT LOCKED {&TableName} AND NOT AVAILABLE {&TableName}) OR
               (AVAILABLE {&TableName} AND NOT LOCKED {&TableName}) OR
               (iLockAgain >= 5) THEN
                LEAVE.

            ASSIGN iLockAgain = iLockAgain + 1.
        END.

        /*Alterado por Anderson para controlar o erro de registro eliminado por outro 
            usu rio*/
        IF NOT AVAILABLE {&TableName} THEN DO:

             IF EXTENT(cErrorList) > 33 THEN DO:
                   /*---Erro 34: Registro eliminado por outro usu rio*/
                    {method/svc/errors/inserr.i &ErrorNumber="34"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}
              END.                                              
              ELSE DO:
                    /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/    
                    {method/svc/errors/inserr.i &ErrorNumber="3"
                                            &ErrorType="INTERNAL"
                                            &ErrorSubType="ERROR"}
              END.

              ASSIGN cReturnValue = "NOK":U.

              LEAVE TRANS_BLOCK.
              /*fim alteracao anderson*/
        END.
        ELSE IF LOCKED {&TableName} THEN DO:
            /*--- Erro 4: Registro da tabela {&TableLabel} est  bloqueado 
                          por outro usu rio ---*/
            {method/svc/errors/inserr.i &ErrorNumber="4"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}

            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.
        ELSE IF CURRENT-CHANGED {&TableName} THEN DO:
            /*--- Erro 12: Registro corrente j  foi alterado por outro usu rio ---*/
            {method/svc/errors/inserr.i &ErrorNumber="12"
                                        &ErrorType="INTERNAL"
                                        &ErrorSubType="ERROR"}

            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="Before"
                                        &Procedure="updateRecord"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.
        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="beforeupdateRecord"}
        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN

            /* DBO-XML-BEGIN */
            /* Gera o documento XML para ser enviado pelo MessageBroker ---*/
    
            {method/xmlprp.i}

            /* DBO-XML-END */
            &ENDIF
        &ENDIF

        /*--- Copia o registro da temptable RowObject para a tabela 
              {&TableName} (_copyTT2Buffer) ---*/
        RUN _copyTT2Buffer IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa m‚todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="After"
                                        &Procedure="updateRecord"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        /*--- Executa customiza‡Æo (before/after) ---*/
        {method/svc/custom/custom.i &Event="afterupdateRecord"}
        IF lCustomExecuted AND RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN cReturnValue = "NOK":U.
            UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
        END.

        &IF "{&DBType}":U <> "PROGRESS":U &THEN
        /*altera‡Æo valdir - 10/06/2004 - Atividade 114576*/
        VALIDATE {&TableName} NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN  DO:  /*se ocorreu algum erro*/
           DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO.
           DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*la‡o para todos os erros*/
               CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                   WHEN 132 OR /* registro j  existe */
                   WHEN 1502 THEN DO: /* registro deu erro no oracle, nÆo no progress*/
                        /*--- Erro 35: Registro j  cadastrado na tabela ---*/
                           {method/svc/errors/inserr.i
                                              &ErrorNumber="35"
                                              &ErrorType="INTERNAL"
                                              &ErrorSubType="ERROR"}
                        ASSIGN cReturnValue = "NOK":U.
                        UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                   END.

                   WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                        /*--- Erro 36: Valor do campo maior que o permitido. Consulte o 
                              arquivo Dataserv.lg para descobrir a tabela e o campo envolvidos. ---*/
                           {method/svc/errors/inserr.i
                                              &ErrorNumber="36"
                                              &ErrorType="INTERNAL"
                                              &ErrorSubType="ERROR"}
                        ASSIGN cReturnValue = "NOK":U.
                        UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                   END.

                   OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                        /*--- Erro 37: Ocorreu um erro no dataserver: &1 ---*/
                           {method/svc/errors/inserr.i
                                              &ErrorNumber="37"
                                              &ErrorType="INTERNAL"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters=ERROR-STATUS:GET-MESSAGE(iNumErro)}
                        ASSIGN cReturnValue = "NOK":U.
                        UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
                   END.
               END CASE.
           END.
        END.
        /*fim altera‡Æo valdir - 10/06/2004 - Atividade 114576*/
        &EndIF
        /*--- Marca registro com no-lock ---*/
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */

        &IF "{&DYNAMIC-QUERY-ENABLED}":U = "YES":U &THEN
            hQuery:GET-CURRENT(NO-LOCK).
        &ELSE
/************ Customizacao Datasul S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    /* FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
            /*
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                FIND CURRENT {&TableName} NO-LOCK NO-ERROR.
            &ELSE
                GET CURRENT {&QueryName} NO-LOCK.
            &ENDIF
            */
            &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                /*TECH14187 - FO 1489656 - corre‡Æo do teste para ver se usa FIND*/
                IF lookup(cQueryUseded,"{&CHANGE-QUERY-TO-FIND-PROCS}") > 0 THEN DO:
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
    /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY */  
/***********************************************/
        &ENDIF

        /* DBO-XML-END */

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            &IF ("{&XMLProducer}":U = "YES":U AND
                     "{&SOMessageBroker}":U <> "":U) OR 
                     "{&XMLReceiver}":U = "YES":U &THEN

        /* DBO-XML-BEGIN */
        /* Envia a Mensagem XML */
        /* Apos todas as validacoes locais, 
           envia mensagem para outros componentes via Message Broker 
           e desfaz a transa‡Æo se houver erro */

        {method/xmlsnd.i}

        /* DBO-XML-END */
            &ENDIF
        &ENDIF

     END /* TRANS_BLOCK */.
&IF  DEFINED(TRIGGER-DISABLE-PROGRAM) > 0 &THEN
    IF  VALID-HANDLE(hProgramDisable) THEN.
        DELETE PROCEDURE hProgramDisable.
&ENDIF

    IF  cReturnValue = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

