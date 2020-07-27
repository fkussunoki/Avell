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
{cdp/cdcfgmat.i}    
{utp/ut-glob.i}


DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-mla-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.



DEF VAR c-class AS CHAR NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
def var c-chave as char no-undo.
def var i-chave as integer no-undo.
def var i-empresa LIKE empresa.ep-codigo no-undo.
DEF VAR c-un           AS CHAR FORMAT "x(02)".
DEF VAR c-desc-item    AS CHAR FORMAT "x(60)".
DEF VAR c-ct-codigo    AS CHAR FORMAT "x(20)".
DEF VAR c-sc-codigo    AS CHAR FORMAT "x(20)".
DEF VAR c-narrativa    AS CHAR FORMAT "x(76)".

DEF VAR c-cod-usuar-doc      LIKE mla-usuar-aprov.cod-usuar.
DEF VAR c-nome-usuario-doc   LIKE mla-usuar-aprov.nome-usuar.

/**   Monta chave do documento
**/
{lap/mlachave.i}

DEF VAR c-descricao   AS CHAR NO-UNDO.
DEF VAR c-cod-utiliz  AS CHAR NO-UNDO.
DEF VAR c-desc-util   AS CHAR NO-UNDO.
DEF VAR c-desc-ref    AS CHAR NO-UNDO.
DEF VAR c-desc-conta  AS CHAR NO-UNDO.
DEF VAR c-desc-ccusto AS CHAR NO-UNDO.
DEF VAR c-desc-un     AS CHAR NO-UNDO.
DEF VAR de-preco      AS DEC  NO-UNDO.
DEF VAR urgente       AS LOG  NO-UNDO.
DEF VAR homologa      AS LOG  NO-UNDO.
DEF VAR afeta-qlde    AS LOG  NO-UNDO.
DEF VAR cb-prioridade AS CHAR NO-UNDO.
DEF VAR c-lista-prioridade AS CHAR NO-UNDO.
DEF VAR c-desc-estab       AS CHAR NO-UNDO.
DEF VAR c-desc-empresa     AS CHAR NO-UNDO.
DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel  NO-UNDO.
def var d-valor-total  as dec no-undo.

DEFINE VARIABLE c-servidor AS CHARACTER   NO-UNDO.

/* Include de definição de variáveis Unificação de conceitos */
{laphtml/mlaUnifDefine.i}
/* Handle da API Conta Cont bil e Centro de Custo */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
run prgint/utb/utb742za.py persistent set h_api_ccusto. 

FIND FIRST it-requisicao 
     WHERE it-requisicao.nr-requisicao = integer(tt-mla-chave.valor[1])
     AND   it-requisicao.sequencia     = integer(tt-mla-chave.valor[2])
     AND   it-requisicao.it-codigo     = STRING(tt-mla-chave.valor[3])
     NO-LOCK NO-ERROR.


find requisicao where
    requisicao.nr-requisicao = it-requisicao.nr-requisicao
    no-lock no-error.

&if defined(bf_mla_ambiente_magnus) &then  
find mla-usuar-aprov where
    mla-usuar-aprov.cod-usuar = USERID("mgadm")
    no-lock no-error.
&else 

find mla-usuar-aprov 
     WHERE mla-usuar-aprov.cod-usuar = requisicao.nome-abrev
     no-lock no-error.

&endif   

IF NOT AVAIL mla-usuar-aprov THEN NEXT.


FIND estabelec WHERE estabelec.cod-estabel = it-requisicao.cod-estabel NO-LOCK NO-ERROR.

IF AVAIL estabelec THEN
   run cdp/cd9970.p (input  ROWID(estabelec),
                     output i-empresa).

FIND FIRST mla-param-aprov 
     WHERE mla-param-aprov.ep-codigo = i-empresa 
     AND mla-param-aprov.cod-estabel = it-requisicao.cod-estabel
     NO-LOCK NO-ERROR.

ASSIGN c-cod-estabel = it-requisicao.cod-estabel.

assign c-desc-conta  = ""
       c-desc-ccusto = "".

