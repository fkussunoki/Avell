&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF BUFFER b-dc-comis-trans FOR dc-comis-trans.

DEF NEW GLOBAL SHARED VAR v_rec_dc_comis_trans  AS RECID        NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_cta_ctbl  AS RECID        NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_cta_ctbl        AS RECID        NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_ccusto    AS RECID        NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_ccusto          AS RECID        NO-UNDO.

DEF VAR v_log_answer                            AS LOGICAL      NO-UNDO.
DEF VAR l-valida                                AS LOGICAL      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES emsdocol.dc-comis-trans

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame ~
emsdocol.dc-comis-trans.cod_transacao ~
emsdocol.dc-comis-trans.dat_inic_valid ~
emsdocol.dc-comis-trans.dat_fim_valid emsdocol.dc-comis-trans.descricao ~
emsdocol.dc-comis-trans.ind_tip_trans ~
emsdocol.dc-comis-trans.ind_incid_liquido ~
emsdocol.dc-comis-trans.ind_incid_ir ~
emsdocol.dc-comis-trans.log_perm_digitacao ~
emsdocol.dc-comis-trans.ind_tip_movto ~
emsdocol.dc-comis-trans.ind_incid_iss ~
emsdocol.dc-comis-trans.log_contabiliza 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
emsdocol.dc-comis-trans.dat_inic_valid ~
emsdocol.dc-comis-trans.dat_fim_valid emsdocol.dc-comis-trans.descricao ~
emsdocol.dc-comis-trans.ind_tip_movto ~
emsdocol.dc-comis-trans.log_contabiliza 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH emsdocol.dc-comis-trans SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH emsdocol.dc-comis-trans SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emsdocol.dc-comis-trans.dat_inic_valid ~
emsdocol.dc-comis-trans.dat_fim_valid emsdocol.dc-comis-trans.descricao ~
emsdocol.dc-comis-trans.ind_tip_movto ~
emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl ~
emsdocol.dc-comis-trans-ctb.cod_cta_ctbl ~
emsdocol.dc-comis-trans-ctb.cod_plano_ccusto emsdocol.dc-comis-trans-ctb.cod_ccusto ~
emsdocol.dc-comis-trans.log_contabiliza 
&Scoped-define ENABLED-TABLES emsdocol.dc-comis-trans emsdocol.dc-comis-trans-ctb
&Scoped-define FIRST-ENABLED-TABLE emsdocol.dc-comis-trans
&Scoped-define SECOND-ENABLED-TABLE dc-comis-trans-ctb
&Scoped-Define ENABLED-OBJECTS bt-zoom-plano-cta-ctbl bt-zoom-cta-ctbl ~
bt-zoom-cod-plano-ccusto bt-zoom-ccusto bt-ok bt-salva bt-cancela ~
bt-anterior bt-pesquisa bt-proximo bt-ajuda RECT-7 rt-chave rt-contabil ~
rt-financeiro 
&Scoped-Define DISPLAYED-FIELDS emsdocol.dc-comis-trans.cod_transacao ~
emsdocol.dc-comis-trans.dat_inic_valid ~
emsdocol.dc-comis-trans.dat_fim_valid emsdocol.dc-comis-trans.descricao ~
emsdocol.dc-comis-trans.ind_tip_trans ~
emsdocol.dc-comis-trans.ind_incid_liquido ~
emsdocol.dc-comis-trans.ind_incid_ir ~
emsdocol.dc-comis-trans.log_perm_digitacao ~
emsdocol.dc-comis-trans.ind_tip_movto ~
emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl ~
emsdocol.dc-comis-trans-ctb.cod_cta_ctbl ~
emsdocol.dc-comis-trans-ctb.cod_plano_ccusto emsdocol.dc-comis-trans-ctb.cod_ccusto ~
emsdocol.dc-comis-trans.ind_incid_iss ~
emsdocol.dc-comis-trans.log_contabiliza 
&Scoped-define DISPLAYED-TABLES emsdocol.dc-comis-trans emsdocol.dc-comis-trans-ctb
&Scoped-define FIRST-DISPLAYED-TABLE emsdocol.dc-comis-trans
&Scoped-define SECOND-DISPLAYED-TABLE dc-comis-trans-ctb


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-anterior 
     IMAGE-UP FILE "Image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-pre1.bmp":U
     LABEL "Anterior" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-pesquisa 
     IMAGE-UP FILE "Image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-sea1.bmp":U
     LABEL "Pesquisa" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-proximo 
     IMAGE-UP FILE "Image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-nex1.bmp":U
     LABEL "Pr¢ximo" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-salva DEFAULT 
     LABEL "Salva" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-zoom-ccusto 
     IMAGE-UP FILE "Image/im-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-zoo.bmp":U
     LABEL "Centro Custo" 
     SIZE 4 BY .88.

DEFINE BUTTON bt-zoom-cod-plano-ccusto 
     IMAGE-UP FILE "Image/im-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-zoo.bmp":U
     LABEL "Plano Centro Custo" 
     SIZE 4 BY .88.

DEFINE BUTTON bt-zoom-cta-ctbl 
     IMAGE-UP FILE "Image/im-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-zoo.bmp":U
     LABEL "Conta Cont†bil" 
     SIZE 4 BY .88.

DEFINE BUTTON bt-zoom-plano-cta-ctbl 
     IMAGE-UP FILE "Image/im-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-zoo.bmp":U
     LABEL "Plano Conta Cont†bil" 
     SIZE 4 BY .88.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rt-chave
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 2.5.

DEFINE RECTANGLE rt-contabil
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 4.5.

