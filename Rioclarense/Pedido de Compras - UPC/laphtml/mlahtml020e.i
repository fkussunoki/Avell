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

DEF INPUT  PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT  PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT  PARAMETER table for tt-mla-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

DEFINE VARIABLE c-class       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-chave       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-chave       AS INTEGER     NO-UNDO.
def var i-empresa LIKE empresa.ep-codigo no-undo.
DEFINE VARIABLE c-empresa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-estado      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-equipto     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tag         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fm-equipto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ccusto      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-causa-padr  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sint-padr   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-interv-padr AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuar       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-manut       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-plano       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ord-orig    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-parada      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-equip-res   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-planejad    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-narrativa   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-servidor AS CHARACTER   NO-UNDO.

/**   Monta chave do documento
**/
{lap/mlachave.i}

FIND solic-serv WHERE
     solic-serv.nr-soli-serv = INTEGER(tt-mla-chave.valor[1])
     NO-LOCK NO-ERROR.

IF  solic-serv.cd-equipto <> "" THEN DO:
   FIND FIRST equipto WHERE 
       equipto.cd-equipto = solic-serv.cd-equipto 
       NO-LOCK NO-ERROR.
   IF  AVAIL equipto THEN 
       ASSIGN c-cod-estabel = equipto.cod-estabel.
END.
ELSE DO:
   FIND FIRST tag WHERE 
       tag.cd-tag = solic-serv.cd-tag 
       NO-LOCK NO-ERROR.
   IF  AVAIL tag THEN 
       ASSIGN c-cod-estabel = tag.cod-estabel.
END.
FIND estabelec WHERE
     estabelec.cod-estabel = c-cod-estabel
     NO-LOCK NO-ERROR.
IF  AVAIL estabelec THEN
    run cdp/cd9970.p (input  ROWID(estabelec),
                      output i-empresa).

FIND FIRST mla-param-aprov  where
    mla-param-aprov.ep-codigo   = i-empresa and
    mla-param-aprov.cod-estabel = c-cod-estabel
    NO-LOCK NO-ERROR.

ASSIGN c-estado = {ininc/i01in414.i 04 solic-serv.estado}.

FIND equipto WHERE
    equipto.cd-equipto = solic-serv.cd-equipto
    NO-LOCK NO-ERROR.
IF  AVAILABLE equipto THEN
    ASSIGN c-equipto = equipto.descricao.

FIND tag WHERE
    tag.cd-tag = solic-serv.cd-tag
    NO-LOCK NO-ERROR.
IF  AVAILABLE tag THEN
    ASSIGN c-tag = tag.descricao.

FIND fam-equipto WHERE
    fam-equipto.fm-equipto = solic-serv.fm-equipto
    NO-LOCK NO-ERROR.
IF  AVAILABLE fam-equipto THEN
    ASSIGN c-fm-equipto = fam-equipto.descricao.

FIND centro-custo WHERE
    centro-custo.cc-codigo = solic-serv.cc-codigo
    NO-LOCK NO-ERROR.
IF  AVAILABLE centro-custo THEN
    ASSIGN c-ccusto = centro-custo.descricao.

FIND causa-padrao WHERE
    causa-padrao.cd-causa-padr = solic-serv.cd-causa-padr
    NO-LOCK NO-ERROR.
IF  AVAILABLE causa-padrao THEN
    ASSIGN c-causa-padr = causa-padrao.descricao.

FIND sint-padrao WHERE
    sint-padrao.cd-sint-padr = solic-serv.cd-sint-padr
    NO-LOCK NO-ERROR.
IF  AVAILABLE sint-padrao THEN
    ASSIGN c-sint-padr = sint-padrao.descricao.

FIND interv-padrao WHERE
    interv-padrao.cd-interv-padr = solic-serv.cd-interv-padr
    NO-LOCK NO-ERROR.
IF  AVAILABLE interv-padrao THEN
    ASSIGN c-interv-padr = interv-padrao.descricao.

FIND usuar_mestre WHERE
    usuar_mestre.cod_usuar = solic-serv.nome-usua
    NO-LOCK NO-ERROR.
IF  AVAILABLE usuar_mestre THEN
    ASSIGN c-usuar = usuar_mestre.nom_usuar.

FIND manut WHERE
    manut.cd-manut = solic-serv.cd-manut
    NO-LOCK NO-ERROR.
