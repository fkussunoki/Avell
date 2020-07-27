&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library principal para DBOs, cont�m defini��es, chamadas a outras Method Libraries e chamadas a includes de Servi�os."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : method/dbofun.i
    Purpose    : Method Library principal para DBOs Function, cont�m 
                 defini��es, chamadas a outras Method Libraries e chamadas 
                 a includes de Servi�os

    Author     : John Cleber Jaraceski

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini��o ---*/
&GLOBAL-DEFINE DBOProtocol 2.0
&GLOBAL-DEFINE DBOFunctions {&DBOCustomFunctions}


/*--- Defini��o de vari�veis padr�o ---*/
{method/dboverr.i}

DEFINE VARIABLE lCustomExecuted     AS LOGICAL   NO-UNDO. /* Customiza��o foi executada ? */
DEFINE VARIABLE lOverrideExecuted   AS LOGICAL   NO-UNDO. /* Override foi executado ? */

/* DBO-XML-BEGIN */
/* Nao compila este m�todo no DBOFunction */
&GLOBAL-DEFINE EXCLUDE-getRowErrorsXML
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

/*--- Include com defini��o dos Servi�os dispon�veis para o DBO ---*/
{config/dbosvc.i}


/*--- Include com defini��o da temp-table RowErrors ---*/
{method/dbotterr.i}


/*--- Include com defini��o da temp-table RowRaw ---*/
{method/dbottraw.i}


/*--- Include com defini��o da temp-table RowInfo ---*/
{method/dbottinf.i}


/*--- Include com defini��o de vari�veis/m�todos referentes ao 
      Servi�o de Autentica��o ---*/
{method/svc/autentic/autdefs.i}


/*--- Include com defini��o de vari�veis/m�todos referentes ao 
      Servi�o de Erro ---*/
{method/svc/errors/errdefs.i}


/*--- Include com defini��o de vari�veis/m�todos referentes ao 
      Servi�o de Customiza��o ---*/
{method/svc/custom/customdefs.i}


/*--- Include com defini��o de vari�veis/m�todos referentes ao
      Servi�o de Seguran�a ---*/
{method/svc/security/sctrdefs.i}


/*--- Include com implementa��o do Servi�o de Seguran�a (Seguran�a para o 
      programa DBO) ---*/
{method/svc/security/security.i}


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
/*--- Include com defini��o de m�todos gen�ricos ---*/
{method/dbogen.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


