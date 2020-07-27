&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
          emsuni           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 
  Description: 
  Input Parameters:
  Output Parameters:
  Author: 
  Created: 
  Manutená∆o: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

{utp/ut-glob504.i}

/* Local Variable Definitions ---                                       */
DEF NEW GLOBAL SHARED VAR v_rec_tit_ap           AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_movto_tit_ap     AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_item_lancto_ctbl AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-documento           AS ROWID NO-UNDO.

def new global shared var v_cod_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.
def new global shared var v_cdn_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.

DEF VAR h-lista-frames  AS HANDLE  NO-UNDO EXTENT 3.
DEF VAR h-lista-botoes  AS HANDLE  NO-UNDO EXTENT 3.
DEF VAR i-posicao-frame AS INTEGER NO-UNDO.
DEF VAR i-cont          AS INTEGER NO-UNDO.
DEF VAR c-param         AS CHAR    NO-UNDO.

DEF VAR i-clas-cta      AS INT     NO-UNDO INIT 4.
DEF VAR i-clas-det      AS INT     NO-UNDO INIT 4.
DEF VAR i-clas-rcc      AS INT     NO-UNDO INIT 3.

DEF VAR cc-plano         AS CHAR    NO-UNDO.
DEF VAR c-cod-estab      AS CHAR    NO-UNDO.
DEF VAR c-cod-estabel    AS CHAR    NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-est-doc023        AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-cta-doc023        AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-ccusto-doc023     AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR da-trans-ini-doc023 AS DATE NO-UNDO.
DEF NEW GLOBAL SHARED VAR da-trans-fim-doc023 AS DATE NO-UNDO.


DEFINE VARIABLE l-implanta AS LOGICAL     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

{doinc/doc024.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-contas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cta cta_ctbl tt-detalhe tt-ccusto-cta ~
tt-res-origem

/* Definitions for BROWSE br-contas                                     */
&Scoped-define FIELDS-IN-QUERY-br-contas tt-cta.cod_cta_ctbl cta_ctbl.des_tit_ctbl tt-cta.val-orcado tt-cta.val-previsto tt-cta.val-realiz tt-cta.val-variac   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contas   
&Scoped-define SELF-NAME br-contas
&Scoped-define QUERY-STRING-br-contas FOR EACH tt-cta                            WHERE tt-cta.val-realiz <> 0                               OR tt-cta.val-orcado <> 0, ~
                                  FIRST cta_ctbl NO-LOCK                            WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"                              AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl                               BY tt-cta.val-realiz DESC                               BY tt-cta.val-variac DESC                               BY tt-cta.val-orcado DESC                               BY tt-cta.cod_cta_ctbl
&Scoped-define OPEN-QUERY-br-contas OPEN QUERY {&SELF-NAME} FOR EACH tt-cta                            WHERE tt-cta.val-realiz <> 0                               OR tt-cta.val-orcado <> 0, ~
                                  FIRST cta_ctbl NO-LOCK                            WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"                              AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl                               BY tt-cta.val-realiz DESC                               BY tt-cta.val-variac DESC                               BY tt-cta.val-orcado DESC                               BY tt-cta.cod_cta_ctbl.
&Scoped-define TABLES-IN-QUERY-br-contas tt-cta cta_ctbl
&Scoped-define FIRST-TABLE-IN-QUERY-br-contas tt-cta
&Scoped-define SECOND-TABLE-IN-QUERY-br-contas cta_ctbl


/* Definitions for BROWSE br-detalhamento                               */
&Scoped-define FIELDS-IN-QUERY-br-detalhamento tt-detalhe.cod_ccusto /*tt-detalhe.dat_transacao*/ tt-detalhe.cod_modul_dtsul tt-detalhe.val-movto tt-detalhe.val-previsto tt-detalhe.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-detalhamento   
&Scoped-define SELF-NAME br-detalhamento
&Scoped-define QUERY-STRING-br-detalhamento FOR EACH tt-detalhe                            WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl                               BY tt-detalhe.cod_cta_ctbl                               BY tt-detalhe.val-movto DESC                               BY tt-detalhe.cod_ccusto                               BY tt-detalhe.dat_transacao
&Scoped-define OPEN-QUERY-br-detalhamento OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhe                            WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl                               BY tt-detalhe.cod_cta_ctbl                               BY tt-detalhe.val-movto DESC                               BY tt-detalhe.cod_ccusto                               BY tt-detalhe.dat_transacao.
&Scoped-define TABLES-IN-QUERY-br-detalhamento tt-detalhe
&Scoped-define FIRST-TABLE-IN-QUERY-br-detalhamento tt-detalhe


/* Definitions for BROWSE br-res-ccusto                                 */
&Scoped-define FIELDS-IN-QUERY-br-res-ccusto tt-ccusto-cta.cod_ccusto tt-ccusto-cta.des_tit_ctbl tt-ccusto-cta.val-orcado tt-ccusto-cta.val-previsto tt-ccusto-cta.val-movto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-res-ccusto   
&Scoped-define SELF-NAME br-res-ccusto
&Scoped-define QUERY-STRING-br-res-ccusto FOR EACH tt-ccusto-cta                            WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl                               BY tt-ccusto-cta.cod_cta_ctbl                               BY tt-ccusto-cta.val-movto DESC
&Scoped-define OPEN-QUERY-br-res-ccusto OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-cta                            WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl                               BY tt-ccusto-cta.cod_cta_ctbl                               BY tt-ccusto-cta.val-movto DESC.
&Scoped-define TABLES-IN-QUERY-br-res-ccusto tt-ccusto-cta
&Scoped-define FIRST-TABLE-IN-QUERY-br-res-ccusto tt-ccusto-cta


/* Definitions for BROWSE br-res-origem                                 */
&Scoped-define FIELDS-IN-QUERY-br-res-origem tt-res-origem.cod_modul_dtsul tt-res-origem.val-movto tt-res-origem.val-previsto tt-res-origem.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-res-origem   
&Scoped-define SELF-NAME br-res-origem
&Scoped-define QUERY-STRING-br-res-origem FOR EACH tt-res-origem     WHERE tt-res-origem.cod_cta_ctbl = tt-cta.cod_cta_ctbl
&Scoped-define OPEN-QUERY-br-res-origem OPEN QUERY {&SELF-NAME} FOR EACH tt-res-origem     WHERE tt-res-origem.cod_cta_ctbl = tt-cta.cod_cta_ctbl.
&Scoped-define TABLES-IN-QUERY-br-res-origem tt-res-origem
&Scoped-define FIRST-TABLE-IN-QUERY-br-res-origem tt-res-origem


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-contas}

/* Definitions for FRAME f-detalhamento                                 */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-detalhamento ~
    ~{&OPEN-QUERY-br-detalhamento}

/* Definitions for FRAME f-res-ccusto                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-res-ccusto ~
    ~{&OPEN-QUERY-br-res-ccusto}

/* Definitions for FRAME f-res-origem                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-res-origem ~
    ~{&OPEN-QUERY-br-res-origem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 rs-tipo-filtro br-contas ~
btn-res-origem btn-res-ccusto btn-detalhamento btn-imp-geral de-tot-orcado ~
de-tot-previsto de-tot-realiz de-val-variac 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo-filtro de-tot-orcado ~
de-tot-previsto de-tot-realiz de-val-variac 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-detalhamento 
     LABEL "Detalhe CCusto" 
     SIZE 14 BY 1.

DEFINE BUTTON btn-imp-geral 
     LABEL "Imprime" 
     SIZE 14 BY 1.

DEFINE BUTTON btn-res-ccusto 
     LABEL "Resumo CCusto" 
     SIZE 14 BY 1.

DEFINE BUTTON btn-res-origem 
     LABEL "Resumo Origem" 
     SIZE 14 BY 1.

DEFINE VARIABLE de-tot-orcado AS DECIMAL FORMAT "-zz,zzz,zz9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE de-tot-previsto AS DECIMAL FORMAT "-zz,zzz,zz9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE de-tot-realiz AS DECIMAL FORMAT "-zz,zzz,zz9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE de-val-variac AS DECIMAL FORMAT "-zzz9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE rs-tipo-filtro AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Centro de Custo", 1,
"Grupo OBZ", 2
     SIZE 14 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 3.25.

DEFINE BUTTON btn-imp-cta 
     LABEL "Imprime" 
     SIZE 14 BY 1.

DEFINE BUTTON btn-origem 
     LABEL "Detalhe" 
     SIZE 14 BY 1.

DEFINE BUTTON btn-imp-ccusto 
     LABEL "Imprime" 
     SIZE 14 BY 1
     FONT 4.

DEFINE BUTTON btn-detalhe-res-origem 
     LABEL "Detalhe" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "Image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-exi.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-leave-cod-ccusto 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 4 BY .88.

DEFINE BUTTON btn-next 
     IMAGE-UP FILE "image/im-nex1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btn-pesq 
     IMAGE-UP FILE "image/im-run.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Pesquisa Informaá‰es".

DEFINE BUTTON btn-prev 
     IMAGE-UP FILE "image/im-pre1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btn-sel-ccusto 
     IMAGE-UP FILE "image/im-ran_a.gif":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Seleciona Centro de Custo".

DEFINE VARIABLE c-cod-ccusto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Custo" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-lista-ccusto AS CHARACTER FORMAT "X(2000)":U 
     LABEL "Pesq CCusto" 
     VIEW-AS FILL-IN 
     SIZE 77 BY .88 NO-UNDO.

DEFINE VARIABLE da-fim AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE BUTTON bt-exit-2 
     IMAGE-UP FILE "Image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-exi.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-leave-grp 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 4 BY .88.

DEFINE BUTTON btn-next-2 
     IMAGE-UP FILE "image/im-nex1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btn-pesq-grp 
     IMAGE-UP FILE "image/im-run.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Pesquisa Informaá‰es".

DEFINE BUTTON btn-prev-2 
     IMAGE-UP FILE "image/im-pre1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE c-cod-grupo LIKE dc-orc-grupo.cod-grupo
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contas FOR 
      tt-cta, 
      cta_ctbl SCROLLING.

DEFINE QUERY br-detalhamento FOR 
      tt-detalhe SCROLLING.

DEFINE QUERY br-res-ccusto FOR 
      tt-ccusto-cta SCROLLING.

DEFINE QUERY br-res-origem FOR 
      tt-res-origem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contas C-Win _FREEFORM
  QUERY br-contas DISPLAY
      tt-cta.cod_cta_ctbl    FORMAT "x(6)"            COLUMN-LABEL "Conta"
cta_ctbl.des_tit_ctbl  FORMAT "x(52)"           COLUMN-LABEL "T°tulo"
tt-cta.val-orcado      FORMAT "->>,>>>,>>9.99"         LABEL "Oráado"
tt-cta.val-previsto    FORMAT "->>,>>>,>>9.99"         LABEL "Previsto"
tt-cta.val-realiz      FORMAT "->>,>>>,>>9.99"         LABEL "Realizado"
tt-cta.val-variac      FORMAT "->>>>9.99"              LABEL "% Var"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 9.5
         FONT 2
         TITLE "Contas Cont†beis".

DEFINE BROWSE br-detalhamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-detalhamento C-Win _FREEFORM
  QUERY br-detalhamento DISPLAY
      tt-detalhe.cod_ccusto       FORMAT "x(5)" COLUMN-LABEL "CCusto"
/*tt-detalhe.dat_transacao*/
tt-detalhe.cod_modul_dtsul  FORMAT 'x(10)'
tt-detalhe.val-movto
tt-detalhe.val-previsto
tt-detalhe.descricao        FORMAT "x(1000)" LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 8.75
         FONT 2
         TITLE "Detalhamento".

