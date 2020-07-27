&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
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
/* Parameters Definitions ---                                           */
DEF VAR hMen702dd AS HANDLE NO-UNDO.
DEF VAR v_cod_prog_dtsul AS CHAR NO-UNDO.
/* Local Variable Definitions ---                                       */
DEF NEW GLOBAL SHARED VAR v_periodo AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS char NO-UNDO.
DEF var l-data-1        AS LOGICAL NO-UNDO.
DEF var l-data-2        AS LOGICAL NO-UNDO.
DEF var l-data-3        AS LOGICAL NO-UNDO.
DEF var l-data-4        AS LOGICAL NO-UNDO.
DEF VAR i-sequencia     AS INTEGER NO-UNDO.
def var c-usuar-1       AS char NO-UNDO.    
def var c-usuar-2       AS char NO-UNDO.   
def var c-usuar-3       AS char NO-UNDO.   
def var c-usuar-4       AS char NO-UNDO.    
def var d-alteracao-1    AS date  NO-UNDO.
def var d-alteracao-2    AS date  NO-UNDO. 
def var d-alteracao-3    AS date  NO-UNDO.
def var d-alteracao-4    AS date  NO-UNDO.


DEF VAR i-tot AS INTEGER.
/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES ext_roteiro_fechamento

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ext_roteiro_fechamento.responsavel ext_roteiro_fechamento.programa ext_roteiro_fechamento.rotina ext_roteiro_fechamento.semana-1 ext_roteiro_fechamento.semana-2 ext_roteiro_fechamento.semana-3 ext_roteiro_fechamento.semana-4 ext_roteiro_fechamento.usuario-1 ext_roteiro_fechamento.usuario-2 ext_roteiro_fechamento.usuario-3 ext_roteiro_fechamento.usuario-4 ext_roteiro_fechamento.date1 ext_roteiro_fechamento.data2 ext_roteiro_fechamento.data3 ext_roteiro_fechamento.data4 //   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 ext_roteiro_fechamento.semana-1 ~
ext_roteiro_fechamento.semana-2 ~
ext_roteiro_fechamento.semana-3 ~
ext_roteiro_fechamento.semana-4   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 ext_roteiro_fechamento
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 ext_roteiro_fechamento
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ext_roteiro_fechamento USE-INDEX sequencia     WHERE ext_roteiro_fechamento.periodo = INPUT FRAME {&FRAME-NAME} c-periodo     AND   ext_roteiro_fechamento.setor = INPUT FRAME {&FRAME-NAME} c-setor     AND   ext_roteiro_fechamento.responsavel >= INPUT FRAME {&FRAME-NAME} c-modul-ini     AND   ext_roteiro_fechamento.responsavel <= INPUT FRAME {&FRAME-NAME} c-modul-fim
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH ext_roteiro_fechamento USE-INDEX sequencia     WHERE ext_roteiro_fechamento.periodo = INPUT FRAME {&FRAME-NAME} c-periodo     AND   ext_roteiro_fechamento.setor = INPUT FRAME {&FRAME-NAME} c-setor     AND   ext_roteiro_fechamento.responsavel >= INPUT FRAME {&FRAME-NAME} c-modul-ini     AND   ext_roteiro_fechamento.responsavel <= INPUT FRAME {&FRAME-NAME} c-modul-fim.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ext_roteiro_fechamento
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ext_roteiro_fechamento


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-6 RECT-5 BUTTON-15 BUTTON-13 ~
c-setor c-periodo BUTTON-16 c-modul-fim c-modul-ini BROWSE-2 BUTTON-9 ~
BUTTON-10 BUTTON-12 
&Scoped-Define DISPLAYED-OBJECTS c-setor c-periodo c-modul-fim c-modul-ini 

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
DEFINE BUTTON BUTTON-10 
     LABEL "Modifica" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-12 
     LABEL "Elimina" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-13 
     IMAGE-UP FILE "IMAGE/im-cop.bmp":U
     LABEL "Button 13" 
     SIZE 7.43 BY 1.13.

DEFINE BUTTON BUTTON-15 
     IMAGE-UP FILE "IMAGE/im-check.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.13.

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "IMAGE/im-check.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.13.

