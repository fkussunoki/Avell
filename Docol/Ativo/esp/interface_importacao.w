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
field ttv-desmembrar                as LOGICAL INITIAL NO
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
FIELD ttv-concatena-para            AS CHAR.
/* Local Variable Definitions ---                                       */
def var ch-excel As Com-handle No-undo.
def var ch-book  As Com-handle No-undo.
def var ch-sheet As Com-handle No-undo.
Def Var i-linha  As Int        No-undo.
Def Var l-erro   As Log        No-undo.
Def Var i        As Int        No-undo.
DEF VAR i-cont AS INTEGER NO-UNDO.
DEF VAR v_cod_dwb_program AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF VAR v_cod_dwb_user AS CHAR NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-planilha.ttv-status tt-planilha.ttv-localizacao-de tt-planilha.ttv-localizacao-para tt-planilha.ttv-cta-pat tt-planilha.ttv-descricao tt-planilha.ttv-cta-pat-para tt-planilha.ttv-bem-de tt-planilha.ttv-inc-de tt-planilha.ttv-desmembrar tt-planilha.ttv-bem-para tt-planilha.ttv-inc-para tt-planilha.ttv-cc-de tt-planilha.ttv-cc-para tt-planilha.ttv-dt-aquisicao tt-planilha.ttv-descricao1 tt-planilha.ttv-descricao-de tt-planilha.ttv-descricao-para tt-planilha.ttv-local-de tt-planilha.ttv-local-para tt-planilha.ttv-ps tt-planilha.ttv-cod-especie tt-planilha.ttv-des-especie tt-planilha.ttv-taxa-conta tt-planilha.ttv-vlr-original tt-planilha.ttv-vlr-original-corr tt-planilha.ttv-depreciacao tt-planilha.ttv-situacao tt-planilha.ttv-nf tt-planilha.ttv-fornecedor tt-planilha.ttv-dt-base-arquivo tt-planilha.ttv-taxa-societaria tt-planilha.ttv-residual   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 tt-planilha.ttv-cc-de   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-planilha
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-planilha
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-planilha


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button BUTTON-1 BROWSE-2 BUTTON-9 ~
BUTTON-10 

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
DEFINE BUTTON BUTTON-1 
     LABEL "Importa Planilha" 
     SIZE 17.14 BY 1.13.

DEFINE BUTTON BUTTON-10 
     LABEL "Gerar Planilha" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-9 
     LABEL "Baixar Bem" 
     SIZE 15 BY 1.13.

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
      tt-planilha.ttv-status               column-label "Status"
tt-planilha.ttv-localizacao-de            column-label "Estab DE"
tt-planilha.ttv-localizacao-para          column-label "Estab PARA"
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
tt-planilha.ttv-descricao1           column-label "Descricao1"
tt-planilha.ttv-descricao-de         column-label "Descricao DE"
tt-planilha.ttv-descricao-para       column-label "Descricao PARA"
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

    ENABLE tt-planilha.ttv-cc-de
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 108.57 BY 13.08 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     BUTTON-1 AT ROW 1.25 COL 1.57 WIDGET-ID 2
     BROWSE-2 AT ROW 2.83 COL 1.86 WIDGET-ID 200
     BUTTON-9 AT ROW 3.58 COL 111.29 WIDGET-ID 4
     BUTTON-10 AT ROW 5.5 COL 111.14 WIDGET-ID 6
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 19.83 WIDGET-ID 100.


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
         HEIGHT             = 19.92
         WIDTH              = 126.43
         MAX-HEIGHT         = 19.92
         MAX-WIDTH          = 126.43
         VIRTUAL-HEIGHT     = 19.92
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha.
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 w-livre
ON CHOOSE OF BUTTON-1 IN FRAME f-cad /* Importa Planilha */
DO:
  RUN importa-planilha.
  {&OPEN-QUERY-browse-2}

  APPLY "value-changed" TO BROWSE browse-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 w-livre
ON CHOOSE OF BUTTON-9 IN FRAME f-cad /* Baixar Bem */
DO:
      do i-cont = 1 to browse-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:

          if  browse-2:fetch-selected-row (i-cont) then do:

            case tt-planilha.ttv-tratamento:
                when "REIMPLANTAR" then do:
                    run pi-baixa.
                end.
                when "ALTERACAO" then do:
                    run pi-alterar.
                end.
                when "RECLASSIFICAR" then do:
                    run pi-reclassificar.
                end.
                when "DESMEMBRAR" then do:
                    run pi-desmembrar.
                end.
            END.
          END.
      END.
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