DEFINE BROWSE br-res-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-res-ccusto C-Win _FREEFORM
  QUERY br-res-ccusto DISPLAY
      tt-ccusto-cta.cod_ccusto   FORMAT "x(5)" COLUMN-LABEL "CCusto"
tt-ccusto-cta.des_tit_ctbl               COLUMN-LABEL "T°tulo"
tt-ccusto-cta.val-orcado COLUMN-LABEL "Valor Oráado"
tt-ccusto-cta.val-previsto COLUMN-LABEL "Valor Previsto"
tt-ccusto-cta.val-movto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 8.75
         FONT 2
         TITLE "Resumo Centro Custo".

DEFINE BROWSE br-res-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-res-origem C-Win _FREEFORM
  QUERY br-res-origem DISPLAY
      tt-res-origem.cod_modul_dtsul  FORMAT 'x(10)'
tt-res-origem.val-movto
tt-res-origem.val-previsto
tt-res-origem.descricao        FORMAT "x(1000)" LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 8.75
         FONT 2
         TITLE "Resumo Origem".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     rs-tipo-filtro AT ROW 1.5 COL 3 NO-LABEL WIDGET-ID 8
     br-contas AT ROW 4.5 COL 1
     btn-res-origem AT ROW 14 COL 1 WIDGET-ID 4
     btn-res-ccusto AT ROW 14 COL 15
     btn-detalhamento AT ROW 14 COL 29
     btn-imp-geral AT ROW 14 COL 43
     de-tot-orcado AT ROW 14 COL 58 COLON-ALIGNED NO-LABEL
     de-tot-previsto AT ROW 14 COL 73 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     de-tot-realiz AT ROW 14 COL 88 COLON-ALIGNED NO-LABEL
     de-val-variac AT ROW 14 COL 102.57 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.57 BY 24.42
         FONT 4.

DEFINE FRAME frame-cc
     c-cod-ccusto AT ROW 1.25 COL 16 COLON-ALIGNED WIDGET-ID 18
     bt-leave-cod-ccusto AT ROW 1.25 COL 32.72 WIDGET-ID 6
     da-ini AT ROW 1.25 COL 54.29 COLON-ALIGNED WIDGET-ID 24
     da-fim AT ROW 1.25 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     btn-prev AT ROW 1.25 COL 83 WIDGET-ID 14
     btn-next AT ROW 1.25 COL 87 WIDGET-ID 10
     btn-pesq AT ROW 1.25 COL 91 WIDGET-ID 12
     bt-exit AT ROW 1.25 COL 95 WIDGET-ID 8
     btn-sel-ccusto AT ROW 2.5 COL 95 WIDGET-ID 16
     c-lista-ccusto AT ROW 2.63 COL 16 COLON-ALIGNED WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 18 ROW 1
         SIZE 99 BY 3.25
         FONT 4 WIDGET-ID 200.

DEFINE FRAME f-res-origem
     br-res-origem AT ROW 1 COL 1
     btn-detalhe-res-origem AT ROW 9.75 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 15.21
         SIZE 116 BY 10
         FONT 4 WIDGET-ID 100.

DEFINE FRAME f-detalhamento
     br-detalhamento AT ROW 1 COL 1
     btn-origem AT ROW 9.75 COL 1
     btn-imp-cta AT ROW 9.75 COL 15
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 15.21
         SIZE 116 BY 10
         FONT 4.

DEFINE FRAME f-res-ccusto
     br-res-ccusto AT ROW 1 COL 1
     btn-imp-ccusto AT ROW 9.75 COL 1 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 15.21
         SIZE 116 BY 10.

DEFINE FRAME frame-grp
     c-cod-grupo AT ROW 1.25 COL 14.57 COLON-ALIGNED HELP
          "" WIDGET-ID 18
     bt-leave-grp AT ROW 1.25 COL 28.86 WIDGET-ID 6
     da-ini AT ROW 1.25 COL 54.29 COLON-ALIGNED WIDGET-ID 24
          LABEL "Data Transaá∆o" FORMAT "99/99/9999":U
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     da-fim AT ROW 1.25 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22 FORMAT "99/99/9999":U
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     btn-prev-2 AT ROW 1.25 COL 83 WIDGET-ID 14
     btn-next-2 AT ROW 1.25 COL 87 WIDGET-ID 10
     btn-pesq-grp AT ROW 1.25 COL 91 WIDGET-ID 12
     bt-exit-2 AT ROW 1.25 COL 95 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 18 ROW 1
         SIZE 99 BY 3.25
         FONT 4 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Despesas Realizadas - DOC024 - Empresa: "
         HEIGHT             = 24.42
         WIDTH              = 116.57
         MAX-HEIGHT         = 28.75
         MAX-WIDTH          = 130.72
         VIRTUAL-HEIGHT     = 28.75
         VIRTUAL-WIDTH      = 130.72
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-detalhamento:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-res-ccusto:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-res-origem:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frame-cc:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frame-grp:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB br-contas rs-tipo-filtro DEFAULT-FRAME */
ASSIGN 
       br-contas:ALLOW-COLUMN-SEARCHING IN FRAME DEFAULT-FRAME = TRUE.

/* SETTINGS FOR FRAME f-detalhamento
                                                                        */
/* BROWSE-TAB br-detalhamento 1 f-detalhamento */
ASSIGN 
       br-detalhamento:ALLOW-COLUMN-SEARCHING IN FRAME f-detalhamento = TRUE.

/* SETTINGS FOR FRAME f-res-ccusto
                                                                        */
/* BROWSE-TAB br-res-ccusto 1 f-res-ccusto */
ASSIGN 
       br-res-ccusto:ALLOW-COLUMN-SEARCHING IN FRAME f-res-ccusto = TRUE.

/* SETTINGS FOR FRAME f-res-origem
                                                                        */
/* BROWSE-TAB br-res-origem 1 f-res-origem */
/* SETTINGS FOR FRAME frame-cc
   UNDERLINE                                                            */
/* SETTINGS FOR FRAME frame-grp
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-grupo IN FRAME frame-grp
   LIKE = emsdocol.dc-orc-grupo.cod-grupo EXP-SIZE                      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contas
/* Query rebuild information for BROWSE br-contas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cta
                           WHERE tt-cta.val-realiz <> 0
                              OR tt-cta.val-orcado <> 0,
                           FIRST cta_ctbl NO-LOCK
                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                              BY tt-cta.val-realiz DESC
                              BY tt-cta.val-variac DESC
                              BY tt-cta.val-orcado DESC
                              BY tt-cta.cod_cta_ctbl
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-contas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-detalhamento
/* Query rebuild information for BROWSE br-detalhamento
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhe
                           WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                              BY tt-detalhe.cod_cta_ctbl
                              BY tt-detalhe.val-movto DESC
                              BY tt-detalhe.cod_ccusto
                              BY tt-detalhe.dat_transacao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-detalhamento */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-res-ccusto
/* Query rebuild information for BROWSE br-res-ccusto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-cta
                           WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                              BY tt-ccusto-cta.cod_cta_ctbl
                              BY tt-ccusto-cta.val-movto DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-res-ccusto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-res-origem
/* Query rebuild information for BROWSE br-res-origem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-res-origem
    WHERE tt-res-origem.cod_cta_ctbl = tt-cta.cod_cta_ctbl
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-res-origem */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Consulta Despesas Realizadas - DOC024 - Empresa:  */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Consulta Despesas Realizadas - DOC024 - Empresa:  */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contas
&Scoped-define SELF-NAME br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas C-Win
ON ROW-DISPLAY OF br-contas IN FRAME DEFAULT-FRAME /* Contas Cont†beis */
DO:
   ASSIGN tt-cta.cod_cta_ctbl:BGCOLOR IN BROWSE br-contas   = IF i-clas-cta = 1 THEN 8
                                                                                ELSE 15
          cta_ctbl.des_tit_ctbl:BGCOLOR IN BROWSE br-contas = IF i-clas-cta = 2 THEN 8
                                                                                ELSE 15
          tt-cta.val-orcado:BGCOLOR IN BROWSE br-contas     = IF i-clas-cta = 3 THEN 8
                                                                                ELSE 15
          tt-cta.val-realiz:BGCOLOR IN BROWSE br-contas     = IF i-clas-cta = 4 THEN 8
                                                                                ELSE 15
          tt-cta.val-variac:BGCOLOR IN BROWSE br-contas     = IF i-clas-cta = 5 THEN 8
                                                                                ELSE 15
          tt-cta.val-previsto:BGCOLOR IN BROWSE br-contas   = IF i-clas-cta = 6 THEN 8
                                                                                ELSE 15.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas C-Win
ON START-SEARCH OF br-contas IN FRAME DEFAULT-FRAME /* Contas Cont†beis */
DO:
  DEFINE VARIABLE vwh-column AS WIDGET-HANDLE NO-UNDO.

  vwh-column = SELF:CURRENT-COLUMN.
  IF NOT VALID-HANDLE(vwh-column) THEN
    RETURN NO-APPLY.

  CASE vwh-column:LABEL:
    WHEN "Conta":U     THEN i-clas-cta = 1.
    WHEN "T°tulo":U    THEN i-clas-cta = 2.
    WHEN "Oráado":U    THEN i-clas-cta = 3.
    WHEN "Realizado":U THEN i-clas-cta = 4.
    WHEN "% Var":U     THEN i-clas-cta = 5.
    WHEN "Previsto":U  THEN i-clas-cta = 6.
  END CASE.

  RUN pi-abre-contas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas C-Win
