/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CE0341RP 2.00.00.018 } /*** "010018" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ce0341rp MCE}
&ENDIF

/******************************************************************************
**
**       PROGRAMA: CE0341RP.P
**
**       DATA....: Abril de 1999
**
**       OBJETIVO: Resusprimento do Estoque
**
**       VERSAO..: 1.00.000
** 
******************************************************************************/
{include/i-rpvar.i}
{include/i-rpcab.i}
{ccp/ccapi012.i1} /* Definicao tt-ordem-compra e tt-prazo-compra */
{utp/ut-glob.i}
{cdp/cd0666.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{include/tt-edit.i}
/* Defini‡Æo de elementos referentes a EPC */
{include/i-epc200.i ce0341rp}
{method/dbotterr.i}
{cdp/cd0031.i "MCE"} /*Seguranca por Estabelecimento*/

/* Empresa do Usuario */
DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario AS CHARACTER NO-UNDO.

define buffer bRowErrors for RowErrors.
def var i-seq-erro as integer no-undo.

disable triggers for load of necessidade-oc.

def temp-table tt-msg NO-UNDO
    field nr-ordem     like ordem-compra.numero-ordem
    field comprador    like ordem-compra.cod-comprado
    field it-codigo    like it-requisicao.it-codigo
    field estabel      like ordem-compra.cod-estabel
    field conta        like ordem-compra.conta-contabil
    field pedido       like ordem-compra.num-pedido
    field qtd          like ordem-compra.qt-solic
    field natureza     as char format "x(12)"
    field situacao     as char format "x(12)"
    field origem       as char format "x(10)"
    field cond-pag     like ordem-compra.cod-cond-pag
    field despesa      like ordem-compra.tp-despesa
    field dt-emissao   like ordem-compra.data-emissao
    field narrativa    like ordem-compra.narrativa.

def temp-table tt-raw-digita
    field raw-digita as raw.

def temp-table tt-entrega NO-UNDO
        field cd-freq        like frequencia.cd-freq /*cod. da frequencia de */
        field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
        field dat-entrega    as date.
{cep/ce0341.i3}
def buffer b-ordem-compra for ordem-compra.
def buffer b-ordem        for ordem-compra.
def buffer b-prazo        for prazo-compra.
def buffer b-item         for item.

/*************************  Multi-Planta ************************************/
def var  i-tipo-movto   as integer    no-undo.
def var  l-cria         as logical    no-undo.

{cdp/cd7300.i1}
{mpp/mpapi011.i}
{cdp/cdcfgmat.i}

def buffer b-tt-dados-env  for tt-dados-env.
def temp-table tt-dados-env-aux NO-UNDO like tt-dados-env.


/************************* Fim Multi-Planta *********************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

def var l-per-cc       as logical init no no-undo.
def var i-per-corrente as integer no-undo.
def var i-ano-corrente as integer no-undo.
def var da-iniper-fech like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech like param-estoq.ult-fech-dia no-undo.
def var i-mes-aux      as integer no-undo format "99".
def var h-acomp        as handle  no-undo.
def var c-acompanha    as char    no-undo.
def var l-resposta     as logical init no  no-undo.
def var l-primeira     as logical init no  no-undo.
def var l-erro         as logical no-undo.
def var i-seq1         as integer no-undo.
def var l-gerou        as l       no-undo init no.
def var i-empresa like param-global.empresa-prin no-undo.
DEF VAR c-grp-cod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.

/* Vari¿veis p/ tradu¶’o */
def var c-lb-param    as char no-undo.
def var c-lb-digit    as char no-undo.
def var c-lb-ordem    as char no-undo.
def var c-lb-impr     as char no-undo.
def var c-lb-dest      as char no-undo.
def var c-lb-usuar     as char no-undo.
def var c-lb-selec     as char no-undo.
def var c-lb-classe    as char no-undo.
def var c-lb-gera      as char no-undo.
def var c-lb-ponto     as char no-undo.
def var c-lb-period    as char no-undo.
def var c-lb-divis     as char no-undo.
def var c-lb-dt-contr  as char no-undo.
def var c-lb-narra     as char no-undo.
def var c-lb-tit-par   as char no-undo.
def var c-lb-tit-sel   as char no-undo.
def var c-lb-natur     as char no-undo.
def var c-lb-situa     as char no-undo.
def var c-lb-pto-enc   as char no-undo.
def var c-lb-periodico as char no-undo.
def var c-lb-estab     as char no-undo.
def var c-lb-estabel   as char no-undo.
def var c-lb-ge        as char no-undo.
def var c-lb-fam       as char no-undo.
def var c-lb-item      as char no-undo.
def var c-lb-dt-gera   as char no-undo.
def var c-lb-tit-imp   as char no-undo.
def var c-lb-destino   as char no-undo.
def var c-lb-usuario   as char no-undo.
def var c-lb-msg       as char no-undo.
def var c-lb-erro      as char no-undo.
def var c-lb-compr     as char format "x(12)" no-undo.
def var c-lb-orig      as char no-undo.
def var c-lb-data      as char no-undo.
def var c-lb-desc     as char no-undo.
def var c-lb-cdp       as char no-undo.
def var c-lb-tipo      as char no-undo.
def var c-lb-qtd       as char format "x(5)" no-undo.
DEF VAR c-lb-requisit  AS CHAR NO-UNDO.
DEF VAR c-lb-icms      AS CHAR NO-UNDO.

def var c-desc         as char format "x(30)" no-undo.
def var l-pto-enc      like item.loc-unica no-undo.
def var l-periodico    like item.loc-unica no-undo.
def var c-mensagem     like &IF "{&emsfnd_version}" >= "1.00" 
                            &THEN cadast_msg.dsl_help_msg VIEW-AS EDITOR SIZE 70 BY 10 
                            &ELSE cad-msgs.help-msg &ENDIF no-undo.
def var i-ordem        like ordem-compra.numero-ordem no-undo.
def var i-ordem-aux    like ordem-compra.numero-ordem no-undo.
def var i-ord-aux      like ordem-compra.nr-ord-orig  no-undo.

{utp/ut-liter.i Ordem * r}
assign c-lb-ordem = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-lb-item = trim(return-value).
{utp/ut-liter.i Est * r}
assign c-lb-estab = trim(return-value).
{utp/ut-liter.i Data_Gera‡Æo * r}
assign c-lb-dt-gera = trim(return-value).
{utp/ut-field.i mgadm ordem-compra cod-estabel 1}
assign c-lb-estabel = trim(return-value).
{utp/ut-field.i mgind ordem-compra natureza 1}
assign c-lb-natur = trim(return-value).
{utp/ut-field.i mgind ordem-compra situacao 1}
assign c-lb-situa = trim(return-value).
{utp/ut-field.i mgind ordem-compra origem 1}
assign c-lb-orig = trim(return-value).
{utp/ut-field.i mgind prazo-compra data-entrega 2}
assign c-lb-data = trim(return-value).
{utp/ut-field.i mgind item ge-codigo 1}
assign c-lb-ge = trim(return-value).
{utp/ut-field.i mgind item fm-codigo 1}
assign c-lb-fam = trim(return-value).
{utp/ut-field.i mgadm cond-pagto cod-cond-pag 1}
assign c-lb-cdp = trim(return-value).
{utp/ut-field.i mgind item demanda 1}
assign c-lb-tipo = trim(return-value).
{utp/ut-liter.i Ponto_Encomenda * r}
assign c-lb-ponto = trim(return-value).
{utp/ut-liter.i Peri¢dico * r}
assign c-lb-period = trim(return-value).
{utp/ut-liter.i Gera_Ordens_M£ltiplas * r}
assign c-lb-gera = trim(return-value).
{utp/ut-liter.i Fazer_DivisÆo_das_Ordens * r}
assign c-lb-divis = trim(return-value).
{utp/ut-liter.i Considera_Prazo_Entrega_do_Contrato * r}
assign c-lb-dt-contr = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
assign c-lb-selec = trim(return-value).
{utp/ut-liter.i CLASSIFICA€ÇO * r}
assign c-lb-classe = trim(return-value).
{utp/ut-liter.i PAR¶METROS * r}
assign c-lb-param = trim(return-value).
{utp/ut-liter.i DIGITA€ÇO * r}
assign c-lb-digit = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-impr = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-dest = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuar = trim(return-value).
{utp/ut-liter.i Msg * r}
assign c-lb-msg = trim(return-value).
{utp/ut-liter.i Erro * r}
assign c-lb-erro = trim(return-value).
{utp/ut-field.i mgind item desc-item 1}
assign c-lb-desc = return-value.
{utp/ut-field.i mgind ordem-compra qt-solic 1}
assign c-lb-qtd = return-value.
{utp/ut-field.i mgind ordem-compra requisitante 1}
ASSIGN c-lb-requisit = RETURN-VALUE.
{utp/ut-liter.i ICMS * r}
ASSIGN c-lb-icms = RETURN-VALUE.
{utp/ut-liter.i Narrativa * r}
ASSIGN c-lb-narra = trim(RETURN-VALUE).


form c-lb-ordem
     c-lb-compr at 11  format "x(12)"
     c-lb-item  at 24
     c-lb-desc at 41  format "x(14)"
     c-lb-estab at 79  format "x(3)"     
     c-lb-qtd   at 96
     c-lb-situa at 105  format "x(14)"
     c-lb-data  at 123 format "x(10)" skip
     "--------------------------------------------------" space(0)
     "--------------------------------------------------" space(0)
     "--------------------------------"
     with stream-io no-box no-label width 132 page-top frame f-cab-ordem.

form tt-msg.nr-ordem
     tt-msg.comprador  at 11
     tt-msg.it-codigo  at 24
     c-desc            at 41
     tt-msg.estabel    at 79     
     tt-msg.qtd        at 86
     tt-msg.situacao   at 105  format "x(14)"
     tt-msg.dt-emissao at 123
     with stream-io no-box no-label width 132 frame f-ordem.

form tt-editor.conteudo at 10 format "x(100)"
     with stream-io no-box no-label width 132 frame f-narrativa.

find first param-estoq  no-lock no-error.
find first param-global no-lock no-error.
find first param-compra no-lock no-error.
find first empresa
    where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                    output da-iniper-x,
                    output da-fimper-x,
                    output i-per-corrente,
                    output i-ano-corrente,
                    output da-iniper-fech,
                    output da-fimper-fech).

