&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CD0138 1.00.00.001}

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

def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
def var h_api_cta_ctbl     as handle no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_des_ccusto       as char   no-undo.
def var v_cod_ccusto       as char   no-undo.
DEF VAR c-conta            AS CHAR   NO-UNDO.
def var c-estabelecimento  as char   no-undo.
DEF VAR l-utiliza-cc       AS LOG    NO-UNDO.
def var c-format-ccusto    as char   no-undo.
DEF VAR c-format-conta     AS CHAR   NO-UNDO.
def var v_log_utz_ccusto   as log    no-undo.
def var v_cod_formato      as char   no-undo.
DEF VAR c-desc-conta  AS CHAR NO-UNDO.
DEF VAR c-desc-ccusto AS CHAR NO-UNDO.
DEF VAR i-empresa     AS CHAR NO-UNDO.
DEFINE INPUT param p-rowid AS ROWID.
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 c-custo-adm ~
c-ctb-adm c-custo-coml c-ctbl-coml TOGGLE-1 bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-descricao c-custo-adm ~
c-ctb-adm c-custo-coml c-ctbl-coml TOGGLE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-ctb-adm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cta.Ctbl.Adm" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-ctbl-coml AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cta.Ctbl.Coml" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-custo-adm AS CHARACTER FORMAT "X(256)":U 
     LABEL "C.Custo Adm" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-custo-coml AS CHARACTER FORMAT "X(256)":U 
     LABEL "C.Custo Coml" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 10.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 8.67.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Rateio" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-it-codigo AT ROW 1.42 COL 8.14 COLON-ALIGNED WIDGET-ID 8
     c-descricao AT ROW 1.42 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-custo-adm AT ROW 3.42 COL 59.72 COLON-ALIGNED WIDGET-ID 14
     c-ctb-adm AT ROW 3.5 COL 16 COLON-ALIGNED WIDGET-ID 12
     c-custo-coml AT ROW 4.92 COL 59.72 COLON-ALIGNED WIDGET-ID 18
     c-ctbl-coml AT ROW 5 COL 16 COLON-ALIGNED WIDGET-ID 16
     TOGGLE-1 AT ROW 8.33 COL 28.43 WIDGET-ID 24
     bt-ok AT ROW 12.21 COL 3
     bt-cancelar AT ROW 12.21 COL 14
     bt-ajuda AT ROW 12.21 COL 69
     RECT-1 AT ROW 12 COL 2
     RECT-2 AT ROW 1.17 COL 1.29 WIDGET-ID 2
     RECT-3 AT ROW 1.25 COL 1.86 WIDGET-ID 4
     RECT-4 AT ROW 2.71 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutencao de Contas Contabeis - MLA"
         HEIGHT             = 12.67
         WIDTH              = 80
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Manutencao de Contas Contabeis - MLA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Manutencao de Contas Contabeis - MLA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:

    FIND FIRST ITEM WHERE ROWID(item) = p-rowid.
    
    FIND FIRST ext-item-mat WHERE ext-item-mat.it-codigo = item.it-codigo NO-ERROR.

    IF NOT AVAIL ext-item-mat THEN DO:
        
        CREATE ext-item-mat.
        ASSIGN ext-item-mat.it-codigo      = ITEM.it-codigo
               ext-item-mat.ct-codigo-adm  = c-ctb-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.ct-codigo-coml = c-ctbl-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.sc-cod-adm     = c-custo-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.sc-cod-coml    = c-custo-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.l-rateio       = logical(toggle-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    END.

    IF AVAIL ext-item-mat THEN DO:
        ASSIGN ext-item-mat.it-codigo      = ITEM.it-codigo
               ext-item-mat.ct-codigo-adm  = c-ctb-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.ct-codigo-coml = c-ctbl-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.sc-cod-adm     = c-custo-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.sc-cod-coml    = c-custo-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ext-item-mat.l-rateio       = logical(toggle-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
        


    END.

APPLY 'close' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ctb-adm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ctb-adm w-window
ON F5 OF c-ctb-adm IN FRAME F-Main /* Cta.Ctbl.Adm */
DO:
    RUN pi-localiza-empresa (INPUT "101",
                             OUTPUT i-empresa).
    
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "CEP",              /* M…DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

        ASSIGN c-ctb-adm:SCREEN-VALUE = v_cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ctb-adm w-window
ON MOUSE-SELECT-DBLCLICK OF c-ctb-adm IN FRAME F-Main /* Cta.Ctbl.Adm */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ctbl-coml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ctbl-coml w-window
ON F5 OF c-ctbl-coml IN FRAME F-Main /* Cta.Ctbl.Coml */
DO:
    RUN pi-localiza-empresa (INPUT "101",
                             OUTPUT i-empresa).
    
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "CEP",              /* M…DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

        ASSIGN c-ctbl-coml:SCREEN-VALUE = v_cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ctbl-coml w-window
ON MOUSE-SELECT-DBLCLICK OF c-ctbl-coml IN FRAME F-Main /* Cta.Ctbl.Coml */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-custo-adm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-custo-adm w-window
ON F5 OF c-custo-adm IN FRAME F-Main /* C.Custo Adm */
DO:
    ASSIGN c-conta = input frame {&FRAME-NAME} c-ctb-adm.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       c-desc-conta,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" THEN DO:

        IF l-utiliza-cc THEN DO:

            RUN pi-localiza-empresa (INPUT "102",
                                     OUTPUT i-empresa).

                assign c-estabelecimento = "102".
                RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT i-empresa,             /*Empresa*/
                                                               INPUT c-estabelecimento,     /*Estabelecimento */
                                                               INPUT NO,                    /*Considera Todos os Estabelecimentos ?*/
                                                               INPUT "",                    /*Unidade de Neg¢cio*/
                                                               INPUT "",                    /*Plano de Contas*/
                                                               INPUT c-conta,               /*C¢digo da Conta*/
                                                               INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                               INPUT TODAY,                 /*Data da Transa‡Æo*/
                                                               OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                               OUTPUT v_des_ccusto,         /*Descri‡Æo CCusto*/
                                                               OUTPUT TABLE tt_log_erro ).  /*Erros*/            
            
                if return-value = "OK" then do:
                    ASSIGN c-custo-adm:SCREEN-VALUE = v_cod_ccusto.
                end.
                
            END.
       END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-custo-adm w-window
ON MOUSE-SELECT-DBLCLICK OF c-custo-adm IN FRAME F-Main /* C.Custo Adm */
DO:
  APPLY 'f5' TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-custo-coml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-custo-coml w-window
ON F5 OF c-custo-coml IN FRAME F-Main /* C.Custo Coml */
DO:
    ASSIGN c-conta = input frame {&FRAME-NAME} c-ctbl-coml.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       c-desc-conta,
                        OUTPUT       l-utiliza-cc).

    IF RETURN-VALUE = "OK" THEN DO:

        IF l-utiliza-cc THEN DO:

            RUN pi-localiza-empresa (INPUT "102",
                                     OUTPUT i-empresa).

                assign c-estabelecimento = "102".
                RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT i-empresa,             /*Empresa*/
                                                               INPUT c-estabelecimento,     /*Estabelecimento */
                                                               INPUT NO,                    /*Considera Todos os Estabelecimentos ?*/
                                                               INPUT "",                    /*Unidade de Neg¢cio*/
                                                               INPUT "",                    /*Plano de Contas*/
                                                               INPUT c-conta,               /*C¢digo da Conta*/
                                                               INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                               INPUT TODAY,                 /*Data da Transa‡Æo*/
                                                               OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                               OUTPUT v_des_ccusto,         /*Descri‡Æo CCusto*/
                                                               OUTPUT TABLE tt_log_erro ).  /*Erros*/            
      
                if return-value = "OK" then do:
                
                ASSIGN c-custo-coml:SCREEN-VALUE = v_cod_ccusto.
  
                END.  

         END.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-custo-coml w-window