ON VALUE-CHANGED OF br-contas IN FRAME DEFAULT-FRAME /* Contas Cont†beis */
DO:
    IF AVAIL tt-cta THEN DO:
        br-detalhamento:TITLE IN FRAME f-detalhamento = "Detalhamento da Conta " + tt-cta.cod_cta_ctbl.
        br-res-ccusto:TITLE IN FRAME f-res-ccusto     = "Resumo Centro Custo da Conta " + tt-cta.cod_cta_ctbl.
        br-res-origem:TITLE IN FRAME f-res-origem     = "Resumo Origem da Conta " + tt-cta.cod_cta_ctbl.
        {&OPEN-QUERY-br-detalhamento}
        {&OPEN-QUERY-br-res-ccusto}
        {&OPEN-QUERY-br-res-origem}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-detalhamento
&Scoped-define FRAME-NAME f-detalhamento
&Scoped-define SELF-NAME br-detalhamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-detalhamento C-Win
ON ROW-DISPLAY OF br-detalhamento IN FRAME f-detalhamento /* Detalhamento */
DO:
   ASSIGN tt-detalhe.cod_ccusto:BGCOLOR IN BROWSE br-detalhamento      = IF i-clas-det = 1 THEN 8
                                                                                           ELSE 15
          /*tt-detalhe.dat_transacao:BGCOLOR IN BROWSE br-detalhamento   = IF i-clas-det = 2 THEN 8
                                                                                           ELSE 15*/
          tt-detalhe.cod_modul_dtsul:BGCOLOR IN BROWSE br-detalhamento = IF i-clas-det = 3 THEN 8
                                                                                           ELSE 15
          tt-detalhe.val-movto:BGCOLOR IN BROWSE br-detalhamento       = IF i-clas-det = 4 THEN 8
                                                                                           ELSE 15
          tt-detalhe.descricao:BGCOLOR IN BROWSE br-detalhamento       = IF i-clas-det = 5 THEN 8
                                                                                           ELSE 15.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-detalhamento C-Win
ON START-SEARCH OF br-detalhamento IN FRAME f-detalhamento /* Detalhamento */
DO:
  
    DEFINE VARIABLE vwh-column AS WIDGET-HANDLE NO-UNDO.

    vwh-column = SELF:CURRENT-COLUMN.
    IF NOT VALID-HANDLE(vwh-column) THEN
      RETURN NO-APPLY.

    CASE vwh-column:LABEL:
      WHEN "CCusto":U         THEN i-clas-det = 1.
      WHEN "Data Transaá∆o":U THEN i-clas-det = 2.
      WHEN "Mod":U            THEN i-clas-det = 3.
      WHEN "Valor Movto":U    THEN i-clas-det = 4.
      WHEN "Descriá∆o":U      THEN i-clas-det = 5.
    END CASE.

    RUN pi-abre-detalhamento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-res-ccusto
&Scoped-define FRAME-NAME f-res-ccusto
&Scoped-define SELF-NAME br-res-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-res-ccusto C-Win
ON ROW-DISPLAY OF br-res-ccusto IN FRAME f-res-ccusto /* Resumo Centro Custo */
DO:
   ASSIGN tt-ccusto-cta.cod_ccusto:BGCOLOR IN BROWSE br-res-ccusto   = IF i-clas-rcc = 1 THEN 8
                                                                                         ELSE 15
          tt-ccusto-cta.des_tit_ctbl:BGCOLOR IN BROWSE br-res-ccusto = IF i-clas-rcc = 2 THEN 8
                                                                                         ELSE 15
          tt-ccusto-cta.val-movto:BGCOLOR IN BROWSE br-res-ccusto    = IF i-clas-rcc = 3 THEN 8
                                                                                         ELSE 15.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-res-ccusto C-Win
ON START-SEARCH OF br-res-ccusto IN FRAME f-res-ccusto /* Resumo Centro Custo */
DO:
    DEFINE VARIABLE vwh-column AS WIDGET-HANDLE NO-UNDO.

    vwh-column = SELF:CURRENT-COLUMN.
    IF NOT VALID-HANDLE(vwh-column) THEN
      RETURN NO-APPLY.

    CASE vwh-column:LABEL:
      WHEN "CCusto":U      THEN i-clas-rcc = 1.
      WHEN "T°tulo":U      THEN i-clas-rcc = 2.
      WHEN "Valor Movto":U THEN i-clas-rcc = 3.
    END CASE.

    RUN pi-abre-res-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit C-Win
ON CHOOSE OF bt-exit IN FRAME frame-cc
DO:
    APPLY 'close' TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME bt-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit-2 C-Win
ON CHOOSE OF bt-exit-2 IN FRAME frame-grp
DO:
    APPLY 'close' TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME bt-leave-cod-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-leave-cod-ccusto C-Win
ON CHOOSE OF bt-leave-cod-ccusto IN FRAME frame-cc
DO:
    APPLY "leave" TO c-cod-ccusto IN FRAME frame-cc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME bt-leave-grp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-leave-grp C-Win
ON CHOOSE OF bt-leave-grp IN FRAME frame-grp
DO:
    APPLY "leave" TO c-cod-grupo IN FRAME frame-grp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME btn-detalhamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-detalhamento C-Win
