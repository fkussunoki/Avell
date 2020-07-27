/********************* Temporary Table Definition Begin *********************/

def temp-table tt_acerto_val_bem_pis_cofins no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field ttv_val_calc_parc_pis            as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_cofins         as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_cofins_bxa     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_pis_bxa        as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_num_order                    as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_num_percent_desmbrto         as integer format ">>>>,>>9"
    .

def temp-table tt_acerto_val_pis_cofins_incorp no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field ttv_val_calc_parc_pis            as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_cofins         as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_cofins_bxa     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_calc_parc_pis_bxa        as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_num_order                    as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_num_percent_desmbrto         as integer format ">>>>,>>9"
    .

def temp-table tt_acum_calc_parc_pis_cofins no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field ttv_val_tot_parc_gerad_cofins    as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_parc_gerad_pis       as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_parc_cofins_incorp   as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_parc_pis_incorp      as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_cr_cofins            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    field ttv_val_sdo_cr_pis               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    field ttv_val_sdo_cr_cofins_incorp     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    field ttv_val_sdo_cr_pis_incorp        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    index tt_id                            is primary unique
          tta_num_id_bem_pat               ascending
          tta_num_seq_incorp_bem_pat       ascending
    .

def temp-table tt_acum_val_pis_cofins_incorp no-undo
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field ttv_val_tot_calc_parc_pis        as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_calc_parc_cofins     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_grav_pis             as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_grav_cofins          as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_pis_aux              as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_cofins_aux           as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_bxa_real_pis         as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_tot_bxa_real_cofins      as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    .

def temp-table tt_bem_pat_cong no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_grp_calc                 as character format "x(6)" label "Grupo C†lculo" column-label "Grupo C†lculo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field ttv_dat_movto                    as date format "99/99/9999" label "Data Movimento" column-label "Data Movimento"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_ind_tip_param                as character format "X(08)"
    .

def temp-table tt_calc_parc_pis_cofins no-undo
    field tta_num_id_calc_parc             as integer format "9999999999" initial 0 label "Id Calculo Parcela" column-label "Id Calculo Parcela"
    index tt_id                            is primary unique
          tta_num_id_calc_parc             ascending
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
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    .

def new global shared temp-table tt_desmembramento no-undo
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field ttv_val_custo                    as decimal format "->>>>>,>>>,>>9.99" decimals 2
    field ttv_val_dpr_cust_atrib           as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_val_perc_bxado               as decimal format "->>,>>>,>>>,>>9.9999999" decimals 7
    index tt_id                           
          tta_num_seq_incorp_bem_pat       ascending
    .

def new shared temp-table tt_desmembrto_bem_pat        
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(20)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_log_busca_orig               as logical format "Sim/N∆o" initial no label "Busca da Origem" column-label "Busca da Origem"
    index tt_desmembrto_bem_pat_id         is primary unique
          tta_cod_empresa                  ascending
          tta_cod_cta_pat                  ascending
          tta_num_bem_pat                  ascending
          tta_num_seq_bem_pat              ascending
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

def temp-table tt_incorp_bem_pat_calc_parc no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field tta_num_parc_pis_cofins          as integer format "999" initial 0 label "Nr Parcelas" column-label "Nr Parcelas"
    index tt_id                            is primary
          tta_num_id_bem_pat               ascending
          tta_num_seq_incorp_bem_pat       ascending
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

def temp-table tt_log_erros_modulo no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .


def temp-table tt_log_inconsist no-undo
    field ttv_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Ident Bem" column-label "Ident Bem"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_cod_finalid_econ             as character format "x(10)" label "Finalidade Econìmica" column-label "Finalidade Econìmica"
    field ttv_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field ttv_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem Pat"
    field ttv_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field ttv_num_seq_incorp_bem_pat       as integer format ">>>>,>>9" initial 0 label "Seq Incorp Bem" column-label "Seq Incorp Bem"
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_des_erro_bem_pat             as character format "x(200)"
    index tt_id                            is primary unique
          ttv_num_id_bem_pat               ascending
          ttv_num_seq_incorp_bem_pat       ascending
          ttv_cod_cenar_ctbl               ascending
          ttv_cod_finalid_econ             ascending
          ttv_num_erro                     ascending
          ttv_num_seq                      ascending
    index tt_num                          
          ttv_cod_cenar_ctbl               ascending
          ttv_cod_finalid_econ             ascending
          ttv_cod_cta_pat                  ascending
          ttv_num_bem_pat                  ascending
          ttv_num_seq_bem_pat              ascending
          ttv_num_seq_incorp_bem_pat       ascending
    .

