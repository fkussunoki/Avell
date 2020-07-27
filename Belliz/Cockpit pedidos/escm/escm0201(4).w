&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escm0201 1.00.00.001}

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

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-ped-venda 
    field ttv-cod-estabel     AS char
    field ttv-dt-implant      AS date
    field ttv-nr-pedcli       AS char
    field ttv-sit-pedido      AS char
    FIELD ttv-cdn-cliente     AS INTEGER
    field ttv-nome-abrev      AS char
    field ttv-razao           AS char
    field ttv-repres          AS INTEGER
    field ttv-nom-repres      AS char
    field ttv-uf              AS char
    field ttv-cidade          AS char
    field ttv-vl-aberto       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field ttv-vl-liq-pedido   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field ttv-vl-tot-ped      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field ttv-limite-credito  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field ttv-vlr-tit-aberto  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    FIELD ttv-email           AS char
    FIELD ttv-telefone        AS char
    field ttv-desc-bloq-cr    as char
    field ttv-desc-desbloq    as char
    field ttv-sit-credito as char
    FIELD ttv-situacao        AS LOGICAL
    field ttv-rowid           as ROWID
    INDEX order_customer
    ttv-cdn-cliente ASCENDING
    ttv-nome-abrev  ASCENDING
    ttv-vl-liq-pedido ASCENDING
    ttv-vl-tot-ped ASCENDING.

DEFINE TEMP-TABLE tt-filtro
    FIELD ttv-abertos          AS LOGICAL
    FIELD ttv-atendido-parcial AS LOGICAL
    FIELD ttv-atendido-total   AS LOGICAL
    field ttv-pendente         as logical
    FIELD ttv-suspenso         AS LOGICAL
    FIELD ttv-cancelado        AS LOGICAL
    FIELD ttv-avaliado         AS LOGICAL
    FIELD ttv-nao-avaliado     AS LOGICAL
    FIELD ttv-aprovado         AS LOGICAL
    FIELD ttv-nao-aprovado     AS LOGICAL
    FIELD ttv-dt-impl-ini      AS DATE
    FIELD ttv-dt-impl-fim      AS date
    FIELD ttv-dt-entrega-ini   AS date
    FIELD ttv-dt-entrega-fim   AS date
    FIELD ttv-pedido-ini       AS char
    FIELD ttv-pedido-fim       AS char
    FIELD ttv-cdn-cliente-ini  AS INTEGER
    FIELD ttv-cdn-cliente-fim  AS INTEGER
    FIELD ttv-cdn-matriz-ini   AS char
    FIELD ttv-cdn-matriz-fim   AS char
    field ttv-estab-ini        as char
    field ttv-estab-fim        as char
    .
DEFINE new GLOBAL shared var gr-ped-venda as rowid no-undo.
DEFINE VARIABLE dtTimeInicial AS DATETIME   NO-UNDO.
DEFINE VARIABLE dtTimeFinal   AS DATETIME   NO-UNDO.
DEFINE new GLOBAL shared var  v_cod_empres_usuar as char no-undo.
DEF VAR i-cont AS INTEGER.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.

DEFINE VARIABLE c-acao AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpg0
&Scoped-define BROWSE-NAME br-pedidos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-venda

/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-venda.ttv-situacao tt-ped-venda.ttv-cdn-cliente tt-ped-venda.ttv-nome-abrev tt-ped-venda.ttv-razao tt-ped-venda.ttv-vl-liq-pedido tt-ped-venda.ttv-vl-tot-ped tt-ped-venda.ttv-limite-credito tt-ped-venda.ttv-vlr-tit-aberto tt-ped-venda.ttv-desc-bloq-cr tt-ped-venda.ttv-dt-implant tt-ped-venda.ttv-cod-estabel tt-ped-venda.ttv-nr-pedcli tt-ped-venda.ttv-sit-credito tt-ped-venda.ttv-sit-pedido tt-ped-venda.ttv-repres tt-ped-venda.ttv-nom-repres tt-ped-venda.ttv-uf tt-ped-venda.ttv-cidade /* tt-ped-venda.ttv-vl-aberto */ tt-ped-venda.ttv-desc-desbloq   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos tt-ped-venda.ttv-situacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-venda USE-INDEX order_customer  NO-LOCK     WHERE tt-ped-venda.ttv-situacao = logical(toggle-1:SCREEN-VALUE IN FRAME fpg0)          INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-pedidos OPEN query {&SELF-NAME} FOR EACH tt-ped-venda USE-INDEX order_customer  NO-LOCK     WHERE tt-ped-venda.ttv-situacao = logical(toggle-1:SCREEN-VALUE IN FRAME fpg0)          INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-venda


