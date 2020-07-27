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
{include/i-prgvrs.i RESTCd1530 1.00.00.000}

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

/* Local Variable Definitions ---                                       */

    DEFINE VAR v_nat-oper AS CHAR VIEW-AS FILL-IN.
    DEFINE VAR l-logico AS LOGICAL.
    DEFINE BUTTON b_ok.
    DEFINE VAR i-cont AS INTEGER.

DEFINE VAR i-tot AS INTEGER.

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
&Scoped-Define ENABLED-OBJECTS rt-buttom c-nat bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-nat 

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

DEFINE VARIABLE c-nat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nat-Oper" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-nat AT ROW 2.83 COL 14.14 COLON-ALIGNED WIDGET-ID 2
     bt-ok AT ROW 12.54 COL 3
     bt-cancela AT ROW 12.54 COL 14
     bt-ajuda AT ROW 12.54 COL 59
     rt-buttom AT ROW 12.29 COL 2
     SPACE(0.85) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Ver restricao CD1530"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ver restricao CD1530 */
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
  
    ASSIGN v_nat-oper = INPUT FRAME {&FRAME-NAME} c-nat.

    MESSAGE "Arquivo gerado em " + SESSION:TEMP-DIRECTORY  + "natur-oper.txt" VIEW-AS ALERT-BOX.


    OUTPUT TO value(session:TEMP-DIRECTORY + "natur-oper.txt").      
                            /*Nat. n’o pode ser desativada, devido a exist¼ncia de documentos no receb. n’o atualizados*/ 

            IF  CAN-FIND (FIRST docum-est WHERE
                                docum-est.ce-atual = NO
                            AND docum-est.nat-operacao = v_nat-oper) THEN DO:

                RUN docum-est.



                end.

            /* Existem pedido de venda para esta natureza */

            if  can-find (first ped-venda where
                                ped-venda.nat-operacao =  v_nat-oper AND
                                ped-venda.cod-sit-ped  < 3) then do:

                RUN ped-venda.
            end.

            /* Existem itens de pedido para esta natureza */

            DO  i-cont = 1 TO 2:

                FOR EACH ped-venda WHERE
                         ped-venda.cod-sit-ped = i-cont NO-LOCK,
                    EACH ped-item OF ped-venda
                    WHERE ped-item.cod-sit-item < 3 AND
                          ped-item.nat-operacao = v_nat-oper NO-LOCK:
            RUN it-ped-venda.  
            RETURN.
                END.
            END.

            /* Existem documentos pendentes para esta natureza */

                 if  can-find (first  wt-docto WHERE 
                                      wt-docto.nat-operacao = v_nat-oper) then do:

        RUN wt-docto.

                 end.

                 if  can-find (first  wt-it-docto WHERE 
                                      wt-it-docto.nat-operacao = v_nat-oper or
                                      wt-it-docto.nat-docum = v_nat-oper) then do:

        RUN wt-it-docto.
                 end.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE docum-est D-Dialog 
PROCEDURE docum-est :
RUN utp/ut-perc.p PERSISTENT SET h-prog.

PUT "docum-est.............." SKIP.
         PUT "esp-docto; serie; nr-docto; emitente; dt-emissao" SKIP.
         FOR EACH               docum-est WHERE
                                docum-est.ce-atual = NO
                                AND docum-est.nat-operacao = v_nat-oper:
ASSIGN i-tot = i-tot + 1.
         END.
         
RUN pi-inicializar IN h-prog ("Docum-est", i-tot).    
         
         FOR EACH               docum-est WHERE
                                docum-est.ce-atual = NO
                                AND docum-est.nat-operacao = v_nat-oper:
RUN pi-acompanhar IN h-prog.

             PUT docum-est.esp-docto ";"
                 docum-est.serie-docto ";"
                 docum-est.nro-docto ";"
                 docum-est.cod-emitente ";"
                 docum-est.dt-emissao
                 SKIP.
             END.
RUN pi-finalizar IN h-prog.

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
  DISPLAY c-nat 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom c-nat bt-ok bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE it-ped-venda D-Dialog 
