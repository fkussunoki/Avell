&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-conrelaciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-conrelaciona 
{include/i-prgvrs.i DPD607 12.00.00.001}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var p-table as rowid.

{dop/fn-situacao-unif-amkt.i} // definiá∆o da funá∆o fn-situacao-unif-amkt
{dop/dpd611.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-encerra bt-cancela bt-detalhes ~
bt-cancela-2 bt-cancela-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-sequencia-realiz w-conrelaciona 
FUNCTION fn-sequencia-realiz RETURNS INTEGER(p-sequencia AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-conrelaciona AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V† para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU mi-ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  mi-ajuda       LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b01dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b03dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b04dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b05dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b06dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b08dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q01dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v01dpd607 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v02dpd607 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     IMAGE-UP FILE "o:/ems2/image/toolbar/im-can.bmp":U
     LABEL "Cancelar Solicitaá∆o" 
     SIZE 5 BY 1.42 TOOLTIP "Cancelar Solicitaá∆o".

DEFINE BUTTON bt-cancela-2 
     IMAGE-UP FILE "image/toolbar/im-pcust.bmp":U
     LABEL "Cancelar Solicitaá∆o" 
     SIZE 5 BY 1.42 TOOLTIP "Gerar Antecipaá∆o".

DEFINE BUTTON bt-cancela-3 
     IMAGE-UP FILE "image/im-aval.bmp":U
     LABEL "Cancelar Solicitaá∆o" 
     SIZE 5 BY 1.42 TOOLTIP "Baixar antecipaá∆o".

DEFINE BUTTON bt-detalhes 
     IMAGE-UP FILE "IMAGE/toolbar/im-comments.bmp":U
     LABEL "" 
     SIZE 5 BY 1.42 TOOLTIP "DinÉmica/Justificativa".

DEFINE BUTTON bt-encerra 
     IMAGE-UP FILE "image/toolbar/im-chck1.bmp":U
     LABEL "Encerrar Solicitaá∆o" 
     SIZE 5 BY 1.42 TOOLTIP "Encerrar Solicitaá∆o".

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-encerra AT ROW 1 COL 39 HELP
          "Encerrar Solicitaá∆o" WIDGET-ID 4
     bt-cancela AT ROW 1 COL 45 HELP
          "Cancelar Solicitaá∆o" WIDGET-ID 2
     bt-detalhes AT ROW 1 COL 65.57 HELP
          "DinÉmica/Justificativa" WIDGET-ID 6
     bt-cancela-2 AT ROW 1.04 COL 54 HELP
          "Cancelar Solicitaá∆o" WIDGET-ID 8
     bt-cancela-3 AT ROW 1.04 COL 59 HELP
          "Cancelar Solicitaá∆o" WIDGET-ID 10
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.14 BY 26.88
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 7
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-conrelaciona ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Relacionamentos"
         HEIGHT             = 26.92
         WIDTH              = 89.29
         MAX-HEIGHT         = 26.92
         MAX-WIDTH          = 137.14
         VIRTUAL-HEIGHT     = 26.92
         VIRTUAL-WIDTH      = 137.14
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-cadastro:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-conrelaciona 
/* ************************* Included-Libraries *********************** */


{src/adm/method/containr.i}
{include/w-conrel.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-conrelaciona
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-conrelaciona)
THEN w-conrelaciona:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-conrelaciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-conrelaciona w-conrelaciona
ON END-ERROR OF w-conrelaciona /* Consulta Relacionamentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-conrelaciona w-conrelaciona
ON WINDOW-CLOSE OF w-conrelaciona /* Consulta Relacionamentos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-conrelaciona
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar Solicitaá∆o */
DO:
    DEFINE VARIABLE i-numero         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-motivo-cancela AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok             AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-erro           AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE h-aux            AS HANDLE      NO-UNDO.

    RUN send-key IN h_q01dpd607("numero", OUTPUT i-numero).
    IF i-numero = 0 OR i-numero = ? THEN RETURN NO-APPLY.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN RETURN NO-APPLY.

    IF amkt-solicitacao.log-cancela = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi cancelada.", "").
        RETURN NO-APPLY.
    END.
    IF amkt-solicitacao.log-encerra = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi encerrada.", "").
        RETURN NO-APPLY.
    END.

    /*FIND FIRST amkt-forma-pagto NO-LOCK WHERE
               amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto NO-ERROR.

    ASSIGN l-erro = NO.

    IF amkt-forma-pagto.tipo-pagto = 1 OR       // Bonificado
       amkt-forma-pagto.tipo-pagto = 2 THEN DO: // Abatimento
        IF amkt-solicitacao.situacao-pagto   <> "N∆o Dispon°vel" OR
           (amkt-solicitacao.situacao-comprov <> "N∆o Dispon°vel" AND 
            amkt-solicitacao.situacao-comprov <> "Pendente de Comprovaá∆o") THEN
            ASSIGN l-erro = YES.
    END.
    ELSE DO: // 3 - Adiantamento
        IF amkt-solicitacao.situacao-comprov <> "N∆o Dispon°vel" OR
           (amkt-solicitacao.situacao-pagto <> "N∆o Dispon°vel" AND
            amkt-solicitacao.situacao-pagto <> "Solicitaá∆o Pagto. Liberada") THEN
            ASSIGN l-erro = YES.
    END.*/

    IF l-erro THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o n∆o permite Cancelamento.",
                          "Comprovaá∆o e Pagamento em andamento, n∆o Ç poss°vel efetuar o cancelamento.").
        RETURN NO-APPLY.
    END.

    RUN dop/message4.p("Confirma cancelamento da Solicitaá∆o?",
                       "Ser† solicitado um Motivo para o cancelamento.").
    IF RETURN-VALUE <> "YES" THEN RETURN NO-APPLY.

    ASSIGN h-aux = w-conrelaciona:HANDLE.
    ASSIGN h-aux:SENSITIVE = NO.
    RUN dop/dpd607a.w(OUTPUT c-motivo-cancela, OUTPUT l-ok).
    ASSIGN h-aux:SENSITIVE = YES.

    IF NOT l-ok THEN RETURN NO-APPLY.

    // Finaliza VC
    FIND FIRST amkt-solicitacao EXCLUSIVE-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    run piOrcamento(output table tt_log_erros).           


    ASSIGN amkt-solicitacao.cod-situacao     = "Solicitaá∆o Cancelada"
           amkt-solicitacao.situacao-comprov = "Solicitaá∆o Cancelada"
           amkt-solicitacao.situacao-pagto   = "Solicitaá∆o Cancelada"
           amkt-solicitacao.log-cancela      = YES
           amkt-solicitacao.usuario-cancela  = c-seg-usuario
           amkt-solicitacao.motivo-cancela   = c-motivo-cancela
           amkt-solicitacao.dt-hr-cancela    = NOW.
    RELEASE amkt-solicitacao NO-ERROR.

    // Finaliza bonificaá‰es de pedidos - NDS 90730
    FOR EACH amkt-solic-vl-bonific EXCLUSIVE-LOCK WHERE
             amkt-solic-vl-bonific.tipo-documento = 1 /* amkt-solicitacao */ AND
             amkt-solic-vl-bonific.documento      = STRING(i-numero)         AND
             amkt-solic-vl-bonific.vl-liberado    > amkt-solic-vl-bonific.vl-realizado:


        CREATE amkt-solic-vl-bonific-realiz.
        ASSIGN amkt-solic-vl-bonific-realiz.sequencia        = amkt-solic-vl-bonific.sequencia
               amkt-solic-vl-bonific-realiz.sequencia-realiz = fn-sequencia-realiz(amkt-solic-vl-bonific.sequencia)
               amkt-solic-vl-bonific-realiz.tipo-ajuste      = 1 // Positivo
               amkt-solic-vl-bonific-realiz.nr-pedcli        = "VC CANCELADA"
               amkt-solic-vl-bonific-realiz.nome-abrev       = "VC CANCELADA"
               amkt-solic-vl-bonific-realiz.valor            = (amkt-solic-vl-bonific.vl-liberado - amkt-solic-vl-bonific.vl-realizado)
               amkt-solic-vl-bonific-realiz.data-pedido      = TODAY.
        
        ASSIGN amkt-solic-vl-bonific.vl-realizado = amkt-solic-vl-bonific.vl-realizado + amkt-solic-vl-bonific-realiz.valor.

        RELEASE amkt-solic-vl-bonific-realiz NO-ERROR.
    END.

    // Finaliza bonificaá‰es de t°tulos - NDS 90730
    FOR EACH amkt-solic-vl-bonific EXCLUSIVE-LOCK WHERE
             amkt-solic-vl-bonific.tipo-documento = 2 /* amkt-solicitacao */ AND
             amkt-solic-vl-bonific.documento      = STRING(i-numero)         AND
             amkt-solic-vl-bonific.vl-liberado    > amkt-solic-vl-bonific.vl-realizado:
        find first amkt-solic-vl-bonific-tit-acr no-lock where amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia no-error.
        if avail amkt-solic-vl-bonific-tit-acr then
        run piOrcamentoACR( INPUT i-numero,
                            output table tt_log_erros).           


        CREATE amkt-solic-vl-bonific-tit-acr.
        ASSIGN amkt-solic-vl-bonific-tit-acr.sequencia       = amkt-solic-vl-bonific.sequencia
               amkt-solic-vl-bonific-tit-acr.cod_estab       = ""
               amkt-solic-vl-bonific-tit-acr.cod_espec_docto = ""
               amkt-solic-vl-bonific-tit-acr.cod_ser_docto   = ""
               amkt-solic-vl-bonific-tit-acr.cod_tit_acr     = "VC CANCELADA"
               amkt-solic-vl-bonific-tit-acr.cod_parcela     = ""
               amkt-solic-vl-bonific-tit-acr.cod-usuario     = "SUPER"
               amkt-solic-vl-bonific-tit-acr.data            = TODAY
               amkt-solic-vl-bonific-tit-acr.valor           = (amkt-solic-vl-bonific.vl-liberado - amkt-solic-vl-bonific.vl-realizado).

        ASSIGN amkt-solic-vl-bonific.vl-realizado = amkt-solic-vl-bonific.vl-realizado + amkt-solic-vl-bonific-tit-acr.valor.

        RELEASE amkt-solic-vl-bonific-tit-acr NO-ERROR.
    END.

    RUN dop/env-mail-mkt.p(i-numero).

    IF VALID-HANDLE(h_v01dpd607) THEN RUN local-display-fields IN h_v01dpd607.
    IF VALID-HANDLE(h_v02dpd607) THEN RUN local-display-fields IN h_v02dpd607.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela-2 w-conrelaciona
ON CHOOSE OF bt-cancela-2 IN FRAME f-cad /* Cancelar Solicitaá∆o */
DO:
    DEFINE VARIABLE i-numero         AS INTEGER     NO-UNDO.

    RUN send-key IN h_q01dpd607("numero", OUTPUT i-numero).
    IF i-numero = 0 OR i-numero = ? THEN RETURN NO-APPLY.



    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN DO: 
        RETURN NO-APPLY.
    END.

    IF amkt-solicitacao.situacao-pagto = "N∆o dispon°vel" THEN DO:
            RUN dop/MESSAGE.p("Situaá∆o de Pagamento Invalida", "").
        RETURN NO-APPLY.
    END.

    IF amkt-solicitacao.cd-forma-pagto <> 2 THEN DO:
            RUN dop/MESSAGE.p("Forma de Pagamento nao permite Adiantamentos", "").
        RETURN NO-APPLY.
    END.


    IF amkt-solicitacao.log-cancela = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi cancelada.", "").
        RETURN NO-APPLY.
    END.
    IF amkt-solicitacao.log-encerra = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi encerrada.", "").
        RETURN NO-APPLY.
    END.

    find first repres no-lock where repres.cod-rep = amkt-solicitacao.cod-rep no-error.
    
    find first emitente no-lock where emitente.cgc = repres.cgc no-error.

    find first tit_ap no-lock where tit_ap.cdn_fornecedor = emitente.cod-emitente
                          and   tit_ap.cod_espec_docto = "VC"
                          and   tit_ap.cod_ser_docto   = ""
                          and   tit_ap.cod_tit_ap      = fill('0', 7 - length(string(amkt-solicitacao.numero))) + string(amkt-solicitacao.numero)
                          and   tit_ap.log_sdo_tit_ap  = yes no-error.

                          if avail tit_ap then do:

                            run dop/message.p("Ja existe antecipaá∆o em aberto", "o documento Estab " + tit_ap.cod_estab + " Numero " +
                            tit_ap.cod_tit_ap + " Parcela " + tit_ap.cod_parcela + " Emitente " + string(tit_ap.cdn_fornecedor) + " Tem saldo de " +
                            string(tit_ap.val_sdo_tit_ap) + " disponivel").
                            return no-apply.
                            end.




    
          RUN dop\dpd607e.p(INPUT emitente.cod-emitente,
                            INPUT emitente.nome-abrev,
                            INPUT amkt-solicitacao.numero,
                            INPUT amkt-solicitacao.vl-solicitacao).


    IF VALID-HANDLE(h_v01dpd607) THEN RUN local-display-fields IN h_v01dpd607.
    IF VALID-HANDLE(h_v02dpd607) THEN RUN local-display-fields IN h_v02dpd607.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela-3 w-conrelaciona
ON CHOOSE OF bt-cancela-3 IN FRAME f-cad /* Cancelar Solicitaá∆o */
DO:
    DEFINE VARIABLE i-numero         AS INTEGER     NO-UNDO.

    RUN send-key IN h_q01dpd607("numero", OUTPUT i-numero).
    IF i-numero = 0 OR i-numero = ? THEN RETURN NO-APPLY.



    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN DO: 
        RETURN NO-APPLY.
    END.

    IF amkt-solicitacao.situacao-pagto = "N∆o Disponivel" THEN DO:
            RUN dop/MESSAGE.p("Situaá∆o de Pagamento Invalida", "").
        RETURN NO-APPLY.
    END.

    IF amkt-solicitacao.cd-forma-pagto <> 2 THEN DO:
            RUN dop/MESSAGE.p("Forma de Pagamento nao permite Adiantamentos", "").
        RETURN NO-APPLY.
    END.


    IF amkt-solicitacao.log-cancela = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi cancelada.", "").
        RETURN NO-APPLY.
    END.
    IF amkt-solicitacao.log-encerra = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi encerrada.", "").
        RETURN NO-APPLY.
    END.

    find first repres no-lock where repres.cod-rep = amkt-solicitacao.cod-rep no-error.
    
    find first emitente no-lock where emitente.cgc = repres.cgc no-error.

    FIND FIRST sgv-seg-mercado NO-LOCK WHERE
        sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
    
    FIND FIRST dc-repres-gestor NO-LOCK WHERE
        dc-repres-gestor.cod-rep     = repres.cod-rep              AND
        dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
    
    FIND FIRST dc-regiao NO-LOCK WHERE
        dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.




    find LAST tit_ap no-lock where tit_ap.cod_estab =  "9"
                          and   tit_ap.cod_tit_ap = FILL("0", 7 - LENGTH(STRING(i-numero))) + string(i-numero)
                          and   tit_ap.cod_ser_docto = ""
                          and   tit_ap.cdn_fornecedor = emitente.cod-emitente 
                          AND   tit_ap.log_sdo_tit_ap = YES NO-ERROR.

    IF NOT AVAIL tit_ap THEN DO:
        RUN dop/MESSAGE.p("Titulo Inexistente", "Antecipaá∆o ainda nao foi gerada").
        RETURN NO-APPLY.

    END.

    ELSE DO:
        RUN dop\dpd607f.w (INPUT tit_ap.cod_estab,
                           INPUT tit_ap.cod_tit_ap,
                           INPUT tit_ap.cod_espec_docto,
                           INPUT tit_ap.cod_parcela,
                           INPUT tit_ap.num_id_tit_ap,
                           INPUT dc-regiao.cod-ccusto,
                           INPUT tit_ap.val_sdo_tit_ap)
                           .
    END.
    

    IF VALID-HANDLE(h_v01dpd607) THEN RUN local-display-fields IN h_v01dpd607.
    IF VALID-HANDLE(h_v02dpd607) THEN RUN local-display-fields IN h_v02dpd607.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhes w-conrelaciona
ON CHOOSE OF bt-detalhes IN FRAME f-cad
DO:
    DEFINE VARIABLE i-numero AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-aux    AS HANDLE      NO-UNDO.

    RUN send-key IN h_q01dpd607("numero", OUTPUT i-numero).
    IF i-numero = 0 OR i-numero = ? THEN RETURN NO-APPLY.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN RETURN NO-APPLY.

    ASSIGN h-aux = w-conrelaciona:HANDLE.
    ASSIGN h-aux:SENSITIVE = NO.
    RUN dop/dpd607b.w(i-numero).
    ASSIGN h-aux:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-encerra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-encerra w-conrelaciona
ON CHOOSE OF bt-encerra IN FRAME f-cad /* Encerrar Solicitaá∆o */
DO:
    DEFINE VARIABLE i-numero AS INTEGER     NO-UNDO.

    RUN send-key IN h_q01dpd607("numero", OUTPUT i-numero).
    IF i-numero = 0 OR i-numero = ? THEN RETURN NO-APPLY.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN RETURN NO-APPLY.

    IF amkt-solicitacao.log-cancela = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi cancelada.", "").
        RETURN NO-APPLY.
    END.
    IF amkt-solicitacao.log-encerra = YES THEN DO:
        RUN dop/MESSAGE.p("Solicitaá∆o j† foi encerrada.", "").
        RETURN NO-APPLY.
    END.

    FIND FIRST amkt-forma-pagto NO-LOCK WHERE
               amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto NO-ERROR.

    RUN dop/message4.p("Confirma encerramento da Solicitaá∆o?", "").
    IF RETURN-VALUE <> "YES" THEN RETURN NO-APPLY.

    FIND FIRST amkt-solicitacao EXCLUSIVE-LOCK WHERE
               amkt-solicitacao.numero = i-numero NO-ERROR.
    ASSIGN amkt-solicitacao.cod-situacao     = "Solicitaá∆o Encerrada"
           amkt-solicitacao.situacao-comprov = "Solicitaá∆o Encerrada"
           amkt-solicitacao.situacao-pagto   = "Solicitaá∆o Encerrada"
           amkt-solicitacao.log-encerra      = YES
           amkt-solicitacao.usuario-encerra  = c-seg-usuario
           amkt-solicitacao.dt-hr-encerra    = NOW.
    RELEASE amkt-solicitacao NO-ERROR.

    RUN dop/env-mail-mkt.p(i-numero).

    IF VALID-HANDLE(h_v01dpd607) THEN RUN local-display-fields IN h_v01dpd607.
    IF VALID-HANDLE(h_v02dpd607) THEN RUN local-display-fields IN h_v02dpd607.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-anterior w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-anterior /* Anterior */
DO:
  RUN pi-anterior IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-conrelaciona
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-pesquisa w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-pesquisa /* Pesquisa */
DO:
  RUN pi-pesquisa IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-primeiro w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-primeiro /* Primeiro */
DO:
  RUN pi-primeiro IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-proximo w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-proximo /* Pr¢ximo */
DO:
  RUN pi-proximo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-ultimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-ultimo w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-ultimo /* Èltimo */
DO:
  RUN pi-ultimo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-va-para w-conrelaciona
ON CHOOSE OF MENU-ITEM mi-va-para /* V† para */
DO:
  RUN pi-vapara IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-conrelaciona 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-conrelaciona  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-navega.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navega ).
       RUN set-position IN h_p-navega ( 1.17 , 1.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 24.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 73.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dovwr/v01dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v01dpd607 ).
       RUN set-position IN h_v01dpd607 ( 2.46 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 16.50 , 89.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Sell In Prop.|Hist. Aprov|Comprov|Pagamento|Cancela.|Bonifics.|T°tulos' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 19.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 8.83 , 89.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'doqry/q01dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'ProgPesquisa = dozoom\z01dpd607.w,
                     ProgVaPara = dovp\vp01dpd607.w,
                     ProgIncMod = ,
                     Implantar = no':U ,
             OUTPUT h_q01dpd607 ).
       RUN set-position IN h_q01dpd607 ( 1.25 , 32.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 5.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Links to SmartViewer h_v01dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_v01dpd607 ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q01dpd607. */
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'Navigation':U , h_q01dpd607 ).
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'State':U , h_q01dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
             bt-cancela-3:HANDLE IN FRAME f-cad , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             h_p-navega , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v01dpd607 ,
             h_p-exihel , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_v01dpd607 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b01dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b01dpd607 ).
       RUN set-position IN h_b01dpd607 ( 20.33 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 6.50 , 88.00 ) */

       /* Links to SmartBrowser h_b01dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b01dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b01dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b03dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b03dpd607 ).
       RUN set-position IN h_b03dpd607 ( 20.33 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.54 , 88.00 ) */

       /* Links to SmartBrowser h_b03dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b03dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b03dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b04dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b04dpd607 ).
       RUN set-position IN h_b04dpd607 ( 20.33 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.38 , 88.00 ) */

       /* Links to SmartBrowser h_b04dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b04dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b04dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b05dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b05dpd607 ).
       RUN set-position IN h_b05dpd607 ( 20.33 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 6.50 , 88.00 ) */

       /* Links to SmartBrowser h_b05dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b05dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b05dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dovwr/v02dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v02dpd607 ).
       RUN set-position IN h_v02dpd607 ( 20.33 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 88.57 ) */

       /* Links to SmartViewer h_v02dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_v02dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v02dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b06dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b06dpd607 ).
       RUN set-position IN h_b06dpd607 ( 20.25 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 77.00 ) */

       /* Links to SmartBrowser h_b06dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b06dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b06dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dobrw/b08dpd607.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b08dpd607 ).
       RUN set-position IN h_b08dpd607 ( 20.25 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 87.00 ) */

       /* Links to SmartBrowser h_b08dpd607. */
       RUN add-link IN adm-broker-hdl ( h_q01dpd607 , 'Record':U , h_b08dpd607 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b08dpd607 ,
             h_folder , 'AFTER':U ).
    END. /* Page 7 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-conrelaciona  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-conrelaciona  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-conrelaciona)
  THEN DELETE WIDGET w-conrelaciona.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-conrelaciona  _DEFAULT-ENABLE
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
  ENABLE rt-button bt-encerra bt-cancela bt-detalhes bt-cancela-2 bt-cancela-3 
      WITH FRAME f-cad IN WINDOW w-conrelaciona.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-conrelaciona.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-conrelaciona 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-conrelaciona 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-conrelaciona 
PROCEDURE local-initialize :
{include/win-size.i}

run pi-before-initialize.

{utp/ut9000.i "DPD607" "12.00.00.001"}

RUN pi-handle-folder IN h_v01dpd607(h_folder).

RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

run pi-after-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOrcamento w-conrelaciona 
PROCEDURE piOrcamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAM TABLE  FOR tt_log_erros.
  
  def var v_cod_empresa        as character.
  def var v_cod_plano_cta_ctbl as char.
  def var v_cod_cta_ctbl       as char.
  def var v_cod_plano_ccusto   as char.
  def var v_cod_ccusto         as char.
  def var v_cod_estab          as char.
  def var v_cod_unid_negoc     as char.
  def var v_dat_transacao      as date.
  def var v_cod_finalid_econ   as char.
  def var v_val_aprop_ctbl     as dec.    
  def var v_num_seq            as int.
  def var v_cod_funcao         as char.
  def var v_cod_id             as char.
  DEF VAR v_orig_movto         AS CHAR.
  def var da-valid-orcto       as date.
  def var v_situacao_docto     as char.
  
  DEF VAR i-controle           AS INTEGER.
  
      FIND FIRST param-global NO-ERROR.
      EMPTY TEMP-TABLE tt_xml_input_1.
      empty temp-table tt_log_erros.

      assign i-controle = amkt-solicitacao.numero.
//busca dados para envio de informaá∆o de centro de custos para oráamento
FIND FIRST repres NO-LOCK WHERE
    repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.

FIND FIRST emitente NO-LOCK WHERE
    emitente.cod-emitente = amkt-solicitacao.cod-emitente NO-ERROR.

FIND FIRST sgv-seg-mercado NO-LOCK WHERE
    sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.

FIND FIRST dc-repres-gestor NO-LOCK WHERE
    dc-repres-gestor.cod-rep     = repres.cod-rep              AND
    dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.

FIND FIRST dc-regiao NO-LOCK WHERE
    dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.

find first amkt-forma-pagto no-lock where amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto no-error.
    IF amkt-forma-pagto.tipo-pagto = 3 /* Adiantamento */ THEN
    ASSIGN da-valid-orcto = amkt-solicitacao.dt-validade-final.
