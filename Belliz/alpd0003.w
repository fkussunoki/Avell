&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ALPD0003 2.11.00.003}

{include/i-alcast-license.i ALPD0003} /*licenáa programa espec°ficos*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ALPD0003
&GLOBAL-DEFINE Version        2.11.00.003

&GLOBAL-DEFINE WindowType     Window

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btFechar btHelp2 ~
                              bt-filtro-geral bt-grafico bt-legenda bt-historico bt-carrega ~
                              fi-nr-pedcli bt-aprovacoes bt-impressao bt-pedido ~
                              bt-aprov-comercial bt-reativar bt-suspender bt-cancelar bt-altera-pedido ~
                              fi-email-repres fi-telefone-repres bt-grafico-novo tg-analitico

&GLOBAL-DEFINE diasAtualiz 365
&GLOBAL-DEFINE diasFiltros 365

/*&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   */

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
      FIELD nome-emit   LIKE emitente.nome-emit
      FIELD nome-matriz LIKE emitente.nome-matriz
      FIELD l_aprov_com        AS LOGICAL   FORMAT "Sim/N∆o" COLUMN-LABEL "Aprov.Com"
      FIELD desc-sit-ped       AS CHARACTER FORMAT "x(15)" COLUMN-LABEL "Sit.Pedido" 
      FIELD desc-sit-pre       AS CHARACTER FORMAT "x(15)" COLUMN-LABEL "Sit.Alocaáao"
      FIELD desc-sit-aval      AS CHARACTER FORMAT "x(15)" COLUMN-LABEL "Sit.Avaliac."
      FIELD cod-rep            LIKE repres.cod-rep
      FIELD email-repres       AS CHARACTER
      FIELD email-repres-secun AS CHARACTER 
      FIELD telefone-repres    AS CHARACTER
      FIELD sit-ped-logist     AS INTEGER
      FIELD desc-sit-ped-log   AS CHARACTER FORMAT "x(60)"
      FIELD cdd-embarq         LIKE alc-embarque.cdd-embarq
      FIELD dt-prevista-embarq LIKE alc-embarque.dt-prevista-embarq
      FIELD desc-cond-pag      AS CHARACTER FORMAT "x(60)"
      FIELD volume             AS DECIMAL
      FIELD cubagem            AS DECIMAL DECIMALS 4 FORMAT ">>,>>9.9999"
      FIELD valor-embarque     AS DECIMAL
      FIELD sit-embarque       AS CHARACTER
      FIELD c-setor            AS CHARACTER FORMAT "x(15)"
      FIELD l-emite-duplic     AS LOGICAL FORMAT "Sim/N∆o"
      FIELD desc-aprov-contab  AS CHARACTER COLUMN-LABEL "Aprov.Contab" FORMAT "x(12)"
      FIELD des-unid-neg       AS CHARACTER FORMAT "x(20)"
      FIELD dt-atualiza-cli    LIKE emitente.dt-atualiza
      FIELD lim-credito-tot    LIKE emitente.lim-credito 
      FIELD vl-dup-aberto      AS DECIMAL DECIMALS 2 FORMAT "->,>>>,>>9.99"
      FIELD sit-ped-graf       AS CHARACTER FORMAT "X(30)"
      FIELD peso-bruto-ped     AS DEC DECIMALS 4 FORMAT "->,>>>,>>9.9999" COLUMN-LABEL 'Peso Bru Ab'
      FIELD dt-agenda-logist   AS DATE FORMAT "99/99/9999" COLUMN-LABEL 'Dt Agenda Log°stica'
      FIELD l-cli-multa-atraso AS LOG COLUMN-LABEL 'Multa por Atraso'
      FIELD l-entr-exclusiva   AS LOG COLUMN-LABEL 'Entr Exclus'
      FIELD l-possui-agenda    AS LOG COLUMN-LABEL 'Possui Agendamento'
      FIELD l-entr-paletizada  AS LOG COLUMN-LABEL 'Entr Paletizada'
      FIELD dt-aprov-com-contab AS DATE
      FIELD r-rowid            AS ROWID.

DEFINE TEMP-TABLE tt-resumo NO-UNDO 
    FIELD c-setor            AS CHARACTER FORMAT "x(15)"
    FIELD valor              AS DECIMAL.

DEFINE TEMP-TABLE tt-logistica NO-UNDO 
    FIELD situacao           AS CHARACTER FORMAT "x(15)"
    FIELD valor              AS DECIMAL.

DEFINE TEMP-TABLE tt-ped-item-analitico NO-UNDO LIKE ped-item 
    FIELD cod-estabel       LIKE ped-venda.cod-estabel
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD cidade            LIKE ped-venda.cidade
    FIELD estado            LIKE ped-venda.estado
    FIELD nome-emit         LIKE emitente.nome-emit
    FIELD nome-matriz       LIKE emitente.nome-emit
    FIELD desc-item         LIKE item.desc-item
    FIELD qtidade-atu-12    LIKE saldo-estoq.qtidade-atu COLUMN-LABEL "Qt Atual Plms" 
    FIELD qt-alocada-12     LIKE saldo-estoq.qt-alocada COLUMN-LABEL "Qt Alocada Plms" 
    FIELD qt-saldo-12       AS DEC COLUMN-LABEL "Qt Disp Plms"
    FIELD qtidade-atu-14    LIKE saldo-estoq.qtidade-atu COLUMN-LABEL "Qt Atual Arauc" 
    FIELD qt-alocada-14     LIKE saldo-estoq.qt-alocada  COLUMN-LABEL "Qt Alocada Arauc" 
    FIELD qt-saldo-14       AS DEC COLUMN-LABEL "Qt Disp Arauc"
    FIELD r-rowid           AS ROWID.




{utp/utapi019.i}
{include/i-freeac.i}

/* Local Variable Definitions ---                                       */

{pdp/alpd0003tt.i}

DEFINE VARIABLE i-bgcolor AS INTEGER INITIAL ? NO-UNDO.
DEFINE VARIABLE i-fgcolor AS INTEGER INITIAL ? NO-UNDO.

def new global shared var gr-ped-venda as rowid no-undo.
def new global shared var gr-emitente  as rowid no-undo.
def new global shared var v_rec_cliente as recid format ">>>>>>9":U no-undo.

DEFINE BUFFER b-pre-fatur FOR pre-fatur.
DEFINE BUFFER b-repres    FOR repres.

DEFINE VARIABLE de-volume         AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-cubagem        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-peso-bruto     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-peso-liqui     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-sit-embarque    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-contador-ped    AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-bodi605     AS HANDLE   NO-UNDO.
DEFINE VARIABLE dtTimeInicial AS DATETIME   NO-UNDO.
DEFINE VARIABLE dtTimeFinal   AS DATETIME   NO-UNDO.
DEFINE VARIABLE l-exec-ok     AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-itens-pedido

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-item-analitico tt-ped-venda

/* Definitions for BROWSE br-itens-pedido                               */
&Scoped-define FIELDS-IN-QUERY-br-itens-pedido tt-ped-item-analitico.cod-estabel tt-ped-item-analitico.cod-emitente tt-ped-item-analitico.nome-emit tt-ped-item-analitico.nr-pedcli tt-ped-item-analitico.cidade tt-ped-item-analitico.estado tt-ped-item-analitico.nome-matriz tt-ped-item-analitico.dt-entrega tt-ped-item-analitico.it-codigo tt-ped-item-analitico.desc-item tt-ped-item-analitico.qt-pedida tt-ped-item-analitico.qt-pedida - tt-ped-item-analitico.qt-atendida tt-ped-item-analitico.vl-liq-abe tt-ped-item-analitico.qtidade-atu-12 tt-ped-item-analitico.qt-alocada-12 tt-ped-item-analitico.qt-saldo-12 tt-ped-item-analitico.qtidade-atu-14 tt-ped-item-analitico.qt-alocada-14 tt-ped-item-analitico.qt-saldo-14   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens-pedido   
&Scoped-define SELF-NAME br-itens-pedido
&Scoped-define QUERY-STRING-br-itens-pedido FOR EACH tt-ped-item-analitico
&Scoped-define OPEN-QUERY-br-itens-pedido OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item-analitico.
&Scoped-define TABLES-IN-QUERY-br-itens-pedido tt-ped-item-analitico
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens-pedido tt-ped-item-analitico


