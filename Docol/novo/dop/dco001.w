&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.
{utp/ut-glob504.i}
    
/* ***************************  Definitions  ************************** */

DEF BUFFER b-dc-comis-trans FOR dc-comis-trans.

DEF NEW GLOBAL SHARED VAR v_rec_dc_comis_trans   AS RECID    NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_empresa         AS RECID    NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario   like param-global.empresa-prin NO-UNDO.

DEF VAR v_log_answer        AS LOGICAL  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES dc-comis-trans

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME dc-comis-trans.log_contabiliza ~
dc-comis-trans.cod_transacao dc-comis-trans.dat_inic_valid ~
dc-comis-trans.dat_fim_valid dc-comis-trans.descricao ~
dc-comis-trans.ind_tip_trans dc-comis-trans.ind_incid_liquido ~
dc-comis-trans.ind_incid_ir dc-comis-trans.log_perm_digitacao ~
dc-comis-trans.ind_tip_movto dc-comis-trans.ind_incid_iss 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DEFAULT-FRAME ~
dc-comis-trans.cod_transacao dc-comis-trans.dat_inic_valid 
&Scoped-define ENABLED-TABLES-IN-QUERY-DEFAULT-FRAME dc-comis-trans
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DEFAULT-FRAME dc-comis-trans
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH dc-comis-trans SHARE-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH dc-comis-trans SHARE-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME dc-comis-trans
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME dc-comis-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS dc-comis-trans.cod_transacao ~
dc-comis-trans.dat_inic_valid  
&Scoped-define ENABLED-TABLES dc-comis-trans dc-comis-trans-ctb
&Scoped-define FIRST-ENABLED-TABLE dc-comis-trans
&Scoped-Define ENABLED-OBJECTS Btn_First Btn_Prev Btn_Next Btn_Last bt-add ~
bt-mod bt-era bt-det bt-sea bt-exit bt-ajuda bt-go RECT-1 rt-chave ~
rt-contabil rt-financeiro 
&Scoped-Define DISPLAYED-FIELDS dc-comis-trans.log_contabiliza ~
dc-comis-trans.cod_transacao dc-comis-trans.dat_inic_valid ~
dc-comis-trans.dat_fim_valid dc-comis-trans.descricao ~
dc-comis-trans.ind_tip_trans dc-comis-trans.ind_incid_liquido ~
dc-comis-trans.ind_incid_ir dc-comis-trans.log_perm_digitacao ~
dc-comis-trans.ind_tip_movto dc-comis-trans-ctb.cod_plano_cta_ctbl ~
dc-comis-trans-ctb.cod_cta_ctbl dc-comis-trans-ctb.cod_plano_ccusto ~
dc-comis-trans-ctb.cod_ccusto dc-comis-trans.ind_incid_iss 
&Scoped-define DISPLAYED-TABLES dc-comis-trans dc-comis-trans-ctb
&Scoped-define FIRST-DISPLAYED-TABLE dc-comis-trans
&Scoped-define SECOND-DISPLAYED-TABLE dc-comis-trans-ctb


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Arquivo 
       MENU-ITEM m_Primeiro     LABEL "Primeiro"       ACCELERATOR "ALT-HOME"
       MENU-ITEM m_Anterior     LABEL "Anterior"       ACCELERATOR "ALT-CURSOR-LEFT"
       MENU-ITEM m_Prximo       LABEL "Pr¢ximo"        ACCELERATOR "ALT-CURSOR-RIGHT"
       MENU-ITEM m_ltimo        LABEL "Èltimo"         ACCELERATOR "ALT-END"
       RULE
       MENU-ITEM m_Pesquisa     LABEL "Pesquisa"       ACCELERATOR "ALT-Z"
       MENU-ITEM m_Ajuda        LABEL "Ajuda"          ACCELERATOR "ALT-F1"
       RULE
       MENU-ITEM m_Sada         LABEL "Sa°da"         .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Arquivo      LABEL "Arquivo"       .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "Image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-add.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-ajuda 
     IMAGE-UP FILE "Image/im-hel.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-hel.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-det 
     IMAGE-UP FILE "Image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Detalhe do T°tulo".

DEFINE BUTTON bt-era 
     IMAGE-UP FILE "Image/im-era1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-era1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "Image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-exi.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-go 
     IMAGE-UP FILE "Image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-enter.bmp":U
     LABEL "" 
     SIZE 4 BY .88.

