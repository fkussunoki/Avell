/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: api_desmemb_bens
** Descricao.............: Aplication Program Interface
** Versao................:  1.00.00.019
** Procedimento..........: sp2_desmemb_bens
** Programa Original..........: prgfin/fas/fas404za.py
** Recebe parametros para geracao 
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.019":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.019[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i api_desmemb_bens FAS}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=2":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_bem_pat_cong no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_grp_calc                 as character format "x(6)" label "Grupo C†lculo" column-label "Grupo C†lculo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field ttv_dat_movto                    as date format "99/99/9999" label "Data Movimento" column-label "Data Movimento"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_ind_tip_param                as character format "X(08)"
    .

def temp-table tt_converter_finalid_econ no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transaá∆o" column-label "Transaá∆o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Projeá∆o" column-label "G/P Projeá∆o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers∆o" column-label "Forma Convers∆o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    .

def temp-table tt_desmembramento_bem_pat_api no-undo
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field ttv_dat_desmbrto                 as date format "99/99/9999" label "Data Desmbrto" column-label "Data Desmbrto"
    field ttv_ind_tip_desmbrto_bem_pat     as character format "X(16)"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .

def temp-table tt_desmemb_novos_bem_pat_api no-undo
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(11)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field ttv_val_origin_movto_bem_pat     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original Movto" column-label "Valor Original Movto"
    field ttv_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .

def temp-table tt_erros_cenario no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_dat_refer_sit                as date format "99/99/9999"
    index tt_id1                           is primary unique
          tta_cod_modul_dtsul              ascending
          tta_cod_empresa                  ascending
          tta_cod_cenar_ctbl               ascending
          ttv_dat_refer_sit                ascending
    .

def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    .

def temp-table tt_finalid_bem_pat_calculo no-undo
    field ttv_rec_bem_pat                  as recid format ">>>>>>9" initial ?
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    index tt_recid                         is primary unique
          ttv_rec_bem_pat                  ascending
          tta_cod_finalid_econ             ascending
    .

def temp-table tt_guarda_valor_origin no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_perc_5                   as decimal format "->>,>>>,>>>,>>9.99" decimals 10
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .

def temp-table tt_row_errors no-undo
    field ttv_num_seq_erro                 as integer format ">>>>,>>9"
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending
    .

def temp-table tt_verifica_diferenca_desmem no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_dpr_val_origin           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Valor Original" column-label "Dpr Valor Original"
    field tta_val_dpr_cm                   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Correá∆o Monet" column-label "Dpr Correá∆o Monet"
    field tta_val_dpr_incevda_val_origin   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Depreciaá∆o Incentiv" column-label "Depreciaá∆o Incentiv"
    field tta_val_dpr_incevda_cm           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Incentiv CM" column-label "Dpr Incentiv CM"
    field tta_val_cm_dpr                   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet Dpr" column-label "Correá∆o Monet Dpr"
    field tta_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_cm_dpr_incevda           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "CM Dpr Incentivada" column-label "CM Dpr Incentivada"
    field tta_val_dpr_val_origin_amort     as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizaá∆o VO" column-label "Amortizaá∆o VO"
    field tta_val_dpr_cm_amort             as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizaá∆o CM" column-label "Amortizaá∆o CM"
    field tta_val_amort_incevda_origin     as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizacao Incentiv" column-label "Amortizacao Incentiv"
    field tta_cod_tip_calc                 as character format "x(7)" label "Tipo C†lculo" column-label "Tipo C†lculo"
    field tta_ind_tip_calc                 as character format "X(20)" initial "Depreciaá∆o" label "Tipo" column-label "Tipo"
    .

def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    .



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_num_vers_integr_api
    as integer
    format ">>>>,>>9"
    no-undo.


/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

def buffer btt_desmemb_novos_bem_pat_api
    for tt_desmemb_novos_bem_pat_api.
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_aloc_bem
    for aloc_bem.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_bem_pat
    for bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_cronog_calc_pat
    for cronog_calc_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_incorp_bem_pat
    for incorp_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_desmbrto
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_implant
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_incorp
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_incorp_aux
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_param_calc_bem_pat
    for param_calc_bem_pat.
&endif
&if "{&emsfin_version}" >= "5.06" &then
def buffer b_param_calc_incorp_pat
    for param_calc_incorp_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_quant_produz
    for quant_produz.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_sdo_bem_pat
    for sdo_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_val_origin_bem_pat
    for val_origin_bem_pat.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_ccusto_000
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cenar_ctbl
    as character
    format "x(8)":U
    label "Cen†rio Cont†bil"
    column-label "Cen†rio Cont†bil"
    no-undo.
def var v_cod_cenar_ctbl_fisc
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
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
def var v_cod_finalid_aux
    as character
    format "x(8)":U
    no-undo.
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
    no-undo.
def var v_cod_finalid_econ_bem_orig
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_indic_econ
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Moeda"
    no-undo.
def var v_cod_indic_econ_bem_orig
    as character
    format "x(8)":U
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
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new shared var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.
def var v_cod_return_sit
    as character
    format "x(40)":U
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def new shared var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_execution_end
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_fim_period
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    no-undo.
def new shared var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def var v_dat_inic_valid_unid_organ
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_movimen_pat
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_des_filespec
    as character
    format "x(10)":U
    extent 10
    no-undo.
def var v_des_sit_movimen_cenar
    as character
    format "x(40)":U
    no-undo.
def var v_dsl_msg_erro
    as Character
    format "x(255)":U
    no-undo.
def var v_hdl_procedure
    as Handle
    format ">>>>>>9":U
    no-undo.
def new shared var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def new shared var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
    no-undo.
def shared var v_ind_message_output
    as character
    format "X(10)":U
    initial "Na Tela" /*l_on_Screen*/
    view-as radio-set Horizontal
    radio-buttons "Na Tela", "Na Tela", "Em Arquivo", "Em Arquivo"
     /*l_on_Screen*/ /*l_on_Screen*/ /*l_on_file*/ /*l_on_file*/
    bgcolor 8 
    no-undo.
def new shared var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_bxa_bem
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_congel_cenar_ctbl
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_connect
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_connect_ems2_ok
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_erro_integr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_reduc_sdo
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_localiz_col
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_sit_movimen_pat
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_transf_ext
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def shared var v_log_view_file
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Visualiza Arquivo"
    column-label "Visualiza Arquivo"
    no-undo.
def new shared var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def new shared var v_nom_filename
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    no-undo.
def var v_nom_filename_api
    as character
    format "x(30)":U
    label "Abatimentos"
    column-label "Abatimentos"
    no-undo.
def new shared var v_nom_name
    as character
    format "x(20)":U
    extent 10
    no-undo.
def new shared var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def new shared var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def new shared var v_nom_title
    as character
    format "x(40)":U
    no-undo.
def var v_num_bem_pat
    as integer
    format ">>>>>>>>9":U
    initial 1
    label "Bem Patrimonial"
    column-label "Bem Pat"
    no-undo.
def var v_num_mensagem
    as integer
    format ">>>>,>>9":U
    label "N£mero"
    column-label "N£mero Mensagem"
    no-undo.
def new shared var v_num_page_number
    as integer
    format ">>>>>9":U
    label "P†gina"
    column-label "P†gina"
    no-undo.
def var v_num_parc_pis_cofins
    as integer
    format "999":U
    initial 0
    label "Nro Parcelas"
    column-label "Nro Parcelas"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_bem
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_incorp_bem_pat
    as integer
    format ">>>>,>>9":U
    initial 0
    label "Seq Incorp Bem"
    column-label "Seq Incorp Bem"
    no-undo.
def var v_qtd_bem_pat_desmembr
    as decimal
    format "->>>>,>>9":U
    decimals 0
    no-undo.
def var v_qtd_bem_pat_represen
    as decimal
    format ">>>>>>>>9":U
    decimals 0
    label "Quantidade Bens Representados"
    column-label "Bem Represen"
    no-undo.
def var v_rec_b_val_origin_bem_pat
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_despes_financ
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Valor Despesa Financ"
    column-label "Val Desp Fin"
    no-undo.
def var v_val_dif
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_maior
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_original
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    initial 0
    label "Valor Original"
    column-label "Valor Original"
    no-undo.
def var v_val_original_cal
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    label "Valor Original"
    column-label "Valor Original"
    no-undo.
def var v_val_origin_bem_pat
    as decimal
    format "->>>>,>>>,>>9.9999":U
    decimals 4
    no-undo.
def var v_val_origin_desmembr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 7
    no-undo.
def var v_val_origin_moed_bem_pat
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Valor Original"
    column-label "Valor Original"
    no-undo.
def var v_val_perc_desmembr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 7
    no-undo.
def var v_val_perc_desmembr_aux
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 7
    no-undo.
def var v_val_perc_movto_bem_pat
    as decimal
    format "->>>>,>>>,>>9.9999999":U
    decimals 7
    label "Percentual Movimento"
    column-label "Percentual Movimento"
    no-undo.
def var v_val_tot_perc
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_transf
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor Transferància"
    column-label "Valor Transferància"
    no-undo.
def var v_log_param_calc_incorp          as logical         no-undo. /*local*/


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_desmemb_bens}


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('api_desmemb_bens':U, 'prgfin/fas/fas404za.py':U, '1.00.00.019':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = '@(&program)' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = '@(&program)'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */



/* Begin_Include: i_tt_trans_bem_aux */
def temp-table tt_trans_bem_aux no-undo
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_num_empresa     as integer   format '999' label 'Empresa' column-label 'Empresa'
    &ELSE
    field ttv_num_empresa     as char      format 'x(3)' label 'Empresa' column-label 'Empresa'
    &ENDIF      
    FIELD ttv_cod_cta_pat     AS CHARACTER FORMAT "x(18)" LABEL "Conta Patrimonial"             COLUMN-LABEL "Conta Patrimonial"
    FIELD ttv_num_bem_pat     AS INTEGER   FORMAT ">>>>>>>>9" INITIAL 0 LABEL "Bem Patrimonial" COLUMN-LABEL "Bem Pat"
    FIELD ttv_num_seq_bem_pat AS INTEGER   FORMAT ">>>>9"     INITIAL 0 LABEL "Sequància Bem"   COLUMN-LABEL "Sequencia"
    FIELD tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    FIELD ttv_dat_trans       AS DATE      FORMAT "99/99/9999" INITIAL ?
    FIELD ttv_situacao        AS CHARACTER FORMAT "x(20)" LABEL "Situaá∆o"                      COLUMN-LABEL "Situaá∆o"
    INDEX tt_indice_trans_bem IS PRIMARY UNIQUE
        ttv_num_empresa ASCENDING
        ttv_cod_cta_pat ASCENDING
        ttv_num_bem_pat ASCENDING
        ttv_num_seq_bem_pat ASCENDING.
/* End_Include: i_tt_trans_bem_aux */



/* Begin_Include: i_testa_funcao_reduc_sdo */
&IF DEFINED(BF_FIN_METOD_REDUC_SDO) &THEN
    assign v_log_funcao_reduc_sdo = yes.
&ELSE
    &if '{&emsuni_version}' >= '5.04' &then
        if  can-find (first emsbas.histor_exec_especial no-lock
             where emsbas.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
             and   emsbas.histor_exec_especial.cod_prog_dtsul  = 'spp_metod_reduc_sdo':U)
        then do:
            assign v_log_funcao_reduc_sdo = yes.
        end /* if */.

        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'spp_metod_reduc_sdo'      at 1 
                v_log_funcao_reduc_sdo  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */
        .
    &endif
&ENDIF
/* End_Include: i_funcao_extract */



/* Begin_Include: i_fnc_param_calc_incorp */
assign v_log_param_calc_incorp = no.

&if '{&emsbas_version}' >= '5.04' &then
    if  can-find (first emsbas.histor_exec_especial
        where emsbas.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
        and   emsbas.histor_exec_especial.cod_prog_dtsul  = 'SPP_PARAM_CALC_INCORP') then
        assign v_log_param_calc_incorp = yes.

        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'SPP_PARAM_CALC_INCORP'      at 1 
                v_log_param_calc_incorp  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */
        .
&endif 



/* End_Include: i_funcao_extract */


if  can-find(first emsbas.histor_exec_especial
    where emsbas.histor_exec_especial.cod_prog_dtsul = 'spp_cong_cenar_ctbl') then do:
    assign v_log_congel_cenar_ctbl = yes.
end.


/* Begin_Include: i_funcao_extract */
if  v_cod_arq <> '' and v_cod_arq <> ?
then do:

    output stream s-arq to value(v_cod_arq) append.

    put stream s-arq unformatted
        'spp_cong_cenar_ctbl'      at 1 
        v_log_congel_cenar_ctbl  at 43 skip.

    output stream s-arq close.

end /* if */.
/* End_Include: i_funcao_extract */



/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emsbas.histor_exec_especial NO-LOCK
         WHERE emsbas.histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND emsbas.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            SPP      at 1 
            v_log_retorno  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */
    .

    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */



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
** Procedure Interna.....: pi_efetiva_desmemb_bens
** Descricao.............: pi_efetiva_desmemb_bens
** Criado por............: its0048
** Criado em.............: 05/10/2004 15:57:57
** Alterado por..........: fut35256
** Alterado em...........: 14/12/2006 10:16:59
*****************************************************************************/
PROCEDURE pi_efetiva_desmemb_bens:

    /************************ Parameter Definition Begin ************************/

    def input-output param table 
        for tt_desmembramento_bem_pat_api.
    def input-output param table 
        for tt_desmemb_novos_bem_pat_api.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_val_tot_calc                   as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* Localizaá∆o Colìmbia */
    assign v_log_localiz_col = GetDefinedFunction('SPP_LOCALIZ_COLOMBIA').

    if  v_log_localiz_col then do:
        /* Programa Persistente para funá‰es da Localizaá∆o Colìmbia */
        if not valid-handle(v_hdl_procedure)
            or v_hdl_procedure:type       <> 'procedure':U
            or v_hdl_procedure:file-name  <> 'prgfin/lco/lco003za.py':U
            then run prgfin/lco/lco003za.py persistent set v_hdl_procedure (INPUT '',
                                                                            INPUT '',
                                                                            INPUT 0,
                                                                            INPUT 0,
                                                                            INPUT '',
                                                                            INPUT 0).
    end.

    blk_tt_desmembrto:
    for each tt_desmembramento_bem_pat_api exclusive-lock:

        if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat <> "Por Valor" /*l_por_valor*/ 
        and tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat <> "Por Quantidade" /*l_por_quantidade*/ 
        and tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat <> "Por Percentual" /*l_por_percentual*/  then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Tipo de Desmembramento Inv†lido !", "FAS") /*13626*/.
            next blk_tt_desmembrto.
        end.

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat <> "Por Valor" /*l_por_valor*/  then
            assign tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl = ''
                   tt_desmembramento_bem_pat_api.ttv_cod_indic_econ = ''.

        find first b_bem_pat
            where b_bem_pat.cod_empresa     = tt_desmembramento_bem_pat_api.tta_cod_empresa
            and   b_bem_pat.cod_cta_pat     = tt_desmembramento_bem_pat_api.tta_cod_cta_pat
            and   b_bem_pat.num_bem_pat     = tt_desmembramento_bem_pat_api.tta_num_bem_pat
            and   b_bem_pat.num_seq_bem_pat = tt_desmembramento_bem_pat_api.tta_num_seq_bem_pat exclusive-lock no-error.
        if  avail b_bem_pat then do:

            assign v_val_origin_desmembr    = 0
                   v_val_perc_movto_bem_pat = 0
                   v_val_perc_desmembr      = 0
                   v_qtd_bem_pat_desmembr   = 0
                   v_qtd_bem_pat_represen   = b_bem_pat.qtd_bem_pat_represen.

            run pi_validar_api_desmemb_bem.
            if  return-value = "NOK" /*l_nok*/  then do:
                if  tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "" then
                    assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Os bens selecionados para este desmembramento n∆o est∆o ok.", "FAS") /*13729*/.

                run pi_desmembrto_novo_bem_pat_erro /*pi_desmembrto_novo_bem_pat_erro*/.
                next blk_tt_desmembrto.
            end.

            blk_bem_novo:
            do  on error undo blk_bem_novo, leave blk_bem_novo:

                assign v_val_perc_desmembr_aux = 0.
                for each tt_desmemb_novos_bem_pat_api
                    where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto no-lock:		
                    assign v_val_perc_desmembr_aux = v_val_perc_desmembr_aux + tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat.
                end.

                for each tt_desmemb_novos_bem_pat_api
                    where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto exclusive-lock:

                    if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat <> "Por Quantidade" /*l_por_quantidade*/  then
                        assign tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen = v_qtd_bem_pat_represen.

                    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/ 
                    or tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then do:
                        assign tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat = round(((v_val_original * tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat) / 100),2)
                               v_val_tot_perc   = v_val_tot_perc         + tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat
                               v_val_tot_transf = round(v_val_tot_transf + tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat,2).

                        if abs(v_val_maior) < abs(tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat) then
                            assign v_val_maior   = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat
                                   v_num_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
                                   v_num_seq_bem = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat.
                    end.

                    run pi_validar_novos_bens_api /*pi_validar_novos_bens_api*/.
                    if  return-value = "NOK" /*l_nok*/  then do:
                        if  tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "" then
                            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Os novos bens selecionados para este desmembramento n∆o est∆o ok.", "FAS") /*13981*/.

                        run pi_desmembrto_novo_bem_pat_erro /*pi_desmembrto_novo_bem_pat_erro*/.
                        undo blk_bem_novo, leave blk_bem_novo.
                    end.

                    run pi_efetiva_desmemb_bens_more /*pi_efetiva_desmemb_bens_more*/.

                    find bem_pat no-lock
                        where bem_pat.cod_empresa     = v_cod_empres_usuar
                        and   bem_pat.cod_cta_pat     = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat
                        and   bem_pat.num_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
                        and   bem_pat.num_seq_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat no-error.
                    if  not avail bem_pat then do:
                        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Verifique se existe o Bem Patrimonial implantado por desmembramento.", "FAS") /*873*/.
                        if  tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "" then
                            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Os novos bens selecionados para este desmembramento n∆o est∆o ok.", "FAS") /*13981*/.

                        run pi_desmembrto_novo_bem_pat_erro /*pi_desmembrto_novo_bem_pat_erro*/.
                        undo blk_bem_novo, leave blk_bem_novo.
                    end.

                    run pi_validar_param_ctbz_cta_pat (buffer bem_pat,
                                                       Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                                       output v_cod_return) /*pi_validar_param_ctbz_cta_pat*/.
                    if  return-value <> "OK" /*l_ok*/  then do:
                        case entry(1, v_cod_return, chr(10)):
                            when '1111' then
                                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado !", "FAS") /*1111*/.
                            when '3347' then
                                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Conta Cont†bil &1 n∆o utiliza o Centro de Custo &2 !", "FAS") /*3347*/, entry(2,v_cod_return, chr(10)), entry(3,v_cod_return, chr(10))).
                            when '950' then
                                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FAS") /*950*/, entry(2,v_cod_return, chr(10)), entry(3,v_cod_return, chr(10))).
                            when '1253' then
                                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Centro Custo &1 Inv†lido para a Unidade Neg¢cio &2 !", "FAS") /*1253*/, entry(2,v_cod_return, chr(10)), entry(3,v_cod_return, chr(10))).
                            when '5729' then
                                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Existe restriá∆o do ccusto &1 no estabelecimento: &2 !", "FAS") /*5729*/, entry(2,v_cod_return, chr(10)), entry(3,v_cod_return, chr(10))).
                        end.

                        case entry(1, v_cod_return, chr(10)):
                            when '1111' or
                            when '3347' or
                            when '950'  or
                            when '1253' or
                            when '5729' then do:
                                if  tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "" then
                                    assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Os novos bens selecionados para este desmembramento n∆o est∆o ok.", "FAS") /*13981*/.

                                run pi_desmembrto_novo_bem_pat_erro /*pi_desmembrto_novo_bem_pat_erro*/.
                                undo blk_bem_novo, leave blk_bem_novo.
                            end.
                        end.
                    end.
                end.

                find utiliz_cenar_ctbl no-lock
                    where utiliz_cenar_ctbl.cod_empresa    = b_bem_pat.cod_empresa
                    and   utiliz_cenar_ctbl.log_cenar_fisc = yes no-error.
                if avail utiliz_cenar_ctbl then
                    assign v_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.

                find first histor_finalid_econ no-lock
                    where histor_finalid_econ.cod_indic_econ          = b_bem_pat.cod_indic_econ
                    and   histor_finalid_econ.dat_inic_valid_finalid <= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
                    and   histor_finalid_econ.dat_fim_valid_finalid   > tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-error.
                if avail histor_finalid_econ then
                    assign v_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.

                find last b_val_origin_bem_pat no-lock
                    where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                    and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = 0
                    and   b_val_origin_bem_pat.cod_cenar_ctbl         = v_cod_cenar_ctbl
                    and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
                if avail b_val_origin_bem_pat then
                    assign v_val_original = b_val_origin_bem_pat.val_original.
                else
                    assign v_val_original = b_bem_pat.val_original.

                if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
                    assign v_val_tot_calc = round(((v_val_original * v_val_tot_perc) / 100),2)
                           v_val_dif      = (v_val_tot_calc - v_val_tot_transf).

                    if v_val_dif <> 0 then do:
                        find first tt_desmemb_novos_bem_pat_api exclusive-lock
                            where tt_desmemb_novos_bem_pat_api.tta_num_bem_pat     = v_num_bem_pat
                            and   tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat = v_num_seq_bem no-error.
                        if avail tt_desmemb_novos_bem_pat_api then
                            assign tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat = (tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat + v_val_dif).

                        find first bem_pat no-lock 
                            where bem_pat.cod_empresa     = tt_desmembramento_bem_pat_api.tta_cod_empresa
                            and   bem_pat.cod_cta_pat     = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat             
                            and   bem_pat.num_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
                            and   bem_pat.num_seq_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat no-error.
                        if avail bem_pat then do:
                            find first movto_bem_pat exclusive-lock
                                where movto_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat no-error.
                            assign movto_bem_pat.val_origin_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat.
                        end.
                    end.
                end.

                run pi_baixa_bem_desmemb_incorp /*pi_baixa_bem_desmemb_incorp*/.
                if  return-value = "NOK" /*l_nok*/  then do:
                    if  tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "" then
                        assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Os novos bens selecionados para este desmembramento n∆o est∆o ok.", "FAS") /*13981*/.

                    run pi_desmembrto_novo_bem_pat_erro /*pi_desmembrto_novo_bem_pat_erro*/.
                    undo blk_bem_novo, leave blk_bem_novo.
                end.

            end. /* blk_bem_novo */
        end. /* if avail b_bem_pat then do*/
        else
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Bem n∆o encontrado na base de dados.", "FAS") /*10727*/.
    end.

    if  valid-handle(v_hdl_procedure) then
        delete procedure v_hdl_procedure.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_efetiva_desmemb_bens */
/*****************************************************************************
** Procedure Interna.....: pi_validar_param_ctbz_cta_pat_desm
** Descricao.............: pi_validar_param_ctbz_cta_pat_desm
** Criado por............: src12337
** Criado em.............: 16/10/2001 13:36:14
** Alterado por..........: Menna
** Alterado em...........: 30/10/2002 17:03:18
*****************************************************************************/
PROCEDURE pi_validar_param_ctbz_cta_pat_desm:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_bem_pat
        for bem_pat.
    def Input param p_dat_movto_bem_pat
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    blk_param:
    for each param_calc_bem_pat
        where param_calc_bem_pat.num_id_bem_pat = p_bem_pat.num_id_bem_pat
        and   param_calc_bem_pat.cod_tip_calc  <> ''
        no-lock:
        find finalid_econ
            where finalid_econ.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            no-lock no-error.
        if  avail finalid_econ and
            finalid_econ.ind_armaz_val = "Ativo Fixo" /*l_ativo_fixo*/ 
        then do:
            next blk_param.
        end /* if */.
        find first param_ctbz_cta_pat no-lock
            where param_ctbz_cta_pat.cod_empresa      = p_bem_pat.cod_empresa
            and   param_ctbz_cta_pat.cod_cta_pat      = p_bem_pat.cod_cta_pat
            and   param_ctbz_cta_pat.cod_cenar_ctbl   = param_calc_bem_pat.cod_cenar_ctbl
            and   param_ctbz_cta_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   param_ctbz_cta_pat.ind_finalid_ctbl = "Desmembramento" /*l_desmembramento*/ 
            and   param_ctbz_cta_pat.dat_inic_valid  <= p_dat_movto_bem_pat
            and   param_ctbz_cta_pat.dat_fim_valid   >= p_dat_movto_bem_pat
            no-error.
        if  not avail param_ctbz_cta_pat
        then do:
            assign p_cod_return = "1111" + chr(10) + p_bem_pat.cod_cta_pat + chr(10) + "Desmembramento" /*l_desmembramento*/  + chr(10) +
                                  param_calc_bem_pat.cod_finalid_econ + chr(10) + param_calc_bem_pat.cod_cenar_ctbl.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end.
    return "OK" /*l_ok*/ .

END PROCEDURE. /* pi_validar_param_ctbz_cta_pat_desm */
/*****************************************************************************
** Procedure Interna.....: pi_validar_api_desmemb_bem
** Descricao.............: pi_validar_api_desmemb_bem
** Criado por............: its0048
** Criado em.............: 06/10/2004 15:58:30
** Alterado por..........: its0105
** Alterado em...........: 12/07/2005 16:41:14
*****************************************************************************/
PROCEDURE pi_validar_api_desmemb_bem:

    assign v_num_parc_pis_cofins = &if '{&emsuni_version}' >= '5.06' &then
                                       b_bem_pat.num_parc_pis_cofins
                                   &else
                                       if num-entries(b_bem_pat.cod_livre_1,";")  > 3 then int(entry(4,b_bem_pat.cod_livre_1,';')) else 0
                                   &endif
                                   .
    if  v_num_parc_pis_cofins > 0 then do:
        /* Enquanto as APIÔs de Reclassificaá∆o e Desmembramento n∆o estiverem preparadas para a contabilizaá∆o do credito parcelado PIS COFINS
         * nao ser† possivel fazer estas movimentaá‰es atravÇs das API quando o bem estiver parametrizado para o credito parcelado. */
        assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("O bem selecionado para &2 est† parametrizado para que o crÇdito de PIS / COFINS seja parcelado." + chr(10) +
    "" + chr(10) +
    "As movimentaá‰es de crÇdito parcelado devem ser feitas atravÇs do processo on-line na rotina de Desmobilizaá‰es.", "FAS") /*14047*/, getStrTrans("Desmembrar", "FAS") /*l_desmembrar*/ , getStrTrans("Desmembramento", "FAS") /*l_desmembramento*/ ).
        return "NOK" /*l_nok*/ .
        /* ************************************************************************************************************************ */
    end.

    find first param_calc_bem_pat
        where param_calc_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat no-lock no-error.
    if avail param_calc_bem_pat then do:
        assign v_log_sit_movimen_pat = no
               v_dat_movimen_pat     = ?.
        run pi_sit_movimen_pat(input recid(param_calc_bem_pat),
                               input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                               output v_log_sit_movimen_pat,
                               output v_dat_movimen_pat).
        if  not v_log_sit_movimen_pat then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Data &1 est† fora do per°odo de movimentaá∆o patrimonial !", "FAS") /*394*/, tt_desmembramento_bem_pat_api.ttv_dat_desmbrto).
            return "NOK" /*l_nok*/ .
        end.
    end.

    for each tt_desmemb_novos_bem_pat_api
        where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto exclusive-lock:
        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
            if  tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat > 0 then do:
                assign v_val_perc_movto_bem_pat = v_val_perc_movto_bem_pat + tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat.
                if  v_val_perc_movto_bem_pat > 100 then do:
                    /* erro 864 - Percentual do Desmembramento passa dos 100% do Bem ! */
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("O(s) percentual(is) informado(s) totalizam &1%. Eles n∆o podem ultrapassar os 100% do Bem Patrimonial.", "FAS") /*864*/, v_val_perc_movto_bem_pat).
                    return "NOK" /*l_nok*/ .
                end.
            end.
            else do:
                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Informe o valor do percentual maior que 0 e menor que 100.", "FAS") /*645*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        else do:
            if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then do:
                assign tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen = round(tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen, 0).
                if tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen <= 0 then do:
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Informe quantidade maior que zero", "FAS") /*1179*/.
                    return "NOK" /*l_nok*/ .
                end.
            end.
            else do:
                if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
                    if tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat <= 0 then do:
                        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor do Movimento deve ser maior que zero.", "FAS") /*8359*/.
                        return "NOK" /*l_nok*/ .
                    end.
                end.
            end.
        end.
    end.

    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
        find indic_econ no-lock
            where indic_econ.cod_indic_econ = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ no-error.
        if not avail indic_econ then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Indicador Econìmico Inexistente !", "FAS") /*241*/.
            return "NOK" /*l_nok*/ .
        end.

        run pi_retornar_finalid_indic_econ (Input tt_desmembramento_bem_pat_api.ttv_cod_indic_econ,
                                            Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                            output v_cod_finalid_econ).
        if v_cod_finalid_econ = '' then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("N∆o existe finalidade para indicador econìmico e data !", "FAS") /*698*/.
            return "NOK" /*l_nok*/ .
        end.

        run pi_retornar_dat_inic_valid_unid_organ (Input v_cod_empres_usuar,
                                                   Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                                   output v_dat_inic_valid_unid_organ).

        run pi_validar_finalid_unid_organ (Input v_cod_finalid_econ,
                                           Input tt_desmembramento_bem_pat_api.tta_cod_empresa,
                                           Input v_dat_inic_valid_unid_organ,
                                           output v_cod_return).
        if  v_cod_return = "338" then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Finalidade n∆o liberada para a Unidade Organizacional !", "FAS") /*338*/.
            return "NOK" /*l_nok*/ .
        end.

        run pi_validar_cenar_ctbl (Input tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl,
                                   Input v_cod_empres_usuar,
                                   Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                   output v_num_mensagem).
        if v_num_mensagem <> 0 then do:
            if v_num_mensagem = 2568 then
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Usu†rio sem permiss∆o para manipular todos os cen†rios !", "FAS") /*2568*/.
            if v_num_mensagem = 2557 then
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Usu†rio sem permiss∆o para manipular o cen†rio cont†bil !", "FAS") /*2557*/.
            if v_num_mensagem = 1494 then
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Expirou Validade do Cen†rio para a Empresa !", "FAS") /*1494*/.
            if v_num_mensagem = 1495 then
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Empresa n∆o utiliza o Cen†rio Cont†bil !", "FAS") /*1495*/.

            return "NOK" /*l_nok*/ .
        end.

        run pi_validar_finalid_utiliz_cenar (Input tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl,
                                             Input b_bem_pat.cod_empresa,
                                             Input v_cod_finalid_econ,
                                             Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                             output v_cod_return).
        case entry(1, v_cod_return):
            when '1915' then
            code_block:
            do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Expirou Validade da Finalidade para o Cen†rio !", "FAS") /*1915*/.
                return "NOK" /*l_nok*/ .
            end.
            when '1916' then
            code_block:
            do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Cen†rio Cont†bil n∆o utiliza a Finalidade Econìmica !", "FAS") /*1916*/.
                return "NOK" /*l_nok*/ .
            end.
        end.

        /* valida se o bem tem contrato de leasing, e se o fim desse contrato Ç menor que a data do movimento,
        se for, ira†ser validado se o bem tem registro de calculo de implantacao por aquisicao, caso nao
        tenha ira† apresentar uma messagem, avisando que o usu†rio tem que gerar os calculos de apropriacao
        de leasing antes de fazer a movimentacao */
        find first contrat_leas
            where contrat_leas.cod_contrat_leas = b_bem_pat.cod_contrat_leas
            and   contrat_leas.cod_arrendador   = b_bem_pat.cod_arrendador no-lock no-error.
        if avail contrat_leas then do: 
            if contrat_leas.dat_fim_valid <= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto then do: 
                if not(can-find(first reg_calc_bem_pat
                                where reg_calc_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat
                                and   reg_calc_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/  )) then do:
                    assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Bem com contrato de leasing sem apropriaá∆o.", "FAS") /*9160*/.
                    return "NOK" /*l_nok*/ .
                end.
            end.
        end.

        find last val_origin_bem_pat no-lock
            where val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
            and val_origin_bem_pat.num_seq_incorp_bem_pat = 0
            and val_origin_bem_pat.cod_cenar_ctbl         = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
            and val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
        if not avail val_origin_bem_pat then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor Original inexistente para o bem nesta moeda e cen†rio !", "FAS") /*769*/.
            return "NOK" /*l_nok*/ .
        end.

        assign v_val_origin_bem_pat = val_origin_bem_pat.val_original
               v_val_original_cal   = val_origin_bem_pat.val_original
               v_val_despes_financ  = val_origin_bem_pat.val_despes_financ.

        acumula_incorp_bem_pat_block:
        for each incorp_bem_pat no-lock
            where incorp_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
            find last val_origin_bem_pat no-lock
                where val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
                and val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                and val_origin_bem_pat.cod_cenar_ctbl         = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                and val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
            if  avail val_origin_bem_pat then
                assign v_val_original_cal  = v_val_original_cal  + val_origin_bem_pat.val_original
                       v_val_despes_financ = v_val_despes_financ + val_origin_bem_pat.val_despes_financ.
        end.
    end.
    else do:
        if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/ 
        and v_qtd_bem_pat_represen <= 1 then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("N∆o Ç possivel fazer Desmembramento por Quantidade para Bens que representam apenas 1 unidade.", "FAS") /*14092*/.
            return "NOK" /*l_nok*/ .
        end.

        run pi_retornar_finalid_econ_corren_estab (Input b_bem_pat.cod_estab,
                                                   output v_cod_finalid_econ).
        find last val_origin_bem_pat no-lock
            where val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
            and   val_origin_bem_pat.num_seq_incorp_bem_pat = 0
            and   val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
        if not avail val_origin_bem_pat then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor Original inexistente para o bem nesta moeda e cen†rio !", "FAS") /*769*/.
            return "NOK" /*l_nok*/ .
        end.

        assign v_val_origin_bem_pat = val_origin_bem_pat.val_original
               v_val_original_cal   = val_origin_bem_pat.val_original
               v_val_despes_financ  = val_origin_bem_pat.val_despes_financ.

        /* valida se o bem tem contrato de leasing, e se o fim desse contrato Ç menor que a data do movimento,
        se for, ira†ser validado se o bem tem registro de calculo de implantacao por aquisicao, caso nao
        tenha ira†apresentar uma messagem, avisando que o usuario tem que gerar os calculos de apropriacao
        de leasing antes de fazer a movimentacao */
        find first contrat_leas
            where contrat_leas.cod_contrat_leas = b_bem_pat.cod_contrat_leas
            and   contrat_leas.cod_arrendador   = b_bem_pat.cod_arrendador no-lock no-error.
        if  avail contrat_leas
        and contrat_leas.dat_fim_valid <= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
        and not(can-find(first reg_calc_bem_pat
                          where reg_calc_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                          and   reg_calc_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/  )) then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Bem com contrato de leasing sem apropriaá∆o.", "FAS") /*9160*/.
            return "NOK" /*l_nok*/ .
        end.

        for each incorp_bem_pat no-lock
            where incorp_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
            find last val_origin_bem_pat no-lock
                where val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                and   val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                and   val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
            if  avail val_origin_bem_pat then
                assign v_val_original_cal  = v_val_original_cal  + val_origin_bem_pat.val_original
                       v_val_despes_financ = v_val_despes_financ + val_origin_bem_pat.val_despes_financ.
        end.
    end.

    run pi_validar_param_ctbz_cta_pat_desm (buffer b_bem_pat,
                                            Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                            output v_cod_return) /*pi_validar_param_ctbz_cta_pat_desm*/.
    if  return-value <> "OK" /*l_ok*/  then do:
        assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado !", "FAS") /*1111*/.
        return "NOK" /*l_nok*/ .
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_api_desmemb_bem */
/*****************************************************************************
** Procedure Interna.....: pi_validar_estab
** Descricao.............: pi_validar_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: src12337
** Alterado em...........: 23/03/2001 08:01:00
*****************************************************************************/
PROCEDURE pi_validar_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find emsuni.unid_organ no-lock
         where unid_organ.cod_unid_organ = p_cod_estab /*cl_estab of unid_organ*/ no-error.
    if  avail unid_organ
    then do:
        if  p_dat_transacao <> ? and
           (p_dat_transacao < unid_organ.dat_inic_valid or
            p_dat_transacao > unid_organ.dat_fim_valid)
        then do:
            assign p_cod_return = "Unidade Organizacional" /*l_unid_organ*/ .
            return.
        end /* if */.
    end /* if */.
    else do:
        assign p_cod_return = "Unidade Organizacional" /*l_unid_organ*/ .
        return.
    end /* else */.
    if  p_cod_empresa <> ?
    then do:
        find estabelecimento no-lock
             where estabelecimento.cod_estab = p_cod_estab /*cl_param_estab of estabelecimento*/ no-error.
        if  avail estabelecimento and
            estabelecimento.cod_empresa <> p_cod_empresa
        then do:
            assign p_cod_return = "Empresa" /*l_empresa*/ .
            return.
        end /* if */.
    end /* if */.
    if  can-find(emsuni.segur_unid_organ
            where segur_unid_organ.cod_unid_organ = p_cod_estab
              and segur_unid_organ.cod_grp_usuar = '*' /*cl_valid_estab_todos_usuarios of segur_unid_organ*/)
            then do:
        /* todos os usu†rio podem acessar */
       assign p_cod_return = "".
       return.
    end /* if */.
    contr_block:
    for
       each usuar_grp_usuar no-lock
       where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren
    &if "{&emsbas_version}" >= "5.01" &then
       use-index srgrpsr_usuario
    &endif
        /*cl_grupos_do_usuario of usuar_grp_usuar*/:
       find first emsuni.segur_unid_organ no-lock
            where segur_unid_organ.cod_unid_organ = p_cod_estab
              and segur_unid_organ.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar /*cl_valida_estab of segur_unid_organ*/ no-error.
       if  avail segur_unid_organ
       then do:
          assign p_cod_return = "".
          return.
       end /* if */.
    end /* for contr_block */.
    assign p_cod_return = "Usu†rio" /*l_usuario*/ .

