/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i OF0540RP 2.00.00.034 } /*** 010034 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i of0540rp MOF}
&ENDIF

{include/i_fnctrad.i}
/* ---------------------[ VERSAO ]-------------------- */
/****************************************************************************
**
**  Programa: OF0540.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - modelo P1 
**
******************************************************************************/

/* Definicao e Preparacao dos Parametros */
 
def temp-table tt-raw-digita NO-UNDO
    field raw-digita   as raw.
                             
def input parameter raw-param AS RAW        NO-UNDO.
def input parameter table for tt-raw-digita.

def new shared workfile w-auxi NO-UNDO
    field cfop        like doc-fiscal.nat-oper
    field valor       like doc-fiscal.vl-icms-com.

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    field dt-inic          as date
    field dt-fim           as date
    field resum-per        as logical
    field resum-mes        as logical
    field tot-icms         as logical
    field tot-ant          as logical
    field fornec           as logical
    field insc-est         as logical
    field cont-contabil    as logical
    field docto            as logical
    field dt-icms-ini      as date
    field dt-icms-fim      as date
    field emissao          as logical
    field incentiva        as logical
    field l-eliqui         as logical
    field l-icms-subst     as logical
    FIELD l-cfop-serv      AS LOGICAL.
                                
create tt-param. 
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}

{include/tt-edit.i}

{ofp/of0540.i "new shared"}       

def new shared frame f-param          with stream-io.
def new shared frame f-tot-res        with stream-io.
def new shared var i-op-rel           as integer                    init 1                                NO-UNDO.
def new shared var c-tot-res          as character format "x(60)"                                         NO-UNDO.
def new shared var c-desc-tot         as character format "x(62)"                                         NO-UNDO.
def new shared var l-imp-for          as logical   format "Sim/Nao" init yes                              NO-UNDO.
def new shared var l-tot-icm          as logical   format "Sim/Nao"                                       NO-UNDO.
def new shared var l-imp-ins          as logical   format "Sim/Nao" init no                               NO-UNDO.
def new shared var l-resumo-mes       as logical   format "Sim/Nao" init no                               NO-UNDO.
def new shared var l-incentivado      as logical   format "Sim/Nao"                                       NO-UNDO. 
def new shared var l-documentos       as logical   format "Icms Substituto/Todos Documentos"              NO-UNDO.
def new shared var l-previa           as logical   format "Previa/Emissao"  init YES                      NO-UNDO.
def new shared var da-ini-cab         as date                                                             NO-UNDO.
def new shared var l-erro-x           as logical                                                          NO-UNDO.
def new shared var l-of0540x          as logical                                                          NO-UNDO.
def new shared var l-eliqui           as logical                                                          NO-UNDO.
def new shared var l-icms-subst       as logical                                                          NO-UNDO.
def new shared var l-consid-cfop-serv as logical                                                          NO-UNDO.

DEF buffer b-tt-tab-ocor for tt-tab-ocor.
DEF var l-confirma           AS logical    format "Sim/Nao"                                               NO-UNDO.
DEF var da-ini-aux           AS date                                                                      NO-UNDO.
DEF var c-super-comp         AS CHAR FORMAT "x(30)"                                                       NO-UNDO.
DEF var c-normal             AS CHAR FORMAT "x(30)"                                                       NO-UNDO.
DEF var c-opcao              AS character                                                                 NO-UNDO.
DEF var l-selecao            AS logical                                                                   NO-UNDO.
DEF new shared var i-termo   AS integer                                                                   NO-UNDO.
DEF new shared var h-of0540e AS handle                                                                    NO-UNDO.
DEF new shared var h-acomp   AS handle                                                                    NO-UNDO.
DEF var c-seg-usuario        AS CHAR                                                                      NO-UNDO.
DEF VAR i-livro              AS INTEGER                                                                   NO-UNDO.
DEF new shared var l-emit-resumo-dec as logical init YES format "Sim/Nao" label "Emite Resumo do Periodo" NO-UNDO.

