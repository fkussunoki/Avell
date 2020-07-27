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

{include/i-prgvrs.i V01DPD611 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEF BUFFER b-amkt-solic-vl-bonific FOR amkt-solic-vl-bonific.

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
&Scoped-define EXTERNAL-TABLES amkt-solic-vl-bonific
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solic-vl-bonific


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solic-vl-bonific.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS amkt-solic-vl-bonific.sequencia ~
amkt-solic-vl-bonific.data-hora-lib amkt-solic-vl-bonific.vl-liberado ~
amkt-solic-vl-bonific.vl-realizado amkt-solic-vl-bonific.data-hora-inclusao ~
amkt-solic-vl-bonific.cod-usuario amkt-solic-vl-bonific.motivo 
&Scoped-define ENABLED-TABLES amkt-solic-vl-bonific
&Scoped-define FIRST-ENABLED-TABLE amkt-solic-vl-bonific
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold fi-lbl-motivo 
&Scoped-Define DISPLAYED-FIELDS amkt-solic-vl-bonific.sequencia ~
amkt-solic-vl-bonific.tipo-documento amkt-solic-vl-bonific.documento ~
amkt-solic-vl-bonific.cod-emitente amkt-solic-vl-bonific.data-hora-lib ~
amkt-solic-vl-bonific.vl-liberado amkt-solic-vl-bonific.vl-realizado ~
amkt-solic-vl-bonific.data-hora-inclusao amkt-solic-vl-bonific.cod-usuario ~
amkt-solic-vl-bonific.motivo 
&Scoped-define DISPLAYED-TABLES amkt-solic-vl-bonific
&Scoped-define FIRST-DISPLAYED-TABLE amkt-solic-vl-bonific
&Scoped-Define DISPLAYED-OBJECTS fi-nome-emit fi-saldo fi-lbl-motivo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS amkt-solic-vl-bonific.tipo-documento ~
amkt-solic-vl-bonific.documento amkt-solic-vl-bonific.cod-emitente 
&Scoped-define ADM-ASSIGN-FIELDS amkt-solic-vl-bonific.tipo-documento ~
amkt-solic-vl-bonific.documento amkt-solic-vl-bonific.cod-emitente 

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
DEFINE VARIABLE fi-lbl-motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Motivo:" 
      VIEW-AS TEXT 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>>,>>>,>>9.99":U 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     amkt-solic-vl-bonific.sequencia AT ROW 1.25 COL 16 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88 NO-TAB-STOP 
     amkt-solic-vl-bonific.tipo-documento AT ROW 2.25 COL 5.86 WIDGET-ID 12
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Selecione um",0,
                     "1 - Verba Cooperada",1,
                     "2 - VC - Abatimento",2
          DROP-DOWN-LIST
          SIZE 21 BY 1
     amkt-solic-vl-bonific.documento AT ROW 2.25 COL 49 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     amkt-solic-vl-bonific.cod-emitente AT ROW 3.25 COL 16 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-nome-emit AT ROW 3.25 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     amkt-solic-vl-bonific.data-hora-lib AT ROW 4.75 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     amkt-solic-vl-bonific.vl-liberado AT ROW 5.75 COL 16 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     amkt-solic-vl-bonific.vl-realizado AT ROW 5.75 COL 43 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 14 BY .88 NO-TAB-STOP 
     fi-saldo AT ROW 5.75 COL 70 COLON-ALIGNED WIDGET-ID 26 NO-TAB-STOP 
     amkt-solic-vl-bonific.data-hora-inclusao AT ROW 6.75 COL 16 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88 NO-TAB-STOP 
     amkt-solic-vl-bonific.cod-usuario AT ROW 6.75 COL 49 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88 NO-TAB-STOP 
     amkt-solic-vl-bonific.motivo AT ROW 7.75 COL 18 NO-LABEL WIDGET-ID 18
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 55 BY 4
     fi-lbl-motivo AT ROW 7.75 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 20 NO-TAB-STOP 
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: emsdocol.amkt-solic-vl-bonific
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
         HEIGHT             = 11.04
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

/* SETTINGS FOR FILL-IN amkt-solic-vl-bonific.cod-emitente IN FRAME f-main
   NO-ENABLE 1 2                                                        */
ASSIGN 
       amkt-solic-vl-bonific.cod-usuario:READ-ONLY IN FRAME f-main        = TRUE.

ASSIGN 
       amkt-solic-vl-bonific.data-hora-inclusao:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN amkt-solic-vl-bonific.documento IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       amkt-solic-vl-bonific.sequencia:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR COMBO-BOX amkt-solic-vl-bonific.tipo-documento IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2                                                */
ASSIGN 
       amkt-solic-vl-bonific.vl-realizado:READ-ONLY IN FRAME f-main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME amkt-solic-vl-bonific.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific.cod-emitente V-table-Win
ON F5 OF amkt-solic-vl-bonific.cod-emitente IN FRAME f-main /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z02ad098.w"
                       &campo=amkt-solic-vl-bonific.cod-emitente
                       &campozoom=cod-emitente
                       &campo2=fi-nome-emit
                       &campozoom=nome-emit}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific.cod-emitente V-table-Win