/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-venda.dt-implant tt-ped-venda.nr-pedcli tt-ped-venda.desc-sit-ped tt-ped-venda.cod-estabel tt-ped-venda.nome-abrev tt-ped-venda.nome-emit tt-ped-venda.cod-rep tt-ped-venda.no-ab-rep tt-ped-venda.estado tt-ped-venda.cidade tt-ped-venda.vl-liq-abe tt-ped-venda.vl-liq-ped tt-ped-venda.vl-tot-ped tt-ped-venda.lim-credito-tot tt-ped-venda.dt-aprov-com-contab tt-ped-venda.dt-apr-cred tt-ped-venda.vl-dup-aberto tt-ped-venda.nome-matriz tt-ped-venda.contato tt-ped-venda.nat-operacao tt-ped-venda.l-emite-duplic tt-ped-venda.cod-cond-pag tt-ped-venda.desc-cond-pag tt-ped-venda.cod-portador tt-ped-venda.modalidade tt-ped-venda.dt-entrega tt-ped-venda.c-setor tt-ped-venda.cod-unid-neg tt-ped-venda.des-unid-neg tt-ped-venda.completo tt-ped-venda.l_aprov_com tt-ped-venda.desc-aprov-contab tt-ped-venda.desc-sit-aval tt-ped-venda.quem-aprovou tt-ped-venda.sit-ped-graf tt-ped-venda.desc-sit-pre tt-ped-venda.desc-sit-ped-log tt-ped-venda.cdd-embarq tt-ped-venda.dt-prevista-embarq tt-ped-venda.sit-embarque tt-ped-venda.volume tt-ped-venda.cubagem tt-ped-venda.valor-embarque tt-ped-venda.dt-atualiza-cli tt-ped-venda.dt-agenda-logist tt-ped-venda.cgc tt-ped-venda.peso-bruto-ped tt-ped-venda.l-cli-multa-atraso tt-ped-venda.l-entr-exclusiva tt-ped-venda.l-possui-agenda tt-ped-venda.l-entr-paletizada fn-ult-nf-fat(tt-ped-venda.nome-abrev, tt-ped-venda.nr-pedcli)   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos   
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-venda
&Scoped-define OPEN-QUERY-br-pedidos OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda.
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-venda


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-pedidos}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-itens-pedido}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-analitico bt-filtro-geral bt-grafico ~
btQueryJoins btReportsJoins btExit btHelp fi-nr-pedcli bt-carrega ~
fi-tempo-proc bt-historico bt-aprovacoes bt-impressao bt-pedido ~
bt-aprov-comercial bt-reativar bt-suspender bt-cancelar bt-contabilidade ~
bt-financeiro bt-altera-pedido fi-email-repres fi-vl-tot-abe fi-vl-tot-liq ~
fi-vl-tot-ped btFechar btHelp2 bt-legenda bt-grafico-novo rtToolBar-2 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tg-analitico fi-telefone-repres ~
fi-nr-pedcli fi-tempo-proc fi-email-repres fi-vl-tot-abe fi-vl-tot-liq ~
fi-vl-tot-ped 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-ult-nf-fat wWindow 
FUNCTION fn-ult-nf-fat RETURNS CHAR
  ( pc-nome-abrev AS CHAR,
    pc-nr-pedcli  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataAtualizaEmit wWindow 
FUNCTION fnDataAtualizaEmit RETURNS DATETIME
  ( INPUT i-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataLibFinanceiro wWindow 
FUNCTION fnDataLibFinanceiro RETURNS DATE
  ( pc-nome-abrev AS CHAR,
    pc-nr-pedcli  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItemPed wWindow 
FUNCTION fnItemPed RETURNS LOGICAL
  ( INPUT cnm_abrev  AS CHARACTER,
    INPUT cnr_pedcli AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeEmitente wWindow 
FUNCTION fnNomeEmitente RETURNS CHARACTER
  ( p-cod-emitente AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU miReportsJoins 
       MENU-ITEM m_Pedidos_Selecionados LABEL "Pedidos Selecionados"
       RULE
       MENU-ITEM m_Pedidos_Cancelados LABEL "Pedidos Cancelados"
       MENU-ITEM m_Pedidos_Suspensos LABEL "Pedidos Suspensos"
       RULE
       MENU-ITEM m_Clientes_Inativos LABEL "Clientes Inativos"
       RULE
       MENU-ITEM m_Limite_Credito LABEL "Clientes Limite CrÇdito".

DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       SUB-MENU  miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .

DEFINE MENU POPUP-MENU-br-pedidos 
       MENU-ITEM m_Desaprova_Comercial LABEL "Desaprova Comercial".

DEFINE MENU POPUP-MENU-bt-contabilidade 
       MENU-ITEM m_AprovarReprovar LABEL "Aprovar/Reprovar"
       MENU-ITEM m_Notas_Fiscais LABEL "Notas Fiscais" 
       MENU-ITEM m_Cliente_Contabilidade LABEL "Cliente (Financeiro)".

DEFINE SUB-MENU m_ind_lib_separ 
       MENU-ITEM m_libera_separ_pedido LABEL "Libera Separaá∆o do Pedido"
       MENU-ITEM m_bloqueia_separ_pedido LABEL "Bloqueia Separaá∆o de Pedido".

DEFINE MENU POPUP-MENU-bt-financeiro 
       MENU-ITEM m_credito      LABEL "Inf CrÇdito/Avaliaá∆o Cliente"
       MENU-ITEM m_Cliente_Financeiro LABEL "Inf Financeiras Cliente"
       RULE
       MENU-ITEM m_visualiza_pedidos LABEL "Avaliaá∆o CrÇdito de Pedidos"
       RULE
       SUB-MENU  m_ind_lib_separ LABEL "Liberaá∆o p/ Separaá∆o (Picking)".


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-altera-pedido 
     LABEL "Altera Inf.Pedido" 
     SIZE 12.86 BY 1.

DEFINE BUTTON bt-aprov-comercial 
     LABEL "Aprova Comercial" 
     SIZE 13.86 BY 1.

DEFINE BUTTON bt-aprovacoes 
     LABEL "Aprovaá‰es" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-cancelar 
     LABEL "Cancela Pedido" 
     SIZE 12.86 BY 1.

DEFINE BUTTON bt-carrega 
     IMAGE-UP FILE "image/toolbar/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-relo.bmp":U
     LABEL "" 
     SIZE 4.72 BY 1.25.

DEFINE BUTTON bt-contabilidade 
     LABEL "Contabilidade" 
     SIZE 12.86 BY 1.

DEFINE BUTTON bt-filtro-geral 
     IMAGE-UP FILE "image/im-param2.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-param2.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-financeiro 
     LABEL "Financeiro" 
     SIZE 12.86 BY 1.

DEFINE BUTTON bt-grafico 
     IMAGE-UP FILE "image/im-grf.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-grf.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-grafico-novo 
     IMAGE-UP FILE "image/im-grf.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-grf.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-historico 
     LABEL "Hist¢rico" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-impressao 
     LABEL "Imprimir Pedido" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-legenda 
     IMAGE-UP FILE "image/toolbar/im-legen.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-legen.bmp":U
     LABEL "Filtro" 
     SIZE 4.72 BY 1.25
     FONT 4.

DEFINE BUTTON bt-pedido 
     LABEL "Consulta Pedido" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-reativar 
     LABEL "Reativa Pedido" 
     SIZE 12.86 BY 1.

DEFINE BUTTON bt-suspender 
     LABEL "Suspende Pedido" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-email-repres AS CHARACTER FORMAT "X(256)":U 
     LABEL "E-mail Repres" 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli AS CHARACTER FORMAT "x(12)" 
     LABEL "Pedido Cliente" 
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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 138 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 138 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-analitico AS LOGICAL INITIAL no 
     LABEL "Modo Anal°tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens-pedido FOR 
      tt-ped-item-analitico SCROLLING.

DEFINE QUERY br-pedidos FOR 
      tt-ped-venda SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens-pedido wWindow _FREEFORM
  QUERY br-itens-pedido DISPLAY
      tt-ped-item-analitico.cod-estabel      
      tt-ped-item-analitico.cod-emitente
tt-ped-item-analitico.nome-emit      WIDTH 15
tt-ped-item-analitico.nr-pedcli
tt-ped-item-analitico.cidade         WIDTH 15
tt-ped-item-analitico.estado
tt-ped-item-analitico.nome-matriz    WIDTH 15
tt-ped-item-analitico.dt-entrega
tt-ped-item-analitico.it-codigo
tt-ped-item-analitico.desc-item      
tt-ped-item-analitico.qt-pedida
tt-ped-item-analitico.qt-pedida - tt-ped-item-analitico.qt-atendida COLUMN-LABEL 'Saldo' FORMAT '->>,>>>,>>9.99'
tt-ped-item-analitico.vl-liq-abe
tt-ped-item-analitico.qtidade-atu-12 
tt-ped-item-analitico.qt-alocada-12  
tt-ped-item-analitico.qt-saldo-12
tt-ped-item-analitico.qtidade-atu-14 
tt-ped-item-analitico.qt-alocada-14  
tt-ped-item-analitico.qt-saldo-14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 12.25
         FONT 1.

DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos wWindow _FREEFORM
  QUERY br-pedidos DISPLAY
      tt-ped-venda.dt-implant      
    tt-ped-venda.nr-pedcli       
    tt-ped-venda.desc-sit-ped WIDTH 9
    tt-ped-venda.cod-estabel  COLUMN-LABEL "Estab" WIDTH 3 FORMAT "x(3)" 
    tt-ped-venda.nome-abrev   WIDTH 7   
    tt-ped-venda.nome-emit    WIDTH 33    
    tt-ped-venda.cod-rep      COLUMN-LABEL "Repres"
    tt-ped-venda.no-ab-rep    COLUMN-LABEL "Nome Repres" WIDTH 11
    tt-ped-venda.estado       COLUMN-LABEL "UF"
    tt-ped-venda.cidade       COLUMN-LABEL "Cidade"
    tt-ped-venda.vl-liq-abe  
    tt-ped-venda.vl-liq-ped 
    tt-ped-venda.vl-tot-ped
    tt-ped-venda.lim-credito-tot    COLUMN-LABEL "Limite CrÇdito"
    tt-ped-venda.dt-aprov-com-contab COLUMN-LABEL "Dt.Comer/Contab" 
    tt-ped-venda.dt-apr-cred
    tt-ped-venda.vl-dup-aberto      COLUMN-LABEL "Vl Dup. Aberto"
    tt-ped-venda.nome-matriz  WIDTH 7
    tt-ped-venda.contato            COLUMN-LABEL "OC.Cliente" WIDTH 12
    tt-ped-venda.nat-operacao
    tt-ped-venda.l-emite-duplic     COLUMN-LABEL "Emite Dupl"
    tt-ped-venda.cod-cond-pag
    tt-ped-venda.desc-cond-pag      COLUMN-LABEL "Cond.Pagto" WIDTH 15
    tt-ped-venda.cod-portador
    tt-ped-venda.modalidade         COLUMN-LABEL "Modalid"
    tt-ped-venda.dt-entrega         COLUMN-LABEL "Dt.Entrega"
    tt-ped-venda.c-setor            COLUMN-LABEL "Setor" WIDTH 12 
    tt-ped-venda.cod-unid-neg       COLUMN-LABEL "Un.Neg" 
    tt-ped-venda.des-unid-neg       COLUMN-LABEL "Desc.Unid.Negoc." WIDTH 20
    tt-ped-venda.completo
    tt-ped-venda.l_aprov_com        COLUMN-LABEL "Comerc."
    tt-ped-venda.desc-aprov-contab  
    tt-ped-venda.desc-sit-aval      COLUMN-LABEL "Financeiro"
    tt-ped-venda.quem-aprovou
    tt-ped-venda.sit-ped-graf       COLUMN-LABEL "Sit.Ped.Graf"
    tt-ped-venda.desc-sit-pre       COLUMN-LABEL "Sit.Alocaá∆o"
    tt-ped-venda.desc-sit-ped-log   COLUMN-LABEL "Situaá∆o Log°stica" WIDTH 25
    tt-ped-venda.cdd-embarq         COLUMN-LABEL "Nr.Embarque"        WIDTH 10
    tt-ped-venda.dt-prevista-embarq COLUMN-LABEL "Dt.Prev.Embarque"
    tt-ped-venda.sit-embarque       COLUMN-LABEL "Sit.Embarque" 
    tt-ped-venda.volume             COLUMN-LABEL "Volumes"
    tt-ped-venda.cubagem            COLUMN-LABEL "Cubagem"
    tt-ped-venda.valor-embarque     COLUMN-LABEL "Vl.Liq.Embarq"
    tt-ped-venda.dt-atualiza-cli    COLUMN-LABEL "Dt.Atual.Cli"
    tt-ped-venda.dt-agenda-logist   COLUMN-LABEL "Dt.Age.Logist"
    tt-ped-venda.cgc                
    tt-ped-venda.peso-bruto-ped     COLUMN-LABEL "Peso Bru Ab"
    tt-ped-venda.l-cli-multa-atraso COLUMN-LABEL "Cli Multa Atraso" VIEW-AS TOGGLE-BOX
    tt-ped-venda.l-entr-exclusiva   VIEW-AS TOGGLE-BOX
    tt-ped-venda.l-possui-agenda    VIEW-AS TOGGLE-BOX
    tt-ped-venda.l-entr-paletizada  VIEW-AS TOGGLE-BOX
    fn-ult-nf-fat(tt-ped-venda.nome-abrev, tt-ped-venda.nr-pedcli) COLUMN-LABEL "Èlt NF Fat" FORMAT 'x(30)' WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135.72 BY 13.17
         FONT 1
         TITLE "Pedidos de Venda - Quantidade: 0".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-analitico AT ROW 2.75 COL 61 WIDGET-ID 214
     fi-telefone-repres AT ROW 18.67 COL 56.29 COLON-ALIGNED WIDGET-ID 96
     bt-filtro-geral AT ROW 1.13 COL 1.57 HELP
          "Consultas relacionadas" WIDGET-ID 38
     bt-grafico AT ROW 1.13 COL 6 HELP
          "Consultas relacionadas" WIDGET-ID 90
     btQueryJoins AT ROW 1.13 COL 122.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 126.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 130.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 134.72 HELP
          "Ajuda"
     fi-nr-pedcli AT ROW 2.67 COL 11 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" WIDGET-ID 80
     bt-carrega AT ROW 2.46 COL 28.14 WIDGET-ID 4
     fi-tempo-proc AT ROW 2.67 COL 46 COLON-ALIGNED WIDGET-ID 94
     bt-historico AT ROW 2.63 COL 89.29 WIDGET-ID 92
     bt-aprovacoes AT ROW 2.63 COL 101.57 WIDGET-ID 88
     bt-impressao AT ROW 2.63 COL 113.86 WIDGET-ID 76
     bt-pedido AT ROW 2.63 COL 126.14 WIDGET-ID 36
     bt-aprov-comercial AT ROW 17.42 COL 2.14 WIDGET-ID 64
     bt-reativar AT ROW 17.42 COL 16.43 WIDGET-ID 56
     bt-suspender AT ROW 17.42 COL 29.72 WIDGET-ID 58
     bt-cancelar AT ROW 17.42 COL 43 WIDGET-ID 60
     bt-contabilidade AT ROW 17.42 COL 92.86 WIDGET-ID 86
     bt-financeiro AT ROW 17.42 COL 106 WIDGET-ID 82
     bt-altera-pedido AT ROW 17.42 COL 125.29 WIDGET-ID 78
     fi-email-repres AT ROW 18.67 COL 10.14 COLON-ALIGNED WIDGET-ID 62
     fi-vl-tot-abe AT ROW 18.67 COL 85.14 COLON-ALIGNED WIDGET-ID 66
     fi-vl-tot-liq AT ROW 18.67 COL 104 COLON-ALIGNED WIDGET-ID 72
     fi-vl-tot-ped AT ROW 18.67 COL 123.29 COLON-ALIGNED WIDGET-ID 74
     btFechar AT ROW 19.92 COL 2
     btHelp2 AT ROW 19.92 COL 128.57
     bt-legenda AT ROW 1.13 COL 10.29 HELP
          "Consultas relacionadas" WIDGET-ID 210
     bt-grafico-novo AT ROW 1.13 COL 54 HELP
          "Consultas relacionadas" WIDGET-ID 212
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 19.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.14 BY 20.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     br-itens-pedido AT ROW 1 COL 1 WIDGET-ID 500
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4
         SIZE 136 BY 13.25
         FONT 1
         TITLE "Pedidos de Venda ANAL°TICO - Quantidade: 0" WIDGET-ID 400.

DEFINE FRAME fPage1
     br-pedidos AT ROW 1 COL 1 WIDGET-ID 200
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4
         SIZE 136 BY 13.25
         FONT 1 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.38
         WIDTH              = 138.14
         MAX-HEIGHT         = 25.46
         MAX-WIDTH          = 154.72
         VIRTUAL-HEIGHT     = 25.46
         VIRTUAL-WIDTH      = 154.72
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-contabilidade:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-bt-contabilidade:HANDLE.

ASSIGN 
       bt-financeiro:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-bt-financeiro:HANDLE.

ASSIGN 
       fi-email-repres:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-telefone-repres IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-telefone-repres:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-pedidos 1 fPage1 */
ASSIGN 
       br-pedidos:POPUP-MENU IN FRAME fPage1             = MENU POPUP-MENU-br-pedidos:HANDLE
       br-pedidos:NUM-LOCKED-COLUMNS IN FRAME fPage1     = 3
       br-pedidos:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-itens-pedido 1 fPage2 */
ASSIGN 
       br-itens-pedido:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       br-itens-pedido:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens-pedido
/* Query rebuild information for BROWSE br-itens-pedido
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item-analitico.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens-pedido */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pedidos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pedidos
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON ENTRY OF br-pedidos IN FRAME fPage1 /* Pedidos de Venda - Quantidade: 0 */
DO:
    APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON MOUSE-SELECT-CLICK OF br-pedidos IN FRAME fPage1 /* Pedidos de Venda - Quantidade: 0 */
DO:
   APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON ROW-DISPLAY OF br-pedidos IN FRAME fPage1 /* Pedidos de Venda - Quantidade: 0 */
DO:
    IF AVAIL tt-ped-venda THEN DO:
        CASE tt-ped-venda.cod-sit-ped:
            WHEN 1 THEN DO: /*Aberto/Pendente*/
                IF tt-ped-venda.l_aprov_com = YES AND tt-ped-venda.cod-sit-aval = 4 AND
                   (NOT tt-ped-venda.quem-aprovou = "Sistema" AND
                    NOT tt-ped-venda.quem-aprovou = "Autom†tico" AND 
                    NOT tt-ped-venda.quem-aprovou = "") THEN DO:
                        ASSIGN i-bgcolor = 12
                               i-fgcolor = 15. /* Reprovados */
                END.
                ELSE DO:
                    IF tt-ped-venda.l_aprov_com THEN
                        ASSIGN i-bgcolor = ?
                               i-fgcolor = 9.
                    ELSE IF tt-ped-venda.completo THEN
                        ASSIGN i-bgcolor = ?
                               i-fgcolor = 2.
                    ELSE
                        ASSIGN i-bgcolor = ?
                               i-fgcolor = ?.
                END.
            END.
            WHEN 2 THEN /*Atend.Parcial*/
                ASSIGN i-bgcolor = 11
                       i-fgcolor = ?. 
            WHEN 3 THEN /*Atend.Total*/
                IF tt-ped-venda.dt-cancel <> ? THEN /* Mostra como Cancelado, se tiver sido faturado parcial */
                    ASSIGN i-bgcolor = 13
                           i-fgcolor = 15.
                ELSE
                    ASSIGN i-bgcolor = 22
                           i-fgcolor = ?. 
            WHEN 5 THEN /*Suspenso*/
                ASSIGN i-bgcolor = 14
                       i-fgcolor = ?. 
            WHEN 6 THEN /*Cancelado*/
                ASSIGN i-bgcolor = 13
                       i-fgcolor = 15. 
            OTHERWISE DO:
                ASSIGN i-bgcolor = ?
                       i-fgcolor = ?. 
            END.
        END CASE.

        ASSIGN tt-ped-venda.dt-implant          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.dt-implant          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.nr-pedcli           :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.nr-pedcli           :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.desc-sit-ped        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.desc-sit-ped        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cod-estabel         :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cod-estabel         :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.nome-abrev          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.nome-abrev          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.nome-emit           :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.nome-emit           :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.estado              :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.estado              :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cidade              :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cidade              :FGCOLOR IN BROWSE br-pedidos = i-fgcolor               
               tt-ped-venda.cod-rep             :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cod-rep             :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.no-ab-rep           :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.no-ab-rep           :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.vl-liq-abe          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.vl-liq-abe          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.vl-liq-ped          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.vl-liq-ped          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.vl-tot-ped          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.vl-tot-ped          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.dt-aprov-com-contab :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.dt-aprov-com-contab :FGCOLOR IN BROWSE br-pedidos = i-fgcolor 
               tt-ped-venda.lim-credito-tot     :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.lim-credito-tot     :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.vl-dup-aberto       :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.vl-dup-aberto       :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.nome-matriz         :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.nome-matriz         :FGCOLOR IN BROWSE br-pedidos = i-fgcolor 
               tt-ped-venda.contato             :BGCOLOR IN BROWSE br-pedidos = i-bgcolor  
               tt-ped-venda.contato             :FGCOLOR IN BROWSE br-pedidos = i-fgcolor  
               tt-ped-venda.nat-operacao        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.nat-operacao        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor 
               tt-ped-venda.l-emite-duplic      :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.l-emite-duplic      :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cod-cond-pag        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.cod-cond-pag        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor 
               tt-ped-venda.desc-cond-pag       :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.desc-cond-pag       :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cod-portador        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.cod-portador        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.modalidade          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor  
               tt-ped-venda.modalidade          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor  
               tt-ped-venda.dt-entrega          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.dt-entrega          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.c-setor             :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.c-setor             :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cod-unid-negoc      :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cod-unid-negoc      :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.des-unid-neg        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.des-unid-neg        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.completo            :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.completo            :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.l_aprov_com         :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.l_aprov_com         :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.desc-aprov-contab   :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.desc-aprov-contab   :FGCOLOR IN BROWSE br-pedidos = i-fgcolor 
               tt-ped-venda.desc-sit-aval       :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.desc-sit-aval       :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.quem-aprovou        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.quem-aprovou        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.sit-ped-graf        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.sit-ped-graf        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.desc-sit-pre        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.desc-sit-pre        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.desc-sit-ped-log    :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.desc-sit-ped-log    :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cdd-embarq          :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cdd-embarq          :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.dt-prevista-embarq  :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.dt-prevista-embarq  :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.sit-embarque        :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.sit-embarque        :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.volume              :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.volume              :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cubagem             :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.cubagem             :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.valor-embarque      :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.valor-embarque      :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.dt-atualiza-cli     :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.dt-atualiza-cli     :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.dt-apr-cred         :BGCOLOR IN BROWSE br-pedidos = i-bgcolor  
               tt-ped-venda.dt-apr-cred         :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.cgc                 :BGCOLOR IN BROWSE br-pedidos = i-bgcolor  
               tt-ped-venda.cgc                 :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.peso-bruto-ped      :BGCOLOR IN BROWSE br-pedidos = i-bgcolor  
               tt-ped-venda.peso-bruto-ped      :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.l-cli-multa-atraso  :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.l-cli-multa-atraso  :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.l-entr-exclusiva    :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.l-entr-exclusiva    :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.dt-agenda-logist    :BGCOLOR IN BROWSE br-pedidos = i-bgcolor
               tt-ped-venda.dt-agenda-logist    :FGCOLOR IN BROWSE br-pedidos = i-fgcolor
               tt-ped-venda.l-possui-agenda     :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.l-possui-agenda     :FGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.l-entr-paletizada   :BGCOLOR IN BROWSE br-pedidos = i-bgcolor 
               tt-ped-venda.l-entr-paletizada   :FGCOLOR IN BROWSE br-pedidos = i-fgcolor .

        IF tt-ped-venda.dt-atualiza-cli = ? OR TODAY - tt-ped-venda.dt-atualiza-cli > {&diasAtualiz} THEN
            ASSIGN tt-ped-venda.nome-abrev:FGCOLOR IN BROWSE br-pedidos = 7
                   tt-ped-venda.nome-emit :FGCOLOR IN BROWSE br-pedidos = 7.

        IF tt-ped-venda.l-cli-multa-atraso = YES THEN
            ASSIGN tt-ped-venda.l-cli-multa-atraso:BGCOLOR IN BROWSE br-pedidos = 12
                   tt-ped-venda.l-cli-multa-atraso:FGCOLOR IN BROWSE br-pedidos = 12.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON START-SEARCH OF br-pedidos IN FRAME fPage1 /* Pedidos de Venda - Quantidade: 0 */
DO:
  DEF VAR coluna AS CHAR. /* Guarda o nome real da coluna clicada no browse */
  DEF VAR cWhere AS CHAR INIT "FOR EACH tt-ped-venda NO-LOCK BY tt-ped-venda.dt-implant INDEXED-REPOSITION.".
  DEF VAR hQuery AS HANDLE.

 /* Se a coluna clicada n∆o foi clicada anteriormente faáa */
  IF SELF :CURRENT-COLUMN :SORT-ASCENDING = ? THEN DO:
     SELF :CLEAR-SORT-ARROWS(). /* Limpa as setas das outras colunas */
     SELF :CURRENT-COLUMN :SORT-ASCENDING = FALSE. /* Ordena a coluna ascendentemente */
  END.
  /* Sen∆o ordena a coluna ao inverso do que j† est† ordenada */
  ELSE SELF :CURRENT-COLUMN :SORT-ASCENDING = NOT SELF :CURRENT-COLUMN :SORT-ASCENDING.

  /* Armazena a coluna recem selecionada */
  coluna = SELF :CURRENT-COLUMN :NAME.

  /* Verifica se a ordenaá∆o est† ascendente e altera a vari†vel cWhere da Query */
  IF SELF :CURRENT-COLUMN :SORT-ASCENDING = FALSE THEN DO:
/* Retira as ordenaá‰es que existiam e coloca somente para a coluna clicada - CRESCENTE */
     cWhere = REPLACE(cWhere,SUBSTRING(cWhere,INDEX(cWhere,"BY"),INDEX(cWhere,"indexed") - INDEX(cWhere,"BY")),STRING("BY " + coluna + " ")).
  END.
  ELSE IF SELF :CURRENT-COLUMN :SORT-ASCENDING = TRUE THEN DO:
     /* Retira as ordenaá‰es que existiam e coloca somente para a coluna clicada - DECRESCENTE */
     cWhere = REPLACE(cWhere,SUBSTRING(cWhere,INDEX(cWhere,"BY"),INDEX(cWhere,"indexed") - INDEX(cWhere,"BY")),STRING("BY " + coluna + " DESC ")).
  END.
  ELSE DO:
      /* Se n∆o houver coluna clicada limpa as £ltimas clicadas e retorna. */
      SELF :CLEAR-SORT-ARROWS().
      RETURN.
  END.

  /* Executa a nova query para o Browse */
  ASSIGN hQuery = SELF :QUERY :HANDLE.
  hQuery:QUERY-PREPARE(cWhere).
  hQuery:QUERY-OPEN().

  APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos wWindow
ON VALUE-CHANGED OF br-pedidos IN FRAME fPage1 /* Pedidos de Venda - Quantidade: 0 */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        ASSIGN bt-aprov-comercial:SENSITIVE IN FRAME fPage0  = NO
               MENU-ITEM m_desaprova_comercial:SENSITIVE IN MENU POPUP-MENU-br-pedidos = NO
               bt-reativar:SENSITIVE IN FRAME fPage0  = NO
               bt-suspender:SENSITIVE IN FRAME fPage0 = NO
               bt-cancelar:SENSITIVE IN FRAME fPage0  = NO
               fi-email-repres:SCREEN-VALUE IN FRAME fPage0 = ""
               fi-telefone-repres:SCREEN-VALUE IN FRAME fPage0 = ""
               bt-financeiro:SENSITIVE IN FRAME fPage0  = NO.
    END.
    ELSE DO:
        ASSIGN fi-email-repres:SCREEN-VALUE IN FRAME fPage0    = tt-ped-venda.email-repres
               fi-telefone-repres:SCREEN-VALUE IN FRAME fPage0 = tt-ped-venda.telefone-repres
               bt-aprov-comercial:SENSITIVE IN FRAME fPage0 = (NOT tt-ped-venda.l_aprov_com AND tt-ped-venda.cod-sit-ped <= 2 AND tt-ped-venda.completo)
               MENU-ITEM m_desaprova_comercial:SENSITIVE IN MENU POPUP-MENU-br-pedidos = (tt-ped-venda.l_aprov_com AND tt-ped-venda.cod-sit-ped <= 2 AND tt-ped-venda.completo)
               bt-altera-pedido:SENSITIVE IN FRAME fPage0   = tt-ped-venda.cod-sit-ped <= 2 AND tt-ped-venda.completo
               bt-contabilidade:SENSITIVE IN FRAME fPage0   = tt-ped-venda.cod-sit-ped <= 2 AND tt-ped-venda.completo AND tt-ped-venda.l_aprov_com AND
                                                              CAN-FIND(FIRST alc-natur-oper NO-LOCK 
                                                                       WHERE alc-natur-oper.nat-operacao = tt-ped-venda.nat-operacao 
                                                                         AND alc-natur-oper.l-pedido-aprov-contab)
               bt-financeiro:SENSITIVE IN FRAME fPage0      = tt-ped-venda.cod-sit-ped <= 2 AND tt-ped-venda.completo AND tt-ped-venda.l_aprov_com.

        CASE tt-ped-venda.cod-sit-ped:
            WHEN 2 THEN DO: /*Atend.Parcial*/
                ASSIGN bt-reativar:SENSITIVE IN FRAME fPage0  = NO
                       bt-suspender:SENSITIVE IN FRAME fPage0 = YES
                       bt-cancelar:SENSITIVE IN FRAME fPage0  = YES.
                RUN pi-permissoes.
            END.
            WHEN 3 OR /*Atend.Total ou Cancelado*/ 
            WHEN 6 THEN DO: 
                ASSIGN bt-reativar:SENSITIVE IN FRAME fPage0  = NO
                       bt-suspender:SENSITIVE IN FRAME fPage0 = NO
                       bt-cancelar:SENSITIVE IN FRAME fPage0  = NO.

                IF tt-ped-venda.cod-sit-ped = 3          AND 
                   tt-ped-venda.dt-implant >= 01/01/2014 AND 
                   tt-ped-venda.l_aprov_com = NO THEN DO:
                    FIND FIRST alc-param-usuar NO-LOCK
                         WHERE alc-param-usuar.usuario = v_cod_usuar_corren NO-ERROR.
                    ASSIGN bt-aprov-comercial:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-aprova-comercial THEN YES ELSE NO)
                           MENU-ITEM m_desaprova_comercial:SENSITIVE IN MENU POPUP-MENU-br-pedidos = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-aprova-comercial THEN YES ELSE NO).
                END.
            END.
            WHEN 5 THEN DO: /*Suspenso*/
                ASSIGN bt-reativar:SENSITIVE IN FRAME fPage0  = YES
                       bt-suspender:SENSITIVE IN FRAME fPage0 = NO
                       bt-cancelar:SENSITIVE IN FRAME fPage0  = NO.
                RUN pi-permissoes.
            END.
            OTHERWISE DO: /*Aberto/Pendente*/
                ASSIGN bt-reativar:SENSITIVE IN FRAME fPage0  = NO
                       bt-suspender:SENSITIVE IN FRAME fPage0 = YES
                       bt-cancelar:SENSITIVE IN FRAME fPage0  = YES.
                RUN pi-permissoes.
            END.
        END CASE.

        RUN pi-perm-financeiro.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-altera-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-pedido wWindow
ON CHOOSE OF bt-altera-pedido IN FRAME fpage0 /* Altera Inf.Pedido */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        RUN pi-altera-pedido.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprov-comercial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprov-comercial wWindow
ON CHOOSE OF bt-aprov-comercial IN FRAME fpage0 /* Aprova Comercial */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE RUN pi-aprova-comercial.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprovacoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprovacoes wWindow
ON CHOOSE OF bt-aprovacoes IN FRAME fpage0 /* Aprovaá‰es */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        RUN pi-mostra-aprovacoes.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar wWindow
ON CHOOSE OF bt-cancelar IN FRAME fpage0 /* Cancela Pedido */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE RUN pi-cancelar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega wWindow
ON CHOOSE OF bt-carrega IN FRAME fpage0
DO:
    ASSIGN INPUT FRAME fPage0 fi-nr-pedcli.
  
    RUN pi-carrega-tabelas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contabilidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contabilidade wWindow
ON CHOOSE OF bt-contabilidade IN FRAME fpage0 /* Contabilidade */
DO:
    MESSAGE "Selecione uma opá∆o com utilizando o bot∆o direito!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro-geral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro-geral wWindow
ON CHOOSE OF bt-filtro-geral IN FRAME fpage0 /* Filtro */
DO:
    DEFINE VARIABLE c-acao AS CHARACTER   NO-UNDO.

    ASSIGN wWindow:SENSITIVE = NO.

    RUN pdp/alpd0003f.w (INPUT-OUTPUT TABLE tt-filtros, OUTPUT c-acao). 

    ASSIGN wWindow:SENSITIVE = YES.

    IF c-acao = "atualizar" THEN DO:
        /*ASSIGN i-linha-browse = 0.*/
        RUN pi-carrega-tabelas.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-financeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-financeiro wWindow
ON CHOOSE OF bt-financeiro IN FRAME fpage0 /* Financeiro */
DO:
    MESSAGE "Selecione uma opá∆o com utilizando o bot∆o direito!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-grafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico wWindow
ON CHOOSE OF bt-grafico IN FRAME fpage0 /* Filtro */
DO:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-acomp             AS HANDLE NO-UNDO.
    DEFINE VARIABLE c-setor-carteira    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-sit-ped-log  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-unid-negoc        AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE l-laminados AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-valor-fat AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-pedido AS DECIMAL     NO-UNDO.

    DEFINE BUFFER b1-ped-venda FOR ped-venda.

    EMPTY TEMP-TABLE tt-resumo.
    EMPTY TEMP-TABLE tt-logistica.

    run utp/ut-acomp.p persistent set h-acomp.  
    run pi-inicializar in h-acomp (input "Buscando Pedidos...").

    FIND FIRST tt-filtros NO-LOCK NO-ERROR.

    FOR EACH b1-ped-venda USE-INDEX ch-implant NO-LOCK
       WHERE b1-ped-venda.dt-implant      >= TODAY - {&diasFiltros}
         AND b1-ped-venda.dt-implant      <= TODAY
         AND b1-ped-venda.cod-sit-ped     <= 2
         AND b1-ped-venda.completo,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = b1-ped-venda.nat-operacao
         AND natur-oper.emite-duplic,
       FIRST cst_ped_venda NO-LOCK
       WHERE cst_ped_venda.nome-abrev = b1-ped-venda.nome-abrev
         AND cst_ped_venda.nr-pedcli  = b1-ped-venda.nr-pedcli:

        RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(b1-ped-venda.dt-implant,"99/99/9999")).

/*         ASSIGN l-unid-negoc = NO.                        */
/*         IF tt-filtros.i-cod-unid-negoc = 2 THEN DO:      */
/*             /*Laminados*/                                */
/*             FOR FIRST ped-item OF b1-ped-venda NO-LOCK   */
/*                 WHERE ped-item.cod-unid-neg  = "02":     */
/*                 ASSIGN l-unid-negoc = YES.               */
/*             END.                                         */
/*         END.                                             */
/*         ELSE IF tt-filtros.i-cod-unid-negoc = 1 THEN DO: */
/*             ASSIGN l-unid-negoc = YES.                   */
/*             /*Utensilios Domesticos*/                    */
/*             FOR FIRST ped-item OF b1-ped-venda NO-LOCK   */
/*                 WHERE ped-item.cod-unid-neg = "02":      */
/*                     ASSIGN l-unid-negoc = NO.            */
/*             END.                                         */
/*         END.                                             */

        ASSIGN l-laminados = NO.
        FOR FIRST ped-item OF b1-ped-venda NO-LOCK
            WHERE ped-item.cod-unid-neg  = "02":
            ASSIGN l-laminados = YES.
        END.

        ASSIGN l-unid-negoc = NO.
        IF tt-filtros.i-cod-unid-negoc = 2 THEN DO: 
            /*Laminados*/ 
            FOR FIRST ped-item OF b1-ped-venda NO-LOCK
                WHERE ped-item.cod-unid-neg  = "02":
                ASSIGN l-unid-negoc = YES.
            END.
        END.
        ELSE IF tt-filtros.i-cod-unid-negoc = 1 THEN DO: 
            ASSIGN l-unid-negoc = YES.
            /*Utensilios Domesticos*/ 
            FOR FIRST ped-item OF b1-ped-venda NO-LOCK
                WHERE ped-item.cod-unid-neg <> "01": /* ped-item.cod-unid-neg <> "01" */
                    ASSIGN l-unid-negoc = NO.
            END.
        END.

        IF tt-filtros.i-cod-unid-negoc <> 0 AND NOT l-unid-negoc THEN NEXT.

        ASSIGN c-setor-carteira = "".

        IF cst_ped_venda.l_aprov_com = NO OR 
                cst_ped_venda.l_aprov_com = YES AND b1-ped-venda.cod-sit-aval = 4 AND
               (NOT b1-ped-venda.quem-aprovou = "Sistema" AND
                NOT b1-ped-venda.quem-aprovou = "Autom†tico" AND 
                NOT b1-ped-venda.quem-aprovou = "")THEN /* N∆o Aprovados no Comercial e Reprovados Foráadamente fazem parte da Carteira Comercial */
            ASSIGN c-setor-carteira = "Comercial".
        ELSE IF cst_ped_venda.i-aprov-contab <> 2 THEN
            ASSIGN c-setor-carteira = "Contabilidade".
        ELSE IF b1-ped-venda.cod-sit-aval <> 3 THEN 
            ASSIGN c-setor-carteira = "Financeiro".
        ELSE DO:
            IF b1-ped-venda.cod-sit-ped <= 2 THEN
                ASSIGN c-setor-carteira = "Log°stica".
        END.
      
        FIND FIRST tt-resumo NO-LOCK
             WHERE tt-resumo.c-setor = c-setor-carteira NO-ERROR.
        IF NOT AVAIL tt-resumo THEN DO:
            CREATE tt-resumo.
            ASSIGN tt-resumo.c-setor = c-setor-carteira.
        END.
        IF c-setor-carteira = "Log°stica" THEN DO:

            ASSIGN de-valor-pedido = 0.
            FOR EACH ped-item OF b1-ped-venda NO-LOCK
               WHERE ped-item.cod-sit-item < 3:
/*                IF c-seg-usuario = "super" THEN DO:
        OUTPUT TO "C:\temp\movto-lam-log.txt" APPEND.
            PUT UNFORMATTED c-setor-carteira ";" ped-item.nr-sequencia ";" ped-item.it-codigo ";" ped-item.nr-pedcli ";" b1-ped-venda.nome-abrev ";" b1-ped-venda.dt-entrega ";" ped-item.vl-merc-abe ";" b1-ped-venda.cod-cond-pag SKIP.
        OUTPUT CLOSE.
                END.*/
                ASSIGN tt-resumo.valor    = tt-resumo.valor    + ped-item.vl-merc-abe
                       de-valor-pedido    = de-valor-pedido    + ped-item.vl-merc-abe.
            END.

            CASE cst_ped_venda.sit-ped-logist:
                WHEN 0 THEN ASSIGN c-desc-sit-ped-log = "Nenhum".
                WHEN 1 THEN ASSIGN c-desc-sit-ped-log = "Aguardando Agendamento".
                WHEN 2 THEN ASSIGN c-desc-sit-ped-log = "Agendados e/ou Programados".
                WHEN 3 THEN ASSIGN c-desc-sit-ped-log = "Aguardando Produá∆o".
                WHEN 4 THEN ASSIGN c-desc-sit-ped-log = "Aguardando Complemento Cubagem".
                WHEN 5 THEN ASSIGN c-desc-sit-ped-log = "Aguardando Cotaá∆o Frete".
                WHEN 6 THEN ASSIGN c-desc-sit-ped-log = (IF l-laminados THEN "Nenhum" ELSE "Aguardando Faturamento").
                OTHERWISE   ASSIGN c-desc-sit-ped-log = "N∆o definido".
            END CASE.

            /*
            FIND FIRST tt-logistica NO-LOCK
                 WHERE tt-logistica.situacao = c-desc-sit-ped-log NO-ERROR.
            IF NOT AVAIL tt-logistica THEN DO:
                CREATE tt-logistica.
                ASSIGN tt-logistica.situacao = c-desc-sit-ped-log.
            END.

            FIND LAST pre-fatur NO-LOCK
                WHERE pre-fatur.nome-abrev  = b1-ped-venda.nome-abrev
                  AND pre-fatur.nr-pedcli   = b1-ped-venda.nr-pedcli
                  AND pre-fatur.cod-sit-pre = 1 NO-ERROR.
            IF NOT AVAIL pre-fatur THEN DO:
                FOR EACH ped-item OF b1-ped-venda NO-LOCK
                   WHERE ped-item.cod-sit-item < 3:
                    ASSIGN tt-logistica.valor    = tt-logistica.valor    + ped-item.vl-merc-abe.
                END.

            END.
            ELSE DO:
                FOR EACH it-pre-fat OF pre-fatur NO-LOCK:
                    FIND FIRST ped-item OF it-pre-fat NO-LOCK
                         WHERE ped-item.cod-sit-item < 3 NO-ERROR.
                    IF AVAIL ped-item THEN
                        ASSIGN tt-logistica.valor = tt-logistica.valor + (it-pre-fat.qt-alocada * ped-item.vl-preuni).
                END.
            END.*/
            

            ASSIGN de-valor-fat = 0.
            
            /*Verificando faturamento*/
            FOR EACH ped-item OF b1-ped-venda NO-LOCK
               WHERE ped-item.cod-sit-item < 3:

                FOR EACH it-pre-fat OF ped-item NO-LOCK,
                   FIRST pre-fatur OF it-pre-fat NO-LOCK
                   WHERE pre-fatur.cod-sit-pre = 1  :

                    FIND FIRST tt-logistica NO-LOCK
                         WHERE tt-logistica.situacao = "Aguardando Faturamento" NO-ERROR.
                    IF NOT AVAIL tt-logistica THEN DO:
                        CREATE tt-logistica.
                        ASSIGN tt-logistica.situacao = "Aguardando Faturamento".
                    END.
                    ASSIGN tt-logistica.valor = tt-logistica.valor + (it-pre-fat.qt-alocada * ped-item.vl-preuni)
                           de-valor-fat = de-valor-fat + (it-pre-fat.qt-alocada * ped-item.vl-preuni).
/*                    IF c-seg-usuario = "super" THEN DO:
                        OUTPUT TO "C:\temp\movto-ped-lam-fat.txt" APPEND.
                            PUT UNFORMATTED c-setor-carteira ";" ped-item.nr-sequencia ";" ped-item.it-codigo ";" ped-item.nr-pedcli ";" b1-ped-venda.nome-abrev ";" b1-ped-venda.dt-entrega ";" it-pre-fat.qt-alocada ";" it-pre-fat.qt-alocada * ped-item.vl-preuni ";" b1-ped-venda.cod-cond-pag SKIP.
                        OUTPUT CLOSE.
                    END.*/
                END.
            END.

            IF de-valor-pedido <> de-valor-fat THEN DO:
                /*Verificando saldo em aberto*/
                FIND FIRST tt-logistica NO-LOCK
                     WHERE tt-logistica.situacao = c-desc-sit-ped-log NO-ERROR.
                IF NOT AVAIL tt-logistica THEN DO:
                    CREATE tt-logistica.
                    ASSIGN tt-logistica.situacao = c-desc-sit-ped-log.
                END.
                ASSIGN tt-logistica.valor = tt-logistica.valor + (de-valor-pedido - de-valor-fat).
            END.
        END.
        ELSE DO:
            FOR EACH ped-item OF b1-ped-venda NO-LOCK
                WHERE ped-item.cod-sit-item < 3:
/*                IF c-seg-usuario = "super" THEN DO:
        OUTPUT TO "C:\temp\movto-ped-lam.txt" APPEND.
            PUT UNFORMATTED c-setor-carteira ";" ped-item.nr-sequencia ";" ped-item.it-codigo ";" ped-item.nr-pedcli ";" b1-ped-venda.cod-emitente ";" b1-ped-venda.dt-entrega ";" ped-item.vl-merc-abe ";" b1-ped-venda.cod-cond-pag SKIP.
        OUTPUT CLOSE.
                END. */
                ASSIGN tt-resumo.valor    = tt-resumo.valor    + ped-item.vl-merc-abe.
            END.
        END.

    END.
    
    RUN pi-finalizar IN h-acomp.
    
    RUN pi-mostra-resumo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-grafico-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico-novo wWindow
ON CHOOSE OF bt-grafico-novo IN FRAME fpage0 /* Filtro */
DO:
    RUN pdp/alpd0003g.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-historico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-historico wWindow
ON CHOOSE OF bt-historico IN FRAME fpage0 /* Hist¢rico */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        ASSIGN wWindow:SENSITIVE = NO.
        RUN pdp/alpd0003h.w(INPUT tt-ped-venda.nome-abrev,
                            INPUT tt-ped-venda.nr-pedcli). 
        ASSIGN wWindow:SENSITIVE = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impressao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressao wWindow
ON CHOOSE OF bt-impressao IN FRAME fpage0 /* Imprimir Pedido */
DO:
    ASSIGN gr-ped-venda = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nome-abrev = tt-ped-venda.nome-abrev
               AND ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli  NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            ASSIGN gr-ped-venda = ROWID(ped-venda).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN pdp/alpd0601.w.
            ASSIGN wWindow:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-legenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-legenda wWindow
ON CHOOSE OF bt-legenda IN FRAME fpage0 /* Filtro */
DO:
    RUN pdp/alpd0003b.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedido wWindow
ON CHOOSE OF bt-pedido IN FRAME fpage0 /* Consulta Pedido */
DO:
    ASSIGN gr-ped-venda = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nome-abrev = tt-ped-venda.nome-abrev
               AND ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli  NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            ASSIGN gr-ped-venda = ROWID(ped-venda).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN pdp/pd1001.w.
            ASSIGN wWindow:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reativar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reativar wWindow
ON CHOOSE OF bt-reativar IN FRAME fpage0 /* Reativa Pedido */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE RUN pi-reativar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-suspender
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-suspender wWindow
ON CHOOSE OF bt-suspender IN FRAME fpage0 /* Suspende Pedido */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE RUN pi-suspender.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    /*{include/ajuda.i}*/
    DEFINE VARIABLE c-programa-help AS CHARACTER   NO-UNDO.

    RUN esp/ajuda-especificos.p(INPUT "{&program}",
                                OUTPUT c-programa-help).

    IF SEARCH(c-programa-help) <> ? THEN DO:
        OS-COMMAND NO-WAIT VALUE(SEARCH(c-programa-help)).
    END.
    ELSE
        MESSAGE "Documento de ajuda n∆o encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    /*{include/ajuda.i}*/
    DEFINE VARIABLE c-programa-help AS CHARACTER   NO-UNDO.

    RUN esp/ajuda-especificos.p(INPUT "{&program}",
                                OUTPUT c-programa-help).

    IF SEARCH(c-programa-help) <> ? THEN DO:
        OS-COMMAND NO-WAIT VALUE(SEARCH(c-programa-help)).
    END.
    ELSE
        MESSAGE "Documento de ajuda n∆o encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-pedcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedcli wWindow
ON RETURN OF fi-nr-pedcli IN FRAME fpage0 /* Pedido Cliente */
DO:
    APPLY "CHOOSE" TO bt-carrega IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_AprovarReprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_AprovarReprovar wWindow
ON CHOOSE OF MENU-ITEM m_AprovarReprovar /* Aprovar/Reprovar */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        FIND FIRST alc-param-usuar NO-LOCK
             WHERE alc-param-usuar.usuario = v_cod_usuar_corren NO-ERROR.
        IF NOT AVAIL alc-param-usuar OR
           (AVAIL alc-param-usuar AND NOT alc-param-usuar.l-aprov-reprov-contab) THEN DO:
            MESSAGE "Aprovaá∆o/Reprovaá∆o Contabilidade n∆o permitida!" SKIP
                    "Usu†rio sem permiss∆o para Aprovaá∆o/Reprovaá∆o Contabilidade de pedidos!"
                    "Verifique permiss∆o no ALES0022 ou entre em contato departamento TI."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.

        FIND LAST b-pre-fatur NO-LOCK
            WHERE b-pre-fatur.nome-abrev  = tt-ped-venda.nome-abrev
              AND b-pre-fatur.nr-pedcli   = tt-ped-venda.nr-pedcli
              AND b-pre-fatur.cod-sit-pre = 1 NO-ERROR.
        IF AVAIL b-pre-fatur THEN DO:
            MESSAGE "Aprovaá∆o/Reprovaá∆o Contabilidade n∆o permitida!" SKIP
                    "Pedido j† foi alocado no embarque: " b-pre-fatur.cdd-embarq SKIP
                    "Ser† necess†rio desalocar pedido para efetuar Aprovaá∆o/Reprovaá∆o Contabilidade, entre em contato com departamento Log°stica/Comercial."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.

        RUN pi-aprova-reprova-contab.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_bloqueia_separ_pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_bloqueia_separ_pedido wWindow
ON CHOOSE OF MENU-ITEM m_bloqueia_separ_pedido /* Bloqueia Separaá∆o de Pedido */
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST para-ped     NO-LOCK NO-ERROR.

    IF AVAIL tt-ped-venda THEN DO:
        IF CAN-FIND (FIRST alc-ord-separ-ped-venda
                     WHERE alc-ord-separ-ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                       AND alc-ord-separ-ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli) THEN DO:
            FIND FIRST alc-ord-separ-ped-venda
                 WHERE alc-ord-separ-ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                   AND alc-ord-separ-ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-LOCK NO-ERROR.

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                INPUT 29119,
                                INPUT "Existe OS Vinculada nesse Pedido de Venda" + "~~" +
                                      "Por favor comunicar o setor de PCP ou Log°stica sobre a Separaá∆o, antes de efetivar o bloqueio." + CHR(13) +
                                      "Ordem de Separaá∆o: " + STRING(alc-ord-separ-ped-venda.nr-ord-separ)).
            RETURN NO-APPLY.
        END.
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                            INPUT 27100,
                            INPUT "Deseja efetuar o Bloqueio deste Pedido para Separaá∆o no Estoque?" + "~~" +
                                  "O pedido ficar† bloqueado para montagem de Ordens de Separaá∆o.").
        IF RETURN-VALUE = "YES" THEN DO:
            FIND FIRST ped-venda 
                 WHERE ROWID(ped-venda) = tt-ped-venda.r-rowid EXCLUSIVE-LOCK NO-ERROR.
            FIND FIRST cst_ped_venda OF ped-venda EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ped-venda AND AVAIL cst_ped_venda THEN DO:
                ASSIGN cst_ped_venda.lg-lib-separacao    = YES
                       cst_ped_venda.usuar-lib-separacao = c-seg-usuario
                       cst_ped_venda.dt-hr-lib-separacao = NOW.
