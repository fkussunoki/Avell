&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/*** Seguranáa por estabelecimento ***/
&scoped-define TTONLY YES    
{include/i-estab-security.i}
/*** Seguranáa por estabelecimento ***/


/* global variable definitions */

DEF NEW GLOBAL SHARED VAR GR-ITEM         AS ROWID NO-UNDO.
def new global shared var gr-pedido-compr as rowid no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.


def var h-acomp           as handle  no-undo.
DEF VAR h_api_cta_ctbl    AS HANDLE  NO-UNDO.
DEF VAR h_api_ccusto      AS HANDLE  NO-UNDO.


DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem         NO-UNDO.
DEF VAR i-num-pedido         LIKE pedido-compr.num-pedido           NO-UNDO.
def var c-empresa            like ordem-compra.ep-codigo            no-undo.
DEF VAR v_cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto     NO-UNDO.
DEF VAR v_cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl NO-UNDO.
DEF VAR v_cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl             NO-UNDO.
DEF VAR v_cod_empresa_ems5   LIKE emsuni.empresa.cod_empresa        NO-UNDO.

def var v_des_cta_ctbl      as char        no-undo.
def var v_num_tip_cta_ctbl  as char        no-undo. 
def var v_num_sit_cta_ctbl  as char        no-undo. 
def var v_ind_finalid_cta   as char        no-undo. 
def var v_log_utz_ccusto    as logical     no-undo.
DEF VAR v_cod_formato       AS CHAR        NO-UNDO.
DEF VAR v_des_ccusto        AS CHAR        NO-UNDO.
DEF VAR v_cod_ccusto        AS CHAR        NO-UNDO.
DEF VAR l-erro              AS LOG INIT NO NO-UNDO.
DEF VAR c-estab-log         AS CHARACTER   NO-UNDO.
DEF VAR l-permissao-estab   AS LOGICAL     NO-UNDO.
DEF VAR i-cont              AS INTEGER     NO-UNDO.
DEF VAR i-dias              AS INTEGER     NO-UNDO.
DEF VAR i-nr-processo       AS INTEGER     NO-UNDO.

def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".



def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistencia".


{cdp/cd0666.i} /* Definiá∆o da tt-erro */

{dop/dfgl001.i}
{dop/dfgl001.i1}
{utp/ut-glob.i}

RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-estabel i-fornec BUTTON-1 c-it-codigo ~
c-desc-narrativa d-valor d-qtde i-cond-pagto rs-natureza fi-ct-codigo ~
fi-sc-codigo c-comentario bt-confirma bt-desenho 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-estabel d-transacao ~
d-entrega i-fornec c-desc-fornecedor c-it-codigo c-desc-item ~
c-desc-narrativa d-valor d-qtde d-preco-unit c-desc-cond-pagto i-cond-pagto ~
c-comprador c-desc-comprador rs-natureza fi-ct-codigo c-ct-titulo ~
fi-sc-codigo c-sc-titulo c-comentario 

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
DEFINE BUTTON bt-confirma 
     LABEL "Incluir Pedido" 
     SIZE 17 BY 1.13.

DEFINE BUTTON bt-desenho 
     LABEL "Anexar Arquivo" 
     SIZE 16 BY 1.13.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon/prevw-u.bmp":U
     LABEL "Button 1" 
     SIZE 4.29 BY .96.

DEFINE VARIABLE c-comentario AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 2.75 NO-UNDO.

DEFINE VARIABLE c-desc-narrativa AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 2.75 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-comprador AS CHARACTER FORMAT "x(12)":U 
     LABEL "Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-titulo AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-comprador AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornecedor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-titulo AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE d-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-preco-unit AS DECIMAL FORMAT "->>>>>>,>>9.99":U INITIAL 0 
     LABEL "Preáo Unit†rio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtde AS DECIMAL FORMAT "->>>>>>,>>9.99":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor AS DECIMAL FORMAT "->>>>>>,>>9.99":U INITIAL 0 
     LABEL "Preáo Total" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ct-codigo AS CHARACTER FORMAT "x(8)" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE fi-sc-codigo AS CHARACTER FORMAT "x(8)" 
     LABEL "Centro Custo":R13 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE i-cond-pagto AS INTEGER FORMAT " >>>9":U INITIAL 0 
     LABEL "Condiá∆o Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-fornec AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE rs-natureza AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Compra", 1,