/* Definitions for FRAME fpage1                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button BUTTON-4 bt-carrega BUTTON-8 ~
fi-nr-pedcli TOGGLE-1 BUTTON-5 BUTTON-6 f-situacao fi-email-repres ~
fi-vl-tot-abe fi-vl-tot-liq fi-vl-tot-ped 
&Scoped-Define DISPLAYED-OBJECTS fi-tempo-proc fi-nr-pedcli TOGGLE-1 ~
f-pedido f-estab f-situacao fi-email-repres fi-telefone-repres ~
fi-vl-tot-abe fi-vl-tot-liq fi-vl-tot-ped 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

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
       SUB-MENU  mi-programa    LABEL "&Programa"     
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-carrega 
     IMAGE-UP FILE "escm/im-reini.bmp":U
     LABEL "Button 7" 
     SIZE 4.72 BY 1.25 TOOLTIP "Aplicar Filtro".

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "escm/im-param2.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.25
     FONT 1.

DEFINE BUTTON BUTTON-5 
     LABEL "Aprova" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-6 
     LABEL "Rejeita" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMAGE/im-cancel.bmp":U
     LABEL "Button 8" 
     SIZE 4.72 BY 1.25 TOOLTIP "Cancelar Filtro".

DEFINE VARIABLE f-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE f-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 22.43 BY .88 NO-UNDO.

DEFINE VARIABLE f-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email-repres AS CHARACTER FORMAT "X(256)":U 
     LABEL "E-mail Repres" 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli AS CHARACTER FORMAT "X(12)" INITIAL "0" 
     LABEL "Cdn.Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-telefone-repres AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tel Repres" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tempo-proc AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tempo Proc (em seg)" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-tot-abe AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Liq.Abe" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-tot-liq AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Tot.Liq" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-tot-ped AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Tot.Ped" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 138 BY 1.46
     BGCOLOR 7 .

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Visto" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pedidos FOR 
      tt-ped-venda SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos wWindow _FREEFORM
  QUERY br-pedidos DISPLAY
      tt-ped-venda.ttv-situacao       COLUMN-LABEL "Visto"       VIEW-AS TOGGLE-BOX
 tt-ped-venda.ttv-cdn-cliente    LABEL "Cod.Cliente"            FORMAT ">,>>>,>99"
 tt-ped-venda.ttv-nome-abrev     LABEL "Cliente"                FORMAT "x(12)"
tt-ped-venda.ttv-razao          LABEL "Razao Social"           FORMAT "x(80)"
 tt-ped-venda.ttv-vl-liq-pedido  LABEL "Vl. Liq. Pedido"        FORMAT "->,>>>,>>>,>>9.99"
 tt-ped-venda.ttv-vl-tot-ped     LABEL "Vl. Tot. Ped"           FORMAT "->,>>>,>>>,>>9.99"
 tt-ped-venda.ttv-limite-credito LABEL "Limite Credito"         FORMAT "->,>>>,>>>,>>9.99"
 tt-ped-venda.ttv-vlr-tit-aberto LABEL "Vl. Dupl.Aberto"        FORMAT "->,>>>,>>>,>>9.99"
 tt-ped-venda.ttv-desc-bloq-cr   label "Motivo Bloq.Credito"    FORMAT "x(76)"
 tt-ped-venda.ttv-dt-implant     LABEL "Dt.Impl"                FORMAT '99/99/9999'
 tt-ped-venda.ttv-cod-estabel    LABEL "Estab"                  FORMAT "x(5)"
 tt-ped-venda.ttv-nr-pedcli      LABEL "Ped.Cli"                FORMAT "x(12)"
 tt-ped-venda.ttv-sit-credito    label "Sit.Credito"            FORMAT "x(15)"
 tt-ped-venda.ttv-sit-pedido     LABEL "Sit.Pedido"             FORMAT "x(15)"
 tt-ped-venda.ttv-repres         LABEL "Representante"          FORMAT ">>>>>9"
 tt-ped-venda.ttv-nom-repres     LABEL "Nome Repres"            FORMAT "x(80)"
 tt-ped-venda.ttv-uf             LABEL "UF"                     FORMAT "x(2)"
 tt-ped-venda.ttv-cidade         LABEL "Cidade"                 FORMAT "x(50)"

/* tt-ped-venda.ttv-vl-aberto      LABEL "Vlr.Tot.Abe"            FORMAT "->,>>>,>>>,>>9.99" */
 tt-ped-venda.ttv-desc-desbloq   label "Motivo Desbloq.Credito" FORMAT "x(76)"

     ENABLE
     tt-ped-venda.ttv-situacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 137.72 BY 14.17
         FONT 1
         TITLE "Pedido de Venda - Quantidade 0".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpg0
     BUTTON-4 AT ROW 1.17 COL 2.14 WIDGET-ID 2
     bt-carrega AT ROW 2.71 COL 29 WIDGET-ID 96
     BUTTON-8 AT ROW 2.71 COL 34.29 WIDGET-ID 108
     fi-tempo-proc AT ROW 2.83 COL 59 COLON-ALIGNED WIDGET-ID 94
     fi-nr-pedcli AT ROW 2.88 COL 11.43 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" WIDGET-ID 80
     TOGGLE-1 AT ROW 2.88 COL 73.57 WIDGET-ID 110
     BUTTON-5 AT ROW 18.79 COL 1.86 WIDGET-ID 4
     BUTTON-6 AT ROW 18.83 COL 17.86 WIDGET-ID 6
     f-pedido AT ROW 18.92 COL 56.29 COLON-ALIGNED WIDGET-ID 102
     f-estab AT ROW 18.92 COL 79.57 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     f-situacao AT ROW 18.92 COL 104.43 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     fi-email-repres AT ROW 20.08 COL 10.29 COLON-ALIGNED WIDGET-ID 62
     fi-telefone-repres AT ROW 20.08 COL 56.43 COLON-ALIGNED WIDGET-ID 98
     fi-vl-tot-abe AT ROW 20.08 COL 85.29 COLON-ALIGNED WIDGET-ID 66
     fi-vl-tot-liq AT ROW 20.08 COL 104.14 COLON-ALIGNED WIDGET-ID 72
     fi-vl-tot-ped AT ROW 20.08 COL 123.43 COLON-ALIGNED WIDGET-ID 74
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.57 BY 20.08
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage1
     br-pedidos AT ROW 1 COL 1 WIDGET-ID 300
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 4.04
         SIZE 138 BY 14.63
         FONT 1 WIDGET-ID 200.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Aprovacao de Pedidos"
         HEIGHT             = 20.17
         WIDTH              = 138.57
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 138.57
         VIRTUAL-HEIGHT     = 20.17
         VIRTUAL-WIDTH      = 138.57
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fpage1:FRAME = FRAME fpg0:HANDLE.

