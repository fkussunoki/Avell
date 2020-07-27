&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          eai              PROGRESS
*/
&Scoped-define WINDOW-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS c-win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esrc0501a 1.00.00.000 } /*** 010033 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esrc0501a ACR}
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
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Temporary Table Definitions ---                                      */


define temp-table tt-param NO-UNDO
    field destino       as integer
    field arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field classifica    as integer
    field c-serie-ini   as char
    field c-serie-fim   as char
    field c-docto-ini   as char
    field c-docto-fim   as char
    field c-opera-ini   as char
    field c-opera-fim   as char
    field i-emite-ini   as integer
    field i-emite-fim   as integer
    field c-est-ini     as char
    field c-est-fim     as char
    field da-trans-ini  as date format "99/99/9999"
    field da-trans-fim  as date format "99/99/9999"
    field da-atual-ini  as date format "99/99/9999"
    field da-atual-fim  as date format "99/99/9999"
    field c-usuario-ini as char format "x(12)"
    field c-usuario-fim as char format "x(12)"    
    field da-emis-ini   as date format "99/99/9999"
    field da-emis-fim   as date format "99/99/9999"
    field i-tipo-ini    as integer
    field i-tipo-fim    as integer
    field i-parametro   as integer
    field l-narrativa   as logical
    field l-mensagem    as logical
    field l-grade       as logical
    field l-fasb        as logical
    field l-cmcac       as logical
    field l-deta        as logical
    field l-docto-imp   as logical
    field l-extr-forn   as logical
    field l-comp        as logical
    field i-custo       as integer
    field i-mo-fasb     as integer
    field i-mo-cmcac    as integer
    field c-custo       as char
    field c-param       as char
    field c-classe      as char
    field c-destino     as char
    field l-param       as logical.
/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */


/* Local Variable Definitions ---                                       */
def var l-ok            as logical no-undo.
def var c-arq-digita    as char    no-undo.
def var c-terminal      as char    no-undo.
def var i-mo-fasb       as integer no-undo.
def var i-mo-cmcac      as integer no-undo.
def var i-x             as integer no-undo.
def var c-lista         as char    no-undo.
def var c-lista-aux     as char    no-undo.
def var l-mostra        as logical no-undo.
def var l-insere        as logical init no no-undo.
DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

/* include com defini‡Æo de pr‚-processadores */
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES grup-estoque estabelec item param-estoq

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH grup-estoque SHARE-LOCK, ~
      EACH mgadm.estabelec WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK, ~
      EACH item OF grup-estoque SHARE-LOCK, ~
      EACH param-estoq WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH grup-estoque SHARE-LOCK, ~
      EACH mgadm.estabelec WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK, ~
      EACH item OF grup-estoque SHARE-LOCK, ~
      EACH param-estoq WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel grup-estoque estabelec item ~
param-estoq
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel grup-estoque
&Scoped-define SECOND-TABLE-IN-QUERY-f-pg-sel estabelec
&Scoped-define THIRD-TABLE-IN-QUERY-f-pg-sel item
&Scoped-define FOURTH-TABLE-IN-QUERY-f-pg-sel param-estoq


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 RECT-11 rs-destino ~
bt-config-impr bt-arquivo c-arquivo rs-execucao tb-imprimir-parametro ~
text-parametro 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao ~
tb-imprimir-parametro text-parametro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR c-win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
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

DEFINE VARIABLE text-parametro AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 19.72 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3,
"Planilha", 4
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 2.13.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 1.71.

