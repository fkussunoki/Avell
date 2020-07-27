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
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

    DEFINE TEMP-TABLE tt-html no-undo
        FIELD seq-html     AS INT
        FIELD html-doc     AS CHAR
        INDEX i-seq-mensagem
              seq-html        ASCENDING.


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

DEF VAR v_unidade              AS char.
DEF VAR v_cta_ctbl             AS char.















DEF BUFFER b-ordem FOR ordem-compra.
DEF BUFFER b-emitente FOR emitente.

/* Include de defini‡Æo de vari veis Unifica‡Æo de conceitos */
{laphtml/mlaUnifDefine.i}
/* Handle da API Conta Contÿbil e Centro de Custo */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
run prgint/utb/utb742za.py persistent set h_api_ccusto. 



    FUNCTION removeAcento RETURNS CHARACTER (INPUT pChar AS CHARACTER):
    DEFINE VARIABLE iPos AS INTEGER NO-UNDO.
    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("ÿ,’,?,?",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "a".
    END.

    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("?,?,?",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "e".
    END.


    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("?",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "c".
    END.

    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("­,?,Ã",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "i".
    END.

    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("½,„,?,?",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "o".
    END.

    DO iPos = 1 TO LENGTH(pChar):
    IF CAN-DO("œ,?,?",SUBSTRING(pChar,iPos,1)) THEN
    ASSIGN SUBSTRING(pChar,iPos,1) = "u".
    END.

    RETURN UPPER(pChar).

    END FUNCTION.



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
           c-narrativa  = removeacento(pedido-compr.comentario).

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
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">               
                           <html>
                            <head>
                                <meta http-equiv="content-type" content="text/html; charset=utf-8">' + 

								'<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">
                                <tr style="height:15.75pt">
                                   <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                                       <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + 'COMERCIAL CIRURGICA RIOCLARENSE' + '</span></b></p>
                                   </td>
                                </tr>								
								
								<tr style="height:15.75pt">
                                   <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                                       <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + 'PROCESSO DE APROVACAO LOGISTICO' + '</span></b></p>
                                   </td>
                                </tr>'.								


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
    ' </table> </head> ' +
    ' <body> ' +
    ' <form method="GET" action="' + c-servidor + '">' +
    ' <input class="fill-in" type="hidden" name="hid_param"> ' +
    ' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_chave" value="' + REPLACE(c-chave," ","**") + '">' +
    ' <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +

    ' <input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
    ' <input class="fill-in" type="hidden" name="hid_estabel" value="' + c-cod-estabel + '"> ' +

'<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">

        <tr style="height:15.75pt">
           <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
               <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + c-desc-documento + '</span></b></p>
           </td>
        </tr>'.								

    ASSIGN tt-html.html-doc = tt-html.html-doc +  /* '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;"> */
                                '<tr style="height:15.75pt">
                                   <td width=582 colspan=11 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                                       <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Capa do Pedido " + '</span></b></p>
                                   </td>
                                </tr>' +	


                      '<tr style="height:24.0pt">
                        <td width=72 style="width:20.0pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Pedido" + '</span></b></p>
                        </td>
                        <td width=72 style="width:20.0pt;border:solid windowtext 1.0pt;border-top:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Estab</span></b></p>
                        </td>
                        <td width=72 style="width:20pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Emitente</span></b></p>
                        </td>
                        <td width=72 style="width:120.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Razao Social</span></b></p>
                        </td>
                        <td width=72 style="width:30pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Condicao de Pagto</span></b></p>
                        </td>
                        <td width=72 style="width:80.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Vlr. TOTAL DO Pedido</span></b></p>
                        </td>
                        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Usuario Responsavel</span></b></p>
                        </td>
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Usuario</span></b></p>
                                </td>
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Aprovador</span></b></p>
                                </td>
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Situacao</span></b></p>
                                </td>
                    
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Geracao</span></b></p>
                                </td>

                        </tr>'.

        
        
                                                                      
    RUN pi-valores.
                                ASSIGN tt-html.html-doc = tt-html.html-doc +

                                '<tr style="height:24.0pt">
                                                   <td width=72 style="width:20pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                   <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(pedido-compr.num-pedido) + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:20pt;border:solid windowtext 1.0pt;border-top:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-cod-estabel-ent + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:20pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(pedido-compr.cod-emitente) + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:120pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(c-nome-abrev) + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:30pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + STRING(fi-cond-pagto) + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:80pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(trim(STRING(de-1-total,">>>>>,>>>,>>9.99999"))) + '</span></b></p>
                                                   </td>
                                                   <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                       <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(pedido-compr.responsavel) + '</span></b></p>
                                                   </td>
                                                           <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                               <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(pedido-compr.responsavel) + '</span></b></p>
                                                           </td>
                                                           <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                               <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(p-cod-aprovador) + '</span></b></p>
                                                           </td>
                                                           <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                               <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(c-situacao) + '</span></b></p>
                                                           </td>

                                                           <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                               <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(pedido-compr.data-pedido) + '</span></b></p>
                                                           </td>

                                                   </tr> </table>'.

                                    
 
    

    
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
        '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">

        <tr style="height:15.75pt">
           <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
               <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Itens do Pedido" + '</span></b></p>
           </td>
        </tr>' +								
        '<tr style="height:24.0pt">
                            <td width=72 style="width:20pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Ordem" + '</span></b></p>
                            </td>
                            <td width=72 style="width:20.0pt;border:solid windowtext 1.0pt;border-top:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Item" + '</span></b></p>
                            </td>
                            <td width=72 style="width:120pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Descricao" + '</span></b></p>
                            </td>
                            <td width=72 style="width:120pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Fabricante" + '</span></b></p>
                            </td>
                            <td width=72 style="width:15.00pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + "UM" + '</span></b></p>
                            </td>
                            <td width=72 style="width:60.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Qtde" + '</span></b></p>
                            </td>
                            <td width=72 style="width:80.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Preco" + '</span></b></p>
                            </td>
                                    <td width=72 style="width:80.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "$ Total" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Entrega" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Situacao" + '</span></b></p>
                                    </td>

                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Emissao" + '</span></b></p>
                                    </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Dias de Estoque" + '</span></b></p>
        </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Cta.Ctb" + '</span></b></p>
        </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "C.Csto" + '</span></b></p>
        </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Un. Negocio" + '</span></b></p>
        </td>

                            </tr>'.
							



/*     {utp/ut-liter.i Parcelada} */
/*     assign c-literal = trim(return-value). */
/*     {utp/ut-liter.i Incluso} */
/*     assign c-incluso = trim(return-value). */
/*     {utp/ut-liter.i N’o} */
/*     assign c-naoincluso = trim(return-value) + " " + c-incluso. */
/*     {utp/ut-liter.i Industrializado} */
/*     assign c-industrial = trim(return-value). */
/*     {utp/ut-liter.i Consumo} */
    assign /* c-consumo = trim(return-value) */
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
        assign c-fabricante = ext-item.cod-fabricante. /* FLAVIO KUSSUNOKI */
        end.


        FIND FIRST cta_ctbl NO-LOCK WHERE cta_ctbl.cod_cta_ctbl = ordem-compra.ct-codigo NO-ERROR.
          IF AVAIL cta_ctbl THEN DO:
              
          
              ASSIGN v_cta_ctbl = cta_ctbl.des_tit_ctbl.
          END.

          IF NOT AVAIL cta_ctbl THEN DO:
              
              FIND FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

              FIND FIRST contabiliza NO-LOCK WHERE contabiliza.ge-codigo = item.ge-codigo
                                             AND   contabiliza.cod-depos = ordem-compra.dep-almoxar
                                             AND   contabiliza.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

              FIND FIRST cta_ctbl WHERE cta_ctbl.cod_cta_ctbl = contabiliza.ct-codigo NO-ERROR.

              ASSIGN v_cta_ctbl = cta_ctbl.des_tit_ctbl.

          END.




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

        /* Calculo do Valor da Cota?’o */
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
        
        ASSIGN v_unidade = "".

                FIND FIRST unid_negoc NO-LOCK WHERE unid_negoc.cod_unid_negoc = ordem-compra.cod-unid-negoc NO-ERROR.

                IF AVAIL unid_negoc THEN DO:
                    
                    ASSIGN v_unidade = ordem-compra.cod-unid-negoc + "-" + unid_negoc.des_unid_negoc.

                END.

        IF NOT AVAIL unid_negoc THEN DO:
            

            FOR EACH unid-neg-ordem NO-LOCK WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem
                                            :

                FIND FIRST unid_negoc NO-LOCK WHERE unid_negoc.cod_unid_negoc = unid-neg-ordem.cod_unid_negoc NO-ERROR.

                ASSIGN v_unidade = v_unidade + " ** " +  unid-neg-ordem.cod_unid_negoc + "-" + unid_negoc.des_unid_negoc + "-" + string(unid-neg-ordem.perc-unid-neg, "999.9%").


            END.

        END.

        
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

        '<tr style="height:24.0pt">
                            <td width=72 style="width:20pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + '<a href="#' + STRING(ordem-compra.numero-ordem) + '"' +   '>' + STRING(ordem-compra.numero-ordem) + '</span></b></p>
                            </td>
                            <td width=72 style="width:20pt;border:solid windowtext 1.0pt;border-top:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + STRING(ordem-compra.it-codigo)  + '</span></b></p>
                            </td>
                            <td width=72 style="width:120pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-desc-item + '</span></b></p>
                            </td>
                            <td width=72 style="width:120pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(c-fabricante)  + '</span></b></p>
                            </td>
                            <td width=72 style="width:15pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'   + STRING(item.un)  + '</span></b></p>
                            </td>
                            <td width=72 style="width:60.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(de-quant-saldo,">>>,>>>,>>9.999"))  + '</span></b></p>
                            </td>
                            <td width=72 style="width:80.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(d-pre-unit-for,">>>>>,>>>,>>9.999"))  + '</span></b></p>
                            </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(d-preco-unit,">>>>>,>>>,>>9.999"))  + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(dt-entreg))  + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(c-situacao-b))  + '</span></b></p>
                                    </td>

                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(ordem-compra.data-emissao))  + '</span></b></p>
                                    </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(days_boh))  + '</span></b></p>
        </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(ordem-compra.ct-codigo))  + " " + v_cta_ctbl + '</span></b></p>
        </td>
        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(ordem-compra.sc-codigo))  + '</span></b></p>
        </td>
            <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + v_unidade + '</span></b></p>
            </td>



         </tr> 
                <tr style="height:24.0pt">
                                     <td width=582 colspan=15 style="width:882.9pt;border:solid windowtext 1.0pt;border-top:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">Narrativa: '  +  removeacento(ordem-compra.narrativa)  + '</span></b></p>
                            </td> </tr>'.

 
         
         

 

    END. /* For each ordem-compra */

    ASSIGN tt-html.html-doc = tt-html.html-doc + 

        '<tr style="height:15.75pt">
           <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#ffff00;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
               <p class=MsoNormal align=center style="text-align:right"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR"> ' + "Valor Total do Pedido: <b>" + trim(string(de-total,">>>>>,>>>,>>9.99999")) +  '</span></b></p>           </td>


         </tr> </table>'.


 



