&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{include/i-prgvrs.i V01DPD611C 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.


def new global shared var v_rec_tit_acr as RECID format ">>>>>>9":U no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES amkt-solic-vl-bonific-tit-acr
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solic-vl-bonific-tit-acr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solic-vl-bonific-tit-acr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS amkt-solic-vl-bonific-tit-acr.cod_estab ~
amkt-solic-vl-bonific-tit-acr.cod_espec_docto ~
amkt-solic-vl-bonific-tit-acr.cod_ser_docto ~
amkt-solic-vl-bonific-tit-acr.cod_tit_acr ~
amkt-solic-vl-bonific-tit-acr.cod_parcela ~
amkt-solic-vl-bonific-tit-acr.valor ~
amkt-solic-vl-bonific-tit-acr.cod-usuario ~
amkt-solic-vl-bonific-tit-acr.data 
&Scoped-define ENABLED-TABLES amkt-solic-vl-bonific-tit-acr
&Scoped-define FIRST-ENABLED-TABLE amkt-solic-vl-bonific-tit-acr
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS amkt-solic-vl-bonific-tit-acr.cod_estab ~
amkt-solic-vl-bonific-tit-acr.cod_espec_docto ~
amkt-solic-vl-bonific-tit-acr.cod_ser_docto ~
amkt-solic-vl-bonific-tit-acr.cod_tit_acr ~
amkt-solic-vl-bonific-tit-acr.cod_parcela ~
amkt-solic-vl-bonific-tit-acr.valor ~
amkt-solic-vl-bonific-tit-acr.cod-usuario ~
amkt-solic-vl-bonific-tit-acr.data 
&Scoped-define DISPLAYED-TABLES amkt-solic-vl-bonific-tit-acr
&Scoped-define FIRST-DISPLAYED-TABLE amkt-solic-vl-bonific-tit-acr


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
sequencia||y|emsdocol.amkt-solic-vl-bonific-tit-acr.sequencia
cod-usuario||y|emsdocol.amkt-solic-vl-bonific-tit-acr.cod-usuario
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "sequencia,cod-usuario"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     amkt-solic-vl-bonific-tit-acr.cod_estab AT ROW 1.25 COL 15 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     amkt-solic-vl-bonific-tit-acr.cod_espec_docto AT ROW 1.25 COL 41 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     amkt-solic-vl-bonific-tit-acr.cod_ser_docto AT ROW 2.25 COL 15 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     amkt-solic-vl-bonific-tit-acr.cod_tit_acr AT ROW 2.25 COL 41 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     amkt-solic-vl-bonific-tit-acr.cod_parcela AT ROW 2.25 COL 63 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     amkt-solic-vl-bonific-tit-acr.valor AT ROW 3.75 COL 15 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     amkt-solic-vl-bonific-tit-acr.cod-usuario AT ROW 3.75 COL 41 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     amkt-solic-vl-bonific-tit-acr.data AT ROW 3.75 COL 63 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: emsdocol.amkt-solic-vl-bonific-tit-acr
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 78.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}
{dop/dpd611.i} //definicao temp-table orcamento

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       amkt-solic-vl-bonific-tit-acr.cod-usuario:READ-ONLY IN FRAME f-main        = TRUE.

ASSIGN 
       amkt-solic-vl-bonific-tit-acr.data:READ-ONLY IN FRAME f-main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME amkt-solic-vl-bonific-tit-acr.cod_espec_docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_espec_docto V-table-Win
ON F5 OF amkt-solic-vl-bonific-tit-acr.cod_espec_docto IN FRAME f-main /* Esp‚cie Documento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_espec_docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific-tit-acr.cod_espec_docto IN FRAME f-main /* Esp‚cie Documento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solic-vl-bonific-tit-acr.cod_estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_estab V-table-Win
ON F5 OF amkt-solic-vl-bonific-tit-acr.cod_estab IN FRAME f-main /* Estabelecimento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_estab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific-tit-acr.cod_estab IN FRAME f-main /* Estabelecimento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solic-vl-bonific-tit-acr.cod_parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_parcela V-table-Win
ON F5 OF amkt-solic-vl-bonific-tit-acr.cod_parcela IN FRAME f-main /* Parcela */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_parcela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific-tit-acr.cod_parcela IN FRAME f-main /* Parcela */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solic-vl-bonific-tit-acr.cod_ser_docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_ser_docto V-table-Win
ON F5 OF amkt-solic-vl-bonific-tit-acr.cod_ser_docto IN FRAME f-main /* S‚rie Documento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_ser_docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific-tit-acr.cod_ser_docto IN FRAME f-main /* S‚rie Documento */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solic-vl-bonific-tit-acr.cod_tit_acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_tit_acr V-table-Win
ON F5 OF amkt-solic-vl-bonific-tit-acr.cod_tit_acr IN FRAME f-main /* T¡tulo */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific-tit-acr.cod_tit_acr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific-tit-acr.cod_tit_acr IN FRAME f-main /* T¡tulo */
DO:
    RUN pi-zoom-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