DEFINE RECTANGLE rt-financeiro
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 5.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      emsdocol.dc-comis-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     emsdocol.dc-comis-trans.cod_transacao AT ROW 1.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
          BGCOLOR 15 FONT 2
     emsdocol.dc-comis-trans.dat_inic_valid AT ROW 2.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
          BGCOLOR 15 FONT 2
     emsdocol.dc-comis-trans.dat_fim_valid AT ROW 2.5 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
          BGCOLOR 15 FONT 2
     emsdocol.dc-comis-trans.descricao AT ROW 4.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
          BGCOLOR 15 FONT 2
     emsdocol.dc-comis-trans.ind_tip_trans AT ROW 5.25 COL 20 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 8
          LIST-ITEMS "Adiantamento","DelCredere","Estorno Vendor","GenÇrico","Indenizaá∆o","Imposto Renda","Rescis∆o" 
          DROP-DOWN-LIST
          SIZE 18 BY 1
          BGCOLOR 15 FONT 2
     emsdocol.dc-comis-trans.ind_incid_liquido AT ROW 7.25 COL 20 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "Positivo","Negativo","N∆o Incide" 
          DROP-DOWN-LIST
          SIZE 18 BY 1
          BGCOLOR 15 
     emsdocol.dc-comis-trans.ind_incid_ir AT ROW 8.25 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     emsdocol.dc-comis-trans.log_perm_digitacao AT ROW 8.25 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     emsdocol.dc-comis-trans.ind_tip_movto AT ROW 10.75 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", yes,
"CrÇdito", no
          SIZE 33 BY .88
     emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl AT ROW 11.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
          BGCOLOR 15 FONT 2
     bt-zoom-plano-cta-ctbl AT ROW 11.75 COL 32.29
     emsdocol.dc-comis-trans-ctb.cod_cta_ctbl AT ROW 12.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
          BGCOLOR 15 FONT 2
     bt-zoom-cta-ctbl AT ROW 12.75 COL 37.29
     emsdocol.dc-comis-trans-ctb.cod_plano_ccusto AT ROW 11.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
          BGCOLOR 15 FONT 2
     bt-zoom-cod-plano-ccusto AT ROW 11.75 COL 66.29
     emsdocol.dc-comis-trans-ctb.cod_ccusto AT ROW 12.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .88
          BGCOLOR 15 FONT 2
     bt-zoom-ccusto AT ROW 12.75 COL 68.29
     bt-ok AT ROW 14.5 COL 3
     bt-salva AT ROW 14.5 COL 14
     bt-cancela AT ROW 14.5 COL 25
     bt-anterior AT ROW 14.5 COL 42
     bt-pesquisa AT ROW 14.5 COL 47
     bt-proximo AT ROW 14.5 COL 52
     bt-ajuda AT ROW 14.5 COL 71
     emsdocol.dc-comis-trans.ind_incid_iss AT ROW 6.25 COL 20 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "Positivo","Negativo","N∆o Incide" 
          DROP-DOWN-LIST
          SIZE 18 BY 1
     emsdocol.dc-comis-trans.log_contabiliza AT ROW 9.75 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     RECT-7 AT ROW 14.25 COL 2
     rt-chave AT ROW 1.25 COL 2
     rt-contabil AT ROW 9.5 COL 2
     rt-financeiro AT ROW 4 COL 2
     "Tipo Movto:" VIEW-AS TEXT
          SIZE 8.29 BY .88 AT ROW 10.75 COL 13
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     "(?)" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 12.83 COL 72.72
     SPACE(8.27) SKIP(2.62)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Modifica Transaá∆o de Comiss∆o - DCO001B".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Dialog-Frame 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob504.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   Custom                                                               */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN emsdocol.dc-comis-trans.cod_transacao IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX emsdocol.dc-comis-trans.ind_incid_ir IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX emsdocol.dc-comis-trans.ind_incid_iss IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX emsdocol.dc-comis-trans.ind_incid_liquido IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX emsdocol.dc-comis-trans.ind_tip_trans IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX emsdocol.dc-comis-trans.log_perm_digitacao IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "emsdocol.dc-comis-trans"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Modifica Transaá∆o de Comiss∆o - DCO001B */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-anterior Dialog-Frame
ON CHOOSE OF bt-anterior IN FRAME Dialog-Frame /* Anterior */
DO:
    RUN pi-verifica-alteracao.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.
    GET PREV {&FRAME-NAME}.
    IF  NOT AVAIL dc-comis-trans THEN
        GET FIRST {&FRAME-NAME}.
    RUN pi-display.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela Dialog-Frame
ON CHOOSE OF bt-cancela IN FRAME Dialog-Frame /* Cancela */
DO:
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok Dialog-Frame
ON CHOOSE OF bt-ok IN FRAME Dialog-Frame /* OK */
DO:
    RUN pi-salvar.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa Dialog-Frame
ON CHOOSE OF bt-pesquisa IN FRAME Dialog-Frame /* Pesquisa */
DO:
    RUN pi-verifica-alteracao.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.

    DEF VAR v-rec-aux   AS RECID    NO-UNDO.
    ASSIGN  v-rec-aux   = v_rec_dc_comis_trans.

    RUN dozoom/dco001z1.w.

    IF  v_rec_dc_comis_trans <> ? THEN DO:
        REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
        GET NEXT {&FRAME-NAME}.
        RUN pi-display.
    END.

    ASSIGN  v_rec_dc_comis_trans = v-rec-aux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-proximo Dialog-Frame