FIND first mla-doc-pend-aprov 
 WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
   AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
   AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
   AND mla-doc-pend-aprov.chave-doc    = c-chave  
   AND mla-doc-pend-aprov.ind-situacao = 1
   AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */
if avail mla-doc-pend-aprov then  do:
   RUN pi-rodape.
END.


if not can-find(funcao where
               funcao.cd-funcao = "html_red_MLA" and
               funcao.ativo     = yes) then do:

    
        ASSIGN tt-html.html-doc = tt-html.html-doc + '<br> </br> <br> </br> <br> </br> <br> </br> <br> </br> <br> </br>' +  
        '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">


            <tr style="height:15.75pt">
               <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                   <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Pedido Compra (Total)" + '</span></b></p>
               </td>
            </tr> </table>' +				 

        '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">

            <tr style="height:15.75pt">
               <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                   <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Pedido:         " + STRING(pedido-compr.num-pedido) + '</span></b></p>
               </td>
            </tr> </table>' .  			 


/*             ' <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                 <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(days_boh))  + '</span></b></p>                                                                                                                */
/*             </td> '.                                                                                                                                                                                                                                                                 */





/*         ' <a name="parcelas"></a> ' +                                                                                                                         */
/*         ' <div align="center"><center> ' +                                                                                                                    */
/*         '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +                                               */
/*         '     <tr> ' +                                                                                                                                        */
/*         '       <td class="barratitulo">Pedido Compra (Total)</td> ' +                                                                                        */
/*         '     </tr> ' +                                                                                                                                       */
/*         '    <tr> ' +                                                                                                                                         */
/*         '     <td class="linhaForm" align="center"><center> ' +                                                                                               */
/*         '      <fieldset> ' +                                                                                                                                 */
/*         '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +                                                            */
/*         '          <tr><td height="5"></td></tr> ' +                                                                                                          */
/*         '          <tr> ' +                                                                                                                                   */
/*         '            <th align="right" class="linhaForm" nowrap>Pedido:</th> ' +                                                                              */
/*         '            <td class="linhaForm" align="right" nowrap> ' +                                                                                          */
/*         '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_pedido" value="' + STRING(pedido-compr.num-pedido) + '" readonly> ' + */
/*         '            </td> ' +                                                                                                                                */
/*         '          </tr> ' +                                                                                                                                  */
/*         '         <tr><td height="5"></td></tr> ' +                                                                                                           */
/*         '        </table> ' +                                                                                                                                 */
/*         '      </fieldset> ' +                                                                                                                                */
/*         '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +                                                            */
/*         '          <tr> ' +                                                                                                                                   */
/*         '            <th align="center" class="linhaForm" nowrap><a href="#dados" class="aBrowser"> Dados</a></th> ' +                                        */
/*         '            <th align="center" class="linhaForm" nowrap>Parcelas</th> ' .                                                                            */
    
        
        ASSIGN tt-html.html-doc = tt-html.html-doc +

        '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">' +

            '<tr style="height:24.0pt">
                                <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Ordem" + '</span></b></p>
                                </td>
                                <td width=72 style="width:107.0pt;border:solid windowtext 1.0pt;border-top:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Parc" + '</span></b></p>
                                </td>
                                <td width=72 style="width:56.55pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Dt. Entrega" + '</span></b></p>
                                </td>
                                <td width=72 style="width:65.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Unidade" + '</span></b></p>
                                </td>
                                <td width=72 style="width:44.25pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + "Qtde" + '</span></b></p>
                                </td>
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Qtde Saldo" + '</span></b></p>
                                </td>
                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Qtde Recebida" + '</span></b></p>
                                </td>
                                        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Qtde Devolvida" + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Situacao" + '</span></b></p>
                                        </td>

                                </tr>'.

