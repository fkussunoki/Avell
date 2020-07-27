&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgdis            PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520 2.00.00.052 } /*** 010052 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0520 MOF}
&ENDIF

/*------------------------------------------------------------------------
          
  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include para n∆o habilitar PDF */
/* Include Com as Vari†veis Globais */
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char
    field usuario               as char
    field data-exec             as date
    field hora-exec             as integer
    field cod-estabel-ini       as character
    field cod-estabel-fim       as character
    field dt-docto-ini          as date
    field dt-docto-fim          as date
    field resumo                as logical
    field resumo-mes            as logical
    field tot-icms              as logical
    field imp-for               as logical
    field periodo-ant           as logical
    field imp-ins               as logical
    field conta-contabil        as logical
    field at-perm               as logical
    field separadores           as logical
    field previa                as character
    field documentos            as character
    field da-icms-ini           as date
    field da-icms-fim           as date
    field incentivado           as logical
    field relat                 as character
    field eliqui                as logical
    field c-nomest              like estabelec.nome 
    field c-estado              like estabelec.estado
    field c-cgc                 like estabelec.cgc
    field c-insestad            as character
    field c-cgc-1               as character
    field c-fornecedor          as character
    field c-ins-est             as character
    field c-titulo              as character
    field imp-cnpj              as logical
    &if '{&bf_dis_versao_ems}' >= '2.04' &then
        field considera-icms-st     as logical
    &endif
    field imp-cab               as CHARACTER
    FIELD l-cfop-serv           AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* buffer */

def buffer b-termo        for termo.
def buffer b-contr-livros for contr-livros.

/* Local Variable Definitions ---                                       */

def var l-ok                as logical                   no-undo.
def var c-arq-digita        as char                      no-undo.
def var c-terminal          as char                      no-undo.
def var dt-docto-ver        as date                      no-undo.
def var c-nomest            like estabelec.nome          no-undo.
def var c-estado            like estabelec.estado        no-undo.
def var c-cgc               like estabelec.cgc           no-undo.
def var c-insestad          as character format "x(19)"  no-undo.
def var c-cgc-1             as character format "x(12)"  no-undo.
def var c-fornecedor        as character format "x(12)"  no-undo.
def var c-ins-est           as character format "x(14)"  no-undo.
def var c-titulo            as character format "x(43)"  no-undo.
def var i-tp-livro          as integer                   no-undo.
def var cod-estabel-ant     as char                      no-undo.
def var l-trocou-estab      as logical                   no-undo.
def var dt-docto-ant        as date                      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES it-doc-fisc estabelec

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH it-doc-fisc SHARE-LOCK, ~
      EACH estabelec OF it-doc-fisc SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH it-doc-fisc SHARE-LOCK, ~
      EACH estabelec OF it-doc-fisc SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel it-doc-fisc estabelec
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel it-doc-fisc
&Scoped-define SECOND-TABLE-IN-QUERY-f-pg-sel estabelec


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-config-impr ~
bt-arquivo c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE da-icms-fim AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Final ICMS" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-icms-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Inicial ICMS" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U INITIAL "Resumo por UF imprime" 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Emiss∆o" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Impress∆o Cabeáalho" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE VARIABLE c-documentos AS CHARACTER INITIAL "1" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "ICMS Substituto", "1",
"Todos Documentos", "2"
     SIZE 26.14 BY 1.5 NO-UNDO.

DEFINE VARIABLE c-imp-cab AS CHARACTER INITIAL "1" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Folha", "1",
"P†gina", "2"
     SIZE 25.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-previa AS CHARACTER INITIAL "1" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Previa", "1",
"Emiss∆o", "2"
     SIZE 25.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 1.21.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 2.21.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 1.21.

DEFINE VARIABLE f-l-at-perm AS LOGICAL INITIAL no 
     LABEL "Demonst. Ativo Permanente" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-consid-icms-st AS LOGICAL INITIAL yes 
     LABEL "Considera ICMS-ST no Valor Cont†bil" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .83 NO-UNDO.

DEFINE VARIABLE f-l-imp-cnpj AS LOGICAL INITIAL no 
     LABEL "CNPJ" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.86 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-imp-conta AS LOGICAL INITIAL no 
     LABEL "Imprime C¢digo da Conta Cont†bil" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-imp-for AS LOGICAL INITIAL no 
     LABEL "Fornecedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-imp-ins AS LOGICAL INITIAL no 
     LABEL "Inscriá∆o Estadual" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-imp-per-ant AS LOGICAL INITIAL no 
     LABEL "Imprime Totais de Per°odos Anteriores" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-incentivado AS LOGICAL INITIAL no 
     LABEL "Produtos Incentivados" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-res-per AS LOGICAL INITIAL no 
     LABEL "Imprime Resumo do Per°odo" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-resumo-mes AS LOGICAL INITIAL no 
     LABEL "Imprime Resumo Mensal" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .75 NO-UNDO.