find first tt-digita where tt-digita.marca = "*" no-lock no-error.
if not avail tt-digita then   /* Gera as ordens pela Selecao do usuario */
    run pi-carrega-tt-digita.
ELSE
    RUN pi-carrega-ordem-tt-digita.

assign c-programa = "CE/0341"
       c-versao   = "1.00"
       c-revisao  = "000"
       i-mes-aux  = month(da-fimper-x)
       i-numper-x = i-mes-aux
       c-empresa  = empresa.razao-social
       i-seq1     = if tt-param.l-multip then 1 else 0.

find first tt-param no-lock no-error.
{include/i-rpout.i}

{utp/ut-liter.i Ressuprimento_Estoques * L}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i ESTOQUE * L}
assign c-sistema = trim(return-value).

if param-compra.int-2 = 2 then do:   /* por comprador */
   {utp/ut-liter.i Comprador * r}
   assign c-lb-compr = trim(return-value).
end.
else do: /* por grupo de compras */
   {utp/ut-liter.i Grupo_Compra * r}
   assign c-lb-compr = trim(return-value).
end.

view frame f-cabper.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Ressuprimento_Estoque * L}
run pi-inicializar in h-acomp (input return-value).
for each tt-digita where
    tt-digita.marca = "*" exclusive-lock:
    
    assign i-ordem = param-compra.prox-ord-aut.
    
    for each tt-erro:
        delete tt-erro.
    end.
    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.
    for each tt-prazo-compra:
        delete tt-prazo-compra.
    end.
    
    find item
         where item.it-codigo = tt-digita.it-codigo 
         no-lock no-error.
    &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */
        find first item-uni-estab where
            item-uni-estab.it-codigo   = tt-digita.it-codig and
            item-uni-estab.cod-estabel = tt-digita.cod-estabel no-lock no-error.
        {utp/ut-field.i mgind item-uni-estab it-codigo 1}
    &else      
        find first item-mat-estab where
            item-mat-estab.it-codigo   = tt-digita.it-codig and
            item-mat-estab.cod-estabel = tt-digita.cod-estabel NO-LOCK no-error.
        {utp/ut-field.i mgind item-mat-estab it-codigo 1}
    &endif 
    assign c-acompanha = return-value + ": " + tt-digita.it-codig.
    {utp/ut-field.i mgadm estabelec cod-estabel 1} 
    assign c-acompanha = c-acompanha  + " " + return-value + ": " + tt-digita.cod-estabel.
    run pi-acompanhar in h-acomp (input c-acompanha).
    
    find first necessidade-oc where
     rowid(necessidade-oc) = tt-digita.rw-nec EXCLUSIVE-LOCK no-error.
    
    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = tt-digita.numero-ordem NO-LOCK NO-ERROR. 
    IF AVAIL ordem-compra THEN DO:
        RUN ccp/ccapi333.p(INPUT NO,
                           OUTPUT tt-digita.numero-ordem).
    END.

    create tt-ordem-compra.
    assign tt-ordem-compra.numero-ordem = tt-digita.numero-ordem
           tt-ordem-compra.l-gerou      = no.

    if tt-param.l-narrativa then
        ASSIGN tt-ordem-compra.narrativa = item.narrativa.
    

    {cep/ce0341.i2} /* gera ordem compra e prazo compra */

    for each tt-msg:

        find first b-item no-lock where 
             b-item.it-codigo = tt-msg.it-codigo no-error.

        assign c-desc = if avail b-item
                           then substring(b-item.desc-item,1,30)
                           else "".

        if (line-counter > (page-size - 2) or line-counter < 6) then /* ImpressÆo Cabe‡alho */
            disp c-lb-ordem
                 c-lb-compr 
                 c-lb-item  
                 c-lb-estab
                 c-lb-desc
                 c-lb-qtd
                 c-lb-situa 
                 c-lb-data with frame f-cab-ordem.     
        disp tt-msg.nr-ordem
             tt-msg.comprador  
             tt-msg.it-codigo  
             c-desc
             tt-msg.estabel    
             tt-msg.conta
             tt-msg.qtd   
             tt-msg.situacao  
             tt-msg.dt-emissao 
             with down frame f-ordem.
        down with frame f-ordem.
        if  tt-msg.narrativa <> "" then do:
            run pi-print-editor (tt-msg.narrativa,100).
            put unformatted (c-lb-narra + ": ") at 10.
            FOR EACH tt-editor 
                WHERE tt-editor.conteudo <> "":
                disp tt-editor.conteudo
                     when avail tt-editor
                     with frame f-narrativa.
                down with frame f-narrativa.
            END.
            put skip(1).
        end.    
        
        /*********** Chamada EPC - Fo 554.719  ****************************/   
        for each tt-epc where 
            tt-epc.cod-event = "purchase-center" : 
            delete tt-epc.
        end.            

        create tt-epc.
        assign tt-epc.cod-event     = "purchase-center"
               tt-epc.cod-parameter = "ordem-compra.numero-ordem"
               tt-epc.val-parameter = string(tt-msg.nr-ordem). 

        {include/i-epc201.i "purchase-center"}

        /************************* Fim chamada EPC **************************/

        delete tt-msg.
    end.

    DELETE necessidade-oc.