DEFINE BUTTON bt-mod 
     IMAGE-UP FILE "Image/im-mod.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-mod.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-sea 
     IMAGE-UP FILE "Image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON Btn_First 
     IMAGE-UP FILE "Image/im-fir.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-fir.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Last 
     IMAGE-UP FILE "Image/im-las.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-las.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Next 
     IMAGE-UP FILE "Image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-nex1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Prev 
     IMAGE-UP FILE "Image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-pre1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 82 BY 1.29
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
DEFINE QUERY DEFAULT-FRAME FOR 
      dc-comis-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     dc-comis-trans.log_contabiliza AT ROW 11 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     Btn_First AT ROW 1.08 COL 1.43
     Btn_Prev AT ROW 1.08 COL 5.43
     Btn_Next AT ROW 1.08 COL 9.43
     Btn_Last AT ROW 1.08 COL 13.43
     bt-add AT ROW 1.08 COL 19
     bt-mod AT ROW 1.08 COL 23
     bt-era AT ROW 1.08 COL 27
     bt-det AT ROW 1.08 COL 38.14
     bt-sea AT ROW 1.08 COL 42.14
     bt-exit AT ROW 1.08 COL 74.72
     bt-ajuda AT ROW 1.08 COL 78.72
     dc-comis-trans.cod_transacao AT ROW 2.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
          BGCOLOR 15 FONT 2
     bt-go AT ROW 2.75 COL 27
     dc-comis-trans.dat_inic_valid AT ROW 3.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.dat_fim_valid AT ROW 3.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.descricao AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.ind_tip_trans AT ROW 6.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.ind_incid_liquido AT ROW 8.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
          BGCOLOR 15 
     dc-comis-trans.ind_incid_ir AT ROW 9.5 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .71
     dc-comis-trans.log_perm_digitacao AT ROW 9.5 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     dc-comis-trans.ind_tip_movto AT ROW 12 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DB", yes,
"CR", no
          SIZE 17 BY .88
     dc-comis-trans-ctb.cod_plano_cta_ctbl AT ROW 13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_cta_ctbl AT ROW 14 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_plano_ccusto AT ROW 13 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans-ctb.cod_ccusto AT ROW 14 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          BGCOLOR 15 FONT 2
     dc-comis-trans.ind_incid_iss AT ROW 7.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .79
          BGCOLOR 15 
     "Tipo Movto:" VIEW-AS TEXT
          SIZE 8.29 BY .88 AT ROW 12 COL 13
     RECT-1 AT ROW 1 COL 1
     rt-chave AT ROW 2.5 COL 2
     rt-contabil AT ROW 10.75 COL 2
     rt-financeiro AT ROW 5.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.57 BY 14.63
         BGCOLOR 8 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o Transaá∆o de Comiss∆o - dco001"
         HEIGHT             = 14.54
         WIDTH              = 81.86
         MAX-HEIGHT         = 29.38
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29.38
         VIRTUAL-WIDTH      = 146.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN dc-comis-trans.dat_fim_valid IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.descricao IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.ind_incid_ir IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_incid_iss IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_incid_liquido IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET dc-comis-trans.ind_tip_movto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-comis-trans.ind_tip_trans IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.log_contabiliza IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dc-comis-trans.log_perm_digitacao IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "emsdocol.dc-comis-trans"
     _Options          = "SHARE-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Manutená∆o Transaá∆o de Comiss∆o - dco001 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Manutená∆o Transaá∆o de Comiss∆o - dco001 */
DO:
  /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add C-Win
ON CHOOSE OF bt-add IN FRAME DEFAULT-FRAME
DO:
    RUN dop/dco001a.w.

    IF  v_rec_dc_comis_trans <> ? AND 
        v_rec_dc_comis_trans <> 0 THEN DO:
        {&OPEN-QUERY-{&FRAME-NAME}}
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det C-Win
ON CHOOSE OF bt-det IN FRAME DEFAULT-FRAME
DO:
    RUN dop/dco001c.w.

    IF  v_rec_dc_comis_trans <> ? AND 
        v_rec_dc_comis_trans <> 0 THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-era
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-era C-Win
ON CHOOSE OF bt-era IN FRAME DEFAULT-FRAME
DO:
    IF  AVAIL {&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} THEN DO:

        ASSIGN  v_log_answer = NO.
    
        FIND FIRST b-{&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} EXCLUSIVE-LOCK
                 WHERE RECID(b-{&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}}) = RECID({&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}}) NO-ERROR.
        FIND FIRST dc-comis-movto NO-LOCK
             WHERE dc-comis-movto.cod_transacao = b-{&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}}.cod_transacao NO-ERROR.
        IF AVAIL dc-comis-movto THEN DO:
           RUN MESSAGE.p ("Eliminaá∆o n∆o permitida!",
                          "Transaá∆o j† foi utilizada no movimento de comiss∆o.").
        END.
        ELSE DO:
            MESSAGE "Confirme eliminaá∆o de Transaá∆o de Comiss∆o ?" VIEW-AS ALERT-BOX 
                    QUESTION BUTTONS YES-NO-CANCEL TITLE "Transaá∆o de Comiss∆o" UPDATE v_log_answer.
        
            IF  v_log_answer THEN DO:
    
                GET NEXT {&FRAME-NAME}.
                IF  NOT AVAIL {&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} THEN DO:
                    GET PREV {&FRAME-NAME}.
                    GET PREV {&FRAME-NAME}.
                END.
    
                delete_block:
                DO  ON ERROR UNDO delete_block, LEAVE delete_block:
                    FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                                    AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                                    AND dc-comis-trans-ctb.cod_empresa    = i-ep-codigo-usuario EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL dc-comis-trans-ctb THEN
                       DELETE dc-comis-trans-ctb.
                    DELETE  b-{&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}}.
                    ASSIGN  v_rec_dc_comis_trans = ?.
                END /* do delete_block */.
    
                RUN pi-display.
    
            END /* if */.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit C-Win