END PROCEDURE. /* pi_validar_estab */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_utiliz_funcao
** Descricao.............: pi_verifica_utiliz_funcao
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41675_3
** Alterado em...........: 12/04/2011 09:14:39
*****************************************************************************/
PROCEDURE pi_verifica_utiliz_funcao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_funcao_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def output param p_log_param_utiliz_produt_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* funcao: */
    case p_cod_funcao_negoc:
       when "UNID_NEG" /*l_unid_neg*/ then assign p_cod_funcao_negoc = 'BU'.

       when "CMCAC" /*l_cmcac*/ then    assign p_cod_funcao_negoc = 'CCC'.

    end /* case funcao */.

    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) &THEN
        assign p_log_param_utiliz_produt_val = yes.
    &ELSE
        if  p_cod_empresa = ""
        then do:
           assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                          where param_utiliz_produt.cod_funcao_negoc = p_cod_funcao_negoc /*cl_verifica_utiliz_funcao_funcao of param_utiliz_produt*/).
        end /* if */.
        else do:
           if  p_cod_empresa = v_cod_empres_usuar
           then do:
              assign p_log_param_utiliz_produt_val = can-do(v_cod_funcao_negoc_empres,trim(p_cod_funcao_negoc)).
           end /* if */.
           else do:
              assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                             where param_utiliz_produt.cod_empresa = p_cod_empresa
                                                               and param_utiliz_produt.cod_modul_dtsul = ''
                                                               and param_utiliz_produt.cod_funcao_negoc = p_cod_funcao_negoc /*cl_verifica_utiliz_funcao_empresa of param_utiliz_produt*/).
           end /* else */.
        end /* else */.
    &ENDIF
END PROCEDURE. /* pi_verifica_utiliz_funcao */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_unid_negoc
** Descricao.............: pi_verifica_segur_unid_negoc
** Criado por............: Henke
** Criado em.............: 06/02/1996 13:59:16
** Alterado por..........: corp45591
** Alterado em...........: 14/11/2011 11:33:53
*****************************************************************************/
PROCEDURE pi_verifica_segur_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    if  can-find(segur_unid_negoc
        where segur_unid_negoc.cod_unid_negoc = p_cod_unid_negoc
          and segur_unid_negoc.cod_grp_usuar = "*" /*l_**/ )
    then do:
        assign p_log_return = yes.
        return.
        /* tem permiss∆o*/
    end.
    for
       each usuar_grp_usuar no-lock
       where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
       find first segur_unid_negoc no-lock
            where segur_unid_negoc.cod_unid_negoc = p_cod_unid_negoc
              and segur_unid_negoc.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar no-error.
       if  avail segur_unid_negoc
       then do:
            assign p_log_return = yes.
            return.
           /* tem permiss∆o*/
        END.
    END.
