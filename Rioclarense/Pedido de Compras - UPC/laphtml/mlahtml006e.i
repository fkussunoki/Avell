/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{lap/mlaapi001.i99}
{laphtml/mlahtml.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}


DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-mla-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

def var c-class       as char no-undo.
def var i-cont        as int  no-undo.
def var c-chave       as char no-undo.
def var i-chave       as int  no-undo.
def var i-empresa     LIKE empresa.ep-codigo  no-undo.
def VAR c-cod-estabel LIKE estabelec.cod-estabel no-undo.

DEF VAR c-nome-usuario-doc LIKE mla-usuar-aprov.nome-usuar.
DEF VAR c-nome-usuario-trans LIKE mla-usuar-aprov.nome-usuar.

DEFINE VARIABLE c-titulo AS CHARACTER  NO-UNDO.

DEF VAR l-alt            AS LOG                        NO-UNDO.
DEF VAR c-quantidade     AS CHAR FORMAT "X(14)"        NO-UNDO.
DEF VAR c-qtd-sal-forn   AS CHAR FORMAT "X(14)"        NO-UNDO.
DEF VAR c-preco          AS CHAR FORMAT "X(21)"        NO-UNDO.
DEF VAR c-pre-unit-for   AS CHAR FORMAT "X(21)"        NO-UNDO.
DEF VAR c-data-entrega   AS CHAR FORMAT "X(10)"        NO-UNDO.
DEF VAR c-data-entrega-2 AS CHAR FORMAT "X(10)"        NO-UNDO.
DEF VAR c-cod-cond-pag   AS CHAR FORMAT "X(3)"         NO-UNDO.
DEF VAR c-cod-cond-pag-2 AS CHAR FORMAT "X(3)"         NO-UNDO.
DEF VAR c-comentarios    LIKE ordem-compra.comentarios NO-UNDO.
def var i-moeda-doc      as int init 0 no-undo. /* 0 = moeda Real */
DEFINE VARIABLE c-servidor AS CHARACTER   NO-UNDO.

/*
/*******  Fonte para Teste  ******/
DEF VAR p-cod-tip-doc   as integer no-undo.
DEF VAR p-cod-aprovador as char    no-undo.
/*
DEF TEMP-TABLE tt-html NO-UNDO
    FIELD html-doc     AS CHAR FORMAT "x(31500)"
    FIELD seq-html     AS INT.
/*********************************/
*/
*/
/**   Monta chave do documento
**/
{lap/mlachave.i}

/* Include de definição de variáveis Unificação de conceitos */
{laphtml/mlaUnifDefine.i}
/* Handle da API Conta Cont bil e Centro de Custo */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
run prgint/utb/utb742za.py persistent set h_api_ccusto. 


FIND FIRST pedido-compr 
     WHERE pedido-compr.num-pedido = integer(tt-mla-chave.valor[1])
     NO-LOCK NO-ERROR.

ASSIGN c-titulo = "Pedido de Compra (Item)".
IF  AVAILABLE pedido-compr AND 
    pedido-compr.emergencial THEN
    ASSIGN c-titulo = "Pedido Emergencial (Item)".

FIND FIRST ordem-compra 
    WHERE ordem-compra.numero-ordem = INTEGER(tt-mla-chave.valor[2])
    NO-LOCK NO-ERROR.


&if defined(bf_mla_ambiente_magnus) &then
    assign c-seg-usuario = USERID("mgadm").
&endif
    
IF c-seg-usuario = "" THEN
    ASSIGN c-seg-usuario = pedido-compr.responsavel.

find mla-usuar-aprov where
    mla-usuar-aprov.cod-usuar = c-seg-usuario
    no-lock no-error.
    
IF pedido-compr.cod-estab-gestor <> "" THEN
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = pedido-compr.cod-estab-gestor
         NO-LOCK NO-ERROR.       
ELSE 
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

ASSIGN c-cod-estabel = estabelec.cod-estabel.

IF AVAIL estabelec THEN
   run cdp/cd9970.p (input  ROWID(estabelec),
                     output i-empresa).
        
FIND FIRST mla-param-aprov  where
    mla-param-aprov.ep-codigo   = i-empresa and
    mla-param-aprov.cod-estabel = c-cod-estabel
    NO-LOCK NO-ERROR.

           

FIND FIRST usuar-mater
     WHERE usuar-mater.cod-usuar = ordem-compra.cod-comprado
     NO-LOCK NO-ERROR.
IF AVAIL usuar-mater THEN
    ASSIGN c-nome-usuario-doc = usuar-mater.nome-usuar.
         
FIND FIRST usuar-mater
     WHERE usuar-mater.cod-usuar = ordem-compra.requisitante
     NO-LOCK NO-ERROR.
IF AVAIL usuar-mater THEN
    ASSIGN c-nome-usuario-trans = usuar-mater.nome-usuar.

IF CAN-FIND(FIRST alt-ped WHERE
                  alt-ped.num-pedido   = pedido-compr.num-pedido    AND
                  alt-ped.numero-ordem = ordem-compra.numero-ordem) THEN
   ASSIGN l-alt = YES.

/**   Outros display's
**/
def var c-desc-item       as char no-undo.
def var c-desc-emitente   as CHAR FORMAT "x(40)" NO-UNDO .
DEF VAR c-desc-estab      AS CHAR NO-UNDO.
DEF VAR c-desc-depos      AS CHAR NO-UNDO.
DEF VAR c-desc-cond-pagto AS CHAR NO-UNDO.
DEF VAR c-desc-moeda      AS CHAR NO-UNDO.
DEF VAR d-data-movto      AS DATE NO-UNDO.
DEF VAR c-data-movto      AS CHAR FORMAT "99/99/9999" NO-UNDO.
DEF VAR c-numero-nota     AS CHAR NO-UNDO.
def var c-desc-despesa    as char no-undo.
def var de-preco          as DEC  no-undo.
def var de-aliquota-ipi   as DEC  no-undo.
def var de-valor-ipi      as DEC  no-undo.
def var de-preco-unit     as DEC  no-undo.
def var de-pre-unit-for   as DEC  no-undo.
def var de-preco-orig     as DEC  no-undo.
def var c-natureza        as char no-undo.
def var c-situacao        as char no-undo.
def var c-origem          as char no-undo.
def var c-conta           as char no-undo.
def var tb-expect         as log  no-undo.
def var l-preco-bruto     as log  no-undo.
DEF VAR da-data           AS DATE NO-UNDO.
DEF VAR de-val-orig       AS DEC  NO-UNDO.
DEF VAR cb-ind-tipo-controle AS CHAR NO-UNDO.
DEF VAR c-desc-empresa    AS CHAR NO-UNDO.
def var c-narrativa       as char format "x(2000)".
def var i-num-seq-item    as integer no-undo.
DEF VAR c-data-emissao    AS CHAR NO-UNDO.
DEF VAR c-data-pedido     AS CHAR NO-UNDO.
def var de-cotacao        as dec  no-undo. 
DEF VAR de-total          AS DEC  NO-UNDO.
def var de-qt-saldo       like prazo-compra.quant-saldo no-undo.
DEFINE VARIABLE c-desc-conta   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-desc-lotacao AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lotacao      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nat-cot-venc AS CHARACTER   NO-UNDO.
DEF VAR c-desc-ccusto AS CHAR NO-UNDO.