"Serviáo", 2
     SIZE 22.14 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-cod-estabel AT ROW 1.75 COL 16 COLON-ALIGNED WIDGET-ID 42
     c-desc-estabel AT ROW 1.75 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     d-transacao AT ROW 2.75 COL 16 COLON-ALIGNED WIDGET-ID 50
     d-entrega AT ROW 2.75 COL 42.43 COLON-ALIGNED WIDGET-ID 118
     i-fornec AT ROW 3.75 COL 16 COLON-ALIGNED WIDGET-ID 52
     c-desc-fornecedor AT ROW 3.75 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     BUTTON-1 AT ROW 4.75 COL 10 WIDGET-ID 114
     c-it-codigo AT ROW 4.75 COL 16.14 COLON-ALIGNED WIDGET-ID 44
     c-desc-item AT ROW 4.75 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     c-desc-narrativa AT ROW 5.75 COL 18 NO-LABEL WIDGET-ID 122
     d-valor AT ROW 8.75 COL 16 COLON-ALIGNED WIDGET-ID 48
     d-qtde AT ROW 9.75 COL 16 COLON-ALIGNED WIDGET-ID 100
     d-preco-unit AT ROW 10.75 COL 16.14 COLON-ALIGNED WIDGET-ID 120
     c-desc-cond-pagto AT ROW 11.71 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     i-cond-pagto AT ROW 11.75 COL 16 COLON-ALIGNED WIDGET-ID 60
     c-comprador AT ROW 12.88 COL 16 COLON-ALIGNED WIDGET-ID 82
     c-desc-comprador AT ROW 12.88 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     rs-natureza AT ROW 13.96 COL 17.29 NO-LABEL WIDGET-ID 72
     fi-ct-codigo AT ROW 14.83 COL 16 COLON-ALIGNED WIDGET-ID 132
     c-ct-titulo AT ROW 14.83 COL 29.57 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     fi-sc-codigo AT ROW 15.96 COL 16 COLON-ALIGNED WIDGET-ID 134
     c-sc-titulo AT ROW 15.96 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-comentario AT ROW 17.13 COL 18.14 NO-LABEL WIDGET-ID 124
     bt-confirma AT ROW 20.71 COL 3 WIDGET-ID 78
     bt-desenho AT ROW 20.75 COL 21 WIDGET-ID 116
     "Natureza:" VIEW-AS TEXT
          SIZE 6.72 BY .67 AT ROW 13.88 COL 10.29 WIDGET-ID 76
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 5.75 COL 11 WIDGET-ID 128
     "Coment†rios:" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 17 COL 8.86 WIDGET-ID 136
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 21.29
         WIDTH              = 90.14.
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
/* SETTINGS FOR FRAME f-cad
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-cad:SCROLLABLE       = FALSE
       FRAME f-cad:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-comprador IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ct-titulo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-comprador IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornecedor IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-titulo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-entrega IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-preco-unit IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-transacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma V-table-Win
ON CHOOSE OF bt-confirma IN FRAME f-cad /* Incluir Pedido */
DO:

    ASSIGN l-erro = NO.
      
    /* valida estabelecimento */
    FIND FIRST estabelec WHERE
               estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN DO: 

         RUN utp/ut-msgs.p("show",17006,"Estabelecimento nao encontrado !").
         ASSIGN l-erro = YES.
    END.

    IF  l-estab-security-active /*seguranáa por estabelecimento*/
    AND NOT CAN-FIND (FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = INPUT FRAME {&FRAME-NAME} c-cod-estabel) THEN DO:
        RUN utp/ut-msgs.p("show",17006,"Estabelecimento informado n∆o est† liberado para seleá∆o !").
        APPLY "entry" TO c-cod-estabel IN FRAME {&FRAME-NAME}.
        ASSIGN l-erro = YES.
    END.

    /* Valida se o usuario possui permiss∆o no estabelecimento */
    ASSIGN l-permissao-estab = NO.
    
    FIND FIRST estabelecimento NO-LOCK
       WHERE estabelecimento.cod_empresa     = v_cod_empresa_ems5 NO-ERROR.
    IF AVAIL estabelecimento THEN
        ASSIGN c-estab-log = estabelecimento.cod_estab.
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
    
        FOR EACH  unid-negoc-grp-usuar NO-LOCK
            WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
            EACH  unid-negoc-estab NO-LOCK
            WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
              AND unid-negoc-estab.cod-estabel     = c-estab-log
              AND unid-negoc-estab.dat-inic-valid <= TODAY
              AND unid-negoc-estab.dat-fim-valid  >= TODAY:
    
            ASSIGN l-permissao-estab = YES.
        END.
    END.
    
    IF l-permissao-estab = NO THEN DO:

        RUN utp/ut-msgs.p("show",17006,"Usu†rio n∆o tem permiss∆o para acessar o estabelecimento informado!").
        APPLY "entry" TO c-cod-estabel IN FRAME {&FRAME-NAME}.
        ASSIGN l-erro = YES.
    END.

   /* valida fornecedor  */
    FIND FIRST emitente WHERE
              emitente.cod-emitente = int(i-fornec:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE emitente THEN DO:
         RUN utp/ut-msgs.p("show",17006,"Fornecedor nao encontrado !").
         ASSIGN l-erro = YES.
    END.

    FIND FIRST ITEM WHERE
               ITEM.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
    IF NOT AVAIL   ITEM THEN DO:
         RUN utp/ut-msgs.p("show",17006,"ITEM nao encontrado !").
         ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF ITEM.tipo-contr <> 4 /*igual de Debito Direto */  THEN DO:
           RUN utp/ut-msgs.p("show",17006,"Somente itens debito direto sao permitidos serem informados !").
           ASSIGN l-erro = YES.
        END.
    END.

    IF dec(d-valor:SCREEN-VALUE IN FRAME f-cad) = 0 THEN DO:
         RUN utp/ut-msgs.p("show",17006,"Preáo TOTAL 0 nao permitido !").
         ASSIGN l-erro = YES.
    END.

    IF dec(d-qtde:SCREEN-VALUE IN FRAME f-cad) = 0 THEN DO:
         RUN utp/ut-msgs.p("show",17006,"Quantidade 0 nao permitida !").
         ASSIGN l-erro = YES.
    END.

    FIND FIRST cond-pagto WHERE
               cond-pagto.cod-cond-pag = int(i-cond-pagto:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.
    IF NOT AVAIL   cond-pagto THEN DO:
         RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento nao encontrado !").
         ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF cond-pagto.cod-cond-pag = 1 THEN DO:
            RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento A Vista N∆o Permitida !").
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            IF cond-pagto.cod-cond-pag >= 100
            AND cond-pagto.cod-cond-pag < 1000 THEN DO:
                RUN utp/ut-msgs.p("show",17006,"Condicao de pagamento N∆o Permitida Para Pedido de Compras !").
                ASSIGN l-erro = YES.
            END.
        END.

    END.

    IF fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad = "" THEN DO:

         RUN utp/ut-msgs.p("show",17006,"Conta nao encontrada !").
         ASSIGN l-erro = YES.
    END.

    FIND FIRST comprador WHERE
               comprador.cod-comprado = c-comprador:SCREEN-VALUE IN FRAME f-cad  NO-LOCK NO-ERROR.
    IF NOT AVAIL   comprador THEN DO:
         RUN utp/ut-msgs.p("show",17006,"Comprador nao encontrado !").
         ASSIGN l-erro = YES.
    END.

    /* validaá∆o conta cont†bil  X CCUSTO */
    IF l-erro = NO  THEN DO:
    
        RUN pi-valida-bt-confirma.
    END.
    
    /* Fim validaá∆o conta cont†bil */ 
    
    IF l-erro = NO THEN DO: 
        /* inclus∆o de validaá∆o referente ao usu†rio materiais x contas cont†beis manutená∆o */
        IF CAN-FIND(FIRST dc-usuar-solic-comp
                    WHERE dc-usuar-solic-comp.ct-codigo = fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad 
                    AND   dc-usuar-solic-comp.sc-codigo = fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad ) THEN DO:
    
            FIND FIRST dc-usuar-solic-comp
                WHERE dc-usuar-solic-comp.ct-codigo = fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad 
                AND   dc-usuar-solic-comp.sc-codigo = fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad 
                AND   dc-usuar-solic-comp.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
    
            IF NOT AVAIL dc-usuar-solic-comp THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Usu†rio sem permiss∆o para incluir esta solicitaá∆o." + 
                                         "~~" + 
                                         "Usu†rio " + v_cod_usuar_corren + " n∆o possui permiss∆o para incluir " +
                                         "solicitaá‰es para esta conta/centro de custo." + " (Programa ESCD1700)").
                ASSIGN l-erro = YES.
            END.
        END.
        ELSE IF CAN-FIND(FIRST dc-usuar-solic-comp
                         WHERE dc-usuar-solic-comp.ct-codigo =fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad 
                           AND dc-usuar-solic-comp.sc-codigo = "") THEN DO:
    
            FIND FIRST dc-usuar-solic-comp
                 WHERE dc-usuar-solic-comp.ct-codigo = fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad 
                   AND dc-usuar-solic-comp.sc-codigo = ""
                   AND dc-usuar-solic-comp.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
    
            IF NOT AVAIL dc-usuar-solic-comp THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Usu†rio sem permiss∆o para incluir esta solicitaá∆o." + 
                                         "~~" + 
                                         "Usu†rio " + v_cod_usuar_corren + " n∆o possui permiss∆o para incluir " +
                                         "solicitaá‰es para esta conta/centro de custo." + "(Programa ESCD1700)").
    
                ASSIGN l-erro = YES.
            END.
        END.
    END.

    IF l-erro = NO THEN DO: /* nao apresentou erro de validacao */

        EMPTY TEMP-TABLE tt_xml_input_1.


        /* FIND LAST proc-compra  NO-LOCK NO-ERROR.                                    */
        /* IF AVAIL  proc-compra  THEN                                                 */
        /*      ASSIGN i-nr-processo = proc-compra.nr-processo + 1.                    */
        /* ELSE ASSIGN i-nr-processo = 1.                                              */
        /*                                                                             */
        /* create proc-compra.                                                         */
        /* assign proc-compra.nr-processo  = i-nr-processo                             */
        /*        proc-compra.cod-comprado = v_cod_usuar_corren                        */
        /*        proc-compra.dt-inicio    = TODAY                                     */
        /*        proc-compra.descricao    = c-comentario:SCREEN-VALUE IN FRAME f-cad. */
        /* &if defined(bf_mat_contratos) &then                                         */
        /*     assign substr(proc-compra.char-1,1,3) = c-cod_estab.                    */
        /* &endif                                                                      */

        //verificando primeiro se ha verba orcamentaria suficiente para geracao do pedido:
        //19.09.2019 - FLAVIO KUSSUNOKI
        // Inserida logica para execucao orcamentaria
        // o programa passa "origem de movimento" 18 (COTACAO)
        // Se utilizar qualquer codigo customizado (ACIMA DE 90), a execuá∆o oráament∆ria
        // nao elimina a cotaáao apos o Recebimento Fiscal (RE1001).
        

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Funá∆o"
               tt_xml_input_1.tt_des_conteudo    = "Verifica"
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Empresa"
               tt_xml_input_1.tt_des_conteudo    = c-empresa
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

