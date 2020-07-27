&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsuni           PROGRESS
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
{utp/ut-glob504.i}

DEF BUFFER b-dc-comis-trans FOR dc-comis-trans.
DEF BUFFER b-dc-comis-trans-ctb FOR dc-comis-trans-ctb.

DEF NEW GLOBAL SHARED VAR v_rec_dc_comis_trans  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_cta_ctbl  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_cta_ctbl        AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_ccusto    AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_ccusto          AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario   like param-global.empresa-prin NO-UNDO.

DEF VAR l-valida        AS LOGICAL      NO-UNDO.

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
emsdocol.dc-comis-trans.log_perm_digitacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
emsdocol.dc-comis-trans.log_perm_digitacao 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH emsdocol.dc-comis-trans SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH emsdocol.dc-comis-trans SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame emsdocol.dc-comis-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emsdocol.dc-comis-trans.log_perm_digitacao 
&Scoped-define ENABLED-TABLES emsdocol.dc-comis-trans 
&Scoped-define FIRST-ENABLED-TABLE emsdocol.dc-comis-trans
&Scoped-Define ENABLED-OBJECTS cod_transacao dat_inic_valid dat_fim_valid ~
descricao ind_tip_trans ind_incid_iss ind_incid_liquido ind_incid_ir ~
log_contabiliza ind_tip_movto cod_plano_cta_ctbl bt-zoom-plano-cta-ctbl ~
cod_plano_ccusto bt-zoom-cod-plano-ccusto cod_cta_ctbl bt-zoom-cta-ctbl ~
cod_ccusto bt-zoom-ccusto bt-ok bt-salva bt-cancela bt-copia bt-ajuda ~
RECT-7 rt-chave rt-contabil rt-financeiro 
&Scoped-Define DISPLAYED-FIELDS emsdocol.dc-comis-trans.log_perm_digitacao 
&Scoped-define DISPLAYED-TABLES emsdocol.dc-comis-trans
&Scoped-define FIRST-DISPLAYED-TABLE emsdocol.dc-comis-trans
&Scoped-Define DISPLAYED-OBJECTS cod_transacao dat_inic_valid dat_fim_valid ~
descricao ind_tip_trans ind_incid_iss ind_incid_liquido ind_incid_ir ~
log_contabiliza ind_tip_movto cod_plano_cta_ctbl cod_plano_ccusto ~
cod_cta_ctbl cod_ccusto 

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

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-copia 
     IMAGE-UP FILE "Image/im-cop.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-cop.bmp":U
     LABEL "Copia" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-salva 
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

DEFINE VARIABLE ind_incid_iss LIKE emsdocol.dc-comis-trans.ind_incid_iss
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Positivo","Negativo","N∆o Incide" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE ind_incid_liquido LIKE emsdocol.dc-comis-trans.ind_incid_liquido
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Positivo","Negativo","N∆o Incide" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE ind_tip_trans LIKE emsdocol.dc-comis-trans.ind_tip_trans
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Adiantamento","DelCredere","Estorno Vendor","GenÇrico","Indenizaá∆o","Imposto Renda","Rescis∆o" 
     DROP-DOWN-LIST
     SIZE 18 BY 1
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE cod_ccusto LIKE emsdocol.dc-comis-trans.cod_ccusto
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 TOOLTIP "Informe o Centro de Custo ou '?' para Coringa"
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE cod_cta_ctbl LIKE emsuni.cta_ctbl.cod_cta_ctbl
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE cod_plano_ccusto LIKE emsdocol.dc-comis-trans.cod_plano_ccusto
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE cod_plano_cta_ctbl LIKE emsdocol.dc-comis-trans.cod_plano_cta_ctbl
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE cod_transacao LIKE emsdocol.dc-comis-trans.cod_transacao
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE dat_fim_valid LIKE emsdocol.dc-comis-trans.dat_fim_valid
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE dat_inic_valid LIKE emsdocol.dc-comis-trans.dat_inic_valid
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE descricao LIKE emsdocol.dc-comis-trans.descricao
     VIEW-AS FILL-IN 
     SIZE 44 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE ind_tip_movto LIKE emsdocol.dc-comis-trans.ind_tip_movto
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "DÇbito", yes,
"CrÇdito", no
     SIZE 33 BY .88 NO-UNDO.

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