amkt-solic-vl-bonific-tit-acr.cod_estab      :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME f-main.
amkt-solic-vl-bonific-tit-acr.cod_espec_docto:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME f-main.
amkt-solic-vl-bonific-tit-acr.cod_ser_docto  :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME f-main.
amkt-solic-vl-bonific-tit-acr.cod_tit_acr    :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME f-main.
amkt-solic-vl-bonific-tit-acr.cod_parcela    :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME f-main.

/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF
/************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "amkt-solic-vl-bonific-tit-acr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solic-vl-bonific-tit-acr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
RUN dispatch IN THIS-PROCEDURE("add-record").

ASSIGN amkt-solic-vl-bonific-tit-acr.cod-usuario:SCREEN-VALUE IN FRAME f-main = c-seg-usuario
       amkt-solic-vl-bonific-tit-acr.data       :SCREEN-VALUE IN FRAME f-main = STRING(TODAY).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
{include/i-valid.i}

FIND FIRST amkt-solic-vl-bonific NO-LOCK WHERE
           ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.

FIND FIRST amkt-solicitacao NO-LOCK WHERE
           amkt-solicitacao.numero = INT(amkt-solic-vl-bonific.documento) NO-ERROR.
IF NOT AVAIL amkt-solicitacao THEN DO:
    RUN dop/MESSAGE.p("NÆo encontrada Solicita‡Æo Mkt com C¢digo " + amkt-solic-vl-bonific.documento + ".", "").
    RETURN "ADM-ERROR".
END.

IF amkt-solicitacao.log-cancela THEN DO:
    RUN dop/MESSAGE.p("Solicita‡Æo Mkt est  cancelada.", "").
    RETURN "ADM-ERROR".
END.

IF amkt-solicitacao.log-encerra THEN DO:
    RUN dop/MESSAGE.p("Solicita‡Æo Mkt est  encerrada.", "").
    RETURN "ADM-ERROR".
END.

IF CAN-FIND(FIRST amkt-solic-vl-bonific-tit-acr NO-LOCK WHERE
                  amkt-solic-vl-bonific-tit-acr.sequencia       = amkt-solic-vl-bonific.sequencia                                  AND
                  amkt-solic-vl-bonific-tit-acr.cod_estab       = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_estab       AND
                  amkt-solic-vl-bonific-tit-acr.cod_espec_docto = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_espec_docto AND
                  amkt-solic-vl-bonific-tit-acr.cod_ser_docto   = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_ser_docto   AND
                  amkt-solic-vl-bonific-tit-acr.cod_tit_acr     = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_tit_acr     AND
                  amkt-solic-vl-bonific-tit-acr.cod_parcela     = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_parcela) THEN DO:
    RUN dop/MESSAGE.p("T¡tulo Contas a Receber j  vinculado.", "").
    RETURN "ADM-ERROR".
END.

FIND FIRST tit_acr NO-LOCK WHERE
           tit_acr.cod_estab       = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_estab       AND
           tit_acr.cod_espec_docto = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_espec_docto AND
           tit_acr.cod_ser_docto   = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_ser_docto   AND
           tit_acr.cod_tit_acr     = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_tit_acr     AND
           tit_acr.cod_parcela     = INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.cod_parcela     NO-ERROR.
IF NOT AVAIL tit_acr THEN DO:
    RUN dop/MESSAGE.p("T¡tulo Contas a Receber nÆo encontrado.", "").
    RETURN "ADM-ERROR".
END.

IF INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor = 0 OR
   INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor = ? THEN DO:
    RUN dop/MESSAGE.p("Valor nÆo informado.", "").
    RETURN "ADM-ERROR".
END.

IF INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor > tit_acr.val_sdo_tit_acr THEN DO:
    RUN dop/MESSAGE.p("Valor informado superior ao Saldo do T¡tulo Contas a Receber.", "").
    RETURN "ADM-ERROR".
END.

IF amkt-solic-vl-bonific.tipo-documento <> 2 /* VC - Abatimento */ THEN DO:
    RUN dop/MESSAGE.p("InclusÆo de T¡tulos permitida para Tipo '2 - VC - Abatimento'.", "").
    RETURN "ADM-ERROR".
