&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN767C1 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin767c1 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin767c1
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-doc-pend-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin767.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt{&TableName}NO-UNDO
    LIKE {&TableName}
    FIELD rrowid AS ROWID.

/**  Outras Vari veis
**/
{inbo/boin767.i2}
{cdp/cd0666.i}
{utp/utapi019.i}
{utp/ut-glob.i}
{laphtml/mlahtml.i}

/**  Defini‡Æo de elementos referentes a UPC 
**/
{include/i-epc200.i "mlaapi100"}

DEFINE VARIABLE hmla-param-aprov         AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-doc-aprov      AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov         AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-chave-doc-aprov     AS HANDLE NO-UNDO.

DEFINE VARIABLE c-alternativo        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuar-trans        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-arq-email          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-arquivo-anexo      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-log                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-ass-e-mail         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-men-e-mail         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-chave              AS INTEGER    NO-UNDO.

DEFINE VARIABLE l-origem-envia-email   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-origem-nome-usuar    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-origem-e-mail        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-destino-recebe-email AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-destino-e-mail       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-destino-log-html     AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-usuar-origem         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-usuar-destino        AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-param-log-email        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-param-compl-email      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-param-servidor-email   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-param-porta-email      AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-param-log-aprov-altern AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-param-log-exchange     AS LOGICAL    NO-UNDO.

DEFINE VARIABLE c-tipo-doc-des-tip-doc   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-tipo-doc-log-html      AS LOGICAL    NO-UNDO.

DEFINE VARIABLE c-mla-log-acomp          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuar-origem           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuar-destino          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iRowsReturned            AS INTEGER    NO-UNDO.

DEFINE VARIABLE l-anexar-conteudo        AS LOGICAL     NO-UNDO.