/* SETTINGS FOR FRAME fpage1
                                                                        */
/* BROWSE-TAB br-pedidos 1 fpage1 */
ASSIGN 
       br-pedidos:COLUMN-RESIZABLE IN FRAME fpage1       = TRUE.

/* SETTINGS FOR FRAME fpg0
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN f-estab IN FRAME fpg0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-pedido IN FRAME fpg0
   NO-ENABLE                                                            */
ASSIGN 
       fi-email-repres:READ-ONLY IN FRAME fpg0        = TRUE.

/* SETTINGS FOR FILL-IN fi-telefone-repres IN FRAME fpg0
   NO-ENABLE                                                            */
ASSIGN 
       fi-telefone-repres:READ-ONLY IN FRAME fpg0        = TRUE.

/* SETTINGS FOR FILL-IN fi-tempo-proc IN FRAME fpg0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN query {&SELF-NAME} FOR EACH tt-ped-venda USE-INDEX order_customer  NO-LOCK
    WHERE tt-ped-venda.ttv-situacao = logical(toggle-1:SCREEN-VALUE IN FRAME fpg0)
         INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE br-pedidos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Aprovacao de Pedidos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Aprovacao de Pedidos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pedidos
&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON MOUSE-SELECT-DBLCLICK OF br-pedidos IN FRAME fpage1 /* Pedido de Venda - Quantidade 0 */
DO:
    ASSIGN gr-ped-venda = ?.

  IF AVAIL tt-ped-venda THEN DO:

      FIND FIRST ped-venda NO-LOCK
           WHERE ped-venda.nome-abrev = tt-ped-venda.ttv-nome-abrev
             AND ped-venda.nr-pedcli  = tt-ped-venda.ttv-nr-pedcli  NO-ERROR.
      IF AVAIL ped-venda THEN DO:
          ASSIGN gr-ped-venda = ROWID(ped-venda).
          ASSIGN wWindow:SENSITIVE = NO.
          RUN pdp/pd1001.w.
          ASSIGN wWindow:SENSITIVE = YES.
      END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON VALUE-CHANGED OF br-pedidos IN FRAME fpage1 /* Pedido de Venda - Quantidade 0 */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
       assign fi-email-repres:SCREEN-VALUE IN FRAME fPg0 = ""
              fi-telefone-repres:SCREEN-VALUE IN FRAME fPg0 = ""
              f-pedido:SCREEN-VALUE IN FRAME fpg0 = ""
              f-estab:SCREEN-VALUE IN FRAME fpg0  = ""
              f-situacao:SCREEN-VALUE IN FRAME fpg0 = ""
              f-pedido:BGCOLOR = 15
              f-estab:BGCOLOR  = 15
              f-situacao:BGCOLOR = 15.
    END.
  ELSE DO:
      ASSIGN fi-email-repres:SCREEN-VALUE IN FRAME fpg0    = tt-ped-venda.ttv-email
             fi-telefone-repres:SCREEN-VALUE IN FRAME fpg0 = tt-ped-venda.ttv-telefone
             f-pedido:SCREEN-VALUE IN FRAME fpg0 = tt-ped-venda.ttv-nr-pedcli    
             f-estab:SCREEN-VALUE IN FRAME fpg0  = tt-ped-venda.ttv-cod-estabel
             f-situacao:SCREEN-VALUE IN FRAME fpg0 = tt-ped-venda.ttv-sit-credito.


      IF f-situacao:SCREEN-VALUE IN FRAME fpg0 = "Nao avaliado" THEN
          ASSIGN f-situacao:BGCOLOR = 19.


      IF f-situacao:SCREEN-VALUE IN FRAME fpg0 = "Avaliado" THEN
          ASSIGN f-situacao:BGCOLOR = 10.

      IF f-situacao:SCREEN-VALUE IN FRAME fpg0 = "Aprovado" THEN
          ASSIGN f-situacao:BGCOLOR = 10.

      IF f-situacao:SCREEN-VALUE IN FRAME fpg0 = "Nao Aprovado" THEN
          ASSIGN f-situacao:BGCOLOR = 04.
          ASSIGN f-situacao:FGCOLOR = 15.

      IF f-situacao:SCREEN-VALUE IN FRAME fpg0 = "Pendente Informacao" THEN
          ASSIGN f-situacao:BGCOLOR = 19.



  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpg0