END.

IF INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor > (amkt-solic-vl-bonific.vl-liberado - amkt-solic-vl-bonific.vl-realizado) THEN DO:
    RUN dop/MESSAGE.p("Valor informado superior ao Saldo da Libera‡Æo de Verba.", "").
    RETURN "ADM-ERROR".
END.

FIND FIRST amkt-forma-pagto NO-LOCK WHERE
           amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto NO-ERROR.
IF NOT AVAIL amkt-forma-pagto THEN DO:
    RUN dop/MESSAGE.p("NÆo encontrada Forma Pagamento da Solicita‡Æo Mkt " + STRING(amkt-solicitacao.numero) + ".", "").
    RETURN "ADM-ERROR".
END.

IF amkt-forma-pagto.tipo-pagto <> 2 /* Abatimento */ THEN DO:
    RUN dop/MESSAGE.p("Forma de Pagamento da Solicita‡Æo Mkt possui Tipo inv lido.",
                      "Tipo deve ser Abatimento.").
    RETURN "ADM-ERROR".
END.

FIND LAST amkt-solic-pagto NO-LOCK WHERE
          amkt-solic-pagto.numero         = amkt-solicitacao.numero AND
          amkt-solic-pagto.situacao-pagto = 2 /* aprovada */        NO-ERROR.
IF NOT AVAIL amkt-solic-pagto THEN DO:
    RUN dop/MESSAGE.p("NÆo foi encontrada Solicita‡Æo de Pagamento aprovada.",
                      "A Solicita‡Æo de Pagamento da Solicita‡Æo Mkt deve estar aprovada para permitir inclusÆo de t¡tulos.").
    RETURN "ADM-ERROR".
END.

IF INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor > amkt-solic-pagto.valor THEN DO:
    RUN dop/MESSAGE.p("Valor informado ‚ superior ao aprovado para a Solicita‡Æo Mkt", "").
    RETURN "ADM-ERROR".
END.

//busca dados para envio de informa‡Æo de centro de custos para or‡amento
FIND FIRST repres NO-LOCK WHERE
    repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.

FIND FIRST emitente NO-LOCK WHERE
    emitente.cod-emitente = amkt-solicitacao.cod-emitente NO-ERROR.

FIND FIRST sgv-seg-mercado NO-LOCK WHERE
    sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.

FIND FIRST dc-repres-gestor NO-LOCK WHERE
    dc-repres-gestor.cod-rep     = repres.cod-rep              AND
    dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.

FIND FIRST dc-regiao NO-LOCK WHERE
    dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.

run dop\dpdapi002.p (input amkt-solic-vl-bonific.documento,
                     input dc-regiao.cod-ccusto,
                     input "435362", //conta contabil
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_estab,      
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_espec_docto,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_ser_docto,  
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_tit_acr,    
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_parcela,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.valor,
                     input amkt-solic-vl-bonific.data-hora-lib,
                     OUTPUT TABLE tt_log_erros_alter_tit_acr). //gerar AVA no ACR


                         find first tt_log_erros_alter_tit_acr no-error.

                         if avail tt_log_erros_alter_tit_acr then do:
                            run dop/Message.p(tt_log_erros_alter_tit_acr.ttv_des_msg_erro, 
                                              tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda).
                            return 'ADM-ERROR'.
                         end.


