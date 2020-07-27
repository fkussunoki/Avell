&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i DOC025C 1.00.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

{include/i-frm055.i}
/* Local Variable Definitions ---                                       */
DEF VAR i-cont AS INT.
DEF VAR i-mercado AS INT.
DEF VAR c-mercado AS CHAR.
DEF VAR i-seq AS INT.
DEF VAR l-tipo AS LOG INIT YES.

DEF VAR c-equipto AS CHAR FORMAT "x(20)" COLUMN-LABEL "Equipto".
DEF VAR c-tecnol  AS CHAR FORMAT "x(20)" COLUMN-LABEL "Tecnologia".
DEF VAR c-capacid AS CHAR FORMAT "x(15)" COLUMN-LABEL "Capacidade".
DEF VAR c-descricao AS CHAR FORMAT "x(50)" COLUMN-LABEL "Descri‡Æo".

&Scoped-define table-parent dc-orc-grupo

/* insira a seguir a defini‡Æo da temp-table */
DEF TEMP-TABLE tt-origem NO-UNDO
    FIELD cod-grupo      LIKE dc-orc-grupo-usuar.cod-grupo
    FIELD cod_usuario    LIKE dc-orc-grupo-usuar.cod_usuario
    FIELD nom_usuario    LIKE usuar_mestre.nom_usuario
    INDEX ch-prim IS PRIMARY 
    cod-grupo  
    cod_usuario.
    

DEF TEMP-TABLE tt-destino NO-UNDO
    FIELD cod-grupo      LIKE dc-orc-grupo-usuar.cod-grupo
    FIELD cod_usuario    LIKE dc-orc-grupo-usuar.cod_usuario
    FIELD nom_usuario    LIKE usuar_mestre.nom_usuario
    INDEX ch-prim IS PRIMARY 
    cod-grupo  
    cod_usuario.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-form2
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-formation
&Scoped-define BROWSE-NAME br-source-browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-origem tt-destino

/* Definitions for BROWSE br-source-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-source-browse tt-origem.cod_usuario tt-origem.nom_usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-source-browse   
&Scoped-define SELF-NAME br-source-browse
&Scoped-define QUERY-STRING-br-source-browse FOR EACH tt-origem         WHERE tt-origem.cod_usuario BEGINS c-cod-usuar-orig         OR    tt-origem.nom_usuario BEGINS c-cod-usuar-orig
&Scoped-define OPEN-QUERY-br-source-browse OPEN QUERY {&SELF-NAME}     FOR EACH tt-origem         WHERE tt-origem.cod_usuario BEGINS c-cod-usuar-orig         OR    tt-origem.nom_usuario BEGINS c-cod-usuar-orig.
&Scoped-define TABLES-IN-QUERY-br-source-browse tt-origem
&Scoped-define FIRST-TABLE-IN-QUERY-br-source-browse tt-origem


/* Definitions for BROWSE br-target-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-target-browse tt-destino.cod_usuario tt-destino.nom_usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-target-browse   
&Scoped-define SELF-NAME br-target-browse
&Scoped-define QUERY-STRING-br-target-browse FOR EACH tt-destino
&Scoped-define OPEN-QUERY-br-target-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-destino .
&Scoped-define TABLES-IN-QUERY-br-target-browse tt-destino
&Scoped-define FIRST-TABLE-IN-QUERY-br-target-browse tt-destino


/* Definitions for FRAME f-formation                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-formation ~
    ~{&OPEN-QUERY-br-source-browse}~
    ~{&OPEN-QUERY-br-target-browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key-parent c-cod-usuar-orig ~
bt-ver-origem br-source-browse br-target-browse bt-add bt-del bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS dc-orc-grupo.cod-grupo ~
dc-orc-grupo.descricao 
&Scoped-define DISPLAYED-TABLES dc-orc-grupo
&Scoped-define FIRST-DISPLAYED-TABLE dc-orc-grupo
&Scoped-Define DISPLAYED-OBJECTS c-cod-usuar-orig 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-create-allowed w-window 
FUNCTION is-create-allowed RETURNS LOGICAL
  ( v-row-tt as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-delete-allowed w-window 
FUNCTION is-delete-allowed RETURNS LOGICAL
  ( v-row-target as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image/im-nex.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/im-pre.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Gravar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ver-origem 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.13.

DEFINE VARIABLE c-cod-usuar-orig AS CHARACTER FORMAT "X(12)" 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key-parent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 1.67.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-source-browse FOR 
      tt-origem SCROLLING.

DEFINE QUERY br-target-browse FOR 
      tt-destino SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-source-browse w-window _FREEFORM
  QUERY br-source-browse NO-LOCK DISPLAY
      tt-origem.cod_usuario  
      tt-origem.nom_usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54.43 BY 13
         FONT 4.

DEFINE BROWSE br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-target-browse w-window _FREEFORM
  QUERY br-target-browse DISPLAY
      tt-destino.cod_usuario  
      tt-destino.nom_usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 13
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-formation
     dc-orc-grupo.cod-grupo AT ROW 1.38 COL 22.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     dc-orc-grupo.descricao AT ROW 1.38 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 62 BY .88
     c-cod-usuar-orig AT ROW 2.88 COL 6 COLON-ALIGNED
     bt-ver-origem AT ROW 2.88 COL 32
     br-source-browse AT ROW 4 COL 2
     br-target-browse AT ROW 4 COL 62
     bt-add AT ROW 7.5 COL 56.57
     bt-del AT ROW 11.25 COL 56.72
     bt-ok AT ROW 17.71 COL 3
     bt-cancela AT ROW 17.71 COL 13.72
     bt-ajuda AT ROW 17.75 COL 104.86
     RECT-1 AT ROW 17.5 COL 2
     rt-key-parent AT ROW 1.04 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115.43 BY 18.21
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-form2
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Formar <insert Custom SmartWindow title>"
         HEIGHT             = 17.96
         WIDTH              = 115.29
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FRAME f-formation
   FRAME-NAME                                                           */
