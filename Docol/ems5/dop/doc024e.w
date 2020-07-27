&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{utp/ut-glob504.i}

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-cod_cta_ctbl    LIKE dc-orc-realizado.cod_cta_ctbl NO-UNDO.
DEF INPUT PARAM p-cod_modul_dtsul LIKE dc-orc-realizado.MODULO       NO-UNDO.
DEF INPUT PARAM p-lista-ccusto    AS CHAR                            NO-UNDO.
DEF INPUT PARAM p-da-ini          AS DATE                            NO-UNDO.
DEF INPUT PARAM p-da-fim          AS DATE                            NO-UNDO.

def new global shared var v_cod_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.
def new global shared var v_cdn_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.

DEFINE VARIABLE cc-plano AS CHARACTER NO-UNDO.
{doinc/dsg998.i} /* Sugest∆o cc-plano conforme empresa */

/* Local Variable Definitions ---                                       */
DEF VAR c-cabecalho       AS CHARACTER NO-UNDO.
DEF VAR c-cabecalho-excel AS CHARACTER NO-UNDO.
DEF VAR c-detalhe-excel   AS LONGCHAR  NO-UNDO.

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
&Scoped-Define DISPLAYED-OBJECTS c-cod-cta-ctbl c-des-cta-ctbl c-modulo 

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

DEFINE VARIABLE c-cod-cta-ctbl AS CHARACTER FORMAT "X(8)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cta-ctbl AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE c-modulo AS CHARACTER FORMAT "x(20)":U 
     LABEL "M¢dulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-cabec
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 2.75.

DEFINE VARIABLE c-detalhe AS LONGCHAR 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 111 BY 13.75
     FONT 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     bt-exit AT ROW 1.25 COL 108 WIDGET-ID 14
     c-cod-cta-ctbl AT ROW 1.5 COL 18 COLON-ALIGNED WIDGET-ID 4
     c-des-cta-ctbl AT ROW 1.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-modulo AT ROW 2.5 COL 18 COLON-ALIGNED WIDGET-ID 12
     bt-excel AT ROW 2.5 COL 97 WIDGET-ID 16
     rt-cabec AT ROW 1 COL 1 WIDGET-ID 2
     SPACE(0.00) SKIP(15.13)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 10 WIDGET-ID 100.

DEFINE FRAME f-pg-detalhe
     c-detalhe AT ROW 1.25 COL 1 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4 SCROLLABLE 
         TITLE "Detalhes" WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Detalhar Lanáamentos - DOC024E"
         HEIGHT             = 18.13
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

/* SETTINGS FOR FILL-IN c-cod-cta-ctbl IN FRAME DEFAULT-FRAME
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
ON END-ERROR OF C-Win /* Detalhar Lanáamentos - DOC024E */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Detalhar Lanáamentos - DOC024E */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Detalhar Lanáamentos - DOC024E */
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
  DISPLAY c-cod-cta-ctbl c-des-cta-ctbl c-modulo 
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
DEF VAR c-nome-arq  AS CHAR NO-UNDO.
DEF VAR c-nome-exl  AS CHAR NO-UNDO.

ASSIGN c-nome-arq = SESSION:TEMP-DIRECTORY + "detalhe-" + STRING(TIME) + ".csv".

COPY-LOB FROM c-detalhe-excel TO FILE c-nome-arq CONVERT TARGET CODEPAGE 'iso8859-1'.