ON CHOOSE OF bt-proximo IN FRAME Dialog-Frame /* Pr¢ximo */
DO:
    RUN pi-verifica-alteracao.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.
    GET NEXT {&FRAME-NAME}.
    IF  NOT AVAIL dc-comis-trans THEN
        GET LAST {&FRAME-NAME}.
    RUN pi-display.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva Dialog-Frame
ON CHOOSE OF bt-salva IN FRAME Dialog-Frame /* Salva */
DO:
    RUN pi-salvar.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-ccusto Dialog-Frame
ON CHOOSE OF bt-zoom-ccusto IN FRAME Dialog-Frame /* Centro Custo */
DO:
    RUN prgint/utb/utb066ka.p.
                         
    IF  v_rec_ccusto <> ? THEN DO:
        FIND FIRST emsuni.ccusto NO-LOCK
             WHERE RECID(emsuni.ccusto) = v_rec_ccusto NO-ERROR.
        DISPLAY emsuni.ccusto.cod_ccusto @ dc-comis-trans-ctb.cod_ccusto WITH FRAME {&FRAME-NAME}.
    END.                                                                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom-cod-plano-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-cod-plano-ccusto Dialog-Frame
ON CHOOSE OF bt-zoom-cod-plano-ccusto IN FRAME Dialog-Frame /* Plano Centro Custo */
DO:
    RUN prgint/utb/utb083ka.p.
                         
    IF  v_rec_plano_ccusto <> ? THEN DO:
        FIND FIRST plano_ccusto NO-LOCK
             WHERE RECID(plano_ccusto) = v_rec_plano_ccusto NO-ERROR.
        DISPLAY plano_ccusto.cod_plano_ccusto @ dc-comis-trans-ctb.cod_plano_ccusto WITH FRAME {&FRAME-NAME}.
    END.   
    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_plano_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom-cta-ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-cta-ctbl Dialog-Frame
ON CHOOSE OF bt-zoom-cta-ctbl IN FRAME Dialog-Frame /* Conta Cont†bil */
DO:
    RUN prgint/utb/utb080nc.p.
                         
    IF  v_rec_cta_ctbl <> ? THEN DO:
        FIND FIRST cta_ctbl NO-LOCK
             WHERE RECID(cta_ctbl) = v_rec_cta_ctbl NO-ERROR.
        DISPLAY cta_ctbl.cod_cta_ctbl   @ dc-comis-trans-ctb.cod_cta_ctbl WITH FRAME {&FRAME-NAME}.
        APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_cta_ctbl.
    END.                                                                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom-plano-cta-ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-plano-cta-ctbl Dialog-Frame
ON CHOOSE OF bt-zoom-plano-cta-ctbl IN FRAME Dialog-Frame /* Plano Conta Cont†bil */
DO:
    RUN prgint/utb/utb080ka.p.
                         
    IF  v_rec_plano_cta_ctbl <> ? THEN DO:
        FIND FIRST plano_cta_ctbl NO-LOCK
             WHERE RECID(plano_cta_ctbl) = v_rec_plano_cta_ctbl NO-ERROR.
        DISPLAY plano_cta_ctbl.cod_plano_cta_ctbl   @ dc-comis-trans-ctb.cod_plano_cta_ctbl WITH FRAME {&FRAME-NAME}.
    END.
    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emsdocol.dc-comis-trans-ctb.cod_cta_ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emsdocol.dc-comis-trans-ctb.cod_cta_ctbl Dialog-Frame
ON LEAVE OF emsdocol.dc-comis-trans-ctb.cod_cta_ctbl IN FRAME Dialog-Frame /* Conta Cont†bil */
DO:
    ASSIGN  l-valida = NO.

    FOR EACH criter_distrib_cta_ctbl NO-LOCK
       WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = INPUT dc-comis-trans-ctb.cod_plano_cta_ctbl
         AND criter_distrib_cta_ctbl.cod_cta_ctbl       = INPUT dc-comis-trans-ctb.cod_cta_ctbl
         AND criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_usuar :
        
        IF  criter_distrib_cta_ctbl.dat_fim_valid  < TODAY OR
            criter_distrib_cta_ctbl.dat_inic_valid > TODAY THEN NEXT.

        CASE  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto :
            WHEN 'N∆o Utiliza'      THEN NEXT.
            WHEN 'Utiliza Todos'    THEN ASSIGN  l-valida = YES.
            WHEN 'Definidos'        THEN ASSIGN  l-valida = YES.
        END CASE. 
    END. /*FOR EACH criter_distrib_cta_ctbl NO-LOCK*/

    ASSIGN  dc-comis-trans-ctb.cod_plano_ccusto :SENSITIVE  = l-valida
            bt-zoom-cod-plano-ccusto            :SENSITIVE  = l-valida
            dc-comis-trans-ctb.cod_ccusto       :SENSITIVE  = l-valida
            bt-zoom-ccusto                      :SENSITIVE  = l-valida.  
    IF  NOT l-valida THEN
        ASSIGN  dc-comis-trans-ctb.cod_plano_ccusto:SCREEN-VALUE = ''
                dc-comis-trans-ctb.cod_ccusto      :SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emsdocol.dc-comis-trans-ctb.cod_plano_ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emsdocol.dc-comis-trans-ctb.cod_plano_ccusto Dialog-Frame
ON LEAVE OF emsdocol.dc-comis-trans-ctb.cod_plano_ccusto IN FRAME Dialog-Frame /* Plano CCusto */
DO:
    FIND FIRST plano_ccusto NO-LOCK
         WHERE plano_ccusto.cod_plano_ccusto = dc-comis-trans-ctb.cod_plano_ccusto:SCREEN-VALUE NO-ERROR.
    ASSIGN  dc-comis-trans-ctb.cod_ccusto:FORMAT = IF  AVAIL plano_ccusto THEN plano_ccusto.cod_format_ccusto ELSE 'X(11)'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl Dialog-Frame
