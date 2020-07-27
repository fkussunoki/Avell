/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520RP 2.00.00.059 } /*** 010059 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0520rp MOF}
&ENDIF

{include/i_fnctrad.i}
/****************************************************************************
**
**  Programa: esof0520rp.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**
******************************************************************************/

{include/i-rpvar.i}
{ofp/esof0520.i "new shared"} /* Definicao de variaveis para esof0520pr.p */
{cdp/cdcfgdis.i}
def new shared var h-esof0520e          as handle             no-undo.
def new shared var c-estado-estab     like estabelec.estado no-undo.
DEF NEW SHARED VAR l-consid-cfop-serv AS LOGICAL            NO-UNDO.

def var l-confirma     as logical    format "Sim/Nao"   no-undo.
def var l-eliqui       as logical                       no-undo.
def var da-ini-aux     as date                          no-undo.
def var c-super-comp   AS CHAR FORMAT "x(20)"           no-undo.
def var c-normal       AS CHAR FORMAT "x(20)"           no-undo.
def var c-opcao        as character                     no-undo.
def var l-selecao      as logical                       no-undo.
def var i-tp-livro     as integer                       no-undo.
def var c-relat        as character  extent 2 init ["1 - Normal","2 - Expandido"].

def temp-table tt-raw-digita
    field raw-digita   as raw.
                             
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char
    field usuario               as char
    field data-exec             as date
    field hora-exec             as integer
    
    field cod-estabel-ini       as character
    field cod-estabel-fim       as character
    field dt-docto-ini          as date
    field dt-docto-fim          as date
    field resumo                as logical
    field resumo-mes            as logical
    field tot-icms              as logical
    field imp-for               as logical
    field periodo-ant           as logical
    field imp-ins               as logical
    field conta-contabil        as logical
    field at-perm               as logical
    field separadores           as logical
    field previa                as character
    field documentos            as character
    field da-icms-ini            as date
    field da-icms-fim            as date
    field incentivado           as logical
    field relat                 as character
    field eliqui                as logical
   
    field c-nomest              like estabelec.nome 
    field c-estado              like estabelec.estado
    field c-cgc                 like estabelec.cgc
    field c-insestad            as character
    field c-cgc-1               as character
    field c-fornecedor          as character
    field c-ins-est             as character
    field c-titulo              as character
    field imp-cnpj              as logical
    &if '{&bf_dis_versao_ems}' >= '2.04' &then
        field considera-icms-st     as logical
    &endif
    field imp-cab               as character
    FIELD l-cfop-serv           AS LOGICAL.
    

def var l-tem-funcao         as log     no-undo.

assign l-tem-funcao = can-find(funcao where funcao.cd-funcao = "considera-termo" and funcao.ativo).