ON CHOOSE OF btn-detalhamento IN FRAME DEFAULT-FRAME /* Detalhe CCusto */
DO:
   RUN pi-frame(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-res-origem
&Scoped-define SELF-NAME btn-detalhe-res-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-detalhe-res-origem C-Win
ON CHOOSE OF btn-detalhe-res-origem IN FRAME f-res-origem /* Detalhe */
DO:
    IF AVAIL tt-res-origem THEN DO:
        FIND FIRST dc-orc-realizado NO-LOCK
             WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
               AND dc-orc-realizado.cod_plano_ctbl   = "PCDOCOL"
               AND dc-orc-realizado.cod_cta_ctbl     = tt-res-origem.cod_cta_ctbl
               AND dc-orc-realizado.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
               AND dc-orc-realizado.modulo           = tt-res-origem.cod_modul_dtsul
               AND dc-orc-realizado.data            >= da-ini
               AND dc-orc-realizado.data            <= da-fim NO-ERROR.
        IF AVAIL dc-orc-realizado THEN DO:
            
            RUN dop/doc024e.w (INPUT tt-res-origem.cod_cta_ctbl,
                               INPUT tt-res-origem.cod_modul_dtsul,
                               INPUT (IF rs-tipo-filtro = 1 THEN c-lista-ccusto ELSE ""),
                               INPUT da-ini,
                               INPUT da-fim).
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-res-ccusto
&Scoped-define SELF-NAME btn-imp-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-imp-ccusto C-Win
ON CHOOSE OF btn-imp-ccusto IN FRAME f-res-ccusto /* Imprime */
DO:
    IF AVAIL tt-ccusto-cta THEN DO:
       RUN dop/doc024b.w (INPUT c-cod-ccusto,
                          INPUT da-ini,
                          INPUT da-fim,
                          INPUT c-lista-ccusto,
                          INPUT tt-cta.cod_cta_ctbl,
                          INPUT TABLE tt-ccusto-cta).
    END.
    ELSE DO:
       RUN dop/MESSAGE.p ("N∆o foi poss°vel imprimir!",
                          "Centro de Custo n∆o encontrado.").
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-detalhamento
&Scoped-define SELF-NAME btn-imp-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-imp-cta C-Win
ON CHOOSE OF btn-imp-cta IN FRAME f-detalhamento /* Imprime */
DO:
    IF AVAIL tt-cta THEN DO:
       RUN dop/doc024a.w (INPUT "cta",
                        INPUT c-cod-ccusto,
                        INPUT da-ini,
                        INPUT da-fim,
                        INPUT c-lista-ccusto,
                        INPUT tt-cta.cod_cta_ctbl,
                        INPUT TABLE tt-cta,
                        INPUT TABLE tt-detalhe).
    END.
    ELSE DO:
       RUN dop/MESSAGE.p ("N∆o foi poss°vel imprimir!",
                          "Conta n∆o encontrada.").
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME btn-imp-geral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-imp-geral C-Win
ON CHOOSE OF btn-imp-geral IN FRAME DEFAULT-FRAME /* Imprime */
DO:
   IF AVAIL tt-cta THEN DO:
      RUN dop/doc024a.w (INPUT "ccusto",
                        INPUT c-cod-ccusto,
                        INPUT da-ini,
                        INPUT da-fim,
                        INPUT c-lista-ccusto,
                        INPUT "",
                        INPUT TABLE tt-cta,
                        INPUT TABLE tt-detalhe).
   END.
   ELSE DO:
      RUN dop/MESSAGE.p ("N∆o foi poss°vel imprimir!",
                         "Contas n∆o encontradas.").
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME btn-next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-next C-Win
ON CHOOSE OF btn-next IN FRAME frame-cc
DO:
    ASSIGN da-ini = da-ini - DAY(da-ini) + 40
           da-ini = da-ini - DAY(da-ini) + 1
           da-fim = da-ini + 40
           da-fim = da-fim - DAY(da-fim).
    DISP da-ini
         da-fim WITH FRAME frame-cc.
    DISP da-ini
         da-fim WITH FRAME frame-grp.
    RUN pi-limpa-valores.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME btn-next-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-next-2 C-Win
ON CHOOSE OF btn-next-2 IN FRAME frame-grp
DO:
    ASSIGN da-ini = da-ini - DAY(da-ini) + 40
           da-ini = da-ini - DAY(da-ini) + 1
           da-fim = da-ini + 40
           da-fim = da-fim - DAY(da-fim).
    DISP da-ini
         da-fim WITH FRAME frame-cc.
    DISP da-ini
         da-fim WITH FRAME frame-grp.
    RUN pi-limpa-valores.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-detalhamento
&Scoped-define SELF-NAME btn-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-origem C-Win
ON CHOOSE OF btn-origem IN FRAME f-detalhamento /* Detalhe */
DO:
    IF AVAIL tt-detalhe THEN DO:
       FIND dc-orc-realizado NO-LOCK
           WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
           AND   dc-orc-realizado.cod_estab        = tt-detalhe.cod_estab
           AND   dc-orc-realizado.cod_plano_ctbl   = "PCDOCOL"
           AND   dc-orc-realizado.cod_cta_ctbl     = tt-detalhe.cod_cta_ctbl
           AND   dc-orc-realizado.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
           AND   dc-orc-realizado.cod_ccusto       = tt-detalhe.cod_ccusto
           AND   dc-orc-realizado.modulo           = tt-detalhe.cod_modul_dtsul
           AND   dc-orc-realizado.data             = tt-detalhe.dat_transacao NO-ERROR.
       IF AVAIL dc-orc-realizado THEN DO:
           RUN dop/doc024d.w (INPUT ROWID(dc-orc-realizado)).
           RETURN NO-APPLY.
       END.

       IF tt-detalhe.cod_modul_dtsul = "APB" THEN DO:
          FIND FIRST movto_tit_ap NO-LOCK
               WHERE movto_tit_ap.cod_estab           = tt-detalhe.cod_estab
                 AND movto_tit_ap.num_id_movto_tit_ap = tt-detalhe.num_id_movto_tit_ap NO-ERROR.
          IF AVAIL movto_tit_ap THEN DO:
             FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
          END.
          IF AVAIL tit_ap THEN DO:
             ASSIGN v_rec_tit_ap       = RECID(tit_ap)
                    v_rec_movto_tit_ap = RECID(movto_tit_ap).
             RUN prgfin/apb/apb223ia.r.
          END.
          ELSE DO:
             RUN dop/MESSAGE.p ("Movimento Origem n∆o encontrado!",
                                "").
          END.
       END.

       IF tt-detalhe.cod_modul_dtsul = "CEP" THEN DO:
          IF tt-detalhe.nr-trans = 0 THEN DO:
             RUN dop/message2.p ("Movimento Origem n∆o encontrado!",
                                 "Gerar Grade Cont†bil de Estoque para detalhar lanáamento?").
             IF RETURN-VALUE = "yes" THEN DO:
                ASSIGN c-est-doc023        = tt-detalhe.cod_estab
                       c-cta-doc023        = tt-detalhe.cod_cta_ctbl
                       c-ccusto-doc023     = c-lista-ccusto
                       da-trans-ini-doc023 = da-ini
                       da-trans-fim-doc023 = da-fim.
                RUN dop/dce004r.w.
             END.
             ELSE DO:
                RETURN NO-APPLY.
             END.
          END.
          ELSE DO:
             FIND FIRST movind.movto-estoq NO-LOCK
                  WHERE movind.movto-estoq.nr-trans = tt-detalhe.nr-trans NO-ERROR.
             IF AVAIL movind.movto-estoq THEN
                FIND FIRST movind.docum-est OF movind.movto-estoq NO-LOCK NO-ERROR.
             IF AVAIL movind.docum-est THEN
                ASSIGN gr-documento = ROWID(movind.docum-est).
             RUN rep/re0701.r.
          END.
       END.

       IF tt-detalhe.cod_modul_dtsul = "FGL" THEN DO:
          FIND FIRST item_lancto_ctbl NO-LOCK
               WHERE item_lancto_ctbl.num_lote_ctbl       = tt-detalhe.num_lote_ctbl      
                 AND item_lancto_ctbl.num_lancto_ctbl     = tt-detalhe.num_lancto_ctbl
                 AND item_lancto_ctbl.num_seq_lancto_ctbl = tt-detalhe.num_seq_lancto_ctbl NO-ERROR.
          IF AVAIL item_lancto_ctbl THEN DO:
             ASSIGN v_rec_item_lancto_ctbl = RECID(item_lancto_ctbl).
             RUN prgfin/fgl/fgl702ja.r.
          END.
          ELSE DO:
             RUN dop/MESSAGE.p ("Movimento Origem n∆o encontrado!",
                                "").
          END.
       END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME btn-pesq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-pesq C-Win
ON CHOOSE OF btn-pesq IN FRAME frame-cc
DO:
    IF YEAR(da-ini) <> YEAR(da-fim) THEN DO:
        RUN dop/MESSAGE.p ("Datas inv†lidas!",
                           "A datas devem ser do mesmo exerc°cio.").
        APPLY "entry" TO da-ini IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        RUN pi-limpa-valores.
        
        ASSIGN c-lista-ccusto.
        
        RUN pi-pesq-modulos.
        
        RUN pi-monta-br-contas.
        
        RUN pi-abre-contas.
        
        DISP de-tot-orcado
             de-tot-previsto
             de-tot-realiz 
             de-val-variac WITH FRAME DEFAULT-FRAME.
        
        APPLY "entry" TO br-contas IN FRAME DEFAULT-FRAME.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME btn-pesq-grp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-pesq-grp C-Win
ON CHOOSE OF btn-pesq-grp IN FRAME frame-grp
DO:
    IF YEAR(da-ini) <> YEAR(da-fim) THEN DO:
       RUN dop/MESSAGE.p ("Datas inv†lidas!",
                          "A datas devem ser do mesmo exerc°cio.").
       APPLY "entry" TO da-ini IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
       RUN pi-limpa-valores.
    
       ASSIGN c-cod-grupo.
      
       RUN pi-pesq-modulos-grp.
       
       RUN pi-monta-br-contas-grp.

       RUN pi-abre-contas.
       
       DISP de-tot-orcado
            de-tot-previsto
            de-tot-realiz 
            de-val-variac WITH FRAME DEFAULT-FRAME.
       
       APPLY "entry" TO br-contas IN FRAME DEFAULT-FRAME.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME btn-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-prev C-Win
ON CHOOSE OF btn-prev IN FRAME frame-cc
DO:
  ASSIGN da-fim = da-ini - DAY(da-ini)
         da-ini = DATE(MONTH(da-fim),01,YEAR(da-fim)).
  DISP da-ini
       da-fim WITH FRAME frame-cc.
  DISP da-ini
       da-fim WITH FRAME frame-grp.
  RUN pi-limpa-valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME btn-prev-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-prev-2 C-Win
ON CHOOSE OF btn-prev-2 IN FRAME frame-grp
DO:
  ASSIGN da-fim = da-ini - DAY(da-ini)
         da-ini = DATE(MONTH(da-fim),01,YEAR(da-fim)).
  DISP da-ini
       da-fim WITH FRAME frame-cc.
  DISP da-ini
       da-fim WITH FRAME frame-grp.
  RUN pi-limpa-valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME btn-res-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-res-ccusto C-Win
ON CHOOSE OF btn-res-ccusto IN FRAME DEFAULT-FRAME /* Resumo CCusto */
DO:
  RUN pi-frame(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-res-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-res-origem C-Win
ON CHOOSE OF btn-res-origem IN FRAME DEFAULT-FRAME /* Resumo Origem */
DO:
    RUN pi-frame(3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME btn-sel-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-sel-ccusto C-Win
ON CHOOSE OF btn-sel-ccusto IN FRAME frame-cc
DO:
    FIND FIRST tt-ccusto NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-ccusto THEN DO:
       RUN dop/MESSAGE.p ("Informe o Centro de Custo!",
                          "Para selecionar os centros de custos de pesquisa, informe primeiro o Centro de Custo Pai.").
       APPLY "entry" TO c-cod-ccusto IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
       ASSIGN  INPUT FRAME {&FRAME-NAME} c-lista-ccusto.
       RUN dozoom/doc023z.w (INPUT TABLE tt-ccusto,
                             INPUT-OUTPUT c-lista-ccusto).
       DISPLAY c-lista-ccusto WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto C-Win
ON ENTER OF c-cod-ccusto IN FRAME frame-cc /* Centro de Custo */
DO:
    APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto C-Win
ON LEAVE OF c-cod-ccusto IN FRAME frame-cc /* Centro de Custo */
DO:
    DEF VAR log-segur-ccusto AS LOG NO-UNDO.

    RUN pi-limpa-valores.

    ASSIGN c-cod-ccusto
           c-lista-ccusto   = ""
           log-segur-ccusto = NO.

    FOR EACH tt-ccusto:
        DELETE tt-ccusto.
    END.

    IF c-cod-ccusto = "" THEN
        RETURN 'NOK'.

    FIND FIRST emsuni.ccusto NO-LOCK
         WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
           AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
           AND emsuni.ccusto.cod_ccusto       = c-cod-ccusto NO-ERROR.
    IF NOT AVAIL emsuni.ccusto THEN DO:
       RUN dop/MESSAGE.p ("Centro de Custo n∆o Cadastrado!",
                          "").
       RETURN 'NOK'.
    END.

    RELEASE usuar_grp_usuar NO-ERROR.

    FIND FIRST usuar_grp_usuar NO-LOCK
         WHERE (usuar_grp_usuar.cod_grp_usuar = "ctb" OR /* Contabilidade */
                usuar_grp_usuar.cod_grp_usuar = "bdg" OR /* Respons†vel pelo Oráamento */
                usuar_grp_usuar.cod_grp_usuar = "aud" OR /* Auditoria */
                usuar_grp_usuar.cod_grp_usuar = "tcc")   /* Acessa Todos os Centros de Custo */
           AND usuar_grp_usuar.cod_usuario    = v_cod_usuar_corren NO-ERROR.

    IF AVAIL usuar_grp_usuar THEN DO:
       ASSIGN log-segur-ccusto = YES.
    END.
    ELSE DO:
       FOR EACH segur_ccusto NO-LOCK
          WHERE segur_ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
            AND segur_ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
            AND segur_ccusto.cod_ccusto       = c-cod-ccusto
            AND (segur_ccusto.cod_grp_usuar   BEGINS "c0" OR /* Somente considerar grupos usados para Seguranáa por CC */
                 segur_ccusto.cod_grp_usuar   BEGINS "c1" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c2" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c3" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c4" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c5" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c6" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c7" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c8" OR
                 segur_ccusto.cod_grp_usuar   BEGINS "c9"):
          FIND FIRST usuar_grp_usuar NO-LOCK
               WHERE usuar_grp_usuar.cod_grp_usuar = segur_ccusto.cod_grp_usuar
                 AND usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren NO-ERROR.
          IF AVAIL usuar_grp_usuar THEN DO:
             ASSIGN log-segur-ccusto = YES.
             LEAVE.
          END.
       END.
    END.

    IF NOT log-segur-ccusto THEN DO:
        IF  c-cod-ccusto <> "" THEN
            RUN dop/MESSAGE.p ("Usu†rio sem Acesso ao Centro de Custo!",
                               "N∆o ser† poss°vel consultar as despesas realizadas.").
    END.
    ELSE DO:
    
       CREATE tt-ccusto.
       ASSIGN tt-ccusto.cod_ccusto = c-cod-ccusto.
    
       RUN pi-pesq-ccusto-filho (INPUT tt-ccusto.cod_ccusto).

       FOR EACH tt-ccusto NO-LOCK.
           ASSIGN c-lista-ccusto = c-lista-ccusto + IF c-lista-ccusto = ""
                                                       THEN tt-ccusto.cod_ccusto
                                                       ELSE "," + tt-ccusto.cod_ccusto.
       END.
       DISP c-lista-ccusto WITH FRAME frame-cc.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME c-cod-grupo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grupo C-Win
ON ENTER OF c-cod-grupo IN FRAME frame-grp /* Grupo OBZ */
DO:
    APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grupo C-Win
ON F5 OF c-cod-grupo IN FRAME frame-grp /* Grupo OBZ */
DO:
  {include/zoomvar.i  &prog-zoom=dozoom/doc025z.w
                      &campo=c-cod-grupo 
                      &campozoom=cod-grupo
                      &frame=frame-grp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grupo C-Win
ON LEAVE OF c-cod-grupo IN FRAME frame-grp /* Grupo OBZ */
DO:

    RUN pi-limpa-valores.

    ASSIGN INPUT FRAME frame-grp c-cod-grupo.
   

    IF c-cod-grupo = "" THEN
        RETURN 'NOK'.

    IF NOT CAN-FIND(FIRST dc-orc-grupo NO-LOCK
                    WHERE dc-orc-grupo.cod-grupo = c-cod-grupo) THEN DO:
        RUN dop/MESSAGE.p ("Grupo OBZ inexistente!",
                          "").
        RETURN 'NOK'.

    END.

    IF NOT CAN-FIND(FIRST dc-orc-grupo-usuar 
                    WHERE dc-orc-grupo-usuar.cod-grupo   = c-cod-grupo
                      AND dc-orc-grupo-usuar.cod_usuario = v_cod_usuar_corren) THEN DO:
        RUN dop/MESSAGE.p ("Usu†rio sem permiss∆o para o grupo informado!",
                          "").
        ASSIGN c-cod-grupo = "".
        DISP c-cod-grupo WITH FRAME frame-grp.
        RETURN 'NOK'.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grupo C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-grupo IN FRAME frame-grp /* Grupo OBZ */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME c-lista-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lista-ccusto C-Win
ON ENTER OF c-lista-ccusto IN FRAME frame-cc /* Pesq CCusto */
DO:
  APPLY "leave" TO c-cod-ccusto IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME da-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-fim C-Win
ON LEAVE OF da-fim IN FRAME frame-grp
DO:
   ASSIGN da-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-cc
&Scoped-define SELF-NAME da-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-fim C-Win
ON LEAVE OF da-fim IN FRAME frame-cc
DO:
   ASSIGN da-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-ini C-Win
ON LEAVE OF da-ini IN FRAME frame-cc /* Data Transaá∆o */
DO:
   ASSIGN da-ini.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame-grp
&Scoped-define SELF-NAME da-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-ini C-Win
ON LEAVE OF da-ini IN FRAME frame-grp /* Data Transaá∆o */
DO:
   ASSIGN da-ini.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME rs-tipo-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-filtro C-Win
ON VALUE-CHANGED OF rs-tipo-filtro IN FRAME DEFAULT-FRAME
DO:
  ASSIGN INPUT FRAME {&FRAME-NAME} rs-tipo-filtro.

  CASE INPUT FRAME DEFAULT-FRAME rs-tipo-filtro:
      WHEN 1 THEN DO:
          ASSIGN FRAME frame-cc:HIDDEN     = NO
                 FRAME frame-cc:SENSITIVE  = YES
                 frame frame-grp:HIDDEN    = YES    
                 frame frame-grp:SENSITIVE = NO.

      END.
      WHEN 2 THEN DO:
          ASSIGN frame frame-cc:HIDDEN     = YES
                 frame frame-cc:SENSITIVE  = NO
                 frame frame-grp:HIDDEN    = NO    
                 frame frame-grp:SENSITIVE = YES.

      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contas
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
                                                             
FIND FIRST estabelec WHERE estabelec.ep-codigo = v_cdn_empres_usuar NO-LOCK NO-ERROR.

ASSIGN c-cod-estabel = estabelec.cod-estabel.

c-cod-grupo:LOAD-MOUSE-POINTER("image/lupa.cur").

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  ASSIGN da-ini = DATE(MONTH(TODAY),01,YEAR(TODAY))
         da-fim = ADD-INTERVAL(da-ini,1,"month") - 1 /*TODAY*/.

  {doinc/dsg998.i} /* Sugest∆o cc-plano conforme empresa */
  {doinc/dsg999.i} /* Sugest∆o c-cod-estab conforme empresa */

  FIND FIRST prog_dtsul NO-LOCK
       WHERE prog_dtsul.cod_prog_dtsul = "doc023" NO-ERROR.
  IF prog_dtsul.log_gera_log_exec = yes then do transaction:
     create log_exec_prog_dtsul.
     assign log_exec_prog_dtsul.cod_prog_dtsul           = "doc023"
            log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
            log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
            log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
            log_exec_prog_dtsul.dat_fim_exec_prog_dtsul  = today                                                    
            log_exec_prog_dtsul.hra_fim_exec_prog_dtsul  = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":",""). 
     assign v_rec_log = recid(log_exec_prog_dtsul).
     release log_exec_prog_dtsul no-error.
  end.

  RUN enable_UI.
  
  RUN pi-inicio.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY rs-tipo-filtro de-tot-orcado de-tot-previsto de-tot-realiz 
          de-val-variac 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-3 rs-tipo-filtro br-contas btn-res-origem btn-res-ccusto 
         btn-detalhamento btn-imp-geral de-tot-orcado de-tot-previsto 
         de-tot-realiz de-val-variac 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY c-cod-ccusto da-ini da-fim c-lista-ccusto 
      WITH FRAME frame-cc IN WINDOW C-Win.
  ENABLE c-cod-ccusto bt-leave-cod-ccusto da-ini da-fim btn-prev btn-next 
         btn-pesq bt-exit btn-sel-ccusto c-lista-ccusto 
      WITH FRAME frame-cc IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frame-cc}
  DISPLAY c-cod-grupo da-ini da-fim 
      WITH FRAME frame-grp IN WINDOW C-Win.
  ENABLE c-cod-grupo bt-leave-grp da-ini da-fim btn-prev-2 btn-next-2 
         btn-pesq-grp bt-exit-2 
      WITH FRAME frame-grp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frame-grp}
  ENABLE br-detalhamento btn-origem btn-imp-cta 
      WITH FRAME f-detalhamento IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-detalhamento}
  ENABLE br-res-ccusto btn-imp-ccusto 
      WITH FRAME f-res-ccusto IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-res-ccusto}
  ENABLE br-res-origem btn-detalhe-res-origem 
      WITH FRAME f-res-origem IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-res-origem}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-contas C-Win 