&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega wWindow
ON CHOOSE OF bt-carrega IN FRAME fpg0 /* Button 7 */
DO:
    ASSIGN INPUT FRAME fPg0 fi-nr-pedcli.

  RUN pi-carrega-tabela.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 wWindow
ON CHOOSE OF BUTTON-4 IN FRAME fpg0 /* Button 4 */
DO:


    ASSIGN wWindow:SENSITIVE = NO.

      run escm/escm0201a.w (INPUT-OUTPUT TABLE tt-filtro, OUTPUT c-acao). 

    ASSIGN wWindow:SENSITIVE = YES.

    IF c-acao = "atualizar" THEN DO:
        /*ASSIGN i-linha-browse = 0.*/
        RUN pi-carrega-tabela.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWindow
ON CHOOSE OF BUTTON-5 IN FRAME fpg0 /* Aprova */
DO:
    def var c-motivo-aprov as char no-undo.

    IF NOT AVAIL tt-ped-venda THEN DO:
      MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  ELSE DO:

      do i-cont = 1 to br-pedidos:NUM-SELECTED-ROWS IN FRAME fpage1:

          if  br-pedidos:fetch-selected-row (i-cont) then do:

      assign wWindow:sensitive = no.

      run escm/escm0201b.p(output c-motivo-aprov).

      RUN escm/esapi0201b.p(input tt-ped-venda.ttv-rowid,
                         input v_cod_usuar_corren,
                         input today,
                         input 'Aprovacao Automatica',
                         input c-motivo-aprov,
                         input yes ).


       end.
      END.
      assign wWindow:sensitive = yes.
      RUN pi-carrega-tabela.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 wWindow
