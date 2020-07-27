&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i v-3dcc108 9.99.99.999}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-digita
    FIELD nr-pedcli    like pre-fatur.nr-pedcli
    FIELD nr-sequencia like ped-item.nr-sequencia
    FIELD it-codigo    like ped-item.it-codigo
    FIELD desc-item    like ITEM.desc-item
    FIELD qt-pedida    like ped-item.qt-pedida     
    FIELD qt-alocada   like ped-item.qt-alocada
    FIELD qt-atendida  like ped-item.qt-atendida
    FIELD qt-saldo     AS DEC FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Qt Saldo"
    FIELD vl-tot-it    like ped-item.vl-tot-it
    FIELD vl-liq-abe   like ped-item.vl-liq-abe.

DEF TEMP-TABLE tt-imp    
    FIELD it-codigo      LIKE ITEM.it-codigo 
    FIELD desc-item      LIKE ITEM.desc-item
    FIELD num-pedido     LIKE ordem-compra.num-pedido
    FIELD numero-ordem   LIKE ordem-compra.numero-ordem
    FIELD qtde           AS DEC 
    FIELD valor          AS DEC
    FIELD cond-pagto     AS INT
    FIELD conta          AS INT FORMAT "999999999"
    FIELD sc-conta       AS INT FORMAT "999999999"
    FIELD narrativa      AS CHAR FORMAT "x(2000)"
    FIELD i-linha        AS INT
    FIELD erro           AS CHAR FORMAT "X(200)"
    INDEX id it-codigo i-linha.

{cdp/cd0666.i} /* Definiá∆o da tt-erro */

DEF VAR wh-pesquisa AS WIDGET-HANDLE.

DEF VAR i-numero-ordem LIKE ordem-compra.numero-ordem    NO-UNDO.
DEF VAR i-num-pedido   LIKE pedido-compr.num-pedido      NO-UNDO.
DEF VAR i-nr-processo  AS INTEGER                        NO-UNDO.
DEF VAR i-linha        AS INTEGER                        NO-UNDO.
DEF VAR c-linha        AS CHAR                           NO-UNDO.

DEF VAR i-prim-pedido LIKE param-compra.num-pedido-ini   NO-UNDO. 
DEF VAR i-ult-pedido  LIKE param-compra.num-pedido-fim   NO-UNDO.
DEF VAR i-nr-pedido   LIKE param-compra.num-pedido-fim   NO-UNDO.
DEF VAR c-cod_estab   AS CHAR                            NO-UNDO.
DEF VAR l-erro-imp    AS LOG INIT NO                     NO-UNDO.
DEF VAR d-soma-valor  AS DEC                             NO-UNDO.
DEF VAR v_cod_unid_negoc LIKE emsuni.unid_negoc.cod_unid_negoc NO-UNDO.

def new global shared var v_cod_usuar_corren    As Character    no-undo.
DEF VAR h_api_cta_ctbl    AS HANDLE  NO-UNDO.
DEF VAR h_api_ccusto      AS HANDLE  NO-UNDO.

def var v_des_cta_ctbl                  as char     no-undo.
def var v_num_tip_cta_ctbl              as char     no-undo. 
def var v_num_sit_cta_ctbl              as char     no-undo. 
def var v_ind_finalid_cta               as char     no-undo. 
def var v_log_utz_ccusto                as logical  no-undo.
DEF VAR v_cod_formato                   AS CHAR     NO-UNDO.
DEF VAR v_des_ccusto                    AS CHAR     NO-UNDO.
DEF VAR v_cod_ccusto                    AS CHAR     NO-UNDO.
DEF VAR l-erro                          AS LOG INIT NO NO-UNDO.
def var c-empresa    like ordem-compra.ep-codigo    no-undo.
DEF VAR v_cod_empresa_ems5   LIKE emsuni.empresa.cod_empresa        NO-UNDO.
DEF VAR v_cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto     NO-UNDO.
DEF VAR v_cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl NO-UNDO.


/* DEF VAR c-cod-estabel LIKE  estabelec.cod-estabel   NO-UNDO. */
DEF VAR c-estab-log                     AS CHARACTER   NO-UNDO.
DEF VAR l-permissao-estab               AS LOGICAL     NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
DEF VAR i-dias AS INTEGER NO-UNDO.
DEF VAR l-gerapedido AS LOGICAL     NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "Número"          column-label "Número"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistencia".

//temp-table para verba orcamentaria
def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

//temp-table para erro de verba orcamentaria
def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".



/*** Seguranáa por estabelecimento ***/
&scoped-define TTONLY YES    
{include/i-estab-security.i}
/*** Seguranáa por estabelecimento ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-imp
&Scoped-define BROWSE-NAME br-importar

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-imp

/* Definitions for BROWSE br-importar                                   */
&Scoped-define FIELDS-IN-QUERY-br-importar /* tt-imp.numero-ordem */ tt-imp.it-codigo tt-imp.desc-item tt-imp.qtde tt-imp.valor tt-imp.conta tt-imp.sc-conta tt-imp.erro tt-imp.narrativa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-importar   
&Scoped-define SELF-NAME br-importar
&Scoped-define QUERY-STRING-br-importar FOR EACH tt-imp NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-importar OPEN QUERY br-importar FOR EACH tt-imp NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-importar tt-imp
&Scoped-define FIRST-TABLE-IN-QUERY-br-importar tt-imp