IF  AVAILABLE manut THEN
    ASSIGN c-manut = manut.descricao.

&IF '{&bf_mat_versao_ems}' >= '2.06' &THEN
FIND ord-manut WHERE
    ord-manut.nr-ord-produ = solic-serv.nr-ord-orig
    NO-LOCK NO-ERROR.
IF  AVAILABLE ord-manut THEN
    ASSIGN c-ord-orig = ord-manut.des-man-corr.
&ENDIF

FIND mi-parada WHERE
    mi-parada.cd-parada = solic-serv.cd-parada
    NO-LOCK NO-ERROR.
IF  AVAILABLE mi-parada THEN
    ASSIGN c-parada = mi-parada.descricao.

FIND equipe WHERE
    equipe.cd-equipe = solic-serv.cd-equip-res
    NO-LOCK NO-ERROR.
IF  AVAILABLE equipe THEN
    ASSIGN c-equip-res = equipe.desc-equipe.

FIND mnt-planejador WHERE
    mnt-planejador.cd-planejado = solic-serv.cd-planejado
    NO-LOCK NO-ERROR.
IF  AVAILABLE mnt-planejador THEN
    ASSIGN c-planejad = mnt-planejador.nome.

FIND msg-solic-serv WHERE
    msg-solic-serv.nr-soli-serv = solic-serv.nr-soli-serv
    NO-LOCK NO-ERROR.
IF  AVAILABLE msg-solic-serv THEN
    ASSIGN c-narrativa = msg-solic-serv.msg-exp.

FIND FIRST empresa 
     WHERE empresa.ep-codigo = i-empresa
     NO-LOCK NO-ERROR.
IF  AVAIL empresa THEN
    ASSIGN c-empresa = empresa.nome.
