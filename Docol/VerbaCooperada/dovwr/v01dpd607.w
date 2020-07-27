&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V01DPD607 12.00.00.001}

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{dop\dpd607def.i}

DEFINE VARIABLE h-folder AS HANDLE      NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES amkt-solicitacao
&Scoped-define FIRST-EXTERNAL-TABLE amkt-solicitacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR amkt-solicitacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS amkt-solicitacao.numero ~
amkt-solicitacao.cod-situacao amkt-solicitacao.situacao-comprov ~
amkt-solicitacao.situacao-pagto amkt-solicitacao.data-solicitacao ~
amkt-solicitacao.vl-solicitacao amkt-solicitacao.dt-validade-inicial ~
amkt-solicitacao.dt-validade-final amkt-solicitacao.payback-dias ~
amkt-solicitacao.cd-acao amkt-solicitacao.cod-emitente ~
amkt-solicitacao.cod-rep amkt-solicitacao.cd-tipo-acao ~
amkt-solicitacao.cd-publico-alvo amkt-solicitacao.cd-justificativa ~
amkt-solicitacao.cd-forma-pagto amkt-solicitacao.forma-pagto-cd-banco ~
amkt-solicitacao.forma-pagto-nome-banco amkt-solicitacao.forma-pagto-tipo ~
amkt-solicitacao.forma-pagto-agencia amkt-solicitacao.forma-pagto-conta ~
amkt-solicitacao.forma-pagto-favorecido ~
amkt-solicitacao.forma-pagto-cpf-cnpj 
&Scoped-define ENABLED-TABLES amkt-solicitacao
&Scoped-define FIRST-ENABLED-TABLE amkt-solicitacao
&Scoped-Define ENABLED-OBJECTS rt-key RECT-18 RECT-19 
&Scoped-Define DISPLAYED-FIELDS amkt-solicitacao.numero ~
amkt-solicitacao.cod-situacao amkt-solicitacao.situacao-comprov ~
amkt-solicitacao.situacao-pagto amkt-solicitacao.log-encerra ~
amkt-solicitacao.log-cancela amkt-solicitacao.data-solicitacao ~
amkt-solicitacao.vl-solicitacao amkt-solicitacao.dt-validade-inicial ~
amkt-solicitacao.dt-validade-final amkt-solicitacao.payback-dias ~
amkt-solicitacao.cd-acao amkt-solicitacao.cod-emitente ~
amkt-solicitacao.cod-rep amkt-solicitacao.cd-tipo-acao ~
amkt-solicitacao.cd-publico-alvo amkt-solicitacao.cd-justificativa ~
amkt-solicitacao.cd-forma-pagto amkt-solicitacao.forma-pagto-cd-banco ~
amkt-solicitacao.forma-pagto-nome-banco amkt-solicitacao.forma-pagto-tipo ~
amkt-solicitacao.forma-pagto-agencia amkt-solicitacao.forma-pagto-conta ~
amkt-solicitacao.forma-pagto-favorecido ~
amkt-solicitacao.forma-pagto-cpf-cnpj 
&Scoped-define DISPLAYED-TABLES amkt-solicitacao
&Scoped-define FIRST-DISPLAYED-TABLE amkt-solicitacao
&Scoped-Define DISPLAYED-OBJECTS fi-situacao-unif fi-vl-aprov fi-desc-acao ~
fi-desc-emitente fi-desc-repres fi-desc-tipo-acao fi-desc-publico-alvo ~
fi-desc-justificativa fi-desc-forma-pagto fi-desc-tipo-pagto 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-desc-acao AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-emitente AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-forma-pagto AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-justificativa AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-publico-alvo AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-repres AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-acao AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-pagto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-situacao-unif AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-aprov AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Realizado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 4.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 13.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     amkt-solicitacao.numero AT ROW 1.25 COL 20 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     amkt-solicitacao.cod-situacao AT ROW 1.25 COL 51.28 WIDGET-ID 16
          LABEL "Situa‡Æo Solicita‡Æo" FORMAT "x(30)"
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     amkt-solicitacao.situacao-comprov AT ROW 2.25 COL 20 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     amkt-solicitacao.situacao-pagto AT ROW 2.25 COL 64 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     fi-situacao-unif AT ROW 3.25 COL 20 COLON-ALIGNED WIDGET-ID 76 NO-TAB-STOP 
     amkt-solicitacao.log-encerra AT ROW 3.25 COL 66 WIDGET-ID 78
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .83
     amkt-solicitacao.log-cancela AT ROW 3.25 COL 77 WIDGET-ID 72
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .88
     amkt-solicitacao.data-solicitacao AT ROW 4.75 COL 20 COLON-ALIGNED WIDGET-ID 50 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     amkt-solicitacao.vl-solicitacao AT ROW 4.75 COL 48 COLON-ALIGNED WIDGET-ID 48
          LABEL "Valor Solicita‡Æo"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-vl-aprov AT ROW 4.75 COL 73 COLON-ALIGNED WIDGET-ID 80 NO-TAB-STOP 
     amkt-solicitacao.dt-validade-inicial AT ROW 5.75 COL 20 COLON-ALIGNED WIDGET-ID 54
          LABEL "Data In¡cio A‡Æo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     amkt-solicitacao.dt-validade-final AT ROW 5.75 COL 48 COLON-ALIGNED WIDGET-ID 52
          LABEL "Data Fim A‡Æo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     amkt-solicitacao.payback-dias AT ROW 5.75 COL 73 COLON-ALIGNED WIDGET-ID 60
          LABEL "Öndice de Viab." FORMAT "->,>>>,>>"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     amkt-solicitacao.cd-acao AT ROW 6.75 COL 20 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-acao AT ROW 6.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     amkt-solicitacao.cod-emitente AT ROW 7.75 COL 20 COLON-ALIGNED WIDGET-ID 12
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-emitente AT ROW 7.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     amkt-solicitacao.cod-rep AT ROW 8.75 COL 20 COLON-ALIGNED WIDGET-ID 14
          LABEL "Representante"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-repres AT ROW 8.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     amkt-solicitacao.cd-tipo-acao AT ROW 9.75 COL 20 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-tipo-acao AT ROW 9.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     amkt-solicitacao.cd-publico-alvo AT ROW 10.75 COL 20 COLON-ALIGNED WIDGET-ID 10
          LABEL "P£blico Alvo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-publico-alvo AT ROW 10.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     amkt-solicitacao.cd-justificativa AT ROW 11.75 COL 20 COLON-ALIGNED WIDGET-ID 8
          LABEL "Justificativa"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-justificativa AT ROW 11.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     amkt-solicitacao.cd-forma-pagto AT ROW 13.25 COL 18 COLON-ALIGNED WIDGET-ID 6
          LABEL "Forma Pagto"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-forma-pagto AT ROW 13.25 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi-desc-tipo-pagto AT ROW 13.25 COL 71 COLON-ALIGNED NO-LABEL WIDGET-ID 74 NO-TAB-STOP 
     amkt-solicitacao.forma-pagto-cd-banco AT ROW 14.25 COL 18 COLON-ALIGNED WIDGET-ID 20
          LABEL "Banco"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     amkt-solicitacao.forma-pagto-nome-banco AT ROW 14.25 COL 45 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 27.86 BY .88
     amkt-solicitacao.forma-pagto-tipo AT ROW 15.25 COL 18 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Conta Corrente","Conta Poupan‡a" 
          DROP-DOWN-LIST
          SIZE 16.14 BY 1
     amkt-solicitacao.forma-pagto-agencia AT ROW 15.25 COL 45 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     amkt-solicitacao.forma-pagto-conta AT ROW 15.25 COL 71 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     amkt-solicitacao.forma-pagto-favorecido AT ROW 16.25 COL 18 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 43.14 BY .88
     amkt-solicitacao.forma-pagto-cpf-cnpj AT ROW 16.25 COL 71 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     "Pagamento" VIEW-AS TEXT
          SIZE 8.43 BY .54 AT ROW 12.75 COL 3 WIDGET-ID 34
     rt-key AT ROW 1 COL 1
     RECT-18 AT ROW 13 COL 2 WIDGET-ID 32
     RECT-19 AT ROW 4.5 COL 1 WIDGET-ID 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: emsdocol.amkt-solicitacao
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
         HEIGHT             = 16.5
         WIDTH              = 89.29.
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

