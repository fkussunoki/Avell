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

/* Parameters Definitions ---                                           */

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
&Scoped-Define ENABLED-OBJECTS c-item-ini c-item-fim c-est-ini c-est-fim ~
c-periodo-ini c-periodo-fim BUTTON-3 BUTTON-4 IMAGE-1 IMAGE-2 IMAGE-25 ~
IMAGE-26 IMAGE-27 IMAGE-28 RECT-13 
&Scoped-Define DISPLAYED-OBJECTS c-item-ini c-item-fim c-est-ini c-est-fim ~
c-periodo-ini c-periodo-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-4 
     LABEL "Fechar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-est-fim AS CHARACTER FORMAT "X(3)":U INITIAL "zzzzz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE c-est-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(256)":U INITIAL "zzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE c-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE c-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .75 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.43 BY 7.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-item-ini AT ROW 2.13 COL 9.57 COLON-ALIGNED WIDGET-ID 2
     c-item-fim AT ROW 2.08 COL 31.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-est-ini AT ROW 3.83 COL 9.57 COLON-ALIGNED WIDGET-ID 8
     c-est-fim AT ROW 3.79 COL 31.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-periodo-ini AT ROW 5.58 COL 9.57 COLON-ALIGNED WIDGET-ID 12
     c-periodo-fim AT ROW 5.54 COL 31.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     BUTTON-3 AT ROW 7.17 COL 11.14 WIDGET-ID 32
     BUTTON-4 AT ROW 7.13 COL 27.57 WIDGET-ID 34
     IMAGE-1 AT ROW 2.13 COL 26.43 WIDGET-ID 14
     IMAGE-2 AT ROW 2.13 COL 30.43 WIDGET-ID 16
     IMAGE-25 AT ROW 3.88 COL 26.43 WIDGET-ID 18
     IMAGE-26 AT ROW 3.88 COL 30.43 WIDGET-ID 20
     IMAGE-27 AT ROW 5.54 COL 26.29 WIDGET-ID 22
     IMAGE-28 AT ROW 5.54 COL 30.29 WIDGET-ID 24
     RECT-13 AT ROW 1.17 COL 1.57 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.29 BY 8.08 WIDGET-ID 100.


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
         TITLE              = "CUSTO MEDIO"
         HEIGHT             = 8.08
         WIDTH              = 54.29
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* CUSTO MEDIO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* CUSTO MEDIO */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 C-Win
ON CHOOSE OF BUTTON-3 IN FRAME DEFAULT-FRAME /* Executar */
DO:
  RUN executar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 C-Win
ON CHOOSE OF BUTTON-4 IN FRAME DEFAULT-FRAME /* Fechar */
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
  DISPLAY c-item-ini c-item-fim c-est-ini c-est-fim c-periodo-ini c-periodo-fim 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE c-item-ini c-item-fim c-est-ini c-est-fim c-periodo-ini c-periodo-fim 
         BUTTON-3 BUTTON-4 IMAGE-1 IMAGE-2 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 
         RECT-13 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executar C-Win 
PROCEDURE executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Cria as variaveis necessÿrias para o relat½rio */

def var h-prog as handle no-undo.
DEF VAR chExcelApplication AS COM-HANDLE NO-UNDO.
DEF VAR chWorkbook AS COM-HANDLE NO-UNDO.
DEF var chworksheet AS com-handle.
DEF VAR m-linha AS INTEGER NO-UNDO. /* Variÿvel p/ contagem das linhas */

DEF VAR i-tot AS INTEGER.
ASSIGN m-linha = 1.
CREATE "Excel.Application" chExcelApplication. /* Cria a Planilha */
ASSIGN chWorkbook = chExcelApplication:Workbooks:ADD("")
       chworksheet=chexcelapplicAtion:sheets:item(1)
       chworksheet:name="Pasta do Relat½rio". /* Nome que serÿ criada a Pasta da Planilha */
       m-linha = 2.
    ASSIGN chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    ASSIGN chworksheet:range("A1:g1"):FONT:colorindex = 02 /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:g1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:g1"):VALUE = "ETENO - CUSTO MEDIO".
       chWorkSheet:Range("A1:g1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:g1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat½rio */
    ASSIGN chworksheet:range("A2:G2"):font:bold = TRUE  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):VALUE = "Item"
        chworksheet:range("B" + STRING(m-linha)):VALUE = "Descri‡ao"
        chworksheet:range("C" + STRING(m-linha)):VALUE = "Estab"
        chworksheet:range("d" + STRING(m-linha)):VALUE = "Periodo"
        chworksheet:range("e" + STRING(m-linha)):VALUE = "Material"
        chworksheet:range("f" + STRING(m-linha)):VALUE = "GGF"
        chworksheet:range("g" + STRING(m-linha)):VALUE = "Medio total".

        m-linha = m-linha + 1.
       
run utp/ut-perc.p persistent set h-prog.

    FOR EACH pr-it-per WHERE pr-it-per.it-codigo >= c-item-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.it-codigo <= c-item-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.cod-estabel >= c-est-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.cod-estabel <= c-est-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.periodo >= date(c-periodo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                        AND pr-it-per.periodo <= date(c-periodo-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK:
i-tot = i-tot + 1.
END.
    

run pi-inicializar in h-prog(input "Gerando arquivos", i-tot).
    /* Fa»a o for each desejado */    
     FOR EACH pr-it-per WHERE pr-it-per.it-codigo >= c-item-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.it-codigo <= c-item-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.cod-estabel >= c-est-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.cod-estabel <= c-est-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                        AND pr-it-per.periodo >= date(c-periodo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                        AND pr-it-per.periodo <= date(c-periodo-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK:

         
    
       run pi-acompanhar in h-prog.
   
        
       FIND FIRST ITEM WHERE ITEM.it-codigo = pr-it-per.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL ITEM THEN DO:
            
        
    
            /* Lista os dados da tabela nas colunas */
            ASSIGN chworksheet:range("A" + STRING(m-linha)):VALUE = pr-it-per.it-codigo
                chworksheet:range("B" + STRING(m-linha)):VALUE = item.descricao-1
                chworksheet:range("C" + STRING(m-linha)):VALUE = pr-it-per.cod-estabel
                chworksheet:range("D" + STRING(m-linha)):VALUE = pr-it-per.periodo
                chworksheet:range("E" + STRING(m-linha)):VALUE = pr-it-per.val-unit-mat-m[1]
                chworksheet:range("F" + STRING(m-linha)):VALUE = pr-it-per.val-unit-ggf-m[1]
                chworksheet:range("G" + STRING(m-linha)):VALUE = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-ggf-m[1].


                ASSIGN m-linha = m-linha + 1.
                

          END.

    END.

run pi-finalizar in h-prog.
    chExcelApplication:Range("A1"):select.
    chExcelApplication:Visible = yes.
    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorkbook.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