DEFINE VARIABLE ind_incid_ir AS LOGICAL INITIAL yes 
     LABEL "Incide Imposto Renda" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE log_contabiliza LIKE emsdocol.dc-comis-trans.log_contabiliza
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      emsdocol.dc-comis-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cod_transacao AT ROW 1.5 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     dat_inic_valid AT ROW 2.5 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     dat_fim_valid AT ROW 2.5 COL 54 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     descricao AT ROW 4.25 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     ind_tip_trans AT ROW 5.25 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     ind_incid_iss AT ROW 6.25 COL 20 COLON-ALIGNED
     ind_incid_liquido AT ROW 7.25 COL 20 COLON-ALIGNED
     ind_incid_ir AT ROW 8.25 COL 22
     emsdocol.dc-comis-trans.log_perm_digitacao AT ROW 8.25 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     log_contabiliza AT ROW 9.75 COL 22
     ind_tip_movto AT ROW 10.75 COL 22 NO-LABEL
     cod_plano_cta_ctbl AT ROW 11.75 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     bt-zoom-plano-cta-ctbl AT ROW 11.75 COL 32.29
     cod_plano_ccusto AT ROW 11.75 COL 54 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     bt-zoom-cod-plano-ccusto AT ROW 11.75 COL 66.29
     cod_cta_ctbl AT ROW 12.75 COL 20 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     bt-zoom-cta-ctbl AT ROW 12.75 COL 37.29
     cod_ccusto AT ROW 12.75 COL 54 COLON-ALIGNED
          BGCOLOR 15 FONT 2
     bt-zoom-ccusto AT ROW 12.75 COL 68.29
     bt-ok AT ROW 14.5 COL 3
     bt-salva AT ROW 14.5 COL 14
     bt-cancela AT ROW 14.5 COL 25
     bt-copia AT ROW 14.5 COL 40
     bt-ajuda AT ROW 14.5 COL 71
     RECT-7 AT ROW 14.25 COL 2
     rt-chave AT ROW 1.25 COL 2
     rt-contabil AT ROW 9.5 COL 2
     rt-financeiro AT ROW 4 COL 2
     "Tipo Movto:" VIEW-AS TEXT
          SIZE 8.29 BY .88 AT ROW 11 COL 13
     "(?)" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 12.83 COL 72.57
     SPACE(8.28) SKIP(2.62)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Inclui Transaá∆o de Comiss∆o - DCO001A"
         DEFAULT-BUTTON bt-salva.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   L-To-R                                                               */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cod_ccusto IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
/* SETTINGS FOR FILL-IN cod_cta_ctbl IN FRAME Dialog-Frame
   LIKE = emsuni.cta_ctbl.cod_cta_ctbl EXP-SIZE                         */
/* SETTINGS FOR FILL-IN cod_plano_ccusto IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
/* SETTINGS FOR FILL-IN cod_plano_cta_ctbl IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
/* SETTINGS FOR FILL-IN cod_transacao IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.                                      */
/* SETTINGS FOR FILL-IN dat_fim_valid IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.                                      */
/* SETTINGS FOR FILL-IN dat_inic_valid IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.                                      */
/* SETTINGS FOR FILL-IN descricao IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.                                      */
/* SETTINGS FOR COMBO-BOX ind_incid_iss IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.ind_incid_iss EXP-SIZE                */
/* SETTINGS FOR COMBO-BOX ind_incid_liquido IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
/* SETTINGS FOR RADIO-SET ind_tip_movto IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
/* SETTINGS FOR COMBO-BOX ind_tip_trans IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans.ind_tip_trans EXP-SIZE                */
/* SETTINGS FOR TOGGLE-BOX log_contabiliza IN FRAME Dialog-Frame
   LIKE = emsdocol.dc-comis-trans. EXP-SIZE                             */
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Inclui Transaá∆o de Comiss∆o - DCO001A */
DO:
  APPLY "END-ERROR":U TO SELF.
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