/* Definitions for FRAME F-imp                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-imp ~
    ~{&OPEN-QUERY-br-importar}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-estabel fornec cond-pagto C-Arquivo ~
bt-ARQ-2 bt-valida-arquivo-importacao br-importar 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-estabel fornec ~
c-des-fornecedor cond-pagto c-des-cond-pagto responsavel C-Arquivo ~
d-valor-total 

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
</FOREIGN-KEYS
><EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ARQ-2 
     IMAGE-UP FILE "adeicon/no-file.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-importar 
     LABEL "Incluir Pedido" 
     SIZE 14 BY 1.13.

DEFINE BUTTON bt-valida-arquivo-importacao 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE C-Arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cond-pagto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-fornecedor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE cond-pagto AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Cond.Pagto" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-total AS DECIMAL FORMAT "->>>>>>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE fornec AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE responsavel AS CHARACTER FORMAT "X(12)":U 
     LABEL "Responsavel" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-importar FOR 
      tt-imp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-importar B-table-Win _FREEFORM
  QUERY br-importar NO-LOCK DISPLAY
      /*       tt-imp.numero-ordem COLUMN-LABEL "Ordem Compra" FORMAT "99999999":U */
      tt-imp.it-codigo    COLUMN-LABEL "Item"          FORMAT "x(16)":U  
      tt-imp.desc-item    COLUMN-LABEL "Descriá∆o"     FORMAT "X(30)":U
      tt-imp.qtde         COLUMN-LABEL "Qtde"          FORMAT ">>>>>,>>9.99":U 
      tt-imp.valor        COLUMN-LABEL "Preáo TOTAL"   FORMAT ">>>>>,>>>,>>9.99":U  
      tt-imp.conta        COLUMN-LABEL "Conta"         FORMAT ">>>>>>>>9":U 
      tt-imp.sc-conta     COLUMN-LABEL "Sub-Conta"     FORMAT ">>>>>>>>9":U
      tt-imp.erro         COLUMN-LABEL "Erro"          FORMAT "X(200)"
      tt-imp.narrativa    COLUMN-LABEL "Narrativa"     FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 115.29 BY 13
         FONT 1 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-imp
     c-cod-estabel AT ROW 1.17 COL 16 COLON-ALIGNED WIDGET-ID 42
     c-desc-estabel AT ROW 1.17 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fornec AT ROW 2.17 COL 16 COLON-ALIGNED WIDGET-ID 18
     c-des-fornecedor AT ROW 2.17 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     cond-pagto AT ROW 3.17 COL 16 COLON-ALIGNED WIDGET-ID 20
     c-des-cond-pagto AT ROW 3.17 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     responsavel AT ROW 4.17 COL 16 COLON-ALIGNED WIDGET-ID 12
     C-Arquivo AT ROW 5.17 COL 16 COLON-ALIGNED WIDGET-ID 28
     bt-ARQ-2 AT ROW 5 COL 72.29 WIDGET-ID 68
     bt-valida-arquivo-importacao AT ROW 4.92 COL 77 WIDGET-ID 70
     br-importar AT ROW 6.25 COL 1.72 WIDGET-ID 200
     bt-importar AT ROW 19.38 COL 2 WIDGET-ID 110
     d-valor-total AT ROW 19.5 COL 115.57 RIGHT-ALIGNED WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
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
         HEIGHT             = 19.58
         WIDTH              = 116.29.
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
/* SETTINGS FOR FRAME F-imp
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br-importar bt-valida-arquivo-importacao F-imp */
ASSIGN 
       FRAME F-imp:SCROLLABLE       = FALSE
       FRAME F-imp:HIDDEN           = TRUE.

ASSIGN 
       br-importar:COLUMN-RESIZABLE IN FRAME F-imp       = TRUE
       br-importar:COLUMN-MOVABLE IN FRAME F-imp         = TRUE.

