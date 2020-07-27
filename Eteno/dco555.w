&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
def temp-table tt-planilha no-undo
    FIELD ttv-tp-venda                  AS CHAR
    FIELD ttv-organizacao               AS CHAR
    FIELD ttv-canal-distrib             AS CHAR
    FIELD ttv-setor                     AS CHAR
    FIELD ttv-emissor                   AS CHAR
    FIELD ttv-nr-pedido                 AS CHAR
    FIELD ttv-it-codigo                 AS CHAR
    FIELD ttv-condicao-coml             AS CHAR
    FIELD ttv-material                  AS CHAR
    FIELD ttv-lote                      AS CHAR
    FIELD ttv-qtde                      AS DEC FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD ttv-dt-entrega                AS DATE
    FIELD ttv-preco-negoc               AS DEC FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD ttv-selected                  AS CHAR
    FIELD ttv-linha                     AS INTEGER
    field ttv-centro                    as char
    field ttv-deposito                  as char
    field ttv-transbordo                as char
    field ttv-cod-parceiro              as char
    field ttv-texto                     as char
    field ttv-OV                        as char
    field ttv-estabelecimento           as CHAR
    FIELD ttv-pedido                    AS INTEGER.

define temp-table tt-itens
    field ttv-it-codigo     as char
    field ttv-tratado       as char
    field ttv-dep-padrao    as char
    field ttv-un            as char.





/* Local Variable Definitions ---                                       */
def var ch-excel As Com-handle No-undo.
def var ch-book  As Com-handle No-undo.
def var ch-sheet As Com-handle No-undo.
Def Var i-linha  As Int        No-undo.
Def Var l-erro   As Log        No-undo.
Def Var i        As Int        No-undo.
DEF VAR v_cod_dwb_set_parameters_mor AS CHAR NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
DEF VAR v_cod_dwb_program AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF VAR i-memo AS INTEGER NO-UNDO.
DEF VAR v_cod_dwb_user AS CHAR NO-UNDO.
DEF VAR c-acao AS CHAR NO-UNDO.
def var c-arquivo-conv  as char no-undo.
DEF VAR l-ok            AS LOGICAL NO-UNDO.
DEF VAR v-num-linha     AS INTEGER NO-UNDO.
DEF VAR v-vlr-total     AS DEC.

DEFINE BUFFER b-tt-planilha FOR tt-planilha.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-planilha

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-planilha.ttv-selected tt-planilha.ttv-estabelecimento tt-planilha.ttv-pedido tt-planilha.ttv-tp-venda tt-planilha.ttv-organizacao tt-planilha.ttv-canal-distrib tt-planilha.ttv-setor tt-planilha.ttv-emissor tt-planilha.ttv-nr-pedido tt-planilha.ttv-it-codigo tt-planilha.ttv-condicao-coml tt-planilha.ttv-material tt-planilha.ttv-lote tt-planilha.ttv-qtde tt-planilha.ttv-dt-entrega tt-planilha.ttv-preco-negoc tt-planilha.ttv-centro tt-planilha.ttv-deposito tt-planilha.ttv-transbordo tt-planilha.ttv-cod-parceiro tt-planilha.ttv-texto tt-planilha.ttv-OV   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 tt-planilha.ttv-estabelecimento   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-planilha              INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha              INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-planilha


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-13 bt-executar bt-importar ~
c-planilha bt-dir-entrada BROWSE-2 c-motivo c-status 
&Scoped-Define DISPLAYED-OBJECTS c-planilha c-motivo c-status FILL-IN-4 ~
FILL-IN-5 FILL-IN-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-dir-entrada 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-importar 
     LABEL "Importa Planilha" 
     SIZE 17.14 BY 1.13.

DEFINE VARIABLE c-motivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 102 BY .88 NO-UNDO.

DEFINE VARIABLE c-planilha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Planilha" 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-status AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U INITIAL "Concluido com sucesso" 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88
     BGCOLOR 10  NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Necessita de a‡Æo posterior" 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Erro - Verifique motivo" 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88
     BGCOLOR 12  NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123.43 BY 3.67.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 126 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-planilha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-livre _FREEFORM
  QUERY BROWSE-2 DISPLAY
      tt-planilha.ttv-selected             column-label "Selecionado"