/*         create tt_xml_input_1.                                          */
/*         assign tt_xml_input_1.tt_cod_label       = "Plano Contas"       */
/*                tt_xml_input_1.tt_des_conteudo    = "PCDOCOL"            */
/*                tt_xml_input_1.tt_num_seq_1_xml   = 1                    */
/*                tt_xml_input_1.tt_num_seq_2_xml   = 0.                   */
/*                                                                         */
/*         create tt_xml_input_1.                                          */
/*         assign tt_xml_input_1.tt_cod_label       = "Plano Centro Custo" */
/*                tt_xml_input_1.tt_des_conteudo    = "CCDOCOL"            */
/*                tt_xml_input_1.tt_num_seq_1_xml   = 1                    */
/*                tt_xml_input_1.tt_num_seq_2_xml   = 0.                   */
/*                                                                         */

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
               tt_xml_input_1.tt_des_conteudo    = fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
               tt_xml_input_1.tt_des_conteudo    = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
               tt_xml_input_1.tt_des_conteudo   = STRING(d-entrega:SCREEN-VALUE IN FRAME f-cad)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
               tt_xml_input_1.tt_des_conteudo   = "0"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
               tt_xml_input_1.tt_des_conteudo   = STRING(d-valor:SCREEN-VALUE IN FRAME f-cad)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
               tt_xml_input_1.tt_des_conteudo   = STRING(d-qtde:SCREEN-VALUE IN FRAME f-cad)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
               tt_xml_input_1.tt_des_conteudo   = "18" //cotacao, nao Ç possivel usar o customizado
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
               tt_xml_input_1.tt_des_conteudo   = "Testando"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
               tt_xml_input_1.tt_des_conteudo   = "DOC"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
               tt_xml_input_1.tt_des_conteudo    = STRING(fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad)
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        RUN prgfin/bgc/bgc700za.py (input 1,
                                    input table tt_xml_input_1,
                                    output table tt_log_erros) .  


        FIND FIRST tt_log_erros NO-LOCK NO-ERROR.

        IF AVAIL tt_log_erros THEN DO:

            RUN dop/MESSAGE.p (INPUT "O Pedido nao gerado!",
                                INPUT "Motivo: " + tt_log_erros.ttv_des_ajuda).
            RETURN 'NOK'.

        END.

        ELSE DO:
        
       
        RUN dop/dco002a.p 
                      (INPUT  c-it-codigo:SCREEN-VALUE IN FRAME f-cad,        /* ITEM */
                       INPUT  dec(d-qtde:SCREEN-VALUE IN FRAME f-cad),        /* QTDE */
                       INPUT  d-transacao:SCREEN-VALUE IN FRAME f-cad,        /* DATA */
                       INPUT  0,                                              /* ORDEM PRODUCAO */
                       INPUT  fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad,       /* Conta Contabil */
                       INPUT  fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad,       /* centro custo   */
                       INPUT  int(rs-natureza:SCREEN-VALUE IN FRAME f-cad),   /* Natureza - 1-Compra, 2-Servico e 3-Beneficiamento */
                       INPUT  1,                                              /* I-CODIGO-ICM 1-consumo 2-industrializacao */
                       INPUT  c-comentario:SCREEN-VALUE IN FRAME f-cad,       /* comentario */
                       INPUT  c-desc-narrativa:SCREEN-VALUE IN FRAME f-cad,   /* narrativa  */
                       INPUT  0,                                              /* num-seq-item  */
                       INPUT  int(i-fornec:SCREEN-VALUE IN FRAME f-cad),      /* fornecedor */
                       INPUT  DEC(d-valor:SCREEN-VALUE IN FRAME f-cad),       /* preco-cotacao */
                       INPUT  INT(i-cond-pagto:SCREEN-VALUE IN FRAME f-cad),  /* condicao de pagamento */
                       INPUT  c-comprador:SCREEN-VALUE IN FRAME f-cad ,       /* comprador */
                       INPUT  0,                                              /* processo compras */
                       INPUT  0,                                              /* ao informar num-pedido = 0 sera criado um pedido a cada execucao, se for informado o nr sera criado somente 1 pedido */
                       INPUT  "dcc108",                                       /* programa chamador */
                       INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME f-cad,
                       OUTPUT i-numero-ordem,                                 /* retorno nr ordem compra gerada */
                       OUTPUT i-num-pedido,                                   /* retorno num pedido de compra gerado */
                       OUTPUT TABLE tt-erro).                                 /* retorno erro */


        FIND FIRST tt-erro NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-erro THEN DO:
       
           IF i-numero-ordem > 0 THEN DO:
       
              FIND FIRST doc-pend-aprov 
                   WHERE doc-pend-aprov.numero-ordem = i-numero-ordem             
                     AND doc-pend-aprov.num-pedido   = i-num-pedido                
                     AND doc-pend-aprov.ind-tip-doc  = 6
                     AND doc-pend-aprov.ind-situacao = 1
                     AND doc-pend-aprov.it-codigo    = c-it-codigo NO-LOCK NO-ERROR.
              IF AVAIL doc-pend-aprov THEN
                  RUN utp/ut-msgs.p("show",15825,"Geraá∆o Pedido Compra efetuado com sucesso !" + "~~" + "Pedido Compra: " + string(i-num-pedido) + " Ordem de compra : " + STRING(i-numero-ordem) + "." + "                                            "  + "Foi gerado pendància de aprovaá∆o para o pedido de compras."  ).
              ELSE 
                  RUN utp/ut-msgs.p("show",15825,"Geraá∆o Pedido Compra efetuado com sucesso !" + "~~" + "Pedido Compra: " + string(i-num-pedido) + " Ordem de compra : " + STRING(i-numero-ordem) + ".").
       
              //Alterando a temp-table para poder atualizar os dados orcamentarios com nome de Verifica e Atualiza.
              FIND FIRST tt_xml_input_1 WHERE tt_xml_input_1.tt_cod_label = "Funcao" NO-ERROR.
              ASSIGN tt_xml_input_1.tt_des_conteudo    = "Verifica e Atualiza". 

              FIND FIRST tt_xml_input_1 WHERE tt_xml_input_1.tt_cod_label = "ID Movimento" NO-ERROR.
              ASSIGN tt_xml_input_1.tt_des_conteudo   = STRING(i-numero-ordem) + chr(10) + "1".   

             
              RUN prgfin/bgc/bgc700za.py (input 1,
                                          input table tt_xml_input_1,
                                          output table tt_log_erros) .

              // Nao Ç executada nova conferencia, pois nao Ç para haver mais erros no momento.


              ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.cod-estabel
                     c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = ""
                     i-fornec:SCREEN-VALUE IN FRAME f-cad = ""
                     c-desc-fornecedor:SCREEN-VALUE IN FRAME f-cad = ""
                     c-it-codigo:SCREEN-VALUE IN FRAME f-cad = ""
                     c-desc-item:SCREEN-VALUE IN FRAME f-cad = ""
                     c-desc-narrativa:SCREEN-VALUE IN FRAME f-cad = ""
                     d-valor:SCREEN-VALUE IN FRAME f-cad = ""
                     d-qtde:SCREEN-VALUE IN FRAME f-cad = ""
                     d-preco-unit:SCREEN-VALUE IN FRAME f-cad = ""
                     i-cond-pagto:SCREEN-VALUE IN FRAME f-cad = ""
                     c-desc-cond-pagto:SCREEN-VALUE IN FRAME f-cad = ""
                     fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad = ""
                     c-ct-titulo:SCREEN-VALUE IN FRAME f-cad = ""
                     fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad = ""
                     c-sc-titulo:SCREEN-VALUE IN FRAME f-cad = ""
                     c-comentario:SCREEN-VALUE IN FRAME f-cad = ""
                     d-transacao:SCREEN-VALUE IN FRAME f-cad = string(TODAY) 
                     d-entrega:SCREEN-VALUE IN FRAME f-cad = string(TODAY).
       
                      ENABLE fi-sc-codigo WITH FRAME F-CAD.
                      FIND FIRST usuar-mater WHERE
                                    usuar-mater.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
                      IF AVAIL usuar-mater THEN  
                           ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad = usuar-mater.sc-codigo.
                      ELSE ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad = "".
       
       

              APPLY 'value-changed' TO c-cod-estabel IN FRAME f-cad.
       
              {&OPEN-QUERY-br-consulta}
              RETURN "OK".

           END.
        END.
        ELSE DO:
       
              RUN utp/ut-msgs.p("show",17006,"N∆o foi poss°vel gerar o pedido de compras !" + "~~" + tt-erro.mensagem ).
              RETURN "NOK". 
       
        END.
    END.
    END.

    ELSE RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desenho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desenho V-table-Win