/* SETTINGS FOR BUTTON bt-importar IN FRAME F-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cond-pagto IN FRAME F-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-fornecedor IN FRAME F-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME F-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-valor-total IN FRAME F-imp
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN responsavel IN FRAME F-imp
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-importar
/* Query rebuild information for BROWSE br-importar
     _START_FREEFORM
OPEN QUERY br-importar FOR EACH tt-imp NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _Where[1]         = "movind.pedido-compr.emergencial = yes and
movind.pedido-compr.responsavel = v_cod_usuar_corren"
     _Query            is OPENED
*/  /* BROWSE br-importar */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-imp
/* Query rebuild information for FRAME F-imp
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-imp */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-ARQ-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ARQ-2 B-table-Win
ON CHOOSE OF bt-ARQ-2 IN FRAME F-imp
DO:  
  
  DISABLE bt-importar WITH FRAME f-cad.

  def var cFile as char no-undo.
  def var l-ok  as logical no-undo.

  assign cFile = replace(input frame f-imp c-arquivo, "/", "~\").
  SYSTEM-DIALOG GET-FILE cFile
     FILTERS "*.csv" "*.csv",
             "*.*" "*.*"
     DEFAULT-EXTENSION "csv"
     INITIAL-DIR "c:\temp"
     MUST-EXIST
     USE-FILENAME
     UPDATE l-ok.
  if  l-ok = yes then
      assign c-arquivo:screen-value in frame f-imp  = replace(cFile, "~\", "/").
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar B-table-Win
ON CHOOSE OF bt-importar IN FRAME F-imp /* Incluir Pedido */
DO:
    RUN MESSAGE2.p (INPUT 'Confirma a importaá∆o ? ' ,
                    INPUT 'Ao termino apresentaremos o numero do pedido gerado, caso nao tenhamos erros que invalidem a geraá∆o.' ).
    IF RETURN-VALUE = "YES" THEN DO: 

        FIND FIRST tt-imp NO-LOCK
            WHERE tt-imp.erro <> "" NO-ERROR.
        IF AVAIL   tt-imp THEN DO:
            RUN dop/MESSAGE.p  (INPUT "Existem erros, arquivo de importacao !", "Verifique a descricao da coluna browser erro.").
            
            RETURN "NOK".
        END.
        ELSE DO:

            /* valida fornecedor  */
            FIND FIRST       emitente WHERE
                             emitente.cod-emitente = int(fornec:SCREEN-VALUE IN FRAME f-imp) NO-LOCK NO-ERROR.
            IF NOT AVAILABLE emitente THEN DO:
                  RUN utp/ut-msgs.p("show",17006,"Fornecedor nao encontrado !").
                  RETURN "NOK".
            END.        

            /* valida condicao de pagamento */
            FIND FIRST   cond-pagto WHERE
                         cond-pagto.cod-cond-pag = int(cond-pagto:SCREEN-VALUE IN FRAME f-imp) NO-LOCK NO-ERROR.
            IF NOT AVAIL cond-pagto THEN DO:
                 RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento nao encontrado !").
                 RETURN "NOK".
            END.

            FIND FIRST usuar-mater WHERE
                       usuar-mater.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
            IF NOT AVAIL usuar-mater THEN DO:
                RUN utp/ut-msgs.p("show",17006,"Usuario nao ≤ comprador ! ").
                RETURN "NOK".
            END.


              find first param-compra no-lock no-error.
              if  avail param-compra then do:
                  assign i-prim-pedido = param-compra.num-pedido-ini 
                         i-ult-pedido  = param-compra.num-pedido-fim.
              end.

              FIND last pedido-compr no-lock
                  WHERE pedido-compr.num-pedido <= i-ult-pedido no-error.
              if  avail pedido-compr then DO:
                  if (pedido-compr.num-pedido + 1) > i-ult-pedido or 
                     (pedido-compr.num-pedido + 1) < i-prim-pedido then 
                      assign i-nr-pedido = i-prim-pedido.
                  ELSE 
                      assign i-nr-pedido = pedido-compr.num-pedido + 1.
              END.
              ELSE 
                  assign i-nr-pedido = i-prim-pedido.

            /* geracao do processo de compras */
  /*           FIND LAST proc-compra  NO-LOCK NO-ERROR.                                */
  /*           IF AVAIL  proc-compra  THEN DO:                                         */
  /*                                                                                   */
  /*              ASSIGN i-nr-processo = proc-compra.nr-processo + 1.                  */
  /*                                                                                   */
  /*              create proc-compra.                                                  */
  /*              assign proc-compra.nr-processo  = i-nr-processo                      */
  /*                     proc-compra.cod-comprado = v_cod_usuar_corren                 */
  /*                     proc-compra.dt-inicio    = TODAY                              */
  /*                     proc-compra.descricao    = "geraá∆o Processo compras dcc108". */
  /*              &if defined(bf_mat_contratos) &then                                  */
  /*                  assign substr(proc-compra.char-1,1,3) = c-cod_estab.             */
  /*              &endif                                                               */
  /*           END.                                                                    */


              ASSIGN l-gerapedido = NO.

              FIND FIRST tt-imp NO-LOCK NO-ERROR.
              IF AVAIL tt-imp THEN DO:

                /* inicio leitura da tt-imp para geracao do pedido de compra emergencial */    
                  EMPTY TEMP-TABLE tt-erro.
                  ASSIGN d-soma-valor = 0.
                  /* percorre os registros importados sem ocorrencia de erro , identificado antes da execucao */
                FOR EACH tt-imp WHERE tt-imp.erro = "" NO-LOCK:
                //valida novamente a execucao orcamentaria, para verificar se ainda ha verba disponivel

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label       = "Funá∆o"
                           tt_xml_input_1.tt_des_conteudo    = "Verifica"
                           tt_xml_input_1.tt_num_seq_1_xml   = 1
                           tt_xml_input_1.tt_num_seq_2_xml   = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label       = "Empresa"
                           tt_xml_input_1.tt_des_conteudo    = c-empresa
                           tt_xml_input_1.tt_num_seq_1_xml   = 1
                           tt_xml_input_1.tt_num_seq_2_xml   = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
                           tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.conta )
                           tt_xml_input_1.tt_num_seq_1_xml   = 1
                           tt_xml_input_1.tt_num_seq_2_xml   = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                           tt_xml_input_1.tt_des_conteudo    = STRING(c-cod-estabel:SCREEN-VALUE IN FRAME f-imp)
                           tt_xml_input_1.tt_num_seq_1_xml   = 1
                           tt_xml_input_1.tt_num_seq_2_xml   = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                           tt_xml_input_1.tt_des_conteudo   = STRING(TODAY)
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                           tt_xml_input_1.tt_des_conteudo   = "0"
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                           tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.valor)
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                           tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.qtde)
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                           tt_xml_input_1.tt_des_conteudo   = "18" //cotacao, nao Ç possivel usar o customizado
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                           tt_xml_input_1.tt_des_conteudo   = STRING(i-numero-ordem) + chr(10) + "1"
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                           tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                           tt_xml_input_1.tt_num_seq_1_xml  = 1
                           tt_xml_input_1.tt_num_seq_2_xml  = 0.

                    create tt_xml_input_1.
                    assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                           tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.sc-conta)
                           tt_xml_input_1.tt_num_seq_1_xml   = 1
                           tt_xml_input_1.tt_num_seq_2_xml   = 0.


                    RUN prgfin/bgc/bgc700za.py (input 1,
                                                input table tt_xml_input_1,
                                                output table tt_log_erros) .  

                    FIND FIRST tt_log_erros NO-LOCK NO-ERROR.

                    IF AVAIL tt_log_erros THEN DO:

                           CREATE tt-erro.
                           ASSIGN tt-erro.i-sequen =  tt_log_erros.ttv_num_seq
                                  tt-erro.cd-erro  =  tt_log_erros.ttv_num_cod_erro.
                           ASSIGN tt-imp.erro =  tt-imp.erro + " - " + tt_log_erros.ttv_des_ajuda.
                    END.

                    ELSE DO:
                        
                    RUN dop/dco002a.p (INPUT  tt-imp.it-codigo,                              /* tt-comprar.it-codigo, */
                                       INPUT  tt-imp.qtde,                                   /* tt-comprar.qt-comprar, */
                                       INPUT  TODAY,                                         /* tt-comprar.dt-entrega, */
                                       INPUT  0,                                             /* Ordem de Producao*/
                                       INPUT  tt-imp.conta,                                  /* ct-codigo - Conta Contabil */
                                       INPUT  tt-imp.sc-conta,                               /* sc-codigo - conta contabil */
                                       INPUT  2,                                             /* Natureza - 1-Compra, 2-Servico e 3-Beneficiamento */
                                       INPUT  1,                                             /* i-codigo-icm 1-consumo 2-industrializacao */
                                       INPUT  tt-imp.narrativa,                              /* tt-comprar.comentario , */
                                       INPUT  tt-imp.narrativa,                              /* tt-compras.narrativa  */
                                       INPUT  tt-imp.i-linha,                                /* tt-comprar.num-seq-item, */
                                       INPUT  int(fornec:SCREEN-VALUE IN FRAME f-imp),       /* fornecedor */
                                       INPUT  tt-imp.valor,                                  /* preco-cotacao */
                                       INPUT  int(cond-pagto:SCREEN-VALUE IN FRAME f-imp),   /* condicao de pagamento */
                                       INPUT  v_cod_usuar_corren,                            /* comprador */    
                                       INPUT  0,                                             /* nr-processo */
                                       INPUT  i-nr-pedido ,                                  /* num-pedido se for informado 0 sera criado um novo pedido, se for informado o nr utiliza o mesmo */
                                       INPUT  "dcc108",                                      /* programa chamador */
                                       INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME f-imp,
                                       OUTPUT i-numero-ordem,                                /* retorno nr ordem compra gerada */                                     
                                       OUTPUT i-num-pedido,                                  /* retorno nr pedido compra gerado */
                                       OUTPUT TABLE tt-erro).                                /* retorno erro */
                    
                    ASSIGN d-soma-valor = d-soma-valor + tt-imp.valor.
    
                    FIND FIRST tt-erro NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt-erro THEN DO: 
                        
                            ASSIGN tt-imp.numero-ordem = i-numero-ordem.
    
    
                        //cria empenho de verba de execucao orcamentaria
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Funá∆o"
                               tt_xml_input_1.tt_des_conteudo    = "Atualiza"
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Empresa"
                               tt_xml_input_1.tt_des_conteudo    = c-empresa
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
                               tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.conta )
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                               tt_xml_input_1.tt_des_conteudo    = STRING(c-cod-estabel:SCREEN-VALUE IN FRAME f-imp)
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                               tt_xml_input_1.tt_des_conteudo   = STRING(TODAY)
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                               tt_xml_input_1.tt_des_conteudo   = "0"
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                               tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.valor)
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                               tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.qtde)
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                               tt_xml_input_1.tt_des_conteudo   = "18" //cotacao, nao Ç possivel usar o customizado
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                               tt_xml_input_1.tt_des_conteudo   = STRING(i-numero-ordem) + chr(10) + "1"
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                               tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
    
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                               tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.sc-conta)
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
    
                        RUN prgfin/bgc/bgc700za.py (input 1,
                                                    input table tt_xml_input_1,
                                                    output table tt_log_erros) .  
    
                            FIND FIRST tt_log_erros NO-LOCK NO-ERROR.
        
                            IF AVAIL tt_log_erros THEN DO:
                                   ASSIGN tt-imp.erro =  tt-imp.erro + " - " + tt_log_erros.ttv_des_ajuda.
                            END.
                        END.
                    END.
                END.
    
                /* verifica se retornou algum erro ao processar a api de geracao de pedidos de compras */
                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-erro THEN DO:
                    RUN dop/MESSAGE3.p  (INPUT "Pedido Compra Gerado com sucesso !", " Pedido Compra: " + STRING(i-nr-pedido  ) + " Valor: " + STRING(d-soma-valor) ).  
    
                    /* RUN utp/ut-msgs.p("show",17006,"Pedido Compra Gerado com sucesso !" + "~~" +   " Pedido Compra: " + STRING(i-nr-pedido  ) + " Valor: " + STRING(d-soma-valor) ). */
    
                    ASSIGN fornec:SCREEN-VALUE IN FRAME f-imp = ""
                           c-des-fornecedor:SCREEN-VALUE IN FRAME f-imp = ""
                           cond-pagto:SCREEN-VALUE IN FRAME f-imp = ""
                           c-des-cond-pagto:SCREEN-VALUE IN FRAME f-imp = ""
                           c-arquivo:SCREEN-VALUE IN FRAME f-imp = "" 
                           d-valor-total:SCREEN-VALUE IN FRAME f-imp = "".
    
                   EMPTY TEMP-TABLE tt-imp.  
    
                   OPEN QUERY br-importar FOR EACH tt-imp NO-LOCK  .
    
                END.
                ELSE DO:
    
                    RUN dop/MESSAGE.p  (INPUT "Existem erros, arquivo de importacao !", "Verifique a descricao da coluna browser.").  
    
                    /* RUN utp/ut-msgs.p("show",17006,"Existem erros, arquivo de importacao !" + "~~" + "Verifique a descricao da coluna browser." ). */
     
                    OPEN QUERY br-importar FOR EACH tt-imp NO-LOCK.

                END.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-valida-arquivo-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-valida-arquivo-importacao B-table-Win
