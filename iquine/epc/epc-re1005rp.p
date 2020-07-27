/*******************************************************************************
**  Cliente  : Tintas Iquine
**  Sistema  : TOTVS 12
**  Programa : upc_re1005rp
**  Objetivo : Gerar Titulos de Devolucao no ACR
**  Data     : 03/2020
**  Autor    : Flavio Kussunoki
**  Versao   : 5.06.000
*******************************************************************************/
define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

def new shared temp-table tt_integr_acr_abat_antecip no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending.


def new shared temp-table tt_integr_acr_abat_prev no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/N’o" initial no label "Zera Saldo" column-label "Zera Saldo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending.


def new shared temp-table tt_integr_acr_aprop_ctbl_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_log_impto_val_agreg          as logical format "Sim/N’o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_cta_ctbl_ext             ascending
          tta_cod_sub_cta_ctbl_ext         ascending
          tta_cod_unid_negoc               ascending
          tta_cod_unid_negoc_ext           ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_ccusto_ext               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_log_impto_val_agreg          ascending.

def new shared temp-table tt_integr_acr_aprop_desp_rec no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria»’o" column-label "Tipo Apropria»’o"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_cta_ctbl_ext             ascending
          tta_cod_sub_cta_ctbl_ext         ascending
          tta_cod_unid_negoc_ext           ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_ind_tip_aprop_recta_despes   ascending
          tta_cod_tip_abat                 ascending.

def new shared temp-table tt_integr_acr_aprop_liq_antec no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T­tulo" column-label "Unid Negoc T­tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido".



def new shared temp-table tt_integr_acr_aprop_relacto no-undo
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ?
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl".



def new shared temp-table tt_integr_acr_cheq no-undo
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss’o" column-label "Dt Emiss"
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep½sito" column-label "Dep½sito"
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs’o Dep½sito" column-label "Previs’o Dep½sito"
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu»’o" column-label "Motivo Devolu»’o"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usuÿrio" column-label "Usuÿrio"
    field tta_log_pend_cheq_acr            as logical format "Sim/N’o" initial no label "Cheque Pendente" column-label "Cheque Pendente"
    field tta_log_cheq_terc                as logical format "Sim/N’o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N’o" initial no label "Cheque Reneg" column-label "Cheque Reneg"
    field tta_log_cheq_acr_devolv          as logical format "Sim/N’o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    index tt_id                            is primary unique
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending.


def new shared temp-table tt_integr_acr_impto_impl_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tributÿvel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Al­quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»’o" column-label "Cota»’o"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota»’o" column-label "Data Cota»’o"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_pais                     ascending
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending.

def new shared temp-table tt_integr_acr_item_lote_impl no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»’o Cobran»a" column-label "Cond Cobran»a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»’o" column-label "Prev Liquida»’o"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 INITIAL 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 INITIAL 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Bancÿria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Bancÿria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi»’o Pagamento" column-label "Condi»’o Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag¼ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
    field tta_log_liquidac_autom           as logical format "Sim/N’o" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo Cart’o" column-label "C½digo Cart’o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart’o" column-label "Validade Cart’o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½d Pr²-Autoriza»’o" column-label "C½d Pr²-Autoriza»’o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concessionÿria" column-label "Concessionÿria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N’o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/N’o" initial no label "D²bito Automÿtico" column-label "D²bito Automÿtico"
    field tta_log_destinac_cobr            as logical format "Sim/N’o" initial no label "Destin Cobran»a" column-label "Destin Cobran»a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Bancÿria" column-label "Sit Bancÿria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending.


def temp-table tt_integr_acr_item_lote_impl_9 no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»’o Cobran»a" column-label "Cond Cobran»a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»’o" column-label "Prev Liquida»’o"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Bancÿria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Bancÿria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi»’o Pagamento" column-label "Condi»’o Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag¼ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
    field tta_log_liquidac_autom           as logical format "Sim/N’o" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo Cart’o" column-label "C½digo Cart’o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart’o" column-label "Validade Cart’o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½d Pr²-Autoriza»’o" column-label "C½d Pr²-Autoriza»’o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concessionÿria" column-label "Concessionÿria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N’o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/N’o" initial no label "D²bito Automÿtico" column-label "D²bito Automÿtico"
    field tta_log_destinac_cobr            as logical format "Sim/N’o" initial no label "Destin Cobran»a" column-label "Destin Cobran»a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Bancÿria" column-label "Sit Bancÿria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»’o" column-label "Cota»’o"
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo Cÿlculo Juros" column-label "Tipo Cÿlculo Juros"
    field ttv_cod_comprov_vda_aux          as character format "x(12)"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_cod_autoriz_bco_emissor      as character format "x(6)" label "Codigo Autoriza»’o" column-label "Codigo Autoriza»’o"
    field ttv_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    field ttv_cod_estab_vendor             as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi»’o Pagto" column-label "Condi»’o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N’o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N’o" initial no
    field ttv_cod_estab_portad             as character format "x(8)"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta»’o" column-label "Processo Exporta»’o"
    field ttv_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito PIS" column-label "Vl Cred PIS/PASEP"
    field ttv_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito COFINS" column-label "Credito COFINS"
    field ttv_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito CSLL" column-label "Credito CSLL"
    field tta_cod_indic_econ_desemb        as character format "x(8)" label "Moeda Desembolso" column-label "Moeda Desembolso"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N’o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field ttv_cod_nota_fisc_faturam        as character format "x(16)"
    field tta_cod_band                     as character format "x(10)" label "Bandeira" column-label "Bandeira"
    field tta_cod_tid                      as character format "x(10)" label "TID" column-label "TID"
    field tta_cod_terminal                 as character format "x(8)" label "Nr Terminal" column-label "Nr Terminal"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending.


def new shared temp-table tt_integr_acr_lote_impl no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C½digo Empresa Ext" column-label "C½d Emp Ext"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_ind_orig_tit_acr             as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec"
    field tta_val_tot_lote_impl_tit_acr    as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Total Movimento"
    field tta_val_tot_lote_infor_tit_acr   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran»a" column-label "Tipo Cobran»a"
    field ttv_log_lote_impl_ok             as logical format "Sim/N’o" initial no
    field tta_log_liquidac_autom           as logical format "Sim/N’o" initial no label "Liquidac Automÿtica" column-label "Liquidac Automÿtica"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_refer                    ascending.


def new shared temp-table tt_integr_acr_ped_vda_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_val_origin_ped_vda           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ped Venda" column-label "Original Ped Venda"
    field tta_val_sdo_ped_vda              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Pedido Venda" column-label "Saldo Pedido Venda"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_ped_vda                  ascending.




