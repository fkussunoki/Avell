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
 
DEF VAR c-class        AS CHAR NO-UNDO.
DEF VAR i-cont         AS INTEGER NO-UNDO.
def var c-chave        as char no-undo.
def var i-chave        as integer no-undo.
DEF VAR situacao       AS CHAR NO-UNDO.
def var i-empresa      LIKE empresa.ep-codigo no-undo.
DEF VAR c-narrativa    AS CHAR FORMAT "X(2000)".
DEF VAR c-un           AS CHAR FORMAT "x(02)".
DEF VAR de-preco-item  AS DEC  FORMAT "->,>>>,>>>,>>9.99".
DEF VAR de-total-item  AS DEC  FORMAT "->,>>>,>>>,>>9.99".
DEF VAR c-ct-codigo AS CHAR FORMAT "x(20)".
DEF VAR c-sc-codigo AS CHAR FORMAT "x(20)".
DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel  NO-UNDO.
DEFINE VARIABLE c-servidor AS CHARACTER   NO-UNDO.

/* Include de definição de variáveis Unificação de conceitos */
{laphtml/mlaUnifDefine.i}
/* Handle da API Conta Cont bil e Centro de Custo */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
run prgint/utb/utb742za.py persistent set h_api_ccusto. 

/**   Monta chave do documento
**/
{lap/mlachave.i}

find first requisicao 
     WHERE requisicao.nr-requisicao = integer(tt-mla-chave.valor[1])
     no-lock no-error.

&if defined(bf_mla_ambiente_magnus) &then
    assign c-seg-usuario = USERID("mgadm").
&endif
    
find mla-usuar-aprov where
    mla-usuar-aprov.cod-usuar = c-seg-usuario
    no-lock no-error.

FIND estabelec WHERE
     estabelec.cod-estabel = requisicao.cod-estabel
     NO-LOCK NO-ERROR.
IF AVAIL estabelec THEN
   run cdp/cd9970.p (input  ROWID(estabelec),
                     output i-empresa).
ASSIGN c-cod-estabel =  estabelec.cod-estabel.

FIND FIRST mla-param-aprov  where
    mla-param-aprov.ep-codigo   = i-empresa and
    mla-param-aprov.cod-estabel = requisicao.cod-estabel
    NO-LOCK NO-ERROR.

FIND FIRST mguni.empresa WHERE mguni.empresa.ep-codigo = i-empresa NO-LOCK NO-ERROR.
    
/**   Outros display's
**/
def var de-tot-doc as dec no-undo.
def var c-desc-estabel as char no-undo.
def var c-nome-requis as char no-undo.    
def var c-desc-item as char no-undo.
def var c-desc-conta AS CHAR NO-UNDO.
def var c-desc-ccusto AS CHAR NO-UNDO.
DEF VAR lotacao  AS char NO-UNDO.
DEF VAR des-lot AS CHAR NO-UNDO.


if available estabelec then
    assign c-desc-estabel = estabelec.nome.
else
    assign c-desc-estabel = "".

find first mla-usuar-aprov where
    mla-usuar-aprov.cod-usuar = requisicao.nome-abrev
    no-lock no-error.
if available mla-usuar-aprov then
    assign c-nome-requis = mla-usuar-aprov.nome.
else
    assign c-nome-requis = "".    


IF AVAIL mla-usuar-aprov THEN DO:
   ASSIGN lotacao = mla-usuar-aprov.cod-lotacao.
   FIND FIRST mla-lotacao
        WHERE mla-lotacao.ep-codigo   = i-empresa
        and   mla-lotacao.cod-lotacao = mla-usuar-aprov.cod-lotacao
        NO-LOCK NO-ERROR.
   IF AVAIL mla-lotacao THEN
       ASSIGN lotacao = mla-lotacao.cod-lotacao
              des-lot = mla-lotacao.desc-lotacao.
END.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.