ON CHOOSE OF bt-exit IN FRAME DEFAULT-FRAME
DO:
    APPLY 'close' TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go C-Win
ON CHOOSE OF bt-go IN FRAME DEFAULT-FRAME
DO:
    FIND FIRST b-dc-comis-trans no-lock
         WHERE b-dc-comis-trans.cod_transacao  = INPUT FRAME {&FRAME-NAME} dc-comis-trans.cod_transacao 
           AND b-dc-comis-trans.dat_inic_valid = INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_inic_valid NO-ERROR.
    IF  AVAIL b-dc-comis-trans THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID RECID(b-dc-comis-trans).
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mod C-Win
ON CHOOSE OF bt-mod IN FRAME DEFAULT-FRAME
DO:
    RUN dop/dco001b.w.

    IF  v_rec_dc_comis_trans <> ? AND 
        v_rec_dc_comis_trans <> 0 THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sea C-Win
ON CHOOSE OF bt-sea IN FRAME DEFAULT-FRAME
DO:
    RUN dozoom/dco001z1.w.

    IF  v_rec_dc_comis_trans <> ? AND 
        v_rec_dc_comis_trans <> 0 THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_First
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_First C-Win
ON CHOOSE OF Btn_First IN FRAME DEFAULT-FRAME
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN notify IN THIS-PROCEDURE ("get-first") NO-ERROR.
  &ELSEIF "{&TABLES-IN-QUERY-{&FRAME-NAME}}" ne "" &THEN
  /* This is a simple FIRST RECORD navigation button, useful for building
     test screens quickly.  NOTE: if there are no tables in the query, then
     this code will not compile; so use the preprocessor to skip it. */
      
      GET FIRST {&FRAME-NAME}.
      RUN pi-display.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Last C-Win
ON CHOOSE OF Btn_Last IN FRAME DEFAULT-FRAME
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN notify IN THIS-PROCEDURE ("get-last") NO-ERROR.
  &ELSEIF "{&TABLES-IN-QUERY-{&FRAME-NAME}}" ne "" &THEN
  /* This is a simple LAST RECORD navigation button, useful for building
     test screens quickly.  NOTE: if there are no tables in the query, then
     this code will not compile; so use the preprocessor to skip it. */
      
      GET LAST {&FRAME-NAME}.
      RUN pi-display.
      
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Next C-Win
ON CHOOSE OF Btn_Next IN FRAME DEFAULT-FRAME
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN notify IN THIS-PROCEDURE ("get-next") NO-ERROR.
  &ELSEIF "{&TABLES-IN-QUERY-{&FRAME-NAME}}" ne "" &THEN
  /* This is a simple NEXT RECORD navigation button, useful for building
     test screens quickly.  NOTE: if there are no tables in the query, then
     this code will not compile; so use the preprocessor to skip it. */

        GET NEXT {&FRAME-NAME}.
        IF  NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} THEN 
            GET LAST {&FRAME-NAME}.

        RUN pi-display.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Prev C-Win
ON CHOOSE OF Btn_Prev IN FRAME DEFAULT-FRAME
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN notify IN THIS-PROCEDURE ("get-prev") NO-ERROR.
  &ELSEIF "{&TABLES-IN-QUERY-{&FRAME-NAME}}" ne "" &THEN
  /* This is a simple PREV RECORD navigation button, useful for building
     test screens quickly.  NOTE: if there are no tables in the query, then
     this code will not compile; so use the preprocessor to skip it. */
      
        GET PREV {&FRAME-NAME}.
        IF  NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} THEN 
            GET FIRST {&FRAME-NAME}.

        RUN pi-display.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ajuda C-Win