/* Realiza a busca da conta contabil */
assign v_cod_cta_ctbl = ordem-compra.ct-codigo.
{laphtml/mlaUnifBuscaConta.i i-empresa v_cod_cta_ctbl today}
find first tt_log_erro no-lock no-error.
if avail tt_log_erro then do:
    ASSIGN c-desc-conta = "".
end.
else
    ASSIGN c-desc-conta = v_titulo_cta_ctbl.

/* Realiza a busca do centro de custo */
{laphtml/mlaUnifBuscaCC.i i-empresa ordem-compra.sc-codigo today}
find first tt_log_erro no-lock no-error.
if avail tt_log_erro then do:
    ASSIGN c-desc-ccusto = "".
end.
else
    ASSIGN c-desc-ccusto = v_titulo_ccusto.

/******** Unificação de conceitos, buscando formatos ********/
{laphtml/mlaUnifFormatos.i i-empresa today}          
if c-formato-conta <> "" then
    assign v_cod_cta_ctbl = string(ordem-compra.ct-codigo, c-formato-conta).
else
    assign v_cod_cta_ctbl = ordem-compra.ct-codigo.
    
if c-formato-ccusto <> "" then
    assign v_cod_ccusto = string(ordem-compra.sc-codigo, c-formato-ccusto).
else
    assign v_cod_ccusto = ordem-compra.sc-codigo.        

FIND mla-lotacao WHERE mla-lotacao.ep-codigo  = i-empresa 
                   AND mla-lotacao.cod-lotacao = ordem-compra.sc-codigo NO-LOCK NO-ERROR.

IF AVAIL mla-lotacao THEN
    ASSIGN c-lotacao      = mla-lotacao.cod-lotacao
           c-desc-lotacao = desc-lotacao.


IF ordem-compra.data-emissao <> ? THEN
   ASSIGN c-data-emissao = string(ordem-compra.data-emissao,"99/99/9999").
ELSE
   ASSIGN c-data-emissao = "".

IF ordem-compra.data-pedido <> ? THEN
   ASSIGN c-data-pedido = string(ordem-compra.data-pedido,"99/99/9999").
ELSE
   ASSIGN c-data-pedido = "".

if  ordem-compra.qt-acum-rec > 0 then do: 
    for last recebimento field (num-pedido numero-ordem data-movto numero-nota)
       where recebimento.num-pedido   = ordem-compra.num-pedido
       and   recebimento.numero-ordem = ordem-compra.numero-ordem
       no-lock: end.
    if avail recebimento then do:
       assign d-data-movto    = recebimento.data-movto
              c-numero-nota   = string(recebimento.numero-nota).
    end.
end.
else do:
   assign c-numero-nota = ""
          d-data-movto = ?.
end.
IF d-data-movto = ? THEN
   ASSIGN c-data-movto = "".
ELSE
   ASSIGN c-data-movto = STRING(d-data-movto,"99/99/9999").

if  avail ordem-compra and ordem-compra.tp-despesa <> 0 then do:
    find tipo-rec-desp where
         tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa
         no-lock no-error.
    assign c-desc-despesa = if not avail tipo-rec-desp then ""
                           else tipo-rec-desp.descricao.   
end. 
else
    assign c-desc-despesa = "".

FIND FIRST emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
IF AVAIL emitente THEN
   ASSIGN c-desc-emitente = string(emitente.nome-emit,"x(40)").
ELSE
   ASSIGN c-desc-emitente = "".

IF AVAIL estabelec THEN
  ASSIGN c-desc-estab = estabelec.nome.
ELSE
  ASSIGN c-desc-estab = "".

find deposito where deposito.cod-depos = ordem-compra.dep-almoxar no-lock no-error.
assign c-desc-depos = if available deposito then deposito.nome else " ".

FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK NO-ERROR.
IF AVAIL cond-pagto THEN
  ASSIGN c-desc-cond-pagto = cond-pagto.descricao.
ELSE
  ASSIGN c-desc-cond-pagto = "".
  IF ordem-compra.cod-cond-pag = 0 AND c-desc-cond-pagto = "" THEN
      ASSIGN c-desc-cond-pagto = "ESPECÖFICA".

FIND FIRST ITEM WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
IF AVAIL ITEM THEN
&if defined(bf_mla_ambiente_magnus) &then
  assign c-desc-item = item.descricao-1 + item.descricao-2.
&else  
  ASSIGN c-desc-item = replace(item.desc-item,'"',"'"). /* quando no cadastro do item 'e colocado " causa erro na visuzlizacao */
&endif  
ELSE
  ASSIGN c-desc-item = "".

find first param-compra no-lock no-error.
if avail param-compra and 
&if defined(bf_mla_ambiente_magnus) &then
    param-compra.ipi-sobre-preco then
&else    
    param-compra.ipi-sobre-preco = 1 then
&endif    
    assign l-preco-bruto = yes.
else
  assign l-preco-bruto = no.

if  avail ordem-compra then do:
    &if defined(bf_mla_ambiente_magnus) &then
    case ordem-compra.natureza:
        when "C" then assign c-natureza = "Compra".
        when "S" then assign c-natureza = "Servi‡o".
        when "B" then assign c-natureza = "Beneficiamento".
    end case.
    case ordem-compra.situacao:
        when "N" then assign c-situacao = "NÆo Confirmada".
        when "C" then assign c-situacao = "Confirmada".
        when "T" then assign c-situacao = "Cotada".
        when "E" then assign c-situacao = "Eliminada".
        when "M" then assign c-situacao = "Em Cota‡Æo".
        when "R" then assign c-situacao = "Terminada".
    end case.
    case ordem-compra.origem:
        when "M" then assign c-origem = "Manual".
        when "D" then assign c-origem = "Dependente".
        when "I" then assign c-origem = "Independente".
    end case.
    assign de-aliquota-ipi = ordem-compra.aliquota-ipi
           tb-expect       = no.
    &else
    assign c-natureza      = {ininc/i01in274.i 04 ordem-compra.natureza}
           c-situacao      = {ininc/i02in274.i 04 ordem-compra.situacao}
           c-origem        = {ininc/i03in274.i 04 ordem-compra.origem}
           de-aliquota-ipi = ordem-compra.aliquota-ipi
           tb-expect       = ordem-compra.expectativa.
    &endif            
end.
else do:
    &if defined(bf_mla_ambiente_magnus) &then
    assign c-natureza = "Compra"
           c-situacao = "NÆo Confirmada"
           c-origem   = "Manual".
    &else
    assign c-natureza = {ininc/i01in274.i 04 1}
           c-situacao = {ininc/i02in274.i 04 1}
           c-origem   = {ininc/i03in274.i 04 1}.
    &endif           
    assign c-conta    = ""
           tb-expect  = no.
end.
   