ON LEAVE OF emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl IN FRAME Dialog-Frame /* Plano de Contas */
DO:
    IF  dc-comis-trans-ctb.cod_plano_cta_ctbl:SCREEN-VALUE = '' THEN DO:
        ASSIGN  dc-comis-trans-ctb.cod_cta_ctbl :SCREEN-VALUE   = ''
                dc-comis-trans-ctb.cod_cta_ctbl :SENSITIVE      = NO
                bt-zoom-cta-ctbl                :SENSITIVE      = NO.
    END.
    ELSE DO:
        FIND FIRST plano_cta_ctbl NO-LOCK 
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = dc-comis-trans-ctb.cod_plano_cta_ctbl:SCREEN-VALUE NO-ERROR.
        ASSIGN  dc-comis-trans-ctb.cod_cta_ctbl:FORMAT    = IF  AVAIL plano_cta_ctbl THEN  plano_cta_ctbl.cod_format_cta_ctbl ELSE 'X(20)'
                dc-comis-trans-ctb.cod_cta_ctbl:SENSITIVE = YES 
                bt-zoom-cta-ctbl               :SENSITIVE = YES.
    END.
    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emsdocol.dc-comis-trans.log_contabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emsdocol.dc-comis-trans.log_contabiliza Dialog-Frame