DEFINE BUTTON BUTTON-9 
     LABEL "Novo" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-setor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Setor" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Financeiro","Recebimento","Estoque","Faturamento","Custos","Producao","Fechamento","Conciliacao" 
     DROP-DOWN-LIST
     SIZE 24.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-modul-fim AS CHARACTER FORMAT "X(256)":U INITIAL "zzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-modul-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "99/9999":U 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.72 BY 22.33.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.72 BY 3.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 208.57 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ext_roteiro_fechamento SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-livre _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ext_roteiro_fechamento.responsavel FORMAT "X(20)":U LABEL "Modulo"
      ext_roteiro_fechamento.programa FORMAT "x(20)":U
      ext_roteiro_fechamento.rotina FORMAT "x(50)":U WIDTH 39.43
      ext_roteiro_fechamento.semana-1 COLUMN-LABEL "1Week" FORMAT "yes/no":U
            WIDTH 6.29 VIEW-AS TOGGLE-BOX
      ext_roteiro_fechamento.semana-2 COLUMN-LABEL "2Week" FORMAT "yes/no":U
            WIDTH 6.29 VIEW-AS TOGGLE-BOX
      ext_roteiro_fechamento.semana-3 COLUMN-LABEL "3Week" FORMAT "yes/no":U
            WIDTH 6.29 VIEW-AS TOGGLE-BOX
      ext_roteiro_fechamento.semana-4 COLUMN-LABEL "4Week" FORMAT "yes/no":U
            WIDTH 6.86 VIEW-AS TOGGLE-BOX
      ext_roteiro_fechamento.usuario-1 FORMAT "x(8)":U
      ext_roteiro_fechamento.usuario-2 FORMAT "x(8)":U
      ext_roteiro_fechamento.usuario-3 FORMAT "x(8)":U
      ext_roteiro_fechamento.usuario-4 FORMAT "x(8)":U
      ext_roteiro_fechamento.date1 FORMAT "99/99/9999":U
      ext_roteiro_fechamento.data2 FORMAT "99/99/9999":U
      ext_roteiro_fechamento.data3 FORMAT "99/99/9999":U
      ext_roteiro_fechamento.data4 FORMAT "99/99/9999":U
//  ENABLE
      ext_roteiro_fechamento.semana-1
      ext_roteiro_fechamento.semana-2
      ext_roteiro_fechamento.semana-3
      ext_roteiro_fechamento.semana-4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189.14 BY 22.17
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     BUTTON-15 AT ROW 1.21 COL 65.14 WIDGET-ID 10
     BUTTON-13 AT ROW 1.21 COL 70.86 WIDGET-ID 18
     c-setor AT ROW 1.25 COL 12.57 COLON-ALIGNED WIDGET-ID 4
     c-periodo AT ROW 1.29 COL 48.43 COLON-ALIGNED WIDGET-ID 6
     BUTTON-16 AT ROW 3.75 COL 53.57 WIDGET-ID 32
     c-modul-fim AT ROW 3.88 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     c-modul-ini AT ROW 3.92 COL 14.14 COLON-ALIGNED WIDGET-ID 24
     BROWSE-2 AT ROW 5.67 COL 3.57 WIDGET-ID 200
     BUTTON-9 AT ROW 6.08 COL 193.57 WIDGET-ID 8
     BUTTON-10 AT ROW 7.54 COL 193.57 WIDGET-ID 16
     BUTTON-12 AT ROW 9.08 COL 193.57 WIDGET-ID 14
     "Filtra por modulo" VIEW-AS TEXT
          SIZE 19.43 BY .67 AT ROW 2.67 COL 6.14 WIDGET-ID 28
     rt-button AT ROW 1 COL 1
     RECT-6 AT ROW 2.58 COL 4.14 WIDGET-ID 26
     RECT-5 AT ROW 5.5 COL 193 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 208.57 BY 29.63 WIDGET-ID 100.


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
         HEIGHT             = 28.88
         WIDTH              = 208.43
         MAX-HEIGHT         = 40.54
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 40.54
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB BROWSE-2 c-modul-ini f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ext_roteiro_fechamento USE-INDEX sequencia
    WHERE ext_roteiro_fechamento.periodo = INPUT FRAME {&FRAME-NAME} c-periodo
    AND   ext_roteiro_fechamento.setor = INPUT FRAME {&FRAME-NAME} c-setor
    AND   ext_roteiro_fechamento.responsavel >= INPUT FRAME {&FRAME-NAME} c-modul-ini
    AND   ext_roteiro_fechamento.responsavel <= INPUT FRAME {&FRAME-NAME} c-modul-fim
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME f-cad
DO:
    ASSIGN v_cod_prog_dtsul = ext_roteiro_fechamento.programa.

    RUN men/men702dd.p PERSISTENT SET hMen702dd (THIS-PROCEDURE, v_cod_prog_dtsul).
    SESSION:SET-WAIT-STATE('general').
    RUN pi-executa IN hMen702dd.
    SESSION:SET-WAIT-STATE('').

    RUN pi-atualiza-data.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 w-livre