def temp-table tt_row_errors no-undo
    field ttv_num_seq_erro                 as integer format ">>>>,>>9" initial 0
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending
    .

def temp-table tt_rpt_consist_bem_pat no-undo like bem_pat
    field ttv_rec_id_bem_pat               as recid format ">>>>>>9"
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


def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_ccusto_000
    as Character
    format "x(20)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(20)":U
    label "Centro Custo"
    column-label "Centro Custo"
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
    format "x(5)":U
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
def var v_cod_finalid_econ_pais
    as character
    format "x(8)":U
    no-undo.
def var v_cod_format_1
    as character
    format "x(8)":U
    no-undo.
def var v_cod_format_ccusto
    as character
    format "x(11)":U
    initial "x(11)" /*l_x(11)*/
    label "Formato CCusto"
    column-label "Formato CCusto"
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
def var v_cod_opcao
    as character
    format "x(30)":U
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
def var v_cod_plano_ccusto_old
    as character
    format "x(8)":U
    label "Plano CCusto Antigo"
    column-label "Plano Centros Custo"
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
def new shared var v_dat_desmbrto
    as date
    format "99/99/9999":U
    label "Data Desmbrto"
    column-label "Data Desmbrto"
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
def var v_dat_inic_validac
    as date
    format "99/99/9999":U
    initial today
    label "In°cio validaá∆o"
    column-label "In°cio validaá∆o"
    no-undo.
def var v_dat_inic_valid_unid_organ
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_return
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_des_filespec
    as character
    format "x(10)":U
    extent 10
    no-undo.
def var v_des_percent_complete
    as character
    format "x(06)":U
    no-undo.
def var v_des_percent_complete_fnd
    as character
    format "x(08)":U
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
def new shared var v_ind_message_output
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
def var v_log_cancel
    as logical
    format "Sim/N∆o"
    initial yes
    label "Cancelado"
    column-label "Cancelado"
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
def var v_log_funcao_congel_cenar_ctbl
    as logical
    format "Sim/N∆o"
    initial yes
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
def var v_log_plano_ccusto_val
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def var v_log_transf_ext
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_valid_calc_parc_bem
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_valid_calc_parc_incorp
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new shared var v_log_view_file
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Visualiza Arquivo"
    column-label "Visualiza Arquivo"
    no-undo.
def var v_nom_arq_log
    as character
    format "x(30)":U
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
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def new shared var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def new shared var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def new shared var v_nom_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
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
def var v_num_parc_desc
    as integer
    format "999":U
    label "Parc Descontadas"
    column-label "Parc Descontadas"
    no-undo.
def var v_num_parc_pis_cofins
    as integer
    format "999":U
    initial 0
    label "Nro Parcelas"
    column-label "Nro Parcelas"
    no-undo.
def var v_num_parc_pis_cofins_incorp
    as integer
    format "999":U
    initial 0
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_bem
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_bem_pat
    as integer
    format ">>>>9":U
    initial 0
    label "Sequància Bem"
    column-label "Sequància"
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
def var v_qtd_bem_pat_represen_ant
    as decimal
    format ">>>>>>>>9":U
    decimals 0
    label "Quantidade Bens Representados"
    column-label "Bem Represen"
    no-undo.
def var v_qtd_val_origin_desmbrto
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    initial 0
    no-undo.
def new global shared var v_rec_bem_pat
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_b_val_origin_bem_pat
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_cenar_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_cta_pat
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_indic_econ
    as recid
    format ">>>>>>9":U
    no-undo.
def var V_REC_LOG
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_ccusto
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_val_acum_origin
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_baixa
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_calc_parc_cofins_bxa
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_calc_parc_pis_bxa
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cr_cofins
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Valor CrÇdito COFINS"
    column-label "Credito COFINS"
    no-undo.