ON CHOOSE OF bt-valida-arquivo-importacao IN FRAME F-imp
DO:
    RUN MESSAGE2.p (INPUT 'Confirma a validaá∆o DO arquivo de importaá∆o ? ' ,
                    INPUT 'Ao termino apresentaremos os registros processados, caso apresente alguma validacao dos registros, verifique a coluna erro.' ).

    IF RETURN-VALUE = "YES" THEN DO: 
        
        DISABLE bt-importar WITH FRAME f-imp.
        ASSIGN l-erro-imp = NO.
        RUN pi-valida (OUTPUT l-erro-imp).
        IF l-erro-imp = YES THEN DO:
            RETURN "NOK".
        END.

        IF SEARCH(c-arquivo:SCREEN-VALUE IN FRAME f-imp) = ? THEN DO:
            RUN MESSAGE.p(INPUT "Arquivo nao encontrado !",
                          INPUT "").
            APPLY "entry" TO c-arquivo IN FRAME F-imp.
            RETURN "NOK".
        END.
        ELSE DO:

            IF ENTRY(NUM-ENTRIES(c-arquivo:SCREEN-VALUE IN FRAME f-imp, "."), c-arquivo:SCREEN-VALUE IN FRAME f-imp, ".") <> "csv" THEN DO:
                RUN dop/MESSAGE.p("Arquivo invalido.", "Deve ser selecionado um arquivo CSV.").
                LEAVE.
            END.

            find first param-compra no-lock no-error.
            if  avail param-compra then do:
                assign i-prim-pedido = param-compra.num-pedido-ini 
                       i-ult-pedido  = param-compra.num-pedido-fim.
            end.

            FIND last pedido-compr no-lock
                where pedido-compr.num-pedido <= i-ult-pedido no-error.    
            if  avail pedido-compr then  DO:
                if (pedido-compr.num-pedido + 1) > i-ult-pedido
                or (pedido-compr.num-pedido + 1) < i-prim-pedido then 
                    assign i-nr-pedido = i-prim-pedido.
                ELSE 
                    assign i-nr-pedido = pedido-compr.num-pedido + 1.
            END.
            ELSE
                assign i-nr-pedido = i-prim-pedido.

            /* Importa planilha*/

            EMPTY TEMP-TABLE tt-imp.
            //limpa temp-table de execucao orcamentaria

            EMPTY TEMP-TABLE tt_xml_input_1.

            ASSIGN i-linha = 0.
            INPUT FROM VALUE(SEARCH(c-arquivo:SCREEN-VALUE IN FRAME f-imp)) CONVERT SOURCE "iso8859-1".
            REPEAT:
                IMPORT UNFORMATTED c-linha.
                ASSIGN i-linha = i-linha + 1.
        
                IF i-linha = 1 THEN NEXT.
                IF c-linha <> "" THEN DO:

                    FIND FIRST tt-imp 
                        WHERE tt-imp.it-codigo = ENTRY(1, c-linha, ";")
                        AND   tt-imp.i-linha   = i-linha NO-ERROR.
                    IF NOT AVAIL tt-imp THEN DO:

                        CREATE tt-imp.
                        ASSIGN tt-imp.i-linha        = i-linha
                               tt-imp.num-pedido     = 0
                               tt-imp.it-codigo      = ENTRY(1, c-linha, ";")  
                               tt-imp.qtde           = dec(ENTRY(2, c-linha, ";"))  
                               tt-imp.valor          = dec(ENTRY(3, c-linha, ";"))
                               tt-imp.conta          = int(ENTRY(5, c-linha, ";"))   
                               tt-imp.sc-conta       = int(ENTRY(6, c-linha, ";"))  
                               tt-imp.narrativa      = ENTRY    (7, c-linha, ";") .
                    END. //avail tt-imp
                END.
                ELSE LEAVE.
            END.
            INPUT CLOSE.

            ASSIGN l-erro-imp  = NO
                   d-soma-valor = 0.
         
            /* validacao dos registros importados */
            FOR EACH tt-imp :
                /* valida o item precisa estar cadastrado e nao bloqueado */
                FIND FIRST ITEM no-lock
                    WHERE ITEM.it-codigo = tt-imp.it-codigo NO-ERROR.
                IF NOT AVAIL ITEM THEN DO:
                    ASSIGN tt-imp.erro = "ITEM nao cadastrado.".
                END.
                ELSE DO:

                    ASSIGN tt-imp.desc-item = ITEM.desc-item.
                    IF ITEM.tipo-contr <> 4 THEN /* ativo */
                        ASSIGN tt-imp.erro = "ITEM obsoleto.".
                END.
                
                /* valida a qtde tem que ser maior que zero */
                IF tt-imp.qtde <= 0 THEN 
                    ASSIGN tt-imp.erro = tt-imp.erro + " - Quantidade = 0.".
                /* valida o valor tem que ser maior que zero */
                IF tt-imp.valor <= 0 THEN 
                    ASSIGN tt-imp.erro = tt-imp.erro + " -  Valor = 0.".

                ASSIGN d-soma-valor = d-soma-valor + tt-imp.valor.
                
                run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input       c-empresa,           /* EMPRESA EMS2 */
                                                               input        "",                 /* PLANO DE CONTAS */
                                                               input-output tt-imp.conta,       /* CONTA */
                                                               input        TODAY,              /* DATA TRANSACAO */   
                                                               output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                               output       v_num_sit_cta_ctbl, /* SITUA∞AO DA CONTA */
                                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                               output table tt_log_erro).       /* ERROS */
                for first tt_log_erro:
                    ASSIGN tt-imp.erro = tt-imp.erro + " - " + string(tt_log_erro.ttv_num_cod_erro) + ' - '  + string(tt_log_erro.ttv_des_msg_ajuda).
                END.
                /*#### UTILIZA CENTRO CUSTO #####*/
                run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS 2 */
                                                                   input  c-cod_estab ,         /* ESTABELECIMENTO EMS2 */
                                                                   input  "",                   /* PLANO CONTAS */
                                                                   input  tt-imp.conta,         /* CONTA */
                                                                   input  TODAY,                /* DT TRANSACAO */
                                                                   output v_log_utz_ccusto,     /* UTILIZA CCUSTO ? */
                                                                   output table tt_log_erro).   /* ERROS */
                for first tt_log_erro:
                    ASSIGN tt-imp.erro = tt-imp.erro + ' - ' + string(tt_log_erro.ttv_num_cod_erro) + ' - '  + string(tt_log_erro.ttv_des_msg_ajuda).
                END.
              
                find first criter_distrib_cta_ctbl NO-LOCK
                     WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                     AND   criter_distrib_cta_ctbl.cod_cta_ctbl       = string(tt-imp.conta) /* Conta Contˇbil */
                     AND   criter_distrib_cta_ctbl.cod_estab          = estabelecimento.cod_estab
                     AND   criter_distrib_cta_ctbl.dat_inic_valid    <= TODAY                          
                     AND   criter_distrib_cta_ctbl.dat_fim_valid     >= TODAY no-error.
                 if not avail criter_distrib_cta_ctbl then DO:
                     ASSIGN tt-imp.erro = tt-imp.erro + ' - ' + "N∆o Foi encontrado CritÇrio de Distribuiá∆o para Conta Cont†bil !".
                 END.
                 ELSE DO:
                     if criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/  then do:
                         find first mapa_distrib_ccusto NO-LOCK 
                              where mapa_distrib_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab 
                              AND   mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto no-error.
                         if not avail mapa_distrib_ccusto THEN DO:
                             ASSIGN tt-imp.erro = tt-imp.erro + ' - ' + "N∆o Foi encontrado Mapa de Distribuiá∆o para Conta Cont†bil !".
                         END.
                         ELSE DO:
                             FIND FIRST item_lista_ccusto no-lock
                                 where item_lista_ccusto.cod_estab        = mapa_distrib_ccusto.cod_estab
                                 AND   item_lista_ccusto.cod_mapa_distrib = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
                                 AND   item_lista_ccusto.cod_empresa      = v_cod_empresa_ems5
                                 AND   item_lista_ccusto.cod_plano_ccusto = v_cod_plano_ccusto
                                 AND   item_lista_ccusto.cod_ccusto       = string(tt-imp.sc-conta) NO-ERROR.
                             IF NOT AVAIL ITEM_lista_ccusto THEN DO:
                                 ASSIGN tt-imp.erro = tt-imp.erro + ' - ' + "Conta Cont†bil n∆o Permite lanáamento para o Centro de custo! Verifique Item Mapa De Distribuiá∆o".
                                 
                             END.
                         END.
                     END.
                END.

                /* inclus∆o de validaá∆o referente ao usu†rio materiais x contas cont†beis manutená∆o */
                IF CAN-FIND(FIRST dc-usuar-solic-comp NO-LOCK
                    WHERE dc-usuar-solic-comp.ct-codigo = STRING(tt-imp.conta)
                    AND   dc-usuar-solic-comp.sc-codigo = string(tt-imp.sc-conta) ) THEN DO:
            
                    FIND FIRST dc-usuar-solic-comp
                        WHERE dc-usuar-solic-comp.ct-codigo = STRING(tt-imp.conta )
                        AND   dc-usuar-solic-comp.sc-codigo = string(tt-imp.sc-conta)
                        AND   dc-usuar-solic-comp.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
            
                    IF NOT AVAIL dc-usuar-solic-comp THEN DO:
                        for first tt_log_erro:
                            ASSIGN tt-imp.erro =  tt-imp.erro + " - " +  "Usu†rio " + v_cod_usuar_corren + " n∆o possui permiss∆o para incluir " +
                                                 "solicitaá‰es para esta conta/centro de custo." + " (Programa ESCD1700)" .
                        END.
                    END.
                    
                    ELSE IF CAN-FIND(FIRST dc-usuar-solic-comp NO-LOCK
                                 WHERE dc-usuar-solic-comp.ct-codigo = STRING(tt-imp.conta )
                                   AND dc-usuar-solic-comp.sc-codigo = "") THEN DO:
            
                        FIND FIRST dc-usuar-solic-comp
                             WHERE dc-usuar-solic-comp.ct-codigo = STRING(tt-imp.conta ) 
                               AND dc-usuar-solic-comp.sc-codigo = ""
                               AND dc-usuar-solic-comp.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
                
                        IF NOT AVAIL dc-usuar-solic-comp THEN DO:
                            for first tt_log_erro:
                                ASSIGN tt-imp.erro =  ' - '  +  "Usu†rio " + v_cod_usuar_corren + " n∆o possui permiss∆o para incluir " +
                                                     "solicitaá‰es para esta conta/centro de custo." + " (Programa ESCD1700)" .
                            END.
                           ASSIGN l-erro = YES.
                        END. 
                    END.
                END.


                //inclusao de validacao de verba orcamentaria por conta contabil:

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label       = "Funá∆o"
                       tt_xml_input_1.tt_des_conteudo    = "Verifica"
                       tt_xml_input_1.tt_num_seq_1_xml   = 1
                       tt_xml_input_1.tt_num_seq_2_xml   = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label       = "Empresa"
                       tt_xml_input_1.tt_des_conteudo    = c-empresa
                       tt_xml_input_1.tt_num_seq_1_xml   = 1
                       tt_xml_input_1.tt_num_seq_2_xml   = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
                       tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.conta )
                       tt_xml_input_1.tt_num_seq_1_xml   = 1
                       tt_xml_input_1.tt_num_seq_2_xml   = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                       tt_xml_input_1.tt_des_conteudo    = STRING(c-cod-estabel:SCREEN-VALUE IN FRAME f-imp)
                       tt_xml_input_1.tt_num_seq_1_xml   = 1
                       tt_xml_input_1.tt_num_seq_2_xml   = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                       tt_xml_input_1.tt_des_conteudo   = STRING(TODAY)
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                       tt_xml_input_1.tt_des_conteudo   = "0"
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                       tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.valor)
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                       tt_xml_input_1.tt_des_conteudo   = STRING(tt-imp.qtde)
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                       tt_xml_input_1.tt_des_conteudo   = "18" //cotacao, nao Ç possivel usar o customizado
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                       tt_xml_input_1.tt_des_conteudo   = "Testando"
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                       tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                       tt_xml_input_1.tt_num_seq_1_xml  = 1
                       tt_xml_input_1.tt_num_seq_2_xml  = 0.

                create tt_xml_input_1.
                assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                       tt_xml_input_1.tt_des_conteudo    = STRING(tt-imp.sc-conta)
                       tt_xml_input_1.tt_num_seq_1_xml   = 1
                       tt_xml_input_1.tt_num_seq_2_xml   = 0.


                RUN prgfin/bgc/bgc700za.py (input 1,
                                            input table tt_xml_input_1,
                                            output table tt_log_erros) .  

                FIND FIRST tt_log_erros NO-LOCK NO-ERROR.

                IF AVAIL tt_log_erros THEN DO:

                       ASSIGN tt-imp.erro =  tt-imp.erro + " - " + tt_log_erros.ttv_des_ajuda.


                END.



                IF tt-imp.erro <> "" THEN 
                    ASSIGN l-erro-imp  = YES.                  
            END.
        END.

        ASSIGN d-valor-total:SCREEN-VALUE IN FRAME f-imp = STRING(d-soma-valor).

        OPEN QUERY br-importar FOR EACH tt-imp NO-LOCK.

        IF l-erro-imp = NO THEN 
            ENABLE bt-importar WITH FRAME f-imp.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel B-table-Win