//execucao or‡amentaria - Estorna o empenho criado na solicita‡Æo de pagamento.
//Verifica existencia de verba para realiza‡Æo dos valores.
// Realiza os valores empenhados na data.
run dop\dpdapi001.p (input dc-regiao.cod-ccusto,
                     input "9", //estabelecimento esta fixo, precisa olhar
                     input "DOC", //unidade de negocio esta fixa
                     input amkt-solic-vl-bonific.data-hora-lib,
                     input 0,  //moeda real
                     input INPUT FRAME f-main amkt-solic-vl-bonific-tit-acr.valor,
                     input 1,//sequencia 
                     input amkt-solic-vl-bonific.documento,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_espec_docto,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_estab,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_parcela,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_ser_docto,
                     input input frame f-main amkt-solic-vl-bonific-tit-acr.cod_tit_acr,
                     output table tt_log_erros).

                     find first tt_log_erros no-error.

                     if avail tt_log_erros then do:
                        run dop/Message.p(tt_log_erros.ttv_des_erro, 
                                          tt_log_erros.ttv_des_ajuda).
                                          return 'ADM-ERROR'.
                     end.



RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
    return 'ADM-ERROR':U.

// Soma realizado e encerra Verba Cooperada
FIND FIRST amkt-solic-vl-bonific EXCLUSIVE-LOCK WHERE
           ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.
ASSIGN amkt-solic-vl-bonific.vl-realizado = amkt-solic-vl-bonific.vl-realizado + amkt-solic-vl-bonific-tit-acr.valor.
FIND CURRENT amkt-solic-vl-bonific NO-LOCK NO-ERROR.

IF amkt-solic-vl-bonific.vl-realizado >= amkt-solic-vl-bonific.vl-liberado THEN DO:
    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = INT(amkt-solic-vl-bonific.documento) NO-ERROR.
    IF AVAIL amkt-solicitacao AND amkt-solicitacao.log-cancela = NO AND amkt-solicitacao.log-encerra = NO THEN DO:
        RUN dop/message2.p("Deseja encerrar a Verba Cooperada?","").
        IF RETURN-VALUE = "YES" THEN DO:
            FIND CURRENT amkt-solicitacao EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN amkt-solicitacao.cod-situacao     = "Solicita‡Æo Encerrada"
                   amkt-solicitacao.situacao-comprov = "Solicita‡Æo Encerrada"
                   amkt-solicitacao.situacao-pagto   = "Solicita‡Æo Encerrada"
                   amkt-solicitacao.log-encerra      = YES
                   amkt-solicitacao.usuario-encerra  = c-seg-usuario
                   amkt-solicitacao.dt-hr-encerra    = NOW.
            FIND CURRENT amkt-solicitacao NO-LOCK NO-ERROR.
            RUN dop/env-mail-mkt.p(amkt-solicitacao.numero).
        END.
    END.
END.

RELEASE amkt-solic-vl-bonific NO-ERROR.
RELEASE amkt-solicitacao      NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
RUN dispatch IN THIS-PROCEDURE("create-record").

FIND FIRST amkt-solic-vl-bonific NO-LOCK WHERE
           ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.
IF AVAIL amkt-solic-vl-bonific THEN
    ASSIGN amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
RUN dispatch IN THIS-PROCEDURE("display-fields").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

&if  defined(ADM-MODIFY-FIELDS) &then
if adm-new-record = yes then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
&endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-tit-acr V-table-Win 
PROCEDURE pi-zoom-tit-acr :
RUN prgfin/acr/acr212ka.p.

IF v_rec_tit_acr <> ? THEN DO:
    FIND FIRST tit_acr NO-LOCK WHERE
               RECID(tit_acr) = v_rec_tit_acr NO-ERROR.
    IF AVAIL tit_acr THEN
        ASSIGN amkt-solic-vl-bonific-tit-acr.cod_estab      :SCREEN-VALUE IN FRAME f-main = STRING(tit_acr.cod_estab)
               amkt-solic-vl-bonific-tit-acr.cod_espec_docto:SCREEN-VALUE IN FRAME f-main = STRING(tit_acr.cod_espec_docto)
               amkt-solic-vl-bonific-tit-acr.cod_ser_docto  :SCREEN-VALUE IN FRAME f-main = STRING(tit_acr.cod_ser_docto)
               amkt-solic-vl-bonific-tit-acr.cod_tit_acr    :SCREEN-VALUE IN FRAME f-main = STRING(tit_acr.cod_tit_acr)
               amkt-solic-vl-bonific-tit-acr.cod_parcela    :SCREEN-VALUE IN FRAME f-main = STRING(tit_acr.cod_parcela).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "sequencia" "amkt-solic-vl-bonific-tit-acr" "sequencia"}
  {src/adm/template/sndkycas.i "cod-usuario" "amkt-solic-vl-bonific-tit-acr" "cod-usuario"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "amkt-solic-vl-bonific-tit-acr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




