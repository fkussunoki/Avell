&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emscad           PROGRESS
*/
&Scoped-define WINDOW-NAME main-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS main-window 
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

DEFINE TEMP-TABLE tt-ext_exc_justificativas LIKE ext_exc_justificativas
    FIELD l-selecionado AS LOGICAL
    FIELD l-novo AS char.
          
DEFINE TEMP-TABLE tt-ext-palavras
    FIELD cod_palavras AS CHAR.

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
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-source-browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ext-palavras TT-ext_exc_justificativas

/* Definitions for BROWSE br-source-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-source-browse tt-ext-palavras.cod_palavras   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-source-browse   
&Scoped-define SELF-NAME br-source-browse
&Scoped-define QUERY-STRING-br-source-browse FOR EACH tt-ext-palavras NO-LOCK
&Scoped-define OPEN-QUERY-br-source-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-palavras NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-source-browse tt-ext-palavras
&Scoped-define FIRST-TABLE-IN-QUERY-br-source-browse tt-ext-palavras


/* Definitions for BROWSE br-target-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-target-browse TT-ext_exc_justificativas.cod_padr_coluna TT-ext_exc_justificativas.cod_palavra   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-target-browse   
&Scoped-define SELF-NAME br-target-browse
&Scoped-define QUERY-STRING-br-target-browse FOR EACH TT-ext_exc_justificativas WHERE TT-ext_exc_justificativas.cod_padr_coluna = COD_USUARIO                        NO-LOCK      INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-target-browse OPEN QUERY {&SELF-NAME} FOR EACH TT-ext_exc_justificativas WHERE TT-ext_exc_justificativas.cod_padr_coluna = COD_USUARIO                        NO-LOCK      INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-target-browse TT-ext_exc_justificativas
&Scoped-define FIRST-TABLE-IN-QUERY-br-target-browse TT-ext_exc_justificativas


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-source-browse}~
    ~{&OPEN-QUERY-br-target-browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ~
padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl 
&Scoped-define ENABLED-TABLES padr_col_demonst_ctbl
&Scoped-define FIRST-ENABLED-TABLE padr_col_demonst_ctbl
&Scoped-Define ENABLED-OBJECTS rt-key-parent rt-source-browse ~
rt-source-browse-2 RECT-1 RECT-2 br-source-browse br-target-browse bt-add ~
bt-del bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS ~
padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl 
&Scoped-define DISPLAYED-TABLES padr_col_demonst_ctbl
&Scoped-define FIRST-DISPLAYED-TABLE padr_col_demonst_ctbl


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-create-allowed main-window 
FUNCTION is-create-allowed RETURNS LOGICAL
  ( v-row-tt as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-delete-allowed main-window 
FUNCTION is-delete-allowed RETURNS LOGICAL
  ( v-row-target as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR main-window AS WIDGET-HANDLE NO-UNDO.

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
      tt-ext-palavras SCROLLING.

DEFINE QUERY br-target-browse FOR 
      TT-ext_exc_justificativas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-source-browse main-window _FREEFORM
  QUERY br-source-browse DISPLAY
      tt-ext-palavras.cod_palavras
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36.43 BY 7.5.

DEFINE BROWSE br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-target-browse main-window _FREEFORM
  QUERY br-target-browse DISPLAY
      TT-ext_exc_justificativas.cod_padr_coluna
      TT-ext_exc_justificativas.cod_palavra
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36.43 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl AT ROW 1.88 COL 17.29 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 50.29 BY .88
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
  CREATE WINDOW main-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Formar Or‡amentos"
         HEIGHT             = 14.38
         WIDTH              = 89.86
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 90
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB main-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW main-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-source-browse cod_padr_col_demonst_ctbl f-main */
/* BROWSE-TAB br-target-browse br-source-browse f-main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(main-window)
THEN main-window:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-source-browse
/* Query rebuild information for BROWSE br-source-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-palavras NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-source-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-target-browse
/* Query rebuild information for BROWSE br-target-browse
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH TT-ext_exc_justificativas WHERE TT-ext_exc_justificativas.cod_padr_coluna = COD_USUARIO

                      NO-LOCK      INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-target-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME main-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL main-window main-window
ON END-ERROR OF main-window /* Formar Or‡amentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL main-window main-window
ON WINDOW-CLOSE OF main-window /* Formar Or‡amentos */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-source-browse main-window
ON VALUE-CHANGED OF br-source-browse IN FRAME f-main
DO:
  {include/i-frm020.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-target-browse
&Scoped-define SELF-NAME br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-target-browse main-window
ON VALUE-CHANGED OF br-target-browse IN FRAME f-main
DO:
  {include/i-frm010.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add main-window
ON CHOOSE OF bt-add IN FRAME f-main
DO:
RUN pi-ins.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda main-window
ON CHOOSE OF bt-ajuda IN FRAME f-main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela main-window
ON CHOOSE OF bt-cancela IN FRAME f-main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del main-window
ON CHOOSE OF bt-del IN FRAME f-main
DO:
 
   run pi-del.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok main-window
ON CHOOSE OF bt-ok IN FRAME f-main /* OK */
DO:
  run pi-commit.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-source-browse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK main-window 


/* ***************************  Main Block  *************************** */

{include/i-frm040.i}
/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects main-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available main-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI main-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(main-window)
  THEN DELETE WIDGET main-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI main-window  _DEFAULT-ENABLE
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
  IF AVAILABLE padr_col_demonst_ctbl THEN 
    DISPLAY padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl 
      WITH FRAME f-main IN WINDOW main-window.
  ENABLE rt-key-parent rt-source-browse rt-source-browse-2 RECT-1 RECT-2 
         padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl br-source-browse 
         br-target-browse bt-add bt-del bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-main IN WINDOW main-window.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
  VIEW main-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize main-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "MGLA1211aa" "1.00.00.000"}


  run pi-show-master-record.

  FOR EACH ext_palavras_excecao NO-LOCK BREAK BY ext_palavras_excecao.cod_palavras:
      CREATE tt-ext-palavras.
      ASSIGN tt-ext-palavras.cod_palavras = ext_palavras_excecao.cod_palavras.

  END.

  FIND FIRST padr_col_demonst_ctbl NO-LOCK WHERE ROWID(padr_col_demonst_ctbl) =  r-record NO-ERROR.

  ASSIGN cod_usuario = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl.
  FOR EACH ext_exc_justificativas NO-LOCK BREAK BY ext_palavras_excecao.cod_palavras:

      CREATE tt-ext_exc_justificativas.
      ASSIGN tt-ext_exc_justificativas.cod_padr_coluna        = ext_exc_justificativas.cod_padr_coluna
             tt-ext_exc_justificativas.cod_palavra            = ext_exc_justificativas.cod_palavra
             tt-ext_exc_justificativas.l-selecionado          = YES.



  END.

  /* Dispatch standard ADM method.                             */  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail padr_col_demonst_ctbl THEN DO:
      
    disp padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl              with frame {&frame-name}.
 

END.

ELSE
    MESSAGE "eeo" VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-to-target main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-commit main-window 
PROCEDURE pi-commit :
FOR EACH tt-ext_exc_justificativas WHERE  tt-ext_exc_justificativas.l-novo       = "new" 
    :

    FIND FIRST ext_exc_justificativas  WHERE ext_exc_justificativas.cod_padr_coluna = tt-ext_exc_justificativas.cod_padr_coluna
                                       AND   ext_exc_justificativas.cod_palavra     = tt-ext_exc_justificativas.cod_palavra NO-ERROR.

    IF NOT avail ext_exc_justificativas THEN DO:
        

        CREATE ext_exc_justificativas.
        ASSIGN ext_exc_justificativas.cod_padr_coluna = tt-ext_exc_justificativas.cod_padr_coluna
               ext_exc_justificativas.cod_palavra     = tt-ext_exc_justificativas.cod_palavra               .              


    END.


END.


FOR EACH ext_exc_justificativas:

    FIND FIRST tt-ext_exc_justificativas  WHERE tt-ext_exc_justificativas.cod_padr_coluna = ext_exc_justificativas.cod_padr_coluna
                                          AND   tt-ext_exc_justificativas.cod_palavra = ext_exc_justificativas.cod_palavra NO-ERROR.


    IF NOT AVAIL tt-ext_exc_justificativas THEN DO:
        

        DELETE ext_exc_justificativas.
    END.
               

END.



    APPLY 'close' TO THIS-PROCEDURE.
                                                                                                                         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-del main-window 
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
        assign v_rec_table  = recid(TT-ext_exc_justificativas).
              

             FIND TT-ext_exc_justificativas WHERE recid(TT-ext_exc_justificativas) = v_rec_table NO-ERROR.
                          
             IF avail  TT-ext_exc_justificativas THEN DO:
           
                 DELETE TT-ext_exc_justificativas.
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
  
      OPEN QUERY br-target-browse FOR EACH TT-ext_exc_justificativas WHERE  TT-ext_exc_justificativas.cod_padr_col = cod_usuario
                                                            
             NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-from-target main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ins main-window 
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
        assign v_rec_table  = recid(tt-ext-palavras).
              
             FIND FIRST padr_col_demonst_ctbl NO-LOCK WHERE ROWID(padr_col_demonst_ctbl) =  r-record NO-ERROR.

             FIND  tt-ext-palavras WHERE recid(tt-ext-palavras) = v_rec_table NO-ERROR.
             
             FIND tt-ext_exc_justificativas  WHERE tt-ext_exc_justificativas.cod_padr_coluna      =  padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl   
                                             AND   tt-ext_exc_justificativas.cod_palavra          =  tt-ext-palavras.cod_palavra           
                                             NO-ERROR.            

             IF NOT avail  tt-ext_exc_justificativas THEN DO:
                 

                 CREATE tt-ext_exc_justificativas.
                 ASSIGN tt-ext_exc_justificativas.cod_padr_coluna      =  padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl 
                        tt-ext_exc_justificativas.cod_palavra          =  tt-ext-palavras.cod_palavra  
                        tt-ext_exc_justificativas.l-selecionado        = YES
                        tt-ext_exc_justificativas.l-novo               = "new".




            assign v_log_method = browse br-source-browse:deselect-selected-row(v_num_row_a)
                   v_num_row_a  = v_num_row_a - 1
                   v_log_atualiz_gerdoc = yes.
             

    END.
      END.
OPEN QUERY br-target-browse FOR EACH tt-ext_exc_justificativas WHERE tt-ext_exc_justificativas.cod_padr_coluna = cod_usuario
                            NO-LOCK INDEXED-REPOSITION.

/*   /* Jamais remova a definição do include a seguir de dentro da lógica do programa */                                                                                                   */
  {include/i-frm165.i}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-show-master-record main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records main-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "TT-ext_exc_justificativas"}
  {src/adm/template/snd-list.i "tt-ext-palavras"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-create-allowed main-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-delete-allowed main-window 
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

