/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i MLAHTML008E 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i mlahtml008e MML}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-epc200.i "mlahtml008e"}
{lap/mlaapi001.i99}
{laphtml/mlahtml.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}


DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-mla-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.


DEF VAR c-class AS CHAR NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
def var c-chave as char no-undo.
def var i-chave as integer no-undo.
DEF VAR i-seq-html AS INTEGER NO-UNDO.
DEF var i-empresa LIKE mgcad.empresa.ep-codigo no-undo.

DEF VAR l-alt            AS LOG                        NO-UNDO.
DEF VAR c-quantidade     AS CHAR FORMAT "X(14)"        NO-UNDO.
DEF VAR c-qtd-sal-forn   AS CHAR FORMAT "X(14)"        NO-UNDO.
DEF VAR c-preco          AS CHAR FORMAT "X(21)"        NO-UNDO.
DEF VAR c-pre-unit-for   AS CHAR FORMAT "X(21)"        NO-UNDO.
DEF VAR c-dt-entrega     AS CHAR FORMAT "X(10)"        NO-UNDO.
DEF VAR c-dt-entrega-2   AS CHAR FORMAT "X(10)"        NO-UNDO.
DEF VAR c-cod-cond-pag   AS CHAR FORMAT "X(3)"         NO-UNDO.
DEF VAR c-cod-cond-pag-2 AS CHAR FORMAT "X(3)"         NO-UNDO.
DEF VAR c-comentarios    LIKE ordem-compra.comentarios NO-UNDO.
DEFINE VARIABLE c-servidor AS CHARACTER   NO-UNDO.

/**   Monta chave do documento
**/
{lap/mlachave.i}

DEF VAR c-nome-abrev    AS CHAR NO-UNDO.
DEF VAR c-frete         AS CHAR NO-UNDO.
DEF VAR c-natureza      AS CHAR NO-UNDO.
DEF VAR c-via-trans     AS CHAR NO-UNDO.
DEF VAR c-situacao      AS CHAR NO-UNDO.
DEF VAR de-total        AS DEC  NO-UNDO.  
DEF VAR de-preco-unit   AS DEC  NO-UNDO.
DEF VAR c-moeda         AS CHAR NO-UNDO.
DEF VAR c-transporte    AS CHAR NO-UNDO.
DEF VAR c-data-entrega      AS CHAR NO-UNDO.
DEF VAR de-quant-saldo      AS DEC  NO-UNDO.
DEF VAR d-aliquota-ipi      AS DEC  NO-UNDO.
DEF VAR de-val-orig         AS DEC  NO-UNDO.
DEF VAR d-pre-unit-for      AS DEC  NO-UNDO.
DEF VAR d-preco-unit        AS DEC  NO-UNDO.
DEF VAR c-desc-item         AS CHAR NO-UNDO.
DEF VAR c-frete-b           AS CHAR NO-UNDO.
DEF VAR c-ipi               AS CHAR NO-UNDO.
DEF VAR c-icm               AS CHAR NO-UNDO.
DEF VAR c-situacao-b        AS CHAR NO-UNDO.
DEF VAR c-literal           AS CHAR NO-UNDO.
DEF VAR c-incluso           AS CHAR NO-UNDO.
DEF VAR c-naoincluso        AS CHAR NO-UNDO.
DEF VAR c-consumo           AS CHAR NO-UNDO.
DEF VAR c-industrial        AS CHAR NO-UNDO.
DEF VAR c-lista-natureza    AS CHAR NO-UNDO.
DEF VAR c-lista-situacao    AS CHAR NO-UNDO.
DEF VAR c-sit               AS CHAR NO-UNDO.
DEF VAR fi-cond-pagto       AS CHAR NO-UNDO.
DEF VAR fi-desc-resp        AS CHAR NO-UNDO.
DEF VAR c-narrativa         AS CHAR NO-UNDO.
DEF VAR c-desc-conta        AS CHAR NO-UNDO.
DEF VAR c-desc-ccusto       AS CHAR NO-UNDO.
DEF VAR c-desc-requis       AS CHAR NO-UNDO.
DEF VAR fi-tp-despesa       AS CHAR NO-UNDO.
DEF VAR c-un-cot            AS CHAR NO-UNDO.
DEF VAR dt-entreg           AS CHAR NO-UNDO.
DEF VAR centro-custo        AS CHAR NO-UNDO.
DEF VAR aprovador           AS CHAR NO-UNDO.
DEF VAR desc-aprovador      AS CHAR NO-UNDO.
DEF VAR req-narrativa       AS CHAR NO-UNDO.
DEF VAR c-desc-estab        AS CHAR NO-UNDO.
DEF VAR c-desc-empresa      AS CHAR NO-UNDO.
DEF VAR i-empresa-prin      AS INT  NO-UNDO.
DEF VAR l-preco-bruto       AS LOG  NO-UNDO.
DEF VAR de-valor-ipi        AS DEC  NO-UNDO. 
DEF VAR de-preco-conv       AS DEC  NO-UNDO.
DEF VAR de-preco-mat        AS DEC  NO-UNDO.
DEF VAR de-preco-total-cot  AS DEC  NO-UNDO.
DEF VAR c-utl-natureza      AS CHAR NO-UNDO.
DEF VAR c-utl-moeda         AS CHAR NO-UNDO.
DEF VAR de-utl-quant        AS DEC  NO-UNDO.
DEF VAR c-razao-social      AS CHAR NO-UNDO.
def var c-cod-estabel       LIKE estabelec.cod-estabel no-undo.
def var c-cod-estabel-ent   as char no-undo.
def var c-narrativa-ordem   as char format "x(2000)".
DEF VAR c-narrativa-cotac   AS char format "x(2000)".
def var c-ct-codigo         as char format "x(20)".
def var c-sc-codigo         as char format "x(20)".
def var de-total-item       as decimal no-undo.
DEF VAR da-cotacao          AS DATE    NO-UNDO.
DEF VAR de-cotacao          AS DECIMAL NO-UNDO.
def var i-moeda-doc         as int init 0 no-undo. /* 0 = moeda Real */
DEF VAR c-desc-documento    AS CHAR NO-UNDO.
DEF VAR de-preco-unit-conv  AS DECIMAL NO-UNDO.
def var c-1-data-entrega    as char no-undo.
def var de-1-quant-saldo    as DEC no-undo.
def var c-1-frete-b         as char no-undo.
def var c-1-ipi             as char no-undo.
def var c-1-incluso         as char no-undo.
def var c-1-naoincuso       as char no-undo.
def var da-1-cotacao        as date no-undo.
def var d-1-pre-unit-for    as DEC no-undo.
def var de-1-cotacao        as DEC no-undo.
def var d-1-preco-unit      as DEC no-undo.
def var de-1-total          as DEC no-undo.
DEF VAR c-1-naoincluso       AS CHAR NO-UNDO.

def var de-fvalor-final    as decimal format "999999999999.9999" initial 0.
def var de-fvl-ss30        as decimal format "999999999999.9999" initial 0.
def var de-fvalor-ss30     as decimal format "999999999999.9999" initial 0.
def var de-fvl-final       as decimal format "999999999999.9999" initial 0. 
def var de-fvalor-ent      as decimal format "999999999999.9999" initial 0.
def var de-fvl-ent         as decimal format "999999999999.9999" initial 0.
def var de-fvalor-ent-efe  as decimal format "999999999999.9999" initial 0.
def var de-fvl-ent-efe     as decimal format "999999999999.9999" initial 0.
def var de-fvalor-sai      as decimal format "999999999999.9999" initial 0.
def var de-fvl-sai         as decimal format "999999999999.9999" initial 0.
def var de-fvalor-sai-efe  as decimal format "999999999999.9999" initial 0.
def var de-fvl-sai-efe     as decimal format "999999999999.9999" initial 0.
def var de-val-sup  as decimal format "ZZZ,ZZZ,ZZ9.99" init ?.
def var de-lim-exc  as decimal format "ZZZ,ZZZ,ZZ9.99" init ?.
def var de-perc-var as decimal format "ZZ9.99" init ? .
def var de-fvalor-medio     as decimal format "999999999999.9999" initial 0.
def var de-fvalor-excedente as decimal format "999999999999.9999" initial 0.
def var de-fvalor-seguranca as decimal format "999999999999.9999" initial 0.
def var de-fvl-med          as decimal format "999999999999.9999" initial 0.
def var de-fvl-exc          as decimal format "999999999999.9999" initial 0.
def var de-fvl-seg          as decimal format "999999999999.9999" initial 0.

def var i-dia              as integer format "99".
def var i-dia-x            as integer format "99".
def var i-dias-cons2       as i format "ZZZ9".
def var i-fitens-ss30      as integer format "999999" init 0.
def var i-fit-ss30         like i-fitens-ss30.
def var i-mo               as integer format "9" initial 1.
def var i-fentradas        like i-fitens-ss30.
def var i-fent             like i-fitens-ss30.
def var i-fent-efe         like i-fitens-ss30.
def var i-fentradas-efe    like i-fitens-ss30.
def var i-fsaidas          like i-fitens-ss30.
def var i-fsai             like i-fitens-ss30.
def var i-fsaidas-efe      like i-fitens-ss30.
def var i-fsai-efe         like i-fitens-ss30.
def var i-fitens-impressos like i-fitens-ss30.
def var i-fit-imp          like i-fitens-ss30.
def var i-mes-fec          as integer format "99".
def var i-ano-fec          like i-mes-fec.
def var i-dia-fec          like i-mes-fec.

def var c-classe              as c format "x(1)".
def var da-data-cot           like movto-estoq.dt-trans.
def var de-preco-convertido   like item-estab.val-unit-mat-m extent 0.
def var de-qtde               like movto-estoq.quantidade.
def var de-saldo-ent          as decimal format "999999999999.9999" init 0.
def var de-vl-medio           like de-saldo-ent.
def var de-saldo-sai          like de-saldo-ent.
def var de-saldo-medio        like de-saldo-ent.
def var de-saldo-excedente    like de-saldo-ent.
def var de-saldo-seguranca    like de-saldo-ent.
def var de-nr-dias-estoque    like de-saldo-ent.
def var de-giro               like de-saldo-ent.
def var de-valor-ent          like de-saldo-ent.
def var de-valor-sai          like de-saldo-ent.
def var de-valor-medio        like de-saldo-ent.
def var de-valor-excedente    like de-saldo-ent.
def var de-valor-seguranca    like de-saldo-ent.
def var de-valor-saldo        like de-saldo-ent.
def var de-valor              like de-saldo-ent.
def var de-saldo-ini          like de-saldo-ent.
def var de-valor-ini          like de-saldo-ent.
def var de-preco-base         like item.preco-base.
def var de-preco-ul-ent       like item.preco-ul-ent.
def var de-preco-repos        like item.preco-repos.
def var i-tipo-est-seg        like item.tipo-est-seg.
def var de-quant-segur        like item.quant-segur.
def var i-tempo-segur         like item.tempo-segur.
def var c-classif-abc         like item.classif-abc.
def var da-data-ult-ent       like item.data-ult-ent.
def var da-data-ult-sai       like item.data-ult-sai.
def var de-lote-economi       like item.lote-economi.

