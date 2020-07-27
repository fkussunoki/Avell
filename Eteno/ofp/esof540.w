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
{include/i-prgvrs.i esof0540 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0540 MOF}
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
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include para nÆo habilitar PDF */
{cdp/cd9992.i}

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    field dt-inic          as date
    field dt-fim           as date
    field resum-per        as logical
    field resum-mes        as logical
    field tot-icms         as logical
    field tot-ant          as logical
    field fornec           as logical
    field insc-est         as logical
    field cont-contabil    as logical
    field docto            as logical
    field dt-icms-ini      as date
    field dt-icms-fim      as date
    field emissao          as logical
    field incentiva        as logical
    field l-eliqui         as logical
    field l-icms-subst     as logical
    FIELD l-cfop-serv      AS LOGICAL.

define temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

define buffer b-tt-digita     for tt-digita.
define buffer b-contr-livros  for contr-livros.
def buffer b-termo        for termo.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok                as logical no-undo.
def var c-arq-digita        as char    no-undo.
def var c-terminal          as char    no-undo.
def var c-temp              as char    no-undo.

DEF VAR i-livro             AS INTEGER NO-UNDO.
def var dt-docto-ant        as date    no-undo.

{cdp/cdcfgdis.i} /* pre-processador */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES it-doc-fisc

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH it-doc-fisc SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH it-doc-fisc SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel it-doc-fisc
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel it-doc-fisc


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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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
     LABEL "Data final para ICMS" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-icms-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data inicial para ICMS" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-docto AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos documentos", no,
"Icms substituto", yes
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE l-emissao AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pr‚via", yes,
"EmissÆo", no
     SIZE 23.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 1.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26 BY 1.21.

DEFINE VARIABLE l-cfop-servico AS LOGICAL INITIAL no 
     LABEL "Considera CFOP's Servi‡os" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE l-cont-contabil AS LOGICAL INITIAL no 
     LABEL "Imprime c¢digo da conta cont bil" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE l-fornec AS LOGICAL INITIAL no 
     LABEL "Fornecedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE l-icms-subst AS LOGICAL INITIAL yes 
     LABEL "Considera o ICMS - ST no Valor Cont bil" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE l-incentiva AS LOGICAL INITIAL no 
     LABEL "Incentivado" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE l-insc-est AS LOGICAL INITIAL no 
     LABEL "Inscri‡Æo estadual" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-resum-mes AS LOGICAL INITIAL no 
     LABEL "Imprime resumo mensal" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE l-resum-per AS LOGICAL INITIAL no 
     LABEL "Imprime resumo do per¡odo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE l-tot-ant AS LOGICAL INITIAL no 
     LABEL "Imprime totais per¡odos anteriores" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE l-tot-icms AS LOGICAL INITIAL no 
     LABEL "Totaliza ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-fim AS DATE FORMAT "99/99/9999" INITIAL 01/01/99 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-inic AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data":R15 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
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
      it-doc-fisc SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-par
     l-resum-per AT ROW 1.5 COL 3.29
     l-resum-mes AT ROW 1.5 COL 48
     l-tot-icms AT ROW 2.5 COL 3.29
     l-fornec AT ROW 2.5 COL 48
     l-tot-ant AT ROW 3.5 COL 3.29
     l-insc-est AT ROW 3.5 COL 48
     l-cont-contabil AT ROW 4.5 COL 3.29
     l-cfop-servico AT ROW 4.5 COL 48 HELP
          "Doctos Serv. Tribut. pelo ISSQN - Ajuste SINIEF 3/2004"
     l-icms-subst AT ROW 5.5 COL 3.29
     l-incentiva AT ROW 5.5 COL 48
     l-docto AT ROW 7.25 COL 4.29 NO-LABEL
     l-emissao AT ROW 7.25 COL 49 NO-LABEL
     da-icms-ini AT ROW 8.5 COL 23 COLON-ALIGNED
     da-icms-fim AT ROW 8.5 COL 59 COLON-ALIGNED
     "Tipo de emissÆo" VIEW-AS TEXT
          SIZE 16 BY .67 AT ROW 6.5 COL 48.57
     "Resumo por UF imprime" VIEW-AS TEXT
          SIZE 23 BY .88 AT ROW 6.5 COL 4.14
     RECT-10 AT ROW 7 COL 3.29
     RECT-11 AT ROW 7 COL 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10
         FONT 1.

