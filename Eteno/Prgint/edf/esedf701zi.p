/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_prg_formul_39
** Descricao.............: F¢rmula 39
** Versao................:  1.00.00.010
** Procedimento..........: utl_programs_formulas_edi
** Nome Externo..........: prgint/edf/edf701zi.py
** Data Geracao..........: 12/05/2010 - 15:56:37
** Criado por............: tech14032
** Criado em.............: 19/01/2005 11:31:05
** Alterado por..........: fut41420
** Alterado em...........: 11/11/2009 10:06:18
** Gerado por............: corp1153
*****************************************************************************/

def buffer fornecedor           for emsfin.fornecedor.
DEF BUFFER histor_exec_especial FOR emsfin.histor_exec_especial.

def var c-versao-prg as char initial " 1.00.00.010":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_prg_formul_39 EDF}
&ENDIF

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

/************************* Variable Definition Begin ************************/
def new global shared var v_dsl_dados_edi
    as Character
    format "x(15000)":U
    label "Dados EDI"
    column-label "Dados EDI"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def new global shared var v_des_flag_public_geral
    as character
    format "x(15)":U
    extent 10
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.

def var v_cod_cei
    as character
    format "x(30)":U
    no-undo.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

/************************************************************************/
/* def stream s-cdhu.                                                                  */
/* output stream s-cdhu to value("F:\Totvs\EDI\PAGTO\BB\Testes\edi_prod.txt") append.  */
/* put stream s-cdhu                                                                   */
/*     skip(2)                                                                         */
/*     "Data...............: " today             skip                                  */
/*     "Programa...........: " "esedf701zi.p"    skip                                  */
/*     "p_cdn_segment_edi..: " p_cdn_segment_edi skip                                  */
/*     "p_cdn_element_edi..: " p_cdn_element_edi skip                                  */
/*     "v_dsl_dados_edi....: " v_dsl_dados_edi   skip.                                 */
/* for each tt_param_program_formul:                                                   */
/*     disp stream s-cdhu                                                              */
/*        tt_param_program_formul with width 600 stream-io.                            */
/* end.                                                                                */
/* output stream s-cdhu close.                                                         */
/************************************************************************/