ON f5 OF c-cod-estabel IN FRAME F-imp /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel B-table-Win
ON LEAVE OF c-cod-estabel IN FRAME F-imp /* Estabelecimento */
DO:

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-imp NO-ERROR.
    IF AVAIL   estabelec THEN DO:
        ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME f-imp = estabelec.nome
               c-desc-estabel:SCREEN-VALUE IN FRAME f-imp = estabelec.nome.
               c-empresa                                  = estabelec.ep-codigo.

    END.
    FIND FIRST matriz_trad_org_ext NO-LOCK
        WHERE matriz_trad_org_ext.ind_orig_org_ext = "EMS2" NO-ERROR.
    FIND FIRST trad_org_ext NO-LOCK
        WHERE trad_org_ext.cod_tip_unid_organ = "998"
        AND   trad_org_ext.cod_unid_organ_ext = c-empresa NO-ERROR.
    IF AVAIL trad_org_ext THEN
        ASSIGN v_cod_empresa_ems5 = trad_org_ext.cod_unid_organ
               c-empresa          = trad_org_ext.cod_unid_organ_ext.

    FIND FIRST emsuni.estabelecimento NO-LOCK
        WHERE emsuni.estabelecimento.cod_empresa  = v_cod_empresa_ems5
        AND emsuni.estabelecimento.log_estab_princ NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel B-table-Win
