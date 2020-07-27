/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540A 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0540a MOF}
&ENDIF

/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540A.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - Impressao do Resumo por CFOP do periodo
**
******************************************************************************/

def shared var i-op-rel   AS integer   initial 1        NO-UNDO.
def shared var l-imp-for  AS logical   format "Sim/Nao" NO-UNDO.
def shared var c-desc-tot AS character format "x(62)"   NO-UNDO.
def shared var l-imp-ins  AS logical   format "Sim/Nao" NO-UNDO.
def var c-char-aux        AS CHARACTER                  NO-UNDO.
def shared var h-esof0540e  AS handle                     NO-UNDO.
/*** vari veis do formato cfop ***/
def var c-formato-cfop as character NO-UNDO.
def var i-formato-cfop as integer   NO-UNDO.

def shared workfile w-auxi NO-UNDO
    field cfop        like doc-fiscal.nat-oper
    field valor       like doc-fiscal.vl-icms-com.

{cdp/cdcfgdis.i}
{ofp/esof0540.i "shared"}
 
def buffer b-tt-tab-ocor for tt-tab-ocor.

/**********************************************
**** RESUMO DE OPERACOES POR CODIGO FISCAL ****
***********************************************/

assign c-char-aux = "RES ANT".
{ofp/esof0540a.i "c-char-aux"}