if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('fnc_prg_formul_39':U, 'prgint/edf/edf701zi.py':U, '1.00.00.010':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        Message "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        Message "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_prg_formul_39') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado nÆo ‚ um programa v lido Datasul ! */
    run pi_Messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prg_formul_39')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu rio sem permissÆo para acessar o programa. */
    run pi_Messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prg_formul_39')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_prg_formul_39' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_prg_formul_39'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


def var v_cod_segto           as char no-undo.
def var v_dsl_segto           as char no-undo.
def var v_cod_agenc_fav       as char no-undo.
def var v_cod_dig_agenc_fav   as char no-undo.
def var v_cdn_bco             as int  no-undo.
def var v_num_inic            as int  no-undo.
def var v_cod_cta_fav         as char no-undo.
def var v_cod_dig_cta_fav     as char no-undo.
def var v_cdn_tip_forma_pagto as Int  no-undo.
def var v_dec_aux             as dec  no-undo.
def var v_dec_aux2            as dec  no-undo.
def var v_dec_aux3            as dec  no-undo.
def var v_num_tam_format      as int  no-undo.
def var v_forma_pagto         as char no-undo.
def var v_tp_forn             as int  no-undo.
def var v_cod_estab           as char no-undo.
def var dt-aux                as date no-undo.
def var c-mes                 as int  no-undo.
def var c-ano                 as int  no-undo.
def var c-aux                 as char no-undo.
def var i-aux                 as int  no-undo.
def var c-bloco               as char no-undo.
def var de-aux                as dec no-undo.
def var de-aux2               as dec no-undo.
def var de-aux3               as dec no-undo.
def var v_cod_banco           as char no-undo.
DEF VAR v_num_reg_bloco       AS INT NO-UNDO.
DEF VAR v_num_bloco           AS INT NO-UNDO.
DEF VAR tipo-documento        AS INT NO-UNDO.

/* Tipo de Pagamento */

if p_cdn_segment_edi = 307 and
   p_cdn_element_edi = 2681 then do:

    find first tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 0
        and   tt_param_program_formul.tta_cdn_element_edi = 0 
        no-error.
    
    case tt_param_program_formul.ttv_des_contdo :
        when "Boleto" /*l_boleto*/   + "Consumo" /*l_consumo*/   then
            return "98".
        when "Boleto" /*l_boleto*/   + "Outros" /*l_outros*/   then
            return "98".
        when "Boleto" /*l_boleto*/   + "Banco" /*l_banco*/   then
            return "98".
        when "Pagto Tributos" /*l_Pagto_Tributos*/  then
            return "98".
        when "DOC" /*l_doc*/   then
            return "20".
        when "Cr‚dito C/C" /*l_credito_cc*/   then
            return "20".
        when "Cr‚dito C/P" /*l_credito_cp*/   then
            return "98".
        when "Cheque ADM" /*l_cheque_adm*/   then
            return "20".
        when "Ordem Pagto" /*l_ordem_pagto*/   then
            return "20". 
        when 'TED CIP' /* l_ted_cip*/   then
            return "20".
        when 'TED STR' /* l_ted_str*/   then
            return "20".                     
    end.
end.


/* Forma de Pagamento */

if p_cdn_segment_edi = 307 and
   p_cdn_element_edi = 2682 then do:

    find first tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 0
        and   tt_param_program_formul.tta_cdn_element_edi = 0 
        no-error.

    case tt_param_program_formul.ttv_des_contdo :
        when "Boleto" /*l_boleto*/   + 'Consumo' /* l_cosumo*/  then
            return '11'.
        when "Boleto" /*l_boleto*/   + 'Outros' /* l_outros*/  then
            return '31'.
/*         when 'Boleto' /* l_boleto*/  + 'Outros' /* l_outros*/  then do: */
/*             /* Teste quando existe mais de um bloco */ */
/*             find last reg_proces_saida_edi where */
/*                  reg_proces_saida_edi.cdn_proces_edi  = int(v_des_flag_public_geral[1]) and */
/*                  reg_proces_saida_edi.cdn_segment_edi = 309 */
/*                  no-lock no-error. */
/*             if avail reg_proces_saida_edi then do: */
/*                 find first reg_proces_entr_edi where */
/*                      reg_proces_entr_edi.cdn_proces_edi             = reg_proces_saida_edi.cdn_proces_edi and */
/*                      reg_proces_entr_edi.des_id_reg_bloco_modul_edi = reg_proces_saida_edi.des_id_reg_bloco_modul_edi */
/*                      no-lock no-error. */
/*                 if avail reg_proces_entr_edi then do: */
/*                     find next reg_proces_entr_edi where */
/*                          reg_proces_entr_edi.cdn_proces_edi  = reg_proces_saida_edi.cdn_proces_edi and */
/*                          reg_proces_entr_edi.cdn_segment_edi = 289 no-lock no-error. */
/*                     if length(entry(35,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24))) = 48 then */
/*                         return '11'. */
/*                     else */
/*                         return '31'. */
/*                 end. */
/*             end. */
/*             /* Teste quando estiver no inicio do primeiro bloco */ */
/*             find first reg_proces_entr_edi where */
/*                  reg_proces_entr_edi.cdn_proces_edi  = int(v_des_flag_public_geral[1]) and */
/*                  reg_proces_entr_edi.cdn_segment_edi = 289 */
/*                  no-lock no-error. */
/*             if avail reg_proces_entr_edi then do: */
/*                if length(entry(35,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24))) = 48 then */
/*                   return '11'. */
/*                else */
/*                   return '31'. */
/*             end. */
/*             return '31'. */
/*         end. */
        when "Boleto" /*l_boleto*/   + 'Banco' /* l_banco*/  then
            return '30'.
        when "DOC" /*l_doc*/   then
            return '03'.
        when "Cr‚dito C/C" /*l_credito_cc*/  then 
            return '01'.
        when "Cr‚dito C/P" /*l_credito_cc*/   then 
            return '05'.
        when "Cheque ADM" /*l_cheque_adm*/   then
            return '02'.
        when "Ordem Pagto" /*l_ordem_pagto*/   then
            return '10'.    
        when "TED CIP" /*l_ted_cip*/   then
            return '43'.    
        when "TED STR" /*l_ted_str*/    then
            return '41'.
        when "Pagto Tributos" /*l_pagto_tribut*/  then do:
            find first tt_param_program_formul
                where tt_param_program_formul.tta_cdn_segment_edi = 288
                and   tt_param_program_formul.tta_cdn_element_edi = 4838
                no-error.

            return trim(tt_param_program_formul.ttv_des_contdo).
        end.        
    end.
end.

/* if p_cdn_segment_edi = 307 and                                              */
/*    p_cdn_element_edi = 2681 then do:                                        */
/*                                                                             */
/*    find tt_param_program_formul                                             */
/*         where tt_param_program_formul.tta_cdn_segment_edi = 288             */
/*         and   tt_param_program_formul.tta_cdn_element_edi = 3729 no-error.  */
/*                                                                             */
/*    if int(tt_param_program_formul.ttv_des_contdo) = 22 then                 */
/*       return '22'.                                                          */
/*    else                                                                     */
/*       return '20'.                                                          */
/* end.                                                                        */

/* C½digo do Segmento */
if p_cdn_segment_edi = 309 and
   p_cdn_element_edi = 2693 then do:

   run pi_retorna_tp_segto (output v_cod_segto).

   return trim(v_cod_segto).
end.

/* Detalhe Variÿvel - Registro Detalhe */
if p_cdn_segment_edi = 309 and
   p_cdn_element_edi = 5174 then do:

   run pi_retorna_tp_segto (output v_cod_segto).

   case v_cod_segto:
     when "A" /*l_A*/  then  /* Pagamento com Cheque, OP, DOC, TED e Cr²dito em Conta Corrente */

         run pi_segto_tipo_A.

     when "J" /*l_J*/  then  /* Liquida‡Æo de T¡tulos (bloquetos) em cobran»a no Itaœ e em outros Bancos */

         run pi_segto_tipo_J.

     when "N" /*l_n*/  then  /* Pagamento Tributos (GPS / DARF / DARF SIMPLES) */

         run pi_segto_tipo_N.

     when "O" /*l_o*/  then  /* Pagamento Contas Concessionÿrias */

         run pi_segto_tipo_O.

   end case.

   return v_dsl_segto. /* Vai retornar registro com dados de detalhe variÿvel */
end.

/* Segmento B - Registro Detalhe */
if p_cdn_segment_edi = 309 and
   p_cdn_element_edi = 5175 then do:

    run pi_retorna_tp_segto (output v_cod_segto).

    assign v_dsl_segto = chr(10). /* Quebra linha */

    if v_cod_segto = "A" then do: /* Complemanto - Segmento Tipo B */

        run pi_segto_tipo_B.

    end.

    return v_dsl_segto. /* Vai retornar registro */

end.

/* /* Detalhe Variÿvel - Registro Detalhe Trailler */                                                                               */
/* if p_cdn_segment_edi = 311 and                                                                                                   */
/*    p_cdn_element_edi = 5133 then do:                                                                                             */
/*                                                                                                                                  */
/*    assign v_dsl_segto = ''                                                                                                       */
/*           de-aux      = 0                                                                                                        */
/*           de-aux2     = 0                                                                                                        */
/*           de-aux3     = 0.                                                                                                       */
/*                                                                                                                                  */
/*    find first tt_param_program_formul                                                                                            */
/*         where tt_param_program_formul.tta_cdn_segment_edi = 0                                                                    */
/*         and   tt_param_program_formul.tta_cdn_element_edi = 0                                                                    */
/*         no-error.                                                                                                                */
/*                                                                                                                                  */
/*    assign c-bloco = tt_param_program_formul.ttv_des_contdo.                                                                      */
/*                                                                                                                                  */
/*    run pi_retorna_tp_segto (output v_cod_segto).                                                                                 */
/*                                                                                                                                  */
/*    for each reg_proces_entr_edi no-lock where                                                                                    */
/*        reg_proces_entr_edi.cdn_proces_edi   = int(v_des_flag_public_geral[1]) and                                                */
/*        reg_proces_entr_edi.cod_id_bloco_edi = c-bloco.                                                                           */
/*                                                                                                                                  */
/*        /* somatorios */                                                                                                          */
/*        assign de-aux  = de-aux  + dec(entry(33,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24)))   /* Valor Nominal do T¡tulo */  */
/*               de-aux2 = de-aux2 + dec(entry(30,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24)))   /* Juros */                    */
/*               de-aux3 = de-aux3 + dec(entry(25,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24))).  /* Valor Pagto */              */
/*    end.                                                                                                                          */
/*                                                                                                                                  */
/*    case v_cod_segto:                                                                                                             */
/*       when "N" /*l_n*/  then do: /* Pagamento de Tributos */                                                                     */
/*                                                                                                                                  */
/*          assign v_dsl_segto = string(de-aux,"99999999999999")  + /* Somat½rio valor pagamentos */                                */
/*                               '00000000000000'                 + /* Somat½rio outras entidades */                                */
/*                               string(de-aux2,'99999999999999') + /* Somat½rio valor multa / mora */                              */
/*                               string(de-aux3,'99999999999999').  /* Somat½rio total pagamento */                                 */
/*                                                                                                                                  */
/*       end.                                                                                                                       */
/*       otherwise do:                                                                                                              */
/*          assign v_dsl_segto = string(de-aux3,'999999999999999999') + /* Somat½rio valor pagamentos */                            */
/*                               fill('0',18) + /* Zeros */                                                                         */
/*                               fill(' ',20). /* brancos */                                                                        */
/*       end.                                                                                                                       */
/*    end case.                                                                                                                     */
/*                                                                                                                                  */
/*    return v_dsl_segto.                                                                                                           */
/* end.                                                                                                                             */


/* Qtde Moedas - Registro Detalhe Trailler */
if p_cdn_segment_edi = 311 and
   p_cdn_element_edi = 5134 then do:

    find first tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 0
        and   tt_param_program_formul.tta_cdn_element_edi = 0 
        no-error.

    case tt_param_program_formul.ttv_des_contdo :
        when "Boleto" /*l_boleto*/  + "Consumo" /*l_consumo*/  then
            return "" /*l_*/ .
        when "Boleto" /*l_boleto*/  + "Outros" /*l_outros*/  then
            return "" /*l_*/ .
        when "Boleto" /*l_boleto*/  + "Banco" /*l_banco*/  then
            return "" /*l_*/ .
        when "Pagto Tributos" /*l_pagto_tributos*/ then
            return "" /*l_*/ .
        when "DOC" /*l_doc*/  then
            return "000000000000000000".
        when "Cr‚dito C/C" /*l_credito_cc*/  then
            return "000000000000000000".
        when "Cr‚dito C/P" /*l_credito_cc*/  then
            return "000000000000000000".
        when "Cheque ADM" /*l_cheque_adm*/  then
            return "000000000000000000".
        when "Ordem Pagto" /*l_ordem_pagto*/  then
            return "000000000000000000".
        when 'TED CIP' /* l_ted_cip*/  then
            return "000000000000000000".        
        when 'TED STR' /* l_ted_str*/  then
            return "000000000000000000".        
    end.
end.


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUN€ÇO *******************************
** Fun‡Æo para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser  atualizado
**  p_cod_campo       - Campo / Vari vel que ser  atualizada
**  p_cod_separador   - Separador que ser  utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */



/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_tp_segto
** Descricao.............: pi_retorna_tp_segto
** Criado por............: tech14020
** Criado em.............: 08/09/2006 09:03:38
** Alterado por..........: corp1153
** Alterado em...........: 23/03/2009 11:29:03
*****************************************************************************/
PROCEDURE pi_retorna_tp_segto:

           def output parameter p_cod_segto as char.

           find first tt_param_program_formul
               where tt_param_program_formul.tta_cdn_segment_edi = 0
               and   tt_param_program_formul.tta_cdn_element_edi = 0 
               no-error.

           case tt_param_program_formul.ttv_des_contdo :
               when "Boleto" /*l_boleto*/   + "Consumo" /*l_consumo*/   then
                   assign p_cod_segto = "O" /*l_o*/ .
               when "Boleto" /*l_boleto*/   + "Outros" /*l_outros*/   then
                   assign p_cod_segto = "J" /*l_j*/ .
/*                when "Boleto" /*l_boleto*/   + "Outros" /*l_outros*/   then do: */
/*                    find first tt_param_program_formul where */
/*                         tt_param_program_formul.tta_cdn_segment_edi = 289 and */
/*                         tt_param_program_formul.tta_cdn_element_edi = 2807 */
/*                         no-lock no-error. */
/*                    if length(tt_param_program_formul.ttv_des_contdo) = 48 then */
/*                       assign p_cod_segto = "O" /*l_o*/ . */
/*                    else */
/*                       assign p_cod_segto = "J" /*l_J*/ . */
/*                end. */
               when "Boleto" /*l_boleto*/   + "Banco" /*l_banco*/   then
                   assign p_cod_segto = "J" /*l_j*/ .
               when "Pagto Tributos" /*l_Pagto_Tributos*/  then
                   assign p_cod_segto = "N" /*l_n*/ .
               when "DOC" /*l_doc*/   then
                   assign p_cod_segto = "A" /*l_a*/ .
               when "Cr‚dito C/C" /*l_credito_cc*/   then
                   assign p_cod_segto = "A" /*l_a*/ .
               when "Cr‚dito C/P" /*l_credito_cc*/   then
                   assign p_cod_segto = "A" /*l_a*/ .
               when "Cheque ADM" /*l_cheque_adm*/   then
                   assign p_cod_segto = "A" /*l_a*/ .
               when "Ordem Pagto" /*l_ordem_pagto*/   then
                   assign p_cod_segto = "A" /*l_a*/ . 
               when 'TED CIP' /* l_ted_cip*/   then
                   assign p_cod_segto = "A" /*l_a*/ .
               when 'TED STR' /* l_ted_str*/   then
                   assign p_cod_segto = "A" /*l_a*/ .                     
           end.


/* /*            if p_cdn_segment_edi = 311 and                                             */                        */
/* /*               p_cdn_element_edi = 5133 then do:                                       */                        */
/* /*                                                                                       */                        */
/* /*                find first tt_param_program_formul where                               */                        */
/* /*                     tt_param_program_formul.tta_cdn_segment_edi = 288 and             */                        */
/* /*                     tt_param_program_formul.tta_cdn_element_edi = 3729                */                        */
/* /*                     no-lock no-error.                                                 */                        */
/* /*                if tt_param_program_formul.ttv_des_contdo = '22' then                  */                        */
/* /*                   return "N" /*l_n*/ .                                                */                        */
/* /*                else find first tt_param_program_formul where                          */                        */
/* /*                                tt_param_program_formul.tta_cdn_segment_edi = 288 and  */                        */
/* /*                                tt_param_program_formul.tta_cdn_element_edi = 3729     */                        */
/* /*                                no-lock no-error.                                      */                        */
/* /*            end.                                                                       */                        */
/* /*            else do:                                                                   */                        */
/*                find first tt_param_program_formul where                                                            */
/*                     tt_param_program_formul.tta_cdn_segment_edi = 289 and                                          */
/*                     tt_param_program_formul.tta_cdn_element_edi = 3729                                             */
/*                     no-lock no-error.                                                                              */
/*                if tt_param_program_formul.ttv_des_contdo = '22' then                                               */
/*                   return "N" /*l_n*/ .                                                                             */
/*                else find first tt_param_program_formul where                                                       */
/*                                tt_param_program_formul.tta_cdn_segment_edi = 289 and                               */
/*                                tt_param_program_formul.tta_cdn_element_edi = 3729                                  */
/*                                no-lock no-error.                                                                   */
/* /*            end.  */                                                                                             */
/*                                                                                                                    */
/*            case int(trim(tt_param_program_formul.ttv_des_contdo)):                                                 */
/*                when 1  then assign p_cod_segto = "J" /*l_J*/ .                                                     */
/*                when 2  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 3  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 4  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 5  then assign p_cod_segto = "J" /*l_J*/ .                                                     */
/*                when 6  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 7  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 8  then assign p_cod_segto = "A" /*l_A*/ .                                                     */
/*                when 20 then assign p_cod_segto = "O" /*l_o*/ .                                                     */
/*                when 22 then assign p_cod_segto = "N" /*l_n*/ .                                                     */
/*            end case.                                                                                               */
/*            find first tt_param_program_formul where                                                                */
/*                 tt_param_program_formul.tta_cdn_segment_edi = 0 and                                                */
/*                 tt_param_program_formul.tta_cdn_element_edi = 0                                                    */
/*                 no-lock no-error.                                                                                  */
/*            if p_cod_segto = "" then do:                                                                            */
/*                 case tt_param_program_formul.ttv_des_contdo:                                                       */
/*                     when 'Boleto' /* l_boleto*/  + 'Banco' /* l_banco*/    then assign p_cod_segto = "J".          */
/*                     when 'DOC' /* l_doc*/  then assign p_cod_segto = "A".                                          */
/*                     when 'Cr‚dito C/C' /* l_credito_cc*/  then assign p_cod_segto = "A".                           */
/*                     when 'Cr‚dito C/P' /* l_credito_cc*/  then assign p_cod_segto = "A".                           */
/*                     when 'Cheque ADM' /* l_cheque_adm*/  then  assign p_cod_segto = "A".                           */
/*                     when 'Ordem Pagto' /* l_ordem_pagto*/  then assign p_cod_segto = "A".                          */
/*                     when 'TED CIP' /* l_ted_cip*/  then assign p_cod_segto = "A".                                  */
/*                     when 'TED STR' /* l_ted_str*/   then assign p_cod_segto = "A".                                 */
/*                 end case.                                                                                          */
/*            end.                                                                                                    */
/*                                                                                                                    */
/*            if p_cdn_segment_edi = 309 and                                                                          */
/*               p_cdn_element_edi = 5175 then                                                                        */
/*                leave.                                                                                              */
/*                                                                                                                    */
/*            if tt_param_program_formul.ttv_des_contdo = 'Boleto' /* l_boleto*/  + 'Outros' /* l_outros*/  then do:  */
/*                find first tt_param_program_formul where                                                            */
/*                     tt_param_program_formul.tta_cdn_segment_edi = 289 and                                          */
/*                     tt_param_program_formul.tta_cdn_element_edi = 2807                                             */
/*                     no-lock no-error.                                                                              */
/*                if length(tt_param_program_formul.ttv_des_contdo) = 48 then                                         */
/*                   assign p_cod_segto = "O" /*l_o*/ .                                                               */
/*                else                                                                                                */
/*                   assign p_cod_segto = "J" /*l_J*/ .                                                               */
/*            end.                                                                                                    */
END PROCEDURE. /* pi_retorna_tp_segto */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_A
** Descricao.............: pi_segto_tipo_A
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:18:06
** Alterado por..........: corp1153
** Alterado em...........: 07/05/2009 11:44:29
*****************************************************************************/
PROCEDURE pi_segto_tipo_A:
        
        find first tt_param_program_formul where 
            tt_param_program_formul.tta_cdn_segment_edi = 289 and   
            tt_param_program_formul.tta_cdn_element_edi = 3729 no-error.

        case int(tt_param_program_formul.ttv_des_contdo):

            when 2 then /* DOC */  
                assign v_dsl_segto = '700'. /* posi‡Æo 018 a 020 (zeros) */

            when 3 then /* Crýdito Conta Corrente */
                assign v_dsl_segto = '000'. /* posi‡Æo 018 a 020 (zeros) */

            when 4 then /* Cheque Administrativo  */
                assign v_dsl_segto = '000'. /* posi‡Æo 018 a 020 (zeros) */

            when 6 then /* ORDEM DE PAGAMENTO  */
                assign v_dsl_segto = '000'. /* posi‡Æo 018 a 020 (zeros) */

            when 7 then /* TED CIP  */
                assign v_dsl_segto = '018'. /* posi‡Æo 018 a 020 (zeros) */

            when 8 then /* TED STR  */
                assign v_dsl_segto = '018'. /* posi‡Æo 018 a 020 (zeros) */
            
            otherwise
                assign v_dsl_segto = '000'. /* posi‡Æo 018 a 020 (zeros) */

        end case.
        
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and   
             tt_param_program_formul.tta_cdn_element_edi = 3729 no-error.

        assign v_cdn_tip_forma_pagto = int(tt_param_program_formul.ttv_des_contdo).

        /* * Banco do Favorecido * */
        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3737
             no-lock no-error.

        /* posi‡Æo 021 a 023 (C¢digo Banco) */
        if  v_cdn_tip_forma_pagto = 6 then /* Ordem de Pagto */
            assign v_dsl_segto = v_dsl_segto + '001'. /* Banco do Brasil */
        else
            assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999').

        assign v_cdn_bco = int(tt_param_program_formul.ttv_des_contdo).

        /* * Agˆncia Favorecido **/
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and   
             tt_param_program_formul.tta_cdn_element_edi = 3922 no-error.

        if length(tt_param_program_formul.ttv_des_contdo) > 4
            then assign v_num_inic = (length(tt_param_program_formul.ttv_des_contdo) - 3).
            else assign v_num_inic = 1.

        assign v_cod_agenc_fav = substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,4).
        
        /* * Dig Agˆncia Favorecido **/
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 5143 no-error.

        assign v_cod_dig_agenc_fav = string(tt_param_program_formul.ttv_des_contdo).

        /* * Conta Corrente Favorecido **/
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3796 no-error.

        if length(tt_param_program_formul.ttv_des_contdo) > 10
            then assign v_num_inic = (length(tt_param_program_formul.ttv_des_contdo) - 9).
            else assign v_num_inic = 1.

        assign v_cod_cta_fav = substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,10).

        /* * Dig conta Favorecido **/
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3927 no-error.

        assign v_cod_dig_cta_fav = trim(tt_param_program_formul.ttv_des_contdo).

        if  length(v_cod_dig_cta_fav) = 2 then do:
            assign v_cod_cta_fav     = trim(v_cod_cta_fav) + substring(tt_param_program_formul.ttv_des_contdo,1,1)
                   v_cod_dig_cta_fav = substring(tt_param_program_formul.ttv_des_contdo,2,1).
        end.
        if  length(v_cod_dig_cta_fav) = 0 then
            assign v_cod_dig_cta_fav = ' '.

        /* posi‡Æo 024 a 043 (Agencia/Conta Favorecido) */
        if  v_cdn_tip_forma_pagto = 6 then /* Ordem de Pagto */
            assign v_dsl_segto = v_dsl_segto + '00000'        /* Agencia do Favorecido */
                                             + '0'            /* Dig Agencia do Favorecido */
                                             + '000000000000' /* Conta do Favorecido */
                                             + '0'            /* Dig Conta do Favorecido */
                                             + ' '.           /* Dig Verificador da AG/Conta */
        else
            assign v_dsl_segto = v_dsl_segto + string(int(v_cod_agenc_fav),'99999')           /* Agencia do Favorecido */    
                                             + string(substring(v_cod_dig_agenc_fav,1,1),'x') /* Dig Agencia do Favorecido */
                                             + string(dec(v_cod_cta_fav),'999999999999')      /* Conta do Favorecido */      
                                             + string(substring(v_cod_dig_cta_fav,1,1),'x')   /* Dig Conta do Favorecido */ 
                                             + fill(' ',1).                                   /* Dig Verificador da AG/Conta */


        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3734
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posi‡Æo 044 a 073 (Nome Favorecido) */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3928
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ). /* posi‡Æo 074 a 093 (Seu N£mero) */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3709
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ) + /* posi‡Æo 094 a 101 (Data Pagamento) */
                             "BRL" /*l_BRL*/   + /* posi‡Æo 102 a 104 (Tipo Moeda) */
                             '000000000000000'. /* posi‡Æo 105 a 119 (Zeros) */

        if v_cdn_tip_forma_pagto = 4 or v_cdn_tip_forma_pagto = 6 then do:
           find first tt_param_program_formul where
                tt_param_program_formul.tta_cdn_segment_edi = 289 and
                tt_param_program_formul.tta_cdn_element_edi = 4421
                no-lock no-error.

           assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
           assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 120 a 134 (Valor Pagamento) */
        end.
        else do:
           find first tt_param_program_formul where
                tt_param_program_formul.tta_cdn_segment_edi = 289 and
                tt_param_program_formul.tta_cdn_element_edi = 4436
                no-lock no-error.
           assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
           assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 120 a 134 (Valor Pagamento) */
        end.

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3743
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + fill(' ',15) + /* posi‡Æo 135 a 149 (Nosso N£mero) */
                             fill(' ',5) + /* posi‡Æo 150 a 154 (Brancos) */
                             '00000000000000000000000' + /* posi‡Æo 155 a 177 (Zeros) */
                             fill(' ',20) + /* posi‡Æo 178 a 197 (Brancos) */
                             fill(' ',6). /* posi‡Æo 198 a 203 (Brancos) */.

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3916
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + /* string(tt_param_program_formul.ttv_des_contdo,'99999999999999')*/ fill(' ',14) + /* posi‡Æo 204 a 217 (Nr. Inscri‡Æo) */
                             fill(' ',12) + /* posi‡Æo 218 a 229 (Brancos) */
                             '0' + /* posi‡Æo 230 a 230 (Aviso ao Favorecido) */
                             fill(' ',10). /* posi‡Æo 231 a 240 (Ocorrˆncias) */
