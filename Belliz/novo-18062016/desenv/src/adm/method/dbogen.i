&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library que contÇm a definiá∆o de mÇtodos genÇricos."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dbogen.i
    Purpose    : Method Library que contÇm a definiá∆o de mÇtodos genÇricos

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

&IF DEFINED(EXCLUDE-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy Method-Library 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:     Destr¢i o DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="before"
                                    &Procedure="destroy"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    DELETE PROCEDURE THIS-PROCEDURE.

    /*--- Executa mÇtodos sobrepostos (before/after) ---*/
    {method/svc/override/override.i &Position="after"
                                    &Procedure="destroy"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*--- Include com implementaá∆o do Serviáo de Seguranáa (Log Final de Execuá∆o) ---*/
    {method/svc/security/logfin.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowErrors Method-Library 
PROCEDURE emptyRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     Limpa temptable RowErrors
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowErrors:
        DELETE RowErrors.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyRowInfo Method-Library 
PROCEDURE emptyRowInfo :
/*------------------------------------------------------------------------------
  Purpose:     Limpa temptable RowInfo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowInfo EXCLUSIVE-LOCK:
        DELETE RowInfo.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProtocol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProtocol Method-Library 
PROCEDURE getProtocol :
/*------------------------------------------------------------------------------
  Purpose:     Retorna vers∆o do protocolo do DBO
  Parameters:  retorna protocolo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pProtocol AS CHARACTER NO-UNDO.

    ASSIGN pProtocol = "{&DBOProtocol}":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrors Method-Library 
PROCEDURE getRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     Retorna registros da temptable RowErrors
  Parameters:  retorna temptable RowErrors
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableName Method-Library 
PROCEDURE getTableName :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o nome da tabela principal do DBO
  Parameters:  retorna nome da tabela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pTableName AS CHARACTER NO-UNDO.

    ASSIGN pTableName = "{&TableName}":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selfInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selfInfo Method-Library 
PROCEDURE selfInfo :
/*------------------------------------------------------------------------------
  Purpose:     Retorna informaá‰es sobre DBO
  Parameters:  retorna temp-table RowInfo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowInfo.

    /*--- Limpa temp-table RowInfo ---*/
    RUN emptyRowInfo IN THIS-PROCEDURE.

    CREATE RowInfo.
    ASSIGN RowInfo.Code      = "Name":U
           RowInfo.CodeValue = "{&DBOName}":U.

    CREATE RowInfo.
    ASSIGN RowInfo.Code      = "Version":U
           RowInfo.CodeValue = "{&DBOVersion}":U.

    CREATE RowInfo.
    ASSIGN RowInfo.Code      = "TableName":U
           RowInfo.CodeValue = "{&TableName}":U.

    CREATE RowInfo.
    ASSIGN RowInfo.Code      = "Functions":U
           RowInfo.CodeValue = "{&DBOFunctions}":U.

    /*--- Popula informaá‰es espec°ficas sobre o DBO ---*/
    RUN _selfOthersInfo IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_insertError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _insertError Method-Library 
PROCEDURE _insertError :
/*------------------------------------------------------------------------------
  Purpose:     Insere registro na temptable RowErrors
  Parameters:  recebe n£mero do erro
               recebe tipo do erro (PROGRESS, INTERNAL, ...)
               recebe parÉmetros da mensagem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iErrorSequence     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cErrorSubType      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cErrorDescription  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cErrorHelp         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-complemento-erro AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iErrors AS INTEGER NO-UNDO.

    CASE pErrorType:
        WHEN "PROGRESS":U THEN DO iErrors = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cErrorDescription = "":U
                   cErrorHelp        = "":U.

            {method/svc/errors/errorspsc.i &ErrorNumber=ERROR-STATUS:GET-NUMBER(iErrors)
                                           &ErrorMessage=ERROR-STATUS:GET-MESSAGE(iErrors)
                                           &vErrorDescription=cErrorDescription
                                           &vErrorHelp=cErrorHelp}

            /*--- Atualiza vari†vel de seqÅància de erros ---*/
            IF CAN-FIND(LAST RowErrors) THEN DO:
                /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
                /** WBD: BEGIN_NULL_CODE **/                
                FIND LAST RowErrors.
                /** WBD: END_NULL_CODE **/
                /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/                
                ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
            END.
            ELSE
                ASSIGN iErrorSequence = iErrorSequence + 1.

            CREATE RowErrors.
            IF cErrorDescription <> "":U AND
               cErrorDescription <> ? THEN
                ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                       RowErrors.ErrorNumber      = pErrorNumber
                       RowErrors.ErrorType        = pErrorType
                       RowErrors.ErrorSubType     = pErrorSubType
                       RowErrors.ErrorDescription = cErrorDescription
                       RowErrors.ErrorHelp        = cErrorHelp
                       RowErrors.ErrorParameters  = pErrorParameters.
            ELSE
                ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                       RowErrors.ErrorNumber      = ERROR-STATUS:GET-NUMBER(iErrors)
                       RowErrors.ErrorType        = pErrorType
                       RowErrors.ErrorSubType     = pErrorSubType
                       RowErrors.ErrorDescription = ERROR-STATUS:GET-MESSAGE(iErrors)
                       RowErrors.ErrorHelp        = ?
                       RowErrors.ErrorParameters  = ?.
        END.

        WHEN "INTERNAL":U THEN DO:
            /*--- Atualiza vari†vel de seqÅància de erros ---*/
            IF CAN-FIND(LAST RowErrors) THEN DO:
                /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
                /** WBD: BEGIN_NULL_CODE **/                
                FIND LAST RowErrors.
                /** WBD: END_NULL_CODE **/
                /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/                
                ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
            END.
            ELSE
                ASSIGN iErrorSequence = iErrorSequence + 1.

            /*--- Somente pode existir um parÉmetros para erros internos, pois
                  n∆o Ç feito tratamento para mais de um erro ---*/
            &IF "{&DBType}":U = "PROGRESS":U &THEN
            IF pErrorNumber = 4 THEN
            DO:
                &IF DEFINED(TableName) <> 0 &THEN 
                    &IF "{&TableName}":U <> "":U &THEN
                        RUN utp/utAlias.p (INPUT "{&TableName}":U, INPUT RECID({&TableName}), INPUT THIS-PROCEDURE:DB-REFERENCES).
                        ASSIGN c-complemento-erro = ENTRY(1,RETURN-VALUE,',') + " na estaá∆o " + ENTRY(2,RETURN-VALUE,',').
                    &ELSE
                        ASSIGN c-complemento-erro = "n∆o identificado.".
                    &ENDIF
                &ELSE
                    ASSIGN c-complemento-erro = "n∆o identificado.".
                &ENDIF

            END.
            &ENDIF

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                   RowErrors.ErrorNumber      = pErrorNumber
                   RowErrors.ErrorType        = "INTERNAL":U
                   RowErrors.ErrorSubType     = pErrorSubType
                   RowErrors.ErrorDescription = SUBSTITUTE(cErrorList[pErrorNumber], pErrorParameters) + c-complemento-erro.
        END.

        OTHERWISE DO:
            {method/svc/errors/errors.i &ErrorNumber=pErrorNumber
                                        &ErrorParameters=pErrorParameters
                                        &vErrorSubType=cErrorSubType
                                        &vErrorDescription=cErrorDescription
                                        &vErrorHelp=cErrorHelp}

            /*--- Atualiza vari†vel de seqÅància de erros ---*/
            IF CAN-FIND(LAST RowErrors) THEN DO:
                /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
                /** WBD: BEGIN_NULL_CODE **/                
                FIND LAST RowErrors.
                /** WBD: END_NULL_CODE **/
                /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/                
                ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
            END.
            ELSE
                ASSIGN iErrorSequence = iErrorSequence + 1.

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                   RowErrors.ErrorNumber      = pErrorNumber
                   RowErrors.ErrorType        = pErrorType
                   RowErrors.ErrorSubType     = cErrorSubType
                   RowErrors.ErrorDescription = cErrorDescription
                   RowErrors.ErrorHelp        = cErrorHelp
                   RowErrors.ErrorParameters  = pErrorParameters.
        END.
    END.

    /* Deve ser criado um include para utilizar esta procedure */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_insertErrorManual) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _insertErrorManual Method-Library 
PROCEDURE _insertErrorManual :
/*------------------------------------------------------------------------------
  Purpose:     Insere registro na temptable RowErrors manualmente
  Parameters:  recebe n£mero do erro
               recebe tipo do erro (PROGRESS, INTERNAL, ...)
               recebe descriá∆o do erro
               recebe help do erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorDescription AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorHelp        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iErrorSequence AS INTEGER NO-UNDO.

    /*--- Atualiza vari†vel de seqÅància de erros ---*/
    IF CAN-FIND(LAST RowErrors) THEN DO:
        /** FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/
        /** WBD: BEGIN_NULL_CODE **/
        FIND LAST RowErrors.
        /** WBD: END_NULL_CODE **/
        /** FIM FO: 1591670 - Valdir - C¢digos do WBD a serem ignorados **/        
        ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
    END.
    ELSE
        ASSIGN iErrorSequence = iErrorSequence + 1.

    /** FO: 1591670 - Valdir - Eliminada vers∆o na 2.05, criamos o c¢digo
        para traduá∆o na 2.00 e prÇ-processamos. **/
    &IF "{&mguni_version}" >= "2.05"  &THEN
        /*chamada para traduzir o pErrorDescription*/
        run utp/ut-liter.p (input replace(pErrorDescription, " ", "_"),
                            input "",
                            input "") no-error.
        ASSIGN pErrorDescription = RETURN-VALUE.
    &ENDIF
    /** FIM FO: 1591670 - Valdir - Eliminada vers∆o na 2.05, criamos o c¢digo
        para traduá∆o na 2.00 e prÇ-processamos. **/


    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = iErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorType        = pErrorType
           RowErrors.ErrorSubType     = pErrorSubType
           RowErrors.ErrorDescription = pErrorDescription
           RowErrors.ErrorHelp        = pErrorHelp
           RowErrors.ErrorParameters  = pErrorParameters.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