ON CHOOSE OF bt-desenho IN FRAME f-cad /* Anexar Arquivo */
DO:
  RUN doepc\cd1406a2x.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME f-cad /* Button 1 */
DO:
  RUN doepc\cd1406a4x.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON f5 OF c-cod-estabel IN FRAME f-cad /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON LEAVE OF c-cod-estabel IN FRAME f-cad /* Estabelecimento */
DO:
  RUN pi-valida-estab-plano (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME f-cad,
                             INPUT "LEAVE" ).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON mouse-select-dblclick OF c-cod-estabel IN FRAME f-cad /* Estabelecimento */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comprador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comprador V-table-Win
ON f5 OF c-comprador IN FRAME f-cad /* Respons†vel */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in055.w"
                   &campo=c-comprador
                   &campozoom=cod-comprado
                   &campo2=c-desc-comprador
                   &campozoom2=nome}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comprador V-table-Win
ON LEAVE OF c-comprador IN FRAME f-cad /* Respons†vel */
DO:

   FIND FIRST comprador WHERE
              comprador.cod-comprado = c-comprador:SCREEN-VALUE IN FRAME f-cad  NO-LOCK NO-ERROR.
   IF AVAIL   comprador THEN DO:

      ASSIGN c-desc-comprador:SCREEN-VALUE IN FRAME f-cad = comprador.nome.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comprador V-table-Win
