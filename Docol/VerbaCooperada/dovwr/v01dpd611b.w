&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{include/i-prgvrs.i V01DPD611B 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEF BUFFER b-amkt-solic-vl-bonific-realiz FOR amkt-solic-vl-bonific-realiz.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES amkt-solic-vl-bonific-realiz
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solic-vl-bonific-realiz


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solic-vl-bonific-realiz.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS amkt-solic-vl-bonific-realiz.sequencia-realiz ~
amkt-solic-vl-bonific-realiz.data-pedido ~
amkt-solic-vl-bonific-realiz.nr-pedcli ~
amkt-solic-vl-bonific-realiz.nome-abrev amkt-solic-vl-bonific-realiz.valor ~
amkt-solic-vl-bonific-realiz.tipo-ajuste ~
amkt-solic-vl-bonific-realiz.log-estornado 
&Scoped-define ENABLED-TABLES amkt-solic-vl-bonific-realiz
&Scoped-define FIRST-ENABLED-TABLE amkt-solic-vl-bonific-realiz
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ~
amkt-solic-vl-bonific-realiz.sequencia-realiz ~
amkt-solic-vl-bonific-realiz.data-pedido ~
amkt-solic-vl-bonific-realiz.nr-pedcli ~
amkt-solic-vl-bonific-realiz.nome-abrev amkt-solic-vl-bonific-realiz.valor ~
amkt-solic-vl-bonific-realiz.tipo-ajuste ~
amkt-solic-vl-bonific-realiz.log-estornado 
&Scoped-define DISPLAYED-TABLES amkt-solic-vl-bonific-realiz
&Scoped-define FIRST-DISPLAYED-TABLE amkt-solic-vl-bonific-realiz


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     amkt-solic-vl-bonific-realiz.sequencia-realiz AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 8 BY .88 NO-TAB-STOP 
     amkt-solic-vl-bonific-realiz.data-pedido AT ROW 2.75 COL 17 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     amkt-solic-vl-bonific-realiz.nr-pedcli AT ROW 3.75 COL 17 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     amkt-solic-vl-bonific-realiz.nome-abrev AT ROW 3.75 COL 49 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     amkt-solic-vl-bonific-realiz.valor AT ROW 4.75 COL 17 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     amkt-solic-vl-bonific-realiz.tipo-ajuste AT ROW 4.75 COL 36 NO-LABEL WIDGET-ID 18
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Positivo", 1,
"Negativo", 2
          SIZE 28 BY .88
     amkt-solic-vl-bonific-realiz.log-estornado AT ROW 5.75 COL 19 WIDGET-ID 4
          LABEL "Estornado"
          VIEW-AS TOGGLE-BOX
          SIZE 11 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: emsdocol.amkt-solic-vl-bonific-realiz
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.08
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX amkt-solic-vl-bonific-realiz.log-estornado IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       amkt-solic-vl-bonific-realiz.sequencia-realiz:READ-ONLY IN FRAME f-main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF
/************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "amkt-solic-vl-bonific-realiz"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solic-vl-bonific-realiz"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
RUN dispatch IN THIS-PROCEDURE("add-record").

FIND FIRST amkt-solic-vl-bonific NO-LOCK WHERE
           ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.
FIND LAST b-amkt-solic-vl-bonific-realiz NO-LOCK WHERE
          b-amkt-solic-vl-bonific-realiz.sequencia         = amkt-solic-vl-bonific.sequencia AND
          b-amkt-solic-vl-bonific-realiz.sequencia-realiz >= 0                               NO-ERROR.
ASSIGN amkt-solic-vl-bonific-realiz.sequencia-realiz:SCREEN-VALUE IN FRAME f-main = IF AVAIL b-amkt-solic-vl-bonific-realiz THEN STRING(b-amkt-solic-vl-bonific-realiz.sequencia-realiz + 1) ELSE "1".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
DEFINE VARIABLE h-bonif-amkt AS HANDLE      NO-UNDO.

{include/i-valid.i}

IF INPUT FRAME f-main amkt-solic-vl-bonific-realiz.data-pedido = ? THEN DO:
    RUN dop/MESSAGE.p("Data Pedido nÆo foi informada", "").
    RETURN "ADM-ERROR".
END.

IF INPUT FRAME f-main amkt-solic-vl-bonific-realiz.data-pedido > TODAY THEN DO:
    RUN dop/MESSAGE.p("Data Pedido nÆo pode ser futura", "").
    RETURN "ADM-ERROR".
END.

/*
IF TRIM(INPUT FRAME f-main amkt-solic-vl-bonific-realiz.nr-pedcli) = "" OR
   INPUT FRAME f-main amkt-solic-vl-bonific-realiz.nr-pedcli       = ?  THEN DO:
    RUN dop/MESSAGE.p("Pedido Cliente nÆo foi informado", "").
    RETURN "ADM-ERROR".
END.

IF TRIM(INPUT FRAME f-main amkt-solic-vl-bonific-realiz.nome-abrev) = "" OR
   INPUT FRAME f-main amkt-solic-vl-bonific-realiz.nome-abrev       = ?  THEN DO:
    RUN dop/MESSAGE.p("Nome Abreviado nÆo foi informado", "").
    RETURN "ADM-ERROR".
END.
*/

IF INPUT FRAME f-main amkt-solic-vl-bonific-realiz.valor = ? OR
   INPUT FRAME f-main amkt-solic-vl-bonific-realiz.valor = 0 THEN DO:
    RUN dop/MESSAGE.p("Valor nÆo foi informado", "").
    RETURN "ADM-ERROR".
END.

IF adm-new-record THEN DO:
    FIND FIRST amkt-solic-vl-bonific NO-LOCK WHERE
               ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.

    IF CAN-FIND(b-amkt-solic-vl-bonific-realiz NO-LOCK WHERE
                b-amkt-solic-vl-bonific-realiz.sequencia        = amkt-solic-vl-bonific.sequencia AND
                b-amkt-solic-vl-bonific-realiz.sequencia-realiz = INPUT FRAME f-main amkt-solic-vl-bonific-realiz.sequencia-realiz) THEN DO:
        FIND LAST b-amkt-solic-vl-bonific-realiz NO-LOCK WHERE
                  b-amkt-solic-vl-bonific-realiz.sequencia         = amkt-solic-vl-bonific.sequencia AND
                  b-amkt-solic-vl-bonific-realiz.sequencia-realiz >= 0                               NO-ERROR.
        ASSIGN amkt-solic-vl-bonific-realiz.sequencia-realiz:SCREEN-VALUE IN FRAME f-main = IF AVAIL b-amkt-solic-vl-bonific-realiz THEN STRING(b-amkt-solic-vl-bonific-realiz.sequencia-realiz + 1) ELSE "1".
        RUN dop/MESSAGE3.p("Sequˆncia Realizado foi atualizada para " + amkt-solic-vl-bonific-realiz.sequencia-realiz:SCREEN-VALUE IN FRAME f-main, "").
    END.
END.

RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
    return 'ADM-ERROR':U.

RUN dop/bonif-amkt.p PERSISTENT SET h-bonif-amkt.
RUN atualiza-realizado IN h-bonif-amkt(amkt-solic-vl-bonific-realiz.sequencia).
DELETE PROCEDURE h-bonif-amkt.
ASSIGN h-bonif-amkt = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
RUN dispatch IN THIS-PROCEDURE("create-record").

FIND FIRST amkt-solic-vl-bonific NO-LOCK WHERE
           ROWID(amkt-solic-vl-bonific) = v-row-parent NO-ERROR.
IF AVAIL amkt-solic-vl-bonific THEN DO:
    ASSIGN amkt-solic-vl-bonific-realiz.sequencia = amkt-solic-vl-bonific.sequencia.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "amkt-solic-vl-bonific-realiz"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