/*                 ASSIGN ped-venda.dsp-pre-fat        = NO                              */
/*                        ped-venda.dt-mensagem        = TODAY                           */
/*                        ped-venda.cod-message-alerta = 3                               */
/*                        ped-venda.nome-prog          = "alpd0003"                      */
/*                        tt-ped-venda.dsp-pre-fat     = ped-venda.dsp-pre-fat           */
/*                        tt-ped-venda.dt-mensagem        = ped-venda.dt-mensagem        */
/*                        tt-ped-venda.cod-message-alerta = ped-venda.cod-message-alerta */
/*                        tt-ped-venda.nome-prog          = ped-venda.nome-prog.         */

                IF SUBSTRING(para-ped.char-1,64,3) = "YES" THEN DO: /* Hist¢rico de Pedidos - Est† fora de inclus∆o da BO para An†lise*/
                     CREATE histor-pdven.
                     ASSIGN histor-pdven.nom-abrevi-clien = tt-ped-venda.nome-abrev
                            histor-pdven.cod-ped-clien    = tt-ped-venda.nr-pedcli
                            histor-pdven.cod-usuar        = c-seg-usuario
                            histor-pdven.dat-histor       = TODAY
                            histor-pdven.hra-histor       = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
                            histor-pdven.cdn-tip-histor   = 9
                            histor-pdven.cod-classif      = "1"
                            histor-pdven.des-histor       = "Pedido Bloqueado para Separaá∆o - OS Tipo Antecipada".
                     RELEASE histor-pdven NO-ERROR.
                END.
                RELEASE cst_ped_venda NO-ERROR.
                RELEASE ped-venda NO-ERROR.

                RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                     INPUT 15825,
                                     INPUT "Pedido Bloqueado para Separaá∆o." + "~~" + 
                                           "Para desfazer este Bloqueio, acessar a opá∆o Financeiro e selecionar a opá∆o Libera Separaá∆o.").
            END.
        END.
    END.  
    APPLY "value-changed" TO br-pedidos IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Clientes_Inativos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Clientes_Inativos wWindow
ON CHOOSE OF MENU-ITEM m_Clientes_Inativos /* Clientes Inativos */
DO:
  RUN pi-lista-clientes-inativos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cliente_Contabilidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cliente_Contabilidade wWindow
ON CHOOSE OF MENU-ITEM m_Cliente_Contabilidade /* Cliente (Financeiro) */
DO:
    ASSIGN v_rec_cliente = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST emscad.cliente NO-LOCK
             WHERE cliente.cdn_cliente = tt-ped-venda.cod-emitente NO-ERROR.
        IF AVAIL cliente THEN DO:
            ASSIGN v_rec_cliente = RECID(cliente).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN prgfin/acr/acr205aa.p.
            ASSIGN wWindow:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cliente_Financeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cliente_Financeiro wWindow
ON CHOOSE OF MENU-ITEM m_Cliente_Financeiro /* Inf Financeiras Cliente */
DO:
    ASSIGN v_rec_cliente = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST emscad.cliente NO-LOCK
             WHERE cliente.cdn_cliente = tt-ped-venda.cod-emitente NO-ERROR.
        IF AVAIL cliente THEN DO:
            ASSIGN v_rec_cliente = RECID(cliente).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN prgfin/acr/acr205aa.p.
            ASSIGN wWindow:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_credito wWindow
ON CHOOSE OF MENU-ITEM m_credito /* Inf CrÇdito/Avaliaá∆o Cliente */
DO:
    ASSIGN gr-emitente = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:
            ASSIGN gr-emitente = ROWID(emitente).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN cmp/cm0102.w.
            ASSIGN wWindow:SENSITIVE = YES.
            APPLY "VALUE-CHANGED" TO br-pedidos IN FRAME fPage1.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Desaprova_Comercial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Desaprova_Comercial wWindow
ON CHOOSE OF MENU-ITEM m_Desaprova_Comercial /* Desaprova Comercial */
DO:
    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Obrigat¢rio selecionar um pedido no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE RUN pi-desaprova-com.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_libera_separ_pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_libera_separ_pedido wWindow
ON CHOOSE OF MENU-ITEM m_libera_separ_pedido /* Libera Separaá∆o do Pedido */
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST para-ped     NO-LOCK NO-ERROR.

    IF AVAIL tt-ped-venda THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                            INPUT 27100,
                            INPUT "Deseja efetuar a Liberaá∆o deste Pedido para Separaá∆o mesmo sem aprovaá∆o financeira?" + "~~" +
                                  "Este tipo de liberaá∆o, permitir† a alocaá∆o/separaá∆o do material deste pedido no estoque, mesmo sem ter a aprovaá∆o financeira do pedido de venda.").
        IF RETURN-VALUE = "YES" THEN DO:
            FIND FIRST ped-venda 
                 WHERE ROWID(ped-venda) = tt-ped-venda.r-rowid EXCLUSIVE-LOCK NO-ERROR.
            FIND FIRST cst_ped_venda OF ped-venda EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ped-venda AND AVAIL cst_ped_venda THEN DO:
                ASSIGN cst_ped_venda.lg-lib-separacao    = YES
                       cst_ped_venda.usuar-lib-separacao = c-seg-usuario
                       cst_ped_venda.dt-hr-lib-separacao = NOW.

/*                 ASSIGN ped-venda.dsp-pre-fat        = YES                             */
/*                        ped-venda.dt-mensagem        = TODAY                           */
/*                        ped-venda.cod-message-alerta = ?                               */
/*                        ped-venda.nome-prog          = "alpd0003"                      */
/*                        tt-ped-venda.dsp-pre-fat     = ped-venda.dsp-pre-fat           */
/*                        tt-ped-venda.dt-mensagem        = ped-venda.dt-mensagem        */
/*                        tt-ped-venda.cod-message-alerta = ped-venda.cod-message-alerta */
/*                        tt-ped-venda.nome-prog          = ped-venda.nome-prog.         */

                IF SUBSTRING(para-ped.char-1,64,3) = "YES" THEN DO: /* Hist¢rico de Pedidos - Est† fora de inclus∆o da BO para An†lise*/
                     CREATE histor-pdven .
                     ASSIGN histor-pdven.nom-abrevi-clien = tt-ped-venda.nome-abrev
                            histor-pdven.cod-ped-clien    = tt-ped-venda.nr-pedcli
                            histor-pdven.cod-usuar        = c-seg-usuario
                            histor-pdven.dat-histor       = TODAY
                            histor-pdven.hra-histor       = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
                            histor-pdven.cdn-tip-histor   = 9
                            histor-pdven.cod-classif      = "1"
                            histor-pdven.des-histor       = "Pedido Liberado apenas para Separaá∆o - OS Tipo Antecipada".
                     RELEASE histor-pdven NO-ERROR.
                END.

                RELEASE ped-venda NO-ERROR.
                RELEASE cst_ped_venda NO-ERROR.

                RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                     INPUT 15825,
                                     INPUT "Pedido Dispon°vel para Separaá∆o." + "~~" + 
                                           "Para desfazer esta liberaá∆o, acessar a opá∆o Financeiro e selecionar a opá∆o Bloqueia Separaá∆o.").
            END.
        END.
    END.
    APPLY "VALUE-CHANGED" TO br-pedidos IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Limite_Credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Limite_Credito wWindow
ON CHOOSE OF MENU-ITEM m_Limite_Credito /* Clientes Limite CrÇdito */
DO:
  RUN pi-lista-limite-credito.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Notas_Fiscais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Notas_Fiscais wWindow
ON CHOOSE OF MENU-ITEM m_Notas_Fiscais /* Notas Fiscais */
DO:
    ASSIGN gr-emitente = ?.

    IF AVAIL tt-ped-venda THEN DO:
        ASSIGN wWindow:SENSITIVE = NO.
        RUN ftp/ft0904.w.
        ASSIGN wWindow:SENSITIVE = YES.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pedidos_Cancelados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pedidos_Cancelados wWindow
ON CHOOSE OF MENU-ITEM m_Pedidos_Cancelados /* Pedidos Cancelados */
DO:
   RUN pi-lista-pedidos-cancelados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pedidos_Selecionados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pedidos_Selecionados wWindow
ON CHOOSE OF MENU-ITEM m_Pedidos_Selecionados /* Pedidos Selecionados */
DO:
  RUN pi-gera-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pedidos_Suspensos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pedidos_Suspensos wWindow
ON CHOOSE OF MENU-ITEM m_Pedidos_Suspensos /* Pedidos Suspensos */
DO:
  RUN pi-lista-pedidos-suspensos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_visualiza_pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_visualiza_pedidos wWindow
ON CHOOSE OF MENU-ITEM m_visualiza_pedidos /* Avaliaá∆o CrÇdito de Pedidos */
DO:
    ASSIGN gr-emitente = ?.

    IF AVAIL tt-ped-venda THEN DO:

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:
            ASSIGN gr-emitente = ROWID(emitente).
            ASSIGN wWindow:SENSITIVE = NO.
            RUN cmp/cm0201.w.
            ASSIGN wWindow:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum pedido para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-analitico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-analitico wWindow
ON VALUE-CHANGED OF tg-analitico IN FRAME fpage0 /* Modo Anal°tico */
DO:
    IF tg-analitico:CHECKED THEN DO:

        RUN pi-carrega-ped-item-analit.
        FRAME fpage2:MOVE-TO-TOP().
    END.
    ELSE DO:
        FRAME fpage1:MOVE-TO-TOP().
        {&OPEN-QUERY-br-itens-pedido}
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens-pedido
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-area-pedido AS INTEGER NO-UNDO.
    DEFINE VARIABLE h-acomp       AS HANDLE  NO-UNDO.

    ASSIGN i-area-pedido  = 1 /*comercial*/
           i-contador-ped = 0.

    ASSIGN br-pedidos       :SENSITIVE IN FRAME fpage1 = YES
           br-itens-pedido  :SENSITIVE IN FRAME fpage2 = YES.

    FRAME fpage1:MOVE-TO-TOP().


    FOR FIRST alc-param-usuar NO-LOCK
        WHERE alc-param-usuar.usuario = v_cod_usuar_corren:
        ASSIGN i-area-pedido = alc-param-usuar.i-area-pedido.
    END.

    CREATE tt-filtros.                   
    ASSIGN tt-filtros.i-tipo-filtro       = i-area-pedido + 1
           tt-filtros.cod-estab-ini       = ""
           tt-filtros.cod-estab-fim       = "ZZZ"
           tt-filtros.nome-matriz-ini     = ""
           tt-filtros.nome-matriz-fim     = "ZZZZZZZZZ"
           tt-filtros.nome-abrev-ini      = ""
           tt-filtros.nome-abrev-fim      = "ZZZZZZZZZ"
           tt-filtros.cod-emitente-ini    = 0
           tt-filtros.cod-emitente-fim    = 99999999
           tt-filtros.nr-pedcli-ini       = ""
           tt-filtros.nr-pedcli-fim       = "ZZZZZZZZZZZZ"
           tt-filtros.dt-implant-ini      = TODAY - {&diasFiltros}
           tt-filtros.dt-implant-fim      = TODAY
           tt-filtros.dt-financ-ini       = TODAY - {&diasFiltros}
           tt-filtros.dt-financ-fim       = TODAY
           tt-filtros.l-dt-financ         = NO
           tt-filtros.dt-entrega-ini      = TODAY - 180
           tt-filtros.dt-entrega-fim      = TODAY + 365
           tt-filtros.nat-operacao-ini    = ""
           tt-filtros.nat-operacao-fim    = "ZZZZZZ"
           tt-filtros.cod-rep-ini         = 0
           tt-filtros.cod-rep-fim         = 99999
           tt-filtros.cod-cond-pag-ini    = 0
           tt-filtros.cod-cond-pag-fim    = 9999
           tt-filtros.cdd-embarq-ini      = 0        
           tt-filtros.cdd-embarq-fim      = 999999999        
           tt-filtros.i-cod-unid-negoc    = 0
           tt-filtros.i-aprov-comerc      = 1 /*N∆o*/
           tt-filtros.i-completo          = 2 /*Sim*/
           tt-filtros.i-emite-duplic      = 3
           tt-filtros.l-aberto            = YES
           tt-filtros.l-at-parcial        = YES
           tt-filtros.l-at-total          = YES
           tt-filtros.l-pendente          = YES
           tt-filtros.l-suspenso          = NO
           tt-filtros.l-cancelado         = NO
           tt-filtros.l-nao-avaliado      = YES
           tt-filtros.l-avaliado          = YES
           tt-filtros.l-nao-aprovado      = YES
           tt-filtros.l-aprovado          = YES
           tt-filtros.l-contab-nenhum     = YES
           tt-filtros.l-contab-reprovado  = YES
           tt-filtros.l-contab-aprovado   = YES
           tt-filtros.i-aval-credito      = 3
           tt-filtros.i-alocados          = 3.

    CASE tt-filtros.i-tipo-filtro:
        WHEN 1 THEN DO:
            /*Triagem*/
            ASSIGN tt-filtros.i-aprov-comerc     = 1 /*N∆o*/
                   tt-filtros.i-completo         = 1 /*N∆o*/
                   tt-filtros.i-emite-duplic     = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = YES
                   tt-filtros.l-pendente          = YES
                   tt-filtros.l-suspenso          = NO
                   tt-filtros.l-cancelado         = NO
                   tt-filtros.l-contab-nenhum     = YES    
                   tt-filtros.l-contab-reprovado  = YES    
                   tt-filtros.l-contab-aprovado   = YES
                   tt-filtros.l-nao-avaliado      = YES
                   tt-filtros.l-avaliado          = YES
                   tt-filtros.l-nao-aprovado      = YES
                   tt-filtros.l-aprovado          = YES
                   tt-filtros.i-aval-credito      = 3.
        END.
        WHEN 2 THEN DO:
            /*Comercial*/
            ASSIGN tt-filtros.i-aprov-comerc     = 2 /*N∆o e Sim (Apenas Reprovados)*/
                   tt-filtros.i-completo         = 2 /*Sim*/
                   tt-filtros.i-emite-duplic     = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = YES
                   tt-filtros.l-pendente          = YES
                   tt-filtros.l-suspenso          = NO
                   tt-filtros.l-cancelado         = NO
                   tt-filtros.l-contab-nenhum     = YES    
                   tt-filtros.l-contab-reprovado  = YES    
                   tt-filtros.l-contab-aprovado   = YES
                   tt-filtros.l-nao-avaliado      = YES
                   tt-filtros.l-avaliado          = YES
                   tt-filtros.l-nao-aprovado      = YES
                   tt-filtros.l-aprovado          = YES
                   tt-filtros.i-aval-credito      = 2.
        END.
        WHEN 3 THEN DO:
            /*Contabilidade*/
            ASSIGN tt-filtros.i-aprov-comerc      = 3 /*Sim*/
                   tt-filtros.i-completo          = 2 /*Sim*/
                   tt-filtros.i-emite-duplic      = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = NO
                   tt-filtros.l-pendente          = NO
                   tt-filtros.l-suspenso          = NO
                   tt-filtros.l-cancelado         = NO
                   tt-filtros.l-contab-nenhum     = YES
                   tt-filtros.l-contab-reprovado  = YES
                   tt-filtros.l-contab-aprovado   = NO
                   tt-filtros.l-nao-avaliado      = YES
                   tt-filtros.l-avaliado          = YES
                   tt-filtros.l-nao-aprovado      = YES
                   tt-filtros.l-aprovado          = YES
                   tt-filtros.i-aval-credito      = 3.
        END.
        WHEN 4 THEN DO:
            /*Financeiro*/
            ASSIGN tt-filtros.i-aprov-comerc      = 3 /*Sim*/
                   tt-filtros.i-completo          = 2 /*Sim*/
                   tt-filtros.i-emite-duplic      = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = NO
                   tt-filtros.l-pendente          = NO
                   tt-filtros.l-suspenso          = NO
                   tt-filtros.l-cancelado         = NO
                   tt-filtros.l-contab-nenhum     = NO
                   tt-filtros.l-contab-reprovado  = NO
                   tt-filtros.l-contab-aprovado   = YES    
                   tt-filtros.l-nao-avaliado      = YES
                   tt-filtros.l-avaliado          = YES
                   tt-filtros.l-nao-aprovado      = YES
                   tt-filtros.l-aprovado          = NO
                   tt-filtros.i-aval-credito      = 1.
        END.
        WHEN 5 THEN DO:
            /*Log°stica*/
            ASSIGN tt-filtros.i-aprov-comerc      = 3 /*Sim*/
                   tt-filtros.i-completo          = 2 /*Sim*/
                   tt-filtros.i-emite-duplic      = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = NO
                   tt-filtros.l-pendente          = NO
                   tt-filtros.l-suspenso          = NO
                   tt-filtros.l-contab-nenhum     = NO
                   tt-filtros.l-contab-reprovado  = NO
                   tt-filtros.l-contab-aprovado   = YES
                   tt-filtros.l-cancelado         = NO
                   tt-filtros.l-nao-avaliado      = NO
                   tt-filtros.l-avaliado          = NO
                   tt-filtros.l-nao-aprovado      = NO
                   tt-filtros.l-aprovado          = YES
                   tt-filtros.i-aval-credito      = 3.
        END.
        OTHERWISE DO:
            /*Geral*/
            ASSIGN tt-filtros.i-cod-unid-negoc    = 0
                   tt-filtros.i-aprov-comerc      = 4 /*Todos*/
                   tt-filtros.i-completo          = 3 /*Todos*/
                   tt-filtros.i-emite-duplic      = 3 /*Todos*/
                   tt-filtros.l-aberto            = YES
                   tt-filtros.l-at-parcial        = YES
                   tt-filtros.l-at-total          = YES
                   tt-filtros.l-pendente          = YES
                   tt-filtros.l-suspenso          = YES
                   tt-filtros.l-cancelado         = YES
                   tt-filtros.l-contab-nenhum     = YES    
                   tt-filtros.l-contab-reprovado  = YES    
                   tt-filtros.l-contab-aprovado   = YES    
                   tt-filtros.l-nao-avaliado      = YES
                   tt-filtros.l-avaliado          = YES
                   tt-filtros.l-nao-aprovado      = YES
                   tt-filtros.l-aprovado          = YES
                   tt-filtros.i-aval-credito      = 3.
        END.
    END CASE.
/*                                                                                                            */
/*     RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                                                             */
/*     RUN pi-inicializar IN h-acomp (INPUT "Verificando Pedidos sem itens a mais de 10 dias...").            */
/*                                                                                                            */
/*     FOR EACH ped-venda FIELDS(ped-venda.dt-implant ped-venda.nome-abrev ped-venda.nr-pedcli)               */
/*         WHERE ped-venda.cod-sit-ped = 1                                                                    */
/*         AND   ped-venda.log-cotacao = NO                                                                   */
/*         AND   ped-venda.dt-implant >= TODAY - {&diasFiltros} NO-LOCK:                                      */
/*                                                                                                            */
/*         RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).         */
/*         /*pedidos implantados a mais de 10 dias sem inclus∆o de itens                                      */
/*           Carlos Daniel 28/05/2014 - Chamado 821*/                                                         */
/*         IF (TODAY - ped-venda.dt-implant) > 10 THEN DO:                                                    */
/*             IF NOT fnItemPed(ped-venda.nome-abrev,ped-venda.nr-pedcli) THEN                                */
/*                 RUN pi-elimina-ped(INPUT ROWID(ped-venda)). /*Chama rotina para eliminar pedido de venda*/ */
/*         END.                                                                                               */
/*     END.                                                                                                   */
/*                                                                                                            */
/*     RUN pi-finalizar IN h-acomp.                                                                           */
/*                                                                                                            */
/*     IF i-contador-ped > 0 THEN                                                                             */
/*         MESSAGE "Foi(ram) deletado(s) " + STRING(i-contador-ped) + " Pedido(s) automaticamento." SKIP      */
/*                 "Motivo: Este(s) foi(ram) implantado(s) a mais de 10 dias e ainda n∆o tinha(m) itens."     */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                             */
/*                                                                                                            */
/*     IF v_cod_usuar_corren <> "super" THEN RUN pi-carrega-tabelas.                                          */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-pedido wWindow 
PROCEDURE pi-altera-pedido :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Pedido
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-ped-venda FOR ped-venda.
    DEFINE BUFFER b-ped-item  FOR ped-item.
    DEFINE BUFFER b-ped-ent   FOR ped-ent.

    DEFINE VARIABLE v-nome-abrev      AS CHARACTER LABEL "Nome Abrev"       NO-UNDO.
    DEFINE VARIABLE v-nr-pedcli       AS CHARACTER LABEL "Pedido"           NO-UNDO.
    DEFINE VARIABLE v-dt-entrega      AS DATE      LABEL "Data Entrega"      FORMAT "99/99/9999" NO-UNDO.
    DEFINE VARIABLE v-dt-agenda       AS DATE      LABEL "Data Agenda Logist"       FORMAT "99/99/9999" NO-UNDO.
    DEFINE VARIABLE v-observacoes     LIKE ped-venda.observacoes  NO-UNDO.
    DEFINE VARIABLE v-cond-espec      LIKE ped-venda.cond-espec  NO-UNDO.
    DEFINE VARIABLE v-sit-ped-logist  AS INTEGER   LABEL "Situaá∆o Log°stica" NO-UNDO.

    DEFINE VARIABLE l-altera-pedido AS LOGICAL     NO-UNDO.

    DEFINE BUTTON btPedidoCancel AUTO-END-KEY
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btPedidoOK  
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtPedidoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fPedidoRecord
        v-nome-abrev       AT ROW 1.21 COL 14.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-nr-pedcli        AT ROW 2.21 COL 14.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-dt-entrega       AT ROW 3.21 COL 14.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-dt-agenda        AT ROW 4.21 COL 14.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-sit-ped-logist   AT ROW 5.21 COL 14.72 COLON-ALIGNED VIEW-AS COMBO-BOX INNER-LINES 8
                                                               LIST-ITEM-PAIRS "Nenhum",0,
                                                                               "Aguardando Agendamento",1,
                                                                               "Agendados e/ou Programados",2,
                                                                               "Aguardando Produá∆o",3,
                                                                               "Aguardando Complemento Cubagem",4,
                                                                               "Aguardando Cotaá∆o Frete",5,
                                                                               "Aguardando Faturamento",6,
                                                                               "Saldo Embarque Parcial",7  
                                                               DROP-DOWN-LIST SIZE 50 BY 5
        v-observacoes      AT ROW 6.21 COL 14.72 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 5
        v-cond-espec       AT ROW 11.50 COL 14.72 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 5
        btPedidoOK      AT ROW 17 COL 2.14
        btPedidoCancel  AT ROW 17 COL 13
        rtPedidoButton  AT ROW 16.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Altera Data Entrega" FONT 1
             CANCEL-BUTTON btPedidoCancel.
    
    /*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fPedidoRecord:Handle).
    {utp/ut-liter.i "Altera Data Entrega"}
    ASSIGN FRAME fPedidoRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fPedidoRecord:HANDLE) NO-ERROR.

    ASSIGN v-observacoes:RETURN-INSERTED IN FRAME fPedidoRecord = YES
           v-cond-espec:RETURN-INSERTED IN FRAME fPedidoRecord = YES.

    ASSIGN v-nome-abrev      = tt-ped-venda.nome-abrev
           v-nr-pedcli       = tt-ped-venda.nr-pedcli
           v-dt-entrega      = tt-ped-venda.dt-entrega
           v-dt-agenda       = tt-ped-venda.dt-agenda-logist
           v-sit-ped-logist  = tt-ped-venda.sit-ped-logist
           v-observacoes     = tt-ped-venda.observacoes
           v-cond-espec      = tt-ped-venda.cond-espec.

    DISP v-nome-abrev   
         v-nr-pedcli
         v-dt-entrega
         v-dt-agenda   
         v-sit-ped-logist
         v-observacoes
         v-cond-espec
        WITH FRAME fPedidoRecord. 

    ON "CHOOSE":U OF btPedidoOK IN FRAME fPedidoRecord DO:
        ASSIGN v-nome-abrev
               v-nr-pedcli 
               v-dt-entrega
               v-dt-agenda 
               v-sit-ped-logist
               v-observacoes
               v-cond-espec.

        IF v-dt-entrega <> tt-ped-venda.dt-entrega AND 
           (v-dt-entrega = ? OR v-dt-entrega < TODAY) THEN DO:
            MESSAGE "Data Entrega inv†lida!" SKIP
                    "Data Entrega deve ser maior ou igual a data atual." SKIP
                    "Favor informe uma data entrega v†lida."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
        END.
        ELSE DO:
            ASSIGN l-altera-pedido = NO.

            MESSAGE "Confirma alteraá∆o das informaá‰es do pedido e itens do pedido?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-altera-pedido.

            IF l-altera-pedido THEN DO:

                FOR FIRST b-ped-venda EXCLUSIVE-LOCK
                    WHERE b-ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                      AND b-ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli:

                    IF b-ped-venda.cod-sit-ped > 2 OR NOT b-ped-venda.completo THEN DO: 
                        MESSAGE "N∆o foi poss°vel alterar data entrega." SKIP
                                "Somente pedidos completos e com situaá∆o Aberto ou Atend.Parcial podem ser alterados!"
                            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                        RETURN NO-APPLY.
                    END.
                    ELSE DO:
                        IF b-ped-venda.dt-entrega <> v-dt-entrega  OR 
                           b-ped-venda.observacoes = v-observacoes OR
                           b-ped-venda.cond-espec  = v-cond-espec THEN 
                            ASSIGN b-ped-venda.dt-useralt  = TODAY
                                   b-ped-venda.user-alte   = v_cod_usuar_corren.

                        IF b-ped-venda.observacoes <> v-observacoes THEN ASSIGN b-ped-venda.observacoes = v-observacoes.
                        IF b-ped-venda.cond-espec  <> v-cond-espec  THEN ASSIGN b-ped-venda.cond-espec  = v-cond-espec.

                        IF v-dt-entrega <> b-ped-venda.dt-entrega AND b-ped-venda.cod-emitente <> 2 THEN DO:
                            /*N∆o altera data de entrega de pedidos de transferàncias de beltrao para palmas */
                            ASSIGN b-ped-venda.dt-entrega  = v-dt-entrega
                                   b-ped-venda.dt-useralt  = TODAY
                                   b-ped-venda.user-alte   = v_cod_usuar_corren.
                            FOR EACH b-ped-item OF b-ped-venda EXCLUSIVE-LOCK:
                                IF b-ped-item.cod-sit-item >= 3  OR
                                   b-ped-item.dt-entrega    = v-dt-entrega THEN NEXT.

                                ASSIGN b-ped-item.dt-entrega = v-dt-entrega
                                       b-ped-item.dt-useralt = TODAY
                                       b-ped-item.user-alte  = v_cod_usuar_corren.

                                FOR EACH b-ped-ent OF b-ped-item EXCLUSIVE-LOCK:

                                    IF b-ped-ent.cod-sit-ent >= 3  OR
                                       b-ped-ent.dt-entrega   = v-dt-entrega THEN NEXT.

                                    ASSIGN b-ped-ent.dt-entrega = v-dt-entrega
                                           b-ped-ent.dt-useralt = TODAY
                                           b-ped-ent.user-alte  = v_cod_usuar_corren.

                                    RELEASE b-ped-ent.
                                END.
                                RELEASE b-ped-item.
                            END.
                        END.
                        RELEASE b-ped-venda.
                    END.
                END.

                FOR FIRST cst_ped_venda EXCLUSIVE-LOCK 
                    WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
                      AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli:
                    ASSIGN cst_ped_venda.sit-ped-logistica      = v-sit-ped-logist
                           cst_ped_venda.dt-agenda-logistica    = v-dt-agenda.
                END.
                RELEASE cst_ped_venda NO-ERROR.

                ASSIGN tt-ped-venda.dt-entrega          = v-dt-entrega
                       tt-ped-venda.dt-agenda-logist    = v-dt-agenda
                       tt-ped-venda.sit-ped-logist      = v-sit-ped-logist
                       tt-ped-venda.observacoes         = v-observacoes
                       tt-ped-venda.cond-espec          = v-cond-espec.

                CASE tt-ped-venda.sit-ped-logist:
                    WHEN 0 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Nenhum".
                    WHEN 1 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Agendamento".
                    WHEN 2 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Agendados e/ou Programados".
                    WHEN 3 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Produá∆o".
                    WHEN 4 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Complemento Cubagem".
                    WHEN 5 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Cotaá∆o Frete".
                    WHEN 6 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Faturamento".
                    OTHERWISE   ASSIGN tt-ped-venda.desc-sit-ped-log = "N∆o definido".
                END CASE.
                MESSAGE "Alteraá∆o efetuada com sucesso!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                /*RUN pi-carrega-tabelas.*/
                br-pedidos:REFRESH() IN FRAME fPage1.

                APPLY "GO":U TO FRAME fPedidoRecord.
            END.
        END.
    END.
    
    ENABLE v-dt-entrega
           v-dt-agenda
           v-sit-ped-logist
           v-observacoes
           v-cond-espec
           btPedidoCancel
           btPedidoOK
        WITH FRAME fPedidoRecord. 
    
    WAIT-FOR "GO":U OF FRAME fPedidoRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprova-comercial wWindow 
