&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library principal para DBOs, cont‚m defini‡äes, chamadas a outras Method Libraries e chamadas a includes de Servi‡os."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dbo.i
    Purpose    : Method Library principal para DBOs, cont‚m defini‡äes, 
                 chamadas a outras Method Libraries e chamadas a 
                 includes de Servi‡os

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOProtocol 2.0
&GLOBAL-DEFINE DBOFunctions Create,Delete,Update,Navigation,{&DBOCustomFunctions}

/*--- Include com defini‡Æo dos Servi‡os dispon¡veis para o DBO ---*/
{config/dbosvc.i}

/*--- Defini‡Æo de temp-tables ---*/
DEFINE TEMP-TABLE RowObjectAux NO-UNDO LIKE RowObject.

/*--- Defini‡Æo de vari veis padrÆo ---*/
{method/dboverr.i}


DEFINE VARIABLE cQueryUseded        AS CHARACTER NO-UNDO. /* Query utilizada no openQuery */
DEFINE VARIABLE lCustomExecuted     AS LOGICAL   NO-UNDO. /* Customiza‡Æo foi executada ? */
DEFINE VARIABLE lOverrideExecuted   AS LOGICAL   NO-UNDO. /* Override foi executado ? */
DEFINE VARIABLE lQueryOpened        AS LOGICAL   NO-UNDO  /* Query aberta ? */
    INITIAL NO.
DEFINE VARIABLE rFirstRowid         AS ROWID     NO-UNDO. /* Rowid do primeiro registro da Query */
DEFINE VARIABLE rLastRowid          AS ROWID     NO-UNDO. /* Rowid do £ltimo registro da Query */

&IF "{&DBType}":U <> "PROGRESS":U &THEN
/* vari veis usadas para navega‡Æo em banco diferente de Progress*/
    DEFINE VARIABLE lRepositioned       AS LOGICAL   NO-UNDO. /* Registro foi reposicionado ? (Usado com banco nÆo PROGRESS) */
    DEFINE VARIABLE r-reposition        AS ROWID     NO-UNDO. /* Rowid do registro reposicionado. Usado com banco nao Progress */
&ENDIF

/* Indica se o BO deve efetivar as atualiza‡äes. Deve ser setado para FALSE
   quando o BO estiver sendo chamado a partir de um gatilho de dicion rio. */
DEFINE VARIABLE lExecuteUpdate      AS LOGICAL   NO-UNDO INIT TRUE.


/* DBO-XML-BEGIN */
/* Usa Query Dinamica apenas a partir da V9 */
/* Handle da Query (Dinamica ou est tica) */
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &IF ("{&XMLProducer}":U = "YES":U AND
         "{&SOMessageBroker}":U <> "":U) OR 
         "{&XMLReceiver}":U = "YES":U &THEN
        /* A linha abaixo deve ser habilitada apenas ao final do prototipo do 
           projeto Componentizacao (XML), evitando que esta op‡Æo possa
           causar impacto imediato nos DBOs */
        /* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */
        DEFINE VARIABLE hQuery     AS HANDLE NO-UNDO.
    &ENDIF
&ENDIF

&IF DEFINED(DYNAMIC-QUERY-ENABLED) = 0 &THEN /* DBO nao ‚ Receveiver */
    /* Entao nao compila os m‚todos padrÆo a seguir: */
    &GLOBAL-DEFINE EXCLUDE-setQueryWhere
    &GLOBAL-DEFINE EXCLUDE-setQueryBy
    &GLOBAL-DEFINE EXCLUDE-setQueryFieldList
    &GLOBAL-DEFINE EXCLUDE-openQueryDynamic
&ENDIF
/* DBO-XML-END */

/* DBO-XML-BEGIN */
/*--- Tratamento de XML Receiver ---*/
&IF DEFINED(XMLReceiver) = 0 &THEN /* DBO nao ‚ Receveiver */
    /* Entao nao compila os m‚todos padrÆo a seguir: */
    &GLOBAL-DEFINE EXCLUDE-getRowErrorsXML
    &GLOBAL-DEFINE EXCLUDE-receiveMessage
    &GLOBAL-DEFINE EXCLUDE-setReceivingMessage
    &GLOBAL-DEFINE EXCLUDE-findRecordOFRowObject
&ENDIF
/* DBO-XML-END */

