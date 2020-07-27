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
{dop/dpd611.i}
/* Local Variable Definitions ---                                       */
DEF INPUT PARAM p-estab AS CHAR NO-UNDO.
DEF INPUT PARAM p-tit-ap AS CHAR NO-UNDO.
DEF INPUT PARAM p-espec-docto AS CHAR NO-UNDO.
DEF INPUT PARAM p-parcela AS CHAR NO-UNDO.
DEF INPUT PARAM p-num-id-tit-ap AS INTEGER NO-UNDO.
DEF INPUT PARAM p-ccusto    AS CHAR NO-UNDO.
DEF INPUT PARAM p-valor       AS DEC NO-UNDO.
//DEF OUTPUT PARAM TABLE FOR tt_log_erros_tit_ap_alteracao.
DEF VAR v_cod_refer AS CHAR.
DEF VAR v_hdl_aux AS HANDLE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 RECT-3 RECT-4 ~
RADIO-SET-1 c-conta c-portador d-valor BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS c-estab c-tit-ap c-parcela c-espec ~
RADIO-SET-1 c-conta c-portador d-valor c-ccusto 

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
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-2 
     LABEL "Fechar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-ccusto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Contabil" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-espec AS CHARACTER FORMAT "X(256)":U 
     LABEL "Especie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-parcela AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-portador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ap AS CHARACTER FORMAT "X(256)":U 
     LABEL "Titulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Financeiro", 1,
"Contabil", 2
     SIZE 23 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.14 BY 10.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.29 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.72 BY 3.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 4.67.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 52.29 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-estab AT ROW 3.29 COL 10 COLON-ALIGNED WIDGET-ID 8
     c-tit-ap AT ROW 4.63 COL 23.57 COLON-ALIGNED WIDGET-ID 12
     c-parcela AT ROW 4.63 COL 38.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-espec AT ROW 4.67 COL 10.14 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET-1 AT ROW 7.25 COL 14.14 NO-LABEL WIDGET-ID 28
     c-conta AT ROW 8.33 COL 16.29 COLON-ALIGNED WIDGET-ID 4
     c-portador AT ROW 8.42 COL 16 COLON-ALIGNED WIDGET-ID 32
     d-valor AT ROW 9.46 COL 16.43 COLON-ALIGNED WIDGET-ID 6
     c-ccusto AT ROW 10.63 COL 16 COLON-ALIGNED WIDGET-ID 26
     BUTTON-1 AT ROW 13.42 COL 9.86 WIDGET-ID 18
     BUTTON-2 AT ROW 13.42 COL 27 WIDGET-ID 24
     rt-button AT ROW 1 COL 1
     RECT-1 AT ROW 2.83 COL 1.86 WIDGET-ID 2
     RECT-2 AT ROW 13.08 COL 2.43 WIDGET-ID 16
     RECT-3 AT ROW 3 COL 2.43 WIDGET-ID 20
     RECT-4 AT ROW 7.17 COL 3 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 52.72 BY 14.04 WIDGET-ID 100.


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
         TITLE              = "Acerto de Valor"
         HEIGHT             = 14.13
         WIDTH              = 53.14
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
/* SETTINGS FOR FILL-IN c-ccusto IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-espec IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estab IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-parcela IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ap IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Acerto de Valor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Acerto de Valor */
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
ON CHOOSE OF BUTTON-1 IN FRAME f-cad /* Executar */
DO:
    RUN pi-executar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-livre
ON CHOOSE OF BUTTON-2 IN FRAME f-cad /* Fechar */
DO:
  APPLY 'close' TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 w-livre
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME f-cad
DO:
  CASE radio-set-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}:

      WHEN "1" THEN
          ASSIGN c-portador:VISIBLE = TRUE
                 c-conta:VISIBLE = FALSE.
          OTHERWISE
              ASSIGN c-portador:VISIBLE = FALSE
                  c-conta:VISIBLE = TRUE.
  END CASE.

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
       RUN set-position IN h_p-exihel ( 1.17 , 36.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             c-estab:HANDLE IN FRAME f-cad , 'BEFORE':U ).
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
  DISPLAY c-estab c-tit-ap c-parcela c-espec RADIO-SET-1 c-conta c-portador 
          d-valor c-ccusto 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-1 RECT-2 RECT-3 RECT-4 RADIO-SET-1 c-conta c-portador 
         d-valor BUTTON-1 BUTTON-2 
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