PROCEDURE pi-aprova-comercial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-orc-ped     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-confirma    AS LOGICAL     NO-UNDO.

    
    IF tt-ped-venda.dt-atualiza-cli = ? OR
       TODAY - tt-ped-venda.dt-atualiza-cli > {&diasAtualiz} THEN DO:

        MESSAGE "Aprovaá∆o comercial n∆o permitida!" SKIP
                "Èltima atualizaá∆o de cadastro de cliente maior que {&diasAtualiz} dias." SKIP
                "Favor atualizar cadastro pelo CD0704 antes de efetuar aprovaá∆o comercial!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    FIND FIRST emitente
         WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
    IF emitente.cod-emitente <> emitente.end-cobranca THEN DO:
        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 29119,
                              INPUT "Cliente Cobranáa Diferente do Cliente do Pedido/Faturamento." + "~~" +
                                    "Favor verificar se as informaá‰es cadastrais (CD1022) para que n∆o haja problemas de envio de cobranáa." + CHR(13) +
                                    "Cliente Pedido/Faturamento: " + fnNomeEmitente(emitente.cod-emitente) + CHR(13) +
                                    "Cliente Cobranáa: " + fnNomeEmitente(emitente.end-cobranca)).
    END.
    
    RUN pi-obs-motivo (INPUT "Aprovaá∆o Comercial", OUTPUT c-desc-motivo).
    
    IF c-desc-motivo <> "" THEN DO:
        MESSAGE "Confirma Aprovaá∆o Comercial?" SKIP(1)
                "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
                " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.

        IF l-confirma THEN DO:
            ASSIGN c-orc-ped     = "Pedido" /*IF tt-ped-venda.l_aprov_com THEN "Pedido" ELSE "Oráamento"*/
                   c-desc-motivo = "Aprovaá∆o Comercial - " + c-desc-motivo.

            ASSIGN l-exec-ok = NO.
            aprovacao: DO TRANSACTION ON ERROR  UNDO aprovacao, LEAVE aprovacao
                                      ON QUIT   UNDO aprovacao, LEAVE aprovacao
                                      ON ENDKEY UNDO aprovacao, LEAVE aprovacao
                                      ON STOP   UNDO aprovacao, LEAVE aprovacao:

                FIND FIRST cst_ped_venda EXCLUSIVE-LOCK
                     WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
                       AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL cst_ped_venda THEN DO:

                    IF cst_ped_venda.l_aprov_com THEN DO:
                        MESSAGE "Pedido j† foi aprovado pelo comercial." SKIP
                                "Usu†rio: " cst_ped_venda.usuar_aprov_com SKIP
                                "Data/Hora: " cst_ped_venda.dt_hr_aprov_com
                            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                        RELEASE cst_ped_venda NO-ERROR.
                        RETURN "NOK".
                    END.
                    ELSE DO:
                        ASSIGN cst_ped_venda.l_aprov_com     = YES
                               cst_ped_venda.dt_hr_aprov_com = NOW
                               cst_ped_venda.usuar_aprov_com = v_cod_usuar_corren.


                        IF NOT CAN-FIND(FIRST alc-natur-oper NO-LOCK
                                        WHERE alc-natur-oper.nat-operacao = tt-ped-venda.nat-operacao
                                          AND alc-natur-oper.l-pedido-aprov-contab = YES) THEN DO:

                            ASSIGN cst_ped_venda.i-aprov-contab     = 2 /*Aprovado*/
                                   cst_ped_venda.dt-hr-aprov-contab = NOW
                                   cst_ped_venda.usuar-aprov-contab = "Autom†tica"
                                   cst_ped_venda.obs-aprov-contab   = "APROVAÄ«O AUTOMµTICA SISTEMA - NATUREZA N«O EXIGE APROVAÄ«O CONTABILIDADE".
                        END.
                        RELEASE cst_ped_venda NO-ERROR.

                        CREATE histor-pdven .
                        ASSIGN histor-pdven.nom-abrevi-clien = tt-ped-venda.nome-abrev
                               histor-pdven.cod-ped-clien    = tt-ped-venda.nr-pedcli
                               histor-pdven.cod-usuar        = c-seg-usuario
                               histor-pdven.dat-histor       = TODAY
                               histor-pdven.hra-histor       = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
                               histor-pdven.cdn-tip-histor   = 9
                               histor-pdven.cod-classif      = "1"
                               histor-pdven.des-histor       = c-desc-motivo .
                        RELEASE histor-pdven.
                    END.
                    RELEASE cst_ped_venda NO-ERROR.
                    ASSIGN l-exec-ok = YES.
                    MESSAGE "Pedido Aprovado com sucesso!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
                ELSE DO:
                    MESSAGE "Erro na Aprovaá∆o Comercial." SKIP
                            "N∆o encontrado tabela custom para pedido."
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                    RETURN "NOK".
                END.
            END.
            IF l-exec-ok AND tt-ped-venda.cod-sit-ped <> 3 THEN DO:
                IF SESSION:SET-WAIT-STATE("") THEN.

                RUN pi-envia-email(INPUT c-orc-ped, INPUT "Aprovado", INPUT c-desc-motivo).
                RUN pi-carrega-tabelas.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprova-reprova-contab wWindow 
PROCEDURE pi-aprova-reprova-contab :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de AprovContab
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-nome-abrev      AS CHARACTER LABEL "Nome Abrev"         NO-UNDO.
    DEFINE VARIABLE v-nr-pedcli       AS CHARACTER LABEL "Pedido"             NO-UNDO.

    DEFINE VARIABLE fi-aprov-contab      AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE fi-usuar-aprov-cont  LIKE cst_ped_venda.usuar_aprov_com   NO-UNDO.
    DEFINE VARIABLE fi-dt-hr-aprov-cont  LIKE cst_ped_venda.dt_hr_aprov_com   NO-UNDO.
    DEFINE VARIABLE v-obs-aprov-contab   LIKE cst_ped_venda.obs-aprov-contab  NO-UNDO.

    DEFINE BUTTON btAprovContabCancel AUTO-END-KEY
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btAprovContabOK  
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAprovContabButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fAprovContabRecord
        v-nome-abrev        AT ROW 1.21 COL 14.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-nr-pedcli         AT ROW 1.21 COL 40.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88

        fi-aprov-contab     AT ROW 2.21 COL 14.5 COLON-ALIGNED VIEW-AS COMBO-BOX SIZE 15 BY 1 INNER-LINES 5  LIST-ITEM-PAIRS "Nenhum",0,"Reprovado",1,"Aprovado",2 LABEL "Contabilidade"
        fi-usuar-aprov-cont AT ROW 2.21 COL 29.8 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 NO-LABEL
        fi-dt-hr-aprov-cont AT ROW 2.21 COL 43.1 COLON-ALIGNED VIEW-AS FILL-IN SIZE 21.4 BY .88 NO-LABEL
        v-obs-aprov-contab  AT ROW 3.21 COL 14.5 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 2.88 LABEL "Obs.Aprov.Contab."

        btAprovContabOK       AT ROW 7 COL 2.14
        btAprovContabCancel   AT ROW 7 COL 13  
        rtAprovContabButton  AT ROW 6.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Aprova/Reprova Contabilidade" FONT 1
              CANCEL-BUTTON btAprovContabCancel.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fAprovContabRecord:HANDLE) NO-ERROR.

    ASSIGN v-nome-abrev        = tt-ped-venda.nome-abrev
           v-nr-pedcli         = tt-ped-venda.nr-pedcli
           fi-aprov-contab     = 0
           fi-usuar-aprov-cont = ""
           fi-dt-hr-aprov-cont = ? 
           v-obs-aprov-contab  = "".

    FIND FIRST cst_ped_venda NO-LOCK
         WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
           AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.
    IF AVAIL cst_ped_venda THEN
        ASSIGN fi-aprov-contab     = cst_ped_venda.i-aprov-contab
               fi-usuar-aprov-cont = cst_ped_venda.usuar-aprov-contab
               fi-dt-hr-aprov-cont = cst_ped_venda.dt-hr-aprov-contab
               v-obs-aprov-contab  = cst_ped_venda.obs-aprov-contab.

    DISP v-nome-abrev   
         v-nr-pedcli
         fi-aprov-contab    
         fi-usuar-aprov-cont
         fi-dt-hr-aprov-cont
         v-obs-aprov-contab
        WITH FRAME fAprovContabRecord. 

    ON "CHOOSE":U OF btAprovContabOK IN FRAME fAprovContabRecord DO:
        ASSIGN v-nome-abrev
               v-nr-pedcli 
               fi-aprov-contab
               v-obs-aprov-contab.

        FIND LAST b-pre-fatur NO-LOCK
            WHERE b-pre-fatur.nome-abrev  = tt-ped-venda.nome-abrev
              AND b-pre-fatur.nr-pedcli   = tt-ped-venda.nr-pedcli
              AND b-pre-fatur.cod-sit-pre = 1 NO-ERROR.
        IF AVAIL b-pre-fatur THEN DO:
            MESSAGE "Aprovaá∆o/Reprovaá∆o Contabilidade n∆o permitida!" SKIP
                    "Pedido j† foi alocado no embarque: " b-pre-fatur.cdd-embarq SKIP
                    "Ser† necess†rio desalocar pedido para efetuar Aprovaá∆o/Reprovaá∆o Contabilidade, entre em contato com departamento Log°stica/Comercial."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.

        FOR FIRST cst_ped_venda EXCLUSIVE-LOCK 
            WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
              AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli:

            ASSIGN cst_ped_venda.i-aprov-contab   = fi-aprov-contab
                   cst_ped_venda.obs-aprov-contab = v-obs-aprov-contab.

            IF fi-aprov-contab = 0 THEN
                ASSIGN cst_ped_venda.usuar-aprov-contab = ""
                       cst_ped_venda.dt-hr-aprov-contab = ?.
            ELSE 
                ASSIGN cst_ped_venda.usuar-aprov-contab = v_cod_usuar_corren
                       cst_ped_venda.dt-hr-aprov-contab = NOW.

            IF fi-aprov-contab <> 0 THEN DO:
                CREATE histor-pdven .
                ASSIGN histor-pdven.nom-abrevi-clien = tt-ped-venda.nome-abrev
                       histor-pdven.cod-ped-clien    = tt-ped-venda.nr-pedcli
                       histor-pdven.cod-usuar        = c-seg-usuario
                       histor-pdven.dat-histor       = TODAY
                       histor-pdven.hra-histor       = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
                       histor-pdven.cdn-tip-histor   = 9
                       histor-pdven.cod-classif      = IF fi-aprov-contab = 2 THEN "3" ELSE "4"
                       histor-pdven.des-histor       = IF fi-aprov-contab = 2 THEN "Aprovaá∆o" ELSE "Reprovaá∆o" + " Contabilidade - " v-obs-aprov-contab.
                RELEASE histor-pdven NO-ERROR.
            END.
        END.
        RELEASE cst_ped_venda NO-ERROR.

        MESSAGE "Alteraá∆o efetuada com sucesso!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RUN pi-carrega-tabelas.

        APPLY "GO":U TO FRAME fAprovContabRecord.
    END.
    
    ENABLE fi-aprov-contab     
           /*fi-usuar-aprov-cont 
           fi-dt-hr-aprov-cont */
           v-obs-aprov-contab
           btAprovContabOK
           btAprovContabCancel
        WITH FRAME fAprovContabRecord. 
    
    WAIT-FOR "GO":U OF FRAME fAprovContabRecord.

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
        ASSIGN de-vl-tot-abe = de-vl-tot-abe + tt-ped-venda.vl-liq-abe
               de-vl-tot-liq = de-vl-tot-liq + tt-ped-venda.vl-liq-ped
               de-vl-tot-ped = de-vl-tot-ped + tt-ped-venda.vl-tot-ped
               iqt-pedidos   = iqt-pedidos + 1.
    END.

    DISP de-vl-tot-abe @ fi-vl-tot-abe 
         de-vl-tot-liq @ fi-vl-tot-liq
         de-vl-tot-ped @ fi-vl-tot-ped WITH FRAME fPage0.

    IF iqt-pedidos > 0 THEN
        ASSIGN br-pedidos:TITLE IN FRAME fPage1 = "Pedidos de Venda - Quantidade: " + TRIM(STRING(iqt-pedidos,">>>,>>>,>>>,>>9")).
    ELSE
        ASSIGN br-pedidos:TITLE IN FRAME fPage1 = "Pedidos de Venda - Quantidade: 0".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancelar wWindow 
PROCEDURE pi-cancelar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-orc-ped     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-motivo  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE da-data       AS DATE        NO-UNDO.
    DEFINE VARIABLE l-resultado   AS LOGICAL     NO-UNDO.

    DEFINE BUFFER b-ped-venda FOR ped-venda.