{inbo/boin789.i "tt-mla-chave-doc-aprov"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.79
         WIDTH              = 19.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE(hmla-param-aprov) THEN
        DELETE PROCEDURE hmla-param-aprov.
    IF VALID-HANDLE(hmla-tipo-doc-aprov) THEN
        DELETE PROCEDURE hmla-tipo-doc-aprov.
    IF VALID-HANDLE(hmla-usuar-aprov) THEN
        DELETE PROCEDURE hmla-usuar-aprov.
    IF VALID-HANDLE(hmla-chave-doc-aprov) THEN
        DELETE PROCEDURE hmla-chave-doc-aprov.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorValidate DBOProgram 
PROCEDURE errorValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cd-erro  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem AS CHARACTER NO-UNDO.

    {utp/ut-liter.i p-mensagem}

    {method/svc/errors/inserr.i &ErrorNumber=STRING(p-cd-erro)
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=RETURN-VALUE}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBO DBOProgram 
PROCEDURE initializeBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(hmla-param-aprov) THEN DO:
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.
        run openQueryStatic in hmla-param-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-doc-aprov) THEN DO:
        RUN inbo/boin784.p PERSISTENT SET hmla-tipo-doc-aprov.
        run openQueryStatic in hmla-tipo-doc-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-chave-doc-aprov) THEN DO:
        RUN inbo/boin789.p PERSISTENT SET hmla-chave-doc-aprov.
        run openQueryStatic in hmla-chave-doc-aprov (input "Main").
        RUN getFirst IN hmla-chave-doc-aprov.
        RUN getBatchRecords IN hmla-chave-doc-aprov (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-chave-doc-aprov).
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov) THEN DO:
        RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
        run openQueryStatic in hmla-usuar-aprov (input "Main").
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeHandles DBOProgram 
PROCEDURE initializeHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-hmla-usuar-aprov        AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-tipo-doc-aprov     AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-param-aprov        AS HANDLE      NO-UNDO.  
    DEFINE INPUT PARAMETER p-hmla-chave-doc          AS HANDLE      NO-UNDO.  

    ASSIGN hmla-usuar-aprov     = p-hmla-usuar-aprov   
           hmla-tipo-doc-aprov  = p-hmla-tipo-doc-aprov
           hmla-param-aprov     = p-hmla-param-aprov   
           hmla-chave-doc-aprov = p-hmla-chave-doc.     
   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} 
        for each {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint DBOProgram 
PROCEDURE setConstraint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmail DBOProgram 
PROCEDURE setEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-usuar-origem   AS CHARACTER NO-UNDO.
    def input parameter p-usuar-destino  AS CHARACTER NO-UNDO.
    def input parameter p-tipo-envio     AS INTEGER   NO-UNDO.
    def input parameter p-mla-rowid-pend AS ROWID     NO-UNDO.   
    DEF INPUT PARAMETER p-mla-log-acomp  AS CHARACTER NO-UNDO.

    ASSIGN c-mla-log-acomp = p-mla-log-acomp
           c-usuar-origem  = p-usuar-origem
           c-usuar-destino = p-usuar-destino.

    IF c-mla-log-acomp = "NO":U THEN
        ASSIGN l-param-log-exchange = NO.


    /**  Pendˆncia
    **/
    FIND mla-doc-pend-aprov WHERE
        ROWID(mla-doc-pend-aprov) = p-mla-rowid-pend
        NO-LOCK NO-ERROR.
    
    /**  Origem
    **/
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = p-usuar-origem NO-ERROR.
    IF AVAIL mla-usuar-aprov THEN
        ASSIGN l-usuar-origem       = YES
               l-origem-envia-email = mla-usuar-aprov.envia-email
               c-origem-nome-usuar  = mla-usuar-aprov.nome-usuar
               c-origem-e-mail      = mla-usuar-aprov.e-mail.

    /**  Destino
    **/
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = p-usuar-destino NO-ERROR.
    IF AVAIL mla-usuar-aprov THEN
        ASSIGN l-usuar-destino        = YES
               l-destino-recebe-email = mla-usuar-aprov.recebe-email
               c-destino-e-mail       = mla-usuar-aprov.e-mail
               l-destino-log-html     = mla-usuar-aprov.log-html.

    /**  Parƒmetros
    **/
    FIND FIRST mla-param-aprov NO-LOCK
         WHERE mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
           AND mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel NO-ERROR.
    IF AVAIL mla-param-aprov THEN
        ASSIGN l-param-log-email        = mla-param-aprov.log-email
               c-param-compl-email      = mla-param-aprov.compl-email
               l-anexar-conteudo        = mla-param-aprov.log-atachado
               c-param-servidor-email   = mla-param-aprov.servidor-email
               i-param-porta-email      = mla-param-aprov.porta-email
               l-param-log-aprov-altern = mla-param-aprov.log-aprov-altern
               l-param-log-exchange     = mla-param-aprov.log-exchange WHEN c-mla-log-acomp <> "NO":U.

    /**  Tipo de Documento
    **/
    FIND FIRST mla-tipo-doc-aprov NO-LOCK 
         WHERE mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
           AND mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estab 
           AND mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN c-tipo-doc-des-tip-doc = mla-tipo-doc-aprov.des-tip-doc
               l-tipo-doc-log-html    = mla-tipo-doc-aprov.log-html.

    if  l-param-log-email      and
        l-usuar-origem         and 
        l-usuar-destino        and
        l-origem-envia-email   and 
        l-destino-recebe-email and
        c-destino-e-mail <> "" then do:

        find first moeda
             where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

        case p-tipo-envio:
            when 1 then do:
                ASSIGN c-usuar-trans = c-origem-nome-usuar.
                run utp/ut-msgs.p (input "msg", input 26593, input c-tipo-doc-des-tip-doc + "~~" +
                                                              mla-doc-pend-aprov.chave-doc + "~~" +
                                                              moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                              c-usuar-trans).
                assign c-ass-e-mail = return-value.
                run utp/ut-msgs.p (input "help", input 26593, input c-tipo-doc-des-tip-doc + "~~" +
                                                              mla-doc-pend-aprov.chave-doc + "~~" +
                                                              moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                              c-usuar-trans).
                assign c-men-e-mail = return-value.
            end.
            when 2 then do:
                ASSIGN c-usuar-trans = c-origem-nome-usuar.
                run utp/ut-msgs.p (input "msg", input 26635, input c-tipo-doc-des-tip-doc + "~~" +
                                                              mla-doc-pend-aprov.chave-doc + "~~" +
                                                              moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                              c-usuar-trans).
                assign c-ass-e-mail = return-value.
                run utp/ut-msgs.p (input "help", input 26635, input c-tipo-doc-des-tip-doc + "~~" +
                                                              mla-doc-pend-aprov.chave-doc + "~~" +
                                                              moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                              mla-doc-pend-aprov.narrativa-rej).
                assign c-men-e-mail = return-value.
            end.
        end.

        if  c-param-compl-email <> "" then
            assign c-men-e-mail = c-men-e-mail + CHR(10) + trim(c-param-compl-email).

        if  l-tipo-doc-log-html and 
            l-destino-log-html then do:

            RUN setEnviaEmailHTML IN THIS-PROCEDURE.

        END.
        else do:

            RUN setEnviaEmailTexto IN THIS-PROCEDURE.

        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailHTML DBOProgram 
PROCEDURE setEnviaEmailHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-anexo AS char   NO-UNDO.
    DEFINE VARIABLE DOc-html AS LONGCHAR NO-UNDO.
    /**  HTML
    **/
    EMPTY TEMP-TABLE tt-mensagem.
    ASSIGN c-anexo = "".

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail".
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "pi-envia-e-mail"}

        FIND FIRST tt-epc NO-LOCK  
             WHERE tt-epc.cod-event     = "pi-envia-e-mail" 
               AND tt-epc.cod-parameter = "arquivo-anexo" NO-ERROR.
            
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.

    {lap/mlaapi001.i01}
    create tt-mla-chave.
    assign i-chave = 0.
    for each  mla-chave-doc-aprov no-lock
        where mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc :
        assign i-chave                     = i-chave + 1
               tt-mla-chave.valor[i-chave] = substring(mla-doc-pend-aprov.chave-doc,
                                                       mla-chave-doc-aprov.posicao-ini,
                                                     ((mla-chave-doc-aprov.posicao-fim -
                                                       mla-chave-doc-aprov.posicao-ini) + 1)).
    END.

    IF  mla-doc-pend-aprov.cod-tip-doc < 10 THEN DO:
        RUN VALUE("laphtml/mlahtml00" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p")
                                       (input  mla-doc-pend-aprov.cod-tip-doc,
                                        input  c-usuar-destino,
                                        input  table tt-mla-chave,
                                        output DOc-html).
    END.
    ELSE DO:
        RUN VALUE("laphtml/mlahtml0" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p")
                                      (input  mla-doc-pend-aprov.cod-tip-doc,
                                       input  c-usuar-destino,
                                       input  table tt-mla-chave,
                                       output DOc-html).
    END.
    ASSIGN c-men-e-mail = "".
    
    /* Verifica o tamanho do email, para que nÆo ultrapasse 32kb. Se ultrapassar, ser  enviado o arquivo como anexo. */
    RUN verificaTamanhoEmail.

    if  l-anexar-conteudo then do:
/*         ASSIGN c-arq-email = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm". */
/*         OUTPUT TO VALUE(c-arq-email).                                                                                                                                                                */
/*         FOR EACH tt-mensagem :                                                                                                                                                                       */
/*             PUT UNFORMATTED tt-mensagem.mensagem SKIP.                                                                                                                                               */
/*         END.                                                                                                                                                                                         */
/*         OUTPUT CLOSE.                                                                                                                                                                                */
                    assign c-anexo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                    COPY-LOB FROM doc-html TO FILE c-anexo NO-CONVERT.




    end.

    EMPTY TEMP-TABLE tt-envio2.

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = l-param-log-exchange
           tt-envio2.destino     = c-destino-e-mail
           tt-envio2.assunto     = c-ass-e-mail
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = no
           tt-envio2.log-lida    = no
           tt-envio2.acomp       = no
           tt-envio2.formato     = "HTML".

    ASSIGN tt-envio2.servidor = c-param-servidor-email
           tt-envio2.porta    = i-param-porta-email.

    if  l-anexar-conteudo then
        assign tt-envio2.mensagem    = "Foi gerada uma pendˆncia de aprova‡Æo!" + CHR(10) +
                                       "Favor verificar o arquivo atachado."
               tt-envio2.arq-anexo   = c-anexo.    
        ELSE 
        ASSIGN tt-envio2.arq-anexo   = "".

    if  c-origem-e-mail <> "" then
        assign tt-envio2.remetente = c-origem-e-mail.

    
   /* /* Html para Palm */
    run lap/mlaapi012.p (input mla-doc-pend-aprov.ep-codigo,
                          input mla-doc-pend-aprov.cod-estabel,
                          input mla-doc-pend-aprov.cod-tip-doc,
                          input c-usuar-destino,
                          input table tt-mla-chave,
                          output c-arquivo-anexo).

    if  return-value = "OK" then do:
        if  tt-envio2.arq-anexo = "" then
            assign tt-envio2.arq-anexo = c-arquivo-anexo.
        else
            assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                       + c-arquivo-anexo.
    end.
    /*Fim Html para Palm*/*/

    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : " + STRING(tt-envio2.exchange) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : " + STRING(tt-envio2.servidor) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : " + STRING(tt-envio2.porta)    ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: " + STRING(tt-envio2.remetente)) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : " + STRING(tt-envio2.destino)  ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : " + STRING(tt-envio2.assunto)  ) NO-ERROR.

    run utp/utapi019.p persistent set h-utapi019.

    if  l-anexar-conteudo then
        run pi-execute  in h-utapi019 (input table tt-envio2,
                                       output table tt-erros).
    else
        run pi-execute2 in h-utapi019 (input table tt-envio2,
                                       INPUT TABLE tt-mensagem,
                                       output table tt-erros).

    FIND FIRST tt-erros NO-ERROR.
    IF  AVAILABLE tt-erros THEN do:
        LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + STRING(tt-erros.desc-erro)) NO-ERROR.
    END.
    
    delete procedure h-utapi019.

    if  l-anexar-conteudo then
        OS-DELETE value(c-arq-email).

    os-delete value(c-anexo).

    /**  Envia E-mail para os Alternativos
    **/
    if l-param-log-aprov-altern then do:

        RUN setEnviaEmailHTMLAltern IN THIS-PROCEDURE.

    end.
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailHTMLAltern DBOProgram 
PROCEDURE setEnviaEmailHTMLAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-anexo AS  CHAR   NO-UNDO.
    DEFINE VARIABLE DOc-html AS LONGCHAR NO-UNDO.