ON CHOOSE OF BUTTON-6 IN FRAME fpg0 /* Rejeita */
DO:
    def var c-motivo-reprov as char no-undo.

    IF NOT AVAIL tt-ped-venda THEN DO:
      MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  ELSE DO:

      do i-cont = 1 to br-pedidos:NUM-SELECTED-ROWS IN FRAME fpage1:

          if  br-pedidos:fetch-selected-row (i-cont) then do:

      assign wWindow:sensitive = no.

      run escm/escm0201b.p(output c-motivo-reprov).

      RUN escm/esapi0201c.p(input tt-ped-venda.ttv-rowid,
                         input v_cod_usuar_corren,
                         input today,
                         input 'Rejeicao Automatica',
                         input c-motivo-reprov,
                         input yes ).

          END.
      END.

      assign wWindow:sensitive = yes.
      RUN pi-carrega-tabela.

   end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 wWindow
ON CHOOSE OF BUTTON-8 IN FRAME fpg0 /* Button 8 */
DO:
    ASSIGN fi-nr-pedcli:SCREEN-VALUE IN FRAME fpg0 = "".
    ASSIGN INPUT FRAME fPg0 fi-nr-pedcli.
      RUN pi-carrega-tabela.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-pedcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedcli wWindow
ON F5 OF fi-nr-pedcli IN FRAME fpg0 /* Cdn.Cliente */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=fi-nr-pedcli
                       &campozoom=cod-emitente}.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedcli wWindow
ON LEAVE OF fi-nr-pedcli IN FRAME fpg0 /* Cdn.Cliente */
DO:
    
    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = int(INPUT FRAME fpg0 fi-nr-pedcli) NO-ERROR.

    IF AVAIL emitente THEN DO:
        
        ASSIGN fi-nr-pedcli:SCREEN-VALUE IN FRAME fpg0 = emitente.nome-abrev.
    END.

    ELSE do: 
        MESSAGE "Codigo nao encontrado" VIEW-AS ALERT-BOX.
        RETURN.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedcli wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-nr-pedcli IN FRAME fpg0 /* Cdn.Cliente */
DO:
  APPLY 'f5' TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedcli wWindow
ON RETURN OF fi-nr-pedcli IN FRAME fpg0 /* Cdn.Cliente */
DO:
    APPLY "CHOOSE" TO bt-carrega IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas wWindow
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo wWindow
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir wWindow
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa wWindow
ON MENU-DROP OF MENU mi-programa /* Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair wWindow
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre wWindow
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 wWindow
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME fpg0 /* Visto */
DO:
  
    {&OPEN-QUERY-br-pedidos}
    
    APPLY "value-changed" TO BROWSE br-pedidos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWindow  _ADM-CREATE-OBJECTS
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
             INPUT  FRAME fpg0:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 122.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             BUTTON-4:HANDLE IN FRAME fpg0 , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available wWindow  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  DISPLAY fi-tempo-proc fi-nr-pedcli TOGGLE-1 f-pedido f-estab f-situacao 
          fi-email-repres fi-telefone-repres fi-vl-tot-abe fi-vl-tot-liq 
          fi-vl-tot-ped 
      WITH FRAME fpg0 IN WINDOW wWindow.
  ENABLE rt-button BUTTON-4 bt-carrega BUTTON-8 fi-nr-pedcli TOGGLE-1 BUTTON-5 
         BUTTON-6 f-situacao fi-email-repres fi-vl-tot-abe fi-vl-tot-liq 
         fi-vl-tot-ped 
      WITH FRAME fpg0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fpg0}
  ENABLE br-pedidos 
      WITH FRAME fpage1 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fpage1}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy wWindow 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit wWindow 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize wWindow 
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

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-tela wWindow 
PROCEDURE pi-atualiza-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-br-pedidos}
    
    APPLY "value-changed" TO BROWSE br-pedidos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-totalizadores wWindow 