DEFINE VARIABLE f-l-separadores AS LOGICAL INITIAL no 
     LABEL "Imprime Separadores" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.14 BY .83 NO-UNDO.

DEFINE VARIABLE f-l-tot-icms AS LOGICAL INITIAL no 
     LABEL "Totaliza ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .75 NO-UNDO.

DEFINE VARIABLE l-cfop-servico AS LOGICAL INITIAL no 
     LABEL "Considera CFOP's Serviáos" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-docto-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/99 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE dt-docto-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Documento":R21 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0  
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0  
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-pg-sel FOR 
      it-doc-fisc, 
      estabelec SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14.14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 13.75 COL 2.14
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-par
     f-l-res-per AT ROW 1 COL 4
     f-l-imp-for AT ROW 1 COL 45
     f-l-resumo-mes AT ROW 2 COL 4
     f-l-imp-cnpj AT ROW 2 COL 45
     f-l-imp-per-ant AT ROW 3 COL 4
     f-l-imp-ins AT ROW 3 COL 45
     f-l-imp-conta AT ROW 4 COL 4
     f-l-at-perm AT ROW 4 COL 45
     f-l-incentivado AT ROW 5 COL 4 HELP
          "Imprime Relatorio para Produtos Incentivados?"
     f-l-separadores AT ROW 4.88 COL 45
     f-l-tot-icms AT ROW 6 COL 4
     l-cfop-servico AT ROW 5.75 COL 45 HELP
          "Doctos Serv. Tribut. pelo ISSQN - Ajuste SINIEF 3/2004"
     f-l-consid-icms-st AT ROW 7 COL 4 HELP
          "Considera ICMS-ST no Valor Cont†bil?"
     c-documentos AT ROW 7.33 COL 46.72 NO-LABEL
     da-icms-ini AT ROW 7.83 COL 16 COLON-ALIGNED
     da-icms-fim AT ROW 8.83 COL 16 COLON-ALIGNED
     c-previa AT ROW 10.21 COL 46.72 NO-LABEL
     c-imp-cab AT ROW 10.46 COL 5 NO-LABEL
     FILL-IN-4 AT ROW 6.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 9.5 COL 44.72 COLON-ALIGNED NO-LABEL
     FILL-IN-6 AT ROW 9.75 COL 4 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 10 COL 45
     RECT-11 AT ROW 7 COL 45
     RECT-12 AT ROW 10.25 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3.04
         SIZE 76.72 BY 10.5
         FONT 1.

DEFINE FRAME f-pg-sel
     c-cod-estabel-ini AT ROW 2.38 COL 24.29 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     c-cod-estabel-fim AT ROW 2.38 COL 50 COLON-ALIGNED NO-LABEL
     dt-docto-ini AT ROW 3.38 COL 24.29 COLON-ALIGNED HELP
          "Data do Documento"
     dt-docto-fim AT ROW 3.38 COL 50 COLON-ALIGNED HELP
          "Data do Documento" NO-LABEL
     IMAGE-16 AT ROW 3.38 COL 40
     IMAGE-17 AT ROW 2.38 COL 40
     IMAGE-18 AT ROW 2.38 COL 48.57
     IMAGE-2 AT ROW 3.38 COL 48.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Registro de Entradas p/ ComÇrcio"
         HEIGHT             = 15.13
         WIDTH              = 81
         MAX-HEIGHT         = 23.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 23.17
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
   Custom                                                               */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-4:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Resumo por UF imprime".

/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-5:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Tipo de Emiss∆o".