/*         '          </tr> ' +                                                 */
/*         '        </table> ' +                                                */
/*         '  </td> ' +                                                         */
/*         ' </tr> ' +                                                          */
/*         ' </table>   ' +                                                     */
/*         ' <br> ' +                                                           */
/*         '    <table class="tableForm" align="center"> ' +                    */
/*         '    <tr> ' +                                                        */
/*         '     <td align="center"  class="ColumnLabel" >Ordem</td> ' +        */
/*         '     <td align="center"  class="ColumnLabel" >Parc</td> ' +         */
/*         '     <td align="center"  class="ColumnLabel" >Data Entrega</td> ' + */
/*         '     <td align="center"  class="ColumnLabel" >Un</td> ' +           */
/*         '     <td align="center"  class="ColumnLabel" >Quantidade</td> ' +   */
/*         '     <td align="center"  class="ColumnLabel" >Qtde Saldo</td> ' +   */
/*         '     <td align="center"  class="ColumnLabel" >Qtde Receb</td> ' +   */
/*         '     <td align="center"  class="ColumnLabel" >Qtde Devol</td> ' +   */
/*         '     <td align="center"  class="ColumnLabel" >Situacao</td> ' +     */
/*         '    </tr> '.                                                        */
    
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
                
                    '<tr style="height:24.0pt">
                                        <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + '<a href="#' + STRING(ordem-compra.numero-ordem) + '"' +   '>' + STRING(ordem-compra.numero-ordem) + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:107.0pt;border:solid windowtext 1.0pt;border-top:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + STRING(prazo-compra.parcela)  + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:56.55pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' +  STRING(prazo-compra.data-entrega,"99/99/9999") + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:65.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(prazo-compra.un)   + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:44.25pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'   + trim(STRING(prazo-compra.quantidade,">>>,>>>,>>9.9999"))  + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(prazo-compra.quant-saldo,">>>,>>>,>>9.9999"))  + '</span></b></p>
                                        </td>
                                        <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                            <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(prazo-compra.quant-receb,">>>,>>>,>>9.9999"))  + '</span></b></p>
                                        </td>
                                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                    <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + trim(STRING(prazo-compra.quant-rejeit,">>>,>>>,>>9.9999"))  + '</span></b></p>
                                                </td>
                                                <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                    <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-sit  + '</span></b></p>
                                                </td>' +

                    ' </tr> '.
/*                                                                                          */
/*                     '    <tr> ' +                                                        */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + STRING(ordem-compra.numero-ordem) +                          */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + STRING(prazo-compra.parcela) +                               */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + STRING(prazo-compra.data-entrega,"99/99/9999") +             */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + STRING(prazo-compra.un) +                                    */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + trim(STRING(prazo-compra.quantidade,">>>,>>>,>>9.9999")) +   */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + trim(STRING(prazo-compra.quant-saldo,">>>,>>>,>>9.9999")) +  */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + trim(STRING(prazo-compra.quant-receb,">>>,>>>,>>9.9999")) +  */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + trim(STRING(prazo-compra.quant-rejeit,">>>,>>>,>>9.9999")) + */
/*                 '     </td> ' +                                                          */
/*                 '     <td ' + c-class + '> ' +                                           */
/*                 '       ' + c-sit +                                                      */
/*                 '     </td> ' +                                                          */
/*                 '    </tr> '.                                                            */
            END. /* for each prazo-compra */
        END. /* for each ordem-compra */
        ASSIGN tt-html.html-doc = tt-html.html-doc + '</TABLE>'.
    
    
/*         ASSIGN tt-html.html-doc = tt-html.html-doc + '<br> </br> <br> </br> <br> </br> <br> </br> <br> </br> <br> </br>' +                                                                                                                                                                                      */
/*         '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                                                                                 */
/*             <tr style="height:15.75pt">                                                                                                                                                                                                                                                                         */
/*                <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">                                                             */
/*                    <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Anexos" + '</span></b></p>                                                                                        */
/*                </td>                                                                                                                                                                                                                                                                                            */
/*             </tr> </table>' +                                                                                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                                                                                 */
/*                     '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">' +                                                                                                                                                               */
/*                                                                                                                                                                                                                                                                                                                 */
/*             '<tr style="height:24.0pt">                                                                                                                                                                                                                                                                         */
/*                                 <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>         */
/*                                 <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Docto" + '</span></b></p>                                                                                                                                              */
/*                                 </td> </tr>'.                                                                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                                                                                 */
/*         FIND FIRST pedido-compr                                                                                                                                                                                                                                                                                 */
/*          WHERE pedido-compr.num-pedido = integer(tt-mla-chave.valor[1])                                                                                                                                                                                                                                         */
/*          NO-LOCK NO-ERROR.                                                                                                                                                                                                                                                                                      */
/*                                                                                                                                                                                                                                                                                                                 */
/*     FOR EACH ext-ordem-compra WHERE ext-ordem-compra.nr-pedido = pedido-compr.num-pedido:                                                                                                                                                                                                                       */
/*     ASSIGN tt-html.html-doc = tt-html.html-doc +                                                                                                                                                                                                                                                                */
/*                     '<tr style="height:24.0pt">                                                                                                                                                                                                                                                                 */
/*                                         <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                         <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + '<a href="' + 'file:///' + ext-ordem-compra.local + '"' +  '>' +  ext-ordem-compra.local + '</span></b></p>                                                    */
/*                                         </td> </TR>'.                                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                                                                                 */
/*    END.                                                                                                                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                                                                                 */
    
    
        
        IF l-alt THEN DO:
        
        
               ASSIGN tt-html.html-doc = tt-html.html-doc +        
        '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">

            <tr style="height:15.75pt">
               <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">
                   <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Altera?„es" + '</span></b></p>
               </td>
            </tr> 
            </table>'.				 



            ASSIGN tt-html.html-doc = tt-html.html-doc +
  
                '<tr style="height:24.0pt">
                                    <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                    <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Dt. Alteracao" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:107.0pt;border:solid windowtext 1.0pt;border-top:none;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Hora" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:56.55pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Usuario" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:65.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Ordem Compra" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:44.25pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + "Parcela" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Qtde" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Nova Qtde" + '</span></b></p>
                                    </td>
                                            <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Preco Unitario" + '</span></b></p>
                                            </td>
                                            <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                                <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Novo Preco" + '</span></b></p>
                                            </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Dt. Entrega" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Nova Dt.Entrega" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Cond. Pagto" + '</span></b></p>
                                    </td>
                                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Nova Cond. Pagto" + '</span></b></p>
                                    </td>
                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Observacao" + '</span></b></p>
                    </td>
                    <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#C1CDCD;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b>
                        <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Comentarios" + '</span></b></p>
                    </td> 
  
  
                                </tr>' .
  
  
  



/*             /* Alteracoes */ */
/*             ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*             ' <a name="alt"></a> ' + */
/*             ' <div align="center"><center> ' + */
/*             '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' + */
/*             '     <tr> ' + */
/*             '       <td class="barratitulo">Pedido Compra (Total)</td> ' + */
/*             '     </tr> ' + */
/*             ' </table>   ' + */
/*             '    <tr> ' + */
/*             '     <td class="linhaForm" align="center"><center> ' + */
/*             '      <fieldset> ' + */
/*             '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '          <tr><td height="5"></td></tr> ' + */
/*             '          <tr> ' + */
/*             '            <th align="right" class="linhaForm" nowrap>Pedido:</th> ' + */
/*             '            <td class="linhaForm" align="right" nowrap> ' + */
/*             '             <input class="fill-in" type="text" size="7" maxlength="7" name="w_pedido" value="' + STRING(pedido-compr.num-pedido) + '" readonly> ' + */
/*             '            </td> ' + */
/*             '          </tr> ' + */
/*             '         <tr><td height="5"></td></tr> ' + */
/*             '        </table> ' + */
/*             '      </fieldset> '. */
                                                                                                                                                                 