DEFINE FRAME f-pg-sel
     c-cod-estabel-ini AT ROW 3.25 COL 23 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     c-cod-estabel-fim AT ROW 3.25 COL 46 COLON-ALIGNED NO-LABEL
     da-dt-inic AT ROW 4.25 COL 23 COLON-ALIGNED HELP
          "Data inicial do per¡odo de emissÆo do livro"
     da-dt-fim AT ROW 4.25 COL 46 COLON-ALIGNED HELP
          "Data final do per¡odo de emissÆo do livro" NO-LABEL
     IMAGE-1 AT ROW 3.25 COL 39
     IMAGE-2 AT ROW 3.25 COL 44
     IMAGE-3 AT ROW 4.25 COL 39
     IMAGE-4 AT ROW 4.25 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Registro de Entradas"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
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
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN da-icms-fim IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-icms-ini IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET l-docto IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-incentiva IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-insc-est IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
ASSIGN 
       c-cod-estabel-fim:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
ASSIGN 
       IMAGE-1:HIDDEN IN FRAME f-pg-sel           = TRUE.

ASSIGN 
       IMAGE-2:HIDDEN IN FRAME f-pg-sel           = TRUE.

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
     _TblList          = "mgdis.it-doc-fisc"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Registro de Entradas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Registro de Entradas */
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
   RUN pi-valida-data-documento.

     IF RETURN-VALUE = "NOK" THEN DO:
            return "NOK":U.

     END.
   do on error undo, return no-apply:
      run utp/ut-msgs.p (input "show",
                         input 3100,
                         input "").
      if return-value = "no" then do:
         apply 'mouse-select-click' to im-pg-sel in frame f-relat.
         apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.
      end.
      else 
        run pi-executar.                 
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-cod-estabel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ini C-Win
ON LEAVE OF c-cod-estabel-ini IN FRAME f-pg-sel /* Estabelecimento */
DO:

 find estabelec where estabelec.cod-estabel = input frame f-pg-sel c-cod-estabel-ini
      no-lock no-error.
 if available estabelec then do:
    if estabelec.estado = "ES" then do: 
       assign c-cod-estabel-fim:visible in frame f-pg-sel = yes
                        image-1:visible in frame f-pg-sel = yes
                        image-2:visible in frame f-pg-sel = yes.
    end.   
    else do:
       assign c-cod-estabel-fim:visible in frame f-pg-sel = no
                        image-1:visible in frame f-pg-sel = no
                        image-2:visible in frame f-pg-sel = no.
       assign c-cod-estabel-fim = input frame f-pg-sel c-cod-estabel-ini.
       assign c-cod-estabel-fim  = input frame f-pg-sel c-cod-estabel-ini.
    end.
    if estabelec.estado = "SC" then 
       assign l-docto = no.
    else
       assign l-docto = yes.   

   if estabelec.estado = "PE" then do:
        assign l-incentiva:sensitive in frame f-pg-par = true.
        assign l-icms-subst:sensitive in frame f-pg-par = true.
    end.
    else do:
        assign l-incentiva:sensitive in frame f-pg-par = false.
        assign l-incentiva:CHECKED in frame f-pg-par = false.
        assign l-icms-subst:sensitive in frame f-pg-par = false.
    end.

    ASSIGN l-incentiva = input frame f-pg-par l-incentiva.
    ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                        (IF l-incentiva = TRUE THEN 8 ELSE 1) 
                     &ELSE 
                         1
                     &ENDIF.

    find last contr-livros where
         contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini and
         contr-livros.livro       = i-livro no-lock no-error.
    if available contr-livros and
       input frame f-pg-sel c-cod-estabel-ini <> c-temp then do:
         assign da-dt-inic = contr-livros.dt-ult-emi + 1  
                c-temp     = input frame f-pg-sel c-cod-estabel-ini.
         disp da-dt-inic with frame f-pg-sel.
    end.
 end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ini C-Win
ON VALUE-CHANGED OF c-cod-estabel-ini IN FRAME f-pg-sel /* Estabelecimento */
DO:

    find estabelec where estabelec.cod-estabel = input frame f-pg-sel c-cod-estabel-ini
            no-lock no-error.

    if avail estabelec then do:
        if estabelec.estado = "PE" then do:
            assign l-incentiva:sensitive in frame f-pg-par = true.
            assign l-icms-subst:sensitive in frame f-pg-par = true.
        end.
        else do:
            assign l-incentiva:sensitive in frame f-pg-par = false.
            ASSIGN l-incentiva:CHECKED IN FRAME f-pg-par = FALSE.
            assign l-icms-subst:sensitive in frame f-pg-par = false.
        end.
    end.
    else do:
        assign l-incentiva:sensitive in frame f-pg-par = false.
        ASSIGN l-incentiva:CHECKED IN FRAME f-pg-par = FALSE.
        assign l-icms-subst:sensitive in frame f-pg-par = false.
    end.

    assign l-icms-subst:checked in frame f-pg-par = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-fim C-Win