/*    DEFINE VARIABLE bo-ped-venda      AS HANDLE      NO-UNDO.*/
    DEFINE VARIABLE bo-ped-venda-can  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-return           AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE l-confirma    AS LOGICAL     NO-UNDO.

    IF NOT tt-ped-venda.completo THEN DO:
        MESSAGE "Pedido est† INCOMPLETO. "SKIP(1) 
                "Confirma alteraá∆o para completo e cancelamento?" SKIP(1)
                "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
                " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.
    END.
    ELSE DO:
        MESSAGE "Confirma Cancelamento?" SKIP(1)
                "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
                " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.

    END.

    IF l-confirma THEN DO:

        ASSIGN c-orc-ped = IF tt-ped-venda.l_aprov_com THEN "Pedido" ELSE "Oráamento".

        RUN pi-verif-alocacao.
        IF RETURN-VALUE = "OK" THEN DO:
            RUN pdp/pd4000a.w(INPUT  "Cancelamento",
                              OUTPUT i-cod-motivo,
                              OUTPUT c-desc-motivo,
                              OUTPUT da-data,
                              OUTPUT l-resultado).
            IF l-resultado THEN DO:
                
                FOR FIRST b-ped-venda EXCLUSIVE-LOCK
                    WHERE b-ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                      AND b-ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli 
                      AND NOT b-ped-venda.completo:
                    ASSIGN b-ped-venda.completo = YES.
                END.
                RELEASE b-ped-venda NO-ERROR.

                IF SESSION:SET-WAIT-STATE("general") THEN.
                IF NOT VALID-HANDLE(bo-ped-venda-can) OR
                   bo-ped-venda-can:TYPE <> "PROCEDURE":U OR
                   bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
                   RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.

                RUN setUserLog IN bo-ped-venda-can (INPUT v_cod_usuar_corren).

                RUN validateCancelation IN bo-ped-venda-can (INPUT  tt-ped-venda.r-rowid,
                                                             OUTPUT TABLE Rowerrors).
                IF  SESSION:SET-WAIT-STATE("") THEN.

                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    RUN pi-ShowMessage.
                END.

                ASSIGN l-exec-ok = NO.
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:
                    IF SESSION:SET-WAIT-STATE("general") THEN.
                    cancelando: DO TRANSACTION ON ERROR  UNDO cancelando, LEAVE cancelando
                                               ON QUIT   UNDO cancelando, LEAVE cancelando
                                               ON ENDKEY UNDO cancelando, LEAVE cancelando
                                               ON STOP   UNDO cancelando, LEAVE cancelando:

                        RUN emptyRowErrors IN bo-ped-venda-can.                        
                        RUN updateCancelation in bo-ped-venda-can(INPUT tt-ped-venda.r-rowid,
                                                                  INPUT c-desc-motivo,
                                                                  INPUT da-data,
                                                                  INPUT i-cod-motivo).
    
                        run getRowErrors in bo-ped-venda-can (output table RowErrors).

                        IF NOT CAN-FIND(FIRST RowErrors
                                        WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:
                            IF SESSION:SET-WAIT-STATE("") THEN.

                            FOR FIRST b-ped-venda EXCLUSIVE-LOCK
                                WHERE b-ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                                  AND b-ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli 
                                  AND b-ped-venda.cod-sit-ped = 3 /*atend.total*/ :
    
                                ASSIGN b-ped-venda.completo = YES.
                            END.
                            IF AVAIL b-ped-venda THEN
                                RELEASE b-ped-venda NO-ERROR.

                            ASSIGN l-exec-ok = YES.
                            MESSAGE "Pedido Cancelado com sucesso"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        END.
                        ELSE DO:
                            run pi-ShowMessage.

                            MESSAGE "Ocorreu erro no cancelamento do Pedido." SKIP 
                                    "Erro: " RETURN-VALUE
                                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                        END.
                    END.
                END.
                IF VALID-HANDLE(bo-ped-venda-can)  THEN DO:
                  DELETE PROCEDURE bo-ped-venda-can.
                  ASSIGN bo-ped-venda-can = ?.
                END.    

                IF l-exec-ok THEN DO:
                    RUN pi-envia-email(INPUT c-orc-ped, INPUT "Cancelado", INPUT c-desc-motivo).
                    RUN pi-carrega-tabelas.
                END.
            END.
        END.
        ELSE RETURN "NOK".
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-ped-item-analit wWindow 
PROCEDURE pi-carrega-ped-item-analit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-tt-ped-venda            FOR tt-ped-venda.
    DEFINE BUFFER b-emitente                FOR emitente.
    DEFINE BUFFER b-tt-ped-item-analitico   FOR tt-ped-item-analitico.

    DEFINE VAR i-qt-it-ped AS INT.

    DEFINE VAR h-acomp AS HANDLE.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Carregando Pedidos Anal°ticos...").
    RUN pi-desabilita-cancela IN h-acomp.

    EMPTY TEMP-TABLE tt-ped-item-analitico.


    FOR EACH b-tt-ped-venda,
        EACH ped-item OF b-tt-ped-venda NO-LOCK,
        FIRST item OF ped-item NO-LOCK,
        FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente = b-tt-ped-venda.cod-emitente.

        RUN pi-acompanhar IN h-acomp (INPUT "Nr Pedido: " + STRING(b-tt-ped-venda.nr-pedido) + " - Item: " + ped-item.it-codigo).

        FIND b-emitente NO-LOCK 
            WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

       FIND FIRST tt-ped-item-analitico 
           WHERE tt-ped-item-analitico.nome-abrev   = b-tt-ped-venda.nome-abrev
             AND tt-ped-item-analitico.nr-pedcli    = b-tt-ped-venda.nr-pedcli 
             AND tt-ped-item-analitico.it-codigo    = ped-item.it-codigo            NO-ERROR.
        IF NOT AVAIL tt-ped-item-analitico  THEN DO:
            CREATE tt-ped-item-analitico.
            BUFFER-COPY ped-item TO tt-ped-item-analitico.
        END.
    
        ASSIGN tt-ped-item-analitico.cidade         = b-tt-ped-venda.cidade                                                             
               tt-ped-item-analitico.estado         = b-tt-ped-venda.estado
               tt-ped-item-analitico.cod-estabel    = b-tt-ped-venda.cod-estabel
               tt-ped-item-analitico.nome-emit      = emitente.nome-emit
               tt-ped-item-analitico.cod-emitente   = emitente.cod-emitente
               tt-ped-item-analitico.desc-item      = item.desc-item
               tt-ped-item-analitico.nome-matriz    = IF AVAIL b-emitente THEN
                                                          string(b-emitente.cod-emitente) + " - " + b-emitente.nome-emit
                                                      ELSE 
                                                          string(emitente.cod-emitente) + " - " + emitente.nome-emit
               tt-ped-item-analitico.dt-entrega     = b-tt-ped-venda.dt-entrega                                                         
               tt-ped-item-analitico.qt-pedida      = ped-item.qt-pedida  
               tt-ped-item-analitico.qt-atendida    = ped-item.qt-atendida
               tt-ped-item-analitico.vl-liq-abe     = ped-item.vl-liq-abe.

        
        FOR EACH saldo-estoq NO-LOCK 
            WHERE saldo-estoq.it-codigo    = tt-ped-item-analitico.it-codigo 
              AND saldo-estoq.cod-depos    = "EXP" 
              AND (saldo-estoq.cod-estabel = "12" or 
                   saldo-estoq.cod-estabel = "14"):

            IF saldo-estoq.cod-estabel = "12" THEN
               ASSIGN tt-ped-item-analitico.qtidade-atu-12 = tt-ped-item-analitico.qtidade-atu-12 + saldo-estoq.qtidade-atu
                      tt-ped-item-analitico.qt-alocada-12  = tt-ped-item-analitico.qt-alocada-12  + saldo-estoq.qt-alocada
                      tt-ped-item-analitico.qt-saldo-12    = tt-ped-item-analitico.qtidade-atu-12 - tt-ped-item-analitico.qt-alocada-12.
            ELSE 
            IF saldo-estoq.cod-estabel = "14" THEN
               ASSIGN tt-ped-item-analitico.qtidade-atu-14 = tt-ped-item-analitico.qtidade-atu-14 + saldo-estoq.qtidade-atu
                      tt-ped-item-analitico.qt-alocada-14  = tt-ped-item-analitico.qt-alocada-14  + saldo-estoq.qt-alocada
                      tt-ped-item-analitico.qt-saldo-14    = tt-ped-item-analitico.qtidade-atu-14 - tt-ped-item-analitico.qt-alocada-14.
       END.
    END.

    RUN pi-finalizar IN h-acomp.


    ASSIGN bt-aprov-comercial:SENSITIVE IN FRAME fPage0  = NO
           MENU-ITEM m_desaprova_comercial:SENSITIVE IN MENU POPUP-MENU-br-pedidos = NO
           bt-reativar:SENSITIVE IN FRAME fPage0  = NO
           bt-suspender:SENSITIVE IN FRAME fPage0 = NO
           bt-cancelar:SENSITIVE IN FRAME fPage0  = NO
           fi-email-repres:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-telefone-repres:SCREEN-VALUE IN FRAME fPage0 = ""
           bt-financeiro:SENSITIVE IN FRAME fPage0  = NO.
    RUN pi-permissoes.


    ASSIGN i-qt-it-ped = 0.
    FOR EACH b-tt-ped-item-analitico.
        ASSIGN i-qt-it-ped = i-qt-it-ped + 1.
    END.

    IF i-qt-it-ped > 0 THEN
        FRAME fPage2:TITLE = "Pedidos de Venda ANAL°TICO - Quantidade: " + TRIM(STRING(i-qt-it-ped,">>>,>>>,>>>,>>9")).
    ELSE
        FRAME fPage2:TITLE  = "Pedidos de Venda ANAL°TICO - Quantidade: 0".


    {&OPEN-QUERY-br-itens-pedido}


    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tabelas wWindow 
PROCEDURE pi-carrega-tabelas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-acomp         AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-unid-negoc AS LOGICAL     NO-UNDO.
    
    ASSIGN dtTimeInicial = NOW.
    EMPTY TEMP-TABLE tt-ped-venda.

    FIND FIRST tt-filtros NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-filtros THEN DO:
        MESSAGE "Filtros n∆o foram selecionados!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Carregando Pedidos...").
    RUN pi-desabilita-cancela IN h-acomp.

    IF fi-nr-pedcli <> "" AND fi-nr-pedcli <> "0"  THEN DO:
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.nr-pedcli = fi-nr-pedcli
             /*AND ped-venda.dt-implant >= TODAY - {&diasFiltros}*/ ,
            FIRST repres FIELDS(cod-rep e-mail telefone[1] telefone[2]) NO-LOCK
            WHERE repres.nome-abrev = ped-venda.no-ab-reppri,
            FIRST emitente FIELDS(nome-emit nome-matriz cod-emitente lim-credito lim-adicional) NO-LOCK
            WHERE emitente.cod-emitente = ped-venda.cod-emitente,
            FIRST natur-oper FIELDS(emite-duplic) NO-LOCK
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao,
            FIRST cst_ped_venda NO-LOCK
            WHERE cst_ped_venda.nome-abrev = ped-venda.nome-abrev
              AND cst_ped_venda.nr-pedcli  = ped-venda.nr-pedcli:

            RUN pi-acompanhar IN h-acomp (INPUT "Nr Pedido: " + STRING(ped-venda.nr-pedido) + " - Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).
            
            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
            RUN pi-cria-tt-ped-venda.
        END.
    END.
    ELSE DO:
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.cod-estabel     >= tt-filtros.cod-estab-ini
             AND ped-venda.cod-estabel     <= tt-filtros.cod-estab-fim  
             AND ped-venda.nome-abrev      >= tt-filtros.nome-abrev-ini 
             AND ped-venda.nome-abrev      <= tt-filtros.nome-abrev-fim 
             AND ped-venda.cod-emitente    >= tt-filtros.cod-emitente-ini
             AND ped-venda.cod-emitente    <= tt-filtros.cod-emitente-fim
             AND ped-venda.nr-pedcli       >= tt-filtros.nr-pedcli-ini  
             AND ped-venda.nr-pedcli       <= tt-filtros.nr-pedcli-fim  
             AND ped-venda.dt-implant      >= tt-filtros.dt-implant-ini
             AND ped-venda.dt-implant      <= tt-filtros.dt-implant-fim
             AND ped-venda.dt-entrega      >= tt-filtros.dt-entrega-ini
             AND ped-venda.dt-entrega      <= tt-filtros.dt-entrega-fim
             AND ped-venda.nat-operacao    >= tt-filtros.nat-operacao-ini
             AND ped-venda.nat-operacao    <= tt-filtros.nat-operacao-fim
             AND (IF tt-filtros.i-completo = 3 THEN  TRUE 
                  ELSE ped-venda.completo = (tt-filtros.i-completo = 2))       
             AND ((ped-venda.cod-sit-ped = 1 AND tt-filtros.l-aberto     = YES) OR
                  (ped-venda.cod-sit-ped = 2 AND tt-filtros.l-at-parcial = YES) OR
                  (ped-venda.cod-sit-ped = 3 AND tt-filtros.l-at-total   = YES AND ped-venda.dt-cancel = ?) OR /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */
                  (ped-venda.cod-sit-ped = 4 AND tt-filtros.l-pendente   = YES) OR
                  (ped-venda.cod-sit-ped = 5 AND tt-filtros.l-suspenso   = YES) OR
                  (ped-venda.cod-sit-ped = 6 AND tt-filtros.l-cancelado  = YES) OR
                  (ped-venda.dt-cancel <> ?  AND tt-filtros.l-cancelado  = YES)) /* Tratativa de Quando for Cancelado e estiver Atendido Parcial, vai para Atendido Total */
             AND ((ped-venda.cod-sit-aval = 1 AND tt-filtros.l-nao-avaliado = YES) OR
                  (ped-venda.cod-sit-aval = 2 AND tt-filtros.l-avaliado     = YES) OR
                  (ped-venda.cod-sit-aval = 3 AND tt-filtros.l-aprovado     = YES) OR 
                  (ped-venda.cod-sit-aval = 4 AND tt-filtros.l-nao-aprovado = YES))
             AND (IF tt-filtros.i-aval-credito = 1 THEN /* Avaliaá‰es Autom†ticas */
                      (ped-venda.quem-aprovou = "Sistema"       OR 
                       ped-venda.quem-aprovou = "Autom†tico"    OR 
                       ped-venda.quem-aprovou = "")
                  ELSE IF tt-filtros.i-aval-credito = 2 THEN
                      (ped-venda.quem-aprovou <> "Sistema"      OR 
                       ped-venda.quem-aprovou <> "Autom†tico"    OR 
                       ped-venda.quem-aprovou = "")
                  ELSE
                      (ped-venda.quem-aprovou <> "?" OR ped-venda.quem-aprovou = "")) ,
           FIRST natur-oper FIELDS(emite-duplic) OF ped-venda NO-LOCK,
           FIRST repres FIELDS(cod-rep e-mail telefone[1] telefone[2]) NO-LOCK
           WHERE repres.nome-abrev = ped-venda.no-ab-reppri
             AND repres.cod-rep >= tt-filtros.cod-rep-ini
             AND repres.cod-rep <= tt-filtros.cod-rep-fim,
           FIRST emitente FIELDS(nome-emit nome-matriz cod-emitente lim-credito lim-adicional) NO-LOCK
           WHERE emitente.cod-emitente = ped-venda.cod-emitente
             AND emitente.nome-matriz  >= tt-filtros.nome-matriz-ini
             AND emitente.nome-matriz  <= tt-filtros.nome-matriz-fim,
           FIRST cst_ped_venda NO-LOCK
           WHERE cst_ped_venda.nome-abrev = ped-venda.nome-abrev
             AND cst_ped_venda.nr-pedcli  = ped-venda.nr-pedcli
            BY ped-venda.dt-implant:
            
            RUN pi-acompanhar IN h-acomp (INPUT "Nr Pedido: " + STRING(ped-venda.nr-pedido) + " - Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).

            IF tt-filtros.l-dt-financ  AND
               (ped-venda.dt-apr-cre = ? OR 
                ped-venda.dt-apr-cre < tt-filtros.dt-financ-ini OR
                ped-venda.dt-apr-cre > tt-filtros.dt-financ-fim) THEN NEXT.

            /************** Filtro de Extens∆o de Pedidos **************/
            IF tt-filtros.i-aprov-comerc = 1 AND cst_ped_venda.l_aprov_com = YES THEN NEXT.
            ELSE IF tt-filtros.i-aprov-comerc = 2 AND (cst_ped_venda.l_aprov_com = YES AND
                                                 (NOT ped-venda.cod-sit-aval = 4 OR
                                                 (ped-venda.cod-sit-aval = 4 AND
                                                  ped-venda.quem-aprovou = "Sistema"      OR 
                                                  ped-venda.quem-aprovou = "Autom†tico"   OR 
                                                  ped-venda.quem-aprovou = ""))) THEN NEXT.
            ELSE IF tt-filtros.i-aprov-comerc = 3 AND cst_ped_venda.l_aprov_com = NO THEN NEXT.

            /************** Filtro de Aprovado Contabilidade**************/
            IF NOT ((cst_ped_venda.i-aprov-contab = 0 AND tt-filtros.l-contab-nenhum    = YES) OR
                    (cst_ped_venda.i-aprov-contab = 1 AND tt-filtros.l-contab-reprovado = YES) OR
                    (cst_ped_venda.i-aprov-contab = 2 AND tt-filtros.l-contab-aprovado  = YES)) THEN
                NEXT.


/*             IF (IF tt-filtros.i-aprov-comerc = 4 THEN TRUE                                        */
/*                 ELSE cst_ped_venda.l_aprov_com = (tt-filtros.i-aprov-comerc = 2)) AND             */
/*                ((cst_ped_venda.i-aprov-contab = 0 AND tt-filtros.l-contab-nenhum    = YES) OR     */
/*                 (cst_ped_venda.i-aprov-contab = 1 AND tt-filtros.l-contab-reprovado = YES) OR     */
/*                 (cst_ped_venda.i-aprov-contab = 2 AND tt-filtros.l-contab-aprovado  = YES)) THEN. */
/*             ELSE                                                                                  */
/*                 NEXT.                                                                             */
            
            IF i-tipo-filtro = 3 /*Contabilidade*/ THEN DO:
                FIND FIRST alc-natur-oper NO-LOCK
                     WHERE alc-natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.
                IF NOT AVAIL alc-natur-oper OR NOT alc-natur-oper.l-pedido-aprov-contab THEN 
                    NEXT.
            END.

            IF tt-filtros.i-emite-duplic <> 3 THEN DO:
                IF natur-oper.emite-duplic = (tt-filtros.i-emite-duplic = 1) THEN NEXT.
            END.

             /* Desconsiderar pedidos sem Item quando estiver filtrado por Unidade de Neg¢cio */
            IF tt-filtros.i-cod-unid-negoc <> 0 AND
               NOT CAN-FIND (FIRST ped-item OF ped-venda) THEN DO:
                NEXT.
            END.

            ASSIGN l-unid-negoc = NO.
            IF tt-filtros.i-cod-unid-negoc = 2 THEN DO: 
                /*Laminados*/ 
                FOR FIRST ped-item OF ped-venda NO-LOCK
                    WHERE ped-item.cod-unid-neg  = "02":
                    ASSIGN l-unid-negoc = YES.
                END.
            END.
            ELSE IF tt-filtros.i-cod-unid-negoc = 1 THEN DO: 
                ASSIGN l-unid-negoc = YES.
                /*Utensilios Domesticos*/ 
                FOR FIRST ped-item OF ped-venda NO-LOCK
                    WHERE ped-item.cod-unid-neg <> "01": /* ped-item.cod-unid-neg <> "01" */
                        ASSIGN l-unid-negoc = NO.
                END.
            END.

            IF tt-filtros.i-cod-unid-negoc <> 0 AND 
               NOT l-unid-negoc THEN 
                NEXT.
            
            IF tt-filtros.cdd-embarq-ini = tt-filtros.cdd-embarq-fim THEN DO:
                IF tt-filtros.cdd-embarq-ini = 0 THEN DO:  
                   IF CAN-FIND(FIRST pre-fatur NO-LOCK
                               WHERE pre-fatur.nome-abrev = ped-venda.nome-abrev
                                 AND pre-fatur.nr-pedcli  = ped-venda.nr-pedcli) THEN NEXT.
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST pre-fatur NO-LOCK
                                    WHERE pre-fatur.nome-abrev = ped-venda.nome-abrev
                                      AND pre-fatur.nr-pedcli  = ped-venda.nr-pedcli
                                      AND pre-fatur.cdd-embarq = tt-filtros.cdd-embarq-ini) THEN NEXT.
                END.
            END.
            ELSE DO:
                IF (tt-filtros.cdd-embarq-ini <> 0 OR tt-filtros.cdd-embarq-fim <> 999999999)  AND 
                   NOT CAN-FIND(FIRST pre-fatur NO-LOCK
                                WHERE pre-fatur.nome-abrev = ped-venda.nome-abrev
                                  AND pre-fatur.nr-pedcli  = ped-venda.nr-pedcli
                                  AND pre-fatur.cdd-embarq >= tt-filtros.cdd-embarq-ini
                                  AND pre-fatur.cdd-embarq <= tt-filtros.cdd-embarq-fim) THEN NEXT.
            END.

            IF tt-filtros.i-alocados <> 3 THEN DO: 
                IF tt-filtros.i-alocados = 1 AND /*somente n∆o alocados*/
                   CAN-FIND(FIRST pre-fatur NO-LOCK
                            WHERE pre-fatur.nome-abrev  = ped-venda.nome-abrev
                              AND pre-fatur.nr-pedcli   = ped-venda.nr-pedcli
                              AND pre-fatur.cod-sit-pre = 1) THEN NEXT.
                IF tt-filtros.i-alocados = 2 AND /*somente alocados*/
                   NOT CAN-FIND(FIRST pre-fatur NO-LOCK
                                WHERE pre-fatur.nome-abrev  = ped-venda.nome-abrev
                                  AND pre-fatur.nr-pedcli   = ped-venda.nr-pedcli
                                  AND pre-fatur.cod-sit-pre = 1) THEN NEXT.
            END.

            IF ped-venda.cod-cond-pag < tt-filtros.cod-cond-pag-ini OR
               ped-venda.cod-cond-pag > tt-filtros.cod-cond-pag-fim THEN 
                NEXT.

            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.

            RUN pi-cria-tt-ped-venda.
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    RUN pi-atualiza-totalizadores.
    RUN pi-atualiza-tela.

    IF tg-analitico:CHECKED IN FRAME fpage0 THEN
        RUN pi-carrega-ped-item-analit.

    ASSIGN dtTimeFinal = NOW
           fi-tempo-proc:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(INTERVAL(dtTimeFinal, dtTimeInicial , "seconds")).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-ped-venda wWindow 
PROCEDURE pi-cria-tt-ped-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER b-item-peso FOR item.

    CREATE tt-ped-venda.
    BUFFER-COPY ped-venda TO tt-ped-venda
       ASSIGN tt-ped-venda.nome-emit            = emitente.nome-emit
              tt-ped-venda.nome-matriz          = emitente.nome-matriz
              tt-ped-venda.l_aprov_com          = cst_ped_venda.l_aprov_com
              tt-ped-venda.dt-agenda-logist     = cst_ped_venda.dt-agenda-logistica
              tt-ped-venda.r-rowid              = ROWID(ped-venda)
              tt-ped-venda.cod-rep              = repres.cod-rep
              tt-ped-venda.email-repres         = TRIM(repres.e-mail)
              tt-ped-venda.telefone-repres      = repres.telefone[1] + IF repres.telefone[2] <> "" THEN
                                                                           (" / " + repres.telefone[2])
                                                                       ELSE
                                                                           ""
              tt-ped-venda.l-emite-duplic       = natur-oper.emite-duplic
              tt-ped-venda.dt-atualiza-cli      = fnDataAtualizaEmit(emitente.cod-emitente).

    ASSIGN tt-ped-venda.cod-unid-neg = "01".

    FOR FIRST ped-item OF ped-venda NO-LOCK
        WHERE ped-item.cod-unid-neg  = "02":
        ASSIGN tt-ped-venda.cod-unid-neg = "02".
    END.
        
    FIND FIRST alc-emit-compl NO-LOCK
        WHERE alc-emit-compl.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    IF AVAIL alc-emit-compl THEN
        ASSIGN tt-ped-venda.l-entr-exclusiva    = alc-emit-compl.l-entrega-exclusiva
               tt-ped-venda.l-cli-multa-atraso  = alc-emit-compl.l-multa-atraso
               tt-ped-venda.l-possui-agenda     = alc-emit-compl.l-possui-agenda  
               tt-ped-venda.l-entr-paletizada   = alc-emit-compl.l-entr-paletizada.


    FOR FIRST unid-negoc NO-LOCK 
       WHERE unid-negoc.cod-unid-negoc = tt-ped-venda.cod-unid-neg :
        ASSIGN tt-ped-venda.des-unid-neg = unid-negoc.des-unid-neg.
    END.

    FOR FIRST repres_financ NO-LOCK
        WHERE repres_financ.cdn_repres = repres.cod-rep
          AND repres_financ.cdn_repres_indir <> 0,
        FIRST b-repres NO-LOCK
        WHERE b-repres.cod-rep = repres_financ.cdn_repres_indir:
        ASSIGN tt-ped-venda.email-repres-secun = b-repres.e-mail.
    END.

    ASSIGN tt-ped-venda.desc-sit-ped = ENTRY(ped-venda.cod-sit-ped,"Aberto,Atend.Parcial,Atend.Total,Pendente,Suspenso,Cancelado",",") NO-ERROR.
    IF tt-ped-venda.desc-sit-ped = "" OR tt-ped-venda.desc-sit-ped = ? THEN
        ASSIGN tt-ped-venda.desc-sit-ped = STRING(ped-venda.cod-sit-ped).

    ASSIGN tt-ped-venda.desc-sit-pre = ENTRY(ped-venda.cod-sit-pre,"N∆o Alocado,Aloc.Parcial,Aloc.Total",",") NO-ERROR.
    IF tt-ped-venda.desc-sit-pre = "" OR tt-ped-venda.desc-sit-pre = ? THEN
        ASSIGN tt-ped-venda.desc-sit-pre = STRING(ped-venda.cod-sit-pre).

    ASSIGN tt-ped-venda.desc-sit-aval = ENTRY(ped-venda.cod-sit-aval,"N∆o Avaliado,Avaliado,Aprovado,N∆o Aprovado,Pendente",",") NO-ERROR.
    IF tt-ped-venda.desc-sit-aval = "" OR tt-ped-venda.desc-sit-aval = ? THEN
        ASSIGN tt-ped-venda.desc-sit-aval = STRING(ped-venda.cod-sit-aval).

    /*ASSIGN tt-ped-venda.i-aprov-contab = cst_ped_venda.i-aprov-contab.*/
    CASE cst_ped_venda.i-aprov-contab:
        WHEN 0 THEN ASSIGN tt-ped-venda.desc-aprov-contab = "Nenhum".
        WHEN 1 THEN ASSIGN tt-ped-venda.desc-aprov-contab = "Reprovado".
        WHEN 2 THEN ASSIGN tt-ped-venda.desc-aprov-contab = "Aprovado".
    END CASE.

    ASSIGN tt-ped-venda.sit-ped-logist = cst_ped_venda.sit-ped-logist.
    CASE tt-ped-venda.sit-ped-logist:
        WHEN 0 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Nenhum".
        WHEN 1 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Agendamento".
        WHEN 2 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Agendados e/ou Programados".
        WHEN 3 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Produá∆o".
        WHEN 4 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Complemento Cubagem".
        WHEN 5 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Cotaá∆o Frete".
        WHEN 6 THEN ASSIGN tt-ped-venda.desc-sit-ped-log = "Aguardando Faturamento".
        OTHERWISE   ASSIGN tt-ped-venda.desc-sit-ped-log = "N∆o definido".
    END CASE.

    ASSIGN c-sit-embarque = "Nenhum".
    FIND LAST b-pre-fatur NO-LOCK
        WHERE b-pre-fatur.nome-abrev  = tt-ped-venda.nome-abrev
          AND b-pre-fatur.nr-pedcli   = tt-ped-venda.nr-pedcli
          AND b-pre-fatur.cod-sit-pre = 1 NO-ERROR.
    IF NOT AVAIL b-pre-fatur THEN DO: 
        ASSIGN c-sit-embarque = "Faturado".
        FIND LAST b-pre-fatur NO-LOCK
            WHERE b-pre-fatur.nome-abrev  = tt-ped-venda.nome-abrev
              AND b-pre-fatur.nr-pedcli   = tt-ped-venda.nr-pedcli NO-ERROR.
    END.
    IF AVAIL b-pre-fatur THEN DO:
        IF c-sit-embarque <> "Faturado" THEN
            ASSIGN c-sit-embarque = "Alocado".

        ASSIGN tt-ped-venda.cdd-embarq = b-pre-fatur.cdd-embarq.

        FIND FIRST alc-embarque NO-LOCK
             WHERE alc-embarque.cdd-embarq = b-pre-fatur.cdd-embarq NO-ERROR.
        IF AVAIL alc-embarque THEN
            ASSIGN tt-ped-venda.dt-prevista-embarq = alc-embarque.dt-prevista-embarq.

        FOR EACH it-pre-fat OF b-pre-fatur NO-LOCK:

            FIND FIRST ped-item OF it-pre-fat NO-LOCK NO-ERROR.
            IF AVAIL ped-item THEN
                ASSIGN tt-ped-venda.valor-embarque = tt-ped-venda.valor-embarque + (it-pre-fat.qt-alocada * ped-item.vl-preuni).

            IF c-sit-embarque = "Alocado" THEN DO:
                RUN esp/ales0006.p (INPUT it-pre-fat.it-codigo,                   
                                    INPUT it-pre-fat.qt-alocada,
                                    OUTPUT de-volume,
                                    OUTPUT de-cubagem,
                                    OUTPUT de-peso-bruto,
                                    OUTPUT de-peso-liqui).

                ASSIGN tt-ped-venda.volume     = tt-ped-venda.volume   + de-volume
                       tt-ped-venda.cubagem    = tt-ped-venda.cubagem  + de-cubagem.
            END.
        END.
    END.
    ELSE ASSIGN c-sit-embarque = "Nenhum".

    ASSIGN tt-ped-venda.vl-liq-abe = 0
           tt-ped-venda.vl-liq-ped = 0
           tt-ped-venda.vl-tot-ped = 0.

    FOR EACH ped-item OF ped-venda NO-LOCK:
       
        IF ped-item.cod-sit-item < 3 THEN
            ASSIGN tt-ped-venda.vl-liq-abe = tt-ped-venda.vl-liq-abe + ped-item.vl-merc-abe
                   tt-ped-venda.vl-liq-ped = tt-ped-venda.vl-liq-ped + ped-item.vl-liq-it.

        ASSIGN tt-ped-venda.vl-tot-ped = tt-ped-venda.vl-tot-ped + ped-item.vl-tot-it.

        IF c-sit-embarque <> "Alocado" AND ped-item.cod-sit-item < 3 THEN DO:

            RUN esp/ales0006.p (INPUT ped-item.it-codigo,                   
                                INPUT ped-item.qt-pedida - ped-item.qt-atendida,
                                OUTPUT de-volume,
                                OUTPUT de-cubagem,
                                OUTPUT de-peso-bruto,
                                OUTPUT de-peso-liqui).

            ASSIGN tt-ped-venda.volume     = tt-ped-venda.volume   + de-volume
                   tt-ped-venda.cubagem    = tt-ped-venda.cubagem  + de-cubagem.
        END.

        IF ped-item.cod-sit-item <> 6   AND 
           (ped-item.cod-sit-item  < 3  OR
            ped-item.cod-sit-item  = 5) THEN DO:
            FIND b-item-peso NO-LOCK
                WHERE b-item-peso.it-codigo = ped-item.it-codigo NO-ERROR.
            IF AVAIL b-item-peso THEN
                ASSIGN tt-ped-venda.peso-bruto-ped = tt-ped-venda.peso-bruto-ped + 
                ((ped-item.qt-pedida - ped-item.qt-atendida) * b-item-peso.peso-bruto).
        END.
    END.

    ASSIGN tt-ped-venda.sit-embarque = c-sit-embarque.

    IF AVAIL cond-pagto THEN
        ASSIGN tt-ped-venda.desc-cond-pag = cond-pagto.descricao.
    ELSE
        ASSIGN tt-ped-venda.desc-cond-pag = "N∆o Informado".


    IF NOT tt-ped-venda.completo THEN DO:
        ASSIGN tt-ped-venda.c-setor = "Incompleto".
    END. 
    ELSE IF tt-ped-venda.l_aprov_com = NO OR 
            tt-ped-venda.l_aprov_com = YES AND tt-ped-venda.cod-sit-aval = 4 AND
           (NOT tt-ped-venda.quem-aprovou = "Sistema" AND
            NOT tt-ped-venda.quem-aprovou = "Autom†tico" AND 
            NOT tt-ped-venda.quem-aprovou = "")THEN /* N∆o Aprovados no Comercial e Reprovados Foráadamente fazem parte da Carteira Comercial */
        ASSIGN tt-ped-venda.c-setor = "Comercial".
    ELSE IF cst_ped_venda.i-aprov-contab <> 2 THEN
        ASSIGN tt-ped-venda.c-setor = "Contabilidade".
    ELSE IF tt-ped-venda.cod-sit-aval <> 3 THEN 
        ASSIGN tt-ped-venda.c-setor = "Financeiro".
    ELSE DO:
        IF tt-ped-venda.cod-sit-ped <= 2 THEN
            ASSIGN tt-ped-venda.c-setor = "Log°stica".
        ELSE IF tt-ped-venda.cod-sit-ped = 3 THEN 
            ASSIGN tt-ped-venda.c-setor = "Faturado".
        ELSE
            ASSIGN tt-ped-venda.c-setor = "Outros".
    END.

    ASSIGN tt-ped-venda.lim-credito-tot = emitente.lim-credito + emitente.lim-adicional.

    
    for each tit_acr NO-LOCK where   
        tit_acr.cod_empresa         = v_cod_empres_usuar    AND
        tit_acr.cdn_cliente         = emitente.cod-emitente AND 
        tit_acr.val_sdo_tit_acr    >  0 AND 
        tit_acr.log_tit_acr_estordo = NO:

        if tit_acr.ind_tip_espec_docto =  "Antecipaá∆o" OR 
           tit_acr.ind_tip_espec_docto =  "Nota de CrÇdito"  then
           assign tt-ped-venda.vl-dup-aberto = tt-ped-venda.vl-dup-aberto - tit_acr.val_sdo_tit_acr.
        ELSE 
           assign tt-ped-venda.vl-dup-aberto = tt-ped-venda.vl-dup-aberto + tit_acr.val_sdo_tit_acr.
    END.

    ASSIGN tt-ped-venda.sit-ped-graf = "".
    IF ped-venda.cod-sit-ped = 5 THEN
        ASSIGN tt-ped-venda.sit-ped-graf = "Suspensos".
    ELSE IF cst_ped_venda.l_aprov_com = NO THEN DO:
        ASSIGN tt-ped-venda.sit-ped-graf = "Comercial".
    END.
    ELSE IF cst_ped_venda.l_aprov_com = YES AND ped-venda.cod-sit-aval = 4 AND
           (NOT ped-venda.quem-aprovou = "Sistema" AND
            NOT ped-venda.quem-aprovou = "Autom†tico" AND 
            NOT ped-venda.quem-aprovou = "") THEN DO:
        /* Nío Aprovados no Comercial e Reprovados Forªadamente fazem parte da Carteira Comercial */
        IF cst_ped_venda.lg-lib-separacao THEN
            ASSIGN tt-ped-venda.sit-ped-graf = "Lib.Prod.Aloc".
        ELSE 
            ASSIGN tt-ped-venda.sit-ped-graf = "Reprovados Financeiro".
    END.
    ELSE IF cst_ped_venda.i-aprov-contab <> 2 THEN
        ASSIGN tt-ped-venda.sit-ped-graf = "Contabilidade".
    ELSE IF ped-venda.cod-sit-aval <> 3 THEN 
        ASSIGN tt-ped-venda.sit-ped-graf = "Financeiro".
    ELSE IF ped-venda.cod-sit-ped <= 2 THEN DO: 
        IF tt-ped-venda.sit-ped-logist = 3 THEN ASSIGN tt-ped-venda.sit-ped-graf = "Produá∆o".
        ELSE IF ped-venda.dt-entrega < TODAY THEN ASSIGN tt-ped-venda.sit-ped-graf = "Atrasado".
        ELSE ASSIGN tt-ped-venda.sit-ped-graf = "Log°stica".
    END.
    IF ped-venda.cod-sit-ped = 3 THEN
        ASSIGN tt-ped-venda.sit-ped-graf = "Atend.Total".
    ELSE IF ped-venda.cod-sit-ped = 6 THEN
        ASSIGN tt-ped-venda.sit-ped-graf = "Cancelado".

    /*Gravando ultima data aprovaá∆o antes do financeiro*/
    ASSIGN tt-ped-venda.dt-aprov-com-contab = DATE(cst_ped_venda.dt_hr_aprov_com).
    IF DATE(cst_ped_venda.dt-hr-aprov-contab) <> ? AND (tt-ped-venda.dt-aprov-com-contab = ? OR 
                                                        tt-ped-venda.dt-aprov-com-contab < DATE(cst_ped_venda.dt-hr-aprov-contab)) THEN
        ASSIGN tt-ped-venda.dt-aprov-com-contab = DATE(cst_ped_venda.dt-hr-aprov-contab).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desaprova-com wWindow 
PROCEDURE pi-desaprova-com :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-confirma    AS LOGICAL     NO-UNDO.
    
    FIND FIRST alc-param-usuar NO-LOCK
         WHERE alc-param-usuar.usuario = v_cod_usuar_corren NO-ERROR.
    IF NOT AVAIL alc-param-usuar OR
       (AVAIL alc-param-usuar AND NOT alc-param-usuar.l-desaprova-comercial) THEN DO:
        MESSAGE "Desaprovaá∆o Comercial n∆o permitida!" SKIP
                "Usu†rio sem permiss∆o para desaprovaá∆o comercial de pedidos!"
                "Verifique permiss∆o no ALES0022 ou entre em contato departamento TI."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.
    
    FIND LAST b-pre-fatur NO-LOCK
        WHERE b-pre-fatur.nome-abrev  = tt-ped-venda.nome-abrev
          AND b-pre-fatur.nr-pedcli   = tt-ped-venda.nr-pedcli
          AND b-pre-fatur.cod-sit-pre = 1 NO-ERROR.
    IF AVAIL b-pre-fatur THEN DO:
        MESSAGE "Desaprovaá∆o Comercial n∆o permitida!" SKIP
                "Pedido j† foi alocado no embarque: " b-pre-fatur.cdd-embarq SKIP
                "Ser† necess†rio desalocar pedido para efetuar desaprovaá∆o, entre em contato com departamento Log°stica."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.

    IF CAN-FIND(FIRST alc-natur-oper NO-LOCK 
                WHERE alc-natur-oper.nat-operacao = tt-ped-venda.nat-operacao
                  AND alc-natur-oper.l-pedido-aprov-contab = YES) THEN DO:

        FIND FIRST cst_ped_venda NO-LOCK
             WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
               AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli
               AND cst_ped_venda.i-aprov-contab <> 0 NO-ERROR.
        IF AVAIL cst_ped_venda THEN DO:
            MESSAGE "Desaprovaá∆o Comercial n∆o permitida!" SKIP
                    "Pedido j† foi " (IF cst_ped_venda.i-aprov-contab = 1 THEN "Reprovado" ELSE "Aprovado") " na contabilidade!" SKIP
                    "Ser† necess†rio desaprovaá∆o contabilidade para efetuar desaprovaá∆o comercial, entre em contato departamento Contabilidade."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.
    END.

    RUN pi-obs-motivo (INPUT "Desaprovaá∆o Comercial", OUTPUT c-desc-motivo).
    
    IF c-desc-motivo <> "" THEN DO:
        ASSIGN c-desc-motivo = "Desaprovaá∆o Comercial - " + c-desc-motivo.

        MESSAGE "Confirma Desaprovaá∆o Comercial?" SKIP(1)
                "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
                " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.

        IF l-confirma THEN DO:
            IF tt-ped-venda.cod-sit-ped > 2 THEN DO:
                MESSAGE "Desaprovaá∆o Comercial n∆o permitida!" SKIP
                        "Somente pedidos com situaá∆o (Aberto, Atend.Parcial) podem ser desaprovados!" 
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.

            FIND FIRST cst_ped_venda EXCLUSIVE-LOCK
                 WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
                   AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.
            IF AVAIL cst_ped_venda THEN DO:

                IF NOT cst_ped_venda.l_aprov_com THEN DO:
                    MESSAGE "Pedido j† foi desaprovado pelo comercial."
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                    RELEASE cst_ped_venda NO-ERROR.
                    RETURN "NOK".
                END.
                ELSE DO:
                    ASSIGN cst_ped_venda.l_aprov_com     = NO
                           cst_ped_venda.dt_hr_aprov_com = ?
                           cst_ped_venda.usuar_aprov_com = ""
                           cst_ped_venda.i-aprov-contab     = 0
                           cst_ped_venda.dt-hr-aprov-contab = ?
                           cst_ped_venda.usuar-aprov-contab = "".

                    CREATE histor-pdven .
                    ASSIGN histor-pdven.nom-abrevi-clien = tt-ped-venda.nome-abrev
                           histor-pdven.cod-ped-clien    = tt-ped-venda.nr-pedcli
                           histor-pdven.cod-usuar        = c-seg-usuario
                           histor-pdven.dat-histor       = TODAY
                           histor-pdven.hra-histor       = REPLACE(STRING(TIME,"HH:MM:SS"),":","")
                           histor-pdven.cdn-tip-histor   = 9
                           histor-pdven.cod-classif      = "2"
                           histor-pdven.des-histor       = c-desc-motivo.
                    
                    RELEASE histor-pdven NO-ERROR.
                    RELEASE cst_ped_venda NO-ERROR.

                    MESSAGE "Pedido Desaprovado com sucesso!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RUN pi-carrega-tabelas.
                END.
            END.
            ELSE DO:
                MESSAGE "Erro na Desaprovaá∆o Comercial." SKIP
                        "N∆o encontrado tabela custom para pedido."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-ped wWindow 
PROCEDURE pi-elimina-ped :
/*------------------------------------------------------------------------------
  Purpose: Chama BO de eliminaá∆o de pedidos para eliminar ocorrància atual    
  Notes: Carlos Daniel 28/05/2014 - Chamado 821
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER rwd-ped AS ROWID NO-UNDO.

DEFINE VARIABLE h-bodi159 AS HANDLE NO-UNDO.

EMPTY TEMP-TABLE RowErrors.

RUN dibo/bodi159.p PERSISTENT SET h-bodi159.
            
IF VALID-HANDLE(h-bodi159) THEN DO:
    RUN emptyRowErrors   IN h-bodi159.
    RUN setUserLog       IN h-bodi159(INPUT "super").
    RUN openquerystatic  IN h-bodi159(INPUT "Main":U).
    RUN repositionrecord IN h-bodi159(INPUT rwd-ped).
    RUN deleteRecord     IN h-bodi159.
    RUN getRowErrors     IN h-bodi159(OUTPUT TABLE RowErrors).
END.

IF VALID-HANDLE(h-bodi159) THEN
    DELETE PROCEDURE h-bodi159 NO-ERROR.

IF NOT CAN-FIND(FIRST RowErrors) THEN
    ASSIGN i-contador-ped = i-contador-ped + 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email wWindow 
PROCEDURE pi-envia-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-orc-ped AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-cod-servid-e-mail AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email-remetente   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-num-porta         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-nome-usuario      AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE de-valor            AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-email-repr-secund AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-mensagem          AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.

    IF tt-ped-venda.no-ab-reppri = "ALCAST" THEN DO:
        /*N∆o ser† enviado email para representante ALCAST = 999*/
        RETURN "OK".
    END.

    FOR FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
        ASSIGN c-email-remetente = usuar_mestre.cod_e_mail_local
               c-nome-usuario    = usuar_mestre.nom_usuario.
    END.
    
    FIND FIRST param_email NO-LOCK NO-ERROR.
    IF NOT AVAIL param_email THEN DO:
        MESSAGE "N∆o encontrado parametrizaá∆o de email padr∆o. Entre em contato com TI."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.

    /*FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = tt-ped-venda.cod-estabel,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente:

        ASSIGN c-cod-servid-e-mail = ENTRY(1,TRIM(SUBSTRING(param-nf-estab.cod-livre-2,61,40)),":").

        ASSIGN i-num-porta = INT(ENTRY(2,TRIM(SUBSTRING(param-nf-estab.cod-livre-2,61,40)),":")) NO-ERROR.
    END.*/

    IF c-email-remetente = "" THEN
        ASSIGN c-email-remetente = "rafael.comercial@alcast.com.br".

    ASSIGN de-valor            = IF tt-ped-venda.vl-liq-abe <= 0 THEN tt-ped-venda.vl-tot-ped ELSE tt-ped-venda.vl-liq-abe.
           l-email-repr-secund = IF (p-tipo = "Aprovado" OR p-tipo = "Suspenso" OR p-tipo = "Cancelado" OR p-tipo = "Reativado") THEN YES ELSE NO.

    IF c-email-remetente         <> "" AND
       tt-ped-venda.email-repres <> "" THEN DO:

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

        FOR EACH tt-envio2:     DELETE tt-envio2.   END.
        FOR EACH tt-mensagem:   DELETE tt-mensagem. END.


        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.exchange    = NO
               tt-envio2.servidor    = param_email.cod_servid_e_mail
               tt-envio2.porta       = param_email.num_porta
               tt-envio2.remetente   = c-email-remetente
               tt-envio2.destino     = tt-ped-venda.email-repres + (IF tt-ped-venda.email-repres-secun <> "" AND l-email-repr-secund THEN "," + tt-ped-venda.email-repres-secun ELSE "")
               tt-envio2.copia       = IF tt-ped-venda.email-repres       <> c-email-remetente AND
                                          tt-ped-venda.email-repres-secun <> c-email-remetente THEN (IF c-email-remetente <> "rafael.comercial@alcast.com.br" THEN c-email-remetente ELSE "") ELSE ""
               tt-envio2.assunto     = p-orc-ped + ": " + tt-ped-venda.nr-pedcli + " - (" + p-tipo + ")"
               tt-envio2.importancia = 2
               tt-envio2.log-enviada = YES
               tt-envio2.log-lida    = NO
               tt-envio2.acomp       = NO
               tt-envio2.arq-anexo   = ""
               tt-envio2.formato     = "html".

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = "O " + p-orc-ped + ": " + STRING(tt-ped-venda.nr-pedcli) + " do Cliente: " + tt-ped-venda.nome-emit + 
                                          " no valor de R$ " + TRIM(STRING(de-valor,">>>,>>>,>>9.99")) + 
                                          " foi (" + p-tipo + ") pelos motivos conforme segue abaixo.<BR><BR>".

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 2
               tt-mensagem.mensagem     = "Motivo: " + TRIM(p-motivo) + "<BR><BR>".

        IF p-tipo <> "Reativado"          AND       /*Reativado n∆o envia informaá‰es crÇdito*/
           p-tipo <> "Aprovado"          AND       /*Aprovaá∆o comercial n∆o envia informaá‰es crÇdito*/
           tt-ped-venda.cod-sit-aval  = 4 AND       /*N∆o aprovado*/
           tt-ped-venda.quem-aprovou  <> "Sistema" AND 
           TRIM(tt-ped-venda.desc-bloq-cr) <> "" THEN DO:

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 4
                   tt-mensagem.mensagem     = "Informaá‰es financeiras: " + TRIM(tt-ped-venda.desc-bloq-cr) + "<BR><BR>".

        END.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 4
               tt-mensagem.mensagem     = "Usu†rio: " + TRIM(c-nome-usuario) + "<BR><BR>".

        ASSIGN i-mensagem = 4.

        IF p-tipo = "Cancelado" THEN DO:
            FOR EACH ped-ent NO-LOCK
               WHERE ped-ent.nr-pedcli  = tt-ped-venda.nr-pedcli
                 AND ped-ent.nome-abrev = tt-ped-venda.nome-abrev
                 AND ped-ent.dt-canent = TODAY,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = ped-ent.it-codigo :
                ASSIGN i-mensagem = i-mensagem + 1.

                CREATE tt-mensagem.
                ASSIGN tt-mensagem.seq-mensagem = i-mensagem
                       tt-mensagem.mensagem     = "ITEM: " + ped-ent.it-codigo + "-" + ITEM.DESC-ITEM + 
                                                  " / QT.PEDIDA: " + STRING(ped-ent.qt-pedida) + 
                                                  " / QT.ATEND.: " + STRING(ped-ent.qt-atendida) + 
                                                  " / QT.CANCEL: " + STRING(ped-ent.qt-pedida  - ped-ent.qt-atendida) + "<BR><BR>".
            END.
        END.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = i-mensagem + 1
               tt-mensagem.mensagem     = "Alcast do Brasil Ltda." + "<BR>".

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar IN h-acomp (INPUT "Enviando Email...").
        RUN pi-desabilita-cancela IN h-acomp.
        RUN pi-acompanhar IN h-acomp (INPUT "Para: " + CAPS(tt-ped-venda.email-repres + (IF tt-ped-venda.email-repres-secun <> "" AND l-email-repr-secund THEN "," + tt-ped-venda.email-repres-secun ELSE ""))).

        RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

        IF VALID-HANDLE(h-utapi019) THEN
            DELETE PROCEDURE h-utapi019.

        RUN pi-finalizar IN h-acomp.
        IF NOT CAN-FIND(FIRST tt-erros) THEN DO:
            MESSAGE "Email enviado com sucesso para: " SKIP
                    tt-envio2.destino
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            FOR FIRST tt-erros:
                MESSAGE "Ocorreu erro na tentativa de enviar email. Email n∆o foi enviado para destinat†rio(s)." SKIP
                        "Erro: " tt-erros.cod-erro " - " TRIM(CAPS(tt-erros.desc-erro))                          SKIP
                        "Usu†rio: " c-nome-usuario SKIP 
                        "Data/Hora: " NOW
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel wWindow 
PROCEDURE pi-gera-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcel2  AS COMPONENT-HANDLE NO-UNDO.
    DEFINE VARIABLE chWBook2  AS COMPONENT-HANDLE NO-UNDO.
    DEFINE VARIABLE chWSheet2 AS COMPONENT-HANDLE NO-UNDO.
    
    DEFINE VARIABLE c-arquivo-modelo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo-destino AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-embarques  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-quantidade AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-comis AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-linha      AS INTEGER     NO-UNDO.

    DEFINE VARIABLE de-tot-pago-din AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-val-litr AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-litros   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-despesas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-receitas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-tot-km        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tot-carregado AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-tot-receb    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-pagar    AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE de-chapa-descarg AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-adiant-abaste AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE de-difer-saldo   AS DECIMAL     NO-UNDO.

    ASSIGN de-difer-saldo    = 0
           c-arquivo-modelo  = SEARCH("modelos\CarteiraPedidos.xlsx")
           c-arquivo-destino = "c:\temp\CarteiraPedidos" + STRING(TODAY,"999999") + "-" + STRING(TIME) + ".xlsx".
    
    OS-COPY VALUE(c-arquivo-modelo) VALUE(c-arquivo-destino).
    
    CREATE "Excel.Application" chExcel2 NO-ERROR.

    IF NOT VALID-HANDLE(chExcel2) THEN DO:
        MESSAGE "N∆o Ç possivel gerar gr†fico!" SKIP
                "Para executar essa opá∆o Ç necess†rio ter instalado EXCEL"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.
    
    
    ASSIGN chExcel2:ScreenUpdating = YES
           chExcel2:VISIBLE        = NO.
    
    assign file-info:file-name = c-arquivo-destino. 
    
    chExcel2:WorkBooks:open(file-info:file-name,TRUE). 
    ASSIGN chWBook2  = chExcel2:WorkBooks:ITEM(1)
           chWSheet2 = chWBook2:Sheets:Item(1).
    
    chWSheet2:Activate().
    
    FOR EACH tt-resumo NO-LOCK:
        CASE tt-resumo.c-setor:
            WHEN "Comercial"     THEN ASSIGN chWSheet2:Cells(2,2):Value  = tt-resumo.valor.
            WHEN "Contabilidade" THEN ASSIGN chWSheet2:Cells(3,2):Value  = tt-resumo.valor.
            WHEN "Financeiro"    THEN ASSIGN chWSheet2:Cells(4,2):Value  = tt-resumo.valor.
            WHEN "Log°stica"     THEN ASSIGN de-difer-saldo = tt-resumo.valor
                                             chWSheet2:Cells(5,2):Value  = tt-resumo.valor.
        END CASE.
    END.

    FOR EACH tt-logistica NO-LOCK:
        ASSIGN de-difer-saldo = de-difer-saldo - tt-logistica.valor.
        CASE tt-logistica.situacao:
            WHEN "Nenhum"                           THEN ASSIGN chWSheet2:Cells(2,8):Value  = tt-logistica.valor.
            WHEN "Aguardando Agendamento"           THEN ASSIGN chWSheet2:Cells(3,8):Value  = tt-logistica.valor.
            WHEN "Agendados e/ou Programados"       THEN ASSIGN chWSheet2:Cells(4,8):Value  = tt-logistica.valor.
            WHEN "Aguardando Produá∆o"              THEN ASSIGN chWSheet2:Cells(5,8):Value  = tt-logistica.valor.
            WHEN "Aguardando Complemento Cubagem"   THEN ASSIGN chWSheet2:Cells(6,8):Value  = tt-logistica.valor.
            WHEN "Aguardando Cotaá∆o Frete"         THEN ASSIGN chWSheet2:Cells(7,8):Value  = tt-logistica.valor.
            WHEN "Aguardando Faturamento"           THEN ASSIGN chWSheet2:Cells(8,8):Value  = tt-logistica.valor.
        END CASE.
    END.

    ASSIGN chWSheet2:Cells(9,8):Value  = de-difer-saldo.

    ASSIGN chExcel2:VISIBLE        = YES.
    /*chExcel2:Quit().*/
    
    IF VALID-HANDLE(chWSheet2) THEN
        RELEASE OBJECT chWSheet2.
    
    IF VALID-HANDLE(chWBook2) THEN
        RELEASE OBJECT chWBook2.
    
    IF VALID-HANDLE(chExcel2) THEN
        RELEASE OBJECT chExcel2.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat wWindow 
PROCEDURE pi-gera-relat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE ch-Excel AS COMPONENT-HANDLE   NO-UNDO.
    DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.

    IF NOT AVAIL tt-ped-venda THEN DO:
        MESSAGE "Nenhum pedido selecionado no browse." SKIP
                "Selecione filtros e tente novamente!" 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    ASSIGN c-arquivo-csv = "c:\temp\alpd0003-" + STRING(TODAY,"999999") + "-" +  STRING(TIME) + ".csv".

    OUTPUT TO VALUE(c-arquivo-csv) NO-CONVERT.

    PUT UNFORMATTED
        "Dt.Implant;Nr.Pedido;Situaá∆o Pedido;Estabel;Nome Abrev;Nome Emit;Cidade;UF;Cod.Repres;Nome Repres;Vl.Liq.Aberto;Vl.liq.Pedido;Vl.Tot.Pedido;Nome Matriz;Nat.Oper;EmiteDupl;Cond.Pag;Desc.Cond.Pag;Portador;Dt.Entrega;Setor;Completo;Aprov.Comerc;Aprov.Contab.;Dt.Comer/Contab;Dt.Aprov.Cred;Sit.Aval.Cred.;Aprov.Cred.;Sit.Ped.Graf;Sit.Alocaá∆o;Sit.Log°stica;Nr.Embarque;Dt.Prev.Embarq;Sit.Embarque;Volumes;Cubagem;Vl.Liq.Embarq" SKIP.

    FOR EACH tt-ped-venda NO-LOCK:
        PUT UNFORMATTED
            tt-ped-venda.dt-implant          ";"
            tt-ped-venda.nr-pedcli           ";"
            tt-ped-venda.desc-sit-ped        ";"
            tt-ped-venda.cod-estabel         ";"
            tt-ped-venda.nome-abrev          ";"
            tt-ped-venda.nome-emit           ";"
            tt-ped-venda.cidade              ";"
            tt-ped-venda.estado              ";"
            tt-ped-venda.cod-rep             ";"
            tt-ped-venda.no-ab-rep           ";"
            tt-ped-venda.vl-liq-abe          ";"
            tt-ped-venda.vl-liq-ped          ";"
            tt-ped-venda.vl-tot-ped          ";"
            tt-ped-venda.nome-matriz         ";"
            tt-ped-venda.nat-operacao        ";"
            tt-ped-venda.l-emite-duplic      ";"
            tt-ped-venda.cod-cond-pag        ";"
            tt-ped-venda.desc-cond-pag       ";"
            tt-ped-venda.cod-portador        ";" 
            tt-ped-venda.dt-entrega          ";"
            tt-ped-venda.c-setor             ";"
            tt-ped-venda.completo            ";"
            tt-ped-venda.l_aprov_com         ";"
            tt-ped-venda.desc-aprov-contab   ";"
            tt-ped-venda.dt-aprov-com-contab ";" 
            tt-ped-venda.dt-apr-cred         ";" 
            tt-ped-venda.desc-sit-aval       ";"
            tt-ped-venda.quem-aprovou        ";"
            tt-ped-venda.sit-ped-graf        ";"  
            tt-ped-venda.desc-sit-pre        ";"
            tt-ped-venda.desc-sit-ped-log    ";"
            tt-ped-venda.cdd-embarq          ";"
            tt-ped-venda.dt-prevista-embarq  ";"
            tt-ped-venda.sit-embarque        ";"
            tt-ped-venda.volume              ";"
            tt-ped-venda.cubagem             ";"
            tt-ped-venda.valor-embarque      SKIP.
    END.
    OUTPUT CLOSE.

    CREATE "Excel.Application" ch-Excel NO-ERROR.
    
    IF VALID-HANDLE(ch-Excel) THEN DO:
        RELEASE OBJECT ch-Excel.
        OS-COMMAND NO-WAIT VALUE(c-arquivo-csv).
    END.
    ELSE OS-COMMAND NO-WAIT notepad VALUE(c-arquivo-csv).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lista-clientes-inativos wWindow 
PROCEDURE pi-lista-clientes-inativos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE fi-dt-corte AS DATE FORMAT "99/99/9999"  NO-UNDO.

    DEFINE VARIABLE fi-uf-ini       LIKE emitente.estado   NO-UNDO.
    DEFINE VARIABLE fi-uf-fim       LIKE emitente.estado   NO-UNDO.
    DEFINE VARIABLE fi-cod-rep-ini  LIKE emitente.cod-rep  NO-UNDO.
    DEFINE VARIABLE fi-cod-rep-fim  LIKE emitente.cod-rep  NO-UNDO.

    DEFINE VARIABLE fi-emite-dupli    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-matriz         AS LOGICAL     NO-UNDO.
    
    DEFINE IMAGE IMAGE-1 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-2 FILENAME "image\im-las":U SIZE 3 BY .88. 
    DEFINE IMAGE IMAGE-3 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-4 FILENAME "image\im-las":U SIZE 3 BY .88. 
    
    DEFINE BUTTON btInatCliOk
         LABEL "&Ok" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btInatCliFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtInatCliButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 30 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fInatCliRecord
        fi-dt-corte            AT ROW 1.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 10 BY .88 LABEL "Data Corte"

        fi-uf-ini              AT ROW 2.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88
        IMAGE-1                AT ROW 2.21 COL 18.5
        IMAGE-2                AT ROW 2.21 COL 22
        fi-uf-fim              AT ROW 2.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL

        fi-cod-rep-ini         AT ROW 3.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88
        IMAGE-3                AT ROW 3.21 COL 18.5
        IMAGE-4                AT ROW 3.21 COL 22
        fi-cod-rep-fim         AT ROW 3.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL
        
        l-matriz              AT ROW 4.21 COL 10   COLON-ALIGNED VIEW-AS TOGGLE-BOX  SIZE 20 BY 1 LABEL "Considera Matriz"
        
        fi-emite-dupli         AT ROW 5.21 COL 10   COLON-ALIGNED VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Sim", 1,"N∆o", 2,"Ambos", 3 SIZE 20 BY 1 LABEL "Emite Dupli"
        

        btInatCliOk      AT ROW 7 COL 4
        btInatCliFechar  AT ROW 7 COL 17
        rtInatCliButton  AT ROW 6.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Clientes Inativos " FONT 1
             DEFAULT-BUTTON btInatCliOk.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fInatCliRecord:HANDLE) NO-ERROR.

    ASSIGN fi-dt-corte    = TODAY - 180
           fi-uf-ini      = ""  
           fi-uf-fim      = "ZZZZ"
           fi-cod-rep-ini = 0
           fi-cod-rep-fim = 99999.

    DISP fi-dt-corte    fi-emite-dupli
         fi-uf-ini      fi-uf-fim     
         fi-cod-rep-ini fi-cod-rep-fim
         l-matriz
         WITH FRAME fInatCliRecord. 

    ON "CHOOSE":U OF btInatCliOk IN FRAME fInatCliRecord DO:
        DEFINE VARIABLE ch-Excel      AS COMPONENT-HANDLE   NO-UNDO.
        DEFINE VARIABLE l-achou       AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

        DEFINE VARIABLE c-repres AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-grupo AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE l-fatur AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE dt-fatur AS DATE        NO-UNDO.
        DEFINE VARIABLE c-nr-nota-fis AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-natureza  AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE l-emite-dupli AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE c-nome-matriz AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-tipo-produto   AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-email       AS CHARACTER   NO-UNDO.
        
        DEFINE BUFFER b-emitente FOR emitente.

        ASSIGN INPUT fi-dt-corte fi-uf-ini fi-uf-fim fi-cod-rep-ini fi-cod-rep-fim fi-emite-dupli l-matriz
               c-arquivo-csv = "c:\temp\clientes-inativos-" + STRING(TODAY,"999999") + "-" +  STRING(TIME) + ".csv".        

        run utp/ut-acomp.p persistent set h-acomp.  
        run pi-inicializar in h-acomp (input "Clientes Inativos ...").

        OUTPUT TO VALUE(c-arquivo-csv) NO-CONVERT.

        IF l-matriz THEN DO:
            PUT UNFORMATTED
                "Matriz;Nome Abrev;Nome Matriz;Telefone 1;Telefone 2;Email;Estado;Cidade;Grupo;Desc.Grupo;Fatur;Dt.Ult.Fatur;Nota Fiscal;Estab;Natureza;Emite Duplicata;Cod.Rep;Nome Repres;Tipo Produto" SKIP.

            FOR EACH emitente NO-LOCK
               WHERE emitente.identific <> 2
                 AND emitente.natureza  <> 1
                 AND emitente.nome-matriz = emitente.nome-abrev
                 AND emitente.estado  >= fi-uf-ini     
                 AND emitente.estado  <= fi-uf-fim     
                 AND emitente.cod-rep >= fi-cod-rep-ini
                 AND emitente.cod-rep <= fi-cod-rep-fim:

                FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.

                FIND FIRST repres NO-LOCK WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.

                RUN pi-acompanhar IN h-acomp (INPUT "Cliente: " + STRING(emitente.cod-emitente)).

                ASSIGN c-grupo = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                       c-email = TRIM(REPLACE(REPLACE(REPLACE(emitente.e-mail,";",","),CHR(13),""),CHR(10),""))
                       c-repres = IF AVAIL repres THEN repres.nome ELSE ""
                       l-fatur = NO
                       dt-fatur = ?
                       c-cod-estab = ""
                       c-natureza  = ""
                       c-nr-nota-fis = ""
                       l-emite-dupli = NO.

                FOR LAST nota-fiscal NO-LOCK
                   WHERE nota-fiscal.nome-ab-cli  = emitente.nome-matriz
                     AND nota-fiscal.dt-emis-nota  > fi-dt-corte
                     AND (IF fi-emite-dupli = 3 THEN TRUE
                          ELSE nota-fiscal.emite-dupli = (fi-emite-dupli = 1)):
                END.
                IF NOT AVAIL nota-fiscal THEN DO:
                    FOR LAST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.nome-ab-cli   = emitente.nome-matriz
                         AND nota-fiscal.dt-emis-nota  <= fi-dt-corte
                         AND (IF fi-emite-dupli = 3 THEN TRUE
                              ELSE nota-fiscal.emite-dupli = (fi-emite-dupli = 1)):
                        ASSIGN l-achou = YES 
                               l-fatur = YES
                               dt-fatur = nota-fiscal.dt-emis-nota
                               c-nr-nota-fis = nota-fiscal.nr-nota-fis
                               c-cod-estab = nota-fiscal.cod-estabel
                               c-natureza  = nota-fiscal.nat-operacao
                               l-emite-dupli = nota-fiscal.emite-duplic.

                        ASSIGN c-tipo-produto = "".
                        FOR LAST it-nota-fisc OF nota-fiscal NO-LOCK:
                            IF INDEX(it-nota-fisc.it-codigo,".") = 0 AND it-nota-fisc.it-codigo >= "1" AND it-nota-fisc.it-codigo <= "5z" AND it-nota-fisc.cod-unid-negoc = "02" THEN DO:
                                CASE SUBSTRING(it-nota-fisc.it-codigo,2,1):
                                    WHEN "1" THEN ASSIGN c-tipo-produto = "BOBINAS".
                                    WHEN "2" THEN ASSIGN c-tipo-produto = "DISCOS".
                                    WHEN "3" THEN ASSIGN c-tipo-produto = "CHAPAS/BLANK".
                                    WHEN "4" THEN ASSIGN c-tipo-produto = "TELHAS".
                                    WHEN "5" THEN ASSIGN c-tipo-produto = "FOLHAS".
                                    WHEN "6" THEN ASSIGN c-tipo-produto = "TAMPAS".
                                END CASE.
                            END. 
                        END.

                        PUT UNFORMATTED 
                             emitente.nome-matriz ";"
                             emitente.nome-abrev  ";"
                             REPLACE(emitente.nome-emit,";",",")    ";"
                             REPLACE(emitente.telefone[1],";",",")  ";"
                             REPLACE(emitente.telefone[2],";",",")  ";"
                             c-email               ";"
                             emitente.estado       ";"
                             REPLACE(emitente.cidade,";",",")       ";"
                             emitente.cod-gr-cli   ";"
                             c-grupo               ";"
                             l-fatur               ";"
                             dt-fatur              ";"
                             c-nr-nota-fis         ";" 
                             c-cod-estab           ";"
                             c-natureza            ";"
                             l-emite-dupli         ";"
                             emitente.cod-rep      ";"
                             c-repres              ";"
                             c-tipo-produto        SKIP.
                    END.
                END.
            END.
        END.
        ELSE DO:
            PUT UNFORMATTED
                "Cliente;Nome Abrev;Nome Cliente;Matriz;Nome Matriz;Telefone 1;Telefone 2;Email;Estado;Cidade;Grupo;Desc.Grupo;Fatur;Dt.Ult.Fatur;Nota Fiscal;Estab;Natureza;Emite Duplicata;Cod.Rep;Nome Repres;Tipo Produto" SKIP.

            FOR EACH emitente NO-LOCK
               WHERE emitente.identific <> 2
                 AND emitente.natureza  <> 1
                 AND emitente.estado  >= fi-uf-ini     
                 AND emitente.estado  <= fi-uf-fim     
                 AND emitente.cod-rep >= fi-cod-rep-ini
                 AND emitente.cod-rep <= fi-cod-rep-fim:

                FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.

                FIND FIRST repres NO-LOCK WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.

                FIND FIRST b-emitente NO-LOCK WHERE b-emitente.nome-abrev = emitente.nome-abrev NO-ERROR.

                RUN pi-acompanhar IN h-acomp (INPUT "Cliente: " + STRING(emitente.cod-emitente)).

                ASSIGN c-grupo = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                       c-repres = IF AVAIL repres THEN repres.nome ELSE ""
                       c-email       = TRIM(REPLACE(REPLACE(REPLACE(emitente.e-mail,";",","),CHR(13),""),CHR(10),""))
                       c-nome-matriz = IF AVAIL b-emitente THEN emitente.nome-emit ELSE ""
                       l-fatur = NO
                       dt-fatur = ?
                       c-cod-estab = ""
                       c-natureza  = ""
                       c-nr-nota-fis = ""
                       l-emite-dupli = NO.
                       
                FOR LAST nota-fiscal NO-LOCK
                   WHERE nota-fiscal.cod-emitente  = emitente.cod-emitente
                     AND nota-fiscal.dt-emis-nota  > fi-dt-corte
                     AND (IF fi-emite-dupli = 3 THEN TRUE
                          ELSE nota-fiscal.emite-dupli = (fi-emite-dupli = 1)):
                END.
                IF NOT AVAIL nota-fiscal THEN DO:
                    FOR LAST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-emitente   = emitente.cod-emitente
                         AND nota-fiscal.dt-emis-nota  <= fi-dt-corte
                         AND (IF fi-emite-dupli = 3 THEN TRUE
                              ELSE nota-fiscal.emite-dupli = (fi-emite-dupli = 1)):
                        ASSIGN l-achou = YES 
                               l-fatur = YES
                               dt-fatur = nota-fiscal.dt-emis-nota
                               c-nr-nota-fis = nota-fiscal.nr-nota-fis
                               c-cod-estab = nota-fiscal.cod-estabel
                               c-natureza  = nota-fiscal.nat-operacao
                               l-emite-dupli = nota-fiscal.emite-duplic.

                        ASSIGN c-tipo-produto = "".
                        FOR LAST it-nota-fisc OF nota-fiscal NO-LOCK:
                            IF INDEX(it-nota-fisc.it-codigo,".") = 0 AND it-nota-fisc.it-codigo >= "1" AND it-nota-fisc.it-codigo <= "5z" AND it-nota-fisc.cod-unid-negoc = "02" THEN DO:
                                CASE SUBSTRING(it-nota-fisc.it-codigo,2,1):
                                    WHEN "1" THEN ASSIGN c-tipo-produto = "BOBINAS".
                                    WHEN "2" THEN ASSIGN c-tipo-produto = "DISCOS".
                                    WHEN "3" THEN ASSIGN c-tipo-produto = "CHAPAS/BLANK".
                                    WHEN "4" THEN ASSIGN c-tipo-produto = "TELHAS".
                                    WHEN "5" THEN ASSIGN c-tipo-produto = "FOLHAS".
                                    WHEN "6" THEN ASSIGN c-tipo-produto = "TAMPAS".
                                END CASE.
                            END. 
                        END.

                        PUT UNFORMATTED 
                             emitente.cod-emitente ";"
                             emitente.nome-abrev   ";"
                             REPLACE(emitente.nome-emit,";",",")    ";"
                             emitente.nome-matriz  ";"
                             c-nome-matriz         ";"
                             REPLACE(emitente.telefone[1],";",",")  ";"
                             REPLACE(emitente.telefone[2],";",",")  ";"
                             c-email               ";"
                             emitente.estado       ";"
                             REPLACE(emitente.cidade,";",",")       ";"
                             emitente.cod-gr-cli   ";"
                             c-grupo               ";"
                             l-fatur               ";"
                             dt-fatur              ";"
                             c-nr-nota-fis         ";" 
                             c-cod-estab           ";"
                             c-natureza            ";"
                             l-emite-dupli         ";"
                             emitente.cod-rep      ";"
                             c-repres              ";"
                             c-tipo-produto        SKIP.
                    END.
                END.
            END.
        END.
        OUTPUT CLOSE.


        run pi-finalizar in h-acomp.

        OUTPUT CLOSE.

        IF l-achou THEN DO:
            CREATE "Excel.Application" ch-Excel NO-ERROR.
            IF VALID-HANDLE(ch-Excel) THEN DO:
                RELEASE OBJECT ch-Excel.
                OS-COMMAND NO-WAIT VALUE(c-arquivo-csv).
            END.
            ELSE OS-COMMAND NO-WAIT notepad VALUE(c-arquivo-csv).
        END.
        ELSE
            MESSAGE "Nenhum cliente inativo para filtro!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        APPLY "GO":U TO FRAME fInatCliRecord.
    END.
    
    ON "CHOOSE":U OF btInatCliFechar IN FRAME fInatCliRecord DO:
        APPLY "GO":U TO FRAME fInatCliRecord.
    END.
    ENABLE fi-dt-corte    fi-emite-dupli
           fi-uf-ini      fi-uf-fim     
           fi-cod-rep-ini fi-cod-rep-fim
           l-matriz
           btInatCliOk
           btInatCliFechar
        WITH FRAME fInatCliRecord. 
    
    WAIT-FOR "GO":U OF FRAME fInatCliRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lista-limite-credito wWindow 