END PROCEDURE. /* pi_segto_tipo_A */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_B
** Descricao.............: pi_segto_tipo_B
** Criado por............: Wanderley Teixeira
** Criado em.............: 08/10/2014 10:18:06
*****************************************************************************/
PROCEDURE pi_segto_tipo_B:

        
    def var v_num_bloco                      as integer         no-undo. /*local*/
    def var v_num_reg_bloco                  as integer         no-undo. /*local*/
        
/********************************************************************************************/              
/*         output stream s-cdhu to value("F:\Totvs\EDI\PAGTO\BB\Testes\edi_prod.txt") append.  */
/*                                                                                             */
/*         put stream s-cdhu                                                                   */
/*             skip(2)                                                                         */
/*             "tt_segment_tot" skip                                                           */
/*             "p_cdn_segment_edi..: " p_cdn_segment_edi skip                                  */
/*             "p_cdn_element_edi..: " p_cdn_element_edi skip.                                 */
/*         for each tt_segment_tot no-lock:                                                    */
/*                                                                                             */
/*            disp stream s-cdhu                                                               */
/*                 tt_segment_tot with width 600 stream-io.                                    */
/*         end.                                                                                */
/*                                                                                             */
/*         output stream s-cdhu close.                                                         */
/********************************************************************************************/        

        /* Gera segunda parte - procura sequencia do registro */ 
        find first tt_segment_tot
             where tt_segment_tot.tta_cdn_segment_edi = p_cdn_segment_edi no-error.

        if avail tt_segment_tot
        then do:
            assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                    tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1
                    v_num_reg_bloco                    = tt_segment_tot.ttv_qtd_bloco_docto.
                    
        
        end.
        /* Atualiza somat¢ria dos blocos */
        find first tt_segment_tot
             where tt_segment_tot.tta_cdn_segment_edi = 999999 no-error.

        if avail tt_segment_tot
        then do:
            assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                    tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1.

        end.