def new shared temp-table tt_integr_acr_relacto_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab_tit_acr_pai        as character format "x(5)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field ttv_cod_estab_tit_acr_pai_ext    as character format "x(5)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field tta_num_id_tit_acr_pai           as integer format "9999999999" initial 0 label "Token" column-label "Token"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_relacto_tit_acr          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Relacto" column-label "Vl Relacto"
    field tta_log_gera_alter_val           as logical format "Sim/N’o" initial no label "Gera Alter Valor" column-label "Gera Alter Valor"
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera»’o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor".


def new shared temp-table tt_integr_acr_relacto_pend_cheq no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Bancÿria" column-label "Ag¼ncia Bancÿria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Salÿrio" column-label "Banco Cheque Salÿrio"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending.


def new shared temp-table tt_integr_acr_repres_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi½n" column-label "% Comisi½n"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Emisi½n" column-label "% Comis Emisi½n"
    field tta_val_perc_comis_abat          as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi½n Rebaja" column-label "% Comisi½n Rebaja"
    field tta_val_perc_comis_desc          as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi½n Desct" column-label "% Comisi½n Desct"
    field tta_val_perc_comis_juros         as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Inter" column-label "% Comis Inter"
    field tta_val_perc_comis_multa         as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "S­/No" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comisi½n" column-label "Tipo Comisi½n"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cdn_repres                   ascending.

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer?ncia" column-label "Refer?ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ?ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist?ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".


def temp-table tt_nota_devol_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_ser_nota_devol           as character format "x(5)" label "S‚rie Nota Devol" column-label "S‚rei Dev"
    field tta_cod_nota_devol               as character format "x(16)" label "Nr. Nota Devolu‡Æo" column-label "Nota Dev"
    field tta_cod_natur_operac_devol       as character format "x(6)" label "Natureza Opera‡Æo" column-label "Nat Opera‡Æo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    index tt_id1                           is primary
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    index tt_id2                          
          tta_cdn_cliente                  ascending
          tta_cod_ser_nota_devol           ascending
          tta_cod_nota_devol               ascending
          tta_cod_natur_operac_devol       ascending
    .


def temp-table tt_integr_acr_repres_comis_2 no-undo
     field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
     field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
     field tta_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo Comis Externo" column-label "Tipo Comis Externo"
     field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto Comis" column-label "Lib Comis"
     field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext".

def temp-table tt_integr_acr_aprop_relacto_2b no-undo
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ? label "TK Relac Tit" column-label "TK Relac Tit"
    field ttv_rec_aprop_relacto            as recid format ">>>>>>9"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo".


Def new shared temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending.


def new shared temp-table tt_integr_acr_relacto_pend_aux no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_nota_vincul              as logical format "Sim/NÊo" initial yes

    .


def temp-table tt-tot-tit
    field referencia         as character format 'x(10)'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ep-codigo          as integer   format '>>9'
    &ELSE
    field ep-codigo          as char      format 'x(3)'
    &ENDIF
    field cod-empresa        as character format 'x(3)'
    field cod-estabel        as character format 'x(3)'
    field cod-estab-ems5     as character format 'x(3)'
    field cod-esp            as character format '!!'
    field serie              as character format 'x(5)'
    field nr-docto           as character format 'x(16)'
    field cod-emitente       as integer   format '>>>>>9'
    field tot-saldo          as decimal   format '>>>>>>>,>>9.99'
    field tot-baixa          as decimal   format '>>>>>>>,>>9.99'
    field mo-codigo          as integer   format '>9'
    field cotacao-dia        as decimal   format '>>>,>9.99999999'
    field dt-trans           as date      format '99/99/9999'
    field nr-docto-cr        as character format 'x(16)'
    field serie-cr           as character format 'x(5)'
    field cod-esp-cr         as character format '!!' 
    &if defined(BF_FIN_UNIFIC_CADASTROS) &then
    field cod-tip-fluxo-financ as char format 'x(12)'
    &else
    field tp-codigo          as integer   format '>>9'
    &endif
    field estorn-comis       as logical   format 'Sim/N’o' /* l_sim_nao*/ 
    field sequencia          as integer
    field conta-devol        as character format 'x(17)'
    field erro               as logical   format 'Sim/N’o' /* l_sim_nao*/ 
    field serie-nota         as character format 'x(5)'
    field nr-docto-nota      as character format 'x(16)'
    field nat-operacao       as character format 'x(6)'
    field cod-plano-ccusto   as character format 'x(8)'
    field cod-ccusto         as character format 'x(20)'
    field cod-plano-cta-ctbl as character format 'x(8)'
    index seq            is primary unique
          sequencia
    index titulo
          serie
          nr-docto
          conta-devol
          cod-ccusto.

DEFINE TEMP-TABLE tt-tit-acr-dev
    FIELD cod-estab-ems5  AS CHAR
    field cod-esp         AS CHAR
    field serie           AS CHAR
    field nr-docto        AS CHAR
    field parcela         AS CHAR
    field cod-emitente    AS INTEGER
    field cod-esp-cr      AS CHAR
    FIELD sdo-tit-acr     AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99"
    FIELD sdo-aplicar     AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99"
    FIELD nota-fiscal     AS CHARACTER
    FIELD serie-nota      AS CHARACTER
    FIELD nat-operacao    AS CHARACTER
    FIELD cod-estab-ems2  AS CHARACTER.
/*                                                                           */
/* DEFINE TEMP-TABLE ext-docum-est-dev                                       */
/*     FIELD nota-fiscal     AS CHARACTER                                    */
/*     FIELD serie-nota      AS CHARACTER                                    */
/*     FIELD nat-operacao    AS CHARACTER                                    */
/*     FIELD cod-estab-ems2  AS CHARACTER                                    */
/*     field cod-emitente    AS INTEGER                                      */
/*     FIELD v-vlr-nota      AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99"  */
/*     FIELD sequencia       AS INTEGER.                                     */
DEFINE VAR i-sequencia AS INTEGER.
DEFINE VAR i-controle-interno AS INTEGER NO-UNDO.
DEFINE VAR l_unica     AS LOGICAL INITIAL FALSE.
DEFINE VAR v_refer_unica AS char.
DEFINE VAR v_cod_refer   AS char.
DEFINE VAR v_hdl_api_integr_acr AS HANDLE NO-UNDO.
DEFINE VAR v_parcela     AS char.
DEFINE VAR v_compare     AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99".
DEFINE VAR i-SEQ             AS INTEGER INITIAL 1.
DEFINE VAR l-parcela-unica AS LOGICAL INITIAL FALSE.
DEFINE VAR contra-prova   AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99".
DEFINE VAR contra-prova1  AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>9.99".
DEFINE VAR ctr-parcelas   AS char FORMAT "x(2000)".
DEFINE VAR v_log_refer_unica AS LOGICAL INITIAL NO.
DEFINE VAR PARCELA_UNICA AS LOGICAL INITIAL NO.


DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt_epc.

IF p-ind-event = "apos-finalizar" THEN DO:


    
        EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
    
        EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl.
    
        empty TEMP-TABLE tt_integr_acr_item_lote_impl_9.
    
        empty TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.
    
        empty TEMP-TABLE tt_integr_acr_repres_pend.
    
        EMPTY TEMP-TABLE tt_nota_devol_tit_acr.
    
        EMPTY TEMP-TABLE tt_integr_acr_relacto_pend.


/*         OUTPUT TO c:\temp\ext-tit-acr.txt.       */
/*         FOR EACH ext-tit-acr-dev:                */
/*             EXPORT ext-tit-acr-dev.              */
/*         END.                                     */
/*                                                  */
/*                                                  */
/*         OUTPUT CLOSE.                            */
/*                                                  */
/*                                                  */
/*         OUTPUT TO c:\temp\ext-docum-est-dev.txt. */
/*                                                  */
/*         FOR EACH ext-docum-est-dev:              */
/*             EXPORT ext-docum-est-dev.            */
/*         END.                                     */
/*                                                  */
/*         OUTPUT CLOSE.                            */

        FIND FIRST ext-tit-acr-dev NO-ERROR.
        if avail ext-tit-acr-dev then do:
            repeat while v_log_refer_unica = no:
                run pi_retorna_sugestao_referencia (Input "T" /*l_t*/,
                                                    Input today,
                                                    output v_cod_refer) /*pi_retorna_sugestao_referencia*/.

                run pi_verifica_refer_unica_ACR (Input EXT-TIT-ACR-DEV.COD-ESTAB-EMS5,
                                                Input v_cod_refer,
                                                Input '',
                                                Input ?,
                                                output v_log_refer_unica) /*pi_verifica_refer_unica_apb*/.
            end.

        FIND FIRST EMSBAS.ESTABELECIMENTO NO-LOCK WHERE EMSBAS.ESTABELECIMENTO.cod_estab = ext-tit-acr-dev.cod-estab-ems5 NO-ERROR.

        FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = emsbas.estabelecimento.cod_estab
                                     NO-ERROR.

        create tt_integr_acr_lote_impl.
        assign tt_integr_acr_lote_impl.tta_cod_empresa                = STRING(EMSBAS.ESTABELECIMENTO.cod_empresa)
               tt_integr_acr_lote_impl.tta_cod_estab                  = EXT-TIT-ACR-DEV.cod-estab-ems5
               tt_integr_acr_lote_impl.tta_cod_estab_ext              = EXT-TIT-ACR-DEV.cod-estab-ems5
               tt_integr_acr_lote_impl.tta_cod_refer                  = v_cod_refer
               tt_integr_acr_lote_impl.tta_cod_indic_econ             = 'REAL'
               tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext       = '0'
               tt_integr_acr_lote_impl.tta_cod_espec_docto            = ""
               tt_integr_acr_lote_impl.tta_dat_transacao              = ext-tit-acr-dev.dt-transacao
               tt_integr_acr_lote_impl.tta_ind_tip_espec_docto        = ""
               tt_integr_acr_lote_impl.tta_ind_orig_tit_acr           = "REC" /*l_rec*/
               tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr           = "Normal" /*l_normal*/
               tt_integr_acr_lote_impl.tta_log_liquidac_autom         = no.


        RUN pi-verifica-1.
        RUN pi-verifica-2.
        RUN pi-efetivar.
        end.
/*         OUTPUT TO c:\temp\pamap.txt.             */
/*                                                  */
/*         FOR EACH tt_integr_acr_item_lote_impl:   */
/*             EXPORT tt_integr_acr_item_lote_impl. */
/*         END.                                     */
/*                                                  */
/*         OUTPUT CLOSE.                            */

END.
PROCEDURE pi-verifica-1:

        FOR EACH ext-tit-acr-dev WHERE ext-tit-acr-dev.log-atualizado = NO
                                 AND   ext-tit-acr-dev.sdo-aplicar    > 0
                                 BREAK BY EXT-TIT-ACR-DEV.cod-estab-ems5 
                                       BY ext-tit-acr-dev.cod-esp        
                                       BY ext-tit-acr-dev.serie          
                                       BY ext-tit-acr-dev.nr-docto:       

    
            ACCUMULATE ext-tit-acr-dev.sdo-aplicar (SUB-TOTAL BY ext-tit-acr-dev.nr-docto).
    
            IF LAST-OF(EXT-TIT-ACR-DEV.nr-docto) THEN DO:

                FIND FIRST EMSBAS.ESTABELECIMENTO NO-LOCK WHERE EMSBAS.ESTABELECIMENTO.cod_estab = ext-tit-acr-dev.cod-estab-ems5 NO-ERROR.

                IF (ACCUM SUB-TOTAL BY EXT-TIT-ACR-DEV.nr-docto ext-tit-acr-dev.sdo-aplicar) > 0  THEN  DO:
                    


                    RUN pi-devolucao (INPUT ACCUM SUB-TOTAL BY EXT-TIT-ACR-DEV.nr-docto ext-tit-acr-dev.sdo-aplicar).

                END.
            END.
        END.
END PROCEDURE.

PROCEDURE pi-verifica-2:
        FOR EACH ext-tit-acr-dev 
                                 BREAK BY EXT-TIT-ACR-DEV.cod-estab-ems5 
                                       BY ext-tit-acr-dev.cod-esp        
                                       BY ext-tit-acr-dev.serie          
                                       BY ext-tit-acr-dev.nr-docto:       
                
            FIND FIRST ext-docum-est-dev NO-LOCK WHERE ext-docum-est-dev.nota-fiscal = ext-tit-acr-dev.nota-fiscal
                                                     AND   ext-docum-est-dev.serie-nota   = ext-tit-acr-dev.serie-nota
                                                     AND   ext-docum-est-dev.cod-emitente = ext-tit-acr-dev.cod-emitente
                                                      NO-ERROR.
        


            ACCUMULATE ext-tit-acr-dev.sdo-aplicar (SUB-TOTAL BY ext-tit-acr-dev.nr-docto).
    
            IF LAST-OF(EXT-TIT-ACR-DEV.nr-docto) THEN DO:

    
                    IF  ext-docum-est-dev.v-vlr-nota > (ext-docum-est-dev.v-vlr-nota - ACCUM SUB-TOTAL BY EXT-TIT-ACR-DEV.nr-docto ext-tit-acr-dev.sdo-aplicar)
                    OR  ext-docum-est-dev.v-vlr-nota > (ACCUM SUB-TOTAL BY EXT-TIT-ACR-DEV.nr-docto ext-tit-acr-dev.sdo-aplicar)  THEN
                        RUN pi-antecipacao (INPUT ext-docum-est-dev.v-vlr-nota). //- ACCUM SUB-TOTAL BY EXT-TIT-ACR-DEV.nr-docto ext-tit-acr-dev.sdo-aplicar).
          END.
        END.
    