if  avail ordem-compra then do:
    
    &if defined(bf_mla_ambiente_magnus) &then
    assign cb-ind-tipo-controle = "".
    &else    
    find first item-contrat
        where  item-contrat.nr-contrato  = ordem-compra.nr-contrato
        and    item-contrat.num-seq-item = ordem-compra.num-seq-item
        no-lock no-error.
    if avail item-contrat then do:
       assign cb-ind-tipo-controle = {ininc/i04in582.i 04 item-contrat.ind-tipo-control}.
    end.
    else do:
       assign cb-ind-tipo-controle = {ininc/i04in582.i 04 1}.
    end.
    &endif

    &if defined(bf_mla_ambiente_magnus) &then
    if  ordem-compra.situacao <> "N" and ordem-compra.situacao <> "M" then do:
    &else
    if  ordem-compra.situacao <> 1 and ordem-compra.situacao <> 5 then do:
    &endif

        assign da-data = ordem-compra.data-cotacao.
        
        if  l-preco-bruto = no then
            assign de-valor-ipi = (ordem-compra.preco-unit
                                *  ordem-compra.aliquota-ipi)
                                / (100 + ordem-compra.aliquota-ipi).
        else do:
            if  ordem-compra.perc-descto > 0 then
                assign de-val-orig = (ordem-compra.preco-unit * 100)
                                   / (100 - ordem-compra.perc-descto).
            else
                assign de-val-orig = ordem-compra.preco-unit.
            assign de-valor-ipi = (de-val-orig
                                * ordem-compra.aliquota-ipi)
                                / (100 + ordem-compra.aliquota-ipi).
        end.
        assign de-preco        = ordem-compra.preco-unit - de-valor-ipi
               de-preco-unit   = ordem-compra.preco-unit
               de-pre-unit-for = ordem-compra.pre-unit-for
               de-preco-orig   = ordem-compra.preco-orig.

        if  de-preco        = ? then de-preco        = 0.
        if  de-aliquota-ipi = ? 
        or  de-preco        = 0 then de-aliquota-ipi = 0.
        if  de-valor-ipi    = ? then de-valor-ipi    = 0.
        if  de-preco-unit   = ? then de-preco-unit   = 0.
        if  de-preco-orig   = ? then de-preco-orig   = 0.

    end.
    else
        assign de-preco-unit   = 0
               de-preco        = 0
               de-aliquota-ipi = 0
               de-valor-ipi    = 0
               de-preco-orig   = 0.

    /* ConversÆo dos Valores do Pedido */
    find first cotacao-item 
         where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           and cotacao-item.cot-aprovada = yes no-lock no-error.
    
    /* Calculo do Valor da Cota‡Æo */
    if cotacao-item.mo-codigo = 0 then  
       assign de-cotacao = 1.
    else do:            
       run cdp/cd0812.p (input cotacao-item.mo-codigo,
                         input 0,
                         input 1,
                         input cotacao-item.data-cotacao,
                         output de-cotacao).
       if  de-cotacao = ? then
          assign de-cotacao = 1.
    end.
    
    /*EPC Cliente: FUJITSU F.O.==> 1298.331*/
    if c-nom-prog-upc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-dpc-mg97  <> "" then do:
    
       for each tt-epc:
          delete tt-epc.
       end.
    
       {include/i-epc200.i2 &CodEvent='"OverrideQuotation"':U
                            &CodParameter='"rowid-cotacao-item"':U
                            &ValueParameter="string(rowid(cotacao-item))"}
    
       {include/i-epc201.i "OverrideQuotation"}
    
       /* Sobrescreve a vari vel DE-COTACAO para que o valor do documento nÆo seja convertido */
       find first tt-epc 
            where tt-epc.cod-event     = "OverrideQuotation":U
              and tt-epc.cod-parameter = "ReturnIndex":U no-error.
       if  avail tt-epc then
           assign de-cotacao = dec(tt-epc.val-parameter). /* deve retornar 1 (um) para nÆo converter */
     
       /* retorna a moeda do documento */
       find first tt-epc 
            where tt-epc.cod-event     = "OverrideQuotation":U
              and tt-epc.cod-parameter = "ReturnCoin":U no-error.
       if  avail tt-epc then
           assign i-moeda-doc = int(tt-epc.val-parameter). /* grava moeda original do documento */
    end.
    /*FIM EPC */

    for each prazo-compra
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
          AND prazo-compra.situacao    <> 4 no-lock: /*eliminada*/
        if can-find(funcao where
                    funcao.cd-funcao = "Pedido_Total_MLA" and
                    funcao.ativo     = yes) then
            assign de-qt-saldo = de-qt-saldo + prazo-compra.quantidade.
        else
            assign de-qt-saldo = de-qt-saldo + prazo-compra.qtd-sal-forn. 
    end.

    assign de-total      = de-qt-saldo   * de-pre-unit-for * de-cotacao
           de-preco      = de-preco      * de-cotacao
           de-valor-ipi  = de-valor-ipi  * de-cotacao
           de-preco-unit = de-preco-unit * de-cotacao
           de-preco-orig = de-preco-orig * de-cotacao.


    find first moeda 
         where moeda.mo-codigo = i-moeda-doc no-lock no-error.
    if avail moeda then 
       assign c-desc-moeda = moeda.descricao.
    else 
       assign c-desc-moeda = "".


end.



   FIND estabelec WHERE 
        estabelec.cod-estabel = ordem-compra.cod-estabel 
        NO-LOCK NO-ERROR.

    RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                      OUTPUT i-empresa).


FIND FIRST empresa 
     WHERE empresa.ep-codigo = i-empresa
     NO-LOCK NO-ERROR.
IF AVAIL empresa THEN
   ASSIGN c-desc-empresa = empresa.nome.
ELSE
   ASSIGN c-desc-empresa = "".

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = '<html>' +
'<head>' +
'<style>' +
'    BODY ~{ ' +
'      FONT-SIZE: small; FONT-FAMILY: Times; BACKGROUND-COLOR: #cccccc ' +
'    ~}' +
'    .campo ~{ ' +
'        BACKGROUND: black ' +
'    ~} ' +
'    .destaq ~{ ' +
'        BACKGROUND: #cccccc ' +
'    ~} ' +
'    .linhaBrowse ~{ ' +
'        FONT-SIZE: 8pt; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif ' +
'    ~} ' +
'    .linhaForm ~{ ' +
'        FONT-SIZE: 8pt; LINE-HEIGHT: normal;; COLOR:black; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
'    ~} ' +
'    .fill-in ~{ ' +
'     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:black;background:white; ' +
'    ~} ' +
'    .tableForm ~{ ' +
'        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
'    ~} ' +
'    .tableForm2 ~{ ' +
'        BORDER-width: 0px inset;padding:0;  ' +
'    ~} ' +
'    .barraTitulo ~{ ' +
'        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: center; vertical-alignment: middle ' +
'    ~} ' +
'    .barraTituloBrowse ~{ ' +
'        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #ffffff; FONT-FAMILY: Arial; BACKGROUND-COLOR: #808080; TEXT-ALIGN: center; vertical-alignment: middle ' +
'    ~} ' +
'    .selectedFolder ~{ ' +
'        BACKGROUND-COLOR: white ' +
'    ~} ' +
'    .unselectedFolder ~{ ' +
'        BACKGROUND-COLOR: #dcdcdc ' +
'    ~} ' +
'    .button ~{ ' +
'    font-family:Verdana, Arial;font-size:xx-small;font-weight:bold;color:white;background:#e0b050;cursor:hand;width:80 ' +
'    ~} ' +
'    .linhaBrowsepar ~{ ' +
'        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#d2eef4 ' +
'        ~} ' +
'    .linhaBrowseimpar ~{ ' +
'        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#ffffff ' +
'        ~} ' +
'    .columnLabel ~{ ' +
'        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#107f80 ' +
'        ~} ' +
'    .columnLabelSelected ~{ ' +
'        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#20b0b0 ' +
'        ~} ' +
'    .linkOrdena ~{ ' +
'        COLOR:white;text-decoration:none;  ' +
'        ~} ' +
'    .aBrowser ~{ ' +
'       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
'       ~}  ' +
'    .aBrowser:hover ~{ ' +
'       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline ;  ' +
'      ~}  ' +
'   .aBrowserAcom ~{ ' +
'      color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
'       ~}  ' +
'    .aBrowserAcom:hover ~{ ' +
'       color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline;  ' +
'       ~} ' +
'</style>'.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

