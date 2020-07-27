&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&global-define programa dco005 /*nome_do_programa  Exemplo: rel_cliente*/

{include/i-prgvrs504.i {&programa} 5.04.01.001}

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
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo           AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.
DEFINE BUFFER b-tt-digita   FOR tt-digita.
                    
/* Local Variable Definitions (Template 2)---                           */
DEF VAR l-ok                AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita        AS CHAR    NO-UNDO.
DEF VAR c-terminal          AS CHAR    NO-UNDO.

/* Local Variable Definitions (Template 5) ---                          */
DEF VAR v_num_ped_exec_rpw  AS INTEGER  NO-UNDO.
DEF VAR i-cont              AS INTEGER  NO-UNDO.
DEF VAR c-impressora        AS CHAR     NO-UNDO.
DEF VAR c-layout            AS CHAR     NO-UNDO.
DEF VAR c-char              AS CHAR     NO-UNDO.
DEF VAR rw-log-exec         AS ROWID    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR c-param-campos      AS CHARACTER    NO-UNDO.
DEF VAR c-param-tipos       AS CHARACTER    NO-UNDO.
DEF VAR c-param-dados       AS CHARACTER    NO-UNDO.

/* Shared Variable Definition ---                                       */
DEF NEW SHARED VAR v_des_estab_select       AS CHARACTER        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-65 rs-classif 
&Scoped-Define DISPLAYED-OBJECTS rs-classif 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE rs-classif AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por C¢d. Representante/C¢digo Cliente", 1,
"Por C¢d. Representante/Raz∆o Social Cliente", 2
     SIZE 42 BY 3.75 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 6.25.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

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

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-imp-param AS LOGICAL INITIAL no 
     LABEL "Imprime listagem dos parÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE rs-data AS CHARACTER INITIAL "CrÇdito" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Data Baixa", "Baixa",
"Data CrÇdito", "CrÇdito"
     SIZE 28 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 4.5.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 3.25.

DEFINE VARIABLE tg-gera-movto-comis AS LOGICAL INITIAL no 
     LABEL "Gera Movimento de Comiss‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tg-imp-comissoes AS LOGICAL INITIAL yes 
     LABEL "Comiss‰es por T°tulo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tg-imp-resumo AS LOGICAL INITIAL no 
     LABEL "Resumo do Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tg-paga-carteira AS LOGICAL INITIAL no 
     LABEL "Paga Comiss∆o Carteira de Pedidos" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tg-paga-vinculada AS LOGICAL INITIAL no 
     LABEL "Paga Comiss∆o Vinculada" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tg-rescisao AS LOGICAL INITIAL no 
     LABEL "Rescis∆o de Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE BUTTON bt-select-espec-docto 
     IMAGE-UP FILE "Image/im-ran_a.bmp":U
     LABEL "EspÇcies" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-select-estabelec 
     IMAGE-UP FILE "Image/im-ran_a.bmp":U
     LABEL "Estabelecimentos" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-select-representante 
     IMAGE-UP FILE "Image/im-ran_a.bmp":U
     LABEL "Representantes" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-lista-cdn-repres AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 41 BY .88
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE c-lista-cod-esp AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 41 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-lista-cod-estab AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 41 BY .88
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE c-fim-referencia AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-ini-referencia AS CHARACTER FORMAT "X(10)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-fim-periodo AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ini-periodo AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Comiss∆o do Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-fim-cliente AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-fim-perc-comis AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ini-cliente AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ini-perc-comis AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "% Comiss∆o da Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 8.5.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
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
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder AT ROW 2.5 COL 2
     RECT-1 AT ROW 14.29 COL 2
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         FONT 4
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-cla
     rs-classif AT ROW 4 COL 17 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
     " Classificaá∆o:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 2.5 COL 12
     RECT-65 AT ROW 2.75 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.31
         FONT 4.

DEFINE FRAME f-pg-par
     tg-gera-movto-comis AT ROW 1.75 COL 24
     tg-imp-comissoes AT ROW 2.75 COL 24
     tg-imp-resumo AT ROW 3.75 COL 24
     rs-data AT ROW 4.75 COL 24 NO-LABEL
     tg-rescisao AT ROW 6.25 COL 24
     tg-paga-vinculada AT ROW 7.25 COL 24
     tg-paga-carteira AT ROW 8.25 COL 24
     "Data Pesquisa:" VIEW-AS TEXT
          SIZE 10.72 BY .88 AT ROW 4.67 COL 13.29
     RECT-68 AT ROW 1.25 COL 7
     RECT-69 AT ROW 6 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75.72 BY 10.17
         FONT 4.