ON LEAVE OF da-dt-fim IN FRAME f-pg-sel
DO:
  RUN pi-valida-data-documento.
  if month(input frame f-pg-sel da-dt-fim + 1) <> month(input frame f-pg-sel da-dt-fim) then
     assign l-resum-mes:sensitive in frame f-pg-par = true.
  else
     assign l-resum-mes:sensitive in frame f-pg-par = false.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-inic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-inic C-Win
ON LEAVE OF da-dt-inic IN FRAME f-pg-sel /* Data */
DO:

  IF DATE(SELF:SCREEN-VALUE) <> dt-docto-ant THEN DO:  
      ASSIGN l-incentiva = input frame f-pg-par l-incentiva.
      ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                            (IF l-incentiva = true THEN 8 ELSE 1) 
                       &ELSE 
                            1 
                       &ENDIF.

      find last contr-livros where
             contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini  and
             contr-livros.livro       = i-livro  and
             contr-livros.dt-ult-emi <= input frame f-pg-sel da-dt-inic no-lock no-error.
      if month(input frame f-pg-sel da-dt-inic) > 11 then
         assign da-dt-fim = date(month(input frame f-pg-sel da-dt-inic ),31,
                        (year(input frame f-pg-sel da-dt-inic))).
      else
         assign da-dt-fim = date((month(input frame f-pg-sel da-dt-inic) + 1),01,
                                   year(input frame f-pg-sel da-dt-inic)).
      assign da-dt-fim = da-dt-fim - 1.
      disp da-dt-fim with frame f-pg-sel.
      if day(input frame f-pg-sel da-dt-inic) <> 1 then
         assign l-tot-ant:sensitive in frame f-pg-par = true.
      else
         assign l-tot-ant:sensitive in frame f-pg-par = false.

      ASSIGN dt-docto-ant = DATE(SELF:SCREEN-VALUE).
  END.
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
    run pi-troca-pagina.


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


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME l-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-fornec C-Win
ON VALUE-CHANGED OF l-fornec IN FRAME f-pg-par /* Fornecedores */
DO:
  if input frame f-pg-par l-fornec = yes then
     assign l-insc-est:sensitive in frame f-pg-par = true.
  else
     assign l-insc-est:sensitive in frame f-pg-par = false.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-incentiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-incentiva C-Win
ON VALUE-CHANGED OF l-incentiva IN FRAME f-pg-par /* Incentivado */
DO:

    ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                         IF (l-incentiva:CHECKED IN FRAME f-pg-par = true) THEN 8 ELSE 1 
                     &ELSE 
                          1 
                     &ENDIF.


    find last contr-livros where contr-livros.cod-estabel = c-cod-estabel-ini:screen-value in frame f-pg-sel
          and contr-livros.livro  = i-livro no-lock no-error.
    if avail contr-livros then do:
      assign da-dt-inic:screen-value in frame f-pg-sel = string(contr-livros.dt-ult-emi + 1).
      if month(date(da-dt-inic:screen-value in frame f-pg-sel)) = 12 then
          assign da-dt-fim:screen-value in frame f-pg-sel = string(date(month(date(da-dt-inic:screen-value in frame f-pg-sel)),31,(year(date(da-dt-inic:screen-value in frame f-pg-sel))))).
      else
        assign da-dt-fim:screen-value in frame f-pg-sel  = string(date(month(date(da-dt-inic:screen-value in frame f-pg-sel)) + 1,01,year(date(da-dt-inic:screen-value in frame f-pg-sel))))
               da-dt-fim:screen-value in frame f-pg-sel  = string(date(da-dt-fim:screen-value in frame f-pg-sel) - 1).
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-resum-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-resum-mes C-Win
ON VALUE-CHANGED OF l-resum-mes IN FRAME f-pg-par /* Imprime resumo mensal */
DO:
  if input frame f-pg-par l-resum-mes = yes then
     assign l-docto:sensitive in frame f-pg-par = true.
  else
     assign l-docto:sensitive in frame f-pg-par = false.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-tot-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-tot-icms C-Win