PROCEDURE pi-atualiza-totalizadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iqt-pedidos     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-abe   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-liq   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-ped   AS DECIMAL     NO-UNDO.

    ASSIGN iqt-pedidos    = 0 
           de-vl-tot-abe  = 0
           de-vl-tot-liq  = 0
           de-vl-tot-ped  = 0.

    FOR EACH tt-ped-venda:
        ASSIGN de-vl-tot-abe = de-vl-tot-abe + tt-ped-venda.ttv-vl-aberto     
               de-vl-tot-liq = de-vl-tot-liq + tt-ped-venda.ttv-vl-liq-pedido 
               de-vl-tot-ped = de-vl-tot-ped + tt-ped-venda.ttv-vl-tot-ped    
               iqt-pedidos   = iqt-pedidos + 1.
    END.

    DISP de-vl-tot-abe @ fi-vl-tot-abe 
         de-vl-tot-liq @ fi-vl-tot-liq
         de-vl-tot-ped @ fi-vl-tot-ped WITH FRAME fPg0.

    IF iqt-pedidos > 0 THEN
        ASSIGN br-pedidos:TITLE IN FRAME fPage1 = "Pedidos de Venda - Quantidade: " + TRIM(STRING(iqt-pedidos,">>>,>>>,>>>,>>9")).
    ELSE
        ASSIGN br-pedidos:TITLE IN FRAME fPage1 = "Pedidos de Venda - Quantidade: 0".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tabela wWindow 
