&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{include/i-prgvrs.i B02DPD611 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w

def var v-row-parent as rowid no-undo.
def var v-row-table  as rowid no-undo.

DEFINE VARIABLE i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE c-nome-emit    LIKE emitente.nome-emit    NO-UNDO.

DEF BUFFER b-amkt-solic-vl-bonific FOR amkt-solic-vl-bonific.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE BrowserCadastro2
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES amkt-solic-vl-bonific
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solic-vl-bonific


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solic-vl-bonific.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES amkt-solic-vl-bonific-tit-acr

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table amkt-solic-vl-bonific-tit-acr.valor ~
amkt-solic-vl-bonific-tit-acr.cod_estab ~
amkt-solic-vl-bonific-tit-acr.cod_espec_docto ~
amkt-solic-vl-bonific-tit-acr.cod_ser_docto ~
amkt-solic-vl-bonific-tit-acr.cod_tit_acr ~
amkt-solic-vl-bonific-tit-acr.cod_parcela fn-cdn_cliente() @ i-cod-emitente ~
fn-nome-emit() @ c-nome-emit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH amkt-solic-vl-bonific-tit-acr OF amkt-solic-vl-bonific WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH amkt-solic-vl-bonific-tit-acr OF amkt-solic-vl-bonific WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br-table amkt-solic-vl-bonific-tit-acr
&Scoped-define FIRST-TABLE-IN-QUERY-br-table amkt-solic-vl-bonific-tit-acr


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-incluir bt-eliminar 

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
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
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
DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      amkt-solic-vl-bonific-tit-acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      amkt-solic-vl-bonific-tit-acr.valor FORMAT ">>>,>>>,>>9.99":U
            WIDTH 11.43
      amkt-solic-vl-bonific-tit-acr.cod_estab COLUMN-LABEL "Estab" FORMAT "x(5)":U
            WIDTH 6.57
      amkt-solic-vl-bonific-tit-acr.cod_espec_docto COLUMN-LABEL "EspÇcie" FORMAT "x(3)":U
            WIDTH 6.43
      amkt-solic-vl-bonific-tit-acr.cod_ser_docto COLUMN-LABEL "SÇrie" FORMAT "x(3)":U
            WIDTH 6.43
      amkt-solic-vl-bonific-tit-acr.cod_tit_acr FORMAT "x(10)":U
            WIDTH 11.43
      amkt-solic-vl-bonific-tit-acr.cod_parcela FORMAT "x(2)":U
            WIDTH 6.43
      fn-cdn_cliente() @ i-cod-emitente COLUMN-LABEL "Cliente" FORMAT ">>>,>>>,>>9":U
            WIDTH 9.29
      fn-nome-emit() @ c-nome-emit COLUMN-LABEL "Nome" FORMAT "x(100)":U
            WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86 BY 7.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-incluir AT ROW 8.75 COL 1
     bt-eliminar AT ROW 8.75 COL 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: BrowserCadastro2
   External Tables: emsdocol.amkt-solic-vl-bonific
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.75
         WIDTH              = 86.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/browser.i}
{include/c-brows3.i}
{dop/dpd611.i}
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "emsdocol.amkt-solic-vl-bonific-tit-acr OF emsdocol.amkt-solic-vl-bonific"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > emsdocol.amkt-solic-vl-bonific-tit-acr.valor
"amkt-solic-vl-bonific-tit-acr.valor" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > emsdocol.amkt-solic-vl-bonific-tit-acr.cod_estab
"amkt-solic-vl-bonific-tit-acr.cod_estab" "Estab" ? "character" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > emsdocol.amkt-solic-vl-bonific-tit-acr.cod_espec_docto
"amkt-solic-vl-bonific-tit-acr.cod_espec_docto" "EspÇcie" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > emsdocol.amkt-solic-vl-bonific-tit-acr.cod_ser_docto
"amkt-solic-vl-bonific-tit-acr.cod_ser_docto" "SÇrie" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > emsdocol.amkt-solic-vl-bonific-tit-acr.cod_tit_acr
"amkt-solic-vl-bonific-tit-acr.cod_tit_acr" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > emsdocol.amkt-solic-vl-bonific-tit-acr.cod_parcela
"amkt-solic-vl-bonific-tit-acr.cod_parcela" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fn-cdn_cliente() @ i-cod-emitente" "Cliente" ">>>,>>>,>>9" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fn-nome-emit() @ c-nome-emit" "Nome" "x(100)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State("DblClick, SELF":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  /* run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar B-table-Win
ON CHOOSE OF bt-eliminar IN FRAME F-Main /* Eliminar */
DO:
    DEFINE VARIABLE r-aux  AS ROWID       NO-UNDO.
    DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.
    define variable num-sol as integer    no-undo.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = INT(amkt-solic-vl-bonific.documento) NO-ERROR.
               
    IF AVAIL amkt-solicitacao AND amkt-solicitacao.log-encerra THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o Mkt est† encerrada.", "").
        RETURN NO-APPLY.
    END.

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

    ASSIGN r-aux  = ROWID(amkt-solic-vl-bonific-tit-acr) WHEN AVAIL amkt-solic-vl-bonific-tit-acr
           de-aux = amkt-solic-vl-bonific-tit-acr.valor  WHEN AVAIL amkt-solic-vl-bonific-tit-acr.

          BUFFER-COPY amkt-solic-vl-bonific-tit-acr TO tt-amkt-solic-vl-bonific-tit-acr.
    RUN pi-eliminar.

    FIND FIRST amkt-solic-vl-bonific-tit-acr WHERE ROWID(amkt-solic-vl-bonific-tit-acr) = R-AUX NO-ERROR.
    IF NOT AVAIL amkt-solic-vl-bonific-tit-acr THEN DO:

    run pi-orcamento( input dc-regiao.cod-ccusto,
                      input "9",
                      input "DOC",
                      input amkt-solic-vl-bonific.data-hora-lib,
                      input 0,
                      input tt-amkt-solic-vl-bonific-tit-acr.valor,
                      input 1,
                      input amkt-solicitacao.numero,
                      input tt-amkt-solic-vl-bonific-tit-acr.cod_espec_docto,
                      input tt-amkt-solic-vl-bonific-tit-acr.cod_estab,
                      input tt-amkt-solic-vl-bonific-tit-acr.cod_parcela,
                      input tt-amkt-solic-vl-bonific-tit-acr.cod_ser_docto,
                      input tt-amkt-solic-vl-bonific-tit-acr.cod_tit_acr,
                      output TABLE tt_log_erros).

                      find first tt_log_erros no-error.

                      if avail tt_log_erros then do:
                        RUN dop/MESSAGE.p(tt_log_erros.ttv_des_erro, tt_log_erros.ttv_des_ajuda).
                        return 'nok'.
                      end.


                      EMPTY TEMP-TABLE tt-amkt-solic-vl-bonific-tit-acr.
    END.

    IF NOT AVAIL amkt-solic-vl-bonific-tit-acr OR
           AVAIL amkt-solic-vl-bonific-tit-acr AND ROWID(amkt-solic-vl-bonific-tit-acr) <> r-aux THEN DO:
        FIND FIRST b-amkt-solic-vl-bonific EXCLUSIVE-LOCK WHERE
                   ROWID(b-amkt-solic-vl-bonific) = ROWID(amkt-solic-vl-bonific) NO-ERROR.
        ASSIGN b-amkt-solic-vl-bonific.vl-realizado = b-amkt-solic-vl-bonific.vl-realizado - de-aux.
        RELEASE b-amkt-solic-vl-bonific NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir B-table-Win