ON mouse-select-dblclick OF c-comprador IN FRAME f-cad /* Respons†vel */
DO:
  APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON f5 OF c-it-codigo IN FRAME f-cad /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo=c-it-codigo
                       &campozoom=it-codigo
                       &campo2=c-desc-item
                       &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON LEAVE OF c-it-codigo IN FRAME f-cad /* Item */
DO:

   FIND FIRST ITEM WHERE
              ITEM.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
   IF AVAIL   ITEM THEN DO:

      ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-cad = ITEM.desc-item.
/*              c-desc-narrativa:SCREEN-VALUE IN FRAME f-cad = ITEM.narrativa. */

   END.
   ELSE       ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-cad = "".
/*              c-desc-narrativa:SCREEN-VALUE IN FRAME f-cad = "". */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON mouse-select-dblclick OF c-it-codigo IN FRAME f-cad /* Item */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-entrega V-table-Win
ON f5 OF d-entrega IN FRAME f-cad /* Data Entrega */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-entrega V-table-Win
ON LEAVE OF d-entrega IN FRAME f-cad /* Data Entrega */
DO:

   FIND FIRST estabelec WHERE
              estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
   IF AVAIL   estabelec THEN DO:

      ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-entrega V-table-Win
ON mouse-select-dblclick OF d-entrega IN FRAME f-cad /* Data Entrega */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-preco-unit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-preco-unit V-table-Win
ON f5 OF d-preco-unit IN FRAME f-cad /* Preáo Unit†rio */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-preco-unit V-table-Win
ON LEAVE OF d-preco-unit IN FRAME f-cad /* Preáo Unit†rio */
DO:

   FIND FIRST estabelec WHERE
              estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
   IF AVAIL   estabelec THEN DO:

      ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-preco-unit V-table-Win
ON mouse-select-dblclick OF d-preco-unit IN FRAME f-cad /* Preáo Unit†rio */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-qtde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-qtde V-table-Win
ON f5 OF d-qtde IN FRAME f-cad /* Quantidade */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-qtde V-table-Win
ON LEAVE OF d-qtde IN FRAME f-cad /* Quantidade */
DO:
    

    ASSIGN d-preco-unit:SCREEN-VALUE IN FRAME f-cad =  string( dec(d-valor:SCREEN-VALUE IN FRAME f-cad)  / dec(d-qtde:SCREEN-VALUE IN FRAME f-cad) ) . 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-qtde V-table-Win
ON mouse-select-dblclick OF d-qtde IN FRAME f-cad /* Quantidade */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-transacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-transacao V-table-Win
ON f5 OF d-transacao IN FRAME f-cad /* Data Pedido */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-transacao V-table-Win
ON LEAVE OF d-transacao IN FRAME f-cad /* Data Pedido */
DO:

   FIND FIRST estabelec WHERE
              estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
   IF AVAIL   estabelec THEN DO:

      ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-transacao V-table-Win
ON mouse-select-dblclick OF d-transacao IN FRAME f-cad /* Data Pedido */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-valor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-valor V-table-Win
ON f5 OF d-valor IN FRAME f-cad /* Preáo Total */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-valor V-table-Win
ON LEAVE OF d-valor IN FRAME f-cad /* Preáo Total */
DO:

    ASSIGN d-preco-unit:SCREEN-VALUE IN FRAME f-cad =  string( dec(d-valor:SCREEN-VALUE IN FRAME f-cad)  / dec(d-qtde:SCREEN-VALUE IN FRAME f-cad) ) . 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-valor V-table-Win
ON mouse-select-dblclick OF d-valor IN FRAME f-cad /* Preáo Total */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo V-table-Win
ON F5 OF fi-ct-codigo IN FRAME f-cad /* Conta */
DO:
    DEF VAR c-ct-codigo LIKE nat-conta.ct-codigo NO-UNDO.
    ASSIGN c-ind-finalid-cta = v_ind_finalid_cta. /* guardar finalidade inicial */
    
    run pi_zoom_cta_ctbl_integr in h-zoom-conta (input  c-cod-empres-ems-2,
                                                 input  c-cod-modul-dtsul, /* M¢dulo */
                                                 input  c-plano-cta,
                                                 input  c-ind-finalid-cta, /* Finalidade */
                                                 input  da-dat-trans, /* Data de transaá∆o */
                                                 output c-ct-codigo, /* c¢digo da conta */
                                                 output c-ct-titulo, /* descriá∆o conta conta */
                                                 output c-ind-finalid-cta, /* Finalidade */
                                                 output table tt-log-erro). /* Temp-table de erros */
                                                 
    if c-ct-codigo <> "" THEN DO:
        assign fi-ct-codigo:screen-value in frame {&FRAME-NAME} = c-ct-codigo.
        DISP c-ct-titulo WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo V-table-Win