DEFINE VARIABLE tb-imprimir-parametro AS LOGICAL INITIAL yes 
     LABEL "Imprimir parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE c-esp-fim AS CHARACTER FORMAT "X(20)":U INITIAL "0" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE c-esp-ini AS CHARACTER FORMAT "X(20)":U INITIAL "0" 
     LABEL "Esp‚cie Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE c-docto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "9999999999999999" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-docto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "N£mero" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-est-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-est-ini LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-opera-fim AS CHARACTER FORMAT "9.99-xxx":U INITIAL "999ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-opera-ini AS CHARACTER FORMAT "9.99-xxx":U 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu rio Atualiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-atual-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-atual-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Atualiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-emis-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-emis-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data EmissÆo":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-trans-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-trans-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-emite-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-emite-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
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
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
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
     SIZE 79 BY 11.67
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
      grup-estoque, 
      estabelec, 
      item, 
      param-estoq SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 48 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 48 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     tb-imprimir-parametro AT ROW 8.5 COL 3 WIDGET-ID 4
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-parametro AT ROW 7.58 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
     RECT-11 AT ROW 7.88 COL 2.14 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.5 BY 10.5.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     c-serie-ini AT ROW 1.33 COL 19.57 COLON-ALIGNED WIDGET-ID 44
     c-serie-fim AT ROW 1.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     c-docto-ini AT ROW 2.38 COL 19.57 COLON-ALIGNED WIDGET-ID 28
     c-docto-fim AT ROW 2.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-opera-ini AT ROW 3.38 COL 19.57 COLON-ALIGNED WIDGET-ID 40
     c-opera-fim AT ROW 3.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     i-emite-ini AT ROW 4.38 COL 19.57 COLON-ALIGNED WIDGET-ID 64
     i-emite-fim AT ROW 4.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     c-est-ini AT ROW 5.38 COL 19.57 COLON-ALIGNED HELP
          "" WIDGET-ID 36
          LABEL "Estab":R7
     c-est-fim AT ROW 5.38 COL 48.72 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 34
     da-trans-ini AT ROW 6.38 COL 19.57 COLON-ALIGNED WIDGET-ID 60
     da-trans-fim AT ROW 6.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     da-atual-ini AT ROW 7.29 COL 19.57 COLON-ALIGNED WIDGET-ID 52
     da-atual-fim AT ROW 7.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     c-usuario-ini AT ROW 8.33 COL 19.57 COLON-ALIGNED WIDGET-ID 48
     c-usuario-fim AT ROW 8.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     da-emis-fim AT ROW 9.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     da-emis-ini AT ROW 9.42 COL 19.57 COLON-ALIGNED WIDGET-ID 56
     c-esp-fim AT ROW 10.38 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     c-esp-ini AT ROW 10.42 COL 19.57 COLON-ALIGNED WIDGET-ID 32
     IMAGE-1 AT ROW 1.38 COL 42.29 WIDGET-ID 66
     IMAGE-10 AT ROW 2.38 COL 47.29 WIDGET-ID 68
     IMAGE-11 AT ROW 3.38 COL 47.29 WIDGET-ID 70
     IMAGE-12 AT ROW 4.38 COL 47.29 WIDGET-ID 72
     IMAGE-13 AT ROW 5.38 COL 47.29 WIDGET-ID 74
     IMAGE-14 AT ROW 6.38 COL 47.29 WIDGET-ID 76
     IMAGE-15 AT ROW 7.38 COL 47.29 WIDGET-ID 78
     IMAGE-16 AT ROW 9.38 COL 47.29 WIDGET-ID 80
     IMAGE-2 AT ROW 1.38 COL 47.29 WIDGET-ID 82
     IMAGE-3 AT ROW 2.38 COL 42.29 WIDGET-ID 84
     IMAGE-35 AT ROW 10.38 COL 47.29 WIDGET-ID 86
     IMAGE-36 AT ROW 10.38 COL 42.29 WIDGET-ID 88
     IMAGE-37 AT ROW 8.38 COL 47.29 WIDGET-ID 90
     IMAGE-38 AT ROW 8.38 COL 42.29 WIDGET-ID 92
     IMAGE-4 AT ROW 3.38 COL 42.29 WIDGET-ID 94
     IMAGE-5 AT ROW 4.38 COL 42.29 WIDGET-ID 96
     IMAGE-6 AT ROW 5.38 COL 42.29 WIDGET-ID 98
     IMAGE-7 AT ROW 6.38 COL 42.29 WIDGET-ID 100
     IMAGE-8 AT ROW 7.38 COL 42.29 WIDGET-ID 102
     IMAGE-9 AT ROW 9.38 COL 42.29 WIDGET-ID 104
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.57 BY 10.79.


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
  CREATE WINDOW c-win ASSIGN
         HIDDEN             = YES
         TITLE              = "Cobranca - Posicao"
         HEIGHT             = 15.08
         WIDTH              = 81.14
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB c-win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW c-win
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
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-est-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-est-ini IN FRAME f-pg-sel
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
THEN c-win:HIDDEN = no.

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
     _TblList          = "eai.grup-estoque,mgadm.estabelec WHERE eai.grup-estoque ...,eai.item OF eai.grup-estoque,eai.param-estoq WHERE eai.grup-estoque ..."
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON END-ERROR OF c-win /* Cobranca - Posicao */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON WINDOW-CLOSE OF c-win /* Cobranca - Posicao */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda c-win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo c-win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar c-win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr c-win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar c-win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
    do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp c-win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel c-win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao c-win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK c-win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "esrc0501a" "1.00.00.000"}

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   RUN disable_UI.
END.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


    RUN enable_UI.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
   DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
   ASSIGN cAuxTraducao001 = {ininc/i03in218.i 03}.
   RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
   ASSIGN c-lista     = cAuxTraducao001.
&else
   ASSIGN c-lista     = {ininc/i03in218.i 03}.