if can-find(funcao where
          funcao.cd-funcao = "Integra_AED_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor =  trim(mla-param-aprov.servidor-asp) + "/mla205.asp ".

if can-find(funcao where
          funcao.cd-funcao = "Integra_MLA_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor = trim(mla-param-aprov.servidor-asp) .

ASSIGN tt-html.html-doc = tt-html.html-doc +
'   <meta http-equiv="Cache-Control" content="No-Cache">' +
'   <meta http-equiv="Pragma"        content="No-Cache">' +
'   <meta http-equiv="Expires"       content="0">' +
' </head>' +
' <body topmargin="0" leftmargin="0">' +
'<form method="GET" action="' + c-servidor + '">' +
' <input class="fill-in" type="hidden" name="hid_param">' +
' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '">' +
' <input class="fill-in" type="hidden" name="hid_chave" value="' + replace(c-chave," ","**") + '">' +
' <input class="fill-in" type="hidden" name="hid_cod_usuar" value="' + string(p-cod-aprovador) + '">' +
' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +

' <input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
' <input class="fill-in" type="hidden" name="hid_estabel" value="' + ordem-compra.cod-estabel + '"> '.

/* Primeiro folder */
ASSIGN tt-html.html-doc = tt-html.html-doc +
' <a name="dados">' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">' + c-titulo + '</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'     <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1">' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
'              Empresa:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
'             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
'            </td>' +
'          </tr>' +
'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap>Dados</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#complemento" class="aBrowser">Complemento</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#contrato" class="aBrowser">Contrato</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#req" class="aBrowser">Requisi‡äes</a></th>' .

IF l-alt THEN
   ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <td align="right" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap width="27%">Item:</th>' +
'         <td class="linhaForm" align="left" nowrap colspan="3">' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_item" value=" ' + ordem-compra.it-codigo + ' " readonly>' +
'            <input class="fill-in" type="text" size="50" maxlength="50" name="w_desc_item" value=" ' + c-desc-item + ' " readonly>' +
'         </td>' +                                                                                     
'        </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Estabelecimento:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="6" maxlength="6" name="w_estab" value="' + string(ordem-compra.cod-estabel) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_estab" value="' + c-desc-estab + '" readonly>' +
'       </td>' +
'      <th align="right" class="linhaForm" nowrap>Ordem Invest:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_ordem_invest" value="' + string(ordem-compra.num-ord-inv) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>'.
CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <th align="right" class="linhaForm" nowrap>Dep¢sito:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="5" maxlength="5" name="w_depos" value="' + ordem-compra.dep-almoxar +  '" readonly>' +
'           <input class="fill-in" type="text" size="40" maxlength="40" name="w_desc_depos" value="' + c-desc-depos + '" readonly>' +
'       </td>' +
'       <th align="right" class="linhaForm" nowrap>Pedido:</th>' +
'       <td class="linhaForm" align="left" nowrap>' +
'         <input class="fill-in" type="text" size="10" maxlength="10" name="w_pedido" value="' + string(ordem-compra.num-pedido) + '" readonly>' +
'      </td>' +
'     </tr>' +
'     <tr>' +
'      <th align="right" class="linhaForm" valign="top" nowrap>Condi‡Æo de Pagamento:</th>' +
'      <td class="linhaForm" align="left" nowrap>' +
'         <input class="fill-in" type="text" size="3" maxlength="3" name="w_cond_pagto" value="' + string(ordem-compra.cod-cond-pag) + '" readonly>' +
'        <input class="fill-in" type="text" size="40" maxlength="40" name="w_desc_cond_pagto" value="' + c-desc-cond-pagto + '" readonly>'.


    {laphtml/mlahtmlcondespecif.i}

ASSIGN tt-html.html-doc = tt-html.html-doc +
'     </td>' +
'     <th align="right" class="linhaForm" nowrap>Opera‡Æo:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="8" maxlength="8" name="w_operacao" value="' + string(ordem-compra.op-codigo) + '" readonly>' +
'         </td>' +
'        </tr>' +
'         <th align="right" class="linhaForm" nowrap>Comprador:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_comprador" value="' + ordem-compra.cod-comprado + '" readonly>' +
'           <input class="fill-in" type="text" size="50" maxlength="50" name="w_desc_item" value=" ' + string(c-nome-usuario-doc) + ' " readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Num Alt Pre‡o:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="5" maxlength="5" name="w_preco" value="' + string(ordem-compra.nr-alt-preco) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'          <th align="right" class="linhaForm" nowrap>Requisitante:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="20" maxlength="20" name="w_requisitante" value="' + string(ordem-compra.requisitante) + '" readonly>' +
'           <input class="fill-in" type="text" size="50" maxlength="50" name="w_desc_item" value=" ' + string(c-nome-usuario-trans) + ' " readonly>' +
'        </td>' +
'        <th align="right" class="linhaForm" nowrap>Data EmissÆo:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="10" maxlength="10" name="w_data_emis" value="' + string(c-data-emissao) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Data Pedido:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="10" maxlength="10" name="w_data_pedido" value="' + string(c-data-pedido) + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Ordem Servi‡o:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="5" maxlength="5" name="w_ordem_servico" value="' + string(ordem-compra.ordem-servic) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Quantidade:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="18" name="w_qtde" value="' + trim(string(ordem-compra.qt-solic,">>>,>>>,>>9.9999")) + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Total:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="22" name="w_total" value="' + trim(string(de-total,">>>,>>>,>>>,>>9.9999")) + '" readonly>' +
'         </td>' +
'       <tr><td height="5"></td></tr>' +
'     </table>  ' +
'    </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  ' +
' </tr> ' +
'   <tr>'.

FIND first mla-doc-pend-aprov 
     WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
       AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
       AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
       AND mla-doc-pend-aprov.chave-doc    = c-chave  
       AND mla-doc-pend-aprov.ind-situacao = 1
       AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend¼ncia atual */
if avail mla-doc-pend-aprov then  do:
   {laphtml/mlahtmlrodape.i}
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

/* Segundo Folder */

ASSIGN tt-html.html-doc = tt-html.html-doc +
'<center>' +
'   <a name="complemento">' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">' + c-titulo + '</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'      <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" >' +
    '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
    '              Empresa:               ' +
    '          </th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
    '              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
    '            <td class="linhaForm" colspan=3 align="left" nowrap>' +
    '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
    '             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
    '            </td>' +
    '          </tr>' +

'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap><a href="#dados" class="aBrowser">Dados</a></th>' +
'            <td align="right" class="linhaForm" nowrap>Complemento</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#contrato" class="aBrowser">Contrato</a></th>' +
'           <td align="right" class="linhaForm" nowrap><a href="#req" class="aBrowser">Requisi‡äes</a></th>'.

IF l-alt THEN
   ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <td align="right" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Moeda:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="3" maxlength="3" name="w_moeda" value="' + string(i-moeda-doc) + '" readonly>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_desc_moeda" value="' + c-desc-moeda + '" readonly>' +
'         </td>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'         <th align="right" class="linhaForm" nowrap>Pre‡o:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_d_preco" value="' + trim(string(de-preco,">>>>>,>>>,>>9.9999")) + '" readonly>' +
'         </td>' +
'       </tr>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <tr>' +
'        <th align="right" class="linhaForm" nowrap>Natureza:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_natureza" value="' + c-natureza + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Aliquota IPI:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_aliquota_ipi" value="' + trim(string(de-aliquota-ipi,">>9.99")) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>'.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'         <th align="right" class="linhaForm" nowrap>Situa‡Æo:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_situacao" value="' + c-situacao + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Valor IPI:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_valor_ipi" value="' + trim(string(de-valor-ipi,">>>>>,>>>,>>9.99999")) + '" readonly>' +
'         </td>' +
'        </tr>' +
'         <th align="right" class="linhaForm" nowrap>Origem:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_origem" value="' + c-origem + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Pre‡o Unit:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_preco_unit" value="' + trim(string(de-preco-unit,">>>,>>>,>>9.9999")) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'          <th align="right" class="linhaForm" nowrap>Conta:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="24" maxlength="24" name="w_conta" value="' + v_cod_cta_ctbl + '" readonly>' +
'            <input class="fill-in" type="text" size="40" maxlength="40" name="w_conta" value="' + c-desc-conta + '" readonly>' +
'         </td>' +
'        <th align="right" class="linhaForm" nowrap>Pre‡o Origem:</th>' +
'       <td class="linhaForm" align="left" nowrap>' +
'         <input class="fill-in" type="text" size="16" maxlength="16" name="w_preco_origem" value="' + trim(STRING(de-preco-orig,">>>,>>>,>>9.9999")) + '" readonly>' +
'       </td>' +
'      </tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Centro Custo:</th>' +
'         <td class="linhaForm" align="left" nowrap colspan=3>' +
'            <input class="fill-in" type="text" size="24" maxlength="24" name="w_ccusto" value="' + v_cod_ccusto + '" readonly>' +
'            <input class="fill-in" type="text" size="40" maxlength="40" name="w_ccusto" value="' + c-desc-ccusto + '" readonly>' +
'         </td>' +
'      </tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Lota‡Æo:</th>' +
'         <td class="linhaForm" align="left" nowrap colspan=3>' +
'            <input class="fill-in" type="text" size="24" maxlength="24" name="w_conta" value="' + c-lotacao + '" readonly>' +
'            <input class="fill-in" type="text" size="40" maxlength="40" name="w_conta" value="' + c-desc-lotacao + '" readonly>' +
'         </td>' +
'      </tr>' +
'     <tr>' +
'         <th align="right" class="linhaForm" nowrap>Tipo Despesa:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="3" maxlength="3" name="w_tipo_despesa" value="' + string(ordem-compra.tp-despesa) + '" readonly>' +
'           <input class="fill-in" type="text" size="20" maxlength="20" name="w_desc_tipo_despesa" value="' + c-desc-despesa + '" readonly>' +
'         </td>' +
'         <th align="right" class="linhaForm" nowrap>Data Movimento:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'         <input class="fill-in" type="text" size="16" maxlength="16" name="w_data_movimento" value="' + c-data-movto + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'        <th align="right" class="linhaForm" nowrap>&nbsp;</th>' +
'        <td class="linhaForm" align="left" nowrap>'.

IF tb-expect = YES THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
'           <input type="checkbox" name="w_Ex_compra" value="" disabled checked>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
'           <input type="checkbox" name="w_Ex_compra" value="" disabled>'.

IF AVAIL cotacao-item THEN
    ASSIGN c-nat-cot-venc = cotacao-item.motivo-apr.
ELSE
    ASSIGN c-nat-cot-venc = "".
ASSIGN tt-html.html-doc = tt-html.html-doc +
'           Expect Compra' +
'         </td>' +
'        <th align="right" class="linhaForm" nowrap>Documento:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="16" maxlength="16" name="w_documento" value="' + string(c-numero-nota) + '" readonly>' +
'         </td>' +
'        </tr>'  +
  '       <tr>'  +
  '        <th align="right" class="linhaForm" nowrap>Narrativa Cot. Venc.:</th>' +
  '        <td class="linhaForm" align="left" nowrap>' +
  '           <textarea class="fill-in" name="w_narrativa_cot_vend" rows="4" cols="55" readonly>' + c-nat-cot-venc +  '</textarea>' +
  '        </td>'  +
  '       </tr> '  +
'        <tr><td height="5"></td></tr>' +
'      </table>  ' +
'     </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  '.

ASSIGN tt-html.html-doc = tt-html.html-doc +
' </tr> ' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

/* Terceiro Folder */
CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

ASSIGN tt-html.html-doc = tt-html.html-doc +
' <div align="center"><center>' +
'   <a name="narrativa">' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">' + c-titulo + '</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'      <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" >' +
    '         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
'              Empresa:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
'             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
'            </td>' +
'          </tr>' +

'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>'.

&if defined(bf_mla_ambiente_magnus) &then
    assign c-narrativa = ordem-compra.narrativa[1] +
                         ordem-compra.narrativa[2] +
                         ordem-compra.narrativa[3] +
                         ordem-compra.narrativa[4] +
                         ordem-compra.narrativa[5].   
    assign i-num-seq-item = 0.                         
&else
    assign c-narrativa    = ordem-compra.narrativa
           i-num-seq-item = ordem-compra.num-seq-item.
&endif

    ASSIGN tt-html.html-doc = tt-html.html-doc +
'      </fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap><a href="#dados" class="aBrowser">Dados</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#complemento" class="aBrowser">Complemento</a></th>' +
'            <td align="right" class="linhaForm" nowrap>Narrativa</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#contrato" class="aBrowser">Contrato</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#req" class="aBrowser">Requisi‡äes</a></th>' .

IF l-alt THEN
   ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <td align="right" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <td class="linhaForm" align="center" nowrap>' +
'           <textarea class="fill-in" name="w_narrativa" rows="11" cols="80" readonly>' + c-narrativa +  '</textarea>' +
'         </td>' +
'        </tr> ' +
'        <tr><td height="5"></td></tr>' +
'      </table>  ' +
'     </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  ' +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

    CREATE tt-html.
    ASSIGN i-cont = i-cont + 1
           tt-html.seq-html = i-cont.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
' <div align="center"><center>' +
'   <a name="contrato">' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">' + c-titulo + '</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'      <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" >' +
        '         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
'              Empresa:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
'             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
'            </td>' +
'          </tr>' +

'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
'          <tr>' +
'           <td align="right" class="linhaForm" nowrap><a href="#dados" class="aBrowser">Dados</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#complemento" class="aBrowser">Complemento</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>' +
'            <td align="right" class="linhaForm" nowrap>Contrato</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#req" class="aBrowser">Requisi‡äes</a></th>'.

IF l-alt THEN
   ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <td align="right" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>N£mero do Contrato:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="16" maxlength="16" name="w_nr_contrat" value="' + STRING(ordem-compra.nr-contrato) + '" readonly>' +
'         </td>' +
'        </tr>' +
'       <tr>' +
'         <th align="right" class="linhaForm" nowrap>Seq Item:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_seq_item" value="' + STRING(i-num-seq-item) + '" readonly>' +
'         </td>' +
'        </tr>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Tipo Controle:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" maxlength="20" name="w_tipo_controle" value="' + cb-ind-tipo-controle + '" readonly>' +
'        </td>' +
'        </tr>' +
'         <td colspan="2" class="linhaForm">' +
'           <fieldset>' +
'           <legend>Situa‡Æo</legend> ' +
'            <table align="center" border="0" cellpadding="0" cellspacing="1" width="20%">' +
'              <tr>'.

&if defined(bf_mla_ambiente_magnus) &then
&else
CASE ordem-compra.sit-ordem-contrat: 
 WHEN 1 THEN 
     ASSIGN tt-html.html-doc = tt-html.html-doc +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="1" checked disabled>NÆo Emitido</td>' +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="2" disabled>Emitido</th>' +
  '                 <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="3" disabled>Cancelado</th>'.
 WHEN 2 THEN 
     ASSIGN tt-html.html-doc = tt-html.html-doc +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="1" disabled>NÆo Emitido</td>' +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="2" checked disabled>Emitido</th>' +
  '                 <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="3" disabled>Cancelado</th>'.
 WHEN 3 THEN 
     ASSIGN tt-html.html-doc = tt-html.html-doc +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="1" disabled>NÆo Emitido</td>' +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="2" disabled>Emitido</th>' +
  '                 <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="3" checked disabled>Cancelado</th>'.
 OTHERWISE 
     ASSIGN tt-html.html-doc = tt-html.html-doc +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="1" checked disabled>NÆo Emitido</td>' +
  '                <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="2" disabled>Emitido</th>' +
  '                 <td align="right" class="linhaForm" nowrap><input type="radio" name="w_radio_situacao" value="3" disabled>Cancelado</th>'.
END.
&endif

ASSIGN tt-html.html-doc = tt-html.html-doc +
'               </tr>' +
'             </table>' +
'           </fieldset>' +
'         </td>' +
'        </tr>' +
'       <tr><td height="5"></td></tr>' +
'      </table>  ' +
'     </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  ' +
' </tr> ' +
'  <tr>'.
CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'   </div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
' <div align="center"><center>' +
'   <a name="req">' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">' + c-titulo + '</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'      <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1">' +
    '         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
'              Empresa:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
'             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
'            </td>' +
'          </tr>' +

'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
'            <td class="linhaForm" align="left" nowrap>' +
'             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>' +
' <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
' <tr>' +
'    <td align="right" class="linhaForm" nowrap><a href="#dados" class="aBrowser">Dados</a></th>' +
'    <td align="right" class="linhaForm" nowrap><a href="#complemento" class="aBrowser">Complemento</a></th>' +
'    <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>' +
'    <td align="right" class="linhaForm" nowrap><a href="#contrato" class="aBrowser">Contrato</a></th>' +
'    <td align="right" class="linhaForm" nowrap>Requisi‡äes</th>'.

IF l-alt THEN
   ASSIGN tt-html.html-doc = tt-html.html-doc +
'        <td align="right" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .

ASSIGN tt-html.html-doc = tt-html.html-doc +
' </tr>' +
'</table>' +
'  </center>' +
'  </td>' +
' </tr>' +
' </table><br> ' +
' <table class="tableForm" align="center">' +
'    <tr>' +
'     <td align="center"  class="ColumnLabel" >Requisi‡Æo</td>' +
'     <td align="center"  class="ColumnLabel" >Item</td>' +
'     <td align="center"  class="ColumnLabel" >Dep</td>' +
'     <td align="center"  class="ColumnLabel" >Est</td>' +
'     <td align="center"  class="ColumnLabel" >Localiz</td>' +
'     <td align="center"  class="ColumnLabel" >Ref</td>' +
'     <td align="center"  class="ColumnLabel" >Atendimento</td>' +
'     <td align="center"  class="ColumnLabel" >Entrega</td>' +
'     <td align="center"  class="ColumnLabel" >Conta</td>' +
'     <td align="center"  class="ColumnLabel" >T¡tulo Conta</td>' +
'     <td align="center"  class="ColumnLabel" >Centro Custo</td>' +
'     <td align="center"  class="ColumnLabel" >T¡tulo Centro Custo</td>' +
'     <td align="center"  class="ColumnLabel" >Sit</td>' +
'    </tr>'.

FOR EACH  it-requisicao 
    WHERE it-requisicao.numero-ordem = ordem-compra.numero-ordem 
    NO-LOCK:

    CREATE tt-html.
    ASSIGN i-cont = i-cont + 1
           tt-html.seq-html = i-cont.

    IF (i-cont MOD 2) = 0 THEN
        ASSIGN c-class = ' class="linhaBrowsepar" ' .
    ELSE 
        ASSIGN c-class = ' class="linhaBrowseImpar" '.

        FIND estabelec WHERE 
        estabelec.cod-estabel = ordem-compra.cod-estabel 
        NO-LOCK NO-ERROR.
        
        RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                  OUTPUT i-empresa).

        /* Realiza a busca da conta contabil */
        assign v_cod_cta_ctbl = it-requisicao.ct-codigo.
        {laphtml/mlaUnifBuscaConta.i i-empresa v_cod_cta_ctbl today}
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            ASSIGN c-desc-conta = "".
        end.
        else
            ASSIGN c-desc-conta = v_titulo_cta_ctbl.
        
        /* Realiza a busca do centro de custo */
        {laphtml/mlaUnifBuscaCC.i i-empresa  it-requisicao.sc-codigo today}
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            ASSIGN c-desc-ccusto = "".
        end.
        else
            ASSIGN c-desc-ccusto = v_titulo_ccusto.  
    /*FIND conta-contab WHERE conta-contab.conta-contabil = it-requisicao.conta-contabil NO-LOCK NO-ERROR.*/

           /******** Unificação de conceitos, buscando formatos ********/
        {laphtml/mlaUnifFormatos.i i-empresa today}          
        if c-formato-conta <> "" then
            assign v_cod_cta_ctbl = string(it-requisicao.ct-codigo, c-formato-conta).
        else
            assign v_cod_cta_ctbl = it-requisicao.ct-codigo.
            
        if c-formato-ccusto <> "" then
            assign v_cod_ccusto = string(it-requisicao.sc-codigo, c-formato-ccusto).
        else
            assign v_cod_ccusto = it-requisicao.sc-codigo.   

    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '    <tr>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.nr-requisicao) +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + it-requisicao.it-codigo + 
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.cod-depos) +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.cod-estabel) +
    '     </td>' +
    &if defined(bf_mla_ambiente_magnus) &then
    '     <td ' + c-class + ' >' +
    '      ' + it-requisicao.localizacao +
    '     </td>' +
    &else
    '     <td ' + c-class + ' >' +
    '      ' + it-requisicao.cod-localiz +
    '     </td>' +
    &endif
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.cod-refer) +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.dt-atend,"99/99/9999") +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(it-requisicao.dt-entrega,"99/99/9999") +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + STRING(v_cod_cta_ctbl) +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + c-desc-conta +
    '     </td>'+
     '     <td ' + c-class + ' >' +
    '      ' + STRING(v_cod_ccusto) +
    '     </td>' +
    '     <td ' + c-class + ' >' +
    '      ' + c-desc-ccusto +
    '     </td>'.
 
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '     <td ' + c-class + ' >' +
    '      ' + string({ininc/i01in385.i 4 it-requisicao.situacao}) +
    '     </td>' +
    '    </tr>'.
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +
' </table><br>' +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' .