DEF VAR da-iniper-x           AS DATE NO-UNDO.
DEF VAR da-fimper-x           AS DATE NO-UNDO.
DEF VAR i-numper-x            AS INTEGER NO-UNDO.

def new shared var de-saldo   like de-saldo-ent.
def new shared var de-varcrp  like de-saldo.

def var l-lista                as log init yes.
def var l-ss30                 as log.
def var l-nao-consumo          as log init no.
def var i-ano-corrente         as integer no-undo.
def var i-per-corrente         as integer no-undo.
def var da-iniper-fech  like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech  like param-estoq.ult-fech-dia no-undo.

def var c-lb-item              as char format "x(6)".
def var c-lb-desc              as char    format "x(11)".
def var c-lb-un                as char format "x(2)".
def var c-lb-ge                as char    format "x(2)".
def var c-lb-qtd               as char    format "x(12)".
def var c-lb-valor             as char    format "x(7)".
def var c-lb-dt                as char    format "x(12)".
def var c-lb-obs               as char    format "x(4)".
def var c-lb-ent               as char    format "x(4)".
def var c-lb-sai               as char    format "x(4)".
def var c-lb-sal               as char    format "x(4)".
def var c-lb-med               as char    format "x(4)".
def var c-lb-exc               as char    format "x(4)".
def var c-lb-seg               as char    format "x(4)".
def var c-lb-cons              as char    format "x(16)".
def var c-lb-giro              as char    format "x(4)".
def var c-lb-classe            as char    format "x(9)".
def var c-lb-lote              as char    format "x(14)".
def var c-lb-quant             as char    format "x(10)".
def var c-lb-nr-dias           as char    format "x(18)".
def var c-lb-variacao          as char    format "x(38)".
def var c-fabricante           as char.

def var da-mensal-ate          like param-estoq.mensal-ate.
def var l-fech-estab           as logical init no.
def var de-consumo-prev        as decimal no-undo.
def var days_boh               as integer.

















DEF BUFFER b-ordem FOR ordem-compra.
DEF BUFFER b-emitente FOR emitente.

/* Include de definição de variáveis Unificação de conceitos */
{laphtml/mlaUnifDefine.i}
/* Handle da API Conta Cont bil e Centro de Custo */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
run prgint/utb/utb742za.py persistent set h_api_ccusto. 

find first param-compra no-lock no-error.
if  param-compra.ipi-sobre-preco = 1 then 
    assign l-preco-bruto = YES.
else 
    assign l-preco-bruto = NO.

FIND FIRST pedido-compr 
     WHERE pedido-compr.num-pedido = integer(tt-mla-chave.valor[1])
     NO-LOCK NO-ERROR.

