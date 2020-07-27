&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
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
{include/i-prgvrs.i BDG1001 1.00.00.000}

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

/* {include/i-frm055.i}                                                       */
/* /* Local Variable Definitions ---                                       */ */
/*                                                                            */
/* &Scoped-define table-parent orcto_ctbl_bgc.                                */

DEFINE TEMP-TABLE TT-usuar_mestre
    FIELD cod_usuario   AS CHAR FORMAT "X(16)"
    FIELD nom_usuario   AS char FORMAT "X(40)"
    FIELD L-SELECIONADO AS LOGICAL
    FIELD nivel_usuario  AS char
    .


DEFINE TEMP-TABLE tt-usuario 
    FIELD cod_usuario AS CHAR FORMAT "X(16)"
    FIELD nom_usuario AS CHAR FORMAT "X(40)".


DEFINE TEMP-TABLE tt-nivel-usuario LIKE usuar_niv_usuar.

/* insira a seguir a defini‡Æo da temp-table */


DEF INPUT param r-record AS ROWID.
/*                                    */
def var v_num_row_a
    as integer
    format ">>>,>>9"
    no-undo.

def var v_log_method
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.

def var v_log_atualiz_gerdoc as logical no-undo.

DEF VAR v_rec_table AS recid.
DEFINE VAR cod_usuario AS char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-formation
&Scoped-define BROWSE-NAME br-source-browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-usuario tt-usuar_mestre

/* Definitions for BROWSE br-source-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-source-browse tt-usuario.cod_usuario tt-usuario.nom_usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-source-browse   
&Scoped-define SELF-NAME br-source-browse
&Scoped-define QUERY-STRING-br-source-browse FOR EACH tt-usuario
&Scoped-define OPEN-QUERY-br-source-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-usuario                                             .
&Scoped-define TABLES-IN-QUERY-br-source-browse tt-usuario
&Scoped-define FIRST-TABLE-IN-QUERY-br-source-browse tt-usuario


/* Definitions for BROWSE br-target-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-target-browse tt-usuar_mestre.cod_usuario tt-usuar_mestre.nivel_usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-target-browse   
&Scoped-define SELF-NAME br-target-browse
&Scoped-define QUERY-STRING-br-target-browse FOR EACH tt-usuar_mestre WHERE  tt-usuar_mestre.nivel_usuario = cod_usuario                              NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-target-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-usuar_mestre WHERE  tt-usuar_mestre.nivel_usuario = cod_usuario                              NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-target-browse tt-usuar_mestre
&Scoped-define FIRST-TABLE-IN-QUERY-br-target-browse tt-usuar_mestre


/* Definitions for FRAME f-formation                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-formation ~
    ~{&OPEN-QUERY-br-source-browse}~
    ~{&OPEN-QUERY-br-target-browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ext_lim_justif.cod_niv_usuario 
&Scoped-define ENABLED-TABLES ext_lim_justif
&Scoped-define FIRST-ENABLED-TABLE ext_lim_justif
&Scoped-Define ENABLED-OBJECTS rt-key-parent rt-source-browse ~
rt-source-browse-2 RECT-1 RECT-2 br-source-browse br-target-browse bt-add ~
bt-del bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS ext_lim_justif.cod_niv_usuario 
&Scoped-define DISPLAYED-TABLES ext_lim_justif
&Scoped-define FIRST-DISPLAYED-TABLE ext_lim_justif


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
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "" 
     SIZE 7 BY 1.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "" 
     SIZE 7 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rt-key-parent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 1.67.

DEFINE RECTANGLE rt-source-browse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 8.25.

DEFINE RECTANGLE rt-source-browse-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 8.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-source-browse FOR 
      tt-usuario SCROLLING.

DEFINE QUERY br-target-browse FOR 
      tt-usuar_mestre SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-source-browse w-window _FREEFORM
  QUERY br-source-browse DISPLAY
      tt-usuario.cod_usuario
    tt-usuario.nom_usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36.43 BY 7.5.

DEFINE BROWSE br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-target-browse w-window _FREEFORM
  QUERY br-target-browse DISPLAY
      tt-usuar_mestre.cod_usuario
     tt-usuar_mestre.nivel_usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36.43 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-formation
     ext_lim_justif.cod_niv_usuario AT ROW 1.75 COL 15.43 COLON-ALIGNED WIDGET-ID 36
          LABEL "Nivel Usuario"
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     br-source-browse AT ROW 5.33 COL 2.86
     br-target-browse AT ROW 5.33 COL 52 WIDGET-ID 200
     bt-add AT ROW 7.29 COL 42 WIDGET-ID 12
     bt-del AT ROW 8.92 COL 42 WIDGET-ID 16
     bt-ok AT ROW 13.63 COL 2.86
     bt-cancela AT ROW 13.63 COL 13.86
     bt-ajuda AT ROW 13.63 COL 78
     rt-key-parent AT ROW 1.42 COL 1.86
     rt-source-browse AT ROW 4.83 COL 1.86
     rt-source-browse-2 AT ROW 4.83 COL 51
     RECT-1 AT ROW 13.42 COL 1.86
     RECT-2 AT ROW 3.17 COL 1.86 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.33 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Formar Or‡amentos"
         HEIGHT             = 14.38
         WIDTH              = 89.86
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB br-source-browse cod_niv_usuario f-formation */
/* BROWSE-TAB br-target-browse br-source-browse f-formation */
/* SETTINGS FOR FILL-IN ext_lim_justif.cod_niv_usuario IN FRAME f-formation
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-source-browse
/* Query rebuild information for BROWSE br-source-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-usuario
                                            .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-source-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-target-browse
/* Query rebuild information for BROWSE br-target-browse
     _START_FREEFORM


OPEN QUERY {&SELF-NAME} FOR EACH tt-usuar_mestre WHERE  tt-usuar_mestre.nivel_usuario = cod_usuario

                            NO-LOCK INDEXED-REPOSITION.
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
ON END-ERROR OF w-window /* Formar Or‡amentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Formar Or‡amentos */
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
RUN pi-ins.

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
ON CHOOSE OF bt-cancela IN FRAME f-formation /* Fechar */
DO:
  apply "close":U to this-procedure.
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
ON CHOOSE OF bt-ok IN FRAME f-formation /* OK */
DO:
  run pi-commit.
  

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
  IF AVAILABLE ext_lim_justif THEN 
    DISPLAY ext_lim_justif.cod_niv_usuario 
      WITH FRAME f-formation IN WINDOW w-window.
  ENABLE rt-key-parent rt-source-browse rt-source-browse-2 RECT-1 RECT-2 
         ext_lim_justif.cod_niv_usuario br-source-browse br-target-browse 
         bt-add bt-del bt-ok bt-cancela bt-ajuda 
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
  {include/win-size.i}
  
  {utp/ut9000.i "MGLA1203aa" "1.00.00.000"}


  run pi-show-master-record.

  FOR EACH usuar_mestre BREAK BY usuar_mestre.cod_usuario:
    CREATE tt-usuario.
    ASSIGN tt-usuario.cod_usuario = usuar_mestre.cod_usuario
           tt-usuario.nom_usuario = usuar_mestre.nom_usuario.