if can-find(funcao where
          funcao.cd-funcao = "Integra_AED_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor =  trim(mla-param-aprov.servidor-asp) + "/mla205.asp ".

if can-find(funcao where
          funcao.cd-funcao = "Integra_MLA_EMS" and
          funcao.ativo     = yes) then 
    assign c-servidor = trim(mla-param-aprov.servidor-asp) .


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
ASSIGN tt-html.html-doc = tt-html.html-doc +
'   <meta http-equiv="Cache-Control" content="No-Cache">' +
'   <meta http-equiv="Pragma"        content="No-Cache">' +
'   <meta http-equiv="Expires"       content="0">' +
' </head>' +
' <body topmargin="0" leftmargin="0">' +
'<form method="post" action="' + c-servidor + '">' +
' <input class="fill-in" type="hidden" name="hid_param">' +
' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '">' +
' <input class="fill-in" type="hidden" name="hid_chave" value="' + replace(c-chave," ","**") + '">' +
' <input class="fill-in" type="hidden" name="hid_cod_usuar" value="' + string(p-cod-aprovador) + '">' +
' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +
' <input class="fill-in" type="hidden" name="hid_empresa" value="' + string(i-empresa) + '"> ' +
' <input class="fill-in" type="hidden" name="hid_estabel" value="' + c-cod-estabel + '"> '.

/* Primeiro folder */
ASSIGN tt-html.html-doc = tt-html.html-doc +
' <a name="pagina1">' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Solicita‡Æo de Servi‡o - MI</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'     <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%" class="tableForm">' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Solicita‡Æo:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12" maxlength="12" name="w_nr-solic-serv" value="' + string(solic-serv.nr-soli-serv) + '" readonly>' +
'            </td>' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Data:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="10" maxlength="10" name="w_data" value="' + string(solic-serv.data,"99/99/9999") + '" readonly>' +
'            </td>' +
'          </tr>' +
'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Estado:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12"  maxlength="12" name="w_estado" value="' + string(c-estado) + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Hora:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' + 
'             <input class="fill-in" type="text" size="8" maxlength="8" name="w_hora" value="' + string(solic-serv.hora) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="50%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap>P gina 1</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#pagina2" class="aBrowser">P gina 2</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap width="27%">Descri‡Æo:</th>' +
'         <td class="linhaForm" align="left" nowrap colspan="3">' +
'            <input class="fill-in" type="text" size="50" maxlength="50" name="w_descricao" value=" ' + string(solic-serv.descricao) + ' " readonly>' +
'         </td>' +                                                                                     
'        </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Equipamento:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="16" maxlength="16" name="w_equipamento" value="' + string(solic-serv.cd-equipto) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_equipamento" value="' + c-equipto + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Tag:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="16" maxlength="16" name="w_tag" value="' + string(solic-serv.cd-tag) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_tag" value="' + c-tag + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Fam¡lia:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_fm_equipto" value="' + string(solic-serv.fm-equipto) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_familia" value="' + c-fm-equipto + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Centro Custo:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_c_custo" value="' + string(solic-serv.cc-codigo) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_ccusto" value="' + c-ccusto + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Causa:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_causa" value="' + string(solic-serv.cd-causa-padr) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_causa" value="' + c-causa-padr + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Sintoma:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_sintoma" value="' + string(solic-serv.cd-sint-padr) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_sintoma" value="' + c-sint-padr + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Interven‡Æo:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_intervencao" value="' + string(solic-serv.cd-interv-padr) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_intervencao" value="' + c-interv-padr + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Usu rio:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="20" maxlength="20" name="w_usuario" value="' + string(solic-serv.nome-usua) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_usuario" value="' + c-usuar + '" readonly>' +
'        </td>' +
'       </tr>'.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = tt-html.html-doc +
'       <tr><td height="5"></td></tr>' +
'     </table>  ' +
'    </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  ' +
' </tr> ' +
'   <tr>'.

{laphtml/mlahtmlrodape.i}

ASSIGN tt-html.html-doc = tt-html.html-doc +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

/* Segundo Folder */
CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = tt-html.html-doc +
'<center>' +
' <a name="pagina2">' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Solicita‡Æo de Servi‡o - MI</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'     <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%" class="tableForm">' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Solicita‡Æo:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12" maxlength="12" name="w_nr-solic-serv" value="' + string(solic-serv.nr-soli-serv) + '" readonly>' +
'            </td>' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Data:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="10" maxlength="10" name="w_data" value="' + string(solic-serv.data,"99/99/9999") + '" readonly>' +
'            </td>' +
'          </tr>' +
'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Estado:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12"  maxlength="12" name="w_estado" value="' + string(c-estado) + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Hora:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' + 
'             <input class="fill-in" type="text" size="8" maxlength="8" name="w_hora" value="' + string(solic-serv.hora) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="50%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap><a href="#pagina1" class="aBrowser">P gina 1</a></th>' +
'            <td align="right" class="linhaForm" nowrap>P gina 2</th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#narrativa" class="aBrowser">Narrativa</a></th>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%">' +
'        <tr><td height="5"></td></tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Data In¡cio:</th>' +
'        <td class="linhaForm" colspan=3 align="left" nowrap>' +
'           <input class="fill-in" type="text" size="10" maxlength="10" name="w_data_inicio" value="' + string(solic-serv.dt-inicio,"99/99/9999") + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Data T‚rmino:</th>' +
'        <td class="linhaForm" colspan=3 align="left" nowrap>' +
'           <input class="fill-in" type="text" size="10" maxlength="10" name="w_data_termino" value="' + string(solic-serv.dt-termino,"99/99/9999") + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Manuten‡Æo:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="8" maxlength="8" name="w_manutencao" value="' + string(solic-serv.cd-manut) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_manutencao" value="' + c-manut + '" readonly>' +
'        </td>' +
'       </tr>' +
&IF '{&bf_mat_versao_ems}' >= '2.06' &THEN
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Ordem:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="9" maxlength="9" name="w_ordem" value="' + string(solic-serv.nr-ord-orig) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_ordem" value="' + c-ord-orig + '" readonly>' +
'        </td>' +
'       </tr>' +
&ENDIF
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Prioridade:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="5" maxlength="5" name="w_prioridade" value="' + string(solic-serv.prioridade) + '" readonly>' +
'        </td>' +
'       </tr>' +
'        <tr>' +
'        <th align="right" class="linhaForm" nowrap>&nbsp;</th>' +
'        <td class="linhaForm" align="left" nowrap>'.

IF  solic-serv.parada THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
'           <input type="checkbox" name="w_manut_parada" value="" disabled checked>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
'           <input type="checkbox" name="w_manut_parada" value="" disabled>'.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = tt-html.html-doc +
'           Manuten‡Æo Parada' +
'         </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Parada:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="15" maxlength="15" name="w_parada" value="' + string(solic-serv.cd-parada) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_parada" value="' + c-parada + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Equipe Resp:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="15" maxlength="15" name="w_equipe" value="' + string(solic-serv.cd-equip-res) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_equipe" value="' + c-equip-res + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Planejador:</th>' +
'        <td class="linhaForm" align="left" nowrap>' +
'           <input class="fill-in" type="text" size="15" maxlength="15" name="w_planejado" value="' + string(solic-serv.cd-planejado) + '" readonly>' +
'          <input class="fill-in" type="text" size="60" maxlength="60" name="w_desc_planejado" value="' + c-planejad + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Vlr Or‡ado MAT:</th>' +
'        <td class="linhaForm" align="rigth" nowrap>' +
'           <input class="fill-in" type="text" size="20" maxlength="20" name="w_vlrorcadomat" value="' + string(solic-serv.vl-orcado-mat,">>>,>>>,>>9.99") + '" readonly>' +
'        </td>' +
'       </tr>' +
'       <tr>' +
'        <th align="right" class="linhaForm" nowrap>Vlr Or‡ado MOB:</th>' +
'        <td class="linhaForm" align="rigth" nowrap>' +
'           <input class="fill-in" type="text" size="20" maxlength="20" name="w_vlrorcadomob" value="' + string(solic-serv.vl-orcado-mob,">>>,>>>,>>9.99") + '" readonly>' +
'        </td>' +
'       </tr>'.

CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = tt-html.html-doc +
'       <tr><td height="5"></td></tr>' +
'     </table>  ' +
'    </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  '.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

/* Terceiro Folder */
CREATE tt-html.
ASSIGN i-cont = i-cont + 1
       tt-html.seq-html = i-cont.
ASSIGN tt-html.html-doc = tt-html.html-doc +
'<center>' +
' <a name="narrativa">' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Solicita‡Æo de Servi‡o - MI</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'     <fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%" class="tableForm">' +
'         <tr> ' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Solicita‡Æo:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12" maxlength="12" name="w_nr-solic-serv" value="' + string(solic-serv.nr-soli-serv) + '" readonly>' +
'            </td>' +
'            <th align="right" colspan=1 class="linhaForm" nowrap>Data:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="10" maxlength="10" name="w_data" value="' + string(solic-serv.data,"99/99/9999") + '" readonly>' +
'            </td>' +
'          </tr>' +
'          <tr>' +
'            <th align="right" class="linhaForm" nowrap>Estado:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' +
'             <input class="fill-in" type="text" size="12"  maxlength="12" name="w_estado" value="' + string(c-estado) + '" readonly>' +
'            </td>' +
'            <th align="right" class="linhaForm" nowrap>Hora:</th>' +
'            <td class="linhaForm" colspan=3 align="left" nowrap>' + 
'             <input class="fill-in" type="text" size="8" maxlength="8" name="w_hora" value="' + string(solic-serv.hora) + '" readonly>' +
'            </td>' +
'          </tr>' +
'        </table>' +
'      </fieldset>' +
'        <table align="center" border="0" cellpadding="0" cellspacing="1" width="50%">' +
'          <tr>' +
'            <td align="right" class="linhaForm" nowrap><a href="#pagina1" class="aBrowser">P gina 1</a></th>' +
'            <td align="right" class="linhaForm" nowrap><a href="#pagina2" class="aBrowser">P gina 2</a></th>' +
'            <td align="right" class="linhaForm" nowrap>Narrativa</th>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </tr>' +
'        </table>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="90%">' +
'        <tr><td height="5"></td></tr>' +
'        <tr><td height="5"></td></tr>' +
'        <tr>' +
'         <td class="linhaForm" align="center" nowrap>' +
'           <textarea class="fill-in" name="w_narrativa" rows="15" cols="120" readonly>' + c-narrativa +  '</textarea>' +
'         </td>' +
'        </tr> ' +
'        <tr><td height="5"></td></tr>' +
'        </table>' +
'      </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
' </table>  ' +
'</div>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'  </form>' +
' </body> ' +
'</html>'.

IF  mla-param-aprov.log-atachado THEN
    FOR EACH tt-html:
        ASSIGN tt-html.html-doc = codepage-convert(tt-html.html-doc,"iso8859-1","ibm850").
    END.

/* OUTPUT TO c:~\temp~\espec020e.html.               */
/* FOR EACH  tt-html:                              */
/*     PUT UNFORMATTED tt-html.html-doc AT 1 SKIP. */
/* END.                                            */
/* OUTPUT CLOSE.                                   */