ON mouse-select-dblclick OF c-cod-estabel IN FRAME F-imp /* Estabelecimento */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto B-table-Win
ON f5 OF cond-pagto IN FRAME F-imp /* Cond.Pagto */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                       &campo=cond-Pagto
                       &campozoom=cod-cond-pag
                       &campo2=c-des-cond-pagto
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto B-table-Win
ON LEAVE OF cond-pagto IN FRAME F-imp /* Cond.Pagto */
DO:
    FIND FIRST cond-pagto WHERE
             cond-pagto.cod-cond-pag = int(cond-pagto:SCREEN-VALUE IN FRAME f-imp) NO-LOCK NO-ERROR.
  IF AVAIL   cond-pagto THEN DO:

     ASSIGN c-des-cond-pagto:SCREEN-VALUE IN FRAME f-imp = cond-pagto.descricao.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto B-table-Win
ON mouse-select-dblclick OF cond-pagto IN FRAME F-imp /* Cond.Pagto */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fornec B-table-Win
ON f5 OF fornec IN FRAME F-imp /* Fornecedor */
DO:
     {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo=fornec
                         &campozoom=cod-emitente
                         &campo2=c-des-fornecedor
                         &campozoom2=nome-abrev}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fornec B-table-Win
ON LEAVE OF fornec IN FRAME F-imp /* Fornecedor */
DO:
    FIND FIRST emitente WHERE
             emitente.cod-emitente = int(fornec:SCREEN-VALUE IN FRAME f-imp) NO-LOCK NO-ERROR.
  IF AVAILABLE emitente THEN DO:
     ASSIGN c-des-fornecedor:SCREEN-VALUE IN FRAME f-imp = emitente.nome-abrev.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fornec B-table-Win