DEFINE FRAME f-pg-sel
     bt-select-estabelec AT ROW 2.75 COL 65
     c-lista-cod-estab AT ROW 2.79 COL 24 NO-LABEL
     bt-select-espec-docto AT ROW 3.75 COL 65
     c-lista-cod-esp AT ROW 3.79 COL 24 NO-LABEL
     bt-select-representante AT ROW 4.75 COL 65
     c-lista-cdn-repres AT ROW 4.79 COL 24 NO-LABEL
     i-ini-cliente AT ROW 5.79 COL 22 COLON-ALIGNED
     i-fim-cliente AT ROW 5.79 COL 51.86 COLON-ALIGNED NO-LABEL
     i-ini-perc-comis AT ROW 6.79 COL 22 COLON-ALIGNED
     i-fim-perc-comis AT ROW 6.79 COL 51.86 COLON-ALIGNED NO-LABEL
     dt-ini-periodo AT ROW 7.79 COL 22 COLON-ALIGNED
     dt-fim-periodo AT ROW 7.79 COL 51.86 COLON-ALIGNED NO-LABEL
     c-ini-referencia AT ROW 8.79 COL 22 COLON-ALIGNED
     c-fim-referencia AT ROW 8.79 COL 51.86 COLON-ALIGNED NO-LABEL
     "EspÇcies:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 3.96 COL 17
     "Representantes:" VIEW-AS TEXT
          SIZE 11.57 BY .54 AT ROW 4.92 COL 12.43
     "Estabelecimento:" VIEW-AS TEXT
          SIZE 11.57 BY .54 AT ROW 3 COL 12
     IMAGE-10 AT ROW 6.79 COL 51
     IMAGE-11 AT ROW 7.79 COL 38.86
     IMAGE-12 AT ROW 7.79 COL 51
     IMAGE-13 AT ROW 8.79 COL 38.86
     IMAGE-14 AT ROW 8.79 COL 51
     IMAGE-5 AT ROW 5.79 COL 38.86
     IMAGE-6 AT ROW 5.79 COL 51
     IMAGE-9 AT ROW 6.79 COL 38.86
     RECT-63 AT ROW 2 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 4.

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
     l-imp-param AT ROW 8 COL 4
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-50 AT ROW 7.5 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Relat¢rio de Comiss‰es - DCO005"
         HEIGHT             = 15.08
         WIDTH              = 81
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat504.i}
{utp/ut-glob504.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR RADIO-SET rs-data IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-paga-carteira IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-paga-vinculada IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
ASSIGN 
       c-lista-cdn-repres:READ-ONLY IN FRAME f-pg-sel        = TRUE.

ASSIGN 
       c-lista-cod-esp:READ-ONLY IN FRAME f-pg-sel        = TRUE.

ASSIGN 
       c-lista-cod-estab:READ-ONLY IN FRAME f-pg-sel        = TRUE.

/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

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
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Relat¢rio de Comiss‰es - DCO005 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Relat¢rio de Comiss‰es - DCO005 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-select-espec-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-select-espec-docto w-relat
ON CHOOSE OF bt-select-espec-docto IN FRAME f-pg-sel /* EspÇcies */
DO:
    ASSIGN  INPUT FRAME f-pg-sel c-lista-cod-esp.

    RUN dop/dcr004a.w (INPUT-OUTPUT c-lista-cod-esp).

    DISPLAY c-lista-cod-esp WITH FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-select-estabelec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-select-estabelec w-relat
ON CHOOSE OF bt-select-estabelec IN FRAME f-pg-sel /* Estabelecimentos */
DO:
    RUN prgint/utb/utb071zb.
    
    ASSIGN  c-lista-cod-estab = v_des_estab_select.
    DISPLAY c-lista-cod-estab WITH FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-select-representante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-select-representante w-relat
ON CHOOSE OF bt-select-representante IN FRAME f-pg-sel /* Representantes */
DO:
    RUN dop/dco003a.w (INPUT-OUTPUT c-lista-cdn-repres).
    DISPLAY c-lista-cdn-repres WITH FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-fim-referencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fim-referencia w-relat
ON F5 OF c-fim-referencia IN FRAME f-pg-sel
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fim-referencia w-relat
ON MOUSE-SELECT-DBLCLICK OF c-fim-referencia IN FRAME f-pg-sel
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ini-referencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ini-referencia w-relat
ON F5 OF c-ini-referencia IN FRAME f-pg-sel /* Referància */
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ini-referencia w-relat
ON MOUSE-SELECT-DBLCLICK OF c-ini-referencia IN FRAME f-pg-sel /* Referància */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-fim-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-fim-periodo w-relat
ON F5 OF dt-fim-periodo IN FRAME f-pg-sel
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-fim-periodo w-relat
ON MOUSE-SELECT-DBLCLICK OF dt-fim-periodo IN FRAME f-pg-sel
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-ini-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-ini-periodo w-relat
ON MOUSE-SELECT-DBLCLICK OF dt-ini-periodo IN FRAME f-pg-sel /* Comiss∆o do Per°odo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fim-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fim-cliente w-relat
ON F5 OF i-fim-cliente IN FRAME f-pg-sel
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fim-cliente w-relat
ON MOUSE-SELECT-DBLCLICK OF i-fim-cliente IN FRAME f-pg-sel
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fim-perc-comis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fim-perc-comis w-relat
ON F5 OF i-fim-perc-comis IN FRAME f-pg-sel
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fim-perc-comis w-relat
ON MOUSE-SELECT-DBLCLICK OF i-fim-perc-comis IN FRAME f-pg-sel
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ini-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ini-cliente w-relat
ON F5 OF i-ini-cliente IN FRAME f-pg-sel /* Cliente */
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ini-cliente w-relat
ON MOUSE-SELECT-DBLCLICK OF i-ini-cliente IN FRAME f-pg-sel /* Cliente */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ini-perc-comis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ini-perc-comis w-relat
ON F5 OF i-ini-perc-comis IN FRAME f-pg-sel /* % Comiss∆o da Emiss∆o */
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ini-perc-comis w-relat
ON MOUSE-SELECT-DBLCLICK OF i-ini-perc-comis IN FRAME f-pg-sel /* % Comiss∆o da Emiss∆o */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
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
        when "4" then do:
            assign c-arquivo:sensitive     = YES
                   bt-arquivo:visible      = YES
                   bt-config-impr:visible  = no.
        end.

    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME tg-gera-movto-comis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-gera-movto-comis w-relat
ON VALUE-CHANGED OF tg-gera-movto-comis IN FRAME f-pg-par /* Gera Movimento de Comiss‰es */
DO:
    IF INPUT FRAME f-pg-par tg-gera-movto-comis = 'yes' THEN DO:
       ASSIGN tg-imp-resumo:SCREEN-VALUE   = 'YES'.
       DISABLE tg-imp-resumo WITH FRAME f-pg-par.
    END.
    ELSE DO:
       ENABLE tg-imp-resumo WITH FRAME f-pg-par.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-rescisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-rescisao w-relat
ON VALUE-CHANGED OF tg-rescisao IN FRAME f-pg-par /* Rescis∆o de Representante */
DO:
   IF INPUT FRAME f-pg-par tg-rescisao = 'yes' THEN DO:
      ASSIGN tg-paga-vinculada:SCREEN-VALUE   = 'YES'
             tg-paga-carteira:SCREEN-VALUE    = 'no'
             tg-gera-movto-comis:SCREEN-VALUE = 'yes'.
      ENABLE tg-paga-vinculada
             tg-paga-carteira WITH FRAME f-pg-par.
      DISABLE tg-gera-movto-comis WITH FRAME f-pg-par.
   END.
   ELSE DO:
      ASSIGN tg-paga-vinculada:SCREEN-VALUE = 'no'
             tg-paga-carteira:SCREEN-VALUE  = 'no'.
      DISABLE tg-paga-vinculada
              tg-paga-carteira WITH FRAME f-pg-par.
      ENABLE tg-gera-movto-comis WITH FRAME f-pg-par.
   END.
   APPLY 'value-changed' to tg-gera-movto-comis IN FRAME f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000504.i "{&programa}" "5.04.01.001"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini504.i}
