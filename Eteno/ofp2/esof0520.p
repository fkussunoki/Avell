/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520A 2.00.00.034 } /*** 010034 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520a MOF}
&ENDIF



/******************************************************************************
**
**  Programa: esof0520A.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - Impressao do Resumo por CFOP do periodo
**
******************************************************************************/

def input parameter i-resumo  as integer. 

{ofp/esof0520.i shared}

/* Defini‡Æo de pr‚-processador */
{cdp/cdcfgdis.i}

def var c-char-aux as character.
def var de-geralt-cred    like doc-fiscal.vl-icms-com   no-undo.
def var de-subt-cred      like doc-fiscal.vl-icms-com   no-undo.
def var da-temp           as date no-undo.
def var da-ini            as date no-undo.
def var da-fim            as date no-undo.
def shared var h-esof0520e  as handle no-undo.
def var i-aux             as int no-undo.

assign i-nivel = 2
       c-linha-branco = "".
       
if  l-separadores then
    assign c-linha-branco = c-sep + fill(" ",8) + c-sep + 
           fill(" ",(if i-op-rel = 1 then 55 else 52)) +
           c-sep + fill(" ",16) + c-sep + fill(" ",4) + c-sep + 
           fill(" ",3) + c-sep + fill(" ",16) + c-sep + fill(" ",5) +
           c-sep + fill(" ",16) + c-sep + fill(" ",16) + c-sep + 
           fill(" ",16) + c-sep.

/**********************************************
**** RESUMO DE OPERACOES POR CODIGO FISCAL ****
***********************************************/

assign c-char-aux = if i-resumo = 1 then "RES ANT" else "".

assign da-temp = da-est-ini.
if  i-resumo = 1 then do:
    assign da-ini     = da-est-ini
           da-fim     = da-est-fim
           c-desc-res = string(da-ini,"99/99/9999") + " A " +
           string(da-fim,"99/99/9999").
end.
else do:
    assign da-ini     = date(month(da-est-ini),1,year(da-est-ini))
           da-est-ini = da-ini
           da-fim     = date((month(da-est-fim) modulo 12) + 1,1,
                        year(da-est-fim) +
                        if month(da-est-fim) = 12 then 1 else 0) - 1
           c-desc-res = "MENSAL".
end.

hide all no-pause.
if  l-separadores then do:
    if  i-op-rel = 1 then do:
        view frame f-cab-diag.
        view frame f-bottom.
        view frame f-scab-res.
    end.
    else do:
        view frame f-cab-diag-e.
        view frame f-bottom-e.
        view frame f-scab-res-e.
    end.
end.
else do:
    if  i-op-rel = 1 then do:
        view frame f-cab.
        view frame f-cab-res.
    end.
    else do:
        view frame f-cab-exp.
        view frame f-res-sub.
    end.
end.

{ofp/esof0520a.i "c-char-aux"}

if line-counter > 15 then 
do while line-counter < page-size:
   put c-linha-branco at 1 format "x(132)" skip.
end.
else
   if dbtype('mguni') = "ORACLE" then
      assign i-num-pag = i-num-pag - 1.

/* esof0520A.P */

