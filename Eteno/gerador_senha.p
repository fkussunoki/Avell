&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

DEFINE VARIABLE c-chave-secreta AS CHAR  NO-UNDO. 
DEFINE VARIABLE c-param         AS CHAR NO-UNDO.

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 l-gerar-nova-chave ~
rs-situacao l-limpa-chave-acesso l-informa-chave-acesso l-protocolo ~
l-acerta-dt-emis l-acerta-tp-emis l-acerta-dt-cancel l-dados-emis-man ~
l-elimina-cce dt-validade bt-gerar c-chave EDITOR-1 
&Scoped-Define DISPLAYED-OBJECTS l-gerar-nova-chave rs-situacao ~
l-limpa-chave-acesso l-informa-chave-acesso l-protocolo ~
l-acerta-dt-emis l-acerta-tp-emis l-acerta-dt-cancel l-dados-emis-man ~
l-elimina-cce dt-validade c-chave EDITOR-1

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-gerar 
     LABEL "Gerar" 
     SIZE 15.14 BY 1.42.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 10000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 132.14 BY 13.33 NO-UNDO.

DEFINE VARIABLE c-chave AS CHARACTER FORMAT "X(200)":U 
     VIEW-AS FILL-IN 
     SIZE 103 BY .88 NO-UNDO.

DEFINE VARIABLE dt-validade AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 20.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-situacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Acertos Gerais", 1,
"NF-e n∆o Gerada", 2,
"NF-e Gerada", 3,
"Uso Autorizado", 4,
"Documento Rejeitado", 5,
"Documento Cancelado", 6,
"Documento Inutilizado", 7,
"Em Proces. no Aplicativo Transmiss∆o", 8,
"Em Processamento", 9,
"NF-e em Processamento de Cancelamento", 10,
"NF-e em Processamento de Inutilizaá∆o", 11,
"Uso Denegado", 12
     SIZE 52.43 BY 8.29 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 9.13.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.14 BY 9.13.

DEFINE VARIABLE l-gerar-nova-chave AS LOGICAL INITIAL no 
     LABEL "Gerar nova chave de acesso" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-informa-chave-acesso AS LOGICAL INITIAL no 
     LABEL "Informar chave de acesso manualmente" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-limpa-chave-acesso AS LOGICAL INITIAL no 
     LABEL "Limpar chave de acesso" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.86 BY .79 NO-UNDO.

DEFINE VARIABLE l-protocolo AS LOGICAL INITIAL no 
     LABEL "Informar protocolo da transaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-acerta-dt-emis AS LOGICAL INITIAL no 
     LABEL "Acertar data de emiss∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-acerta-tp-emis AS LOGICAL INITIAL no 
     LABEL "Acertar tipo de emiss∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-acerta-dt-cancel AS LOGICAL INITIAL no 
     LABEL "Acertar data de cancelamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-dados-emis-man AS LOGICAL INITIAL no 
     LABEL "Limpar dados emiss∆o manual" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

DEFINE VARIABLE l-elimina-cce AS LOGICAL INITIAL no 
     LABEL "Eliminar sequàncias CC-e" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.14 BY .79 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     l-gerar-nova-chave     AT ROW 1.79 COL 58.14 WIDGET-ID 32
     rs-situacao            AT ROW 1.96 COL 3 NO-LABEL WIDGET-ID 42
     l-limpa-chave-acesso   AT ROW 2.54 COL 58.14 WIDGET-ID 4
     l-informa-chave-acesso AT ROW 3.29 COL 58.14 WIDGET-ID 2
     l-protocolo            AT ROW 4.13 COL 58.14 WIDGET-ID 36
     l-acerta-dt-emis       AT ROW 4.88 COL 58.14 WIDGET-ID 36
     l-acerta-tp-emis       AT ROW 5.63 COL 58.14 WIDGET-ID 36
     l-acerta-dt-cancel     AT ROW 6.41 COL 58.14 WIDGET-ID 36
     l-dados-emis-man       AT ROW 7.16 COL 58.14 WIDGET-ID 36
     l-elimina-cce          AT ROW 7.91 COL 58.14 WIDGET-ID 36
     dt-validade            AT ROW 12.79 COL 1.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     bt-gerar               AT ROW 13.92 COL 3.14 WIDGET-ID 16
     c-chave                AT ROW 16.25 COL 3.14 NO-LABEL WIDGET-ID 18
     EDITOR-1               AT ROW 18.13 COL 3.14 NO-LABEL WIDGET-ID 22
     "C¢digo de Seguranáa:" VIEW-AS TEXT
          SIZE 21 BY .67 AT ROW 15.58 COL 3.43 WIDGET-ID 56
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 10.14 BY .79 AT ROW 1 COL 3.86 WIDGET-ID 58
     "Dt. de validade do c¢digo de seguranáa:" VIEW-AS TEXT
          SIZE 39 BY .67 AT ROW 12.08 COL 3.14 WIDGET-ID 64
     "Aá∆o Informada:" VIEW-AS TEXT
          SIZE 16.86 BY .5 AT ROW 1.13 COL 58.57 WIDGET-ID 62
     "Texto de orientaá∆o:" VIEW-AS TEXT
          SIZE 19.86 BY .67 AT ROW 17.42 COL 3.14 WIDGET-ID 60
     RECT-10 AT ROW 1.33 COL 2.43 WIDGET-ID 38
     /*RECT-11 AT ROW 1.33 COL 57 WIDGET-ID 40*/
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136 BY 31.14 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Gerador do c¢digo de seguranáa do SPRE100"
         HEIGHT             = 31.38
         WIDTH              = 137.14
         MAX-HEIGHT         = 40.67
         MAX-WIDTH          = 161.43
         VIRTUAL-HEIGHT     = 40.67
         VIRTUAL-WIDTH      = 161.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-chave IN FRAME fMain
   ALIGN-L                                                              */