&Scoped-define SELF-NAME bt-copia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-copia Dialog-Frame
ON CHOOSE OF bt-copia IN FRAME Dialog-Frame /* Copia */
DO:
    DEF VAR v-rec-aux   AS RECID    NO-UNDO.
    ASSIGN  v-rec-aux   = v_rec_dc_comis_trans.

    RUN dozoom/dco001z1.w.

    IF  v_rec_dc_comis_trans <> ? THEN DO:
        FIND FIRST b-dc-comis-trans NO-LOCK
             WHERE RECID(b-dc-comis-trans) = v_rec_dc_comis_trans NO-ERROR.
        FIND FIRST b-dc-comis-trans-ctb 
             WHERE b-dc-comis-trans-ctb.cod_transacao  = b-dc-comis-trans.cod_transacao
               AND b-dc-comis-trans-ctb.dat_inic_valid = b-dc-comis-trans.dat_inic_valid 
               AND b-dc-comis-trans-ctb.cod_empresa    = i-ep-codigo-usuario NO-LOCK NO-ERROR.
        DISPLAY b-dc-comis-trans.cod_transacao      @ cod_transacao
                b-dc-comis-trans.descricao          @ descricao 
                b-dc-comis-trans-ctb.cod_plano_cta_ctbl @ cod_plano_cta_ctbl
                b-dc-comis-trans-ctb.cod_cta_ctbl       @ cod_cta_ctbl      
                b-dc-comis-trans-ctb.cod_plano_ccusto   @ cod_plano_ccusto  
                b-dc-comis-trans-ctb.cod_ccusto         @ cod_ccusto        
                b-dc-comis-trans.dat_inic_valid     @ dat_inic_valid    
                b-dc-comis-trans.dat_fim_valid      @ dat_fim_valid WITH FRAME {&FRAME-NAME}.
        ASSIGN  ind_tip_movto:SCREEN-VALUE = STRING(b-dc-comis-trans.ind_tip_movto).
        APPLY 'LEAVE' TO cod_plano_cta_ctbl.
        APPLY 'LEAVE' TO cod_plano_ccusto.
    END.

    ASSIGN  v_rec_dc_comis_trans = v-rec-aux.
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


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva Dialog-Frame
ON CHOOSE OF bt-salva IN FRAME Dialog-Frame /* Salva */
DO:
    RUN pi-salvar.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.

    RUN pi-incluir.
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
        DISPLAY emsuni.ccusto.cod_ccusto @ cod_ccusto WITH FRAME {&FRAME-NAME}.
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
        DISPLAY plano_ccusto.cod_plano_ccusto @ cod_plano_ccusto WITH FRAME {&FRAME-NAME}.
    END.     
    APPLY 'LEAVE' TO cod_plano_ccusto.
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
        DISPLAY cta_ctbl.cod_cta_ctbl   @ cod_cta_ctbl WITH FRAME {&FRAME-NAME}.
        APPLY 'LEAVE' TO cod_cta_ctbl.
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
        DISPLAY plano_cta_ctbl.cod_plano_cta_ctbl   @ cod_plano_cta_ctbl WITH FRAME {&FRAME-NAME}.
    END.
    APPLY 'LEAVE' TO cod_plano_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod_cta_ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod_cta_ctbl Dialog-Frame