ASSIGN
    tt-html.html-doc = '<html>' +
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
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif ' +
    '    } ' +
    '    .linhaForm ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;; COLOR:black; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .fill-in ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:black;background:white; ' +
    '    } ' +
    '    .tableForm ~{ ' +
    '        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
    '    } ' +
    '    .tableForm2 ~{ ' +
    '        BORDER-width: 0px inset;padding:0;  ' +
    '    } ' +
    '    .barraTitulo ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTotal ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: right; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTituloBrowse ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #ffffff; FONT-FAMILY: Arial; BACKGROUND-COLOR: #808080; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .selectedFolder ~{ ' +
    '        BACKGROUND-COLOR: white ' +
    '    } ' +
    '    .unselectedFolder ~{ ' +
    '        BACKGROUND-COLOR: #dcdcdc ' +
    '    } ' +
    '    .button ~{ ' +
    '    font-family:Verdana, Arial;font-size:xx-small;font-weight:bold;color:white;background:#e0b050;cursor:hand;width:80 ' +
    '    } ' +
    '    .linhaBrowsepar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#d2eef4 ' +
    '        } ' +
    '    .linhaBrowseimpar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#ffffff ' +
    '        } ' +
    '    .columnLabel ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#107f80 ' +
    '        } ' +
    '    .columnLabelSelected ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#20b0b0 ' +
    '        } ' +
    '    .linkOrdena ~{ ' +
    '        COLOR:white;text-decoration:none;  ' +
    '        } ' +
    '    .aBrowser ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowser:hover ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline ;  ' +
    '      }  ' +
    '   .aBrowserAcom ~{ ' +
    '      color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowserAcom:hover ~{ ' +
    '       color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline;  ' +
    '       } ' +
    '</style>' +
                  '<meta http-equiv="Cache-Control" content="No-Cache">' +
                  '<meta http-equiv="Pragma"        content="No-Cache">' +
                  '<meta http-equiv="Expires"       content="0">'.

&if defined(bf_mla_ambiente_magnus) &then
CASE requisicao.tp-requis:
    WHEN "S" THEN ASSIGN situacao = "Solicitacao".
    WHEN "R" THEN ASSIGN situacao = "Requisicao".
END CASE.
ASSIGN c-narrativa = requisicao.narrativa[1] +
                     requisicao.narrativa[2] +
                     requisicao.narrativa[3] +
                     requisicao.narrativa[4] +
                     requisicao.narrativa[5].

&else
ASSIGN situacao = {ininc/i03in385.i 4 requisicao.tp-requis}.
ASSIGN c-narrativa = requisicao.narrativa.
&endif