ON VALUE-CHANGED OF emsdocol.dc-comis-trans.log_contabiliza IN FRAME Dialog-Frame /* Contabiliza */
DO:
  IF INPUT FRAME {&FRAME-NAME} dc-comis-trans.log_contabiliza THEN
     ENABLE dc-comis-trans.ind_tip_movto
            dc-comis-trans-ctb.cod_plano_cta_ctbl
            bt-zoom-plano-cta-ctbl
            dc-comis-trans-ctb.cod_cta_ctbl
            bt-zoom-cta-ctbl
            dc-comis-trans-ctb.cod_plano_ccusto
            bt-zoom-cod-plano-ccusto
            dc-comis-trans-ctb.cod_ccusto
            bt-zoom-ccusto WITH FRAME {&FRAME-NAME}.
  ELSE
     DISABLE dc-comis-trans.ind_tip_movto
             dc-comis-trans-ctb.cod_plano_cta_ctbl
             bt-zoom-plano-cta-ctbl
             dc-comis-trans-ctb.cod_cta_ctbl
             bt-zoom-cta-ctbl
             dc-comis-trans-ctb.cod_plano_ccusto
             bt-zoom-cod-plano-ccusto
             dc-comis-trans-ctb.cod_ccusto
             bt-zoom-ccusto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    
    RUN enable_UI.
    RUN pi-initialize.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  IF AVAILABLE emsdocol.dc-comis-trans THEN DO:
     FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = emsdocol.dc-comis-trans.cod_transacao
                                     AND dc-comis-trans-ctb.dat_inic_valid = emsdocol.dc-comis-trans.dat_inic_valid 
                                     AND dc-comis-trans-ctb.cod_empresa    = v_cod_empres_usuar NO-LOCK NO-ERROR.
     IF AVAILABLE emsdocol.dc-comis-trans-ctb THEN
         DISPLAY emsdocol.dc-comis-trans.cod_transacao 
                 emsdocol.dc-comis-trans.dat_inic_valid 
                 emsdocol.dc-comis-trans.dat_fim_valid 
                 emsdocol.dc-comis-trans.descricao 
                 emsdocol.dc-comis-trans.ind_tip_trans 
                 emsdocol.dc-comis-trans.ind_incid_liquido 
                 emsdocol.dc-comis-trans.ind_incid_ir 
                 emsdocol.dc-comis-trans.log_perm_digitacao 
                 emsdocol.dc-comis-trans.ind_tip_movto 
                 emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl 
                 emsdocol.dc-comis-trans-ctb.cod_cta_ctbl 
                 emsdocol.dc-comis-trans-ctb.cod_plano_ccusto 
                 emsdocol.dc-comis-trans-ctb.cod_ccusto 
                 emsdocol.dc-comis-trans.ind_incid_iss 
                 emsdocol.dc-comis-trans.log_contabiliza 
             WITH FRAME Dialog-Frame.
     ELSE 
         DISPLAY emsdocol.dc-comis-trans.cod_transacao 
                 emsdocol.dc-comis-trans.dat_inic_valid 
                 emsdocol.dc-comis-trans.dat_fim_valid 
                 emsdocol.dc-comis-trans.descricao 
                 emsdocol.dc-comis-trans.ind_tip_trans 
                 emsdocol.dc-comis-trans.ind_incid_liquido 
                 emsdocol.dc-comis-trans.ind_incid_ir 
                 emsdocol.dc-comis-trans.log_perm_digitacao 
                 emsdocol.dc-comis-trans.ind_tip_movto 
                 "" @ emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl 
                 "" @ emsdocol.dc-comis-trans-ctb.cod_cta_ctbl 
                 "" @ emsdocol.dc-comis-trans-ctb.cod_plano_ccusto 
                 "" @ emsdocol.dc-comis-trans-ctb.cod_ccusto 
                 emsdocol.dc-comis-trans.ind_incid_iss 
                 emsdocol.dc-comis-trans.log_contabiliza 
             WITH FRAME Dialog-Frame.
  END.
  ENABLE emsdocol.dc-comis-trans.dat_inic_valid 
         emsdocol.dc-comis-trans.dat_fim_valid 
         emsdocol.dc-comis-trans.descricao 
         emsdocol.dc-comis-trans.ind_tip_movto 
         emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl bt-zoom-plano-cta-ctbl 
         emsdocol.dc-comis-trans-ctb.cod_cta_ctbl bt-zoom-cta-ctbl 
         emsdocol.dc-comis-trans-ctb.cod_plano_ccusto bt-zoom-cod-plano-ccusto 
         emsdocol.dc-comis-trans-ctb.cod_ccusto bt-zoom-ccusto bt-ok bt-salva 
         bt-cancela bt-anterior bt-pesquisa bt-proximo bt-ajuda 
         emsdocol.dc-comis-trans.log_contabiliza RECT-7 rt-chave rt-contabil 
         rt-financeiro 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display Dialog-Frame 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISPLAY {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME {&FRAME-NAME}.

    FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = emsdocol.dc-comis-trans.cod_transacao
                                AND dc-comis-trans-ctb.dat_inic_valid = emsdocol.dc-comis-trans.dat_inic_valid 
                                AND dc-comis-trans-ctb.cod_empresa    = v_cod_empres_usuar NO-LOCK NO-ERROR.
    IF AVAILABLE emsdocol.dc-comis-trans-ctb THEN
        DISPLAY emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl 
                emsdocol.dc-comis-trans-ctb.cod_cta_ctbl 
                emsdocol.dc-comis-trans-ctb.cod_plano_ccusto 
                emsdocol.dc-comis-trans-ctb.cod_ccusto 
            WITH FRAME Dialog-Frame.
    ELSE 
        DISPLAY "" @ emsdocol.dc-comis-trans-ctb.cod_plano_cta_ctbl 
                "" @ emsdocol.dc-comis-trans-ctb.cod_cta_ctbl 
                "" @ emsdocol.dc-comis-trans-ctb.cod_plano_ccusto 
                "" @ emsdocol.dc-comis-trans-ctb.cod_ccusto        
            WITH FRAME Dialog-Frame.

    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_cta_ctbl.
    APPLY 'LEAVE' TO dc-comis-trans-ctb.cod_plano_ccusto.
    APPLY "value-changed" TO dc-comis-trans.log_contabiliza.

    ASSIGN  v_rec_dc_comis_trans = RECID(dc-comis-trans).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initialize Dialog-Frame 
PROCEDURE pi-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    REPOSITION {&FRAME-NAME} TO RECID v_rec_dc_comis_trans.
    GET NEXT {&FRAME-NAME}.

    RUN pi-display.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar Dialog-Frame 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST b-dc-comis-trans NO-LOCK
         WHERE b-dc-comis-trans.cod_transacao    = INPUT FRAME {&FRAME-NAME} dc-comis-trans.cod_transacao 
           AND b-dc-comis-trans.dat_inic_valid  <= INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_fim_valid
           AND b-dc-comis-trans.dat_fim_valid   >= INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_inic_valid
           AND RECID(b-dc-comis-trans)          <> RECID(dc-comis-trans) NO-ERROR.
    IF  AVAIL b-dc-comis-trans THEN DO:
        RUN MESSAGE.p ('C¢digo j† cadastrado no per°odo informado.',
                       'Informe um c¢digo novo ou ajuste o per°odo para que n∆o sobreponha um outro per°odo da mesma transaá∆o.').
        APPLY 'ENTRY' TO dc-comis-trans.cod_transacao IN FRAME {&FRAME-NAME}.
        RETURN 'NOK'.
    END.

    IF INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_liquido = "Positivo" AND 
       NOT INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_movto             THEN DO: /* CrÇdito */
       RUN MESSAGE.p ("Tipo de Movimento Incorreto!",
                      "O Tipo de Movimento deve ser DêBITO para transaá‰es que incidam positivamente no l°quido.").

       APPLY 'ENTRY' TO dc-comis-trans.ind_tip_movto IN FRAME {&FRAME-NAME}.
       RETURN 'NOK'.
    END.

    IF INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_liquido = "Negativo" AND 
       INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_movto                 THEN DO: /* DÇbito */
       RUN MESSAGE.p ("Tipo de Movimento Incorreto!",
                      "O Tipo de Movimento deve ser CRêDITO para transaá‰es que incidam negativamente no l°quido.").
       APPLY 'ENTRY' TO dc-comis-trans.ind_tip_movto IN FRAME {&FRAME-NAME}.
       RETURN 'NOK'.
    END.

    IF  INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl <> '' THEN DO:

        /*plano conta cont†bil*/
        FIND FIRST plano_cta_ctbl NO-LOCK
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl NO-ERROR.
        IF  NOT AVAIL plano_cta_ctbl THEN DO:
            RUN MESSAGE.p ('Plano de Contas n∆o encontrado.',
                           'Informe um C¢digo de Plano de Contas existànte.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  plano_cta_ctbl.ind_tip_plano_cta_ctbl <> 'Primario' THEN DO:
            RUN MESSAGE.p ('Plano de Contas n∆o Ç Prim†rio.',
                           'O Plano de Contas deve ser Prim†rio.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  plano_cta_ctbl.dat_inic_valid   > TODAY OR
            plano_cta_ctbl.dat_fim_valid    < TODAY THEN DO:
            RUN MESSAGE.p ('Plano de Contas fora do per°odo.',
                           'Informe um Plano de Contas com per°odo que permita movimentaá‰es para a data corrente.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        ASSIGN  l-valida    = NO.
        FOR EACH usuar_grp_usuar NO-LOCK 
           WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
            FIND FIRST segur_plano_cta_ctbl NO-LOCK 
                 WHERE segur_plano_cta_ctbl.cod_plano_cta_ctbl  = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
                   AND segur_plano_cta_ctbl.cod_unid_organ      = v_cod_empres_usuar
                   AND (segur_plano_cta_ctbl.cod_grp_usuar      = usuar_grp_usuar.cod_grp_usuar 
                    OR segur_plano_cta_ctbl.cod_grp_usuar       = '*') NO-ERROR.
            IF  AVAIL segur_plano_cta_ctbl THEN
                ASSIGN  l-valida = YES.
        END. /*for each usuar_grp_usuar*/
        IF  NOT l-valida THEN DO:
            RUN MESSAGE.p ('Usu†rio sem permiss∆o para Plano Contas.',
                           'O Usu†rio corrente n∆o tem permiss∆o para utilizar este Plano de Contas.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        /*FIM-plano conta cont†bil*/
        
        /*conta cont†bil*/
        FIND FIRST cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_plano_cta_ctbl  = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
               AND cta_ctbl.cod_cta_ctbl        = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl NO-ERROR.
        IF  NOT AVAIL cta_ctbl THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil n∆o encontrada.',
                           'Entre com uma Conta Cont†bil v†lida para o Plano de Contas informado.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  cta_ctbl.dat_inic_valid > TODAY OR
            cta_ctbl.dat_fim_valid  < TODAY THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil fora de per°odo permitido.',
                           'Informe uma Conta Cont†bil com per°odo que permita a data corrente.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        ASSIGN  l-valida = NO.
        FOR EACH usuar_grp_usuar NO-LOCK 
           WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
                
            FIND FIRST segur_restric_cta_ctbl NO-LOCK 
                 WHERE segur_restric_cta_ctbl.cod_plano_cta_ctbl    = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
                   AND segur_restric_cta_ctbl.cod_cta_ctbl          = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl
                   AND segur_restric_cta_ctbl.cod_unid_organ        = v_cod_empres_usuar
                   AND (segur_restric_cta_ctbl.cod_grp_usuar        = usuar_grp_usuar.cod_grp_usuar
                    OR segur_restric_cta_ctbl.cod_grp_usuar         = '*')  NO-ERROR.
            IF  AVAIL segur_restric_cta_ctbl THEN DO:
                ASSIGN  l-valida = YES.
                LEAVE.
            END.
        END. /*for each usuar_grp_usuar*/
        IF  l-valida THEN DO:
            RUN MESSAGE.p ('Usu†rio com restriá∆o a Conta informada.',
                           'Informe uma Conta Cont†bil que o usuario corrente n∆o tenha restriá∆o de acesso.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        FIND FIRST cta_restric_estab NO-LOCK
             WHERE cta_restric_estab.cod_plano_cta_ctbl = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
               AND cta_restric_estab.cod_cta_ctbl       = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl
               AND cta_restric_estab.cod_unid_organ     = v_cod_empres_usuar
               AND cta_restric_estab.cod_estab          = v_cod_estab_usuar NO-ERROR.
        IF  AVAIL cta_restric_estab THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil com restriá∆o a Estabelecimento.',
                           'Informe uma Conta Cont†bil que n∆o tem restriá∆o de acesso ao Estabelecimento do Usuario corrente.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        FIND FIRST cta_restric_unid_negoc NO-LOCK
             WHERE cta_restric_unid_negoc.cod_plano_cta_ctbl    = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl 
               AND cta_restric_unid_negoc.cod_cta_ctbl          = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl
               AND cta_restric_unid_negoc.cod_unid_organ        = v_cod_empres_usuar
               AND cta_restric_unid_negoc.cod_unid_negoc        = v_cod_unid_negoc_usuar NO-ERROR.
        IF  AVAIL cta_restric_unid_negoc THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil com restriá∆o a Unidade Neg¢cio.',
                           'Informe uma Conta Cont†bil que n∆o tem restriá∆o de acesso a Unidade Neg¢cio do Usuario corrente.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        /*FIM-conta cont†bil*/
    END. /*IF  cod_plano_cta_ctbl <> '' THEN DO:*/

    IF  INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto <> '' THEN DO:
        FIND FIRST plano_ccusto NO-LOCK
             WHERE plano_ccusto.cod_empresa      = v_cod_empres_usuar
               AND plano_ccusto.cod_plano_ccusto = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto   NO-ERROR.
        IF  NOT AVAIL plano_ccusto THEN DO:
            RUN MESSAGE.p ('Plano de Custo de Custo n∆o encontrador.',
                           'Informe um C¢digo de Plano de Centro de Custo cadastrado.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_ccusto.
            RETURN 'NOK'.
        END.
        IF  plano_ccusto.dat_fim_valid  < TODAY OR
            plano_ccusto.dat_inic_valid > TODAY THEN DO:
            RUN MESSAGE.p ('Per°odo do Plano de Centro de Custo inv†lido.',
                           'Informe um Plano de Centro de Custo com per°odo v†lido para data corrente.').
            APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_ccusto.
            RETURN 'NOK'.
        END.
        
        IF  INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto <> ? THEN DO:
            FIND FIRST emsuni.ccusto NO-LOCK
                 WHERE emsuni.ccusto.cod_empresa       = v_cod_empres_usuar
                   AND emsuni.ccusto.cod_plano_ccusto  = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto
                   AND emsuni.ccusto.cod_ccusto        = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto NO-ERROR.
            IF  NOT AVAIL emsuni.ccusto THEN DO:
                RUN MESSAGE.p ('Centro de Custo n∆o encontrada.',
                               'Entre com um Centro de Custo v†lido para o Plano de Centro de Custo.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_plano_ccusto.
                RETURN 'NOK'.
            END.
            IF  ccusto.dat_fim_valid    < TODAY OR
                ccusto.dat_inic_valid   > TODAY THEN DO:
                RUN MESSAGE.p ('Per°odo do Centro de Custo inv†lido.',
                               'Informe um Centro de Custo com per°odo v†lido para data corrente.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_ccusto.
                RETURN 'NOK'.
            END.
            FIND FIRST restric_ccusto NO-LOCK 
                 WHERE restric_ccusto.cod_empresa       = v_cod_empres_usuar
                   AND restric_ccusto.cod_plano_ccusto  = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto
                   AND restric_ccusto.cod_ccusto        = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto
                   AND restric_ccusto.cod_estab         = v_cod_estab_usuar NO-ERROR.
            IF  AVAIL restric_ccusto THEN DO:
                RUN MESSAGE.p ('Centro de Custo com restriá∆o de Estabelecimento.',
                               'Informe um Centro de Custo que n∆o tenha restriná∆o ao Estabelecimento do Usu†rio corrente.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_ccusto.
                RETURN 'NOK'.
            END.
            FIND FIRST ccusto_unid_negoc NO-LOCK
                 WHERE ccusto_unid_negoc.cod_empresa        = v_cod_empres_usuar
                   AND ccusto_unid_negoc.cod_plano_ccusto   = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto
                   AND ccusto_unid_negoc.cod_ccusto         = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto
                   AND ccusto_unid_negoc.cod_unid_negoc     = v_cod_unid_negoc_usuar NO-ERROR.
            IF  NOT AVAIL ccusto_unid_negoc THEN DO:
                RUN MESSAGE.p ('Unidade Neg¢cio sem permiss∆o ao Centro de Custo.',
                               'Informe um Centro de Custo que de permiss∆o a Unidade Neg¢cio do usuario corrente.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_ccusto.
                RETURN 'NOK'.
            END.
            ASSIGN  l-valida = NO.
            FOR EACH usuar_grp_usuar NO-LOCK 
               WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
    
                FIND FIRST segur_ccusto NO-LOCK
                     WHERE segur_ccusto.cod_empresa         = v_cod_empres_usuar
                       AND segur_ccusto.cod_plano_ccusto    = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto
                       AND segur_ccusto.cod_ccusto          = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto
                       AND (segur_ccusto.cod_grp_usuar      = usuar_grp_usuar.cod_grp_usuar
                        OR segur_ccusto.cod_grp_usuar       = '*') NO-ERROR.
                IF  AVAIL segur_ccusto THEN DO:
                    ASSIGN  l-valida = YES.
                    LEAVE.
                END.
            END.
            IF  NOT l-valida THEN DO:
                RUN MESSAGE.p ('Usu†rio sem permiss∆o ao Centro de Custo.',
                               'Informe um Centro de Custo que o usu†rio corrente tenha permiss∆o.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_ccusto.
                RETURN 'NOK'.
            END.

            ASSIGN  l-valida = NO.
            FOR EACH criter_distrib_cta_ctbl NO-LOCK
               WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = INPUT dc-comis-trans-ctb.cod_plano_cta_ctbl
                 AND criter_distrib_cta_ctbl.cod_cta_ctbl       = INPUT dc-comis-trans-ctb.cod_cta_ctbl
                 AND criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_usuar :
        
                IF  criter_distrib_cta_ctbl.dat_fim_valid  < TODAY OR
                    criter_distrib_cta_ctbl.dat_inic_valid > TODAY THEN NEXT.

                CASE  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto :
                    WHEN 'N∆o Utiliza'      THEN NEXT.
                    WHEN 'Utiliza Todos'    THEN ASSIGN  l-valida = YES.
                    WHEN 'Definidos'        THEN DO:
                        FIND FIRST mapa_distrib_ccusto NO-LOCK
                             WHERE mapa_distrib_ccusto.cod_estab                = criter_distrib_cta_ctbl.cod_estab
                               AND mapa_distrib_ccusto.cod_mapa_distrib_ccusto  = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto NO-ERROR.

                        IF  mapa_distrib_ccusto.dat_fim_valid   < TODAY OR
                            mapa_distrib_ccusto.dat_inic_valid  > TODAY THEN NEXT.

                        FIND FIRST item_lista_ccusto NO-LOCK
                             WHERE item_lista_ccusto.cod_estab               = mapa_distrib_ccusto.cod_estab
                               AND item_lista_ccusto.cod_mapa_distrib_ccusto = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
                               AND item_lista_ccusto.cod_empresa             = v_cod_empres_usuar
                               AND item_lista_ccusto.cod_plano_ccusto        = mapa_distrib_ccusto.cod_plano_ccusto
                               AND item_lista_ccusto.cod_ccusto              = dc-comis-trans-ctb.cod_ccusto:SCREEN-VALUE NO-ERROR.
                        IF  AVAIL item_lista_ccusto THEN DO:
                            ASSIGN  l-valida = YES.
                            LEAVE.
                        END. 
                    END.
                END CASE. 
            END. /*FOR EACH criter_distrib_cta_ctbl NO-LOCK*/
            IF  NOT l-valida THEN DO:
                RUN MESSAGE.p ('Centro de Custo fora do CritÇrio de Distribuiá∆o.',
                               'Informe um Centro de Custo que tenha permiss∆o para Conta Cont†bil atravÇs dos CritÇrios de DistribuiáÖo.').
                APPLY 'ENTRY' TO dc-comis-trans-ctb.cod_ccusto.
                RETURN 'NOK'.
            END.
        END. /*IF  cod_ccusto <> '?' THEN DO:*/
    END. /*IF  cod_plano_ccusto <> '' THEN DO:*/


    DO  TRANSACTION:
        FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                        AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                        AND dc-comis-trans-ctb.cod_empresa    = v_cod_empres_usuar EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL dc-comis-trans-ctb THEN
           ASSIGN dc-comis-trans-ctb.cod_plano_cta_ctbl   = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
                  dc-comis-trans-ctb.cod_cta_ctbl         = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl      
                  dc-comis-trans-ctb.cod_plano_ccusto     = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto  
                  dc-comis-trans-ctb.cod_ccusto           = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto.        
        ELSE 
            CREATE  dc-comis-trans-ctb.
            ASSIGN  dc-comis-trans-ctb.cod_empresa          = v_cod_empres_usuar
                    dc-comis-trans-ctb.cod_transacao        = dc-comis-trans.cod_transacao
                    dc-comis-trans-ctb.cod_plano_cta_ctbl   = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
                    dc-comis-trans-ctb.cod_cta_ctbl         = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl      
                    dc-comis-trans-ctb.cod_plano_ccusto     = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto  
                    dc-comis-trans-ctb.cod_ccusto           = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto        
                    dc-comis-trans-ctb.dat_inic_valid       = dc-comis-trans.dat_inic_valid.


        ASSIGN  dc-comis-trans.descricao            = INPUT FRAME {&FRAME-NAME} dc-comis-trans.descricao
                dc-comis-trans.ind_tip_movto        = INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_movto     
                dc-comis-trans.ind_tip_trans        = INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_trans
                dc-comis-trans.cod_plano_cta_ctbl   = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl
                dc-comis-trans.cod_cta_ctbl         = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl      
                dc-comis-trans.cod_plano_ccusto     = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto  
                dc-comis-trans.cod_ccusto           = INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto        
                dc-comis-trans.dat_inic_valid       = INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_inic_valid    
                dc-comis-trans.dat_fim_valid        = INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_fim_valid     
                dc-comis-trans.ind_incid_iss        = INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_iss
                dc-comis-trans.log_contabiliza      = INPUT FRAME {&FRAME-NAME} dc-comis-trans.LOG_contabiliza
                dc-comis-trans.LOG_perm_digitacao   = INPUT FRAME {&FRAME-NAME} dc-comis-trans.LOG_perm_digitacao
                dc-comis-trans.ind_incid_ir         = INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_ir
                v_rec_dc_comis_trans                = RECID(dc-comis-trans).
    END.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-alteracao Dialog-Frame 
PROCEDURE pi-verifica-alteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                    AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                    AND dc-comis-trans-ctb.cod_empresa    = v_cod_empres_usuar NO-LOCK NO-ERROR.
    IF AVAIL dc-comis-trans-ctb THEN
        IF  dc-comis-trans.descricao              <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.descricao              OR 
            dc-comis-trans.ind_tip_movto          <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_movto          OR 
            dc-comis-trans.ind_tip_trans          <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_trans          OR 
            dc-comis-trans-ctb.cod_plano_cta_ctbl <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl OR
            dc-comis-trans-ctb.cod_cta_ctbl       <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl       OR
            dc-comis-trans-ctb.cod_plano_ccusto   <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto   OR
            dc-comis-trans-ctb.cod_ccusto         <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto         OR
            dc-comis-trans.dat_inic_valid         <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_inic_valid         OR
            dc-comis-trans.dat_fim_valid          <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_fim_valid          OR 
            dc-comis-trans.ind_incid_ir           <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_ir THEN DO:

            MESSAGE "Transaá∆o de Comiss∆o sofreu alteraá‰es. Deseja salv†-las ?"
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL TITLE "Transaá∆o de Comiss∆o" UPDATE v_log_answer.
            IF  v_log_answer THEN DO:
                RUN pi-salvar.
                IF  RETURN-VALUE = 'NOK' THEN
                    RETURN 'NOK'.
            END.
        END.
    ELSE
    IF  dc-comis-trans.descricao            <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.descricao              OR 
        dc-comis-trans.ind_tip_movto        <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_movto          OR 
        dc-comis-trans.ind_tip_trans        <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_tip_trans          OR 
        dc-comis-trans.cod_plano_cta_ctbl   <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_cta_ctbl OR
        dc-comis-trans.cod_cta_ctbl         <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_cta_ctbl       OR
        dc-comis-trans.cod_plano_ccusto     <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_plano_ccusto   OR
        dc-comis-trans.cod_ccusto           <> INPUT FRAME {&FRAME-NAME} dc-comis-trans-ctb.cod_ccusto         OR
        dc-comis-trans.dat_inic_valid       <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_inic_valid         OR
        dc-comis-trans.dat_fim_valid        <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.dat_fim_valid          OR 
        dc-comis-trans.ind_incid_ir         <> INPUT FRAME {&FRAME-NAME} dc-comis-trans.ind_incid_ir THEN DO:
        
        MESSAGE "Transaá∆o de Comiss∆o sofreu alteraá‰es. Deseja salv†-las ?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL TITLE "Transaá∆o de Comiss∆o" UPDATE v_log_answer.
        IF  v_log_answer THEN DO:
            RUN pi-salvar.
            IF  RETURN-VALUE = 'NOK' THEN
                RETURN 'NOK'.
        END.
    END.
    
    RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

