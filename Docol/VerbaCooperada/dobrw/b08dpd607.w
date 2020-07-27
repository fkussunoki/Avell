&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{include/i-prgvrs.i B08DPD607 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-tipo-ajuste AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE c-nome-emit    LIKE emitente.nome-emit    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES amkt-solicitacao
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solicitacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solicitacao.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES amkt-solic-vl-bonific ~
amkt-solic-vl-bonific-tit-acr

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table amkt-solic-vl-bonific-tit-acr.valor amkt-solic-vl-bonific-tit-acr.cod_estab amkt-solic-vl-bonific-tit-acr.cod_espec_docto amkt-solic-vl-bonific-tit-acr.cod_ser_docto amkt-solic-vl-bonific-tit-acr.cod_tit_acr amkt-solic-vl-bonific-tit-acr.cod_parcela fn-cdn_cliente() @ i-cod-emitente fn-nome-emit() @ c-nome-emit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH amkt-solic-vl-bonific NO-LOCK WHERE                                  amkt-solic-vl-bonific.tipo-documento = 2 AND                                  amkt-solic-vl-bonific.documento      = STRING(amkt-solicitacao.numero), ~
                               EACH amkt-solic-vl-bonific-tit-acr NO-LOCK WHERE                              amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH amkt-solic-vl-bonific NO-LOCK WHERE                                  amkt-solic-vl-bonific.tipo-documento = 2 AND                                  amkt-solic-vl-bonific.documento      = STRING(amkt-solicitacao.numero), ~
                               EACH amkt-solic-vl-bonific-tit-acr NO-LOCK WHERE                              amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia.
&Scoped-define TABLES-IN-QUERY-br_table amkt-solic-vl-bonific ~
amkt-solic-vl-bonific-tit-acr
&Scoped-define FIRST-TABLE-IN-QUERY-br_table amkt-solic-vl-bonific
&Scoped-define SECOND-TABLE-IN-QUERY-br_table amkt-solic-vl-bonific-tit-acr


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table fi-vl-liberado fi-vl-realizado ~
fi-vl-saldo 
&Scoped-Define DISPLAYED-OBJECTS fi-vl-liberado fi-vl-realizado fi-vl-saldo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
sequencia||y|emsdocol.amkt-solic-vl-bonific-realiz.sequencia
nr-pedcli||y|emsdocol.amkt-solic-vl-bonific-realiz.nr-pedcli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "sequencia,nr-pedcli"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cdn_cliente B-table-Win 
FUNCTION fn-cdn_cliente RETURNS INTEGER() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-emit B-table-Win 
FUNCTION fn-nome-emit RETURNS CHARACTER() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-vl-liberado AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Liberado" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-realizado AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Realizado" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-saldo AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Saldo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      amkt-solic-vl-bonific, 
      amkt-solic-vl-bonific-tit-acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      amkt-solic-vl-bonific-tit-acr.valor     WIDTH 10
amkt-solic-vl-bonific-tit-acr.cod_estab       COLUMN-LABEL "Estab"
amkt-solic-vl-bonific-tit-acr.cod_espec_docto COLUMN-LABEL "Esp‚cie"
amkt-solic-vl-bonific-tit-acr.cod_ser_docto   COLUMN-LABEL "S‚rie"
amkt-solic-vl-bonific-tit-acr.cod_tit_acr     COLUMN-LABEL "T¡tulo"
amkt-solic-vl-bonific-tit-acr.cod_parcela     COLUMN-LABEL "Parcela"
fn-cdn_cliente() @ i-cod-emitente             COLUMN-LABEL "Cliente"
fn-nome-emit() @ c-nome-emit
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 62 BY 7.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     fi-vl-liberado AT ROW 2.5 COL 73 COLON-ALIGNED WIDGET-ID 6 NO-TAB-STOP 
     fi-vl-realizado AT ROW 3.5 COL 73 COLON-ALIGNED WIDGET-ID 2 NO-TAB-STOP 
     fi-vl-saldo AT ROW 4.5 COL 73 COLON-ALIGNED WIDGET-ID 4 NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: emsdocol.amkt-solicitacao
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.54
         WIDTH              = 87.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       fi-vl-liberado:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       fi-vl-realizado:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       fi-vl-saldo:READ-ONLY IN FRAME F-Main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH amkt-solic-vl-bonific NO-LOCK WHERE
                                 amkt-solic-vl-bonific.tipo-documento = 2 AND
                                 amkt-solic-vl-bonific.documento      = STRING(amkt-solicitacao.numero),
                        EACH amkt-solic-vl-bonific-tit-acr NO-LOCK WHERE
                             amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
    {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
    {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "amkt-solicitacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solicitacao"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
DEF BUFFER bpi-amkt-solic-vl-bonific FOR amkt-solic-vl-bonific.

RUN dispatch IN THIS-PROCEDURE('open-query').

ASSIGN fi-vl-liberado  = 0
       fi-vl-realizado = 0
       fi-vl-saldo     = 0.

/*IF AVAIL amkt-solic-vl-bonific THEN
    ASSIGN fi-vl-liberado  = amkt-solic-vl-bonific.vl-liberado
           fi-vl-realizado = amkt-solic-vl-bonific.vl-realizado
           fi-vl-saldo     = amkt-solic-vl-bonific.vl-liberado - amkt-solic-vl-bonific.vl-realizado.*/
// NDS 90730 - Apresenta valores liberados mesmo que ainda nÆo tenham sido realizados
FOR EACH bpi-amkt-solic-vl-bonific NO-LOCK WHERE
         bpi-amkt-solic-vl-bonific.tipo-documento = 2 /* amkt-solicitacao */ AND
         bpi-amkt-solic-vl-bonific.documento      = STRING(amkt-solicitacao.numero):
    ASSIGN fi-vl-liberado  = fi-vl-liberado  + bpi-amkt-solic-vl-bonific.vl-liberado
           fi-vl-realizado = fi-vl-realizado + bpi-amkt-solic-vl-bonific.vl-realizado.
END.
ASSIGN fi-vl-saldo = fi-vl-liberado - fi-vl-realizado.

DISP fi-vl-liberado
     fi-vl-realizado
     fi-vl-saldo
    WITH FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "sequencia" "amkt-solic-vl-bonific-realiz" "sequencia"}
  {src/adm/template/sndkycas.i "nr-pedcli" "amkt-solic-vl-bonific-realiz" "nr-pedcli"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "amkt-solicitacao"}
  {src/adm/template/snd-list.i "amkt-solic-vl-bonific"}
  {src/adm/template/snd-list.i "amkt-solic-vl-bonific-tit-acr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cdn_cliente B-table-Win 
FUNCTION fn-cdn_cliente RETURNS INTEGER():

IF NOT AVAIL amkt-solic-vl-bonific-tit-acr THEN RETURN 0.

FIND FIRST tit_acr NO-LOCK WHERE
           tit_acr.cod_estab       = amkt-solic-vl-bonific-tit-acr.cod_estab       AND
           tit_acr.cod_espec_docto = amkt-solic-vl-bonific-tit-acr.cod_espec_docto AND
           tit_acr.cod_ser_docto   = amkt-solic-vl-bonific-tit-acr.cod_ser_docto   AND
           tit_acr.cod_tit_acr     = amkt-solic-vl-bonific-tit-acr.cod_tit_acr     AND
           tit_acr.cod_parcela     = amkt-solic-vl-bonific-tit-acr.cod_parcela     NO-ERROR.
IF NOT AVAIL tit_acr THEN RETURN 0.

RETURN tit_acr.cdn_cliente.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-emit B-table-Win 
FUNCTION fn-nome-emit RETURNS CHARACTER():

IF NOT AVAIL amkt-solic-vl-bonific-tit-acr THEN RETURN "".

FIND FIRST tit_acr NO-LOCK WHERE
           tit_acr.cod_estab       = amkt-solic-vl-bonific-tit-acr.cod_estab       AND
           tit_acr.cod_espec_docto = amkt-solic-vl-bonific-tit-acr.cod_espec_docto AND
           tit_acr.cod_ser_docto   = amkt-solic-vl-bonific-tit-acr.cod_ser_docto   AND
           tit_acr.cod_tit_acr     = amkt-solic-vl-bonific-tit-acr.cod_tit_acr     AND
           tit_acr.cod_parcela     = amkt-solic-vl-bonific-tit-acr.cod_parcela     NO-ERROR.
IF NOT AVAIL tit_acr THEN RETURN "".

FIND FIRST emitente NO-LOCK WHERE
           emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
IF NOT AVAIL emitente THEN RETURN "".

RETURN emitente.nome-emit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