END PROCEDURE.




PROCEDURE pi-antecipacao:
    DEFINE INPUT PARAM v-vlr-antecipa AS DECIMAL.
           
                FIND FIRST EMSBAS.ESTABELECIMENTO NO-LOCK WHERE EMSBAS.ESTABELECIMENTO.cod_estab = ext-tit-acr-dev.cod-estab-ems5 NO-ERROR.

                FIND FIRST  tt_integr_acr_lote_impl NO-ERROR.
                ASSIGN tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr  = tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr +   ext-docum-est-dev.v-vlr-nota
                       tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr = tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr +  ext-docum-est-dev.v-vlr-nota.




           ASSIGN v_parcela    = "10".


           FOR EACH ext-tit-acr-dev WHERE ext-tit-acr-dev.sdo-aplicar = 0
                                     /* AND   ext-tit-acr-dev.log-atualizado = NO */
                                     :


                        ASSIGN parcela_unica = NO.

             REPEAT WHILE PARCELA_UNICA = NO:

                FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_estab       = ext-tit-acr-dev.cod-estab-ems5
                                           AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp-cr
                                           AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                           AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                           AND   tit_acr.cod_parcela     = V_PARCELA
                                           NO-ERROR.

                IF AVAIL tit_acr THEN DO:

                    ASSIGN V_PARCELA = STRING(INT(V_PARCELA) + 1)
                           PARCELA_UNICA = NO.


                END.

                IF NOT AVAIL tit_acr THEN DO:

                    ASSIGN 
                           ext-tit-acr-dev.ctr-parcela = v_parcela
                           V_PARCELA = STRING(INT(V_PARCELA) + 1)
                           PARCELA_UNICA = YES.

                END.
             END.
           END.

                
            FIND FIRST ext-tit-acr-dev WHERE ext-tit-acr-dev.sdo-aplicar = 0  NO-ERROR.
                                       /* AND   ext-tit-acr-dev.log-atualizado = NO NO-ERROR. */
                            FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_estab       = ext-tit-acr-dev.cod-estab-ems5
                                           AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                           AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                           AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                           AND   tit_acr.cod_parcela     = ext-tit-acr-dev.parcela
                                           AND   tit_acr.cdn_cliente     = ext-tit-acr-dev.cod-emitente
                                           AND   tit_acr.ind_sit_tit_acr = 'Devolu‡Æo' NO-ERROR.

                IF AVAILABLE tit_acr THEN DO:
                   
                        ASSIGN ext-tit-acr-dev.log-atualizado = YES.

                    FIND FIRST espec_docto_financ_acr NO-LOCK WHERE espec_docto_financ_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp-cr NO-ERROR.

                    FIND FIRST emsbas.espec_docto NO-LOCK WHERE emsbas.espec_docto.cod_espec_docto = espec_docto_financ_acr.cod_espec_docto NO-ERROR.



                    FIND LAST tit_acr NO-LOCK USE-INDEX titacr_id WHERE tit_acr.cod_estab = ext-tit-acr-dev.cod-estab-ems5
                                                                  AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                                                  AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                                                  AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                                                  NO-ERROR.

                    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = ext-docum-est-dev.cod-estab-ems2
                                                 NO-ERROR.


                    create tt_integr_acr_item_lote_impl.
                    assign tt_integr_acr_item_lote_impl.ttv_rec_lote_impl_tit_acr      = recid(tt_integr_acr_lote_impl)
                           tt_integr_acr_item_lote_impl.tta_num_seq_refer              = I-SEQ
                           tt_integr_acr_item_lote_impl.tta_cdn_cliente                = ext-tit-acr-dev.cod-emitente
                           tt_integr_acr_item_lote_impl.tta_cod_espec_docto            = ext-tit-acr-dev.cod-esp-cr
                           tt_integr_acr_item_lote_impl.tta_cod_ser_docto              = ext-tit-acr-dev.serie
                           tt_integr_acr_item_lote_impl.tta_cod_tit_acr                = ext-tit-acr-dev.nr-docto
                           tt_integr_acr_item_lote_impl.tta_cod_parcela                = string(ext-tit-acr-dev.ctr-parcela)
                           tt_integr_acr_item_lote_impl.tta_cod_portador               = ""
                           tt_integr_acr_item_lote_impl.tta_cod_portad_ext             = "" /*l_*/
                           tt_integr_acr_item_lote_impl.tta_cod_cart_bcia              = ""
                           tt_integr_acr_item_lote_impl.tta_cod_modalid_ext            = "" /*l_*/
                           tt_integr_acr_item_lote_impl.tta_cod_cond_cobr              = "" /*l_*/
                           tt_integr_acr_item_lote_impl.tta_cod_motiv_movto_tit_acr    = "" /*l_*/
                           tt_integr_acr_item_lote_impl.tta_cod_histor_padr            = "" /*l_*/
                           tt_integr_acr_item_lote_impl.tta_cdn_repres                 = 0
                           tt_integr_acr_item_lote_impl.tta_dat_vencto_tit_acr         = ext-tit-acr-dev.dt-transacao
                           tt_integr_acr_item_lote_impl.tta_dat_prev_liquidac          = ext-tit-acr-dev.dt-transacao
                           tt_integr_acr_item_lote_impl.tta_dat_emis_docto             = ext-tit-acr-dev.dt-transacao
                           .
                    assign tt_integr_acr_item_lote_impl.tta_des_text_histor            ="Integra‡Æo Recebimento com Contas a Receber EMS 5.0 - Devolu‡Æo de Mercadorias" + chr(10) +
                           "NF: " + ext-tit-acr-dev.nota-fiscal + " Serie " + ext-tit-acr-dev.serie-nota + " Nat.OPer " + ext-tit-acr-dev.nat-operacao + CHR(10)
                           tt_integr_acr_item_lote_impl.tta_val_liq_tit_acr            = v-vlr-antecipa
                           tt_integr_acr_item_lote_impl.tta_val_tit_acr                = v-vlr-antecipa
                           tt_integr_acr_item_lote_impl.tta_ind_tip_espec_docto        = emsbas.espec_docto.ind_tip_espec_docto
                           tt_integr_acr_item_lote_impl.tta_ind_sit_tit_acr            = "Normal" /*l_normal*/
                           tt_integr_acr_item_lote_impl.tta_log_liquidac_autom         = no
                           tt_integr_acr_item_lote_impl.tta_num_id_tit_acr             = ?
                           tt_integr_acr_item_lote_impl.tta_num_id_movto_tit_acr       = ?
                           tt_integr_acr_item_lote_impl.tta_cod_refer                  = v_refer_unica
                           tt_integr_acr_item_lote_impl.tta_cod_indic_econ             = 'REAL'
                           tt_integr_acr_item_lote_impl.tta_cod_finalid_econ_ext       = '0'.


                    FIND LAST tit_acr NO-LOCK USE-INDEX titacr_id WHERE tit_acr.cod_estab = ext-tit-acr-dev.cod-estab-ems5
                                                                  AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                                                  AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                                                  AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                                                  AND   tit_acr.cod_parcela     = ext-tit-acr-dev.parcela
                                                                  NO-ERROR.

                        FIND FIRST val_tit_acr NO-LOCK WHERE val_tit_acr.cod_estab = tit_acr.cod_estab
                                                       AND   val_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.

                    CREATE tt_integr_acr_relacto_pend.
                    ASSIGN tt_integr_acr_relacto_pend.ttv_rec_item_lote_impl_tit_acr   = RECID(tt_integr_acr_item_lote_impl)
                           tt_integr_acr_relacto_pend.tta_cod_estab_tit_acr_pai        = ext-tit-acr-dev.cod-estab-ems5
                           tt_integr_acr_relacto_pend.ttv_cod_estab_tit_acr_pai_ext    = ext-tit-acr-dev.cod-estab-ems5
                           tt_integr_acr_relacto_pend.tta_num_id_tit_acr_pai           = tit_acr.num_id_tit_acr
                           tt_integr_acr_relacto_pend.tta_cod_espec_docto              = ext-tit-acr-dev.cod-esp
                           tt_integr_acr_relacto_pend.tta_cod_ser_docto                = ext-tit-acr-dev.serie
                           tt_integr_acr_relacto_pend.tta_cod_tit_acr                  = ext-tit-acr-dev.nr-docto
                           tt_integr_acr_relacto_pend.tta_cod_parcela                  = string(ext-tit-acr-dev.ctr-parcela)
                           tt_integr_acr_relacto_pend.tta_val_relacto_tit_acr          = v-vlr-antecipa.




                   create tt_nota_devol_tit_acr.
                   assign tt_nota_devol_tit_acr.tta_cod_estab              = tt_integr_acr_lote_impl.tta_cod_estab
                          tt_nota_devol_tit_acr.tta_cod_espec_docto        = tt_integr_acr_item_lote_impl.tta_cod_espec_docto
                          tt_nota_devol_tit_acr.tta_cod_ser_docto          = tt_integr_acr_item_lote_impl.tta_cod_ser_docto
                          tt_nota_devol_tit_acr.tta_cod_tit_acr            = tt_integr_acr_item_lote_impl.tta_cod_tit_acr
                          tt_nota_devol_tit_acr.tta_cod_parcela            = tt_integr_acr_item_lote_impl.tta_cod_parcela
                          tt_nota_devol_tit_acr.tta_cdn_cliente            = ext-tit-acr-dev.cod-emitente
                          tt_nota_devol_tit_acr.tta_cod_ser_nota_devol     = ext-tit-acr-dev.serie-nota
                          tt_nota_devol_tit_acr.tta_cod_nota_devol         = ext-tit-acr-dev.nota-fiscal
                          tt_nota_devol_tit_acr.tta_cod_natur_operac_devol = ext-tit-acr-dev.nat-operacao
                          tt_nota_devol_tit_acr.tta_dat_emis_docto         = tt_integr_acr_item_lote_impl.tta_dat_emis_docto.


                    FIND LAST plano_cta_ctbl NO-LOCK WHERE plano_cta_ctbl.dat_fim_valid >= TODAY
                                                     AND   plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Prim rio" NO-ERROR.



                    ASSIGN ext-tit-acr-dev.sdo-aplicar     = 0 
                           ext-tit-acr-dev.log-atualizado  = YES. 



                ASSIGN I-SEQ = I-SEQ + 10.

                END.
            