ON MOUSE-SELECT-DBLCLICK OF c-custo-coml IN FRAME F-Main /* C.Custo Coml */
DO:
  APPLY 'f5' TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY c-it-codigo c-descricao c-custo-adm c-ctb-adm c-custo-coml c-ctbl-coml 
          TOGGLE-1 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-2 RECT-3 RECT-4 c-custo-adm c-ctb-adm c-custo-coml 
         c-ctbl-coml TOGGLE-1 bt-ok bt-cancelar bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    /* Handle da API Conta Cont˜bil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto. 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "CD0138A" "1.00.00.001"}

  FIND FIRST ITEM WHERE ROWID(item) = p-rowid NO-ERROR.



  ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ITEM.it-codigo
         c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ITEM.descricao-1.

  FIND FIRST ext-item-mat NO-LOCK WHERE ext-item-mat.it-codigo = ITEM.it-codigo NO-ERROR.

  IF AVAIL ext-item-mat THEN DO:
  
  ASSIGN c-ctb-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ext-item-mat.ct-codigo-adm
         c-ctbl-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ext-item-mat.ct-codigo-coml
         c-custo-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ext-item-mat.sc-cod-adm
         c-custo-coml:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ext-item-mat.sc-cod-coml
         toggle-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(ext-item-mat.l-rateio).
  END.

  c-ctb-adm:LOAD-MOUSE-POINTER("image~\lupa.cur").
  c-ctbl-coml:LOAD-MOUSE-POINTER("image~\lupa.cur").


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-conta w-window 
PROCEDURE pi-desc-conta :
DEF INPUT-OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-desc-conta AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-utiliza-cc AS LOG  NO-UNDO.

    ASSIGN p-desc-conta = ''.

    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT p-conta,            /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  "102", /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-conta,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-conta = v_des_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-localiza-empresa w-window 
PROCEDURE pi-localiza-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estab AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-empresa   AS CHAR NO-UNDO.

    find estabelec where
         estabelec.cod-estabel = p-cod-estab no-lock no-error.

    ASSIGN p-empresa = estabelec.ep-codigo when avail estabelec.

    RETURN "ok".




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