/*     ASSIGN c-anexo = "". */

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail".
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "pi-envia-e-mail"}

        FIND FIRST tt-epc NO-LOCK  
             WHERE tt-epc.cod-event     = "pi-envia-e-mail" 
               AND tt-epc.cod-parameter = "arquivo-anexo" NO-ERROR.
            
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.
    for each mla-usuar-aprov-altern where
             mla-usuar-aprov-altern.cod-usuar     = c-usuar-destino  and
             mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
             mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
        assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = c-alternativo NO-ERROR.
        IF AVAIL mla-usuar-aprov THEN
            ASSIGN c-destino-e-mail = mla-usuar-aprov.e-mail.

        EMPTY TEMP-TABLE tt-mensagem.

        VALIDATE mla-doc-pend-aprov.
        FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

        LOG-MANAGER:WRITE-MESSAGE (">>> Aprovador Alternativo: " + STRING(c-alternativo)) NO-ERROR.

        IF  mla-doc-pend-aprov.cod-tip-doc < 10 THEN DO:
            RUN VALUE("laphtml/mlahtml00" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p")
                                           (input  mla-doc-pend-aprov.cod-tip-doc,
                                            input  c-alternativo,
                                            input  table tt-mla-chave,
                                            output DOc-html).
        END.
        ELSE DO:
            RUN VALUE("laphtml/mlahtml0" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p")
                                          (input  mla-doc-pend-aprov.cod-tip-doc,
                                           input  c-alternativo,
                                           input  table tt-mla-chave,
                                           output DOc-html).
        END.
        ASSIGN c-men-e-mail = "".

        if  l-anexar-conteudo then do:
/*             ASSIGN c-arq-email = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm". */
/*             OUTPUT TO VALUE(c-arq-email).                                                                                                                                                                */
/*                                                                                                                                                                                                          */
/*             FOR EACH tt-mensagem :                                                                                                                                                                       */
/*                     PUT UNFORMATTED tt-mensagem.mensagem SKIP.                                                                                                                                           */
/*             END.                                                                                                                                                                                         */
/*             OUTPUT CLOSE.                                                                                                                                                                                */

                    assign c-anexo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                    COPY-LOB FROM doc-html TO FILE c-anexo NO-CONVERT.


        end.

        EMPTY TEMP-TABLE tt-envio2.

        create tt-envio2.
        assign tt-envio2.versao-integracao = 1
               tt-envio2.exchange    = l-param-log-exchange
               tt-envio2.destino     = c-destino-e-mail
               tt-envio2.assunto     = c-ass-e-mail
               tt-envio2.importancia = 2
               tt-envio2.log-enviada = no
               tt-envio2.log-lida    = no
               tt-envio2.acomp       = no
               tt-envio2.formato     = "HTML".

             ASSIGN tt-envio2.servidor = c-param-servidor-email
                    tt-envio2.porta    = i-param-porta-email.

        if l-anexar-conteudo then
            assign tt-envio2.mensagem    = "Foi gerada uma pendˆncia de aprova‡Æo!" + CHR(10) +
                                           "Favor verificar o arquivo atachado."
                   tt-envio2.arq-anexo   = c-anexo.
        else
            assign tt-envio2.arq-anexo   = "".

        if c-origem-e-mail <> "" then
           assign tt-envio2.remetente = c-origem-e-mail.

        /* Html para Palm */
        run lap/mlaapi012.p (input mla-doc-pend-aprov.ep-codigo,
                              input mla-doc-pend-aprov.cod-estabel,
                              input mla-doc-pend-aprov.cod-tip-doc,
                              input c-alternativo,
                              input table tt-mla-chave,
                              output c-arquivo-anexo).
        if  return-value = "OK" then do:
            if  tt-envio2.arq-anexo = "" then
                assign tt-envio2.arq-anexo = c-arquivo-anexo.
            else
                assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                           + c-arquivo-anexo.
        end.
        /*Fim Html para Palm*/

        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : " + STRING(tt-envio2.exchange) ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : " + STRING(tt-envio2.servidor) ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : " + STRING(tt-envio2.porta)    ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: " + STRING(tt-envio2.remetente)) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : " + STRING(tt-envio2.destino)  ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : " + STRING(tt-envio2.assunto)  ) NO-ERROR.

        run utp/utapi019.p persistent set h-utapi019.

        if l-anexar-conteudo then
            run pi-execute  in h-utapi019 (input table tt-envio2,
                                           output table tt-erros).
        else
            run pi-execute2 in h-utapi019 (input table tt-envio2,
                                           INPUT TABLE tt-mensagem,
                                           output table tt-erros).

        FIND FIRST tt-erros NO-ERROR.
        IF AVAILABLE tt-erros THEN do:
            LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro) NO-ERROR.
        end.

        delete procedure h-utapi019.

        if l-anexar-conteudo then
            OS-DELETE value(c-arq-email).

        os-delete value(c-anexo).
    end.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailTexto DBOProgram 