PROCEDURE pi-abre-contas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE i-clas-cta:

       WHEN 1 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY tt-cta.cod_cta_ctbl INDEXED-REPOSITION.
       WHEN 2 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY cta_ctbl.des_tit_ctbl.
       WHEN 3 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY tt-cta.val-orcado DESC
                                              BY tt-cta.val-variac DESC
                                              BY tt-cta.val-realiz DESC
                                              BY tt-cta.val-previsto DESC
                                              BY tt-cta.cod_cta_ctbl INDEXED-REPOSITION.
       WHEN 4 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY tt-cta.val-realiz DESC
                                              BY tt-cta.val-variac DESC
                                              BY tt-cta.val-orcado DESC
                                              BY tt-cta.val-previsto DESC
                                              BY tt-cta.cod_cta_ctbl INDEXED-REPOSITION.
       WHEN 5 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY tt-cta.val-variac DESC
                                              BY tt-cta.val-realiz DESC
                                              BY tt-cta.val-orcado DESC
                                              BY tt-cta.val-previsto DESC
                                              BY tt-cta.cod_cta_ctbl INDEXED-REPOSITION.
       WHEN 6 THEN OPEN QUERY br-contas FOR EACH tt-cta
                                           WHERE tt-cta.val-realiz   <> 0
                                              OR tt-cta.val-previsto <> 0
                                              OR tt-cta.val-orcado   <> 0,
                                           FIRST cta_ctbl NO-LOCK
                                           WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                                             AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
                                              BY tt-cta.val-previsto DESC
                                              BY tt-cta.val-variac DESC
                                              BY tt-cta.val-realiz DESC
                                              BY tt-cta.val-orcado DESC
                                              BY tt-cta.cod_cta_ctbl INDEXED-REPOSITION.
    END CASE.

    {&open-query-br-res-origem}

    APPLY "value-changed" TO br-contas IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-detalhamento C-Win 
PROCEDURE pi-abre-detalhamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE i-clas-det:

       WHEN 1 THEN OPEN QUERY br-detalhamento FOR EACH tt-detalhe
                                                 WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                    BY tt-detalhe.cod_cta_ctbl
                                                    BY tt-detalhe.cod_ccusto
                                                    BY tt-detalhe.val-movto DESC
                                                    BY tt-detalhe.dat_transacao.
       WHEN 2 THEN OPEN QUERY br-detalhamento FOR EACH tt-detalhe
                                                 WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                    BY tt-detalhe.cod_cta_ctbl
                                                    BY tt-detalhe.dat_transacao
                                                    BY tt-detalhe.val-movto DESC
                                                    BY tt-detalhe.cod_ccusto.
       WHEN 3 THEN OPEN QUERY br-detalhamento FOR EACH tt-detalhe
                                                 WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                    BY tt-detalhe.cod_cta_ctbl
                                                    BY tt-detalhe.cod_modul_dtsul
                                                    BY tt-detalhe.val-movto DESC
                                                    BY tt-detalhe.cod_ccusto
                                                    BY tt-detalhe.dat_transacao.
       WHEN 4 THEN OPEN QUERY br-detalhamento FOR EACH tt-detalhe
                                                 WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                    BY tt-detalhe.cod_cta_ctbl
                                                    BY tt-detalhe.val-movto DESC
                                                    BY tt-detalhe.cod_ccusto
                                                    BY tt-detalhe.dat_transacao.
       WHEN 5 THEN OPEN QUERY br-detalhamento FOR EACH tt-detalhe
                                                 WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                    BY tt-detalhe.cod_cta_ctbl
                                                    BY tt-detalhe.descricao
                                                    BY tt-detalhe.val-movto DESC
                                                    BY tt-detalhe.cod_ccusto
                                                    BY tt-detalhe.dat_transacao.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-res-ccusto C-Win 