/* BROWSE-TAB br-source-browse bt-ver-origem f-formation */
/* BROWSE-TAB br-target-browse br-source-browse f-formation */
/* SETTINGS FOR FILL-IN dc-orc-grupo.cod-grupo IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dc-orc-grupo.descricao IN FRAME f-formation
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-source-browse
/* Query rebuild information for BROWSE br-source-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-origem
        WHERE tt-origem.cod_usuario BEGINS c-cod-usuar-orig
        OR    tt-origem.nom_usuario BEGINS c-cod-usuar-orig.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, USED, USED"
     _OrdList          = "mgcad.item.desc-item|yes"
     _Where[1]         = "(emsdocol.sim-item.mercado = i-mercado
 OR emsdocol.sim-item.mercado = 3) 
"
     _Query            is OPENED
*/  /* BROWSE br-source-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-target-browse
/* Query rebuild information for BROWSE br-target-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-destino .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-target-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-formation
/* Query rebuild information for FRAME f-formation
     _Query            is NOT OPENED
*/  /* FRAME f-formation */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Formar <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Formar <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-source-browse
&Scoped-define SELF-NAME br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-source-browse w-window
ON VALUE-CHANGED OF br-source-browse IN FRAME f-formation
DO:
  {include/i-frm020.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-target-browse
&Scoped-define SELF-NAME br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-target-browse w-window
ON VALUE-CHANGED OF br-target-browse IN FRAME f-formation
DO:
  {include/i-frm010.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-window
ON CHOOSE OF bt-add IN FRAME f-formation
DO:
   run pi-ins.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME f-formation /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-window
ON CHOOSE OF bt-cancela IN FRAME f-formation /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-window
ON CHOOSE OF bt-del IN FRAME f-formation
DO:
   run pi-del.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME f-formation /* Gravar */
DO:
  RUN dop/message2.p ("Confirma a movimenta‡Æo?","").
  IF RETURN-VALUE = "yes" THEN  DO:
       run pi-commit.
       run dispatch in wh-browse (input 'open-query':U).
  END.
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ver-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ver-origem w-window
ON CHOOSE OF bt-ver-origem IN FRAME f-formation /* Button 1 */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-cod-usuar-orig.
    {&OPEN-QUERY-br-source-browse}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-source-browse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

{include/i-frm040.i}
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
  DISPLAY c-cod-usuar-orig 
      WITH FRAME f-formation IN WINDOW w-window.
  IF AVAILABLE dc-orc-grupo THEN 
    DISPLAY dc-orc-grupo.cod-grupo dc-orc-grupo.descricao 
      WITH FRAME f-formation IN WINDOW w-window.
  ENABLE RECT-1 rt-key-parent c-cod-usuar-orig bt-ver-origem br-source-browse 
         br-target-browse bt-add bt-del bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-formation IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-f-formation}
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

    
  

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-show-master-record.
  {include/win-size.i}
  

  FOR EACH tt-origem:
    DELETE tt-origem.
  END.

  FOR EACH tt-destino:
    DELETE tt-destino.
  END.

  FIND FIRST dc-orc-grupo NO-LOCK
       WHERE ROWID(dc-orc-grupo) = v-row-parent NO-ERROR.
  IF AVAIL dc-orc-grupo THEN DO:
      
      FOR EACH usuar_mestre
          WHERE usuar_mestre.cod_usuario > '9':
          IF NOT CAN-FIND(dc-orc-grupo-usuar WHERE
                          dc-orc-grupo-usuar.cod-grupo   = dc-orc-grupo.cod-grupo AND
                          dc-orc-grupo-usuar.cod_usuario = usuar_mestre.cod_usuario) THEN DO:
              CREATE tt-origem.
              ASSIGN tt-origem.cod-grupo      = dc-orc-grupo.cod-grupo
                     tt-origem.cod_usuario    = usuar_mestre.cod_usuario
                     tt-origem.nom_usuario    = usuar_mestre.nom_usuario.
          END.
      END.
      
      FOR EACH dc-orc-grupo-usuar 
         WHERE dc-orc-grupo-usuar.cod-grupo = dc-orc-grupo.cod-grupo:

          FIND FIRST usuar_mestre NO-LOCK
               WHERE usuar_mestre.cod_usuario    = dc-orc-grupo-usuar.cod_usuario NO-ERROR.

          CREATE tt-destino.
          ASSIGN tt-destino.cod-grupo      = dc-orc-grupo-usuar.cod-grupo
                 tt-destino.cod_usuario    = dc-orc-grupo-usuar.cod_usuario
                 tt-destino.nom_usuario    = usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre.                
      END.
  END.
  
  
  OPEN QUERY br-source-browse FOR EACH tt-origem.
  OPEN QUERY br-target-browse FOR EACH tt-destino.

    
  /* Dispatch standard ADM method.                             */  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-to-target w-window 
PROCEDURE pi-add-to-target :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter v-row-select-in-source as rowid no-undo. 
   
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm190.i}

   /* rowid da tabela que possui um registro selecionado no browse de origem */
   /*
   find tt-primeira-tabela-browse-origem pelo rowid
   if available primeira-tabela-browse-origem  then do:
      find tabela-pai pelo rowid( v-row-parent )
      create primeira-tt-tabela-browse-destino
      assign campos primeira-tt-tabela-browse-destino
   end. 
   */
   FIND tt-origem WHERE ROWID(tt-origem) = v-row-select-in-source.
   
   IF AVAILABLE tt-origem THEN DO:
       
       CREATE tt-destino.
       ASSIGN tt-destino.cod-grupo   = INPUT FRAME {&FRAME-NAME} dc-orc-grupo.cod-grupo     
              tt-destino.cod_usuario = tt-origem.cod_usuario
              tt-destino.nom_usuario = tt-origem.nom_usuario.
       DELETE tt-origem.
       
   END.
   /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  OPEN QUERY br-source-browse FOR EACH tt-origem.
  {include/i-frm195.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-commit w-window 
PROCEDURE pi-commit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO ON ERROR UNDO, RETRY:

    FOR EACH dc-orc-grupo-usuar EXCLUSIVE-LOCK
       WHERE dc-orc-grupo-usuar.cod-grupo = INPUT FRAME {&FRAME-NAME} dc-orc-grupo.cod-grupo:

        FIND FIRST tt-destino WHERE tt-destino.cod-grupo   = dc-orc-grupo-usuar.cod-grupo
                                AND tt-destino.cod_usuario = dc-orc-grupo-usuar.cod_usuario NO-ERROR.
        IF NOT AVAIL tt-destino THEN
            DELETE dc-orc-grupo-usuar.

    END.

    FOR EACH tt-destino:
        FIND FIRST dc-orc-grupo-usuar EXCLUSIVE-LOCK
             WHERE dc-orc-grupo-usuar.cod-grupo   = tt-destino.cod-grupo     
               AND dc-orc-grupo-usuar.cod_usuario = tt-destino.cod_usuario NO-ERROR.
        IF NOT AVAIL dc-orc-grupo-usuar THEN DO:
            CREATE dc-orc-grupo-usuar.
            ASSIGN dc-orc-grupo-usuar.cod-grupo   = tt-destino.cod-grupo     
                   dc-orc-grupo-usuar.cod_usuario = tt-destino.cod_usuario.
        END.
    END.
END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-del w-window 
PROCEDURE pi-del :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm167.i}
  
   /* Caso o include a seguir nao atenda suas necessidades, apague-o  e crie sua propria
  logica usando-o como modelo. 
  */   
   {include/i-frm170.i}
 
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm175.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-from-target w-window 
PROCEDURE pi-delete-from-target :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER v-row-target-browse AS ROWID NO-UNDO.
   
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm180.i}
   
   FIND tt-destino WHERE ROWID( tt-destino ) = v-row-target-browse EXCLUSIVE-LOCK NO-ERROR.
   if AVAILABLE tt-destino THEN DO:
       CREATE tt-origem.
       ASSIGN tt-origem.cod-grupo    = tt-destino.cod-grupo     
              tt-origem.cod_usuario  = tt-destino.cod_usuario
              tt-origem.nom_usuario  = tt-destino.nom_usuario.

       DELETE tt-destino.     

   END.
      
    