if p-cod-tip-doc = 1 then do:          /*Somente para tipo de documento: 1  - Solicita‡Æo de Compra por Item */
                                          
   find first cotacao-item         /*Para buscar o pre‡o unit rio da cota‡Æo do item.*/
        where cotacao-item.numero-ordem = it-requisicao.numero-ordem
          and cotacao-item.cot-aprovada = yes
           no-lock no-error.
   if avail cotacao-item then do:
      FIND FIRST ordem-compra NO-LOCK
           WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-ERROR.
      
       find item-uni-estab 
      where item-uni-estab.cod-estabel = it-requisicao.cod-estabel 
        and item-uni-estab.it-codigo   = it-requisicao.it-codigo 
         no-lock no-error.
    
      if avail ordem-compra               and 
         avail item-uni-estab             and 
         item-uni-estab.variacao-perm > 0 and 
         item-uni-estab.variacao-perm <> 999  then do:

         if (((cotacao-item.preco-unit * 100) / it-requisicao.preco-unit) - 100) >   /*Verifica se o pre‡o unit rio da cota‡Æo*/
            item-uni-estab.variacao-perm then do:                                    /*ultrapassa a variavel permitida(cd0138) */
            assign d-valor-total = cotacao-item.preco-unit  * ordem-compra.qt-solic  /*it-requisicao.qt-requisitada*/
                   de-preco      = cotacao-item.preco-unit.
         end.
         else do:
            assign d-valor-total = it-requisicao.preco-unit * it-requisicao.qt-requisitada
                   de-preco      = it-requisicao.val-item / it-requisicao.qt-a-atender.   /*pre‡o unit rio*/
            IF de-preco = ? OR de-preco = 0  THEN                                 
               ASSIGN de-preco = 0.
         end.
      end.
   end.
   else do:
      assign d-valor-total = it-requisicao.preco-unit * it-requisicao.qt-requisitada
             de-preco      = it-requisicao.val-item / it-requisicao.qt-a-atender.   /*pre‡o unit rio*/
                                                                         
      IF de-preco = ? OR de-preco = 0  THEN                                 
         ASSIGN de-preco = 0.       
   end.
end.
else do:
   assign d-valor-total = it-requisicao.preco-unit * it-requisicao.qt-requisitada
          de-preco      = it-requisicao.val-item / it-requisicao.qt-a-atender.   /*pre‡o unit rio*/
                                                                         
   IF de-preco = ? OR de-preco = 0  THEN                                 
      ASSIGN de-preco = 0.                                               

end.


{utp/ut-liter.i Muito_Alta * r}
assign c-lista-prioridade = trim(return-value).
{utp/ut-liter.i Alta * r}
assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
{utp/ut-liter.i M²dia * r}
assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
{utp/ut-liter.i Baixa MCE r}
assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
                                             
FIND FIRST empresa WHERE empresa.ep-codigo = i-empresa NO-LOCK NO-ERROR.
/* samila */

if  avail it-requisicao then do:
    find requisicao where requisicao.nr-requisicao = it-requisicao.nr-requisicao no-lock no-error.
    
    ASSIGN c-cod-usuar-doc = ""
           c-nome-usuario-doc = "".
    
    FIND FIRST mla-usuar-aprov
    WHERE mla-usuar-aprov.cod-usuar = requisicao.nome-abrev NO-LOCK NO-ERROR.
    
    IF AVAIL mla-usuar-aprov THEN
    ASSIGN c-cod-usuar-doc = mla-usuar-aprov.cod-usuar
           c-nome-usuario-doc = mla-usuar-aprov.nome-usuar.



    find first item where item.it-codigo = it-requisicao.it-codigo no-lock no-error.

    &if defined(bf_mla_ambiente_magnus) &then
    assign c-descricao = if avail item then item.descricao-1 + ITEM.descricao-2 else "":U
           c-cod-utiliz = "".
    &else
    assign c-descricao = if avail item then item.desc-item else "":U
           c-cod-utiliz = substring(it-requisicao.char-2,1,12).
    for first usuar-mater fields(char-1 cod-usuario log-1 log-2 sc-codigo
        lim-requis mo-codigo lim-solic tp-preco)
        where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock: end.

    IF AVAIL usuar-mater THEN DO:
      if substring(usuar-mater.char-1,1,1) = "y" then do:
          for first utilizacao-mater fields (cod-utiliz des-utiliz) where
               utilizacao-mater.cod-utiliz = substring(it-requisicao.char-2,1,12)
               no-lock: end.
          if avail utilizacao-mater then
              assign c-desc-util = utilizacao-mater.des-utiliz.
      end.
    END.
    &endif

    find referencia
        where referencia.cod-refer = it-requisicao.cod-refer no-lock no-error.
    assign c-desc-ref = if avail referencia then referencia.descricao else "":U.

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
    {laphtml/mlaUnifBuscaCC.i i-empresa it-requisicao.sc-codigo today}
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        ASSIGN c-desc-ccusto = "".
    end.
    else
        ASSIGN c-desc-ccusto = v_titulo_ccusto.    
    
    
    /******** Unificação de conceitos, buscando formatos ********/
    {laphtml/mlaUnifFormatos.i i-empresa today}  
    if c-formato-conta <> "" then
        assign c-ct-codigo = string(it-requisicao.ct-codigo, c-formato-conta).
    else
        assign c-ct-codigo = it-requisicao.ct-codigo.
        
    if c-formato-ccusto <> "" then
        assign c-sc-codigo = string(it-requisicao.sc-codigo, c-formato-ccusto).
    else
        assign c-sc-codigo = it-requisicao.sc-codigo. 
    
    
    &if defined(bf_mla_ambiente_magnus) &then
    find tab-unidade where tab-unidade.un = substring(it-requisicao.char-1,1,2) no-lock no-error.
    &else
    find tab-unidade where tab-unidade.un = it-requisicao.un no-lock no-error.
    &endif
    assign c-desc-un = if avail tab-unidade then tab-unidade.descricao else "":U.