PROCEDURE setEnviaEmailTexto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**  Texto
    **/

    EMPTY TEMP-TABLE tt-envio.
    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange    = l-param-log-exchange
           tt-envio.destino     = c-destino-e-mail
           tt-envio.assunto     = c-ass-e-mail
           tt-envio.mensagem    = c-men-e-mail
           tt-envio.importancia = 2
           tt-envio.log-enviada = no
           tt-envio.log-lida    = no
           tt-envio.acomp       = no.
           tt-envio.arq-anexo   = "".

         ASSIGN tt-envio.servidor = c-param-servidor-email
                tt-envio.porta    = i-param-porta-email.

    if /*not l-param-log-exchange and*/ c-origem-e-mail <> "" then
       assign tt-envio.remetente = c-origem-e-mail.

    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.exchange : " + STRING(tt-envio.exchange) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.servidor : " + STRING(tt-envio.servidor) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.porta    : " + STRING(tt-envio.porta)    ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.remetente: " + STRING(tt-envio.remetente)) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.destino  : " + STRING(tt-envio.destino)  ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.assunto  : " + STRING(tt-envio.assunto)  ) NO-ERROR.

    run utp/utapi009.p (input  table tt-envio,
                        output table tt-erros).

    FIND FIRST tt-erros NO-ERROR.
    IF AVAILABLE tt-erros THEN do:
        LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro) NO-ERROR.
    end.

    /**  Envia E-mail para os Alternativos
    **/
    if l-param-log-aprov-altern then do:

        RUN setEnviaEmailTextoAltern IN THIS-PROCEDURE.

    end.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailTextoAltern DBOProgram 