END.


  FIND FIRST ext_lim_justif NO-LOCK WHERE ROWID(ext_lim_justif) =  r-record NO-ERROR.

ASSIGN cod_usuario = ext_lim_justif.cod_niv_usuario.

  /* Dispatch standard ADM method.                             */  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  FOR EACH usuar_niv_usuar NO-LOCK WHERE usuar_niv_usuar.cod_niv_usuar = ext_lim_justif.cod_niv_usuario:

      FIND FIRST tt-nivel-usuario WHERE tt-nivel-usuario.cod_niv_usuar = ext_lim_justif.cod_niv_usuario
                                  AND   tt-nivel-usuario.cod_usuar   = usuar_niv_usuar.cod_usuar NO-ERROR.

      IF NOT AVAIL tt-nivel-usuario THEN DO:
          
            CREATE tt-nivel-usuario.
            ASSIGN tt-nivel-usuario.cod_niv_usuar = ext_lim_justif.cod_niv_usuario
                   tt-nivel-usuario.cod_usuar     = usuar_niv_usuar.cod_usuar.
                



      END.


  
  END.


  FOR EACH usuar_niv_usuar:


      FIND FIRST tt-usuar_mestre WHERE tt-usuar_mestre.cod_usuario      = usuar_niv_usuar.cod_usuar
                                 and   tt-usuar_mestre.L-SELECIONADO    = YES
                                 and   tt-usuar_mestre.nivel_usuario    = usuar_niv_usuar.cod_niv_usuar NO-ERROR.

      IF NOT avail tt-usuar_mestre THEN DO:

          CREATE tt-usuar_mestre.
          ASSIGN tt-usuar_mestre.cod_usuario = usuar_niv_usuar.cod_usuar
                 tt-usuar_mestre.l-selecionado = YES
                 tt-usuar_mestre.nivel_usuario = usuar_niv_usuar.cod_niv_usuar.
      END.






  END.

  /* Code placed here will execute AFTER standard behavior.    */

  if avail ext_lim_justif THEN DO:
      
    disp ext_lim_justif.cod_niv_usuario
         WITH frame {&frame-name}.
 

END.


OPEN QUERY br-target-browse FOR EACH tt-usuar_mestre WHERE tt-usuar_mestre.nivel_usuario = cod_usuario
                                                     
                            NO-LOCK INDEXED-REPOSITION.

 

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
   
/*    find tt-entidades where rowid(tt-entidades) = v-row-select-in-source no-lock no-error.  */
/*    if  available tt-entidades then do:                                                     */
/*        assign tt-entidades.l-selecionado = yes.                                            */
/*    end.                                                                                    */
/*                                                                                            */
   /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm195.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-commit w-window 
