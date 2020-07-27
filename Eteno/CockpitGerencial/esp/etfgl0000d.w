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
DEFINE INPUT PARAM  p-cod-programa AS char.
DEFINE OUTPUT param l-data-1      AS LOGICAL.
DEFINE OUTPUT param l-data-2      AS LOGICAL.
DEFINE OUTPUT param l-data-3      AS LOGICAL.
DEFINE OUTPUT param l-data-4      AS LOGICAL.
DEFINE OUTPUT param c-usuar-1     AS char.
DEFINE OUTPUT param c-usuar-2     AS char.
DEFINE OUTPUT param c-usuar-3     AS char.
DEFINE OUTPUT param c-usuar-4     AS char.
DEFINE OUTPUT param d-alteracao-1 AS date.
DEFINE OUTPUT param d-alteracao-2 AS date.
DEFINE OUTPUT param d-alteracao-3 AS date.
DEFINE OUTPUT param d-alteracao-4 AS date.




/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-26 d-1 d-2 d-3 d-4 bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS d-1 d-2 d-3 d-4 FILL-IN-2 

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

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.43 BY 6.33.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE d-1 AS LOGICAL INITIAL no 
     LABEL "1.a Semana" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE d-2 AS LOGICAL INITIAL no 
     LABEL "2.a Semana" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE d-3 AS LOGICAL INITIAL no 
     LABEL "3.a Semana" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE d-4 AS LOGICAL INITIAL no 
     LABEL "4.a Semana" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     d-1 AT ROW 4.21 COL 3.57 WIDGET-ID 4
     d-2 AT ROW 5.38 COL 3.57 WIDGET-ID 10
     d-3 AT ROW 6.54 COL 3.57 WIDGET-ID 8
     d-4 AT ROW 7.71 COL 3.57 WIDGET-ID 6
     FILL-IN-2 AT ROW 8.79 COL 1.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     bt-ok AT ROW 12.54 COL 3
     bt-cancela AT ROW 12.54 COL 14
     bt-ajuda AT ROW 12.54 COL 59
     "Quais semanas voce esta conciliando?" VIEW-AS TEXT
          SIZE 47.43 BY .67 AT ROW 1.75 COL 1.86 WIDGET-ID 16
          BGCOLOR 14 FGCOLOR 12 
     rt-buttom AT ROW 12.29 COL 2
     RECT-26 AT ROW 3.63 COL 1.57 WIDGET-ID 12
     SPACE(1.85) SKIP(3.91)
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

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
&Scoped-define SELF-NAME d-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-1 D-Dialog
ON VALUE-CHANGED OF d-1 IN FRAME D-Dialog /* 1.a Semana */
DO:
  
    ASSIGN c-usuar-1 = v_cod_usuar_corren
           d-alteracao-1 = NOW
           l-data-1 = INPUT FRAME {&FRAME-NAME} d-1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-2 D-Dialog
ON VALUE-CHANGED OF d-2 IN FRAME D-Dialog /* 2.a Semana */
DO:
    ASSIGN c-usuar-2 = v_cod_usuar_corren
         d-alteracao-2 = NOW
        l-data-2 = INPUT FRAME {&FRAME-NAME} d-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-3 D-Dialog
ON VALUE-CHANGED OF d-3 IN FRAME D-Dialog /* 3.a Semana */
DO:
    ASSIGN c-usuar-3 = v_cod_usuar_corren
         d-alteracao-3 = NOW
        l-data-3 = INPUT FRAME {&FRAME-NAME} d-3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-4 D-Dialog
ON VALUE-CHANGED OF d-4 IN FRAME D-Dialog /* 4.a Semana */
DO:
    ASSIGN c-usuar-4 = v_cod_usuar_corren
         d-alteracao-4 = NOW
        l-data-4 = INPUT FRAME {&FRAME-NAME} d-4.

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
  DISPLAY d-1 d-2 d-3 d-4 FILL-IN-2 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom RECT-26 d-1 d-2 d-3 d-4 bt-ok bt-cancela bt-ajuda 
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

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN fill-in-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-cod-programa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email D-Dialog 
PROCEDURE pi-envia-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/utapi019.i}


    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.

    

    /* */
    ASSIGN cCabecEmail  = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">               
                            <html>
                             <head>
                                 <meta http-equiv="content-type" content="text/html; charset=windows-1250">
                                 <title>Criacao de novo ITEM</title>
                             </head>
                             <body>            
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Prezados,  </br></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">O fechamento referente a semana ' +  </br></p>
                                 <p></p>'
           cCorpoEmail  = '      <p><font style = "font-family: Verdana; font-size: 11px;">Item: ' + SUBSTRING(p-table.it-codigo,1,6) + ' - ' + p-table.desc-item + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Controle de Estoque ' + ' - ' + {ininc/i09in122.i 04 p-table.tipo-contr} + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Grupo de Estoque: ' + STRING(p-table.ge-codigo) + ' - ' + grup-estoque.descricao + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Criacao realizad por: ' + TRIM(c-usuario) + ' </br></p>
                                 <p></p> <p></p>'
           cRodapeEmail = '      <p><font style = "font-family: Verdana; font-size: 11px;">PS: Este email foi enviado automaticamente pelo sistema, por favor, nao responda. </br></p>
                             </body>
                            </html>'.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = cCabecEmail.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 2
           tt-mensagem.mensagem     = cCorpoEmail.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 3
           tt-mensagem.mensagem     = cRodapeEmail.
    /* */

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.remetente         = 'eteno@eteno.com.br'
           tt-envio2.destino           = 'rosangela.santos@eteno.com.br'
           tt-envio2.copia             = 'gedalva.santana@eteno.com.br'
           tt-envio2.assunto           = 'Criacao de um novo Item ' + p-table.it-codigo
           tt-envio2.importancia       = 2
           tt-envio2.log-enviada       = NO
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.formato           = 'HTML'.
           
           

    run utp/ut-utils.p persistent set h-diretorio.
    run setcurrentdir in h-diretorio(input session:temp-directory).

    run utp/utapi019.p persistent set h-utapi019.
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute2 in h-utapi019 (input table tt-envio2,
                                   input table tt-mensagem,
                                   output table tt-erros).
    output close.

    delete procedure h-utapi019.
    delete procedure h-diretorio.
    return 'ok'.

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