/* SETTINGS FOR FILL-IN amkt-solicitacao.cd-forma-pagto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.cd-justificativa IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.cd-publico-alvo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.cod-emitente IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.cod-rep IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.cod-situacao IN FRAME f-main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN amkt-solicitacao.data-solicitacao IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN amkt-solicitacao.dt-validade-final IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.dt-validade-inicial IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-desc-acao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-forma-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-justificativa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-publico-alvo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-repres IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-tipo-acao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-tipo-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-situacao-unif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-aprov IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.forma-pagto-cd-banco IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX amkt-solicitacao.log-cancela IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX amkt-solicitacao.log-encerra IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN amkt-solicitacao.payback-dias IN FRAME f-main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN amkt-solicitacao.vl-solicitacao IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME amkt-solicitacao.cd-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cd-acao V-table-Win
ON LEAVE OF amkt-solicitacao.cd-acao IN FRAME f-main /* Cod. A‡Æo */
DO:
    FIND FIRST amkt-acao NO-LOCK WHERE
               amkt-acao.cd-acao = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cd-acao NO-ERROR.
    ASSIGN fi-desc-acao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL amkt-acao THEN amkt-acao.descricao ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cd-forma-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cd-forma-pagto V-table-Win
ON LEAVE OF amkt-solicitacao.cd-forma-pagto IN FRAME f-main /* Forma Pagto */
DO:
    ASSIGN fi-desc-forma-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           fi-desc-tipo-pagto :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST amkt-forma-pagto NO-LOCK
        WHERE amkt-forma-pagto.cd-forma-pagto = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cd-forma-pagto:
        ASSIGN fi-desc-forma-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = amkt-forma-pagto.descricao.
        ASSIGN fi-desc-tipo-pagto :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(amkt-forma-pagto.tipo-pagto, "Bonificado,Abatimento,Adiantamento") NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cd-justificativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cd-justificativa V-table-Win