ON LEAVE OF fi-ct-codigo IN FRAME f-cad /* Conta */
DO:
    
    assign v_cod_cta_ctbl = INPUT FRAME {&FRAME-NAME} fi-ct-codigo no-error.
    ASSIGN c-ind-finalid-cta = v_ind_finalid_cta. /* guardar finalidade inicial */

    if v_cod_cta_ctbl <> "" then do:
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        TODAY,              /* DATA TRANSACAO */   
                                                       output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄAO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */
        
        assign fi-ct-codigo:screen-value in frame f-cad = if can-find(tt_log_erro) then "" else v_cod_cta_ctbl
               c-ct-titulo:screen-value  in frame f-cad = if can-find(tt_log_erro) then "" else v_des_cta_ctbl.

        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        /*#### UTILIZA CENTRO CUSTO #####*/
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS 2 */
                                                           input  c-cod-estabel,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,       /* CONTA */
                                                           input  TODAY,                /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,     /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).   /* ERROS */
        if not v_log_utz_ccusto then do:
            assign fi-sc-codigo:screen-value in frame f-cad = "":U
                   c-sc-titulo:screen-value  in frame f-cad = "":U
                   fi-sc-codigo:sensitive    in frame f-cad = NO.
            disable fi-sc-codigo.
        end.
        ELSE DO: 
            ENABLE fi-sc-codigo WITH FRAME {&FRAME-NAME}. 
        END.

        /*#### FORMATO #####*/
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  c-empresa,            /* EMPRESA EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  TODAY,                /* DATA DE TRANSACAO */
                                                           output v_cod_formato,        /* FORMATO CONTA */
                                                           output table tt_log_erro).   /* ERROS */
        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.
        
        /* assign fi-ct-codigo:format in frame f-cad = if can-find(tt_log_erro) then "" else  v_cod_formato  . */
    end.
    ELSE DO:
        ASSIGN  c-ct-titulo:screen-value               in frame f-cad = ""
                fi-sc-codigo:SCREEN-VALUE              in frame f-cad = "":U
                c-sc-titulo:screen-value               in frame f-cad = "":U
                fi-sc-codigo:sensitive                 in frame f-cad = NO.
        DISABLE fi-sc-codigo.
    END.





/*     RUN pi-busca-conta IN h-dfgl001 (INPUT INPUT FRAME {&FRAME-NAME} fi-ct-codigo, */
/*                                      INPUT TODAY,                                  */
/*                                      OUTPUT c-tit-cta,                             */
/*                                      OUTPUT dat-cta-inic-valid,                    */
/*                                      OUTPUT dat-cta-fim-valid,                     */
/*                                      OUTPUT c-msg).                                */
/*                                                                                    */
/*     ASSIGN c-ct-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-tit-cta.            */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ct-codigo IN FRAME f-cad /* Conta */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo V-table-Win
ON F5 OF fi-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
    DEFINE VARIABLE c-sc-codigo AS CHARACTER   NO-UNDO.

    run pi_zoom_ccusto in h-zoom-ccusto (input c-cod-empres-ems-2,
                                         input c-plano-cc,
                                         input c-cod-unid-negoc, /* Unidade de Neg¢cio */
                                         input da-dat-trans, /* Data de transaá∆o */
                                         output c-sc-codigo, /* c¢digo da conta */
                                         output c-sc-titulo, /* descriá∆o conta conta */
                                         output table tt-log-erro). /* Temp-table de erros */
                                         
    if c-sc-codigo <> "" then do:
        assign fi-sc-codigo:screen-value in frame {&frame-name} = c-sc-codigo.
        DISP c-sc-titulo WITH FRAME {&FRAME-NAME}.
    end.            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo V-table-Win
ON LEAVE OF fi-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
/*     RUN pi-busca-ccusto IN h-dfgl001 (INPUT INPUT FRAME {&FRAME-NAME} fi-sc-codigo, */
/*                                       INPUT TODAY,                                  */
/*                                       OUTPUT c-tit-cc,                              */
/*                                       OUTPUT dat-cc-inic-valid,                     */
/*                                       OUTPUT dat-cc-fim-valid,                      */
/*                                       OUTPUT c-msg).                                */
/*                                                                                     */
/*     ASSIGN c-sc-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-tit-cc.              */
    
    assign v_cod_ccusto = fi-sc-codigo:screen-value in frame f-cad.
    if v_cod_ccusto <> "" then do:
                
        /* BUSCA DADOS */
        run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                                   input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,         /* CCUSTO */
                                                   input  TODAY,                /* DATA DE TRANSACAO */
                                                   output v_des_ccusto,         /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).   /* ERROS */

        assign fi-sc-codigo:screen-value in frame f-cad = if can-find(tt_log_erro) then "" else v_cod_ccusto
               c-sc-titulo:screen-value  in frame f-cad = if can-find(tt_log_erro) then "" else v_des_ccusto.

        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        /* FORMATO */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CCUSTO */
                                                       input  TODAY,                /* DATA DE TRANSACAO */
                                                       output v_cod_formato,        /* FORMATO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */
        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        if not can-find(tt_log_erro) then
            assign fi-sc-codigo:format in frame f-cad =  v_cod_formato   .
    end.
    ELSE ASSIGN fi-sc-codigo :screen-value in frame f-cad = "".

 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto V-table-Win