ASSIGN 
       c-chave:READ-ONLY IN FRAME fMain        = TRUE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME fMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Gerador do c¢digo de seguranáa do SPRE100 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Gerador do c¢digo de seguranáa do SPRE100 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gerar wWin
ON CHOOSE OF bt-gerar IN FRAME fMain /* Gerar */
DO:
  RUN pi-gerar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-gerar-nova-chave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-gerar-nova-chave wWin
ON VALUE-CHANGED OF l-gerar-nova-chave IN FRAME fMain /* Gerar nova chave de acesso */
DO:
  IF l-gerar-nova-chave:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
      ASSIGN l-informa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME}   = NO
             l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             l-limpa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME}     = NO  
             l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME}   = NO.
  END.
  ELSE DO:
      ASSIGN l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                    WHEN INPUT FRAME {&FRAME-NAME} rs-situacao <> 2 AND 
                                         INPUT FRAME {&FRAME-NAME} rs-situacao <> 3 AND 
                                         INPUT FRAME {&FRAME-NAME} rs-situacao <> 7
             l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                    WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-informa-chave-acesso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-informa-chave-acesso wWin
ON VALUE-CHANGED OF l-informa-chave-acesso IN FRAME fMain /* Informar chave de acesso manualmente */
DO:
  IF l-informa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
      ASSIGN l-gerar-nova-chave:CHECKED IN FRAME {&FRAME-NAME}     = NO
             l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}   = NO
             l-limpa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME}   = NO  
             l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ASSIGN l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1 OR 
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 2 OR 
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 3 OR
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 5
             l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                  WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-limpa-chave-acesso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-limpa-chave-acesso wWin
ON VALUE-CHANGED OF l-limpa-chave-acesso IN FRAME fMain /* Limpar chave de acesso */
DO:
  IF l-limpa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
      ASSIGN l-gerar-nova-chave:CHECKED IN FRAME {&FRAME-NAME}       = NO
             l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}     = NO
             l-informa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME}   = NO  
             l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ASSIGN l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1 OR 
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 2 OR 
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 3 OR
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 5
             l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                                    WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1 OR 
                                         INPUT FRAME {&FRAME-NAME} rs-situacao = 4 OR 
                                         INPUT FRAME {&FRAME-NAME} rs-situacao = 5.
  END.
END.

/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME


&Scoped-define SELF-NAME l-acerta-dt-emis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-acerta-dt-emis wWin
ON VALUE-CHANGED OF l-acerta-dt-emis IN FRAME fMain /* Gerar nova chave de acesso */
DO:
  IF l-acerta-dt-emis:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
      ASSIGN l-acerta-dt-cancel:CHECKED IN FRAME {&FRAME-NAME}   = NO
             l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ASSIGN l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1.

  END.
END.

/* _UIB-CODE-BLOCK-END */


&ANALYZE-RESUME


&Scoped-define SELF-NAME l-acerta-dt-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-acerta-dt-cancel wWin
ON VALUE-CHANGED OF l-acerta-dt-cancel IN FRAME fMain /* Gerar nova chave de acesso */
DO:
  IF l-acerta-dt-cancel:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
      ASSIGN l-acerta-dt-emis:CHECKED IN FRAME {&FRAME-NAME}   = NO
             l-acerta-dt-emis:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ASSIGN l-acerta-dt-emis:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
                                WHEN INPUT FRAME {&FRAME-NAME} rs-situacao = 1 OR 
                                     INPUT FRAME {&FRAME-NAME} rs-situacao = 5.

  END.
END.

