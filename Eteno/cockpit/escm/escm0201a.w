&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */

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
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-filtro.
DEFINE OUTPUT PARAMETER p-acao AS CHARACTER INITIAL "" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-22 RECT-23 RECT-25 IMAGE-1 ~
IMAGE-2 IMAGE-49 IMAGE-50 IMAGE-51 IMAGE-52 IMAGE-53 IMAGE-54 IMAGE-55 ~
IMAGE-56 RECT-26 IMAGE-57 IMAGE-58 l-abertos l-atendido-parcial ~
l-atendido-total l-suspenso l-cancelado l-avaliado l-nao-avaliado ~
l-aprovado l-nao-aprovado dt-impl-ini dt-impl-fim dt-entrega-ini ~
dt-entrega-fim c-pedido-ini c-pedido-fim c-cliente-ini c-cliente-fim ~
c-matriz-ini c-matriz-fim c-estab-ini c-estab-fim bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS l-abertos l-atendido-parcial ~
l-atendido-total l-suspenso l-cancelado l-avaliado l-nao-avaliado ~
l-aprovado l-nao-aprovado dt-impl-ini dt-impl-fim dt-entrega-ini ~
dt-entrega-fim c-pedido-ini c-pedido-fim c-cliente-ini c-cliente-fim ~
c-matriz-ini c-matriz-fim c-estab-ini c-estab-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "&Consultas"    
       MENU-ITEM mi-relatorios  LABEL "&Relatorios"   
       MENU-ITEM mi-Imprimir    LABEL "&Imprimir"     
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     LABEL "Cancelar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-ok 
     LABEL "Ok" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-cliente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cliente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "zzz" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-matriz-fim AS CHARACTER FORMAT "X(12)":U INITIAL "zzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-matriz-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Matriz" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-pedido-fim AS CHARACTER FORMAT "X(12)":U INITIAL "zzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-pedido-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-entrega-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Dt. Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-impl-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-impl-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Dt. Implantacao" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-57
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-58
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.72 BY 6.58.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.43 BY 5.54.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.14 BY 8.5.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.14 BY 2
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

DEFINE VARIABLE l-abertos AS LOGICAL INITIAL yes 
     LABEL "Abertos" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-aprovado AS LOGICAL INITIAL no 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-atendido-parcial AS LOGICAL INITIAL yes 
     LABEL "Atendido Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-atendido-total AS LOGICAL INITIAL no 
     LABEL "Atendido Total" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-avaliado AS LOGICAL INITIAL no 
     LABEL "Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-cancelado AS LOGICAL INITIAL no 
     LABEL "Cancelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-nao-aprovado AS LOGICAL INITIAL yes 
     LABEL "Nao Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.29 BY .83 NO-UNDO.

