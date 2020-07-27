&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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

/* ***************************  Definitions  ************************** */

{utp/ut-glob504.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMET p-rw-dc-orc-realizado AS ROWID NO-UNDO.


/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-cabec bt-exit bt-excel 
&Scoped-Define DISPLAYED-OBJECTS c-cod-cta-ctbl c-des-cta-ctbl c-cod-ccusto ~
c-des-ccusto c-modulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excel 
     LABEL "Exportar p/ Excel" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "Image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-exi.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE c-cod-ccusto AS CHARACTER FORMAT "X(8)":U 
     LABEL "C Custo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cta-ctbl AS CHARACTER FORMAT "X(8)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-ccusto AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cta-ctbl AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE c-modulo AS CHARACTER FORMAT "x(20)":U 
     LABEL "M¢dulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-cabec
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 3.5.

DEFINE VARIABLE c-detalhe AS LONGCHAR 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 111 BY 13.75
     FONT 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-cod-cta-ctbl AT ROW 1.5 COL 18 COLON-ALIGNED WIDGET-ID 4
     c-des-cta-ctbl AT ROW 1.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     bt-exit AT ROW 1.5 COL 108 WIDGET-ID 14
     c-cod-ccusto AT ROW 2.5 COL 18 COLON-ALIGNED WIDGET-ID 6
     c-des-ccusto AT ROW 2.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-modulo AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 12
     bt-excel AT ROW 3.5 COL 97 WIDGET-ID 16
     rt-cabec AT ROW 1.25 COL 1 WIDGET-ID 2
     SPACE(0.00) SKIP(15.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 10 WIDGET-ID 100.

DEFINE FRAME f-pg-detalhe
     c-detalhe AT ROW 1.25 COL 1 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.75 SCROLLABLE 
         TITLE "Detalhes" WIDGET-ID 200.


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
         TITLE              = "Detalhar Lan‡amentos - DOC024D"
         HEIGHT             = 18.88
         WIDTH              = 112.57
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-pg-detalhe:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME DEFAULT-FRAME:SCROLLABLE       = FALSE
       FRAME DEFAULT-FRAME:RESIZABLE        = TRUE.

/* SETTINGS FOR FILL-IN c-cod-ccusto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-cta-ctbl IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-ccusto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cta-ctbl IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-modulo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-detalhe
   Size-to-Fit                                                          */
ASSIGN 
       FRAME f-pg-detalhe:SCROLLABLE       = FALSE.

ASSIGN 
       c-detalhe:READ-ONLY IN FRAME f-pg-detalhe        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Detalhar Lan‡amentos - DOC024D */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Detalhar Lan‡amentos - DOC024D */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Detalhar Lan‡amentos - DOC024D */
DO:
    IF FRAME DEFAULT-FRAME:WIDTH < c-win:WIDTH THEN DO:
        ASSIGN FRAME DEFAULT-FRAME:WIDTH  = c-win:WIDTH               - 0.5
               FRAME DEFAULT-FRAME:HEIGHT = c-win:HEIGHT              - 0.1
               FRAME f-pg-detalhe:WIDTH   = c-win:WIDTH               - 0.5
               FRAME f-pg-detalhe:HEIGHT  = c-win:HEIGHT              - 3.75
               c-detalhe:WIDTH            = FRAME f-pg-detalhe:WIDTH  - 1
               c-detalhe:HEIGHT           = FRAME f-pg-detalhe:HEIGHT - 1.2
               rt-cabec:WIDTH             = c-win:WIDTH               - 0.5.
    END.
    ELSE DO:
        ASSIGN rt-cabec:WIDTH                         = c-win:WIDTH  - 0.5
               c-detalhe:WIDTH  IN FRAME f-pg-detalhe = c-win:WIDTH  - 1.5
               c-detalhe:HEIGHT IN FRAME f-pg-detalhe = c-win:HEIGHT - 4.95
               FRAME f-pg-detalhe:WIDTH               = c-win:WIDTH  - 0.5
               FRAME f-pg-detalhe:HEIGHT              = c-win:HEIGHT - 3.75
               FRAME DEFAULT-FRAME:WIDTH              = c-win:WIDTH  - 0.5
               FRAME DEFAULT-FRAME:HEIGHT             = c-win:HEIGHT.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel C-Win
ON CHOOSE OF bt-excel IN FRAME DEFAULT-FRAME /* Exportar p/ Excel */
DO:
    RUN pi-excel.
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
  RUN pi-inicio.
  RUN enable_UI.
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
  DISPLAY c-cod-cta-ctbl c-des-cta-ctbl c-cod-ccusto c-des-ccusto c-modulo 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rt-cabec bt-exit bt-excel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY c-detalhe 
      WITH FRAME f-pg-detalhe IN WINDOW C-Win.
  ENABLE c-detalhe 
      WITH FRAME f-pg-detalhe IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-detalhe}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excel C-Win 
PROCEDURE pi-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-nome-arq  AS CHAR NO-UNDO.
    DEF VAR c-nome-exl  AS CHAR NO-UNDO.

    FIND dc-orc-realizado NO-LOCK
        WHERE ROWID(dc-orc-realizado) = p-rw-dc-orc-realizado NO-ERROR.
    IF AVAIL dc-orc-realizado THEN DO:
        ASSIGN c-nome-arq = SESSION:TEMP-DIRECTORY + "detalhe-" + STRING(TIME) + ".csv".
        IF dc-orc-realizado.valor-realizado > 0 THEN
            COPY-LOB FROM dc-orc-realizado.det-realizado TO FILE c-nome-arq CONVERT TARGET CODEPAGE 'iso8859-1'.
        ELSE
            COPY-LOB FROM dc-orc-realizado.det-previsto TO FILE c-nome-arq CONVERT TARGET CODEPAGE 'iso8859-1'.

        RUN dop/doapi001.p (INPUT c-nome-arq,      /* p-arq-csv     */
                            INPUT YES,             /* p-elimina-csv */
                            INPUT YES,             /* p-abre-arq    */
                            INPUT NO,              /* p-altera-nome */
                            OUTPUT c-nome-exl).    /* p-nome-saida  */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicio C-Win 
PROCEDURE pi-inicio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-win:MIN-WIDTH  = 112.57
           c-win:MIN-HEIGHT = 18.88.

    FIND dc-orc-realizado NO-LOCK
        WHERE ROWID(dc-orc-realizado) = p-rw-dc-orc-realizado NO-ERROR.
    IF AVAIL dc-orc-realizado THEN DO:

        ASSIGN c-cod-cta-ctbl = dc-orc-realizado.cod_cta_ctbl
               c-cod-ccusto   = dc-orc-realizado.cod_ccusto
               c-modulo       = dc-orc-realizado.modulo.

        FIND cta_ctbl NO-LOCK 
            WHERE cta_ctbl.cod_plano_cta_ctbl = dc-orc-realizado.cod_plano_ctbl
            AND   cta_ctbl.cod_cta_ctbl       = dc-orc-realizado.cod_cta_ctbl NO-ERROR.
        IF AVAIL cta_ctbl THEN
            ASSIGN c-des-cta-ctbl = cta_ctbl.des_tit_ctbl.

        FIND emsuni.ccusto NO-LOCK
            WHERE ccusto.cod_empresa      = v_cod_empres_usuar
            AND   ccusto.cod_plano_ccusto = dc-orc-realizado.cod_plano_ccusto
            AND   ccusto.cod_ccusto       = dc-orc-realizado.cod_ccusto NO-ERROR.
        IF AVAIL ccusto THEN
            ASSIGN c-des-ccusto = ccusto.des_tit_ctbl.

        RUN pi-processa-detalhe.

        /*CASE dc-orc-realizado.modulo:
            WHEN "HCM" THEN DO:
                RUN pi-processa-detalhe-hcm.
            END.
        END CASE.*/

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-detalhe C-Win 
PROCEDURE pi-processa-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-cont-det      AS INTEGER           NO-UNDO.
    DEF VAR i-cont-linha    AS INTEGER           NO-UNDO.
    DEF VAR c-linha         AS CHARACTER         NO-UNDO.
    DEF VAR i-tam           AS INTEGER EXTENT 40 NO-UNDO. /* 40 colunas */
    DEF VAR lc-detalhe      AS LONGCHAR          NO-UNDO.
    DEF VAR lc-previsto     AS LONGCHAR          NO-UNDO.
    
    IF AVAIL dc-orc-realizado THEN DO:

        COPY-LOB FROM dc-orc-realizado.det-realizado TO lc-detalhe.

        IF lc-detalhe = "" OR lc-detalhe = ? THEN
            COPY-LOB FROM dc-orc-realizado.det-previsto TO lc-detalhe.
        
        DO i-cont-det = 1 TO NUM-ENTRIES(lc-detalhe,CHR(10)):
            ASSIGN c-linha = ENTRY(i-cont-det,lc-detalhe,CHR(10)).
            DO i-cont-linha = 1 TO NUM-ENTRIES(c-linha,";"):
                IF i-cont-det = 1 THEN
                    ASSIGN i-tam[i-cont-linha] = LENGTH(ENTRY(i-cont-linha,c-linha,";")).
                ASSIGN c-detalhe = c-detalhe + ENTRY(i-cont-linha,c-linha,";") + FILL(" ",i-tam[i-cont-linha] - LENGTH(ENTRY(i-cont-linha,c-linha,";"))) + " ".
            END.
            ASSIGN c-detalhe = c-detalhe + CHR(10).
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