PROCEDURE setEnviaEmailTextoAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     DEFINE VARIABLE c-anexo AS CHARACTER   NO-UNDO.
     DEFINE VARIABLE DOc-html AS LONGCHAR NO-UNDO.

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail".
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "pi-envia-e-mail"}

        FIND FIRST tt-epc NO-LOCK  
             WHERE tt-epc.cod-event     = "pi-envia-e-mail" 
               AND tt-epc.cod-parameter = "arquivo-anexo" NO-ERROR.
            
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.
    for each mla-usuar-aprov-altern where
        mla-usuar-aprov-altern.cod-usuar = c-usuar-destino and
            mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
            mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
        assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

        LOG-MANAGER:WRITE-MESSAGE (">>> Aprovador Alternativo: " + STRING(c-alternativo)) NO-ERROR.

        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = c-alternativo NO-ERROR.
        IF AVAIL mla-usuar-aprov THEN
            ASSIGN c-destino-e-mail = mla-usuar-aprov.e-mail.

        EMPTY TEMP-TABLE tt-envio.
        create tt-envio.
        assign tt-envio.versao-integracao = 1
               tt-envio.exchange    = l-param-log-exchange
               tt-envio.destino     = c-destino-e-mail
               tt-envio.assunto     = c-ass-e-mail
               tt-envio.mensagem    = c-men-e-mail
               tt-envio.importancia = 2
               tt-envio.log-enviada = no
               tt-envio.log-lida    = no
               tt-envio.acomp       = no.
               tt-envio.arq-anexo   = c-anexo.

         ASSIGN tt-envio.servidor = c-param-servidor-email
                tt-envio.porta    = i-param-porta-email.

        if not l-param-log-exchange and c-origem-e-mail <> "" then
           assign tt-envio.remetente = c-origem-e-mail.
        
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.exchange : " + STRING(tt-envio.exchange) ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.servidor : " + STRING(tt-envio.servidor) ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.porta    : " + STRING(tt-envio.porta)    ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.remetente: " + STRING(tt-envio.remetente)) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.destino  : " + STRING(tt-envio.destino)  ) NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.assunto  : " + STRING(tt-envio.assunto)  ) NO-ERROR.

        run utp/utapi009.p (input  table tt-envio,
                            output table tt-erros).

        FIND FIRST tt-erros NO-ERROR.
        IF AVAILABLE tt-erros THEN do:
            LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro) NO-ERROR.
        END.
    end.
               
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTamanhoEmail DBOProgram 
PROCEDURE verificaTamanhoEmail :
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT l-anexar-conteudo  THEN DO:
        FOR EACH tt-mensagem:
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-mensagem.mensagem).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

