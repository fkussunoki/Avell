&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esce341 1.00.00.027}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

def temp-table tt-digita
    field it-codigo     like necessidade-oc.it-codigo
    field cod-estabel   like necessidade-oc.cod-estabel    
    field c-geracao     as char     
    field data-geracao  like necessidade-oc.data-geracao
    field data-entrega  like necessidade-oc.data-entrega
    field qt-ordem      like necessidade-oc.qt-ordem    
    field qt-orig       like necessidade-oc.qt-orig
    field qt-pendente   like necessidade-oc.qt-pendente
    field estoque-dispo like necessidade-oc.estoque-dispo    
    field marca         as char format "x(01)" label ""    
    field numero-ordem  like requisicao.nr-requisicao
    field vlr-un        as dec format "->>>,>>>,>>>,>>9.99"
    field vlr-total        as dec format "->>>,>>>,>>>,>>9.99"
    field rw-nec        as rowid
    field l-criado      as logical initial no
    field concatena     as char
    FIELD c-erro        AS INTEGER INITIAL 0
    FIELD c-alerta      AS CHAR
    index codigo  cod-estabel
                  it-codigo
                  marca
                  data-geracao.

DEFINE TEMP-TABLE tt-filtro
    FIELD ttv-estab-ini AS CHAR
    FIELD ttv-estab-fim AS CHAR
    FIELD ttv-ge-ini    AS INTEGER
    FIELD ttv-ge-fim    AS INTEGER
    FIELD ttv-fam-ini   AS CHAR
    FIELD ttv-fam-fim   AS CHAR
    FIELD ttv-it-ini    AS CHAR
    FIELD ttv-it-fim    AS CHAR
    FIELD ttv-dt-ini    AS DATE
    FIELD ttv-dt-fim    AS DATE
    field ttv-pto-enc   AS LOGICAL 
    field ttv-periodico AS LOGICAL. 
    .

define  temp-table tt-erro-aed no-undo
     field i-sequen as int             
     field cd-erro  as int
     field mensagem as char format "x(255)"
     field c-param  as char.

def temp-table tt_log_erro no-undo
field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "Nmero"          column-label "Nmero"
field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistncia".
 

DEF VAR c-acao AS CHAR NO-UNDO.
DEF VAR nr-req AS INTEGER NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
DEF VAR i-seq  AS INTEGER NO-UNDO.
DEF VAR l-retorno-aprov AS LOGICAL NO-UNDO.
DEF VAR d-vlr  AS DEC FORMAT "->>>,>>>,>>>,>>9.99" NO-UNDO.
DEF VAR d-unitario  AS DEC FORMAT "->>>,>>>,>>>,>>9.99" NO-UNDO.
def var de-valor-item  as dec format "->>>,>>>,>>>,>>9.99".
def var de-valor-total as dec format "->>>,>>>,>>>,>>9.99".
def var i-itens as integer no-undo.
def var l-confirma as logical NO-UNDO INITIAL NO.
define buffer bf3-oc for it-requisicao.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF VAR h-acomp AS HANDLE.
def var v-cta-fixa as char. //conta fixada conforme email enviado por Marta 16.07.2020

def var v-init as datetime.
def var v-fim as datetime.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.marca tt-digita.it-codigo tt-digita.cod-estabel tt-digita.c-geracao tt-digita.data-geracao tt-digita.data-entrega tt-digita.qt-ordem tt-digita.qt-orig tt-digita.qt-pendente tt-digita.estoque-dispo tt-digita.vlr-un tt-digita.vlr-total tt-digita.c-alerta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.qt-ordem ~
tt-digita.data-entrega   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-digita tt-digita
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita             INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY {&SELF-NAME} FOR EACH tt-digita             INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-digita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-28 bt-executar BUTTON-12 ~
BUTTON-13 BUTTON-11 br-digita 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-executar 
     IMAGE-UP FILE "image/im-rnl.bmp":U
     LABEL "Executar" 
     SIZE 5 BY 1.13.

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Button 11" 
     SIZE 4 BY 1.13.

DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     LABEL "Button 12" 
     SIZE 5 BY 1.13.