end.

if  avail it-requisicao then do:    
    if  it-requisicao.log-1 = yes then
        assign urgente = yes.
    else
        assign urgente = no.
    if  it-requisicao.log-2 = yes then
        assign homologa = yes.
    else
        assign homologa = no.
    if  substr(it-requisicao.char-1,1,1) = "Y" then
        assign afeta-qlde = yes.
    else
        assign afeta-qlde = no.
        
end.

&if defined(bf_mla_ambiente_magnus) &then
ASSIGN cb-prioridade = "".
&else
if available it-requisicao then do:
    if  it-requisicao.prioridade-aprov >= 0   and
        it-requisicao.prioridade-aprov <= 300 then
        assign cb-prioridade = entry(4,c-lista-prioridade).
    if  it-requisicao.prioridade-aprov >  300 and
        it-requisicao.prioridade-aprov <= 600 then
        assign cb-prioridade = entry(3,c-lista-prioridade).
    if  it-requisicao.prioridade-aprov >  600 and
        it-requisicao.prioridade-aprov <  999 then
        assign cb-prioridade = entry(2,c-lista-prioridade).
    if  it-requisicao.prioridade-aprov =  999 then
        assign cb-prioridade = entry(1,c-lista-prioridade).
end.
&endif

FIND FIRST estabelec
     WHERE estabelec.cod-estabel = it-requisicao.cod-estabel
     NO-LOCK NO-ERROR.
IF AVAIL estabelec THEN 
   ASSIGN c-desc-estab = estabelec.nome.
ELSE
   ASSIGN c-desc-estab = "".

FIND FIRST estabelec WHERE                                  
     estabelec.cod-estabel = it-requisicao.cod-estabel
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
ASSIGN tt-html.seq-html = 1.
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
'        BACKGROUND: white ' +
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
'</style>'.

&if defined(bf_mla_ambiente_magnus) &then
ASSIGN c-un = substring(it-requisicao.char-1,1,2)
       c-ct-codigo = string(it-requisicao.ct-codigo)
       c-sc-codigo = STRING(it-requisicao.sc-codigo)
       c-narrativa = it-requisicao.narrativa[1].
&else
ASSIGN c-un = it-requisicao.un
       c-ct-codigo = string(it-requisicao.ct-codigo)
       c-sc-codigo = STRING(it-requisicao.sc-codigo)
       c-narrativa = it-requisicao.narrativa.
&endif

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
' <body topmargin="0" leftmargin="0"> ' +
'<form>' +
' <input class="fill-in" type="hidden" name="hid_param"> ' +
' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '"> ' +
' <input class="fill-in" type="hidden" name="hid_chave" value="' + replace(c-chave," ","**") + '"> ' +
' <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '"> ' +
' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +

' <input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
' <input class="fill-in" type="hidden" name="hid_estabel" value="' + requisicao.cod-estabel + '"> ' +