/*
  FIND tt-item WHERE ROWID(tt-item) = v-row-target-browse EXCLUSIVE-lock NO-ERROR.
  IF AVAIL tt-item THEN
     DELETE tt-item.
  */ 
   
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm185.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ins w-window 
PROCEDURE pi-ins :
/*------------------------------------------------------------------------------
  Purpose   : Incluir no browse destiono o registro selecionado no browse origem     
  Parameters: 
------------------------------------------------------------------------------*/
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */

  {include/i-frm157.i}

  /* Caso o include a seguir nao atenda suas necessidades, apague-o  e crie sua propria
  logica usando-o como modelo. 
  */   
  
 
/*   {include/i-frm160.i} */
   define var v-num-row-a  as integer no-undo.
   define var v-log-method as logical no-undo.
   
   do v-num-row-a = 1 to browse br-source-browse:num-selected-rows :
       assign v-log-method = browse br-source-browse:fetch-selected-row(v-num-row-a).
       
       if  is-create-allowed( rowid( {&FIRST-TABLE-IN-QUERY-br-source-browse}) ) then do:
           run pi-add-to-target( rowid( {&FIRST-TABLE-IN-QUERY-br-source-browse})  ).
           IF BROWSE br-source-browse:NUM-SELECTED-ROWS <> 0 THEN
               assign v-log-method = browse br-source-browse:deselect-selected-row(v-num-row-a)
                      v-num-row-a  = v-num-row-a - 1.
       end.
   end.
   /*{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}*/
   {&OPEN-QUERY-br-target-browse}


  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm165.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-browse w-window 
