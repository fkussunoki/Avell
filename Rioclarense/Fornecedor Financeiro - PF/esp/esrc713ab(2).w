&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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


DEF INPUT param p-row-id AS recid.
DEF INPUT param p-cpf    AS char.
DEF INPUT param p-banco   AS char.
DEF INPUT param p-agencia AS char.
DEF INPUT param p-conta AS char.

/* Local Variable Definitions ---                                       */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

     DEF NEW global SHARED VAR v_rec_banco AS RECID NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-2 c-banco c-agencia ~
c-dig-agencia c-cta c-dig-cta c-descricao l-prefer l-poupanca bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-banco c-agencia c-dig-agencia c-cta ~
c-dig-cta c-descricao l-prefer l-poupanca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-agencia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Agencia" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-banco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descricao" 
     VIEW-AS FILL-IN 
     SIZE 29.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-dig-agencia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-dig-cta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 11.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 40.43 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-poupanca AS LOGICAL INITIAL no 
     LABEL "Poupanca" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-prefer AS LOGICAL INITIAL no 
     LABEL "Preferencial" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-banco AT ROW 2 COL 11 COLON-ALIGNED WIDGET-ID 4
     c-agencia AT ROW 3.08 COL 11 COLON-ALIGNED WIDGET-ID 6
     c-dig-agencia AT ROW 3.08 COL 25.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-cta AT ROW 4.21 COL 10.86 COLON-ALIGNED WIDGET-ID 10
     c-dig-cta AT ROW 4.21 COL 25.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-descricao AT ROW 5.75 COL 10.86 COLON-ALIGNED WIDGET-ID 14
     l-prefer AT ROW 6.92 COL 2.86 WIDGET-ID 18
     l-poupanca AT ROW 6.92 COL 26.72 WIDGET-ID 20
     bt-ok AT ROW 12.54 COL 3
     bt-cancela AT ROW 12.54 COL 14
     bt-ajuda AT ROW 12.58 COL 31.86
     rt-buttom AT ROW 12.29 COL 2
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 16
     SPACE(0.56) SKIP(1.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


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
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    

   IF LOGICAL(l-prefer:SCREEN-VALUE IN FRAME {&FRAME-NAME})= YES THEN DO:
       
   
    
    FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ)= p-row-id NO-ERROR.


        FIND FIRST cta_corren_fornec NO-LOCK WHERE cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
                                             AND   cta_corren_fornec.log_cta_corren_prefer = YES NO-ERROR.
        IF AVAIL cta_corren_fornec THEN DO:
            

            MESSAGE 'nao ‚ permitido ter duas contas preferenciais para um mesmo fornecedor' VIEW-AS ALERT-BOX.
            RETURN.
        END.
    
        RUN pi-altera.

END.

    RUN pi-altera.


  apply "close":U to this-procedure.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-banco D-Dialog
ON F5 OF c-banco IN FRAME D-Dialog /* Banco */
DO:
      run prgint/utb/utb098ka.p /*prg_sea_banco*/.
  if  v_rec_banco <> ?
  then do:
      find emsbas.banco where recid(banco) = v_rec_banco no-lock no-error.
      assign c-banco:screen-value in frame {&FRAME-NAME} =
             string(banco.cod_banco).
      END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-banco D-Dialog
ON MOUSE-SELECT-DBLCLICK OF c-banco IN FRAME D-Dialog /* Banco */
DO:
  APPLY 'f5' TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY c-banco c-agencia c-dig-agencia c-cta c-dig-cta c-descricao l-prefer 
          l-poupanca 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom RECT-2 c-banco c-agencia c-dig-agencia c-cta c-dig-cta 
         c-descricao l-prefer l-poupanca bt-ok bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

  {utp/ut9000.i "D99XX999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ) = p-row-id NO-ERROR.
  IF p-cpf <> "" THEN 
      ASSIGN substring(fornec_financ.cod_livre_2, 86, 3) = "yes"
             SUBSTRING(fornec_financ.cod_livre_2, 89, 11) = p-cpf.


    FIND FIRST cta_corren_fornec WHERE cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
                                 AND   cta_corren_fornec.cod_banco      = p-banco
                                 AND   cta_corren_fornec.cod_agenc_bcia = p-agencia
                                 AND   cta_corren_fornec.cod_cta_corren_bco = p-conta NO-ERROR.

    ASSIGN c-banco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.cod_banco
           c-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.cod_agenc_bcia
           c-dig-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.cod_digito_agenc_bcia
           c-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.cod_cta_corren_bco
           c-dig-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.cod_digito_cta_corren
           c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cta_corren_fornec.des_cta_corren
           l-prefer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(cta_corren_fornec.log_cta_corren_prefer)
           l-poupanca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = substring(cta_corren_fornec.cod_livre_2, 100, 3).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera D-Dialog 
PROCEDURE pi-altera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ)= p-row-id NO-ERROR.

    FIND FIRST cta_corren_fornec         WHERE cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
                                         AND   cta_corren_fornec.cod_banco      = p-banco
                                         AND   cta_corren_fornec.cod_agenc_bcia = p-agencia
                                         AND   cta_corren_fornec.cod_cta_corren_bco = p-conta NO-ERROR.


    IF avail cta_corren_fornec THEN DO:

        ASSIGN cta_corren_fornec.cod_empresa = v_cod_empres_usuar
               cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
               cta_corren_fornec.cod_banco      = c-banco:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_agenc_bcia = c-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_digito_agenc_bcia = c-dig-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_cta_corren_bco = c-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_digito_cta_corren = c-dig-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.des_cta_corren     = c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.log_cta_corren_prefer = LOGICAL(l-prefer:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            substring(cta_corren_fornec.cod_livre_2, 89, 11) = replace(replace(p-cpf, ".", ""), "-", "")
             substring(cta_corren_fornec.cod_livre_2, 100, 3) = INPUT FRAME {&FRAME-NAME} l-poupanca.
            .


    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar D-Dialog 
PROCEDURE pi-criar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF (c-banco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
OR c-agencia:SCREEN-VALU IN FRAME {&FRAME-NAME} = ""
OR c-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "" )  THEN DO:
    
    MESSAGE "Necessario preencher campos em branco (Banco, Agencia ou Conta)" VIEW-AS ALERT-BOX.
    RETURN.
END.


FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ)= p-row-id NO-ERROR.


    FIND FIRST cta_corren_fornec NO-LOCK WHERE cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
                                         AND   cta_corren_fornec.cod_banco      = c-banco:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                                         AND   cta_corren_fornec.cod_agenc_bcia = c-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                                         AND   cta_corren_fornec.cod_cta_corren_bco = c-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.


    IF NOT avail cta_corren_fornec THEN DO:
        CREATE cta_corren_fornec.
        ASSIGN cta_corren_fornec.cod_empresa = v_cod_empres_usuar
               cta_corren_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor
               cta_corren_fornec.cod_banco      = c-banco:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_agenc_bcia = c-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_digito_agenc_bcia = c-dig-agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_cta_corren_bco = c-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.cod_digito_cta_corren = c-dig-cta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               cta_corren_fornec.des_cta_corren     = c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               substring(cta_corren_fornec.cod_livre_2, 89, 11) = replace(replace(p-cpf, ".", ""), "-", "")
               substring(cta_corren_fornec.cod_livre_2, 100, 3) = INPUT FRAME {&FRAME-NAME} l-poupanca.


    END.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