/*             ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*             ' <br> ' + */
/*             '    <table class="tableForm" align="center"> ' + */
/*             '    <tr> ' + */
/*                 '     <td align="center"  class="ColumnLabel" >Data Alteracao</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Hora</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Usuario</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Ordem Compra</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Parcela</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Quantidade</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Nova Qtde</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Prevo Unitario</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Novo Preco</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Dt Entrega</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Nova Dt Ent</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Cond Pagto</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Nova Cond Pagto</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Observacao</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Comentarios</td>' + */
/*             '    </tr> '. */
    
            
            ASSIGN i-cont = 0.
    
            FOR EACH  alt-ped
                WHERE alt-ped.num-pedido = pedido-compr.num-pedido
                    : 
                    
                    find first cond-pagto where cond-pagto.cod-cond-pag = alt-ped.cod-cond-pag no-error.
  
    
                ASSIGN c-quantidade      = STRING(alt-ped.quantidade,">>>>,>>9.9999")
                       c-qtd-sal-forn    = ""
                       c-dt-entrega      = STRING(alt-ped.data-entrega,"99/99/9999")
                       c-dt-entrega-2    = ""
                       c-comentarios     = ""
                       c-cod-cond-pag    = if avail cond-pagto then STRING(cond-pagto.descricao) else ""
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
                              ordem-compra.numero-ordem = alt-ped.numero-ordem NO-LOCK:
    
                    IF AVAIL ordem-compra     AND
                       NOT alt-ped.observacao BEGINS "#" THEN DO:
    
                        &IF  "{&bf_dis_versao_ems}" < "2.04" &THEN
                          ASSIGN c-comentarios = ordem-compra.comentarios.
                        &ENDIF
    
                        /* Novo Pre?o */
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
                           alt-ped.cod-cond-pag <> ordem-compra.cod-cond-pag THEN do:
                           
                           IF alt-ped.char-1 <> "" THEN do:
                                      find first cond-pagto where cond-pagto.cod-cond-pag =   int(ENTRY(4,alt-ped.char-1,"|")) no-error.
                                      
                                      if avail cond-pagto then
                                      assign c-cod-cond-pag-2 = cond-pagto.descricao.
                                      
                                      end.
                                      
                           else do:
                           
                            find first cond-pagto where cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-error.
                            
                            if avail cond-pagto then
                            assign c-cod-cond-pag-2 = cond-pagto.descricao.
                                      

                           end.
                end.
            end.    
                           
 /*                           ASSIGN c-cod-cond-pag-2 = IF alt-ped.char-1 <> "" THEN */
/*                                                         STRING(DEC(ENTRY(4,alt-ped.char-1,"|")),">>>>9") */
/*                                                      ELSE */
/*                                                         STRING(ordem-compra.cod-cond-pag). */
/*                     END. */
/*    */               END.
    
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
                            /* {utp/ut-liter.i Alterado(s):_Preco_Unit˜rio} */
                            ASSIGN c-comentarios = "Alterado(s): Preco Unitario".
                        END.
                        IF c-qtd-sal-forn <> "" THEN DO:
                            IF  c-comentarios = "" THEN DO:
                               /*  {utp/ut-liter.i Alterado(s):_Quantidade_Saldo} */
                                ASSIGN c-comentarios = "Alterado(s): Qtde Saldo".
                            END.
                            ELSE DO:
                                /* {utp/ut-liter.i Quantidade_Saldo} */
                                ASSIGN c-comentarios = c-comentarios + ", " + "Alterado(s): Qtde Saldo".
                            END.
                        END.
                        IF c-dt-entrega <> "" THEN DO:
                            IF  c-comentarios = "" THEN DO:
                               /*  {utp/ut-liter.i Alterado(s):_Data_Entrega} */
                                ASSIGN c-comentarios = "Alterado(s): Dt Entrega".
                            END.
                            ELSE DO:
                                /* {utp/ut-liter.i Data_Entrega} */
                                ASSIGN c-comentarios = c-comentarios + ", " + "Alterado(s): Dt Entrega".
                            END.
                        END.
                        IF c-cod-cond-pag <> "" THEN DO:
                            IF  c-comentarios = "" THEN DO:
                                /* {utp/ut-liter.i Alterado(s):_Condicao_Pagamento} */
                                ASSIGN c-comentarios = "Alterado(s): Condicao Pgto".
                            END.
                            ELSE DO:
                                /* {utp/ut-liter.i Condi?cao_Pagamento} */
                                ASSIGN c-comentarios = c-comentarios + ", " + "Alterado(s) Condicao Pagto".
                            END.
                        END.
                    END.
                &ENDIF
    
                IF (i-cont MOD 2) = 0 THEN
                    ASSIGN c-class = ' class="linhaBrowsepar" ' .
                ELSE
                    ASSIGN c-class = ' class="linhaBrowseImpar" '.
    
    
    
    
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                
                
                
                    '<tr style="height:24.0pt">
                                        <td width=10%> <span style="font-size:8pt">' + STRING(alt-ped.data,"99/99/9999") + '</span></td>
                                        <td width=10%> <span style="font-size:8pt">' + STRING( alt-ped.hora )  + '</span></td>

                                        <td width=10%> <span style="font-size:8pt">' +  STRING(alt-ped.usuario) + '</span></td>

                                        <td width=10%> <span style="font-size:8pt">' + STRING(alt-ped.numero-ordem,"999999,99")   + '</span></td>

                                        <td width=10%> <span style="font-size:8pt">' + STRING(alt-ped.parcela)   + '</span></td>

                                        <td width=10%> <span style="font-size:8pt">' + c-quantidade  + '</span></td>

                                        <td width=10%> <span style="font-size:8pt">' +  c-qtd-sal-forn  + '</span></td>

                                               <td width=10%> <span style="font-size:8pt">' +  c-preco   + '</span></td>

                                                <td width=10%> <span style="font-size:8pt">' + c-pre-unit-for   + '</span></td>
 
                                                <td width=10%> <span style="font-size:8pt">' + c-dt-entrega   + '</span></td>
 
                                                <td width=10%> <span style="font-size:8pt">' + c-dt-entrega-2   + '</span></td>
 
  
                                                <td width=10%> <span style="font-size:8pt">' + c-cod-cond-pag    + '</span></td>

                                                <td width=10%> <span style="font-size:8pt">' + c-cod-cond-pag-2    + '</span></td>
 
                                                <td width=10%> <span style="font-size:8pt">' + alt-ped.observacao    + '</span></td>
 
                                                <td width=10%> <span style="font-size:8pt">' + c-comentarios   + '</span></td>
  
  
                    </tr>'.
               
                
                
                
                
               
 /*                    '<tr style="height:24.0pt"> */
/*                                         <td width=72 style="width:99.75pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                         <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(alt-ped.data,"99/99/9999") + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:107.0pt;border:solid windowtext 1.0pt;border-top:none;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'  + STRING( alt-ped.hora )  + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:56.55pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' +  STRING(alt-ped.usuario) + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:65.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + STRING(alt-ped.numero-ordem,"999999,99")   + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:44.25pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">'   + STRING(alt-ped.parcela)   + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-quantidade  + '</span></b></p> */
/*                                         </td> */
/*                                         <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                             <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' +  c-qtd-sal-forn  + '</span></b></p> */
/*                                         </td> */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' +  c-preco   + '</span></b></p> */
/*                                                 </td> */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-pre-unit-for   + '</span></b></p> */
/*                                                 </td> + */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-dt-entrega   + '</span></b></p> */
/*                                                 </td> + */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-dt-entrega-2   + '</span></b></p> */
/*                                                 </td> + */
/*    */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-cod-cond-pag    + '</span></b></p> */
/*                                                 </td> + */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-cod-cond-pag-2    + '</span></b></p> */
/*                                                 </td> + */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + alt-ped.observacao    + '</span></b></p> */
/*                                                 </td> + */
/*                                                 <td width=72 style="width:37.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:center"><b> */
/*                                                     <span style="font-size:8pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + c-comentarios   + '</span></b></p> */
/*                                                 </td>' + */
/*    */
/*    */
/*                     ' </tr>'. */
  
                    
                    
                    
                    
                    
                    
                    
                    
/*                     '    <tr>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                  STRING(alt-ped.data,"99/99/9999") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                  alt-ped.hora + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 alt-ped.usuario + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 STRING(alt-ped.numero-ordem,"999999,99") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 STRING(alt-ped.parcela) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-quantidade + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-qtd-sal-forn + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-preco + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-pre-unit-for + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-dt-entrega + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-dt-entrega-2 + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-cod-cond-pag + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-cod-cond-pag-2 + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 alt-ped.observacao + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + ' >' + */
/*                 c-comentarios + */
/*                 '     </td>' + */
/*                 '    </tr>'. */
            END.
  
    