def var v_val_cr_cofins_bxa_ant
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cr_pis
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Valor CrÇdito PIS"
    column-label "Vl Cred PIS/PASEP"
    no-undo.
def var v_val_cr_pis_bxa_ant
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_current_value
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_despes_financ
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Valor Despesa Financ"
    column-label "Val Desp Fin"
    no-undo.
def var v_val_maior
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_maximum
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_original_ant
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
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
def var v_val_origin_aux
    as decimal
    format "->>>>>,>>>,>>9.9999999999":U
    decimals 10
    initial 0
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
def var v_val_parc_pag_cofins
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_parc_pag_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_perc_aplic_desmbrto
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 7
    no-undo.
def var v_val_perc_desmembr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 7
    no-undo.
def var v_val_perc_transf_ant
    as decimal
    format ">>9.99":U
    decimals 10
    label "Perc Transferido"
    column-label "Percentual Transf"
    no-undo.
def var v_val_sdo_cr_cofins
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_sdo_cr_cofins_incorp
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_sdo_cr_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_sdo_cr_pis_incorp
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_tot_bxa_real_cofins
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_bxa_real_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_calc_parc_cofins
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_calc_parc_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_cofins_aux
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_grav_cofins
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_grav_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_cofins_incorp
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_cofins
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_cofins_aux
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_cofins_bxa
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_pis
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_pis_aux
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_gerad_pis_bxa
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_parc_pis_incorp
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_perc_aux
    as decimal
    format ">>,>>>,>>>,>>9.9999999":U
    decimals 7
    no-undo.
def var v_val_tot_perc_dest
    as decimal
    format "->>,>>>,>>>,>>9.9999999":U
    decimals 7
    no-undo.
def var v_val_tot_pis_aux
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_cod_cenar_ctbl_fisc            as character       no-undo. /*local*/
def var v_cod_finalid_econ_bem_orig      as character       no-undo. /*local*/
def var v_cod_indic_econ_bem_orig        as character       no-undo. /*local*/
def var v_log_consist                    as logical         no-undo. /*local*/
def var v_log_param_calc_incorp          as logical         no-undo. /*local*/
def var v_log_param_difer                as logical         no-undo. /*local*/

def temp-table tt_trans_bem_aux no-undo
    field ttv_num_empresa                  as char    format 'x(3)' label 'Empresa' column-label 'Empresa'
    field ttv_cod_cta_pat                  as character format 'x(18)' label 'Conta Patrimonial' column-label 'Conta Patrimonial'
    field ttv_num_bem_pat                  as integer format '>>>>>>>>9' initial 0 label 'Bem Patrimonial' column-label 'Bem Pat'
    field ttv_num_seq_bem_pat              as integer format '>>>>9' initial 0 label 'Sequància Bem' column-label 'Sequància'
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_dat_trans                    as date format '99/99/9999' initial ?
    field ttv_ind_orig_calc_bem_pat        as character format 'X(20)' initial 'Aquisiá∆o' label 'Origem' column-label 'Origem'
    index tt_indice_trans_bem              is primary unique
          ttv_num_empresa                  ascending
          ttv_cod_cta_pat                  ascending
          ttv_num_bem_pat                  ascending
          ttv_num_seq_bem_pat              ascending.


DEF TEMP-TABLE b_bem_pat LIKE bem_pat.

ASSIGN v_dat_desmbrto = TODAY. //DEFINIR A DATA NA PASSAGEM DO PARAMETRO.


empty temp-table tt_desmembramento.


FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST EMSCAD.histor_exec_especial NO-LOCK
         WHERE histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.



    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */

assign v_dat_inic_period   = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
       v_dat_fim_period    = 12/31/9999
       v_dat_execution     = today
       v_hra_execution     = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/  ), ':', '').


/* Begin_Include: i_fnc_param_calc_incorp */
assign v_log_param_calc_incorp = no.