/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-situacao wWin
ON VALUE-CHANGED OF rs-situacao IN FRAME fMain
DO:
  /* Desativa todos */
  ASSIGN l-gerar-nova-chave:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-protocolo:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-informa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-limpa-chave-acesso:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-acerta-dt-emis:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-acerta-dt-emis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-acerta-tp-emis:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-acerta-tp-emis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-acerta-dt-cancel:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-dados-emis-man:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-dados-emis-man:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         l-elimina-cce:CHECKED IN FRAME {&FRAME-NAME} = NO
         l-elimina-cce:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF INPUT FRAME {&FRAME-NAME} rs-situacao = 1 THEN DO: /* Acerto Gerais */
      ASSIGN l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             l-limpa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
             l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}     = YES
             l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME}            = YES
             l-acerta-dt-emis:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
             l-acerta-tp-emis:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
             l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME}     = YES
             l-dados-emis-man:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
             l-elimina-cce:SENSITIVE IN FRAME {&FRAME-NAME}          = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 2 THEN DO: /* NF-e n∆o Gerada */
      ASSIGN l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 3 THEN DO: /* NF-e Gerada */
      ASSIGN l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 4 THEN DO: /* Uso Autorizado */
      ASSIGN l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME}            = YES
             l-acerta-tp-emis:SENSITIVE IN FRAME {&FRAME-NAME}       = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 5 THEN DO: /* Documento Rejeitado */
      ASSIGN l-gerar-nova-chave:SENSITIVE IN FRAME {&FRAME-NAME}     = YES
             l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             l-acerta-tp-emis:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
             l-acerta-dt-emis:SENSITIVE IN FRAME {&FRAME-NAME}       = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 6 THEN DO: /* Documento Cancelado */
      ASSIGN l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME}            = YES
             l-informa-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 7 THEN DO: /* Documento Inutilizado */
      ASSIGN l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME}            = YES
             l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.
  END.
  ELSE IF INPUT FRAME {&FRAME-NAME} rs-situacao = 12 THEN DO: /* Uso Denegado */
      ASSIGN l-protocolo:SENSITIVE IN FRAME {&FRAME-NAME}            = YES
             l-acerta-dt-cancel:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY l-gerar-nova-chave rs-situacao l-limpa-chave-acesso 
          l-informa-chave-acesso l-protocolo l-acerta-dt-emis 
          l-acerta-tp-emis l-acerta-dt-cancel l-dados-emis-man
          l-elimina-cce dt-validade c-chave EDITOR-1 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE l-gerar-nova-chave rs-situacao l-limpa-chave-acesso 
         l-informa-chave-acesso l-protocolo l-acerta-dt-emis 
         l-acerta-tp-emis l-acerta-dt-cancel l-dados-emis-man 
         l-elimina-cce dt-validade bt-gerar c-chave EDITOR-1 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  APPLY "value-changed" to rs-situacao in frame {&frame-name}.

  ASSIGN dt-validade = TODAY + 3.

  IF WEEKDAY(dt-validade) = 7 THEN 
      ASSIGN dt-validade = dt-validade + 1.
  IF WEEKDAY(dt-validade) = 1 THEN 
      ASSIGN dt-validade = dt-validade + 1.

  ASSIGN dt-validade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dt-validade). 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gerar wWin 