' <div align="center"><center> ' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
'     <tr> ' +
'       <td class="barratitulo">Solicita‡Æo (Item)</td> ' +
'     </tr> ' +
'     <tr> ' +
'      <td> ' +
'        <fieldset> ' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%"> ' +
'         <tr><td height="5"></td></tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" colspan=1 nowrap> ' +
'              Empresa:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(i-empresa) + '" readonly>' + 
'              <input type="text" class="fill-in" size="60" name="razaosocial" value="' + STRING(c-desc-empresa) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" colspan=1 nowrap> ' +
'              Estabelecimento:               ' +
'          </th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="empresa" value="' + STRING(it-requisicao.cod-estabel) + '" readonly>' + 
'              <input type="text" class="fill-in" size="60" name="razaosocial" value="' + STRING(c-desc-estab) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Requisi‡Æo:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="w_requis" value="' + STRING(it-requisicao.nr-requisicao) + '" readonly> ' +
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Seq :               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="15" name="w_seq" value="' + STRING(it-requisicao.sequencia) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Item: ' +              
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="16" name="w_item" value="' + STRING(it-requisicao.it-codigo) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_item" value="' + c-descricao + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Referˆncia:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="20" name="w_refer" value="' + STRING(it-requisicao.cod-refer) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_refer" value="' + c-desc-ref  + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Qtde Requisitada:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="w_qtde_requis" value="' + STRING(it-requisicao.qt-a-atender) + '" readonly> ' +
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Data Entrega:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="12" name="w_data_entrega" value="' + STRING(it-requisicao.dt-entrega,"99/99/9999") + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>  ' +
'              UM:                ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="16" name="w_un" value="' + STRING(c-un) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_un" value="' + c-desc-un + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Ordem Invest:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="w_ordem_invest" value="' + STRING(it-requisicao.num-ord-inv) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              C¢digo da Utiliza‡Æo:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="10" name="w_cod_utiliz" value="' + STRING(c-cod-utiliz) + '"  readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_utilz" value="' + c-desc-util  + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Centro Custo:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="25" name="w_centro_custo" value="' + STRING(c-sc-codigo) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_cc" value="' + c-desc-ccusto + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Conta:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="25" name="w_conta" value="' + STRING(c-ct-codigo) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_conta" value="' + c-desc-conta + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Pre‡o Unit:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="20" name="w_preco" value="' + TRIM(STRING(de-preco,">>>>>,>>>,>>9.9999")) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Valor Total:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="20" name="w_vl_tot" value="' + TRIM(STRING(d-valor-total,">>>>>,>>>,>>9.9999")) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'          <th align="right" class="linhaForm" nowrap> ' +
'              Requisitante:               ' +
'          </th> ' +
'          <td align="left" class="linhaForm" nowrap colspan="3"> ' +
'              <input type="text" class="fill-in" size="20" name="w_usuar_doc" value="' + STRING(c-cod-usuar-doc) + '" readonly> ' +
'              <input type="text" class="fill-in" size="55" name="w_desc_item" value="' + STRING(c-nome-usuario-doc) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr><td height="5"></td></tr> ' +
'         </table> ' +
'        </fieldset>   ' +
'        <fieldset> ' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%"> ' +
'         <tr><td height="5"></td></tr> ' +
'         <tr> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF urgente = YES THEN
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <label for="urgente"><input type="checkbox" id="urgente" name="w_urgente" value="" disabled checked> '.
ELSE
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="checkbox" name="w_urgente" value="" disabled> '.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'              Urgente </label>' +
'          </td> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF homologa = YES THEN
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="checkbox" name="w_hom_fornec" value="" disabled checked> '.
ELSE
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="checkbox" name="w_hom_fornec" value="" disabled> '.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'              Homologa Fornecedor ' +
'          </td> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF afeta-qlde = YES THEN
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="checkbox" name="w_afeta" value="" disabled checked> '.
ELSE
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="checkbox" name="w_afeta" value="" disabled> '.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'              Afeta Qualidade ' +
'          </td> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              Prior. Aprov.: ' +
'              <input type="text" class="fill-in" size="20" name="w_prior" value="' + cb-prioridade + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr><td height="5"></td></tr> ' +
'         </table> ' +
'        </fieldset>   ' +
'         <fieldset> ' +
'          <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%"> ' +
'           <tr><td height="2"></td></tr> ' +
'           <tr> ' +
'            <td align="center" class="linhaForm" nowrap> ' +
'                <textarea class="fill-in" name="w_narrativa" rows="3" cols="130" readonly>' + c-narrativa + '</textarea> ' +
'            </td> ' +
'           </tr> ' +
'           <tr><td height="2"></td></tr> ' +
'          </table> ' +
'          </fieldset>   ' +
'      </td>   ' +
'     </tr> ' +
'   </table>' +
'   </div>' +
'   </form>' +
'   <form method="get" action="' + c-servidor + '">' +
'   <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '"> ' +
'   <div align="center">'.

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
'   </div>       '                          +
'  </form>    ' +
' </body>  ' +
'</html> ' .

IF mla-param-aprov.log-atachado and index(proversion,"webspeed") = 0 THEN
    FOR EACH tt-html:
        ASSIGN tt-html.html-doc = codepage-convert(tt-html.html-doc,"iso8859-1","ibm850").
    END.

delete object h_api_cta_ctbl.
delete object h_api_ccusto.