DEFINE BUTTON BUTTON-13 
     IMAGE-UP FILE "image/im-ran_m.bmp":U
     LABEL "Button 13" 
     SIZE 5 BY 1.13.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124.57 BY 15.92.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 126 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-livre _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.marca         column-label "Selec" 
      tt-digita.it-codigo     column-label "Item"   
      tt-digita.cod-estabel   column-label "Est Pad" 
      tt-digita.c-geracao     column-label "Motivo" format "x(20)" 
      tt-digita.data-geracao  column-label "Dt.Nec"
      tt-digita.data-entrega  column-label "Dt.Entrega"
      tt-digita.qt-ordem      column-label "Qtd.Ordem"
      tt-digita.qt-orig       column-label "Qtd.Orig"    
      tt-digita.qt-pendente   column-label "Qtd.Pend"
      tt-digita.estoque-dispo column-label "Est.Disp"
      tt-digita.vlr-un        column-label "Vlr.Unit"
      tt-digita.vlr-total     column-label "Vlr.Total"
      tt-digita.c-alerta COLUMN-LABEL "Alerta" FORMAT "x(120)"
ENABLE
      tt-digita.qt-ordem
      tt-digita.data-entrega
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123.43 BY 15.25 ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-executar AT ROW 1.25 COL 2.29 WIDGET-ID 4
     BUTTON-12 AT ROW 1.29 COL 9.29 WIDGET-ID 64
     BUTTON-13 AT ROW 1.29 COL 14.57 WIDGET-ID 66
     BUTTON-11 AT ROW 1.29 COL 20 WIDGET-ID 60
     br-digita AT ROW 3.25 COL 2.43 WIDGET-ID 200
     rt-button AT ROW 1 COL 1
     RECT-28 AT ROW 3 COL 1.57 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 21.79 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Solicitacoes de Compras"
         HEIGHT             = 18.54
         WIDTH              = 126.43
         MAX-HEIGHT         = 21.79
         MAX-WIDTH          = 126.43
         VIRTUAL-HEIGHT     = 21.79
         VIRTUAL-WIDTH      = 126.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-digita BUTTON-11 f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita             INDEXED-REPOSITION
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Solicitacoes de Compras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Solicitacoes de Compras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-livre
ON MOUSE-SELECT-DBLCLICK OF br-digita IN FRAME f-cad
DO:
  if avail tt-digita then do:
      if  tt-digita.marca = "*":R then
          assign tt-digita.marca = " ".
      else
          assign tt-digita.marca = "*":R.
      disp tt-digita.marca with browse br-digita.
  end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-livre
ON ROW-DISPLAY OF br-digita IN FRAME f-cad
DO:
  CASE tt-digita.c-erro:

      WHEN 1 THEN DO:
 ASSIGN
          tt-digita.marca:BGCOLOR           IN BROWSE br-digita = 12
          tt-digita.it-codigo:BGCOLOR       IN BROWSE br-digita = 12     
          tt-digita.cod-estabel:BGCOLOR     IN BROWSE br-digita = 12 
          tt-digita.c-geracao:BGCOLOR       IN BROWSE br-digita = 12  
          tt-digita.data-geracao:BGCOLOR    IN BROWSE br-digita = 12
          tt-digita.data-entrega:BGCOLOR    IN BROWSE br-digita = 12
          tt-digita.qt-ordem:BGCOLOR        IN BROWSE br-digita = 12
          tt-digita.qt-orig:BGCOLOR         IN BROWSE br-digita = 12             
          tt-digita.qt-pendente:BGCOLOR     IN BROWSE br-digita = 12   
          tt-digita.estoque-dispo:BGCOLOR   IN BROWSE br-digita = 12
          tt-digita.vlr-un:BGCOLOR          IN BROWSE br-digita = 12
          tt-digita.vlr-total:BGCOLOR       IN BROWSE br-digita = 12.

      END.

      WHEN 2 THEN DO:
          ASSIGN
                   tt-digita.marca:BGCOLOR           IN BROWSE br-digita = 10
                   tt-digita.it-codigo:BGCOLOR       IN BROWSE br-digita = 10     
                   tt-digita.cod-estabel:BGCOLOR     IN BROWSE br-digita = 10 
                   tt-digita.c-geracao:BGCOLOR       IN BROWSE br-digita = 10  
                   tt-digita.data-geracao:BGCOLOR    IN BROWSE br-digita = 10
                   tt-digita.data-entrega:BGCOLOR    IN BROWSE br-digita = 10
                   tt-digita.qt-ordem:BGCOLOR        IN BROWSE br-digita = 10
                   tt-digita.qt-orig:BGCOLOR         IN BROWSE br-digita = 10             
                   tt-digita.qt-pendente:BGCOLOR     IN BROWSE br-digita = 10   
                   tt-digita.estoque-dispo:BGCOLOR   IN BROWSE br-digita = 10
                   tt-digita.vlr-un:BGCOLOR          IN BROWSE br-digita = 10
                   tt-digita.vlr-total:BGCOLOR       IN BROWSE br-digita = 10.

      END.

  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-livre