tt-planilha.ttv-estabelecimento      column-label "Estabelecimento"
tt-planilha.ttv-pedido               COLUMN-LABEL 'Aglutinador'
tt-planilha.ttv-tp-venda             COLUMN-LABEL "Tp.Venda"
tt-planilha.ttv-organizacao          column-label "Organ"
tt-planilha.ttv-canal-distrib        column-label "CanalDistrib"
tt-planilha.ttv-setor                column-label "Setor"
tt-planilha.ttv-emissor              column-label "Emissor"
tt-planilha.ttv-nr-pedido            column-label "Nr.Pedido"
tt-planilha.ttv-it-codigo            column-label "Item"    FORMAT "x(20)"
tt-planilha.ttv-condicao-coml        column-label "Cond.Coml"
tt-planilha.ttv-material             column-label "Material" FORMAT "x(20)"
tt-planilha.ttv-lote                 column-label "Lote"
tt-planilha.ttv-qtde                 column-label "Qtde"
tt-planilha.ttv-dt-entrega           column-label "Dt.Entrega"
tt-planilha.ttv-preco-negoc          column-label "Preco"
tt-planilha.ttv-centro               column-label "Centro"
tt-planilha.ttv-deposito             column-label "Deposito"
tt-planilha.ttv-transbordo           column-label "Transbordo"
tt-planilha.ttv-cod-parceiro         column-label "Cod-Parceiro"
tt-planilha.ttv-texto                column-label "Texto"
tt-planilha.ttv-OV                   column-label "OV"
ENABLE 
    tt-planilha.ttv-estabelecimento
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123.43 BY 12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-executar AT ROW 1.21 COL 19.43 WIDGET-ID 4
     bt-importar AT ROW 1.25 COL 1.57 WIDGET-ID 2
     c-planilha AT ROW 1.25 COL 42.72 COLON-ALIGNED WIDGET-ID 8
     bt-dir-entrada AT ROW 1.25 COL 86.14 HELP
          "Escolha do nome do arquivo" WIDGET-ID 24
     BROWSE-2 AT ROW 4.29 COL 2.43 WIDGET-ID 200
     c-motivo AT ROW 19.75 COL 21.57 NO-LABEL WIDGET-ID 26
     c-status AT ROW 19.79 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-4 AT ROW 20.92 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-5 AT ROW 20.92 COL 39.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-6 AT ROW 20.92 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     "A‡äes" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 18.67 COL 3.29 WIDGET-ID 42
     rt-button AT ROW 1 COL 1
     RECT-13 AT ROW 18.92 COL 1.86 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 21.79 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 21.79
         WIDTH              = 126.43
         MAX-HEIGHT         = 21.79
         MAX-WIDTH          = 126.43
         VIRTUAL-HEIGHT     = 21.79
         VIRTUAL-WIDTH      = 126.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-2 bt-dir-entrada f-cad */
