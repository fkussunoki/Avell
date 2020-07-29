&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
** ** Objetivo: Programa com objetivo de importar planilha pre-formatada e acertar 
** o modulo de ativo utilizando os programas padr‰es do sistema
** 21.07.2020 - Fizemos a inclus∆o da condiá∆o de Baixa do Bem quando o status
** for diferente de Identificado.
** Foi incluida validaá∆o de data, caso a planilha nao traga data base, Ç
** feito assign no campo para Today (estava dando erro)
** Foi acertada logica para que a descriá∆o existente como Descriá∆o Ajustada
** seja transposta para a Narrativa do bem e a descriá∆o Destino seja inserida
** na descricao do bem.
** Desenvolvedor: Flavio Kussunoki - FKIS Consultoria - (47) 99949-2902
** Envolvidos: Fabiano / Valdeir
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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
FIELD ttv-estabel                   AS CHAR
field ttv-status                    as char
field ttv-localizacao-de            as char
field ttv-localizacao-para          as char
field ttv-cta-pat                   as char
field ttv-descricao                 as char
field ttv-cta-pat-para              as char
field ttv-bem-de                    as char
field ttv-inc-de                    as char
field ttv-foto                      as char
field ttv-desmembrar                as LOGICAL
field ttv-bem-para                  as char
field ttv-inc-para                  as char
field ttv-cc-de                     as char
field ttv-cc-para                   as char
field ttv-dt-aquisicao              as date
field ttv-descricao1                as char
field ttv-descricao-de              as char
field ttv-descricao-para            as char
field ttv-local-de                  as char
field ttv-local-para                as char
field ttv-ps                        as char
field ttv-cod-especie               as char
field ttv-des-especie               as char
field ttv-taxa-conta                as char
field ttv-vlr-original              as char
field ttv-vlr-original-corr         as char
field ttv-depreciacao               as char
field ttv-situacao                  as char
field ttv-nf                        as char
field ttv-fornecedor                as char
field ttv-dt-base-arquivo           as date
field ttv-taxa-societaria           as char
field ttv-residual                  as CHAR
FIELD ttv-tratamento                AS CHAR
FIELD ttv-concatena-de              AS CHAR
FIELD ttv-concatena-para            AS CHAR
FIELD ttv-score                     AS INTEGER
FIELD ttv-cod-empresa               AS CHAR
FIELD ttv-motivo                    AS CHAR
FIELD ttv-selected                  AS CHAR FORMAT "x(1)"
FIELD ttv-status-original           AS CHAR.

DEF TEMP-TABLE tt-score //regua definida atraves de analise combinatoria
    FIELD ttv-tratamento           AS CHAR
    FIELD ttv-score                AS CHAR.

define temp-table tt-erro
    field ttv-mensagem as integer
    field ttv-descricao as char.

DEFINE TEMP-TABLE tt-filtro
    FIELD ttv-reclassificao             AS LOGICAL
    FIELD ttv-transferencia             AS LOGICAL
    FIELD ttv-reclas-transf             AS LOGICAL
    field ttv-alteracao                 as logical
    FIELD ttv-alt-transf                AS LOGICAL
    FIELD ttv-alt-reclas                AS LOGICAL
    FIELD ttv-alt-reclas-transf         AS LOGICAL
    FIELD ttv-baixa                     AS LOGICAL
    FIELD ttv-inexistente               AS LOGICAL
    .

    def temp-table tt_desmembramento_bem_pat_api no-undo
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequ?ncia Bem" column-label "Sequ?ncia"
    field ttv_dat_desmbrto                 as date format "99/99/9999" label "Data Desmbrto" column-label "Data Desmbrto"
    field ttv_ind_tip_desmbrto_bem_pat     as character format "X(16)"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cenˇrio Contˇbil" column-label "Cenˇrio Contˇbil"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .

def temp-table tt_desmemb_novos_bem_pat_api no-undo
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequ?ncia Bem" column-label "Sequ?ncia"
    field tta_des_bem_pat                  as character format "x(40)" label "Descri?ío Bem Pat" column-label "Descri?ío Bem Pat"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(11)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid NegΩcio" column-label "Un Neg"
    field ttv_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field ttv_val_origin_movto_bem_pat     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original Movto" column-label "Valor Original Movto"
    field ttv_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .





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
def var v_hdl_api_bem_pat_desmbrto as handle no-undo.
def var v_controle      as integer no-undo.
def new shared stream s_1.
DEF NEW GLOBAL SHARED VAR v_ind_message_output AS CHAR NO-UNDO.

def NEW SHARED temp-table tt_desmembrto_bem_pat  NO-UNDO      
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaªío Bem" column-label "Identificaªío Bem"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequºncia Bem" column-label "Sequºncia"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriªío Bem Pat" column-label "Descriªío Bem Pat"
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(11)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid NegΩcio" column-label "Un Neg"
    field ttv_log_busca_orig               as logical format "Sim/Nío" initial no label "Busca da Origem" column-label "Busca da Origem"
    index tt_desmembrto_bem_pat_id         is primary unique
          tta_cod_empresa                  ascending
          tta_cod_cta_pat                  ascending
          tta_num_bem_pat                  ascending
          tta_num_seq_bem_pat              ascending
    .

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-planilha.ttv-selected tt-planilha.ttv-tratamento tt-planilha.ttv-localizacao-de tt-planilha.ttv-localizacao-para tt-planilha.ttv-cta-pat tt-planilha.ttv-descricao tt-planilha.ttv-cta-pat-para tt-planilha.ttv-bem-de tt-planilha.ttv-inc-de tt-planilha.ttv-desmembrar tt-planilha.ttv-bem-para tt-planilha.ttv-inc-para tt-planilha.ttv-cc-de tt-planilha.ttv-cc-para tt-planilha.ttv-dt-aquisicao tt-planilha.ttv-descricao1 tt-planilha.ttv-descricao-de tt-planilha.ttv-descricao-para tt-planilha.ttv-local-de tt-planilha.ttv-local-para tt-planilha.ttv-ps tt-planilha.ttv-cod-especie tt-planilha.ttv-des-especie tt-planilha.ttv-taxa-conta tt-planilha.ttv-vlr-original tt-planilha.ttv-vlr-original-corr tt-planilha.ttv-depreciacao tt-planilha.ttv-situacao tt-planilha.ttv-nf tt-planilha.ttv-fornecedor tt-planilha.ttv-dt-base-arquivo tt-planilha.ttv-taxa-societaria tt-planilha.ttv-residual   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-planilha WHERE tt-planilha.ttv-selected = "*"              INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha WHERE tt-planilha.ttv-selected = "*"              INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-planilha


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-13 BUTTON-11 bt-executar ~
bt-importar c-planilha bt-dir-entrada l-desmembra BROWSE-2 c-motivo ~
c-status 
&Scoped-Define DISPLAYED-OBJECTS c-planilha l-desmembra c-motivo c-status ~
FILL-IN-4 FILL-IN-5 FILL-IN-6 

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

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "image/gr-fil.bmp":U
     LABEL "Button 11" 
     SIZE 4 BY 1.13.

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

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Necessita de aá∆o posterior" 
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