ON CHOOSE OF bt-incluir IN FRAME F-Main /* Incluir */
DO:
    IF NOT(AVAIL amkt-solic-vl-bonific AND amkt-solic-vl-bonific.tipo-documento = 2 /* VC - Abatimento */ ) THEN DO:
        RUN dop/MESSAGE.p("Tipo de Documento n∆o permite inclus∆o de t°tulos.",
                          "Funá∆o Dispon°vel apenas para Tipo '2 - VC - Abatimento'.").
        RETURN NO-APPLY.
    END.

    RUN pi-Incmod ('incluir':U).
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
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

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
  {src/adm/template/row-list.i "amkt-solic-vl-bonific"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solic-vl-bonific"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
MESSAGE AVAIL amkt-solic-vl-bonific
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN dispatch IN THIS-PROCEDURE("delete-record").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-orcamento B-table-Win 
PROCEDURE pi-orcamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ccusto             as character no-undo.
def input param p-cod-estab          as character no-undo.
def input param p-cod-unid-negoc     as character no-undo.
def input param p-dat-transacao      as date      no-undo.
def input param p-cod-finalid-econ   as character no-undo.
def input param p-val-apropriacao     as decimal   no-undo.    
def input param p-num-seq            as integer   no-undo.
def input param p-cod-id             as character no-undo.
def input param p-espec-docto        as character no-undo.
def input param p-cod-estab-titulo   as character no-undo.
def input param p-cod-parcela        as character no-undo.
def input param p-serie              as character no-undo.
def input param p-cod-titulo         as character no-undo.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erros.
DEF VAR v_cod_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_cod_funcao   AS CHAR NO-UNDO.
DEF VAR v_cod_empresa  AS CHAR NO-UNDO.
DEF VAR v_orig_movto   AS CHAR NO-UNDO.
def var v_cod_refer    as char no-undo.
//rotina de estorno: variaveis da API padr∆o:
//tabelas estao na include dpd611.i.
empty temp-table tt_input_estorno.

run pi_retorna_sugestao_referencia (Input "T" /*l_l*/,
                                    Input today,
                                    output v_cod_refer) /*pi_retorna_sugestao_referencia*/.

      find first tit_acr no-lock where tit_acr.cod_estab = p-cod-estab
                                 and   tit_acr.cod_espec_docto = p-espec-docto
                                 and   tit_acr.cod_ser_docto   = p-serie
                                 and   tit_acr.cod_tit_acr     = p-cod-titulo
                                 and   tit_acr.cod_parcela     = p-cod-parcela no-error.

            if avail tit_acr then do:

            find LAST histor_movto_tit_acr no-lock where histor_movto_tit_acr.cod_estab = tit_acr.cod_estab
                                                    and   histor_movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                                    and   entry(1, histor_movto_tit_acr.des_text_histor, "|") = p-cod-id no-error.

                      if avail histor_movto_tit_acr then do:

                        find LAST movto_tit_acr no-lock where movto_tit_acr.cod_estab = histor_movto_tit_acr.cod_estab
                                                          and   movto_tit_acr.num_id_tit_acr = histor_movto_tit_acr.num_id_tit_acr
                                                          and   movto_tit_acr.cod_refer = entry(4, histor_movto_tit_acr.des_text_histor, "|")
                                                          AND   movto_tit_acr.ind_trans_acr = "Acerto Valor a Menor" no-error.

                                                          if avail movto_tit_acr then do:
                                          

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "N°vel"
                              tt_input_estorno.ttv_des_conteudo    = "Movimentos".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Operaá∆o"  
                              tt_input_estorno.ttv_des_conteudo    = "Estorno".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Estabelecimento" 
                              tt_input_estorno.ttv_des_conteudo = p-cod-estab.

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "Data" 
                              tt_input_estorno.ttv_des_conteudo = string(p-dat-transacao).

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Referància"
                              tt_input_estorno.ttv_des_conteudo = v_cod_refer.
                                                                              
                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "Hist¢rico" 
                              tt_input_estorno.ttv_des_conteudo = "Estorno de movimento automatico".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "ID Movimento" 
                              tt_input_estorno.ttv_des_conteudo = string(movto_tit_acr.num_id_movto_tit_acr).

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "ID Titulo" 
                              tt_input_estorno.ttv_des_conteudo = string(movto_tit_acr.num_id_tit_acr).

                    

                      run prgfin/acr/acr715zb.py (Input  1,
                                                Input  table tt_input_estorno,
                                                output table tt_log_erros_estorn_cancel).

                                                find first tt_log_erros_estorn_cancel no-error.

                                                if avail tt_log_erros_estorn_cancel then do:
                                                  RUN dop/MESSAGE.p(tt_log_erros_estorn_cancel.ttv_des_msg_erro, tt_log_erros_estorn_cancel.ttv_des_msg_ajuda).
                                                  return 'nok'.
                                                end.
                  end.
                end.
            END.
 

  assign v_cod_cta_ctbl = "435362". //por ora, nao definido local para informar conta 


      FIND FIRST param-global NO-ERROR.
      EMPTY TEMP-TABLE tt_xml_input_1.
      empty temp-table tt_log_erros.
  
          
  
      assign v_cod_empresa        =  param-global.empresa-prin //funciona apenas para docol.
             v_cod_funcao         = "Estorna" 
             v_orig_movto         = "91".
      
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Conta Cont†bil" /*l_conta_contabil*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
             tt_xml_input_1.ttv_des_conteudo = p-ccusto
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
             tt_xml_input_1.ttv_des_conteudo = p-cod-estab
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
             tt_xml_input_1.ttv_des_conteudo = p-cod-unid-negoc
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Data Movimentaá∆o" /*l_data_movimentacao*/ 
             tt_xml_input_1.ttv_des_conteudo = string(p-dat-transacao)
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econìmica" /*l_finalidade_economica*/ 
             tt_xml_input_1.ttv_des_conteudo = p-cod-finalid-econ
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
             tt_xml_input_1.ttv_des_conteudo = string(p-val-apropriacao)
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
             tt_xml_input_1.ttv_des_conteudo = v_orig_movto
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Funá∆o"
             tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
             tt_xml_input_1.ttv_des_conteudo = "Processo " + string(p-cod-id) + " Utilizado no titulo " + p-espec-docto + "|" + p-serie + "|" + p-cod-titulo +
                                                "|" + p-cod-parcela + "| Estabelec " + p-cod-estab-titulo
             tt_xml_input_1.ttv_num_seq_1    = p-num-seq.

      run prgfin/bgc/bgc700za.py (Input 1,
                                 input table tt_xml_input_1,
                                 output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.


END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

  /************************ Parameter Definition Begin ************************/

  def Input param p_ind_tip_atualiz
      as character
      format "X(08)"
      no-undo.
  def Input param p_dat_refer
      as date
      format "99/99/9999"
      no-undo.
  def output param p_cod_refer
      as character
      format "x(10)"
      no-undo.


  /************************* Parameter Definition End *************************/

  /************************* Variable Definition Begin ************************/

  def var v_des_dat                        as character       no-undo. /*local*/
  def var v_num_aux                        as integer         no-undo. /*local*/
  def var v_num_aux_2                      as integer         no-undo. /*local*/
  def var v_num_cont                       as integer         no-undo. /*local*/


  /************************** Variable Definition End *************************/

  assign v_des_dat   = string(p_dat_refer,"99999999")
         p_cod_refer = substring(v_des_dat,7,2)
                     + substring(v_des_dat,3,2)
                     + substring(v_des_dat,1,2)
                     + substring(p_ind_tip_atualiz,1,1)
         v_num_aux_2 = integer(this-procedure:handle).

  do  v_num_cont = 1 to 3:
      assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
             p_cod_refer = p_cod_refer + chr(v_num_aux).
  end.
END PROCEDURE. /* pi_retorna_sugestao_referencia */


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
  {src/adm/template/sndkycas.i "sequencia" "amkt-solic-vl-bonific-tit-acr" "sequencia"}
  {src/adm/template/sndkycas.i "cod-usuario" "amkt-solic-vl-bonific-tit-acr" "cod-usuario"}

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
  run pi-trata-state (p-issuer-hdl, p-state).
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