/*              ASSIGN tt-html.html-doc = tt-html.html-doc +              */
/*                     '</div> ' +                                        */
/*                     '<br><br><br><br><br><br><br><br><br><br><br> ' +  */
/*                     '<br><br><br><br><br><br><br><br><br><br><br> '.   */


  
        END.
   end.     
assign tt-html.html-doc = tt-html.html-doc + '</table>'.
    
    
        /*
        ** Detalhe da Ordem
        */
    /*    */
/*         {utp/ut-liter.i Parcelada} */
/*         assign c-literal = trim(return-value). */
/*    */
/*         {utp/ut-liter.i Incluso} */
/*         assign c-incluso = trim(return-value). */
/*    */
/*         {utp/ut-liter.i Ncao} */
/*         assign c-naoincluso = trim(return-value) + " " + c-incluso. */
/*    */
/*         {utp/ut-liter.i Industrializado} */
/*         assign c-industrial = trim(return-value). */
/*    */
/*         {utp/ut-liter.i Consumo} */
/*         assign c-consumo = trim(return-value). */
/*    */
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
    
            /* Calculo do Valor da Cota?cao */
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
    
            /******** Unifica?’o de conceitos, buscando formatos ********/
            {laphtml/mlaUnifFormatos.i i-empresa today}          
            if c-formato-conta <> "" then
                assign c-ct-codigo = string(ordem-compra.ct-codigo, c-formato-conta).
            else
                assign c-ct-codigo = ordem-compra.ct-codigo.
                
            if c-formato-ccusto <> "" then
                assign c-sc-codigo = string(ordem-compra.sc-codigo, c-formato-ccusto).
            else
                assign c-sc-codigo = ordem-compra.sc-codigo.            
    
/*             ASSIGN tt-html.html-doc = tt-html.html-doc +                                                                                                                                                                                                                               */
/*                 '<tr style="height:15.75pt">                                                                                                                                                                                                                                           */
/*                    <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt">                                */
/*                        <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + 'Detalhe Ordem' + '</span></b></p>                                                    */
/*                    </td>                                                                                                                                                                                                                                                               */
/*                 </tr>                                                                                                                                                                                                                                                                  */
/*                                                                                                                                                                                                                                                                                        */
/*                 <tr style="height:15.75pt">                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*             <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>      */
/*                 <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Ordem:             " +   STRING(ordem-compra.numero-ordem) + '</span></b></p>                                                                                */
/*             </td>  </tr>                                                                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                                        */
/*                 <tr style="height:15.75pt">                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Item:             " +   STRING(ordem-compra.it-codigo) + " " + c-desc-item + '</span></b></p>                                                            */
/*                 </td> </tr>                                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                <tr style="height:15.75pt">                                                                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                                                        */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:400.0pt"><p class=MsoNormal align=center style="text-align:left"><b> */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Narrativa:             " +   ordem-compra.narrativa + '</span></b></p>                                                                                   */
/*                 </td>   </tr>                                                                                                                                                                                                                                                          */
/*                                                                                                                                                                                                                                                                                        */
/*                 <tr style="height:15.75pt">                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                                        */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Aprovador:             " +   p-cod-aprovador + " " + desc-aprovador + '</span></b></p>                                                                   */
/*                 </td>  </tr>                                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                                        */
/*                  <tr style="height:15.75pt">                                                                                                                                                                                                                                           */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Prazo entrega:             " +   STRING(ordem-compra.prazo-entreg) + '</span></b></p>                                                                    */
/*                 </td>  </tr>                                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                                        */
/*                  <tr style="height:15.75pt">                                                                                                                                                                                                                                           */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Situacao:             " +    c-situacao-b + '</span></b></p>                                                                                             */
/*                 </td>  </tr>                                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                                                        */
/*                  <tr style="height:15.75pt">                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                                                        */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "Cta Ctbl:             " +    STRING(c-ct-codigo) + " " + c-desc-conta + '</span></b></p>                                                                 */
/*                 </td> </tr>                                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                           <tr style="height:15.75pt">                                                                                                                                                                                                                                  */
/*                 <td width=72 style="width:880.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#FFFAFA;padding:0cm 3.5pt 0cm 3.5pt;height:24.0pt"><p class=MsoNormal align=center style="text-align:left"><b>  */
/*                     <span style="font-size:11pt;font-family:"Arial","sans-serif";color:black;mso-fareast-language:PT-BR">' + "CCusto:             " +    STRING(c-sc-codigo)  + " " + c-desc-ccusto + '</span></b></p>                                                                 */
/*                 </td>  </tr>'.                                                                                                                                                                                                                                                         */