DEFINE VARIABLE l-desmembra AS LOGICAL INITIAL no 
     LABEL "Desmembramento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-planilha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-livre _FREEFORM
  QUERY BROWSE-2 DISPLAY
      tt-planilha.ttv-selected             COLUMN-LABEL "Sel"
tt-planilha.ttv-tratamento           column-label "Acao"  FORMAT "x(40)"
tt-planilha.ttv-localizacao-de       column-label "Local DE"
tt-planilha.ttv-localizacao-para     column-label "Local PARA"
tt-planilha.ttv-cta-pat              column-label "CtaPat DE"
tt-planilha.ttv-descricao            column-label "Descricao"
tt-planilha.ttv-cta-pat-para         column-label "CtaPat PARA"
tt-planilha.ttv-bem-de               column-label "Bem DE"
tt-planilha.ttv-inc-de               column-label "Inc DE"
tt-planilha.ttv-desmembrar           column-label "Desmenbrar"
tt-planilha.ttv-bem-para             column-label "Bem PARA"
tt-planilha.ttv-inc-para             column-label "Inc PARA"
tt-planilha.ttv-cc-de                column-label "CC DE"
tt-planilha.ttv-cc-para              column-label "CC PARA"
tt-planilha.ttv-dt-aquisicao         column-label "Dt.Aquisicao"
tt-planilha.ttv-descricao1           column-label "Descricao DE"
tt-planilha.ttv-descricao-de         column-label "Descricao PARA"
tt-planilha.ttv-descricao-para       column-label "Narrativa"
tt-planilha.ttv-local-de             column-label "Local DE"
tt-planilha.ttv-local-para           column-label "Local PARA"
tt-planilha.ttv-ps                   column-label "PS"
tt-planilha.ttv-cod-especie          column-label "Cod-Especie"
tt-planilha.ttv-des-especie          column-label "Descricao Especie"
tt-planilha.ttv-taxa-conta           column-label "Taxa"
tt-planilha.ttv-vlr-original         column-label "Vlr.Original"
tt-planilha.ttv-vlr-original-corr    column-label "Vlr.Original Corrigido"
tt-planilha.ttv-depreciacao          column-label "Depreciacao"
tt-planilha.ttv-situacao             column-label "Situacao"
tt-planilha.ttv-nf                   column-label "NF"
tt-planilha.ttv-fornecedor           column-label "Fornecedor"
tt-planilha.ttv-dt-base-arquivo      column-label "Dt-Base"
tt-planilha.ttv-taxa-societaria      column-label "Tx.Societaria"
tt-planilha.ttv-residual             column-label "Residual"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123.43 BY 12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     BUTTON-11 AT ROW 1.17 COL 92.57 WIDGET-ID 60
     bt-executar AT ROW 1.21 COL 19.43 WIDGET-ID 4
     bt-importar AT ROW 1.25 COL 1.57 WIDGET-ID 2
     c-planilha AT ROW 1.25 COL 42.72 COLON-ALIGNED WIDGET-ID 8
     bt-dir-entrada AT ROW 1.25 COL 86.14 HELP
          "Escolha do nome do arquivo" WIDGET-ID 24
     l-desmembra AT ROW 2.75 COL 5 WIDGET-ID 66
     BROWSE-2 AT ROW 4.29 COL 2.43 WIDGET-ID 200
     c-motivo AT ROW 19.75 COL 21.57 NO-LABEL WIDGET-ID 26
     c-status AT ROW 19.79 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-4 AT ROW 20.92 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-5 AT ROW 20.92 COL 39.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-6 AT ROW 20.92 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     "Aá‰es" VIEW-AS TEXT
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
/* BROWSE-TAB BROWSE-2 l-desmembra f-cad */
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
OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha WHERE tt-planilha.ttv-selected = "*"
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
ON MOUSE-SELECT-CLICK OF BROWSE-2 IN FRAME f-cad
DO:
  ASSIGN c-motivo:SCREEN-VALUE = tt-planilha.ttv-motivo
         c-status:SCREEN-VALUE = tt-planilha.ttv-status.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 w-livre
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME f-cad
DO:
    IF INPUT FRAME {&FRAME-NAME} l-desmembra THEN DO:
        IF tt-planilha.ttv-selected = "*" THEN
            ASSIGN tt-planilha.ttv-selected = '*':r.
        ELSE
            ASSIGN tt-planilha.ttv-selected = '*':r.

    END.

    IF INPUT FRAME {&FRAME-NAME} l-desmembra = NO THEN DO:
        IF tt-planilha.ttv-selected = "*" THEN
            ASSIGN tt-planilha.ttv-selected = '':r.
        ELSE
            ASSIGN tt-planilha.ttv-selected = '*':r.

    END.

      DISP tt-planilha.ttv-selected WITH BROWSE browse-2.

      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 w-livre
ON ROW-DISPLAY OF BROWSE-2 IN FRAME f-cad
DO:
  CASE tt-planilha.ttv-status:

      WHEN 'Concluido' THEN DO:

ASSIGN
tt-planilha.ttv-tratamento:BGCOLOR IN browse browse-2 = 10        
tt-planilha.ttv-localizacao-de:BGCOLOR IN browse browse-2 = 10    
tt-planilha.ttv-localizacao-para:BGCOLOR IN browse browse-2 = 10  
tt-planilha.ttv-cta-pat:BGCOLOR IN browse browse-2 = 10           
tt-planilha.ttv-descricao:BGCOLOR IN browse browse-2 = 10         
tt-planilha.ttv-cta-pat-para:BGCOLOR IN browse browse-2 = 10      
tt-planilha.ttv-bem-de:BGCOLOR IN browse browse-2 = 10            
tt-planilha.ttv-inc-de:BGCOLOR IN browse browse-2 = 10            
tt-planilha.ttv-desmembrar:BGCOLOR IN browse browse-2 = 10        
tt-planilha.ttv-bem-para:BGCOLOR IN browse browse-2 = 10          
tt-planilha.ttv-inc-para:BGCOLOR IN browse browse-2 = 10          
tt-planilha.ttv-cc-de:BGCOLOR IN browse browse-2 = 10             
tt-planilha.ttv-cc-para:BGCOLOR IN browse browse-2 = 10           
tt-planilha.ttv-dt-aquisicao:BGCOLOR IN browse browse-2 = 10      
tt-planilha.ttv-descricao1:BGCOLOR IN browse browse-2 = 10   //descricao original     
tt-planilha.ttv-descricao-de:BGCOLOR IN browse browse-2 = 10 //nova descricao     
tt-planilha.ttv-descricao-para:BGCOLOR IN browse browse-2 = 10  //narativa
tt-planilha.ttv-local-de:BGCOLOR IN browse browse-2 = 10          
tt-planilha.ttv-local-para:BGCOLOR IN browse browse-2 = 10        
tt-planilha.ttv-ps:BGCOLOR IN browse browse-2 = 10                
tt-planilha.ttv-cod-especie:BGCOLOR IN browse browse-2 = 10      
tt-planilha.ttv-des-especie:BGCOLOR IN browse browse-2 = 10       
tt-planilha.ttv-taxa-conta:BGCOLOR IN browse browse-2 = 10        
tt-planilha.ttv-vlr-original:BGCOLOR IN browse browse-2 = 10      
tt-planilha.ttv-vlr-original-corr:BGCOLOR IN browse browse-2 = 10 
tt-planilha.ttv-depreciacao:BGCOLOR IN browse browse-2 = 10       
tt-planilha.ttv-situacao:BGCOLOR IN browse browse-2 = 10          
tt-planilha.ttv-nf:BGCOLOR IN browse browse-2 = 10                
tt-planilha.ttv-fornecedor:BGCOLOR IN browse browse-2 = 10        
tt-planilha.ttv-dt-base-arquivo:BGCOLOR IN browse browse-2 = 10   
tt-planilha.ttv-taxa-societaria:BGCOLOR IN browse browse-2 = 10   
tt-planilha.ttv-residual:BGCOLOR IN browse browse-2 = 10          
.
      END.

          WHEN 'Falta aá∆o' THEN DO:

    ASSIGN
    tt-planilha.ttv-tratamento:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-localizacao-de:BGCOLOR IN browse browse-2    = 14    
    tt-planilha.ttv-localizacao-para:BGCOLOR IN browse browse-2  = 14  
    tt-planilha.ttv-cta-pat:BGCOLOR IN browse browse-2           = 14           
    tt-planilha.ttv-descricao:BGCOLOR IN browse browse-2         = 14         
    tt-planilha.ttv-cta-pat-para:BGCOLOR IN browse browse-2      = 14      
    tt-planilha.ttv-bem-de:BGCOLOR IN browse browse-2            = 14            
    tt-planilha.ttv-inc-de:BGCOLOR IN browse browse-2            = 14            
    tt-planilha.ttv-desmembrar:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-bem-para:BGCOLOR IN browse browse-2          = 14          
    tt-planilha.ttv-inc-para:BGCOLOR IN browse browse-2          = 14          
    tt-planilha.ttv-cc-de:BGCOLOR IN browse browse-2             = 14             
    tt-planilha.ttv-cc-para:BGCOLOR IN browse browse-2           = 14           
    tt-planilha.ttv-dt-aquisicao:BGCOLOR IN browse browse-2      = 14      
    tt-planilha.ttv-descricao1:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-descricao-de:BGCOLOR IN browse browse-2      = 14      
    tt-planilha.ttv-descricao-para:BGCOLOR IN browse browse-2    = 14    
    tt-planilha.ttv-local-de:BGCOLOR IN browse browse-2          = 14          
    tt-planilha.ttv-local-para:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-ps:BGCOLOR IN browse browse-2                = 14                
    tt-planilha.ttv-cod-especie:BGCOLOR IN browse browse-2       = 14      
    tt-planilha.ttv-des-especie:BGCOLOR IN browse browse-2       = 14       
    tt-planilha.ttv-taxa-conta:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-vlr-original:BGCOLOR IN browse browse-2      = 14      
    tt-planilha.ttv-vlr-original-corr:BGCOLOR IN browse browse-2 = 14 
    tt-planilha.ttv-depreciacao:BGCOLOR IN browse browse-2       = 14       
    tt-planilha.ttv-situacao:BGCOLOR IN browse browse-2          = 14          
    tt-planilha.ttv-nf:BGCOLOR IN browse browse-2                = 14                
    tt-planilha.ttv-fornecedor:BGCOLOR IN browse browse-2        = 14        
    tt-planilha.ttv-dt-base-arquivo:BGCOLOR IN browse browse-2   = 14   
    tt-planilha.ttv-taxa-societaria:BGCOLOR IN browse browse-2   = 14   
    tt-planilha.ttv-residual:BGCOLOR IN browse browse-2          = 14 .         
      END.

      WHEN 'Erro' THEN DO:

ASSIGN
tt-planilha.ttv-tratamento:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-localizacao-de:BGCOLOR IN browse browse-2    = 12    
tt-planilha.ttv-localizacao-para:BGCOLOR IN browse browse-2  = 12  
tt-planilha.ttv-cta-pat:BGCOLOR IN browse browse-2           = 12           
tt-planilha.ttv-descricao:BGCOLOR IN browse browse-2         = 12         
tt-planilha.ttv-cta-pat-para:BGCOLOR IN browse browse-2      = 12      
tt-planilha.ttv-bem-de:BGCOLOR IN browse browse-2            = 12            
tt-planilha.ttv-inc-de:BGCOLOR IN browse browse-2            = 12            
tt-planilha.ttv-desmembrar:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-bem-para:BGCOLOR IN browse browse-2          = 12          
tt-planilha.ttv-inc-para:BGCOLOR IN browse browse-2          = 12          
tt-planilha.ttv-cc-de:BGCOLOR IN browse browse-2             = 12             
tt-planilha.ttv-cc-para:BGCOLOR IN browse browse-2           = 12           
tt-planilha.ttv-dt-aquisicao:BGCOLOR IN browse browse-2      = 12      
tt-planilha.ttv-descricao1:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-descricao-de:BGCOLOR IN browse browse-2      = 12      
tt-planilha.ttv-descricao-para:BGCOLOR IN browse browse-2    = 12    
tt-planilha.ttv-local-de:BGCOLOR IN browse browse-2          = 12          
tt-planilha.ttv-local-para:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-ps:BGCOLOR IN browse browse-2                = 12                
tt-planilha.ttv-cod-especie:BGCOLOR IN browse browse-2       = 12      
tt-planilha.ttv-des-especie:BGCOLOR IN browse browse-2       = 12       
tt-planilha.ttv-taxa-conta:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-vlr-original:BGCOLOR IN browse browse-2      = 12      
tt-planilha.ttv-vlr-original-corr:BGCOLOR IN browse browse-2 = 12 
tt-planilha.ttv-depreciacao:BGCOLOR IN browse browse-2       = 12       
tt-planilha.ttv-situacao:BGCOLOR IN browse browse-2          = 12          
tt-planilha.ttv-nf:BGCOLOR IN browse browse-2                = 12                
tt-planilha.ttv-fornecedor:BGCOLOR IN browse browse-2        = 12        
tt-planilha.ttv-dt-base-arquivo:BGCOLOR IN browse browse-2   = 12   
tt-planilha.ttv-taxa-societaria:BGCOLOR IN browse browse-2   = 12   
tt-planilha.ttv-residual:BGCOLOR IN browse browse-2          = 12 .         
  END.

  END CASE.
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

    IF INPUT FRAME {&FRAME-NAME} l-desmembra = NO THEN DO:
        {&OPEN-QUERY-browse-2}


        ASSIGN i-cont = 300.


    FOR EACH dwb_set_list WHERE dwb_set_list.cod_dwb_program = "tar_transferencia_interna"
                          AND   dwb_set_list.cod_dwb_user = v_cod_usuaR_corren:

        DELETE dwb_set_list.
    END.

    FOR EACH dwb_set_list WHERE dwb_set_list.cod_dwb_program = "tar_reclassif_bem_pat"
                          AND   dwb_set_list.cod_dwb_user = v_cod_usuaR_corren:

        DELETE dwb_set_list.
    END.

    FOR EACH dwb_set_list WHERE dwb_set_list.cod_dwb_program = "tar_baixa"
                          AND   dwb_set_list.cod_dwb_user = v_cod_usuaR_corren:

        DELETE dwb_set_list.
    END.


    FOR EACH TT-PLANILHA NO-LOCK WHERE TT-PLANILHA.TTV-SELECTED = "*":
            