/* SETTINGS FOR FILL-IN c-motivo IN FRAME f-cad
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha
             INDEXED-REPOSITION
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 w-livre
ON ROW-DISPLAY OF BROWSE-2 IN FRAME f-cad
DO:
IF tt-planilha.ttv-it-codigo = "0" THEN DO:
    ASSIGN 
tt-planilha.ttv-selected:BGCOLOR in browse browse-2 = 12 
tt-planilha.ttv-estabelecimento:BGCOLOR in browse browse-2 = 12 
tt-planilha.ttv-pedido:BGCOLOR in browse browse-2 = 12          
tt-planilha.ttv-tp-venda:BGCOLOR in browse browse-2 = 12        
tt-planilha.ttv-organizacao:BGCOLOR in browse browse-2 = 12     
tt-planilha.ttv-canal-distrib:BGCOLOR in browse browse-2 = 12   
tt-planilha.ttv-setor:BGCOLOR in browse browse-2 = 12           
tt-planilha.ttv-emissor:BGCOLOR in browse browse-2 = 12         
tt-planilha.ttv-nr-pedido:BGCOLOR in browse browse-2 = 12       
tt-planilha.ttv-it-codigo:BGCOLOR in browse browse-2 = 12       
tt-planilha.ttv-condicao-coml:BGCOLOR in browse browse-2 = 12   
tt-planilha.ttv-material:BGCOLOR in browse browse-2 = 12        
tt-planilha.ttv-lote:BGCOLOR in browse browse-2 = 12            
tt-planilha.ttv-qtde:BGCOLOR in browse browse-2 = 12            
tt-planilha.ttv-dt-entrega:BGCOLOR in browse browse-2 = 12      
tt-planilha.ttv-preco-negoc:BGCOLOR in browse browse-2 = 12     
tt-planilha.ttv-centro:BGCOLOR in browse browse-2 = 12          
tt-planilha.ttv-deposito:BGCOLOR in browse browse-2 = 12        
tt-planilha.ttv-transbordo:BGCOLOR in browse browse-2 = 12      
tt-planilha.ttv-cod-parceiro:BGCOLOR in browse browse-2 = 12    
tt-planilha.ttv-texto:BGCOLOR in browse browse-2 = 12           
tt-planilha.ttv-OV:BGCOLOR in browse browse-2 = 12.
END.
IF tt-planilha.ttv-pedido = 0 THEN DO:
    ASSIGN 
   tt-planilha.ttv-selected:BGCOLOR in browse browse-2 = 14 
   tt-planilha.ttv-estabelecimento:BGCOLOR in browse browse-2 = 14 
   tt-planilha.ttv-pedido:BGCOLOR in browse browse-2 = 14          
   tt-planilha.ttv-tp-venda:BGCOLOR in browse browse-2 = 14        
   tt-planilha.ttv-organizacao:BGCOLOR in browse browse-2 = 14     
   tt-planilha.ttv-canal-distrib:BGCOLOR in browse browse-2 = 14   
   tt-planilha.ttv-setor:BGCOLOR in browse browse-2 = 14           
   tt-planilha.ttv-emissor:BGCOLOR in browse browse-2 = 14         
   tt-planilha.ttv-nr-pedido:BGCOLOR in browse browse-2 = 14       
   tt-planilha.ttv-it-codigo:BGCOLOR in browse browse-2 = 14       
   tt-planilha.ttv-condicao-coml:BGCOLOR in browse browse-2 = 14   
   tt-planilha.ttv-material:BGCOLOR in browse browse-2 = 14        
   tt-planilha.ttv-lote:BGCOLOR in browse browse-2 = 14            
   tt-planilha.ttv-qtde:BGCOLOR in browse browse-2 = 14            
   tt-planilha.ttv-dt-entrega:BGCOLOR in browse browse-2 = 14      
   tt-planilha.ttv-preco-negoc:BGCOLOR in browse browse-2 = 14     
   tt-planilha.ttv-centro:BGCOLOR in browse browse-2 = 14          
   tt-planilha.ttv-deposito:BGCOLOR in browse browse-2 = 14        
   tt-planilha.ttv-transbordo:BGCOLOR in browse browse-2 = 14      
   tt-planilha.ttv-cod-parceiro:BGCOLOR in browse browse-2 = 14    
   tt-planilha.ttv-texto:BGCOLOR in browse browse-2 = 14           
   tt-planilha.ttv-OV:BGCOLOR in browse browse-2 = 14.

END.
IF tt-planilha.ttv-pedido <> 0 THEN DO:
    ASSIGN 
   tt-planilha.ttv-selected:BGCOLOR in browse browse-2 = 10
   tt-planilha.ttv-estabelecimento:BGCOLOR in browse browse-2 = 10 
   tt-planilha.ttv-pedido:BGCOLOR in browse browse-2 = 10          
   tt-planilha.ttv-tp-venda:BGCOLOR in browse browse-2 = 10        
   tt-planilha.ttv-organizacao:BGCOLOR in browse browse-2 = 10     
   tt-planilha.ttv-canal-distrib:BGCOLOR in browse browse-2 = 10   
   tt-planilha.ttv-setor:BGCOLOR in browse browse-2 = 10          
   tt-planilha.ttv-emissor:BGCOLOR in browse browse-2 = 10         
   tt-planilha.ttv-nr-pedido:BGCOLOR in browse browse-2 = 10       
   tt-planilha.ttv-it-codigo:BGCOLOR in browse browse-2 = 10       
   tt-planilha.ttv-condicao-coml:BGCOLOR in browse browse-2 = 10   
   tt-planilha.ttv-material:BGCOLOR in browse browse-2 = 10        
   tt-planilha.ttv-lote:BGCOLOR in browse browse-2 = 10            
   tt-planilha.ttv-qtde:BGCOLOR in browse browse-2 = 10            
   tt-planilha.ttv-dt-entrega:BGCOLOR in browse browse-2 = 10      
   tt-planilha.ttv-preco-negoc:BGCOLOR in browse browse-2 = 10     
   tt-planilha.ttv-centro:BGCOLOR in browse browse-2 = 10          
   tt-planilha.ttv-deposito:BGCOLOR in browse browse-2 = 10        
   tt-planilha.ttv-transbordo:BGCOLOR in browse browse-2 = 10      
   tt-planilha.ttv-cod-parceiro:BGCOLOR in browse browse-2 = 10    
   tt-planilha.ttv-texto:BGCOLOR in browse browse-2 = 10          
   tt-planilha.ttv-OV:BGCOLOR in browse browse-2 = 10.

END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-entrada w-livre
ON CHOOSE OF bt-dir-entrada IN FRAME f-cad
DO:
 

    assign c-arquivo-conv = replace(input frame f-cad c-planilha, "/", "~\").

    SYSTEM-DIALOG GET-FILE c-arquivo-conv
       FILTERS "*.xls" "*.xls",
               "*.xlsx" "*.xlsx",
               "*.*" "*.*"
       DEFAULT-EXTENSION "xls"
       INITIAL-DIR SESSION:TEMP-DIRECTORY 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-planilha = replace(c-arquivo-conv, "~\", "/").
        display c-planilha with frame f-cad.
    end.


    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-livre
ON CHOOSE OF bt-executar IN FRAME f-cad /* Executar */
DO:
RUN pi-executar.
{&open-query-browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar w-livre
ON CHOOSE OF bt-importar IN FRAME f-cad /* Importa Planilha */
DO:
   EMPTY TEMP-TABLE tt-planilha.
  RUN importa-planilha.
  {&OPEN-QUERY-browse-2}

  APPLY "value-changed" TO BROWSE browse-2.

  ASSIGN v-num-linha = browse-2:NUM-ITERATIONS.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 110.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-executar:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY c-planilha c-motivo c-status FILL-IN-4 FILL-IN-5 FILL-IN-6 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-13 bt-executar bt-importar c-planilha bt-dir-entrada 
         BROWSE-2 c-motivo c-status 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importa-planilha w-livre 
PROCEDURE importa-planilha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
DEFINE VARIABLE h-prog        AS HANDLE                           NO-UNDO.
{office/office.i Excel chExcel}

    EMPTY TEMP-TABLE tt-planilha.
    
           chWorkBook = chexcel:Workbooks:Add(c-arquivo-conv). 
           chWorkSheet = chWorkBook:worksheets(1).
    
    Assign i-linha = 10
           l-erro  = No.
   
    ASSIGN bt-importar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    RUN utp\ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Importando planilha").
    
   Repeat:

    
        i-linha = i-linha + 1.
    
        RUN pi-acompanhar IN h-prog(INPUT "Linha :" + STRING(i-linha)).
       IF chWorkSheet:cells(i-linha, 1):Text = ""  Then Leave.

       create tt-planilha.
       assign tt-planilha.ttv-tp-venda            = chWorkSheet:cells(i-linha, 1):Text
              tt-planilha.ttv-organizacao         = chWorkSheet:cells(i-linha, 2):Text
              tt-planilha.ttv-canal-distrib       = chWorkSheet:cells(i-linha, 3):Text
              tt-planilha.ttv-setor               = chWorkSheet:cells(i-linha, 4):Text
              tt-planilha.ttv-emissor             = chWorkSheet:cells(i-linha, 5):text
              tt-planilha.ttv-nr-pedido           = chWorkSheet:cells(i-linha, 6):TEXT
              tt-planilha.ttv-it-codigo           = chWorkSheet:cells(i-linha, 7):Text
              tt-planilha.ttv-condicao-coml       = chWorkSheet:cells(i-linha, 8):Text 
              tt-planilha.ttv-material            = chWorkSheet:cells(i-linha, 9):Text
              tt-planilha.ttv-lote                = chWorkSheet:cells(i-linha, 10):TEXT
              tt-planilha.ttv-qtde                = dec(chWorkSheet:cells(i-linha, 11):Text)
              tt-planilha.ttv-dt-entrega          = date(chWorkSheet:cells(i-linha, 12):Text)
              tt-planilha.ttv-preco-negoc         = dec(chWorkSheet:cells(i-linha, 13):Text)
              tt-planilha.ttv-centro              = chWorkSheet:cells(i-linha, 14):TEXT
              tt-planilha.ttv-deposito            = chWorkSheet:cells(i-linha, 15):TEXT
              tt-planilha.ttv-transbordo          = chWorkSheet:cells(i-linha, 16):TEXT
              tt-planilha.ttv-cod-parceiro        = chWorkSheet:cells(i-linha, 17):TEXT
              tt-planilha.ttv-texto               = chWorkSheet:cells(i-linha, 18):TEXT
              tt-planilha.ttv-OV                  = chWorkSheet:cells(i-linha, 19):TEXT
              tt-planilha.ttv-estabelecimento     = chWorkSheet:cells(i-linha, 20):TEXT
              tt-planilha.ttv-selected            = "*"
              tt-planilha.ttv-linha               = i-linha.
              

   END.
   RUN pi-finalizar IN h-prog. 
        chExcel:QUIT().
        ASSIGN bt-importar:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    FOR EACH tt-planilha:

                case tt-planilha.ttv-setor:
                    when "22" then do:

                        find first tt-itens no-lock where tt-itens.ttv-tratado = trim(replace(replace(tt-planilha.ttv-material, "PL14", ""), " ", "")) no-error.

                        if avail tt-itens then do:

                            assign tt-planilha.ttv-it-codigo = tt-itens.ttv-it-codigo.
                        end.
                        ELSE DO:
                            ASSIGN tt-planilha.ttv-it-codigo = 'Nao encontrado'
                                   tt-planilha.ttv-selected = "".
                        END.
                    end.
                        otherwise do:
                            find first tt-itens no-lock where tt-itens.ttv-tratado = trim(replace(tt-planilha.ttv-material, " ", "")) no-error.
                            
                            if avail tt-itens then do:

                                assign tt-planilha.ttv-it-codigo = tt-itens.ttv-it-codigo.

                            end.

                            ELSE DO:
                                ASSIGN tt-planilha.ttv-it-codigo = 'Nao encontrado'
                                       tt-planilha.ttv-selected = "".
                            END.
                        end.
                end.

                FIND FIRST cond-pagto NO-LOCK WHERE entry(1, cond-pagto.descricao, " dias") = STRING(int(entry(1, trim(tt-planilha.ttv-condicao-coml), "A"))) NO-ERROR.

                IF AVAIL cond-pagto THEN
                    ASSIGN tt-planilha.ttv-condicao-coml = string(cond-pagto.cod-cond-pag).
                ELSE
                    ASSIGN tt-planilha.ttv-condicao-coml = "?".

         IF tt-planilha.ttv-qtde < 24.750 THEN DO:

            ASSIGN v-vlr-total = v-vlr-total + tt-planilha.ttv-qtde.

            IF v-vlr-total < 24.750 THEN DO:
                ASSIGN tt-planilha.ttv-pedido = i.
            END.

            ELSE DO:
                    v-vlr-total = 0.
            
                ASSIGN tt-planilha.ttv-pedido = i.
                ASSIGN i = i + 1.


            END.
         END.

         ELSE DO:
             ASSIGN tt-planilha.ttv-pedido = i.
             ASSIGN i = i + 1
                    v-vlr-total = 0.
         END.
         ASSIGN tt-planilha.ttv-qtde = dec(tt-planilha.ttv-qtde) * 1000
                tt-planilha.ttv-preco = dec(tt-planilha.ttv-preco-negoc) / 1000.

    END.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "XX9999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

      for each item no-lock where item.ge-codigo >= 30
    and item.ge-codigo <= 40:

        create tt-itens.
        assign tt-itens.ttv-it-codigo   = item.it-codigo
               tt-itens.ttv-tratado     = trim(replace(replace(item.it-codigo, "-", ""), " ", ""))
               tt-itens.ttv-dep-padrao  = item.deposito-pad
               tt-itens.ttv-un          = item.un.
    end.


  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-livre 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN esp\escc0300rp.p(INPUT-OUTPUT TABLE tt-planilha).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-planilha"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