/* Fun‡Æo nf-ent-cancel-livro criada para gerar notas fiscais de entrada com emissÆo pr¢pria canceladas nos Livros de Entradas e nÆo apresentar nos livros de sa¡das */
DEF NEW SHARED VAR l-funcao-nf-ent-cancel AS LOGICAL NO-UNDO.
ASSIGN l-funcao-nf-ent-cancel = (IF CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-nf-ent-cancel-livro" AND funcao.ativo = YES) THEN YES ELSE NO).

{cdp/cdcfgdis.i} /* pre-processador */
                                
/* Fim definicao e preparacao dos Parametros */

form
   c-tot-res           at 1
   c-imposto           at 61
   i-cod-tri           at 66
   doc-fiscal.vl-bicms at 67 format ">>>>>>,>>>,>>9.99"
   doc-fiscal.vl-icms  at 92 format ">>>>>>,>>>,>>9.99"
   with stream-io no-box no-labels width 132 frame f-tot-res.

form
   c-tot-res            at 1
   c-imposto            at 61
   i-cod-tri            at 66
   doc-fiscal.vl-bicms  at 69  format ">>>>>>,>>>,>>9.99"
   doc-fiscal.vl-icms   at 93  format ">>>>>>,>>>,>>9.99"
   doc-fiscal.vl-bsubs  at 111 format ">>>>>>,>>>,>>9.99"
   doc-fiscal.vl-icmsub at 131 format ">>>>>>,>>>,>>9.99"
   c-observa                   format "x(20)"
   with stream-io no-box no-labels width 170 frame f-tot-exp.

{ofp/of0540.i99} /* atualizacao da versao do programa */

assign c-est-ini          = tt-param.cod-estabel-ini
       c-est-fim          = tt-param.cod-estabel-fim
       da-est-ini         = tt-param.dt-inic
       da-est-fim         = tt-param.dt-fim
       l-resumo           = tt-param.resum-per
       l-resumo-mes       = tt-param.resum-mes
       l-tot-icm          = tt-param.tot-icms
       l-periodo-ant      = tt-param.tot-ant
       l-imp-for          = tt-param.fornec
       l-imp-ins          = tt-param.insc-est
       l-conta-contabil   = tt-param.cont-contabil
       l-documentos       = tt-param.docto
       da-icm-ini         = tt-param.dt-icms-ini
       da-icm-fim         = tt-param.dt-icms-fim
       l-previa           = tt-param.emissao
       l-incentivado      = tt-param.incentiva
       l-eliqui           = tt-param.l-eliqui
       l-icms-subst       = tt-param.l-icms-subst
       l-consid-cfop-serv = tt-param.l-cfop-serv.

run utp/ut-acomp.p persistent set h-acomp.
for first param-global fields ( formato-id-federal formato-id-estadual ) no-lock.
END.

IF NO THEN
    FIND FIRST param-of NO-LOCK NO-ERROR.

IF NOT AVAIL param-of OR
             param-of.cod-estabel <> c-est-ini THEN
    find param-of where param-of.cod-estabel = c-est-ini  no-lock no-error.

if avail param-of then do:
    find first estabelec
         where estabelec.cod-estabel = param-of.cod-estabel no-lock no-error.

    assign c-nomest         = estabelec.nome
           c-insestad       = estabelec.ins-estadual
           c-estado         = estabelec.estado.

    if   avail param-global then do:
         assign c-cgc = if param-global.formato-id-federal <> "" 
                        then string(estabelec.cgc, param-global.formato-id-federal)
                        else estabelec.cgc .
    END.
    find termo where termo.te-codigo     = param-of.termo-ab-ent  no-lock.
    find b-termo where b-termo.te-codigo = param-of.termo-en-ent  no-lock.
end.

DEF VAR c-sigla AS CHAR NO-UNDO.

ASSIGN c-sigla = "".
IF CAN-FIND (FIRST funcao 
             WHERE funcao.cd-funcao = "spp-titulo-cab":U  
               AND funcao.ativo     = YES) THEN
   ASSIGN c-sigla = " - P 1A".


assign c-titulo = if l-incentivado 
       then "RESUMO DE ENTRADAS DE PRODUTOS INCENTIVADOS" + c-sigla
       else "R E G I S T R O  DE  E N T R A D A S" + c-sigla.

if  l-imp-for = no then
    assign c-cgc-1      = ""
           c-fornecedor = "".
else
    assign c-cgc-1      = "CNPJ"
           c-fornecedor = "FORNECEDOR".

if  l-imp-ins = no then
    assign c-ins-est    = "".
else
    assign c-ins-est    = "INSC. ESTADUAL".


assign l-imprimiu-icm = no.

find estabelec where estabelec.cod-estabel = c-est-ini no-lock.

IF NOT AVAIL param-of OR
             param-of.cod-estabel <> c-est-ini THEN
    find param-of where param-of.cod-estabel = c-est-ini no-lock.

ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                    (IF l-incentivado = true THEN 8 ELSE 1) 
                 &ELSE 
                    1 
                 &ENDIF.

find termo where termo.te-codigo     = param-of.termo-ab-ent no-lock.
find b-termo where b-termo.te-codigo = param-of.termo-en-ent no-lock.
find last contr-livros use-index ch-livro where
          contr-livros.cod-estabel = c-est-ini
      and contr-livros.dt-ult-emi <= da-est-ini
      and contr-livros.livro  = i-livro no-lock no-error.

assign c-nomest   = estabelec.nome
       c-insestad = estabelec.ins-estadual
       c-usuario  = TT-PARAM.USUARIO. /* necessario para gerar tt-tab-ocor */

if   avail param-global then do:
         assign c-cgc = if param-global.formato-id-federal <> "" 
                        then string(estabelec.cgc, param-global.formato-id-federal)
                        else estabelec.cgc .
END.
  
for each tt-tab-ocor where
     tt-tab-ocor.cod-tab    = 249 and
     tt-tab-ocor.c-campo[2] = c-usuario no-lock:
     find b-tt-tab-ocor where rowid(b-tt-tab-ocor) = rowid(tt-tab-ocor) 
          exclusive-lock no-error.
          delete b-tt-tab-ocor.
end.
                             
{include/i-rpout.i}

IF  AVAIL contr-livros THEN
    assign i-num-pag = contr-livros.nr-ult-pag.

/****** rotina exclusiva para o estado do Espirito Santo *****/
for each w-estabel:
    delete w-estabel.
end.

if  estabelec.estado = "ES" then do:
    for each estabelec where estabelec.cod-estab >= c-est-ini
        and  estabelec.cod-estab <= c-est-fim
        and  estabelec.estado     = "ES" no-lock:
        create w-estabel.
        assign w-estabel.cod-estab = estabelec.cod-estab.
    end.
end.
else do:
    create w-estabel.
    assign w-estabel.cod-estab = c-est-ini.
end.

/****************************************************************/

run pi-inicializar in h-acomp (input "Registro de Entradas - modelo P1").
run ofp/of0540e.p persistent set h-of0540e. 

 /* termo de abertura */

run pi-print-editor (termo.texto, 60).

if  param-of.reini-pag = yes 
    and (day(da-est-ini) = 1
    or (day(da-est-ini) <> 1 and 
    i-num-pag = param-of.nr-pag-ent)) 
then do:
    
    {ofp/of0540.i3 termo}
    
    find first tt-editor no-error.
    if avail tt-editor then 
       put tt-editor.conteudo at 26.

    
    for each tt-editor where tt-editor.linha > 1:
        put tt-editor.conteudo at 26.
    end.

    put skip.
    page.
    assign i-num-pag = 2.
end.
else
   if param-of.reini-pag = no
      and i-num-pag = param-of.nr-pag-ent
      and (param-of.reinicia-fecha = yes or param-of.reinicia-fecha = ?) then do:
      
      {ofp/of0540.i3 termo}
      
      find first tt-editor no-error.
      if avail tt-editor then 
         put tt-editor.conteudo at 26.
      
      for each tt-editor where tt-editor.linha > 1:
         put tt-editor.conteudo at 26.
      end.
      
      put skip.
      page.
      assign i-num-pag = 2.
   end.
   else       
      if param-of.reini-pag = no and i-num-pag = 0 then do:
      
         {ofp/of0540.i3 termo}
      
         find first tt-editor no-error.
         if avail tt-editor then
             put tt-editor.conteudo at 26.
      
         for each tt-editor where tt-editor.linha > 1:
             put tt-editor.conteudo at 26.
         end.
         put skip.
         page.
         assign i-num-pag = 2.
      end.
      else
          assign i-num-pag = i-num-pag + 1.
   
if i-num-pag modulo param-of.nr-pag-ent = 0 then do:
    run pi-print-editor (b-termo.texto, 60).
    
    {ofp/of0540.i3 "b-termo"}

    find first tt-editor no-error.
    if avail tt-editor then put tt-editor.conteudo at 26.
    for each tt-editor where tt-editor.linha > 1:
        put tt-editor.conteudo at 26.
    end.
    put skip.
    page.
    
    run pi-print-editor (termo.texto, 60).
    {ofp/of0540.i3 termo}
    find first tt-editor no-error.
    if avail tt-editor then put tt-editor.conteudo at 26.
    for each tt-editor where tt-editor.linha > 1:
        put tt-editor.conteudo at 26.
    end.
    put skip.
    page.
    
    assign i-num-pag = i-num-pag + 2.
end.

view frame f-cab.
assign c-localiz = 0.
run ofp/of0540d.p.

if l-resumo then do:
   find  first tt-tab-ocor 
         where tt-tab-ocor.cod-tab    = 249
         and   tt-tab-ocor.l-campo[1] = yes
         and   tt-tab-ocor.c-campo[2] = c-usuario
         and   tt-tab-ocor.c-campo[3] <> "RES ANT" no-lock no-error.

   if avail tt-tab-ocor then do:
      if  line-counter < (page-size - 1) then
          run pi-verifica-linhas in h-of0540e (line-counter,page-size,c-localiz).

      i-aux = 1.
     
      assign c-desc-res = string(da-est-ini) + " A " +
                          string(da-est-fim).
      hide all no-pause.
      assign c-localiz = 1.
      view frame f-cab-res.
      run ofp/of0540a.p.
   end.
end.

assign da-ini-aux = da-est-ini.

if l-resumo-mes then do:
   if line-counter < (page-size - 1) then
      run pi-verifica-linhas in h-of0540e (line-counter,page-size,c-localiz).
   assign i-aux = 1 
          c-desc-res = "MENSAL"
          da-ini-cab = date(month(da-est-ini),01,year(da-est-ini))
          da-est-ini = da-ini-cab.

   run ofp/of0540b.p.
   assign c-localiz = 2.
   hide all no-pause.
   view frame  f-cab-uf.
   run ofp/of0540g.p. 
end.

/**************************************************************
** Criacao do registro de controle referente ao periodo emitido
** e atualizacao do numero da ultima pagina emitida
**************************************************************/

if  param-of.reini-pag = yes
    and ((i-num-pag + 1) modulo param-of.nr-pag-ent = 0
    or  month(da-est-fim + 1) <> month(da-est-fim)) then do:
    find termo where termo.te-codigo = param-of.termo-en-ent no-lock.
    run pi-print-editor (termo.texto, 60).
    {ofp/of0540.i3 termo}
    find first tt-editor  no-error.
    if avail tt-editor then put tt-editor.conteudo at 26.
    for each tt-editor where tt-editor.linha > 1:
        put tt-editor.conteudo at 26.
    end.
    put skip.
    page.
    assign i-num-pag = 0.
end.

if  (month(da-est-fim)   = 12
     and day(da-est-fim) = 31
     and i-num-pag <> 0) then do:
     find termo where termo.te-codigo = param-of.termo-en-ent no-lock.
     run pi-print-editor (b-termo.texto, 60).
     {ofp/of0540.i3 "b-termo"}
     find first tt-editor no-error.
     if avail tt-editor then put tt-editor.conteudo at 26.
     for each tt-editor where tt-editor.linha > 1:
         put tt-editor.conteudo at 26.
     end.
     put skip.
     page.
     assign i-num-pag = 0.
end.

ASSIGN i-livro = &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN 
                    (IF l-incentivado = true THEN 8 ELSE 1) 
                 &ELSE 
                    1 
                 &ENDIF.


if  l-eliqui and not l-previa then do:
    for each contr-livros
         where contr-livros.cod-estabel = c-est-ini
         and   contr-livros.dt-ult-emi  >= da-ini-aux
         and   contr-livros.livro  = i-livro EXCLUSIVE-LOCK:
         delete contr-livros.
     end.
end.

if not l-previa then do:
   create contr-livros.
   assign contr-livros.cod-estabel = c-est-ini
          contr-livros.dt-ult-emi  = da-est-fim
          contr-livros.livro       = i-livro
          contr-livros.nr-ult-pag  = i-num-pag.
end.

for each tt-tab-ocor where
    tt-tab-ocor.cod-tab    = 249 and
    tt-tab-ocor.c-campo[2] = c-usuario no-lock:
    find b-tt-tab-ocor where rowid(b-tt-tab-ocor) = rowid(tt-tab-ocor)
         exclusive-lock no-error.
    delete b-tt-tab-ocor.
end.
{include/i-rpclo.i}

delete procedure h-of0540e.

run pi-finalizar in h-acomp.

{include/pi-edit.i}

return "OK".
 