//      do i-cont = 1 to browse-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
          //          if  browse-2:fetch-selected-row (i-cont) then do:
            case tt-planilha.ttv-tratamento:

                WHEN 'Baixa' THEN DO:
                    RUN pi-baixa.
                    ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                           tt-planilha.ttv-motivo = "Executar programa de BAIXA".
                END.
                when "Transferencia" then do:
                    run pi-transferencia.
                    ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                           tt-planilha.ttv-motivo = "Executar programa de TRANSFERENCIA INTERNA".
                    
                end.
                when "Reclassificaá∆o" then do:
                    run pi-reclassificar.
                    ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                           tt-planilha.ttv-motivo = "Executar programa de RECLASSIFICACAO".
                    

                end.
                when "Reclassificaá∆o, Transferencia" then do:
                    run pi-reclassificar.
                    RUN pi-transferencia.
                    ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                           tt-planilha.ttv-motivo = "Executar programa de TRANSFERENCIA INTERNA/RECLASSIFICACAO".

             
                end.
                when "Alteraá∆o" then do:
                    run dop\pi-alterar.p(INPUT tt-planilha.ttv-bem-de,
                                   input tt-planilha.ttv-cta-pat-para,
                                   input tt-planilha.ttv-inc-de,
                                   input tt-planilha.ttv-descricao-para, //narrativa
                                   INPUT tt-planilha.ttv-descricao-de, //descricao nova
                                   input tt-planilha.ttv-localizacao-para,
                                   input tt-planilha.ttv-bem-para,
                                   INPUT tt-planilha.ttv-cod-empresa,
                                   input tt-planilha.ttv-bem-para,
                                   input tt-planilha.ttv-inc-para,
                                   OUTPUT TABLE tt-erro).
                        FIND FIRST tt-erro NO-ERROR.

                        IF NOT AVAIL tt-erro THEN DO:
                            ASSIGN tt-planilha.ttv-status = "Concluido".
                        END.
                        ELSE DO:
                             ASSIGN tt-planilha.ttv-status = "Erro"
                                   tt-planilha.ttv-motivo = tt-erro.ttv-descricao.
                        END.
                end.
                when "Alteraá∆o, Transferencia" then do:
                    run dop\pi-alterar.p(INPUT tt-planilha.ttv-bem-de,
                                   input tt-planilha.ttv-cta-pat-para,
                                   input tt-planilha.ttv-inc-de,
                                   input tt-planilha.ttv-descricao-para, //narrativa
                                   INPUT tt-planilha.ttv-descricao-de, //descricao nova
                                   input tt-planilha.ttv-localizacao-para,
                                   input tt-planilha.ttv-bem-para,
                                   INPUT tt-planilha.ttv-cod-empresa,
                                   input tt-planilha.ttv-bem-para,
                                   input tt-planilha.ttv-inc-para,
                                   OUTPUT TABLE tt-erro).

                    FIND FIRST tt-erro NO-ERROR.
                    IF NOT AVAIL tt-erro THEN DO:
                        RUN pi-transferencia.
                        ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                               tt-planilha.ttv-motivo = "Executar programa de TRANSFERENCIA INTERNA".
                        

                    END.
                        ELSE DO:
                             ASSIGN tt-planilha.ttv-status = "Erro"
                                   tt-planilha.ttv-motivo = tt-erro.ttv-descricao.
                        END.
                end.
                when "Alteraá∆o, Reclassificaá∆o" then do:
                    run dop\pi-alterar.p(INPUT tt-planilha.ttv-bem-de,
                                   input tt-planilha.ttv-cta-pat-para,
                                   input tt-planilha.ttv-inc-de,
                                   input tt-planilha.ttv-descricao-para, //narrativa
                                   INPUT tt-planilha.ttv-descricao-de, //descricao nova
                                   input tt-planilha.ttv-localizacao-para,
                                   input tt-planilha.ttv-bem-para,
                                   INPUT tt-planilha.ttv-cod-empresa,
                                   input tt-planilha.ttv-bem-para,
                                   input tt-planilha.ttv-inc-para,
                                   OUTPUT TABLE tt-erro).

                    FIND FIRST tt-erro NO-ERROR.
                    IF NOT AVAIL tt-erro THEN DO:
                        RUN pi-reclassificar.
                        ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                               tt-planilha.ttv-motivo = "Executar programa de RECLASSIFICAÄAO".


                    END.
                        ELSE DO:
                             ASSIGN tt-planilha.ttv-status = "Erro"
                                   tt-planilha.ttv-motivo = tt-erro.ttv-descricao.
                        END.
                end.

                when "Alteraá∆o, Reclassificaá∆o, Transferencia" then do:
                    run dop\pi-alterar.p(INPUT tt-planilha.ttv-bem-de,
                                   input tt-planilha.ttv-cta-pat-para,
                                   input tt-planilha.ttv-inc-de,
                                   input tt-planilha.ttv-descricao-para, //narrativa
                                   INPUT tt-planilha.ttv-descricao-de, //descricao nova
                                   input tt-planilha.ttv-localizacao-para,
                                   input tt-planilha.ttv-bem-para,
                                   INPUT tt-planilha.ttv-cod-empresa,
                                   input tt-planilha.ttv-bem-para,
                                   input tt-planilha.ttv-inc-para,
                                   OUTPUT TABLE tt-erro).

                    FIND FIRST tt-erro NO-ERROR.
                    IF NOT AVAIL tt-erro THEN DO:
                            RUN pi-reclassificar.
                            RUN pi-transferencia.
                            ASSIGN tt-planilha.ttv-status = "Falta aá∆o"
                                   tt-planilha.ttv-motivo = "Executar programa de TRANSFERENCIA INTERNA e RECLASSIFICAÄAO".


                    END.
                            ELSE DO:
                                 ASSIGN tt-planilha.ttv-status = "Erro"
                                       tt-planilha.ttv-motivo = tt-erro.ttv-descricao.
                            END.
                END.

            END.
      END.

    END.
      {&OPEN-QUERY-browse-2}


          IF INPUT FRAME {&FRAME-NAME} l-desmembra = YES THEN DO:
              {&OPEN-QUERY-browse-2}
                  RUN pi-desmembrar.
              {&OPEN-QUERY-browse-2}
          END.


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


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 w-livre
ON CHOOSE OF BUTTON-11 IN FRAME f-cad /* Button 11 */
DO:

    ASSIGN w-livre:SENSITIVE = NO.

      run dop/dco555a.w (INPUT-OUTPUT TABLE tt-filtro, OUTPUT c-acao). 

    ASSIGN w-livre:SENSITIVE = YES.

    IF c-acao = "atualizar" THEN DO:
        /*ASSIGN i-linha-browse = 0.*/
        RUN pi-carrega-tabela.
        {&OPEN-QUERY-browse-2}

            ASSIGN v-num-linha = browse-2:NUM-ITERATIONS.



    end.

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
             BUTTON-11:HANDLE IN FRAME f-cad , 'AFTER':U ).
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
  DISPLAY c-planilha l-desmembra c-motivo c-status FILL-IN-4 FILL-IN-5 FILL-IN-6 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-13 BUTTON-11 bt-executar bt-importar c-planilha 
         bt-dir-entrada l-desmembra BROWSE-2 c-motivo c-status 
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
           chWorkSheet = chWorkBook:worksheets(2).
    
    Assign i-linha = 1
           l-erro  = No.
   
    ASSIGN bt-importar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    RUN utp\ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Importando planilha").
    
   Repeat:

    
        i-linha = i-linha + 1.
    
        RUN pi-acompanhar IN h-prog(INPUT "Linha :" + STRING(i-linha)).
       IF chWorkSheet:cells(i-linha, 1):Text = ""  Then Leave.

       create tt-planilha.
       assign tt-planilha.ttv-status               = chWorkSheet:cells(i-linha, 1):Text
              tt-planilha.ttv-localizacao-de       = chWorkSheet:cells(i-linha, 2):Text
              tt-planilha.ttv-localizacao-para     = chWorkSheet:cells(i-linha, 3):Text
              tt-planilha.ttv-cta-pat              = chWorkSheet:cells(i-linha, 4):Text
              tt-planilha.ttv-descricao            = chWorkSheet:cells(i-linha, 5):text
              tt-planilha.ttv-cta-pat-para         = chWorkSheet:cells(i-linha, 6):Text
              tt-planilha.ttv-bem-de               = chWorkSheet:cells(i-linha, 7):Text
              tt-planilha.ttv-inc-de               = chWorkSheet:cells(i-linha, 8):Text 
              tt-planilha.ttv-foto                 = chWorkSheet:cells(i-linha, 9):Text
              tt-planilha.ttv-bem-para             = chWorkSheet:cells(i-linha, 11):Text
              tt-planilha.ttv-inc-para             = chWorkSheet:cells(i-linha, 12):Text
              tt-planilha.ttv-cc-de                = chWorkSheet:cells(i-linha, 13):Text
              tt-planilha.ttv-cc-para              = chWorkSheet:cells(i-linha, 14):Text
              tt-planilha.ttv-dt-aquisicao         = date(chWorkSheet:cells(i-linha, 15):Text)
              tt-planilha.ttv-descricao1           = chWorkSheet:cells(i-linha, 16):Text
              tt-planilha.ttv-descricao-de         = chWorkSheet:cells(i-linha, 17):Text
              tt-planilha.ttv-descricao-para       = chWorkSheet:cells(i-linha, 18):Text
              tt-planilha.ttv-local-de             = chWorkSheet:cells(i-linha, 19):Text
              tt-planilha.ttv-local-para           = chWorkSheet:cells(i-linha, 20):Text
              tt-planilha.ttv-ps                   = chWorkSheet:cells(i-linha, 21):text
              tt-planilha.ttv-cod-especie          = chWorkSheet:cells(i-linha, 22):Text
              tt-planilha.ttv-des-especie          = chWorkSheet:cells(i-linha, 23):Text
              tt-planilha.ttv-taxa-conta           = chWorkSheet:cells(i-linha, 24):Text
              tt-planilha.ttv-vlr-original         = chWorkSheet:cells(i-linha, 25):Text
              tt-planilha.ttv-vlr-original-corr    = chWorkSheet:cells(i-linha, 26):text
              tt-planilha.ttv-depreciacao          = chWorkSheet:cells(i-linha, 27):text
              tt-planilha.ttv-situacao             = chWorkSheet:cells(i-linha, 28):text
              tt-planilha.ttv-nf                   = chWorkSheet:cells(i-linha, 29):text
              tt-planilha.ttv-fornecedor           = chWorkSheet:cells(i-linha, 30):text
              tt-planilha.ttv-taxa-societaria      = chWorkSheet:cells(i-linha, 32):text
              tt-planilha.ttv-residual             = chWorkSheet:cells(i-linha, 33):TEXT
              tt-planilha.ttv-selected             = "*"
              tt-planilha.ttv-status-origInal       = chWorkSheet:cells(i-linha, 1):Text.
             IF date(chWorkSheet:cells(i-linha, 31):text) = ? THEN
                 ASSIGN tt-planilha.ttv-dt-base-arquivo      = TODAY.
             ELSE 
                 ASSIGN tt-planilha.ttv-dt-base-arquivo      = date(chWorkSheet:cells(i-linha, 31):text).

          IF chWorkSheet:cells(i-linha, 10):Text   <> "" THEN
              ASSIGN        tt-planilha.ttv-desmembrar           = YES.
          ELSE 
              ASSIGN        tt-planilha.ttv-desmembrar           = NO.

              

   END.
   RUN pi-finalizar IN h-prog. 
        chExcel:QUIT().
        ASSIGN bt-importar:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