/* Fun‡Æo nf-ent-cancel-livro criada para gerar notas fiscais de entrada com emissÆo pr¢pria canceladas nos Livros de Entradas e nÆo apresentar nos livros de sa¡das */
DEF NEW SHARED VAR l-funcao-nf-ent-cancel AS LOGICAL NO-UNDO.
ASSIGN l-funcao-nf-ent-cancel = (IF CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-nf-ent-cancel-livro" AND funcao.ativo = YES) THEN YES ELSE NO).

create tt-param. 
raw-transfer raw-param to tt-param.
assign c-est-ini          = tt-param.cod-estabel-ini
       c-est-fim          = tt-param.cod-estabel-fim
       da-est-ini         = tt-param.dt-docto-ini
       da-est-fim         = tt-param.dt-docto-fim
       l-resumo           = tt-param.resumo
       l-resumo-mes       = tt-param.resumo-mes
       l-tot-icm          = tt-param.tot-icms
       l-imp-for          = tt-param.imp-for
       l-periodo-ant      = tt-param.periodo-ant
       l-imp-ins          = tt-param.imp-ins
       l-imp-cnpj         = tt-param.imp-cnpj
       l-conta-contabil   = tt-param.conta-contabil
       l-at-perm          = tt-param.at-perm
       l-separadores      = tt-param.separadores
       l-previa           = if tt-param.previa = '1' then yes else no
       c-impres-cab       = if tt-param.imp-cab = "1" then "FOLHA" else "PµGINA"
       l-documentos       = if tt-param.documentos = '1' then yes else no
       da-icm-ini         = tt-param.da-icms-ini
       da-icm-fim         = tt-param.da-icms-fim
       l-incentivado      = tt-param.incentivado
       l-eliqui           = tt-param.eliqui
       c-nomest           = tt-param.c-nomest
       c-estado           = tt-param.c-estado
       c-cgc              = tt-param.c-cgc 
       c-insestad         = tt-param.c-insestad 
       c-cgc-1            = tt-param.c-cgc-1 
       c-fornecedor       = tt-param.c-fornecedor 
       c-ins-est          = tt-param.c-ins-est 
       c-titulo           = tt-param.c-titulo 
       l-imprimiu-icm     = no
       l-consid-cfop-serv = tt-param.l-cfop-serv
       &if '{&bf_dis_versao_ems}' >= '2.04' &then
           i-tp-livro     = if tt-param.incentivado then 8
                            else 1.
       &else
           i-tp-livro     = 1.
       &endif

for each tt-tab-ocor where
         tt-tab-ocor.cod-tab    = 249 and
         tt-tab-ocor.c-campo1 = c-usuario no-lock:
    delete tt-tab-ocor.
end.                                

find last contr-livros where contr-livros.cod-estabel = c-est-ini
      and contr-livros.livro  = i-tp-livro /* Entrada ou Entrada - Incentivado */ no-lock no-error.

for first estabelec fields ( cod-estabel estado )
    where estabelec.cod-estabel = c-est-ini no-lock.
end.

for first param-of fields ( termo-ab-ent termo-en-ent reini-pag
                            nr-pag-ent reinicia-fecha )
    where param-of.cod-estabel = estabelec.cod-estabel no-lock.
end.

find termo 
    where termo.te-codigo = param-of.termo-ab-ent no-lock no-error.
    
find b-termo 
    where b-termo.te-codigo = param-of.termo-en-ent no-lock no-error.

find last contr-livros use-index ch-livro 
    where contr-livros.cod-estabel = c-est-ini
      and contr-livros.dt-ult-emi <= da-est-ini
      and contr-livros.livro = i-tp-livro /* Entrada ou Entrada - Incentivado */ no-lock no-error.
if estabelec.estado = "SC" 
or estabelec.estado = "RS" 
or estabelec.estado = "PR" then
    assign c-titulo-estado = "                           DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM ".
else 
    assign c-titulo-estado = "OPERACOES INTERESTADUAIS - DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM ".


DEF VAR c-sigla AS CHAR NO-UNDO.

ASSIGN c-sigla = "".

IF CAN-FIND (FIRST funcao 
             WHERE funcao.cd-funcao = "spp-titulo-cab":U  
               AND funcao.ativo     = YES) THEN
   ASSIGN c-sigla = " - P 1A".

assign i-num-pag      = if  l-at-perm 
                        then 1 
                        else IF AVAIL contr-livros 
                             THEN contr-livros.nr-ult-pag
                             ELSE 0
       l-previa       = if  l-at-perm 
                        then yes 
                        else l-previa
       c-titulo       = if  l-incentivado
                        then "REGISTRO DE ENTRADAS PRODUTOS INCENTIVADOS" + c-sigla
                        else "R E G I S T R O  DE  E N T R A D A S" + c-sigla
       c-estado-estab = estabelec.estado.
      
for each tt-estabelec:
    delete tt-estabelec.
end.

/****** rotina exclusiva para o estado do Espirito Santo *****/
if  estabelec.estado = "ES" then do:
    for each estabelec fields ( cod-estabel ) 
        where estabelec.cod-estab >= c-est-ini
        and   estabelec.cod-estab <= c-est-fim
        and   estabelec.estado     = "ES" no-lock:
        create tt-estabelec.
        assign tt-estabelec.cod-estab = estabelec.cod-estabel.
    end.
end.
else do:
    create tt-estabelec.
    assign tt-estabelec.cod-estab = c-est-ini.
end.

/****************************************************************/
/* termo de abertura */

{include/i-rpout.i}

if  not l-at-perm then do:

    if  param-of.reini-pag = yes 
    and (day(da-est-ini) = 1
         or (day(da-est-ini) <> 1 and i-num-pag = (param-of.nr-pag-ent +
                                                            if l-tem-funcao
                                                            then 1
                                                            else 0 )))
    then do:
        {ofp/esof0520.i3 termo}
        assign i-num-pag = 2.
        if l-tem-funcao then assign i-num-pag = 1.
    end.
    else
        if param-of.reini-pag = no
        and i-num-pag = (param-of.nr-pag-ent +
                                if l-tem-funcao
                                then 1
                                else 0 )
        and param-of.reinicia-fecha = yes then do:
            {ofp/esof0520.i3 termo}
            assign i-num-pag = 2.
            if l-tem-funcao then assign i-num-pag = 1.
        end.
        else
            if param-of.reini-pag = no and i-num-pag = 0 then do:
               {ofp/esof0520.i3 termo}
               assign i-num-pag = 2.
               if l-tem-funcao then assign i-num-pag = 1.
            end.
            else
                assign i-num-pag = i-num-pag + 1.
                
    if  i-num-pag modulo (param-of.nr-pag-ent +
                                if l-tem-funcao
                                then 1
                                else 0 ) = 0 then do:
        {ofp/esof0520.i3 "b-termo"}
        {ofp/esof0520.i3 termo}
        assign i-num-pag = 2.
        if l-tem-funcao then assign i-num-pag = 1.
    end.
end.

for each tt-cred-com:
    delete tt-cred-com.
end.

/* rodas as procedures pi-verifica-linhas e pi-cabecalhos persistentes */
run ofp/esof0520e.p persistent set h-esof0520e. 

run pi-leitura-param-of in h-esof0520e.

&if '{&bf_dis_versao_ems}' >= '2.04' &then
    run ofp/esof0520d.p (input tt-param.considera-icms-st).
&else
    run ofp/esof0520d.p.
&endif

if l-resumo then do:
   run ofp/esof0520a.p (input 1).
end.

assign da-ini-aux = da-est-ini.
if l-resumo-mes then do:
   run ofp/esof0520a.p (input 2).
   run ofp/esof0520b.p.
end.

/**************************************************************
** Criacao do registro de controle referente ao periodo emitido
** e atualizacao do numero da ultima pagina emitida
**************************************************************/

IF line-counter = page-size - 1 AND l-separadores THEN DO:
  if  i-op-rel = 1 THEN DO:
      view frame f-bottom.
  END.
  else DO:
      view frame f-bottom-e.
  END.
END.

if  i-num-pag + 1 = (param-of.nr-pag-ent + if l-tem-funcao
                                           then 1
                                           else 0) 
and param-of.reini-pag = no then do:
    find b-termo where b-termo.te-codigo = param-of.termo-en-ent no-lock.
    hide all no-pause.
    {ofp/esof0520.i3 "b-termo"}
    assign i-num-pag = 0.    
end.

if  param-of.reini-pag = yes
and ((i-num-pag + 1) modulo (param-of.nr-pag-ent +
                                if l-tem-funcao
                                then 1
                                else 0) = 0
     or  month(da-est-fim + 1) <> month(da-est-fim))
then do:
    find termo where termo.te-codigo = param-of.termo-en-ent no-lock.
    hide all no-pause.
    {ofp/esof0520.i3 termo}
    assign i-num-pag = 0.
end.

if  (month(da-est-fim)   = 12
     and day(da-est-fim) = 31
     and i-num-pag <> 0) then do:
    find b-termo 
        where b-termo.te-codigo = param-of.termo-en-ent no-lock.
    hide all no-pause.
    {ofp/esof0520.i3 "b-termo"}
    assign i-num-pag = 0.
end.

if  l-eliqui 
and not l-previa then do:
    for each contr-livros fields ()
        where contr-livros.cod-estabel = c-est-ini
        and   contr-livros.dt-ult-emi  > da-ini-aux
        and   contr-livros.livro  = i-tp-livro /* Entrada ou Entrada - Incentivado */ exclusive-lock :
        delete contr-livros.
    end.
end.

if  not l-previa then do:
    create contr-livros.
    assign contr-livros.cod-estabel = c-est-ini
           contr-livros.dt-ult-emi  = da-est-fim
           contr-livros.livro  = i-tp-livro /* Entrada ou Entrada - Incentivado */
           contr-livros.nr-ult-pag  = i-num-pag.
end.

for each tt-tab-ocor 
    where tt-tab-ocor.cod-tab    = 249 
    and   tt-tab-ocor.c-campo1 = c-usuario:
    delete tt-tab-ocor.
end.

{include/i-rpclo.i}
delete procedure h-esof0520e.

return "OK":U.