ON CHOOSE OF MENU-ITEM m_Ajuda /* Ajuda */
DO:
    APPLY 'choose' TO Bt-ajuda IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anterior C-Win
ON CHOOSE OF MENU-ITEM m_Anterior /* Anterior */
DO:
    APPLY 'choose' TO Btn_Prev IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ltimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ltimo C-Win
ON CHOOSE OF MENU-ITEM m_ltimo /* Èltimo */
DO:
    APPLY 'choose' TO Btn_Last IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pesquisa C-Win
ON CHOOSE OF MENU-ITEM m_Pesquisa /* Pesquisa */
DO:
    APPLY 'choose' TO Bt-Sea IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Primeiro C-Win
ON CHOOSE OF MENU-ITEM m_Primeiro /* Primeiro */
DO:
    APPLY 'choose' TO Btn_First IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prximo C-Win
ON CHOOSE OF MENU-ITEM m_Prximo /* Pr¢ximo */
DO:
    APPLY 'choose' TO Btn_Next IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sada C-Win
ON CHOOSE OF MENU-ITEM m_Sada /* Sa°da */
DO:
    APPLY 'choose' TO Bt-Exit IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */

ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN pi-initialize.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  IF AVAILABLE dc-comis-trans THEN 
    DISPLAY dc-comis-trans.log_contabiliza dc-comis-trans.cod_transacao 
          dc-comis-trans.dat_inic_valid dc-comis-trans.dat_fim_valid 
          dc-comis-trans.descricao dc-comis-trans.ind_tip_trans 
          dc-comis-trans.ind_incid_liquido dc-comis-trans.ind_incid_ir 
          dc-comis-trans.log_perm_digitacao dc-comis-trans.ind_tip_movto 
          dc-comis-trans.ind_incid_iss 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE dc-comis-trans-ctb THEN 
    DISPLAY dc-comis-trans-ctb.cod_plano_cta_ctbl dc-comis-trans-ctb.cod_cta_ctbl 
          dc-comis-trans-ctb.cod_plano_ccusto dc-comis-trans-ctb.cod_ccusto 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE Btn_First Btn_Prev Btn_Next Btn_Last bt-add bt-mod bt-era bt-det 
         bt-sea bt-exit bt-ajuda dc-comis-trans.cod_transacao bt-go 
         dc-comis-trans.dat_inic_valid  RECT-1 rt-chave rt-contabil 
         rt-financeiro 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display C-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  AVAIL {&FIRST-TABLE-IN-QUERY-{&FRAME-NAME}} THEN DO:
        FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                        AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                        AND dc-comis-trans-ctb.cod_empresa    = i-ep-codigo-usuario NO-LOCK NO-ERROR.
        DISPLAY {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME {&FRAME-NAME}.
        IF AVAIL dc-comis-trans-ctb THEN DO:
            FIND FIRST plano_cta_ctbl NO-LOCK 
                 WHERE plano_cta_ctbl.cod_plano_cta_ctbl = dc-comis-trans-ctb.cod_plano_cta_ctbl NO-ERROR.
            ASSIGN  dc-comis-trans-ctb.cod_cta_ctbl:FORMAT = IF  AVAIL plano_cta_ctbl THEN  plano_cta_ctbl.cod_format_cta_ctbl ELSE 'X(20)'.
    
            FIND FIRST plano_ccusto NO-LOCK
                 WHERE plano_ccusto.cod_plano_ccusto = dc-comis-trans-ctb.cod_plano_ccusto NO-ERROR.
            ASSIGN  dc-comis-trans-ctb.cod_ccusto:FORMAT = IF  AVAIL plano_ccusto THEN plano_ccusto.cod_format_ccusto ELSE 'X(11)'.
            DISPLAY dc-comis-trans-ctb.cod_plano_cta_ctbl dc-comis-trans-ctb.cod_cta_ctbl 
                    dc-comis-trans-ctb.cod_plano_ccusto dc-comis-trans-ctb.cod_ccusto 
               WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
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
               WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
        END.
        
        ASSIGN  v_rec_dc_comis_trans = RECID(dc-comis-trans).
    END.
    ELSE DO:
        CLEAR FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initialize C-Win 
PROCEDURE pi-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  v_rec_dc_comis_trans <> ? THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans NO-ERROR.
        GET NEXT  {&FRAME-NAME}.
    END.
    ELSE 
        GET FIRST {&FRAME-NAME}.

    RUN pi-display.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