END PROCEDURE. /* pi_verifica_segur_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto
** Descricao.............: pi_validar_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Puccini
** Alterado em...........: 16/10/1998 10:09:15
*****************************************************************************/
PROCEDURE pi_validar_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_inic_valid
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim_valid
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    p_log_return = no.
    find first emsuni.ccusto no-lock
         where ccusto.cod_empresa      = p_cod_empresa
           and ccusto.cod_plano_ccusto = p_cod_plano_ccusto
           and ccusto.cod_ccusto       = p_cod_ccusto no-error.
    if  not avail ccusto
    then do:
        return.
    end /* if */.
    find first plano_ccusto no-lock
         where plano_ccusto.cod_empresa = ccusto.cod_empresa
           and plano_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
          no-error.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid <> ?
    then do:
        if  not(ccusto.dat_inic_valid <= p_dat_inic_valid
        and ccusto.dat_fim_valid  >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
        if  not(plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        and plano_ccusto.dat_fim_valid >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid = ?
    then do:
        if  not ccusto.dat_inic_valid <= p_dat_inic_valid
        or  not ccusto.dat_fim_valid >= p_dat_inic_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid = ? and p_dat_fim_valid <> ?
    then do:
        if  not ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    assign p_log_return = yes.
END PROCEDURE. /* pi_validar_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_validar_param_ctbz_cta_pat
** Descricao.............: pi_validar_param_ctbz_cta_pat
** Criado por............: Puccini
** Criado em.............: 29/12/1998 08:55:28
** Alterado por..........: src12337
** Alterado em...........: 28/02/2002 16:37:08
*****************************************************************************/
PROCEDURE pi_validar_param_ctbz_cta_pat:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_bem_pat
        for bem_pat.
    def Input param p_dat_movto_bem_pat
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    def var v_cod_cta_ctbl
        as character
        format "x(20)":U
        label "Conta Cont†bil"
        column-label "Conta Cont†bil"
        no-undo.
    def var v_cod_plano_ccusto
        as character
        format "x(8)":U
        label "Plano CCusto"
        column-label "Plano CCusto"
        no-undo.
    def var v_cod_plano_cta_ctbl
        as character
        format "x(8)":U
        label "Plano Contas"
        column-label "Plano Contas"
        no-undo.
    def var v_cod_unid_negoc
        as character
        format "x(3)":U
        label "Unid Neg¢cio"
        column-label "Un Neg"
        no-undo.
    def var v_ind_finalid_ctbl
        as character
        format "X(30)":U
        label "Finalidade Cont†bil"
        column-label "Finalidade Cont†bil"
        no-undo.
    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_mensagem
        as integer
        format ">>>>,>>9":U
        label "N£mero"
        column-label "N£mero Mensagem"
        no-undo.


    /************************** Variable Definition End *************************/

    blk_param:
    for each param_calc_bem_pat
        where param_calc_bem_pat.num_id_bem_pat = p_bem_pat.num_id_bem_pat
        and   param_calc_bem_pat.cod_tip_calc  <> ""
        no-lock:

        find finalid_econ
            where finalid_econ.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            no-lock no-error.
        if  avail finalid_econ and
            finalid_econ.ind_armaz_val = "Ativo Fixo" /*l_ativo_fixo*/ 
        then do:
            next blk_param.
        end /* if */.

        find tip_calc
            where tip_calc.cod_tip_calc = param_calc_bem_pat.cod_tip_calc
            no-lock no-error.
        if  not avail tip_calc
        then do:
            next blk_param.
        end /* if */.

        find first param_ctbz_cta_pat no-lock
            where param_ctbz_cta_pat.cod_empresa      = p_bem_pat.cod_empresa
            and   param_ctbz_cta_pat.cod_cta_pat      = p_bem_pat.cod_cta_pat
            and   param_ctbz_cta_pat.cod_cenar_ctbl   = param_calc_bem_pat.cod_cenar_ctbl
            and   param_ctbz_cta_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   param_ctbz_cta_pat.ind_finalid_ctbl = tip_calc.ind_tip_calc
            and   param_ctbz_cta_pat.dat_inic_valid  <= p_dat_movto_bem_pat
            and   param_ctbz_cta_pat.dat_fim_valid   >= p_dat_movto_bem_pat
            no-error.

        if  not avail param_ctbz_cta_pat
        then do:
            assign p_cod_return = "1111" + chr(10) + p_bem_pat.cod_cta_pat + chr(10) + tip_calc.ind_tip_calc + chr(10) +
                                  param_calc_bem_pat.cod_finalid_econ + chr(10) + param_calc_bem_pat.cod_cenar_ctbl.
            return "NOK" /*l_nok*/ .
        end /* if */.

        if  tip_calc.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  or
            tip_calc.ind_tip_calc = "Amortizaá∆o" /*l_amortizacao*/ 
        then do:

            if  not can-find(first aloc_bem where aloc_bem.num_id_bem_pat = p_bem_pat.num_id_bem_pat)
            then do:
                run pi_validar_cta_ctbl_distrib_ccusto_1 (Input p_bem_pat.cod_empresa,
                                                          Input p_bem_pat.cod_estab,
                                                          Input param_ctbz_cta_pat.cod_plano_cta_ctbl,
                                                          Input param_ctbz_cta_pat.cod_cta_ctbl_db,
                                                          Input p_bem_pat.cod_plano_ccusto,
                                                          Input p_bem_pat.cod_ccusto_respons,
                                                          Input p_dat_movto_bem_pat,
                                                          output v_log_return,
                                                          output v_cod_return) /*pi_validar_cta_ctbl_distrib_ccusto_1*/.
                if  v_log_return <> yes
                then do:
                    assign p_cod_return = "3347" + chr(10) + param_ctbz_cta_pat.cod_cta_ctbl_db + chr(10) +
                                          p_bem_pat.cod_ccusto_respons.
                    return "NOK" /*l_nok*/ .
                end /* if */.
                run pi_validar_ccusto_unid_negoc_estab (Input p_bem_pat.cod_empresa,
                                                        Input p_bem_pat.cod_plano_ccusto,
                                                        Input p_bem_pat.cod_ccusto_respons,
                                                        Input p_bem_pat.cod_unid_negoc,
                                                        Input p_bem_pat.cod_estab,
                                                        output v_num_mensagem) /*pi_validar_ccusto_unid_negoc_estab*/.
                /* error_block: */
                case v_num_mensagem:
                    when 950 then
                        erro_950:
                        do:
                            assign p_cod_return = "950" + chr(10) + p_bem_pat.cod_unid_negoc + chr(10) + p_bem_pat.cod_estab.
                            return "NOK" /*l_nok*/ .
                        end /* do erro_950 */.
                    when 1253 then
                        erro_1253:
                        do:
                            assign p_cod_return = "1253" + chr(10) + p_bem_pat.cod_ccusto_respons + chr(10) + p_bem_pat.cod_unid_negoc.
                            return "NOK" /*l_nok*/ .
                        end /* do erro_1253 */.
                    when 1388 then
                        erro_1388:
                        do:
                            assign p_cod_return = "5729" + chr(10) + p_bem_pat.cod_ccusto_respons + chr(10) + p_bem_pat.cod_estab.
                            return "NOK" /*l_nok*/ .
                        end /* do erro_1388 */.
                end /* case error_block */.
            end /* if */.
            else do:
                blk_aloc:
                for each aloc_bem no-lock
                    where aloc_bem.num_id_bem_pat = p_bem_pat.num_id_bem_pat:
                    if  aloc_bem.dat_inic_valid <= p_dat_movto_bem_pat and
                         aloc_bem.dat_fim_valid  >= p_dat_movto_bem_pat
                    then do:

                        run pi_validar_cta_ctbl_distrib_ccusto_1 (Input p_bem_pat.cod_empresa,
                                                                  Input p_bem_pat.cod_estab,
                                                                  Input param_ctbz_cta_pat.cod_plano_cta_ctbl,
                                                                  Input param_ctbz_cta_pat.cod_cta_ctbl_db,
                                                                  Input aloc_bem.cod_plano_ccusto,
                                                                  Input aloc_bem.cod_ccusto,
                                                                  Input p_dat_movto_bem_pat,
                                                                  output v_log_return,
                                                                  output v_cod_return) /*pi_validar_cta_ctbl_distrib_ccusto_1*/.
                        if  v_log_return <> yes
                        then do:
                            assign p_cod_return = "3347" + chr(10) + param_ctbz_cta_pat.cod_cta_ctbl_db + chr(10) +
                                                  aloc_bem.cod_ccusto.
                            return "NOK" /*l_nok*/ .
                        end /* if */.
                        run pi_validar_ccusto_unid_negoc_estab (Input p_bem_pat.cod_empresa,
                                                                Input aloc_bem.cod_plano_ccusto,
                                                                Input aloc_bem.cod_ccusto,
                                                                Input aloc_bem.cod_unid_negoc,
                                                                Input p_bem_pat.cod_estab,
                                                                output v_num_mensagem) /*pi_validar_ccusto_unid_negoc_estab*/.
                        /* error_block: */
                        case v_num_mensagem:
                            when 950 then
                                erro_950:
                                do:
                                    assign p_cod_return = "950" + chr(10) + aloc_bem.cod_unid_negoc + chr(10) + p_bem_pat.cod_estab.
                                    return "NOK" /*l_nok*/ .
                                end /* do erro_950 */.
                            when 1253 then
                                erro_1253:
                                do:
                                    assign p_cod_return = "1253" + chr(10) + aloc_bem.cod_ccusto + chr(10) + aloc_bem.cod_unid_negoc.
                                    return "NOK" /*l_nok*/ .
                                end /* do erro_1253 */.
                            when 1388 then
                                erro_1388:
                                do:
                                    assign p_cod_return = "5729" + chr(10) + aloc_bem.cod_ccusto + chr(10) + p_bem_pat.cod_estab.
                                    return "NOK" /*l_nok*/ .
                                end /* do erro_1388 */.
                        end /* case error_block */.
                    end /* if */.                
                end /* for blk_aloc */.
            end /* if */.

            if  tip_calc.cod_tip_calc_cm_dpr <> ""
            then do:        
                assign v_ind_finalid_ctbl = if tip_calc.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  then "CM Depreciaá∆o" /*l_cm_depreciacao*/  else "CM Amortizaá∆o" /*l_cm_amortizacao*/ .
                find first param_ctbz_cta_pat no-lock
                    where param_ctbz_cta_pat.cod_empresa      = p_bem_pat.cod_empresa
                    and   param_ctbz_cta_pat.cod_cta_pat      = p_bem_pat.cod_cta_pat
                    and   param_ctbz_cta_pat.cod_cenar_ctbl   = param_calc_bem_pat.cod_cenar_ctbl
                    and   param_ctbz_cta_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
                    and   param_ctbz_cta_pat.ind_finalid_ctbl = v_ind_finalid_ctbl
                    and   param_ctbz_cta_pat.dat_inic_valid  <= p_dat_movto_bem_pat
                    and   param_ctbz_cta_pat.dat_fim_valid   >= p_dat_movto_bem_pat
                    no-error.

                if  not avail param_ctbz_cta_pat
                then do:
                    assign p_cod_return = "1111" + chr(10) + p_bem_pat.cod_cta_pat + chr(10) + v_ind_finalid_ctbl + chr(10) +
                                          param_calc_bem_pat.cod_finalid_econ + chr(10) + param_calc_bem_pat.cod_cenar_ctbl.
                    return "NOK" /*l_nok*/ .
                end /* if */.
            end /* if */.
        end /* if */.
    end /* for blk_param */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_param_ctbz_cta_pat */
/*****************************************************************************
** Procedure Interna.....: pi_validar_cta_ctbl_distrib_ccusto
** Descricao.............: pi_validar_cta_ctbl_distrib_ccusto
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: Puccini
** Alterado em...........: 02/02/1999 16:19:58
*****************************************************************************/
PROCEDURE pi_validar_cta_ctbl_distrib_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/


    assign p_log_return = no.
    if  p_dat_refer_ent = ?
    then do:
        find last criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab /*cl_verificar_cta_ctbl_utiliz_ccusto of criter_distrib_cta_ctbl*/ no-error.
    end /* if */.
    else do:
        find first criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab
               and criter_distrib_cta_ctbl.dat_inic_valid <= p_dat_refer_ent
               and criter_distrib_cta_ctbl.dat_fim_valid > p_dat_refer_ent /*cl_verificar_cta_ctbl_utiliz_ccusto_dat of criter_distrib_cta_ctbl*/ no-error.
    end /* else */.

    if  not avail criter_distrib_cta_ctbl
    then do:
       return.
    end /* if */.
    if  (avail plano_ccusto) and
         plano_ccusto.cod_empresa = p_cod_empresa and
         plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
    then do:
       run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                    output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
      find plano_ccusto no-lock
           where plano_ccusto.cod_empresa = p_cod_empresa
             and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
      if  avail plano_ccusto
      then do:
         run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                      output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
      end /* if */.
      else do:
         return.
      end /* else */.
    end /* else */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ 
    or  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Autom†tica" /*l_automatica*/ 
    then do:
        if  (p_cod_plano_ccusto <> ?
        and   p_cod_plano_ccusto <> "")
        or  (p_cod_ccusto <> v_cod_ccusto_000)
        then do:
            return.
        end /* if */.
        else do:
            assign p_log_return = yes.
            return.
        end /* else */.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos" /*l_utiliza_todos*/ 
    then do:
        if  (p_cod_plano_ccusto <> ?
        and   p_cod_plano_ccusto <> "")
        /* and  (p_cod_ccusto <> v_cod_ccusto_000) */
        then do:
            assign p_log_return = yes.
            return.
        end /* if */.
        else do:
            return.
        end /* else */.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
    then do:
        if  (p_cod_plano_ccusto = ?
        or    p_cod_plano_ccusto = "")
        /* or   (p_cod_ccusto = v_cod_ccusto_000) */
        then do:
            return.
        end /* if */.
        find mapa_distrib_ccusto no-lock
             where mapa_distrib_ccusto.cod_estab = criter_distrib_cta_ctbl.cod_estab
               and mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
              no-error.
        if  p_dat_refer_ent <> ? and
           (p_dat_refer_ent <  mapa_distrib_ccusto.dat_inic_valid   or
            p_dat_refer_ent >= mapa_distrib_ccusto.dat_fim_valid)
        then do:
            return.
        end /* if */.
        find item_lista_ccusto no-lock
             where item_lista_ccusto.cod_estab = p_cod_estab
               and item_lista_ccusto.cod_mapa_distrib_ccusto = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
               and item_lista_ccusto.cod_empresa = p_cod_empresa
               and item_lista_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and item_lista_ccusto.cod_ccusto = p_cod_ccusto /*cl_validar_cta_ctbl_distrib_ccusto of item_lista_ccusto*/ no-error.
        if  not avail item_lista_ccusto
        then do:
            return.
        end /* if */.
        else do:
            assign p_log_return = yes.
        end /* else */.
    end /* if */.

END PROCEDURE. /* pi_validar_cta_ctbl_distrib_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto_unid_negoc_estab
** Descricao.............: pi_validar_ccusto_unid_negoc_estab
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: Rafael
** Alterado em...........: 21/08/1997 15:17:43
*****************************************************************************/
PROCEDURE pi_validar_ccusto_unid_negoc_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.


    /************************** Variable Definition End *************************/

    if  p_cod_estab <> "" and
        p_cod_unid_negoc <> ""
    then do:
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  not avail estab_unid_negoc
        then do:
            assign p_num_mensagem = 950.
            return.
        end /* if */.
    end /* if */.
    if  avail plano_ccusto and
        plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto and
        plano_ccusto.cod_empresa = p_cod_empresa
    then do:
        run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                     output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
        if  p_cod_plano_ccusto <> ""
        then do:
           find plano_ccusto no-lock
                where plano_ccusto.cod_empresa = p_cod_empresa
                  and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
           if  avail plano_ccusto
           then do:
              run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                           output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
           end /* if */.
           else do:
              assign v_cod_ccusto_000 = "".
           end /* else */.
        end /* if */.
        else do:
           assign v_cod_ccusto_000 = "".
        end /* else */.
    end /* else */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_unid_negoc   <> ""
    then do:
        find ccusto_unid_negoc no-lock
             where ccusto_unid_negoc.cod_empresa = p_cod_empresa
               and ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto
               and ccusto_unid_negoc.cod_ccusto = p_cod_ccusto
               and ccusto_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_validar_ccusto_unid_negoc_estab of ccusto_unid_negoc*/ no-error.
        if  not avail ccusto_unid_negoc
        then do:
            assign p_num_mensagem = 1253.
            return.
        end /* if */.
    end /* if */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_estab        <> ""
    then do:
        find restric_ccusto no-lock
             where restric_ccusto.cod_empresa = p_cod_empresa
               and restric_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and restric_ccusto.cod_ccusto = p_cod_ccusto
               and restric_ccusto.cod_estab = p_cod_estab /*cl_validar_ccusto_unid_negoc_estab of restric_ccusto*/ no-error.
        if  avail restric_ccusto
        then do:
            assign p_num_mensagem = 1388.
            return.
        end /* if */.
    end /* if */.
    assign p_num_mensagem = 0.
END PROCEDURE. /* pi_validar_ccusto_unid_negoc_estab */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_ccusto_inic
** Descricao.............: pi_retornar_ccusto_inic
** Criado por............: pasold
** Criado em.............: 26/08/1996 14:12:15
** Alterado por..........: bre18473
** Alterado em...........: 17/02/2000 09:58:41
*****************************************************************************/
PROCEDURE pi_retornar_ccusto_inic:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format_ccusto
        as character
        format "x(11)"
        no-undo.
    def output param p_cod_ccusto_000
        as Character
        format "x(11)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count = 1.
           v_cod_ccusto_000 = "".

    contador:
    do while v_num_count <= length(p_cod_format_ccusto):
        if  substring(p_cod_format_ccusto,v_num_count,1) <> "-"
        and substring(p_cod_format_ccusto,v_num_count,1) <> ","
        and substring(p_cod_format_ccusto,v_num_count,1) <> "."
        then do:
            if  substring(p_cod_format_ccusto,v_num_count,1) = "!"
            then do:
                assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_ccusto,v_num_count,1) = "9"
                or  substring(p_cod_format_ccusto,v_num_count,1) = "x" /*l_X*/ 
                then do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + "0".
                end /* if */.
                else do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(32).
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
    assign p_cod_ccusto_000 = v_cod_ccusto_000.
END PROCEDURE. /* pi_retornar_ccusto_inic */
/*****************************************************************************
** Procedure Interna.....: pi_validar_novos_bens_api
** Descricao.............: pi_validar_novos_bens_api
** Criado por............: its0048
** Criado em.............: 07/10/2004 11:28:09
** Alterado por..........: its0105
** Alterado em...........: 28/06/2005 11:18:10
*****************************************************************************/
PROCEDURE pi_validar_novos_bens_api:

    find bem_pat no-lock
        where bem_pat.cod_empresa     = v_cod_empres_usuar
        and   bem_pat.cod_cta_pat     = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat
        and   bem_pat.num_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
        and   bem_pat.num_seq_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat no-error.
    if  avail bem_pat then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Bem Patrimonial informado j† existe !", "FAS") /*851*/.
        return "NOK" /*l_nok*/ .
    end.

    if  v_log_congel_cenar_ctbl then do:
        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            EMPTY TEMP-TABLE tt_bem_pat_cong NO-ERROR.
        &ELSE
            FOR EACH tt_bem_pat_cong:
                DELETE tt_bem_pat_cong.
            END.
        &ENDIF

        create tt_bem_pat_cong.
        assign tt_bem_pat_cong.tta_num_id_bem_pat = b_bem_pat.num_id_bem_pat
               tt_bem_pat_cong.ttv_dat_movto      = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
               tt_bem_pat_cong.ttv_ind_tip_param  = "B" /*l_b*/ .
    end.

    if  search("prgfin/fgl/fgl721za.r") = ? and search("prgfin/fgl/fgl721za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl721za.py".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl721za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl721za.py (Input table tt_bem_pat_cong,
                                Input v_cod_empres_usuar,
                                Input "FAS" /*l_fas*/,
                                Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                output v_des_sit_movimen_cenar,
                                output table tt_erros_cenario) /*prg_fnc_consiste_cenar_ctbl*/.

    if v_des_sit_movimen_cenar <> '' and not can-do(v_des_sit_movimen_cenar,"Habilitado" /*l_habilitado*/ ) then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("N∆o foi encontrada uma situaá∆o para o m¢dulo que estivesse habilitada na data fornecida. Reveja as situaá‰es do m¢dulo ou forneáa uma data que esteja em um per°odo habilitado.", "FAS") /*872*/.
        return "NOK" /*l_nok*/ .
    end.
    else do:
        find first tt_erros_cenario no-error.
        if  avail tt_erros_cenario then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Data &1 est† em um per°odo desabilitado para o cen†rio &2 no m¢dulo &3.", "FAS") /*11992*/, tt_erros_cenario.ttv_dat_refer_sit, tt_erros_cenario.tta_cod_cenar_ctbl, tt_erros_cenario.tta_cod_modul_dtsul).
            return "NOK" /*l_nok*/ .
        end.
    end.

    find cta_pat no-lock
        where cta_pat.cod_empresa = v_cod_empres_usuar
        and   cta_pat.cod_cta_pat = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat no-error.
    if not avail cta_pat then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Conta Patrimonial n∆o cadastrada !", "FAS") /*708*/.
        return "NOK" /*l_nok*/ .
    end.

    if tt_desmemb_novos_bem_pat_api.tta_num_bem_pat = 0 then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("N£mero do Bem Patrimonial deve ser informado !", "FAS") /*844*/.
        return "NOK" /*l_nok*/ .
    end.
    if tt_desmemb_novos_bem_pat_api.tta_des_bem_pat = '' then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Descriá∆o do novo bem deve ser informada !", "FAS") /*1000*/.
        return "NOK" /*l_nok*/ .
    end.
    if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/ 
    and tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat = 0 then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor Original deve ser informado !", "FAS") /*409*/.
        return "NOK" /*l_nok*/ .
    end.
    if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/ 
    and tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat = 0 then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Percentual deve ser maior que 0 e menor que 100 !", "FAS") /*411*/.
        return "NOK" /*l_nok*/ .
    end.
    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/ 
    and tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen = 0 then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Quantidade da Baixa apresenta erro !", "FAS") /*431*/.
        return "NOK" /*l_nok*/ .
    end.

    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
        run pi_desmemb_por_valor.
        if return-value = "NOK" /*l_nok*/  then
            return "NOK" /*l_nok*/ .
    end.
    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then do:
        run pi_desmemb_por_quantidade.
        if return-value = "NOK" /*l_nok*/  then
            return "NOK" /*l_nok*/ .
    end.
    if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
        run pi_desmemb_por_percentual.
        if return-value = "NOK" /*l_nok*/  then
            return "NOK" /*l_nok*/ .
    end.

    run pi_validar_estab (input v_cod_empres_usuar,
                          input tt_desmemb_novos_bem_pat_api.tta_cod_estab,
                          input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                          output v_cod_return).
    case entry(1, v_cod_return):
        when '347' then
        code_block:
        do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Estabelecimento n∆o habilitado como Unidade Organizacional !", "FAS") /*347*/.
            return "NOK" /*l_nok*/ .
        end.
        when '348' then
        code_block:
        do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Usu†rio sem permiss∆o para acessar o estabelecimento &1 !", "FAS") /*348*/,tt_desmemb_novos_bem_pat_api.tta_cod_estab).
            return "NOK" /*l_nok*/ .
        end.
        when '512' then
        code_block:
        do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Empresa do Estabelecimento Diferente da Empresa do Usu†rio !", "FAS") /*512*/.
            return "NOK" /*l_nok*/ .
        end.
    end.

    run pi_verifica_utiliz_funcao (input "BU" /*l_BU*/ ,
                                   input v_cod_empres_usuar,
                                   output v_log_return).
    if v_log_return then do:
        run pi_validar_unid_negoc (input tt_desmemb_novos_bem_pat_api.tta_cod_estab,
                                   input tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc,
                                   input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                   output v_cod_return).
        if v_cod_return <> '' then do:
            case entry(1, v_cod_return):
                when '684' then
                code_block:
                do:
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Unidade de Neg¢cio &2 n∆o est† relacionada ao Estab:  &1 !", "FAS") /*684*/, tt_desmemb_novos_bem_pat_api.tta_cod_estab).
                    return "NOK" /*l_nok*/ .
                end.
                when '617' then
                code_block:
                do:
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Unidade Neg¢cio &1 fora de validade !", "FAS") /*617*/, tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc).
                    return "NOK" /*l_nok*/ .
                end.
                when '683' then
                code_block:
                do:
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Usu†rio sem permiss∆o para acessar a Unidade de Neg¢cio &1 !", "FAS") /*683*/, tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc).
                    return "NOK" /*l_nok*/ .
                end.
            end.
        end.
    end.

    find first emsuni.unid_negoc
        where unid_negoc.cod_unid_negoc = tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc no-lock no-error.
    if avail unid_negoc then do:
        run pi_verifica_segur_unid_negoc (input unid_negoc.cod_unid_negoc,
                                          output v_log_return).
        if not v_log_return then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Plano Centro de Custo inexistente !", "FAS") /*238*/.
            return "NOK" /*l_nok*/ .
        end.
    end.

    run pi_validar_ccusto (input v_cod_empres_usuar,
                           input tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto,
                           input tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons,
                           input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                           input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                           output v_log_return).
    if not v_log_return then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Centro de Custo Respons inv†lido na data do movimento !", "FAS") /*870*/.
        return "NOK" /*l_nok*/ .
    end.

    run pi_validar_ccusto_unid_negoc_estab (Input v_cod_empres_usuar,
                                            Input tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto,
                                            Input tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons,
                                            Input tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc,
                                            Input tt_desmemb_novos_bem_pat_api.tta_cod_estab,
                                            output v_num_mensagem).
    case v_num_mensagem:
        when 950 then
        erro_950:
        do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FAS") /*950*/, tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc, tt_desmemb_novos_bem_pat_api.tta_cod_estab).
            return "NOK" /*l_nok*/ .
        end.
        when 1253 then
        erro_1253:
        do:
            /* erro 1253*/
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Centro Custo &1 Inv†lido para a Unidade Neg¢cio &2 !", "FAS") /*1253*/, tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons, tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc).
            return "NOK" /*l_nok*/ .
        end.
        when 1388 then
        erro_1388:
        do:
            /* erro 1388*/
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Existe restriá∆o deste ccusto no estabelecimento: &1 !", "FAS") /*1388*/,tt_desmemb_novos_bem_pat_api.tta_cod_estab).
            return "NOK" /*l_nok*/ .
        end.
    end.

    param_block:
    for each param_calc_cta
        where param_calc_cta.cod_empresa = tt_desmembramento_bem_pat_api.tta_cod_empresa
        and   param_calc_cta.cod_cta_pat = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat
        and   param_calc_cta.cod_tip_calc  <> '' no-lock:

        find first finalid_econ
            where finalid_econ.cod_finalid_econ = param_calc_cta.cod_finalid_econ no-lock no-error.
        if  avail finalid_econ and finalid_econ.ind_armaz_val = "Ativo Fixo" /*l_ativo_fixo*/  then
            next param_block.

        find first param_ctbz_cta_pat no-lock
            where param_ctbz_cta_pat.cod_empresa      = param_calc_cta.cod_empresa
            and   param_ctbz_cta_pat.cod_cta_pat      = param_calc_cta.cod_cta_pat
            and   param_ctbz_cta_pat.cod_cenar_ctbl   = param_calc_cta.cod_cenar_ctbl
            and   param_ctbz_cta_pat.cod_finalid_econ = param_calc_cta.cod_finalid_econ
            and   param_ctbz_cta_pat.ind_finalid_ctbl = "Desmembramento" /*l_desmembramento*/  
            and   param_ctbz_cta_pat.dat_inic_valid  <= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
            and   param_ctbz_cta_pat.dat_fim_valid   >= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-error.
        if  not avail param_ctbz_cta_pat then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado !", "FAS") /*1111*/.
            return "NOK" /*l_nok*/ .
        end.
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_novos_bens_api */
/*****************************************************************************
** Procedure Interna.....: pi_efetiva_desmemb_bens_more
** Descricao.............: pi_efetiva_desmemb_bens_more
** Criado por............: its0048
** Criado em.............: 07/10/2004 17:17:15
** Alterado por..........: fut41422
** Alterado em...........: 21/01/2015 16:05:44
*****************************************************************************/
PROCEDURE pi_efetiva_desmemb_bens_more:

    /************************* Variable Definition Begin ************************/

    def var v_qtd_dias_vida_util
        as decimal
        format ">>>,>>>,>>9":U
        decimals 0
        no-undo.


    /************************** Variable Definition End *************************/

    find first cta_pat
        where cta_pat.cod_empresa = v_cod_empres_usuar
        and   cta_pat.cod_cta_pat = tt_desmemb_novos_bem_pat_api.tta_cod_cta no-lock no-error.
    if avail cta_pat then do:
        create bem_pat.
        assign bem_pat.cod_empresa     = v_cod_empres_usuar
               bem_pat.cod_cta_pat     = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat
               bem_pat.num_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
               bem_pat.num_seq_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat
               bem_pat.des_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_des_bem_pat
               bem_pat.cod_ident_cop   = ''
               bem_pat.ind_orig_bem    = "Desmembramento" /*l_desmembramento*/ .

        if  tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then
            assign bem_pat.qtd_bem_pat_represen = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen.
        else
            assign bem_pat.qtd_bem_pat_represen = v_qtd_bem_pat_represen.

        assign bem_pat.ind_period_invent          = b_bem_pat.ind_period_invent
               bem_pat.qtd_interv_invent          = b_bem_pat.qtd_interv_invent
               bem_pat.cb3_ident_visual           = ?
               bem_pat.dat_aquis_bem_pat          = b_bem_pat.dat_aquis_bem_pat
               bem_pat.cod_estab                  = tt_desmemb_novos_bem_pat_api.tta_cod_estab
               bem_pat.cod_grp_calc               = cta_pat.cod_grp_calc
               bem_pat.ind_periodic_invent        = b_bem_pat.ind_periodic_invent
               bem_pat.val_perc_bxa               = 0
               bem_pat.cod_espec_bem              = b_bem_pat.cod_espec_bem
               bem_pat.cod_marca                  = b_bem_pat.cod_marca
               bem_pat.cod_modelo                 = b_bem_pat.cod_modelo
               bem_pat.cod_licenc_uso             = b_bem_pat.cod_licenc_uso
               bem_pat.cod_especif_tec            = b_bem_pat.cod_especif_tec
               bem_pat.cod_arrendador             = b_bem_pat.cod_arrendador
               bem_pat.cod_contrat_leas           = b_bem_pat.cod_contrat_leas
               bem_pat.cod_estado_fisic_bem_pat   = b_bem_pat.cod_estado_fisic_bem_pat
               bem_pat.cdn_fornecedor             = b_bem_pat.cdn_fornecedor
               bem_pat.cod_localiz                = b_bem_pat.cod_localiz
               bem_pat.cod_usuario                = b_bem_pat.cod_usuario
               bem_pat.cod_plano_ccusto           = tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto
               bem_pat.cod_ccusto_respons         = tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons
               bem_pat.des_anot_tab               = b_bem_pat.des_anot_tab
               bem_pat.cod_unid_negoc             = tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc
               bem_pat.cod_imagem                 = b_bem_pat.cod_imagem
               bem_pat.dat_calc_pat               = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
               bem_pat.cod_indic_econ             = v_cod_indic_econ
               bem_pat.val_original               = round(v_val_origin_bem_pat * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100),2)
               bem_pat.val_despes_financ          = v_val_despes_financ * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100)
               bem_pat.dat_refer                  = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
               bem_pat.log_informa_quant_produz   = b_bem_pat.log_informa_quant_produz
               bem_pat.cod_indic_econ_avaliac     = b_bem_pat.cod_indic_econ_avaliac
               bem_pat.val_avaliac_apol_seguro    = b_bem_pat.val_avaliac_apol_seguro
               bem_pat.dat_avaliac_apol_seguro    = b_bem_pat.dat_avaliac_apol_seguro.

        /* ------------- MP 66 --------------*/ 
        if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then do:
            &if '{&emsuni_version}' >= '5.06' &then
                assign bem_pat.log_bem_imptdo    = b_bem_pat.log_bem_imptdo
                       bem_pat.log_cr_pis        = b_bem_pat.log_cr_pis
                       bem_pat.log_cr_cofins     = b_bem_pat.log_cr_cofins
                       bem_pat.log_cr_csll       = b_bem_pat.log_cr_csll
                       bem_pat.num_exerc_cr_csll = b_bem_pat.num_exerc_cr_csll.
            &else
                assign bem_pat.cod_livre_1 = 'no;no;no;0;0;0;no;0'.

                /* Bem Importado */
                if  num-entries(b_bem_pat.cod_livre_1,";") > 0 then
                    assign entry(1, bem_pat.cod_livre_1, ';') = entry(1, b_bem_pat.cod_livre_1, ';').
                else
                    assign entry(1, bem_pat.cod_livre_1, ';') = 'no'.

                /* Credito PIS */
                if  num-entries(b_bem_pat.cod_livre_1,";") > 1
                and entry(2, b_bem_pat.cod_livre_1, ';') = 'yes' then
                    assign entry(2, bem_pat.cod_livre_1, ';') = 'yes'.
                else
                    assign entry(2, bem_pat.cod_livre_1, ';') = 'no'.

                /* Credito COFINS */
                if  num-entries(b_bem_pat.cod_livre_1,";") > 2
                and entry(3, b_bem_pat.cod_livre_1, ';') = 'yes' then
                    assign entry(3, bem_pat.cod_livre_1, ';') = 'yes'.
                else
                    assign entry(3, bem_pat.cod_livre_1, ';') = 'no'.

                /* Credito CSLL */
                if  num-entries(b_bem_pat.cod_livre_1,";") > 6
                and entry(7, b_bem_pat.cod_livre_1, ';') = 'yes' then
                    assign entry(7, bem_pat.cod_livre_1, ';') = 'yes'.
                else
                    assign entry(7, bem_pat.cod_livre_1, ';') = 'no'.

                /* N£mero Exerc°cios Credito CSLL */
                if  num-entries(b_bem_pat.cod_livre_1,";") > 7 then
                    assign entry(8, bem_pat.cod_livre_1, ';') = entry(8, b_bem_pat.cod_livre_1, ';').
                else
                    assign entry(8, bem_pat.cod_livre_1, ';') = '0'.
            &endif
        end.
        /* ----------------------------------*/

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then
            assign bem_pat.val_original = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat.

        if b_bem_pat.dat_ult_invent > tt_desmembramento_bem_pat_api.ttv_dat_desmbrto then
            assign bem_pat.dat_ult_invent = b_bem_pat.dat_ult_invent.
        else
            assign bem_pat.dat_ult_invent = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto.

        validate bem_pat.

        /* ***************************************/
        for each param_calc_cta no-lock
            where param_calc_cta.cod_empresa = bem_pat.cod_empresa
            and   param_calc_cta.cod_cta_pat = bem_pat.cod_cta_pat:
            create param_calc_bem_pat.
            assign param_calc_bem_pat.cod_tip_calc               = param_calc_cta.cod_tip_calc
                   param_calc_bem_pat.cod_cenar_ctbl             = param_calc_cta.cod_cenar_ctbl
                   param_calc_bem_pat.cod_finalid_econ           = param_calc_cta.cod_finalid_econ
                   param_calc_bem_pat.num_id_bem_pat             = bem_pat.num_id_bem_pat
                   param_calc_bem_pat.dat_inic_calc              = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
                   param_calc_bem_pat.cod_grp_calc               = param_calc_cta.cod_grp_calc
                   param_calc_bem_pat.qtd_anos_vida_util         = param_calc_cta.qtd_anos_vida_util
                   param_calc_bem_pat.qtd_unid_vida_util         = param_calc_cta.qtd_unid_vida_util
                   param_calc_bem_pat.val_perc_anual_dpr         = param_calc_cta.val_perc_anual_dpr
                   param_calc_bem_pat.val_perc_anual_dpr_incevda = param_calc_cta.val_perc_anual_dpr_incevda.
            if v_log_funcao_reduc_sdo then
                assign &if '{&emsuni_version}' >= '5.06' &then
                           param_calc_bem_pat.val_perc_anual_reduc_sdo = param_calc_bem_pat.val_perc_anual_reduc_sdo
                       &else
                           param_calc_bem_pat.cod_livre_1 = param_calc_bem_pat.cod_livre_1
                       &endif
                       .

            /* Localizaá∆o Colìmbia */
            if  v_log_localiz_col then do:
                find tip_calc no-lock
                    where tip_calc.cod_tip_calc = param_calc_cta.cod_tip_calc no-error.
                if (avail tip_calc and
                   (tip_calc.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  OR 
                    tip_calc.ind_tip_calc = "Amortizaá∆o" /*l_amortizacao*/ ))
                then do:
                    run pi_colext_retorna_param_calc_cta 
                         in v_hdl_procedure (INPUT  param_calc_cta.cod_empresa,
                                             INPUT  param_calc_cta.cod_cta_pat,
                                             INPUT  param_calc_cta.cod_tip_calc,
                                             INPUT  param_calc_cta.cod_cenar_ctbl,
                                             INPUT  param_calc_cta.cod_finalid_econ,
                                             OUTPUT v_qtd_dias_vida_util).

                    run pi_colext_inclui_param_calc_bem_pat 
                        in v_hdl_procedure (INPUT  param_calc_bem_pat.num_id_bem_pat,
                                            INPUT  param_calc_bem_pat.cod_tip_calc,
                                            INPUT  param_calc_bem_pat.cod_cenar_ctbl,
                                            INPUT  param_calc_bem_pat.cod_finalid_econ,
                                            INPUT  v_qtd_dias_vida_util).
                end.
            end.


        /* ***************************************/
            find b_param_calc_bem_pat no-lock
                where b_param_calc_bem_pat.num_id_bem_pat   = b_bem_pat.num_id_bem_pat
                and   b_param_calc_bem_pat.cod_tip_calc     = param_calc_cta.cod_tip_calc
                and   b_param_calc_bem_pat.cod_cenar_ctbl   = param_calc_cta.cod_cenar_ctbl
                and   b_param_calc_bem_pat.cod_finalid_econ = param_calc_cta.cod_finalid_econ no-error.
            if avail b_param_calc_bem_pat then do:
                assign param_calc_bem_pat.qtd_anos_vida_util         = b_param_calc_bem_pat.qtd_anos_vida_util
                       param_calc_bem_pat.qtd_unid_vida_util         = b_param_calc_bem_pat.qtd_unid_vida_util
                       param_calc_bem_pat.val_perc_anual_dpr         = b_param_calc_bem_pat.val_perc_anual_dpr
                       param_calc_bem_pat.val_perc_anual_dpr_incevda = b_param_calc_bem_pat.val_perc_anual_dpr_incevda.
                if v_log_funcao_reduc_sdo then
                    assign &if '{&emsuni_version}' >= '5.06' &then
                               param_calc_bem_pat.val_perc_anual_reduc_sdo = b_param_calc_bem_pat.val_perc_anual_reduc_sdo
                           &else
                               param_calc_bem_pat.cod_livre_1 = b_param_calc_bem_pat.cod_livre_1
                           &endif
                           .

               /* Localizaá∆o Colìmbia */
               if  v_log_localiz_col
               then do:
                   find tip_calc no-lock
                       where tip_calc.cod_tip_calc = param_calc_cta.cod_tip_calc no-error.
                   if (avail tip_calc and
                       (tip_calc.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  OR 
                        tip_calc.ind_tip_calc = "Amortizaá∆o" /*l_amortizacao*/ ))
                   then do:
                       run pi_colext_retorna_param_calc_bem_pat 
                            in v_hdl_procedure (INPUT  b_param_calc_bem_pat.num_id_bem_pat,
                                                INPUT  b_param_calc_bem_pat.cod_tip_calc,
                                                INPUT  b_param_calc_bem_pat.cod_cenar_ctbl,
                                                INPUT  b_param_calc_bem_pat.cod_finalid_econ,
                                                OUTPUT v_qtd_dias_vida_util).

                       run pi_colext_inclui_param_calc_bem_pat 
                            in v_hdl_procedure (INPUT  param_calc_bem_pat.num_id_bem_pat,
                                                INPUT  param_calc_bem_pat.cod_tip_calc,
                                                INPUT  param_calc_bem_pat.cod_cenar_ctbl,
                                                INPUT  param_calc_bem_pat.cod_finalid_econ,
                                                INPUT  v_qtd_dias_vida_util).
                   end.
               end /* if */.       
            end.
            validate param_calc_bem_pat.
        end.

        /* ***************************************/
        for each b_aloc_bem no-lock
            where b_aloc_bem.num_id_bem_pat  = b_bem_pat.num_id_bem_pat
            and   b_aloc_bem.dat_inic_valid >= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto:
            create aloc_bem.
            assign aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                   aloc_bem.cod_empresa      = b_aloc_bem.cod_empresa
                   aloc_bem.cod_plano_ccusto = b_aloc_bem.cod_plano_ccusto
                   aloc_bem.cod_ccusto       = b_aloc_bem.cod_ccusto
                   aloc_bem.cod_unid_negoc   = b_aloc_bem.cod_unid_negoc
                   aloc_bem.val_perc_aprop   = b_aloc_bem.val_perc_aprop
                   aloc_bem.dat_fim_valid    = b_aloc_bem.dat_fim_valid
                   aloc_bem.dat_inic_valid   = b_aloc_bem.dat_inic_valid.
            validate aloc_bem.
        end.

        /* ***************************************/
        for each b_cronog_calc_pat no-lock
            where b_cronog_calc_pat.num_id_bem_pat  = b_bem_pat.num_id_bem_pat
            and   b_cronog_calc_pat.dat_fim_parada >= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto:
            create cronog_calc_pat.
            assign cronog_calc_pat.num_id_bem_pat  = bem_pat.num_id_bem_pat
                   cronog_calc_pat.cod_tip_calc    = b_cronog_calc_pat.cod_tip_calc
                   cronog_calc_pat.cod_cenar_ctbl  = b_cronog_calc_pat.cod_cenar_ctbl
                   cronog_calc_pat.dat_inic_parada = b_cronog_calc_pat.dat_inic_parada
                   cronog_calc_pat.dat_fim_parada  = b_cronog_calc_pat.dat_fim_parada
                   cronog_calc_pat.cod_grp_calc    = b_cronog_calc_pat.cod_grp_calc
                   cronog_calc_pat.des_anot_tab    = b_cronog_calc_pat.des_anot_tab.
            validate cronog_calc_pat.
        end.

        /* ***************************************/
        for each b_quant_produz no-lock
            where b_quant_produz.num_id_bem_pat = b_bem_pat.num_id_bem_pat
            and   b_quant_produz.dat_refer     >= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto:
            create quant_produz.
            assign quant_produz.num_id_bem_pat   = bem_pat.num_id_bem_pat
                   quant_produz.cod_unid_negoc   = b_quant_produz.cod_unid_negoc
                   quant_produz.cod_empresa      = b_quant_produz.cod_empresa
                   quant_produz.cod_plano_ccusto = b_quant_produz.cod_plano_ccusto
                   quant_produz.cod_ccusto       = b_quant_produz.cod_ccusto
                   quant_produz.dat_refer        = b_quant_produz.dat_refer
                   quant_produz.qtd_unid_produz  = b_quant_produz.qtd_unid_produz.
            validate quant_produz.
        end.

        /* ***************************************/
        run pi_retornar_finalid_indic_econ(input tt_desmembramento_bem_pat_api.ttv_cod_indic_econ,
                                           input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto, 
                                           output v_cod_finalid_aux).

        /* ***************************************/
        create movto_bem_pat.
        assign movto_bem_pat.num_id_bem_pat           = bem_pat.num_id_bem_pat
               movto_bem_pat.num_seq_movto_bem_pat    = next-value(seq_movto_bem_pat)
               movto_bem_pat.num_seq_incorp_bem_pat   = 0
               movto_bem_pat.dat_movto_bem_pat        = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
               movto_bem_pat.ind_trans_calc_bem_pat   = "Implantaá∆o" /*l_implantacao*/  
               movto_bem_pat.ind_orig_calc_bem_pat    = "Desmembramento" /*l_desmembramento*/  
               movto_bem_pat.num_id_bem_pat_orig      = b_bem_pat.num_id_bem_pat
               movto_bem_pat.qtd_movto_bem_pat        = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen
               movto_bem_pat.cod_empresa              = bem_pat.cod_empresa
               movto_bem_pat.cod_plano_ccusto         = bem_pat.cod_plano_ccusto
               movto_bem_pat.cod_ccusto_respons       = bem_pat.cod_ccusto_respons
               movto_bem_pat.cod_unid_negoc           = bem_pat.cod_unid_negoc
               movto_bem_pat.cod_estab                = bem_pat.cod_estab.

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
            assign movto_bem_pat.cod_cenar_ctbl           = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                   movto_bem_pat.cod_indic_econ           = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ
                   movto_bem_pat.val_origin_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat
                   movto_bem_pat.val_perc_movto_bem_pat   = (tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat * 100)
                                                            / v_val_original_cal.
        end.

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
            assign movto_bem_pat.val_perc_movto_bem_pat   = tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat
                   movto_bem_pat.val_origin_movto_bem_pat = round(v_val_origin_bem_pat * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100),2).
        end.

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then do:
            assign movto_bem_pat.qtd_movto_bem_pat        = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen
                   movto_bem_pat.val_perc_movto_bem_pat   = (tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen * 100)
                                                            / b_bem_pat.qtd_bem_pat_represen
                   movto_bem_pat.val_origin_movto_bem_pat = round(v_val_origin_bem_pat * (movto_bem_pat.val_perc_movto_bem_pat / 100),2).
        end.

        validate movto_bem_pat.

        /* ***************************************/
        for each incorp_bem_pat no-lock
            where incorp_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
            find last b_val_origin_bem_pat no-lock
                where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
            create b_incorp_bem_pat.
            assign b_incorp_bem_pat.num_id_bem_pat             = bem_pat.num_id_bem_pat
                   b_incorp_bem_pat.num_seq_incorp_bem_pat     = incorp_bem_pat.num_seq_incorp_bem_pat
                   b_incorp_bem_pat.cod_cenar_ctbl             = incorp_bem_pat.cod_cenar_ctbl
                   b_incorp_bem_pat.dat_incorp_bem_pat         = incorp_bem_pat.dat_incorp_bem_pat
                   b_incorp_bem_pat.ind_incorp_bem_pat         = incorp_bem_pat.ind_incorp_bem_pat
                   b_incorp_bem_pat.des_incorp_bem_pat         = incorp_bem_pat.des_incorp_bem_pat
                   b_incorp_bem_pat.cod_incent_fisc            = incorp_bem_pat.cod_incent_fisc
                   b_incorp_bem_pat.cod_empresa                = incorp_bem_pat.cod_empresa
                   b_incorp_bem_pat.cdn_fornecedor             = incorp_bem_pat.cdn_fornecedor
                   b_incorp_bem_pat.cod_indic_econ             = incorp_bem_pat.cod_indic_econ
                   b_incorp_bem_pat.val_incorp_bem_pat         = round(b_val_origin_bem_pat.val_original * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100),2)
                   b_incorp_bem_pat.cod_tip_calc_reaval        = incorp_bem_pat.cod_tip_calc_reaval
                   b_incorp_bem_pat.cod_estab                  = incorp_bem_pat.cod_estab
                   b_incorp_bem_pat.cod_docto_entr             = incorp_bem_pat.cod_docto_entr
                   b_incorp_bem_pat.num_item_docto_entr        = incorp_bem_pat.num_item_docto_entr
                   b_incorp_bem_pat.cod_ser_nota               = incorp_bem_pat.cod_ser_nota
                   b_incorp_bem_pat.dat_cotac_outras_moed      = incorp_bem_pat.dat_cotac_outras_moed
                   b_incorp_bem_pat.cod_imagem                 = incorp_bem_pat.cod_imagem
                   b_incorp_bem_pat.des_laudo_reaval_bem_pat   = incorp_bem_pat.des_laudo_reaval_bem_pat
                   &if '{&emsfin_version}' >= '5.01' &then
                       b_incorp_bem_pat.cod_cta_pat = incorp_bem_pat.cod_cta_pat.
                   &else
                       b_incorp_bem_pat.cod_livre_1 = incorp_bem_pat.cod_livre_1.
                   &endif

            if v_log_param_calc_incorp = yes then do:
                for each param_calc_incorp_pat no-lock
                    where param_calc_incorp_pat.num_id_bem_pat = incorp_bem_pat.num_id_bem_pat:
                    create b_param_calc_incorp_pat.
                    assign b_param_calc_incorp_pat.num_id_bem_pat             = bem_pat.num_id_bem_pat
                           b_param_calc_incorp_pat.num_seq_incorp_bem_pat     = param_calc_incorp_pat.num_seq_incorp_bem_pat
                           b_param_calc_incorp_pat.cod_cenar_ctbl             = param_calc_incorp_pat.cod_cenar_ctbl
                           b_param_calc_incorp_pat.cod_finalid_econ           = param_calc_incorp_pat.cod_finalid_econ
                           b_param_calc_incorp_pat.val_perc_anual_dpr         = param_calc_incorp_pat.val_perc_anual_dpr
                           b_param_calc_incorp_pat.val_perc_anual_dpr_incevda = param_calc_incorp_pat.val_perc_anual_dpr_incevda
                           b_param_calc_incorp_pat.qtd_unid_vida_util         = param_calc_incorp_pat.qtd_unid_vida_util.
                end.
            end.
            else do:
                assign b_incorp_bem_pat.val_perc_anual_dpr         = incorp_bem_pat.val_perc_anual_dpr
                       b_incorp_bem_pat.val_perc_anual_dpr_incevda = incorp_bem_pat.val_perc_anual_dpr_incevda
                       b_incorp_bem_pat.qtd_unid_vida_util         = incorp_bem_pat.qtd_unid_vida_util.
            end.

            /* Localizaá∆o Colìmbia */
            if  v_log_localiz_col
            then do:
                run pi_colext_retorna_incorp_bem_pat 
                         in v_hdl_procedure (INPUT  incorp_bem_pat.num_id_bem_pat,
                                             INPUT  incorp_bem_pat.num_seq_incorp_bem_pat,
                                             INPUT  incorp_bem_pat.cod_cenar_ctbl,
                                             INPUT  incorp_bem_pat.dat_incorp_bem_pat,
                                             INPUT  incorp_bem_pat.ind_incorp_bem_pat,
                                             OUTPUT v_qtd_dias_vida_util).

                run pi_colext_inclui_incorp_bem_pat 
                         in v_hdl_procedure (INPUT  b_incorp_bem_pat.num_id_bem_pat,
                                             INPUT  b_incorp_bem_pat.num_seq_incorp_bem_pat,
                                             INPUT  b_incorp_bem_pat.cod_cenar_ctbl,
                                             INPUT  b_incorp_bem_pat.dat_incorp_bem_pat,
                                             INPUT  b_incorp_bem_pat.ind_incorp_bem_pat,
                                             INPUT  v_qtd_dias_vida_util).

            end /* if */.       

            validate b_incorp_bem_pat.

        /* ***************************************/
            create b_movto_bem_pat.
            assign b_movto_bem_pat.num_id_bem_pat           = bem_pat.num_id_bem_pat
                   b_movto_bem_pat.num_seq_movto_bem_pat    = next-value(seq_movto_bem_pat)
                   b_movto_bem_pat.num_seq_incorp_bem_pat   = b_incorp_bem_pat.num_seq_incorp_bem_pat
                   b_movto_bem_pat.dat_movto_bem_pat        = movto_bem_pat.dat_movto_bem_pat
                   b_movto_bem_pat.ind_trans_calc_bem_pat   = "Implantaá∆o" /*l_implantacao*/  
                   b_movto_bem_pat.ind_orig_calc_bem_pat    = "Desmembramento" /*l_desmembramento*/  
                   b_movto_bem_pat.num_id_bem_pat_orig      = b_bem_pat.num_id_bem_pat
                   b_movto_bem_pat.qtd_movto_bem_pat        = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen
                   b_movto_bem_pat.cod_empresa              = bem_pat.cod_empresa
                   b_movto_bem_pat.cod_plano_ccusto         = bem_pat.cod_plano_ccusto
                   b_movto_bem_pat.cod_ccusto_respons       = bem_pat.cod_ccusto_respons
                   b_movto_bem_pat.cod_unid_negoc           = bem_pat.cod_unid_negoc
                   b_movto_bem_pat.cod_estab                = bem_pat.cod_estab.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
                assign b_movto_bem_pat.cod_cenar_ctbl           = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                       b_movto_bem_pat.cod_indic_econ           = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ
                       b_movto_bem_pat.val_origin_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat
                       b_movto_bem_pat.val_perc_movto_bem_pat   = (tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat * 100)
                                                                  / v_val_original_cal.
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
                assign b_movto_bem_pat.val_perc_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat.
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then do:
                assign b_movto_bem_pat.qtd_movto_bem_pat      = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen
                       b_movto_bem_pat.val_perc_movto_bem_pat = (tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen * 100)
                                                                / b_bem_pat.qtd_bem_pat_represen.

            end.

            validate b_movto_bem_pat.

        /* ***************************************/
            for each param_calc_bem_pat no-lock
                where param_calc_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat
                and   param_calc_bem_pat.cod_tip_calc   = '':
                if b_incorp_bem_pat.cod_cenar_ctbl <> ''
                and param_calc_bem_pat.cod_cenar_ctbl <> b_incorp_bem_pat.cod_cenar_ctbl then
                    next.

        /* ***************************************/
                find last b_val_origin_bem_pat no-lock
                    where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                    and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                    and   b_val_origin_bem_pat.cod_finalid_econ       = param_calc_bem_pat.cod_finalid_econ no-error.
                if avail b_val_origin_bem_pat then
                    assign v_val_original = round(b_val_origin_bem_pat.val_original * (b_movto_bem_pat.val_perc_movto_bem_pat / 100),2).

        /* ***************************************/
                else do:
                    find last b_val_origin_bem_pat no-lock
                        where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                        and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                        and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
                    run pi_converter_finalid_econ_finalid (Input v_cod_finalid_econ,
                                                           Input v_cod_empres_usuar,
                                                           Input b_val_origin_bem_pat.dat_calc_pat,
                                                           Input b_val_origin_bem_pat.val_original,
                                                           Input param_calc_bem_pat.cod_finalid_econ,
                                                           output v_cod_return).

        /* ***************************************/
                    if v_cod_return <> "OK" /*l_ok*/  then do:
                        run pi_gerar_retorno_converter_finalid(input v_cod_return).
                        return 'NOK'.
                    end.
                    find first tt_converter_finalid_econ exclusive-lock no-error.
                    assign v_val_original = round(tt_converter_finalid_econ.tta_val_transacao * (b_movto_bem_pat.val_perc_movto_bem_pat / 100),2).
                end.

        /* ***************************************/
                create val_origin_bem_pat.
                assign val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                       val_origin_bem_pat.num_seq_incorp_bem_pat = b_incorp_bem_pat.num_seq_incorp_bem_pat
                       val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
                       val_origin_bem_pat.cod_finalid_econ       = param_calc_bem_pat.cod_finalid_econ
                       val_origin_bem_pat.dat_calc_pat           = b_movto_bem_pat.dat_movto_bem_pat
                       val_origin_bem_pat.val_original           = v_val_original
                       val_origin_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat.num_seq_movto_bem_pat.
                validate val_origin_bem_pat.
            end. /* for each param_calc_bem_pat no-lock*/
        end. /* for each incorp_bem_pat no-lock*/
    end. /* if avail cta_pat then do*/
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_efetiva_desmemb_bens_more */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut43117
** Alterado em...........: 05/12/2011 10:21:41
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* alteracao sob demanda - atividade 195864*/
    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ then 
        assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.