/* Begin_Include: i_declara_Verifica_Program_Name */
FUNCTION Verifica_Program_Name RETURN LOG (INPUT Programa AS CHAR, INPUT Repeticoes AS INT):
    DEF VAR v_num_cont  AS INTEGER NO-UNDO.
    DEF VAR v_log_achou AS LOGICAL NO-UNDO.


    /* Begin_Include: i_verifica_program_name */
    /* include feita para n∆o ocorrer problemas na utilizaá∆o do comando program-name */
    assign  v_num_cont  = 1
            v_log_achou = no.
    bloco:
    repeat:
        if index(program-name(v_num_cont),Programa) = ? then 
            leave bloco.
        if index(program-name(v_num_cont),Programa) <> 0 then do:
            assign v_log_achou = yes.
            leave bloco.
        end.
        if v_num_cont = Repeticoes then
            leave bloco.
        assign v_num_cont = v_num_cont + 1.
    end.
    /* End_Include: i_verifica_program_name */


    RETURN v_log_achou.
END FUNCTION.
/* End_Include: i_declara_Verifica_Program_Name */





/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.


assign v_log_funcao_congel_cenar_ctbl = no.


//CRIAR TEMP-TABLES TANTO PARA BEM A SER DESMONTADO QUANTO PARA BENS FILHOS.
//INTUITO ê PASSAR PARAMETROS EM TEMPO DE EXECUÄ«O, ITEM A ITEM 