IF c-narrativa = ? THEN 
    ASSIGN c-narrativa = "".

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
                '</head>' +
                '<body topmargin="0" leftmargin="0">' +
                '<form method="GET" action="' + c-servidor + '">' +
                '<input class="fill-in" type="hidden" name="hid_param">' +
                '<input class="fill-in" type="hidden" name="hid_tp_docum" value="' + STRING(p-cod-tip-doc) + '">' +
                '<input class="fill-in" type="hidden" name="hid_chave" value="' + REPLACE(c-chave," ","**") + '">' +
                '<input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + STRING(p-cod-aprovador) + '">' +
                '<input class="fill-in" type="hidden" name="hid_senha"  value="1">' +
                
                '<input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
                '<input class="fill-in" type="hidden" name="hid_estabel" value="' + requisicao.cod-estabel + '"> ' +
                
                '<div align="center"><center>' +
                  '<table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
                    '<tr>' +
                      '<td class="barratitulo">Aprova‡Æo Eletr“nica</td>' +
                    '</tr>' +
                   '<tr>' +
                      '<td class="linhaForm" align="center"><center>' +
                        '<fieldset>' +
                          '<table align="center" border="0" cellpadding="0" cellspacing="1">' +
                          '         <tr> ' +
                          '          <th align="right" class="linhaForm" nowrap> ' +
                          '              Empresa:               ' +
                          '          </th> ' +
                          '          <td align="left" class="linhaForm" nowrap> ' +
                          '              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(empresa.ep-codigo) + '" readonly>' + 
                          '              <input type="text" class="fill-in" size="40" name="razaosocial" value="' + STRING(empresa.razao-social) + '" readonly> ' +
                          '          </td> ' +
                          '         </tr> ' +
                          '<tr>' +
                              '<th align="right" class="linhaForm" nowrap>Requisi‡Æo:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="7" maxlength="7" name="w_nr_requisicao" value=' + string(requisicao.nr-requis) + ' readonly></td>' +
                '</tr>' +
              '</table>' +
            '</fieldset>' +
            '<fieldset>' +
              '<table align="center" border="0" cellpadding="0" cellspacing="1">' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Estabelecimento:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="3" maxlength="3" name="w_cod_estabel" value="' + requisicao.cod-estabel + '" readonly>' +
                                                            '<input class="fill-in" type="text" size="40" maxlength="40" name="w_c_estab" value="' + c-desc-estabel + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Requisitante:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="12" maxlength="12" name="w_nome_abrev" value="' + requisicao.nome-abrev + '" readonly>' +
                                                            '<input class="fill-in" type="text" size="40" maxlength="40" name="w_c_nome_requis" value="' + c-nome-requis + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Lota‡Æo:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="24" maxlength="24" name="w_lot" value="' + lotacao + '" readonly>' +
                                                            '<input class="fill-in" type="text" size="40" maxlength="40" name="w_des_lot" value="' + des-lot + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Data Requisi‡Æo:</th>' +
                  '<td colspan="2" class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="10" maxlength="10" name="w_dt_requisicao" value="' + string(requisicao.dt-requis,"99/99/9999") + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Local Entrega:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="30" maxlength="30" name="w_loc_entrega" value="' + requisicao.loc-entrega + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" class="linhaForm" nowrap>Tipo Requisi‡Æo:</th>' +
                  '<td class="linhaForm" align="left" nowrap><input class="fill-in" type="text" size="31" maxlength="31" name="w_fi_tp_requis" value="' + situacao + '" readonly></td>' +
                '</tr>' +
                '<tr>' +
                  '<th align="right" valign="top" class="linhaForm" nowrap>Narrativa:</th>' +
                  '<td class="linhaForm" align="left" nowrap><textarea class="fill-in" name="w_narrativa" rows="3" cols="40" readonly>' + c-narrativa + '</textarea></td>' +
                '</tr>' +
              '</table>' +
            '</fieldset>' +
            '</center>' +
          '</td>' +
        '</tr>' +
      '</table>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
       '<table class="tableForm" align="center">'.

FOR EACH it-requisicao where
    it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:

    CREATE tt-html.
    ASSIGN i-cont = i-cont + 1
           tt-html.seq-html = i-cont.

    IF (i-cont MOD 2) = 0 THEN
        ASSIGN c-class = ' class="linhaBrowseImpar" ' .
    ELSE 
        ASSIGN c-class = ' class="linhaBrowsepar" '.

    /**  Outros display's
    **/
    find first item where
        item.it-codigo = it-requisicao.it-codigo
        no-lock no-error.
    if available item THEN DO:
        &if defined(bf_mla_ambiente_magnus) &then
        ASSIGN c-desc-item = ITEM.descricao-1 + ITEM.descricao-2.
        &else
        assign c-desc-item = item.desc-item.
        &endif
    END.
    else
        assign c-desc-item = "".