PROCEDURE pi-gerar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-texto-cliente       AS CHARACTER FORMAT "x(10000)"  NO-UNDO.
    DEFINE VARIABLE c-rs-situacao-aux     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-rs-situacao-termo   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-first-parafrago-txt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-complem-txt         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-complem-txt2        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-txt-acao-informada  AS CHARACTER  NO-UNDO.

    ASSIGN c-param = ""
           c-chave = ""
           c-texto-cliente = ""
           c-complem-txt = ""
           c-complem-txt2 = ""
           c-chave-secreta = ?.

    IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "1" THEN
        ASSIGN c-rs-situacao-aux = "acerto chave de acesso".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "2" THEN 
        ASSIGN c-rs-situacao-aux = "NF-e n∆o gerada".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "3" THEN
        ASSIGN c-rs-situacao-aux = "NF-e gerada".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "4" THEN
       ASSIGN c-rs-situacao-aux   = "uso autorizado"
              c-rs-situacao-termo = "autorizaá∆o".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "5" THEN
       ASSIGN c-rs-situacao-aux = "documento rejeitado".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "6" THEN
       ASSIGN c-rs-situacao-aux   = "documento cancelado"
              c-rs-situacao-termo = "cancelamento".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "7" THEN
       ASSIGN c-rs-situacao-aux   = "documento inutilizado"
              c-rs-situacao-termo = "inutilizaá∆o".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "8" THEN
       ASSIGN c-rs-situacao-aux = "em processamento no aplicativo de transmiss∆o".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "9" THEN
       ASSIGN c-rs-situacao-aux = "em processamento no EAI".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "10" THEN
       ASSIGN c-rs-situacao-aux = "NF-e em processamento de cancelamento".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "11" THEN
       ASSIGN c-rs-situacao-aux = "NF-e em processamento de inutilizaá∆o".
    ELSE IF rs-situacao:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "12" THEN
       ASSIGN c-rs-situacao-aux   = "uso denegado"
              c-rs-situacao-termo = "denegaá∆o".

    ASSIGN c-param = STRING(dt-validade:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           c-param = c-param + STRING(INTEGER(INPUT FRAME {&FRAME-NAME} rs-situacao),"99").

    IF INPUT FRAME {&FRAME-NAME} l-gerar-nova-chave THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-limpa-chave-acesso THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".  

    IF INPUT FRAME {&FRAME-NAME} l-informa-chave-acesso THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-protocolo THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-acerta-dt-emis THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-acerta-tp-emis THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-acerta-dt-cancel THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-dados-emis-man THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    IF INPUT FRAME {&FRAME-NAME} l-elimina-cce THEN
        ASSIGN c-param = c-param + "Y".
    ELSE
        ASSIGN c-param = c-param + "N".

    ASSIGN c-chave-secreta = HEX-ENCODE(ENCRYPT(c-param,GENERATE-PBE-KEY("bXJlYWN0"))).   
    
    ASSIGN c-chave:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(c-chave-secreta)
           c-chave = STRING(c-chave-secreta).

    ASSIGN c-texto-cliente = 
    "Prezado cliente. " + CHR(13) 
    + CHR(13).

    IF rs-situacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" THEN
        ASSIGN c-first-parafrago-txt = "Ser† necess†rio executar um programa de acerto para corrigir a situaá∆o encontrada.".  
    ELSE 
        ASSIGN c-first-parafrago-txt = "Ser† necess†rio executar um programa de acerto para alterar a situaá∆o da nota fiscal eletrìnica para " + string(c-rs-situacao-aux) + ".".
    
    ASSIGN c-complem-txt = "".
    IF INPUT FRAME {&FRAME-NAME} l-informa-chave-acesso THEN
        ASSIGN c-complem-txt = c-complem-txt + CHR(13) + "No campo " + CHR(34) + "Chave de Acesso" + CHR(34) + ", informar a nova chave de acesso para o documento.". 
    IF INPUT FRAME {&FRAME-NAME} l-protocolo THEN
        ASSIGN c-complem-txt = c-complem-txt + CHR(13) + "No campo " + CHR(34) + "Protocolo" + CHR(34) + ", informar o protocolo de " + string(c-rs-situacao-termo) + ".".  
    ASSIGN c-complem-txt2 = "".
    
    ASSIGN c-texto-cliente = c-texto-cliente + c-first-parafrago-txt + CHR(13) +
    "Para executar esse programa no EMS, no menu, ir em Opá‰es -> Executar Programa." + CHR(13) +
    "Digitar: spp\rep\spre100.r" + CHR(13) +
    "Clicar em OK." + CHR(13) + 
    CHR(13) +
    "No campo "  + CHR(34) + "C¢digo de Seguranáa"  + CHR(34) + " informar o seguinte c¢digo:" + CHR(13) + TRIM(STRING(c-chave:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + CHR(13) + 
    "Clicar no bot∆o " + CHR(34) + "Verificar C¢digo"  + CHR(34) + ". Com isso ser∆o habilitados os campos para informar os dados do documento." +
    c-complem-txt + CHR(13) + "Clicar no bot∆o " + CHR(34) + "Executar" + CHR(34) + " para iniciar a correá∆o." + CHR(13) +
    "No final da execuá∆o ser† aberto um relat¢rio da execuá∆o (arquivo txt)."  + CHR(13) + "Favor salvar esse relat¢rio e nos encaminhar para nossa an†lise." + 
    c-complem-txt2 + CHR(13) + CHR(13) +
    "OBS: O c¢digo de seguranáa Ç " + CHR(34) + "case-sensitive" + CHR(34) + ", ou seja, faz diferenáa entra letras em mai£sculas e min£sculas." + CHR(13) +
    "Sugerimos que o c¢digo seja copiado desse texto e colado diretamente no campo "  + CHR(34) + "C¢digo de Seguranáa"  + CHR(34) + " do programa." + CHR(13) + 
    "Caso haja alguma d£vida nesse procedimento, favor solicitar apoio da †rea de inform†tica da sua empresa."  + CHR(13) + CHR(13) +
    "Ficamos no aguardo do relat¢rio da execuá∆o.".

    ASSIGN EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-texto-cliente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