END PROCEDURE. /* pi_retornar_finalid_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_dat_inic_valid_unid_organ
** Descricao.............: pi_retornar_dat_inic_valid_unid_organ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 11/04/1995 10:50:42
*****************************************************************************/
PROCEDURE pi_retornar_dat_inic_valid_unid_organ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_dat_inic_valid_unid_organ
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first emsuni.unid_organ no-lock
         where unid_organ.cod_unid_organ = p_cod_unid_organ
           and unid_organ.dat_inic_valid <= p_dat_transacao
           and unid_organ.dat_fim_valid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index ndrgn_id
    &endif
          /*cl_retornar_dat_inic_valid of unid_organ*/ no-error.
    if  avail unid_organ
    then do:
      assign p_dat_inic_valid_unid_organ = unid_organ.dat_inic_valid.
    end /* if */.
END PROCEDURE. /* pi_retornar_dat_inic_valid_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_validar_finalid_unid_organ
** Descricao.............: pi_validar_finalid_unid_organ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut1228
** Alterado em...........: 21/01/2004 19:31:53
*****************************************************************************/
PROCEDURE pi_validar_finalid_unid_organ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* Alterado para validar "finalid_unid_organ.dat_fim_valid >= p_dat_transacao", conforme Atividade 107753.
      Devido a lista de impacto desta PI ser muito extenáa, foi acordado que os demais 
      programas deveram ser alterados sobre demanda.*/

    find first finalid_unid_organ no-lock
         where finalid_unid_organ.cod_unid_organ = p_cod_unid_organ
           and finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ
           and finalid_unid_organ.dat_inic_valid <= p_dat_transacao
           and finalid_unid_organ.dat_fim_valid >= p_dat_transacao no-error.

    if  not avail finalid_unid_organ
    then do:
        assign p_cod_return = "338".
    end /* if */.
    else do:
        assign p_cod_return = "OK" /*l_ok*/ .
    end /* else */.
