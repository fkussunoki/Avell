&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i D99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT param p-row AS recid.
DEFINE INPUT param p-cpf AS char.
/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-conta LIKE cta_corren_fornec
    FIELD l-seleciona AS LOGICAL.

DEF VAR l-logico AS LOGICAL.

DEF NEW GLOBAL SHARED VAR v-cpf AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-conta

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-conta.cod_banco tt-conta.cod_agenc_bcia tt-conta.cod_digito_agenc_bcia tt-conta.cod_cta_corren_bco tt-conta.cod_digito_cta_corren tt-conta.des_cta_corren   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-conta
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-conta.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-conta
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-conta


/* Definitions for FRAME f-main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom bt-ok 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79.86 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON BUTTON-13 
     LABEL "Incluir" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-14 
     LABEL "Modifica" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-15 
     LABEL "Elimina" 
     SIZE 15 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-conta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt-conta.cod_banco LABEL 'Banco'
 tt-conta.cod_agenc_bcia LABEL 'Agencia'
 tt-conta.cod_digito_agenc_bcia LABEL 'Dig'
 tt-conta.cod_cta_corren_bco LABEL 'C/Corrente'
 tt-conta.cod_digito_cta_corren LABEL 'Dig'
 tt-conta.des_cta_corren LABEL 'Descricao'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-COLUMN-SCROLLING SEPARATORS SIZE 72.86 BY 6.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     bt-ok AT ROW 12.54 COL 3
     rt-buttom AT ROW 12.29 COL 2
     SPACE(0.27) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.

DEFINE FRAME f-main
     BROWSE-3 AT ROW 2.58 COL 4.14 WIDGET-ID 300
     BUTTON-14 AT ROW 9.21 COL 21.14 WIDGET-ID 4
     BUTTON-13 AT ROW 9.25 COL 4.72 WIDGET-ID 2
     BUTTON-15 AT ROW 9.25 COL 37.14 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 1
         SIZE 80.86 BY 11.08
         TITLE "Contas correntes" WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME f-main:FRAME = FRAME D-Dialog:HANDLE.

/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME f-main
                                                                        */
/* BROWSE-TAB BROWSE-3 1 f-main */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-conta.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define FRAME-NAME f-main
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 D-Dialog
ON CHOOSE OF BUTTON-13 IN FRAME f-main /* Incluir */
DO:
    RUN esp/esrc713aa.p(INPUT p-row,
                      INPUT p-cpf).

    RUN pi-cria-tt.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 D-Dialog
ON CHOOSE OF BUTTON-14 IN FRAME f-main /* Modifica */
DO:
      DEF VAR nb AS INTEGER.
    DEF VAR I  AS INTEGER.
  
    nb = browse-3:NUM-SELECTED-ROWS.


    IF nb <> 0 THEN 

        DO i = 1 TO nb:


        IF browse-3:FETCH-SELECTED-ROW(i) THEN

            RUN esp/esrc713ab.p (INPUT  p-row,
                                 INPUT  p-cpf,
                                 INPUT  tt-conta.cod_banco,
                                 input  tt-conta.cod_agenc_bcia,
                                 input  tt-conta.cod_cta_corren_bco).


            END.
RUN pi-cria-tt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 D-Dialog
ON CHOOSE OF BUTTON-15 IN FRAME f-main /* Elimina */
DO:
    DEF VAR nb AS INTEGER.
  DEF VAR I  AS INTEGER.

  nb = browse-3:NUM-SELECTED-ROWS.


  IF nb <> 0 THEN 

      DO i = 1 TO nb:


      IF browse-3:FETCH-SELECTED-ROW(i) THEN

            ASSIGN tt-conta.l-seleciona = YES.

          END.


          MESSAGE "Deseja eliminar a conta?" VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE l-logico.


          IF l-logico THEN DO:
              FOR EACH tt-conta WHERE tt-conta.l-seleciona = YES:

              FIND FIRST cta_corren_fornec WHERE   cta_corren_fornec.cod_empresa             =  tt-conta.cod_empresa            
                                           and     cta_corren_fornec.cdn_fornecedor          =  tt-conta.cdn_fornecedor         
                                           and     cta_corren_fornec.cod_banco               =  tt-conta.cod_banco              
                                           and     cta_corren_fornec.cod_agenc_bcia          =  tt-conta.cod_agenc_bcia         
                                           and     cta_corren_fornec.cod_digito_agenc_bcia   =  tt-conta.cod_digito_agenc_bcia  
                                           and     cta_corren_fornec.cod_cta_corren_bco      =  tt-conta.cod_cta_corren_bco     
                                           and     cta_corren_fornec.cod_digito_cta_corren   =  tt-conta.cod_digito_cta_corren  
                                           and     cta_corren_fornec.des_cta_corren          =  tt-conta.des_cta_corren         
                                           and     cta_corren_fornec.log_cta_corren_prefer   =  tt-conta.log_cta_corren_prefer  NO-ERROR.
              IF AVAIL cta_corren_fornec THEN
                  DELETE cta_corren_fornec.

              END.
              


          END.

run pi-cria-tt.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME D-Dialog
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
  HIDE FRAME f-main.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  ENABLE rt-buttom bt-ok 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
  ENABLE BROWSE-3 BUTTON-14 BUTTON-13 BUTTON-15 
      WITH FRAME f-main.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "ESRC713" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


RUN pi-cria-tt.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt D-Dialog 
PROCEDURE pi-cria-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ) = p-row NO-ERROR.

  EMPTY TEMP-TABLE tt-conta.

  FOR EACH cta_corren_fornec WHERE cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor 
                             AND   substring(cta_corren_fornec.cod_livre_2, 89, 11) <> " " NO-LOCK:


      FIND FIRST tt-conta WHERE tt-conta.cod_empresa           = cta_corren_fornec.cod_empresa           
                          and    tt-conta.cdn_fornecedor        = cta_corren_fornec.cdn_fornecedor        
                          and     tt-conta.cod_banco             = cta_corren_fornec.cod_banco             
                          and     tt-conta.cod_agenc_bcia        = cta_corren_fornec.cod_agenc_bcia        
                          and     tt-conta.cod_digito_agenc_bcia = cta_corren_fornec.cod_digito_agenc_bcia 
                          and     tt-conta.cod_cta_corren_bco    = cta_corren_fornec.cod_cta_corren_bco    
                          and     tt-conta.cod_digito_cta_corren = cta_corren_fornec.cod_digito_cta_corren NO-ERROR.

      IF NOT AVAIL tt-conta THEN DO:
          


      CREATE tt-conta.
      ASSIGN tt-conta.cod_empresa           = cta_corren_fornec.cod_empresa
             tt-conta.cdn_fornecedor        = cta_corren_fornec.cdn_fornecedor
             tt-conta.cod_banco             = cta_corren_fornec.cod_banco
             tt-conta.cod_agenc_bcia        = cta_corren_fornec.cod_agenc_bcia
             tt-conta.cod_digito_agenc_bcia = cta_corren_fornec.cod_digito_agenc_bcia
             tt-conta.cod_cta_corren_bco    = cta_corren_fornec.cod_cta_corren_bco
             tt-conta.cod_digito_cta_corren = cta_corren_fornec.cod_digito_cta_corren
             tt-conta.des_cta_corren        = cta_corren_fornec.des_cta_corren
             tt-conta.log_cta_corren_prefer = cta_corren_fornec.log_cta_corren_prefer.

      END.

  END.
  {&OPEN-QUERY-browse-3}
       APPLY 'value-changed' TO browse-3 IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-conta"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

