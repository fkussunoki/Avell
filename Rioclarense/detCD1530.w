&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

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
DEFINE VAR h-prog AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-nat BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS c-nat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Ok" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-3 
     LABEL "Cancelar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-nat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nat-Oper" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-nat AT ROW 2.83 COL 14.14 COLON-ALIGNED WIDGET-ID 2
     BUTTON-2 AT ROW 5.5 COL 5.57 WIDGET-ID 4
     BUTTON-3 AT ROW 5.5 COL 20.72 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 41.29 BY 6.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Rest1530"
         HEIGHT             = 6.5
         WIDTH              = 41.86
         MAX-HEIGHT         = 42.38
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 42.38
         VIRTUAL-WIDTH      = 274.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Rest1530 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Rest1530 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Ok */
DO:
  
    ASSIGN v_nat-oper = INPUT FRAME {&FRAME-NAME} c-nat.



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

            RUN it-ped-venda.  
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

MESSAGE 'processo concluido' SKIP 
         "Arquivo gerado em " + SESSION:TEMP-DIRECTORY  + "natur-oper.txt" VIEW-AS ALERT-BOX.
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Cancelar */
DO:
  APPLY 'close' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE docum-est W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE c-nat BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE it-ped-venda W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ped-venda W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wt-docto W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wt-it-docto W-Win 
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