/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-6:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Impress∆o Cabeáalho".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME f-pg-sel
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _TblList          = "mgdis.it-doc-fisc,mgadm.estabelec OF movdis.it-doc-fisc"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Registro de Entradas p/ ComÇrcio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Registro de Entradas p/ ComÇrcio */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   run pi-executar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-cod-estabel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ini C-Win
ON LEAVE OF c-cod-estabel-ini IN FRAME f-pg-sel /* Estabelecimento */
do: 
    if  cod-estabel-ant <> input frame f-pg-sel c-cod-estabel-ini then do:
        assign cod-estabel-ant = input frame f-pg-sel c-cod-estabel-ini
               f-l-consid-icms-st:checked in frame f-pg-par = yes
               l-trocou-estab = yes.

        for first estabelec fields ( estado nome ins-estadual cgc )
            where estabelec.cod-estabel = input frame f-pg-sel c-cod-estabel-ini no-lock.
        end.

        if avail estabelec then do:
            assign c-cod-estabel-fim:screen-value in frame f-pg-sel = if  estabelec.estado = "ES" 
                                                                      then "zzz" 
                                                                      else input frame f-pg-sel c-cod-estabel-ini
                   c-cod-estabel-fim:sensitive in frame f-pg-sel    = if  estabelec.estado = 'ES' 
                                                                      then yes 
                                                                      else no
                   c-nomest                                         = estabelec.nome
                   c-estado                                         = estabelec.estado.

            if  estabelec.estado = 'PE' then
                assign f-l-incentivado:sensitive in frame f-pg-par = yes 
                       i-tp-livro = 8 
                       &if '{&bf_dis_versao_ems}' >= '2.04' &then
                           f-l-consid-icms-st:sensitive in frame f-pg-par = yes
                       &endif.
            else 
                assign f-l-incentivado:sensitive in frame f-pg-par = no 
                       f-l-incentivado:checked   in frame f-pg-par = no
                       i-tp-livro = 1
                       &if '{&bf_dis_versao_ems}' >= '2.04' &then
                           f-l-consid-icms-st:sensitive in frame f-pg-par = no
                       &endif.

            for first param-global fields ( formato-id-federal formato-id-estadual ) no-lock.
            end.

            if avail param-global then do:
                assign c-cgc      = if param-global.formato-id-federal <> "" 
                                    then string(estabelec.cgc, param-global.formato-id-federal)
                                    else estabelec.cgc
                       c-insestad = estabelec.ins-estadual.
            end.                         
            else 
                assign c-cgc      = estabelec.cgc
                       c-insestad = estabelec.ins-estadual.     

            assign f-l-imp-per-ant = day(dt-docto-ini) <> 1
                   c-documentos    = if  estabelec.estado = "SC" 
                                     then "2" 
                                     else "1". 
        end. /*avail estabelec*/
    end.

    if input frame f-pg-par c-previa = "2" then do:
        FIND LAST contr-livros 
            WHERE contr-livros.cod-estabel = INPUT FRAME f-pg-sel c-cod-estabel-ini 
            AND   contr-livros.livro       = i-tp-livro NO-LOCK NO-ERROR.                              

        IF AVAIL contr-livros THEN DO:
            assign dt-docto-ini:screen-value in frame f-pg-sel = string(contr-livros.dt-ult-emi + 1)
                   dt-docto-ini = contr-livros.dt-ult-emi + 1. 

            if month(dt-docto-ini) > 11 then do:
                assign dt-docto-fim = date(month(dt-docto-ini),31,(year(dt-docto-ini))).
            end.
            else
                assign dt-docto-fim = date((month(dt-docto-ini) + 1),01,(year(dt-docto-ini)))
                       dt-docto-fim = dt-docto-fim - 1.
        END.

        assign dt-docto-fim:screen-value in frame f-pg-sel = string(dt-docto-fim)
               dt-docto-ini:screen-value in frame f-pg-sel = string(dt-docto-ini) 
               da-icms-ini = input frame f-pg-sel dt-docto-ini 
               da-icms-fim = input frame f-pg-sel dt-docto-fim 
               da-icms-ini:screen-value in frame f-pg-par = string(da-icms-ini)
               da-icms-fim:screen-value in frame f-pg-par = string(da-icms-fim) .
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-docto-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-docto-fim C-Win
ON CTRL-TAB OF dt-docto-fim IN FRAME f-pg-sel
DO:   
    RUN pi-valida-data-documento.

    IF RETURN-VALUE <> "NOK" THEN DO:
        if (input frame f-pg-sel dt-docto-fim) = dt-docto-ver then
           assign c-documentos:sensitive in frame f-pg-par = yes   
                  f-l-resumo-mes = yes
                  f-l-resumo-mes:sensitive in frame f-pg-par = yes.
        else
           assign c-documentos:sensitive in frame f-pg-par = no
                  f-l-resumo-mes = no
                  f-l-resumo-mes:sensitive in frame f-pg-par = no.   
    
        apply "mouse-select-click" to im-pg-par IN FRAME f-relat.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-docto-fim C-Win
ON LEAVE OF dt-docto-fim IN FRAME f-pg-sel
DO:
    RUN pi-valida-data-documento.
    
    IF RETURN-VALUE <> "NOK" THEN DO:
        if (input frame f-pg-sel dt-docto-fim) = dt-docto-ver then
           assign c-documentos:sensitive in frame f-pg-par = yes   
                  f-l-resumo-mes = yes
                  f-l-resumo-mes:sensitive in frame f-pg-par = yes.
        else
           assign c-documentos:sensitive in frame f-pg-par = no
                  f-l-resumo-mes = no
                  f-l-resumo-mes:sensitive in frame f-pg-par = no.   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-docto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-docto-ini C-Win