ON ROW-DISPLAY OF BROWSE-2 IN FRAME f-cad
DO:
  CASE ext_roteiro_fechamento.periodicidade:

      WHEN "mensal" THEN DO:
        ASSIGN  
          ext_roteiro_fechamento.rotina:BGCOLOR IN BROWSE browse-2 = 10
          ext_roteiro_fechamento.programa:BGCOLOR IN BROWSE browse-2 = 10   
          ext_roteiro_fechamento.semana-1:BGCOLOR IN BROWSE browse-2 = 10  
          ext_roteiro_fechamento.semana-2:BGCOLOR IN BROWSE browse-2 = 10  
          ext_roteiro_fechamento.semana-3:BGCOLOR IN BROWSE browse-2 = 10  
          ext_roteiro_fechamento.semana-4:BGCOLOR IN BROWSE browse-2 = 10  
          ext_roteiro_fechamento.usuario-1:BGCOLOR IN BROWSE browse-2 = 10   
          ext_roteiro_fechamento.usuario-2:BGCOLOR IN BROWSE browse-2 = 10   
          ext_roteiro_fechamento.usuario-3:BGCOLOR IN BROWSE browse-2 = 10   
          ext_roteiro_fechamento.usuario-4:BGCOLOR IN BROWSE browse-2 = 10.   
              
              .

      END.


      OTHERWISE
          ASSIGN  
            ext_roteiro_fechamento.rotina:BGCOLOR IN BROWSE browse-2 = 14
            ext_roteiro_fechamento.programa:BGCOLOR IN BROWSE browse-2 = 14  
            ext_roteiro_fechamento.semana-1:BGCOLOR IN BROWSE browse-2 = 14 
            ext_roteiro_fechamento.semana-2:BGCOLOR IN BROWSE browse-2 = 14 
            ext_roteiro_fechamento.semana-3:BGCOLOR IN BROWSE browse-2 = 14 
            ext_roteiro_fechamento.semana-4:BGCOLOR IN BROWSE browse-2 = 14 
            ext_roteiro_fechamento.usuario-1:BGCOLOR IN BROWSE browse-2 = 14   
            ext_roteiro_fechamento.usuario-2:BGCOLOR IN BROWSE browse-2 = 14   
            ext_roteiro_fechamento.usuario-3:BGCOLOR IN BROWSE browse-2 = 14   
            ext_roteiro_fechamento.usuario-4:BGCOLOR IN BROWSE browse-2 = 14.   

      
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 w-livre
ON CHOOSE OF BUTTON-10 IN FRAME f-cad /* Modifica */
DO:
  RUN esp/etfgl0000b.w(INPUT ROWID(ext_roteiro_fechamento)).
 RUN pi-atualizar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 w-livre
ON CHOOSE OF BUTTON-12 IN FRAME f-cad /* Elimina */
DO:
  DEF BUFFER b-roteiro FOR ext_roteiro_fechamento.

      FIND FIRST b-roteiro WHERE ROWID(b-roteiro) = ROWID(ext_roteiro_fechamento).
    DELETE b-roteiro.
    RUN pi-atualizar.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 w-livre