ON CHOOSE OF bt-executar IN FRAME f-cad /* Executar */
DO:


    run pi-executar.
    {&open-query-br-digita}



END.


procedure pi-executar:

  def var v_cod_estab as char no-undo.
  def var v_nr_req    as integer no-undo.
  DEF VAR i AS INTEGER NO-UNDO.
  ASSIGN i-seq = 1.
  assign i-itens = 1.
  ASSIGN i = 0.

  assign v-init = now.
  run utp\ut-acomp.p persistent set h-acomp.

  run pi-inicializar in h-acomp(input "Gerando Solicitacoes").
  
  gera_itens:


  for each tt-digita where tt-digita.marca = "*" 
                     and   tt-digita.l-criado = no
                    break by tt-digita.concatena:

//alteracao conforme solicitacao de email 22.07
   if first-of(tt-digita.concatena) then do:
      ASSIGN i-seq = 1.
    
      assign v_cod_estab = tt-digita.cod-estabel.

      find first it-requisicao where   it-requisicao.it-codigo = tt-digita.it-codigo
                                 and   it-requisicao.cod-estabel = tt-digita.cod-estabel
                                 and   it-requisicao.situacao  = 1
                                 and   it-requisicao.tp-requis = 2
                                 no-error.

                                 if  avail it-requisicao then do:
                                  assign tt-digita.l-criado   = no
                                         tt-digita.marca      = ""
                                         tt-digita.c-erro     = 1
                                         tt-digita.c-alerta   = "Existe solicitacao em aberto. Verifique " +
                                      " " + string(it-requisicao.nr-requisicao).
                                  NEXT gera_itens.
                                 end.


                                 ASSIGN i-itens = i-itens + 1.

    RUN pi-nr-solicita(OUTPUT nr-req).


    assign v_nr_req = nr-req.

  
    run pi-cria-lote(input tt-digita.it-codigo,
                     input v_cod_estab,
                     input v_nr_req).



        run pi-cria-mla(input rowid(it-requisicao)).

        

   END.

  end.
RUN pi-finalizar IN h-acomp.

IF i-itens > 0 THEN

run pi-apaga-query.
end procedure.

procedure pi-apaga-query:
  message 'Os ' + string(i-itens) ' itens selecionados ja podem ser excluidos das necessidades listadas?' view-as alert-box warning 
  buttons yes-no update l-confirma.

  if l-confirma then do:

    for each tt-digita where tt-digita.marca = "*" 
                       and   tt-digita.l-criado = yes use-index codigo:

      find first necessidade-oc where necessidade-oc.cod-estabel = tt-digita.cod-estabel
                                and   necessidade-oc.it-codigo   = tt-digita.it-codigo
                                and   necessidade-oc.qt-pendente = tt-digita.qt-pendente
                                and   necessidade-oc.data-geracao = tt-digita.data-geracao no-error.

                                if avail necessidade-oc then do:
                                delete necessidade-oc.
                                delete tt-digita.
                                end.
    end.
  end. 

end procedure.