for each tt-planilha no-lock:

    find first bem_pat no-lock where bem_pat.cod_cta_pat      = tt-planilha.ttv-cta-pat
                               and   bem_pat.num_bem_pat      = int(tt-planilha.ttv-bem-de)
                               and   bem_pat.num_seq_bem_pat  = int(tt-planilha.ttv-inc-de) no-error.

    if avail bem_pat then do:

    assign tt-planilha.ttv-estabel = bem_pat.cod_estab
           tt-planilha.ttv-concatena-de =   (bem_pat.cod_estab) + "|" + string(bem_pat.cod_cta_pat)          + "|" + string(bem_pat.num_bem_pat)      + "|" + string(bem_pat.num_seq_bem_pat) + "|" + STRING(bem_pat.cod_ccusto_respons) + "|" +  STRING(bem_pat.des_bem_pat) + "|" + STRING(bem_pat.cod_localiz)
           tt-planilha.ttv-concatena-para = (bem_pat.cod_estab) + "|" + string(tt-planilha.ttv-cta-pat-para) + "|" + string(tt-planilha.ttv-bem-para) + "|" + string(tt-planilha.ttv-inc-para) + "|" + STRING(tt-planilha.ttv-cc-para) + "|" + STRING(tt-planilha.ttv-descricao) + "|" + STRING(tt-planilha.ttv-localizacao-para) 
           tt-planilha.ttv-cod-empresa    = bem_pat.cod_empresa.

    end.

    ELSE ASSIGN tt-planilha.ttv-tratamento = "INEXISTENTE NO ATIVO".

    if length(tt-planilha.ttv-bem-para) > 9 then
    assign tt-planilha.ttv-status = "Erro"
           tt-planilha.ttv-score  = 0
           tt-planilha.ttv-motivo = "Tamanho maximo do campo 9 digitos. Bem tem " + STRING(length(tt-planilha.ttv-bem-para)).

end.