/*--- Include com defini‡Æo de vari veis globais para WEB ---*/
{utp/ut-dbowebglob.i}

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
&IF "{&EMS_DBTYPE}":U = "PROGRESS":U &THEN
    &IF DEFINED(CHANGE-QUERY-TO-FIND) <> 0 &THEN
        &UNDEFINE CHANGE-QUERY-TO-FIND
    &ENDIF
    /*  FO 1230361 - tech14207 - 18/08/2006  - Alterado para evitar problemas de queryïs com BY */
    &IF DEFINED(CHANGE-QUERY-TO-FIND-PROCS) <> 0 &THEN
        &UNDEFINE CHANGE-QUERY-TO-FIND-PROCS
    &ENDIF
    /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY  */    
&ELSE
    /*  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY  */
    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        IF NUM-ENTRIES("{&CHANGE-QUERY-TO-FIND-PROCS}") = 0 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="38"
                &ErrorType="Outros"
                &ErrorSubType="ERROR"
                &ErrorDescription="Objeto de Neg¢cio Irregular"
                &ErrorHelp="O preprocessador CHANGE-QUERY-TO-FIND-PROCS nÆo est  preenchido."}
            RETURN "NOK".
        END.
    &ENDIF
    /* Final Altera‡Æo -  FO 1230361 - tech14207 - 18/08/2006 - Alterado para evitar problemas de queryïs com BY  */
&ENDIF
/***********************************************/

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
         HEIGHT             = 5.67
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

/*--- Include com defini‡Æo da temp-table RowErrors ---*/
{method/dbotterr.i}


/*--- Include com defini‡Æo da temp-table RowRaw ---*/
{method/dbottraw.i}


/*--- Include com defini‡Æo da temp-table RowInfo ---*/
{method/dbottinf.i}


/*--- Include com defini‡Æo de vari veis/m‚todos referentes ao 
      Servi‡o de Autentica‡Æo ---*/
{method/svc/autentic/autdefs.i}


/*--- Include com defini‡Æo de vari veis/m‚todos referentes ao 
      Servi‡o de Erro ---*/
{method/svc/errors/errdefs.i}


/*--- Include com defini‡Æo de vari veis/m‚todos referentes ao 
      Servi‡o de Customiza‡Æo ---*/
{method/svc/custom/customdefs.i}


/*--- Include com defini‡Æo de vari veis/m‚todos referentes ao
      Servi‡o de Seguran‡a ---*/
{method/svc/security/sctrdefs.i}


/*--- Include com implementa‡Æo do Servi‡o de Seguran‡a (Seguran‡a para o 
      programa DBO) ---*/
{method/svc/security/security.i}


/*--- Include com implementa‡Æo do Servi‡o de Seguran‡a (Log Inicial de Execu‡Æo) ---*/
{method/svc/security/logini.i}

/* DBO-XML-BEGIN */
/*--- Include com definicao do mecanismo de MessageBroker ---*/
{method/svc/mb/mbdefs.i}

/*--- Include com inicializacao do mecanismo de MessageBroker ---*/
{method/svc/mb/mbinit.i}
/* DBO-XML-END */
    
/* Inicia XML Parser */
&IF ("{&XMLProducer}":U = "YES":U AND
     "{&SOMessageBroker}":U <> "":U) OR 
     "{&XMLReceiver}":U = "YES":U &THEN

    DEF NEW GLOBAL SHARED VAR hXMLParser AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(hXMLParser) OR 
       hXMLParser:TYPE      <> "PROCEDURE":U OR
       hXMLParser:FILE-NAME <> "utp/ut-xmlprs.p":U THEN
        RUN utp/ut-xmlprs.p PERSISTENT SET hXMLParser.

&ENDIF
/* DBO-XML-END */

/*--- Include com defini‡Æo de m‚todos gen‚ricos ---*/
{method/dbogen.i}


 /*--- Include com defini‡Æo de m‚todos referentes a Navega‡Æo ---*/ 
 {method/dbonav.i}                                                   


/*--- Include com defini‡Æo de m‚todos referentes a Create/Delete/Update ---*/
{method/dboupd.i}


/*--- Include com defini‡Æo de m‚todos diversos ---*/
{method/dbodiv.i}


/*--- Include com defini‡Æo de m‚todos proxy para BO 1.1 => DBO 2.0 ---*/
&IF NOT DEFINED(ProxyNotIncluded) <> 0 &THEN
    {method/dboproxy11.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