/*         find first tt_param_program_formul where */
/*              tt_param_program_formul.tta_cdn_segment_edi = 289 and */
/*              tt_param_program_formul.tta_cdn_element_edi = 3737 */
/*              no-lock no-error. */
/*    */
/*         assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999'). /* C¢digo do banco - 001 a 003 */ */

        assign v_dsl_segto = v_dsl_segto + '001'. /* C¢digo do banco - 001 a 003 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 0 and 
             tt_param_program_formul.tta_cdn_element_edi = 2
             no-lock no-error.
        assign v_num_bloco = int(tt_param_program_formul.ttv_des_contdo) + 1.

        assign v_dsl_segto = v_dsl_segto + string(v_num_bloco,'9999') + /* Lote de servi‡o - 004 a 007 */
                                           '3' + /* Tipo de registro - 008 a 008 */
                                           string(v_num_reg_bloco,'99999') + /* Sequencia de registro - 009 a 013 */
                                           'B' +  /* C¢digo do segmento - 014 a 014 */
                                           fill(' ',3).          /* Uso exclusivo FEBRABAN - 015 a 017  */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3915
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'9').  /* Tipo de incri‡Æo - 018 a 018 */
                             
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3916 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(dec(tt_param_program_formul.ttv_des_contdo),'99999999999999'). /* Incri‡Æo do favoricido - 019 a 032  */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and   
             tt_param_program_formul.tta_cdn_element_edi = 3917 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(30)') + /* Logradouro - 033 a 062 */
                                           '00000' +                                                /* N£mero - 063 a 067 */
                                           fill(' ',15).                                            /* Complemento - 068 a 082 */           
        
        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3621 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(15)'). /* Bairro - 083 a 097 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3918 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(20)'). /* Cidade - 098 a 117 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3920 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(8)'). /* CEP - 118 a 125 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3919 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(2)'). /* UF - 126 a 127 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3606
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,1,2) + 
                                           substring(tt_param_program_formul.ttv_des_contdo,3,2) + 
                                           substring(tt_param_program_formul.ttv_des_contdo,5,4). /* Data vencimento - 128 a 135 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 4421 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999999999999999'). /* Valor documento - 136 a 150 */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 4425
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999999999999999'). /* Valor abatimento - 151 a 165 */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 4423 
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999999999999999'). /* Valor desconto - 166 a 180 */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 4422
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999999999999999'). /* Valor mora - 181 a 195 */

        find first tt_param_program_formul where 
             tt_param_program_formul.tta_cdn_segment_edi = 289 and 
             tt_param_program_formul.tta_cdn_element_edi = 4426
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999999999999999'). /* Valor multa - 196 a 210 */

        assign v_dsl_segto = v_dsl_segto + string(' ','x(15)'). /* Documento do favorecido - 211 a 225 */

        assign v_dsl_segto = v_dsl_segto + string(' ','x(1)'). /* Aviso do favorecido - 226 a 226 */

        assign v_dsl_segto = v_dsl_segto + string(' ','x(6)'). /* Uso exclusivo SIAPE - 227 a 232 */

        assign v_dsl_segto = v_dsl_segto + string(' ','x(8)'). /* Uso exclusivo FEBRABAN - 233 a 240 */