ON LEAVE OF amkt-solicitacao.cd-justificativa IN FRAME f-main /* Justificativa */
DO:
    ASSIGN fi-desc-justificativa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST amkt-justificativa NO-LOCK
        WHERE amkt-justificativa.cd-justificativa = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cd-justificativa:
        ASSIGN fi-desc-justificativa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = amkt-justificativa.descricao.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cd-publico-alvo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cd-publico-alvo V-table-Win
ON LEAVE OF amkt-solicitacao.cd-publico-alvo IN FRAME f-main /* P£blico Alvo */
DO:
    ASSIGN fi-desc-publico-alvo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST amkt-publico-alvo NO-LOCK
        WHERE amkt-publico-alvo.cd-publico-alvo = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cd-publico-alvo:
        ASSIGN fi-desc-publico-alvo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = amkt-publico-alvo.descricao.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cd-tipo-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cd-tipo-acao V-table-Win
ON LEAVE OF amkt-solicitacao.cd-tipo-acao IN FRAME f-main /* Tipo A‡Æo */
DO:
    ASSIGN fi-desc-tipo-acao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST amkt-tipo-acao NO-LOCK
        WHERE amkt-tipo-acao.cd-tipo-acao = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cd-tipo-acao:
        ASSIGN fi-desc-tipo-acao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = amkt-tipo-acao.descricao.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cod-emitente V-table-Win
ON LEAVE OF amkt-solicitacao.cod-emitente IN FRAME f-main /* Cliente */
DO:
    ASSIGN fi-desc-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cod-emitente:
        ASSIGN fi-desc-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = emitente.nome-emit.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME amkt-solicitacao.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL amkt-solicitacao.cod-rep V-table-Win
ON LEAVE OF amkt-solicitacao.cod-rep IN FRAME f-main /* Representante */
DO:
    ASSIGN fi-desc-repres:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FOR FIRST repres NO-LOCK
        WHERE repres.cod-rep = INPUT FRAME {&FRAME-NAME} amkt-solicitacao.cod-rep:
        ASSIGN fi-desc-repres:SCREEN-VALUE IN FRAME {&FRAME-NAME} = repres.nome.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF
/************************ INTERNAL PROCEDURES ********************/

{dop/fn-situacao-unif-amkt.i} // defini‡Æo da fun‡Æo fn-situacao-unif-amkt

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "amkt-solicitacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "amkt-solicitacao"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

APPLY "LEAVE" TO amkt-solicitacao.cd-acao          IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cod-emitente     IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cod-rep          IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cd-tipo-acao     IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cd-publico-alvo  IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cd-justificativa IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO amkt-solicitacao.cd-forma-pagto   IN FRAME {&FRAME-NAME}.

EMPTY TEMP-TABLE ttg-dpd607-sell-in.
IF AVAIL amkt-solicitacao THEN DO:
    FOR EACH amkt-solicitacao-sell-in OF amkt-solicitacao NO-LOCK:
        CREATE ttg-dpd607-sell-in.
        ASSIGN ttg-dpd607-sell-in.numero   = amkt-solicitacao-sell-in.numero
               ttg-dpd607-sell-in.ano      = amkt-solicitacao-sell-in.ano
               ttg-dpd607-sell-in.vl-tipo  = amkt-solicitacao-sell-in.vl-sell-in-futuro.
    END.
END.

IF VALID-HANDLE(h-folder) AND h-folder:CURRENT-WINDOW <> ? /* manter as duas valida‡äes da h-folder */ THEN DO:
    IF AVAIL amkt-solicitacao AND amkt-solicitacao.log-cancela = YES THEN
        RUN enable-folder-page IN h-folder(5). // folder Cancelamento
    ELSE
        RUN disable-folder-page IN h-folder(5). // folder Cancelamento
END.

ASSIGN fi-situacao-unif:SCREEN-VALUE IN FRAME f-main = fn-situacao-unif-amkt(INPUT FRAME f-main amkt-solicitacao.numero).

FIND LAST amkt-solic-pagto NO-LOCK WHERE
          amkt-solic-pagto.numero         = amkt-solicitacao.numero AND
          amkt-solic-pagto.situacao-pagto = 2 /* aprovada */        NO-ERROR.
ASSIGN fi-vl-aprov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL amkt-solic-pagto THEN STRING(amkt-solic-pagto.valor) ELSE "0".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle-folder V-table-Win 
PROCEDURE pi-handle-folder :
DEFINE INPUT  PARAMETER p-folder AS HANDLE      NO-UNDO.

ASSIGN h-folder = p-folder.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "amkt-solicitacao"}

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