/* '<table style = "width: 100%; background-color: #fafafa; border: 1px #000000 solid; font-family: Arial; font-size: 10px;">'+ */
/*             ' <a name="' + STRING(ordem-compra.numero-ordem) + '"></a> ' + */
/*             ' <div align="center"><center> ' + */
/*             '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' + */
/*             '<tr style="height:15.75pt"> */
/*                <td width=582 colspan=15 style="width:882.9pt;border-top:none;border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:solid black 1.0pt;background:#99CCCC;padding:0cm 3.5pt 0cm 3.5pt;height:15.75pt"> */
/*                    <p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:16.0pt;font-family:"Arial","sans-serif";color:#404040;mso-fareast-language:PT-BR">' + "Detalhe da Ordem" + '</span></b></p> */
/*                </td> */
/*             </tr> </table>' + */
/*             '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' + */
/*             '     <td class="linhaForm" align="center"><center> ' + */
/*             '      <fieldset> ' + */
/*             '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '          <tr><td height="5"></td></tr> ' + */
/*             '          <tr> ' + */
/*             '            <th align="right" class="linhaForm" nowrap width="45%">Ordem:</th> ' + */
/*             '            <td class="linhaForm" align="right" nowrap> ' + */
/*             '             <input class="fill-in" type="text" size="12" name="w_ordem" value="' + STRING(ordem-compra.numero-ordem) + '" readonly> ' + */
/*             '            </td> ' + */
/* /*             '            <td class="linhaForm" align="right" nowrap> ' + */ */
/* /*             '             <a href="#cotacao' + STRING(ordem-compra.numero-ordem) + '" class="aBrowser">Detalhes da Cota?ao</a>' + */ */
/* /*             '            </td>' + */ */
/*             '          </tr> ' + */
/*             '         <tr><td height="5"></td></tr> ' + */
/*             '        </table> ' + */
/*             '      </fieldset> ' + */
/*             '     <fieldset> ' + */
/*             '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" width="20%" nowrap>Item:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="16" name="w_item" value="' + ordem-compra.it-codigo + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="64" name="w_desc_item" value="' + c-desc-item + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" valign="top" nowrap>Narrativa:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <textarea class="fill-in" rows=3 cols=86> ' + */
/*                           removeacento(ordem-compra.narrativa) + */
/*             '            </textarea>' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '      </table>   ' + */
/*             '     </fieldset> ' + */
/*             '     <fieldset> ' + */
/*             '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" width="20%" nowrap>Aprovador:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="16" maxlength="20" name="w_aprovador" value="' + p-cod-aprovador + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="64" maxlength="64" name="w_desc_aprovador" value="' + desc-aprovador + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" valign="top" nowrap>Narrativa Solic:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <textarea class="fill-in" rows=3 cols=86> ' + */
/*                           removeacento(req-narrativa) + */
/*             '            </textarea>' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '      </table>   ' + */
/*             '     </fieldset> ' + */
/*             '      <fieldset> ' + */
/*             '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" width="20%" nowrap>Prazo Entrega:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_prazo" value="' + STRING(ordem-compra.prazo-entreg) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Situacao:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_situacao" value="' + c-situacao-b + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Conta:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap colspan="4"> ' + */
/*             '            <input class="fill-in" type="text" size="22" name="w_conta" value="' + STRING(c-ct-codigo) + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="60" name="w_desc_conta" value="' + c-desc-conta + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Centro Custo:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap colspan="4"> ' + */
/*             '            <input class="fill-in" type="text" size="22" name="w_ccusto" value="' + STRING(c-sc-codigo) + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="60" name="w_desc_ccusto" value="' + c-desc-ccusto + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Data Emisscao:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="12" name="w_dt_emis" value="' + STRING(ordem-compra.data-emissao,"99/99/9999") + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Data Cotacao:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="12" name="w_dt_preco" value="' + STRING(ordem-compra.data-cotacao,"99/99/9999") + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Tipo Despesa:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap colspan="4"> ' + */
/*             '            <input class="fill-in" type="text" size="20" name="w_tp_dep" value="' + STRING(ordem-compra.tp-despesa) + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="60" name="w_tp_dep" value="' + STRING(fi-tp-despesa) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Requisitante:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap colspan="4"> ' + */
/*             '            <input class="fill-in" type="text" size="20" name="w_requisitante" value="' + STRING(ordem-compra.requisitante) + '" readonly> ' + */
/*             '            <input class="fill-in" type="text" size="60" name="w_requisitante" value="' + STRING(c-desc-requis) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Un Fornec:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap colspan="4"> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_un_fornec" value="' + STRING(c-un-cot) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '      </table>   ' + */
/*             '     </fieldset> ' + */
/*             '     <fieldset> ' + */
/*             '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" width="20%" nowrap>Taxa Fin:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_taxa_fin" value="' + trim(STRING(ordem-compra.valor-taxa,">>9.9999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Dias Taxa:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_dias_taxa" value="' + STRING(ordem-compra.nr-dias-taxa) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>% Desc:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_desc" value="' + trim(STRING(ordem-compra.perc-descto,">9.99999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Valor Desconto:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_vl_descto" value="' + trim(STRING(ordem-compra.valor-descto,">>>,>>>,>>9.9999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Preco Liquido:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_pb" value="' + trim(STRING(d-preco-unit,">>>>>,>>>,>>9.99999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Preco Unit˜rio:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_pl" value="' + trim(STRING(d-pre-unit-for,">>>>>,>>>,>>9.99999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr> ' + */
/*             '        <tr> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Saldo:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="10" maxlength="10" name="w_sld" value="' + trim(STRING(de-quant-saldo,">>>,>>>,>>9.9999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '         <th align="right" class="linhaForm" nowrap>Valor Total:</th> ' + */
/*             '         <td class="linhaForm" align="right" nowrap> ' + */
/*             '            <input class="fill-in" type="text" size="20" maxlength="10" name="w_vl_tot" value="' + trim(STRING(d-pre-unit-for * de-quant-saldo,">>>>>,>>>,>>9.99999")) + '" readonly> ' + */
/*             '         </td> ' + */
/*             '        </tr> ' + */
/*             '        <tr><td height="5"></td></tr> ' + */
/*             '      </table>   ' + */
/*             '     </fieldset> ' + */
/*             '   </center> ' + */
/*             '  </td> ' + */
/*             ' </tr> ' + */
/*             '</div> ' + */
/*             '<br><br><br><br><br><br><br><br><br><br><br> '. */
/*    */
/*             ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*             ' <a name="cotacao' + STRING(ordem-compra.numero-ordem) + '"></a> ' + */
/*             ' <div align="center"><center>' + */
/*             '  <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' + */
/*             '   <tr>' + */
/*             '    <td class="barratitulo">Cotacao da Ordem - ' + STRING(ordem-compra.numero-ordem) +  '</td>' + */
/*             '   </tr>' + */
/*             ' </table> ' + */
/*             ' <br>  ' + */
/*             ' <table class="tableForm" align="center">' + */
/*             '    <tr>' + */
/*             '     <td align="center"  class="ColumnLabel" >C«digo</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Nome Abreviado</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Data Cota?cao</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Prazo</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Un</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Moeda</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Pre?o Fornecedor</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Pre?o Unit Fornec</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >% IPI</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >IPI Inc</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Contato</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Cond Pagto</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Comprador</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Transp</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Aprov.</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Vl Desconto</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Vlr Frete</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Enc Fin</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Taxa Fin</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Dias Taxa</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >% Desc</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Quant Ordem</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >I.P.I</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Pre?o Lðquido</td>' + */
/*             '     <td align="center"  class="ColumnLabel" >Pre?o Total Cota?cao</td>' + */
/*             '    </tr>'. */
/*    */
/*             ASSIGN i-cont = 0. */
/*    */
/*    */
/*             /* detalha cotacoes */ */
/*    */
/*             FOR EACH  cotacao-item */
/*                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem */
/*                 AND   cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF */
/*                 NO-LOCK: */
/*                 FOR FIRST emitente FIELD(cod-emitente nome-abrev) */
/*                      WHERE emitente.cod-emitente = cotacao-item.cod-emitente */
/*                      NO-LOCK: END. */
/*                 if  l-preco-bruto = no then do: */
/*                     assign de-valor-ipi = ((cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi) / */
/*                                          (100 + cotacao-item.aliquota-ipi)). */
/*                 end. */
/*                 else do: */
/*                     if  cotacao-item.perc-descto > 0 then */
/*                         assign de-val-orig = (cotacao-item.pre-unit-for * 100) / */
/*                                               (100 - cotacao-item.perc-descto). */
/*                     else */
/*                        assign de-val-orig = cotacao-item.pre-unit-for. */
/*                     assign de-valor-ipi = ((de-val-orig * cotacao-item.aliquota-ipi) / */
/*                                       (100 + cotacao-item.aliquota-ipi)). */
/*                 end. */
/*    */
/*                 if cotacao-item.pre-unit-for >= de-valor-ipi then */
/*                    assign de-preco-mat = cotacao-item.pre-unit-for - de-valor-ipi. */
/*    */
/*                 run ccp/cc9020.p (input  no, */
/*                                   input  cotacao-item.cod-cond-pag, */
/*                                   input  cotacao-item.valor-taxa, */
/*                                   input  cotacao-item.nr-dias-taxa, */
/*                                   input  de-preco-mat, */
/*                                   output de-preco-mat). */
/*    */
/*                 assign de-total-item = ordem-compra.qt-solic */
/*                        de-preco-total-cot = (cotacao-item.preco-unit * ordem-compra.qt-solic). */
/*    */
/*                 ASSIGN i-cont = i-cont + 1. */
/*                 IF (i-cont MOD 2) = 0 THEN */
/*                     ASSIGN c-class = ' class="linhaBrowseImpar" '. */
/*                 ELSE */
/*                     ASSIGN c-class = ' class="linhaBrowsepar" ' . */
/*    */
/*                 ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*                 '    <tr>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + STRING(emitente.cod-emitente) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + emitente.nome-abrev + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.data-cotacao,"99/99/9999") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.prazo-entreg) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.un) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.mo-codigo) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + trim(STRING(cotacao-item.preco-fornec,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(cotacao-item.pre-unit-for,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(cotacao-item.aliquota-ipi,">>9.99")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + STRING(cotacao-item.codigo-ipi,"Sim/Ncao") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + cotacao-item.contato + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.cod-cond-pag) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + cotacao-item.cod-comprado + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.cod-transp) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.cot-aprovada,"Sim/Ncao") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + trim(STRING(cotacao-item.valor-descto,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(cotacao-item.valor-frete,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.taxa-financ,"Sim/Nao") + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + trim(STRING(cotacao-item.valor-taxa,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + STRING(cotacao-item.nr-dias-taxa) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(cotacao-item.perc-descto,">9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(de-total-item,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '      ' + trim(STRING(de-valor-ipi,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(de-preco-mat,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '     <td ' + c-class + '>' + */
/*                 '       ' + trim(STRING(de-preco-total-cot,">>>>>,>>>,>>9.99999")) + */
/*                 '     </td>' + */
/*                 '    </tr>'. */
/*             END. /* for each cotacao-item */ */
/*    */
/*             ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*             ' </table><br>'. */
/*    */
/*    */
/*             /* ?ltima compra */ */
/*    */
/*             find last  b-ordem use-index compra-item */
/*                  where b-ordem.it-codigo     = ordem-compra.it-codigo */
/*                  and   b-ordem.data-pedido <> ? */
/*                  and   b-ordem.num-pedido  <> pedido-compr.num-pedido */
/*                  NO-LOCK NO-ERROR. */
/*             IF AVAIL b-ordem THEN DO: */
/*                FOR FIRST b-emitente FIELD(cod-emitente nome-abrev) */
/*                     WHERE b-emitente.cod-emitente = b-ordem.cod-emitente */
/*                     NO-LOCK: END. */
/*    */
/*                ASSIGN de-utl-quant = 0. */
/*                FOR EACH  prazo-compra */
/*                    WHERE prazo-compra.numero-ordem = b-ordem.numero-ordem */
/*                    NO-LOCK: */
/*                     ASSIGN de-utl-quant = de-utl-quant + prazo-compra.quantidade. */
/*                 END. */
/*                 FOR FIRST moeda FIELD(mo-codigo descricao) */
/*                     WHERE  moeda.mo-codigo = i-moeda-doc */
/*                     NO-LOCK: END. */
/*                 ASSIGN c-utl-moeda    = (IF AVAIL moeda THEN moeda.descricao ELSE "") */
/*                        c-utl-natureza = {ininc/i01in274.i 04 b-ordem.natureza}. */
/*    */
/*                 ASSIGN de-preco-unit-conv = b-ordem.preco-unit. */
/*                 if b-ordem.mo-codigo <> 0 then do: */
/*                     run cdp/cd0812.p (input b-ordem.mo-codigo, */
/*                                       input 0, */
/*                                       input b-ordem.preco-unit, */
/*                                       input b-ordem.data-cotacao, */
/*                                       output de-cotacao). */
/*                     if  de-cotacao = ? then */
/*                         assign de-cotacao = 1. */
/*    */
/*                     ASSIGN de-preco-unit-conv =  de-cotacao. */
/*                 end. */
/*    */
/*                 ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*                 '  <table align="center" border="0" cellpadding="0" cellspacing="0" width="90%" class="tableForm">' + */
/*                 '  <tr>' + */
/*                 '    <td  class="barratitulo" align="center">Ultima Compra</td> ' + */
/*                 '  </tr>' + */
/*                 ' </table>'. */
/*    */
                                                                                                                                                  /*    */