ON VALUE-CHANGED OF l-tot-icms IN FRAME f-pg-par /* Totaliza ICMS */
DO:
  if input frame f-pg-par l-tot-icms = yes then
     assign da-icms-ini:sensitive in frame f-pg-par = true
            da-icms-fim:sensitive in frame f-pg-par = true
            da-icms-ini = input frame f-pg-sel da-dt-inic
            da-icms-fim = input frame f-pg-sel da-dt-fim.
  else
     assign da-icms-ini:sensitive in frame f-pg-par = false
            da-icms-fim:sensitive in frame f-pg-par = false
            da-icms-ini = ?
            da-icms-fim = ?.
 disp da-icms-ini da-icms-fim with frame f-pg-par.
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

{utp/ut9000.i "esof0540" "2.00.00.026"}

/* inicializa‡äes do template de relat¢rio */
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
    RUN afterInitializeInterface.

    {include/i-rpmbl.i}

     assign c-cod-estabel-fim:visible in frame f-pg-sel = no
                      image-1:visible in frame f-pg-sel = no
                      image-2:visible in frame f-pg-sel = no.

    find first param-of  no-lock no-error.
    if avail param-of then do:
      find first estabelec
           where estabelec.cod-estabel = param-of.cod-estabel no-lock no-error.

       assign c-cod-estabel-ini:screen-value in frame f-pg-sel = string(estabelec.cod-estabel)
              l-cont-contabil:screen-value in frame f-pg-par = string(can-do(estabelec.estado,"SP"))
              l-incentiva:screen-value in frame f-pg-par = string(can-do(estabelec.estado,"PE"))
              l-incentiva:sensitive in frame f-pg-par = can-do(estabelec.estado,"PE")
              l-resum-per:screen-value in frame f-pg-par = string(no)
              l-tot-icms:screen-value in frame f-pg-par = string(no)
              l-fornec:screen-value in frame f-pg-par = string(no).


      find termo where termo.te-codigo     = param-of.termo-ab-ent  no-lock.
      find b-termo where b-termo.te-codigo = param-of.termo-en-ent  no-lock.
    end.
    else do:

        &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
            IF (l-incentiva:CHECKED IN FRAME f-pg-par) = TRUE THEN
                run utp/ut-msgs.p (input "show",
                                   input 28512,
                                   input "").
            ELSE
                run utp/ut-msgs.p (input "show",
                               input 4431,
                               input "").

        &ELSE 
            run utp/ut-msgs.p (input "show",
                               input 4431,
                               input "").
        &ENDIF.

      return error.                         
    end.

    ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                         IF (l-incentiva:CHECKED IN FRAME f-pg-par = true) THEN 8 ELSE 1 
                     &ELSE 
                          1 
                     &ENDIF.

    find last contr-livros where contr-livros.cod-estabel = c-cod-estabel-ini:screen-value in frame f-pg-sel
          and contr-livros.livro  = i-livro no-lock no-error.
    if avail contr-livros then do:
      assign da-dt-inic:screen-value in frame f-pg-sel = string(contr-livros.dt-ult-emi + 1).
      if month(date(da-dt-inic:screen-value in frame f-pg-sel)) = 12 then
          assign da-dt-fim:screen-value in frame f-pg-sel = string(date(month(date(da-dt-inic:screen-value in frame f-pg-sel)),31,(year(date(da-dt-inic:screen-value in frame f-pg-sel))))).
      else
        assign da-dt-fim:screen-value in frame f-pg-sel  = string(date(month(date(da-dt-inic:screen-value in frame f-pg-sel)) + 1,01,year(date(da-dt-inic:screen-value in frame f-pg-sel))))
               da-dt-fim:screen-value in frame f-pg-sel  = string(date(da-dt-fim:screen-value in frame f-pg-sel) - 1).
    end.

    assign c-temp = c-cod-estabel-ini:screen-value in frame f-pg-sel. 

    find estabelec where estabelec.cod-estabel = c-temp
            no-lock no-error.

    if avail estabelec then do:
        if estabelec.estado = "PE" then do:
            assign l-incentiva:sensitive in frame f-pg-par = true.
            assign l-icms-subst:sensitive in frame f-pg-par = true.

        end.
        else do:
            assign l-incentiva:sensitive in frame f-pg-par = false.
            assign l-icms-subst:sensitive in frame f-pg-par = false.

        end.
    end.
    else do:
        assign l-incentiva:sensitive in frame f-pg-par = false.
        assign l-icms-subst:sensitive in frame f-pg-par = false.

    end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface C-Win 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if '{&bf_dis_versao_ems}' >= '2.04' &then 
    assign l-incentiva:label in frame f-pg-par = "Produtos Incentivados".
    assign l-icms-subst:hidden in frame f-pg-par = false.