ON ENTRY OF dt-docto-ini IN FRAME f-pg-sel /* Data Documento */
DO:
    IF  l-trocou-estab THEN DO:
        ASSIGN l-trocou-estab = NO.
        FIND LAST contr-livros 
            WHERE contr-livros.cod-estabel = INPUT FRAME f-pg-sel c-cod-estabel-ini
              AND contr-livros.livro       = i-tp-livro NO-LOCK NO-ERROR.

        IF  NOT AVAIL contr-livros THEN DO:
            IF  i-tp-livro = 1 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 3119,
                                   INPUT "").                                
                APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.
                APPLY 'entry' TO c-cod-estabel-ini IN FRAME f-pg-sel.
                RETURN NO-APPLY.   
            END.
        END.
        IF AVAIL contr-livros THEN
            ASSIGN dt-docto-ini:SCREEN-VALUE IN FRAME f-pg-sel = STRING(contr-livros.dt-ult-emi + 1)
                   dt-docto-ini = contr-livros.dt-ult-emi + 1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-docto-ini C-Win
ON LEAVE OF dt-docto-ini IN FRAME f-pg-sel /* Data Documento */
DO:
    IF DATE(SELF:SCREEN-VALUE) <> dt-docto-ant THEN DO:
        find last contr-livros 
            where contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini 
              and contr-livros.livro       = i-tp-livro  
              and contr-livros.dt-ult-emi <= input frame f-pg-sel dt-docto-ini no-lock no-error.

        IF not available contr-livros then do:
            IF  i-tp-livro = 1 THEN DO:
                run utp/ut-msgs.p (input "show",
                                   input 3123,
                                   input "").                               
                                       
                apply 'mouse-select-click' to im-pg-sel in frame f-relat.
                apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.
                return no-apply.  
            END.
            ELSE DO: 
                IF MONTH(dt-docto-ini) > 11 THEN DO:
                   ASSIGN dt-docto-fim = DATE(MONTH(dt-docto-ini),31,(YEAR(dt-docto-ini))).
                END.
                ELSE DO:
                   ASSIGN dt-docto-fim = DATE((MONTH(dt-docto-ini) + 1),01,(YEAR(dt-docto-ini)))
                          dt-docto-fim = dt-docto-fim - 1.
                END.
                
                ASSIGN dt-docto-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING(dt-docto-fim).
            END.
        END.
        
        if month(input frame f-pg-sel dt-docto-ini) > 11 then
           assign dt-docto-fim = date(month(input frame f-pg-sel dt-docto-ini),
                                      31,
                                     (year(input frame f-pg-sel dt-docto-ini))).
        else
            assign dt-docto-fim = date((month(input frame f-pg-sel dt-docto-ini) + 1), 01, (year(input frame f-pg-sel dt-docto-ini)))
                   dt-docto-fim = dt-docto-fim - 1.
        
        if  day(input frame f-pg-sel dt-docto-ini) > 1 then 
            assign f-l-imp-per-ant:sensitive in frame f-pg-par = true.
        else 
            assign f-l-imp-per-ant:sensitive in frame f-pg-par = false.
        
        assign dt-docto-fim:screen-value in frame f-pg-sel = string(dt-docto-fim)
               dt-docto-ver = dt-docto-fim
               dt-docto-ant = DATE(SELF:SCREEN-VALUE).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME f-l-imp-cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-imp-cnpj C-Win
ON VALUE-CHANGED OF f-l-imp-cnpj IN FRAME f-pg-par /* CNPJ */
DO:
   if  input frame f-pg-par f-l-imp-cnpj = no then
       assign c-cgc-1 = "".
   else
       assign c-cgc-1 = "CNPJ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-l-imp-for
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-imp-for C-Win
ON VALUE-CHANGED OF f-l-imp-for IN FRAME f-pg-par /* Fornecedores */
DO:
  if  input frame f-pg-par f-l-imp-for = no then
      assign f-l-imp-cnpj:sensitive in frame f-pg-par = no
             f-l-imp-ins:sensitive  in frame f-pg-par = no
             c-cgc-1      = ""
             c-fornecedor = "".
  else
      assign f-l-imp-cnpj:sensitive in frame f-pg-par = yes
             f-l-imp-ins:sensitive  in frame f-pg-par = yes
             c-cgc-1      = "CNPJ"
             c-fornecedor = "FORNECEDOR".

  disp f-l-imp-cnpj
       f-l-imp-ins with frame f-pg-par.           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-l-imp-ins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-imp-ins C-Win
ON VALUE-CHANGED OF f-l-imp-ins IN FRAME f-pg-par /* Inscriá∆o Estadual */
DO:
   if  input frame f-pg-par f-l-imp-ins = no then
       assign c-ins-est    = "".
   else
       assign c-ins-est    = "INSC. ESTADUAL".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-l-incentivado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-incentivado C-Win