END PROCEDURE. /* pi_segto_tipo_B */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_J
** Descricao.............: pi_segto_tipo_J
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:18:22
** Alterado por..........: corp1153
** Alterado em...........: 23/03/2009 11:44:11
*****************************************************************************/
PROCEDURE pi_segto_tipo_J:

                assign v_dsl_segto = ''.
                find tt_param_program_formul
                    where tt_param_program_formul.tta_cdn_segment_edi = 289
                    and   tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.

                &if defined(BF_FIN_ALTER_CODIGO_BARRA) &then
                    assign v_num_tam_format = 10.
                &else
                    find first histor_exec_especial no-lock
                         where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/  
                         and   histor_exec_especial.cod_prog_dtsul  = "SPP_alter_codigo_barra" /*l_spp_alter_codigo_barra*/   no-error.
                    if   avail histor_exec_especial then
                         assign v_num_tam_format = 10.
                    else assign v_num_tam_format = 12.
                &endif

                if  avail tt_param_program_formul then do:
                    assign v_dec_aux    = dec(substring(tt_param_program_formul.ttv_des_contdo, 38, v_num_tam_format))
                           /* posi‡Æo 018 a 061 (C¢d. de Barras) */
                           v_dsl_segto  = substring(tt_param_program_formul.ttv_des_contdo, 01, 03) +
                                          substring(tt_param_program_formul.ttv_des_contdo, 04, 01) +
                                          substring(tt_param_program_formul.ttv_des_contdo, 33, 01) +
                                          substring(tt_param_program_formul.ttv_des_contdo, 34, 04) + 
                                          string(v_dec_aux, '9999999999')                           +
                                          substring(tt_param_program_formul.ttv_des_contdo, 05, 05) +
                                          substring(tt_param_program_formul.ttv_des_contdo, 11, 10) +
                                          substring(tt_param_program_formul.ttv_des_contdo, 22, 10).
                end.

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3734
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posi‡Æo 062 a 091 (Nome Favorecido) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3606
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posi‡Æo 092 a 099 (Data Vencimento) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 4421
                      no-lock no-error.

                 assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                 assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 100 a 114 (Valor T¡tulo) */

                 /* * Valor de Abatimentos **/
                 find first tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 4425 no-error.
                 assign v_dec_aux = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).

                 /* * Valor de Descontos **/
                 find tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 4423 no-error.
                 assign v_dec_aux2 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).

                 assign v_dec_aux = v_dec_aux + v_dec_aux2.

                 assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 115 a 129 (Valor Descontos) */

                 /* * Juros **/
                 find first tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 4422
                     no-error.
                 assign v_dec_aux = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).

                 /* * Multa **/
                 find first tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 4426
                     no-error.
                 assign v_dec_aux2 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).

                 /* * Corre‡Æo Monet ria **/
                 find tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 4437
                     no-error.
                 assign v_dec_aux3 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).

                 assign v_dec_aux = v_dec_aux + v_dec_aux2 + v_dec_aux3.

                 assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 130 a 144 (Acr‚scimos) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3709
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posi‡Æo 145 a 152 (Data Pagamento) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 4436
                      no-lock no-error.

                 assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                 assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* posi‡Æo 153 a 167 (Valor Pagamento) */
                                      '000000000000000'. /* posi‡Æo 168 a 182 (Zeros) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3928
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) + /* posi‡Æo 183 a 202 (Seu N£mero) */
                                      fill(' ',13) + /* posi‡Æo 203 a 215 (Brancos) */
                                      fill(' ',15) + /* posi‡Æo 216 a 230 (Brancos) */
                                      fill(' ',10) + CHR(10). /* posi‡Æo 231 a 240 (Brancos) */

                 RUN pi_segto_tipo_j52.