ON LEAVE OF amkt-solic-vl-bonific.cod-emitente IN FRAME f-main /* Cliente */
DO:
    FIND FIRST emitente NO-LOCK WHERE
               emitente.cod-emitente = INPUT FRAME f-main amkt-solic-vl-bonific.cod-emitente NO-ERROR.
    ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME f-main = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solic-vl-bonific.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF amkt-solic-vl-bonific.cod-emitente IN FRAME f-main /* Cliente */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


amkt-solic-vl-bonific.cod-emitente:LOAD-MOUSE-POINTER("IMAGE/lupa.cur") IN FRAME f-main.

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
  {src/adm/template/row-list.i "amkt-solic-vl-bonific"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solic-vl-bonific"}

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

FIND LAST b-amkt-solic-vl-bonific NO-LOCK WHERE
          b-amkt-solic-vl-bonific.sequencia >= 0 NO-ERROR.
ASSIGN amkt-solic-vl-bonific.sequencia         :SCREEN-VALUE IN FRAME f-main = IF AVAIL b-amkt-solic-vl-bonific THEN STRING(b-amkt-solic-vl-bonific.sequencia + 1) ELSE "1"
       amkt-solic-vl-bonific.data-hora-inclusao:SCREEN-VALUE IN FRAME f-main = STRING(NOW)
       amkt-solic-vl-bonific.cod-usuario       :SCREEN-VALUE IN FRAME f-main = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
{include/i-valid.i}

IF adm-new-record THEN DO:
    IF INPUT FRAME f-main amkt-solic-vl-bonific.tipo-documento = 0 THEN DO:
        RUN dop/MESSAGE.p("Tipo de Documento n∆o foi selecionado.", "").
        RETURN "ADM-ERROR".
    END.

    IF TRIM(INPUT FRAME f-main amkt-solic-vl-bonific.documento) = "" OR
       INPUT FRAME f-main amkt-solic-vl-bonific.documento       = ?  THEN DO:
        RUN dop/MESSAGE.p("Documento n∆o foi informado", "").
        RETURN "ADM-ERROR".
    END.

    IF CAN-FIND(FIRST b-amkt-solic-vl-bonific NO-LOCK WHERE
                      b-amkt-solic-vl-bonific.tipo-documento = INPUT FRAME f-main amkt-solic-vl-bonific.tipo-documento AND
                      b-amkt-solic-vl-bonific.documento      = INPUT FRAME f-main amkt-solic-vl-bonific.documento) THEN DO:
        RUN dop/MESSAGE.p("J† existe Bonificaá∆o para Documento e Tipo", "").
        RETURN "ADM-ERROR".
    END.

    FIND FIRST emitente NO-LOCK WHERE
               emitente.cod-emitente = INPUT FRAME f-main amkt-solic-vl-bonific.cod-emitente AND
               emitente.cod-emitente > 0                                                     NO-ERROR.
    IF NOT AVAIL emitente THEN DO:
        RUN dop/MESSAGE.p("Cliente n∆o foi informado", "").
        RETURN "ADM-ERROR".
    END.

    IF INPUT FRAME f-main amkt-solic-vl-bonific.data-hora-lib = ? THEN DO:
        RUN dop/MESSAGE.p("Data/Hora Liberaá∆o n∆o foi informada", "").
        RETURN "ADM-ERROR".
    END.
    
    IF INPUT FRAME f-main amkt-solic-vl-bonific.data-hora-lib > NOW THEN DO:
        RUN dop/MESSAGE.p("Data/Hora Liberaá∆o n∆o pode ser futura", "").
        RETURN "ADM-ERROR".
    END.

    IF INPUT FRAME f-main amkt-solic-vl-bonific.vl-liberado = 0 THEN DO:
        RUN dop/MESSAGE.p("Valor Liberado n∆o foi informado", "").
        RETURN "ADM-ERROR".
    END.

    IF TRIM(INPUT FRAME f-main amkt-solic-vl-bonific.motivo) = "" OR
       INPUT FRAME f-main amkt-solic-vl-bonific.motivo       = ?  THEN DO:
        RUN dop/MESSAGE.p("Motivo da Bonificaá∆o n∆o foi informado", "").
        RETURN "ADM-ERROR".
    END.

    IF CAN-FIND(FIRST b-amkt-solic-vl-bonific NO-LOCK WHERE
                      b-amkt-solic-vl-bonific.sequencia = INPUT FRAME f-main amkt-solic-vl-bonific.sequencia) THEN DO:
        FIND LAST b-amkt-solic-vl-bonific NO-LOCK WHERE
                  b-amkt-solic-vl-bonific.sequencia >= 0 NO-ERROR.
        ASSIGN amkt-solic-vl-bonific.sequencia:SCREEN-VALUE IN FRAME f-main = IF AVAIL b-amkt-solic-vl-bonific THEN STRING(b-amkt-solic-vl-bonific.sequencia + 1) ELSE "1".
        RUN dop/MESSAGE3.p("Sequància da Bonificaá∆o atualizada para " + amkt-solic-vl-bonific.sequencia:SCREEN-VALUE IN FRAME f-main, "").
    END.
END.

RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
    return 'ADM-ERROR':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
RUN dispatch IN THIS-PROCEDURE('copy-record').

FIND LAST b-amkt-solic-vl-bonific NO-LOCK WHERE
          b-amkt-solic-vl-bonific.sequencia >= 0 NO-ERROR.
ASSIGN amkt-solic-vl-bonific.sequencia         :SCREEN-VALUE IN FRAME f-main = IF AVAIL b-amkt-solic-vl-bonific THEN STRING(b-amkt-solic-vl-bonific.sequencia + 1) ELSE "1"
       amkt-solic-vl-bonific.data-hora-inclusao:SCREEN-VALUE IN FRAME f-main = STRING(NOW)
       amkt-solic-vl-bonific.cod-usuario       :SCREEN-VALUE IN FRAME f-main = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
IF AVAIL amkt-solic-vl-bonific            AND
   amkt-solic-vl-bonific.cod-usuario = "" THEN DO:
    RUN dop/MESSAGE.p("Eliminaá∆o n∆o permitida.",
                      "Bonificaá∆o foi gerada automaticamente, e n∆o pode ser eliminada.").
    RETURN "ADM-ERROR".
END.

RUN dispatch IN THIS-PROCEDURE('delete-record').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
RUN dispatch IN THIS-PROCEDURE("display-fields").

APPLY "LEAVE" TO amkt-solic-vl-bonific.cod-emitente IN FRAME f-main.

ASSIGN fi-saldo:SCREEN-VALUE IN FRAME f-main = STRING(INPUT FRAME f-main amkt-solic-vl-bonific.vl-liberado -
                                                      INPUT FRAME f-main amkt-solic-vl-bonific.vl-realizado).

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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
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
  {src/adm/template/snd-list.i "amkt-solic-vl-bonific"}

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