procedure pi-cria-lote:
    def input param p-it-codigo as char no-undo.
    def input param p-estab as char no-undo.
    def input param p-req   as integer no-undo.
    def var h_api_ccusto as handle no-undo.
    def var v_log_utz_ccusto as logical no-undo.
    def var v_ccusto as char no-undo.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.


  ASSIGN tt-digita.numero-ordem = p-req
         tt-digita.c-erro       = 2.

  run pi-acompanhar in h-acomp(input "Estab " + tt-digita.cod-estabel + " Item " + tt-digita.it-codigo + " Seq " + string(i-seq) + " SC " + string(tt-digita.numero-ordem)).

  create requisicao.
  assign requisicao.cod-estabel         = tt-digita.cod-estabel
         requisicao.dt-atend            = ?
         requisicao.dt-devol            = ?
         requisicao.dt-requisicao       = today //tt-digita.data-geracao
         requisicao.estado              = 2
         requisicao.impressa            = 2
         requisicao.nome-abrev          = v_cod_usuar_corren
         requisicao.nr-requisicao       = p-req
         requisicao.situacao            = 1
         requisicao.tp-requis           = 2.

       
//    for each tt-digita         where tt-digita.marca = "*"
//                               and   tt-digita.cod-estabel = p-estab
//                               and   tt-digita.l-criado    = no
//                               break by tt-digita.cod-estabel:




    assign tt-digita.numero-ordem = p-req
           tt-digita.l-criado     = yes.


      find first item no-lock where item.it-codigo = TT-DIGITA.it-codigo no-error.

      //find first natureza-despesa no-lock where natureza-despesa.nat-despesa = ITEM.nat-despesa no-error.
      //find perde utilidade neste momento devido fixacao de conta na SC.

          assign v-cta-fixa = "11050804". //conta fixada conforme email de 16.07.2020 - Marta

          find first estabelec no-lock where estabelec.cod-estabel = tt-digita.cod-estabel no-error.

          run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  estabelec.ep-codigo,          /* EMPRESA EMS 2 */
                                                            input  estabelec.cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                            input  "",                 /* PLANO CONTAS */
                                                            input  v-cta-fixa,     /* CONTA */
                                                            input  tt-digita.data-geracao,             /* DT TRANSACAO */
                                                            output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                            output table tt_log_erro). /* ERROS */      
                                                            
          if v_log_utz_ccusto then do:

            find first usuar-mater no-lock where usuar-mater.cod-usuario = v_cod_usuar_corren.
          assign v_ccusto = usuar-mater.sc-codigo.
          end.
          
          else do:
            assign v_ccusto = "".
          end.


      create it-requisicao.
      assign it-requisicao.cod-estabel  = tt-digita.cod-estabel
             it-requisicao.cod-comprado = item-uni-estab.cod-comprado
             it-requisicao.cod-depos    = item-uni-estab.deposito-pad
             it-requisicao.cod-localiz  = item-uni-estab.cod-localiz
             it-requisicao.cod-unid-negoc = item-uni-estab.cod-unid-negoc
             it-requisicao.ct-codigo      = v-cta-fixa
             it-requisicao.sc-codigo      = v_ccusto
             it-requisicao.sequencia      = i-seq
             it-requisicao.situacao       = 1
             it-requisicao.tp-requis      = 2
             it-requisicao.un             = item.un
             it-requisicao.val-item       = tt-digita.vlr-total
             it-requisicao.preco-unit     = tt-digita.vlr-un
             it-requisicao.qt-a-atender   = tt-digita.qt-pendente
             it-requisicao.qt-requisitada = tt-digita.qt-pendente
             it-requisicao.nr-requisicao  = p-req
             it-requisicao.nome-abrev     = v_cod_usuar_corren
             it-requisicao.estado         = 2
             it-requisicao.it-codigo      = ITEM.it-codigo
             it-requisicao.dt-entrega     = tt-digita.data-entrega
             .

      ASSIGN i-seq = i-seq + 1.
      assign i-itens = i-itens + 1.

      if i-seq > 999 then do:
        FIND FIRST requisicao NO-LOCK WHERE requisicao.nr-requisicao = p-req NO-ERROR.

        run cdp/cdapi173.p (input  1, //Solicitacao por item 2, total 1
                            input  tt-digita.it-codigo,
                            input  requisicao.nome-abrev,
                            output l-retorno-aprov). //verifica existencia de aprovadores para o documento

        if l-retorno-aprov then do:

          find first it-requisicao no-lock where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-error.

        run pi-cria-mla(input rowid(it-requisicao)).
        end.
        run pi-apaga-query.
        run pi-executar.
      end.
  //END. //for each




    FIND FIRST requisicao NO-LOCK WHERE requisicao.nr-requisicao = tt-digita.numero-ordem NO-ERROR.

                run cdp/cdapi173.p (input  1, //Solicitacao por item 2, total 1
                                    input  tt-digita.it-codigo,
                                    input  requisicao.nome-abrev,
                                    output l-retorno-aprov). //verifica existencia de aprovadores para o documento

      if l-retorno-aprov then do:

        find first it-requisicao no-lock where it-requisicao.nr-requisicao = tt-digita.numero-ordem no-error.

        run pi-cria-mla(input rowid(it-requisicao)).
    end.
  delete procedure h_api_ccusto.