IF AVAIL pedido-compr THEN DO:
    FIND FIRST mla-usuar-aprov 
        WHERE mla-usuar-aprov.cod-usuar = p-cod-aprovador
        NO-LOCK NO-ERROR.

    ASSIGN c-cod-estabel  = pedido-compr.cod-estab-gestor
           desc-aprovador = mla-usuar-aprov.nome-usuar.
    IF  c-cod-estabel = "" THEN ASSIGN c-cod-estabel = pedido-compr.end-entrega.
    IF c-seg-usuario = "" THEN ASSIGN c-seg-usuario = pedido-compr.responsavel.

    FIND estabelec WHERE
         estabelec.cod-estabel = c-cod-estabel
         NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    FIND FIRST mla-param-aprov  
         WHERE mla-param-aprov.ep-codigo   = i-empresa 
         AND   mla-param-aprov.cod-estabel = c-cod-estabel
         NO-LOCK NO-ERROR.

    FIND FIRST mla-doc-pend-aprov USE-INDEX pend-10
        WHERE mla-doc-pend-aprov.ep-codigo   = i-empresa
        AND   mla-doc-pend-aprov.cod-estabel = c-cod-estabel
        AND   mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
        AND   mla-doc-pend-aprov.chave-doc   = tt-mla-chave.valor[1]
        NO-LOCK NO-ERROR.

    FIND FIRST mla-tipo-doc-aprov 
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa 
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel 
           AND mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK NO-ERROR.
    IF AVAIL mla-tipo-doc-aprov THEN
        ASSIGN c-desc-documento = mla-tipo-doc-aprov.des-tip-doc.

    FOR FIRST emitente FIELD(cod-emitente nome-abrev nome-emit)  
        WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK: END.
    IF AVAIL emitente THEN
      assign c-nome-abrev   = emitente.nome-abrev
             c-razao-social = emitente.nome-emit.

    assign c-frete     = {ininc/i03in295.i 04 pedido-compr.frete}
           c-natureza  = {ininc/i01in295.i 04 pedido-compr.natureza}
           c-situacao  = {ininc/i02in295.i 04 pedido-compr.situacao}
           c-via-trans = {adinc/i01ad268.i 04 pedido-compr.via-trans}
           c-narrativa  = pedido-compr.comentario.

    FOR FIRST cond-pagto FIELD(cod-cond-pag descricao)
       WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK: END.
    assign fi-cond-pagto = if avail cond-pagto then cond-pagto.descricao else "".

    FOR FIRST moeda FIELD(mo-codigo descricao)
        WHERE moeda.mo-codigo = 0 NO-LOCK: END.
    IF AVAIL moeda THEN ASSIGN c-moeda = moeda.descricao.

    FOR FIRST transporte FIELD(cod-trans nome-abrev)
        WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK: END.
    IF AVAIL transporte THEN assign c-transporte = transporte.nome-abrev.

    FOR FIRST usuar-mater FIELD(cod-usuar nome-usuar)
         WHERE usuar-mater.cod-usuar = pedido-compr.responsavel
         NO-LOCK: END.
    IF AVAIL usuar-mater THEN
       ASSIGN fi-desc-resp = usuar-mater.nome-usuar.

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.

    FOR FIRST estabelec FIELD(cod-estabel nome)
         WHERE estabelec.cod-estabel = pedido-compr.cod-estabel
         NO-LOCK: END.
    IF AVAIL estabelec THEN 
       ASSIGN c-desc-estab  = estabelec.nome
              c-cod-estabel-ent = estabelec.cod-estabel.

    FOR FIRST mguni.empresa FIELD(ep-codigo nome)
         WHERE empresa.ep-codigo = i-empresa NO-LOCK: END.
    IF AVAIL mguni.empresa THEN
       ASSIGN c-desc-empresa = empresa.nome.

    IF CAN-FIND(FIRST alt-ped WHERE
                      alt-ped.num-pedido = pedido-compr.num-pedido) THEN
       ASSIGN l-alt = YES.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '<html>' +
    '<head>' +
    '<style>' +
    '    BODY ~{ ' +
    '      FONT-SIZE: small; FONT-FAMILY: Times; BACKGROUND-COLOR: #cccccc ' +
    '    ~}' +
    '    .campo ~{ ' +
    '        BACKGROUND: black ' +
    '    } ' +
    '    .destaq ~{ ' +
    '        BACKGROUND: #cccccc ' +
    '    } ' +
    '    .linhaBrowse ~{ ' +
    '        FONT-SIZE: 9pt; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif ' +
    '    } ' +
    '    .linhaForm ~{ ' +
    '        FONT-SIZE: 9pt; LINE-HEIGHT: normal;; COLOR:black; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhaVoltar ~{ ' +
    '        FONT-SIZE: 9pt; LINE-HEIGHT: bold;; COLOR:Blue; FONT-STYLE: normal; text-decoration: none; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhatotal ~{ ' +
    '        FONT-SIZE: 10pt; LINE-HEIGHT: normal;; COLOR:red; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .fill-in ~{ ' +
    '     font-family:Tahoma, Arial;font-size:small;font-weight:bold;color:black;background:white; ' +
    '    } ' +
    '    .total ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:red;background:#cecece; ' +
    '    } ' +
    '    .tableForm ~{ ' +
    '        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
    '    } ' +
    '    .tableFormVoltar ~{ ' +
    '        BORDER-RIGHT: 0px inset; BORDER-TOP: 0px inset; BORDER-LEFT: 0px inset; BORDER-BOTTOM: 0px inset;width:90%  ' +
    '    } ' +
    '    .tableForm2 ~{ ' +
    '        BORDER-width: 0px inset;padding:0;  ' +
    '    } ' +
    '    .barraTitulo ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 9pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #AF1321; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTituloBrowse ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 9pt; COLOR: #ffffff; FONT-FAMILY: Arial; BACKGROUND-COLOR: #808080; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .selectedFolder ~{ ' +
    '        BACKGROUND-COLOR: white ' +
    '    } ' +
    '    .unselectedFolder ~{ ' +
    '        BACKGROUND-COLOR: #dcdcdc ' +
    '    } ' +
    '    .barraTotal ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: right; vertical-alignment: middle ' +
    '    } ' +
    '    .button ~{ ' +
    '    font-family:Verdana, Arial;font-size:small;font-weight:bold;color:white;background:#337AFF;cursor:hand;width:100 ' +
    '    } ' +
    '    .linhaBrowsepar ~{ ' +
    '        FONT-SIZE: 9pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#d2eef4 ' +
    '        } ' +
    '    .linhaBrowseimpar ~{ ' +
    '        FONT-SIZE: 9pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#ffffff ' +
    '        } ' +
    '    .columnLabel ~{ ' +
    '        FONT-SIZE: 9pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#107f80 ' +
    '        } ' +
    '    .columnLabelSelected ~{ ' +
    '        FONT-SIZE: 9pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#20b0b0 ' +
    '        } ' +
    '    .linkOrdena ~{ ' +
    '        COLOR:white;text-decoration:none;  ' +
    '        } ' +
    '    .aBrowser ~{ ' +
    '       color:red;font-family:Arial;font-size:9pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowser:hover ~{ ' +
    '       color:red;font-family:Arial;font-size:9pt;font-weight:normal;text-decoration:underline ;  ' +
    '      }  ' +
    '   .aBrowserAcom ~{ ' +
    '      color:blue;font-family:Arial;font-size:9pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowserAcom:hover ~{ ' +
    '       color:blue;font-family:Arial;font-size:9pt;font-weight:normal;text-decoration:underline;  ' +
    '       } ' +
    '</style>'.

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.

    if can-find(funcao where
          funcao.cd-funcao = "Integra_AED_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor =  trim(mla-param-aprov.servidor-asp) + "/mla205.asp ".

    if can-find(funcao where
          funcao.cd-funcao = "Integra_MLA_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor = trim(mla-param-aprov.servidor-asp) .

    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '   <meta http-equiv="Cache-Control" content="No-Cache"> ' +
    '   <meta http-equiv="Pragma"        content="No-Cache"> ' +
    '   <meta http-equiv="Expires"       content="0"> ' +
    ' </head> ' +
    ' <body> ' +
    ' <form method="GET" action="' + c-servidor + '">' +
    ' <input class="fill-in" type="hidden" name="hid_param"> ' +
    ' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_chave" value="' + REPLACE(c-chave," ","**") + '">' +
    ' <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +

    ' <input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_estabel" value="' + c-cod-estabel + '"> ' +

    ' <a name="dados"></a> ' +
    ' <div align="center"><center> ' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    '    <tr> ' +
    '       <td class="barratitulo"> <fieldset> <b>' + c-desc-documento + '</fieldset> <b/> </td> ' +
    '    </tr> ' +
    ' </div> '.
/*     '     <td class="linhaForm" align="center"><center> ' +                                                                                               */
/*     '      <fieldset> ' +                                                                                                                                 */
/*     '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +                                                            */
/*     '          <tr><td height="5"></td></tr> ' +                                                                                                          */
/*     '          <tr> ' +                                                                                                                                   */
/*     '            <th align="right" class="linhaForm" nowrap>Pedido:</th> ' +                                                                              */
/*     '            <td class="linhaForm" align="right" nowrap> ' +                                                                                           */
/*     '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_pedido" value="' + STRING(pedido-compr.num-pedido) + '" readonly> ' + */
/*     '            </td> ' +                                                                                                                                */
/*     '          </tr> ' +                                                                                                                                  */
/*     '         <tr><td height="5"></td></tr> ' +                                                                                                           */
/*     '        </table> ' +                                                                                                                                 */
/*     '      </fieldset> ' +                                                                                                                                */
/*     '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +                                                            */
/*     '          <tr> ' +                                                                                                                                   */
/*     '            <th align="center" class="linhaForm" nowrap>Dados</th> ' +                                                                               */
/*     '            <th align="center" class="linhaForm" nowrap><a href="#parcelas" class="aBrowser"> Parcelas</a></th> '.                                   */

    IF l-alt THEN
       ASSIGN tt-html.html-doc = tt-html.html-doc +     ' <div align="center"><center> ' +

    '        <th align="center" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera‡äes</a></th>' .


    ASSIGN tt-html.html-doc = tt-html.html-doc + ' <div align="center"> ' +
    ' <center> ' +
    ' <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    ' <tr> ' +
    ' <td class="barratitulo">' +
    ' <fieldset> ' + 
    ' <b>' +
    'Detalhes do Pedido' + 
    ' <b/>  '  + 
    '</fieldset> ' +
    ' </td> ' +
    ' </tr> ' +
    ' </table> ' +
    ' </center> ' +
    ' </div> ' +
    ' </td> ' +
    ' <div align="Center"> ' +
    ' <center> ' +
    ' <table class="tableForm" align="center" width="100%"> ' + '<td>' + 
    '    <tr> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Pedido <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Estab <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Emitente <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Razao Social <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Condicao de Pagamento <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Vlr. Total do Pedido <b/> </td>' +
    '     <td align="center"  class="ColumnLabel" > <b> Usuario Responsavel <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b>Usuario <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Aprovador <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Situacao <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Geracao <b/> </td> ' +
    '    </tr> ' +
    '  </td> '.

    RUN pi-valores.

 
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '    <tr> ' +
    '     <td class ="linhabrowsepar" >' +
    STRING(pedido-compr.num-pedido) +
    '     </a></td> ' +
    '     <td class ="linhabrowsepar" >'  +
    c-cod-estabel-ent  +
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(pedido-compr.cod-emitente) +
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(c-nome-abrev) +
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(fi-cond-pagto) +
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(trim(STRING(de-1-total,">>>>>,>>>,>>9.99999"))) + 
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(pedido-compr.responsavel) + 
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(pedido-compr.responsavel) + 
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(p-cod-aprovador) + 
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(c-situacao) + 
    '     </td> ' +
    '     <td class ="linhabrowsepar">'  +
    STRING(pedido-compr.data-pedido) + 
    '     </td> ' +
    '    </tr> ' +
    '   </table> ' +
    ' </center> ' +
    '</div>' +
    '<br>'.


    
/*     ASSIGN tt-html.html-doc = tt-html.html-doc +                                                                                                                   */
/*     '          </tr> ' +                                                                                                                                           */
/*     '        </table> ' +                                                                                                                                          */
/*     '      <fieldset> ' +                                                                                                                                          */
/*     '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%"> ' +                                                                      */
/*     '        <tr><td height="5"></td></tr> ' +                                                                                                                     */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Empresa:</th> ' +                                                                                         */
/*     '         <td class="linhaForm" align="right" nowrap colspan=3 > ' +                                                                                            */
/*     '            <input class="fill-in" type="text" size="15" name="w_cod_empresa" value="' + STRING(i-empresa) + '" readonly> ' +                                 */
/*     '            <input class="fill-in" type="text" size="57" name="w_nom_empresa" value="' + c-desc-empresa + '" readonly> ' +                                    */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Estabelecimento:</th> ' +                                                                                 */
/*     '         <td class="linhaForm" align="right" nowrap colspan=3 > ' +                                                                                            */
/*     '            <input class="fill-in" type="text" size="5" name="w_cod_estab" value="' + STRING(c-cod-estabel-ent) + '" readonly> ' +                            */
/*     '            <input class="fill-in" type="text" size="67" name="w_nome_estab" value="' + c-desc-estab + '" readonly> ' +                                       */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Fornecedor:</th> ' +                                                                                      */
/*     '         <td class="linhaForm" align="right" nowrap colspan=3 > ' +                                                                                            */
/*     '            <input class="fill-in" type="text" size="15" maxlength="20" name="w_cod_emitente" value="' + STRING(pedido-compr.cod-emitente) + '" readonly> ' + */
/*     '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome_abrev" value="' + c-nome-abrev + '" readonly> ' +                        */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Razao Social:</th> ' +                                                                                    */
/*     '         <td class="linhaForm" align="right" nowrap colspan=3 > ' +                                                                                            */
/*     '            <input class="fill-in" type="text" size="76" name="w_razao_social" value="' + c-razao-social + '" readonly> ' +                                   */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Natureza:</th> ' +                                                                                        */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            <input class="fill-in" type="text" size="16" maxlength="16" name="w_natureza" value="' + c-natureza + '" readonly> ' +                            */
/*     '         </td> ' +                                                                                                                                            */
/*     '         <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +                                                                                           */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            &nbsp; ' +                                                                                                                                        */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Data Pedido:</th> ' +                                                                                     */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            <input class="fill-in" type="text" size="12" name="w_data_pedido" value="' + STRING(pedido-compr.data-pedido,"99/99/9999") + '" readonly> ' +     */
/*     '         </td> ' +                                                                                                                                            */
/*     '         <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +                                                                                           */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            &nbsp;' +                                                                                                                                         */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> ' +                                                                                                                                             */
/*     '        <tr> ' +                                                                                                                                              */
/*     '         <th align="right" class="linhaForm" nowrap>Frete:</th> ' +                                                                                           */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            <input class="fill-in" type="text" size="15" maxlength="15" name="w_frete" value="' + c-frete + '" readonly> ' +                                  */
/*     '         </td> ' +                                                                                                                                            */
/*     '         <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +                                                                                           */
/*     '         <td class="linhaForm" align="right" nowrap> ' +                                                                                                       */
/*     '            &nbsp; ' +                                                                                                                                        */
/*     '         </td> ' +                                                                                                                                            */
/*     '        </tr> '.                                                                                                                                              */

/*     CREATE tt-html.                                                                                                                                             */
/*     ASSIGN i-seq-html       = i-seq-html + 1                                                                                                                    */
/*            tt-html.seq-html = i-seq-html.                                                                                                                       */
/*                                                                                                                                                                 */
/*     ASSIGN tt-html.html-doc = tt-html.html-doc +                                                                                                                */
/*     '        <tr> ' +                                                                                                                                           */
/*     '         <th align="right" class="linhaForm" nowrap>Respons vel:</th> ' +                                                                                  */
/*     '         <td class="linhaForm" align="right" nowrap colspan="3"> ' +                                                                                        */
/*     '            <input class="fill-in" type="text" size="15" maxlength="15" name="w_resp" value="' + pedido-compr.responsavel + '" readonly> ' +               */
/*     '            <input class="fill-in" type="text" size="57" maxlength="59" name="w_desc_resp" value="' + fi-desc-resp + '" readonly> ' +                      */
/*     '         </td> ' +                                                                                                                                         */
/*     '        </tr> ' +                                                                                                                                          */
/*     '        <tr> ' +                                                                                                                                           */
/*     '         <th align="right" class="linhaForm" valign="top" nowrap>Cond. Pagamento:</th> ' +                                                                 */
/*     '         <td class="linhaForm" align="right" nowrap colspan="3"> ' +                                                                                        */
/*     '            <input class="fill-in" type="text" size="15" maxlength="5" name="w_cond_pagto" value="' + STRING(pedido-compr.cod-cond-pag) + '" readonly> ' + */
/*     '            <input class="fill-in" type="text" size="57" maxlength="50" name="w_desc_cond_pagto" value="' + fi-cond-pagto + '" readonly> '.                */
/*                                                                                                                                                                 */
/*     {laphtml/mlahtmlcondespecif.i}                                                                                                                              */
/*                                                                                                                                                                 */
/*     ASSIGN tt-html.html-doc = tt-html.html-doc +                                                                                                                */
/*     '         </td> ' +                                                                                                                                         */
/*     '        </tr> ' +                                                                                                                                          */
/*     '        <tr> ' +                                                                                                                                           */
/*     '         <th align="right" class="linhaForm" nowrap>Transportador:</th> ' +                                                                                */
/*     '         <td class="linhaForm" align="right" nowrap colspan="3"> ' +                                                                                        */
/*     '            <input class="fill-in" type="text" size="15" maxlength="10" name="w_transp" value="' + STRING(pedido-compr.cod-trans) + '" readonly> ' +       */
/*     '            <input class="fill-in" type="text" size="57" maxlength="10" name="w_transp" value="' + c-transporte + '" readonly> ' +                         */
/*     '         </td> ' +                                                                                                                                         */
/*     '        </tr> ' +                                                                                                                                          */
/*     '        <tr> ' +                                                                                                                                           */
/*     '         <th align="right" class="linhaForm" nowrap>Via Transporte:</th> ' +                                                                               */
/*     '         <td class="linhaForm" align="right" nowrap colspan="3"> ' +                                                                                        */
/*     '            <input class="fill-in" type="text" size="15" maxlength="10" name="w_transp" value="' + c-via-trans + '" readonly> ' +                          */
/*     '         </td> ' +                                                                                                                                         */
/*     '        </tr> ' +                                                                                                                                          */
/*     '        <tr> ' +                                                                                                                                           */
/*     '         <th align="right" valign="top" class="linhaForm" nowrap>Comentarios:</th> ' +                                                                     */
/*     '         <td class="linhaForm" align="right" nowrap colspan="3"> ' +                                                                                        */
/*     '           <textarea class="fill-in" rows="3" cols="78" name="w_narrativa">' + c-narrativa +                                                               */
/*     '</textarea>' +                                                                                                                                             */
/*     '         </td> ' +                                                                                                                                         */
/*     '        </tr> ' +                                                                                                                                          */
/*     '        <tr><td height="5"></td></tr> ' +                                                                                                                  */
    
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
    
    '<div align="center"> ' +
    '<center> ' +
    '<table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="TableForm">' +
    '         <td colspan=2> ' +
    '        <tr> ' +     
    '<td class="barraTitulo"><fieldset> <b> Detalhamento dos Itens <b/> </fieldset> </td> </table> </center> </div>' +
    '<div align="center"> ' +
    '<center> ' +   
    ' <table class="tableForm" align="center" width="100%"> ' +
    ' <td>  ' +
    '    <tr> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Ordem <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Item <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Descricao <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Fabricante <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> UM <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Qtde <b/> </td>' +
    '     <td align="center"  class="ColumnLabel" > <b> Preco <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> $ Total <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Entrega <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Situacao <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Emissao <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Dias Estoque <b/> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> Cta.Ctbl </b> </td> ' +
    '     <td align="center"  class="ColumnLabel" > <b> C.Custo <b/> </td> ' +
    '    </tr> ' +
    '   </td> '.
    {utp/ut-liter.i Parcelada}
    assign c-literal = trim(return-value).
    {utp/ut-liter.i Incluso}
    assign c-incluso = trim(return-value).
    {utp/ut-liter.i NÆo}
    assign c-naoincluso = trim(return-value) + " " + c-incluso.
    {utp/ut-liter.i Industrializado}
    assign c-industrial = trim(return-value).
    {utp/ut-liter.i Consumo}
    assign c-consumo = trim(return-value)
           de-total     = 0.

    /* Ordens do Pedido */
    FOR EACH  ordem-compra 
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
        AND (ordem-compra.situacao   = 2 OR
             ordem-compra.situacao   = 6) no-lock:
             
         run pi-estatistica(input ordem-compra.it-codigo,
                            output days_boh).    

        assign c-data-entrega     = "?"
               de-quant-saldo     = 0.

        for each  prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
              AND prazo-compra.situacao    <> 4 /*eliminada*/
            no-lock:
            if can-find(funcao where
                    funcao.cd-funcao = "Pedido_Total_MLA" and
                    funcao.ativo     = yes) THEN
                assign de-quant-saldo     = de-quant-saldo + prazo-compra.quantidade.
            ELSE
                assign de-quant-saldo     = de-quant-saldo + prazo-compra.qtd-sal-forn. 
                /* prazo-compra.quant-saldo - alterado para buscar o saldo do fornecedor, pois caso exista fator de conversao esta ja esta convertida - Favretto */
        end.

        FIND FIRST prazo-compra 
             WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
             NO-LOCK NO-ERROR.
        IF AVAIL prazo-compra THEN 
            ASSIGN dt-entreg = STRING(prazo-compra.data-entrega).

        FOR FIRST mla-lotacao FIELD(ep-codigo cod-lotacao desc-lotacao)
             WHERE mla-lotacao.ep-codigo   = i-empresa
             AND   mla-lotacao.cod-lotacao = ordem-compra.sc-codigo /* SUBSTRING(ordem-compra.conta -contabil,9,8) */
             NO-LOCK: END.
        IF AVAIL mla-lotacao THEN
           ASSIGN centro-custo = mla-lotacao.desc-lotacao.
        ELSE
           ASSIGN centro-custo = "".

        IF centro-custo = "" THEN DO:
           /* Realiza a busca do centro de custo */
           {laphtml/mlaUnifBuscaCC.i i-empresa ordem-compra.sc-codigo today}
           find first tt_log_erro no-lock no-error.
           if avail tt_log_erro then do:
               ASSIGN centro-custo = "".
           end.
           else
               ASSIGN centro-custo = v_titulo_ccusto.           
           
           /*
           FOR FIRST sub-conta FIELD(sc-codigo descricao)
                WHERE sub-conta.sc-codigo = ordem-compra.sc-codigo /* SUBSTRING(ordem-compra.conta -contabil,9,8) */
                NO-LOCK: END.
           IF AVAIL sub-conta THEN
              ASSIGN centro-custo = sub-conta.descricao.
           ELSE
              ASSIGN centro-custo = "". */
        END.

        FOR FIRST item 
             WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.
        ASSIGN c-desc-item = item.desc-item.
        
        find first ext-item where ext-item.it-codigo = item.it-codigo no-error.
        
        if avail ext-item then do:
        assign c-fabricante = ext-item.cod-fabricante.
        end.

        FIND FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
            AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
            AND   cotacao-item.data-cotacao = ordem-compra.data-cotacao
            AND   cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
        IF AVAIL cotacao-item THEN ASSIGN c-un-cot = cotacao-item.un. ELSE ASSIGN c-un-cot = "".

        assign  c-frete-b      = if ordem-compra.frete          then c-incluso else c-naoincluso
                c-ipi          = if ordem-compra.codigo-ipi     then c-incluso else c-naoincluso.

        IF AVAILABLE cotacao-item THEN
            ASSIGN da-cotacao = cotacao-item.data-cotacao.
        ELSE
            ASSIGN da-cotacao = ordem-compra.data-cotacao.

        /* Calculo do Valor da Cota‡Æo */
        if  ordem-compra.mo-codigo = 0 then  
            assign de-cotacao = 1.
        else do:            
            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                              input 0,
                              input 1,
                              input da-cotacao,
                              output de-cotacao).
            if  de-cotacao = ? then
                assign de-cotacao = 1.
        end.
        
        
        ASSIGN d-pre-unit-for = (ordem-compra.pre-unit-for * de-cotacao)
               d-preco-unit   = (ordem-compra.pre-unit-for * de-quant-saldo * de-cotacao)
               de-total       = de-total + d-preco-unit.

        ASSIGN c-icm          = if ordem-compra.codigo-icm = 1 then c-consumo else c-industrial
               c-situacao-b   = {ininc/i02in274.i 04 ordem-compra.situacao}.

        ASSIGN i-cont = i-cont + 1.

        IF (i-cont MOD 2) = 0 THEN
           ASSIGN c-class = ' class="linhaBrowseImpar" '.       
        ELSE 
           ASSIGN c-class = ' class="linhaBrowsepar" ' .

        CREATE tt-html.
        ASSIGN i-seq-html       = i-seq-html + 1
               tt-html.seq-html = i-seq-html.

        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '    <td> ' +
        '    <tr> ' +
        '     <td aling ="right" ' + c-class + '> '  + '<a href="#' + STRING(ordem-compra.numero-ordem) + '"' +   '>' + STRING(ordem-compra.numero-ordem) +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + STRING(ordem-compra.it-codigo)  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> ' +
        c-desc-item +
        '     </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + STRING(c-fabricante)  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + STRING(item.un)  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(de-quant-saldo,">>>,>>>,>>9.999"))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(d-pre-unit-for,">>>>>,>>>,>>9.999"))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(d-preco-unit,">>>>>,>>>,>>9.999"))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(dt-entreg))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(c-situacao-b))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(ordem-compra.data-emissao))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(days_boh))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(ordem-compra.ct-codigo))  +
        '    </td> ' +
        '     <td  aling ="right"' + c-class + '> '  + trim(STRING(ordem-compra.sc-codigo))  +
        '    </td> ' +
        ' </tr> '.
 

    END. /* For each ordem-compra */

    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td align=right colspan=15 class="barratotal">Valor Total do Pedido: <b>' + trim(string(de-total,">>>>>,>>>,>>9.99999")) + '</b></td></tr>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '         </TABLE> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr><td height="5"></td></tr> ' +
    '      </table>   ' +
    '     </fieldset> ' +
    '   </center> ' +
    ' </div>'.
 

FIND first mla-doc-pend-aprov 
 WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
   AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
   AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
   AND mla-doc-pend-aprov.chave-doc    = c-chave  
   AND mla-doc-pend-aprov.ind-situacao = 1
   AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pendˆncia atual */
if avail mla-doc-pend-aprov then  do:
   {laphtml/mlahtmlrodape.i}
END.

if not can-find(funcao where
               funcao.cd-funcao = "html_red_MLA" and
               funcao.ativo     = yes) then do:

    ASSIGN tt-html.html-doc = tt-html.html-doc +
        '   </div> ' +
        '<br><br><br><br><br><br><br><br><br><br><br> ' +
        '<br><br><br><br><br><br><br><br><br><br><br> '.
    
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        ' <a name="parcelas"></a> ' +
        ' <div align="center"><center> ' +
        '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
        '     <tr> ' +
        '       <td class="barratitulo">Pedido Compra (Total)</td> ' +
        '     </tr> ' +
        '    <tr> ' +
        '     <td class="linhaForm" align="center"><center> ' +
        '      <fieldset> ' +
        '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
        '          <tr><td height="5"></td></tr> ' +
        '          <tr> ' +
        '            <th align="right" class="linhaForm" nowrap>Pedido:</th> ' +
        '            <td class="linhaForm" align="right" nowrap> ' +
        '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_pedido" value="' + STRING(pedido-compr.num-pedido) + '" readonly> ' +
        '            </td> ' +
        '          </tr> ' +
        '         <tr><td height="5"></td></tr> ' +
        '        </table> ' +
        '      </fieldset> ' +
        '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
        '          <tr> ' +
        '            <th align="center" class="linhaForm" nowrap><a href="#dados" class="aBrowser"> Dados</a></th> ' +
        '            <th align="center" class="linhaForm" nowrap>Parcelas</th> ' .
    
        IF l-alt THEN
           ASSIGN tt-html.html-doc = tt-html.html-doc +
        '        <th align="center" class="linhaForm" nowrap><a href="#alt" class="aBrowser">Altera»„es</a></th>' .
        
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '          </tr> ' +
        '        </table> ' +
        '  </td> ' +
        ' </tr> ' +
        ' </table>   ' +
        ' <br> ' +
        '    <table class="tableForm" align="center"> ' +
        '    <tr> ' +
        '     <td align="center"  class="ColumnLabel" >Ordem</td> ' +
        '     <td align="center"  class="ColumnLabel" >Parc</td> ' +
        '     <td align="center"  class="ColumnLabel" >Data Entrega</td> ' +
        '     <td align="center"  class="ColumnLabel" >Un</td> ' +
        '     <td align="center"  class="ColumnLabel" >Quantidade</td> ' +
        '     <td align="center"  class="ColumnLabel" >Qtde Saldo</td> ' +
        '     <td align="center"  class="ColumnLabel" >Qtde Receb</td> ' +
        '     <td align="center"  class="ColumnLabel" >Qtde Devol</td> ' +
        '     <td align="center"  class="ColumnLabel" >Situa»’o</td> ' +
        '    </tr> '.
    
        assign c-lista-situacao = {ininc/i02in274.i 03}.
    
        ASSIGN i-cont = 0.
    
        /* Parcelas da Ordem de Compra */
        for each  ordem-compra 
            where ordem-compra.num-pedido = pedido-compr.num-pedido
            and   ordem-compra.situacao   <> 4 /*eliminada*/
            no-lock:
            FOR EACH prazo-compra NO-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                BY prazo-compra.parcela
                BY prazo-compra.data-entrega:
                ASSIGN c-sit   = entry(prazo-compra.situacao, c-lista-situacao)
                       i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                   ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                   ASSIGN c-class = ' class="linhaBrowsepar" ' .
                CREATE tt-html.
                ASSIGN i-seq-html       = i-seq-html + 1
                       tt-html.seq-html = i-seq-html.
    
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr> ' +
                '     <td ' + c-class + '> ' +
                '       ' + STRING(ordem-compra.numero-ordem) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + STRING(prazo-compra.parcela) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + STRING(prazo-compra.data-entrega,"99/99/9999") +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + STRING(prazo-compra.un) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + trim(STRING(prazo-compra.quantidade,">>>,>>>,>>9.9999")) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + trim(STRING(prazo-compra.quant-saldo,">>>,>>>,>>9.9999")) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + trim(STRING(prazo-compra.quant-receb,">>>,>>>,>>9.9999")) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + trim(STRING(prazo-compra.quant-rejeit,">>>,>>>,>>9.9999")) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + c-sit +
                '     </td> ' +
                '    </tr> '.
            END. /* for each prazo-compra */
        END. /* for each ordem-compra */
    
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        ' </table>  ' +
        '</div> ' +
        '<br><br><br><br><br><br><br><br><br><br><br> ' +
        '<br><br><br><br><br><br><br><br><br><br><br> '.
        
        IF l-alt THEN DO:
    
            /* Altera»„es */
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="alt"></a> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Pedido Compra (Total)</td> ' +
            '     </tr> ' +
            '    <tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '            <th align="right" class="linhaForm" nowrap>Pedido:</th> ' +
            '            <td class="linhaForm" align="right" nowrap> ' +
            '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_pedido" value="' + STRING(pedido-compr.num-pedido) + '" readonly> ' +
            '            </td> ' +
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
            '          <tr> ' +
            '            <th align="center" class="linhaForm" nowrap><a href="#dados" class="aBrowser"> Dados</a></th> ' +
            '            <th align="center" class="linhaForm" nowrap><a href="#parcelas" class="aBrowser"> Parcelas</a></th> ' +
            '            <th align="center" class="linhaForm" nowrap>Altera»„es</th>' .
            
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            '          </tr> ' +
            '        </table> ' +
            '  </td> ' +
            ' </tr> ' +
            ' </table>   ' +
            ' <br> ' +
            '    <table class="tableForm" align="center"> ' +
            '    <tr> ' +
                '     <td align="center"  class="ColumnLabel" >Data Altera»’o</td>' +
                '     <td align="center"  class="ColumnLabel" >Hora</td>' +
                '     <td align="center"  class="ColumnLabel" >Usuÿrio</td>' +
                '     <td align="center"  class="ColumnLabel" >Ordem Compra</td>' +
                '     <td align="center"  class="ColumnLabel" >Parcela</td>' +
                '     <td align="center"  class="ColumnLabel" >Quantidade</td>' +
                '     <td align="center"  class="ColumnLabel" >Nova Qtde</td>' +
                '     <td align="center"  class="ColumnLabel" >Pre»o Unitÿrio</td>' +
                '     <td align="center"  class="ColumnLabel" >Novo Pre»o</td>' +
                '     <td align="center"  class="ColumnLabel" >Dt Entrega</td>' +
                '     <td align="center"  class="ColumnLabel" >Nova Dt Ent</td>' +
                '     <td align="center"  class="ColumnLabel" >Cond Pagto</td>' +
                '     <td align="center"  class="ColumnLabel" >Nova Cond Pagto</td>' +
                '     <td align="center"  class="ColumnLabel" >Observa»’o</td>' +
                '     <td align="center"  class="ColumnLabel" >Comentÿrios</td>' +
            '    </tr> '.
    
            
            ASSIGN i-cont = 0.
    
            FOR EACH  alt-ped
                WHERE alt-ped.num-pedido = pedido-compr.num-pedido AND
                      alt-ped.data       = TODAY NO-LOCK: 
    
                ASSIGN c-quantidade      = STRING(alt-ped.quantidade,">>>>,>>9.9999")
                       c-qtd-sal-forn    = ""
                       c-dt-entrega      = STRING(alt-ped.data-entrega,"99/99/9999")
                       c-dt-entrega-2    = ""
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
                            ASSIGN c-dt-entrega-2 = IF alt-ped.char-1 <> "" THEN
                                                         ENTRY(3,alt-ped.char-1,"|")
                                                    ELSE
                                                         STRING(prazo-compra.data-entrega,"99/99/9999").
                    END.
                END.
    
                IF alt-ped.numero-ordem <> 0 THEN DO:
    
                    FOR FIRST ordem-compra FIELDS( comentarios pre-unit-for cod-cond-pag numero-ordem ) WHERE
                              ordem-compra.numero-ordem = alt-ped.numero-ordem NO-LOCK: END.
    
                    IF AVAIL ordem-compra     AND
                       NOT alt-ped.observacao BEGINS "#" THEN DO:
    
                        &IF  "{&bf_dis_versao_ems}" < "2.04" &THEN
                          ASSIGN c-comentarios = ordem-compra.comentarios.
                        &ENDIF
    
                        /* Novo Pre»o */
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
    
                IF c-dt-entrega = ? THEN
                    ASSIGN c-dt-entrega = "".
    
                IF c-dt-entrega-2 = ? THEN
                    ASSIGN c-dt-entrega-2 = "".
    
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
    
                ASSIGN i-cont = i-cont + 1.
    
                &IF  "{&bf_dis_versao_ems}" >= "2.04" &THEN
    
                    IF c-comentarios = "" THEN DO:
                        IF c-pre-unit-for <> "" THEN DO:
                            {utp/ut-liter.i Alterado(s):_Pre»o_Unitÿrio}
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
                        IF c-dt-entrega <> "" THEN DO:
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
                                {utp/ut-liter.i Alterado(s):_Condi»’o_Pagamento}
                                ASSIGN c-comentarios = TRIM(RETURN-VALUE).
                            END.
                            ELSE DO:
                                {utp/ut-liter.i Condi»’o_Pagamento}
                                ASSIGN c-comentarios = c-comentarios + ", " + TRIM(RETURN-VALUE).
                            END.
                        END.
                    END.
                &ENDIF
    
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
                '      ' + c-dt-entrega +
                '     </td>' +
                '     <td ' + c-class + ' >' +
                '      ' + c-dt-entrega-2 +
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
                    ' </table>  ' +
                    '</div> ' +
                    '<br><br><br><br><br><br><br><br><br><br><br> ' +
                    '<br><br><br><br><br><br><br><br><br><br><br> '.
        END.
        
    
    
        /*
        ** Detalhe da Ordem
        */
    
        {utp/ut-liter.i Parcelada}
        assign c-literal = trim(return-value).
    
        {utp/ut-liter.i Incluso}
        assign c-incluso = trim(return-value).
    
        {utp/ut-liter.i N’o}
        assign c-naoincluso = trim(return-value) + " " + c-incluso.
    
        {utp/ut-liter.i Industrializado}
        assign c-industrial = trim(return-value).
    
        {utp/ut-liter.i Consumo}
        assign c-consumo = trim(return-value).
    
        for each  ordem-compra 
            where ordem-compra.num-pedido = pedido-compr.num-pedido
            and   ordem-compra.situacao   <> 4 /*eliminada*/
            no-lock:
            assign de-quant-saldo     = 0.
    
            for each  prazo-compra 
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
              AND prazo-compra.situacao    <> 4 /*eliminada*/
                no-lock:
                if can-find(funcao where
                        funcao.cd-funcao = "Pedido_Total_MLA" and
                        funcao.ativo     = yes) THEN
                    assign de-quant-saldo     = de-quant-saldo + prazo-compra.quantidade.
                ELSE
                    assign de-quant-saldo     = de-quant-saldo + prazo-compra.qtd-sal-forn 
                    /* prazo-compra.quant-saldo - alterado para buscar o saldo do fornecedor, pois caso exista fator de conversao esta ja esta convertida - Favretto */.
            end.
    
            /* Calculo do Valor da Cota»’o */
            if  ordem-compra.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                  input 0,
                                  input 1,
                                  input da-cotacao,
                                  output de-cotacao).
                if  de-cotacao = ? then
                    assign de-cotacao = 1.
            end.
    
            assign  d-pre-unit-for = ordem-compra.pre-unit-for * de-cotacao  
                    d-preco-unit   = ordem-compra.preco-fornec * de-cotacao.
    
            FIND FIRST cotacao-item
                WHERE cotacao-item.cod-emitente = ordem-compra.cod-emitente
                AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
                AND   cotacao-item.data-cotacao = ordem-compra.data-cotacao
                AND   cotacao-item.numero-ordem = ordem-compra.numero-ordem
                AND   cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
            IF AVAIL cotacao-item THEN 
               ASSIGN c-un-cot = cotacao-item.un. 
            ELSE ASSIGN c-un-cot = "".
    
            FOR FIRST item FIELD(it-codigo desc-item un)
                 WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.
            ASSIGN c-desc-item = item.desc-item
                   c-frete-b    = if ordem-compra.frete          then c-incluso else c-naoincluso
                   c-ipi        = if ordem-compra.codigo-ipi     then c-incluso else c-naoincluso
                   c-icm        = if ordem-compra.codigo-icm = 1 then c-consumo else c-industrial.
                   c-situacao-b = {ininc/i02in274.i 04 ordem-compra.situacao}.
            
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
            
            /*
            FOR FIRST conta -contab FIELD(ep-codigo conta -contabil titulo)
                 WHERE  conta -contab.ep-codigo      = i-empresa 
                 AND   conta -contab.conta -contabil = ordem-compra.conta -contabil
                 NO-LOCK: END.
            IF AVAILABLE conta -contab THEN
               ASSIGN c-desc-conta = conta -contab.titulo.
            ELSE
               ASSIGN c-desc-conta = "". */
    
            IF ordem-compra.nr-requisicao <> 0 THEN DO:
                FOR FIRST it-requisicao FIELD(nr-requisicao sequencia it-codigo narrativa)
                     WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                     AND   it-requisicao.sequencia     = ordem-compra.sequencia
                     AND   it-requisicao.it-codigo     = ordem-compra.it-codigo
                     NO-LOCK: END.
                IF AVAIL it-requisicao THEN
                   ASSIGN req-narrativa = it-requisicao.narrativa.
            END.
    
            FOR FIRST usuar-mater FIELD(cod-usuario nome-usuar)
                 WHERE usuar-mater.cod-usuar = ordem-compra.requisitante
                 NO-LOCK: END.
            IF AVAIL usuar-mater THEN
               ASSIGN c-desc-requis = usuar-mater.nome-usuar.
            ELSE
               ASSIGN c-desc-requis = "".
    
            FOR FIRST tipo-rec-desp FIELD(tp-codigo descricao)
                WHERE tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa
                NO-LOCK: END.
            ASSIGN fi-tp-despesa = if not avail tipo-rec-desp then ""
                                      else tipo-rec-desp.descricao.   
    
    
            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
    
            /******** Unifica‡Æo de conceitos, buscando formatos ********/
            {laphtml/mlaUnifFormatos.i i-empresa today}          
            if c-formato-conta <> "" then
                assign c-ct-codigo = string(ordem-compra.ct-codigo, c-formato-conta).
            else
                assign c-ct-codigo = ordem-compra.ct-codigo.
                
            if c-formato-ccusto <> "" then
                assign c-sc-codigo = string(ordem-compra.sc-codigo, c-formato-ccusto).
            else
                assign c-sc-codigo = ordem-compra.sc-codigo.            
    
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="' + STRING(ordem-compra.numero-ordem) + '"></a> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Detalhe Ordem</td> ' +
            '     </tr> ' +
            '    <tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '            <th align="right" class="linhaForm" nowrap width="45%">Ordem:</th> ' +
            '            <td class="linhaForm" align="right" nowrap> ' +
            '             <input class="fill-in" type="text" size="12" name="w_ordem" value="' + STRING(ordem-compra.numero-ordem) + '" readonly> ' + 
            '            </td> ' +
            '            <td class="linhaForm" align="right" nowrap> ' +
            '             <a href="#cotacao' + STRING(ordem-compra.numero-ordem) + '" class="aBrowser">Detalhes da Cota»’o</a>' +
            '            </td>' +  
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '     <fieldset> ' +
            '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" width="20%" nowrap>Item:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="16" name="w_item" value="' + ordem-compra.it-codigo + '" readonly> ' +
            '            <input class="fill-in" type="text" size="64" name="w_desc_item" value="' + c-desc-item + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" valign="top" nowrap>Narrativa:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <textarea class="fill-in" rows=3 cols=86> ' +
                          ordem-compra.narrativa +
            '            </textarea>' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr><td height="5"></td></tr> ' +
            '      </table>   ' +
            '     </fieldset> ' +
            '     <fieldset> ' +
            '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" width="20%" nowrap>Aprovador:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="16" maxlength="20" name="w_aprovador" value="' + p-cod-aprovador + '" readonly> ' +
            '            <input class="fill-in" type="text" size="64" maxlength="64" name="w_desc_aprovador" value="' + desc-aprovador + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" valign="top" nowrap>Narrativa Solic:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <textarea class="fill-in" rows=3 cols=86> ' +
                          req-narrativa +
            '            </textarea>' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr><td height="5"></td></tr> ' +
            '      </table>   ' +
            '     </fieldset> ' +
            '      <fieldset> ' +
            '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" width="20%" nowrap>Prazo Entrega:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_prazo" value="' + STRING(ordem-compra.prazo-entreg) + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Situa»’o:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_situacao" value="' + c-situacao-b + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Conta:</th> ' +
            '         <td class="linhaForm" align="right" nowrap colspan="4"> ' +
            '            <input class="fill-in" type="text" size="22" name="w_conta" value="' + STRING(c-ct-codigo) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="60" name="w_desc_conta" value="' + c-desc-conta + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Centro Custo:</th> ' +
            '         <td class="linhaForm" align="right" nowrap colspan="4"> ' +
            '            <input class="fill-in" type="text" size="22" name="w_ccusto" value="' + STRING(c-sc-codigo) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="60" name="w_desc_ccusto" value="' + c-desc-ccusto + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +		
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Data Emiss’o:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="12" name="w_dt_emis" value="' + STRING(ordem-compra.data-emissao,"99/99/9999") + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Data Cota»’o:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="12" name="w_dt_preco" value="' + STRING(ordem-compra.data-cotacao,"99/99/9999") + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Tipo Despesa:</th> ' +
            '         <td class="linhaForm" align="right" nowrap colspan="4"> ' +
            '            <input class="fill-in" type="text" size="20" name="w_tp_dep" value="' + STRING(ordem-compra.tp-despesa) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="60" name="w_tp_dep" value="' + STRING(fi-tp-despesa) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Requisitante:</th> ' +
            '         <td class="linhaForm" align="right" nowrap colspan="4"> ' +
            '            <input class="fill-in" type="text" size="20" name="w_requisitante" value="' + STRING(ordem-compra.requisitante) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="60" name="w_requisitante" value="' + STRING(c-desc-requis) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Un Fornec:</th> ' +
            '         <td class="linhaForm" align="right" nowrap colspan="4"> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_un_fornec" value="' + STRING(c-un-cot) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr><td height="5"></td></tr> ' +
            '      </table>   ' +
            '     </fieldset> ' +
            '     <fieldset> ' +
            '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" width="20%" nowrap>Taxa Fin:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_taxa_fin" value="' + trim(STRING(ordem-compra.valor-taxa,">>9.9999")) + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Dias Taxa:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_dias_taxa" value="' + STRING(ordem-compra.nr-dias-taxa) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>% Desc:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_desc" value="' + trim(STRING(ordem-compra.perc-descto,">9.99999")) + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Valor Desconto:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_vl_descto" value="' + trim(STRING(ordem-compra.valor-descto,">>>,>>>,>>9.9999")) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Pre»o L­quido:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_pb" value="' + trim(STRING(d-preco-unit,">>>>>,>>>,>>9.99999")) + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Pre»o Unitÿrio:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_pl" value="' + trim(STRING(d-pre-unit-for,">>>>>,>>>,>>9.99999")) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr> ' +
            '        <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Saldo:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_sld" value="' + trim(STRING(de-quant-saldo,">>>,>>>,>>9.9999")) + '" readonly> ' +
            '         </td> ' +
            '         <th align="right" class="linhaForm" nowrap>Valor Total:</th> ' +
            '         <td class="linhaForm" align="right" nowrap> ' +
            '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_vl_tot" value="' + trim(STRING(d-pre-unit-for * de-quant-saldo,">>>>>,>>>,>>9.99999")) + '" readonly> ' +
            '         </td> ' +
            '        </tr> ' +
            '        <tr><td height="5"></td></tr> ' +
            '      </table>   ' +
            '     </fieldset> ' +
            '   </center> ' +
            '  </td> ' +
            ' </tr> ' +
            ' <tr><td class="linhaForm" align="right"><a href="#dados" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   ' +
            '</div> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '.
    
            ASSIGN tt-html.html-doc = tt-html.html-doc + 
            ' <a name="cotacao' + STRING(ordem-compra.numero-ordem) + '"></a> ' +
            ' <div align="center"><center>' +
            '  <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
            '   <tr>' +
            '    <td class="barratitulo">Cota»’o da Ordem - ' + STRING(ordem-compra.numero-ordem) +  '</td>' +
            '   </tr>' +
            ' </table> ' +
            ' <br>  ' +
            ' <table class="tableForm" align="center">' +
            '    <tr>' +
            '     <td align="center"  class="ColumnLabel" >C½digo</td>' +
            '     <td align="center"  class="ColumnLabel" >Nome Abreviado</td>' +
            '     <td align="center"  class="ColumnLabel" >Data Cota»’o</td>' +
            '     <td align="center"  class="ColumnLabel" >Prazo</td>' +
            '     <td align="center"  class="ColumnLabel" >Un</td>' +
            '     <td align="center"  class="ColumnLabel" >Moeda</td>' +
            '     <td align="center"  class="ColumnLabel" >Pre»o Fornecedor</td>' +
            '     <td align="center"  class="ColumnLabel" >Pre»o Unit Fornec</td>' +
            '     <td align="center"  class="ColumnLabel" >% IPI</td>' +
            '     <td align="center"  class="ColumnLabel" >IPI Inc</td>' +
            '     <td align="center"  class="ColumnLabel" >Contato</td>' +
            '     <td align="center"  class="ColumnLabel" >Cond Pagto</td>' +
            '     <td align="center"  class="ColumnLabel" >Comprador</td>' +
            '     <td align="center"  class="ColumnLabel" >Transp</td>' +
            '     <td align="center"  class="ColumnLabel" >Aprov.</td>' +
            '     <td align="center"  class="ColumnLabel" >Vl Desconto</td>' +
            '     <td align="center"  class="ColumnLabel" >Vlr Frete</td>' +
            '     <td align="center"  class="ColumnLabel" >Enc Fin</td>' +
            '     <td align="center"  class="ColumnLabel" >Taxa Fin</td>' +
            '     <td align="center"  class="ColumnLabel" >Dias Taxa</td>' +
            '     <td align="center"  class="ColumnLabel" >% Desc</td>' +
            '     <td align="center"  class="ColumnLabel" >Quant Ordem</td>' +
            '     <td align="center"  class="ColumnLabel" >I.P.I</td>' +
            '     <td align="center"  class="ColumnLabel" >Pre»o L­quido</td>' +
            '     <td align="center"  class="ColumnLabel" >Pre»o Total Cota»’o</td>' +
            '    </tr>'.
    
            ASSIGN i-cont = 0.
    
    
            /* detalha cota»„es */
    
            FOR EACH  cotacao-item 
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                AND   cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                NO-LOCK:
                FOR FIRST emitente FIELD(cod-emitente nome-abrev)
                     WHERE emitente.cod-emitente = cotacao-item.cod-emitente
                     NO-LOCK: END.
                if  l-preco-bruto = no then do:
                    assign de-valor-ipi = ((cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi) /
                                         (100 + cotacao-item.aliquota-ipi)).
                end.
                else do:
                    if  cotacao-item.perc-descto > 0 then 
                        assign de-val-orig = (cotacao-item.pre-unit-for * 100) / 
                                              (100 - cotacao-item.perc-descto).
                    else                                             
                       assign de-val-orig = cotacao-item.pre-unit-for.
                    assign de-valor-ipi = ((de-val-orig * cotacao-item.aliquota-ipi) / 
                                      (100 + cotacao-item.aliquota-ipi)).
                end.
    
                if cotacao-item.pre-unit-for >= de-valor-ipi then
                   assign de-preco-mat = cotacao-item.pre-unit-for - de-valor-ipi.
    
                run ccp/cc9020.p (input  no,
                                  input  cotacao-item.cod-cond-pag,
                                  input  cotacao-item.valor-taxa,
                                  input  cotacao-item.nr-dias-taxa,
                                  input  de-preco-mat,
                                  output de-preco-mat).
    
                assign de-total-item = ordem-compra.qt-solic
                       de-preco-total-cot = (cotacao-item.preco-unit * ordem-compra.qt-solic).
    
                ASSIGN i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                    ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                    ASSIGN c-class = ' class="linhaBrowsepar" ' .
    
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr>' +
                '     <td ' + c-class + '>' +
                '      ' + STRING(emitente.cod-emitente) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + emitente.nome-abrev +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.data-cotacao,"99/99/9999") +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.prazo-entreg) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.un) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.mo-codigo) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '      ' + trim(STRING(cotacao-item.preco-fornec,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(cotacao-item.pre-unit-for,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(cotacao-item.aliquota-ipi,">>9.99")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '      ' + STRING(cotacao-item.codigo-ipi,"Sim/N’o") +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + cotacao-item.contato +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.cod-cond-pag) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + cotacao-item.cod-comprado +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.cod-transp) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.cot-aprovada,"Sim/N’o") +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '      ' + trim(STRING(cotacao-item.valor-descto,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(cotacao-item.valor-frete,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.taxa-financ,"Sim/N’o") +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '      ' + trim(STRING(cotacao-item.valor-taxa,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + STRING(cotacao-item.nr-dias-taxa) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(cotacao-item.perc-descto,">9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(de-total-item,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '      ' + trim(STRING(de-valor-ipi,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(de-preco-mat,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '     <td ' + c-class + '>' +
                '       ' + trim(STRING(de-preco-total-cot,">>>>>,>>>,>>9.99999")) +
                '     </td>' +
                '    </tr>'.
            END. /* for each cotacao-item */
    
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' </table><br>'.
    
    
            /* œltima compra */
    
            find last  b-ordem use-index compra-item 
                 where b-ordem.it-codigo     = ordem-compra.it-codigo 
                 and   b-ordem.data-pedido <> ? 
                 and   b-ordem.num-pedido  <> pedido-compr.num-pedido
                 NO-LOCK NO-ERROR.
            IF AVAIL b-ordem THEN DO:
               FOR FIRST b-emitente FIELD(cod-emitente nome-abrev)
                    WHERE b-emitente.cod-emitente = b-ordem.cod-emitente
                    NO-LOCK: END.
    
               ASSIGN de-utl-quant = 0.
               FOR EACH  prazo-compra 
                   WHERE prazo-compra.numero-ordem = b-ordem.numero-ordem 
                   NO-LOCK:
                    ASSIGN de-utl-quant = de-utl-quant + prazo-compra.quantidade.
                END.
                FOR FIRST moeda FIELD(mo-codigo descricao)
                    WHERE  moeda.mo-codigo = i-moeda-doc 
                    NO-LOCK: END.
                ASSIGN c-utl-moeda    = (IF AVAIL moeda THEN moeda.descricao ELSE "")
                       c-utl-natureza = {ininc/i01in274.i 04 b-ordem.natureza}.
                
                ASSIGN de-preco-unit-conv = b-ordem.preco-unit.
                if b-ordem.mo-codigo <> 0 then do:            
                    run cdp/cd0812.p (input b-ordem.mo-codigo,
                                      input 0,
                                      input b-ordem.preco-unit,
                                      input b-ordem.data-cotacao,
                                      output de-cotacao).
                    if  de-cotacao = ? then
                        assign de-cotacao = 1.
                    
                    ASSIGN de-preco-unit-conv =  de-cotacao.
                end.    
    
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '  <table align="center" border="0" cellpadding="0" cellspacing="0" width="90%" class="tableForm">' +
                '  <tr>' +
                '    <td  class="barratitulo" align="center">‚ltima Compra</td> ' +
                '  </tr>' +
                ' </table>'.
    
    
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                ' <table class="tableForm" align="center" border=0>' +
                '    <tr>' +
                '     <td align="center"  class="ColumnLabel" >Fornecedor</td>' +
                '     <td align="center"  class="ColumnLabel" >Pedido</td>' +
                '     <td align="center"  class="ColumnLabel" >Data</td>' +
                '     <td align="center"  class="ColumnLabel" >Natureza</td>' +
                '     <td align="center"  class="ColumnLabel" >Un</td>' +
                '     <td align="center"  class="ColumnLabel" >Moeda</td>' +
                '     <td align="center"  class="ColumnLabel" >Pre»o Unit For</td>' +
                '     <td align="center"  class="ColumnLabel" >Quantidade</td>' +
                '     <td align="center"  class="ColumnLabel" >% IPI</td>' +
                '     <td align="center"  class="ColumnLabel" >% ICMS</td>' +
                '    </tr>' +
                '    <tr>' +
                '     <td align="center"  class="linhaBrowsepar" >' + string(b-emitente.nome-abrev) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + STRING(b-ordem.num-pedido) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + STRING(b-ordem.data-pedido,"99/99/9999") + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + STRING(c-utl-natureza) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + STRING(ITEM.un) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + STRING(c-utl-moeda) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(de-preco-unit-conv,">>>>>,>>>,>>9.99999")) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(de-utl-quant,">>>>>,>>>,>>9.99999")) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(b-ordem.aliquota-ipi,">>9.99")) + '</td>' +
                '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(b-ordem.aliquota-icm,">>9.99")) + '</td>' +
                '    </tr>' +
                '    </table>'.
    
            END. /* fim œltima compra */
    
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <table class="tableFormVoltar" align="center">' +
            '  <tr>' +
            '    <td class="linhaForm" align="center"><a href="#' + STRING(ordem-compra.numero-ordem) + '" class="linhaVoltar">Voltar</a></td> ' +
            '  </tr>' +
            ' </table><br>' +
            ' </div>' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '
            .
    
        END. /* for each ordem-compra - detalha ordem */
    END. /*fim funcao HTML reduzido*/


    IF mla-param-aprov.log-atachado and index(proversion,"webspeed") = 0 THEN
    FOR EACH tt-html:
        ASSIGN tt-html.html-doc = codepage-convert(tt-html.html-doc,"iso8859-1","ibm850").
    END.

END. /* if avail pedido-compr */

PROCEDURE pi-valores:
    FOR EACH  ordem-compra 
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
        AND (ordem-compra.situacao   = 2 OR
             ordem-compra.situacao   = 6) no-lock:



    
        assign c-1-data-entrega     = "?"
               de-1-quant-saldo     = 0.

        for each  prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
              AND prazo-compra.situacao    <> 4 /*eliminada*/
            no-lock:
            if can-find(funcao where
                    funcao.cd-funcao = "Pedido_Total_MLA" and
                    funcao.ativo     = yes) THEN
                assign de-1-quant-saldo     = de-1-quant-saldo + prazo-compra.quantidade.
            ELSE
                assign de-1-quant-saldo     = de-1-quant-saldo + prazo-compra.qtd-sal-forn. 
                /* prazo-compra.quant-saldo - alterado para buscar o saldo do fornecedor, pois caso exista fator de conversao esta ja esta convertida - Favretto */
        end.

        FIND FIRST prazo-compra 
             WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
             NO-LOCK NO-ERROR.
        IF AVAIL prazo-compra THEN 
            ASSIGN dt-entreg = STRING(prazo-compra.data-entrega).

        FOR FIRST mla-lotacao FIELD(ep-codigo cod-lotacao desc-lotacao)
             WHERE mla-lotacao.ep-codigo   = i-empresa
             AND   mla-lotacao.cod-lotacao = ordem-compra.sc-codigo /* SUBSTRING(ordem-compra.conta -contabil,9,8) */
             NO-LOCK: END.
        IF AVAIL mla-lotacao THEN
           ASSIGN centro-custo = mla-lotacao.desc-lotacao.
        ELSE
           ASSIGN centro-custo = "".

        FIND FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
            AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
            AND   cotacao-item.data-cotacao = ordem-compra.data-cotacao
            AND   cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
        IF AVAIL cotacao-item THEN ASSIGN c-un-cot = cotacao-item.un. ELSE ASSIGN c-un-cot = "".

        assign  c-1-frete-b      = if ordem-compra.frete          then c-1-incluso else c-1-naoincluso
                c-1-ipi          = if ordem-compra.codigo-ipi     then c-1-incluso else c-1-naoincluso.

        IF AVAILABLE cotacao-item THEN
            ASSIGN da-1-cotacao = cotacao-item.data-cotacao.
        ELSE
            ASSIGN da-1-cotacao = ordem-compra.data-cotacao.

        /* Calculo do Valor da Cota‡Æo */
        if  ordem-compra.mo-codigo = 0 then  
            assign de-1-cotacao = 1.
        else do:            
            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                              input 0,
                              input 1,
                              input da-1-cotacao,
                              output de-1-cotacao).
            if  de-1-cotacao = ? then
                assign de-1-cotacao = 1.
        end.
        
        
        ASSIGN d-1-pre-unit-for = (ordem-compra.pre-unit-for * de-1-cotacao)
               d-1-preco-unit   = (ordem-compra.pre-unit-for * de-1-quant-saldo * de-1-cotacao)
               de-1-total       = de-1-total + d-1-preco-unit.


    END.
END PROCEDURE.


PROCEDURE pi-estatistica:


def input param codigo-item as char.
def output param diasboh as integer.
def var i-empresa like param-global.empresa-prin no-undo.
find first param-estoq  no-lock no-error.
find first param-global no-lock no-error.
if avail param-global THEN DO:
    assign i-empresa = param-global.empresa-prin.
END.



{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}


find estabelec where
                estabelec.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
    assign i-empresa = estabelec.ep-codigo.
/*## fim busca i-empresa ##*/



find mguni.empresa where 
    empresa.ep-codigo = i-empresa 
    no-lock.

find first estab-mat where
    estab-mat.cod-estabel = ordem-compra.cod-estabel
    no-lock no-error.

   run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                       output da-iniper-x,
                       output da-fimper-x,
                       output i-per-corrente,
                       output i-ano-corrente,
                       output da-iniper-fech,
                       output da-fimper-fech).