/*    &if defined(bf_mla_ambiente_magnus) &then
    find first conta -contab 
        WHERE conta -contab.ct-codigo = it-requisicao.ct-codigo
        AND   conta -contab.sc-codigo = it-requisicao.sc-codigo
        AND   conta -contab.ep-codigo = i-empresa 
        NO-LOCK NO-ERROR.
    &else
    find first conta -contab 
        WHERE conta -contab.conta -contabil = it-requisicao.conta -contabil
        AND   conta -contab.ep-codigo      = i-empresa 
        NO-LOCK NO-ERROR.
    &endif
    IF AVAILABLE conta -contab THEN
        assign c-desc-conta = conta -contab.titulo.
    else
        assign c-desc-conta = "". */
    
    /* Realiza a busca da conta contabil */
    assign v_cod_cta_ctbl = it-requisicao.ct-codigo.
    {laphtml/mlaUnifBuscaConta.i i-empresa v_cod_cta_ctbl requisicao.dt-requis}
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        ASSIGN c-desc-conta = "".
    end.
    else
        ASSIGN c-desc-conta = v_titulo_cta_ctbl.
    
    /* Realiza a busca do centro de custo */
    {laphtml/mlaUnifBuscaCC.i i-empresa it-requisicao.sc-codigo requisicao.dt-requis}
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        ASSIGN c-desc-ccusto = "".
    end.
    else
        ASSIGN c-desc-ccusto = v_titulo_ccusto.   
    
    &if defined(bf_mla_ambiente_magnus) &then
    assign de-tot-doc = de-tot-doc + it-requisicao.val-item
           c-un = substring(it-requisicao.char-1,1,2)
           de-preco-item = it-requisicao.val-item / it-requisicao.qt-requisitada
           de-total-item = it-requisicao.val-item.
    &else
    assign de-tot-doc = de-tot-doc + (it-requisicao.qt-requis * it-requisicao.preco-uni)
           c-un = it-requisicao.un
           de-preco-item = it-requisicao.preco-unit
           de-total-item = it-requisicao.qt-requis * it-requisicao.preco-unit.
    &endif
                      
    ASSIGN tt-html.html-doc = tt-html.html-doc + 
          '<tr>' +
          '<td align="center"  class="ColumnLabel" >Seq</td>' +
          '<td align="center"  class="ColumnLabel" >Item</td>' +
          '<td align="center"  class="ColumnLabel" >Descri‡Æo</td>' +
          '<td align="center"  class="ColumnLabel" >Un</td>' +
          '<td align="center"  class="ColumnLabel" >Quantidade</td>' +
          '<td align="center"  class="ColumnLabel" >Vl Unit rio</td>' +
          '<td align="center"  class="ColumnLabel" >Vl Total</td>' +
          '</tr>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc + 
          '<tr>' +
          '<td align=right ' + c-class + '>' +
          string(it-requisicao.sequencia) +
          '</td>' +
          '<td align=left  ' + c-class + '>' +
          it-requisicao.it-codigo +
          '</td>' +
          '<td align=left  ' + c-class + '>' +
          c-desc-item +
          '</td>' +
          '<td align=center ' + c-class + '>' +
          c-un +
          '</td>' +
          '<td align=right  ' + c-class + '>' +
          string(it-requisicao.qt-requis,">>>>>,>>>,>>9.9999") +
          '</td>' +
          '<td align=right  ' + c-class + '>' +
          STRING(de-preco-item,">>>>>,>>>,>>9.9999") +
          '</td>' +
          '<td align=right  ' + c-class + ' >' +
          STRING(de-total-item,">>>>>,>>>,>>9.9999") +
          '</td>' +
          '</tr>'.

    ASSIGN tt-html.html-doc = tt-html.html-doc + 
          '<tr>' +
          '<td align="left" valign="top" ' + c-class + ' colspan=5 >' +
          ' <table width="100%" cellpadding="0" cellspacing="2" border=0 align="center">' +
          ' <tr>' +
          '  <td align="center" class="ColumnLabel" >Dt Entrega</td>' +
          '  <td align="center" class="ColumnLabel" >Cod Utiliz</td>' +
          '  <td align="center" class="ColumnLabel" >Conta</td>' +
          '  <td align="center" class="ColumnLabel" >Descri‡Æo</td>' +
          '  <td align="center" class="ColumnLabel" >Centro Custo</td>' +
          '  <td align="center" class="ColumnLabel" >Descri‡Æo</td>' +
          '  <td align="right"  class="ColumnLabel" >Narrativa:</td>' +
          ' </tr>'.

    &if defined(bf_mla_ambiente_magnus) &then
    ASSIGN c-narrativa = it-requisicao.narrativa[1] +
                         it-requisicao.narrativa[2] +
                         it-requisicao.narrativa[3] +
                         it-requisicao.narrativa[4] +
                         it-requisicao.narrativa[5].
    &else
    ASSIGN c-narrativa    = it-requisicao.narrativa.
    &endif
    
    /******** Unificação de conceitos, buscando formatos ********/
    {laphtml/mlaUnifFormatos.i i-empresa requisicao.dt-requis}        
    if c-formato-conta <> "" then
        assign c-ct-codigo = string(it-requisicao.ct-codigo, c-formato-conta).
    else
        assign c-ct-codigo = it-requisicao.ct-codigo.
        
    if c-formato-ccusto <> "" then
        assign c-sc-codigo = string(it-requisicao.sc-codigo, c-formato-ccusto).
    else
        assign c-sc-codigo = it-requisicao.sc-codigo.     
    
    IF c-narrativa = ? THEN DO:
        ASSIGN c-narrativa = "".
    END.

    ASSIGN tt-html.html-doc = tt-html.html-doc + 
          ' <tr>' +
          '  <td align=right  ' + c-class + ' >' +
          string(it-requisicao.dt-entrega,"99/99/9999") +
          '</td>' +
          '  <td align=right  ' + c-class + ' >' +
          SUBSTRING(it-requisicao.char-2,1,12) +
          '</td>' +
          '  <td align=left  ' + c-class + ' >' +
          string(c-ct-codigo) +
          '</td>' +
          '  <td align=left  ' + c-class + ' >' +
          c-desc-conta +
          '</td>' +
          '  <td align=left  ' + c-class + ' >' +
          string(c-sc-codigo) +
          '</td>' +
          '  <td align=left  ' + c-class + ' >' +
          c-desc-ccusto +
          '</td>' +
          '  <td align=left  ' + c-class + ' >&nbsp;</td>' +
          ' </tr>' +
          ' </table>' +
          '</td>' +
          '<td align="left"  ' + c-class + ' colspan=3 >' +
          '<textarea class="fill-in" name="w_narrativa" rows="3" cols="37">' +
          c-narrativa + 
          '</textarea></td>' +
          '</tr>'.   
                      
END.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.

assign tt-html.html-doc = tt-html.html-doc + '<tr><td align=right colspan=7 class="barratotal">Valor Total do Documento: <b>' + string(de-tot-doc,">>>>>,>>>,>>9.9999") + '</b></td></tr>'.

ASSIGN 
    tt-html.html-doc = tt-html.html-doc + '</table></center>'.

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

ASSIGN 
    tt-html.html-doc = tt-html.html-doc +
               '</div>' +
               '</form>' +
             '</body>' +
             '</html>'.

IF mla-param-aprov.log-atachado and index(proversion,"webspeed") = 0 then
    FOR EACH tt-html:
        ASSIGN tt-html.html-doc = codepage-convert(tt-html.html-doc,"iso8859-1","ibm850").
    END.

delete object h_api_cta_ctbl.
delete object h_api_ccusto.

/*OUTPUT TO c:~\tmp~\espec002e.htm.
FOR EACH  tt-html:
    PUT tt-html.html-doc.
END.
OUTPUT CLOSE.*/
/* DOS SILENT VALUE("explorer c:~\Servicos~\Aprova~\espec.htm."). */