&else
    assign l-icms-subst:hidden in frame f-pg-par = true. 
&endif

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
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim da-dt-inic da-dt-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 c-cod-estabel-ini c-cod-estabel-fim 
         da-dt-inic da-dt-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-resum-per l-resum-mes l-tot-icms l-fornec l-tot-ant l-insc-est 
          l-cont-contabil l-cfop-servico l-icms-subst l-incentiva l-docto 
          l-emissao da-icms-ini da-icms-fim 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-10 RECT-11 l-resum-per l-resum-mes l-tot-icms l-fornec l-tot-ant 
         l-cont-contabil l-cfop-servico l-icms-subst l-emissao 
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



    ASSIGN l-incentiva = input frame f-pg-par l-incentiva.
    ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                        (IF l-incentiva = true THEN 8 ELSE 1) 
                     &ELSE 
                         1 
                     &ENDIF.

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

    find first param-of no-lock no-error.
    if not avail param-of then do:


       &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
            IF l-incentiva = TRUE THEN
                run utp/ut-msgs.p (input "show",
                                   input 28512,
                                   input "").
            ELSE
                run utp/ut-msgs.p (input "show",
                               input 4431,
                               input "").

        &ELSE 
            run utp/ut-msgs.p (input "show",
                               input 4431,
                               input "").
        &ENDIF.

       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.                   
       return error.
    end.   

    FIND param-of
        WHERE param-of.cod-estabel = input frame f-pg-sel c-cod-estabel-ini
        no-lock no-error.

    IF NOT AVAIL param-of THEN DO:
        run utp/ut-msgs.p (input "show", 
                           input 16084, 
                           input "").
        apply 'entry' to input frame f-pg-sel c-cod-estabel-ini .
        return 'adm-error':U.
    end.   

    if (input frame f-pg-sel da-dt-fim < input frame f-pg-sel da-dt-inic)
       or (month(input frame f-pg-sel da-dt-fim) <> month(input frame f-pg-sel da-dt-inic))
       or (year(input frame f-pg-sel da-dt-fim) <> year(input frame f-pg-sel da-dt-inic)) then do:
       if not input frame f-pg-par l-emissao then do:
          run utp/ut-msgs.p (input "show",
                             input 3833,
                             input "").
          apply 'mouse-select-click' to im-pg-sel in frame f-relat.
          apply 'entry' to da-dt-inic in frame f-pg-sel.                   
          return error.
       end.
    end.   

    find last contr-livros where
              contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini and
              contr-livros.livro       = i-livro no-lock no-error.


    if not avail contr-livros then do:

       &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
            IF l-incentiva = TRUE THEN
                run utp/ut-msgs.p (input "show",
                                   input 28513,
                                   input "").
            ELSE
                run utp/ut-msgs.p (input "show",
                               input 3119,
                               input "").

        &ELSE 
            run utp/ut-msgs.p (input "show",
                               input 3119,
                               input "").
        &ENDIF.


       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-cod-estabel-ini in frame f-pg-sel.                   
       return error.
    end.

    find last contr-livros where
              contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini and
              contr-livros.livro       = i-livro  and
              contr-livros.dt-ult-emi <= input frame f-pg-sel da-dt-inic no-lock no-error.
    if not available contr-livros then do:

        &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
            IF l-incentiva = TRUE THEN
                run utp/ut-msgs.p (input "show",
                                   input 28514,
                                   input "").
            ELSE
                run utp/ut-msgs.p (input "show",
                               input 3123,
                               input "").

        &ELSE 
            run utp/ut-msgs.p (input "show",
                               input 3123,
                               input "").
        &ENDIF.

       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to da-dt-inic in frame f-pg-sel.                   
       return error.
    end.                   

    if input frame f-pg-par l-tot-icms and 
      (month(input frame f-pg-par da-icms-ini) <> month(input frame f-pg-sel da-dt-inic) or
        year(input frame f-pg-par da-icms-ini) <> year(input frame f-pg-sel da-dt-fim))
       then do:
       run utp/ut-msgs.p (input "show",
                          input 3230,
                          input "").
       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to da-icms-ini in frame f-pg-par.                   
       return error.
    end.

    if input frame f-pg-par l-tot-icms and 
       (month(input frame f-pg-par da-icms-fim) <> month(input frame f-pg-sel da-dt-fim) or
        year(input frame f-pg-par da-icms-fim) <> year(input frame f-pg-sel da-dt-fim))
       then do:
       run utp/ut-msgs.p (input "show",
                          input 3231,
                          input "").
       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to da-icms-fim in frame f-pg-par.                   
       return error.
    end.  

    /***************************************/
    create tt-param.
    /***************************************/

    ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                        (IF l-incentiva = true THEN 8 ELSE 1) 
                    &ELSE 
                        1 
                    &ENDIF.

    find last contr-livros where contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini
         and  contr-livros.livro = i-livro no-lock no-error.
    if  not avail contr-livros then do:

        &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
            IF l-incentiva = TRUE THEN
                run utp/ut-msgs.p (input "show",
                                   input 28515,
                                   input "").
            ELSE
                run utp/ut-msgs.p (input "show",
                               input 3225,
                               input "").

        &ELSE 
            run utp/ut-msgs.p (input "show",
                               input 3225,
                               input "").
        &ENDIF.

    end.
    else   
      if not input frame f-pg-par l-emissao then do:
         find first b-contr-livros use-index ch-livro where
                    b-contr-livros.cod-estabel  = input frame f-pg-sel c-cod-estabel-ini
              and   b-contr-livros.dt-ult-emi   = input frame f-pg-sel da-dt-inic - 1
              and   b-contr-livros.livro        = i-livro no-lock no-error.
         if contr-livros.dt-ult-emi <> input frame f-pg-sel da-dt-inic - 1
            and not avail b-contr-livros then do:
            run utp/ut-msgs.p (input "show",
                               input 3233,
                               input "").
         end.

         if avail b-contr-livros then
            find first contr-livros use-index ch-livro where
                       contr-livros.cod-estabel = input frame f-pg-sel c-cod-estabel-ini
                   and contr-livros.dt-ult-emi >= input frame f-pg-sel da-dt-inic
                   and contr-livros.livro       = i-livro no-lock no-error.

         if avail contr-livros then do:
            run utp/ut-msgs.p (input "show",
                               input 3239,
                               input "").
             assign tt-param.l-eliqui = yes.
         end.
     end. 


    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    assign tt-param.usuario           = c-seg-usuario
           tt-param.destino           = input frame f-pg-imp rs-destino
           tt-param.data-exec         = today
           tt-param.hora-exec         = time
           tt-param.cod-estabel-ini   = input frame f-pg-sel c-cod-estabel-ini
           tt-param.cod-estabel-fim   = input frame f-pg-sel c-cod-estabel-fim
           tt-param.dt-inic           = input frame f-pg-sel da-dt-inic
           tt-param.dt-fim            = input frame f-pg-sel da-dt-fim
           tt-param.resum-per         = input frame f-pg-par l-resum-per
           tt-param.resum-mes         = input frame f-pg-par l-resum-mes
           tt-param.tot-icms          = input frame f-pg-par l-tot-icms
           tt-param.tot-ant           = input frame f-pg-par l-tot-ant
           tt-param.fornec            = input frame f-pg-par l-fornec
           tt-param.insc-est          = input frame f-pg-par l-insc-est
           tt-param.cont-contabil     = input frame f-pg-par l-cont-contabil
           tt-param.docto             = input frame f-pg-par l-docto
           tt-param.dt-icms-ini       = input frame f-pg-par da-icms-ini
           tt-param.dt-icms-fim       = input frame f-pg-par da-icms-fim
           tt-param.emissao           = input frame f-pg-par l-emissao
           tt-param.incentiva         = input frame f-pg-par l-incentiva
           tt-param.l-icms-subst      = input frame f-pg-par l-icms-subst
           tt-param.l-cfop-serv       = INPUT FRAME f-pg-par l-cfop-servico.

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".





    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i ofp/esof0540rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

end procedure.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-data-documento C-Win 
PROCEDURE pi-valida-data-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if (input frame f-pg-sel da-dt-fim < input frame f-pg-sel da-dt-inic)
     or (month(input frame f-pg-sel da-dt-fim) <> month(input frame f-pg-sel da-dt-inic)) 
     or (year(input frame f-pg-sel da-dt-fim) <> year(input frame f-pg-sel da-dt-inic)) then do:
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