PROCEDURE pi-abre-res-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE i-clas-rcc:

       WHEN 1 THEN OPEN QUERY br-res-ccusto FOR EACH tt-ccusto-cta
                                               WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.cod_ccusto.
       WHEN 2 THEN OPEN QUERY br-res-ccusto FOR EACH tt-ccusto-cta
                                               WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.des_tit_ctbl.
       WHEN 3 THEN OPEN QUERY br-res-ccusto FOR EACH tt-ccusto-cta
                                               WHERE tt-ccusto-cta.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.cod_cta_ctbl
                                                  BY tt-ccusto-cta.val-movto DESC.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frame C-Win 
PROCEDURE pi-frame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-i-frame   AS INTEGER      NO-UNDO.
    
    IF  i-posicao-frame <> 0 THEN
        ASSIGN h-lista-frames[i-posicao-frame]:HIDDEN    = YES
               h-lista-botoes[i-posicao-frame]:SENSITIVE = YES.
    
    ASSIGN  h-lista-frames[p-i-frame]:HIDDEN    = NO
            h-lista-botoes[p-i-frame]:SENSITIVE = NO.
            i-posicao-frame                     = p-i-frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicio C-Win 
PROCEDURE pi-inicio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "value-changed" TO rs-tipo-filtro IN FRAME DEFAULT-FRAME.

    ASSIGN  h-lista-frames[01]  = FRAME f-detalhamento:HANDLE
            h-lista-frames[02]  = FRAME f-res-ccusto  :HANDLE
            h-lista-frames[03]  = FRAME f-res-origem  :HANDLE

            h-lista-botoes[01]  = btn-detalhamento:HANDLE IN FRAME default-frame
            h-lista-botoes[02]  = btn-res-ccusto  :HANDLE IN FRAME default-frame
            h-lista-botoes[03]  = btn-res-origem  :HANDLE IN FRAME default-frame.
    DO  i-cont = 1 TO 2:
        IF  VALID-HANDLE(h-lista-frames[i-cont]) THEN
            ASSIGN  h-lista-frames[i-cont]:HIDDEN = YES.    
    END.
    RUN pi-frame(3).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-valores C-Win 