END PROCEDURE. /* pi_segto_tipo_J */




/* /***************************************************************************** */
/* ** Procedure Interna.....: pi_segto_tipo_J52                                   */
/* ** Descricao.............: pi_segto_tipo_J52                                   */
/* ** Criado por............: FLAVIO KUSSUNOKI - FKIS CONSULTORIA                 */
/* ** Criado em.............: 09/13/2017                                          */
/* *****************************************************************************/ */
procedure pi_segto_tipo_j52:
    def var num_car as integer.
    
    assign v_dsl_segto = v_dsl_segto + '001' .





                /* gera segunda parte - procura sequencia do registro */ 
                find first tt_segment_tot
                     where tt_segment_tot.tta_cdn_segment_edi = 309 no-error.

                if avail tt_segment_tot
                then do:
                    assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                            tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1
                            v_num_reg_bloco                    = tt_segment_tot.ttv_qtd_bloco_docto.
                end.

                /* Atualiza somat¢rio dos blocos*/
                find first tt_segment_tot
                     where tt_segment_tot.tta_cdn_segment_edi = 999999 no-error.
                if avail tt_segment_tot
                then do:
                    assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                            tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1
                             .
                end.

                /* localiza o bloco */
                find first tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 0
                       and tt_param_program_formul.tta_cdn_element_edi = 2
                       and tt_param_program_formul.tta_des_label_utiliz_formul_edi = 'QTD BLOCOS' no-error.
                if avail tt_param_program_formul THEN DO:


                     assign v_num_bloco = int(tt_param_program_formul.ttv_des_contdo) + 1.
                END.


                /* codigo do lote */
                assign v_dsl_segto = v_dsl_segto + string(v_num_bloco,'9999'). /* somat¢rio blocos */

                /* tipo registro */
                assign v_dsl_segto = v_dsl_segto + "3". 

                /* numero registro */
                assign v_dsl_segto = v_dsl_segto + string(v_num_reg_bloco,'99999').  /* somat½rio de registros no bloco */


/*****************************************************************************************************************************/    
   
    assign v_dsl_segto = v_dsl_segto + 'J'. /* posicao 014 a 014 (A) */

    /*Filler Branco x(003) */

    assign v_dsl_segto = v_dsl_segto + fill('0',01). /* posicao 015 a 015 */

    ASSIGN v_dsl_segto = v_dsl_segto + fill ('0',02). /* posicao 016 a 017 */
	
	assign v_dsl_segto = v_dsl_segto + '52'. /* posicao 018 a 019 */
	
	/* Sacado */
	/* Tipo de Inscrição*/
	

	find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 3710 no-error.
     
        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1).
       
			tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).
		
	find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 4643 no-error.

        if tipo-documento = 1 then 
                assign v_dsl_segto = v_dsl_segto + "0000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + "0" + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
     
    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 16 no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo).
        assign num_car = 40 - length(string(tt_param_program_formul.ttv_des_contdo)).

        assign v_dsl_segto = v_dsl_segto + fill(' ', num_car).

               
     

              	
	
	/*Tipo de Incri‡Æo do Favorecido  9(001)*/
/*    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3915 no-error.

        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1) 
               tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).*/
        
    /* cnpf ou cpf do favorecido */ 

        find       tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.


            IF LENGTH(string(tt_param_program_formul.ttv_des_contdo)) = 11 THEN
                assign v_dsl_segto = v_dsl_segto + '1' + "0000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + '2' + "0" + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
     
  find   tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.

        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo). 


        assign num_car = 40 - length(string(tt_param_program_formul.ttv_des_contdo)).

		
		assign v_dsl_segto = v_dsl_segto + fill(' ', num_car) + fill('0',1) + fill('0',15) + fill(' ',40) + fill(' ',53) + chr(10).
END PROCEDURE. /* pi_segto_tipo_j52 */