end.

find first param-compra no-lock no-error.
page.
hide frame f-cab-ordem.

IF tt-param.l-imp-param THEN DO:
    put unformatted c-lb-param skip(1).
    
    put c-lb-ponto    at 5 format "x(35)" ": " string(tt-param.pto-enc, "Sim/NÆo").
    put c-lb-period   at 5 format "x(35)" ": " string(tt-param.periodico, "Sim/NÆo").
    put c-lb-narra    at 5 format "x(35)" ": " string(tt-param.l-narrativa, "Sim/NÆo").

    &IF '{&bf_mat_versao_ems}' < '2.08' &THEN
    put c-lb-gera     at 5 format "x(35)" ": " tt-param.l-multip.
    &ELSE
    put c-lb-divis    at 5 format "x(35)" ": " tt-param.l-split.
    put c-lb-dt-contr at 5 format "x(35)" ": " tt-param.l-prazo-contr.
    &endif
    
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        PUT UNFORMATTED c-lb-icms     AT 5 FORMAT "x(35)" ": " {ininc/i01in082.i 04 tt-param.i-icms}.
        PUT c-lb-requisit AT 5 FORMAT "x(35)" ": " tt-param.c-requisitante.
    &ENDIF      
    PUT SKIP(1).
    
    put c-lb-selec        skip(1)
        c-lb-estabel      format "x(15)"        at 05 ":"
        tt-param.estabelec-ini                  at 22 "|<  >| " at 34 tt-param.estabelec-fim
        c-lb-ge           format "x(15)"        at 05 ":"
        string(tt-param.ge-ini)                 at 22 "|<  >| " at 34 string(tt-param.ge-fim)
        c-lb-fam          format "x(15)"        at 05 ":"
        tt-param.familia-ini                    at 22 "|<  >| " at 34 tt-param.familia-fim
        c-lb-item         format "x(15)"        at 05 ":"
        tt-param.item-ini                       at 22 "|<  >| " at 34 tt-param.item-fim 
        c-lb-dt-gera      format "x(15)"        at 05 ":"
        tt-param.data-ini format "99/99/9999"   at 22 "|<  >| " at 34 tt-param.data-fim format "99/99/9999" skip(1).

    put unformatted 
        c-lb-impr         skip(1)
        c-lb-dest           at 22  ": " tt-param.c-destino " - " tt-param.arquivo
        c-lb-usuar          at 22  ": " tt-param.usuario skip(1).    