ON mouse-select-dblclick OF fornec IN FRAME F-imp /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-importar
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
fornec:load-mouse-pointer("image\lupa.cur") in frame f-imp.
cond-pagto:load-mouse-pointer("image\lupa.cur") in frame f-imp.

FIND FIRST emsuni.estabelecimento NO-LOCK
     WHERE emsuni.estabelecimento.cod_empresa  = v_cod_empres_usuar
       AND emsuni.estabelecimento.log_estab_princ NO-ERROR.

FIND FIRST matriz_trad_org_ext NO-LOCK
    WHERE matriz_trad_org_ext.ind_orig_org_ext = "EMS2" NO-ERROR.
FIND FIRST trad_org_ext NO-LOCK
    WHERE trad_org_ext.cod_tip_unid_organ = "998"
    AND   trad_org_ext.cod_unid_organ = v_cod_empres_usuar NO-ERROR.
IF AVAIL trad_org_ext THEN
    ASSIGN c-empresa = trad_org_ext.cod_unid_organ_ext.

FIND FIRST estabelec WHERE
          estabelec.ep-codigo = c-empresa NO-LOCK NO-ERROR.
IF AVAIL   estabelec THEN DO:
  ASSIGN c-cod-estabel:SCREEN-VALUE  IN FRAME f-imp = estabelec.cod-estabel
         c-desc-estabel:SCREEN-VALUE IN FRAME f-imp = estabelec.nome.
         v_cod_empresa_ems5 = v_cod_empres_usuar.
END.
/*  Busca Plano CCusto da Empresa  e Plano de Contas */ 
for each plano_cta_unid_organ no-lock
    where  plano_cta_unid_organ.cod_unid_organ = v_cod_empresa_ems5
    AND    plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio"  :
    if  plano_cta_unid_organ.dat_inic_valid <= TODAY
    AND plano_cta_unid_organ.dat_fim_valid  >= TODAY then
        assign v_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.
end.
find first plano_cta_ctbl no-lock
    where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl 
    AND   plano_cta_ctbl.dat_inic_valid    <= TODAY
    AND   plano_cta_ctbl.dat_fim_valid     >= TODAY no-error.
IF NOT AVAIL plano_cta_ctbl THEN DO:
    RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo n∆o encontrado para empresa! ").
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

for each plano_ccusto no-lock
    where plano_ccusto.cod_empresa = v_cod_empresa_ems5:

    if  plano_ccusto.dat_inic_valid <= TODAY 
    and plano_ccusto.dat_fim_valid  >= TODAY then
        assign v_cod_plano_ccusto = plano_ccusto.cod_plano_ccusto.
end.

find first plano_ccusto NO-LOCK 
    where plano_ccusto.cod_empresa      = v_cod_empresa_ems5
    AND   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto
    AND   plano_ccusto.dat_inic_valid  <= TODAY
    AND   plano_ccusto.dat_fim_valid   >= TODAY no-error.       

if not avail plano_ccusto then do:
      RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo nío encontrado para empresa! ").
      APPLY "CLOSE" TO THIS-PROCEDURE.       
END.
/*
FIND FIRST estabelec WHERE
          estabelec.ep-codigo = c-empresa NO-LOCK NO-ERROR.
IF AVAIL estabelec THEN
ASSIGN c-cod-estabel = estabelec.cod-estabel. */




FIND FIRST comprador WHERE
           comprador.cod-comprado = v_cod_usuar_corren NO-LOCK NO-ERROR.
IF NOT AVAIL comprador THEN DO:
   RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa  !").
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.
ELSE DO:
   FIND FIRST usuar-mater WHERE
              usuar-mater.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
   IF NOT AVAIL usuar-mater THEN DO:
      RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa ! ").
      APPLY "CLOSE" TO THIS-PROCEDURE.
   END.
   ELSE DO:
       IF usuar-mater.usuar-comprador = NO THEN DO:
           RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa ! ").
           APPLY "CLOSE" TO THIS-PROCEDURE.
       END.
   END.
END.


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF




RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.


APPLY "LEAVE" TO c-cod-estabel IN FRAME f-imp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  HIDE FRAME F-imp.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

