&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{include/i-prgvrs.i B04DPD607 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w

/* Local Variable Definitions ---                                       */

def new global shared var v-row-parent as rowid no-undo.
def var v-row-table  as rowid.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(10)" COLUMN-LABEL "Situa��o" NO-UNDO.

DEFINE VARIABLE h-inst AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES amkt-solicitacao
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solicitacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solicitacao.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES amkt-aprov-pend amkt-solic-comprov

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table amkt-solic-comprov.sequencia amkt-aprov-pend.cod-papel amkt-aprov-pend.dt-pendencia amkt-aprov-pend.cod-usuario amkt-aprov-pend.valor-limite fn-situacao(amkt-aprov-pend.situacao) @ c-situacao amkt-aprov-pend.dt-situacao amkt-aprov-pend.cod-usuario-situacao amkt-aprov-pend.altern-situacao amkt-aprov-pend.observacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH amkt-aprov-pend NO-LOCK WHERE                                  amkt-aprov-pend.cd-solicitacao = amkt-solicitacao.numero AND                                  amkt-aprov-pend.tipo           = 2, ~
       /* Comprova��o */                             LAST amkt-solic-comprov NO-LOCK WHERE                                  amkt-solic-comprov.numero      = amkt-aprov-pend.cd-solicitacao AND                                  amkt-solic-comprov.data-envio <= amkt-aprov-pend.dt-pendencia                                  BY amkt-aprov-pend.dt-situacao
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH amkt-aprov-pend NO-LOCK WHERE                                  amkt-aprov-pend.cd-solicitacao = amkt-solicitacao.numero AND                                  amkt-aprov-pend.tipo           = 2, ~
       /* Comprova��o */                             LAST amkt-solic-comprov NO-LOCK WHERE                                  amkt-solic-comprov.numero      = amkt-aprov-pend.cd-solicitacao AND                                  amkt-solic-comprov.data-envio <= amkt-aprov-pend.dt-pendencia                                  BY amkt-aprov-pend.dt-situacao.
&Scoped-define TABLES-IN-QUERY-br-table amkt-aprov-pend amkt-solic-comprov
&Scoped-define FIRST-TABLE-IN-QUERY-br-table amkt-aprov-pend
&Scoped-define SECOND-TABLE-IN-QUERY-br-table amkt-solic-comprov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-visualizar fi-url-arquivo 
&Scoped-Define DISPLAYED-OBJECTS fi-url-arquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
numero||y|emsdocol.amkt-solicitacao-sell-in.numero
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "numero"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Optionsososos" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao B-table-Win 
FUNCTION fn-situacao RETURNS CHARACTER(p-situacao AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-visualizar 
     LABEL "Visualizar" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-url-arquivo AS CHARACTER FORMAT "X(300)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      amkt-aprov-pend, 
      amkt-solic-comprov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      amkt-solic-comprov.sequencia      
amkt-aprov-pend.cod-papel            WIDTH 20            
amkt-aprov-pend.dt-pendencia   FORMAT "99/99/9999 HH:MM"
amkt-aprov-pend.cod-usuario
amkt-aprov-pend.valor-limite
fn-situacao(amkt-aprov-pend.situacao) @ c-situacao WIDTH 10
amkt-aprov-pend.dt-situacao          FORMAT "99/99/9999 HH:MM"
amkt-aprov-pend.cod-usuario-situacao
amkt-aprov-pend.altern-situacao      FORMAT "X/"
amkt-aprov-pend.observacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 88 BY 6.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-visualizar AT ROW 7.38 COL 46.86 WIDGET-ID 4
     fi-url-arquivo AT ROW 7.42 COL 7 COLON-ALIGNED WIDGET-ID 2 NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: emsdocol.amkt-solicitacao
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.46
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br-table:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

ASSIGN 
       fi-url-arquivo:READ-ONLY IN FRAME F-Main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH amkt-aprov-pend NO-LOCK WHERE
                                 amkt-aprov-pend.cd-solicitacao = amkt-solicitacao.numero AND
                                 amkt-aprov-pend.tipo           = 2, /* Comprova��o */
                            LAST amkt-solic-comprov NO-LOCK WHERE
                                 amkt-solic-comprov.numero      = amkt-aprov-pend.cd-solicitacao AND
                                 amkt-solic-comprov.data-envio <= amkt-aprov-pend.dt-pendencia
                                 BY amkt-aprov-pend.dt-situacao.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State("DblClick, SELF":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
    /* This code displays initial values for newly added or copied rows. */
    //{src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
    IF NOT AVAIL amkt-solic-comprov THEN
        ASSIGN fi-url-arquivo:SCREEN-VALUE IN FRAME F-Main = "".
    ELSE DO:
        ASSIGN fi-url-arquivo:SCREEN-VALUE IN FRAME F-Main = ENTRY(NUM-ENTRIES(amkt-solic-comprov.url-arquivo, "\"), amkt-solic-comprov.url-arquivo, "\") NO-ERROR.
    END.
    //{src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-visualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-visualizar B-table-Win
ON CHOOSE OF bt-visualizar IN FRAME F-Main /* Visualizar */
DO:
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    IF NOT AVAIL amkt-solic-comprov THEN RETURN NO-APPLY.

    /*IF SEARCH(amkt-solic-comprov.url-arquivo) = ? THEN DO:
        RUN dop/MESSAGE.p("Arquivo n�o encontrado.", "Favor entrar em contato com a TIC.").
        RETURN NO-APPLY.
    END.*/

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + INPUT FRAME F-Main fi-url-arquivo.

    OS-DELETE VALUE(c-arquivo).

    OS-COPY VALUE(amkt-solic-comprov.url-arquivo) VALUE(c-arquivo).

    RUN ShellExecuteA(INPUT  0, 
                      INPUT  "Open", 
                      INPUT  SEARCH(c-arquivo),
                      INPUT  "",
                      INPUT  "", 
                      INPUT  1, 
                      OUTPUT h-inst).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
PROCEDURE ShellExecuteA EXTERNAL "shell32.dll":
    DEFINE INPUT  PARAMETER HWND         AS LONG.
    DEFINE INPUT  PARAMETER lpOperation  AS CHAR.
    DEFINE INPUT  PARAMETER lpFile       AS CHAR.
    DEFINE INPUT  PARAMETER lpParameters AS CHAR.
    DEFINE INPUT  PARAMETER lpDirectory  AS CHAR.
    DEFINE INPUT  PARAMETER nShowCmd     AS LONG.
    DEFINE RETURN PARAMETER hInstance    AS LONG.
END PROCEDURE.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "amkt-solicitacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solicitacao"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
RUN dispatch IN THIS-PROCEDURE('open-query').

APPLY "VALUE-CHANGED" TO br-table IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "numero" "amkt-solicitacao-sell-in" "numero"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "amkt-solicitacao"}
  {src/adm/template/snd-list.i "amkt-aprov-pend"}
  {src/adm/template/snd-list.i "amkt-solic-comprov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao B-table-Win 
FUNCTION fn-situacao RETURNS CHARACTER(p-situacao AS INT):

CASE p-situacao:
    WHEN 1 THEN RETURN "Pendente".
    WHEN 2 THEN RETURN "Aprovada".
    WHEN 3 THEN RETURN "Reprovada".
END CASE.

RETURN STRING(p-situacao).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