END.    

{include/i-rpclo.i}
run pi-finalizar in h-acomp.
{include/pi-edit.i}

RETURN "OK":U.

PROCEDURE pi-carrega-tt-digita :
/*------------------------------------------------------------------------------
  Purpose: criar a tt-digita quando o .w nao passou nada
  Parameters:  <none>
  Notes: copia do pi-carrega-browse do ce0341.w
------------------------------------------------------------------------------*/
if can-find(first necessidade-oc) then
    for each estabelec fields (cod-estabel) where
        estabelec.cod-estabel >= tt-param.estabelec-ini and
        estabelec.cod-estabel <= tt-param.estabelec-fim no-lock:
        for each necessidade-oc where
            necessidade-oc.cod-estabel   = estabelec.cod-estabel            and
            necessidade-oc.it-codigo    >= tt-param.item-ini  and
            necessidade-oc.it-codigo    <= tt-param.item-fim  and
            necessidade-oc.data-geracao >= tt-param.data-ini and
            necessidade-oc.data-geracao <= tt-param.data-fim and 
            necessidade-oc.qt-pendente   > 0 no-lock: 
            for first item fields (it-codigo fm-codigo ge-codigo) where
                 item.it-codigo = necessidade-oc.it-codigo no-lock: end.
            if item.ge-codigo > tt-param.ge-fim or
               item.ge-codigo < tt-param.ge-ini then
                next.
            if item.fm-codigo > tt-param.familia-fim or
               item.fm-codigo < tt-param.familia-ini then
                next.
            if not (item.ge-codigo >= tt-param.ge-ini and
                    item.ge-codigo <= tt-param.ge-fim) then
                next.
            if (necessidade-oc.tp-geracao = 1 and tt-param.pto-enc) or
               (necessidade-oc.tp-geracao = 2 and tt-param.periodico) or
               (necessidade-oc.tp-geracao = 3 and tt-param.periodico) then do:
                create tt-digita.
                assign tt-digita.cod-estabel   = necessidade-oc.cod-estabel
                       tt-digita.it-codigo     = necessidade-oc.it-codigo
                       tt-digita.data-entrega  = necessidade-oc.data-entrega
                       tt-digita.data-geracao  = necessidade-oc.data-geracao
                       tt-digita.estoque-dispo = necessidade-oc.estoque-dispo
                       tt-digita.it-codigo     = necessidade-oc.it-codigo
                       tt-digita.qt-ordem      = necessidade-oc.qt-ordem
                       tt-digita.qt-orig       = necessidade-oc.qt-orig
                       tt-digita.qt-pendente   = necessidade-oc.qt-pendente
                       tt-digita.c-geracao     = {ininc/i01in658.i 04 necessidade-oc.tp-geracao}
                       tt-digita.rw-nec        = rowid(necessidade-oc)
                       tt-digita.marca         = "*".

                RUN ccp/ccapi333.p(INPUT NO,
                                   OUTPUT i-ordem).

                ASSIGN tt-digita.numero-ordem  = i-ordem.

            end.
        end.
    end.

END PROCEDURE.

PROCEDURE pi-carrega-ordem-tt-digita:

    for each tt-digita WHERE tt-digita.marca = "*":

        RUN ccp/ccapi333.p(INPUT NO,
                           OUTPUT i-ordem).

        ASSIGN tt-digita.numero-ordem  = i-ordem.

    END.

END PROCEDURE.
