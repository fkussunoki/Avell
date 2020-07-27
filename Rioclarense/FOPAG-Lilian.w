&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

DEFINE TEMP-TABLE tt-fp
    FIELD cdn_funcionario AS INTEGER
    FIELD cdn_empresa     AS char
    FIELD cdn_estab       AS char
    FIELD num_mes         AS INTEGER
    FIELD num_ano         AS INTEGER
    FIELD cdn_event_fp    AS char
    FIELD cdn_cta_efp_Db     AS char
    field cdn_cta_efp_cr     as char
    field cod_rh_ccusto_db   as char
    field cod_rh_ccusto_cr   as char
    field cod_unid_negoc  as char 
    FIELD percentual      AS char
    FIELD valor           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99" .

DEFINE VAR i AS INTEGER.

def var h-prog as handle.
def temp-table tt-erros
field cod_event as char.

DEFINE STREAM S1.
DEFINE STREAM S2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 c-ano c-mes BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS c-ano c-mes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-ano AS INTEGER FORMAT ">>>>":U INITIAL 0 
     LABEL "Ano" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-mes AS INTEGER FORMAT ">>":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.72 BY 5.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-ano AT ROW 2.13 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     c-mes AT ROW 3.88 COL 10.72 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 5.83 COL 12.57 WIDGET-ID 6
     RECT-1 AT ROW 1.33 COL 2.72 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 45.29 BY 6.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "FOPAG - BACA"
         HEIGHT             = 6.54
         WIDTH              = 45.29
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* FOPAG - BACA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* FOPAG - BACA */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* Executar */
DO:
  
RUN pi-executar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY c-ano c-mes 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 c-ano c-mes BUTTON-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN i = 1.


run utp/ut-acomp.p persistent set h-prog.

run pi-inicializar in h-prog(Input "Iniciando").

FOR EACH movto_calcul_func NO-LOCK WHERE movto_calcul_func.num_ano_refer_fp = INPUT FRAME {&FRAME-NAME} c-ano
                                   AND   movto_calcul_func.num_mes_refer_fp >= INPUT FRAME {&FRAME-NAME} c-mes
                                   AND   movto_calcul_func.num_mes_refer_fp <= INPUT FRAME {&FRAME-NAME} c-mes:

            FIND FIRST funcionario NO-LOCK WHERE funcionario.cdn_empresa = movto_calcul_func.cdn_empresa
                                           AND   funcionario.cdn_estab   = movto_calcul_func.cdn_estab
                                           AND   funcionario.cdn_funcionario  = movto_calcul_func.cdn_funcionario NO-ERROR.


                
            run pi-acompanhar in h-prog(Input "Ano" + string(movto_calcul_func.num_ano_refer_fp) + " Mes " + string(movto_calcul_func.num_mes_refer_fp) + "Func " + string(funcionario.cdn_funcionario) + " Estab " + movto_calcul_func.cdn_estab).

                       DO WHILE i < 31:                                                
 
                        FIND FIRST cta_mdo_efp NO-LOCK WHERE cta_mdo_efp.cdn_empresa = movto_calcul_func.cdn_empresa
                                                       AND   cta_mdo_efp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i]
                                                       AND   cta_mdo_efp.cod_tip_mdo  = funcionario.cod_tip_mdo NO-ERROR.
                        if avail cta_mdo_efp then do:
                               
                        CREATE tt-fp.
                        ASSIGN tt-fp.cdn_empresa                        = movto_calcul_func.cdn_empresa
                               tt-fp.cdn_funcionario                    = movto_calcul_func.cdn_funcionario
                               tt-fp.cdn_estab                          = movto_calcul_func.cdn_estab
                               tt-fp.num_mes                            = movto_calcul_func.num_mes_refer_fp
                               tt-fp.num_ano                            = movto_calcul_func.num_ano_refer_fp
                               tt-fp.cdn_event_fp                       = cta_mdo_efp.cdn_event_fp
                               tt-fp.cdn_cta_efp_db                     = cta_mdo_efp.cod_rh_cta_ctbl_db
                               tt-fp.cdn_cta_efp_cr                     = cta_mdo_efp.cod_rh_cta_ctbl_cr
                               tt-fp.cod_rh_ccusto_db                  = cta_mdo_efp.cod_rh_ccusto_db
                               tt-fp.cod_rh_ccusto_cr                  = cta_mdo_efp.cod_rh_ccusto_cr
                               tt-fp.cod_unid_negoc                     = funcionario.cod_unid_negoc
                               tt-fp.valor                              = movto_calcul_func.val_calcul_efp[i].
                                                
                        
                        END.

                        
                        if not avail cta_mdo_efp then do:
                        create tt-erros.
                        assign tt-erros.cod_event = movto_calcul_func.cdn_event_fp[i].
                        
                      end.
                      assign i = i + 1.
                  END.
                  assign i = 1.
         END.   
run pi-finalizar in h-prog.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Preparando Relatorio").

            FOR EACH tt-fp:


                FOR EACH perc_rat_ccusto NO-LOCK WHERE perc_rat_ccusto.cdn_funcionario = tt-fp.cdn_funcionario
                                                 AND   perc_rat_ccusto.cdn_empresa     = tt-fp.cdn_empresa
                                                 AND   perc_rat_ccusto.cdn_estab       = tt-fp.cdn_estab:

RUN pi-acompanhar IN h-prog(INPUT " Funcionario " + STRING(perc_rat_ccusto.cdn_funcionario) + " Empresa " + perc_rat_ccusto.cdn_empresa + " Estabel " + perc_rat_ccusto.cdn_estab_trab).

                    ASSIGN tt-fp.percentual = tt-fp.percentual + ";" + perc_rat_ccusto.cdn_estab_trab + ";" + perc_rat_ccusto.cod_rh_ccusto + ";" + perc_rat_ccusto.cod_unid_negoc + ";" + string(perc_rat_ccusto.val_val_perc_rat_ccusto).



            END.
     END.
RUN pi-finalizar IN h-prog.

     OUTPUT STREAM S1 TO c:\temp\folha.txt.
     PUT STREAM S1 UNFORMATTED "Funcionario" ";" "Estab" ";" "Mes" ";" "Ano" ";" "Evento" ";" "Cta_DB" ";" "Cta_Cr" ";" "UN" ";" "Vlr.Evt" ";" "Percentuais" ";"
         SKIP.




            FOR EACH tt-fp:


                PUT STREAM S1 UNFORMATTED tt-fp.cdn_funcionario ";"
                                TT-FP.cdn_estab       ";"
                                tt-fp.num_mes         ";"
                                tt-fp.num_ano         ";"
                                tt-fp.cdn_event    ";"
                                tt-fp.cdn_cta_efp_Db    ";" 
                                tt-fp.cdn_cta_efp_cr    ";"
                                tt-fp.cod_unid_negoc ";"
                                tt-fp.valor          ";"
                                tt-fp.percentual
 
                    SKIP.










            END.
            
                        OUTPUT STREAM S2 TO c:\temp\ERROS.txt.
FOR EACH TT-ERROS:
DISP STREAM S2 TT-ERROS.

END.

            
            message "fim" view-as alert-box.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