PROCEDURE pi-lista-limite-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE fi-uf-ini       LIKE emitente.estado   NO-UNDO.
    DEFINE VARIABLE fi-uf-fim       LIKE emitente.estado   NO-UNDO.
    DEFINE VARIABLE fi-cod-estabel-ini  LIKE it-nota-fisc.cod-estabel  NO-UNDO.
    DEFINE VARIABLE fi-cod-estabel-fim  LIKE it-nota-fisc.cod-estabel  NO-UNDO.
    DEFINE VARIABLE fi-cod-unid-negoc-ini  LIKE it-nota-fisc.cod-unid-negoc  NO-UNDO.
    DEFINE VARIABLE fi-cod-unid-negoc-fim  LIKE it-nota-fisc.cod-unid-negoc  NO-UNDO.
    DEFINE VARIABLE fi-cod-rep-ini  LIKE emitente.cod-rep  NO-UNDO.
    DEFINE VARIABLE fi-cod-rep-fim  LIKE emitente.cod-rep  NO-UNDO.

    DEFINE VARIABLE fi-emite-dupli    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-matriz          AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-movimentos      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-limite         AS LOGICAL     NO-UNDO.
    
    DEFINE IMAGE IMAGE-1 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-2 FILENAME "image\im-las":U SIZE 3 BY .88. 
    DEFINE IMAGE IMAGE-3 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-4 FILENAME "image\im-las":U SIZE 3 BY .88. 
    DEFINE IMAGE IMAGE-5 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-6 FILENAME "image\im-las":U SIZE 3 BY .88. 
    DEFINE IMAGE IMAGE-7 FILENAME "image\im-fir":U SIZE 3 BY .88.
    DEFINE IMAGE IMAGE-8 FILENAME "image\im-las":U SIZE 3 BY .88. 
    
    DEFINE BUTTON btCliLimCreOk
         LABEL "&Ok" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btCliLimCreFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtCliLimCreButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 30 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fCliLimCreRecord
        fi-uf-ini              AT ROW 1.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88
        IMAGE-1                AT ROW 1.21 COL 18.5
        IMAGE-2                AT ROW 1.21 COL 22
        fi-uf-fim              AT ROW 1.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL

        fi-cod-estabel-ini     AT ROW 2.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 LABEL "Estabel"
        IMAGE-3                AT ROW 2.21 COL 18.5
        IMAGE-4                AT ROW 2.21 COL 22
        fi-cod-estabel-fim     AT ROW 2.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL

        fi-cod-unid-negoc-ini  AT ROW 3.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 LABEL "Unid.Negoc."
        IMAGE-5                AT ROW 3.21 COL 18.5
        IMAGE-6                AT ROW 3.21 COL 22
        fi-cod-unid-negoc-fim  AT ROW 3.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL

        fi-cod-rep-ini         AT ROW 4.21 COL 10   COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88
        IMAGE-7                AT ROW 4.21 COL 18.5
        IMAGE-8                AT ROW 4.21 COL 22
        fi-cod-rep-fim         AT ROW 4.21 COL 23.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6 BY .88 NO-LABEL
        
        l-limite              AT ROW 5.21 COL 10   COLON-ALIGNED VIEW-AS TOGGLE-BOX  SIZE 20 BY 1 LABEL "Somente com limite"
        l-movimentos          AT ROW 6.21 COL 10   COLON-ALIGNED VIEW-AS TOGGLE-BOX  SIZE 20 BY 1 LABEL "Somente com movimentos"
        l-matriz              AT ROW 7.21 COL 10   COLON-ALIGNED VIEW-AS TOGGLE-BOX  SIZE 20 BY 1 LABEL "Considera Matriz Cliente"
        
        fi-emite-dupli         AT ROW 8.21 COL 10   COLON-ALIGNED VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Sim", 1,"N∆o", 2,"Ambos", 3 SIZE 20 BY 1 LABEL "Emite Dupli"
        

        btCliLimCreOk      AT ROW 9 COL 4
        btCliLimCreFechar  AT ROW 9 COL 17
        rtCliLimCreButton  AT ROW 8.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Clientes Limite Credito " FONT 1
             DEFAULT-BUTTON btCliLimCreOk.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fCliLimCreRecord:HANDLE) NO-ERROR.

    ASSIGN fi-uf-ini      = ""  
           fi-uf-fim      = "ZZZZ"
           fi-cod-estabel-ini = ""
           fi-cod-estabel-fim = "ZZ"
           fi-cod-unid-negoc-ini = ""
           fi-cod-unid-negoc-fim = "ZZ"
           fi-cod-rep-ini = 0
           fi-cod-rep-fim = 99999.

    DISP fi-emite-dupli
         fi-uf-ini      fi-uf-fim     
         fi-cod-estabel-ini fi-cod-estabel-fim 
         fi-cod-unid-negoc-ini fi-cod-unid-negoc-fim 
         fi-cod-rep-ini fi-cod-rep-fim
         l-limite l-movimentos l-matriz
         WITH FRAME fCliLimCreRecord. 

    ON "CHOOSE":U OF btCliLimCreOk IN FRAME fCliLimCreRecord DO:
        DEFINE VARIABLE ch-Excel      AS COMPONENT-HANDLE   NO-UNDO.
        DEFINE VARIABLE l-achou       AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

        DEFINE VARIABLE c-repres AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-grupo AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE l-fatur AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE dt-fatur AS DATE        NO-UNDO.
        DEFINE VARIABLE c-nr-nota-fis AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-natureza  AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE l-emite-dupli AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE c-nome-matriz AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-tipo-produto   AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-it-codigo      AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-email       AS CHARACTER   NO-UNDO.
        
        DEFINE VARIABLE de-aberto AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-atraso AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-vl-pedidos AS DECIMAL NO-UNDO.

        DEFINE BUFFER b-emitente FOR emitente.

        ASSIGN INPUT fi-uf-ini fi-uf-fim fi-cod-estabel-ini fi-cod-estabel-fim fi-cod-unid-negoc-ini fi-cod-unid-negoc-fim fi-cod-rep-ini fi-cod-rep-fim fi-emite-dupli l-limite l-movimentos l-matriz
               c-arquivo-csv = SESSION:TEMP-DIRECTORY + "clientes-limcred-" + STRING(TODAY,"999999") + "-" +  STRING(TIME) + ".csv".        

        run utp/ut-acomp.p persistent set h-acomp.  
        run pi-inicializar in h-acomp (input "Clientes Limite Credito ...").

        OUTPUT TO VALUE(c-arquivo-csv) NO-CONVERT.

        IF l-matriz THEN DO:
            PUT UNFORMATTED
                "Matriz;Nome Abrev;Nome Matriz;Telefone 1;Telefone 2;Email;Estado;Cidade;Grupo;Desc.Grupo;Fatur;Limite Credito;Titulos Abertos;Titulos Atrasados;Pedidos Abertos;Saldo Credito;Dt.Ult.Fatur;Nota Fiscal;Estab;Natureza;Emite Duplicata;Cod.Rep;Nome Repres;Tipo Produto;Desc.Item" SKIP.

            FOR EACH emitente NO-LOCK
               WHERE emitente.identific <> 2
                 AND emitente.natureza  <> 1
                 AND emitente.nome-matriz = emitente.nome-abrev
                 AND emitente.estado  >= fi-uf-ini     
                 AND emitente.estado  <= fi-uf-fim     
                 AND emitente.cod-rep >= fi-cod-rep-ini
                 AND emitente.cod-rep <= fi-cod-rep-fim
                BY emitente.cod-emitente:

                FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.

                FIND FIRST repres NO-LOCK WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.

                RUN pi-acompanhar IN h-acomp (INPUT "Cliente: " + STRING(emitente.cod-emitente)).

                IF l-limite AND emitente.lim-credito + emitente.lim-adicional = 0 THEN NEXT.

                ASSIGN c-grupo = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                       c-email = TRIM(REPLACE(REPLACE(REPLACE(emitente.e-mail,";",","),CHR(13),""),CHR(10),""))
                       c-repres = IF AVAIL repres THEN repres.nome ELSE ""
                       l-fatur = NO
                       dt-fatur = ?
                       c-cod-estab = ""
                       c-natureza  = ""
                       c-nr-nota-fis = ""
                       c-tipo-produto = ""
                       c-it-codigo    = ""
                       l-emite-dupli = NO
                       de-aberto = 0
                       de-atraso = 0
                       de-vl-pedidos = 0. 

                FOR LAST it-nota-fisc NO-LOCK
                   WHERE it-nota-fisc.nome-ab-cli  = emitente.nome-matriz
                     AND it-nota-fisc.cod-estabel    >= fi-cod-estabel-ini
                     AND it-nota-fisc.cod-estabel    <= fi-cod-estabel-fim
                     AND it-nota-fisc.cod-unid-negoc >= fi-cod-unid-negoc-ini
                     AND it-nota-fisc.cod-unid-negoc <= fi-cod-unid-negoc-fim
                     AND it-nota-fisc.dt-cancela      = ?
                     AND (IF fi-emite-dupli = 3 THEN TRUE ELSE it-nota-fisc.emite-dupli = (fi-emite-dupli = 1)),
                   FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
                   ASSIGN l-achou = YES 
                          l-fatur = YES
                          dt-fatur = it-nota-fisc.dt-emis-nota
                          c-nr-nota-fis = it-nota-fisc.nr-nota-fis
                          c-cod-estab = it-nota-fisc.cod-estabel
                          c-natureza  = it-nota-fisc.nat-operacao
                          l-emite-dupli = it-nota-fisc.emite-duplic.

                   
                   IF INDEX(it-nota-fisc.it-codigo,".") = 0 AND it-nota-fisc.it-codigo >= "1" AND it-nota-fisc.it-codigo <= "5z" AND it-nota-fisc.cod-unid-negoc = "02" THEN DO:
                       CASE SUBSTRING(it-nota-fisc.it-codigo,2,1):
                           WHEN "1" THEN ASSIGN c-tipo-produto = "BOBINAS".
                           WHEN "2" THEN ASSIGN c-tipo-produto = "DISCOS".
                           WHEN "3" THEN ASSIGN c-tipo-produto = "CHAPAS/BLANK".
                           WHEN "4" THEN ASSIGN c-tipo-produto = "TELHAS".
                           WHEN "5" THEN ASSIGN c-tipo-produto = "FOLHAS".
                           WHEN "6" THEN ASSIGN c-tipo-produto = "TAMPAS".
                       END CASE.
                   END.
                   ASSIGN c-it-codigo = STRING(ITEM.ge-codigo) + " - " + item.it-codigo + " - " + item.desc-item.
                END.

                FOR EACH estabelec NO-LOCK
                   WHERE estabelec.cod-estabel      >= fi-cod-estabel-ini
                     AND estabelec.cod-estabel      <= fi-cod-estabel-fim,
                    EACH tit_acr NO-LOCK
                   WHERE tit_acr.cod_estab           = estabelec.cod-estabel
                     AND tit_acr.cdn_cliente         = emitente.cod-emitente
                     AND tit_acr.val_sdo_tit_acr      > 0
                     AND tit_acr.ind_tip_espec_docto = "Normal"
                     AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:

                    ASSIGN de-aberto = de-aberto + tit_acr.val_sdo_tit_acr.

                    IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN 
                        ASSIGN de-atraso = de-atraso + tit_acr.val_sdo_tit_acr.

                END.

                FOR EACH ped-item NO-LOCK
                   WHERE ped-item.nome-abrev = emitente.nome-matriz
                     AND ped-item.cod-sit-item <= 2
                     AND ped-item.cod-unid-negoc >= fi-cod-unid-negoc-ini
                     AND ped-item.cod-unid-negoc <= fi-cod-unid-negoc-fim,
                   FIRST ped-venda OF ped-item NO-LOCK
                   WHERE ped-venda.completo
                     AND ped-venda.cod-estabel    >= fi-cod-estabel-ini
                     AND ped-venda.cod-estabel    <= fi-cod-estabel-fim:
                    ASSIGN de-vl-pedidos = de-vl-pedidos + ped-item.vl-liq-abe.
                END.

                IF l-movimentos AND  (de-aberto + de-atraso + de-vl-pedidos = 0) THEN NEXT.

                PUT UNFORMATTED 
                     emitente.nome-matriz ";"
                     emitente.nome-abrev  ";"
                     REPLACE(emitente.nome-emit,";",",")    ";"
                     REPLACE(emitente.telefone[1],";",",")  ";"
                     REPLACE(emitente.telefone[2],";",",")  ";"
                     c-email               ";"
                     emitente.estado       ";"
                     REPLACE(emitente.cidade,";",",")       ";"
                     emitente.cod-gr-cli   ";"
                     c-grupo               ";"
                     l-fatur               ";"
                     emitente.lim-credito + emitente.lim-adicional ";"
                     de-aberto             ";"
                     de-atraso             ";"
                     de-vl-pedidos         ";"
                     (emitente.lim-credito + emitente.lim-adicional) - (de-aberto + de-vl-pedidos) ";"
                     dt-fatur              ";"
                     c-nr-nota-fis         ";" 
                     c-cod-estab           ";"
                     c-natureza            ";"
                     l-emite-dupli         ";"
                     emitente.cod-rep      ";"
                     c-repres              ";"
                     c-tipo-produto        ";"
                     c-it-codigo           SKIP.
            END.
        END.
        ELSE DO:
            PUT UNFORMATTED
                "Cliente;Nome Abrev;Nome Cliente;Matriz;Nome Matriz;Telefone 1;Telefone 2;Email;Estado;Cidade;Grupo;Desc.Grupo;Fatur;Limite Credito;Titulos Abertos;Titulos Atrasados;Pedidos Abertos;Saldo Credito;Dt.Ult.Fatur;Nota Fiscal;Estab;Natureza;Emite Duplicata;Cod.Rep;Nome Repres;Tipo Produto;Desc.Item" SKIP.

            FOR EACH emitente NO-LOCK
               WHERE emitente.identific <> 2
                 AND emitente.natureza  <> 1
                 AND emitente.estado  >= fi-uf-ini     
                 AND emitente.estado  <= fi-uf-fim     
                 AND emitente.cod-rep >= fi-cod-rep-ini
                 AND emitente.cod-rep <= fi-cod-rep-fim
                BY emitente.cod-emitente:

                FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.

                FIND FIRST repres NO-LOCK WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.

                FIND FIRST b-emitente NO-LOCK WHERE b-emitente.nome-abrev = emitente.nome-abrev NO-ERROR.

                RUN pi-acompanhar IN h-acomp (INPUT "Cliente: " + STRING(emitente.cod-emitente)).

                IF l-limite AND emitente.lim-credito + emitente.lim-adicional = 0 THEN NEXT.

                ASSIGN c-grupo       = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                       c-repres      = IF AVAIL repres THEN repres.nome ELSE ""
                       c-email       = TRIM(REPLACE(REPLACE(REPLACE(emitente.e-mail,";",","),CHR(13),""),CHR(10),""))
                       c-nome-matriz = IF AVAIL b-emitente THEN emitente.nome-emit ELSE ""
                       l-fatur       = NO
                       dt-fatur      = ?
                       c-cod-estab   = ""
                       c-natureza    = ""
                       c-nr-nota-fis = ""
                       c-tipo-produto = ""
                       c-it-codigo    = ""
                       l-emite-dupli = NO
                       de-aberto = 0
                       de-atraso = 0
                       de-vl-pedidos = 0. 

                FOR LAST it-nota-fisc NO-LOCK
                   WHERE it-nota-fisc.nome-ab-cli  = emitente.nome-abrev
                     AND it-nota-fisc.cod-estabel    >= fi-cod-estabel-ini
                     AND it-nota-fisc.cod-estabel    <= fi-cod-estabel-fim
                     AND it-nota-fisc.cod-unid-negoc >= fi-cod-unid-negoc-ini
                     AND it-nota-fisc.cod-unid-negoc <= fi-cod-unid-negoc-fim
                     AND it-nota-fisc.dt-cancela      = ?
                     AND (IF fi-emite-dupli = 3 THEN TRUE ELSE it-nota-fisc.emite-dupli = (fi-emite-dupli = 1)),
                    FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
                    ASSIGN l-achou = YES 
                           l-fatur = YES
                           dt-fatur = it-nota-fisc.dt-emis-nota
                           c-nr-nota-fis = it-nota-fisc.nr-nota-fis
                           c-cod-estab = it-nota-fisc.cod-estabel
                           c-natureza  = it-nota-fisc.nat-operacao
                           l-emite-dupli = it-nota-fisc.emite-duplic.

                    IF INDEX(it-nota-fisc.it-codigo,".") = 0 AND it-nota-fisc.it-codigo >= "1" AND it-nota-fisc.it-codigo <= "5z" AND it-nota-fisc.cod-unid-negoc = "02" THEN DO:
                        CASE SUBSTRING(it-nota-fisc.it-codigo,2,1):
                            WHEN "1" THEN ASSIGN c-tipo-produto = "BOBINAS".
                            WHEN "2" THEN ASSIGN c-tipo-produto = "DISCOS".
                            WHEN "3" THEN ASSIGN c-tipo-produto = "CHAPAS/BLANK".
                            WHEN "4" THEN ASSIGN c-tipo-produto = "TELHAS".
                            WHEN "5" THEN ASSIGN c-tipo-produto = "FOLHAS".
                            WHEN "6" THEN ASSIGN c-tipo-produto = "TAMPAS".
                        END CASE.
                    END. 
                    ASSIGN c-it-codigo = STRING(ITEM.ge-codigo) + " - " + item.it-codigo + " - " + item.desc-item.
                END.

                FOR EACH estabelec NO-LOCK
                   WHERE estabelec.cod-estabel      >= fi-cod-estabel-ini
                     AND estabelec.cod-estabel      <= fi-cod-estabel-fim,
                    EACH tit_acr NO-LOCK
                   WHERE tit_acr.cod_estab           = estabelec.cod-estabel
                     AND tit_acr.cdn_cliente         = emitente.cod-emitente
                     AND tit_acr.val_sdo_tit_acr      > 0
                     AND tit_acr.ind_tip_espec_docto = "Normal"
                     AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:

                    ASSIGN de-aberto = de-aberto + tit_acr.val_sdo_tit_acr.

                    IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN 
                        ASSIGN de-atraso = de-atraso + tit_acr.val_sdo_tit_acr.

                END.

                FOR EACH ped-item NO-LOCK
                   WHERE ped-item.nome-abrev = emitente.nome-abrev
                     AND ped-item.cod-sit-item <= 2
                     AND ped-item.cod-unid-negoc >= fi-cod-unid-negoc-ini
                     AND ped-item.cod-unid-negoc <= fi-cod-unid-negoc-fim,
                   FIRST ped-venda OF ped-item NO-LOCK
                   WHERE ped-venda.completo
                     AND ped-venda.cod-estabel    >= fi-cod-estabel-ini
                     AND ped-venda.cod-estabel    <= fi-cod-estabel-fim:
                    ASSIGN de-vl-pedidos = de-vl-pedidos + ped-item.vl-liq-abe.
                END.

                IF l-movimentos AND  (de-aberto + de-atraso + de-vl-pedidos = 0) THEN NEXT.

                PUT UNFORMATTED 
                     emitente.cod-emitente ";"
                     emitente.nome-abrev   ";"
                     REPLACE(emitente.nome-emit,";",",")    ";"
                     emitente.nome-matriz  ";"
                     c-nome-matriz         ";"
                     REPLACE(emitente.telefone[1],";",",")  ";"
                     REPLACE(emitente.telefone[2],";",",")  ";"
                     c-email               ";"
                     emitente.estado       ";"
                     REPLACE(emitente.cidade,";",",")       ";"
                     emitente.cod-gr-cli   ";"
                     c-grupo               ";"
                     l-fatur               ";"
                     emitente.lim-credito + emitente.lim-adicional ";"
                     de-aberto             ";"
                     de-atraso             ";" 
                     de-vl-pedidos         ";"
                     (emitente.lim-credito + emitente.lim-adicional) - (de-aberto + de-vl-pedidos) ";"
                     dt-fatur              ";"
                     c-nr-nota-fis         ";" 
                     c-cod-estab           ";"
                     c-natureza            ";"
                     l-emite-dupli         ";"
                     emitente.cod-rep      ";"
                     c-repres              ";"
                     c-tipo-produto        ";"
                     c-it-codigo           SKIP.

            END.
        END.
        OUTPUT CLOSE.

        run pi-finalizar in h-acomp.

        OUTPUT CLOSE.

        IF l-achou THEN DO:
            CREATE "Excel.Application" ch-Excel NO-ERROR.
            IF VALID-HANDLE(ch-Excel) THEN DO:
                RELEASE OBJECT ch-Excel.
                OS-COMMAND NO-WAIT VALUE(c-arquivo-csv).
            END.
            ELSE OS-COMMAND NO-WAIT notepad VALUE(c-arquivo-csv).
        END.
        ELSE
            MESSAGE "Nenhum cliente para filtro!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        APPLY "GO":U TO FRAME fCliLimCreRecord.
    END.
    
    ON "CHOOSE":U OF btCliLimCreFechar IN FRAME fCliLimCreRecord DO:
        APPLY "GO":U TO FRAME fCliLimCreRecord.
    END.
    ENABLE fi-uf-ini      fi-uf-fim     
           fi-cod-estabel-ini fi-cod-estabel-fim 
           fi-cod-unid-negoc-ini fi-cod-unid-negoc-fim 
           fi-cod-rep-ini fi-cod-rep-fim
           l-limite l-movimentos  l-matriz  fi-emite-dupli
           btCliLimCreOk
           btCliLimCreFechar
        WITH FRAME fCliLimCreRecord. 
    
    WAIT-FOR "GO":U OF FRAME fCliLimCreRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lista-pedidos-cancelados wWindow 