ON LEAVE OF cod_cta_ctbl IN FRAME Dialog-Frame /* Conta Cont†bil */
DO:
    ASSIGN  l-valida = NO.
        
    FOR EACH criter_distrib_cta_ctbl NO-LOCK
       WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = cod_plano_cta_ctbl:SCREEN-VALUE
         AND criter_distrib_cta_ctbl.cod_cta_ctbl       = string(int(cod_cta_ctbl:SCREEN-VALUE))
         AND criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_usuar:

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
                       AND item_lista_ccusto.cod_plano_ccusto        = mapa_distrib_ccusto.cod_plano_ccusto NO-ERROR.
                IF  AVAIL item_lista_ccusto THEN DO:
                    ASSIGN  l-valida = YES.
                    LEAVE.
                END.      
            END.
        END CASE. 
    END. /*FOR EACH criter_distrib_cta_ctbl NO-LOCK*/

    ASSIGN  cod_plano_ccusto        :SENSITIVE  = l-valida
            bt-zoom-cod-plano-ccusto:SENSITIVE  = l-valida
            cod_ccusto              :SENSITIVE  = l-valida
            bt-zoom-ccusto          :SENSITIVE  = l-valida.
    IF  NOT l-valida THEN
        ASSIGN  cod_plano_ccusto    :SCREEN-VALUE = ''
                cod_ccusto          :SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod_plano_ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod_plano_ccusto Dialog-Frame
ON LEAVE OF cod_plano_ccusto IN FRAME Dialog-Frame /* Plano CCusto */
DO:
    IF  cod_plano_ccusto:SCREEN-VALUE = '' THEN DO:
        ASSIGN  cod_ccusto    :SCREEN-VALUE = ''
                cod_ccusto    :SENSITIVE    = NO
                bt-zoom-ccusto:SENSITIVE    = NO.
    END.
    ELSE DO: 
        FIND FIRST plano_ccusto NO-LOCK
             WHERE plano_ccusto.cod_plano_ccusto = cod_plano_ccusto:SCREEN-VALUE NO-ERROR.
        ASSIGN  cod_ccusto:FORMAT = IF  AVAIL plano_ccusto THEN plano_ccusto.cod_format_ccusto ELSE 'X(11)'
                cod_ccusto    :SENSITIVE     = YES
                bt-zoom-ccusto:SENSITIVE    = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod_plano_cta_ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod_plano_cta_ctbl Dialog-Frame
ON LEAVE OF cod_plano_cta_ctbl IN FRAME Dialog-Frame /* Plano de Contas */
DO:
    IF  cod_plano_cta_ctbl:SCREEN-VALUE = '' THEN DO:
        ASSIGN  cod_cta_ctbl    :SCREEN-VALUE   = ''
                cod_cta_ctbl    :SENSITIVE      = NO
                bt-zoom-cta-ctbl:SENSITIVE      = NO.
    END.
    ELSE DO:
        FIND FIRST plano_cta_ctbl NO-LOCK 
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = cod_plano_cta_ctbl:SCREEN-VALUE NO-ERROR.
        ASSIGN  cod_cta_ctbl:FORMAT = IF  AVAIL plano_cta_ctbl THEN  plano_cta_ctbl.cod_format_cta_ctbl ELSE 'X(20)'
                cod_cta_ctbl    :SENSITIVE      = YES 
                bt-zoom-cta-ctbl:SENSITIVE      = YES.
    END.
    APPLY 'LEAVE' TO cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log_contabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log_contabiliza Dialog-Frame