/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_N
** Descricao.............: pi_segto_tipo_N
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:21:22
** Alterado por..........: fut41420
** Alterado em...........: 11/11/2009 10:03:29
*****************************************************************************/
PROCEDURE pi_segto_tipo_N:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_pessoa_jurid
        for pessoa_jurid.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_conteudo
        as character
        format "x(40)":U
        label "Texto"
        column-label "Texto"
        no-undo.


    /************************** Variable Definition End *************************/

                 find tt_param_program_formul
                      where tt_param_program_formul.tta_cdn_segment_edi = 289
                      and   tt_param_program_formul.tta_cdn_element_edi = 4838 no-error.

                 assign v_forma_pagto = trim(tt_param_program_formul.ttv_des_contdo)
                        v_dsl_segto   = ''.

                 case v_forma_pagto:
                    when '16' then do: /* DARF */
                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 3928
                             no-lock no-error.

                        assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo.

                        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ).  /* Seu N£mero - 18 a 37*/

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 75
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + string(' ',"x(20)" /*l_x(20)*/ ). /* Nosso N£mero - 38 a 57 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 3895
                             no-lock no-error.

                        if entry(3,v_des_conteudo,';') = "N" /*l_n*/   then do:
                            find first item_bord_ap no-lock
                                 where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                   and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                            if avail item_bord_ap then
                                find first compl_impto_retid_ap
                                     where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                       and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                        end.
                        else do:
                           find first item_bord_ap_agrup no-lock
                                where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                           if avail item_bord_ap_agrup then do:
                               blk_teste:
                               for each item_bord_ap no-lock
                                  where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                    and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                    break by item_bord_ap.cod_estab:

                                   if first-of (item_bord_ap.cod_estab) then do:
                                       find first compl_impto_retid_ap
                                            where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                              and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                       if avail compl_impto_retid_ap then
                                           leave blk_teste.

                                   end.
                               end.
                           end.
                        end.

                        find first estabelecimento where 
                             estabelecimento.cod_estab = getentryfield(1,v_des_conteudo,';') no-lock no-error.
                        
                        if avail estabelecimento then do:
                            find first b_pessoa_jurid where
                                 b_pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-lock no-error.
                        end.

                        find first fornecedor where
                             fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                             fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                             no-lock no-error.

                        if avail b_pessoa_jurid then do:
                            assign v_tp_forn = 1. /* Pessoa Jur¡dica */.
                            assign v_dsl_segto = v_dsl_segto + string(b_pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte - 58 a 87 */
                        end.
                        else do:
                            if fornecedor.num_pessoa modulo 2 = 0 then do:
                                assign v_tp_forn = 2. /* Pessoa Fisica */
                                find first pessoa_fisic where
                                     pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                                     no-lock no-error.
                                assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte - 58 a 87 */
                            end.
                            else do:
                               assign v_tp_forn = 1. /* Pessoa Jur¡dica */.
                               find first pessoa_jurid where
                                    pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                                    no-lock no-error.
                               assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte - 58 a 87 */
                            end.
                        end.

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 3709
                             no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo. /* Data Pagamento - 88 a 95 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 4436
                             no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* Valor Total - 96 a 110 */
                                                           string(int(compl_impto_retid_ap.cod_classif_impto),'999999'). /* C¢digo Receita - 111 a 116 */                         
                        
                        if avail b_pessoa_jurid then do:
                            assign v_dsl_segto = v_dsl_segto + string(v_tp_forn,'99') + /* Tipo Inscri‡Æo - 117 a 118 */
                                                               string(b_pessoa_jurid.cod_id_feder,'99999999999999'). /* Identificador - 119 a 132 */
                        end.
                        else do:
                            if  v_tp_forn = 2 then /* Pessoa Fisica */
                                assign v_dsl_segto = v_dsl_segto + string(v_tp_forn,"99") + /* Tipo Inscri‡Æo - 117 a 118 */
                                                                   string(pessoa_fisic.cod_id_feder,'99999999999999'). /* Identificador - 119 a 132 */
                            else /* Pessoa Jur¡dica */
                                assign v_dsl_segto = v_dsl_segto + string(v_tp_forn,'99') + /* Tipo Inscri‡Æo - 117 a 118 */
                                                                   string(pessoa_jurid.cod_id_feder,'99999999999999'). /* Identificador - 119 a 132 */
                        end.

                        find tt_param_program_formul
                             where tt_param_program_formul.tta_cdn_segment_edi = 289
                             and   tt_param_program_formul.tta_cdn_element_edi = 4838 no-error.

                        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),"99"). /* Identifica‡Æo Tributo - 133 a 134 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 3704
                             no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Per¡odo - 135 a 142 */
                                             '00000000000000000'. /* Referˆncia - 143 a 159 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and  
                             tt_param_program_formul.tta_cdn_element_edi = 4421
                             no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* Valor Principal - 160 a 174 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 4426
                             no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* Multa - 175 a 189 */

                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 4422
                             no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* Juros / Encargos - 190 a 204 */
                        
                        find first tt_param_program_formul where
                             tt_param_program_formul.tta_cdn_segment_edi = 289 and
                             tt_param_program_formul.tta_cdn_element_edi = 3606
                             no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo. /* Data Vencimento - 205 a 212 */

                        assign v_dsl_segto = v_dsl_segto + string(' ',"x(18)" /*l_x(18)*/ ) + /* Uso Exclusivo FEBRABAN/CNAB - 213 a 230 */
                                                           string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorrˆncias - 231 a 240 */
                    end.

                    when '17' then do: /* Pagamento GPS */

                        /* Begin_Include: i_pagamento_gps_17 */  

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3928
                        no-lock no-error.

                        assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo. 

                        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x(20)*/ ). /* Seu N£mero - 18 a 37 */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 75
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + string(' ',"x(20)" /*l_x(20)*/ ). /* Nosso N£mero - 38 a 57 */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3895
                        no-lock no-error.

                        if entry(3,v_des_conteudo,';') = "N" /*l_n*/  then do:
                            find first item_bord_ap no-lock
                                 where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                   and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                            if avail item_bord_ap then do:
                                find first compl_impto_retid_ap
                                     where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                       and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                find first tit_ap of item_bord_ap no-lock no-error.
                            end. 
                        end.
                        else do:
                           find first item_bord_ap_agrup no-lock
                                where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                           if avail item_bord_ap_agrup then do:
                               blk_teste:
                               for each item_bord_ap no-lock
                                  where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                    and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                    break by item_bord_ap.cod_estab:
                                    find first tit_ap of item_bord_ap no-lock no-error.
                                    if first-of (item_bord_ap.cod_estab) then do:
                                        find first compl_impto_retid_ap
                                             where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                               and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                        if avail compl_impto_retid_ap then
                                            leave blk_teste.

                                   end.
                               end.
                           end.
                        end.

                        find first fornecedor where
                                   fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                                   fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                        no-lock no-error.

                        if fornecedor.num_pessoa modulo 2 = 0 then
                            assign v_tp_forn = 2. /* Pessoa Fisica */
                        else
                            assign v_tp_forn = 1. /* Pessoa Jur¡dica */.

                        if v_tp_forn = 1 then do:
                            find first pessoa_jurid where
                                       pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                            no-lock no-error.
                            assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte - 58 a 87 */
                        end.
                        else do:
                            find first pessoa_fisic where
                                       pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                            no-lock no-error.
                            assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte - 58 a 87 */
                        end.

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3709
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo.  /* Data Arrecada‡Æo - 88 a 95 */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4436
                        no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* Valor Arrecadado - 96 a 110 */
                                                           string(int(compl_impto_retid_ap.cod_classif_impto),'999999'). /* C¢digo da receita do Tributo - 111 a 116 */
                        
                        if trim(compl_impto_retid_ap.cod_classif_impto) = '2658' then do:
                            assign v_dsl_segto = v_dsl_segto + '04' /* CEI */. /* Tipo Inscri‡Æo - 117 a 118 */
                            