PROCEDURE pi-lista-pedidos-cancelados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fi-dt-corte AS DATE FORMAT "99/99/9999"  NO-UNDO.

    DEFINE BUTTON btPedCancOk
         LABEL "&Ok" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btPedCancFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtPedCancButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 25 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fPedCancRecord
        fi-dt-corte      AT ROW 1.21 COL 10 COLON-ALIGNED VIEW-AS FILL-IN SIZE 14 BY .88 LABEL "Data Corte"
        btPedCancOk      AT ROW 3 COL 2.14
        btPedCancFechar  AT ROW 3 COL 13
        rtPedCancButton  AT ROW 2.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Data Corte " FONT 1
             DEFAULT-BUTTON btPedCancOk.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fPedCancRecord:HANDLE) NO-ERROR.

    ASSIGN fi-dt-corte = TODAY - 180.

    DISP fi-dt-corte WITH FRAME fPedCancRecord. 

    ON "CHOOSE":U OF btPedCancOk IN FRAME fPedCancRecord DO:
        DEFINE VARIABLE ch-Excel      AS COMPONENT-HANDLE   NO-UNDO.
        DEFINE VARIABLE l-achou       AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE i-repres      AS INTEGER     NO-UNDO.
        DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

        ASSIGN INPUT fi-dt-corte
               c-arquivo-csv = "c:\temp\alpd0003-cancel-" + STRING(TODAY,"999999") + "-" +  STRING(TIME) + ".csv".        


        run utp/ut-acomp.p persistent set h-acomp.  
        run pi-inicializar in h-acomp (input "Pedidos Cancelados...").

        OUTPUT TO VALUE(c-arquivo-csv) NO-CONVERT.

        PUT UNFORMATTED
            "Nr.Pedido;Nr.Pecli;Item;Desc.Item;Motivo;Desc.Motivo;Quantidade;Valor Cancelado;Vl.Liq.Item;Vl.Tot.Item;Cliente;Nome Emit;Repres;Dt.Inclusío;Dt.Cancelamento;Obs.Cancel;" SKIP.

        ASSIGN l-achou = NO.
        FOR EACH ped-venda NO-LOCK 
           WHERE ped-venda.dt-implant >= fi-dt-corte,
           FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = ped-venda.cod-emitente,
            EACH ped-item OF ped-venda NO-LOCK
           WHERE ped-item.dt-canseq <> ?,
           FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = ped-item.it-codigo:

            RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).

            ASSIGN c-desc-motivo = "".
            FIND FIRST motivo 
                 WHERE motivo.cod-motivo = ped-venda.cod-mot-canc-cot NO-LOCK NO-ERROR.
            IF AVAIL motivo THEN
                ASSIGN c-desc-motivo = motivo.descricao.

            ASSIGN i-repres = 0.
            FIND FIRST repres NO-LOCK
                 WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
            IF AVAIL repres THEN
                ASSIGN i-repres = repres.cod-rep.

            PUT UNFORMATTED
                 ped-venda.nr-pedido                                            ";"
                 ped-venda.nr-pedcli                                            ";"
                 ped-item.it-codigo                                             ";"
                 ITEM.desc-item                                                 ";"
                 ped-item.cod-mot-canc-cot                                      ";"
                 c-desc-motivo                                                  ";"
                 ped-item.qt-pedida - ped-item.qt-atend                         ";"
                 ROUND((ped-item.qt-pedida - ped-item.qt-atend) * ped-item.vl-preuni,2)  ";"
                 ped-item.vl-liq-it                                             ";"
                 ped-item.vl-tot-it                                             ";"
                 ped-venda.cod-emitente                                         ";"
                 emitente.nome-emit FORMAT "x(60)"                              ";"
                 i-repres                                                       ";"
                 ped-venda.dt-implant                                           ";"
                 ped-item.dt-canseq                                             ";"
                 REPLACE(REPLACE(REPLACE(ped-item.desc-cancel,CHR(13)," "),CHR(10)," "),";",".")  SKIP.

            ASSIGN l-achou = YES.
        END.

        run pi-finalizar in h-acomp.

        OUTPUT CLOSE.

        IF l-achou THEN DO:
            CREATE "Excel.Application" ch-Excel NO-ERROR.
            IF VALID-HANDLE(ch-Excel) THEN DO:
                RELEASE OBJECT ch-Excel.
                OS-COMMAND NO-WAIT VALUE(c-arquivo-csv).
            END.
            ELSE OS-COMMAND NO-WAIT notepad VALUE(c-arquivo-csv).
        END.
        ELSE
            MESSAGE "Nenhum pedido cancelado apartir de " fi-dt-corte
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        APPLY "GO":U TO FRAME fPedCancRecord.
    END.
    
    ON "CHOOSE":U OF btPedCancFechar IN FRAME fPedCancRecord DO:
        APPLY "GO":U TO FRAME fPedCancRecord.
    END.
    ENABLE fi-dt-corte
           btPedCancOk
           btPedCancFechar
        WITH FRAME fPedCancRecord. 
    
    WAIT-FOR "GO":U OF FRAME fPedCancRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lista-pedidos-suspensos wWindow 
PROCEDURE pi-lista-pedidos-suspensos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fi-dt-corte      AS DATE FORMAT "99/99/9999"  NO-UNDO.
    DEFINE VARIABLE de-vl-mercad     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER   NO-UNDO.

    DEFINE BUTTON btPedSuspOk
         LABEL "&Ok" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btPedSuspFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtPedSuspButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 25 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fPedSuspRecord
        fi-dt-corte      AT ROW 1.21 COL 10 COLON-ALIGNED VIEW-AS FILL-IN SIZE 14 BY .88 LABEL "Data Corte"
        btPedSuspOk      AT ROW 3 COL 2.14
        btPedSuspFechar  AT ROW 3 COL 13
        rtPedSuspButton  AT ROW 2.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Data Corte " FONT 1
             DEFAULT-BUTTON btPedSuspOk.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fPedSuspRecord:HANDLE) NO-ERROR.

    ASSIGN fi-dt-corte = TODAY - 180.

    DISP fi-dt-corte WITH FRAME fPedSuspRecord. 

    ON "CHOOSE":U OF btPedSuspOk IN FRAME fPedSuspRecord DO:
        DEFINE VARIABLE ch-Excel      AS COMPONENT-HANDLE   NO-UNDO.
        DEFINE VARIABLE l-achou       AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE i-repres      AS INTEGER     NO-UNDO.
        DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

        DEFINE VARIABLE i-cod-matriz    AS INTEGER     NO-UNDO.
        DEFINE VARIABLE de-valor-aberto AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE de-valor-atraso AS DECIMAL     NO-UNDO.

        DEFINE BUFFER b-emitente FOR emitente.
        ASSIGN INPUT fi-dt-corte
               c-arquivo-csv = "c:\temp\alpd0003-suspend-" + STRING(TODAY,"999999") + "-" +  STRING(TIME) + ".csv".        


        run utp/ut-acomp.p persistent set h-acomp.  
        run pi-inicializar in h-acomp (input "Pedidos Suspensos...").

        OUTPUT TO VALUE(c-arquivo-csv) NO-CONVERT.

        PUT UNFORMATTED
            "Est;Unid.Negoc;Nr.Pedido;Nr.Pecli;Cliente;Nome Emit;Repres;Vl.Mercad;Vl.Tot.Ped;Dt.Inclus∆o;Dt.Entrega;Dt.Suspens∆o;Obs.Suspens∆o;Vl.Tit.Abertos;Vl.Tit.Vencidos" SKIP.

        ASSIGN l-achou = NO.

        FOR EACH ped-venda NO-LOCK 
           WHERE ped-venda.dt-implant >= fi-dt-corte
             AND ped-venda.cod-sit-ped = 5
             AND ped-venda.completo,
           FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = ped-venda.cod-emitente,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
         /*AND natur-oper.emite-duplic*/ ,
       FIRST cst_ped_venda NO-LOCK
       WHERE cst_ped_venda.nome-abrev = ped-venda.nome-abrev
         AND cst_ped_venda.nr-pedcli  = ped-venda.nr-pedcli:

            /*s¢ busca pedidos que n∆o tem duplicata pedidos de palmas,restante desconsidera*/
            IF ped-venda.cod-emitente <> 2 AND natur-oper.emite-duplic = NO THEN NEXT.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(ped-venda.dt-implant,"99/99/9999")).

            ASSIGN i-repres = 0.
            FIND FIRST repres NO-LOCK
                 WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
            IF AVAIL repres THEN
                ASSIGN i-repres = repres.cod-rep.

            ASSIGN i-cod-matriz = 0.
            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.
            IF AVAIL b-emitente THEN
                ASSIGN i-cod-matriz = b-emitente.cod-emitente.

            RUN pi-titulos (INPUT ped-venda.cod-estabel,
                            INPUT ped-venda.cod-emitente,
                            INPUT i-cod-matriz,
                            OUTPUT de-valor-aberto,
                            OUTPUT de-valor-atraso).
            
            ASSIGN c-cod-unid-negoc = ""
                   de-vl-mercad = 0.

            FOR EACH ped-item OF ped-venda NO-LOCK
                WHERE ped-item.cod-sit-item = 5:

                IF c-cod-unid-negoc = "" THEN ASSIGN c-cod-unid-negoc = ped-item.cod-unid-negoc.

                ASSIGN de-vl-mercad = de-vl-mercad + ped-item.vl-merc-abe.
            END.

            PUT UNFORMATTED
                 ped-venda.cod-estabel                                          ";"
                 c-cod-unid-negoc                                               ";"   
                 ped-venda.nr-pedido                                            ";"
                 ped-venda.nr-pedcli                                            ";"
                 ped-venda.cod-emitente                                         ";"
                 emitente.nome-emit FORMAT "x(60)"                              ";"
                 i-repres                                                       ";"
                 de-vl-mercad                                                   ";" 
                 ped-venda.vl-tot-ped                                           ";"
                 ped-venda.dt-implant                                           ";"
                 ped-venda.dt-entrega                                           ";"
                 ped-venda.dt-suspensao                                         ";"
                 REPLACE(REPLACE(REPLACE(ped-venda.desc-suspend,CHR(13)," "),CHR(10)," "),";",".") ";"
                 de-valor-aberto                                                ";"
                 de-valor-atraso SKIP.


            ASSIGN l-achou = YES.
        END.

        run pi-finalizar in h-acomp.

        OUTPUT CLOSE.

        IF l-achou THEN DO:
            CREATE "Excel.Application" ch-Excel NO-ERROR.
            IF VALID-HANDLE(ch-Excel) THEN DO:
                RELEASE OBJECT ch-Excel.
                OS-COMMAND NO-WAIT VALUE(c-arquivo-csv).
            END.
            ELSE OS-COMMAND NO-WAIT notepad VALUE(c-arquivo-csv).
        END.
        ELSE
            MESSAGE "Nenhum pedido suspenso apartir de " fi-dt-corte
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        APPLY "GO":U TO FRAME fPedSuspRecord.
    END.
    
    ON "CHOOSE":U OF btPedSuspFechar IN FRAME fPedSuspRecord DO:
        APPLY "GO":U TO FRAME fPedSuspRecord.
    END.
    ENABLE fi-dt-corte
           btPedSuspOk
           btPedSuspFechar
        WITH FRAME fPedSuspRecord. 
    
    WAIT-FOR "GO":U OF FRAME fPedSuspRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-aprovacoes wWindow 