ASSIGN  c-arq-old = SESSION:TEMP-DIRECTORY + "{&programa}.tmp".

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl504.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
  
    {include/i-rpmbl504.i}

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = v_cod_usuar_corren  NO-ERROR. 
    RUN pi-recupera-param.

    ASSIGN  rs-data:SCREEN-VALUE IN FRAME f-pg-par             = 'CrÇdito'
            tg-gera-movto-comis:SCREEN-VALUE IN FRAME f-pg-par = 'no'
            tg-rescisao:SCREEN-VALUE IN FRAME f-pg-par         = 'no'
            tg-paga-vinculada:SCREEN-VALUE IN FRAME f-pg-par   = 'no'
            tg-paga-carteira:SCREEN-VALUE IN FRAME f-pg-par    = 'no'.

    APPLY 'value-changed' TO tg-rescisao IN FRAME f-pg-par.
    APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.
    
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-cla im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-lista-cod-estab c-lista-cod-esp c-lista-cdn-repres i-ini-cliente 
          i-fim-cliente i-ini-perc-comis i-fim-perc-comis dt-ini-periodo 
          dt-fim-periodo c-ini-referencia c-fim-referencia 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-5 IMAGE-6 IMAGE-9 
         RECT-63 bt-select-estabelec c-lista-cod-estab bt-select-espec-docto 
         c-lista-cod-esp bt-select-representante c-lista-cdn-repres 
         i-ini-cliente i-fim-cliente i-ini-perc-comis i-fim-perc-comis 
         dt-ini-periodo dt-fim-periodo c-ini-referencia c-fim-referencia 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-classif 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE RECT-65 rs-classif 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY rs-destino c-arquivo rs-execucao l-imp-param text-destino text-modo 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-50 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao l-imp-param 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY tg-gera-movto-comis tg-imp-comissoes tg-imp-resumo rs-data tg-rescisao 
          tg-paga-vinculada tg-paga-carteira 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-68 RECT-69 tg-gera-movto-comis tg-imp-comissoes tg-imp-resumo 
         tg-rescisao 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-faltou AS LOG NO-UNDO.

    /* valida conflitos com os processos agendados no servidor (RPW) */
    {include\i-vld-param504.i}
    
    DO  ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {include/i-rpexa504.i}
        
        /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas 
           devem apresentar uma mensagem de erro cadastrada, posicionar na 
           p†gina com problemas e colocar o focus no campo com problemas */
        
        IF INPUT FRAME f-pg-par tg-rescisao = YES THEN DO:
           IF  INPUT FRAME f-pg-sel c-lista-cdn-repres MATCHES "*,*" THEN DO:
               RUN MESSAGE.p ("Somente um representante dever† ser selecionado.",
                              "Na rescis∆o de representante, o relat¢rio de comiss‰es deve ser emitido individualmente.").
               RETURN ERROR.
           END.
        END.
            
        IF INPUT FRAME f-pg-par tg-gera-movto-comis = YES THEN DO: /* Gera movimento de comiss‰es */
           IF month(INPUT FRAME f-pg-sel dt-ini-periodo) = MONTH(INPUT FRAME f-pg-sel dt-ini-periodo - 1) THEN DO:
              RUN MESSAGE.p ("Data inicial do Per°odo deve ser o 1o. dia do màs",
                             "Quando o campo Gera Movimento de Comiss∆o estiver marcado, o 1o. dia da seleá∆o dever† ser o 1o. dia do per°odo.").
              RETURN ERROR.
           END.

           IF INPUT FRAME f-pg-par tg-rescisao = NO                                                        AND
              month(INPUT FRAME f-pg-sel dt-fim-periodo) = MONTH(INPUT FRAME f-pg-sel dt-fim-periodo + 1) THEN DO:
              RUN MESSAGE.p ("Data final do Per°odo deve ser o £ltimo dia do màs",
                             "Quando o campo Gera Movimento de Comiss∆o estiver marcado, o £ltimo dia da seleá∆o dever† ser o £ltimo dia do per°odo.").
              RETURN ERROR.
           END.

           IF INPUT FRAME f-pg-par tg-imp-resumo = NO THEN DO:
              RUN MESSAGE.p ("Resumo do representante deve ser marcado",
                             "Quando o campo Gera Movimento de Comiss∆o estiver marcado, o campo Resumo do representante deve ser marcado").
              RETURN ERROR.
           END.

           IF INPUT FRAME f-pg-par rs-data <> "CrÇdito" THEN DO:
              RUN MESSAGE.p ("Data de Pesquisa dever† ser data de CrÇdito",
                             "Quando o campo Gera Movimento de Comiss∆o estiver marcado, o campo Data de Pesquisa dever† ser Data de CrÇdito").
              RETURN ERROR.
           END.

           

           ASSIGN l-faltou = NO.
           FOR EACH emsuni.representante NO-LOCK,
               EACH emsfin.repres_financ OF emsuni.representante NO-LOCK:
                IF LOOKUP(STRING(representante.cdn_repres),INPUT FRAME f-pg-sel c-lista-cdn-repres) = 0 THEN ASSIGN l-faltou = NO.
           END.
           IF l-faltou THEN DO:
               RUN message2.p ("Confirma Geraá∆o PARCIAL do Movimento de Comiss∆o?",
                               "N«O foram selecionados todos os representantes da base! Se j† houver sido gerado movimento de comiss∆o anteriormente ele ser† eliminado. Esteja certo de que n∆o tenha sido feita integraá∆o com Contas a Pagar."). 
               IF RETURN-VALUE = "no" THEN
                  RETURN ERROR.
           END.
           ELSE DO:
               RUN message2.p ("Confirma Geraá∆o do Movimento de Comiss∆o?",
                               "Se j† houver sido gerado movimento de comiss∆o anteriormente ele ser† eliminado. Esteja certo de que n∆o tenha sido feita integraá∆o com Contas a Pagar."). 
               IF RETURN-VALUE = "no" THEN
                  RETURN ERROR.
           END.


        END.

        /* Aqui s∆o gravados os campos da tabela que ser† grava e lida dentro 
           do pograma RP.P */
        RUN pi-salva-param.

        IF  rs-execucao:SCREEN-VALUE IN FRAME f-pg-imp = "2" THEN DO: /*execuá∆o em batch*/
            RUN prgtec/btb/btb911za.p (INPUT  "{&programa}rp",
                                       INPUT  "1.00.000",
                                       INPUT  0,
                                       INPUT  RECID(dwb_set_list_param),
                                       OUTPUT v_num_ped_exec_rpw).
          
            IF  v_num_ped_exec_rpw <> 0 THEN DO:
                RUN pi-message  (INPUT "show",
                                 INPUT 3556,
                                 INPUT SUBSTITUTE ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       v_num_ped_exec_rpw)).
          
                FIND CURRENT dwb_set_list_param NO-LOCK NO-ERROR.
            END.
        END.
        ELSE DO: /*execuá∆o on-line*/
            IF  SESSION:SET-WAIT-STATE("general") THEN.
                 RUN VALUE("dop/dco005rp.p").
            IF  SESSION:SET-WAIT-STATE("") THEN.
            
            /*abre o editor quando a saida for terminal*/
            {include/i-rptrm504.i}
        END.
    END. /* do transaction */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param w-relat 