ON f5 OF i-cond-pagto IN FRAME f-cad /* Condiá∆o Pagamento */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                       &campo=i-cond-Pagto
                       &campozoom=cod-cond-pag
                       &campo2=c-desc-cond-pagto
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto V-table-Win
ON LEAVE OF i-cond-pagto IN FRAME f-cad /* Condiá∆o Pagamento */
DO:

   FIND FIRST cond-pagto WHERE
              cond-pagto.cod-cond-pag = int(i-cond-pagto:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.
   IF AVAIL   cond-pagto THEN DO:

      ASSIGN c-desc-cond-pagto:SCREEN-VALUE IN FRAME f-cad = cond-pagto.descricao.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto V-table-Win
ON mouse-select-dblclick OF i-cond-pagto IN FRAME f-cad /* Condiá∆o Pagamento */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fornec V-table-Win
ON f5 OF i-fornec IN FRAME f-cad /* Fornecedor */
DO:
     {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo=i-fornec
                         &campozoom=cod-emitente
                         &campo2=c-desc-fornecedor
                         &campozoom2=nome-abrev}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fornec V-table-Win
ON LEAVE OF i-fornec IN FRAME f-cad /* Fornecedor */
DO:

  FIND FIRST emitente WHERE
             emitente.cod-emitente = int(i-fornec:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.
  IF AVAILABLE emitente THEN DO:
     ASSIGN c-desc-fornecedor:SCREEN-VALUE IN FRAME f-cad = emitente.nome-abrev.
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fornec V-table-Win
ON mouse-select-dblclick OF i-fornec IN FRAME f-cad /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

c-cod-estabel:load-mouse-pointer("image\lupa.cur") in frame f-cad.
i-fornec:load-mouse-pointer("image\lupa.cur") in frame f-cad.
c-it-codigo:load-mouse-pointer("image\lupa.cur") in frame f-cad.
i-cond-pagto:load-mouse-pointer("image\lupa.cur") in frame f-cad.
fi-ct-codigo:load-mouse-pointer("image\lupa.cur") in frame f-cad.
fi-sc-codigo:load-mouse-pointer("image\lupa.cur") in frame f-cad.
c-comprador:load-mouse-pointer("image\lupa.cur") in frame f-cad.


ASSIGN i-fornec:SCREEN-VALUE IN FRAME f-cad = "0"
       d-valor :SCREEN-VALUE IN FRAME f-cad = "0,00"
       d-qtde  :SCREEN-VALUE IN FRAME f-cad = "0,00"
       i-cond-pagto:SCREEN-VALUE IN FRAME f-cad = "0"
       d-preco-unit:SCREEN-VALUE IN FRAME f-cad = "0,00".

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

/* Validaá∆o empresaa / Estabelecimento / Plano contas e Plano CCusto */
FIND FIRST emsuni.estabelecimento NO-LOCK
     WHERE emsuni.estabelecimento.cod_empresa  = v_cod_empres_usuar
       AND emsuni.estabelecimento.log_estab_princ NO-ERROR.

FIND FIRST matriz_trad_org_ext NO-LOCK
    WHERE matriz_trad_org_ext.ind_orig_org_ext = "EMS2" NO-ERROR.
FIND FIRST trad_org_ext NO-LOCK
    WHERE trad_org_ext.cod_tip_unid_organ = "998"
    AND   trad_org_ext.cod_unid_organ = v_cod_empres_usuar NO-ERROR.
IF AVAIL trad_org_ext THEN
    ASSIGN c-empresa = trad_org_ext.cod_unid_organ_ext.


FIND FIRST estabelec WHERE
          estabelec.ep-codigo = c-empresa NO-LOCK NO-ERROR.
IF AVAIL   estabelec THEN DO:

  ASSIGN c-cod-estabel:SCREEN-VALUE  IN FRAME f-cad = estabelec.cod-estabel
         c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.
         v_cod_empresa_ems5 = v_cod_empres_usuar.
END.

RUN pi-valida-estab-plano (INPUT c-cod-estabel,
                           INPUT "Main" ).


FIND FIRST comprador NO-LOCK
    WHERE comprador.cod-comprado = v_cod_usuar_corren NO-ERROR.
IF NOT AVAIL comprador THEN DO:
   RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa  !").
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.
ELSE DO:
   FIND FIRST usuar-mater WHERE
              usuar-mater.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
   IF NOT AVAIL usuar-mater THEN DO:
      RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa ! ").
      APPLY "CLOSE" TO THIS-PROCEDURE.
   END.
   ELSE DO:
       IF usuar-mater.usuar-comprador = NO THEN DO:
           RUN utp/ut-msgs.p("show",17006,"Usuario nao Ç comprador, nao tem permiss∆o para utilizaá∆o deste programa ! ").
           APPLY "CLOSE" TO THIS-PROCEDURE.
       END.
   END.
END.

ASSIGN d-transacao:SCREEN-VALUE IN FRAME f-cad = string(TODAY).
ASSIGN d-entrega:SCREEN-VALUE IN FRAME f-cad = string(TODAY).

FIND FIRST ITEM WHERE
          ITEM.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
IF AVAIL   ITEM THEN DO:

  ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-cad = ITEM.desc-item.

END.

/* ASSIGN comprador-ini:SCREEN-VALUE IN FRAME f-con = v_cod_usuar_corren  */
/*        comprador-fim:SCREEN-VALUE IN FRAME f-con = v_cod_usuar_corren. */

FIND FIRST usuar-mater WHERE
              usuar-mater.cod-usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
IF AVAIL usuar-mater THEN  
     ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad = usuar-mater.sc-codigo.
ELSE ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad = "".

ASSIGN c-comprador:SCREEN-VALUE IN FRAME f-cad = v_cod_usuar_corren.
FIND FIRST comprador WHERE
          comprador.cod-comprado = c-comprador:SCREEN-VALUE IN FRAME f-cad  NO-LOCK NO-ERROR.
IF  AVAIL   comprador THEN DO:
    ASSIGN c-desc-comprador:SCREEN-VALUE IN FRAME f-cad = comprador.nome.
END.
ELSE ASSIGN c-desc-comprador:SCREEN-VALUE IN FRAME f-cad = "" .
 





/* find first param-compra no-lock no-error.            */
/* if  avail param-compra then do:                      */
/*  assign i-prim-pedido = param-compra.num-pedido-ini  */
/*         i-ult-pedido  = param-compra.num-pedido-fim. */
/* end.                                                 */

/* FIND last pedido-compr where                                        */
/*           pedido-compr.num-pedido <= i-ult-pedido no-lock no-error. */
/* if  avail pedido-compr then                                         */
/*     if (pedido-compr.num-pedido + 1) > i-ult-pedido or              */
/*        (pedido-compr.num-pedido + 1) < i-prim-pedido then           */
/*          assign i-nr-pedido = i-prim-pedido.                        */
/*     ELSE assign i-nr-pedido = pedido-compr.num-pedido + 1.          */
/* ELSE     assign i-nr-pedido = i-prim-pedido.                        */
/*                                                                     */

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
  HIDE FRAME f-cad.
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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

find first estabelec no-lock
     where estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad no-error.
assign c-empresa = estabelec.ep-codigo when avail estabelec.


/*   IF gr-item <> ? THEN DO:                                                         */
/*       FIND FIRST ITEM NO-LOCK                                                      */
/*           WHERE rowid(ITEM) = gr-item NO-ERROR.                                    */
/*       IF AVAIL ITEM THEN                                                           */
/*           ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ITEM.it-codigo. */
/*   END.                                                                             */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida V-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-bt-confirma V-table-Win 
PROCEDURE pi-valida-bt-confirma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* validaá∆o conta cont†bil  X CCUSTO */
    find first criter_distrib_cta_ctbl NO-LOCK
        WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        AND   criter_distrib_cta_ctbl.cod_cta_ctbl       = fi-ct-codigo:SCREEN-VALUE IN FRAME f-cad /* Conta Cont†bil */
        AND   criter_distrib_cta_ctbl.cod_estab          = estabelecimento.cod_estab
        AND   criter_distrib_cta_ctbl.dat_inic_valid    <= TODAY                          
        AND   criter_distrib_cta_ctbl.dat_fim_valid     >= TODAY no-error.
    if not avail criter_distrib_cta_ctbl then DO:
        RUN utp/ut-msgs.p("show",17006,"N∆o Foi encontrado CritÇrio de Distribuiá∆o para Conta Cont†bil !").
        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        if criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/  then do:
            find first mapa_distrib_ccusto NO-LOCK 
                 where mapa_distrib_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab 
                 AND   mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto no-error.
            if not avail mapa_distrib_ccusto THEN DO:
                RUN utp/ut-msgs.p("show",17006,"N∆o Foi encontrado Mapa de Distribuiá∆o para Conta Cont†bil !").
                ASSIGN l-erro = YES.
            END.
            ELSE DO:
                FIND FIRST item_lista_ccusto no-lock
                    where item_lista_ccusto.cod_estab        = mapa_distrib_ccusto.cod_estab
                    AND   item_lista_ccusto.cod_mapa_distrib = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
                    AND   item_lista_ccusto.cod_empresa      = v_cod_empresa_ems5
                    AND   item_lista_ccusto.cod_plano_ccusto = v_cod_plano_ccusto
                    AND   item_lista_ccusto.cod_ccusto       = fi-sc-codigo:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
                IF NOT AVAIL ITEM_lista_ccusto THEN DO:
                    RUN utp/ut-msgs.p("show",17006,"Conta Cont†bil n∆o permite lanáamento para o Centro de Custo! Verifique Item Mapa de Distribuiá∆o.").
                    ASSIGN l-erro = YES.
                END.
            END.
        END.
    END.
    /* Fim validaá∆o conta cont†bil */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-estab-plano V-table-Win 
PROCEDURE pi-valida-estab-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def Input param p_cod_estab as CHARACTER format "x(5)" no-undo.
DEF INPUT PARAM p_funcao    as CHARACTER format "x(10)" no-undo.

IF p_funcao = "LEAVE" THEN DO: 
    FIND FIRST estabelec WHERE
               estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
    IF AVAIL   estabelec THEN DO:
       ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome
              c-empresa                                  = estabelec.ep-codigo.
    END.
    FIND FIRST matriz_trad_org_ext NO-LOCK
        WHERE matriz_trad_org_ext.ind_orig_org_ext = "EMS2" NO-ERROR.
    FIND FIRST trad_org_ext NO-LOCK
        WHERE trad_org_ext.cod_tip_unid_organ = "998"
        AND   trad_org_ext.cod_unid_organ_ext = c-empresa NO-ERROR.
    IF AVAIL trad_org_ext THEN
        ASSIGN v_cod_empresa_ems5 = trad_org_ext.cod_unid_organ
               c-empresa          = trad_org_ext.cod_unid_organ_ext.

    FIND FIRST emsuni.estabelecimento NO-LOCK
         WHERE emsuni.estabelecimento.cod_empresa  = v_cod_empresa_ems5
           AND emsuni.estabelecimento.log_estab_princ NO-ERROR.

    FIND FIRST estabelec WHERE
          estabelec.ep-codigo = c-empresa NO-LOCK NO-ERROR.
    IF AVAIL   estabelec THEN DO:
        ASSIGN c-cod-estabel:SCREEN-VALUE  IN FRAME f-cad = estabelec.cod-estabel
               c-desc-estabel:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.
    END.
END.

/*  Busca Plano CCusto da Empresa  e Plano de Contas */ 
for each plano_cta_unid_organ no-lock
    where  plano_cta_unid_organ.cod_unid_organ = v_cod_empresa_ems5
    AND    plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio"  :
    if  plano_cta_unid_organ.dat_inic_valid <= TODAY
    AND plano_cta_unid_organ.dat_fim_valid  >= TODAY then
        assign v_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.
end.
find first plano_cta_ctbl no-lock
    where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl 
    AND   plano_cta_ctbl.dat_inic_valid    <= TODAY
    AND   plano_cta_ctbl.dat_fim_valid     >= TODAY no-error.
IF NOT AVAIL plano_cta_ctbl THEN DO:
    RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo n∆o encontrado para empresa! ").
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

for each plano_ccusto no-lock
    where plano_ccusto.cod_empresa = v_cod_empresa_ems5:

    if  plano_ccusto.dat_inic_valid <= TODAY 
    and plano_ccusto.dat_fim_valid  >= TODAY then
        assign v_cod_plano_ccusto = plano_ccusto.cod_plano_ccusto.
end.

find first plano_ccusto NO-LOCK 
    where plano_ccusto.cod_empresa      = v_cod_empresa_ems5
    AND   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto
    AND   plano_ccusto.dat_inic_valid  <= TODAY
    AND   plano_ccusto.dat_fim_valid   >= TODAY no-error.       

if not avail plano_ccusto then do:
      RUN utp/ut-msgs.p("show",17006,"Plano de Centro de custo n∆o encontrado para empresa! ").
      APPLY "CLOSE" TO THIS-PROCEDURE.       
END.
/*
 
/*#### FORMATO #####*/
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  c-empresa,            /* EMPRESA EMS2 */
                                                   input  v_cod_plano_cta_ctbl, /* PLANO CONTAS */
                                                   input  TODAY,                /* DATA DE TRANSACAO */
                                                   output v_cod_formato,        /* FORMATO CONTA */
                                                   output table tt_log_erro).   /* ERROS */

IF NOT CAN-FIND(tt_log_erro) THEN
   assign fi-ct-codigo:format in frame f-cad = if can-find(tt_log_erro) then "" else  v_cod_formato  .

/* FORMATO */
run pi_retorna_formato_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                               input  v_cod_plano_ccusto,   /* PLANO CCUSTO */
                                               input  TODAY,                /* DATA DE TRANSACAO */
                                               output v_cod_formato,        /* FORMATO CCUSTO */
                                               output table tt_log_erro).   /* ERROS */

if not can-find(tt_log_erro) then
    assign fi-sc-codigo:format in frame f-cad =  v_cod_formato .
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