PROCEDURE pi-commit :
FOR EACH tt-usuar_mestre:



                FIND FIRST usuar_niv_usuar       WHERE usuar_niv_usuar.cod_usuar = tt-usuar_mestre.cod_usuario
                                                  AND  usuar_niv_usuar.cod_niv_usuar = tt-usuar_mestre.nivel_usuario
                                                  NO-ERROR.


                IF NOT AVAIL usuar_niv_usuar THEN DO:
                    
                    CREATE usuar_niv_usuar.
                    ASSIGN usuar_niv_usuar.cod_usuar                           =   tt-usuar_mestre.cod_usuario                                         
                           usuar_niv_usuar.cod_niv_usuar                       =   tt-usuar_mestre.nivel_usuario                                   
.                                 


                END.

                ASSIGN usuar_niv_usuar.cod_usuar                           =   tt-usuar_mestre.cod_usuario                                             
                       usuar_niv_usuar.cod_niv_usuar                       =   tt-usuar_mestre.nivel_usuario                                      
.                                 





             END.

             FOR EACH usuar_niv_usuar:

                   
                 FIND FIRST tt-usuar_mestre WHERE tt-usuar_mestre.cod_usuario = usuar_niv_usuar.cod_usuar
                                            AND   tt-usuar_mestre.nivel_usuario = usuar_niv_usuar.cod_niv_usuar NO-ERROR.

                 IF NOT AVAIL tt-usuar_mestre THEN DO:
                   
                                      DELETE usuar_niv_usuar.
             END.
             END.

    APPLY 'close' TO THIS-PROCEDURE.


                                                                                                                         
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
  


            do v_num_row_a = 1 to browse br-target-browse:NUM-SELECTED-ROWS:
        assign v_log_method = browse br-target-browse:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(tt-usuar_mestre).
              

        FIND tt-usuar_mestre WHERE recid(tt-usuar_mestre) = v_rec_table NO-ERROR.
             IF avail  tt-usuar_mestre THEN DO:
            DELETE tt-usuar_mestre.
             END.




            assign v_log_method = browse br-target-browse:deselect-selected-row(v_num_row_a)
                   v_num_row_a  = v_num_row_a - 1
                   v_log_atualiz_gerdoc = yes.
             

END.


/*   /* Jamais remova a definição do include a seguir de dentro da lógica do programa */                                                                                                   */
  {include/i-frm165.i}


/*       DELETE tt-entidades. */
/*                            */
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm175.i}
  
      OPEN QUERY br-target-browse FOR EACH tt-usuar_mestre WHERE tt-usuar_mestre.nivel_usuario  = cod_usuario
             NO-LOCK INDEXED-REPOSITION.

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
   define input parameter v-row-target-browse as rowid no-undo.
   
  /* Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm180.i}
  
/*    find tt-entidades where rowid(tt-entidades) = v-row-target-browse no-lock no-error. */
/*    if  available tt-entidades then do:                                                 */
/*        DELETE tt-entidades.                                                            */
/*    end.                                                                                */
   
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
 


      do v_num_row_a = 1 to browse br-source-browse:NUM-SELECTED-ROWS:
        assign v_log_method = browse br-source-browse:fetch-selected-row(v_num_row_a).
        assign v_rec_table  = recid(tt-usuario).
              
             FIND ext_lim_justif  WHERE ROWID(ext_lim_justif) = r-record NO-ERROR.

             FIND  tt-usuario  WHERE recid(tt-usuario) = v_rec_table NO-ERROR.
             
             FIND tt-usuar_mestre WHERE tt-usuar_mestre.cod_usuar = tt-usuario.cod_usuario
                                  AND   tt-usuar_mestre.nivel_usuario = ext_lim_justif.cod_niv_usuario
                                  NO-ERROR.

             IF NOT AVAIL tt-usuar_mestre THEN do:
                 
                 CREATE tt-usuar_mestre.
                 ASSIGN tt-usuar_mestre.cod_usuar          = tt-usuario.cod_usuario   
                        tt-usuar_mestre.nom_usuar         = tt-usuario.nom_usuario
                        tt-usuar_mestre.nivel_usuario   = ext_lim_justif.cod_niv_usuario                       
                        tt-usuar_mestre.l-selecionado = YES.

             
             END.




            assign v_log_method = browse br-source-browse:deselect-selected-row(v_num_row_a)
                   v_num_row_a  = v_num_row_a - 1
                   v_log_atualiz_gerdoc = yes.
             

END.

OPEN QUERY br-target-browse FOR EACH tt-usuar_mestre WHERE  tt-usuar_mestre.nivel_usuario = cod_usuario
                                                     
                            NO-LOCK INDEXED-REPOSITION.

/*   /* Jamais remova a definição do include a seguir de dentro da lógica do programa */                                                                                                   */
  {include/i-frm165.i}



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

  /*
  {include/i-frm150.i}
  */
  
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
  {src/adm/template/snd-list.i "tt-usuar_mestre"}
  {src/adm/template/snd-list.i "tt-usuario"}

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
  
  if p-state = "apply-entry":U then
     apply "entry":U to bt-ok in frame {&frame-name}.
  
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
  ( v-row-target as rowid) : /*:T rowid do registro selecionado no destino */
/*:T------------------------------------------------------------------------------
  Purpose:  Insira aqui a l¢gica que deve verificar se o registro corrente pode ou
            nÆo ser eliminado do browse de destino
    Notes:  
------------------------------------------------------------------------------*/

  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