/*                             find first es_ext_tit_ap of tit_ap no-lock no-error.                                                                            */
/*                             if avail es_ext_tit_ap then do:                                                                                                 */
/*                                 find first es_contrato no-lock                                                                                              */
/*                                      where es_contrato.nr_contrato = substr(es_ext_tit_ap.cod_contrato,1,4) + "/" + substr(es_ext_tit_ap.cod_contrato,5,2)  */
/*                                        and es_contrato.cod_empreendimento = es_ext_tit_ap.cod_empreendimento                                                */
/*                                        and es_contrato.cdn_fornecedor = fornecedor.cdn_fornecedor                                                           */
/*                                        and es_contrato.tip_contrato = es_ext_tit_ap.tip_contrato no-error.                                                  */
/*                                                                                                                                                             */
/*                                 if avail es_contrato then                                                                                                   */
/*                                 assign v_cod_cei   = trim(es_contrato.cod_cei)                                                                              */
/*                                        v_cod_cei   = replace(v_cod_cei,"/","")                                                                              */
/*                                        v_cod_cei   = replace(v_cod_cei,".","")                                                                              */
/*                                        v_dsl_segto = v_dsl_segto + string(dec(v_cod_cei),'99999999999999'). /* Identificador Contribuinte - 119 a 132 */    */
/*                                 else                                                                                                                        */
/*                                     assign v_dsl_segto = v_dsl_segto + '00000000000000'. /* Identificador Contribuinte - 119 a 132 */                       */
/*                             end.                                                                                                                            */
/*                             else                                                                                                                            */
/*                                 assign v_dsl_segto = v_dsl_segto + '00000000000000'. /* Identificador Contribuinte - 119 a 132 */                           */
                        end.
                        else do:
                            if v_tp_forn = 1 then
                                assign v_dsl_segto = v_dsl_segto + string(v_tp_forn,'99') + /* Tipo Inscri‡Æo - 117 a 118 */
                                                                   string(dec(pessoa_jurid.cod_id_feder),'99999999999999'). /* Identificador Contribuinte - 119 a 132 */
                            else
                                assign v_dsl_segto = v_dsl_segto + string(v_tp_forn,'99') + /* Tipo Inscri‡Æo - 117 a 118 */
                                                                   string(dec(pessoa_fisic.cod_id_feder),'99999999999999'). /* Identificador Contribuinte - 119 a 132 */
                        end.
                        find tt_param_program_formul
                             where tt_param_program_formul.tta_cdn_segment_edi = 289
                             and   tt_param_program_formul.tta_cdn_element_edi = 4838 no-error.

                        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),"99"). /* Identifica‡Æo Tributo - 133 a 134 */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3885
                        no-lock no-error.

                        assign dt-aux = date(tt_param_program_formul.ttv_des_contdo)
                               c-mes  = month(dt-aux)
                               c-ano  = year(dt-aux)
                               c-aux  = string(c-mes,"99") + string(c-ano,'9999').

                        assign v_dsl_segto = v_dsl_segto + string(c-aux,'999999'). /* Mˆs e Ano Competˆncia - 135 a 140 */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4421
                        no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        find first classif_impto
                             where classif_impto.cod_pais          = compl_impto_retid_ap.cod_pais
                               and classif_impto.cod_unid_federac  = compl_impto_retid_ap.cod_unid_federac
                               and classif_impto.cod_imposto       = compl_impto_retid_ap.cod_imposto
                               and classif_impto.cod_classif_impto = compl_impto_retid_ap.cod_classif_impto no-lock no-error.

                        if avail classif_impto then do:
                            find first imposto
                                 where imposto.cod_pais         = classif_impto.cod_pais
                                   and imposto.cod_unid_federac = classif_impto.cod_unid_federac
                                   and imposto.cod_imposto      = classif_impto.cod_imposto no-lock no-error.

                           if avail imposto then do:
                               if imposto.ind_tip_impto = 'SEST/SENAT':U then do:                        
                                   assign v_dsl_segto = v_dsl_segto + '000000000000000' + /* Valor Tributo - 141 a 155 */
                                          string(v_dec_aux,'999999999999999') . /* Valor Outras Entidades - 156 a 170 */           
                               end. 
                               else do:
                                   assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* Valor Tributo - 141 a 155 */
                                                       '000000000000000'. /* Valor Outras Entidades 156 a 170 */                  
                               end.
                           end.
                        end. /* if classif_impto */                     

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4426  
                        no-lock no-error. 

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* Vlr Multa T¡tulo - 171 a 185 */

                        assign v_dsl_segto = v_dsl_segto + string(' ',"x(45)" /*l_x(45)*/ ) + /* Uso exclusivo FEBRABAN/CNAB - 186 a 230 */
                                                           string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorrˆncias - 231 a 240 */

                        /* End_Include: i_pagamento_gps_17 */
                    end.    

                    when '18' then do: /* DARF Simples */

                      assign v_dsl_segto = '03'. /* Identifica‡Æo Tributo */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3928
                           no-lock no-error.

                      assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo.

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3895
                           no-lock no-error.

                       if entry(3,v_des_conteudo,';') = "N" /*l_n*/   then do:
                           find first item_bord_ap no-lock
                                where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                  and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                           if avail item_bord_ap then
                               find first compl_impto_retid_ap
                                    where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                      and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                       end.
                       else do:
                           find first item_bord_ap_agrup no-lock
                                where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                           if avail item_bord_ap_agrup then do:
                               blk_teste:
                               for each item_bord_ap no-lock
                                  where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                    and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                    break by item_bord_ap.cod_estab:
                                    if first-of (item_bord_ap.cod_estab) then do:
                                        find first compl_impto_retid_ap
                                             where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                               and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                        if avail compl_impto_retid_ap then
                                            leave blk_teste.
                                    end.
                               end.
                          end.                             
                      end.

                      assign v_dsl_segto = v_dsl_segto + string(compl_impto_retid_ap.cod_classif_impto,'9999'). /* C«digo Receita */


                      find first estabelecimento where 
                          estabelecimento.cod_estab = getentryfield(1,v_des_conteudo,';') no-lock no-error.
                      if avail estabelecimento then do:
                          find first b_pessoa_jurid where
                                     b_pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-lock no-error.
                      end.

                      find first fornecedor where
                           fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                           fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                           no-lock no-error.

                      if avail b_pessoa_jurid then do:
                             assign v_tp_forn = 1. /* Pessoa Jur¡dica */.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri‡Æo */
                                                  string(b_pessoa_jurid.cod_id_feder,'99999999999999'). /* Inscri‡Æo Empresa */
                      end.
                      else do:
                          if fornecedor.num_pessoa modulo 2 = 0 then do:
                             assign v_tp_forn = 2. /* Pessoa Fisica */

                             find first pessoa_fisic where
                                  pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                                  no-lock no-error.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri‡Æo */
                                                  string(pessoa_fisic.cod_id_feder,'99999999999999'). /* Inscri‡Æo Empresa */

                          end.
                          else do:
                             assign v_tp_forn = 1. /* Pessoa Jur¡dica */.

                             find first pessoa_jurid where
                                  pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                                  no-lock no-error.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri‡Æo */
                                                  string(pessoa_jurid.cod_id_feder,'99999999999999'). /* Inscri‡Æo Empresa */
                          end.
                      end.
                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3704
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Per¡odo */
                                           string((compl_impto_retid_ap.val_rendto_tribut * 100),'999999999') + /* Receita Bruta */
                                           string((compl_impto_retid_ap.val_aliq_impto * 100),'9999') + /* Percentual */
                                           string(' ',"x(04)" /*l_x(4)*/ ). /* Brancos */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4421
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Principal */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4426
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Multa */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4422
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Juros / Encargos */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4436
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Total */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3606
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo. /* Data Vencimento */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3709
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Data Pagamento */
                                           string(' ',"x(30)" /*l_x(30)*/ ). /* Brancos */

                      if avail b_pessoa_jurid then do:
                          assign v_dsl_segto = v_dsl_segto + string(b_pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                      end.
                      else do:
                          if v_tp_forn = 2 then
                             assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                          else
                             assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).    
                      end.       

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3928
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) +  /* Seu N£mero */
                                           string(' ',"x(15)" /*l_x(15)*/ ) + /* Nosso N£mero */
                                           string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorr¼ncias */
                    end.
                 end case.

END PROCEDURE. /* pi_segto_tipo_N */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_O
** Descricao.............: pi_segto_tipo_O
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:23:26
** Alterado por..........: tech14020
** Alterado em...........: 08/09/2006 13:44:42
*****************************************************************************/
PROCEDURE pi_segto_tipo_O:

            find tt_param_program_formul
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.

            /* posi‡Æo 018 a 061 (C¢digo de barras) */
            assign v_dsl_segto  = substring(tt_param_program_formul.ttv_des_contdo, 01, 11) +
                                  substring(tt_param_program_formul.ttv_des_contdo, 13, 11) +
                                  substring(tt_param_program_formul.ttv_des_contdo, 25, 11) +
                                  substring(tt_param_program_formul.ttv_des_contdo, 37, 11).

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3734
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posi‡Æo 062 a 091 (Nome Concession ria) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3606
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posi‡Æo 092 a 99 (Data Vencimento) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3709
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posi‡Æo 100 a 107 (Data Pagamento) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 4421
                 no-lock no-error.

            assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

            assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posi‡Æo 108 a 122 (Valor Pagamento) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3928
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) + /* posi‡Æo 123 a 142 (Seu N£mero) */
                                 fill(' ',20) + /* posi‡Æo 143 a 162 (Nosso N£mero) */  
                                 fill(' ',68). /* posi‡Æo 163 a 230 (Uso exclusivo FEBRABAN) */  
                                 fill(' ',10). /* posi‡Æo 231 a 240 (Ocorrˆncias) */  
END PROCEDURE. /* pi_segto_tipo_O */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_Messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_Messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "Messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        Message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_Messages */
/*************************  End of fnc_prg_formul_39 ************************/