ELSE // 1 - Bonificado, 2 - Abatimento
    ASSIGN da-valid-orcto = amkt-solicitacao.dt-validade-final.

  
      assign v_cod_empresa        =  param-global.empresa-prin
             v_cod_cta_ctbl       = "435362"
             v_cod_ccusto         = dc-regiao.cod-ccusto
             v_cod_estab          = "9" //esta fixo porque, ate a data de 20.09.2019 existe orcamento apenas para este estabelecimento
             v_cod_unid_negoc     = "DOC" 
             v_dat_transacao      = da-valid-orcto
             v_cod_finalid_econ   = "0" /*REFERENTE AO CÖDIGO DA FINALIDADE ECONOMICA REAL*/
             v_val_aprop_ctbl     = amkt-solicitacao.vl-solicitacao
             v_num_seq            = 1
             v_cod_funcao         = "Estorna" 
             v_cod_id             = string(i-controle) //nao h† descricao, pois o empenho nao Ç realizado, apenas Ç feito check
             v_orig_movto         = "90".

             find first amkt-solic-pagto NO-LOCK where amkt-solic-pagto.numero = amkt-solicitacao.numero
                                                  and   amkt-solic-pagto.situacao-pagto = 2 no-error.

                                                  if avail amkt-solic-pagto then
             assign v_situacao_docto = "Solicitacao DPD607 (Pagto)" + string(v_cod_id).
             else
             assign v_situacao_docto = "Solicitacao DPD607 " + string(v_cod_id). 
           
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Conta Cont†bil" /*l_conta_contabil*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_ccusto
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_estab
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_unid_negoc
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Data Movimentaá∆o" /*l_data_movimentacao*/ 
             tt_xml_input_1.ttv_des_conteudo = string(v_dat_transacao)
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econìmica" /*l_finalidade_economica*/ 
             tt_xml_input_1.ttv_des_conteudo = v_cod_finalid_econ
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
             tt_xml_input_1.ttv_des_conteudo = string(v_val_aprop_ctbl)
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
             tt_xml_input_1.ttv_des_conteudo = v_orig_movto
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "Funá∆o"
             tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
      create tt_xml_input_1.
      assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
             tt_xml_input_1.ttv_des_conteudo = v_situacao_docto
             tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
  
      
      run prgfin/bgc/bgc700za.py (Input 1,
                                 input table tt_xml_input_1,
                                 output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.
  
          find first tt_log_erros no-error.

          IF AVAIL tt_log_erros THEN
              MESSAGE "bvabou" VIEW-AS ALERT-BOX.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOrcamentoACr w-conrelaciona 
PROCEDURE piOrcamentoACr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAM i-numero AS INTEGER.

 DEFINE OUTPUT PARAM TABLE  FOR tt_log_erros.

  def var v_cod_empresa        as character.
  def var v_cod_plano_cta_ctbl as char.
  def var v_cod_cta_ctbl       as char.
  def var v_cod_plano_ccusto   as char.
  def var v_cod_ccusto         as char.
  def var v_cod_estab          as char.
  def var v_cod_unid_negoc     as char.
  def var v_dat_transacao      as date.
  def var v_cod_finalid_econ   as char.
  def var v_val_aprop_ctbl     as dec.    
  def var v_num_seq            as int.
  def var v_cod_funcao         as char.
  def var v_cod_id             as char.
  DEF VAR v_orig_movto         AS CHAR.
  def var da-valid-orcto       as date.
  DEF VAR v_cod_refer          AS CHAR NO-UNDO.
  
  DEF VAR i-controle           AS INTEGER.
  
      FIND FIRST param-global NO-ERROR.
      EMPTY TEMP-TABLE tt_xml_input_1.
      empty temp-table tt_log_erros.

      assign i-controle = i-numero.

find first amkt-solicitacao no-lock where amkt-solicitacao.numero = i-numero no-error.
//busca dados para envio de informaá∆o de centro de custos para oráamento
FIND FIRST repres NO-LOCK WHERE
    repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.

FIND FIRST emitente NO-LOCK WHERE
    emitente.cod-emitente = amkt-solicitacao.cod-emitente NO-ERROR.

FIND FIRST sgv-seg-mercado NO-LOCK WHERE
    sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.

FIND FIRST dc-repres-gestor NO-LOCK WHERE
    dc-repres-gestor.cod-rep     = repres.cod-rep              AND
    dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.

FIND FIRST dc-regiao NO-LOCK WHERE
    dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.

find first amkt-forma-pagto no-lock where amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto no-error.
    IF amkt-forma-pagto.tipo-pagto = 3 /* Adiantamento */ THEN
    ASSIGN da-valid-orcto = amkt-solicitacao.dt-validade-final.
ELSE // 1 - Bonificado, 2 - Abatimento
    ASSIGN da-valid-orcto = amkt-solicitacao.dt-validade-final.

  
  
      assign v_cod_empresa        =  param-global.empresa-prin
             v_cod_cta_ctbl       = "435362"
             v_cod_ccusto         = dc-regiao.cod-ccusto
             v_cod_estab          = "9" //esta fixo porque, ate a data de 20.09.2019 existe orcamento apenas para este estabelecimento
             v_cod_unid_negoc     = "DOC" 
             v_dat_transacao      = da-valid-orcto
             v_cod_finalid_econ   = "0" /*REFERENTE AO CÖDIGO DA FINALIDADE ECONOMICA REAL*/
             v_num_seq            = 1
             v_cod_funcao         = "Estorna" 
             v_cod_id             = string(i-controle) //nao h† descricao, pois o empenho nao Ç realizado, apenas Ç feito check
             v_orig_movto         = "90".
    
for each amkt-solic-vl-bonific-tit-acr no-lock where amkt-solic-vl-bonific-tit-acr.sequencia = amkt-solic-vl-bonific.sequencia:
//rotina de estorno: variaveis da API padr∆o:
//tabelas estao na include dpd611.i.
empty temp-table tt_input_estorno.

run pi_retorna_sugestao_referencia (Input "T" /*l_l*/,
                                    Input today,
                                    output v_cod_refer) /*pi_retorna_sugestao_referencia*/.

      find first tit_acr no-lock where tit_acr.cod_estab       = amkt-solic-vl-bonific-tit-acr.cod_estab
                                 and   tit_acr.cod_espec_docto = amkt-solic-vl-bonific-tit-acr.cod_espec_docto
                                 and   tit_acr.cod_ser_docto   = amkt-solic-vl-bonific-tit-acr.cod_ser_docto
                                 and   tit_acr.cod_tit_acr     = amkt-solic-vl-bonific-tit-acr.cod_tit_acr
                                 and   tit_acr.cod_parcela     = amkt-solic-vl-bonific-tit-acr.cod_parcela no-error.

            if avail tit_acr then do:

            find first histor_movto_tit_acr no-lock where histor_movto_tit_acr.cod_estab = tit_acr.cod_estab
                                                    and   histor_movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                                    and   entry(1, histor_movto_tit_acr.des_text_histor, "|") = v_cod_id no-error.

                      if avail histor_movto_tit_acr then do:

                        find first movto_tit_acr no-lock where movto_tit_acr.cod_estab = histor_movto_tit_acr.cod_estab
                                                          and   movto_tit_acr.num_id_tit_acr = histor_movto_tit_acr.num_id_tit_acr
                                                          and   movto_tit_acr.num_id_movto_tit_acr = histor_movto_tit_acr.num_id_movto_tit_acr
                                                          and   movto_tit_acr.cod_refer = entry(4, histor_movto_tit_acr.des_text_histor, "|") no-error.

                                                          if avail movto_tit_acr then do:
                                          

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "N°vel"
                              tt_input_estorno.ttv_des_conteudo    = "Movimentos".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Operaá∆o"  
                              tt_input_estorno.ttv_des_conteudo    = "Estorno".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Estabelecimento" 
                              tt_input_estorno.ttv_des_conteudo = v_cod_estab.

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "Data" 
                              tt_input_estorno.ttv_des_conteudo = string(v_dat_transacao).

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "Referància"
                              tt_input_estorno.ttv_des_conteudo = v_cod_refer.
                                                                              
                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "Hist¢rico" 
                              tt_input_estorno.ttv_des_conteudo = "Estorno de movimento automatico".

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq       = 1
                              tt_input_estorno.ttv_cod_label       = "ID Movimento" 
                              tt_input_estorno.ttv_des_conteudo = string(movto_tit_acr.num_id_movto_tit_acr).

                    create tt_input_estorno.
                    assign tt_input_estorno.ttv_num_seq        = 1
                              tt_input_estorno.ttv_cod_label        = "ID Titulo" 
                              tt_input_estorno.ttv_des_conteudo = string(movto_tit_acr.num_id_tit_acr).

                    

                      run prgfin/acr/acr715zb.py (Input  1,
                                                Input  table tt_input_estorno,
                                                output table tt_log_erros_estorn_cancel).

                                                find first tt_log_erros_estorn_cancel no-error.

                                                if avail tt_log_erros_estorn_cancel then do:
                                                  RUN dop/MESSAGE.p(tt_log_erros_estorn_cancel.ttv_des_msg_erro, tt_log_erros_estorn_cancel.ttv_des_msg_ajuda).
                                                  return 'nok'.
                                                end.
                  end.
                end.
            END.
 


             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Conta Cont†bil" /*l_conta_contabil*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
                    tt_xml_input_1.ttv_des_conteudo = dc-regiao.cod-ccusto
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_cod_estab
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_cod_unid_negoc
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Data Movimentaá∆o" /*l_data_movimentacao*/ 
                    tt_xml_input_1.ttv_des_conteudo = string(v_dat_transacao)
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econìmica" /*l_finalidade_economica*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_cod_finalid_econ
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
                    tt_xml_input_1.ttv_des_conteudo = string(amkt-solic-vl-bonific-tit-acr.valor)
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
                    tt_xml_input_1.ttv_des_conteudo = v_orig_movto
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "Funá∆o"
                    tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
             create tt_xml_input_1.
             assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
                    tt_xml_input_1.ttv_des_conteudo = "Processo " + string(amkt-solicitacao.numero) + " Utilizado no titulo " + amkt-solic-vl-bonific-tit-acr.cod_espec_docto + "|" + 
                    amkt-solic-vl-bonific-tit-acr.cod_ser_docto + "|" + amkt-solic-vl-bonific-tit-acr.cod_tit_acr +
                                                       "|" + amkt-solic-vl-bonific-tit-acr.cod_parcela + "| Estabelec " + amkt-solic-vl-bonific-tit-acr.cod_estab
                    tt_xml_input_1.ttv_num_seq_1    = v_num_seq.

      RUN prgfin/bgc/bgc700za.py (input 1,
      input table tt_xml_input_1,
      output table tt_log_erros) .  

end.

  
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_retorna_sugestao_referencia w-conrelaciona 
PROCEDURE pi_retorna_sugestao_referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /************************ Parameter Definition Begin ************************/

  def Input param p_ind_tip_atualiz
      as character
      format "X(08)"
      no-undo.
  def Input param p_dat_refer
      as date
      format "99/99/9999"
      no-undo.
  def output param p_cod_refer
      as character
      format "x(10)"
      no-undo.


  /************************* Parameter Definition End *************************/

  /************************* Variable Definition Begin ************************/

  def var v_des_dat                        as character       no-undo. /*local*/
  def var v_num_aux                        as integer         no-undo. /*local*/
  def var v_num_aux_2                      as integer         no-undo. /*local*/
  def var v_num_cont                       as integer         no-undo. /*local*/


  /************************** Variable Definition End *************************/

  assign v_des_dat   = string(p_dat_refer,"99999999")
         p_cod_refer = substring(v_des_dat,7,2)
                     + substring(v_des_dat,3,2)
                     + substring(v_des_dat,1,2)
                     + substring(p_ind_tip_atualiz,1,1)
         v_num_aux_2 = integer(this-procedure:handle).

  do  v_num_cont = 1 to 3:
      assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
             p_cod_refer = p_cod_refer + chr(v_num_aux).
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-conrelaciona  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-conrelaciona 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-sequencia-realiz w-conrelaciona 
FUNCTION fn-sequencia-realiz RETURNS INTEGER(p-sequencia AS INT):

DEF BUFFER bfn-amkt-solic-vl-bonific-realiz FOR amkt-solic-vl-bonific-realiz.

FIND LAST bfn-amkt-solic-vl-bonific-realiz NO-LOCK WHERE
          bfn-amkt-solic-vl-bonific-realiz.sequencia = p-sequencia NO-ERROR.
IF AVAIL bfn-amkt-solic-vl-bonific-realiz THEN
    RETURN (bfn-amkt-solic-vl-bonific-realiz.sequencia-realiz + 1).
ELSE
    RETURN 1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

