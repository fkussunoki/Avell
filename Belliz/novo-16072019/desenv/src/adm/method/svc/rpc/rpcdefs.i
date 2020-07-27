&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m defini‡äes para Servi‡o de RPC."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/rpc/rpcdefs.i
    Purpose    : Include que cont‚m defini‡äes para Servi‡o de RPC

    Parameters :

    Author     :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Defini‡Æo de vari vel que cont‚m o handle global do DBO de RPC ---*/
DEFINE NEW GLOBAL SHARED VARIABLE hSORun AS HANDLE NO-UNDO. /* Handle SO RPC */


/*--- Defini‡Æo de vari veis auxiliares ---*/
DEFINE VARIABLE hServer      AS HANDLE    NO-UNDO. /* Handle APPServer */
DEFINE VARIABLE cServiceName AS CHARACTER NO-UNDO. /* Nome do service */
DEFINE VARIABLE cHostName    AS CHARACTER NO-UNDO. /* Nome do host */
DEFINE VARIABLE cNetworkType AS CHARACTER NO-UNDO. /* Tipo de protocolo de rede */

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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runDBO Include 
PROCEDURE runDBO :
/*------------------------------------------------------------------------------
  Purpose:     Executa DBO atrav‚s do recurso de RPC, quando dispon¡vel
  Parameters:  recebe nome do DBO
               retorna handle do DBO
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pDBO       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle AS HANDLE    NO-UNDO.

    CREATE SERVER hServer.

    GET-KEY-VALUE SECTION "TransactionServer":U
                  KEY "ServiceName":U
                  VALUE cServiceName.
    GET-KEY-VALUE SECTION "TransactionServer":U
                  KEY "HostName":U
                  VALUE cHostName.
    GET-KEY-VALUE SECTION "TransactionServer":U
                  KEY "NetworkType":U
                  VALUE cNetworkType.

    IF cServiceName <> "LOCAL":U THEN 
        hServer:CONNECT( "-S ":U + cServiceName + 
                        " -H ":U + cHostName + 
                        " -N ":U + cNetworkType).

    IF hServer:CONNECTED() THEN
        RUN VALUE(pDBO) PERSISTENT SET pDBOHandle ON SERVER hServer.
    ELSE
        RUN VALUE(pDBO) PERSISTENT SET pDBOHandle.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