ON VALUE-CHANGED OF log_contabiliza IN FRAME Dialog-Frame /* Contabiliza */
DO:
  IF INPUT FRAME {&FRAME-NAME} log_contabiliza THEN
     ASSIGN ind_tip_movto:SENSITIVE            = YES
            cod_plano_cta_ctbl:SENSITIVE       = YES
            bt-zoom-plano-cta-ctbl:SENSITIVE   = YES
            cod_cta_ctbl:SENSITIVE             = YES
            bt-zoom-cta-ctbl:SENSITIVE         = YES
            cod_plano_ccusto:SENSITIVE         = YES
            bt-zoom-cod-plano-ccusto:SENSITIVE = YES
            cod_ccusto:SENSITIVE               = YES
            bt-zoom-ccusto:SENSITIVE           = YES.
  ELSE
     ASSIGN ind_tip_movto:SENSITIVE            = NO
            cod_plano_cta_ctbl:SENSITIVE       = NO
            bt-zoom-plano-cta-ctbl:SENSITIVE   = NO
            cod_cta_ctbl:SENSITIVE             = NO
            bt-zoom-cta-ctbl:SENSITIVE         = NO
            cod_plano_ccusto:SENSITIVE         = NO
            bt-zoom-cod-plano-ccusto:SENSITIVE = NO
            cod_ccusto:SENSITIVE               = NO
            bt-zoom-ccusto:SENSITIVE           = NO.
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

    RUN pi-incluir.

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
  DISPLAY cod_transacao dat_inic_valid dat_fim_valid descricao ind_tip_trans 
          ind_incid_iss ind_incid_liquido ind_incid_ir log_contabiliza 
          ind_tip_movto cod_plano_cta_ctbl cod_plano_ccusto cod_cta_ctbl 
          cod_ccusto 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE emsdocol.dc-comis-trans THEN 
    DISPLAY emsdocol.dc-comis-trans.log_perm_digitacao 
      WITH FRAME Dialog-Frame.
  ENABLE cod_transacao dat_inic_valid dat_fim_valid descricao ind_tip_trans 
         ind_incid_iss ind_incid_liquido ind_incid_ir 
         emsdocol.dc-comis-trans.log_perm_digitacao log_contabiliza 
         ind_tip_movto cod_plano_cta_ctbl bt-zoom-plano-cta-ctbl 
         cod_plano_ccusto bt-zoom-cod-plano-ccusto cod_cta_ctbl 
         bt-zoom-cta-ctbl cod_ccusto bt-zoom-ccusto bt-ok bt-salva bt-cancela 
         bt-copia bt-ajuda RECT-7 rt-chave rt-contabil rt-financeiro 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-incluir Dialog-Frame 