end procedure.

procedure pi-cria-mla:
  define input param p-rowid-requisicao as rowid no-undo.
  run cdp/cdapi171.p (INPUT 1,
                      INPUT 1,
                      p-rowid-requisicao).
  //alteracao enviada por email pela Marta.
  //run piMensagemAprEletr(input p-rowid-requisicao).

end procedure.

PROCEDURE piMensagemAprEletr :
  /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p_rw-ordem-compra AS ROWID NO-UNDO.
  
    DEF VAR i-moeda-lim AS INT NO-UNDO.
    DEF VAR i-tipo-moeda AS INT NO-UNDO.
    DEF VAR c-tipo-moeda AS CHAR NO-UNDO.
    DEF VAR de-valor-doc AS DEC NO-UNDO.
    DEF VAR de-valor-lim AS DEC NO-UNDO.
    DEF VAR c-moeda-lim AS CHAR NO-UNDO.
    DEF VAR l-pendente AS LOG NO-UNDO.
    DEF VAR c-param-msg AS CHAR NO-UNDO.
    def var apr-nr-req  as integer no-undo.
  
  
    run cdp/cdapi174.p (1,
                        p_rw-ordem-compra,
                        output i-moeda-lim,
                        output i-tipo-moeda,
                        output de-valor-doc,
                        output de-valor-lim) no-error.
  
    for first moeda fields(mo-codigo descricao) where
        moeda.mo-codigo = i-moeda-lim
        no-lock: end.
    assign c-moeda-lim  = string(i-moeda-lim,"99") + " - ":U + moeda.descricao.
    case i-tipo-moeda:
        when 1 then do:
            {utp/ut-liter.i (Usuario) * r}
            assign c-tipo-moeda = return-value.
        end.
        when 2 then do:
            {utp/ut-liter.i (Aprovador) * r}
            assign c-tipo-moeda = return-value.
        end.
        when 3 then do:
            {utp/ut-liter.i (Familia) * r}
            assign c-tipo-moeda = return-value.
        end.
        when 4 then do:
            {utp/ut-liter.i (Mestre) * r}
            assign c-tipo-moeda = return-value.
        end.
    end case.
  
    run cdp/cdapi172.p (input 1, input p_rw-ordem-compra, output l-pendente).
  
    /* rde */
    IF de-valor-doc = 0 THEN DO:
  
        FOR EACH bf3-oc OF it-requisicao NO-LOCK
              WHERE bf3-oc.situacao = 2 /* confirmada */ .
      
              ASSIGN de-valor-doc = de-valor-doc + (bf3-oc.qt-a-atender * bf3-oc.preco-unit).
          END.
  
    END.
    /* */

    find first it-requisicao no-lock where rowid(it-requisicao) = p_rw-ordem-compra no-error.
    assign apr-nr-req = it-requisicao.nr-requisicao.

  
    if l-pendente = no then do:

      find first it-requisicao no-lock where rowid(it-requisicao) = p_rw-ordem-compra no-error.
      assign apr-nr-req = it-requisicao.nr-requisicao.

      for each it-requisicao where it-requisicao.nr-requisicao = apr-nr-req:
      find first requisicao where requisicao.nr-requisicao = it-requisicao.nr-requisicao no-error.

      assign it-requisicao.estado = 1.
      assign requisicao.estado    = 1.
    end.
      
        ASSIGN c-param-msg =  "Documento " + string(apr-nr-req) + " aprovado automaticamente.~~" + CHR(10) +
                              "Moeda Convers∆o: " + c-moeda-lim + CHR(10) +
                              "Limite Aprovaá∆o: " + TRIM(STRING(de-valor-lim,'zzzz,zzz,zzz,zz9.99')) + c-tipo-moeda + CHR(10) +
                              "Valor Documento: " + TRIM(STRING(de-valor-doc,'zzzz,zzz,zzz,zz9.99')).
        RUN utp\ut-msgs.p (INPUT 'show':U, INPUT 33331, INPUT c-param-msg).
    end.
    else do:
        ASSIGN c-param-msg =  "Documento " + string(apr-nr-req) + " est† pendente de aprovaá∆o.~~" + CHR(10) +
                              "Moeda Convers∆o: " + c-moeda-lim + CHR(10) +
                              "Limite Aprovaá∆o: " + TRIM(STRING(de-valor-lim,'zzzz,zzz,zzz,zz9.99')) + c-tipo-moeda + CHR(10) +
                              "Valor Documento: " + TRIM(STRING(de-valor-doc,'zzzz,zzz,zzz,zz9.99')).
        RUN utp\ut-msgs.p (INPUT 'show':U, INPUT 33331, INPUT c-param-msg).
    end.
  
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 w-livre
ON CHOOSE OF BUTTON-11 IN FRAME f-cad /* Button 11 */
DO:

    ASSIGN w-livre:SENSITIVE = NO.

      run esp/esce341a.w (INPUT-OUTPUT TABLE tt-filtro, OUTPUT c-acao). 

    ASSIGN w-livre:SENSITIVE = YES.


    IF c-acao = "atualizar" THEN DO:

      empty temp-table tt-digita.
        /*ASSIGN i-linha-browse = 0.*/
        RUN pi-carrega-tabela.




        {&OPEN-QUERY-br-digita}


    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 w-livre