PROCEDURE it-ped-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    PUT "ped-venda............" SKIP.
    PUT "cod-est; nome; nr-pedido-cl; nr-pedido; emitente" SKIP.
RUN utp/ut-perc.p PERSISTENT SET h-prog.

                 FOR EACH ped-venda WHERE
                         ped-venda.cod-sit-ped = i-cont NO-LOCK,
                    EACH ped-item OF ped-venda
                    WHERE ped-item.cod-sit-item < 3 AND
                          ped-item.nat-operacao = v_nat-oper NO-LOCK:

ASSIGN i-tot = i-tot + 1.
                 END.


RUN pi-inicializar IN h-prog ("Ped-venda", i-tot).    
    FOR EACH ped-venda WHERE
                         ped-venda.cod-sit-ped = i-cont NO-LOCK,
                    EACH ped-item OF ped-venda
                    WHERE ped-item.cod-sit-item < 3 AND
                          ped-item.nat-operacao = v_nat-oper NO-LOCK:
RUN pi-acompanhar IN h-prog.
                      PUT ped-venda.cod-estabel ";"
                          ped-venda.nome-abrev ";"
                          ped-venda.nr-pedcli ";"
                          ped-venda.nr-pedido ";"
                          ped-venda.cod-emitente
                          SKIP.
    END.

RUN pi-finalizar IN h-prog.
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

  {utp/ut9000.i "RestCD1530" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ped-venda D-Dialog 
PROCEDURE ped-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        PUT "ped-venda.........." SKIP.
        PUT "estab; nome; ped-cliente; pedido; dt-emissao" SKIP.
RUN utp/ut-perc.p PERSISTENT SET h-prog.
        
        FOR EACH                ped-venda where
                                ped-venda.nat-operacao =  v_nat-oper AND
                                ped-venda.cod-sit-ped  < 3:
     ASSIGN i-tot = i-tot + 1.
        END.

RUN pi-inicializar IN h-prog ("Ped-venda", i-tot).          
        FOR EACH                ped-venda where
                                ped-venda.nat-operacao =  v_nat-oper AND
                                ped-venda.cod-sit-ped  < 3:
RUN pi-acompanhar IN h-prog.
            PUT ped-venda.cod-estabel ";"
                ped-venda.nome-abrev ";"
                ped-venda.nr-pedcli ";"
                ped-venda.nr-pedido ";"
                ped-venda.dt-emissao
                SKIP.
            END.
RUN pi-finalizar IN h-prog.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wt-docto D-Dialog 
PROCEDURE wt-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN utp/ut-perc.p PERSISTENT SET h-prog.        
        FOR EACH                      wt-docto WHERE 
                                      wt-docto.nat-operacao = v_nat-oper:
        
            ASSIGN i-tot = i-tot + 1.
        END.

        PUT "wt-docto.........." SKIP.
        PUT "estab; serie; nr-nota; nome; dt-emissao; nr.pedido" SKIP.
        
RUN pi-inicializar IN h-prog ("Wt-docto", i-tot).    
        
        FOR EACH                      wt-docto WHERE 
                                      wt-docto.nat-operacao = v_nat-oper:
            RUN pi-acompanhar IN h-prog.

            PUT wt-docto.cod-estabel ";"
                wt-docto.serie ";"
                wt-docto.nr-nota ";"
                wt-docto.nome-abrev ";"
                wt-docto.dt-emis-nota ";"
                wt-docto.nr-pedcli
                SKIP.

            END.
RUN pi-finalizar IN h-prog.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wt-it-docto D-Dialog 
PROCEDURE wt-it-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        PUT "wt-it-docto.........." SKIP.
        PUT "it-codigo; nr-docum" SKIP.
        FOR EACH wt-it-docto         WHERE 
                                      wt-it-docto.nat-operacao = v_nat-oper or
                                      wt-it-docto.nat-docum = v_nat-oper:

            PUT wt-it-docto.it-codigo ";"
                wt-it-docto.nr-docum
                SKIP.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