ON VALUE-CHANGED OF f-l-incentivado IN FRAME f-pg-par /* Produtos Incentivados */
DO:
    DEF VAR c-sigla AS CHAR NO-UNDO.
    
    ASSIGN c-sigla = "".

    IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-titulo-cab":U  
                   AND funcao.ativo     = YES) THEN
        ASSIGN c-sigla = "- P 1A".

        FOR FIRST estabelec FIELDS ( estado nome ins-estadual cgc )
            WHERE estabelec.cod-estabel = INPUT FRAME f-pg-sel c-cod-estabel-ini NO-LOCK.
        END.

        IF  estabelec.estado = 'PE'
        AND input frame f-pg-par f-l-incentivado = NO THEN
            ASSIGN c-titulo   = "R E G I S T R O  DE  E N T R A D A S" + c-sigla
                   i-tp-livro = 8.
        
        IF  estabelec.estado = 'PE'
        AND INPUT FRAME f-pg-par f-l-incentivado THEN 
            ASSIGN c-titulo   = "RESUMO DE ENTRADAS DE PRODUTOS INCENTIVADOS" + c-sigla
                   i-tp-livro = 8.

        IF estabelec.estado <> 'PE' THEN
            ASSIGN c-titulo   = "R E G I S T R O  DE  E N T R A D A S" + c-sigla
                   i-tp-livro = 1.
    
        find last contr-livros 
            where contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini 
              and contr-livros.livro       = i-tp-livro no-lock no-error.
    
        IF  NOT AVAIL contr-livros THEN DO:
            IF i-tp-livro = 1 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 3119,
                                   INPUT "").    
                APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.
                APPLY 'entry' TO c-cod-estabel-ini IN FRAME f-pg-sel.
                RETURN NO-APPLY.   
            END.
            ELSE DO: 
                IF INPUT FRAME f-pg-par f-l-incentivado THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 28513,
                                       INPUT "").     

                    APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.
                    APPLY 'entry' TO c-cod-estabel-ini IN FRAME f-pg-sel.
                    RETURN NO-APPLY. 
                END.
            END.
        END.

        FIND LAST contr-livros 
            WHERE contr-livros.cod-estabel = INPUT FRAME f-pg-sel c-cod-estabel-ini 
            AND   contr-livros.livro       = i-tp-livro  
            AND   contr-livros.dt-ult-emi <= INPUT FRAME f-pg-sel dt-docto-ini NO-LOCK NO-ERROR.
            
            IF NOT AVAIL contr-livros 
            AND i-tp-livro <> 1
            AND INPUT FRAME f-pg-par f-l-incentivado THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 28514,
                                   INPUT ""). 
                APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.
                APPLY 'entry' TO c-cod-estabel-ini IN FRAME f-pg-sel.
                RETURN NO-APPLY. 
            END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME f-l-resumo-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-resumo-mes C-Win
ON VALUE-CHANGED OF f-l-resumo-mes IN FRAME f-pg-par /* Imprime Resumo Mensal */
DO:
  /* if input frame f-pg-par f-l-resumo-mes = yes then
     assign c-documentos:sensitive in frame f-pg-par = true.
  else 
     assign c-documentos:sensitive in frame f-pg-par = false. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-l-tot-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-l-tot-icms C-Win
ON VALUE-CHANGED OF f-l-tot-icms IN FRAME f-pg-par /* Totaliza ICMS */
DO:
    IF INPUT FRAME f-pg-par f-l-tot-icms THEN 
        ASSIGN da-icms-ini = INPUT FRAME f-pg-sel dt-docto-ini
               da-icms-fim = INPUT FRAME f-pg-sel dt-docto-fim.
    
    IF INPUT FRAME f-pg-par f-l-tot-icms = YES THEN DO:
        ASSIGN da-icms-ini:SENSITIVE IN FRAME f-pg-par = TRUE
               da-icms-fim:SENSITIVE IN FRAME f-pg-par = TRUE.
        DISP da-icms-ini
             da-icms-fim WITH FRAME f-pg-par.
    END.                            
    ELSE
        ASSIGN da-icms-ini:SENSITIVE IN FRAME f-pg-par = FALSE
               da-icms-fim:SENSITIVE IN FRAME f-pg-par = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    for first param-of fields ( cod-estabel termo-ab-ent termo-en-ent) no-lock.
    end.

    if  avail param-of then do:
        for first estabelec fields ( estado )
            where estabelec.cod-estabel = param-of.cod-estabel no-lock.
        end.
    end.
    run pi-troca-pagina.  
    disp f-l-resumo-mes
         with frame f-pg-par. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
   run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
    do  with frame f-pg-imp:
        case self:screen-value:
            when "1" then do:
                assign c-arquivo:sensitive    = no
                       bt-arquivo:visible     = no
                       bt-config-impr:visible = yes.
            end.
            when "2" then do:
                assign c-arquivo:sensitive     = yes
                       bt-arquivo:visible      = yes
                       bt-config-impr:visible  = no.
            end.
            when "3" then do:
                assign c-arquivo:sensitive     = no
                       bt-arquivo:visible      = no
                       bt-config-impr:visible  = no.
            end.
        end case.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "esof0520" "2.00.00.047"}