/*                 ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*                 ' <table class="tableForm" align="center" border=0>' + */
/*                 '    <tr>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Fornecedor</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Pedido</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Data</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Natureza</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Un</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Moeda</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Preco Unit For</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >Quantidade</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >% IPI</td>' + */
/*                 '     <td align="center"  class="ColumnLabel" >% ICMS</td>' + */
/*                 '    </tr>' + */
/*                 '    <tr>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + string(b-emitente.nome-abrev) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + STRING(b-ordem.num-pedido) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + STRING(b-ordem.data-pedido,"99/99/9999") + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + STRING(c-utl-natureza) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + STRING(ITEM.un) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + STRING(c-utl-moeda) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(de-preco-unit-conv,">>>>>,>>>,>>9.99999")) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(de-utl-quant,">>>>>,>>>,>>9.99999")) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(b-ordem.aliquota-ipi,">>9.99")) + '</td>' + */
/*                 '     <td align="center"  class="linhaBrowsepar" >' + TRIM(STRING(b-ordem.aliquota-icm,">>9.99")) + '</td>' + */
/*                 '    </tr>' + */
/*                 '    </table>'. */
/*    */
/*             END. /* fim ?ltima compra */ */
/*    */
/*             ASSIGN tt-html.html-doc = tt-html.html-doc + */
/*             ' <table class="tableFormVoltar" align="center">' + */
/*             '  <tr>' + */
/*             '    <td class="linhaForm" align="center"><a href="#' + STRING(ordem-compra.numero-ordem) + '" class="linhaVoltar">Voltar</a></td> ' + */
/*             '  </tr>' + */
/*             ' </table><br>' + */
/*             ' </div>' + */
/*             '<br><br><br><br><br><br><br><br><br><br><br> ' + */
/*             '<br><br><br><br><br><br><br><br><br><br><br> ' */
/*             . */
/*    */
        END. /* for each ordem-compra - detalha ordem */
    END. /*fim funcao HTML reduzido*/
                                                                                                                                                                                                      
      assign tt-html.html-doc = tt-html.html-doc +       ' <tr><td class="linhaForm" align="right"><a href="#dados" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   '.


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

        /* Calculo do Valor da Cota?’o */
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
            (not movto-estoq.referencia begins "RF")          and /*movto gerado pelo Rec. F­sico*/
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

end.  

/** 
***  For each item
**/

/** fim-do-include  ce0506a.p 
**/




END PROCEDURE.


delete object h_api_cta_ctbl.
delete object h_api_ccusto.