RUN dop/doapi001.p (INPUT c-nome-arq,      /* p-arq-csv     */
                    INPUT YES,             /* p-elimina-csv */
                    INPUT YES,             /* p-abre-arq    */
                    INPUT NO,              /* p-altera-nome */
                    OUTPUT c-nome-exl).    /* p-nome-saida  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicio C-Win 
PROCEDURE pi-inicio :
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN c-win:MIN-WIDTH  = 112.57
       c-win:MIN-HEIGHT = 18.88.

ASSIGN c-cod-cta-ctbl = p-cod_cta_ctbl
       c-modulo       = p-cod_modul_dtsul.

    
FIND  cta_ctbl NO-LOCK 
WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
  AND cta_ctbl.cod_cta_ctbl       = p-cod_cta_ctbl NO-ERROR.
IF AVAIL cta_ctbl THEN
    ASSIGN c-des-cta-ctbl = cta_ctbl.des_tit_ctbl.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Carregando despesas...").

FIND FIRST estabelec WHERE estabelec.ep-codigo = v_cdn_empres_usuar NO-LOCK NO-ERROR.

IF p-lista-ccusto <> "" THEN
    DO i-cont = 1 TO NUM-ENTRIES(p-lista-ccusto):
        FOR EACH dc-orc-realizado NO-LOCK
           WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
             AND dc-orc-realizado.cod_estab        = estabelec.cod-estabel
             AND dc-orc-realizado.cod_plano_ctbl   = "PCDOCOL"
             AND dc-orc-realizado.cod_cta_ctbl     = p-cod_cta_ctbl
             AND dc-orc-realizado.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
             AND dc-orc-realizado.modulo           = p-cod_modul_dtsul
             AND dc-orc-realizado.cod_ccusto       = ENTRY(i-cont,p-lista-ccusto,",")
             AND dc-orc-realizado.data            >= p-da-ini
             AND dc-orc-realizado.data            <= p-da-fim:
    
            RUN pi-acompanhar IN h-acomp(INPUT "CCusto " + dc-orc-realizado.cod_ccusto).
                
            RUN pi-processa-detalhe.
        END.
    END.
ELSE DO:

    FOR EACH dc-orc-realizado NO-LOCK
       WHERE dc-orc-realizado.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
       AND   dc-orc-realizado.cod_estab        = estabelec.cod-estabel
       AND   dc-orc-realizado.modulo           = p-cod_modul_dtsul
       AND   dc-orc-realizado.data            >= p-da-ini
       AND   dc-orc-realizado.data            <= p-da-fim
       AND   dc-orc-realizado.cod_cta_ctbl     = p-cod_cta_ctbl:

        RUN pi-acompanhar IN h-acomp(INPUT "CCusto " + dc-orc-realizado.cod_ccusto).

        RUN pi-processa-detalhe.

    END.

END.

IF c-detalhe   <> "" AND
   c-cabecalho <> "" THEN
    ASSIGN c-detalhe       = c-cabecalho       + CHR(10) + c-detalhe
           c-detalhe-excel = c-cabecalho-excel + CHR(10) + c-detalhe-excel.

REPEAT:
    IF INDEX(c-detalhe, CHR(10) + CHR(10)) = 0 THEN LEAVE.
    ASSIGN c-detalhe = REPLACE(c-detalhe,CHR(10) + CHR(10),CHR(10)).
END.

REPEAT:
    IF INDEX(c-detalhe-excel, CHR(10) + CHR(10)) = 0 THEN LEAVE.
    ASSIGN c-detalhe-excel = REPLACE(c-detalhe-excel,CHR(10) + CHR(10),CHR(10)).
END.


RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-detalhe C-Win 
PROCEDURE pi-processa-detalhe :
DEF VAR i-cont-det      AS INTEGER           NO-UNDO.
DEF VAR i-cont-linha    AS INTEGER           NO-UNDO.
DEF VAR c-linha         AS CHARACTER         NO-UNDO.
DEF VAR i-tam           AS INTEGER EXTENT 30 NO-UNDO. /* 30 colunas */
DEF VAR lc-detalhe      AS LONGCHAR          NO-UNDO.
DEF VAR lc-previsto     AS LONGCHAR          NO-UNDO.

COPY-LOB FROM dc-orc-realizado.det-realizado TO lc-detalhe.
IF lc-detalhe = "" OR lc-detalhe = ? THEN
    COPY-LOB FROM dc-orc-realizado.det-previsto TO lc-detalhe.

ASSIGN c-cabecalho = "".
DO i-cont-det = 1 TO NUM-ENTRIES(lc-detalhe,CHR(10)):
    ASSIGN c-linha = ENTRY(i-cont-det,lc-detalhe,CHR(10)).
    DO i-cont-linha = 1 TO NUM-ENTRIES(c-linha,";"):

        IF i-cont-det = 1 THEN
            ASSIGN i-tam[i-cont-linha] = LENGTH(ENTRY(i-cont-linha,c-linha,";")).

        IF i-cont-det = 1 /* Cabeáalho */ THEN
            ASSIGN c-cabecalho       = c-cabecalho + ENTRY(i-cont-linha,c-linha,";") + FILL(" ",i-tam[i-cont-linha] - LENGTH(ENTRY(i-cont-linha,c-linha,";"))) + " ".
        ELSE
            ASSIGN c-detalhe       = c-detalhe       + ENTRY(i-cont-linha,c-linha,";") + FILL(" ",i-tam[i-cont-linha] - LENGTH(ENTRY(i-cont-linha,c-linha,";"))) + " ".
    END.
    ASSIGN c-detalhe       = c-detalhe       + CHR(10).
    IF i-cont-det = 1 THEN
        ASSIGN c-cabecalho-excel = c-linha + CHR(10).
    ELSE
        ASSIGN c-detalhe-excel = c-detalhe-excel + c-linha + CHR(10).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