ON CHOOSE OF BUTTON-13 IN FRAME f-cad /* Button 13 */
DO:
  RUN esp/etfgl0000c.w.


  DEFINE BUFFER b-novo FOR ext_roteiro_fechamento.
  DEFINE BUFFER b-verifica FOR ext_roteiro_fechamento.


      FIND LAST b-verifica NO-ERROR.

      ASSIGN i-sequencia = b-verifica.sequenca + 1.
      FOR EACH b-novo WHERE b-novo.periodo = b-verifica.periodo:
      ASSIGN i-tot = i-tot  + 1.

      END.

      RUN Utp/ut-perc.p PERSISTENT SET h-prog.

      RUN pi-inicializar IN h-prog (INPUT "Gerando.....Aguarde", i-tot).
      FOR EACH b-novo WHERE b-novo.periodo = b-verifica.periodo:
        RUN pi-acompanhar IN h-prog.
          FIND FIRST ext_roteiro_fechamento NO-LOCK WHERE ext_roteiro_fechamento.periodo = v_periodo 
                                                     AND  ext_roteiro_fechamento.rotina  = b-novo.rotina
                                                     AND  ext_roteiro_fechamento.programa = b-novo.programa NO-ERROR.

          IF NOT AVAIL ext_roteiro_fechamento THEN DO:
              

              CREATE ext_roteiro_fechamento.
              ASSIGN ext_roteiro_fechamento.periodo = v_periodo
                     ext_roteiro_fechamento.rotina  = b-novo.rotina
                     ext_roteiro_fechamento.programa = b-novo.programa
                     ext_roteiro_fechamento.sequenca = i-sequencia
                     ext_roteiro_fechamento.periodicidade = b-novo.periodicidade
                     ext_roteiro_fechamento.setor         = b-novo.setor
                     ext_roteiro_fechamento.responsavel   = b-novo.responsavel.
              ASSIGN i-sequencia = i-sequencia + 1.

          END.


      END.
RUN pi-finalizar IN h-prog.

MESSAGE "Copia Finalizada" VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 w-livre
ON CHOOSE OF BUTTON-15 IN FRAME f-cad
DO:
    {&open-query-browse-2}
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 w-livre
ON CHOOSE OF BUTTON-16 IN FRAME f-cad
DO:
    {&open-query-browse-2}
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 w-livre
ON CHOOSE OF BUTTON-9 IN FRAME f-cad /* Novo */
DO:
  RUN esp/etfgl0000a.w.
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
       RUN set-position IN h_p-exihel ( 1.08 , 192.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             BUTTON-15:HANDLE IN FRAME f-cad , 'BEFORE':U ).
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
  DISPLAY c-setor c-periodo c-modul-fim c-modul-ini 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-6 RECT-5 BUTTON-15 BUTTON-13 c-setor c-periodo 
         BUTTON-16 c-modul-fim c-modul-ini BROWSE-2 BUTTON-9 BUTTON-10 
         BUTTON-12 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-data w-livre 
PROCEDURE pi-atualiza-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER b-fech FOR ext_roteiro_fechamento.

run esp/etfgl0000d.w (INPUT v_cod_prog_dtsul,
                      OUTPUT l-data-1,
                      OUTPUT l-data-2,
                      OUTPUT l-data-3,
                      OUTPUT l-data-4,
                      output c-usuar-1,    
                      output c-usuar-2,    
                      output c-usuar-3,    
                      output c-usuar-4,    
                      output d-alteracao-1,
                      output d-alteracao-2,
                      output d-alteracao-3,
                      output d-alteracao-4).



FIND FIRST b-fech WHERE ROWID(b-fech) = ROWID(ext_roteiro_fechamento) NO-ERROR.




ASSIGN b-fech.semana-1 = l-data-1
       b-fech.semana-2  = l-data-2
       b-fech.semana-3  = l-data-3
       b-fech.semana-4  = l-data-4
       b-fech.usuario-1 = c-usuar-1
       b-fech.usuario-2 = c-usuar-2
       b-fech.usuario-3 = c-usuar-3
       b-fech.usuario-4 = c-usuar-4
       b-fech.date1 = d-alteracao-1
       b-fech.data2 = d-alteracao-2
       b-fech.data3 = d-alteracao-3
       b-fech.data4 = d-alteracao-4.

RUN pi-atualizar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar w-livre 
PROCEDURE pi-atualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-browse-2}
    
    APPLY "open_query" TO BROWSE browse-2.
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
  {src/adm/template/snd-list.i "ext_roteiro_fechamento"}

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