END PROCEDURE.
    
PROCEDURE pi-devolucao:

    DEFINE INPUT PARAM v_total AS DECIMAL.


          FIND FIRST   tt_integr_acr_lote_impl NO-ERROR.
          ASSIGN tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr  = tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr + v_total.
                 tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr = tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr + v_total.
    


    FIND FIRST EMSBAS.ESTABELECIMENTO NO-LOCK WHERE EMSBAS.ESTABELECIMENTO.cod_estab = ext-tit-acr-dev.cod-estab-ems5 NO-ERROR.

    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = emsbas.estabelecimento.cod_estab
                                 NO-ERROR.


    
       ASSIGN v_parcela    = "01".
    
       FOR EACH ext-tit-acr-dev WHERE ext-tit-acr-dev.sdo-aplicar > 0
                                 AND   ext-tit-acr-dev.log-atualizado = NO
                                 :
    
                    ASSIGN parcela_unica = NO.
    
         REPEAT WHILE PARCELA_UNICA = NO:
    
            FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_estab       = ext-tit-acr-dev.cod-estab-ems5
                                       AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp-cr
                                       AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                       AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                       AND   tit_acr.cod_parcela     = V_PARCELA
                                       NO-ERROR.
    
            IF AVAIL tit_acr THEN DO:
    
                ASSIGN V_PARCELA = STRING(INT(V_PARCELA) + 1)
                       PARCELA_UNICA = NO.
    
    
            END.
    
            IF NOT AVAIL tit_acr THEN DO:
    
                ASSIGN 
                    ext-tit-acr-dev.ctr-parcela = v_parcela

                       V_PARCELA = STRING(INT(V_PARCELA) + 1)
                       PARCELA_UNICA = YES.

                     
            END.
         END.
       END.
    
        FOR EACH ext-tit-acr-dev WHERE ext-tit-acr-dev.sdo-aplicar > 0
                                 AND   ext-tit-acr-dev.log-atualizado = NO
                                 :
    
    
            FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_estab       = ext-tit-acr-dev.cod-estab-ems5
                                       AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                       AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                       AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                       AND   tit_acr.cod_parcela     = ext-tit-acr-dev.parcela
                                       AND   tit_acr.cdn_cliente     = ext-tit-acr-dev.cod-emitente
                                       AND   tit_acr.ind_sit_tit_acr = 'Devolu‡Æo' NO-ERROR.
    
            IF AVAILABLE tit_acr THEN DO:
                    ASSIGN ext-tit-acr-dev.log-atualizado = YES.
    
                FIND FIRST emsbas.espec_docto NO-LOCK WHERE emsbas.espec_docto.cod_espec_docto = ext-tit-acr-dev.cod-esp-cr NO-ERROR.
    
    
    
                FIND LAST tit_acr NO-LOCK USE-INDEX titacr_id WHERE tit_acr.cod_estab = ext-tit-acr-dev.cod-estab-ems5
                                                              AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                                              AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                                              AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                                              NO-ERROR.

                FIND FIRST val_tit_acr NO-LOCK WHERE val_tit_acr.cod_estab = tit_acr.cod_estab
                                               AND   val_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
    
    
                create tt_integr_acr_item_lote_impl.
                assign tt_integr_acr_item_lote_impl.ttv_rec_lote_impl_tit_acr      = recid(tt_integr_acr_lote_impl)
                       tt_integr_acr_item_lote_impl.tta_num_seq_refer              = I-SEQ
                       tt_integr_acr_item_lote_impl.tta_cdn_cliente                = ext-tit-acr-dev.cod-emitente
                       tt_integr_acr_item_lote_impl.tta_cod_espec_docto            = ext-tit-acr-dev.cod-esp-cr
                       tt_integr_acr_item_lote_impl.tta_cod_ser_docto              = ext-tit-acr-dev.serie
                       tt_integr_acr_item_lote_impl.tta_cod_tit_acr                = ext-tit-acr-dev.nr-docto
                       tt_integr_acr_item_lote_impl.tta_cod_parcela                = string(ext-tit-acr-dev.ctr-parcela)
                       tt_integr_acr_item_lote_impl.tta_cod_portador               = "666"
                       tt_integr_acr_item_lote_impl.tta_cod_portad_ext             = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_cart_bcia              = "sim"
                       tt_integr_acr_item_lote_impl.tta_cod_modalid_ext            = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_cond_cobr              = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_motiv_movto_tit_acr    = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_histor_padr            = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cdn_repres                 = 0
                       tt_integr_acr_item_lote_impl.tta_dat_vencto_tit_acr         = ext-tit-acr-dev.dt-transacao
                       tt_integr_acr_item_lote_impl.tta_dat_prev_liquidac          = ext-tit-acr-dev.dt-transacao
                       tt_integr_acr_item_lote_impl.tta_dat_emis_docto             = ext-tit-acr-dev.dt-transacao
                       .
                assign tt_integr_acr_item_lote_impl.tta_des_text_histor            ="Integra‡Æo Recebimento com Contas a Receber EMS 5.0 - Devolu‡Æo de Mercadorias" + chr(10) +
                       "NF: " + ext-tit-acr-dev.nota-fiscal + " Serie " + ext-tit-acr-dev.serie-nota + " Nat.OPer " + ext-tit-acr-dev.nat-operacao + CHR(10)
                       tt_integr_acr_item_lote_impl.tta_val_liq_tit_acr            = ext-tit-acr-dev.sdo-aplicar
                       tt_integr_acr_item_lote_impl.tta_val_tit_acr                = ext-tit-acr-dev.sdo-aplicar
                       tt_integr_acr_item_lote_impl.tta_ind_tip_espec_docto        = emsbas.espec_docto.ind_tip_espec_docto
                       tt_integr_acr_item_lote_impl.tta_ind_sit_tit_acr            = "Normal" /*l_normal*/
                       tt_integr_acr_item_lote_impl.tta_log_liquidac_autom         = no
                       tt_integr_acr_item_lote_impl.tta_num_id_tit_acr             = ?
                       tt_integr_acr_item_lote_impl.tta_num_id_movto_tit_acr       = ?
                       tt_integr_acr_item_lote_impl.tta_cod_refer                  = v_refer_unica
                       tt_integr_acr_item_lote_impl.tta_cod_indic_econ             = 'REAL'
                       tt_integr_acr_item_lote_impl.tta_cod_finalid_econ_ext       = '0'.
    
    
                FIND LAST tit_acr NO-LOCK USE-INDEX titacr_id WHERE tit_acr.cod_estab = ext-tit-acr-dev.cod-estab-ems5
                                                              AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                                              AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                                              AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                                              AND   tit_acr.cod_parcela     = ext-tit-acr-dev.parcela
                                                              NO-ERROR.
    
                CREATE tt_integr_acr_relacto_pend.
                ASSIGN tt_integr_acr_relacto_pend.ttv_rec_item_lote_impl_tit_acr   = RECID(tt_integr_acr_item_lote_impl)
                       tt_integr_acr_relacto_pend.tta_cod_estab_tit_acr_pai        = ext-tit-acr-dev.cod-estab-ems5
                       tt_integr_acr_relacto_pend.ttv_cod_estab_tit_acr_pai_ext    = ext-tit-acr-dev.cod-estab-ems5
                       tt_integr_acr_relacto_pend.tta_num_id_tit_acr_pai           = tit_acr.num_id_tit_acr
                       tt_integr_acr_relacto_pend.tta_cod_espec_docto              = ext-tit-acr-dev.cod-esp
                       tt_integr_acr_relacto_pend.tta_cod_ser_docto                = ext-tit-acr-dev.serie
                       tt_integr_acr_relacto_pend.tta_cod_tit_acr                  = ext-tit-acr-dev.nr-docto
                       tt_integr_acr_relacto_pend.tta_cod_parcela                  = string(ext-tit-acr-dev.ctr-parcela)
                       tt_integr_acr_relacto_pend.tta_val_relacto_tit_acr          = ext-tit-acr-dev.sdo-aplicar .
    
    
    
    
               create tt_nota_devol_tit_acr.
               assign tt_nota_devol_tit_acr.tta_cod_estab              = tt_integr_acr_lote_impl.tta_cod_estab
                      tt_nota_devol_tit_acr.tta_cod_espec_docto        = tt_integr_acr_item_lote_impl.tta_cod_espec_docto
                      tt_nota_devol_tit_acr.tta_cod_ser_docto          = tt_integr_acr_item_lote_impl.tta_cod_ser_docto
                      tt_nota_devol_tit_acr.tta_cod_tit_acr            = tt_integr_acr_item_lote_impl.tta_cod_tit_acr
                      tt_nota_devol_tit_acr.tta_cod_parcela            = tt_integr_acr_item_lote_impl.tta_cod_parcela
                      tt_nota_devol_tit_acr.tta_cdn_cliente            = ext-tit-acr-dev.cod-emitente
                      tt_nota_devol_tit_acr.tta_cod_ser_nota_devol     = ext-tit-acr-dev.serie-nota
                      tt_nota_devol_tit_acr.tta_cod_nota_devol         = ext-tit-acr-dev.nota-fiscal
                      tt_nota_devol_tit_acr.tta_cod_natur_operac_devol = ext-tit-acr-dev.nat-operacao
                      tt_nota_devol_tit_acr.tta_dat_emis_docto         = tt_integr_acr_item_lote_impl.tta_dat_emis_docto.
    


    
    
            END.
    
            ASSIGN I-SEQ = I-SEQ + 10.
            ASSIGN ext-tit-acr-dev.sdo-aplicar     = 0 
                   ext-tit-acr-dev.log-atualizado  = YES. 
    
    
        END.
    
    

        FOR EACH ext-tit-acr-dev WHERE ext-tit-acr-dev.sdo-aplicar     > 0
                                 AND   ext-tit-acr-dev.log-atualizado = NO
                                 :
    
    
                FIND FIRST emsbas.espec_docto NO-LOCK WHERE emsbas.espec_docto.cod_espec_docto = ext-tit-acr-dev.cod-esp-cr NO-ERROR.
    
   
                FIND FIRST clien_financ NO-LOCK WHERE clien_financ.cdn_cliente = ext-tit-acr-dev.cod-emitente NO-ERROR.
    
                create tt_integr_acr_item_lote_impl.
                assign tt_integr_acr_item_lote_impl.ttv_rec_lote_impl_tit_acr      = recid(tt_integr_acr_lote_impl)
                       tt_integr_acr_item_lote_impl.tta_num_seq_refer              = I-SEQ
                       tt_integr_acr_item_lote_impl.tta_cdn_cliente                = ext-tit-acr-dev.cod-emitente
                       tt_integr_acr_item_lote_impl.tta_cod_espec_docto            = ext-tit-acr-dev.cod-esp-cr
                       tt_integr_acr_item_lote_impl.tta_cod_ser_docto              = ext-tit-acr-dev.serie
                       tt_integr_acr_item_lote_impl.tta_cod_tit_acr                = ext-tit-acr-dev.nr-docto
                       tt_integr_acr_item_lote_impl.tta_cod_parcela                = string(ext-tit-acr-dev.ctr-parcela)
                       tt_integr_acr_item_lote_impl.tta_cod_portador               = "666"
                       tt_integr_acr_item_lote_impl.tta_cod_portad_ext             = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_cart_bcia              = "sim"
                       tt_integr_acr_item_lote_impl.tta_cod_modalid_ext            = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_cond_cobr              = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_motiv_movto_tit_acr    = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cod_histor_padr            = "" /*l_*/
                       tt_integr_acr_item_lote_impl.tta_cdn_repres                 = 0
                       tt_integr_acr_item_lote_impl.tta_dat_vencto_tit_acr         = ext-tit-acr-dev.dt-transacao
                       tt_integr_acr_item_lote_impl.tta_dat_prev_liquidac          = ext-tit-acr-dev.dt-transacao
                       tt_integr_acr_item_lote_impl.tta_dat_emis_docto             = ext-tit-acr-dev.dt-transacao
                       .
                assign tt_integr_acr_item_lote_impl.tta_des_text_histor            ="Integra‡Æo Recebimento com Contas a Receber EMS 5.0 - Devolu‡Æo de Mercadorias" + chr(10) +
                       "NF: " + ext-tit-acr-dev.nota-fiscal + " Serie " + ext-tit-acr-dev.serie-nota + " Nat.OPer " + ext-tit-acr-dev.nat-operacao + CHR(10)
                       tt_integr_acr_item_lote_impl.tta_val_liq_tit_acr            = ext-tit-acr-dev.sdo-aplicar
                       tt_integr_acr_item_lote_impl.tta_val_tit_acr                = ext-tit-acr-dev.sdo-aplicar
                       tt_integr_acr_item_lote_impl.tta_ind_tip_espec_docto        = emsbas.espec_docto.ind_tip_espec_docto
                       tt_integr_acr_item_lote_impl.tta_ind_sit_tit_acr            = "Normal" /*l_normal*/
                       tt_integr_acr_item_lote_impl.tta_log_liquidac_autom         = no
                       tt_integr_acr_item_lote_impl.tta_num_id_tit_acr             = ?
                       tt_integr_acr_item_lote_impl.tta_num_id_movto_tit_acr       = ?
                       tt_integr_acr_item_lote_impl.tta_cod_refer                  = v_refer_unica
                       tt_integr_acr_item_lote_impl.tta_cod_indic_econ             = 'REAL'
                       tt_integr_acr_item_lote_impl.tta_cod_finalid_econ_ext       = '0'.
    
    
                FIND LAST tit_acr NO-LOCK USE-INDEX titacr_id WHERE tit_acr.cod_estab = ext-tit-acr-dev.cod-estab-ems5
                                                              AND   tit_acr.cod_espec_docto = ext-tit-acr-dev.cod-esp
                                                              AND   tit_acr.cod_ser_docto   = ext-tit-acr-dev.serie
                                                              AND   tit_acr.cod_tit_acr     = ext-tit-acr-dev.nr-docto
                                                              AND   tit_acr.cod_parcela     = ext-tit-acr-dev.parcela
                                                              NO-ERROR.
    
                CREATE tt_integr_acr_relacto_pend.
                ASSIGN tt_integr_acr_relacto_pend.ttv_rec_item_lote_impl_tit_acr   = RECID(tt_integr_acr_item_lote_impl)
                       tt_integr_acr_relacto_pend.tta_cod_estab_tit_acr_pai        = ext-tit-acr-dev.cod-estab-ems5
                       tt_integr_acr_relacto_pend.ttv_cod_estab_tit_acr_pai_ext    = ext-tit-acr-dev.cod-estab-ems5
                       tt_integr_acr_relacto_pend.tta_num_id_tit_acr_pai           = tit_acr.num_id_tit_acr
                       tt_integr_acr_relacto_pend.tta_cod_espec_docto              = ext-tit-acr-dev.cod-esp
                       tt_integr_acr_relacto_pend.tta_cod_ser_docto                = ext-tit-acr-dev.serie
                       tt_integr_acr_relacto_pend.tta_cod_tit_acr                  = ext-tit-acr-dev.nr-docto
                       tt_integr_acr_relacto_pend.tta_cod_parcela                  = string(ext-tit-acr-dev.ctr-parcela)
                       tt_integr_acr_relacto_pend.tta_val_relacto_tit_acr          = ext-tit-acr-dev.sdo-aplicar.
    
    
    
    
               create tt_nota_devol_tit_acr.
               assign tt_nota_devol_tit_acr.tta_cod_estab              = tt_integr_acr_lote_impl.tta_cod_estab
                      tt_nota_devol_tit_acr.tta_cod_espec_docto        = tt_integr_acr_item_lote_impl.tta_cod_espec_docto
                      tt_nota_devol_tit_acr.tta_cod_ser_docto          = tt_integr_acr_item_lote_impl.tta_cod_ser_docto
                      tt_nota_devol_tit_acr.tta_cod_tit_acr            = tt_integr_acr_item_lote_impl.tta_cod_tit_acr
                      tt_nota_devol_tit_acr.tta_cod_parcela            = tt_integr_acr_item_lote_impl.tta_cod_parcela
                      tt_nota_devol_tit_acr.tta_cdn_cliente            = ext-tit-acr-dev.cod-emitente
                      tt_nota_devol_tit_acr.tta_cod_ser_nota_devol     = ext-tit-acr-dev.serie-nota
                      tt_nota_devol_tit_acr.tta_cod_nota_devol         = ext-tit-acr-dev.nota-fiscal
                      tt_nota_devol_tit_acr.tta_cod_natur_operac_devol = ext-tit-acr-dev.nat-operacao
                      tt_nota_devol_tit_acr.tta_dat_emis_docto         = tt_integr_acr_item_lote_impl.tta_dat_emis_docto.

    
               ASSIGN ext-tit-acr-dev.sdo-aplicar     = 0 
                      ext-tit-acr-dev.log-atualizado  = YES. 
    
    
            ASSIGN I-SEQ = I-SEQ + 10.
    
    
        END.