PROCEDURE pi-recupera-param :
/*------------------------------------------------------------------------------
  Purpose:     Recuperar os parÉmetros informados pelo usu†rio corrente em 
               sua £ltima execuá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST dwb_set_list_param NO-LOCK
         WHERE dwb_set_list_param.cod_dwb_program = "{&programa}"
           AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
         
    IF  NOT AVAIL dwb_set_list_param THEN RETURN 'nok'.
    
    {include/i-rprcpr504.i}

    ASSIGN  /*pagina de impress∆o*/
            rs-destino              = LOOKUP(dwb_set_list_param.cod_dwb_output,"Impressora,Arquivo,Terminal,Planilha")
            l-imp-param             = dwb_set_list_param.log_dwb_print_parameters
            c-arquivo               = dwb_set_list_param.cod_dwb_file
            c-impressora            = dwb_set_list_param.nom_dwb_printer
            c-layout                = dwb_set_list_param.cod_dwb_print_layout.
    IF  rs-destino = 1 
        THEN ASSIGN  c-imp-old  = c-impressora + ":" + c-layout.
        ELSE ASSIGN  c-arq-old  = c-arquivo.
    
    /*pagina de digitaá∆o*/
    FIND FIRST dwb_set_list_param_aux EXCLUSIVE-LOCK
         WHERE dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
           AND dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user NO-ERROR.
    IF  AVAIL dwb_set_list_param_aux THEN 
        DO  i-cont = 1 TO NUM-ENTRIES(dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)):
            CREATE  tt-digita.
            ASSIGN  tt-digita.ordem   = INT(ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)))
                    i-cont            = i-cont + 1
                    tt-digita.exemplo = ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)).
        END.

    DISPLAY /*pagina de impress∆o*/
            rs-destino      
            l-imp-param     
            c-arquivo       WITH FRAME f-pg-imp.
    
    /*pagina de digitaá∆o*/
    {&OPEN-QUERY-br-digita}
    
    APPLY "value-changed"       TO rs-destino   IN FRAME f-pg-imp.
    APPLY "mouse-select-click"  TO im-pg-sel    IN FRAME f-relat.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-param w-relat 