/*****************************************************************************
** Procedure Interna.....: pi_bt_ok_bem_pat_desmembr
** Descricao.............: pi_bt_ok_bem_pat_desmembr
** Criado por............: bre17892
** Criado em.............: 17/11/1999 15:33:27
** Alterado por..........: log32668
** Alterado em...........: 02/03/2011 20:38:02
*****************************************************************************/
PROCEDURE pi_bt_ok_bem_pat_desmembr:

    /************************** Buffer Definition Begin *************************/

    def buffer b_aprop_parc_pis_cofins
        for aprop_parc_pis_cofins.
    def buffer b_bem_pat_aux
        for bem_pat.
    def buffer b_val_origin_bem_pat
        for val_origin_bem_pat.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cb1_calc_dat_term_carenc
        as Integer
        format ">>>>>>>9":U
        no-undo.
    def var v_cod_cenar_ctbl
        as character
        format "x(8)":U
        label "Cen†rio Cont†bil"
        column-label "Cen†rio Cont†bil"
        no-undo.
    def var v_cod_finalid
        as character
        format "x(20)":U
        label "Finalidade"
        column-label "Finalidade"
        no-undo.
    def var v_rec_val_origin_bem_pat
        as recid
        format ">>>>>>9":U
        initial ?
        no-undo.
    def var v_val_original
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        initial 0
        label "Valor Original"
        column-label "Valor Original"
        no-undo.


    /************************** Variable Definition End *************************/

    if not avail b_bem_pat then do:
        /* Bem deve ser informado ! */

        create tt_log_erros_modulo.
        assign tt_log_erros.ttv_num_seq             = 0 //definir controle
               tt_log_erros_modulo.ttv_num_cod_erro = 10446
               tt_log_erros_modulo.ttv_des_erro     = "Bem deve ser informado" 
               tt_log_erros_modulo.ttv_des_ajuda    = "Necessario informar um bem original".
    end.

    assign v_cod_cenar_ctbl   = ''
           v_cod_finalid_econ = ''
           v_val_original     = 0.

    run pi_validar_param_ctbz_cta_pat_desm(buffer b_bem_pat,
                                           Input v_dat_desmbrto,
                                           output v_cod_return).
    if  return-value <> "OK" /*l_ok*/  then do:
        /* ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado ! */
        create tt_log_erros_modulo.
        assign tt_log_erros.ttv_num_seq             = 0 //definir controle
               tt_log_erros_modulo.ttv_num_cod_erro = 1111
               tt_log_erros_modulo.ttv_des_erro     = "Parametro FAS" 
               tt_log_erros_modulo.ttv_des_ajuda    = "ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado".
    end. 

    /* --- Valida situaá∆o do m¢dulo ---*/
    RUN pi_retornar_sit_movimen_modul  (INPUT  'FAS' /* l_fas*/ ,
                                        INPUT  v_cod_empres_usuar,
                                        INPUT  v_dat_desmbrto,
                                        INPUT  'Habilitado' /* l_habilitado*/ ,
                                        OUTPUT v_cod_return).
    if not can-do(v_cod_return,'Habilitado' /* l_habilitado*/  ) then do:
        if  v_ind_message_output = 'Na Tela' /* l_on_screen*/ 
        then do:
            create tt_log_erros_modulo.
            assign tt_log_erros.ttv_num_seq             = 0 //definir controle
                   tt_log_erros_modulo.ttv_num_cod_erro = 4153
                   tt_log_erros_modulo.ttv_des_erro     = "Periodo nao habilitado" 
                   tt_log_erros_modulo.ttv_des_ajuda    = "Verifique no programa Exercicio contabil ocorrencia de habilitaáao do periodo".
        END /* END.*/ .
    end.
    for each tt_desmembrto_bem_pat.
        blk_param:
        for each param_calc_cta
            where param_calc_cta.cod_empresa = tt_desmembrto_bem_pat.tta_cod_empresa
            and   param_calc_cta.cod_cta_pat = tt_desmembrto_bem_pat.tta_cod_cta_pat
            and   param_calc_cta.cod_tip_calc  <> '' no-lock:

            find finalid_econ
                where finalid_econ.cod_finalid_econ = param_calc_cta.cod_finalid_econ no-lock no-error.
            if  avail finalid_econ 
            and finalid_econ.ind_armaz_val = "Ativo Fixo" /*l_ativo_fixo*/  then
                next blk_param.

            find first param_ctbz_cta_pat no-lock
                where param_ctbz_cta_pat.cod_empresa      = param_calc_cta.cod_empresa
                and   param_ctbz_cta_pat.cod_cta_pat      = param_calc_cta.cod_cta_pat
                and   param_ctbz_cta_pat.cod_cenar_ctbl   = param_calc_cta.cod_cenar_ctbl
                and   param_ctbz_cta_pat.cod_finalid_econ = param_calc_cta.cod_finalid_econ
                and   param_ctbz_cta_pat.ind_finalid_ctbl = "Desmembramento" /*l_desmembramento*/ 
                and   param_ctbz_cta_pat.dat_inic_valid  <= v_dat_desmbrto
                and   param_ctbz_cta_pat.dat_fim_valid   >= v_dat_desmbrto no-error.
            if  not avail param_ctbz_cta_pat then do:
                create tt_log_erros_modulo.
                assign tt_log_erros.ttv_num_seq             = 0 //definir controle
                       tt_log_erros_modulo.ttv_num_cod_erro = 1111
                       tt_log_erros_modulo.ttv_des_erro     = "Parametro FAS" 
                       tt_log_erros_modulo.ttv_des_ajuda    = "ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado".
            end.
        end.    
    end.

    find utiliz_cenar_ctbl no-lock
         where utiliz_cenar_ctbl.cod_empresa    = b_bem_pat.cod_empresa
           and utiliz_cenar_ctbl.log_cenar_fisc = yes no-error.

    if avail utiliz_cenar_ctbl
       then assign v_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_indic_econ          = b_bem_pat.cod_indic_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= v_dat_desmbrto
           and histor_finalid_econ.dat_fim_valid_finalid   > v_dat_desmbrto no-error.
    if avail histor_finalid_econ
       then assign v_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.

    find last b_val_origin_bem_pat no-lock
         where b_val_origin_bem_pat.num_id_bem_pat         = b_bem_pat.num_id_bem_pat
           and b_val_origin_bem_pat.num_seq_incorp_bem_pat = 0
           and b_val_origin_bem_pat.cod_cenar_ctbl         = v_cod_cenar_ctbl
           and b_val_origin_bem_pat.cod_finalid_econ       = v_cod_finalid_econ no-error.

    if avail b_val_origin_bem_pat 
       then assign v_val_original = b_val_origin_bem_pat.val_original.
       else assign v_val_original = b_bem_pat.val_original.

    run pi_tratar_pis_cofins_desmembramento (input v_val_original) /*pi_tratar_pis_cofins_desmembramento*/.
    if return-value = "NOK" /*l_nok*/  then return "NOK" /*l_nok*/ .

    return 'OK'.
END PROCEDURE. /* pi_bt_ok_bem_pat_desmembr */


/* End_Include: i_declara_SetEntryField */


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
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