FIND FIRST  comprador WHERE
            comprador.cod-comprado = v_cod_usuar_corren  NO-LOCK NO-ERROR.
IF  AVAIL   comprador THEN DO:
     ASSIGN responsavel:SCREEN-VALUE IN FRAME f-imp = comprador.cod-comprado.
END.
ELSE 
    ASSIGN responsavel:SCREEN-VALUE IN FRAME f-imp = "".


IF AVAIL   estabelec THEN DO:
  ASSIGN c-cod-estabel:SCREEN-VALUE  IN FRAME f-imp = estabelec.cod-estabel
         c-desc-estabel:SCREEN-VALUE IN FRAME f-imp = estabelec.nome.
         v_cod_empresa_ems5 = v_cod_empres_usuar.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida B-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM P-erro-imp as LOG no-undo.
    
    /* valida estabelecimento */
    FIND FIRST estabelec WHERE
               estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-imp NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN DO: 
    
         RUN utp/ut-msgs.p("show",17006,"Estabelecimento n∆o encontrado !").
         RETURN "NOK".
    END.
    
    IF  l-estab-security-active /*seguranªa por estabelecimento*/
    AND NOT CAN-FIND (FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = INPUT FRAME {&FRAME-NAME} c-cod-estabel) THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Estabelecimento informado n∆o est† liberado para seleá∆o !").
        APPLY "entry" TO c-cod-estabel IN FRAME f-imp.
        ASSIGN p-erro-imp = YES.
        RETURN "NOK".
    END.
    
    /* Valida se o usuario possui permissío no estabelecimento */
    ASSIGN l-permissao-estab = NO.
    
    FIND FIRST estabelecimento NO-LOCK
       WHERE estabelecimento.cod_empresa     = v_cod_empresa_ems5 NO-ERROR.
    IF AVAIL estabelecimento THEN
        ASSIGN c-estab-log = estabelecimento.cod_estab.
    
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
    
        FOR EACH  unid-negoc-grp-usuar NO-LOCK
            WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
            EACH  unid-negoc-estab NO-LOCK
            WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
              AND unid-negoc-estab.cod-estabel     = c-estab-log
              AND unid-negoc-estab.dat-inic-valid <= TODAY
              AND unid-negoc-estab.dat-fim-valid  >= TODAY:
    
            ASSIGN l-permissao-estab = YES.
            ASSIGN v_cod_unid_negoc = unid-negoc-grp-usuar.cod-unid-negoc.
        END.
    END.
    
    IF l-permissao-estab = NO THEN DO:
    
        RUN utp/ut-msgs.p("show",17006,"Usu†rio n∆o tem permiss∆o para acessar o estabelecimento informado!").
        APPLY "entry" TO c-cod-estabel IN FRAME f-imp.
    END.
    
    /* valida fornecedor  */
    FIND FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente = int(fornec:SCREEN-VALUE IN FRAME f-imp) NO-ERROR.
    IF NOT AVAILABLE emitente THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Fornecedor nao encontrado !").
        ASSIGN p-erro-imp = YES.
        RETURN "NOK".
    END.        
    
    /* valida condicao de pagamento */
    FIND FIRST cond-pagto NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = int(cond-pagto:SCREEN-VALUE IN FRAME f-imp) NO-ERROR.
    IF NOT AVAIL cond-pagto THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento nao encontrado !").
        ASSIGN p-erro-imp = YES.
        RETURN "NOK".
    END.
    ELSE DO:
        IF cond-pagto.cod-cond-pag = 1 THEN DO:
            RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento A Vista N∆o Permitida !").
            ASSIGN p-erro-imp = YES.
            RETURN "NOK".
        END.
        ELSE DO:
            IF cond-pagto.cod-cond-pag >= 100
            AND cond-pagto.cod-cond-pag < 1000 THEN DO:
                RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento N∆o Permitida Para Pedido de Compras !").
                ASSIGN p-erro-imp = YES.
                RETURN "NOK".
            END.
        END.
    END.
    
    FIND FIRST usuar-mater NO-LOCK 
        WHERE usuar-mater.cod-usuario = responsavel:SCREEN-VALUE IN FRAME f-imp NO-ERROR.
    IF NOT AVAIL usuar-mater THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador ! ").
        ASSIGN p-erro-imp = YES.
        RETURN "NOK".
    END.
    ELSE DO:
        IF usuar-mater.usuar-comprador = NO THEN DO:
            RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador ! ").
            ASSIGN p-erro-imp = YES.            
            RETURN "NOK".
        END.
    END.


    /*  Busca Plano CCusto da Empresa  e Plano de Contas */ 
    for each plano_cta_unid_organ no-lock
        where  plano_cta_unid_organ.cod_unid_organ = v_cod_empresa_ems5
        AND    plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio"  :
        if  plano_cta_unid_organ.dat_inic_valid <= TODAY
        AND plano_cta_unid_organ.dat_fim_valid  >= TODAY then
            assign v_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.
    end.
    find first plano_cta_ctbl no-lock
        where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl 
        AND   plano_cta_ctbl.dat_inic_valid    <= TODAY
        AND   plano_cta_ctbl.dat_fim_valid     >= TODAY no-error.
    IF NOT AVAIL plano_cta_ctbl THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo n∆o encontrado para empresa! ").
        RETURN "NOK".
    END.

    for each plano_ccusto no-lock
        where plano_ccusto.cod_empresa = v_cod_empresa_ems5:

        if  plano_ccusto.dat_inic_valid <= TODAY 
        and plano_ccusto.dat_fim_valid  >= TODAY then
            assign v_cod_plano_ccusto = plano_ccusto.cod_plano_ccusto.
    end.

    find first plano_ccusto NO-LOCK 
        where plano_ccusto.cod_empresa      = v_cod_empresa_ems5
        AND   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto
        AND   plano_ccusto.dat_inic_valid  <= TODAY
        AND   plano_ccusto.dat_fim_valid   >= TODAY no-error.       

    if not avail plano_ccusto then do:
          RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo nío encontrado para empresa! ").
          RETURN "NOK".      
    END.


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
  {src/adm/template/snd-list.i "tt-imp"}

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