PROCEDURE pi-carrega-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-acomp         AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-unid-negoc AS LOGICAL     NO-UNDO.
    
    ASSIGN dtTimeInicial = NOW.
    EMPTY TEMP-TABLE tt-ped-venda.

    FIND FIRST tt-filtro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-filtro THEN DO:
        MESSAGE "Filtros nÆo foram selecionados!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Carregando Pedidos...").
    RUN pi-desabilita-cancela IN h-acomp.

    IF fi-nr-pedcli <> "" AND fi-nr-pedcli <> "0"  THEN DO:
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.nome-abrev = fi-nr-pedcli
           AND   ped-venda.cod-estabel     >= tt-filtro.ttv-estab-ini   
           AND   ped-venda.cod-estabel     <= tt-filtro.ttv-estab-fim 
           AND ped-venda.nr-pedcli       >= tt-filtro.ttv-pedido-ini                                                                                                                                            
           AND ped-venda.nr-pedcli       <= tt-filtro.ttv-pedido-fim                                                                                                                                            
           AND ped-venda.dt-implant      >= tt-filtro.ttv-dt-impl-ini                                                                                                                                           
           AND ped-venda.dt-implant      <= tt-filtro.ttv-dt-impl-fim                                                                                                                                           
           AND ped-venda.dt-entrega      >= tt-filtro.ttv-dt-entrega-ini                                                                                                                                        
           AND ped-venda.dt-entrega      <= tt-filtro.ttv-dt-entrega-fim                                                                                                                                        
           AND ((ped-venda.cod-sit-ped = 1 AND tt-filtro.ttv-abertos     = YES) OR                                                                                                                              
                (ped-venda.cod-sit-ped = 2 AND tt-filtro.ttv-atendido-parcial = YES) OR                                                                                                                         
                (ped-venda.cod-sit-ped = 3 AND tt-filtro.ttv-atendido-total   = YES AND ped-venda.dt-cancel = ?) OR /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */ 
                (ped-venda.cod-sit-ped = 4 AND tt-filtro.ttv-pendente   = YES) OR                                                                                                                               
                (ped-venda.cod-sit-ped = 5 AND tt-filtro.ttv-suspenso   = YES) OR                                                                                                                               
                (ped-venda.cod-sit-ped = 6 AND tt-filtro.ttv-cancelado  = YES) OR                                                                                                                               
                (ped-venda.dt-cancel <> ?  AND tt-filtro.ttv-cancelado  = YES)) /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */                                     
           AND ((ped-venda.cod-sit-aval = 1 AND tt-filtro.ttv-nao-avaliado = YES) OR                                                                                                                            
                (ped-venda.cod-sit-aval = 2 AND tt-filtro.ttv-avaliado     = YES) OR                                                                                                                            
                (ped-venda.cod-sit-aval = 3 AND tt-filtro.ttv-aprovado     = YES) OR                                                                                                                            
                (ped-venda.cod-sit-aval = 4 AND tt-filtro.ttv-nao-aprovado = YES)),                                                                                                                             


            FIRST repres FIELDS(cod-rep nome e-mail telefone[1] telefone[2]) NO-LOCK
            WHERE repres.nome-abrev = ped-venda.no-ab-reppri,
            FIRST emitente FIELDS(nome-emit estado cidade nome-matriz cod-emitente lim-credito lim-adicional) NO-LOCK
            WHERE emitente.cod-emitente = ped-venda.cod-emitente,
            FIRST natur-oper FIELDS(emite-duplic) NO-LOCK
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao:

            RUN pi-acompanhar IN h-acomp (INPUT "Nr Pedido: " + STRING(ped-venda.nr-pedido) + " - Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).
            
            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
            RUN pi-criar-tabela.
        END.
    END.                                                                                                                   
    ELSE DO:                                                                                                               
        FOR EACH ped-venda no-lock                                                                                         
           WHERE ped-venda.cod-estabel     >= tt-filtro.ttv-estab-ini                                                      
             AND ped-venda.cod-estabel     <= tt-filtro.ttv-estab-fim                                                     
             AND ped-venda.cod-emitente    >= tt-filtro.ttv-cdn-cliente-ini                                               
             AND ped-venda.cod-emitente    <= tt-filtro.ttv-cdn-cliente-fim                                               
             AND ped-venda.nr-pedcli       >= tt-filtro.ttv-pedido-ini                                                    
             AND ped-venda.nr-pedcli       <= tt-filtro.ttv-pedido-fim                                                    
             AND ped-venda.dt-implant      >= tt-filtro.ttv-dt-impl-ini                                                   
             AND ped-venda.dt-implant      <= tt-filtro.ttv-dt-impl-fim                                                   
             AND ped-venda.dt-entrega      >= tt-filtro.ttv-dt-entrega-ini                                                
             AND ped-venda.dt-entrega      <= tt-filtro.ttv-dt-entrega-fim                                                
             AND ((ped-venda.cod-sit-ped = 1 AND tt-filtro.ttv-abertos     = YES) OR                                      
                  (ped-venda.cod-sit-ped = 2 AND tt-filtro.ttv-atendido-parcial = YES) OR                                 
                  (ped-venda.cod-sit-ped = 3 AND tt-filtro.ttv-atendido-total   = YES AND ped-venda.dt-cancel = ?) OR /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */
                  (ped-venda.cod-sit-ped = 4 AND tt-filtro.ttv-pendente   = YES) OR
                  (ped-venda.cod-sit-ped = 5 AND tt-filtro.ttv-suspenso   = YES) OR
                  (ped-venda.cod-sit-ped = 6 AND tt-filtro.ttv-cancelado  = YES) OR
                  (ped-venda.dt-cancel <> ?  AND tt-filtro.ttv-cancelado  = YES)) /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */
             AND ((ped-venda.cod-sit-aval = 1 AND tt-filtro.ttv-nao-avaliado = YES) OR
                  (ped-venda.cod-sit-aval = 2 AND tt-filtro.ttv-avaliado     = YES) OR
                  (ped-venda.cod-sit-aval = 3 AND tt-filtro.ttv-aprovado     = YES) OR 
                  (ped-venda.cod-sit-aval = 4 AND tt-filtro.ttv-nao-aprovado = YES)),
           FIRST natur-oper FIELDS(emite-duplic) OF ped-venda NO-LOCK,
           FIRST repres FIELDS(cod-rep nome e-mail telefone[1] telefone[2]) NO-LOCK
           WHERE repres.nome-abrev = ped-venda.no-ab-reppri,
           FIRST emitente FIELDS(nome-emit estado cidade  nome-matriz cod-emitente lim-credito lim-adicional) NO-LOCK
           WHERE emitente.cod-emitente = ped-venda.cod-emitente
             AND emitente.nome-matriz  >= tt-filtro.ttv-cdn-matriz-ini
             AND emitente.nome-matriz  <= tt-filtro.ttv-cdn-matriz-fim
            BY ped-venda.dt-implant:
            
            RUN pi-acompanhar IN h-acomp (INPUT "Nr Pedido: " + STRING(ped-venda.nr-pedido) + " - Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).


            run pi-criar-tabela.
        end.
    end.


    RUN pi-finalizar IN h-acomp.

    RUN pi-atualiza-totalizadores.
    RUN pi-atualiza-tela.
    ASSIGN dtTimeFinal = NOW
       fi-tempo-proc:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(INTERVAL(dtTimeFinal, dtTimeInicial , "seconds")).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-tabela wWindow 
PROCEDURE pi-criar-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
create tt-ped-venda.
assign tt-ped-venda.ttv-cod-estabel       = ped-venda.cod-estabel
       tt-ped-venda.ttv-dt-implant        = ped-venda.dt-implant
       tt-ped-venda.ttv-nr-pedcli         = ped-venda.nr-pedcli
       tt-ped-venda.ttv-nome-abrev        = ped-venda.nome-abrev
       tt-ped-venda.ttv-razao             = emitente.nome-emit
       tt-ped-venda.ttv-repres            = repres.cod-rep
       tt-ped-venda.ttv-desc-bloq-cr      = ped-venda.desc-bloq-cr
       tt-ped-venda.ttv-desc-desbloq      = ped-venda.desc-forc-cr
       tt-ped-venda.ttv-nom-repres        = repres.nome
       tt-ped-venda.ttv-uf                = emitente.estado
       tt-ped-venda.ttv-cidade            = emitente.cidade
       tt-ped-venda.ttv-limite-credito    = emitente.lim-credito
       tt-ped-venda.ttv-cdn-cliente       = ped-venda.cod-emitente
       tt-ped-venda.ttv-email             = repres.e-mail
       tt-ped-venda.ttv-rowid             = rowid(ped-venda)
       tt-ped-venda.ttv-telefone          = repres.telefone[1] + IF repres.telefone[2] <> "" THEN
                                                                           (" / " + repres.telefone[2])
                                                                       ELSE
                                                                           "".
      case ped-venda.cod-sit-ped:
          when 1 then
              assign  tt-ped-venda.ttv-sit-pedido = "Aberto".
          when 2 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Atendido Parcial".
          when 3 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Atendido Total".
          when 4 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Pendente".
          when 5 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Suspenso".
          when 6 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Cancelado".
          when 7 then
              assign  tt-ped-venda.ttv-sit-pedido  = "Faturado Balcao".

      end case.

      case ped-venda.cod-sit-aval:
          when 1 then
          assign tt-ped-venda.ttv-sit-credito = "Nao avaliado".
          when 2 then
          assign tt-ped-venda.ttv-sit-credito = "Avaliado".
          when 3 then
          assign tt-ped-venda.ttv-sit-credito = "Aprovado".
          when 4 then
          assign tt-ped-venda.ttv-sit-credito = "Nao aprovado".
          when 5 then
          assign tt-ped-venda.ttv-sit-credito = "Pendente Informacao".


      end case.

assign tt-ped-venda.ttv-vlr-tit-aberto    = 0
       tt-ped-venda.ttv-vl-aberto         = 0
       tt-ped-venda.ttv-vl-liq-pedido     = 0
       tt-ped-venda.ttv-vl-tot-ped        = 0.


for each ped-item of ped-venda no-lock:

    if ped-item.cod-sit-item < 3 then
        assign tt-ped-venda.ttv-vl-aberto = tt-ped-venda.ttv-vl-aberto + ped-item.vl-merc-abe
               tt-ped-venda.ttv-vl-liq-pedido  = tt-ped-venda.ttv-vl-liq-pedido  + ped-item.vl-liq-it
               tt-ped-venda.ttv-vl-tot-ped     = tt-ped-venda.ttv-vl-tot-ped  + ped-item.vl-tot-it.

    end.


    for each tit_acr no-lock where tit_acr.cod_empresa = v_cod_empres_usuar
                             and   tit_acr.cdn_cliente = emitente.cod-emitente
                             and   tit_acr.val_sdo_tit_acr > 0 
                             and   tit_acr.log_tit_acr_estordo = no:

        if tit_acr.ind_tip_espec_docto = "Antecipa‡Æo" or
            tit_acr.ind_tip_espec_docto = "Nota de cr‚dito" then

        assign tt-ped-venda.ttv-vlr-tit-aberto = tt-ped-venda.ttv-vlr-tit-aberto - tit_acr.val_sdo_tit_acr.
        else
            assign tt-ped-venda.ttv-vlr-tit-aberto = tt-ped-venda.ttv-vlr-tit-aberto + tit_acr.val_sdo_tit_acr.
        
    end.


   
   
   


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records wWindow  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ped-venda"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed wWindow 
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