PROCEDURE pi-monta-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-origem:
        DELETE tt-origem.
    END.
    
    FOR EACH usuar_mestre
        WHERE usuar_mestre.cod_usuario > '9':
        /*IF c-cod-usuar-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND
           NOT usuar_mestre.cod_usuario BEGINS c-cod-usuar-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN NEXT.*/

        FIND FIRST tt-destino WHERE 
                   tt-destino.cod-grupo   = INPUT FRAME {&FRAME-NAME} dc-orc-grupo.cod-grupo AND
                   tt-destino.cod_usuario = usuar_mestre.cod_usuario NO-ERROR.
        IF NOT AVAIL tt-destino THEN DO:
            CREATE tt-origem.
            ASSIGN tt-origem.cod-grupo   = INPUT FRAME {&FRAME-NAME} dc-orc-grupo.cod-grupo
                   tt-origem.cod_usuario = usuar_mestre.cod_usuario
                   tt-origem.nom_usuario = usuar_mestre.nom_usuario.
        END.                            
    END.
    
    OPEN QUERY br-source-browse FOR EACH tt-origem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-show-master-record w-window 
PROCEDURE pi-show-master-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */

  {include/i-frm145.i}

  /* Lógica padrão para apresentação do registro da tabela pai caso esta lógica atenda 
     as suas necessidades chame o include a seguir no corpo da procedure (retire-o de
     dentro do comentário). Em caso contrário crie sua própria lógica usando a 
     do include como modelo.
  */   

  
  {include/i-frm150.i}
  
  
  {include/i-frm155.i}

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-destino"}
  {src/adm/template/snd-list.i "tt-origem"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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
  
  if p-state = "apply-entry":u then
     apply "entry":u to bt-ok in frame {&frame-name}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-create-allowed w-window 
FUNCTION is-create-allowed RETURNS LOGICAL
  ( v-row-tt as rowid) : /*:T rowid do registro selecionado no origem */
/*:T------------------------------------------------------------------------------
  Purpose:  Insira aqui a l¢gica que deve verificar se o registro corrente pode ou
            nÆo ser incluido no browse de destino
    Notes:  
------------------------------------------------------------------------------*/

  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-delete-allowed w-window 
FUNCTION is-delete-allowed RETURNS LOGICAL
  ( v-row-target as rowid) : /* rowid do registro selecionado no destino */
/*------------------------------------------------------------------------------
  Purpose:  Insira aqui a l¢gica que deve verificar se o registro corrente pode ou
            nÆo ser eliminado do browse de destino
    Notes:  
------------------------------------------------------------------------------*/

  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

