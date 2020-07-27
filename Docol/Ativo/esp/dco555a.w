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
&Scoped-Define ENABLED-OBJECTS rt-button RECT-22 RECT-26 l-transferencia ~
l-reclassificacao l-recla-transf l-alteracao l-alt-transf l-alt-reclass ~
l-alt-reclass-transf l-baixa l-inexistente bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS l-transferencia l-reclassificacao ~
l-recla-transf l-alteracao l-alt-transf l-alt-reclass l-alt-reclass-transf ~
l-baixa l-inexistente 

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

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.72 BY 12.58.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.14 BY 2
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

DEFINE VARIABLE l-alt-reclass AS LOGICAL INITIAL yes 
     LABEL "Altera‡Æo/Reclassifca‡ao" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-alt-reclass-transf AS LOGICAL INITIAL yes 
     LABEL "Altera‡Æo/Reclassifica‡Æo/Transferencia" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-alt-transf AS LOGICAL INITIAL yes 
     LABEL "Altera‡Æo / Transferencia" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-alteracao AS LOGICAL INITIAL yes 
     LABEL "Altera‡ao" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-baixa AS LOGICAL INITIAL yes 
     LABEL "Baixa" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-inexistente AS LOGICAL INITIAL yes 
     LABEL "Inexistente" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-recla-transf AS LOGICAL INITIAL yes 
     LABEL "Reclassificacao/Transferencia" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-reclassificacao AS LOGICAL INITIAL yes 
     LABEL "Reclassificacao" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-transferencia AS LOGICAL INITIAL yes 
     LABEL "Transferencia" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     l-transferencia AT ROW 3.33 COL 20.86 WIDGET-ID 8
     l-reclassificacao AT ROW 4.5 COL 20.72 WIDGET-ID 10
     l-recla-transf AT ROW 5.67 COL 20.72 WIDGET-ID 12
     l-alteracao AT ROW 6.83 COL 20.72 WIDGET-ID 14
     l-alt-transf AT ROW 7.92 COL 20.72 WIDGET-ID 16
     l-alt-reclass AT ROW 9.13 COL 20.14 WIDGET-ID 22
     l-alt-reclass-transf AT ROW 10.21 COL 20.14 WIDGET-ID 24
     l-baixa AT ROW 11.33 COL 20.14 WIDGET-ID 114
     l-inexistente AT ROW 12.33 COL 20.14 WIDGET-ID 116
     bt-ok AT ROW 16 COL 3.72 WIDGET-ID 110
     bt-cancela AT ROW 16 COL 19.29 WIDGET-ID 112
     "Situacao" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 2.54 COL 3.57 WIDGET-ID 4
     rt-button AT ROW 1 COL 1
     RECT-22 AT ROW 2.67 COL 1.29 WIDGET-ID 2
     RECT-26 AT ROW 15.58 COL 1.72 WIDGET-ID 108
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
         TITLE              = "dco555a"
         HEIGHT             = 16.96
         WIDTH              = 75.14
         MAX-HEIGHT         = 40.21
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 40.21
         VIRTUAL-WIDTH      = 195.14
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
ON END-ERROR OF w-livre /* dco555a */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* dco555a */
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
             l-transferencia:HANDLE IN FRAME f-cad , 'BEFORE':U ).
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
  DISPLAY l-transferencia l-reclassificacao l-recla-transf l-alteracao 
          l-alt-transf l-alt-reclass l-alt-reclass-transf l-baixa l-inexistente 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-22 RECT-26 l-transferencia l-reclassificacao 
         l-recla-transf l-alteracao l-alt-transf l-alt-reclass 
         l-alt-reclass-transf l-baixa l-inexistente bt-ok bt-cancela 
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

  {utp/ut9000.i "dco555a" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  FIND FIRST tt-filtro NO-ERROR.

  IF AVAIL tt-filtro THEN DO:

      ASSIGN l-reclassificacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = string(tt-filtro.ttv-reclassificao)          
             l-transferencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = string(tt-filtro.ttv-transferencia)          
             l-recla-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = string(tt-filtro.ttv-reclas-transf)          
             l-alteracao:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = string(tt-filtro.ttv-alteracao)              
             l-alt-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = string(tt-filtro.ttv-alt-transf)             
             l-alt-reclass:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = string(tt-filtro.ttv-alt-reclas)             
             l-alt-reclass-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = string(tt-filtro.ttv-alt-reclas-transf).      
      
          

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

      ASSIGN tt-filtro.ttv-reclassificao      = input frame {&frame-name} l-reclassificacao        
             tt-filtro.ttv-transferencia      = input frame {&frame-name} l-transferencia          
             tt-filtro.ttv-reclas-transf      = input frame {&frame-name} l-recla-transf           
             tt-filtro.ttv-alteracao          = input frame {&frame-name} l-alteracao              
             tt-filtro.ttv-alt-transf         = input frame {&frame-name} l-alt-transf             
             tt-filtro.ttv-alt-reclas         = input frame {&frame-name} l-alt-reclass            
             tt-filtro.ttv-alt-reclas-transf  = input frame {&frame-name} l-alt-reclass-transf
             tt-filtro.ttv-baixa              = INPUT FRAME {&FRAME-NAME} l-baixa
             tt-filtro.ttv-inexistente        = INPUT FRAME {&FRAME-NAME} l-inexistente.


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