/* Altera‡äes */
IF l-alt THEN DO:

    CREATE tt-html.
    ASSIGN i-cont = i-cont + 1
           tt-html.seq-html = i-cont.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' <div align="center"><center>' +
    '   <a name="alt">' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
    '     <tr>' +
    '       <td class="barratitulo">' + c-titulo + '</td>' +
    '     </tr>' +
    '    <tr>' +
    '     <td class="linhaForm" align="center"><center>' +
    '      <fieldset>' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1">' +
        '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap> ' +
    '              Empresa:               ' +
    '          </th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
    '              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '            <th align="right" colspan=1 class="linhaForm" nowrap>Fornecedor:</th>' +
    '            <td class="linhaForm" colspan=3 align="left" nowrap>' +
    '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_emitente" value="' + string(ordem-compra.cod-emitente) + '" readonly>' +
    '             <input class="fill-in" type="text" size="40" maxlength="40" name="w_nome_abrev" value="' + c-desc-emitente + '" readonly>' +
    '            </td>' +
    '          </tr>' +
    
    '          <tr>' +
    '            <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
    '            <td class="linhaForm" align="left" nowrap>' +
    '             <input class="fill-in" type="text" size="9"  maxlength="9" name="w_ordem" value="' + string(ordem-compra.numero-ordem,"zzzzz9,99") + '" readonly>' +
    '            </td>' +
    '            <th align="right" class="linhaForm" nowrap>Seq:</th>' +
    '            <td class="linhaForm" align="left" nowrap>' +
    '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_seq" value="' + string(ordem-compra.sequencia) + '" readonly>' +
    '            </td>' +
    '          </tr>' +
    '        </table>' +
    '      </fieldset>' +
    ' <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%">' +
    ' <tr>' +
    '    <td align="right" class="linhaForm" nowrap><a href="#dados" class="aBrowser">Dados</a></th>' +
    '    <td align="right" class="linhaForm" nowrap><a href="#complemento" class="aBrowser">Complemento</a></th>' +
    '    <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>' +
    '    <td align="right" class="linhaForm" nowrap><a href="#contrato" class="aBrowser">Contrato</a></th>' +
    '    <td align="right" class="linhaForm" nowrap><a href="#req" class="aBrowser">Requisi‡äes</a></th>' +
    '    <td align="right" class="linhaForm" nowrap>Altera‡äes</th>' .
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' </tr>' +
    '</table>' +
    '  </center>' +
    '  </td>' +
    ' </tr>' +
    ' </table><br> ' +
    ' <table class="tableForm" align="center">' +
    '    <tr>' +
        '     <td align="center"  class="ColumnLabel" >Data Altera‡Æo</td>' +
        '     <td align="center"  class="ColumnLabel" >Hora</td>' +
        '     <td align="center"  class="ColumnLabel" >Usu rio</td>' +
        '     <td align="center"  class="ColumnLabel" >Ordem Compra</td>' +
        '     <td align="center"  class="ColumnLabel" >Parcela</td>' +
        '     <td align="center"  class="ColumnLabel" >Quantidade</td>' +
        '     <td align="center"  class="ColumnLabel" >Nova Qtde</td>' +
        '     <td align="center"  class="ColumnLabel" >Pre‡o Unit rio</td>' +
        '     <td align="center"  class="ColumnLabel" >Novo Pre‡o</td>' +
        '     <td align="center"  class="ColumnLabel" >Dt Entrega</td>' +
        '     <td align="center"  class="ColumnLabel" >Nova Dt Ent</td>' +
        '     <td align="center"  class="ColumnLabel" >Cond Pagto</td>' +
        '     <td align="center"  class="ColumnLabel" >Nova Cond Pagto</td>' +
        '     <td align="center"  class="ColumnLabel" >Observa‡Æo</td>' +
        '     <td align="center"  class="ColumnLabel" >Coment rios</td>' +
    '    </tr>'.

    
    FOR EACH  alt-ped
        WHERE alt-ped.num-pedido   = pedido-compr.num-pedido   AND 
              alt-ped.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
    
        ASSIGN c-quantidade      = STRING(alt-ped.quantidade,">>>>,>>9.9999")
               c-qtd-sal-forn    = ""
               c-data-entrega    = STRING(alt-ped.data-entrega,"99/99/9999")
               c-data-entrega-2  = ""
               c-comentarios     = ""
               c-cod-cond-pag    = STRING(alt-ped.cod-cond-pag)
               c-cod-cond-pag-2  = ""
               c-preco           = STRING(alt-ped.preco,">>>>>,>>>,>>9.99999") 
               c-pre-unit-for    = "".
               
        IF  alt-ped.parcela <> 0 THEN 
            FOR FIRST prazo-compra FIELDS( qtd-sal-forn data-entrega ) WHERE 
                      prazo-compra.numero-ordem = alt-ped.numero-ordem AND
                      prazo-compra.parcela      = alt-ped.parcela      NO-LOCK: END.
    
        IF  alt-ped.parcela <> ? AND
            AVAIL prazo-compra  THEN DO:
        
            IF NOT alt-ped.observacao BEGINS "#" THEN DO:
                /* Nova Quantidade */
                IF  alt-ped.quantidade <> ? AND 
                    alt-ped.quantidade <> prazo-compra.qtd-sal-forn THEN 
                    ASSIGN c-qtd-sal-forn = IF alt-ped.char-1 <> "" THEN 
                                               STRING(DEC(ENTRY(2,alt-ped.char-1,"|")),">>>>,>>9.9999")
                                            ELSE
                                                STRING(prazo-compra.qtd-sal-forn,">>>>,>>9.9999").
    
                /* Nova Data Entrega */
                IF  alt-ped.data-entrega <> ? AND 
                    alt-ped.data-entrega <> prazo-compra.data-entrega THEN
                    ASSIGN c-data-entrega-2 = IF alt-ped.char-1 <> "" THEN 
                                                 ENTRY(3,alt-ped.char-1,"|")
                                              ELSE
                                                 STRING(prazo-compra.data-entrega,"99/99/9999").
            END.        
        END.
        
        IF alt-ped.numero-ordem <> 0 THEN DO:
        
            IF alt-ped.numero-ordem <> ordem-compra.numero-ordem THEN
               FOR FIRST ordem-compra FIELDS( comentarios pre-unit-for cod-cond-pag numero-ordem ) WHERE 
                         ordem-compra.numero-ordem = alt-ped.numero-ordem NO-LOCK: END.
        
            IF AVAIL ordem-compra     AND 
               NOT alt-ped.observacao BEGINS "#" THEN DO:
            
                &IF  "{&bf_dis_versao_ems}" < "2.04" &THEN
                  ASSIGN c-comentarios = ordem-compra.comentarios.
                &ENDIF
            
                /* Novo Pre‡o */
                IF alt-ped.preco <> 0  AND 
                   alt-ped.preco <> ?  AND
                   alt-ped.preco <> ordem-compra.pre-unit-for THEN
                   ASSIGN c-pre-unit-for = IF alt-ped.char-1 <> "" THEN  
                                              STRING(dec(ENTRY(1,alt-ped.char-1,"|")),">>>>>,>>>,>>9.99999")
                                           ELSE
                                              STRING(ordem-compra.pre-unit-for,">>>>>,>>>,>>9.99999").
                /* Nova Cond. Pagamento */
                IF alt-ped.cod-cond-pag <> 0 AND 
                   alt-ped.cod-cond-pag <> ? AND 
                   alt-ped.cod-cond-pag <> ordem-compra.cod-cond-pag THEN 
                   ASSIGN c-cod-cond-pag-2 = IF alt-ped.char-1 <> "" THEN  
                                                STRING(DEC(ENTRY(4,alt-ped.char-1,"|")),">>9")
                                             ELSE 
                                                STRING(ordem-compra.cod-cond-pag).
            END.
        END.
        
        IF c-data-entrega = ? THEN
            ASSIGN c-data-entrega = "".
    
        IF c-data-entrega-2 = ? THEN
            ASSIGN c-data-entrega-2 = "".
    
        IF c-cod-cond-pag = ? THEN
            ASSIGN c-cod-cond-pag = "".
    
        IF c-cod-cond-pag-2 = ? THEN
            ASSIGN c-cod-cond-pag-2 = "".
    
        IF c-preco = ? THEN
            ASSIGN c-preco = "".
    
        IF c-pre-unit-for = ? THEN
            ASSIGN c-pre-unit-for = "".
    
        IF c-quantidade = ? THEN
            ASSIGN c-quantidade = "".
    
        IF c-qtd-sal-forn = ? THEN
            ASSIGN c-qtd-sal-forn = "".

        &IF  "{&bf_dis_versao_ems}" >= "2.04" &THEN
            
            IF c-comentarios = "" THEN DO:
                IF c-pre-unit-for <> "" THEN DO:
                    {utp/ut-liter.i Alterado(s):_Pre‡o_Unit rio}
                    ASSIGN c-comentarios = TRIM(RETURN-VALUE).
                END.
                IF c-qtd-sal-forn <> "" THEN DO:
                    IF  c-comentarios = "" THEN DO:
                        {utp/ut-liter.i Alterado(s):_Quantidade_Saldo}
                        ASSIGN c-comentarios = TRIM(RETURN-VALUE).
                    END.
                    ELSE DO:
                        {utp/ut-liter.i Quantidade_Saldo}
                        ASSIGN c-comentarios = c-comentarios + ", " + TRIM(RETURN-VALUE).
                    END.
                END.
                IF c-data-entrega <> "" THEN DO:
                    IF  c-comentarios = "" THEN DO:
                        {utp/ut-liter.i Alterado(s):_Data_Entrega}
                        ASSIGN c-comentarios = TRIM(RETURN-VALUE).
                    END.
                    ELSE DO:
                        {utp/ut-liter.i Data_Entrega}
                        ASSIGN c-comentarios = c-comentarios + ", " + TRIM(RETURN-VALUE).
                    END.
                END.
                IF c-cod-cond-pag <> "" THEN DO:
                    IF  c-comentarios = "" THEN DO:
                        {utp/ut-liter.i Alterado(s):_Condi‡Æo_Pagamento}
                        ASSIGN c-comentarios = TRIM(RETURN-VALUE).
                    END.
                    ELSE DO:
                        {utp/ut-liter.i Condi‡Æo_Pagamento}
                        ASSIGN c-comentarios = c-comentarios + ", " + TRIM(RETURN-VALUE).
                    END.
                END.
            END.
        &ENDIF
    
        
        CREATE tt-html.
        ASSIGN i-cont = i-cont + 1
               tt-html.seq-html = i-cont.

        IF (i-cont MOD 2) = 0 THEN
            ASSIGN c-class = ' class="linhaBrowsepar" ' .
        ELSE 
            ASSIGN c-class = ' class="linhaBrowseImpar" '.
    
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '    <tr>' +
        '     <td ' + c-class + ' >' +
        '      ' + STRING(alt-ped.data,"99/99/9999") +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + alt-ped.hora +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + alt-ped.usuario +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + STRING(alt-ped.numero-ordem,"999999,99") +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + STRING(alt-ped.parcela) +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-quantidade +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-qtd-sal-forn +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-preco +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-pre-unit-for +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-data-entrega +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-data-entrega-2 +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-cod-cond-pag +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-cod-cond-pag-2 +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + alt-ped.observacao +
        '     </td>' +
        '     <td ' + c-class + ' >' +
        '      ' + c-comentarios +
        '     </td>' +
        '    </tr>'.
    END.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' </table><br>' +
    '</div>' +
    '<br><br><br><br><br><br><br><br><br><br><br>' +
    '<br><br><br><br><br><br><br><br><br><br><br>' +
    '<br><br><br><br><br><br><br><br><br><br><br>' +
    '<br><br><br><br><br><br><br><br><br><br><br>' .

END.


ASSIGN tt-html.html-doc = tt-html.html-doc +
'  </form>' +
' </body> ' +
'</html>'.

IF mla-param-aprov.log-atachado and index(proversion,"webspeed") = 0 THEN
    FOR EACH tt-html:
        ASSIGN tt-html.html-doc = codepage-convert(tt-html.html-doc,"iso8859-1","ibm850").
    END.
delete object h_api_cta_ctbl.
delete object h_api_ccusto.

/* OUTPUT TO c:~\tmp~\espec006e.htm.                     */
/* FOR EACH  tt-html:                                  */
/*     PUT tt-html.html-doc.                           */
/* END.                                                */
/* OUTPUT CLOSE.                                       */
/* DOS SILENT VALUE("explorer c:~\tmp~\espec006e.htm."). */