assign i-mes-fec = month(da-iniper-x)
       i-ano-fec = year(da-iniper-x)
       i-dia-x = day(da-fimper-x)
       i-numper-x = i-per-corrente.

for each item no-lock where
    item.it-codigo  = codigo-item     and
    (item.compr-fabric = 1 or
    item.compr-fabric = 2):

    /**  Busca consumo previsto
    **/
    
    find first estab-mat where
        estab-mat.cod-estabel = ordem-compra.cod-estabel
        no-lock no-error.
        find item-uni-estab where
            item-uni-estab.cod-estabel = estab-mat.cod-estabel-prin and
            item-uni-estab.it-codigo   = item.it-codigo
            no-lock no-error.
        assign de-consumo-prev = if  available item-uni-estab
                                 and param-estoq.cons-prev-estab 
                                 then item-uni-estab.consumo-prev
                                 else item.consumo-prev.           
        if  avail item-uni-estab then 
            assign de-preco-base   = item-uni-estab.preco-base
                   de-preco-ul-ent = item-uni-estab.preco-ul-ent
                   de-preco-repos  = item-uni-estab.preco-repos
                   i-tipo-est-seg  = item-uni-estab.tipo-est-seg
                   de-quant-segur  = item-uni-estab.quant-segur
                   i-tempo-segur   = item-uni-estab.tempo-segur
                   c-classif-abc   = item-uni-estab.classif-abc
                   da-data-ult-ent = item-uni-estab.data-ult-ent
                   da-data-ult-sai = item-uni-estab.data-ult-sai
                   de-lote-economi = item-uni-estab.lote-economi.