PROCEDURE pi-limpa-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-cta.
    EMPTY TEMP-TABLE tt-detalhe.
    EMPTY TEMP-TABLE tt-ccusto-cta.

    ASSIGN de-tot-orcado   = 0
           de-tot-realiz   = 0
           de-tot-previsto = 0
           de-val-variac   = 0.

    {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
    {&OPEN-QUERY-br-detalhamento}
    {&OPEN-QUERY-br-res-ccusto}

    DISP c-lista-ccusto WITH FRAME frame-cc.

    DISP de-tot-orcado
         de-tot-realiz 
         de-val-variac
         de-tot-previsto
          WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-br-contas C-Win 
PROCEDURE pi-monta-br-contas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR h-acomp        AS HANDLE NO-UNDO.
    DEF VAR i-periodo      AS INT    NO-UNDO.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Processando...").
    RUN pi-acompanhar IN h-acomp (INPUT "Compondo Vis‰es...").
    
    EMPTY TEMP-TABLE tt-cta.
    EMPTY TEMP-TABLE tt-detalhe.
    EMPTY TEMP-TABLE tt-ccusto-cta.

    ASSIGN de-tot-orcado   = 0
           de-tot-realiz   = 0
           de-val-variac   = 0
           de-tot-previsto = 0.

    DO i-cont = 1 TO NUM-ENTRIES(c-lista-ccusto):
       FIND FIRST tt-ccusto NO-LOCK
            WHERE tt-ccusto.cod_ccusto = ENTRY(i-cont,c-lista-ccusto,",") NO-ERROR.
       IF NOT AVAIL tt-ccusto THEN NEXT.
       FIND FIRST emsuni.ccusto NO-LOCK
            WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
              AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
              AND emsuni.ccusto.cod_ccusto       = tt-ccusto.cod_ccusto NO-ERROR.

       FOR EACH dc-desp-ccusto NO-LOCK
          WHERE dc-desp-ccusto.cod_ccusto     = tt-ccusto.cod_ccusto
             AND dc-desp-ccusto.cod_estab      = c-cod-estabel 
            AND dc-desp-ccusto.dat_transacao >= da-ini
            AND dc-desp-ccusto.dat_transacao <= da-fim:
           
          FIND FIRST tt-cta NO-LOCK
               WHERE tt-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl NO-ERROR.
          IF NOT AVAIL tt-cta THEN DO:
             CREATE tt-cta.
             ASSIGN tt-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl.
          END.
          ASSIGN tt-cta.val-realiz   = tt-cta.val-realiz + dc-desp-ccusto.val-movto
                 tt-cta.val-previsto = tt-cta.val-previsto + dc-desp-ccusto.val-previsto.

          CREATE tt-detalhe.
          ASSIGN tt-detalhe.cod_cta_ctbl        = dc-desp-ccusto.cod_cta_ctbl
                 tt-detalhe.cod_ccusto          = dc-desp-ccusto.cod_ccusto
                 tt-detalhe.dat_transacao       = dc-desp-ccusto.dat_transacao
                 tt-detalhe.cod_modul_dtsul     = dc-desp-ccusto.cod_modul_dtsul
                 tt-detalhe.cod_estab           = dc-desp-ccusto.cod_estab
                 tt-detalhe.num_id_movto_tit_ap = dc-desp-ccusto.num_id_movto_tit_ap
                 tt-detalhe.nr-trans            = dc-desp-ccusto.nr-trans
                 tt-detalhe.num_lote_ctbl       = dc-desp-ccusto.num_lote_ctbl      
                 tt-detalhe.num_lancto_ctbl     = dc-desp-ccusto.num_lancto_ctbl    
                 tt-detalhe.num_seq_lancto_ctbl = dc-desp-ccusto.num_seq_lancto_ctbl
                 tt-detalhe.descricao           = dc-desp-ccusto.descricao
                 tt-detalhe.val-movto           = dc-desp-ccusto.val-movto
                 tt-detalhe.val-previsto        = dc-desp-ccusto.val-previsto
                 de-tot-realiz                  = de-tot-realiz + tt-detalhe.val-movto
                 de-tot-previsto                = de-tot-previsto + tt-detalhe.val-previsto.

          FIND FIRST tt-ccusto-cta
               WHERE tt-ccusto-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl
                 AND tt-ccusto-cta.cod_ccusto   = dc-desp-ccusto.cod_ccusto NO-ERROR.
          IF NOT AVAIL tt-ccusto-cta THEN DO:
             CREATE tt-ccusto-cta.
             ASSIGN tt-ccusto-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl
                    tt-ccusto-cta.cod_ccusto   = dc-desp-ccusto.cod_ccusto.
             
             IF AVAIL emsuni.ccusto THEN
                ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
          END.
          ASSIGN tt-ccusto-cta.val-movto = tt-ccusto-cta.val-movto + dc-desp-ccusto.val-movto
                 tt-ccusto-cta.val-previsto = tt-ccusto-cta.val-previsto + dc-desp-ccusto.val-previsto.
       END.
       FOR EACH dc-orc-realizado NO-LOCK
           WHERE dc-orc-realizado.modulo           = ""
           AND   dc-orc-realizado.data            >= da-ini
           AND   dc-orc-realizado.data            <= da-fim
           AND   dc-orc-realizado.cod_empresa      = emsuni.ccusto.cod_empresa
           AND   dc-orc-realizado.cod_plano_ccusto = emsuni.ccusto.cod_plano_ccusto
           AND   dc-orc-realizado.cod_ccusto       = emsuni.ccusto.cod_ccusto:

           FIND FIRST tt-cta NO-LOCK
                WHERE tt-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl NO-ERROR.
           IF NOT AVAIL tt-cta THEN DO:
              CREATE tt-cta.
              ASSIGN tt-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl.
           END.
           ASSIGN tt-cta.val-orcado = tt-cta.val-orcado + dc-orc-realizado.valor-orcto
                  de-tot-orcado     = de-tot-orcado     + dc-orc-realizado.valor-orcto.

           /* Oráamento por Centro de Custo */
           FIND FIRST tt-ccusto-cta
                WHERE tt-ccusto-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl
                  AND tt-ccusto-cta.cod_ccusto   = dc-orc-realizado.cod_ccusto   NO-ERROR.
           IF NOT AVAIL tt-ccusto-cta THEN DO:
              CREATE tt-ccusto-cta.
              ASSIGN tt-ccusto-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl
                     tt-ccusto-cta.cod_ccusto   = dc-orc-realizado.cod_ccusto.
              IF AVAIL emsuni.ccusto THEN
                 ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
           END.
           ASSIGN tt-ccusto-cta.val-orcado = tt-ccusto-cta.val-orcado + dc-orc-realizado.valor-orcto.

       END.

       /*
       DO i-periodo = MONTH(da-ini) TO MONTH(da-fim):
          
          FOR EACH sdo_orcto_ctbl_bgc NO-LOCK
             WHERE sdo_orcto_ctbl_bgc.cod_empresa         = "DOC"
               AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = "CCDOCOL"
               AND sdo_orcto_ctbl_bgc.cod_ccusto          = tt-ccusto.cod_ccusto
               AND sdo_orcto_ctbl_bgc.cod_cenar_orctario  = "Orc-" + STRING(YEAR(da-fim))
               AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = "Docol"
               AND sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl  = 1
               AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl BEGINS "1"
               AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = "Fiscal"
               AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = STRING(YEAR(da-fim))
               AND sdo_orcto_ctbl_bgc.num_period_ctbl     = i-periodo
               AND sdo_orcto_ctbl_bgc.cod_cta_ctbl        < "7"
               AND NOT sdo_orcto_ctbl_bgc.cod_cta_ctbl BEGINS "4319" .
    
             IF sdo_orcto_ctbl_bgc.val_orcado = 0 THEN NEXT.
    
             FIND FIRST tt-cta NO-LOCK
                  WHERE tt-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl NO-ERROR.
             IF NOT AVAIL tt-cta THEN DO:
                CREATE tt-cta.
                ASSIGN tt-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl.
             END.
             ASSIGN tt-cta.val-orcado = tt-cta.val-orcado + sdo_orcto_ctbl_bgc.val_orcado
                    de-tot-orcado     = de-tot-orcado     + sdo_orcto_ctbl_bgc.val_orcado.

             /* Oráamento por Centro de Custo */
             FIND FIRST tt-ccusto-cta
                  WHERE tt-ccusto-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                    AND tt-ccusto-cta.cod_ccusto   = sdo_orcto_ctbl_bgc.cod_ccusto   NO-ERROR.
             IF NOT AVAIL tt-ccusto-cta THEN DO:
                CREATE tt-ccusto-cta.
                ASSIGN tt-ccusto-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                       tt-ccusto-cta.cod_ccusto   = sdo_orcto_ctbl_bgc.cod_ccusto.
                FIND FIRST emsuni.ccusto NO-LOCK
                     WHERE emsuni.ccusto.cod_empresa      = "DOC"
                       AND emsuni.ccusto.cod_plano_ccusto = "CCDOCOL"
                       AND emsuni.ccusto.cod_ccusto       = tt-ccusto-cta.cod_ccusto NO-ERROR.
                IF AVAIL emsuni.ccusto THEN
                   ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
             END.
             ASSIGN tt-ccusto-cta.val-orcado = tt-ccusto-cta.val-orcado + sdo_orcto_ctbl_bgc.val_orcado.
             /* FIM-Oráamento por Centro de Custo */


          END.
          
       END.
       */

       FOR EACH tt-cta.
           IF tt-cta.val-realiz <> 0 THEN
              ASSIGN tt-cta.val-variac = (tt-cta.val-realiz / tt-cta.val-orcado) * 100.
       END.
    END.

    ASSIGN de-val-variac = (de-tot-realiz / de-tot-orcado) * 100.

    /* Carrega resumo por origem */
    EMPTY TEMP-TABLE tt-res-origem.

    FOR EACH tt-detalhe:
        FIND FIRST tt-res-origem WHERE
                   tt-res-origem.cod_cta_ctbl    = tt-detalhe.cod_cta_ctbl    AND
                   tt-res-origem.cod_modul_dtsul = tt-detalhe.cod_modul_dtsul NO-ERROR.
        IF NOT AVAIL tt-res-origem THEN DO:
            CREATE tt-res-origem.
            ASSIGN tt-res-origem.cod_cta_ctbl    = tt-detalhe.cod_cta_ctbl
                   tt-res-origem.cod_modul_dtsul = tt-detalhe.cod_modul_dtsul
                   tt-res-origem.descricao       = tt-detalhe.descricao.
        END.

        ASSIGN tt-res-origem.val-movto    = tt-res-origem.val-movto    + tt-detalhe.val-movto
               tt-res-origem.val-previsto = tt-res-origem.val-previsto + tt-detalhe.val-previsto.
    END.

    RUN pi-finalizar IN h-acomp.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-br-contas-grp C-Win 
PROCEDURE pi-monta-br-contas-grp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR h-acomp        AS HANDLE NO-UNDO.
    DEF VAR i-periodo      AS INT    NO-UNDO.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Processando...").
    RUN pi-acompanhar IN h-acomp (INPUT "Compondo Vis‰es...").
    
    EMPTY TEMP-TABLE tt-cta.
    EMPTY TEMP-TABLE tt-detalhe.
    EMPTY TEMP-TABLE tt-ccusto-cta.

    ASSIGN de-tot-orcado   = 0
           de-tot-realiz   = 0
           de-val-variac   = 0
           de-tot-previsto = 0.

    FOR EACH dc-orc-grupo-conta NO-LOCK
       WHERE dc-orc-grupo-conta.cod-grupo = INPUT FRAME frame-grp c-cod-grupo:

       FOR EACH dc-desp-ccusto NO-LOCK
          WHERE dc-desp-ccusto.cod_cta_ctbl   = dc-orc-grupo-conta.cod_cta_ctbl
            AND dc-desp-ccusto.cod_estab      = c-cod-estabel 
            AND dc-desp-ccusto.dat_transacao >= da-ini
            AND dc-desp-ccusto.dat_transacao <= da-fim:
          FIND FIRST tt-cta NO-LOCK
               WHERE tt-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl NO-ERROR.
          IF NOT AVAIL tt-cta THEN DO:
             CREATE tt-cta.
             ASSIGN tt-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl.
          END.

          ASSIGN tt-cta.val-realiz   = tt-cta.val-realiz + dc-desp-ccusto.val-movto
                 tt-cta.val-previsto = tt-cta.val-previsto + dc-desp-ccusto.val-previsto.

          CREATE tt-detalhe.
          ASSIGN tt-detalhe.cod_cta_ctbl        = dc-desp-ccusto.cod_cta_ctbl
                 tt-detalhe.cod_ccusto          = dc-desp-ccusto.cod_ccusto
                 tt-detalhe.dat_transacao       = dc-desp-ccusto.dat_transacao
                 tt-detalhe.cod_modul_dtsul     = dc-desp-ccusto.cod_modul_dtsul
                 tt-detalhe.cod_estab           = dc-desp-ccusto.cod_estab
                 tt-detalhe.num_id_movto_tit_ap = dc-desp-ccusto.num_id_movto_tit_ap
                 tt-detalhe.nr-trans            = dc-desp-ccusto.nr-trans
                 tt-detalhe.num_lote_ctbl       = dc-desp-ccusto.num_lote_ctbl      
                 tt-detalhe.num_lancto_ctbl     = dc-desp-ccusto.num_lancto_ctbl    
                 tt-detalhe.num_seq_lancto_ctbl = dc-desp-ccusto.num_seq_lancto_ctbl
                 tt-detalhe.descricao           = dc-desp-ccusto.descricao
                 tt-detalhe.val-movto           = dc-desp-ccusto.val-movto
                 tt-detalhe.val-previsto        = dc-desp-ccusto.val-previsto
                 de-tot-realiz                  = de-tot-realiz + tt-detalhe.val-movto
                 de-tot-previsto                = de-tot-previsto + tt-detalhe.val-previsto.

          FIND FIRST tt-ccusto-cta
               WHERE tt-ccusto-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl
                 AND tt-ccusto-cta.cod_ccusto   = dc-desp-ccusto.cod_ccusto NO-ERROR.
          IF NOT AVAIL tt-ccusto-cta THEN DO:
             CREATE tt-ccusto-cta.
             ASSIGN tt-ccusto-cta.cod_cta_ctbl = dc-desp-ccusto.cod_cta_ctbl
                    tt-ccusto-cta.cod_ccusto   = dc-desp-ccusto.cod_ccusto.

             FIND FIRST emsuni.ccusto NO-LOCK
                  WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
                    AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
                    AND emsuni.ccusto.cod_ccusto       = dc-desp-ccusto.cod_ccusto NO-ERROR.
             
             IF AVAIL emsuni.ccusto THEN
                ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
          END.
          ASSIGN tt-ccusto-cta.val-movto = tt-ccusto-cta.val-movto + dc-desp-ccusto.val-movto
                 tt-ccusto-cta.val-previsto = tt-ccusto-cta.val-previsto + dc-desp-ccusto.val-previsto.
       END.

       FOR EACH dc-orc-realizado NO-LOCK
           WHERE dc-orc-realizado.modulo           = ""
           AND   dc-orc-realizado.data            >= da-ini
           AND   dc-orc-realizado.data            <= da-fim
           AND   dc-orc-realizado.cod_cta_ctbl     = dc-orc-grupo-conta.cod_cta_ctbl
           AND   dc-orc-realizado.cod_empresa      = v_cod_empres_usuar:

           FIND FIRST tt-cta NO-LOCK
                WHERE tt-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl NO-ERROR.
           IF NOT AVAIL tt-cta THEN DO:
              CREATE tt-cta.
              ASSIGN tt-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl.
           END.
           ASSIGN tt-cta.val-orcado = tt-cta.val-orcado + dc-orc-realizado.valor-orcto
                  de-tot-orcado     = de-tot-orcado     + dc-orc-realizado.valor-orcto.

           /* Oráamento por Centro de Custo */
           FIND FIRST tt-ccusto-cta
                WHERE tt-ccusto-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl
                  AND tt-ccusto-cta.cod_ccusto   = dc-orc-realizado.cod_ccusto   NO-ERROR.
           IF NOT AVAIL tt-ccusto-cta THEN DO:
              CREATE tt-ccusto-cta.
              ASSIGN tt-ccusto-cta.cod_cta_ctbl = dc-orc-realizado.cod_cta_ctbl
                     tt-ccusto-cta.cod_ccusto   = dc-orc-realizado.cod_ccusto.

              FIND FIRST emsuni.ccusto NO-LOCK
                  WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
                    AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
                    AND emsuni.ccusto.cod_ccusto       = dc-orc-realizado.cod_ccusto NO-ERROR.

              IF AVAIL emsuni.ccusto THEN
                 ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
           END.
           ASSIGN tt-ccusto-cta.val-orcado = tt-ccusto-cta.val-orcado + dc-orc-realizado.valor-orcto.

       END.

       /*
       DO i-periodo = MONTH(da-ini) TO MONTH(da-fim):
          
          FOR EACH sdo_orcto_ctbl_bgc NO-LOCK
             WHERE sdo_orcto_ctbl_bgc.cod_empresa         = "DOC"
               AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = "CCDOCOL"
               AND sdo_orcto_ctbl_bgc.cod_ccusto          = tt-ccusto.cod_ccusto
               AND sdo_orcto_ctbl_bgc.cod_cenar_orctario  = "Orc-" + STRING(YEAR(da-fim))
               AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = "Docol"
               AND sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl  = 1
               AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl BEGINS "1"
               AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = "Fiscal"
               AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = STRING(YEAR(da-fim))
               AND sdo_orcto_ctbl_bgc.num_period_ctbl     = i-periodo
               AND sdo_orcto_ctbl_bgc.cod_cta_ctbl        < "7"
               AND NOT sdo_orcto_ctbl_bgc.cod_cta_ctbl BEGINS "4319" .
    
             IF sdo_orcto_ctbl_bgc.val_orcado = 0 THEN NEXT.
    
             FIND FIRST tt-cta NO-LOCK
                  WHERE tt-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl NO-ERROR.
             IF NOT AVAIL tt-cta THEN DO:
                CREATE tt-cta.
                ASSIGN tt-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl.
             END.
             ASSIGN tt-cta.val-orcado = tt-cta.val-orcado + sdo_orcto_ctbl_bgc.val_orcado
                    de-tot-orcado     = de-tot-orcado     + sdo_orcto_ctbl_bgc.val_orcado.

             /* Oráamento por Centro de Custo */
             FIND FIRST tt-ccusto-cta
                  WHERE tt-ccusto-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                    AND tt-ccusto-cta.cod_ccusto   = sdo_orcto_ctbl_bgc.cod_ccusto   NO-ERROR.
             IF NOT AVAIL tt-ccusto-cta THEN DO:
                CREATE tt-ccusto-cta.
                ASSIGN tt-ccusto-cta.cod_cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                       tt-ccusto-cta.cod_ccusto   = sdo_orcto_ctbl_bgc.cod_ccusto.
                FIND FIRST emsuni.ccusto NO-LOCK
                     WHERE emsuni.ccusto.cod_empresa      = "DOC"
                       AND emsuni.ccusto.cod_plano_ccusto = "CCDOCOL"
                       AND emsuni.ccusto.cod_ccusto       = tt-ccusto-cta.cod_ccusto NO-ERROR.
                IF AVAIL emsuni.ccusto THEN
                   ASSIGN tt-ccusto-cta.des_tit_ctbl = emsuni.ccusto.des_tit_ctbl.
             END.
             ASSIGN tt-ccusto-cta.val-orcado = tt-ccusto-cta.val-orcado + sdo_orcto_ctbl_bgc.val_orcado.
             /* FIM-Oráamento por Centro de Custo */


          END.
          
       END.
       */

       FOR EACH tt-cta.
           IF tt-cta.val-realiz <> 0 THEN
              ASSIGN tt-cta.val-variac = (tt-cta.val-realiz / tt-cta.val-orcado) * 100.
       END.
    END.

    ASSIGN de-val-variac = (de-tot-realiz / de-tot-orcado) * 100.

    /* Carrega resumo por origem */
    EMPTY TEMP-TABLE tt-res-origem.

    FOR EACH tt-detalhe:
        FIND FIRST tt-res-origem WHERE
                   tt-res-origem.cod_cta_ctbl    = tt-detalhe.cod_cta_ctbl    AND
                   tt-res-origem.cod_modul_dtsul = tt-detalhe.cod_modul_dtsul NO-ERROR.
        IF NOT AVAIL tt-res-origem THEN DO:
            CREATE tt-res-origem.
            ASSIGN tt-res-origem.cod_cta_ctbl    = tt-detalhe.cod_cta_ctbl
                   tt-res-origem.cod_modul_dtsul = tt-detalhe.cod_modul_dtsul
                   tt-res-origem.descricao       = tt-detalhe.descricao.
        END.

        ASSIGN tt-res-origem.val-movto    = tt-res-origem.val-movto    + tt-detalhe.val-movto
               tt-res-origem.val-previsto = tt-res-origem.val-previsto + tt-detalhe.val-previsto.
    END.

    RUN pi-finalizar IN h-acomp.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pesq-ccusto-filho C-Win 
PROCEDURE pi-pesq-ccusto-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ccusto-pai AS CHAR NO-UNDO.
    FOR EACH estrut_ccusto NO-LOCK
       WHERE estrut_ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
         AND estrut_ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
         AND estrut_ccusto.cod_ccusto_pai   = p-ccusto-pai.
       CREATE tt-ccusto.
       ASSIGN tt-ccusto.cod_ccusto = estrut_ccusto.cod_ccusto_filho.

       RUN pi-pesq-ccusto-filho (INPUT tt-ccusto.cod_ccusto).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pesq-modulos C-Win 
PROCEDURE pi-pesq-modulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   DEF VAR da-aux         AS DATE   NO-UNDO.
   DEF VAR h-acomp        AS HANDLE NO-UNDO.

   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
   RUN pi-inicializar IN h-acomp (INPUT "Pesquisando...").
        
   DO i-cont = 1 TO NUM-ENTRIES(c-lista-ccusto):
      FIND FIRST tt-ccusto NO-LOCK
           WHERE tt-ccusto.cod_ccusto = ENTRY(i-cont,c-lista-ccusto,",") NO-ERROR.
      IF NOT AVAIL tt-ccusto THEN NEXT.
      
      RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo " + tt-ccusto.cod_ccusto).

      FOR EACH dc-desp-ccusto USE-INDEX ch-ccusto-data EXCLUSIVE-LOCK
         WHERE dc-desp-ccusto.cod_ccusto      = tt-ccusto.cod_ccusto
           AND dc-desp-ccusto.cod_estab       = c-cod-estabel 
           AND dc-desp-ccusto.dat_transacao  >= da-ini
           AND dc-desp-ccusto.dat_transacao  <= da-fim:
         DELETE dc-desp-ccusto.
      END.
            
      FIND FIRST emsuni.ccusto 
           WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
             AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
             AND emsuni.ccusto.cod_ccusto       = tt-ccusto.cod_ccusto NO-ERROR.

      FOR EACH tt-cta-pesq.
          DELETE tt-cta-pesq.
      END.
      
      FOR EACH item_lista_ccusto OF emsuni.ccusto NO-LOCK.
         FOR EACH mapa_distrib_ccusto OF item_lista_ccust NO-LOCK:
            FOR EACH criter_distrib_cta_ctbl OF mapa_distrib_ccusto NO-LOCK.
               FIND FIRST tt-cta-pesq NO-LOCK
                    WHERE tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab         
                      AND tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
                      AND tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl NO-ERROR.
               IF NOT AVAIL tt-cta-pesq THEN DO:
                  CREATE tt-cta-pesq.
                  ASSIGN tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab          
                         tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl 
                         tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl.
               END.
            END.
         END.
      END.

      FOR EACH criter_distrib_cta_ctbl NO-LOCK
         WHERE criter_distrib_cta_ctbl.cod_empresa               = v_cod_empres_usuar /*"DOC"*/
         AND   criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos".
         FIND FIRST tt-cta-pesq NO-LOCK
              WHERE tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab         
                AND tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
                AND tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl NO-ERROR.
         IF NOT AVAIL tt-cta-pesq THEN DO:
            CREATE tt-cta-pesq.
            ASSIGN tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab          
                   tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl 
                   tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl.
         END.
      END.

      FOR EACH tt-cta-pesq:
          FOR EACH dc-orc-realizado NO-LOCK
              WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
              AND   dc-orc-realizado.cod_estab        = tt-cta-pesq.cod_estab
              AND   dc-orc-realizado.cod_plano_ctbl   = tt-cta-pesq.cod_plano_cta_ctbl
              AND   dc-orc-realizado.cod_cta_ctbl     = tt-cta-pesq.cod_cta_ctbl
              AND   dc-orc-realizado.cod_plano_ccusto = emsuni.ccusto.cod_plano_ccusto
              AND   dc-orc-realizado.cod_ccusto       = emsuni.ccusto.cod_ccusto
              AND   dc-orc-realizado.modulo           > ""
              AND   dc-orc-realizado.data            >= da-ini
              AND   dc-orc-realizado.data            <= da-fim:

              CREATE dc-desp-ccusto.
              ASSIGN dc-desp-ccusto.cod_ccusto          = dc-orc-realizado.cod_ccusto 
                     dc-desp-ccusto.cod_cta_ctbl        = dc-orc-realizado.cod_cta_ctbl
                     dc-desp-ccusto.dat_transacao       = dc-orc-realizado.data
                     dc-desp-ccusto.cod_modul_dtsul     = dc-orc-realizado.modulo
                     dc-desp-ccusto.cod_estab           = dc-orc-realizado.cod_estab
                     dc-desp-ccusto.val-movto           = dc-orc-realizado.valor-realizado
                     dc-desp-ccusto.val-previsto        = dc-orc-realizado.valor-previsto
                     dc-desp-ccusto.descricao           = dc-orc-realizado.descricao.

          END.

      END.
   END.

   RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pesq-modulos-grp C-Win 
PROCEDURE pi-pesq-modulos-grp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   DEF VAR da-aux         AS DATE   NO-UNDO.
   DEF VAR h-acomp        AS HANDLE NO-UNDO.

   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
   RUN pi-inicializar IN h-acomp (INPUT "Pesquisando...").

   EMPTY TEMP-TABLE dc-desp-ccusto.
        
   FOR EACH dc-orc-grupo-conta NO-LOCK
      WHERE dc-orc-grupo-conta.cod-grupo = INPUT FRAME frame-grp c-cod-grupo:
      
      RUN pi-acompanhar IN h-acomp (INPUT "Conta " + dc-orc-grupo-conta.cod_cta_ctbl).

      FOR EACH tt-cta-pesq.
          DELETE tt-cta-pesq.
      END.
      
      FIND FIRST tt-cta-pesq NO-LOCK
           WHERE tt-cta-pesq.cod_estab          = c-cod-estab /*"9"*/        
             AND tt-cta-pesq.cod_plano_cta_ctbl = dc-orc-grupo-conta.cod_plano_ctbl
             AND tt-cta-pesq.cod_cta_ctbl       = dc-orc-grupo-conta.cod_cta_ctbl NO-ERROR.
      IF NOT AVAIL tt-cta-pesq THEN DO:
         CREATE tt-cta-pesq.
         ASSIGN tt-cta-pesq.cod_estab          = c-cod-estab /*"9"*/          
                tt-cta-pesq.cod_plano_cta_ctbl = dc-orc-grupo-conta.cod_plano_ctbl 
                tt-cta-pesq.cod_cta_ctbl       = dc-orc-grupo-conta.cod_cta_ctbl.
      END.

      FOR EACH tt-cta-pesq:

          FOR EACH dc-orc-realizado NO-LOCK
              WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
              AND   dc-orc-realizado.cod_estab        = tt-cta-pesq.cod_estab
              AND   dc-orc-realizado.cod_plano_ctbl   = tt-cta-pesq.cod_plano_cta_ctbl
              AND   dc-orc-realizado.cod_cta_ctbl     = tt-cta-pesq.cod_cta_ctbl
              AND   dc-orc-realizado.modulo           > ""
              AND   dc-orc-realizado.data            >= da-ini
              AND   dc-orc-realizado.data            <= da-fim:

              CREATE dc-desp-ccusto.
              ASSIGN dc-desp-ccusto.cod_ccusto          = dc-orc-realizado.cod_ccusto 
                     dc-desp-ccusto.cod_cta_ctbl        = dc-orc-realizado.cod_cta_ctbl
                     dc-desp-ccusto.dat_transacao       = dc-orc-realizado.data
                     dc-desp-ccusto.cod_modul_dtsul     = dc-orc-realizado.modulo
                     dc-desp-ccusto.cod_estab           = dc-orc-realizado.cod_estab
                     dc-desp-ccusto.val-movto           = dc-orc-realizado.valor-realizado
                     dc-desp-ccusto.val-previsto        = dc-orc-realizado.valor-previsto
                     dc-desp-ccusto.descricao           = dc-orc-realizado.descricao.

          END.
      END.
   END.

   RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