ASSIGN c-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-estab
       c-espec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-espec-docto
       c-tit-ap:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-tit-ap
       c-parcela:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-parcela
       d-valor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(p-valor)
       c-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-ccusto.

ASSIGN c-portador:VISIBLE = TRUE
       c-conta:VISIBLE = FALSE.
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
    find first tit_ap no-lock where tit_ap.num_id_tit_ap = p-num-id-tit-ap
                              and   tit_ap.cod_estab     = p-estab no-error.

                              run pi_retorna_sugestao_referencia (Input "T" /*l_l*/,
                              Input today,
                              output v_cod_refer) /*pi_retorna_sugestao_referencia*/.
                    

                              EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_3.
                              EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
                              EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

        create tt_tit_ap_alteracao_base_aux_3.
        assign tt_tit_ap_alteracao_base_aux_3.ttv_cod_usuar_corren            = v_cod_usuar_corren
               tt_tit_ap_alteracao_base_aux_3.tta_cod_empresa                 = tit_ap.cod_empresa
               tt_tit_ap_alteracao_base_aux_3.tta_cod_estab                   = tit_ap.cod_estab
               tt_tit_ap_alteracao_base_aux_3.tta_num_id_tit_ap               = tit_ap.num_id_tit_ap
               tt_tit_ap_alteracao_base_aux_3.tta_ind_tip_espec_docto         = tit_ap.ind_tip_espec_docto
               //tt_tit_ap_alteracao_base_aux_3.ttv_rec_tit_ap                
               tt_tit_ap_alteracao_base_aux_3.tta_cdn_fornecedor              = tit_ap.cdn_fornecedor
               tt_tit_ap_alteracao_base_aux_3.tta_cod_espec_docto             = tit_ap.cod_espec_docto
               tt_tit_ap_alteracao_base_aux_3.tta_cod_ser_docto               = tit_ap.cod_ser_docto
               tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap                  = tit_ap.cod_tit_ap
               tt_tit_ap_alteracao_base_aux_3.tta_cod_parcela                 = tit_ap.cod_parcela
               tt_tit_ap_alteracao_base_aux_3.ttv_dat_transacao               = today
               tt_tit_ap_alteracao_base_aux_3.ttv_cod_refer                   = v_cod_refer
               tt_tit_ap_alteracao_base_aux_3.tta_val_sdo_tit_ap              = tit_ap.val_sdo_tit_ap - DEC(INPUT FRAME {&FRAME-NAME} d-valor)
               tt_tit_ap_alteracao_base_aux_3.tta_dat_emis_docto              = tit_ap.dat_emis_docto
               tt_tit_ap_alteracao_base_aux_3.tta_dat_vencto_tit_ap           = tit_ap.dat_vencto_tit_ap
               tt_tit_ap_alteracao_base_aux_3.tta_dat_prev_pagto              = tit_ap.dat_prev_pagto
               tt_tit_ap_alteracao_base_aux_3.tta_dat_ult_pagto               = tit_ap.dat_ult_pagto
               tt_tit_ap_alteracao_base_aux_3.tta_num_dias_atraso             = tit_ap.num_dias_atraso
               tt_tit_ap_alteracao_base_aux_3.tta_val_perc_multa_atraso       = tit_ap.val_perc_multa_atraso
               tt_tit_ap_alteracao_base_aux_3.tta_val_juros_dia_atraso        = tit_ap.val_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_3.tta_val_perc_juros_dia_atraso   = tit_ap.val_perc_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_3.tta_dat_desconto                = tit_ap.dat_desconto
               tt_tit_ap_alteracao_base_aux_3.tta_val_perc_desc               = tit_ap.val_perc_desc
               tt_tit_ap_alteracao_base_aux_3.tta_val_desconto                = tit_ap.val_desconto
               tt_tit_ap_alteracao_base_aux_3.tta_cod_portador                = tit_ap.cod_portador
               tt_tit_ap_alteracao_base_aux_3.tta_log_pagto_bloqdo            = tit_ap.log_pagto_bloqdo
               tt_tit_ap_alteracao_base_aux_3.ttv_cod_portador_mov            = INPUT FRAME {&FRAME-NAME} c-portador
               tt_tit_ap_alteracao_base_aux_3.ttv_rec_tit_ap                  = RECID(tit_ap)
               tt_tit_ap_alteracao_base_aux_3.ttv_ind_motiv_alter_val_tit_ap  = "Baixa"