&Scoped-define BROWSE-NAME BROWSE-2
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
             BUTTON-1:HANDLE IN FRAME f-cad , 'BEFORE':U ).
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
  ENABLE rt-button BUTTON-1 BROWSE-2 BUTTON-9 BUTTON-10 
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
    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add("c:\desenv\docol.xlsx"). 
           ch-sheet = ch-book:worksheets(1).
    
    Assign i-linha = 1
           l-erro  = No.
   
    
   Repeat:
    
        i-linha = i-linha + 1.
    
       IF ch-sheet:cells(i-linha, 1):Text = ""  Then Leave.

       create tt-planilha.
       assign tt-planilha.ttv-status               = ch-sheet:cells(i-linha, 1):Text
              tt-planilha.ttv-localizacao-de       = ch-sheet:cells(i-linha, 2):Text
              tt-planilha.ttv-localizacao-para     = ch-sheet:cells(i-linha, 3):Text
              tt-planilha.ttv-cta-pat              = ch-sheet:cells(i-linha, 4):Text
              tt-planilha.ttv-descricao            = ch-sheet:cells(i-linha, 5):text
              tt-planilha.ttv-cta-pat-para         = ch-sheet:cells(i-linha, 6):Text
              tt-planilha.ttv-bem-de               = ch-sheet:cells(i-linha, 7):Text
              tt-planilha.ttv-inc-de               = ch-sheet:cells(i-linha, 8):Text 
              tt-planilha.ttv-foto                 = ch-sheet:cells(i-linha, 9):Text
              tt-planilha.ttv-desmembrar           = ch-sheet:cells(i-linha, 10):Text
              tt-planilha.ttv-bem-para             = ch-sheet:cells(i-linha, 11):Text
              tt-planilha.ttv-inc-para             = ch-sheet:cells(i-linha, 12):Text
              tt-planilha.ttv-cc-de                = ch-sheet:cells(i-linha, 13):Text
              tt-planilha.ttv-cc-para              = ch-sheet:cells(i-linha, 14):Text
              tt-planilha.ttv-dt-aquisicao         = date(ch-sheet:cells(i-linha, 15):Text)
              tt-planilha.ttv-descricao1           = ch-sheet:cells(i-linha, 16):Text
              tt-planilha.ttv-descricao-de         = ch-sheet:cells(i-linha, 17):Text
              tt-planilha.ttv-descricao-para       = ch-sheet:cells(i-linha, 18):Text
              tt-planilha.ttv-local-de             = ch-sheet:cells(i-linha, 19):Text
              tt-planilha.ttv-local-para           = ch-sheet:cells(i-linha, 20):Text
              tt-planilha.ttv-ps                   = ch-sheet:cells(i-linha, 21):text
              tt-planilha.ttv-cod-especie          = ch-sheet:cells(i-linha, 22):Text
              tt-planilha.ttv-des-especie          = ch-sheet:cells(i-linha, 24):Text
              tt-planilha.ttv-taxa-conta           = ch-sheet:cells(i-linha, 25):Text
              tt-planilha.ttv-vlr-original         = ch-sheet:cells(i-linha, 26):Text
              tt-planilha.ttv-vlr-original-corr    = ch-sheet:cells(i-linha, 27):text
              tt-planilha.ttv-depreciacao          = ch-sheet:cells(i-linha, 28):text
              tt-planilha.ttv-situacao             = ch-sheet:cells(i-linha, 29):text
              tt-planilha.ttv-nf                   = ch-sheet:cells(i-linha, 30):text
              tt-planilha.ttv-fornecedor           = ch-sheet:cells(i-linha, 31):text
              tt-planilha.ttv-dt-base-arquivo      = date(ch-sheet:cells(i-linha, 32):text)
              tt-planilha.ttv-taxa-societaria      = ch-sheet:cells(i-linha, 33):text
              tt-planilha.ttv-residual             = ch-sheet:cells(i-linha, 34):TEXT.
              
   END.

for each tt-planilha no-lock:

    find first bem_pat no-lock where bem_pat.cod_cta_pat      = tt-planilha.ttv-cta-pat
                               and   bem_pat.num_bem_pat      = int(tt-planilha.ttv-bem-de)
                               and   bem_pat.num_seq_bem_pat  = int(tt-planilha.ttv-inc-de) no-error.

    if avail bem_pat then do:

    assign tt-planilha.ttv-estabel = bem_pat.cod_estab
           tt-planilha.ttv-concatena-de =   (bem_pat.cod_estab) + "|" + string(bem_pat.cod_cta_pat)          + "|" + string(bem_pat.num_bem_pat)      + "|" + string(bem_pat.num_seq_bem_pat)
           tt-planilha.ttv-concatena-para = (bem_pat.cod_estab) + "|" + string(tt-planilha.ttv-cta-pat-para) + "|" + string(tt-planilha.ttv-bem-para) + "|" + string(tt-planilha.ttv-inc-para).

    end.

    ELSE ASSIGN tt-planilha.ttv-tratamento = "INEXISTENTE NO ATIVO".

end.