END PROCEDURE. /* pi_validar_finalid_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_validar_cenar_ctbl
** Descricao.............: pi_validar_cenar_ctbl
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut1228
** Alterado em...........: 29/12/2005 16:39:36
*****************************************************************************/
PROCEDURE pi_validar_cenar_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cenar_ctbl
        as character
        format "x(8)":U
        label "Cen†rio Cont†bil"
        column-label "Cen†rio Cont†bil"
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_log_ativ_cenar
        as logical
        format "Sim/N∆o"
        initial no
        view-as toggle-box
        label "Inativo"
        column-label "Inativo"
        no-undo.
    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_log_segur_cenar_ctbl
        as logical
        format "Sim/N∆o"
        initial no
        view-as toggle-box
        label "Seguranáa Cont†bil"
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_num_mensagem = 0.

    if  p_cod_cenar_ctbl = "  "
    then do:
        segur:
        for each segur_cenar_ctbl no-lock
         where segur_cenar_ctbl.cod_empresa = p_cod_empresa /*cl_retorna_empresa of segur_cenar_ctbl*/ break by segur_cenar_ctbl.cod_cenar_ctbl:
            if  first-of(segur_cenar_ctbl.cod_cenar_ctbl)
            then do:
                assign v_log_segur_cenar_ctbl = no.
            end /* if */.
            find usuar_grp_usuar no-lock
                 where usuar_grp_usuar.cod_grp_usuar = segur_cenar_ctbl.cod_grp_usuar
                   and (usuar_grp_usuar.cod_usuario = v_cod_usuar_corren
                      or usuar_grp_usuar.cod_usuario = "*")
            &if '{&emsbas_version}' >= '5.01' &then
                use-index srgrpsr_id
            &endif
            no-error.
            if  avail usuar_grp_usuar
            then do:
                assign v_log_segur_cenar_ctbl = yes.
            end /* if */.
            if  last-of(segur_cenar_ctbl.cod_cenar_ctbl)
            and v_log_segur_cenar_ctbl = no
            then do:
                assign p_num_mensagem = 2568.
                return.
            end /* if */.
        end /* for segur */.
    end /* if */.
    else do:
        find first utiliz_cenar_ctbl no-lock
             where utiliz_cenar_ctbl.cod_cenar_ctbl = p_cod_cenar_ctbl
               and utiliz_cenar_ctbl.cod_empresa = p_cod_empresa /*cl_retorna_cenar_ctbl_valido_empresa of utiliz_cenar_ctbl*/ no-error.
        if  avail utiliz_cenar_ctbl
        then do:
         /* @for(segur_cenar) @record(each, segur_cenar_ctbl, utiliz_cenar_ctbl, utlzcnrc_sgrcnrct, null, no_lock).
                @find(null, usuar_grp_usuar, null, null, cl_permissao_cenar_ctbl, no_lock, wait, no_error).*/
            if can-find(first segur_cenar_ctbl
                where segur_cenar_ctbl.cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl
                  and segur_cenar_ctbl.cod_empresa = utiliz_cenar_ctbl.cod_empresa
                  and segur_cenar_ctbl.cod_grp_usuar = "*")
            then
                assign v_log_segur_cenar_ctbl = yes.
            else do:
                for each usuar_grp_usuar no-lock
                     where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
                    find first segur_cenar_ctbl no-lock
                         where segur_cenar_ctbl.cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl
                           and segur_cenar_ctbl.cod_empresa    = utiliz_cenar_ctbl.cod_empresa
                           and segur_cenar_ctbl.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar 
                         no-error.
                    if  avail segur_cenar_ctbl
                    then do:
                        assign v_log_segur_cenar_ctbl = yes.
                    end /* if */.
                end /* for usuar_grp_usuar */.
            end.
            if  v_log_segur_cenar_ctbl = no
            then do:
                assign p_num_mensagem = 2557.
                return.
            end /* if */.

            if  not avail cenar_ctbl or cenar_ctbl.cod_cenar_ctbl <> utiliz_cenar_ctbl.cod_cenar_ctbl then
                find first cenar_ctbl where cenar_ctbl.cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl no-lock no-error.

            if  avail cenar_ctbl
            then do:
                &if '{&emsfin_version}' >= '5.06' &then 
                    assign v_log_ativ_cenar = cenar_ctbl.log_cenar_inativ.
                &else
                    assign v_log_ativ_cenar = cenar_ctbl.log_livre_1.
                &endif
            end /* if */.

            if  p_dat_refer_ent <> ?
            and (utiliz_cenar_ctbl.dat_inic_valid >  p_dat_refer_ent
            or   utiliz_cenar_ctbl.dat_fim_valid  <= p_dat_refer_ent)
            and  v_log_ativ_cenar = no
            then do:
                 assign p_num_mensagem   = 1494.
                 return.
            end /* if */.
        end /* if */.
        else do:
            assign p_num_mensagem = 1495.
            return.
        end /* else */.
    end /* else */.
END PROCEDURE. /* pi_validar_cenar_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_validar_finalid_utiliz_cenar
** Descricao.............: pi_validar_finalid_utiliz_cenar
** Criado por............: Uno
** Criado em.............: 01/02/1996 11:22:01
** Alterado por..........: Uno
** Alterado em...........: 01/02/1996 17:38:45
*****************************************************************************/
PROCEDURE pi_validar_finalid_utiliz_cenar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_cod_return = " ".

    find finalid_utiliz_cenar no-lock
         where finalid_utiliz_cenar.cod_cenar_ctbl = p_cod_cenar_ctbl
           and finalid_utiliz_cenar.cod_empresa = p_cod_empresa
           and finalid_utiliz_cenar.cod_finalid_econ = p_cod_finalid_econ
    &if "{&emsuni_version}" >= "5.01" &then
         use-index fnldtlzc_id
    &endif
          /*cl_valida_finalid_utiliz_cenar of finalid_utiliz_cenar*/ no-error.
    if  avail finalid_utiliz_cenar
    then do:
        if  p_dat_transacao <> ?
        and (finalid_utiliz_cenar.dat_inic_valid >  p_dat_transacao
        or   finalid_utiliz_cenar.dat_fim_valid  <= p_dat_transacao)
        then do:
             assign p_cod_return = "1915" + "," + p_cod_finalid_econ + "," + p_cod_cenar_ctbl.
        end /* if */.
    end /* if */.
    else do:
        assign p_cod_return = "1916" + "," + p_cod_finalid_econ + "," + p_cod_cenar_ctbl.
    end /* else */.

END PROCEDURE. /* pi_validar_finalid_utiliz_cenar */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_econ_corren_estab
** Descricao.............: pi_retornar_finalid_econ_corren_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41061
** Alterado em...........: 27/04/2009 08:43:48
*****************************************************************************/
PROCEDURE pi_retornar_finalid_econ_corren_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab
         use-index stblcmnt_id no-error.
    if  avail estabelecimento
    then do:
       find emsuni.pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais
             no-error.
       assign p_cod_finalid_econ = pais.cod_finalid_econ_pais.
    end.
END PROCEDURE. /* pi_retornar_finalid_econ_corren_estab */
/*****************************************************************************
** Procedure Interna.....: pi_validar_cta_ctbl_distrib_ccusto_1
** Descricao.............: pi_validar_cta_ctbl_distrib_ccusto_1
** Criado por............: src12337
** Criado em.............: 28/02/2002 14:21:46
** Alterado por..........: src12337
** Alterado em...........: 28/02/2002 14:59:29
*****************************************************************************/
PROCEDURE pi_validar_cta_ctbl_distrib_ccusto_1:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no
           p_cod_return = ''.
    if  p_dat_refer_ent = ?
    then do:
        find last criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab /* cl_verificar_cta_ctbl_utiliz_ccusto of criter_distrib_cta_ctbl*/ no-error.
    end /* if */.
    else do:
        find first criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab
               and criter_distrib_cta_ctbl.dat_inic_valid <= p_dat_refer_ent
               and criter_distrib_cta_ctbl.dat_fim_valid > p_dat_refer_ent /* cl_verificar_cta_ctbl_utiliz_ccusto_dat of criter_distrib_cta_ctbl*/ no-error.
    end /* else */.

    if  not avail criter_distrib_cta_ctbl
    then do:
       assign p_log_return = yes
              p_cod_return = "N∆o Utiliza" /*l_nao_utiliza*/ .    
       return.
    end /* if */.
    if  (avail plano_ccusto) and
         plano_ccusto.cod_empresa = p_cod_empresa and
         plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
    then do:
       run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                    output v_cod_ccusto_000) /* pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
      find plano_ccusto no-lock
           where plano_ccusto.cod_empresa = p_cod_empresa
             and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /* cl_valida_plano of plano_ccusto*/ no-error.
      if  avail plano_ccusto
      then do:
         run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                      output v_cod_ccusto_000) /* pi_retornar_ccusto_inic*/.
      end /* if */.
      else do:
         return.
      end /* else */.
    end /* else */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" /*l_nao_utiliza*/ 
    then do:
        assign p_log_return = yes
               p_cod_return = "N∆o Utiliza" /*l_nao_utiliza*/ .
        return.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos" /*l_utiliza_todos*/ 
    then do:
        if  (p_cod_plano_ccusto <> ?
        and   p_cod_plano_ccusto <> "")
        /* and  (p_cod_ccusto <> v_cod_ccusto_000) */
        then do:
            assign p_log_return = yes.
            return.
        end /* if */.
        else do:
            return.
        end /* else */.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
    then do:
        if  (p_cod_plano_ccusto = ?
        or    p_cod_plano_ccusto = "")
        /* or   (p_cod_ccusto = v_cod_ccusto_000) */
        then do:
            return.
        end /* if */.
        find mapa_distrib_ccusto no-lock
             where mapa_distrib_ccusto.cod_estab = criter_distrib_cta_ctbl.cod_estab
               and mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
              no-error.
        if  p_dat_refer_ent <> ? and
           (p_dat_refer_ent <  mapa_distrib_ccusto.dat_inic_valid   or
            p_dat_refer_ent >= mapa_distrib_ccusto.dat_fim_valid)
        then do:
            return.
        end /* if */.
        find item_lista_ccusto no-lock
             where item_lista_ccusto.cod_estab = p_cod_estab
               and item_lista_ccusto.cod_mapa_distrib_ccusto = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
               and item_lista_ccusto.cod_empresa = p_cod_empresa
               and item_lista_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and item_lista_ccusto.cod_ccusto = p_cod_ccusto /* cl_validar_cta_ctbl_distrib_ccusto of item_lista_ccusto*/ no-error.
        if  not avail item_lista_ccusto
        then do:
            return.
        end /* if */.
        else do:
            assign p_log_return = yes.
        end /* else */.
    end /* if */.
END PROCEDURE. /* pi_validar_cta_ctbl_distrib_ccusto_1 */
/*****************************************************************************
** Procedure Interna.....: pi_sit_movimen_pat
** Descricao.............: pi_sit_movimen_pat
** Criado por............: marcelo
** Criado em.............: // 
** Alterado por..........: src12337
** Alterado em...........: 01/07/2003 09:02:43
*****************************************************************************/
PROCEDURE pi_sit_movimen_pat:

    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_param_calc_bem_pat
        as recid
        format ">>>>>>9"
        no-undo.
    def Input param p_dat_inic_parada
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.
    def output param p_dat_return
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/


    /* N∆o podem existir para um bem patrimonial dois movimentos em um mesmo dia */
    find first sdo_bem_pat no-lock
        where sdo_bem_pat.num_id_bem_pat  = param_calc_bem_pat.num_id_bem_pat 
        and   sdo_bem_pat.dat_sdo_bem_pat > p_dat_inic_parada no-error.
    if  avail sdo_bem_pat then do:
        assign p_log_return = no
               p_dat_return = ?.
        return.
    end.

    find param_calc_bem_pat 
        where recid(param_calc_bem_pat) = p_rec_param_calc_bem_pat 
        no-lock no-error.  
    find last reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat         = param_calc_bem_pat.num_id_bem_pat
        and   reg_calc_bem_pat.num_seq_incorp_bem_pat = 0
        and   reg_calc_bem_pat.cod_tip_calc           = param_calc_bem_pat.cod_tip_calc
        and   reg_calc_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl 
        no-error.
    assign p_log_return = yes
           p_dat_return = today.
    if  not avail reg_calc_bem_pat or
       (avail reg_calc_bem_pat and
        reg_calc_bem_pat.dat_calc_pat < p_dat_inic_parada)
    then do:
        find last movto_bem_pat no-lock
             where movto_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat
               and movto_bem_pat.log_estorn_movto_bem_pat = no
             use-index mvtbmpt_estorn no-error.
        if  avail movto_bem_pat and
            movto_bem_pat.dat_movto_bem_pat < p_dat_inic_parada
        then do:
            if  avail reg_calc_bem_pat
            then do:
                assign p_dat_return = reg_calc_bem_pat.dat_calc_pat.
            end /* if */.
            else do:
                assign p_dat_return = movto_bem_pat.dat_movto_bem_pat.
            end /* else */.
        end /* if */.
        else do:
            assign p_log_return = no
                   p_dat_return = ?.
        end /* else */.
    end /* if */.
    else do:
        assign p_log_return = no
               p_dat_return = ?.
    end /* else */.

    IF p_log_return THEN DO:
        FIND FIRST reg_calc_bem_pat no-lock
            where reg_calc_bem_pat.num_id_bem_pat         = param_calc_bem_pat.num_id_bem_pat
            and   reg_calc_bem_pat.num_seq_incorp_bem_pat <> 0
            and   reg_calc_bem_pat.cod_tip_calc           = param_calc_bem_pat.cod_tip_calc
            and   reg_calc_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl 
            AND   reg_calc_bem_pat.dat_calc_pat           = p_dat_inic_parada
            NO-ERROR.
        assign p_log_return = yes
               p_dat_return = today.
        if  not avail reg_calc_bem_pat or
           (avail reg_calc_bem_pat and
            reg_calc_bem_pat.dat_calc_pat < p_dat_inic_parada)
        then do:
            find last movto_bem_pat no-lock
                 where movto_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat
                   and movto_bem_pat.log_estorn_movto_bem_pat = no
                 use-index mvtbmpt_estorn no-error.
            if  avail movto_bem_pat and
                movto_bem_pat.dat_movto_bem_pat < p_dat_inic_parada
            then do:
                if  avail reg_calc_bem_pat
                then do:
                    assign p_dat_return = reg_calc_bem_pat.dat_calc_pat.
                end /* if */.
                else do:
                    assign p_dat_return = movto_bem_pat.dat_movto_bem_pat.
                end /* else */.
            end /* if */.
            else do:
                assign p_log_return = no
                       p_dat_return = ?.
            end /* else */.
        end /* if */.
        else do:
            assign p_log_return = no
                   p_dat_return = ?.
        end /* else */.
    END.

    find first contrat_leas where 
        contrat_leas.cod_contrat_leas = bem_pat.cod_contrat_leas and
        contrat_leas.cod_arrendador = bem_pat.cod_arrendador no-lock no-error.
    if  avail contrat_leas
    then do: 
        if  contrat_leas.dat_fim_valid <= p_dat_inic_parada
        then do:
            /* validaá∆o de data de in°cio de calculo para tipo de calculo  " " */
            if  param_calc_bem_pat.cod_tip_calc = "" and
                param_calc_bem_pat.dat_inic_calc > p_dat_inic_parada
            then do:
                assign p_log_return = no
                       p_dat_return = ?.
            end /* if */.
        end /* if */.        
    end /* if */.
    else do:     
       /* validaá∆o de data de in°cio de calculo para tipo de calculo  " " */
        if  param_calc_bem_pat.cod_tip_calc = "" and
            param_calc_bem_pat.dat_inic_calc > p_dat_inic_parada
        then do:
            assign p_log_return = no
                   p_dat_return = ?.
        end /* if */.
    end /* if */.
    /* A valiaá∆o do cronograa foi retirado devido a solicitaá∆o da FO 214128 
    @if(p_log_return = yes)
        @find(null, cronog_calc_pat, param_calc_bem_pat, prmclcbm_crngclcp, null, no_lock, wait, no_error).
        @if(avail cronog_calc_pat and
            p_dat_inic_parada >= cronog_calc_pat.dat_inic_parada and
            p_dat_inic_parada <= cronog_calc_pat.dat_fim_parada)
            assign p_log_return = no
                   p_dat_return = ?.
        @end_if().
    @end_if().
    */
END PROCEDURE. /* pi_sit_movimen_pat */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_finalid
** Descricao.............: pi_retornar_indic_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:21:29
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_cenar_ctbl_fisc
** Descricao.............: pi_retornar_cenar_ctbl_fisc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Rovina
** Alterado em...........: 13/11/1995 22:07:23
*****************************************************************************/
PROCEDURE pi_retornar_cenar_ctbl_fisc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first utiliz_cenar_ctbl no-lock
         where utiliz_cenar_ctbl.cod_empresa = p_cod_empresa
           and utiliz_cenar_ctbl.log_cenar_fisc = yes /*cl_retorna_fisc of utiliz_cenar_ctbl*/ no-error.
    if  avail utiliz_cenar_ctbl
    then do:
        if  p_dat_refer_ent = ? or (utiliz_cenar_ctbl.dat_inic_valid <= p_dat_refer_ent and
                                    utiliz_cenar_ctbl.dat_fim_valid >= p_dat_refer_ent)
        then do:
            assign p_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.
        end /* if */.
        else do:
            assign p_cod_cenar_ctbl = "".
        end /* else */.
    end /* if */.
    else do:
        assign p_cod_cenar_ctbl = "".
    end /* else */.