.


        IF radio-set-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2" THEN DO:
        
    find first movto_tit_ap no-lock where movto_tit_ap.cod_estab = tit_ap.cod_estab
                                    and   movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                    no-error.
    find first rat_movto_tit_ap no-lock where rat_movto_tit_ap.cod_estab = movto_tit_ap.cod_estab
                                        and   rat_movto_tit_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap no-error.
    find first aprop_ctbl_ap no-lock where aprop_ctbl_ap.num_id_movto_tit_ap = rat_movto_tit_ap.num_id_movto_tit_ap
                                     and   aprop_ctbl_ap.cod_estab = rat_movto_tit_ap.cod_estab no-error.

    find first plano_ccusto no-lock where plano_ccusto.dat_fim_valid >= today
                                    and   plano_ccusto.cod_empresa   = tit_ap.cod_empresa
                                    no-error.
create tt_tit_ap_alteracao_rateio.
assign tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = tt_tit_ap_alteracao_base_aux_3.ttv_rec_tit_ap
        tt_tit_ap_alteracao_rateio.tta_cod_estab            = tit_ap.cod_estab
        tt_tit_ap_alteracao_rateio.tta_cod_refer            = v_cod_refer
        tt_tit_ap_alteracao_rateio.tta_num_seq_refer        = 10
        tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl   = aprop_ctbl_ap.cod_plano_cta_ctbl
        tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl         = INPUT FRAME {&FRAME-NAME} c-conta
        tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto     = plano_ccusto.cod_plano_ccusto
        tt_tit_ap_alteracao_rateio.tta_cod_ccusto           = p-ccusto
        tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl       = DEC(INPUT FRAME {&FRAME-NAME} d-valor)
        tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        = tit_ap.num_id_tit_ap
        tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat   = "Valor"
        tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        = tt_tit_ap_alteracao_base_aux_3.tta_num_id_tit_ap.

.
        END.


run prgfin/apb/apb767zf.py persistent set v_hdl_aux.

run pi_main_code_api_integr_ap_alter_tit_ap_6 in v_hdl_aux (Input 1,
                                               Input "APB",
                                               Input "EMS2",
                                              input NO,
                                               input-output table tt_tit_ap_alteracao_base_aux_3,
                                               input-output table tt_tit_ap_alteracao_rateio,
                                               input-output table tt_params_generic_api, 
                                               output table tt_log_erros_tit_ap_alteracao).

FIND FIRST tt_log_erros_tit_ap_alteracao NO-ERROR.

IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:

    RUN dop/MESSAGE.p(tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro,
                  tt_log_erroS_tit_ap_alteracao.ttv_num_mensagem).
    RETURN 'ADM-ERROR'.
END.
delete procedure v_hdl_aux.  

RUN dop/MESSAGE.p("Titulo Gerado", "Titulo Gerado com sucesso").
APPLY 'close' TO THIS-PROCEDURE.
RETURN 'ok'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_retorna_sugestao_referencia w-livre 
PROCEDURE pi_retorna_sugestao_referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.

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