ON CHOOSE OF BUTTON-12 IN FRAME f-cad /* Button 12 */
DO:
  FOR EACH tt-digita WHERE tt-digita.marca = "":

      ASSIGN tt-digita.marca = "*".


  END.
  {&open-query-br-digita}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 w-livre
ON CHOOSE OF BUTTON-13 IN FRAME f-cad /* Button 13 */
DO:
    FOR EACH tt-digita WHERE tt-digita.marca = "*":

      ASSIGN tt-digita.marca = "".


  END.
  {&open-query-br-digita}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
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
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 110.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-executar:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  ENABLE rt-button RECT-28 bt-executar BUTTON-12 BUTTON-13 BUTTON-11 br-digita 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "esce341" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run btb/btb910zz.p (input c-seg-usuario, input no).

  if  return-value = "NOK" then do:
      RUN pi-sair IN h_p-exihel.
      return "ADM-ERROR".
  end.


  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tabela w-livre 
PROCEDURE pi-carrega-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR l-lo AS LOGICAL.
    find first tt-filtro no-error.
    for each estabelec fields (cod-estabel) where
        estabelec.cod-estabel >= tt-filtro.ttv-estab-ini and
        estabelec.cod-estabel <= tt-filtro.ttv-estab-fim no-lock:


        for each necessidade-oc where
            necessidade-oc.cod-estabel   = estabelec.cod-estabel            and
            necessidade-oc.it-codigo    >= tt-filtro.ttv-it-ini  and
            necessidade-oc.it-codigo    <= tt-filtro.ttv-it-fim  and
            necessidade-oc.data-geracao >= tt-filtro.ttv-dt-ini and
            necessidade-oc.data-geracao <= tt-filtro.ttv-dt-fim and 
            necessidade-oc.qt-pendente   > 0 no-lock: 

            for first item fields (it-codigo fm-codigo ge-codigo) where
                 item.it-codigo = necessidade-oc.it-codigo no-lock: 
            if item.ge-codigo > tt-filtro.ttv-ge-fim or
               item.ge-codigo < tt-filtro.ttv-ge-ini then
                next.
            if item.fm-codigo > tt-filtro.ttv-fam-fim or
               item.fm-codigo < tt-filtro.ttv-fam-ini then
                next.
            if not (item.ge-codigo >= tt-filtro.ttv-ge-ini and
                    item.ge-codigo <= tt-filtro.ttv-ge-fim) then
                next.



            if (necessidade-oc.tp-geracao = 1 and tt-filtro.ttv-pto-enc) or
               (necessidade-oc.tp-geracao = 2 and tt-filtro.ttv-periodico) or
               (necessidade-oc.tp-geracao = 3 and tt-filtro.ttv-periodico) then do:


          
          
          

                 create tt-digita.
                assign tt-digita.it-codigo     = necessidade-oc.it-codigo
                       tt-digita.cod-estabel   = necessidade-oc.cod-estabel
                       tt-digita.c-geracao     = {ininc/i01in658.i 04 necessidade-oc.tp-geracao}
                       tt-digita.data-geracao  = necessidade-oc.data-geracao
                       tt-digita.data-entrega  = necessidade-oc.data-entrega
                       tt-digita.qt-ordem      = necessidade-oc.qt-ordem
                       tt-digita.qt-orig       = necessidade-oc.qt-orig 
                       tt-digita.qt-pendente   = necessidade-oc.qt-pendente
                       tt-digita.estoque-dispo = necessidade-oc.estoque-dispo
                       tt-digita.marca         = "*"
                       tt-digita.rw-nec        = rowid(necessidade-oc)
                       tt-digita.l-criado       = no
                       tt-digita.concatena      = necessidade-oc.cod-estabel + " " + necessidade-oc.it-codigo.
               end.
            end.
        end.
    end.    


    for each tt-digita where tt-digita.marca = "*" 
                       and   tt-digita.l-criado = no use-index codigo:

      find first item no-lock where item.it-codigo = tt-digita.it-codigo no-error.

      find first natureza-despesa no-lock where natureza-despesa.nat-despesa = ITEM.nat-despesa no-error.
          
      find first item-uni-estab no-lock where item-uni-estab.it-codigo =   tt-digita.it-codigo
                                        and   item-uni-estab.cod-estabel = tt-digita.cod-estabel no-error.

      FIND FIRST ITEM-ESTAB NO-LOCK WHERE ITEM-ESTAB.IT-CODIGO = tt-digita.it-codigo
                                    AND   ITEM-ESTA.COD-ESTAB  = tt-digita.cod-estabel NO-ERROR.

      if avail item-estab then

      ASSIGN d-unitario = (item-estab.val-unit-mat-m [1] + item-estab.val-unit-mob-m [1]).

      IF d-unitario = 0 THEN

          ASSIGN d-unitario = ITEM.preco-ul-ent.

      IF d-unitario = 0 THEN

          ASSIGN d-unitario = ITEM.preco-repos.

      IF d-unitario = 0 THEN

          ASSIGN d-unitario = 1.

          assign tt-digita.vlr-un = d-unitario
                 tt-digita.vlr-total = (d-unitario) * tt-digita.qt-pendente.

      end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-nr-solicita w-livre 
PROCEDURE pi-nr-solicita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param i-nr-requisicao as integer no-undo.

    
    
                find first param-compra no-error.
                find last requisicao use-index requisicao
                     where requisicao.nr-requisicao >= param-compra.prim-solic-esp
                     and   requisicao.nr-requisicao <= param-compra.ult-solic-esp no-lock no-error.

                ASSIGN I-CONT = REQUISICAO.NR-REQUISICAO + 1.
                    
                IF  requisicao.nr-requisicao >= 999999999 OR requisicao.nr-requisicao = param-compra.ult-solic-esp THEN DO:
                    ASSIGN i-cont = param-compra.prim-solic-esp.
                    REPEAT:
                         IF CAN-FIND(requisicao WHERE
                                   requisicao.nr-requisicao = i-cont) THEN DO:
                             ASSIGN  i-cont = i-cont + 1.
                             NEXT.
                         END.
                         ASSIGN i-nr-requisicao = i-cont .
                         LEAVE.    
                    END. 
                END.
                ELSE
                    assign i-nr-requisicao = if avail requisicao then (requisicao.nr-requisicao + 1)
                                                                 else prim-solic-esp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-digita"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
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