for each tt-planilha:

    if entry(1, tt-planilha.ttv-concatena-de, "|") + entry(2, tt-planilha.ttv-concatena-de, "|")  + entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|")
    =  entry(1, tt-planilha.ttv-concatena-para, "|") + entry(2, tt-planilha.ttv-concatena-para, "|")  + entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|")
    then 
    assign tt-planilha.ttv-tratamento = "ALTERACAO".

    if entry(1, tt-planilha.ttv-concatena-de, "|")    +  entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|")
    =  entry(1, tt-planilha.ttv-concatena-para, "|")  +  entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|")
    and entry(2, tt-planilha.ttv-concatena-de, "|")  <> entry(2, tt-planilha.ttv-concatena-para, "|") then
    assign tt-planilha.ttv-tratamento = "RECLASSIFICAR".

    IF entry(1, tt-planilha.ttv-concatena-de, "|")    +  entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|") <> 
    entry(1, tt-planilha.ttv-concatena-para, "|")  +  entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|") then
    assign tt-planilha.ttv-tratamento = "REIMPLANTAR".

    IF tt-planilha.ttv-desmembrar then
    assign tt-planilha.ttv-tratamento = "DESMEMBRAR".

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


create dwb_set_list.
assign dwb_set_list.ind_dwb_set_type = "Regra"
    dwb_set_list.cod_dwb_set_initial = ""
    dwb_set_list.cod_dwb_set_final   = ""
    dwb_set_list.cod_dwb_set         = "Individual"
    entry(1, dwb_set_list.cod_dwb_set_single, chr(10)) = tt-planilha.ttv-cta-pat
    entry(2, dwb_set_list.cod_dwb_set_single, chr(10)) = STRING(tt-planilha.ttv-bem-de)
    entry(3, dwb_set_list.cod_dwb_set_single, chr(10)) = STRING(i-cont)
    entry(1, dwb_set_list.cod_dwb_set_parameters, chr(10)) = STRING(tt-planilha.ttv-dt-base-arquivo)
    entry(2, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "" //precisa definir um motivo
    entry(3, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "fiscal" //verificar se precisa fazer para mais cenarios
    entry(4, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "corrente"
    entry(5, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "0"
    entry(6, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "100"
    entry(7, dwb_set_list.cod_dwb_set_parameters, chr(10)) = '0'
    entry(9, dwb_set_list.cod_dwb_set_parameters, chr(10)) = '0'
    entry(13, dwb_set_list.cod_dwb_set_parameters, chr(10)) = "Quebra" //verificar
    entry(14, dwb_set_list.cod_dwb_set_parameters, chr(10)) = ""
    dwb_set_list.num_dwb_order = i-cont + 300. //definir um motivo valido 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reclassifica w-livre 
PROCEDURE pi-reclassifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN v_cod_dwb_program  = "tar_reclassif_bem_pat"
       v_cod_dwb_user     = v_cod_usuar_corren.


find first cta_pat no-lock where cta_pat.cod_cta_pat = tt-planilha.ttv-cta-pat-para
                           and   cta_pat.cod_empresa =  v_cod_empres_usuar no-error.

                           find first emsbas.ccusto no-lock where ccusto.cod_empresa = v_cod_empres_usuar
                                                    and    ccusto.cod_ccusto = tt-planilha.ttv-cc-para
                                                    and    ccusto.dat_fim_valid >= today
                                                    no-error.

                            find first ccusto_unid_negoc no-lock where ccusto_unid_negoc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                            no-error.                           

create dwb_set_list.
assign dwb_set_list.ind_dwb_set_type = "Regra"
       dwb_set_list.cod_dwb_set_initial     = ""
       dwb_set_list.cod_dwb_set_final       = ""
       dwb_set_list.cod_dwb_set             = "Individual"
       entry(1,dwb_set_list.cod_dwb_set_single,chr(10)) = tt-planilha.ttv-cta-pat
       entry(2,dwb_set_list.cod_dwb_set_single,chr(10)) = string(tt-planilha.ttv-bem-de)
       entry(3,dwb_set_list.cod_dwb_set_single,chr(10)) = string(i-cont)
       entry(1,dwb_set_list.cod_dwb_set_parameters,chr(10)) = string(tt-planilha.ttv-dt-base-arquivo)
       entry(2,dwb_set_list.cod_dwb_set_parameters,chr(10)) = tt-planilha.ttv-cta-pat-para
       entry(3,dwb_set_list.cod_dwb_set_parameters,chr(10)) = cta_pat.cod_grp_calc
       entry(5,dwb_set_list.cod_dwb_set_parameters,chr(10)) = ccusto.cod_plano_ccusto
       entry(6,dwb_set_list.cod_dwb_set_parameters,chr(10)) = tt-planilha.ttv-cc-para
       entry(7,dwb_set_list.cod_dwb_set_parameters,chr(10)) = tt-planilha.ttv-estabel
       entry(8,dwb_set_list.cod_dwb_set_parameters,chr(10)) = ccusto_unid_negoc.cod_unid_negoc
       entry(9,dwb_set_list.cod_dwb_set_parameters,chr(10)) = tt-planilha.ttv-localizacao-para
       dwb_set_list.num_dwb_order = i-cont + 300.



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