DEFINE VARIABLE l-nao-avaliado AS LOGICAL INITIAL yes 
     LABEL "Nao avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-suspenso AS LOGICAL INITIAL no 
     LABEL "Suspenso" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     l-abertos AT ROW 3.33 COL 20.86 WIDGET-ID 8
     l-atendido-parcial AT ROW 4.5 COL 20.72 WIDGET-ID 10
     l-atendido-total AT ROW 5.67 COL 20.72 WIDGET-ID 12
     l-suspenso AT ROW 6.83 COL 20.72 WIDGET-ID 14
     l-cancelado AT ROW 7.92 COL 20.72 WIDGET-ID 16
     l-avaliado AT ROW 10.67 COL 20.14 WIDGET-ID 22
     l-nao-avaliado AT ROW 11.75 COL 20.14 WIDGET-ID 24
     l-aprovado AT ROW 12.83 COL 20 WIDGET-ID 26
     l-nao-aprovado AT ROW 13.92 COL 20 WIDGET-ID 28
     dt-impl-ini AT ROW 16.67 COL 18 COLON-ALIGNED WIDGET-ID 36
     dt-impl-fim AT ROW 16.67 COL 42.29 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     dt-entrega-ini AT ROW 17.88 COL 17.86 COLON-ALIGNED WIDGET-ID 78
     dt-entrega-fim AT ROW 17.88 COL 42.14 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     c-pedido-ini AT ROW 19.04 COL 18 COLON-ALIGNED WIDGET-ID 84
     c-pedido-fim AT ROW 19.08 COL 42.29 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     c-cliente-ini AT ROW 20.25 COL 18 COLON-ALIGNED WIDGET-ID 94
     c-cliente-fim AT ROW 20.29 COL 42.29 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     c-matriz-ini AT ROW 21.33 COL 18 COLON-ALIGNED WIDGET-ID 102
     c-matriz-fim AT ROW 21.38 COL 42.29 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     c-estab-ini AT ROW 22.5 COL 18.14 COLON-ALIGNED WIDGET-ID 116
     c-estab-fim AT ROW 22.54 COL 42.43 COLON-ALIGNED NO-LABEL WIDGET-ID 114
     bt-ok AT ROW 24.75 COL 3.86 WIDGET-ID 110
     bt-cancela AT ROW 24.75 COL 19.43 WIDGET-ID 112
     "Demais selecoes" VIEW-AS TEXT
          SIZE 22.29 BY .67 AT ROW 15.42 COL 3.43 WIDGET-ID 34
     "Situacao" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 2.54 COL 3.57 WIDGET-ID 4
     "Avaliacao" VIEW-AS TEXT
          SIZE 11.72 BY .67 AT ROW 9.46 COL 4 WIDGET-ID 20
     rt-button AT ROW 1 COL 1
     RECT-22 AT ROW 2.67 COL 1.29 WIDGET-ID 2
     RECT-23 AT ROW 9.71 COL 1.57 WIDGET-ID 18
     RECT-25 AT ROW 15.58 COL 1.86 WIDGET-ID 32
     IMAGE-1 AT ROW 16.67 COL 34.29 WIDGET-ID 70
     IMAGE-2 AT ROW 16.67 COL 41.29 WIDGET-ID 72
     IMAGE-49 AT ROW 17.88 COL 34.14 WIDGET-ID 80
     IMAGE-50 AT ROW 17.88 COL 41.14 WIDGET-ID 82
     IMAGE-51 AT ROW 19.08 COL 34.43 WIDGET-ID 88
     IMAGE-52 AT ROW 19.08 COL 41.43 WIDGET-ID 90
     IMAGE-53 AT ROW 20.29 COL 34.43 WIDGET-ID 96
     IMAGE-54 AT ROW 20.29 COL 41.43 WIDGET-ID 98
     IMAGE-55 AT ROW 21.38 COL 34.43 WIDGET-ID 104
     IMAGE-56 AT ROW 21.38 COL 41.43 WIDGET-ID 106
     RECT-26 AT ROW 24.33 COL 1.86 WIDGET-ID 108
     IMAGE-57 AT ROW 22.54 COL 34.57 WIDGET-ID 118
     IMAGE-58 AT ROW 22.54 COL 41.57 WIDGET-ID 120
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 25.83
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "escm0201a"
         HEIGHT             = 25.38
         WIDTH              = 75.14
         MAX-HEIGHT         = 40.21
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 40.21
         VIRTUAL-WIDTH      = 90
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* escm0201a */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* escm0201a */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-livre
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  APPLY 'close' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-livre
ON CHOOSE OF bt-ok IN FRAME f-cad /* Ok */
DO:
  
    RUN pi-salvar-tabela.

    ASSIGN p-acao = "atualizar".

    APPLY 'close' TO THIS-PROCEDURE.

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


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Arquivo */
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
       RUN set-position IN h_p-exihel ( 1.13 , 59.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             l-abertos:HANDLE IN FRAME f-cad , 'BEFORE':U ).
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
  DISPLAY l-abertos l-atendido-parcial l-atendido-total l-suspenso l-cancelado 
          l-avaliado l-nao-avaliado l-aprovado l-nao-aprovado dt-impl-ini 
          dt-impl-fim dt-entrega-ini dt-entrega-fim c-pedido-ini c-pedido-fim 
          c-cliente-ini c-cliente-fim c-matriz-ini c-matriz-fim c-estab-ini 
          c-estab-fim 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-22 RECT-23 RECT-25 IMAGE-1 IMAGE-2 IMAGE-49 IMAGE-50 
         IMAGE-51 IMAGE-52 IMAGE-53 IMAGE-54 IMAGE-55 IMAGE-56 RECT-26 IMAGE-57 
         IMAGE-58 l-abertos l-atendido-parcial l-atendido-total l-suspenso 
         l-cancelado l-avaliado l-nao-avaliado l-aprovado l-nao-aprovado 
         dt-impl-ini dt-impl-fim dt-entrega-ini dt-entrega-fim c-pedido-ini 
         c-pedido-fim c-cliente-ini c-cliente-fim c-matriz-ini c-matriz-fim 
         c-estab-ini c-estab-fim bt-ok bt-cancela 
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

  {utp/ut9000.i "escm0201a" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  FIND FIRST tt-filtro NO-ERROR.

  IF AVAIL tt-filtro THEN DO:
      
      ASSIGN l-abertos:SCREEN-VALUE IN FRAME {&FRAME-NAME}           =      string(tt-filtro.ttv-abertos)         
             l-atendido-parcial:screen-value in frame {&FRAME-NAME}  =      string(tt-filtro.ttv-atendido-parcial)
             l-atendido-total:screen-value in frame {&FRAME-NAME}    =      string(tt-filtro.ttv-atendido-total)  
             l-suspenso:screen-value in frame {&FRAME-NAME}          =      string(tt-filtro.ttv-suspenso)        
             l-cancelado:screen-value in frame {&FRAME-NAME}         =      STRING(tt-filtro.ttv-cancelado)       
             l-avaliado:screen-value in frame {&FRAME-NAME}          =      string(tt-filtro.ttv-avaliado)        
             l-nao-avaliado:screen-value in frame {&FRAME-NAME}      =      string(tt-filtro.ttv-nao-avaliado)    
             l-aprovado:screen-value in frame {&FRAME-NAME}          =      string(tt-filtro.ttv-aprovado)        
             l-nao-aprovado:screen-value in frame {&FRAME-NAME}      =      string(tt-filtro.ttv-nao-aprovado)    
             dt-impl-ini:screen-value in frame {&FRAME-NAME}         =      string(tt-filtro.ttv-dt-impl-ini)     
             dt-impl-fim:screen-value in frame {&FRAME-NAME}         =      string(tt-filtro.ttv-dt-impl-fim)     
             dt-entrega-ini:screen-value in frame {&FRAME-NAME}      =      string(tt-filtro.ttv-dt-entrega-ini)  
             dt-entrega-fim:screen-value in frame {&FRAME-NAME}      =      string(tt-filtro.ttv-dt-entrega-fim)  
             c-pedido-ini:screen-value in frame {&FRAME-NAME}        =      string(tt-filtro.ttv-pedido-ini)      
             c-pedido-fim:screen-value in frame {&FRAME-NAME}        =      string(tt-filtro.ttv-pedido-fim)      
             c-cliente-ini:screen-value in frame {&FRAME-NAME}       =      string(tt-filtro.ttv-cdn-cliente-ini) 
             c-cliente-fim:screen-value in frame {&FRAME-NAME}       =      string(tt-filtro.ttv-cdn-cliente-fim) 
             c-matriz-ini:screen-value in frame {&FRAME-NAME}        =      string(tt-filtro.ttv-cdn-matriz-ini)  
             c-matriz-fim:screen-value in frame {&FRAME-NAME}        =      string(tt-filtro.ttv-cdn-matriz-fim)
             c-estab-ini:screen-value in FRAME {&FRAME-NAME}         =      string(tt-filtro.ttv-estab-ini)
             c-estab-fim:screen-value in FRAME {&FRAME-NAME}         =      string(tt-filtro.ttv-estab-fim)
          . 
          
          

  END.

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar-tabela w-livre 
PROCEDURE pi-salvar-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST tt-filtro NO-ERROR.

IF NOT AVAIL tt-filtro THEN
    CREATE tt-filtro.


ASSIGN  tt-filtro.ttv-abertos                    =      input frame {&FRAME-NAME}  l-abertos                          
        tt-filtro.ttv-atendido-parcial           =      input frame {&FRAME-NAME}  l-atendido-parcial        
        tt-filtro.ttv-atendido-total             =      input frame {&FRAME-NAME}  l-atendido-total            
        tt-filtro.ttv-suspenso                   =      input frame {&FRAME-NAME}  l-suspenso                        
        tt-filtro.ttv-cancelado                  =      input frame {&FRAME-NAME}  l-cancelado                      
        tt-filtro.ttv-avaliado                   =      input frame {&FRAME-NAME}  l-avaliado                        
        tt-filtro.ttv-nao-avaliado               =      input frame {&FRAME-NAME}  l-nao-avaliado                
        tt-filtro.ttv-aprovado                   =      input frame {&FRAME-NAME}  l-aprovado                        
        tt-filtro.ttv-nao-aprovado               =      input frame {&FRAME-NAME}  l-nao-aprovado                
        tt-filtro.ttv-dt-impl-ini                =      input frame {&FRAME-NAME}  dt-impl-ini                      
        tt-filtro.ttv-dt-impl-fim                =      input frame {&FRAME-NAME}  dt-impl-fim                      
        tt-filtro.ttv-dt-entrega-ini             =      input frame {&FRAME-NAME}  dt-entrega-ini                
        tt-filtro.ttv-dt-entrega-fim             =      input frame {&FRAME-NAME}  dt-entrega-fim                
        tt-filtro.ttv-pedido-ini                 =      input frame {&FRAME-NAME}  c-pedido-ini                    
        tt-filtro.ttv-pedido-fim                 =      input frame {&FRAME-NAME}  c-pedido-fim                    
        tt-filtro.ttv-cdn-cliente-ini            =      input frame {&FRAME-NAME}  c-cliente-ini                  
        tt-filtro.ttv-cdn-cliente-fim            =      input frame {&FRAME-NAME}  c-cliente-fim                  
        tt-filtro.ttv-cdn-matriz-ini             =      input frame {&FRAME-NAME}  c-matriz-ini                    
        tt-filtro.ttv-cdn-matriz-fim             =      input frame {&FRAME-NAME}  c-matriz-fim 
        tt-filtro.ttv-estab-ini                  =      input frame {&FRAME-NAME}  c-estab-ini
        tt-filtro.ttv-estab-fim                  =      input FRAME {&FRAME-NAME}  c-estab-fim     .            


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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

