&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME det-dc-comis-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS det-dc-comis-trans 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF BUFFER b-dc-comis-trans FOR dc-comis-trans.

DEF NEW GLOBAL SHARED VAR v_rec_dc_comis_trans   AS RECID        NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario   like param-global.empresa-prin NO-UNDO.

DEF VAR v_log_answer                            AS LOGICAL      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME det-dc-comis-trans

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES dc-comis-trans

/* Definitions for DIALOG-BOX det-dc-comis-trans                        */
&Scoped-define FIELDS-IN-QUERY-det-dc-comis-trans ~
dc-comis-trans.cod_transacao dc-comis-trans.dat_inic_valid ~
dc-comis-trans.dat_fim_valid dc-comis-trans.descricao ~
dc-comis-trans.ind_tip_trans dc-comis-trans.ind_incid_iss ~
dc-comis-trans.ind_incid_liquido dc-comis-trans.ind_incid_ir ~
dc-comis-trans.log_perm_digitacao dc-comis-trans.log_contabiliza ~
dc-comis-trans.ind_tip_movto  
&Scoped-define QUERY-STRING-det-dc-comis-trans FOR EACH dc-comis-trans SHARE-LOCK
&Scoped-define OPEN-QUERY-det-dc-comis-trans OPEN QUERY det-dc-comis-trans FOR EACH dc-comis-trans SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-det-dc-comis-trans dc-comis-trans
&Scoped-define FIRST-TABLE-IN-QUERY-det-dc-comis-trans dc-comis-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-relacoes bt-ok bt-cancela bt-anterior ~
bt-pesquisa bt-proximo bt-ajuda RECT-7 rt-chave rt-contabil rt-financeiro 
&Scoped-Define DISPLAYED-FIELDS dc-comis-trans.cod_transacao ~
dc-comis-trans.dat_inic_valid dc-comis-trans.dat_fim_valid ~
dc-comis-trans.descricao dc-comis-trans.ind_tip_trans ~
dc-comis-trans.ind_incid_iss dc-comis-trans.ind_incid_liquido ~
dc-comis-trans.ind_incid_ir dc-comis-trans.log_perm_digitacao ~
dc-comis-trans.log_contabiliza dc-comis-trans.ind_tip_movto ~
dc-comis-trans-ctb.cod_plano_cta_ctbl dc-comis-trans-ctb.cod_plano_ccusto ~
dc-comis-trans-ctb.cod_cta_ctbl dc-comis-trans-ctb.cod_ccusto 
&Scoped-define DISPLAYED-TABLES dc-comis-trans dc-comis-trans-ctb
&Scoped-define FIRST-DISPLAYED-TABLE dc-comis-trans
&Scoped-define SECOND-DISPLAYED-TABLE dc-comis-trans-ctb


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-anterior 
     IMAGE-UP FILE "Image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-pre1.bmp":U
     LABEL "Anterior" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancela AUTO-GO 
     LABEL "Cancela" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-pesquisa 
     IMAGE-UP FILE "Image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-sea1.bmp":U
     LABEL "Pesquisa" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-proximo 
     IMAGE-UP FILE "Image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-nex1.bmp":U
     LABEL "Pr¢ximo" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-relacoes 
     LABEL "Relaá‰es" 
     SIZE 15 BY 1.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rt-chave
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 2.5.

DEFINE RECTANGLE rt-contabil
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 4.5.

DEFINE RECTANGLE rt-financeiro
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 5.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY det-dc-comis-trans FOR 
      dc-comis-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME det-dc-comis-trans
     dc-comis-trans.cod_transacao AT ROW 1.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.dat_inic_valid AT ROW 2.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.dat_fim_valid AT ROW 2.5 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.descricao AT ROW 4.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.ind_tip_trans AT ROW 5.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .92
          BGCOLOR 15 FONT 2
     dc-comis-trans.ind_incid_iss AT ROW 6.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
          BGCOLOR 15 
     dc-comis-trans.ind_incid_liquido AT ROW 7.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .79
          BGCOLOR 15 
     dc-comis-trans.ind_incid_ir AT ROW 8.25 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .71
     dc-comis-trans.log_perm_digitacao AT ROW 8.25 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     dc-comis-trans.log_contabiliza AT ROW 9.75 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     dc-comis-trans.ind_tip_movto AT ROW 10.75 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", yes,