PROCEDURE pi-salva-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {include/i-rpsvpr504.i}
    
    ASSIGN  /*pagina de impress∆o*/
            INPUT FRAME f-pg-imp    rs-destino  c-arquivo
                                    l-imp-param rs-execucao.
    
    /* verfica controles do EMS 5 e dispara login se necess†rio */
    RUN prgtec/btb/btb906za.p.    
    
    IF  rs-destino = 2 AND rs-execucao = 2 THEN 
        DO  WHILE INDEX(c-arquivo,"~/") <> 0: 
            ASSIGN  c-arquivo = SUBSTRING(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
        END. 
    IF  rs-destino = 3 THEN 
        ASSIGN  c-arquivo = SESSION:TEMP-DIRECTORY + "{&programa}.tmp".

    DO  TRANSACTION:
        FIND FIRST dwb_set_list_param EXCLUSIVE-LOCK
             WHERE dwb_set_list_param.cod_dwb_program = "{&programa}"
               AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
        IF  NOT AVAIL dwb_set_list_param THEN DO:
            CREATE  dwb_set_list_param.
            ASSIGN  dwb_set_list_param.cod_dwb_program = "{&programa}"
                    dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren.
        END.
        
        ASSIGN  dwb_set_list_param.cod_dwb_file             = c-arquivo
                dwb_set_list_param.nom_dwb_printer          = c-impressora
                dwb_set_list_param.cod_dwb_print_layout     = c-layout
                dwb_set_list_param.qtd_dwb_line             = 64
                dwb_set_list_param.log_dwb_print_parameters = l-imp-param
                dwb_set_list_param.cod_dwb_output           = ENTRY(rs-destino,"Impressora,Arquivo,Terminal,Planilha")
                dwb_set_list_param.cod_dwb_parameters       = c-param-campos + CHR(13) + 
                                                                     c-param-tipos  + CHR(13) + 
                                                                     c-param-dados  .
        FIND CURRENT dwb_set_list_param NO-LOCK NO-ERROR.
        
        /*grava a lista da temp-table digita*/
        FIND FIRST dwb_set_list_param_aux EXCLUSIVE-LOCK
             WHERE dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
               AND dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user NO-ERROR.

        FIND FIRST tt-digita NO-LOCK NO-ERROR.
        IF  AVAIL tt-digita THEN DO:
        
            IF  NOT AVAIL dwb_set_list_param_aux THEN DO:
                CREATE  dwb_set_list_param_aux.
                ASSIGN  dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
                        dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user.
            END.
            
            ASSIGN  i-cont = 0.
            FOR EACH tt-digita NO-LOCK:
                ASSIGN  i-cont = i-cont + 1.
                IF  i-cont = 1 
                    THEN ASSIGN  dwb_set_list_param_aux.cod_dwb_parameters = STRING(tt-digita.ordem) + CHR(10) + tt-digita.exemplo.
                    ELSE ASSIGN  dwb_set_list_param_aux.cod_dwb_parameters = dwb_set_list_param_aux.cod_dwb_parameters + chr(10) +
                                                                                    STRING(tt-digita.ordem) + CHR(10) + tt-digita.exemplo.
            END.
        END.
        ELSE /* se n∆o existe tt-digita e existe dwb_set_list_param, apaga */
            IF  AVAIL dwb_set_list_param_aux THEN
                DELETE  dwb_set_list_param_aux.

    END. /*do transaction*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp504.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
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