for each tt-planilha WHERE tt-planilha.ttv-concatena-de <> "":


    
    if   ENTRY(2, tt-planilha.ttv-concatena-de, "|") <> entry(2, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 1.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

    if   ENTRY(3, tt-planilha.ttv-concatena-de, "|") <> entry(3, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 103.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

    if   ENTRY(4, tt-planilha.ttv-concatena-de, "|") <> entry(4, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 210.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

    if   ENTRY(5, tt-planilha.ttv-concatena-de, "|") <> entry(5, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 325.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

    if   ENTRY(6, tt-planilha.ttv-concatena-de, "|") <> entry(6, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 487.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

    if   ENTRY(7, tt-planilha.ttv-concatena-de, "|") <> entry(7, tt-planilha.ttv-concatena-para, "|") THEN
        ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 679.
        ELSE ASSIGN tt-planilha.ttv-score = tt-planilha.ttv-score + 0.

END.

FOR EACH tt-planilha WHERE tt-planilha.ttv-score > 0:

    IF tt-planilha.ttv-status-original <> "identificado" THEN DO:
        ASSIGN tt-planilha.ttv-tratamento = "BAIXA".
        NEXT.
    END.
    ASSIGN i-memo = tt-planilha.ttv-score.

    FIND FIRST tt-score NO-LOCK WHERE LOOKUP(string(i-memo), tt-score.ttv-score, ",") > 0 NO-ERROR.
     
    IF AVAIL tt-score THEN

            ASSIGN tt-planilha.ttv-tratamento = tt-score.ttv-tratamento.

        ELSE

            ASSIGN tt-planilha.ttv-tratamento = "ERRO".


END.

    IF INPUT FRAME {&FRAME-NAME} l-desmembra = YES THEN DO:
        for each tt-planilha:

                CASE tt-planilha.ttv-desmembrar:
                WHEN YES THEN DO:
                    ASSIGN tt-planilha.ttv-tratamento = "Desmembra".
                    find first bem_pat no-lock where bem_pat.cod_cta_pat      = tt-planilha.ttv-cta-pat
                                                     and   bem_pat.num_bem_pat      = int(tt-planilha.ttv-bem-de)
                                                     and   bem_pat.num_seq_bem_pat  = int(tt-planilha.ttv-inc-de) no-error.

                          IF NOT AVAIL bem_pat THEN
                              ASSIGN tt-planilha.ttv-tratamento = "Inexistente no Ativo"
                                     tt-planilha.ttv-status     = 'erro'.


                END.
                OTHERWISE DO:
                    DELETE tt-planilha.
                END.
            END CASE.

      
        end.
    END.
        
        IF INPUT FRAME {&FRAME-NAME} l-desmembra = NO THEN DO:
            for each tt-planilha:
                CASE tt-planilha.ttv-desmembrar:

                    WHEN YES THEN DO:
                        DELETE tt-planilha.
                    END.
                END CASE.

            end.
      

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
  CREATE tt-score.
  ASSIGN tt-score.ttv-tratamento = "Transferencia" 
         tt-score.ttv-score      = "325".

  CREATE tt-score.
  ASSIGN tt-score.ttv-tratamento = "Reclassificaá∆o" 
         tt-score.ttv-score      = "1".

  CREATE tt-score.
  ASSIGN tt-score.ttv-tratamento = "Reclassificaá∆o, Transferencia" 
         tt-score.ttv-score      = "326".

  CREATE tt-score.
  ASSIGN tt-score.ttv-tratamento = "Alteraá∆o" 
         tt-score.ttv-score      = "103,210,313,487,590,697,800,679,782,889,992,1166,1269,1376,1479".

  CREATE tt-score.                              
  ASSIGN tt-score.ttv-tratamento = "Alteraá∆o, Transferencia" 
         tt-score.ttv-score      = "428,535,638,812,915,1022,1125,1004,1107,1214,1317,1491,1594,1701,1804".

  CREATE tt-score.                              
  ASSIGN tt-score.ttv-tratamento = "Alteraá∆o, Reclassificaá∆o" 
         tt-score.ttv-score      = "104,211,314,488,591,698,801,680,783,890,993,11167,1270,1377,1480".

  CREATE tt-score.                              
  ASSIGN tt-score.ttv-tratamento = "Alteraá∆o, Reclassificaá∆o, Transferencia" 
         tt-score.ttv-score      = "429,536,639,813,916,1023,1126,1005,1108,1215,1318,1492,1595,1702,1805".


  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-baixa w-livre 
PROCEDURE pi-baixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN v_cod_dwb_program  = "tar_baixa"
       v_cod_dwb_user     = v_cod_usuar_corren.

ASSIGN v_cod_dwb_set_parameters_mor = "" + chr(10) + "" + chr(10) + "" + chr(10) + "" + chr(10) + "".

    IF tt-planilha.ttv-dt-base-arquivo = ? THEN
    ASSIGN tt-planilha.ttv-dt-base-arquivo = TODAY.


create dwb_set_list.
assign dwb_set_list.ind_dwb_set_type = "Regra"
    dwb_set_list.cod_dwb_user        = v_cod_usuar_corren
    dwb_set_list.cod_dwb_program     = v_cod_dwb_program
    dwb_set_list.cod_dwb_set_initial = ""
    dwb_set_list.cod_dwb_set_final   = ""
    dwb_set_list.cod_dwb_set         = "Individual"
    dwb_set_list.cod_dwb_set_single  = trim(tt-planilha.ttv-cta-pat) + CHR(10) + STRING(tt-planilha.ttv-bem-para) + CHR(10) + STRING(tt-planilha.ttv-inc-para)
    dwb_set_list.cod_dwb_set_parameters = STRING(tt-planilha.ttv-dt-base-arquivo) + CHR(10) + "" + CHR(10) + "fiscal" + CHR(10) + "real"
    + CHR(10) + "0" + CHR(10) + "100" + CHR(10) + "0" + CHR(10) + v_cod_dwb_set_parameters_mor + CHR(10) + "Percentual" + CHR(10) + "Inutilizaá∆o" + CHR(10)
    dwb_set_list.num_dwb_order = i-cont. //definir um motivo valido 
ASSIGN i-cont = i-cont + 1.

FIND FIRST dwb_set_list WHERE dwb_set_list.cod_dwb_program = 'tar_baixa' NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tabela w-livre 
PROCEDURE pi-carrega-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-planilha:

    FIND FIRST tt-filtro NO-LOCK NO-ERROR.

    CASE tt-planilha.ttv-tratamento:
        WHEN 'Transferencia' THEN DO:
            IF tt-filtro.ttv-trans THEN

            ASSIGN tt-planilha.ttv-selected = "*".
            ELSE
            ASSIGN tt-planilha.ttv-selected = "".
        END.
        WHEN 'Reclassificaá∆o' THEN DO:
            IF tt-filtro.ttv-reclassificao THEN
            ASSIGN tt-planilha.ttv-selected = "*".
            ELSE
            ASSIGN tt-planilha.ttv-selected = "".
        END.
        WHEN 'Reclassificaá∆o,Transferencia' THEN DO:
            IF tt-filtro.ttv-reclas-transf THEN
                ASSIGN tt-planilha.ttv-selected = "*".
                ELSE
                ASSIGN tt-planilha.ttv-selected = "".
        END.
        WHEN 'Alteraá∆o' THEN DO:
            IF tt-filtro.ttv-alteracao THEN
                ASSIGN tt-planilha.ttv-selected = "*".
                ELSE
                ASSIGN tt-planilha.ttv-selected = "".

        END.
        WHEN 'Alteraá∆o, Transferencia' THEN DO:
            IF tt-filtro.ttv-alt-transf THEN
                ASSIGN tt-planilha.ttv-selected = "*".
                ELSE
                ASSIGN tt-planilha.ttv-selected = "".

        END.
        WHEN 'Alteraá∆o, Reclassificaá∆o' THEN DO:
            IF tt-filtro.ttv-alt-reclas THEN
                ASSIGN tt-planilha.ttv-selected = "*".
                ELSE
                ASSIGN tt-planilha.ttv-selected = "".

        END.
        WHEN 'Alteraá∆o, Reclassificaá∆o, Transferencia' THEN DO:
            IF tt-filtro.ttv-alt-reclas-trans THEN
                ASSIGN tt-planilha.ttv-selected = "*".
                ELSE
                ASSIGN tt-planilha.ttv-selected = "".

        END.
        
    END CASE.



END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desmembrar w-livre 
PROCEDURE pi-desmembrar :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/

  empty temp-table tt_desmemb_novos_bem_pat_api.
  empty temp-table tt_desmembramento_bem_pat_api.
for each tt-planilha where tt-planilha.ttv-selected = "*" 
                     AND   tt-planilha.ttv-status   <> "erro" break by tt-planilha.ttv-concatena-de:

  find first plano_ccusto no-lock where plano_ccusto.dat_fim_valid >= today
                                  and   plano_ccusto.cod_empresa   = v_cod_empres_usuar no-error.

  if first-of(tt-planilha.ttv-concatena-de) then do:

    assign v_controle = v_controle + 1.
    create tt_desmembramento_bem_pat_api.
    assign tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto         = v_controle
           tt_desmembramento_bem_pat_api.tta_cod_empresa                = tt-planilha.ttv-cod-empresa
           tt_desmembramento_bem_pat_api.tta_cod_cta_pat                = tt-planilha.ttv-cta-pat
           tt_desmembramento_bem_pat_api.tta_num_bem_pat                = int(tt-planilha.ttv-bem-de)
           tt_desmembramento_bem_pat_api.tta_num_seq_bem_pat            = int(tt-planilha.ttv-inc-de)
           tt_desmembramento_bem_pat_api.ttv_dat_desmbrto               = tt-planilha.ttv-dt-base-arquivo
           tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat   = 'Por valor'
           tt_desmembramento_bem_pat_api.ttv_cod_indic_econ             = 'real'
           tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl             = 'fiscal'
           tt_desmembramento_bem_pat_api.ttv_rec_id_temp_table          = recid(tt_desmembramento_bem_pat_api).
  end.

  create tt_desmemb_novos_bem_pat_api.
  assign tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat                = tt-planilha.ttv-cta-pat-para
         tt_desmemb_novos_bem_pat_api.tta_num_bem_pat                = int(tt-planilha.ttv-bem-para)
         tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat            = int(tt-planilha.ttv-inc-para)
         tt_desmemb_novos_bem_pat_api.tta_des_bem_pat                = tt-planilha.ttv-descricao-de
         tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto           = plano_ccusto.cod_plano_ccusto
         tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons         = tt-planilha.ttv-cc-para
         tt_desmemb_novos_bem_pat_api.tta_cod_estab                  = tt-planilha.ttv-estabel
         tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc             = 'DOC'
         tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat   = dec(tt-planilha.ttv-vlr-original)
         tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto         = v_controle
         tt_desmemb_novos_bem_pat_api.ttv_rec_id_temp_table          = recid(tt_desmemb_novos_bem_pat_api).


end.
  run dop/dcoapi002.p persistent set v_hdl_api_bem_pat_desmbrto (input 1).

  run pi_efetiva_desmemb_bens in v_hdl_api_bem_pat_desmbrto (input-output table tt_desmembramento_bem_pat_api,
                                                             input-output table tt_desmemb_novos_bem_pat_api).


delete procedure v_hdl_api_bem_pat_desmbrto.


for each tt-planilha:
  find first tt_desmembramento_bem_pat_api where tt_desmembramento_bem_pat_api.tta_cod_cta_pat         = tt-planilha.ttv-cta-pat      
                                          and   tt_desmembramento_bem_pat_api.tta_num_bem_pat         = int(tt-planilha.ttv-bem-de)     
                                          and   tt_desmembramento_bem_pat_api.tta_num_seq_bem_pat     = int(tt-planilha.ttv-inc-de)       no-error.

                                          if tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat <> "" then do:
                                            assign tt-planilha.ttv-motivo = tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat
                                                  tt-planilha.ttv-status = 'Erro'.

                                          end.

                                          ELSE
                                              ASSIGN tt-planilha.ttv-status = 'Concluido'.
                                        end.



end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reclassificar w-livre 
PROCEDURE pi-reclassificar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN v_cod_dwb_program  = "tar_reclassif_bem_pat"
       v_cod_dwb_user     = v_cod_usuar_corren.


find first cta_pat no-lock where cta_pat.cod_cta_pat = tt-planilha.ttv-cta-pat-para
                           and   cta_pat.cod_empresa =  v_cod_empres_usuar no-error.

                           find first emsuni.ccusto no-lock where ccusto.cod_empresa = v_cod_empres_usuar
                                                    and    ccusto.cod_ccusto = tt-planilha.ttv-cc-para
                                                    and    ccusto.dat_fim_valid >= today
                                                    no-error.

                            find first ccusto_unid_negoc no-lock where ccusto_unid_negoc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                            no-error.    


                            IF tt-planilha.ttv-dt-base-arquivo = ? THEN
                                ASSIGN tt-planilha.ttv-dt-base-arquivo = TODAY.

create dwb_set_list.
assign dwb_set_list.ind_dwb_set_type = "Regra"
       dwb_set_list.cod_dwb_user        = v_cod_usuar_corren
       dwb_set_list.cod_dwb_program     = v_cod_dwb_program
       dwb_set_list.cod_dwb_set_initial     = ""
       dwb_set_list.cod_dwb_set_final       = ""
       dwb_set_list.cod_dwb_set             = "Individual"
       dwb_set_list.cod_dwb_set_single      = tt-planilha.ttv-cta-pat + CHR(10) + STRING(tt-planilha.ttv-bem-para) + CHR(10) + STRING(tt-planilha.ttv-inc-para)
       dwb_set_list.cod_dwb_set_parameters  = string(tt-planilha.ttv-dt-base-arquivo) + CHR(10) + tt-planilha.ttv-cta-pat-para + CHR(10) + cta_pat.cod_grp_calc + CHR(10)
                                             + "" + CHR(10) + ccusto.cod_plano_ccusto + CHR(10) + tt-planilha.ttv-cc-para + CHR(10) +  tt-planilha.ttv-estabel + CHR(10) 
                                             + ccusto_unid_negoc.cod_unid_negoc + chr(10) + tt-planilha.ttv-localizacao-para + CHR(10)
       dwb_set_list.num_dwb_order = i-cont.
       ASSIGN i-cont = i-cont + 1.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transferencia w-livre 
PROCEDURE pi-transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN v_cod_dwb_program  = "tar_transferencia_interna"
       v_cod_dwb_user     = v_cod_usuar_corren.


find first cta_pat no-lock where cta_pat.cod_cta_pat = tt-planilha.ttv-cta-pat-para
                           and   cta_pat.cod_empresa =  v_cod_empres_usuar no-error.

                           find first emsuni.ccusto no-lock where ccusto.cod_empresa = v_cod_empres_usuar
                                                    and    ccusto.cod_ccusto = tt-planilha.ttv-cc-para
                                                    and    ccusto.dat_fim_valid >= today
                                                    no-error.

                            find first ccusto_unid_negoc no-lock where ccusto_unid_negoc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                            no-error.               

                            IF tt-planilha.ttv-dt-base-arquivo = ? THEN
                            ASSIGN tt-planilha.ttv-dt-base-arquivo = TODAY.


   create dwb_set_list.
   assign dwb_set_list.ind_dwb_set_type = "Regra"
       dwb_set_list.cod_dwb_user        = v_cod_usuar_corren
       dwb_set_list.cod_dwb_program     = v_cod_dwb_program
       dwb_set_list.cod_dwb_set_initial     = ""
       dwb_set_list.cod_dwb_set_final       = ""
       dwb_set_list.cod_dwb_set             = "Individual"
       dwb_set_list.cod_dwb_set_single      = tt-planilha.ttv-cta-pat + CHR(10) + string(tt-planilha.ttv-bem-para) + CHR(10) + string(tt-planilha.ttv-inc-para) + CHR(10)
       dwb_set_list.cod_dwb_set_parameters  = string(tt-planilha.ttv-dt-base-arquivo) + CHR(10) + ccusto.cod_plano_ccusto + CHR(10) + tt-planilha.ttv-cc-para + CHR(10) +
                                             ccusto_unid_negoc.cod_unid_negoc + CHR(10) + tt-planilha.ttv-localizacao-para
       dwb_set_list.num_dwb_order = i-cont.
       ASSIGN i-cont = i-cont + 1.



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