PROCEDURE pi-mostra-aprovacoes :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de DetAprov
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-nome-abrev      AS CHARACTER LABEL "Nome Abrev"         NO-UNDO.
    DEFINE VARIABLE v-nr-pedcli       AS CHARACTER LABEL "Pedido"             NO-UNDO.

    DEFINE VARIABLE fi-aprov-comercial  AS LOGICAL FORMAT "yes/no"            NO-UNDO.
    DEFINE VARIABLE fi-usuar_aprov_com  LIKE cst_ped_venda.usuar_aprov_com    NO-UNDO.
    DEFINE VARIABLE fi-dt_hr_aprov_com  LIKE cst_ped_venda.dt_hr_aprov_com    NO-UNDO.
    
    DEFINE VARIABLE fi-aprov-contab      AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE fi-usuar-aprov-cont  LIKE cst_ped_venda.usuar_aprov_com   NO-UNDO.
    DEFINE VARIABLE fi-dt-hr-aprov-cont  LIKE cst_ped_venda.dt_hr_aprov_com   NO-UNDO.
    DEFINE VARIABLE v-obs-aprov-contab   LIKE cst_ped_venda.obs-aprov-contab  NO-UNDO.

    DEFINE VARIABLE fi-cod-sit-aval     AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE fi-dt-apr-cred      LIKE ped-venda.dt-apr-cred            NO-UNDO.
    DEFINE VARIABLE fi-quem-aprovou     LIKE ped-venda.quem-aprovou           NO-UNDO.
    DEFINE VARIABLE fi-desc-bloq-cr     LIKE ped-venda.desc-bloq-cr           NO-UNDO.
    DEFINE VARIABLE fi-desc-forc-cr     LIKE ped-venda.desc-forc-cr           NO-UNDO.
    
    DEFINE VARIABLE v-observacoes     LIKE ped-venda.observacoes  NO-UNDO.
    DEFINE VARIABLE v-cond-espec      LIKE ped-venda.cond-espec  NO-UNDO.

    DEFINE BUTTON btDetAprovFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtDetAprovButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fDetAprovRecord
        v-nome-abrev        AT ROW 1.21 COL 14.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-nr-pedcli         AT ROW 1.21 COL 40.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        v-observacoes       AT ROW 2.21 COL 14.5 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 2.88
        v-cond-espec        AT ROW 5.21 COL 14.5 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 2.88
        
        fi-aprov-comercial  AT ROW 8.21 COL 14.5 COLON-ALIGNED VIEW-AS COMBO-BOX SIZE 15 BY 1 INNER-LINES 5  LIST-ITEM-PAIRS "N∆o Aprovado",No,"Aprovado",YES LABEL "Comercial"
        fi-usuar_aprov_com  AT ROW 8.21 COL 29.8 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 NO-LABEL
        fi-dt_hr_aprov_com  AT ROW 8.21 COL 43.1 COLON-ALIGNED VIEW-AS FILL-IN SIZE 21.4 BY .88 NO-LABEL

        fi-aprov-contab     AT ROW 9.21 COL 14.5 COLON-ALIGNED VIEW-AS COMBO-BOX SIZE 15 BY 1 INNER-LINES 5  LIST-ITEM-PAIRS "Nenhum",0,"Reprovado",1,"Aprovado",2 LABEL "Contabilidade"
        fi-usuar-aprov-cont AT ROW 9.21 COL 29.8 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 NO-LABEL
        fi-dt-hr-aprov-cont AT ROW 9.21 COL 43.1 COLON-ALIGNED VIEW-AS FILL-IN SIZE 21.4 BY .88 NO-LABEL
        v-obs-aprov-contab  AT ROW 10.21 COL 14.5 COLON-ALIGNED VIEW-AS EDITOR SIZE 50 BY 2.88 LABEL "Obs.Aprov.Contab."

        fi-cod-sit-aval     AT ROW 13.21 COL 14.5 COLON-ALIGNED VIEW-AS COMBO-BOX SIZE 15 BY 1 INNER-LINES 5  LIST-ITEM-PAIRS "N∆o avaliado",1,"Avaliado",2,"Aprovado",3,"N∆o aprovado",4,"Pendente",5 LABEL "Financeiro"
        fi-quem-aprovou     AT ROW 13.21 COL 29.8 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 NO-LABEL                                                                         
        fi-dt-apr-cred      AT ROW 13.21 COL 43.1 COLON-ALIGNED VIEW-AS FILL-IN SIZE 21.4 BY .88 NO-LABEL
        fi-desc-bloq-cr     AT ROW 14.21 COL 14.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 50   BY .88 LABEL "Mot.Bloqueio CrÇdito"
        fi-desc-forc-cr     AT ROW 15.21 COL 14.5 COLON-ALIGNED VIEW-AS FILL-IN SIZE 50   BY .88 LABEL "Mot.Aprov. CrÇdito"

        btDetAprovFechar   AT ROW 17 COL 2.14
        rtDetAprovButton  AT ROW 16.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Detalhes Aprovaá‰es" FONT 1
             DEFAULT-BUTTON btDetAprovFechar.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fDetAprovRecord:HANDLE) NO-ERROR.

    ASSIGN v-observacoes:READ-ONLY IN FRAME fDetAprovRecord = YES
           v-cond-espec:READ-ONLY IN FRAME fDetAprovRecord = YES
           v-obs-aprov-contab:READ-ONLY IN FRAME fDetAprovRecord = YES.

    ASSIGN v-nome-abrev        = tt-ped-venda.nome-abrev
           v-nr-pedcli         = tt-ped-venda.nr-pedcli
           v-observacoes       = tt-ped-venda.observacoes
           v-cond-espec        = tt-ped-venda.cond-espec
           fi-aprov-comercial  = NO
           fi-usuar_aprov_com  = ""
           fi-dt_hr_aprov_com  = ?
           fi-aprov-contab     = 0
           fi-usuar-aprov-cont = ""
           fi-dt-hr-aprov-cont = ? 
           v-obs-aprov-contab  = ""
           fi-cod-sit-aval     = tt-ped-venda.cod-sit-aval
           fi-quem-aprovou     = tt-ped-venda.quem-aprovou
           fi-dt-apr-cred      = tt-ped-venda.dt-apr-cred
           fi-desc-bloq-cr     = tt-ped-venda.desc-bloq-cr
           fi-desc-forc-cr     = tt-ped-venda.desc-forc-cr.

    FIND FIRST cst_ped_venda NO-LOCK
         WHERE cst_ped_venda.nome-abrev = tt-ped-venda.nome-abrev
           AND cst_ped_venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.
    IF AVAIL cst_ped_venda THEN
        ASSIGN fi-aprov-comercial  = cst_ped_venda.l_aprov_com
               fi-usuar_aprov_com  = cst_ped_venda.usuar_aprov_com
               fi-dt_hr_aprov_com  = cst_ped_venda.dt_hr_aprov_com
               fi-aprov-contab     = cst_ped_venda.i-aprov-contab
               fi-usuar-aprov-cont = cst_ped_venda.usuar-aprov-contab
               fi-dt-hr-aprov-cont = cst_ped_venda.dt-hr-aprov-contab
               v-obs-aprov-contab  = cst_ped_venda.obs-aprov-contab.

    DISP v-nome-abrev   
         v-nr-pedcli
         v-observacoes
         v-cond-espec
         fi-aprov-comercial
         fi-usuar_aprov_com
         fi-dt_hr_aprov_com
         fi-aprov-contab    
         fi-usuar-aprov-cont
         fi-dt-hr-aprov-cont
         v-obs-aprov-contab
         fi-cod-sit-aval
         fi-quem-aprovou
         fi-dt-apr-cred 
         fi-desc-bloq-cr
         fi-desc-forc-cr
        WITH FRAME fDetAprovRecord. 

    ON "CHOOSE":U OF btDetAprovFechar IN FRAME fDetAprovRecord DO:
        APPLY "GO":U TO FRAME fDetAprovRecord.
    END.
    
    ENABLE v-observacoes
           v-cond-espec
           v-obs-aprov-contab
           btDetAprovFechar
        WITH FRAME fDetAprovRecord. 
    
    WAIT-FOR "GO":U OF FRAME fDetAprovRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-resumo wWindow 
PROCEDURE pi-mostra-resumo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-unid-neg AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE fi-valor-comercial      AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-valor-contabilidade  AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-valor-financeiro     AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-valor-logistica      AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-valor-total          AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    
    DEFINE VARIABLE fi-perc-comercial      AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-contabilidade  AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-financeiro     AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-logistica      AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    
    DEFINE VARIABLE fi-vl-log0              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log1              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log2              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log3              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log4              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log5              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-log6              AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-vl-difer             AS DECIMAL FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
    
    DEFINE VARIABLE fi-perc-log0              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log1              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log2              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log3              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log4              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log5              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
    DEFINE VARIABLE fi-perc-log6              AS DECIMAL FORMAT ">>9.99"  NO-UNDO.

    DEFINE BUTTON btResumoGrafico
         LABEL "&Gr†fico" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btResumoFechar
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtResumoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fResumoRecord
        fi-valor-comercial      AT ROW 1.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Comercial"
        fi-perc-comercial       AT ROW 1.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88 NO-LABEL
        fi-valor-contabilidade  AT ROW 2.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Contabilidade"
        fi-perc-contabilidade   AT ROW 2.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88 NO-LABEL
        fi-valor-financeiro     AT ROW 3.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Financeiro"
        fi-perc-financeiro      AT ROW 3.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88 NO-LABEL
        fi-valor-logistica      AT ROW 4.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Log°stica"
        fi-perc-logistica       AT ROW 4.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88 NO-LABEL
        fi-valor-total          AT ROW 5.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Total"

        fi-vl-log0              AT ROW 7.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Nenhum"
        fi-perc-log0            AT ROW 7.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log1              AT ROW 8.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Aguardando Agendamento"
        fi-perc-log1            AT ROW 8.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log2              AT ROW 9.21  COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Agendados e/ou Programados"
        fi-perc-log2            AT ROW 9.21  COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log3              AT ROW 10.21 COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Aguardando Produá∆o"
        fi-perc-log3            AT ROW 10.21 COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log4              AT ROW 11.21 COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Aguardando Complemento Cubagem"
        fi-perc-log4            AT ROW 11.21 COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log5              AT ROW 12.21 COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Aguardando Cotaá∆o Frete"
        fi-perc-log5            AT ROW 12.21 COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL
        fi-vl-log6              AT ROW 13.21 COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Aguardando Faturamento"
        fi-perc-log6            AT ROW 13.21 COL 43 COLON-ALIGNED VIEW-AS FILL-IN SIZE  8 BY .88 NO-LABEL

        fi-vl-difer             AT ROW 14.21 COL 30 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY .88 LABEL "Diferenáa Saldo"

        btResumoGrafico  AT ROW 16 COL 2.14
        btResumoFechar   AT ROW 16 COL 12.33
        rtResumoButton   AT ROW 15.75 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Pedidos Setor/Carteira" FONT 1
             DEFAULT-BUTTON btResumoFechar.
    
    CASE tt-filtros.i-cod-unid-negoc:
        WHEN 0 THEN ASSIGN c-unid-neg = "TODOS".
        WHEN 1 THEN ASSIGN c-unid-neg = "UTENS÷LIOS DOMESTICOS".
        WHEN 2 THEN ASSIGN c-unid-neg = "LAMINADOS".
        OTHERWISE ASSIGN c-unid-neg = "OUTRAS".
    END CASE.

    ASSIGN FRAME fResumoRecord:TITLE = CAPS("Pedidos - Unid.Negoc: " + c-unid-neg).

    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
     RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fResumoRecord:HANDLE) NO-ERROR.

    ASSIGN fi-valor-comercial      = 0
           fi-valor-contabilidade  = 0
           fi-valor-financeiro     = 0
           fi-valor-logistica      = 0
           fi-valor-total          = 0
           fi-vl-log0              = 0
           fi-vl-log1              = 0
           fi-vl-log2              = 0
           fi-vl-log3              = 0
           fi-vl-log4              = 0
           fi-vl-log5              = 0
           fi-vl-log6              = 0.

    FOR EACH tt-resumo NO-LOCK:
        CASE tt-resumo.c-setor:
            WHEN "Comercial"     THEN ASSIGN fi-valor-comercial      = tt-resumo.valor.
            WHEN "Contabilidade" THEN ASSIGN fi-valor-contabilidade  = tt-resumo.valor.
            WHEN "Financeiro"    THEN ASSIGN fi-valor-financeiro     = tt-resumo.valor.
            WHEN "Log°stica"     THEN ASSIGN fi-valor-logistica      = tt-resumo.valor.
        END CASE.
        ASSIGN fi-valor-total = fi-valor-total + tt-resumo.valor.
    END.

    ASSIGN fi-perc-comercial      = fi-valor-comercial     / fi-valor-total * 100
           fi-perc-contabilidade  = fi-valor-contabilidade / fi-valor-total * 100
           fi-perc-financeiro     = fi-valor-financeiro    / fi-valor-total * 100
           fi-perc-logistica      = fi-valor-logistica     / fi-valor-total * 100.

    FOR EACH tt-logistica NO-LOCK:
        CASE tt-logistica.situacao:
            WHEN "Nenhum"                           THEN ASSIGN fi-vl-log0 = tt-logistica.valor.
            WHEN "Aguardando Agendamento"           THEN ASSIGN fi-vl-log1 = tt-logistica.valor.
            WHEN "Agendados e/ou Programados"       THEN ASSIGN fi-vl-log2 = tt-logistica.valor.
            WHEN "Aguardando Produá∆o"              THEN ASSIGN fi-vl-log3 = tt-logistica.valor.
            WHEN "Aguardando Complemento Cubagem"   THEN ASSIGN fi-vl-log4 = tt-logistica.valor.
            WHEN "Aguardando Cotaá∆o Frete"         THEN ASSIGN fi-vl-log5 = tt-logistica.valor.
            WHEN "Aguardando Faturamento"           THEN ASSIGN fi-vl-log6 = tt-logistica.valor.
        END CASE.
    END.

    ASSIGN fi-perc-log0 = fi-vl-log0 / fi-valor-logistica * 100
           fi-perc-log1 = fi-vl-log1 / fi-valor-logistica * 100
           fi-perc-log2 = fi-vl-log2 / fi-valor-logistica * 100
           fi-perc-log3 = fi-vl-log3 / fi-valor-logistica * 100
           fi-perc-log4 = fi-vl-log4 / fi-valor-logistica * 100
           fi-perc-log5 = fi-vl-log5 / fi-valor-logistica * 100
           fi-perc-log6 = fi-vl-log6 / fi-valor-logistica * 100
        
           fi-vl-difer  = fi-valor-logistica - (fi-vl-log0 + fi-vl-log1 + fi-vl-log2 + fi-vl-log3 + fi-vl-log4 + fi-vl-log5 + fi-vl-log6).

    DISP fi-valor-comercial       fi-perc-comercial    
         fi-valor-contabilidade   fi-perc-contabilidade
         fi-valor-financeiro      fi-perc-financeiro   
         fi-valor-logistica       fi-perc-logistica    
         fi-valor-total
         fi-vl-log0               fi-perc-log0
         fi-vl-log1               fi-perc-log1
         fi-vl-log2               fi-perc-log2
         fi-vl-log3               fi-perc-log3
         fi-vl-log4               fi-perc-log4
         fi-vl-log5               fi-perc-log5
         fi-vl-log6               fi-perc-log6
         fi-vl-difer 
        WITH FRAME fResumoRecord. 

    ON "CHOOSE":U OF btResumoFechar IN FRAME fResumoRecord DO:
        APPLY "GO":U TO FRAME fResumoRecord.
    END.
    
    ON "CHOOSE":U OF btResumoGrafico IN FRAME fResumoRecord DO:
        RUN pi-gera-excel.
    END.

    ENABLE btResumoGrafico
           btResumoFechar
        WITH FRAME fResumoRecord. 
    
    WAIT-FOR "GO":U OF FRAME fResumoRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-obs-motivo wWindow 
PROCEDURE pi-obs-motivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-tipo        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETE v-obs-motivo  AS CHARACTER FORMAT "x(80)" NO-UNDO.

    DEFINE BUTTON btObsMotivoCancel AUTO-END-KEY
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btObsMotivoOK  
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtObsMotivoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fObsMotivoRecord
        v-obs-motivo        AT ROW 1.21 COL 7 COLON-ALIGNED VIEW-AS FILL-IN SIZE 60 BY 0.88 LABEL "Motivo"
        btObsMotivoOK       AT ROW 2.41 COL 2.14
        btObsMotivoCancel   AT ROW 2.41 COL 13  
        rtObsMotivoButton  AT ROW 2.21 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Motivo" FONT 1
              CANCEL-BUTTON btObsMotivoCancel.
    
    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.

    RUN pi_aplica_facelift_thin in h-facelift(INPUT FRAME fObsMotivoRecord:HANDLE) NO-ERROR.

    ASSIGN FRAME fObsMotivoRecord:TITLE = "Motivo " + p-tipo.

    ASSIGN v-obs-motivo  = "".

    DISP v-obs-motivo
        WITH FRAME fObsMotivoRecord. 

    ON "CHOOSE":U OF btObsMotivoOK IN FRAME fObsMotivoRecord DO:
        ASSIGN INPUT FRAME fObsMotivoRecord v-obs-motivo.

        IF v-obs-motivo = "" THEN DO:
            MESSAGE "Obrigat¢rio informar um motivo"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.

        APPLY "GO":U TO FRAME fObsMotivoRecord.
    END.
    
    ENABLE v-obs-motivo
           btObsMotivoOK
           btObsMotivoCancel
        WITH FRAME fObsMotivoRecord. 
    
    WAIT-FOR "GO":U OF FRAME fObsMotivoRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-perm-financeiro wWindow 
PROCEDURE pi-perm-financeiro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-financeiro AS LOGICAL     NO-UNDO.

    ASSIGN l-financeiro = NO.

    FIND emitente 
        WHERE emitente.nome-abrev = tt-ped-venda.nome-abrev NO-LOCK NO-ERROR.
      FIND FIRST usu-gr-cli  /* Pesquisa por usu†rio e cliente */
           WHERE usu-gr-cli.cod-usuario = c-seg-usuario
             AND usu-gr-cli.nome-abrev  = emitente.nome-abrev
             AND usu-gr-cli.ind-funcao  = 1 /* CrÇdito */ NO-LOCK NO-ERROR.
      IF NOT AVAIL usu-gr-cli THEN DO:
          FIND FIRST usu-gr-cli  /* Pesquisa por usu†rio e grupo */
               WHERE usu-gr-cli.cod-usuario = c-seg-usuario
               AND   (usu-gr-cli.cod-gr-cli = emitente.cod-gr-cli
               OR usu-gr-cli.cod-gr-cli = 0)
               AND usu-gr-cli.ind-funcao    = 1 NO-LOCK NO-ERROR.
          IF AVAIL usu-gr-cli THEN
              ASSIGN l-financeiro = YES.
          ELSE
              ASSIGN l-financeiro = NO.
      END.
      ELSE
          ASSIGN l-financeiro = YES.
    /************ Habilita Ou Desabilita Bot∆o do Financeiro ************/
    ASSIGN bt-financeiro:SENSITIVE IN FRAME fPage0      = l-financeiro.
    /************ Habilita Ou Desabilita Bot‰es de Aprovaá∆o ************/
    IF tt-ped-venda.cod-sit-ped > 2 THEN 
        ASSIGN l-financeiro = NO.

    /* Tratar Liberaá‰es de Pedidos para Alocaá∆o/Separaá∆o sem estar Aprovado no Financeiro */
    FOR FIRST emitente
        WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK:
        IF CAN-FIND(FIRST alc-emitente OF emitente
                    WHERE alc-emitente.ind-lib-separacao <> 3) THEN DO:
            IF NOT tt-ped-venda.dsp-pre-fat THEN
                ASSIGN SUB-MENU m_ind_lib_separ:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = YES
                       MENU-ITEM m_libera_separ_pedido:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = YES
                       MENU-ITEM m_bloqueia_separ_pedido:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = NO.
            ELSE DO:
                ASSIGN SUB-MENU m_ind_lib_separ:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = YES
                       MENU-ITEM m_libera_separ_pedido:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = NO
                       MENU-ITEM m_bloqueia_separ_pedido:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = YES.
            END.
        END.
        ELSE DO:
            ASSIGN SUB-MENU m_ind_lib_separ:SENSITIVE IN MENU POPUP-MENU-bt-financeiro = NO.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-permissoes wWindow 
PROCEDURE pi-permissoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST alc-param-usuar NO-LOCK
         WHERE alc-param-usuar.usuario = v_cod_usuar_corren NO-ERROR.

    IF bt-altera-pedido:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-altera-pedido:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-altera-pedido THEN YES ELSE NO).

    IF bt-aprov-comercial:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-aprov-comercial:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-aprova-comercial THEN YES ELSE NO).

    IF bt-suspender:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-suspender:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-suspende-pedido THEN YES ELSE NO).

    IF bt-reativar:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-reativar:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-reativa-pedido THEN YES ELSE NO).

    IF bt-cancelar:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-cancelar:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-cancela-pedido THEN YES ELSE NO).

    IF bt-contabilidade:SENSITIVE IN FRAME fPage0 THEN 
        ASSIGN bt-contabilidade:SENSITIVE IN FRAME fPage0 = (IF AVAIL alc-param-usuar AND alc-param-usuar.l-aprov-reprov-contab THEN YES ELSE NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reativar wWindow 
PROCEDURE pi-reativar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-orc-ped     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-motivo  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE da-data       AS DATE        NO-UNDO.
    DEFINE VARIABLE l-resultado   AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE bo-ped-venda-rct AS HANDLE      NO-UNDO.

    DEFINE VARIABLE l-confirma    AS LOGICAL     NO-UNDO.

    MESSAGE "Confirma Reativaá∆o Pedido?" SKIP(1)
            "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
            " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.

    IF l-confirma THEN DO:
        ASSIGN c-orc-ped = IF tt-ped-venda.l_aprov_com THEN "Pedido" ELSE "Oráamento".

        RUN pi-verif-alocacao.
        IF RETURN-VALUE = "OK" THEN DO:
            RUN pdp/pd4000a.w(INPUT  "Reativaá∆o",
                              OUTPUT i-cod-motivo,
                              OUTPUT c-desc-motivo,
                              OUTPUT da-data,
                              OUTPUT l-resultado).

            IF l-resultado THEN DO:
                IF SESSION:SET-WAIT-STATE("general") THEN.
                IF NOT VALID-HANDLE(bo-ped-venda-rct) OR 
                   bo-ped-venda-rct:TYPE <> "PROCEDURE":U OR
                   bo-ped-venda-rct:FILE-NAME <> "dibo/bodi159rct.p":U THEN
                    RUN dibo/bodi159rct.p PERSISTENT set bo-ped-venda-rct.

                RUN setUserLog IN bo-ped-venda-rct (INPUT v_cod_usuar_corren).
                RUN validateReactivation IN bo-ped-venda-rct (INPUT tt-ped-venda.r-rowid,
                                                              OUTPUT TABLE Rowerrors).

                IF SESSION:SET-WAIT-STATE("") THEN.

                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    run pi-ShowMessage.
                END.

                ASSIGN l-exec-ok = NO.
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:

                    reativar: DO TRANSACTION ON ERROR  UNDO reativar, LEAVE reativar
                                             ON QUIT   UNDO reativar, LEAVE reativar
                                             ON ENDKEY UNDO reativar, LEAVE reativar
                                             ON STOP   UNDO reativar, LEAVE reativar:

                        RUN emptyRowErrors IN bo-ped-venda-rct.                        
                        RUN updateReactivation IN bo-ped-venda-rct (INPUT tt-ped-venda.r-rowid,
                                                                    INPUT c-desc-motivo).
                        RUN getRowErrors IN bo-ped-venda-rct (OUTPUT TABLE RowErrors). 
                        IF CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:
                            run pi-ShowMessage.
                        END.
                        ELSE DO:
                            ASSIGN l-exec-ok = YES.
                            MESSAGE "Pedido Reativado com sucesso"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        END.
                    END.
                END.
                IF VALID-HANDLE(bo-ped-venda-rct)  THEN DO:
                  DELETE PROCEDURE bo-ped-venda-rct.
                  ASSIGN bo-ped-venda-rct = ?.
                END.        
                IF l-exec-ok THEN DO:
                    FOR FIRST cst_ped_venda OF tt-ped-venda EXCLUSIVE-LOCK:
                         ASSIGN cst_ped_venda.l_aprov_com        = NO
                                cst_ped_venda.dt_hr_aprov_com    = ?
                                cst_ped_venda.usuar_aprov_com    = ""
                                cst_ped_venda.i-aprov-contab     = 0
                                cst_ped_venda.dt-hr-aprov-contab = ?
                                cst_ped_venda.usuar-aprov-contab = ""
                                cst_ped_venda.obs-aprov-contab   = "".
                    END.
                    RELEASE cst_ped_venda NO-ERROR.

                    IF SESSION:SET-WAIT-STATE("") THEN.

                    RUN pi-envia-email(INPUT c-orc-ped, INPUT "Reativado", INPUT c-desc-motivo).
                    RUN pi-carrega-tabelas.
                END.
            END.
        END.
        ELSE RETURN "NOK".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ShowMessage wWindow 
PROCEDURE pi-ShowMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {method/showmessage.i1}
    {method/showmessage.i2 &Modal=YES}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-suspender wWindow 
PROCEDURE pi-suspender :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-orc-ped     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-motivo  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE da-data       AS DATE        NO-UNDO.
    DEFINE VARIABLE l-resultado   AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE bo-ped-venda-sus AS HANDLE      NO-UNDO.

    DEFINE VARIABLE l-confirma    AS LOGICAL     NO-UNDO.

    MESSAGE "Confirma Suspens∆o Pedido?" SKIP(1)
            "Cliente: " tt-ped-venda.cod-emitente " - " tt-ped-venda.nome-abrev SKIP
            " Pedido: " tt-ped-venda.nr-pedcli    " - " tt-ped-venda.no-ab-reppri
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-confirma.

    IF l-confirma THEN DO:
        ASSIGN c-orc-ped = IF tt-ped-venda.l_aprov_com THEN "Pedido" ELSE "Oráamento".

        RUN pi-verif-alocacao.
        IF RETURN-VALUE = "OK" THEN DO:
            RUN pdp/pd4000a.w(INPUT  "Suspens∆o",
                              OUTPUT i-cod-motivo,
                              OUTPUT c-desc-motivo,
                              OUTPUT da-data,
                              OUTPUT l-resultado).

            IF l-resultado THEN DO:
                IF NOT VALID-HANDLE(bo-ped-venda-sus) OR 
                   bo-ped-venda-sus:TYPE <> "PROCEDURE":U OR 
                   bo-ped-venda-sus:FILE-NAME <> "dibo/bodi159sus.p":U THEN

                RUN dibo/bodi159sus.p PERSISTENT SET bo-ped-venda-sus.

                RUN setUserLog IN bo-ped-venda-sus (INPUT v_cod_usuar_corren).

                IF SESSION:SET-WAIT-STATE("general") THEN.

                RUN validateSuspension IN bo-ped-venda-sus (INPUT tt-ped-venda.r-rowid,
                                                            OUTPUT TABLE Rowerrors).

                IF SESSION:SET-WAIT-STATE("") THEN.

                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    RUN pi-ShowMessage.
                END.

                ASSIGN l-exec-ok = NO.
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:

                    suspender: DO TRANSACTION ON ERROR  UNDO suspender, LEAVE suspender
                                              ON QUIT   UNDO suspender, LEAVE suspender
                                              ON ENDKEY UNDO suspender, LEAVE suspender
                                              ON STOP   UNDO suspender, LEAVE suspender:

                        RUN updateSuspension IN bo-ped-venda-sus (INPUT tt-ped-venda.r-rowid,
                                                                  INPUT c-desc-motivo).
                        IF CAN-FIND(FIRST RowErrors) THEN DO:
                            run pi-ShowMessage.
                        END.
                        ELSE DO:
                            ASSIGN l-exec-ok = YES.
                            MESSAGE "Pedido Suspenso com sucesso"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        END.
                    END.
                END.
                IF VALID-HANDLE(bo-ped-venda-sus)  THEN DO:
                  DELETE PROCEDURE bo-ped-venda-sus.
                  ASSIGN bo-ped-venda-sus = ?.
                END.        

                IF l-exec-ok THEN DO:
                    IF SESSION:SET-WAIT-STATE("") THEN.

                    RUN pi-envia-email(INPUT c-orc-ped, INPUT "Suspenso", INPUT c-desc-motivo).
                    RUN pi-carrega-tabelas.
                END.
            END.
        END.
        ELSE RETURN "NOK".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-titulos wWindow 
PROCEDURE pi-titulos :
DEFINE  INPUT PARAMETER p-estab    AS CHARACTER NO-UNDO.
    DEFINE  INPUT PARAMETER p-emitente AS INTEGER   NO-UNDO.
    DEFINE  INPUT PARAMETER p-matriz   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER de-aberto  AS DECIMAL FORMAT "->>>,>>>,>>9.99"  NO-UNDO.
    DEFINE OUTPUT PARAMETER de-atraso  AS DECIMAL FORMAT "->>>,>>>,>>9.99"  NO-UNDO.

    FOR EACH tit_acr NO-LOCK
       WHERE tit_acr.cod_estab           = p-estab
         AND tit_acr.cdn_cliente         = p-emitente
         AND tit_acr.val_sdo_tit_acr      > 0
         AND tit_acr.ind_tip_espec_docto = "Normal"
         AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:

        ASSIGN de-aberto = de-aberto + tit_acr.val_sdo_tit_acr.

        IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN 
            ASSIGN de-atraso = de-atraso + tit_acr.val_sdo_tit_acr.

    END.

    IF p-matriz <> p-emitente THEN DO:
        FOR EACH tit_acr NO-LOCK
           WHERE tit_acr.cod_estab           = p-estab
             AND tit_acr.cdn_cliente         = p-matriz
             AND tit_acr.val_sdo_tit_acr      > 0
             AND tit_acr.ind_tip_espec_docto = "Normal"
             AND tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:

            ASSIGN de-aberto = de-aberto + tit_acr.val_sdo_tit_acr.

            IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN 
                ASSIGN de-atraso = de-atraso + tit_acr.val_sdo_tit_acr.
        END.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verif-alocacao wWindow 
PROCEDURE pi-verif-alocacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bodi519 AS HANDLE      NO-UNDO.

    IF tt-ped-venda.email-repres = "" THEN DO:
        MESSAGE "Email Representante n∆o cadastrado." SKIP
                "Nenhuma aá∆o ser† permitida!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(h-bodi519) THEN
        RUN dibo/bodi519.p PERSISTENT SET h-bodi519.

    IF VALID-HANDLE(h-bodi519) THEN DO:
        RUN verificaItemComAlocacao IN h-bodi519(INPUT tt-ped-venda.r-rowid,
                                                 OUTPUT TABLE RowErrors).
    END.

    IF VALID-HANDLE(h-bodi519) THEN DO:
        DELETE PROCEDURE h-bodi519.
        ASSIGN h-bodi519 = ?.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {METHOD/showmessage.i1}
        {METHOD/showmessage.i2 &Modal=YES}
    END.

    IF CAN-FIND(FIRST rowErrors 
                WHERE rowErrors.errorSubType = "Error") THEN DO:
       RETURN "NOK".
    END.
    ELSE RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-ult-nf-fat wWindow 
FUNCTION fn-ult-nf-fat RETURNS CHAR
  ( pc-nome-abrev AS CHAR,
    pc-nr-pedcli  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    
    FIND LAST nota-fiscal USE-INDEX ch-pedido NO-LOCK
        WHERE nota-fiscal.nome-ab-cli   = pc-nome-abrev
          AND nota-fiscal.nr-pedcli     = pc-nr-pedcli  NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        RETURN nota-fiscal.nr-nota-fis + '/' + nota-fiscal.serie + '/' + nota-fiscal.cod-estabel .
    END.
    RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataAtualizaEmit wWindow 
FUNCTION fnDataAtualizaEmit RETURNS DATETIME
  ( INPUT i-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FOR FIRST alc-emitente FIELDS(data-atualiza)
    WHERE alc-emitente.cod-emitente = i-emitente NO-LOCK:

    RETURN alc-emitente.data-atualiza.
END.

RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataLibFinanceiro wWindow 
FUNCTION fnDataLibFinanceiro RETURNS DATE
  ( pc-nome-abrev AS CHAR,
    pc-nr-pedcli  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_cst_ped_venda FOR cst_ped_venda.
    

    FIND FIRST b_cst_ped_venda NO-LOCK
        WHERE b_cst_ped_venda.nome-abrev    = pc-nome-abrev
          AND b_cst_ped_venda.nr-pedcli     = pc-nr-pedcli  NO-ERROR.
    IF AVAIL b_cst_ped_venda THEN DO:
        RETURN date(b_cst_ped_venda.dt-hr-lib-separacao).

        //b_cst_ped_venda.lg-lib-separacao    = YES
        //b_cst_ped_venda.usuar-lib-separacao = c-seg-usuario
        //b_cst_ped_venda.dt-hr-lib-separacao = NOW.
    END.
    ELSE
        RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItemPed wWindow 
FUNCTION fnItemPed RETURNS LOGICAL
  ( INPUT cnm_abrev  AS CHARACTER,
    INPUT cnr_pedcli AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Verifica se pedido contÇm itens 
    Notes: Carlos Daniel 28/05/2014 - Chamado 821 
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST ped-item NO-LOCK
                WHERE ped-item.nome-abrev = cnm_abrev
                AND   ped-item.nr-pedcli  = cnr_pedcli) THEN
        RETURN TRUE.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeEmitente wWindow 
FUNCTION fnNomeEmitente RETURNS CHARACTER
  ( p-cod-emitente AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST emitente
         WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN
        RETURN STRING(emitente.cod-emitente) + " - " + emitente.nome-emit.
    ELSE  
        RETURN STRING(p-cod-emitente) + " - " + "Cliente N∆o Cadastrado". 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