PROCEDURE pi-rodape:
    /********************************************************************************
    ** Copyright DATASUL S.A. 
    ** Todos os Direitos Reservados.
    **
    ** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
    ** parcial ou total por qualquer meio, so podera ser feita mediante
    ** autorizacao expressa.
    *******************************************************************************/
    DEFINE VARIABLE c-class-notif AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-informado   AS CHAR       NO-UNDO.
    DEFINE VARIABLE i-cont-aprov  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-checked     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-sequencia-substring AS INTEGER    NO-UNDO.
    /*
    /**  Login Integrado
    **/
    def var v_hdl_login_integr          as HANDLE  no-undo.
    def var v_log_habilita_login_integr as LOGICAL no-undo.
    {include/i_dbvers.i}
    */

    FIND FIRST mla-tipo-doc-aprov 
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa    
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-LOCK NO-ERROR.

    /* Altera?’o realizada para corre??o na PQU e Orsa-Suzano - N’o retirar */
    FOR EACH mla-doc-pend-aprov 
         WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
           AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
           AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
           AND mla-doc-pend-aprov.chave-doc    = c-chave  NO-LOCK: /* pend?ncia atual */
    END.
    /* Fim altera?’o */

    FIND LAST mla-doc-pend-aprov 
         WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
           AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
           AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
           AND mla-doc-pend-aprov.chave-doc    = c-chave  
           AND mla-doc-pend-aprov.ind-situacao = 1
           AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
    '<input class="fill-in" type="hidden" name="hid_nr_trans"  value="' + string(mla-doc-pend-aprov.nr-trans) + '"> '.

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '<table border=0 width=50%> ' +
           '  <tr> ' +
           '  <td align=left> ' +
           '   <table border=0> ' +
           '     <tr> ' +
           '      <th class=linhaform align=right>C&oacute;digo Rejei&ccedil;&atilde;o:</th> ' +
           '       <td align=left>' +
           '        <select name="w_cod_rejeicao" class="fill-in">'.

    FOR EACH mla-rej-aprov NO-LOCK:
        ASSIGN tt-html.html-doc = tt-html.html-doc + '<option value="' + STRING(mla-REJ-APROV.cod-rejeicao) + '">' + string(mla-REJ-APROV.cod-rejeicao) + '-' + mla-REJ-APROV.des-rejeicao + IF mla-REJ-APROV.LOG-1 AND mla-tipo-doc-aprov.log-2 THEN "(Re-anÿlise)</option>" ELSE "</option>".
    END.

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '        </select></td></tr>' +
           '      </td>    ' +
           '      </tr> ' +
           '      <tr> ' +
           '       <th class=linhaform align=right>Narrativa:</th> ' +
           '       <td valign="midlle" align=left><textarea class="fill-in" name="w_narrativa_usuar" rows="3" cols="40"></textarea> ' +
           '      </td></tr> ' +
           '      </tr>'.

    /*
    /**  LOGIN Integrado
    **/
    /* If  Not Valid-handle(v_hdl_login_integr) Then                                                   */
    /*     Run btb/btapi910zb.p Persisten Set v_hdl_login_integr (Input 1).                            */
    /* If  Valid-handle(v_hdl_login_integr) Then                                                       */
    /*     Run pi_Login_Integr_Habilitado In v_hdl_login_integr (Output v_log_habilita_login_integr).  */


    Run pi_Login_Integr_Habilitado (Output v_log_habilita_login_integr).

    &IF "{&mguni_version}" > "2.06B" &THEN
      Find First usuar_mestre_ext Where usuar_mestre_ext.cod_usuario = p-cod-aprovador NO-LOCK NO-ERROR.
      IF  NOT v_log_habilita_login_integr OR NOT AVAIL usuar_mestre_ext THEN DO:
    &ELSE
      Find First usuar-mestre-ext Where usuar-mestre-ext.cod-usuario = p-cod-aprovador NO-LOCK NO-ERROR.
      IF  NOT v_log_habilita_login_integr OR NOT AVAIL usuar-mestre-ext THEN DO:
    &ENDIF

        /**  Login Senha **/
        ASSIGN tt-html.html-doc = tt-html.html-doc +           
               '       <th class=linhaform align=right>Senha EMS:</th>' +
               '       <td align=left>' +
               '        <input type="password" class="fill-in" name="w_senha_usuar" size="13" maxlength="12">' +
               '      </td></tr>'.
    END.
    */
    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '      <tr><td align=left colspan=2> '.

    /**  EPC para inserir outro bot’o no HTML **/
    for each tt-epc:
       delete tt-epc.
    end.
    create tt-epc.
    assign tt-epc.cod-event     = "NovoBotao"
           tt-epc.cod-parameter = "Documento"
           tt-epc.val-parameter = string(mla-tipo-doc-aprov.cod-tip-doc). 

    {include/i-epc201.i "NovoBotao"}

    FIND FIRST tt-epc 
         WHERE tt-epc.cod-event     = "NovoBotao" 
           AND tt-epc.cod-parameter = "NovoBotao"
           AND tt-epc.val-parameter <> "" NO-ERROR.
    IF AVAIL tt-epc THEN
        ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '       <input type="submit" name="action" value="' + TRIM(tt-epc.val-parameter) + '" class="button">'.
    /**  Fim EPC  **/

    ASSIGN tt-html.html-doc = tt-html.html-doc +
           '       <input type="submit" name="action" value="Aprovar"  class="button">' +
           '       <input type="submit" name="action" value="Rejeitar" class="button">' +
           '      </td></tr>      ' +

           '    </table>       ' + 
           '  </td>' +
           '  <td align=center>'.


    IF AVAIL mla-tipo-doc-aprov AND 
       (SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y" OR 
        SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y") THEN DO:

        ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '<table class="tableForm" align="center" width="100%">' +
           '   <tr>' +
           '      <td align="center"  class="ColumnLabel" colspan=2>Notificar os Seguites Usuÿrios</td>' +
           '   </tr>' +
           '   <tr>' +
           '      <th align="center"  class="ColumnLabel">Aprova&ccedil;&atilde;o</th>' +
           '      <th align="center"  class="ColumnLabel">Rejei&ccedil;&atilde;o</th>' +
           '   </tr>'
.

         {laphtml/mlahtmlrodape.i2 "aprova"}

         FIND FIRST mla-doc-pend-aprov 
              WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
                AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
                AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
                AND mla-doc-pend-aprov.chave-doc    = c-chave  
                AND mla-doc-pend-aprov.ind-situacao = 1
                AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

         {laphtml/mlahtmlrodape.i2 "rejeita"}

        ASSIGN tt-html.html-doc = tt-html.html-doc +
                                   '</tr>' +
                                   '</table>'.
  
  
        ASSIGN tt-html.html-doc = tt-html.html-doc +
               '  </td>' +
               '  </tr>' +
               '</table>'.

    END.
        ASSIGN tt-html.html-doc = tt-html.html-doc +    
               '  </td>' +
               '  </tr>' +
               '     <tr> ' +
               '      <td align=center>'.

    ASSIGN i-cont-aprov = 0.

    IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.log-1 = YES THEN DO:

        ASSIGN tt-html.html-doc = tt-html.html-doc +  
               '   <center> ' +
               '   <table border=0 width=80%> ' +
               '     <tr> ' +
               '      <td class=linhaform align=left>' +
               '        <fieldset><legend><b>Aprovacoes</b></legend>' + 
               '   <table border=0>'.


               FOR EACH  mla-doc-pend-aprov 
                   WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
                     AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
                     AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
                     AND mla-doc-pend-aprov.chave-doc    = c-chave  
                     AND mla-doc-pend-aprov.ind-situacao = 2
                     AND mla-doc-pend-aprov.historico    = NO NO-LOCK USE-INDEX pend-18 BY mla-doc-pend-aprov.nr-trans: 

                   FIND mla-tipo-aprov WHERE mla-tipo-aprov.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK NO-ERROR. 


                   ASSIGN i-cont-aprov = i-cont-aprov + 1.

                   IF mla-doc-pend-aprov.cod-usuar-altern = "" THEN 
                       FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.
                   ELSE
                       FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar-altern NO-LOCK NO-ERROR.


                   ASSIGN tt-html.html-doc = tt-html.html-doc + 
                                             '<tr> ' +
                                             '  <td colspan=2 class=linhaform align=left>' +
                                             '----------- N­vel ' + STRING(i-cont-aprov) + ' (' + mla-tipo-aprov.des-tip-aprov + ') ------------<br>' +
                                             '<b>Aprovado por: </b>' + usuar_mestre.cod_usuar + ' - ' + usuar_mestre.nom_usuario + '<br>' +
                                             '<b>Quando: </b>' + string(mla-doc-pend-aprov.dt-aprova,'99/99/9999') + ' as ' + substring(mla-doc-pend-aprov.char-1,1,8) +
                                             '  </td> ' +
                                             '</tr> ' +
                                             '<tr> ' +
                                             '  <td class=linhaform align=left valign=top>' +
                                             '      <b>Comentÿrio: </b>' + 
                                             '  </td>' +
                                             '  <td class=linhaform align=left>' + mla-doc-pend-aprov.narrativa-apr +
                                             '  </td>' +
                                             '</tr>'. 

               END.

    ASSIGN tt-html.html-doc = tt-html.html-doc +
               '        </table>' +

               '   </table> </table>'
               .
  
    END.


    /*
    /*****************************************************************************
    ** Procedure.: pi_Login_Integr_Habilitado
    ** Fun??o....: Retorna se a funcionalidade do Login Integrado est˜ habilitada
    *****************************************************************************/
    Procedure pi_Login_Integr_Habilitado:

        Def Output Param pLoginIntegrHabilit As Logical Initial No.

        &IF "{&mguni_version}" > "2.06B" &THEN
          Find First login_integr_so No-lock NO-ERROR.
          Assign pLoginIntegrHabilit = (Avail login_integr_so
                                        And login_integr_so.log_habtdo_login_integr).
        &ELSE
          Find First login-integr-so No-lock NO-ERROR.
          Assign pLoginIntegrHabilit = (Avail login-integr-so 
                                        And login-integr-so.log-habtdo-login-integr).
        &ENDIF.

    End Procedure. /* --- pi_Login_Integr_Habilitado - */
    */


END PROCEDURE.