END PROCEDURE. /* pi_retornar_cenar_ctbl_fisc */
/*****************************************************************************
** Procedure Interna.....: pi_tt_desmembrto_api
** Descricao.............: pi_tt_desmembrto_api
** Criado por............: its0048
** Criado em.............: 08/10/2004 16:42:30
** Alterado por..........: its0105
** Alterado em...........: 23/05/2005 17:50:42
*****************************************************************************/
PROCEDURE pi_tt_desmembrto_api:

    find last b_val_origin_bem_pat no-lock
        where b_val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
        and b_val_origin_bem_pat.num_seq_incorp_bem_pat = 0
        and b_val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
        and b_val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ no-error.
    if not avail b_val_origin_bem_pat then
        return 'next'.

    assign v_val_original_cal  = b_val_origin_bem_pat.val_original
           v_val_despes_financ = b_val_origin_bem_pat.val_despes_financ.

    find first val_origin_bem_pat exclusive-lock
        where val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
        and val_origin_bem_pat.num_seq_incorp_bem_pat = 0
        and val_origin_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat
        and val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
        and val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ
        and val_origin_bem_pat.dat_calc_pat           = b_movto_bem_pat_desmbrto.dat_movto_bem_pat no-error.
    if not avail val_origin_bem_pat then do:
        create val_origin_bem_pat.
        assign val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
               val_origin_bem_pat.num_seq_incorp_bem_pat = 0
               val_origin_bem_pat.cod_cenar_ctbl         = b_val_origin_bem_pat.cod_cenar_ctbl
               val_origin_bem_pat.cod_finalid_econ       = b_val_origin_bem_pat.cod_finalid_econ
               val_origin_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat
               val_origin_bem_pat.dat_calc_pat           = b_movto_bem_pat_desmbrto.dat_movto_bem_pat
               val_origin_bem_pat.val_despes_financ      = b_val_origin_bem_pat.val_despes_financ * ((100 - v_val_perc_desmembr) / 100)
               val_origin_bem_pat.val_dif_val_origin     = round((b_val_origin_bem_pat.val_original * (v_val_perc_desmembr / 100)),2)
               val_origin_bem_pat.val_original           = round(b_val_origin_bem_pat.val_original - round((b_val_origin_bem_pat.val_original * (v_val_perc_desmembr / 100)),2),2)
               v_rec_b_val_origin_bem_pat                = recid(val_origin_bem_pat).
        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  
        and tt_finalid_bem_pat_calculo.tta_cod_finalid_econ = v_cod_finalid_econ then
            assign val_origin_bem_pat.val_original       = round(b_val_origin_bem_pat.val_original - round(b_val_origin_bem_pat.val_original * (b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat / 100),2),2)
                   val_origin_bem_pat.val_dif_val_origin = round(b_val_origin_bem_pat.val_original * (b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat / 100),2).

       validate val_origin_bem_pat.
    end.

    blk_acumula_incorp:
    for each incorp_bem_pat no-lock
        where incorp_bem_pat.num_id_bem_pat      = b_bem_pat.num_id_bem_pat
        and   incorp_bem_pat.dat_incorp_bem_pat <= tt_desmembramento_bem_pat_api.ttv_dat_desmbrto:
        if incorp_bem_pat.cod_cenar_ctbl <> ' ' and incorp_bem_pat.cod_cenar_ctbl <> param_calc_bem_pat.cod_cenar_ctbl then
            next blk_acumula_incorp.

        find last b_val_origin_bem_pat no-lock
            where b_val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
            and b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
            and b_val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
            and b_val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ no-error.
        if not avail b_val_origin_bem_pat then
            next blk_acumula_incorp.
        assign v_val_original_cal  = b_val_origin_bem_pat.val_original      + v_val_original_cal
               v_val_despes_financ = b_val_origin_bem_pat.val_despes_financ + v_val_despes_financ.

        find first val_origin_bem_pat exclusive-lock
            where val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
            and val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
            and val_origin_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp.num_seq_movto_bem_pat
            and val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
            and val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ
            and val_origin_bem_pat.dat_calc_pat           = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-error.
        if not avail val_origin_bem_pat then do:
            create val_origin_bem_pat.
            assign val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                   val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                   val_origin_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp.num_seq_movto_bem_pat
                   val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
                   val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ
                   val_origin_bem_pat.dat_calc_pat           = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
                   val_origin_bem_pat.val_despes_financ      = b_val_origin_bem_pat.val_despes_financ * ((100 - v_val_perc_desmembr) / 100)
                   val_origin_bem_pat.val_dif_val_origin     = round(b_val_origin_bem_pat.val_original * (v_val_perc_desmembr / 100),2)
                   val_origin_bem_pat.val_original           = b_val_origin_bem_pat.val_original - round(b_val_origin_bem_pat.val_original * (b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat / 100),2).
           validate val_origin_bem_pat.
        end.
    end.

    tt_desmemb_novos_bem_pat_api_block:
    for each tt_desmemb_novos_bem_pat_api
        where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto no-lock:
        find bem_pat exclusive-lock
            where bem_pat.cod_empresa     = v_cod_empres_usuar
            and   bem_pat.cod_cta_pat     = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat
            and   bem_pat.num_bem_pat     = tt_desmemb_novos_bem_pat_api.tta_num_bem_pat
            and   bem_pat.num_seq_bem_pat = tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat no-error.
        if not avail bem_pat then do:
            /* erro 873 - Bem Patrimonial implantado por desmembramento nao existe ! */
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Verifique se existe o Bem Patrimonial implantado por desmembramento.", "FAS") /*873*/.
            return "NOK" /*l_nok*/ .
        end.
        find first movto_bem_pat exclusive-lock
            where movto_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat no-error.
        assign movto_bem_pat.num_id_bem_pat_orig        = b_movto_bem_pat_desmbrto.num_id_bem_pat
               movto_bem_pat.num_seq_movto_bem_pat_orig = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat.

        find last b_val_origin_bem_pat no-lock
            where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
            and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = 0
            and   b_val_origin_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
            and   b_val_origin_bem_pat.cod_finalid_econ       = tt_finalid_bem_pat_calculo.tta_cod_finalid_econ 
            and   recid(b_val_origin_bem_pat)                <> v_rec_b_val_origin_bem_pat no-error.
        if not avail b_val_origin_bem_pat then
            return 'next'.
        assign v_val_original_cal  = round(b_val_origin_bem_pat.val_original, 2)
               v_val_despes_financ = b_val_origin_bem_pat.val_despes_financ.

        find first val_origin_bem_pat exclusive-lock
            where val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
            and   val_origin_bem_pat.num_seq_incorp_bem_pat = 0
            and   val_origin_bem_pat.cod_cenar_ctbl         = b_val_origin_bem_pat.cod_cenar_ctbl
            and   val_origin_bem_pat.cod_finalid_econ       = b_val_origin_bem_pat.cod_finalid_econ
            and   val_origin_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat
            and   val_origin_bem_pat.dat_calc_pat           = movto_bem_pat.dat_movto_bem_pat no-error.
        if not avail val_origin_bem_pat then do:
            create val_origin_bem_pat.
            assign val_origin_bem_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat
                   val_origin_bem_pat.num_seq_incorp_bem_pat  = 0
                   val_origin_bem_pat.cod_cenar_ctbl          = b_val_origin_bem_pat.cod_cenar_ctbl
                   val_origin_bem_pat.cod_finalid_econ        = b_val_origin_bem_pat.cod_finalid_econ
                   val_origin_bem_pat.num_seq_movto_bem_pat   = movto_bem_pat.num_seq_movto_bem_pat
                   val_origin_bem_pat.dat_calc_pat            = movto_bem_pat.dat_movto_bem_pat
                   val_origin_bem_pat.val_original            = round(b_val_origin_bem_pat.val_original * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100),2)
                   val_origin_bem_pat.val_despes_financ       = v_val_despes_financ * (tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat / 100)
                   val_origin_bem_pat.val_dif_val_origin      = 0.

            run pi_retornar_finalid_indic_econ (Input tt_desmembramento_bem_pat_api.ttv_cod_indic_econ,
                                                input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                                output v_cod_finalid_econ).

            if v_cod_finalid_econ = b_val_origin_bem_pat.cod_finalid_econ
            and b_val_origin_bem_pat.cod_cenar_ctbl = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl then do:
                create tt_guarda_valor_origin.
                assign tt_guarda_valor_origin.tta_num_id_bem_pat   = bem_pat.num_id_bem_pat
                       tt_guarda_valor_origin.ttv_val_perc_5       = tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat
                       tt_guarda_valor_origin.tta_val_original     = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat
                       tt_guarda_valor_origin.tta_cod_cenar_ctbl   = b_val_origin_bem_pat.cod_cenar_ctbl
                       tt_guarda_valor_origin.tta_cod_finalid_econ = v_cod_finalid_econ.
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then do:
                find first tt_guarda_valor_origin
                    where tt_guarda_valor_origin.tta_num_id_bem_pat = bem_pat.num_id_bem_pat no-error.
                if not avail tt_guarda_valor_origin then do:
                    create tt_guarda_valor_origin.
                    assign tt_guarda_valor_origin.tta_num_id_bem_pat   = bem_pat.num_id_bem_pat
                           tt_guarda_valor_origin.ttv_val_perc_5       = tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat
                           tt_guarda_valor_origin.tta_cod_cenar_ctbl   = b_val_origin_bem_pat.cod_cenar_ctbl
                           tt_guarda_valor_origin.tta_cod_finalid_econ = v_cod_finalid_econ.
                end.                      
            end.

            validate val_origin_bem_pat.

            if b_val_origin_bem_pat.cod_finalid_econ = v_cod_finalid_econ_bem_orig
            and b_val_origin_bem_pat.cod_cenar_ctbl = v_cod_cenar_ctbl_fisc then
                assign bem_pat.dat_calc_pat            = val_origin_bem_pat.dat_calc_pat
                       bem_pat.cod_indic_econ          = v_cod_indic_econ_bem_orig
                       bem_pat.val_original            = val_origin_bem_pat.val_original
                       bem_pat.cod_indic_econ_avaliac  = v_cod_indic_econ_bem_orig
                       bem_pat.val_avaliac_apol_seguro = val_origin_bem_pat.val_original
                       bem_pat.dat_avaliac_apol_seguro = val_origin_bem_pat.dat_calc_pat.
        end. /* if not avail val_origin_bem_pat then do:*/
    end. /* for each @&(temp_table)*/
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_tt_desmembrto_api */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_valores_originais_origem_api
** Descricao.............: pi_verificar_valores_originais_origem_api
** Criado por............: its0048
** Criado em.............: 18/10/2004 16:47:00
** Alterado por..........: its0048
** Alterado em...........: 18/10/2004 16:57:42
*****************************************************************************/
PROCEDURE pi_verificar_valores_originais_origem_api:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_verific
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_val_origin_bem_pat
        for val_origin_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_rec_obj
        as recid
        format ">>>>>>9":U
        no-undo.
    def var v_val_aux
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        initial 0
        no-undo.
    def var v_val_maior
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        no-undo.
    def var v_val_perc_5
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 10
        no-undo.


    /************************** Variable Definition End *************************/

    if not p_log_verific then do:
        for each tt_verifica_diferenca_desmem.
            delete tt_verifica_diferenca_desmem.
        end.
        /* Essa pi vai fazer a verificaá∆o da val_origin_bem_pat, se os valores baixados correspondem
        ao valor desmembrado primeiro grava-se os valores originais que deveriam ser baixados
        */
        assign v_val_aux = 0.
        run pi_retornar_finalid_indic_econ (Input tt_desmembramento_bem_pat_api.ttv_cod_indic_econ,
                                            Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                            output v_cod_finalid_econ).
        for each val_origin_bem_pat no-lock
            where val_origin_bem_pat.num_id_bem_pat   = b_bem_pat.num_id_bem_pat
            and   val_origin_bem_pat.cod_cenar_ctbl   = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
            and   val_origin_bem_pat.cod_finalid_econ = v_cod_finalid_econ
            break by val_origin_bem_pat.num_seq_incorp_bem_pat.
            if last-of(val_origin_bem_pat.num_seq_incorp_bem_pat) then do:
                find last b_val_origin_bem_pat
                    where b_val_origin_bem_pat.num_id_bem_pat         = val_origin_bem_pat.num_id_bem_pat
                    and   b_val_origin_bem_pat.cod_cenar_ctbl         = val_origin_bem_pat.cod_cenar_ctbl
                    and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ
                    and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = val_origin_bem_pat.num_seq_incorp_bem_pat
                    and   b_val_origin_bem_pat.dat_calc_pat           < tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-lock no-error.
                if avail b_val_origin_bem_pat then
                    assign v_val_aux = v_val_aux + b_val_origin_bem_pat.val_original.
            end.                
        end.

        if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then
            assign v_val_perc_5 = (v_val_origin_desmembr * 100) / v_val_aux.
        else
            assign v_val_perc_5 = v_val_perc_desmembr.

        assign v_val_aux = 0.
        for each val_origin_bem_pat no-lock
            where val_origin_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat
            and   val_origin_bem_pat.dat_calc_pat   = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
            break by val_origin_bem_pat.cod_cenar_ctbl
                  by val_origin_bem_pat.cod_finalid_econ.
            find last b_val_origin_bem_pat
                where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                and   b_val_origin_bem_pat.cod_cenar_ctbl         = val_origin_bem_pat.cod_cenar_ctbl
                and   b_val_origin_bem_pat.cod_finalid_econ       = val_origin_bem_pat.cod_finalid_econ
                and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = val_origin_bem_pat.num_seq_incorp_bem_pat
                and   b_val_origin_bem_pat.dat_calc_pat           < tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-lock.

                assign v_val_aux = v_val_aux + round((b_val_origin_bem_pat.val_original * v_val_perc_5) / 100,2).

            if last-of(val_origin_bem_pat.cod_cenar_ctbl) or last-of(val_origin_bem_pat.cod_finalid_econ) then do:
                if  val_origin_bem_pat.cod_cenar_ctbl   = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                and val_origin_bem_pat.cod_finalid_econ = v_cod_finalid_econ
                and tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
                    /* Se for o cenario e finalidade da tela vai armazenar o valor da tela quando for por valor */
                    create tt_verifica_diferenca_desmem.
                    assign tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl   = val_origin_bem_pat.cod_cenar_ctbl
                           tt_verifica_diferenca_desmem.tta_cod_finalid_econ = val_origin_bem_pat.cod_finalid_econ
                           tt_verifica_diferenca_desmem.tta_val_original     = v_val_origin_desmembr
                           v_val_aux                                         = 0.
                end.
                create tt_verifica_diferenca_desmem.
                assign tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl   = val_origin_bem_pat.cod_cenar_ctbl
                       tt_verifica_diferenca_desmem.tta_cod_finalid_econ = val_origin_bem_pat.cod_finalid_econ
                       tt_verifica_diferenca_desmem.tta_val_original     = v_val_aux
                       v_val_aux                                         = 0.
            end.                   
        end.        
    end.
    else do:
        /* Nesse ponto Ç verificado se os valores baixados correspondem ao desmembrado */
        for each val_origin_bem_pat
            where val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
            and   val_origin_bem_pat.num_seq_incorp_bem_pat = 0
            and   val_origin_bem_pat.dat_calc_pat           = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-lock.
            assign v_val_aux   = 0
                   v_val_maior = 0.
            for each b_val_origin_bem_pat
                where b_val_origin_bem_pat.num_id_bem_pat   = b_bem_pat.num_id_bem_pat
                and   b_val_origin_bem_pat.cod_cenar_ctbl   = val_origin_bem_pat.cod_cenar_ctbl
                and   b_val_origin_bem_pat.cod_finalid_econ = val_origin_bem_pat.cod_finalid_econ
                and   b_val_origin_bem_pat.dat_calc_pat     = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto no-lock.
                assign v_val_aux = v_val_aux + b_val_origin_bem_pat.val_dif_val_origin.
                if abs(v_val_maior) < abs(b_val_origin_bem_pat.val_original) then
                    assign v_val_maior = b_val_origin_bem_pat.val_original
                           v_rec_obj   = recid(b_val_origin_bem_pat).
            end.
            find first tt_verifica_diferenca_desmem
                where tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl   = val_origin_bem_pat.cod_cenar_ctbl
                and   tt_verifica_diferenca_desmem.tta_cod_finalid_econ = val_origin_bem_pat.cod_finalid_econ no-error.
            if avail tt_verifica_diferenca_desmem and tt_verifica_diferenca_desmem.tta_val_original <> v_val_aux then do:
                find b_val_origin_bem_pat
                    where recid(b_val_origin_bem_pat) = v_rec_obj exclusive-lock no-error.
                if avail b_val_origin_bem_pat then do:
                    if tt_verifica_diferenca_desmem.tta_val_original > v_val_aux then
                        assign b_val_origin_bem_pat.val_dif_val_origin = b_val_origin_bem_pat.val_dif_val_origin + (tt_verifica_diferenca_desmem.tta_val_original - v_val_aux)
                               b_val_origin_bem_pat.val_original       = b_val_origin_bem_pat.val_original - (tt_verifica_diferenca_desmem.tta_val_original - v_val_aux).
                   else
                       assign b_val_origin_bem_pat.val_dif_val_origin = b_val_origin_bem_pat.val_dif_val_origin - (v_val_aux - tt_verifica_diferenca_desmem.tta_val_original)
                              b_val_origin_bem_pat.val_original       = b_val_origin_bem_pat.val_original + (v_val_aux - tt_verifica_diferenca_desmem.tta_val_original).
                end.
            end.
        end.        
    end.

END PROCEDURE. /* pi_verificar_valores_originais_origem_api */
/*****************************************************************************
** Procedure Interna.....: pi_validar_unid_negoc
** Descricao.............: pi_validar_unid_negoc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41675_3
** Alterado em...........: 27/04/2011 10:01:17
*****************************************************************************/
PROCEDURE pi_validar_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return                     as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign p_cod_return = "".
    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) = 0 &THEN
    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab /*cl_param_estab of estabelecimento*/ no-error.

    find first param_utiliz_produt no-lock
         where param_utiliz_produt.cod_empresa = estabelecimento.cod_empresa
           and param_utiliz_produt.cod_modul_dtsul = ''
           and param_utiliz_produt.cod_funcao_negoc = 'BU' /*cl_verifica_unid_negoc of param_utiliz_produt*/ no-error.
    if  avail param_utiliz_produt
    then do:
    &ENDIF
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  avail estab_unid_negoc
        then do:
            if  p_dat_refer_ent <> ? and
               (estab_unid_negoc.dat_inic_valid > p_dat_refer_ent or
                estab_unid_negoc.dat_fim_valid  < p_dat_refer_ent)
            then do:
                 assign p_cod_return = "Data" /*l_data*/ .
                 return.
            end /* if */.
            run pi_verifica_segur_unid_negoc (Input p_cod_unid_negoc,
                                              output v_log_return) /*pi_verifica_segur_unid_negoc*/.
            if v_log_return = yes 
            then do:
               assign p_cod_return = "".
               return.
            end /* if */.

            assign p_cod_return = "Usu†rio" /*l_usuario*/ .
        end /* if */.
        else do:
            assign p_cod_return = "Estabelecimento" /*l_estabelecimento*/ .
        end /* else */.
    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) = 0 &THEN
    end /* if */.
    &ENDIF

END PROCEDURE. /* pi_validar_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_converter_finalid_econ_finalid
** Descricao.............: pi_converter_finalid_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut12234_3
** Alterado em...........: 10/04/2006 09:50:41
*****************************************************************************/
PROCEDURE pi_converter_finalid_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ_orig
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ_dest
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_indic_econ
        as character
        format "x(8)":U
        label "Moeda"
        column-label "Moeda"
        no-undo.


    /************************** Variable Definition End *************************/




    run pi_retornar_indic_econ_finalid 

                                       (Input p_cod_finalid_econ_orig,
                                        Input p_dat_transacao,
                                        output v_cod_indic_econ) /* pi_retornar_indic_econ_finalid*/.

    run pi_converter_indic_econ_finalid (Input v_cod_indic_econ,
                                         Input p_cod_unid_organ,
                                         Input p_dat_transacao,
                                         Input p_val_transacao,
                                         Input p_cod_finalid_econ_dest,
                                         output p_cod_return) /*pi_converter_indic_econ_finalid*/.



END PROCEDURE. /* pi_converter_finalid_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_converter_indic_econ_finalid
** Descricao.............: pi_converter_indic_econ_finalid
** Criado por............: karla
** Criado em.............: // 
** Alterado por..........: fut12201
** Alterado em...........: 30/07/2008 10:08:19
*****************************************************************************/
PROCEDURE pi_converter_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cotaá∆o"
        column-label "Data Cotaá∆o"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cotaá∆o"
        column-label "Cotaá∆o"
        no-undo.


    /************************** Variable Definition End *************************/



    elimina:
    for each tt_converter_finalid_econ exclusive-lock: 
        delete tt_converter_finalid_econ. 
    end /* for elimina */. 

    run pi_validar_indic_econ_valid (Input p_cod_indic_econ,
                                     Input p_dat_transacao,
                                     output p_cod_return) /*pi_validar_indic_econ_valid*/. 
    if  p_cod_return <> "OK" /*l_ok*/ 
    then do:
        return. 
    end /* if */. 



    if  p_cod_finalid_econ <> ""
    then do: 
        /* OBS: Esta alteraá∆o deve permanecer no c¢digo fonte, pois esta sendo feita sob demanda. Conforme acordo com a equipe do Test Center, 
               devido lista de impacto muito extensa. Atividade 138100 */
        find first compos_finalid no-lock
             where compos_finalid.cod_indic_econ_base = p_cod_indic_econ
               and compos_finalid.cod_finalid_econ = p_cod_finalid_econ
               and compos_finalid.dat_inic_valid <= p_dat_transacao
               and compos_finalid.dat_fim_valid > p_dat_transacao
             use-index cmpsfnld_parid_indic_econ no-error.
        if  not avail compos_finalid
        then do:
            assign p_cod_return = "782" + "," + p_cod_finalid_econ + "," + p_cod_indic_econ + "," + string(p_dat_transacao).
            return. 
        end /* if */. 

        if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
        then do: 
            find finalid_econ no-lock 
                 where finalid_econ.cod_finalid_econ = compos_finalid.cod_finalid_econ no-error. 
            if  /* finalid_econ.ind_armaz_val = "Contabilidade" /*l_contabilidade*/ 
            or */ finalid_econ.ind_armaz_val = "N∆o" /*l_nao*/ 
            then do:
                assign p_cod_return = "1389" + "," + finalid_econ.cod_finalid_econ. 
                return. 
            end /* if */. 
            run pi_validar_finalid_unid_organ (Input compos_finalid.cod_finalid_econ,
                                               Input p_cod_unid_organ,
                                               Input p_dat_transacao,
                                               output p_cod_return) /*pi_validar_finalid_unid_organ*/. 
            if  p_cod_return <> "OK" /*l_ok*/ 
            then do:
                return. 
            end /* if */. 

            find first compos_finalid_cmcmm no-lock 
                  where compos_finalid_cmcmm.cod_finalid_econ = compos_finalid.cod_finalid_econ 
                    and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid 
                    and compos_finalid_cmcmm.cod_indic_econ_base = compos_finalid.cod_indic_econ_base 
                    and compos_finalid_cmcmm.cod_indic_econ_idx = compos_finalid.cod_indic_econ_idx 
                    and compos_finalid_cmcmm.dat_inic_valid_compos = compos_finalid.dat_inic_valid 
                    and compos_finalid_cmcmm.dat_inic_valid <= p_dat_transacao 
                    and compos_finalid_cmcmm.dat_fim_valid > p_dat_transacao no-error. 

             if  avail compos_finalid_cmcmm
             then do: 
                  run pi_achar_cotac_indic_econ 

                                                (Input compos_finalid.cod_indic_econ_base,
                                                 Input compos_finalid.cod_indic_econ_idx,
                                                 Input p_dat_transacao,
                                                 Input "Real" /*l_real*/ ,
                                                 output v_dat_cotac_indic_econ,
                                                 output v_val_cotac_indic_econ,
                                                 output v_cod_return) /* pi_achar_cotac_indic_econ*/.

                  if  entry(1,v_cod_return) = "358"
                  then do: 
                      elimina:
                      for each tt_converter_finalid_econ exclusive-lock: 
                          delete tt_converter_finalid_econ. 
                      end /* for elimina */. 
                      assign p_cod_return = v_cod_return. 
                      return. 
                  end /* if */. 
                  create tt_converter_finalid_econ. 
                  assign tt_converter_finalid_econ.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ 
                         tt_converter_finalid_econ.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ 
                         tt_converter_finalid_econ.tta_val_cotac_indic_econ = v_val_cotac_indic_econ 
                         tt_converter_finalid_econ.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ. 
                  run pi_retornar_indic_econ_finalid 

                                                     (Input compos_finalid.cod_finalid_econ,
                                                      Input p_dat_transacao,
                                                      output tt_converter_finalid_econ.tta_cod_indic_econ) /* pi_retornar_indic_econ_finalid*/.
             end /* if */. 
             else do: 
                  elimina:
                  for each tt_converter_finalid_econ exclusive-lock: 
                      delete tt_converter_finalid_econ. 
                  end /* for elimina */. 
                  /* alteraá∆o por demanda, deve permanecer no fonte, atividade 159924 (fo 1345764) */   
                  assign p_cod_return = "1200" + "," + 
                                        compos_finalid.cod_indic_econ_base + "," + 
                                        compos_finalid.cod_indic_econ_idx + "," + 
                                        string(p_dat_transacao)  + "," + 
                                        compos_finalid.cod_finalid_econ + "," + 
                                        string(compos_finalid.dat_inic_valid_finalid) + "," +
                                        string(compos_finalid.dat_inic_valid).                                     
                  return. 
             end /* else */. 
        end /* if */. 
        else do: 
            create tt_converter_finalid_econ. 
            assign tt_converter_finalid_econ.tta_cod_finalid_econ      = compos_finalid.cod_finalid_econ 
                   tt_converter_finalid_econ.tta_dat_cotac_indic_econ  = p_dat_transacao 
                   tt_converter_finalid_econ.tta_val_cotac_indic_econ  = 1 
                   tt_converter_finalid_econ.tta_val_transacao         = p_val_transacao 
                   tt_converter_finalid_econ.tta_cod_indic_econ        = compos_finalid.cod_indic_econ_idx. 
        end /* else */. 
    end /* if */. 
    else do: 
        composicoes: 
        for each compos_finalid no-lock 
         where compos_finalid.cod_indic_econ_base = p_cod_indic_econ 
           and compos_finalid.dat_inic_valid <= p_dat_transacao 
           and compos_finalid.dat_fim_valid > p_dat_transacao 
         use-index cmpsfnld_parid_indic_econ : 
           if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
           then do: 
               find finalid_econ no-lock 
                    where finalid_econ.cod_finalid_econ = compos_finalid.cod_finalid_econ no-error. 
               if  finalid_econ.ind_armaz_val = "Contabilidade" /*l_contabilidade*/ 
               or  finalid_econ.ind_armaz_val = "N∆o" /*l_nao*/ 
               then do:
                   next composicoes. 
               end /* if */. 
               run pi_validar_finalid_unid_organ (Input compos_finalid.cod_finalid_econ, 
                                                  Input p_cod_unid_organ, 
                                                  Input p_dat_transacao, 
                                                  output v_cod_return) . 
               if  v_cod_return = "338"
               then do: 
                   next composicoes. 
               end /* if */. 
                find first compos_finalid_cmcmm no-lock 
                     where compos_finalid_cmcmm.cod_finalid_econ = compos_finalid.cod_finalid_econ 
                       and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid 
                       and compos_finalid_cmcmm.cod_indic_econ_base = compos_finalid.cod_indic_econ_base 
                       and compos_finalid_cmcmm.cod_indic_econ_idx = compos_finalid.cod_indic_econ_idx 
                       and compos_finalid_cmcmm.dat_inic_valid_compos = compos_finalid.dat_inic_valid 
                       and compos_finalid_cmcmm.dat_inic_valid <= p_dat_transacao 
                       and compos_finalid_cmcmm.dat_fim_valid > p_dat_transacao no-error. 

                if  avail compos_finalid_cmcmm
                then do: 
                     run pi_achar_cotac_indic_econ 

                                                   (Input compos_finalid.cod_indic_econ_base, 
                                                    Input compos_finalid.cod_indic_econ_idx, 
                                                    Input p_dat_transacao, 
                                                    Input "Real" /*l_real*/ ,
                                                    output v_dat_cotac_indic_econ, 
                                                    output v_val_cotac_indic_econ, 
                                                    output v_cod_return) . 
                     if  entry(1,v_cod_return) = "358"
                     then do:
                        elimina: 
                        for 
                            each tt_converter_finalid_econ exclusive-lock: 
                            delete tt_converter_finalid_econ. 
                        end . 
                        assign p_cod_return = v_cod_return. 
                        return. 
                     end /* if */. 
                     create tt_converter_finalid_econ. 
                     assign tt_converter_finalid_econ.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ 
                            tt_converter_finalid_econ.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ 
                            tt_converter_finalid_econ.tta_val_cotac_indic_econ = v_val_cotac_indic_econ 
                            tt_converter_finalid_econ.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ. 
                     run pi_retornar_indic_econ_finalid

                                                        (Input compos_finalid.cod_finalid_econ, 
                                                         Input p_dat_transacao, 
                                                         output tt_converter_finalid_econ.tta_cod_indic_econ) . 

                end /* if */. 
                else do: 
                   elimina: 
                   for 
                       each tt_converter_finalid_econ exclusive-lock: 
                       delete tt_converter_finalid_econ. 
                   end . 
                   /* alteraá∆o por demanda, deve permanecer no fonte, atividade 159924 (fo 1345764) */   
                   assign p_cod_return = "1200" + "," + 
                                         compos_finalid.cod_indic_econ_base + "," + 
                                         compos_finalid.cod_indic_econ_idx + "," + 
                                         string(p_dat_transacao) + "," +
                                         compos_finalid.cod_finalid_econ + "," + 
                                         string(compos_finalid.dat_inic_valid_finalid) + "," +
                                         string(compos_finalid.dat_inic_valid).                                     
                   return. 
                end /* else */. 
           end /* if */. 
           else do: 
                create tt_converter_finalid_econ. 
                assign tt_converter_finalid_econ.tta_cod_finalid_econ      = compos_finalid.cod_finalid_econ 
                       tt_converter_finalid_econ.tta_dat_cotac_indic_econ  = p_dat_transacao 
                       tt_converter_finalid_econ.tta_val_cotac_indic_econ  = 1 
                       tt_converter_finalid_econ.tta_val_transacao         = p_val_transacao 
                       tt_converter_finalid_econ.tta_cod_indic_econ        = compos_finalid.cod_indic_econ_idx. 
           end /* else */. 
        end . 
        find first tt_converter_finalid_econ no-lock no-error. 
        if  not avail tt_converter_finalid_econ
        then do: 
            assign p_cod_return = "1568". 
            return. 
        end /* if */. 
    end /* else */. 

    assign p_cod_return = "OK" /*l_ok*/ .
END PROCEDURE. /* pi_converter_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_validar_indic_econ_valid
** Descricao.............: pi_validar_indic_econ_valid
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 26/09/1995 10:04:56
*****************************************************************************/
PROCEDURE pi_validar_indic_econ_valid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find indic_econ no-lock
         where indic_econ.cod_indic_econ = p_cod_indic_econ /*cl_indic_econ_valid of indic_econ*/ no-error.
    if  not avail indic_econ
    then do:
       assign p_cod_return = "241".
       return.
    end /* if */.

    if  p_dat_transacao <  indic_econ.dat_inic_valid or
       p_dat_transacao >= indic_econ.dat_fim_valid
    then do:
       assign p_cod_return = "1199".
       return.
    end /* if */.

    assign p_cod_return = "OK" /*l_ok*/ .