/* inicializaá‰es do template de relat¢rio */

{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */

PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:

DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI. 

    FIND FIRST param-of
        WHERE  param-of.cod-estabel = c-cod-estabel-ini NO-LOCK NO-ERROR.

    IF AVAIL param-of THEN 
        FOR FIRST estabelec fields ( cod-estabel estado )
            WHERE  estabelec.cod-estabel = param-of.cod-estabel NO-LOCK:
        END.

    IF AVAIL estabelec then do:
        assign c-cod-estabel-ini = estabelec.cod-estabel
               cod-estabel-ant   = '0'
               &if '{&bf_dis_versao_ems}' >= '2.04' &then
                   i-tp-livro = if  f-l-incentivado:checked in frame f-pg-par then 8
                                else 1.
               &else
                   i-tp-livro = 1.
               &endif

        find last contr-livros 
            where contr-livros.cod-estabel = estabelec.cod-estabel 
            and   contr-livros.livro       = i-tp-livro no-lock no-error.

        if avail contr-livros then do:
            assign dt-docto-ini   = contr-livros.dt-ult-emi + 1.

        if month(dt-docto-ini) > 11 then do:
           assign dt-docto-fim = date(month(dt-docto-ini),31,(year(dt-docto-ini))).
        end.
        else
           assign dt-docto-fim = date((month(dt-docto-ini) + 1),01,(year(dt-docto-ini)))
                  dt-docto-fim = dt-docto-fim - 1.

        assign dt-docto-fim:screen-value in frame f-pg-sel = string(dt-docto-fim)
               dt-docto-ini:screen-value in frame f-pg-sel = string(dt-docto-ini) .

        if month(dt-docto-fim + 1) <> month (dt-docto-fim) then do:
               /*assign f-l-resumo-mes = yes.
     *            assign f-l-resumo-mes:sensitive in frame f-pg-par = true.*/
        end.
        else do:
            assign f-l-resumo-mes = f-l-resumo-mes.
        end.

        assign f-l-imp-cnpj:sensitive       in frame f-pg-par = no
               f-l-imp-ins:sensitive        in frame f-pg-par = no
               da-icms-ini:sensitive        in frame f-pg-par = no
               da-icms-fim:sensitive        in frame f-pg-par = no
               f-l-incentivado:sensitive    in frame f-pg-par = no
               &if '{&bf_dis_versao_ems}' >= '2.04' &then
                   f-l-consid-icms-st:sensitive in frame f-pg-par = no
               &endif
               f-l-resumo-mes:sensitive     in frame f-pg-par = no.

        &IF "{&mguni_version}" >= "2.071" &THEN
            assign c-cod-estabel-fim:screen-value in frame f-pg-sel = if estabelec.estado = "ES" then "ZZZZZ" else ""
        &ELSE
            assign c-cod-estabel-fim:screen-value in frame f-pg-sel = if estabelec.estado = "ES" then "zzz" else ""
        &ENDIF
            c-cod-estabel-fim:sensitive in frame f-pg-sel    = if estabelec.estado = "ES" then yes else no.

        if  estabelec.estado = 'PE' then
            assign f-l-incentivado:sensitive    in frame f-pg-par = yes 
                   &if '{&bf_dis_versao_ems}' >= '2.04' &then
                       f-l-consid-icms-st:sensitive in frame f-pg-par = yes
                       f-l-consid-icms-st:checked   in frame f-pg-par = yes
                   &endif.
        else 
            assign f-l-incentivado:sensitive in frame f-pg-par = no 
                   f-l-incentivado:checked   in frame f-pg-par = no
                   i-tp-livro = 1
                   &if '{&bf_dis_versao_ems}' >= '2.04' &then
                       f-l-consid-icms-st:sensitive in frame f-pg-par = no
                   &endif.

        if day(dt-docto-ini) > 1 then 
           assign f-l-imp-per-ant:sensitive in frame f-pg-par = true.
        else 
           assign f-l-imp-per-ant:sensitive in frame f-pg-par = false.  

        if  month(dt-docto-fim + 1) <> month (dt-docto-fim) then
            assign f-l-resumo-mes = yes
                   f-l-resumo-mes:sensitive in frame f-pg-par = true.
        else
            assign f-l-resumo-mes = no
                   f-l-resumo-mes:sensitive in frame f-pg-par = false.
    end.
end.

{include/i-rpmbl.i}

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN c-cod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
    ASSIGN c-cod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
&ENDIF

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
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
  ENABLE im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim dt-docto-ini dt-docto-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-2 c-cod-estabel-ini dt-docto-ini 
         dt-docto-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY f-l-res-per f-l-imp-for f-l-resumo-mes f-l-imp-cnpj f-l-imp-per-ant 
          f-l-imp-ins f-l-imp-conta f-l-at-perm f-l-incentivado f-l-separadores 
          f-l-tot-icms l-cfop-servico f-l-consid-icms-st c-documentos 
          da-icms-ini da-icms-fim c-previa c-imp-cab 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE f-l-res-per f-l-imp-for f-l-resumo-mes f-l-imp-cnpj f-l-imp-per-ant 
         f-l-imp-ins f-l-imp-conta f-l-at-perm f-l-incentivado f-l-separadores 
         f-l-tot-icms l-cfop-servico f-l-consid-icms-st c-documentos 
         da-icms-ini da-icms-fim c-previa c-imp-cab RECT-10 RECT-11 RECT-12 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    &if '{&bf_dis_versao_ems}' >= '2.04' &then
        assign f-l-consid-icms-st:hidden in frame f-pg-par = no.
        {utp/ut-liter.i Produtos_Incentivados}
    &else
        assign f-l-consid-icms-st:hidden in frame f-pg-par = yes.
        {utp/ut-liter.i Incentivado}
    &endif
    assign f-l-incentivado:label in frame f-pg-par = trim(return-value).  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:

    {include/i-rpexa.i}

    RUN pi-valida-data-documento.

    IF RETURN-VALUE <> "NOK" THEN DO: 
        if  input frame f-pg-imp rs-destino = 2 then do:
            run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
            if  return-value = "nok" then do:
                run utp/ut-msgs.p (input "show",
                                   input 73,
                                   input "").
                apply 'mouse-select-click' to im-pg-imp in frame f-relat.
                apply 'entry' to c-arquivo in frame f-pg-imp.                   
                return error.
            end.
        end.
    
        /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
          devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
          com problemas e colocar o focus no campo com problemas             */    
        create tt-param.
        assign tt-param.usuario           = c-seg-usuario
               tt-param.destino           = input frame f-pg-imp rs-destino
               tt-param.data-exec         = today
               tt-param.hora-exec         = time
               tt-param.cod-estabel-ini   = input frame f-pg-sel c-cod-estabel-ini
               tt-param.cod-estabel-fim   = input frame f-pg-sel c-cod-estabel-fim
               tt-param.dt-docto-ini      = input frame f-pg-sel dt-docto-ini
               tt-param.dt-docto-fim      = input frame f-pg-sel dt-docto-fim
               tt-param.resumo            = input frame f-pg-par f-l-res-per
               tt-param.resumo-mes        = input frame f-pg-par f-l-resumo-mes
               tt-param.tot-icms          = input frame f-pg-par f-l-tot-icms
               tt-param.imp-for           = input frame f-pg-par f-l-imp-for
               tt-param.periodo-ant       = input frame f-pg-par f-l-imp-per-ant
               tt-param.imp-ins           = input frame f-pg-par f-l-imp-ins
               tt-param.conta-contabil    = input frame f-pg-par f-l-imp-conta
               tt-param.at-perm           = input frame f-pg-par f-l-at-perm  
               tt-param.separadores       = input frame f-pg-par f-l-separadores 
               tt-param.previa            = input frame f-pg-par c-previa
               tt-param.imp-cab           = input frame f-pg-par c-imp-cab
               tt-param.documentos        = input frame f-pg-par c-documentos
               tt-param.da-icms-ini       = input frame f-pg-par da-icms-ini
               tt-param.da-icms-fim       = input frame f-pg-par da-icms-fim
               tt-param.incentivado       = input frame f-pg-par f-l-incentivado   
               &if '{&bf_dis_versao_ems}' >= '2.04' &then
                   tt-param.considera-icms-st = input frame f-pg-par f-l-consid-icms-st
               &endif
               tt-param.imp-cnpj          = input frame f-pg-par f-l-imp-cnpj
    
               tt-param.c-nomest          = c-nomest 
               tt-param.c-estado          = c-estado
               tt-param.c-cgc             = c-cgc
               tt-param.c-insestad        = c-insestad
               tt-param.c-cgc-1           = c-cgc-1
               tt-param.c-fornecedor      = c-fornecedor
               tt-param.c-ins-est         = c-ins-est
               tt-param.c-titulo          = c-titulo
               tt-param.l-cfop-serv       = INPUT FRAME f-pg-par l-cfop-servico.
    
        IF  tt-param.destino = 1 then
            assign tt-param.arquivo = "".
        else
        if  tt-param.destino = 2 then 
            assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
        else
            assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".
    
        FIND FIRST param-of
            WHERE  param-of.cod-estabel = tt-param.cod-estabel-ini no-lock no-error.
    
        IF AVAIL param-of THEN DO:
           FIND FIRST termo 
               WHERE  termo.te-codigo   = param-of.termo-ab-ent  NO-LOCK NO-ERROR.
           FIND FIRST b-termo 
               WHERE  b-termo.te-codigo = param-of.termo-en-ent  NO-LOCK NO-ERROR.
        END.
    
        IF NOT AVAIL param-of THEN DO:
            RUN utp/ut-msgs.p (input "show", 
                               input 16084, 
                               input "").
            APPLY 'entry' to c-cod-estabel-ini in frame f-pg-sel.
            RETURN 'adm-error':U.
        END.
    
        find last contr-livros 
            where contr-livros.cod-estabel = tt-param.cod-estabel-ini
              and contr-livros.livro  = i-tp-livro no-lock no-error.
    
        if tt-param.tot-icm and (month(tt-param.da-icms-ini) <> month(tt-param.dt-docto-ini)
        and year(tt-param.da-icms-ini) <> year(tt-param.dt-docto-ini)) then do:
           run utp/ut-msgs.p (input "show",
                              input 3230,
                              input "").                                
           apply 'mouse-select-click' to im-pg-sel in frame f-relat.
           apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.
           return error.       
        end.
    
        if tt-param.tot-icms and (month(tt-param.da-icms-fim) <> month(tt-param.dt-docto-fim)
        or year(tt-param.da-icms-fim) <> year(tt-param.dt-docto-fim)) then do:
           run utp/ut-msgs.p (input "show",
                              input 3231,
                              input "").                                
           apply 'mouse-select-click' to im-pg-sel in frame f-relat.
           apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.
           return error.       
        end.
    
        find last contr-livros 
            where contr-livros.cod-estabel = tt-param.cod-estabel-ini
             and  contr-livros.livro       = i-tp-livro no-lock no-error.
        IF  not avail contr-livros then do: 
            IF i-tp-livro = 1 THEN DO:
                RUN utp/ut-msgs.p (input "show",
                                   input 3225,
                                   input "").  
                apply 'mouse-select-click' to im-pg-imp in frame f-relat.
                apply 'entry' to c-arquivo in frame f-pg-imp.  
                return error. 
            END.
            ELSE DO:
                IF tt-param.incentivado = YES THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 28515,
                                       INPUT "").                                
                    apply 'mouse-select-click' to im-pg-imp in frame f-relat.
                    apply 'entry' to c-arquivo in frame f-pg-imp.  
                    return error. 
                END.
            END.
        END.
        ELSE DO:
            if input frame f-pg-par c-previa = "2" then do:
                find first b-contr-livros use-index ch-livro 
                    where  b-contr-livros.cod-estabel  = tt-param.cod-estabel-ini
                       and b-contr-livros.dt-ult-emi   = tt-param.dt-docto-ini - 1
                       and b-contr-livros.livro        = i-tp-livro no-lock no-error.
    
                IF AVAIL contr-livros 
                AND contr-livros.dt-ult-emi <> tt-param.dt-docto-ini - 1
                AND NOT AVAIL b-contr-livros THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 3233,
                                       INPUT "").                                
                    APPLY 'mouse-select-click' TO im-pg-imp IN FRAME f-relat.
                    APPLY 'entry' TO c-arquivo IN FRAME f-pg-imp.  
                    RETURN ERROR.      
                END.
                
                IF AVAIL b-contr-livros THEN 
                    FIND FIRST contr-livros USE-INDEX ch-livro 
                        WHERE  contr-livros.cod-estabel = tt-param.cod-estabel-ini
                        AND    contr-livros.dt-ult-emi >= tt-param.dt-docto-ini
                        AND    contr-livros.livro       = i-tp-livro NO-LOCK NO-ERROR.
                
                IF AVAIL contr-livros THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 3239,
                                       INPUT "").                                
                    APPLY 'mouse-select-click' TO im-pg-imp IN FRAME f-relat.
                    APPLY 'entry' TO c-arquivo IN FRAME f-pg-imp.  
                    ASSIGN tt-param.eliqui = YES.
                END.
            END.
        END.
    
        /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table tt-param */ 
    
        {include/i-rpexb.i}
    
        if  session:set-wait-state("general") then.
    
        {include/i-rprun.i ofp/esof0520rp.p}
    
        apply 'mouse-select-click' to im-pg-sel in frame f-relat.
        apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.        
        
        {include/i-rpexc.i}
    
        if  session:set-wait-state("") then.
    
        {include/i-rptrm.i}
    
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-data-documento C-Win 
PROCEDURE pi-valida-data-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if (input frame f-pg-sel dt-docto-fim < input frame f-pg-sel dt-docto-ini)
     or (month(input frame f-pg-sel dt-docto-fim) <> month(input frame f-pg-sel dt-docto-ini)) 
     or (year(input frame f-pg-sel dt-docto-fim) <> year(input frame f-pg-sel dt-docto-ini)) then do:
     run utp/ut-msgs.p (input "show",
                        input 3833,
                        input "").
     return 'NOK':U.
  end.     
  ELSE 
     return 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "it-doc-fisc"}
  {src/adm/template/snd-list.i "estabelec"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