&endif
ASSIGN 
             c-lista-aux = "".
      do  i-x = 20 to 23:
          assign c-lista-aux = c-lista-aux + string(i-x,"99") + " - " + entry(i-x,c-lista).
          if  i-x <> 23 then
              assign c-lista-aux = c-lista-aux + ",".
      end.
      assign c-esp-ini:list-items in frame f-pg-sel = c-lista-aux
             c-esp-fim:list-items in frame f-pg-sel = c-lista-aux.

    {utp/ut-field.i mgind natur-oper nat-operacao 4}
    assign c-opera-ini:format in frame f-pg-sel = trim(return-value)
           c-opera-fim:format in frame f-pg-sel = trim(return-value).

     ASSIGN c-est-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".

     assign c-esp-ini:screen-value in frame f-pg-sel = entry(1,c-lista-aux)
            c-esp-fim:screen-value in frame f-pg-sel = entry(num-entries(c-lista-aux),c-lista-aux).

     {include/i-rpmbl.i im-pg-sel}



     IF  NOT THIS-PROCEDURE:PERSISTENT THEN
         WAIT-FOR CLOSE OF THIS-PROCEDURE.




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects c-win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available c-win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI c-win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
  THEN DELETE WIDGET c-win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI c-win  _DEFAULT-ENABLE
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
  ENABLE im-pg-imp im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-destino c-arquivo rs-execucao tb-imprimir-parametro text-parametro 
      WITH FRAME f-pg-imp IN WINDOW c-win.
  ENABLE RECT-7 RECT-9 RECT-11 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao tb-imprimir-parametro text-parametro 
      WITH FRAME f-pg-imp IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY c-serie-ini c-serie-fim c-docto-ini c-docto-fim c-opera-ini 
          c-opera-fim i-emite-ini i-emite-fim c-est-ini c-est-fim da-trans-ini 
          da-trans-fim da-atual-ini da-atual-fim c-usuario-ini c-usuario-fim 
          da-emis-fim da-emis-ini c-esp-fim c-esp-ini 
      WITH FRAME f-pg-sel IN WINDOW c-win.
  ENABLE IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 
         IMAGE-2 IMAGE-3 IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 IMAGE-4 IMAGE-5 
         IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 c-serie-ini c-serie-fim c-docto-ini 
         c-docto-fim c-opera-ini c-opera-fim i-emite-ini i-emite-fim c-est-ini 
         c-est-fim da-trans-ini da-trans-fim da-atual-ini da-atual-fim 
         c-usuario-ini c-usuario-fim da-emis-fim da-emis-ini c-esp-fim 
         c-esp-ini 
      WITH FRAME f-pg-sel IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW c-win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit c-win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize c-win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar c-win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}
    if  input frame f-pg-imp rs-destino = 2 OR 
        input frame f-pg-imp rs-destino = 4 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry'              to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.