END PROCEDURE. /* pi_validar_indic_econ_valid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ
** Descricao.............: pi_achar_cotac_indic_econ
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut1309_4
** Alterado em...........: 08/02/2006 16:12:34
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
    &if "{&emsuni_version}" >= "5.01" &then
                     use-index ctcprd_id
    &endif
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
    &if "{&emsuni_version}" >= "5.01" &then
                         use-index prdndccn_id
    &endif
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: bre17752
** Alterado em...........: 30/07/2003 12:46:24
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di†ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */
/*****************************************************************************
** Procedure Interna.....: pi_gerar_retorno_converter_finalid
** Descricao.............: pi_gerar_retorno_converter_finalid
** Criado por............: its0048
** Criado em.............: 07/10/2004 16:40:51
** Alterado por..........: fut36015
** Alterado em...........: 18/01/2007 17:07:34
*****************************************************************************/
PROCEDURE pi_gerar_retorno_converter_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    case entry(1, p_cod_return):
        when '782' then
            erro_block:
            do:
                /* Finalidade econÀmica nío relacionada para o Indic EconÀmico ! */
                run pi_messages (input 'show',
                                 input 782,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_782*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '338' then
            erro_block:
            do:
                /* Finalidade nío liberada para a Unidade Organizacional ! */
                run pi_messages (input 'show',
                                 input 338,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_338*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '358' then
            erro_block:
            do:
                /* Cotaªío entre Indicadores EconÀmicos nío encontrada ! */
                run pi_messages (input 'show',
                                 input 358,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                    entry(2, p_cod_return), entry(3, p_cod_return), entry(4, p_cod_return), entry(5, p_cod_return))) /* msg_358*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '1200' then
            erro_block:
            do:
                /* alteraá∆o por demanda, deve permanecer no fonte, atividade 159924 (fo 1345764) */
                /* Par≥metros de conversío da composiªío inexistentes ! */
                run pi_messages (input 'show',
                                 input 1200,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                    entry(2, p_cod_return), entry(3, p_cod_return), entry(4, p_cod_return), entry(5, p_cod_return), entry(6, p_cod_return), entry(7, p_cod_return), "Finalidade:" /*l_finalidade:*/ , "- Data In°cio Validade Finalidade:" /*l_ds_dt1*/ , "- Data In°cio Validade:" /*l_ds_dt2*/ )) /* msg_1200*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '1389' then
            erro_block:
            do:
                /* Finalidade EconÀmica nío armazena valores no MΩdulo ! */
                run pi_messages (input 'show',
                                 input 1389,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                    entry(2, p_cod_return))) /* msg_1389*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '241' then
            erro_block:
            do:
                /* Indicador EconÀmico Inexistente ! */
                run pi_messages (input 'show',
                                 input 241,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_241*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '1199' then
            erro_block:
            do:
                /* Indicador EconÀmico nío habilitado na Data da Transaªío ! */
                run pi_messages (input 'show',
                                 input 1199,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_1199*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when '1568' then
            erro_block:
            do:
                /* Valor nío convertido para outras finalidades ! */
                run pi_messages (input 'show',
                                 input 1568,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_1568*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
        when 'OK' /* l_ok*/ then.
        otherwise
            erro_block:
            do:
                /* Comunique a Datasul sobre esta mensagem ! */
                run pi_messages (input 'show',
                                 input 1036,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')) /* msg_1036*/.
                return 'NOK' /* l_nok*/ .
            end /* do erro_block */.
    end /* case teste_block */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_gerar_retorno_converter_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_desmemb_por_valor
** Descricao.............: pi_desmemb_por_valor
** Criado por............: its0048
** Criado em.............: 22/10/2004 15:13:13
** Alterado por..........: its0105
** Alterado em...........: 27/06/2005 18:39:48
*****************************************************************************/
PROCEDURE pi_desmemb_por_valor:

    if v_val_original_cal < 0 then do:
        if b_bem_pat.qtd_bem_pat_represen > 1 then do:
            if (abs(v_val_origin_desmembr) + abs(tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat)) <> abs(v_val_original_cal) then do:
                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor a desmembrar deve ser o valor total do bem !", "FAS") /*13110*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        else do:
            if tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat > 0 then do:
                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Valor Ö desmembrar ultrapassa o valor do bem: &1 !", "FAS") /*857*/, v_val_original_cal).
                return "NOK" /*l_nok*/ .
            end. 
            else do:
                if (abs(v_val_origin_desmembr) + abs(tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat)) > abs(v_val_original_cal) then do:
                    assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Valor Ö desmembrar ultrapassa o valor do bem: &1 !", "FAS") /*857*/, v_val_original_cal).
                    return "NOK" /*l_nok*/ .
                end.
            end.
        end.
    end.
    else do:
        if b_bem_pat.qtd_bem_pat_represen > 1 then do:
            if (abs(v_val_origin_desmembr) + abs(tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat)) <> abs(v_val_original_cal) then do:
                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Valor a desmembrar deve ser o valor total do bem !", "FAS") /*13110*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        else do:
            if (abs(v_val_origin_desmembr) + abs(tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat)) > abs(v_val_original_cal) then do:
                assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Valor Ö desmembrar ultrapassa o valor do bem: &1 !", "FAS") /*857*/, v_val_original_cal).
                return "NOK" /*l_nok*/ .
            end.            
        end.
    end.

    assign tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat * 100
                                                                     / v_val_original_cal.

    find cta_pat no-lock
         where cta_pat.cod_empresa = v_cod_empres_usuar
           and cta_pat.cod_cta_pat = tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat no-error.
    if  not avail cta_pat then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Conta Patrimonial n∆o cadastrada !", "FAS") /*708*/.
        return "NOK" /*l_nok*/ .
    end.

    if v_log_congel_cenar_ctbl then do:
        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
            EMPTY TEMP-TABLE tt_bem_pat_cong NO-ERROR.
        &ELSE
            FOR EACH tt_bem_pat_cong:
                DELETE tt_bem_pat_cong.
            END.
        &ENDIF

        CREATE tt_bem_pat_cong.
        ASSIGN tt_bem_pat_cong.tta_cod_grp_calc  = cta_pat.cod_grp_calc
               tt_bem_pat_cong.ttv_dat_movto     = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
               tt_bem_pat_cong.ttv_ind_tip_param = "G" /*l_G*/  .
    end.

    if  search("prgfin/fgl/fgl721za.r") = ? and search("prgfin/fgl/fgl721za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl721za.py".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl721za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl721za.py (Input table tt_bem_pat_cong,
                                Input v_cod_empres_usuar,
                                Input "FAS" /*l_fas*/,
                                Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                output v_des_sit_movimen_cenar,
                                output table tt_erros_cenario) /*prg_fnc_consiste_cenar_ctbl*/.
    if v_des_sit_movimen_cenar <> '' and not can-do(v_des_sit_movimen_cenar,"Habilitado" /*l_habilitado*/ ) then do:
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Data &1 est† em per°odo desabilitado !", "FAS") /*872*/,tt_desmembramento_bem_pat_api.ttv_dat_desmbrto).
        return "NOK" /*l_nok*/ .
    end.
    else do:
        find first tt_erros_cenario no-error.
        if  avail tt_erros_cenario then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Data &1 est† em um per°odo desabilitado para o cen†rio &2 no m¢dulo &3.", "FAS") /*11992*/, tt_erros_cenario.ttv_dat_refer_sit, tt_erros_cenario.tta_cod_cenar_ctbl, tt_erros_cenario.tta_cod_modul_dtsul).
            return "NOK" /*l_nok*/ .
        end.
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_desmemb_por_valor */
/*****************************************************************************
** Procedure Interna.....: pi_desmemb_por_percentual
** Descricao.............: pi_desmemb_por_percentual
** Criado por............: its0048
** Criado em.............: 22/10/2004 15:13:31
** Alterado por..........: its0105
** Alterado em...........: 12/07/2005 16:34:12
*****************************************************************************/
PROCEDURE pi_desmemb_por_percentual:

    if b_bem_pat.qtd_bem_pat_represen > 1 then do:
        if  tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat <> 100 then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Percentual a desmembrar deve ser 100% !", "FAS") /*13111*/.
            return "NOK" /*l_nok*/ .
        end.
    end.
    else do:
        if  v_val_perc_desmembr_aux > 100 then do:
            assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Percentual do Desmembramento passa dos 100% do Bem !", "FAS") /*864*/.
            return "NOK" /*l_nok*/ .
        end.
    end.
END PROCEDURE. /* pi_desmemb_por_percentual */
/*****************************************************************************
** Procedure Interna.....: pi_desmemb_por_quantidade
** Descricao.............: pi_desmemb_por_quantidade
** Criado por............: its0048
** Criado em.............: 22/10/2004 15:13:22
** Alterado por..........: its0105
** Alterado em...........: 20/05/2005 11:18:14
*****************************************************************************/
PROCEDURE pi_desmemb_por_quantidade:

    if (v_qtd_bem_pat_desmembr + tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen) > b_bem_pat.qtd_bem_pat_represen then do:
        /* erro 868 - Quantidade Ö desmembrar Ç maior que a quantidade do Bem: &1 ! */
        assign tt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Quantidade Ö desmembrar Ç maior que a quantidade do Bem: &1 !", "FAS") /*868*/,b_bem_pat.qtd_bem_pat_represen).
        return "NOK" /*l_nok*/ .
    end.

    assign tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat = tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen * 100
                                                                     / b_bem_pat.qtd_bem_pat_represen.

END PROCEDURE. /* pi_desmemb_por_quantidade */
/*****************************************************************************
** Procedure Interna.....: pi_desmembrto_novo_bem_pat_erro
** Descricao.............: pi_desmembrto_novo_bem_pat_erro
** Criado por............: its0105
** Criado em.............: 20/12/2004 16:00:56
** Alterado por..........: its0105
** Alterado em...........: 20/05/2005 11:17:54
*****************************************************************************/
PROCEDURE pi_desmembrto_novo_bem_pat_erro:

    for each btt_desmemb_novos_bem_pat_api
        where btt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto         = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto
        and   btt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = "":

        assign btt_desmemb_novos_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("O novo bem ou o Bem informado para Desmembramento possui alguma inconsistància.", "FAS") /*13718*/.
    end.
END PROCEDURE. /* pi_desmembrto_novo_bem_pat_erro */
/*****************************************************************************
** Procedure Interna.....: pi_rotina_integr_manuf_API
** Descricao.............: pi_rotina_integr_manuf_API
** Criado por............: fut35183_2
** Criado em.............: 05/09/2005 11:10:54
** Alterado por..........: carinah
** Alterado em...........: 29/08/2017 14:59:15
*****************************************************************************/
PROCEDURE pi_rotina_integr_manuf_API:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_cta_pat
        as character
        format "x(18)"
        no-undo.
    def Input param p_num_bem_pat
        as integer
        format ">>>>>>>>9"
        no-undo.
    def Input param p_num_seq_bem_pat
        as integer
        format ">>>>9"
        no-undo.
    def Input param p_dat_movto_bem_pat
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_orig_calc_bem_pat
        as character
        format "X(20)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_gerac
        as character
        format "X(08)":U
        no-undo.
    def var v_log_connect_inic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    &if defined(BF_FIN_BXA_BEM_MANUF) &then
        assign v_log_bxa_bem = yes. 
    &else
        if can-find(first emsbas.histor_exec_especial  
           where emsbas.histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/     
           and emsbas.histor_exec_especial.cod_prog_dtsul = 'spp_bxa_bem_manuf':U) then  
               assign v_log_bxa_bem = yes. 
    &endif

    if  v_log_bxa_bem = yes then do:

        find first param_integr_ems 
        where param_integr_ems.ind_param_integr_ems = "Manufatura" /*l_manufatura*/  no-lock no-error.

        if avail param_integr_ems then do:
            assign v_ind_tip_gerac = "On-Line" /*l_online*/ .
            if  v_cod_dwb_user begins 'es_' then
                assign v_ind_tip_gerac = "Batch" /*l_batch*/ .

            /* Conecta os bancos externos */                                                       
            run pi_conecta_base_ems2_new (input 3,
                                          input v_ind_tip_gerac).   /* 3 - Conecta, 4 - Desconecta*/

            if v_log_connect = yes or v_log_connect_ems2_ok = yes then do:

                run pi_verifica_bases_externas_conectadas(output v_log_connect_inic).

                if not v_log_connect_inic then leave.

                if  search('cdp/cd9904.r') = ? and search('cdp/cd9904.p') = ? then do:
                    if  v_cod_dwb_user begins 'es_' then
                        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + 'cdp/cd9904.p'.
                    else do:
                        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  getStrTrans("cdp/cd9904.p", "FAS")
                            view-as alert-box error buttons ok.
                        return.
                    end.
                end.
                else do:
                    run cdp/cd9904.p (input 1). /* Verifica se o Frotas esta implantado no EMS */

                    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                        EMPTY TEMP-TABLE tt_log_erros NO-ERROR.
                        EMPTY TEMP-TABLE tt_xml_input_output NO-ERROR.                   
                    &ELSE
                        FOR EACH tt_log_erros:
                            DELETE tt_log_erros.
                        END.
                        FOR EACH tt_xml_input_output:
                            DELETE tt_xml_input_output.
                        END.
                    &ENDIF

                    FOR EACH tt_trans_bem_aux:
                        DELETE tt_trans_bem_aux.
                    END.                                    

                    if return-value = "OK" /*l_ok*/  then do:              
                        CREATE tt_xml_input_output.
                        ASSIGN tt_xml_input_output.ttv_cod_label    = 'Funá∆o':U 
                               tt_xml_input_output.ttv_des_conteudo = "Manufatura" /*l_manufatura*/ 
                               tt_xml_input_output.ttv_num_seq_1    = 1.
                        CREATE tt_xml_input_output.
                        ASSIGN tt_xml_input_output.ttv_cod_label    = 'Produto':U
                               tt_xml_input_output.ttv_des_conteudo = "EMS 2" /*l_ems2*/ 
                               tt_xml_input_output.ttv_num_seq_1    = 1.
                        CREATE tt_xml_input_output.
                        ASSIGN tt_xml_input_output.ttv_cod_label    = 'Empresa':U
                               tt_xml_input_output.ttv_des_conteudo = p_cod_empresa
                               tt_xml_input_output.ttv_num_seq_1    = 1.

                        if  search('prgint/utb/utb786za.r') = ? and search('prgint/utb/utb786za.py') = ? then do:
                           if  v_cod_dwb_user begins 'es_' then
                               return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + 'prgint/utb/utb786za.py'.
                           else do:
                               message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgint/utb/utb786za.py"
                               view-as alert-box error buttons ok.
                               return.
                           end.
                        end.
                        else
                           run prgint/utb/utb786za.py (input-output table tt_xml_input_output,
                                                       output table tt_log_erros).

                        /* A api de traducao exige que alÇm da empresa o estabelecimento tambÇm seja traduzido. Como neste
                        caso a traducao do estabelecimento ainda nao Ç possÇvel estamos eliminando o registro de erro criado. */
                        for each tt_log_erros:
                            if tt_log_erros.ttv_num_cod_erro = 10209 
                            and index(tt_log_erros.ttv_des_ajuda,"Estabelecimento" /*l_estabelecimento*/ ) <> 0 then
                                delete tt_log_erros.
                            else do:
                                assign tt_log_erros.ttv_num_cod_erro  = tt_log_erros.ttv_num_cod_erro
                                       tt_log_erros.ttv_des_ajuda = tt_log_erros.ttv_des_erro
                                       tt_log_erros.ttv_des_erro  = tt_log_erros.ttv_des_ajuda.
                            end.
                        end.

                        if can-find(first tt_log_erros) then
                          return.

                        /* Localiza traducao */
                        find first tt_xml_input_output
                        where tt_xml_input_output.ttv_cod_label = 'Empresa':U no-error.
                        if avail tt_xml_input_output then
                           assign p_cod_empresa = tt_xml_input_output.ttv_des_conteudo_aux.

                        create tt_trans_bem_aux.
                        assign &IF '{&emsfin_version}' < '5.07A' &THEN
                               tt_trans_bem_aux.ttv_num_empresa        = integer(p_cod_empresa)
                               &ELSE
                               tt_trans_bem_aux.ttv_num_empresa        = p_cod_empresa
                               &ENDIF
                               tt_trans_bem_aux.ttv_cod_cta_pat        = p_cod_cta_pat
                               tt_trans_bem_aux.ttv_num_bem_pat        = p_num_bem_pat
                               tt_trans_bem_aux.ttv_num_seq_bem_pat    = p_num_seq_bem_pat
                               tt_trans_bem_aux.ttv_dat_trans          = p_dat_movto_bem_pat
                               tt_trans_bem_aux.ttv_situacao           = p_ind_orig_calc_bem_pat.

                        /* Apos a traducao da empresa, chamar a API do modulo de Frotas, passando estas informacoes como parametro:*/
                        if  search('cdp/cdapi024a.r') = ? and search('cdp/cdapi024a.p') = ? then do:
                            if  v_cod_dwb_user begins 'es_' then
                                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/   + 'cdp/cdapi024a.p'.
                            else do:
                                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/   getStrTrans("cdp/cdapi024a.p", "FAS")
                                       view-as alert-box error buttons ok.
                                return.
                            end.
                        end.
                        else do:
                            run cdp/cdapi024a.p (input  table tt_trans_bem_aux,
                                                 output table tt_row_errors).
                        end.  

                        if  can-find(first tt_row_errors) then do:
                            assign v_log_erro_integr = yes.
                            for each tt_row_errors no-lock:
                                assign v_dsl_msg_erro = v_dsl_msg_erro + 'Seq_Erro: ' + string(tt_row_errors.ttv_num_seq_erro) + 
                                       'Num Erro: ' + string(tt_row_errors.ttv_num_erro) + 'Desc.: '+ tt_row_errors.ttv_des_erro + '   '.                              
                            end.
                        end.
                    end.
                end.
            end.            
        end.      

        /* Desconecta os bancos externos EMS2 */
        if  v_log_connect_ems2_ok = yes or v_log_connect = yes then
            run pi_conecta_base_ems2_new (input 4,
                                          input v_ind_tip_gerac).  
    end.   
END PROCEDURE. /* pi_rotina_integr_manuf_API */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_bases_externas_conectadas
** Descricao.............: pi_verifica_bases_externas_conectadas
** Criado por............: src388
** Criado em.............: 18/09/2003 13:26:16
** Alterado por..........: fut12197
** Alterado em...........: 07/10/2005 12:05:54
*****************************************************************************/
PROCEDURE pi_verifica_bases_externas_conectadas:

    /************************ Parameter Definition Begin ************************/

    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* Procedure criada para que este c¢digo pudesse ser utulizdo em outros procedimentos */
    if (connected('mguni') &if '{&emsfin_dbtype}' <> "progress" /*l_progress*/   &then and connected('shmguni') &endif)
    or (connected('mgdis') &if '{&emsfin_dbtype}' <> "progress" /*l_progress*/   &then and connected('shmgdis') &endif)
    or (connected('mgadm') &if '{&emsfin_dbtype}' <> "progress" /*l_progress*/   &then and connected('shmgadm') &endif)
    or (connected('ems2cad') &if '{&emsfin_dbtype}' <> "progress" /*l_progress*/   &then and connected('shems2cad') &endif)
    or (connected('ems2mov') &if '{&emsfin_dbtype}' <> "progress" /*l_progress*/   &then and connected('shems2mov') &endif)
    then assign p_log_return = yes.
END PROCEDURE. /* pi_verifica_bases_externas_conectadas */
/*****************************************************************************
** Procedure Interna.....: pi_baixa_bem_desmemb_incorp
** Descricao.............: pi_baixa_bem_desmemb_incorp
** Criado por............: its0048
** Criado em.............: 08/10/2004 11:12:40
** Alterado por..........: fut41422
** Alterado em...........: 04/03/2015 09:31:03
*****************************************************************************/
PROCEDURE pi_baixa_bem_desmemb_incorp:

    if b_bem_pat.val_perc_bxa = 100 then do:
        find last b_movto_bem_pat_implant
            where b_movto_bem_pat_implant.num_id_bem_pat = b_bem_pat.num_id_bem_pat
            and   b_movto_bem_pat_implant.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  no-lock no-error.
        if not avail b_movto_bem_pat_implant
        or (avail b_movto_bem_pat_implant
        and (b_movto_bem_pat_implant.ind_orig_calc_bem_pat = "Reclassificaá∆o" /*l_reclassificacao*/ 
        or b_movto_bem_pat_implant.ind_orig_calc_bem_pat = "Desmembramento" /*l_desmembramento*/ 
        or b_movto_bem_pat_implant.ind_orig_calc_bem_pat = "Uni∆o" /*l_uniao*/ )) then do:
            assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Este bem ja esta baixado totalmente por reclassificaá∆o, uni∆o ou outro desmembramento anterior, por isso n∆o pode ser desmembrado.", "FAS") /*9238*/.
            return "NOK" /*l_nok*/ .
        end.
    end.
    if not can-find(first compos_grp_calc
                    where compos_grp_calc.cod_grp_calc = b_bem_pat.cod_grp_calc
                    and compos_grp_calc.cod_tip_calc   = ' ') then do:
        assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("ê necess†rio que se cadastre no m°nimo uma Composiá∆o de Grupo C†lculo com o tipo de C†lculo em branco, que servir† para indicar as composiá‰es Cen†rios/Finalidades onde ser∆o gerados os Valores Originais, Registros de C†lculo e Registros de Saldo.", "FAS") /*2650*/.
        return "NOK" /*l_nok*/ .
    end.
    blk_desmembrar:
    do on error undo blk_desmembrar, leave blk_desmembrar on endkey undo blk_desmembrar, leave blk_desmembrar:
        assign v_val_perc_desmembr = 0 v_val_origin_desmembr = 0 v_qtd_bem_pat_desmembr = 0.
        if b_bem_pat.cod_arrendador <> '' and b_bem_pat.cod_contrat_leas <> '' then do:
            find first contrat_leas no-lock
                where contrat_leas.cod_arrendador = b_bem_pat.cod_arrendador
                and contrat_leas.cod_contrat_leas = b_bem_pat.cod_contrat_leas no-error.
            if (contrat_leas.dat_term_contrat_leas <> ?
            and contrat_leas.dat_term_contrat_leas > contrat_leas.dat_fim_valid
            and tt_desmembramento_bem_pat_api.ttv_dat_desmbrto < contrat_leas.dat_term_contrat_leas)
            or (tt_desmembramento_bem_pat_api.ttv_dat_desmbrto < contrat_leas.dat_fim_valid) then do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Para bens relacionados Ö contratos de leasing, somente poder∆o ser desmobilizados (desmembramento, baixa, uni∆o e transferància), quando a data do movimento for maior que a data de tÇrmino do contrato.", "FAS") /*2264*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        find first tt_desmemb_novos_bem_pat_api
            where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto exclusive-lock no-error.
        if avail tt_desmemb_novos_bem_pat_api then do:
            for each tt_desmemb_novos_bem_pat_api
                where tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto = tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto exclusive-lock:
                assign v_val_perc_desmembr    = v_val_perc_desmembr         + tt_desmemb_novos_bem_pat_api.ttv_val_perc_movto_bem_pat
                       v_val_origin_desmembr  = round(v_val_origin_desmembr + tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat,2)
                       v_qtd_bem_pat_desmembr = v_qtd_bem_pat_desmembr      + tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen.
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/ 
            and abs(v_val_origin_desmembr) > abs(v_val_original_cal) then do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Verifique o valor do Bem Patrimonial. O valor que vocà est† tentando desmembrar n∆o pode ser maior que o valor original do Bem Patrimonial.", "FAS") /*857*/.
                return "NOK" /*l_nok*/ .
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/ 
            and v_val_perc_desmembr > 100 then do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("O(s) percentual(is) informado(s) totalizam &1%. Eles n∆o podem ultrapassar os 100% do Bem Patrimonial.", "FAS") /*864*/, v_val_perc_desmembr).
                return "NOK" /*l_nok*/ .
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/ 
            and v_qtd_bem_pat_desmembr > b_bem_pat.qtd_bem_pat_represen then do:
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = getStrTrans("Verifique a quantidade do Bem Patrimonial. Vocà n∆o pode desmembrar uma quantidade superior Ö quantidade do Bem Patrimonial.", "FAS") /*868*/.
                return "NOK" /*l_nok*/ .
            end.
            run pi_retornar_finalid_indic_econ (Input b_bem_pat.cod_indic_econ,
                                                Input b_bem_pat.dat_calc_pat,
                                                output v_cod_finalid_econ_bem_orig).
            run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_bem_orig,
                                                Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                                output v_cod_indic_econ_bem_orig).
            run pi_retornar_cenar_ctbl_fisc (Input b_bem_pat.cod_empresa,
                                             Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                             output v_cod_cenar_ctbl_fisc).
            create b_movto_bem_pat_desmbrto.
            assign b_movto_bem_pat_desmbrto.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                   b_movto_bem_pat_desmbrto.num_seq_incorp_bem_pat = 0
                   b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat  = next-value(seq_movto_bem_pat)
                   b_movto_bem_pat_desmbrto.dat_movto_bem_pat      = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
                   b_movto_bem_pat_desmbrto.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  
                   b_movto_bem_pat_desmbrto.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/  
                   b_movto_bem_pat_desmbrto.cod_empresa            = b_bem_pat.cod_empresa
                   b_movto_bem_pat_desmbrto.cod_plano_ccusto       = b_bem_pat.cod_plano_ccusto
                   b_movto_bem_pat_desmbrto.cod_ccusto_respons     = b_bem_pat.cod_ccusto_respons
                   b_movto_bem_pat_desmbrto.cod_unid_negoc         = b_bem_pat.cod_unid_negoc
                   b_movto_bem_pat_desmbrto.cod_estab              = b_bem_pat.cod_estab.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
                assign v_num_seq_incorp_bem_pat = 0.
                find last b_val_origin_bem_pat no-lock
                    where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                    and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = v_num_seq_incorp_bem_pat
                    and   b_val_origin_bem_pat.cod_cenar_ctbl         = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                    and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
                assign v_val_origin_moed_bem_pat = round(b_val_origin_bem_pat.val_original,2)
                       b_movto_bem_pat_desmbrto.cod_cenar_ctbl           = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                       b_movto_bem_pat_desmbrto.cod_indic_econ           = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ
                       b_movto_bem_pat_desmbrto.val_origin_movto_bem_pat = v_val_origin_desmembr
                       b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat   = v_val_perc_desmembr.
                find last b_sdo_bem_pat
                    where b_sdo_bem_pat.num_id_bem_pat         = b_movto_bem_pat_desmbrto.num_id_bem_pat
                    and   b_sdo_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_desmbrto.num_seq_incorp_bem_pat
                    and   b_sdo_bem_pat.cod_cenar_ctbl         = b_movto_bem_pat_desmbrto.cod_cenar_ctbl
                    and   b_sdo_bem_pat.cod_finalid_econ       = v_cod_finalid_aux no-lock no-error.
                if avail b_sdo_bem_pat then do:
                    if v_val_origin_desmembr = b_sdo_bem_pat.val_original then
                        assign b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat = 100.
                end.
            end.
            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then
                assign b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat = v_val_perc_desmembr.

            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then
                assign b_movto_bem_pat_desmbrto.qtd_movto_bem_pat      = v_qtd_bem_pat_desmembr
                       b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat = v_val_perc_desmembr.

            assign b_movto_bem_pat_desmbrto.cod_empresa        = b_bem_pat.cod_empresa
                   b_movto_bem_pat_desmbrto.cod_plano_ccusto   = b_bem_pat.cod_plano_ccusto
                   b_movto_bem_pat_desmbrto.cod_ccusto_respons = b_bem_pat.cod_ccusto_respons
                   b_movto_bem_pat_desmbrto.cod_unid_negoc     = b_bem_pat.cod_unid_negoc
                   b_movto_bem_pat_desmbrto.cod_estab          = b_bem_pat.cod_estab.
            validate b_movto_bem_pat_desmbrto.

            for each incorp_bem_pat no-lock
                where incorp_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
                if incorp_bem_pat.dat_incorp_bem_pat > tt_desmembramento_bem_pat_api.ttv_dat_desmbrto then
                    next.
                create b_movto_bem_pat_incorp.
                assign b_movto_bem_pat_incorp.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                       b_movto_bem_pat_incorp.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                       b_movto_bem_pat_incorp.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat
                       b_movto_bem_pat_incorp.dat_movto_bem_pat      = tt_desmembramento_bem_pat_api.ttv_dat_desmbrto
                       b_movto_bem_pat_incorp.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  
                       b_movto_bem_pat_incorp.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/  
                       b_movto_bem_pat_incorp.cod_empresa            = b_bem_pat.cod_empresa
                       b_movto_bem_pat_incorp.cod_plano_ccusto       = b_bem_pat.cod_plano_ccusto
                       b_movto_bem_pat_incorp.cod_ccusto_respons     = b_bem_pat.cod_ccusto_respons
                       b_movto_bem_pat_incorp.cod_unid_negoc         = b_bem_pat.cod_unid_negoc
                       b_movto_bem_pat_incorp.cod_estab              = b_bem_pat.cod_estab.

                if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Valor" /*l_por_valor*/  then do:
                    if trim(incorp_bem_pat.cod_cenar_ctbl) = '' then do:
                        find last b_val_origin_bem_pat no-lock
                            where b_val_origin_bem_pat.num_id_bem_pat       = b_bem_pat.num_id_bem_pat
                            and b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                            and b_val_origin_bem_pat.cod_cenar_ctbl         = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                            and b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
                        if avail b_val_origin_bem_pat then
                            assign v_val_origin_moed_bem_pat                       = round(b_val_origin_bem_pat.val_original,2)
                                   b_movto_bem_pat_incorp.cod_cenar_ctbl           = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                                   b_movto_bem_pat_incorp.cod_indic_econ           = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ
                                   b_movto_bem_pat_incorp.val_origin_movto_bem_pat = round((v_val_origin_moed_bem_pat -
                                                                                     (v_val_origin_moed_bem_pat * v_val_perc_desmembr) / 100),2)
                                   b_movto_bem_pat_incorp.val_perc_movto_bem_pat   = v_val_perc_desmembr.
                        if b_movto_bem_pat_incorp.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  then do:
                            run pi_retornar_finalid_indic_econ(input b_movto_bem_pat_incorp.cod_indic_econ,
                                                               input b_movto_bem_pat_incorp.dat_movto_bem_pat, 
                                                               output v_cod_finalid_aux).
                            find last b_sdo_bem_pat
                                where b_sdo_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp.num_id_bem_pat
                                and   b_sdo_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp.num_seq_incorp_bem_pat
                                and   b_sdo_bem_pat.cod_cenar_ctbl         = b_movto_bem_pat_incorp.cod_cenar_ctbl
                                and   b_sdo_bem_pat.cod_finalid_econ       = v_cod_finalid_aux no-lock no-error.
                            if avail b_sdo_bem_pat then do:
                                if v_val_origin_desmembr = b_sdo_bem_pat.val_original then
                                    assign b_movto_bem_pat_incorp.val_perc_movto_bem_pat = 100.
                            end.
                        end.
                    end.
                    else do:
                        find last b_val_origin_bem_pat no-lock
                            where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
                            and   b_val_origin_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                            and   b_val_origin_bem_pat.cod_cenar_ctbl         = incorp_bem_pat.cod_cenar_ctbl
                            and   b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.
                        if avail b_val_origin_bem_pat then do:
                            assign v_val_origin_moed_bem_pat                       = round(b_val_origin_bem_pat.val_original,2)
                                   b_movto_bem_pat_incorp.cod_cenar_ctbl           = tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl
                                   b_movto_bem_pat_incorp.cod_indic_econ           = tt_desmembramento_bem_pat_api.ttv_cod_indic_econ
                                   b_movto_bem_pat_incorp.val_origin_movto_bem_pat = round(((v_val_origin_moed_bem_pat * v_val_perc_desmembr) / 100),2)
                                   b_movto_bem_pat_incorp.val_perc_movto_bem_pat   = v_val_perc_desmembr.
                            if b_movto_bem_pat_incorp.ind_trans_calc_bem_pat       = "Baixa" /*l_baixa*/  then do:
                                run pi_retornar_finalid_indic_econ(input b_movto_bem_pat_incorp.cod_indic_econ,
                                                                   input b_movto_bem_pat_incorp.dat_movto_bem_pat, 
                                                                   output v_cod_finalid_aux).
                                find last b_sdo_bem_pat
                                    where b_sdo_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp.num_id_bem_pat
                                    and   b_sdo_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp.num_seq_incorp_bem_pat
                                    and   b_sdo_bem_pat.cod_cenar_ctbl         = b_movto_bem_pat_incorp.cod_cenar_ctbl
                                    and   b_sdo_bem_pat.cod_finalid_econ       = v_cod_finalid_aux no-lock no-error.
                                if avail b_sdo_bem_pat then do:
                                    if v_val_origin_desmembr = b_sdo_bem_pat.val_original then
                                        assign b_movto_bem_pat_incorp.val_perc_movto_bem_pat = 100.
                                end.
                            end.       
                        end.
                    end.
                end.
                if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Percentual" /*l_por_percentual*/  then
                    assign b_movto_bem_pat_incorp.val_perc_movto_bem_pat = v_val_perc_desmembr.
                if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then
                    assign b_movto_bem_pat_incorp.qtd_movto_bem_pat      = 0
                           b_movto_bem_pat_incorp.val_perc_movto_bem_pat = v_val_perc_desmembr.

                assign b_movto_bem_pat_incorp.cod_empresa        = b_bem_pat.cod_empresa
                       b_movto_bem_pat_incorp.cod_plano_ccusto   = b_bem_pat.cod_plano_ccusto
                       b_movto_bem_pat_incorp.cod_ccusto_respons = b_bem_pat.cod_ccusto_respons
                       b_movto_bem_pat_incorp.cod_unid_negoc     = b_bem_pat.cod_unid_negoc
                       b_movto_bem_pat_incorp.cod_estab          = b_bem_pat.cod_estab.
                validate b_movto_bem_pat_incorp.
            end.
            blk_param_calc:
            for each param_calc_bem_pat exclusive-lock
                where param_calc_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat 
                break by param_calc_bem_pat.cod_cenar_ctbl  
                      by param_calc_bem_pat.cod_finalid_econ:

                for each tt_finalid_bem_pat_calculo no-lock:
                    delete tt_finalid_bem_pat_calculo.
                end.
                create tt_finalid_bem_pat_calculo.
                assign tt_finalid_bem_pat_calculo.ttv_rec_bem_pat      = recid(bem_pat)
                       tt_finalid_bem_pat_calculo.tta_cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ.

                for each tt_finalid_bem_pat_calculo no-lock:
                    run pi_tt_desmembrto_api.
                    if return-value = 'next' then next.
                    if return-value = 'NOK' then undo blk_param_calc, leave blk_param_calc.
                end.
                find movto_cenar_bem_pat no-lock
                    where movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_desmbrto.num_id_bem_pat
                    and   movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_desmbrto.num_seq_incorp_bem_pat
                    and   movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat
                    and   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl no-error.
                if not avail movto_cenar_bem_pat then do:
                    create movto_cenar_bem_pat.
                    assign movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_desmbrto.num_id_bem_pat
                           movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_desmbrto.num_seq_incorp_bem_pat
                           movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat
                           movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl.
                    validate movto_cenar_bem_pat.
                end.
                blk_incorp:
                for each incorp_bem_pat no-lock
                    where incorp_bem_pat.num_id_bem_pat      = b_movto_bem_pat_desmbrto.num_id_bem_pat
                    and   incorp_bem_pat.dat_incorp_bem_pat <= b_movto_bem_pat_desmbrto.dat_movto_bem_pat:
                    if incorp_bem_pat.cod_cenar_ctbl <> ' ' and  incorp_bem_pat.cod_cenar_ctbl <> param_calc_bem_pat.cod_cenar_ctbl then
                        next blk_incorp.
                    find first b_movto_bem_pat_incorp no-lock
                        where b_movto_bem_pat_incorp.num_id_bem_pat         = b_movto_bem_pat_desmbrto.num_id_bem_pat
                        and   b_movto_bem_pat_incorp.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
                        and   b_movto_bem_pat_incorp.num_seq_movto_bem_pat  = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat no-error.
                    find movto_cenar_bem_pat no-lock
                        where movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp.num_id_bem_pat
                        and   movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp.num_seq_incorp_bem_pat
                        and   movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp.num_seq_movto_bem_pat
                        and   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl no-error.
                    if not avail movto_cenar_bem_pat then do:
                        create movto_cenar_bem_pat.
                        assign movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp.num_id_bem_pat
                               movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp.num_seq_incorp_bem_pat
                               movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp.num_seq_movto_bem_pat
                               movto_cenar_bem_pat.cod_cenar_ctbl = param_calc_bem_pat.cod_cenar_ctbl.
                        validate movto_cenar_bem_pat.
                    end.
                end.
                blk_movto_implant:
                for each movto_bem_pat no-lock
                    where movto_bem_pat.num_id_bem_pat_orig        = b_movto_bem_pat_desmbrto.num_id_bem_pat
                    and   movto_bem_pat.num_seq_movto_bem_pat_orig = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat:
                    find movto_cenar_bem_pat no-lock
                        where movto_cenar_bem_pat.num_id_bem_pat         = movto_bem_pat.num_id_bem_pat
                        and   movto_cenar_bem_pat.num_seq_incorp_bem_pat = movto_bem_pat.num_seq_incorp_bem_pat
                        and   movto_cenar_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat
                        and   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl
                        &if '{&emsfin_version}' >= '5.01' &then
                            use-index mvtcnrbm_id
                        &endif
                        no-error.
                    if not avail movto_cenar_bem_pat then do:
                        create movto_cenar_bem_pat.
                        assign movto_cenar_bem_pat.num_id_bem_pat         = movto_bem_pat.num_id_bem_pat
                               movto_cenar_bem_pat.num_seq_incorp_bem_pat = movto_bem_pat.num_seq_incorp_bem_pat
                               movto_cenar_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat
                               movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl.
                        validate movto_cenar_bem_pat.
                    end.
                    blk_incorp_imp:
                    for each incorp_bem_pat no-lock
                        where incorp_bem_pat.num_id_bem_pat      = movto_bem_pat.num_id_bem_pat
                        and   incorp_bem_pat.dat_incorp_bem_pat <= b_movto_bem_pat_desmbrto.dat_movto_bem_pat:
                        if incorp_bem_pat.cod_cenar_ctbl <> ' ' and  incorp_bem_pat.cod_cenar_ctbl <> param_calc_bem_pat.cod_cenar_ctbl then
                            next blk_incorp_imp.
                        find first b_movto_bem_pat_incorp_aux exclusive-lock
                            where b_movto_bem_pat_incorp_aux.num_id_bem_pat         = movto_bem_pat.num_id_bem_pat
                            and   b_movto_bem_pat_incorp_aux.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat 
                            and   b_movto_bem_pat_incorp_aux.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/  no-error.
                        assign b_movto_bem_pat_incorp_aux.num_seq_movto_bem_pat_orig = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat.
                        find movto_cenar_bem_pat no-lock
                            where movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp_aux.num_id_bem_pat
                            and   movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp_aux.num_seq_incorp_bem_pat
                            and   movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp_aux.num_seq_movto_bem_pat
                            and   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl no-error.
                        if not avail movto_cenar_bem_pat then do:
                            create movto_cenar_bem_pat.
                            assign movto_cenar_bem_pat.num_id_bem_pat         = b_movto_bem_pat_incorp_aux.num_id_bem_pat
                                   movto_cenar_bem_pat.num_seq_incorp_bem_pat = b_movto_bem_pat_incorp_aux.num_seq_incorp_bem_pat
                                   movto_cenar_bem_pat.num_seq_movto_bem_pat  = b_movto_bem_pat_incorp_aux.num_seq_movto_bem_pat
                                   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_bem_pat.cod_cenar_ctbl.
                            validate movto_cenar_bem_pat.
                        end.
                    end.
                end.
            end.
            run pi_verificar_valores_originais_origem_api (input no).
            assign b_bem_pat.val_perc_bxa = b_bem_pat.val_perc_bxa + ((100 - b_bem_pat.val_perc_bxa) * b_movto_bem_pat_desmbrto.val_perc_movto_bem_pat / 100).
            if b_bem_pat.val_perc_bxa > 100 then
                assign b_bem_pat.val_perc_bxa = 100.

            if tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat = "Por Quantidade" /*l_por_quantidade*/  then
                assign b_bem_pat.qtd_bem_pat_represen = b_bem_pat.qtd_bem_pat_represen - v_qtd_bem_pat_desmembr. 
            else 
                if b_bem_pat.val_perc_bxa = 100 then
                    assign b_movto_bem_pat_desmbrto.qtd_movto_bem_pat = b_bem_pat.qtd_bem_pat_represen
                           b_bem_pat.qtd_bem_pat_represen             = 0. 
                else
                    assign b_movto_bem_pat_desmbrto.qtd_movto_bem_pat = 0.

            if b_bem_pat.val_perc_bxa = 100 then
                run pi_rotina_integr_manuf_api(input b_bem_pat.cod_empresa,
                                           input b_bem_pat.cod_cta_pat,
                                           input b_bem_pat.num_bem_pat,
                                           input b_bem_pat.num_seq_bem_pat,
                                               input b_movto_bem_pat_desmbrto.dat_movto_bem_pat,   
                                               input b_movto_bem_pat_desmbrto.ind_orig_calc_bem_pat).   

            if v_log_erro_integr = yes then
                assign tt_desmembramento_bem_pat_api.ttv_des_erro_api_movto_bem_pat = substitute(getStrTrans("Houve erros na integraá∆o com a Manufatura !", "FAS") /*14059*/) + v_dsl_msg_erro.



            if  search("prgfin/fas/fas903zb.r") = ? and search("prgfin/fas/fas903zb.py") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas903zb.py".
                else do:
                    message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas903zb.py"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/fas/fas903zb.py (buffer b_bem_pat,
                                        Input ' ',
                                        Input b_movto_bem_pat_desmbrto.dat_movto_bem_pat) /*prg_fnc_bem_pat_calc_movimento*/.
            if return-value = "NOK" /*l_nok*/  then do:
                return "NOK" /*l_nok*/ .
            end.

            for each param_calc_bem_pat no-lock
                where param_calc_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
                if param_calc_bem_pat.val_resid_min > 0 then
                    assign param_calc_bem_pat.val_resid_min = param_calc_bem_pat.val_resid_min * (1 - (v_val_perc_desmembr / 100)).
            end.
            if v_log_param_calc_incorp = yes then do:
                for each param_calc_incorp_pat no-lock
                    where param_calc_incorp_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
                    if  param_calc_incorp_pat.val_resid_min > 0 then
                        assign param_calc_incorp_pat.val_resid_min = param_calc_incorp_pat.val_resid_min * (1 - (v_val_perc_desmembr / 100)).
                end.
            end.
            else do:
                &if '{&emsfin_version}' >= '5.09' &then
                    for each val_resid_incorp no-lock
                        where val_resid_incorp.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
                        if  val_resid_incorp.val_resid_min > 0 then
                            assign val_resid_incorp.val_resid_min = val_resid_incorp.val_resid_min * (1 - (v_val_perc_desmembr / 100)).
                    end.
                &else
                    for each tab_livre_emsfin no-lock
                        where tab_livre_emsfin.cod_modul_dtsul      = "FAS" /*l_fas*/ 
                        and   tab_livre_emsfin.cod_tab_dic_dtsul    = 'val_resid_incorp'
                        and   tab_livre_emsfin.cod_compon_1_idx_tab begins string(b_bem_pat.num_id_bem_pat):
                        if  tab_livre_emsfin.val_livre_1 > 0 then
                            assign tab_livre_emsfin.val_livre_1 = tab_livre_emsfin.val_livre_1 * (1 - (v_val_perc_desmembr / 100)).
                    end.
                &endif
            end.    

            blk_calculo_implant:
            for each movto_bem_pat no-lock
                where movto_bem_pat.num_id_bem_pat_orig        = b_movto_bem_pat_desmbrto.num_id_bem_pat
                and   movto_bem_pat.num_seq_movto_bem_pat_orig = b_movto_bem_pat_desmbrto.num_seq_movto_bem_pat:

                find bem_pat no-lock
                    where bem_pat.num_id_bem_pat = movto_bem_pat.num_id_bem_pat no-error.

                if  search("prgfin/fas/fas903zb.r") = ? and search("prgfin/fas/fas903zb.py") = ? then do:
                    if  v_cod_dwb_user begins 'es_' then
                        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas903zb.py".
                    else do:
                        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas903zb.py"
                               view-as alert-box error buttons ok.
                        return.
                    end.
                end.
                else
                    run prgfin/fas/fas903zb.py (buffer bem_pat,
                                            Input ' ',
                                            Input movto_bem_pat.dat_movto_bem_pat) /*prg_fnc_bem_pat_calc_movimento*/.
                if return-value = "NOK" /*l_nok*/  then do:
                    return "NOK" /*l_nok*/ .
                end.
            end.
        end. /* if avail tt_desmemb_novos_bem_pat_api then do:*/
        run pi_verificar_valores_originais_origem_api (input yes).

        /* Verifica se existe diferenáa entre o bem baixado por desmemb e o implantado por desmemb*/
        if  search("dop/dcoapi001.r") = ? and search("dop/dcoapi001.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "dop/dcoapi001.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "dop/dcoapi001.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run dop/dcoapi001.p (Input tt_desmembramento_bem_pat_api.ttv_dat_desmbrto,
                                   buffer b_bem_pat,
                                   Input table tt_verifica_diferenca_desmem) /*prg_fnc_bem_pat*/.
    end. /* do on error undo blk_desmembrar*/
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_baixa_bem_desmemb_incorp */
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: andrew
** Alterado em...........: 30/09/2014 16:12:39
*****************************************************************************/
PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_filename
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "."
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/.', substring(v_cod_1, v_num_1, 1)) = 0
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0
        then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_filename_validation */
/*****************************************************************************
** Procedure Interna.....: pi_system_dialog_get_file
** Descricao.............: pi_system_dialog_get_file
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 17/04/1995 13:51:55
*****************************************************************************/
PROCEDURE pi_system_dialog_get_file:

    system-dialog get-file v_nom_filename
        title v_nom_title
        filters v_nom_name[1]  v_des_filespec[1] ,
                v_nom_name[2]  v_des_filespec[2] ,
                v_nom_name[3]  v_des_filespec[3] ,
                v_nom_name[4]  v_des_filespec[4] ,
                v_nom_name[5]  v_des_filespec[5] ,
                v_nom_name[6]  v_des_filespec[6] ,
                v_nom_name[7]  v_des_filespec[7] ,
                v_nom_name[8]  v_des_filespec[8] ,
                v_nom_name[9]  v_des_filespec[9] ,
                v_nom_name[10] v_des_filespec[10]
        must-exist
        initial-dir v_nom_filename
        use-filename
        update v_log_answer.

END PROCEDURE. /* pi_system_dialog_get_file */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_print_editor
**  Descricao........: Imprime editores nos relat¢rios
*****************************************************************************/
PROCEDURE pi_print_editor:

    def input param p_stream    as char    no-undo.
    def input param p1_editor   as char    no-undo.
    def input param p1_pos      as char    no-undo.
    def input param p2_editor   as char    no-undo.
    def input param p2_pos      as char    no-undo.
    def input param p3_editor   as char    no-undo.
    def input param p3_pos      as char    no-undo.

    def var c_editor as char    extent 5             no-undo.
    def var l_first  as logical extent 5 initial yes no-undo.
    def var c_at     as char    extent 5             no-undo.
    def var i_pos    as integer extent 5             no-undo.
    def var i_len    as integer extent 5             no-undo.

    def var c_aux    as char               no-undo.
    def var i_aux    as integer            no-undo.
    def var c_ret    as char               no-undo.
    def var i_ind    as integer            no-undo.

    assign c_editor [1] = p1_editor
           c_at  [1]    =         substr(p1_pos,1,2)
           i_pos [1]    = integer(substr(p1_pos,3,3))
           i_len [1]    = integer(substr(p1_pos,6,3)) - 4
           c_editor [2] = p2_editor
           c_at  [2]    =         substr(p2_pos,1,2)
           i_pos [2]    = integer(substr(p2_pos,3,3))
           i_len [2]    = integer(substr(p2_pos,6,3)) - 4
           c_editor [3] = p3_editor
           c_at  [3]    =         substr(p3_pos,1,2)
           i_pos [3]    = integer(substr(p3_pos,3,3))
           i_len [3]    = integer(substr(p3_pos,6,3)) - 4
           c_ret        = chr(255) + chr(255).

    do while c_editor [1] <> "" or c_editor [2] <> "" or c_editor [3] <> "":
        do i_ind = 1 to 3:
            if c_editor[i_ind] <> "" then do:
                assign i_aux = index(c_editor[i_ind], chr(10)).
                if i_aux > i_len[i_ind] or (i_aux = 0 and length(c_editor[i_ind]) > i_len[i_ind]) then
                    assign i_aux = r-index(c_editor[i_ind], " ", i_len[i_ind] + 1).
                if i_aux = 0 then
                    assign c_aux = substr(c_editor[i_ind], 1, i_len[i_ind])
                           c_editor[i_ind] = substr(c_editor[i_ind], i_len[i_ind] + 1).
                else
                    assign c_aux = substr(c_editor[i_ind], 1, i_aux - 1)
                           c_editor[i_ind] = substr(c_editor[i_ind], i_aux + 1).
                if i_pos[1] = 0 then
                    assign entry(i_ind, c_ret, chr(255)) = c_aux.
                else
                    if l_first[i_ind] then
                        assign l_first[i_ind] = no.
                    else
                        case p_stream:
                            when "s_1" then
                                if c_at[i_ind] = "at" then
                                    put stream s_1 unformatted c_aux at i_pos[i_ind].
                                else
                                    put stream s_1 unformatted c_aux to i_pos[i_ind].
                        end.
            end.
        end.
        case p_stream:
        when "s_1" then
            put stream s_1 unformatted skip.
        end.
        if i_pos[1] = 0 then
            return c_ret.
    end.
    return c_ret.
END PROCEDURE.  /* pi_print_editor */

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message getStrTrans("Mensagem nr. ", "FAS") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "FAS") c_prg_msg getStrTrans("n∆o encontrado.", "FAS")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*************************  End of api_desmemb_bens *************************/