/*     &else */
/*         find item-mat-estab where */
/*             item-mat-estab.cod-estabel = estab-mat.cod-estabel-prin and */
/*             item-mat-estab.it-codigo   = item.it-codigo */
/*             no-lock no-error. */
/*         assign de-consumo-prev = if  available item-mat-estab */
/*                                  and param-estoq.cons-prev-estab */
/*                                  then item-mat-estab.consumo-prev */
/*                                  else item.consumo-prev. */
/*    */
/*         if  avail item-mat-estab then */
/*             assign de-preco-base   = item-mat-estab.preco-base */
/*                    de-preco-ul-ent = item-mat-estab.preco-ul-ent */
/*                    de-preco-repos  = item-mat-estab.preco-repos */
/*                    i-tipo-est-seg  = item-mat-estab.tipo-est-seg */
/*                    de-quant-segur  = item-mat-estab.quant-segur */
/*                    i-tempo-segur   = item-mat-estab.tempo-segur */
/*                    c-classif-abc   = item-mat-estab.classif-abc */
/*                    da-data-ult-ent = item-mat-estab.data-ult-ent */
/*                    da-data-ult-sai = item-mat-estab.data-ult-sai */
/*                    de-lote-economi = item-mat-estab.lote-economi. */
/*     &endif */
/*         else */
/*             assign de-preco-base   = item.preco-base */
/*                    de-preco-ul-ent = item.preco-ul-ent */
/*                    de-preco-repos  = item.preco-repos */
/*                    i-tipo-est-seg  = item.tipo-est-seg */
/*                    de-quant-segur  = item.quant-segur */
/*                    i-tempo-segur   = item.tempo-segur */
/*                    c-classif-abc   = item.classif-abc */
/*                    da-data-ult-ent = item.data-ult-ent */
/*                    da-data-ult-sai = item.data-ult-sai */
/*                    de-lote-economi = item.lote-economi. */
/*    */


    assign de-saldo-ent       = 0
           de-saldo-sai       = 0
           de-saldo-ini       = 0
           de-saldo-medio     = 0
           de-saldo-excedente = 0
           de-saldo-seguranca = 0
           de-valor-medio     = 0
           de-valor-excedente = 0
           de-valor-seguranca = 0
           de-valor-ini       = 0
           de-valor-ent       = 0
           de-valor-sai       = 0
           de-valor-saldo     = 0
           i-dia              = 0
           de-saldo           = 0.
           
          
    find item-estab where
        item-estab.it-codigo   = item.it-codigo and
        item-estab.cod-estabel = estab-mat.cod-estabel-prin
        no-lock no-error.
    if avail item-estab then do:
   

                assign de-valor-ini = de-valor-ini 
                                    + item-estab.sald-ini-mat-m[i-mo]
                                    + item-estab.sald-ini-mob-m[i-mo]
                                    + item-estab.sald-ini-ggf-m[i-mo].
                assign de-fvalor-final = de-fvalor-final
                                    + item-estab.sald-ini-mat-m[i-mo]
                                    + item-estab.sald-ini-mob-m[i-mo]
                                    + item-estab.sald-ini-ggf-m[i-mo].


        for each saldo-estoq where
            saldo-estoq.it-codigo = item.it-codigo and
            saldo-estoq.cod-estabel = ordem-compra.cod-estabel no-lock:

            assign de-saldo-ini = de-saldo-ini + saldo-estoq.qtidade-ini.


        end.        
        /** 
        ***  For each saldo-estoq 
        **/
        if l-fech-estab then do:
           &if defined(bf_mat_fech_estab) &then
           assign da-mensal-ate = estab-mat.mensal-ate.
           &endif
        end.
        else
           assign da-mensal-ate = param-estoq.mensal-ate.
         
        for each movto-estoq where
            movto-estoq.it-codigo    = item.it-codigo         and
            movto-estoq.cod-estabel  = ordem-compra.cod-estabel and
            movto-estoq.dt-trans    >= da-iniper-x            and
            movto-estoq.dt-trans    <= da-fimper-x            and 
            (not movto-estoq.referencia begins "RF")          and /*movto gerado pelo Rec. F¡sico*/
            movto-estoq.esp-docto   <> 33                     and not
            (movto-estoq.esp-docto   = 6                      and
            movto-estoq.serie-docto  = "CVR")
            EXCLUSIVE-LOCK break by movto-estoq.dt-trans:

            assign de-qtde = movto-est.quantidade.

            if first-of(movto-est.dt-trans) then
                assign de-saldo-medio = 
                       de-saldo-medio + (de-saldo-ent + de-saldo-sai +
                       de-saldo-ini)  * (day(dt-trans) - i-dia)
                                i-dia = day(dt-trans).

                    assign de-vl-medio = movto-estoq.valor-mat-m[i-mo]
                                       + movto-estoq.valor-mob-m[i-mo]
                                       + movto-estoq.valor-ggf-m[i-mo].

                assign de-valor = de-vl-medio.
           

            if  movto-estoq.tipo-trans = 1 then do:
                assign de-saldo-ent    = de-saldo-ent    + de-qtde
                       de-valor-ent    = de-valor-ent    + de-vl-medio
                       de-fvalor-ent   = de-fvalor-ent   + de-vl-medio
                       de-fvalor-final = de-fvalor-final + de-vl-medio
                       i-fentradas     = i-fentradas     + 1.

            end.
            

            if  movto-estoq.tipo-trans = 2 then do:
                assign de-saldo-sai    = de-saldo-sai    + de-qtde
                       de-valor-sai    = de-valor-sai    + de-vl-medio
                       de-fvalor-sai   = de-fvalor-sai   + de-vl-medio
                       de-fvalor-final = de-fvalor-final + de-vl-medio
                       i-fsaidas        = i-fsaidas     + 1.

           end. 
         
        end.
     end.  
        /**
        ***  For each movto-estoq 
        **/
        

        assign de-saldo = de-saldo-ini + de-saldo-ent + de-saldo-sai.

            assign de-valor-saldo = de-valor-ini + de-valor-ent - de-valor-sai.


        assign de-valor = de-valor-ent.


        if i-dia-x = i-dia then
            assign i-dia = i-dia-x - 1.

        assign de-saldo-medio = de-saldo-medio + (de-saldo-ent +
               de-saldo-sai + de-saldo-ini) * (i-dia-x - i-dia)
               de-saldo-medio = de-saldo-medio / i-dia-x.

                assign de-valor-medio = de-saldo-medio 
                                      * (item-estab.val-unit-mat-m[i-mo]
                                      +  item-estab.val-unit-mob-m[i-mo] 
                                      +  item-estab.val-unit-ggf-m[i-mo]).

        assign de-valor = de-valor-medio.

        assign de-saldo-excedente = de-saldo-medio 
                                  - de-consumo-prev 
               de-giro            = (de-saldo-sai) 
                                  / de-saldo-medio * 100   
               de-saldo-sai       = de-saldo-sai * -1.

                assign de-valor-seguranca = de-saldo-seguranca
                                         * (item-estab.val-unit-mat-m[i-mo] 
                                         +  item-estab.val-unit-mob-m[i-mo]
                                         +  item-estab.val-unit-ggf-m[i-mo])
                       de-valor-excedente = de-saldo-excedente
                                         * (item-estab.val-unit-mat-m[i-mo]
                                         +  item-estab.val-unit-mob-m[i-mo]
                                         +  item-estab.val-unit-ggf-m[i-mo]).
    end.                                     
    /**
    ***  Available item-estab
    **/
    

    assign de-valor = de-valor-seguranca.


    assign de-valor = de-valor-excedente.


       assign de-nr-dias-estoque = ((de-saldo
                                 -   de-saldo-seguranca) * 30)
                                 / de-giro
              de-varcrp          = (de-saldo-sai
                                 - de-consumo-prev) * 100
                                 / de-consumo-prev.

        
    if (de-giro = 0 or  de-saldo = 0) then
    assign diasboh = 999. else

        assign diasboh = de-nr-dias-estoque.
        
        assign de-nr-dias-estoque = 0
               de-saldo = 0
               de-saldo-seguranca = 0
               de-giro = 0.
               
                assign de-saldo-ent    = 0
                       de-valor-ent    = 0
                       de-fvalor-ent   = 0
                       de-fvalor-final = 0
                       i-fentradas     = 0.
            
                assign de-saldo-sai    = 0
                       de-valor-sai    = 0
                       de-fvalor-sai   = 0
                       de-fvalor-final = 0
                       i-fsaidas        = 0.
               
    
    if de-varcrp >  999999.99 then 
        assign de-varcrp =  999999.99.

    if de-varcrp < -999999.99 then 
        assign de-varcrp = -999999.99.

    if de-nr-dias-estoque = ? or de-nr-dias-estoque < 0 then
        assign de-nr-dias-estoque = 0.

    assign l-lista = yes.   


/** 
***  For each item
**/

/** fim-do-include  ce0506a.p 
**/




END PROCEDURE.


delete object h_api_cta_ctbl.
delete object h_api_ccusto.

