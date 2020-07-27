
/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_extracao_banco_brasil
** Descricao.............: Extra‡Æo Banco do Brasil
** Versao................:  1.00.00.031
** Procedimento..........: utl_formula_edi
** Nome Externo..........: prgint/edf/edf900zi.py
** Data Geracao..........: 20/10/2006 - 11:51:57
** Criado por............: Claudia
** Criado em.............: 28/09/1998 15:29:42
** Alterado por..........: tech14116
** Alterado em...........: 22/11/2002 11:00:45
** Gerado por............: tech14020
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.031":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  fnc_extracao_banco_brasil EDF}
&ENDIF

{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=0":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_param_program_formul no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field tta_cdn_element_edi              as Integer format ">>>>>9" initial 0 label "Elemento" column-label "Elemento"
    field tta_des_label_utiliz_formul_edi  as character format "x(10)" label "Label Utiliz Formula" column-label "Label Utiliz Formula"
    field ttv_des_contdo                   as character format "x(100)" label "Conteudo" column-label "Conteudo"
    index tt_param_program_formul_id       is primary
          tta_cdn_segment_edi              ascending
          tta_cdn_element_edi              ascending
    .

def shared temp-table tt_segment_tot no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field ttv_qtd_proces_edi               as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_qtd_bloco_docto              as decimal format "99999"
    field ttv_log_trailler_edi             as logical format "Sim/NÆo" initial no label "Trailler" column-label "Trailler"
    field ttv_log_header_edi               as logical format "Sim/NÆo" initial no label "Header" column-label "Header"
    .



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_cdn_mapa_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_segment_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_element_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param table 
    for tt_param_program_formul.


/************************* Parameter Definition End *************************/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 0
            and   tt_param_program_formul.tta_cdn_element_edi = 0 
            no-error.

        case tt_param_program_formul.ttv_des_contdo :
            when "Boleto" /*l_boleto*/  + "Outros" /*l_outros*/  then do:
                return "040".
              end.
            when "Boleto" /*l_boleto*/  + "Banco" /*l_banco*/  then do:
            return "040".
          end.
            when "DOC" /*l_doc*/  then  do:
            return "045".
          end.
            when "Cr‚dito C/C" /*l_credito_cc*/  then do:
            return "045".
          end.
            when "Cheque ADM" /*l_cheque_adm*/  then do:
            return "045".
          end.
            when "Ordem Pagto" /*l_ordem_pagto*/  then do:
            return "045".
          end.
            when "TED CIP" /*l_ted_cip*/  then do:
            return "045".
          end.
            when "TED STR" /*l_ted_str*/   then do:
            return "045".
          end.
               END CASE.