/*             /* Valida‡Æo de duplicidade de registro na temp-table tt-digita */                                                 */
/*             find first b-tt-digita where b-tt-digita.cod-estabel = tt-digita.cod-estabel and                                   */
/*                                          rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.                              */
/*             if avail b-tt-digita then do:                                                                                      */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid rowid(b-tt-digita).                                                              */
/*                                                                                                                                */
/*                 run utp/ut-msgs.p (input "show", input 108, input "").                                                         */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             /* As demais valida‡äes devem ser feitas aqui */                                                                   */
/*             if not can-find(estabelec where estabelec.cod-estabel = tt-digita.cod-estabel)                                     */
/*             then do:                                                                                                           */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                                                                                                                                */
/*                 {utp/ut-table.i mgadm estabelec 1}                                                                             */
/*                 run utp/ut-msgs.p (input "show", input 2, input return-value).                                                 */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             find estab-mat where estab-mat.cod-estabel = tt-digita.cod-estabel                                                 */
/*                  no-lock no-error.                                                                                             */
/*             if not avail estab-mat then do:                                                                                    */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                                                                                                                                */
/*                 {utp/ut-table.i mgind estab-mat 1}                                                                             */
/*                 run utp/ut-msgs.p (input "show", input 2, input return-value).                                                 */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             run cdp/cdapi005.p (input  estab-mat.ult-per-fech,                                                                 */
/*                                 output da-iniper-x,                                                                            */
/*                                 output da-fimper-x,                                                                            */
/*                                 output i-mes,                                                                                  */
/*                                 output i-ano,                                                                                  */
/*                                 output da-iniper-fech,                                                                         */
/*                                 output da-fimper-fech).                                                                        */
/*                                                                                                                                */
/*             if i-mes = ? or                                                                                                    */
/*                i-ano = 0 then do:                                                                                              */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                 run utp/ut-msgs.p (input "show", input 16459, input "").                                                       */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*                                                                                                                                */
/*             end.                                                                                                               */
/*             if estab-mat.ult-per-fech = "" or                                                                                  */
/*                estab-mat.ult-per-fech = ? then do:                                                                             */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                 run utp/ut-msgs.p (input "show", input 17109, input "").                                                       */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*         end.                                                                                                                   */
/*     &endif.                                                                                                                    */
/*                                                                                                                                */
/*     /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas                                                       */
/*        devem apresentar uma mensagem de erro cadastrada, posicionar na p gina                                                  */
/*        com problemas e colocar o focus no campo com problemas             */                                                   */
/*                                                                                                                                */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) = 1                                                                   */
/*     and param-estoq.tem-moeda1 = no then do:                                                                                   */
/*         run utp/ut-msgs.p (input "show", input 110, input "").                                                                 */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) = 2                                                                   */
/*     and param-estoq.tem-moeda2 = no then do:                                                                                   */
/*         run utp/ut-msgs.p (input "show", input 111, input "").                                                                 */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) > 2 then do:                                                          */
/*         run utp/ut-msgs.p (input "show", input 4412, input "").                                                                */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */
/*     /*Validar se existe ano fiscal cadastrado para o periodo informado*/                                                       */
/*     if not avail param-global then                                                                                             */
/*         find first param-global no-lock no-error.                                                                              */
/*                                                                                                                                */
/*     assign i-empresa = param-global.empresa-prin.                                                                              */
/*                                                                                                                                */
/*     if not can-find(first ano-fiscal where ano-fiscal.ep-codigo  = i-empresa                                                   */
/*                                        and ano-fiscal.ano-fiscal = INT(SUBSTRING(input frame f-pg-sel c-per-i,1,4))) then do:  */
/*         run utp/ut-msgs.p (input "show",                                                                                       */
/*                            input 4138,                                                                                         */
/*                            input SUBSTRING(input frame f-pg-sel c-per-i,1,4)).                                                 */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */
/*      if not can-find(first ano-fiscal where ano-fiscal.ep-codigo  = i-empresa                                                  */
/*                                         and ano-fiscal.ano-fiscal = INT(SUBSTRING(input frame f-pg-sel c-per-f,1,4))) then do: */
/*        run utp/ut-msgs.p (input "show",                                                                                        */
/*                           input 4138,                                                                                          */
/*                           input SUBSTRING(input frame f-pg-sel c-per-f,1,4)).                                                  */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */


    assign input frame f-pg-sel c-esp-ini
           input frame f-pg-sel c-esp-fim.        
    create tt-param.
    assign tt-param.usuario       = c-seg-usuario
           tt-param.destino       = input frame f-pg-imp rs-destino
           tt-param.data-exec     = today
           tt-param.hora-exec     = time
           tt-param.c-serie-ini   = input frame f-pg-sel c-serie-ini 
           tt-param.c-serie-fim   = input frame f-pg-sel c-serie-fim
           tt-param.c-docto-ini   = input frame f-pg-sel c-docto-ini
           tt-param.c-docto-fim   = input frame f-pg-sel c-docto-fim
           tt-param.c-opera-ini   = input frame f-pg-sel c-opera-ini
           tt-param.c-opera-fim   = input frame f-pg-sel c-opera-fim
           tt-param.i-emite-ini   = input frame f-pg-sel i-emite-ini
           tt-param.i-emite-fim   = input frame f-pg-sel i-emite-fim
           tt-param.c-est-ini     = input frame f-pg-sel c-est-ini
           tt-param.c-est-fim     = input frame f-pg-sel c-est-fim
           tt-param.da-trans-ini  = input frame f-pg-sel da-trans-ini
           tt-param.da-trans-fim  = input frame f-pg-sel da-trans-fim
           tt-param.da-atual-ini  = input frame f-pg-sel da-atual-ini
           tt-param.da-atual-fim  = input frame f-pg-sel da-atual-fim
           tt-param.c-usuario-ini = input frame f-pg-sel c-usuario-ini
           tt-param.c-usuario-fim = input frame f-pg-sel c-usuario-fim           
           tt-param.da-emis-ini   = input frame f-pg-sel da-emis-ini
           tt-param.da-emis-fim   = input frame f-pg-sel da-emis-fim
           tt-param.i-tipo-ini    = int(substring(c-esp-ini,1,2,"char"))
           tt-param.i-tipo-fim    = int(substring(c-esp-fim,1,2,"char")).

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 OR tt-param.destino = 4 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

     {include/i-rprun.i esp/esrc0501arp.p}
    

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina c-win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records c-win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "grup-estoque"}
  {src/adm/template/snd-list.i "estabelec"}
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "param-estoq"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed c-win 
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