PROCEDURE pi-incluir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CLEAR FRAME {&FRAME-NAME}.
    
    ASSIGN  dat_inic_valid:SCREEN-VALUE = '01/01/0001'
            dat_fim_valid:SCREEN-VALUE  = '31/12/9999'.

    APPLY 'ENTRY' TO cod_transacao.

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
    ASSIGN  INPUT FRAME {&FRAME-NAME} 
                cod_ccusto          cod_cta_ctbl        cod_plano_ccusto 
                cod_plano_cta_ctbl  cod_transacao       dat_fim_valid 
                dat_inic_valid      descricao           ind_tip_movto
                ind_tip_trans       ind_incid_liquido ind_incid_ir
                ind_incid_iss       log_contabiliza.

    /*validaá∆o*/
    FIND FIRST b-dc-comis-trans NO-LOCK
         WHERE b-dc-comis-trans.cod_transacao     = cod_transacao 
           AND b-dc-comis-trans.dat_inic_valid  <= dat_fim_valid
           AND b-dc-comis-trans.dat_fim_valid   >= dat_inic_valid NO-ERROR.
    IF  AVAIL b-dc-comis-trans THEN DO:
        RUN MESSAGE.p ('C¢digo j† cadastrado no per°odo informado.',
                       'Informe um c¢digo novo ou ajuste o per°odo para que n∆o sobreponha um outro per°odo da mesma transaá∆o.').
        APPLY 'ENTRY' TO cod_transacao IN FRAME {&FRAME-NAME}.
        RETURN 'NOK'.
    END.

    IF ind_incid_liquido = "Positivo" AND 
       NOT ind_tip_movto             THEN DO: /* CrÇdito */
       RUN MESSAGE.p ("Tipo de Movimento Incorreto!",
                      "O Tipo de Movimento deve ser DêBITO para transaá‰es que incidam positivamente no l°quido.").

       APPLY 'ENTRY' TO ind_tip_movto IN FRAME {&FRAME-NAME}.
       RETURN 'NOK'.
    END.

    IF ind_incid_liquido = "Negativo" AND 
       ind_tip_movto                 THEN DO: /* DÇbito */
       RUN MESSAGE.p ("Tipo de Movimento Incorreto!",
                      "O Tipo de Movimento deve ser CRêDITO para transaá‰es que incidam negativamente no l°quido.").
       APPLY 'ENTRY' TO ind_tip_movto IN FRAME {&FRAME-NAME}.
       RETURN 'NOK'.
    END.

    IF  cod_plano_cta_ctbl <> '' THEN DO:

        /*plano conta cont†bil*/
        FIND FIRST plano_cta_ctbl NO-LOCK
             WHERE plano_cta_ctbl.cod_plano_cta_ctbl = cod_plano_cta_ctbl NO-ERROR.
        IF  NOT AVAIL plano_cta_ctbl THEN DO:
            RUN MESSAGE.p ('Plano de Contas n∆o encontrado.',
                           'Informe um C¢digo de Plano de Contas existànte.').
            APPLY 'ENTRY' TO cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  plano_cta_ctbl.ind_tip_plano_cta_ctbl <> 'Primario' THEN DO:
            RUN MESSAGE.p ('Plano de Contas n∆o Ç Prim†rio.',
                           'O Plano de Contas deve ser Prim†rio.').
            APPLY 'ENTRY' TO cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  plano_cta_ctbl.dat_inic_valid   > TODAY OR
            plano_cta_ctbl.dat_fim_valid    < TODAY THEN DO:
            RUN MESSAGE.p ('Plano de Contas fora do per°odo.',
                           'Informe um Plano de Contas com per°odo que permita movimentaá‰es para a data corrente.').
            APPLY 'ENTRY' TO cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        ASSIGN  l-valida    = NO.
        FOR EACH usuar_grp_usuar NO-LOCK 
           WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
            FIND FIRST segur_plano_cta_ctbl NO-LOCK 
                 WHERE segur_plano_cta_ctbl.cod_plano_cta_ctbl  = cod_plano_cta_ctbl
                   AND segur_plano_cta_ctbl.cod_unid_organ      = v_cod_empres_usuar
                   AND (segur_plano_cta_ctbl.cod_grp_usuar      = usuar_grp_usuar.cod_grp_usuar 
                    OR segur_plano_cta_ctbl.cod_grp_usuar       = '*') NO-ERROR.
            IF  AVAIL segur_plano_cta_ctbl THEN
                ASSIGN  l-valida = YES.
        END. /*for each usuar_grp_usuar*/
        IF  NOT l-valida THEN DO:
            RUN MESSAGE.p ('Usu†rio sem permiss∆o para Plano Contas.',
                           'O Usu†rio corrente n∆o tem permiss∆o para utilizar este Plano de Contas.').
            APPLY 'ENTRY' TO cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        /*FIM-plano conta cont†bil*/
        
        /*conta cont†bil*/
        FIND FIRST cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_plano_cta_ctbl  = cod_plano_cta_ctbl
               AND cta_ctbl.cod_cta_ctbl        = cod_cta_ctbl NO-ERROR.
        IF  NOT AVAIL cta_ctbl THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil n∆o encontrada.',
                           'Entre com uma Conta Cont†bil v†lida para o Plano de Contas informado.').
            APPLY 'ENTRY' TO cod_plano_cta_ctbl.
            RETURN 'NOK'.
        END.
        IF  cta_ctbl.dat_inic_valid > TODAY OR
            cta_ctbl.dat_fim_valid  < TODAY THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil fora de per°odo permitido.',
                           'Informe uma Conta Cont†bil com per°odo que permita a data corrente.').
            APPLY 'ENTRY' TO cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        ASSIGN  l-valida = NO.
        FOR EACH usuar_grp_usuar NO-LOCK 
           WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
                
            FIND FIRST segur_restric_cta_ctbl NO-LOCK 
                 WHERE segur_restric_cta_ctbl.cod_plano_cta_ctbl    = cod_plano_cta_ctbl
                   AND segur_restric_cta_ctbl.cod_cta_ctbl          = cod_cta_ctbl
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
            APPLY 'ENTRY' TO cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        FIND FIRST cta_restric_estab NO-LOCK
             WHERE cta_restric_estab.cod_plano_cta_ctbl = cod_plano_cta_ctbl
               AND cta_restric_estab.cod_cta_ctbl       = cod_cta_ctbl
               AND cta_restric_estab.cod_unid_organ     = v_cod_empres_usuar
               AND cta_restric_estab.cod_estab          = v_cod_estab_usuar NO-ERROR.
        IF  AVAIL cta_restric_estab THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil com restriá∆o a Estabelecimento.',
                           'Informe uma Conta Cont†bil que n∆o tem restriá∆o de acesso ao Estabelecimento do Usuario corrente.').
            APPLY 'ENTRY' TO cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        FIND FIRST cta_restric_unid_negoc NO-LOCK
             WHERE cta_restric_unid_negoc.cod_plano_cta_ctbl    = cod_plano_cta_ctbl 
               AND cta_restric_unid_negoc.cod_cta_ctbl          = cod_cta_ctbl
               AND cta_restric_unid_negoc.cod_unid_organ        = v_cod_empres_usuar
               AND cta_restric_unid_negoc.cod_unid_negoc        = v_cod_unid_negoc_usuar NO-ERROR.
        IF  AVAIL cta_restric_unid_negoc THEN DO:
            RUN MESSAGE.p ('Conta Cont†bil com restriá∆o a Unidade Neg¢cio.',
                           'Informe uma Conta Cont†bil que n∆o tem restriá∆o de acesso a Unidade Neg¢cio do Usuario corrente.').
            APPLY 'ENTRY' TO cod_cta_ctbl.
            RETURN 'NOK'.
        END.
        /*FIM-conta cont†bil*/
    END. /*IF  cod_plano_cta_ctbl <> '' THEN DO:*/

    IF  cod_plano_ccusto <> '' THEN DO:
        FIND FIRST plano_ccusto NO-LOCK
             WHERE plano_ccusto.cod_empresa      = v_cod_empres_usuar
               AND plano_ccusto.cod_plano_ccusto = cod_plano_ccusto   NO-ERROR.
        IF  NOT AVAIL plano_ccusto THEN DO:
            RUN MESSAGE.p ('Plano de Centro de Custo n∆o encontrado.',
                           'Informe um C¢digo de Plano de Centro de Custo cadastrado.').
            APPLY 'ENTRY' TO cod_plano_ccusto.
            RETURN 'NOK'.
        END.
        IF  plano_ccusto.dat_fim_valid  < TODAY OR
            plano_ccusto.dat_inic_valid > TODAY THEN DO:
            RUN MESSAGE.p ('Per°odo do Plano de Centro de Custo inv†lido.',
                           'Informe um Plano de Centro de Custo com per°odo v†lido para data corrente.').
            APPLY 'ENTRY' TO cod_plano_ccusto.
            RETURN 'NOK'.
        END.
        
        IF  cod_ccusto <> ? THEN DO:
            FIND FIRST emsuni.ccusto NO-LOCK
                 WHERE emsuni.ccusto.cod_empresa       = v_cod_empres_usuar
                   AND emsuni.ccusto.cod_plano_ccusto  = cod_plano_ccusto
                   AND emsuni.ccusto.cod_ccusto        = cod_ccusto NO-ERROR.
            IF  NOT AVAIL emsuni.ccusto THEN DO:
                RUN MESSAGE.p ('Centro de Custo n∆o encontrado.',
                               'Entre com um Centro de Custo v†lido para o Plano de Centro de Custo.').
                APPLY 'ENTRY' TO cod_plano_ccusto.
                RETURN 'NOK'.
            END.
            IF  ccusto.dat_fim_valid    < TODAY OR
                ccusto.dat_inic_valid   > TODAY THEN DO:
                RUN MESSAGE.p ('Per°odo do Centro de Custo inv†lido.',
                               'Informe um Centro de Custo com per°odo v†lido para data corrente.').
                APPLY 'ENTRY' TO cod_ccusto.
                RETURN 'NOK'.
            END.
            FIND FIRST restric_ccusto NO-LOCK 
                 WHERE restric_ccusto.cod_empresa       = v_cod_empres_usuar
                   AND restric_ccusto.cod_plano_ccusto  = cod_plano_ccusto
                   AND restric_ccusto.cod_ccusto        = cod_ccusto
                   AND restric_ccusto.cod_estab         = v_cod_estab_usuar NO-ERROR.
            IF  AVAIL restric_ccusto THEN DO:
                RUN MESSAGE.p ('Centro de Custo com restriá∆o de Estabelecimento.',
                               'Informe um Centro de Custo que n∆o tenha restriná∆o ao Estabelecimento do Usu†rio corrente.').
                APPLY 'ENTRY' TO cod_ccusto.
                RETURN 'NOK'.
            END.
            FIND FIRST ccusto_unid_negoc NO-LOCK
                 WHERE ccusto_unid_negoc.cod_empresa        = v_cod_empres_usuar
                   AND ccusto_unid_negoc.cod_plano_ccusto   = cod_plano_ccusto
                   AND ccusto_unid_negoc.cod_ccusto         = cod_ccusto
                   AND ccusto_unid_negoc.cod_unid_negoc     = v_cod_unid_negoc_usuar NO-ERROR.
            IF  NOT AVAIL ccusto_unid_negoc THEN DO:
                RUN MESSAGE.p ('Unidade Neg¢cio sem permiss∆o ao Centro de Custo.',
                               'Informe um Centro de Custo que de permiss∆o a Unidade Neg¢cio do usuario corrente.').
                APPLY 'ENTRY' TO cod_ccusto.
                RETURN 'NOK'.
            END.

            ASSIGN  l-valida = NO.
            FOR EACH criter_distrib_cta_ctbl NO-LOCK
               WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = cod_plano_cta_ctbl
                 AND criter_distrib_cta_ctbl.cod_cta_ctbl       = cod_cta_ctbl
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
                               AND item_lista_ccusto.cod_ccusto              = cod_ccusto NO-ERROR.
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
                APPLY 'ENTRY' TO cod_ccusto.
                RETURN 'NOK'.
            END.
        END. /*IF  cod_ccusto <> '?' THEN DO:*/
    END. /*IF  cod_plano_ccusto <> '' THEN DO:*/

    DO  TRANSACTION:
        CREATE  dc-comis-trans.
        ASSIGN  dc-comis-trans.cod_transacao        = cod_transacao
                dc-comis-trans.descricao            = descricao
                dc-comis-trans.ind_tip_movto        = ind_tip_movto     
                dc-comis-trans.ind_tip_trans        = ind_tip_trans
                dc-comis-trans.cod_plano_cta_ctbl   = cod_plano_cta_ctbl
                dc-comis-trans.cod_cta_ctbl         = cod_cta_ctbl      
                dc-comis-trans.cod_plano_ccusto     = cod_plano_ccusto  
                dc-comis-trans.cod_ccusto           = cod_ccusto        
                dc-comis-trans.dat_inic_valid       = dat_inic_valid    
                dc-comis-trans.dat_fim_valid        = dat_fim_valid
                dc-comis-trans.ind_incid_iss        = ind_incid_iss
                dc-comis-trans.ind_incid_liquido    = ind_incid_liquido
                dc-comis-trans.ind_incid_ir         = ind_incid_ir
                dc-comis-trans.log_contabiliza      = log_contabiliza
                v_rec_dc_comis_trans                = RECID(dc-comis-trans).
        CREATE  dc-comis-trans-ctb.
        ASSIGN  dc-comis-trans-ctb.cod_empresa          = i-ep-codigo-usuario
                dc-comis-trans-ctb.cod_transacao        = cod_transacao
                dc-comis-trans-ctb.cod_plano_cta_ctbl   = cod_plano_cta_ctbl
                dc-comis-trans-ctb.cod_cta_ctbl         = cod_cta_ctbl      
                dc-comis-trans-ctb.cod_plano_ccusto     = cod_plano_ccusto  
                dc-comis-trans-ctb.cod_ccusto           = cod_ccusto        
                dc-comis-trans-ctb.dat_inic_valid       = dat_inic_valid.
    END.

    RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