"CrÇdito", no
          SIZE 33 BY .88
     dc-comis-trans-ctb.cod_plano_cta_ctbl AT ROW 11.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_plano_ccusto AT ROW 11.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_cta_ctbl AT ROW 12.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_ccusto AT ROW 12.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .88
          BGCOLOR 15 FONT 2
     bt-relacoes AT ROW 14.25 COL 2
     bt-ok AT ROW 15.75 COL 3
     bt-cancela AT ROW 15.75 COL 14
     bt-anterior AT ROW 15.75 COL 28
     bt-pesquisa AT ROW 15.75 COL 33
     bt-proximo AT ROW 15.75 COL 38
     bt-ajuda AT ROW 15.75 COL 71
     RECT-7 AT ROW 15.5 COL 2
     rt-chave AT ROW 1.25 COL 2
     rt-contabil AT ROW 9.5 COL 2
     rt-financeiro AT ROW 4 COL 2
     "Tipo Movto:" VIEW-AS TEXT
          SIZE 8.29 BY .88 AT ROW 10.75 COL 13
     SPACE(61.70) SKIP(5.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Detalhe Transaá∆o de Comiss∆o - DCO001C"
         DEFAULT-BUTTON bt-ok CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX det-dc-comis-trans
                                                                        */
ASSIGN 
       FRAME det-dc-comis-trans:SCROLLABLE       = FALSE
       FRAME det-dc-comis-trans:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN dc-comis-trans.cod_ccusto IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.cod_cta_ctbl IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.cod_plano_ccusto IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.cod_plano_cta_ctbl IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.cod_transacao IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.dat_fim_valid IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.dat_inic_valid IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.descricao IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.ind_incid_ir IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_incid_iss IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_incid_liquido IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET dc-comis-trans.ind_tip_movto IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_tip_trans IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.log_contabiliza IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.log_perm_digitacao IN FRAME det-dc-comis-trans
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX det-dc-comis-trans
/* Query rebuild information for DIALOG-BOX det-dc-comis-trans
     _TblList          = "emsdocol.dc-comis-trans"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX det-dc-comis-trans */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME det-dc-comis-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL det-dc-comis-trans det-dc-comis-trans
ON WINDOW-CLOSE OF FRAME det-dc-comis-trans /* Detalhe Transaá∆o de Comiss∆o - DCO001C */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-anterior det-dc-comis-trans
ON CHOOSE OF bt-anterior IN FRAME det-dc-comis-trans /* Anterior */
DO:
    GET PREV {&FRAME-NAME}.
    IF  NOT AVAIL dc-comis-trans THEN
        GET FIRST {&FRAME-NAME}.
    RUN pi-display.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela det-dc-comis-trans
ON CHOOSE OF bt-cancela IN FRAME det-dc-comis-trans /* Cancela */
DO:
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok det-dc-comis-trans
ON CHOOSE OF bt-ok IN FRAME det-dc-comis-trans /* OK */
DO:
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa det-dc-comis-trans
ON CHOOSE OF bt-pesquisa IN FRAME det-dc-comis-trans /* Pesquisa */
DO:
    DEF VAR v-rec-aux   AS RECID    NO-UNDO.
    ASSIGN  v-rec-aux   = v_rec_dc_comis_trans.

    RUN dozoom/dco001z1.w.

    IF  v_rec_dc_comis_trans <> ? THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.

    ASSIGN  v_rec_dc_comis_trans = v-rec-aux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-proximo det-dc-comis-trans
ON CHOOSE OF bt-proximo IN FRAME det-dc-comis-trans /* Pr¢ximo */
DO:
    GET NEXT {&FRAME-NAME}.
    IF  NOT AVAIL dc-comis-trans THEN
        GET LAST {&FRAME-NAME}.
    RUN pi-display.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relacoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relacoes det-dc-comis-trans
ON CHOOSE OF bt-relacoes IN FRAME det-dc-comis-trans /* Relaá‰es */
DO:
    /************************* Variable Definition Begin ************************/

    DEF VAR v_wgh_child             as widget-handle    format ">>>>>>9"    no-undo.
    DEF VAR v_wgh_current_menu      as widget-handle    format ">>>>>>9"    no-undo.
    DEF VAR v_wgh_current_window    as widget-handle    format ">>>>>>9"    no-undo.

    /************************** Variable Definition End *************************/

    ASSIGN  v_wgh_current_window        = CURRENT-WINDOW
            v_wgh_current_menu          = CURRENT-WINDOW:MENUBAR 
            CURRENT-WINDOW:WINDOW-STATE = 2
            v_wgh_child                 = CURRENT-WINDOW:FIRST-CHILD
            CURRENT-WINDOW:VISIBLE      = NO.
    IF  v_wgh_current_menu <> ? then do:
        ASSIGN  v_wgh_current_menu:SENSITIVE = NO.
    END /* if */.

    desab:
    DO  WHILE v_wgh_child <> ?:
        ASSIGN  v_wgh_child:SENSITIVE = NO
                v_wgh_child           = v_wgh_child:NEXT-SIBLING.
    end /* do desab */.

    RUN dop/dco001.w.

    ASSIGN  CURRENT-WINDOW              = v_wgh_current_window
            v_wgh_child                 = CURRENT-WINDOW:FIRST-CHILD
            CURRENT-WINDOW:WINDOW-STATE = 3
            CURRENT-WINDOW:VISIBLE      = YES.
    IF  v_wgh_current_menu <> ? THEN DO:
        ASSIGN  v_wgh_current_menu:SENSITIVE = YES.
    END /* if */.
    
    hab:
    DO  WHILE v_wgh_child <> ?:
        ASSIGN  v_wgh_child:SENSITIVE = YES
                v_wgh_child           = v_wgh_child:NEXT-SIBLING.
    END /* do hab */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK det-dc-comis-trans 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    
    RUN enable_UI.
    RUN pi-initialize.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI det-dc-comis-trans  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME det-dc-comis-trans.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI det-dc-comis-trans  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-det-dc-comis-trans}
  GET FIRST det-dc-comis-trans.
  IF AVAILABLE dc-comis-trans THEN DO: 
     FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                     AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                     AND dc-comis-trans-ctb.cod_empresa    = i-ep-codigo-usuario NO-LOCK NO-ERROR.
    DISPLAY dc-comis-trans.cod_transacao dc-comis-trans.dat_inic_valid 
          dc-comis-trans.dat_fim_valid dc-comis-trans.descricao 
          dc-comis-trans.ind_tip_trans dc-comis-trans.ind_incid_iss 
          dc-comis-trans.ind_incid_liquido dc-comis-trans.ind_incid_ir 
          dc-comis-trans.log_perm_digitacao dc-comis-trans.log_contabiliza 
          dc-comis-trans.ind_tip_movto dc-comis-trans-ctb.cod_plano_cta_ctbl 
          dc-comis-trans-ctb.cod_plano_ccusto dc-comis-trans-ctb.cod_cta_ctbl 
          dc-comis-trans-ctb.cod_ccusto 
      WITH FRAME det-dc-comis-trans.
  END.
  ENABLE bt-relacoes bt-ok bt-cancela bt-anterior bt-pesquisa bt-proximo 
         bt-ajuda RECT-7 rt-chave rt-contabil rt-financeiro 
      WITH FRAME det-dc-comis-trans.
  VIEW FRAME det-dc-comis-trans.
  {&OPEN-BROWSERS-IN-QUERY-det-dc-comis-trans}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display det-dc-comis-trans 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISPLAY {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME {&FRAME-NAME}.

    FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                    AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                    AND dc-comis-trans-ctb.cod_empresa    = i-ep-codigo-usuario NO-LOCK NO-ERROR.
    IF AVAIL dc-comis-trans-ctb THEN DO:
        FIND FIRST plano_cta_ctbl NO-LOCK 
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = dc-comis-trans-ctb.cod_plano_cta_ctbl NO-ERROR.
        ASSIGN  dc-comis-trans-ctb.cod_cta_ctbl:FORMAT = IF  AVAIL plano_cta_ctbl THEN  plano_cta_ctbl.cod_format_cta_ctbl ELSE 'X(20)'.

        FIND FIRST plano_ccusto NO-LOCK
             WHERE plano_ccusto.cod_plano_ccusto = dc-comis-trans-ctb.cod_plano_ccusto NO-ERROR.
        ASSIGN  dc-comis-trans-ctb.cod_ccusto:FORMAT = IF  AVAIL plano_ccusto THEN plano_ccusto.cod_format_ccusto ELSE 'X(11)'.
        DISPLAY dc-comis-trans-ctb.cod_plano_cta_ctbl dc-comis-trans-ctb.cod_cta_ctbl 
                dc-comis-trans-ctb.cod_plano_ccusto dc-comis-trans-ctb.cod_ccusto 
           WITH FRAME det-dc-comis-trans.
    END.
    ELSE DO:
        FIND FIRST plano_cta_ctbl NO-LOCK 
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = dc-comis-trans.cod_plano_cta_ctbl NO-ERROR.
        ASSIGN  dc-comis-trans-ctb.cod_cta_ctbl:FORMAT = IF  AVAIL plano_cta_ctbl THEN  plano_cta_ctbl.cod_format_cta_ctbl ELSE 'X(20)'.

        FIND FIRST plano_ccusto NO-LOCK
             WHERE plano_ccusto.cod_plano_ccusto = dc-comis-trans.cod_plano_ccusto NO-ERROR.
        ASSIGN  dc-comis-trans-ctb.cod_ccusto:FORMAT = IF  AVAIL plano_ccusto THEN plano_ccusto.cod_format_ccusto ELSE 'X(11)'.
        DISPLAY " " @  dc-comis-trans-ctb.cod_plano_cta_ctbl
                " " @  dc-comis-trans-ctb.cod_cta_ctbl      
                " " @  dc-comis-trans-ctb.cod_plano_ccusto  
                " " @  dc-comis-trans-ctb.cod_ccusto        
           WITH FRAME det-dc-comis-trans.
    END.

    ASSIGN  v_rec_dc_comis_trans = RECID(dc-comis-trans).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initialize det-dc-comis-trans 
PROCEDURE pi-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
    GET NEXT {&FRAME-NAME}.

    RUN pi-display.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