END PROCEDURE.


PROCEDURE pi-efetivar:
    OUTPUT TO value(SESSION:TEMP-DIRECTORY + "FINAL5.txt") NO-CONVERT append.

                find param_integr_ems
                     where param_integr_ems.ind_param_integr_ems = "Recebimento 2.00" no-lock no-error.
    
                run prgfin/acr/acr900zi.py persistent set v_hdl_api_integr_acr.
    
                run pi_main_code_integr_acr_new_13 in v_hdl_api_integr_acr(input 11,
                                                                           input param_integr_ems.des_contdo_param_integr_ems,
                                                                           input YES,
                                                                           input NO,
                                                                           input table tt_integr_acr_repres_comis_2,
                                                                           input-output table tt_integr_acr_item_lote_impl_9,
                                                                           input table tt_integr_acr_aprop_relacto_2b,
                                                                           input-output table tt_params_generic_api,
                                                                           Input table tt_integr_acr_relacto_pend_aux).
                delete procedure v_hdl_api_integr_acr.

                
                FIND FIRST tt_log_erros_atualiz  NO-ERROR.
    
                IF AVAIL tt_log_erros_atualiz  THEN DO:
                export tt_log_erros_atualiz.
                output close.
                    FOR EACH ext-docum-est-dev :
                        
                        FOR EACH docum-est WHERE docum-est.cod-emitente = ext-docum-est-dev.cod-emitente
                                           AND   docum-est.nro-docto    = ext-docum-est-dev.nota-fiscal
                                           AND   docum-est.serie-docto  = ext-docum-est-dev.serie-nota:
        
                            ASSIGN docum-est.cr-atual = NO.

                            DELETE ext-docum-est-dev.
                        END.
                    END.

                    EMPTY TEMP-TABLE tt_integr_acr_lote_impl.

                    EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl.

                    empty TEMP-TABLE tt_integr_acr_item_lote_impl_9.

                    empty TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.

                    empty TEMP-TABLE tt_integr_acr_repres_pend.

                    EMPTY TEMP-TABLE tt_nota_devol_tit_acr.

                    EMPTY TEMP-TABLE tt_integr_acr_relacto_pend.
                    
                    for each ext-tit-acr-dev:
                        delete ext-tit-acr-dev.
                    end.
    
                    RUN esp\MESSAGE.p(INPUT "Nota fiscal apresenta erros",
                                      INPUT tt_log_erros_atualiz.ttv_des_msg_ajuda).
    
    
                    RETURN 'nok'.
    
                END.
    
                ELSE DO:
    
                    FOR EACH ext-tit-acr-dev WHERE   ext-tit-acr-dev.log-atualizado = YES:
                        
                    CREATE nota_devol_tit_acr.
                    ASSIGN nota_devol_tit_acr.cod_estab              = ext-tit-acr-dev.cod-estab-ems5
                           nota_devol_tit_acr.cod_espec_docto        = ext-tit-acr-dev.cod-esp-cr
                           nota_devol_tit_acr.cod_ser_docto          = ext-tit-acr-dev.serie
                           nota_devol_tit_acr.cod_tit_acr            = ext-tit-acr-dev.nr-docto
                           nota_devol_tit_acr.cod_parcela            = string(ext-tit-acr-dev.ctr-parcela)
                           nota_devol_tit_acr.cdn_cliente            = ext-tit-acr-dev.cod-emitente
                           nota_devol_tit_acr.cod_ser_nota_devol     = ext-tit-acr-dev.serie-nota
                           nota_devol_tit_acr.cod_nota_devol         = ext-tit-acr-dev.nota-fiscal
                           nota_devol_tit_acr.cod_natur_operac_devol = ext-tit-acr-dev.nat-operacao
                           nota_devol_tit_acr.dat_emis_docto         = ext-tit-acr-dev.dt-transacao.
    
    
                    DELETE ext-tit-acr-dev.
                    END.
    
                    FOR EACH ext-tit-acr-dev:
                        DELETE ext-tit-acr-dev.
                    END.

                    FOR EACH ext-docum-est-dev:
                        FOR EACH docum-est WHERE docum-est.cod-emitente = ext-docum-est-dev.cod-emitente
                        AND   docum-est.nro-docto    = ext-docum-est-dev.nota-fiscal
                        AND   docum-est.serie-docto  = ext-docum-est-dev.serie-nota:

                        ASSIGN docum-est.cr-atual = NO.

                        DELETE ext-docum-est-dev.
                        end.
                    END.
                    EMPTY TEMP-TABLE tt_integr_acr_lote_impl.

                    EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl.

                    empty TEMP-TABLE tt_integr_acr_item_lote_impl_9.

                    empty TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.

                    empty TEMP-TABLE tt_integr_acr_repres_pend.

                    EMPTY TEMP-TABLE tt_nota_devol_tit_acr.

                    EMPTY TEMP-TABLE tt_integr_acr_relacto_pend.
                    
                    RUN esp\MESSAGE.p(INPUT "Concluido",
                    INPUT "Processo concluido com sucesso").
  
                    RETURN "ok".

                END.



END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE. /* pi_retorna_sugestao_referencia */

PROCEDURE pi_verifica_refer_unica_acr:

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
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N’o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    def buffer b_renegoc_acr
        for renegoc_acr.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "Opera»’o financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.

    &if defined (BF_FIN_BCOS_HISTORICOS) &then
        if  v_log_utiliza_mbh
        and can-find (his_movto_tit_acr_histor no-lock
                      where his_movto_tit_acr_histor.cod_estab = p_cod_estab
                      and   his_movto_tit_acr_histor.cod_refer = p_cod_refer)
        then do:

            assign p_log_refer_uni = no.
        end.
    &endif
END PROCEDURE.
