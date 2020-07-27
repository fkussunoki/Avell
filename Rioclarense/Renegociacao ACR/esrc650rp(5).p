/* Nova versao do programa em 05/02/2019 */
/* Verificado com o banco que a geracao do nosso numero */
/* na geracao de boletos manuais � feita incrementando o */
/* ultimo nosso numero enviado pela empresa */
/* Gerando pelo controle de inadimplencia estava dando duplicidade */
/* Este programa gera o nosso numero com base nos seguintes dados */
/* Convenio cadastrado no Portador EDI  + Numero do Titulo +  Parcela da Renegociacao)*/
/* Revisao em 30/09/2019 - Acerto de logica para nao gerar problemas de duplicidade na serie*/

def new shared temp-table tt_integr_acr_abat_antecip no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
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
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/N�o" initial no label "Zera Saldo" column-label "Zera Saldo"
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
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont�bil" column-label "Conta Cont�bil"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa��o" column-label "UF"
    field tta_log_impto_val_agreg          as logical format "Sim/N�o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa�s Externo" column-label "Pa�s Externo"
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
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont�bil" column-label "Conta Cont�bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria��o" column-label "Tipo Apropria��o"
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
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T�tulo" column-label "Unid Negoc T�tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido".



def new shared temp-table tt_integr_acr_aprop_relacto no-undo
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ?
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont�bil" column-label "Conta Cont�bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl".



def new shared temp-table tt_integr_acr_cheq no-undo
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss�o" column-label "Dt Emiss"
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep�sito" column-label "Dep�sito"
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs�o Dep�sito" column-label "Previs�o Dep�sito"
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu��o" column-label "Motivo Devolu��o"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu�rio" column-label "Usu�rio"
    field tta_log_pend_cheq_acr            as logical format "Sim/N�o" initial no label "Cheque Pendente" column-label "Cheque Pendente"
    field tta_log_cheq_terc                as logical format "Sim/N�o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N�o" initial no label "Cheque Reneg" column-label "Cheque Reneg"
    field tta_log_cheq_acr_devolv          as logical format "Sim/N�o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s"
    index tt_id                            is primary unique
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending.


def new shared temp-table tt_integr_acr_impto_impl_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa�s Externo" column-label "Pa�s Externo"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa��o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ�ncia" column-label "NumSeq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut�vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Al�quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont�bil" column-label "Conta Cont�bil"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota��o" column-label "Cota��o"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota��o" column-label "Data Cota��o"
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
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ�ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi��o Cobran�a" column-label "Cond Cobran�a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist�rico Padr�o" column-label "Hist�rico Padr�o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida��o" column-label "Prev Liquida��o"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss�o" column-label "Dt Emiss�o"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 INITIAL 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 INITIAL 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist�rico" column-label "Hist�rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D�gito Cta Corrente" column-label "D�gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc�ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc�ria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L�quido" column-label "Vl L�quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi��o Pagamento" column-label "Condi��o Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag�ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa��o T�tulo" column-label "Situa��o T�tulo"
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C�digo Cart�o" column-label "C�digo Cart�o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart�o" column-label "Validade Cart�o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C�d Pr�-Autoriza��o" column-label "C�d Pr�-Autoriza��o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concession�ria" column-label "Concession�ria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N�o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere�o Cobran�a" column-label "Endere�o Cobran�a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/N�o" initial no label "D�bito Autom�tico" column-label "D�bito Autom�tico"
    field tta_log_destinac_cobr            as logical format "Sim/N�o" initial no label "Destin Cobran�a" column-label "Destin Cobran�a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc�ria" column-label "Sit Banc�ria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T�tulo Banco" column-label "Num T�tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag�ncia Cobran�a" column-label "Ag�ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran�a" column-label "Obs Cobran�a"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending.


def temp-table tt_integr_acr_item_lote_impl_9 no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ�ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi��o Cobran�a" column-label "Cond Cobran�a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist�rico Padr�o" column-label "Hist�rico Padr�o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida��o" column-label "Prev Liquida��o"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss�o" column-label "Dt Emiss�o"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist�rico" column-label "Hist�rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D�gito Cta Corrente" column-label "D�gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc�ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc�ria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L�quido" column-label "Vl L�quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi��o Pagamento" column-label "Condi��o Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag�ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa��o T�tulo" column-label "Situa��o T�tulo"
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C�digo Cart�o" column-label "C�digo Cart�o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart�o" column-label "Validade Cart�o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C�d Pr�-Autoriza��o" column-label "C�d Pr�-Autoriza��o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concession�ria" column-label "Concession�ria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N�o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere�o Cobran�a" column-label "Endere�o Cobran�a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/N�o" initial no label "D�bito Autom�tico" column-label "D�bito Autom�tico"
    field tta_log_destinac_cobr            as logical format "Sim/N�o" initial no label "Destin Cobran�a" column-label "Destin Cobran�a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc�ria" column-label "Sit Banc�ria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T�tulo Banco" column-label "Num T�tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag�ncia Cobran�a" column-label "Ag�ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran�a" column-label "Obs Cobran�a"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota��o" column-label "Cota��o"
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C�lculo Juros" column-label "Tipo C�lculo Juros"
    field ttv_cod_comprov_vda_aux          as character format "x(12)"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_cod_autoriz_bco_emissor      as character format "x(6)" label "Codigo Autoriza��o" column-label "Codigo Autoriza��o"
    field ttv_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    field ttv_cod_estab_vendor             as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi��o Pagto" column-label "Condi��o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car�ncia" column-label "Dias Car�ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N�o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N�o" initial no
    field ttv_cod_estab_portad             as character format "x(8)"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta��o" column-label "Processo Exporta��o"
    field ttv_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr�dito PIS" column-label "Vl Cred PIS/PASEP"
    field ttv_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr�dito COFINS" column-label "Credito COFINS"
    field ttv_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr�dito CSLL" column-label "Credito CSLL"
    field tta_cod_indic_econ_desemb        as character format "x(8)" label "Moeda Desembolso" column-label "Moeda Desembolso"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N�o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field ttv_cod_nota_fisc_faturam        as character format "x(16)"
    field tta_cod_band                     as character format "x(10)" label "Bandeira" column-label "Bandeira"
    field tta_cod_tid                      as character format "x(10)" label "TID" column-label "TID"
    field tta_cod_terminal                 as character format "x(8)" label "Nr Terminal" column-label "Nr Terminal"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending.


def new shared temp-table tt_integr_acr_lote_impl no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C�digo Empresa Ext" column-label "C�d Emp Ext"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa��o" column-label "Dat Transac"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie"
    field tta_ind_orig_tit_acr             as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec"
    field tta_val_tot_lote_impl_tit_acr    as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Total Movimento"
    field tta_val_tot_lote_infor_tit_acr   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran�a" column-label "Tipo Cobran�a"
    field ttv_log_lote_impl_ok             as logical format "Sim/N�o" initial no
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica"
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
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_relacto_tit_acr          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Relacto" column-label "Vl Relacto"
    field tta_log_gera_alter_val           as logical format "Sim/N�o" initial no label "Gera Alter Valor" column-label "Gera Alter Valor"
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera��o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor".


def new shared temp-table tt_integr_acr_relacto_pend_cheq no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal�rio" column-label "Banco Cheque Sal�rio"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending.


def new shared temp-table tt_integr_acr_repres_pend no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi�n" column-label "% Comisi�n"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Emisi�n" column-label "% Comis Emisi�n"
    field tta_val_perc_comis_abat          as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi�n Rebaja" column-label "% Comisi�n Rebaja"
    field tta_val_perc_comis_desc          as decimal format ">>9.9999" decimals 4 initial 0 label "% Comisi�n Desct" column-label "% Comisi�n Desct"
    field tta_val_perc_comis_juros         as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Inter" column-label "% Comis Inter"
    field tta_val_perc_comis_multa         as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.9999" decimals 4 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "S�/No" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comisi�n" column-label "Tipo Comisi�n"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cdn_repres                   ascending.

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer?ncia" column-label "Refer?ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ?ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N�mero" column-label "N�mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist?ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".



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
    field ttv_log_nota_vincul              as logical format "Sim/N�o" initial yes

    .


Def var v_hdl_programa as HANDLE format ">>>>>>9" no-undo.
DEF VAR controle AS INTEGER.
DEF VAR v_cod_nosso_numero AS char.
DEF VAR h-prog AS HANDLE.

DEFINE TEMP-TABLE tt-titulos 
    FIELD ttv-estab AS char
    FIELD ttv-especie AS char
    FIELD ttv-serie   AS char
    FIELD ttv-titulo AS CHAR
    FIELD ttv-parcela AS char
    FIELD ttv-valor   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>>.99"
    FIELD ttv-cta-ctbl AS char
    FIELD ttv-vcto   AS DATE
    INDEX ttv-idx-titulos IS PRIMARY unique
          ttv-estab           ASCENDING
          ttv-especie         ASCENDING
          ttv-serie           ASCENDING
          ttv-titulo          ASCENDING
          ttv-parcela         ASCENDING.




DEFINE INPUT PARAM TABLE FOR tt-titulos.
DEFINE INPUT param p-valor AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>>.99".

DEF VAR c-cta_ctbl AS char.
DEF VAR i-tot AS INTEGER.
DEF VAR v_serie AS INTEGER.
DEF VAR v_cod_digito_nosso_num AS CHAR.

OUTPUT TO c:\temp\tt-titulos.txt.

disp p-valor.

FOR EACH tt-titulos:

    EXPORT tt-titulos.
END.

OUTPUT CLOSE.

DEFINE VAR v_cod_refer AS char.


       FOR EACH tt_integr_acr_lote_impl:
            DELETE tt_integr_acr_lote_impl.
        END.

        FOR EACH tt_integr_acr_item_lote_impl_9:
            DELETE tt_integr_acr_item_lote_impl_9.
        END.

        FOR EACH tt_integr_acr_aprop_ctbl_pend:
            DELETE tt_integr_acr_aprop_ctbl_pend.
        END.

        FOR EACH tt_integr_acr_repres_pend:
            DELETE tt_integr_acr_repres_pend.
        END.

ASSIGN controle  = 10.


FIND FIRST tt-titulos NO-ERROR.

run pi-serie(output v_serie).


FIND FIRST  tit_Acr WHERE tit_acr.cod_estab             = tt-titulos.ttv-estab
                   AND   tit_Acr.cod_espec_docto        = tt-titulos.ttv-especie
                   AND   tit_Acr.cod_ser_docto          = tt-titulos.ttv-serie
                   AND   tit_Acr.cod_tit_acr            = tt-titulos.ttv-titulo
                   and   substring(tit_acr.cod_parcela,1,1) <> "r"            
                   NO-ERROR.

IF AVAIL tit_Acr THEN
    

          ASSIGN c-cta_ctbl = tt-titulos.ttv-cta-ctbl.
        
          run pi_referencia (Input "T",
                           Input today,
                           output v_cod_refer) .

        
        CREATE tt_integr_acr_lote_impl.

        ASSIGN
            tt_integr_acr_lote_impl.tta_cod_empresa                 =   STRING(tit_Acr.cod_empresa)
            tt_integr_acr_lote_impl.tta_cod_estab                   =   tit_Acr.cod_estab
            tt_integr_acr_lote_impl.tta_cod_refer                   =   v_cod_refer
            tt_integr_acr_lote_impl.tta_dat_transacao               =   TODAY
            tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr   =   p-valor
            tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr  =   p-valor.


RUN utp/ut-perc.p PERSISTENT SET h-prog.


        FOR EACH tt-titulos USE-INDEX ttv-idx-titulos:

            FIND FIRST tit_Acr WHERE tit_acr.cod_estab              = tt-titulos.ttv-estab
                               AND   tit_Acr.cod_espec_docto        = tt-titulos.ttv-especie
                               AND   tit_Acr.cod_ser_docto          = tt-titulos.ttv-serie
                               AND   tit_Acr.cod_tit_acr            = tt-titulos.ttv-titulo
                               NO-ERROR.
           
        FIND FIRST portad_edi NO-LOCK WHERE portad_edi.cod_modul_dtsul  = "ACR"
                                      AND   portad_edi.cod_estab        = tit_Acr.cod_estab
                                      AND   portad_edi.cod_portador     = tit_Acr.cod_portador
                                      AND   portad_edi.cod_cart_bcia    = tit_Acr.cod_cart_bcia
                                      AND   portad_edi.cod_finalid_econ = "corrente" 
                                      AND   entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) <> "" NO-ERROR.

        IF AVAIL portad_edi THEN DO:

            CASE tt-titulos.ttv-estab:

                WHEN '101' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '1' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).
                WHEN '102' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '2' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).

                WHEN '103' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '3' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).
                WHEN '104' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '4' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).
                WHEN '301' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '5' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).
                WHEN '401' THEN
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '6' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).
                OTHERWISE
                    ASSIGN v_cod_nosso_numero = entry(1, portad_edi.des_tip_var_portad_edi, CHR(10)) + '7' + tit_Acr.cod_tit_acr  + SUBSTRING(tt-titulos.ttv-parcela, 2, 1) + STRING(v_serie).


            END CASE.


                            run pi_calcula_modulo11_char (Input "Banco do Brasil" /*l_banco_do_brasil*/,
                                              Input v_cod_nosso_numero,
                                              Input NO,
                                              output v_cod_digito_nosso_num) /*pi_calcula_modulo11_char*/.
        END.

        ELSE DO:
            MESSAGE "O portador " + tit_Acr.cod_portador + "Estab " + tit_Acr.cod_estab + "Carteira " + tit_Acr.cod_cart_bcia SKIP
                    " nao possui cadastro para geracao de nosso numero. Verifique o convenio informado" VIEW-AS ALERT-BOX.
            RETURN.
        END.

            
        

CREATE tt_integr_acr_item_lote_impl_9.
ASSIGN tt_integr_acr_item_lote_impl_9.ttv_rec_lote_impl_tit_acr        = RECID(tt_integr_acr_lote_impl)
       tt_integr_acr_item_lote_impl_9.tta_num_seq_refer                = controle
       tt_integr_acr_item_lote_impl_9.tta_cdn_cliente                  = tit_Acr.cdn_cliente
       tt_integr_acr_item_lote_impl_9.tta_cod_espec_docto              = tit_Acr.cod_espec_docto
       tt_integr_acr_item_lote_impl_9.tta_cod_ser_docto                = STRING(v_serie)
       tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr                  = tit_Acr.cod_tit_acr
       tt_integr_acr_item_lote_impl_9.tta_cod_parcela                  = tt-titulos.ttv-parcela
       tt_integr_acr_item_lote_impl_9.tta_cod_indic_econ               = tit_Acr.cod_indic_econ
       tt_integr_acr_item_lote_impl_9.tta_cod_finalid_econ_ext         = "0"
       tt_integr_acr_item_lote_impl_9.tta_cod_portador                 = tit_Acr.cod_portador
       tt_integr_acr_item_lote_impl_9.tta_cod_portad_ext               = tit_Acr.cod_portador
       tt_integr_acr_item_lote_impl_9.tta_cod_cart_bcia                = tit_Acr.cod_cart_bcia
       tt_integr_acr_item_lote_impl_9.tta_cod_modalid_ext              = "1"
       tt_integr_acr_item_lote_impl_9.tta_cod_cond_cobr                = tit_Acr.cod_cond_cobr
       tt_integr_acr_item_lote_impl_9.tta_cdn_repres                   = tit_Acr.cdn_repres
       tt_integr_acr_item_lote_impl_9.tta_dat_vencto_tit_acr           = tt-titulos.ttv-vcto
       tt_integr_acr_item_lote_impl_9.tta_dat_prev_liquidac            = tt-titulos.ttv-vcto
       tt_integr_acr_item_lote_impl_9.tta_dat_emis_docto               = tit_Acr.dat_emis_docto
       tt_integr_acr_item_lote_impl_9.tta_val_tit_acr                  = tt-titulos.ttv-valor
       tt_integr_acr_item_lote_impl_9.tta_val_base_calc_comis          = tt-titulos.ttv-valor
       tt_integr_acr_item_lote_impl_9.tta_des_text_histor              = "Renegociacao automatica"
       tt_integr_acr_item_lote_impl_9.tta_cod_banco                    = tit_Acr.cod_banco
       tt_integr_acr_item_lote_impl_9.tta_cod_agenc_bcia               = tit_Acr.cod_agenc_bcia
       tt_integr_acr_item_lote_impl_9.tta_cod_cta_corren_bco           = tit_Acr.cod_cta_corren_bco 
       tt_integr_acr_item_lote_impl_9.tta_val_liq_tit_acr              = tt-titulos.ttv-valor
       tt_integr_acr_item_lote_impl_9.tta_ind_tip_espec_docto          = tit_Acr.ind_tip_espec_docto
       tt_integr_acr_item_lote_impl_9.tta_cod_cond_pagto               = tit_Acr.cod_cond_pagto
       tt_integr_acr_item_lote_impl_9.tta_cod_refer                    = tt_integr_acr_lote_impl.tta_cod_refer
       tt_integr_acr_item_lote_impl_9.ttv_rec_item_lote_impl_tit_acr   = recid(tt_integr_acr_item_lote_impl_9)
       tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr_bco              = v_cod_nosso_numero.

controle = controle  + 10.
END.



FOR EACH tt_integr_acr_item_lote_impl_9 FIELDS (tta_cod_espec_docto tta_cod_ser_docto tta_cod_tit_acr ttv_rec_item_lote_impl_tit_acr tta_val_tit_acr)  USE-INDEX tt_id :

    ASSIGN i-tot = i-tot + 1.

    END.


    RUN pi-inicializar IN h-prog (INPUT "Gerando...Aguarde", i-tot).

FOR EACH tt_integr_acr_item_lote_impl_9 FIELDS (tta_cod_espec_docto tta_cod_ser_docto tta_cod_tit_acr ttv_rec_item_lote_impl_tit_acr tta_val_tit_acr)  USE-INDEX tt_id :


    FIND FIRST tt_integr_acr_lote_impl WHERE tt_integr_acr_lote_impl.tta_cod_refer = tt_integr_acr_item_lote_impl_9.tta_cod_refer NO-ERROR.
    
    

    FIND FIRST tit_Acr no-lock WHERE tit_acr.cod_estab      = tt_integr_acr_lote_impl.tta_cod_estab  
                       AND   tit_Acr.cod_espec_docto        = tt_integr_acr_item_lote_impl_9.tta_cod_espec_docto    
                       AND   tit_Acr.cod_tit_acr            = tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr
                       and   tit_acr.ind_orig_tit_acr       = "FATEMS20"
                       NO-ERROR.

    FIND FIRST movto_tit_acr NO-LOCK WHERE movto_tit_acr.num_id_tit_acr = tit_Acr.num_id_tit_acr
                                     AND   movto_tit_acr.ind_trans_acr_abrev = "IMPL" 
                                     AND   movto_tit_acr.cod_estab      = tit_Acr.cod_estab
                                     AND   movto_tit_acr.cod_refer      = tit_Acr.cod_refer
                                     AND   movto_tit_acr.cod_espec_docto = tit_Acr.cod_espec_docto
/*                                   AND   movto_tit_acr.cod_portador    = tit_Acr.cod_portador   */
/*                                   AND   movto_tit_acr.cod_cart_bcia   = tit_Acr.cod_cart_bcia  */
                                     AND   movto_tit_acr.dat_transacao   = tit_Acr.dat_transacao NO-ERROR.

    FIND FIRST aprop_ctbl_acr NO-LOCK WHERE aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr 
                                      AND   aprop_ctbl_acr.cod_empresa          = movto_tit_acr.cod_empresa
                                      AND   aprop_ctbl_acr.cod_estab            = movto_tit_acr.cod_estab
                                      AND   aprop_ctbl_acr.dat_transacao        = movto_tit_acr.dat_transacao NO-ERROR.


    FIND FIRST rat_movto_tit_acr NO-LOCK WHERE rat_movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr 
                                         AND   rat_movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
                                         NO-ERROR.
    
    RUN pi-acompanhar IN h-prog.

CREATE tt_integr_acr_aprop_ctbl_pend.
ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr  = tt_integr_acr_item_lote_impl_9.ttv_rec_item_lote_impl_tit_acr 
       tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl          = "padrao"
       tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl                = c-cta_ctbl 
       tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc              = aprop_ctbl_acr.cod_unid_negoc
       tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ        = rat_movto_tit_acr.cod_tip_fluxo_financ
       tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl              = tt_integr_acr_item_lote_impl_9.tta_val_tit_acr 
.
              


        FOR EACH fat-repre fields(cod-estabel serie nr-fatura nome-ab-rep perc-comis) USE-INDEX ch-fatrep NO-LOCK WHERE  fat-repre.cod-estabel               = tt_integr_acr_lote_impl.tta_cod_estab  
                                                                                                       AND   fat-repre.serie                     = tt_integr_acr_item_lote_impl_9.tta_cod_ser_docto
                                                                                                       AND   fat-repre.nr-fatura                 = tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr:
 

            FIND FIRST representante NO-LOCK WHERE representante.nom_abrev = fat-repre.nome-ab-rep NO-ERROR.

                CREATE tt_integr_acr_repres_pend.
                ASSIGN tt_integr_acr_repres_pend.ttv_rec_item_lote_impl_tit_acr     = tt_integr_acr_item_lote_impl_9.ttv_rec_item_lote_impl_tit_acr 
                       tt_integr_acr_repres_pend.tta_cdn_repres                     = representante.cdn_repres
                       tt_integr_acr_repres_pend.tta_val_perc_comis_repres          = fat-repre.perc-comis
                       tt_integr_acr_repres_pend.tta_log_comis_repres_proporc       = YES
                       tt_integr_acr_repres_pend.tta_ind_tip_comis                  = "Valor Liquido".
    
    END.
END.




/*         FIND FIRST tit_Acr WHERE tit_acr.cod_estab              = tt-titulos.ttv-estab                      */
/*                            AND   tit_Acr.cod_espec_docto        = tt-titulos.ttv-especie                    */
/*                            AND   tit_Acr.cod_ser_docto          = tt-titulos.ttv-serie                      */
/*                            AND   tit_Acr.cod_tit_acr            = tt-titulos.ttv-titulo                     */
/*                            NO-ERROR.                                                                        */
/*                                                                                                             */
/*                                                                                                             */
/*                                                                                                             */
/*             FOR EACH repres_tit_acr NO-LOCK WHERE repres_tit_acr.cod_empresa = tit_Acr.cod_empresa          */
/*                                             AND   repres_tit_acr.cod_estab   = tit_Acr.cod_estab            */
/*                                             AND   repres_tit_acr.cod_espec_docto = tit_Acr.cod_espec_docto  */
/*                                             AND   repres_tit_acr.num_id_tit_acr  = tit_Acr.num_id_tit_acr   */
/*                                             AND   repres_tit_acr.cdn_cliente     = tit_Acr.cdn_cliente:     */
/*                                                                                                             */
        
/*         FOR EACH fat-repre USE-INDEX ch-fatrep NO-LOCK WHERE fat-repre.cod-estabel                = tt-titulos.ttv-estab                              */
/*                                                         AND   fat-repre.serie                     = tt_integr_acr_item_lote_impl_9.tta_cod_ser_docto  */
/*                                                         AND   fat-repre.nr-fatura                 = tt_integr_acr_item_lote_impl_9.tta_cod_tit_acr    */
/*                                                         AND   fat-repre.cod-classificador         = "":                                               */
 



/*         FIND FIRST representante NO-LOCK WHERE representante.nom_abrev = fat-repre.nome-ab-rep NO-ERROR.  */

        


/* CREATE tt_integr_acr_repres_pend.                                                                                                    */
/* ASSIGN tt_integr_acr_repres_pend.ttv_rec_item_lote_impl_tit_acr     = tt_integr_acr_item_lote_impl_9.ttv_rec_item_lote_impl_tit_acr  */
/*        tt_integr_acr_repres_pend.tta_cdn_repres                     = repres_tit_acr.cdn_repres                                      */
/*        tt_integr_acr_repres_pend.tta_val_perc_comis_repres          = repres_tit_acr.val_perc_comis_repres                           */
/*        tt_integr_acr_repres_pend.tta_log_comis_repres_proporc       = YES                                                            */
/*        tt_integr_acr_repres_pend.tta_ind_tip_comis                  = repres_tit_acr.ind_tip_comis.                                  */

/*     END.  */
/* END.      */


RUN pi-finalizar IN h-prog.






RUN prgfin/acr/acr900zi.py persistent set v_hdl_programa.



RUN pi_main_code_integr_acr_new_13 IN v_hdl_programa (INPUT 11,
                                                      INPUT 'FINANC',
                                                      INPUT NO,
                                                      INPUT NO,
                                                      INPUT TABLE tt_integr_acr_repres_comis_2,
                                                      INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_9,
                                                      INPUT TABLE tt_integr_acr_aprop_relacto_2b,
                                                      INPUT-OUTPUT TABLE tt_params_generic_api,
                                                      INPUT TABLE tt_integr_acr_relacto_pend_aux).

Delete procedure v_hdl_programa.


OUTPUT TO value(SESSION:TEMP-DIRECTORY + "detail.txt").

FOR EACH  tt_integr_acr_item_lote_impl_9 :

    disp tt_integr_acr_item_lote_impl_9.tta_val_tit_acr 
        tt_integr_acr_item_lote_impl_9.tta_cod_portador    
        tt_integr_acr_item_lote_impl_9.tta_cod_portad_ext  
        tt_integr_acr_item_lote_impl_9.tta_cod_cart_bcia   
        tt_integr_acr_item_lote_impl_9.tta_cod_modalid_ext 
        
        .

END.

OUTPUT CLOSE.

OUTPUT TO value(SESSION:TEMP-DIRECTORY + "FINAL.txt").

FIND FIRST tt_log_erros_atualiz  NO-ERROR.

IF AVAIL tt_log_erros_atualiz  THEN DO:

    MESSAGE "erro gerado em: " SESSION:TEMP-DIRECTORY + "final.txt." VIEW-AS ALERT-BOX.
    
    EXPORT tt_log_erros_atualiz.

END.

IF NOT avail tt_log_erros_atualiz THEN DO:
    
    MESSAGE "Lote " + v_cod_refer + " esta disponivel para conferencia. So sera atualizado apos sua verificacao." VIEW-AS ALERT-BOX.

END.



/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
*****************************************************************************/
PROCEDURE pi_referencia:

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

/*****************************************************************************
** Procedure Interna.....: pi_calcula_modulo11_char
** Descricao.............: pi_calcula_modulo11_char
** Criado por............: fut12234
** Criado em.............: 14/11/2007 09:57:07
** Alterado por..........: fut12234
** Alterado em...........: 22/11/2007 16:22:06
*****************************************************************************/
PROCEDURE pi_calcula_modulo11_char:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_tipo
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_num_base
        as character
        format "x(11)"
        no-undo.
    def Input param p_log_inverte
        as logical
        format "Sim/N�o"
        no-undo.
    def output param p_cod_digito
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_aux                        as integer         no-undo. /*local*/
    def var v_cdn_cont                       as integer         no-undo. /*local*/
    def var v_cdn_digito                     as integer         no-undo. /*local*/
    def var v_cdn_peso                       as integer         no-undo. /*local*/
    def var v_cdn_resto                      as integer         no-undo. /*local*/
    def var v_cdn_somatorio                  as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  (p_cod_tipo = "Banco do Brasil" /*l_banco_do_brasil*/ ) then do:
        assign v_cdn_peso = 7.
        /* calcula somatorio */
        REPEAT v_cdn_cont = 1 TO length(p_cod_num_base) :

            ASSIGN v_cdn_aux    = (v_cdn_peso * INT(SUBSTR(p_cod_num_base,v_cdn_cont,1)))
                   v_cdn_digito = v_cdn_digito + v_cdn_aux.
            IF v_cdn_peso = 9 THEN 
               ASSIGN v_cdn_peso = 2.
            ELSE 
               ASSIGN v_cdn_peso = v_cdn_peso + 1.
        END. 

        ASSIGN v_cdn_digito = (v_cdn_digito MOD 11).

        IF  v_cdn_digito = 10 THEN
            ASSIGN p_cod_digito = 'X'.
        ELSE 
            ASSIGN p_cod_digito = STRING(v_cdn_digito).
    end.
    if  (p_cod_tipo = "Bradesco" /*l_bradesco*/ ) then do:
        ASSIGN v_cdn_somatorio = v_cdn_somatorio + (2 * INTEGER(SUBSTRING(p_cod_num_base,01,1)))
               v_cdn_somatorio = v_cdn_somatorio + (7 * INTEGER(SUBSTRING(p_cod_num_base,02,1)))
               v_cdn_somatorio = v_cdn_somatorio + (6 * INTEGER(SUBSTRING(p_cod_num_base,03,1)))
               v_cdn_somatorio = v_cdn_somatorio + (5 * INTEGER(SUBSTRING(p_cod_num_base,04,1)))
               v_cdn_somatorio = v_cdn_somatorio + (4 * INTEGER(SUBSTRING(p_cod_num_base,05,1)))
               v_cdn_somatorio = v_cdn_somatorio + (3 * INTEGER(SUBSTRING(p_cod_num_base,06,1)))
               v_cdn_somatorio = v_cdn_somatorio + (2 * INTEGER(SUBSTRING(p_cod_num_base,07,1)))
               v_cdn_somatorio = v_cdn_somatorio + (7 * INTEGER(SUBSTRING(p_cod_num_base,08,1)))
               v_cdn_somatorio = v_cdn_somatorio + (6 * INTEGER(SUBSTRING(p_cod_num_base,09,1)))
               v_cdn_somatorio = v_cdn_somatorio + (5 * INTEGER(SUBSTRING(p_cod_num_base,10,1)))
               v_cdn_somatorio = v_cdn_somatorio + (4 * INTEGER(SUBSTRING(p_cod_num_base,11,1)))
               v_cdn_somatorio = v_cdn_somatorio + (3 * INTEGER(SUBSTRING(p_cod_num_base,12,1)))
               v_cdn_somatorio = v_cdn_somatorio + (2 * INTEGER(SUBSTRING(p_cod_num_base,13,1))).

        /* Validar antes se resto da divisao for zero, entao considera 0 como digito */
        if (v_cdn_somatorio MODULO 11) = 0 then do:
            ASSIGN p_cod_digito = '0'.
        end.
        else do:
            ASSIGN v_cdn_resto = 11 - (v_cdn_somatorio MODULO 11).

            IF v_cdn_resto = 10 THEN
               ASSIGN p_cod_digito = 'P'.
            ELSE
               ASSIGN p_cod_digito = STRING(v_cdn_resto).
        end.
    end.
END PROCEDURE. /* pi_calcula_modulo11_char */


procedure pi-serie:

//criado com o intuito de gerar uma serie separada
// para nao dar erro de duplicidade

define output param v_serie as integer.
define var i as logical initial false.


    do while i <> true:
    assign v_serie = 1.
    
    FIND last  tit_Acr WHERE tit_acr.cod_estab              = tt-titulos.ttv-estab
                       AND   tit_Acr.cod_espec_docto        = tt-titulos.ttv-especie
                       and   tit_acr.cod_ser_docto          = string(v_serie)
                       AND   tit_Acr.cod_tit_acr            = tt-titulos.ttv-titulo
                       and   substring(tit_acr.cod_parcela,1,1) = "r"            
                       NO-ERROR.
        if avail tit_acr then do:
        
        ASSIGN v_serie = v_serie + 1.
        
        
        end.
        
        assign v_serie = v_serie + 1
               i       = true.
        
    end.

    if not avail tit_acr then do:
    FIND FIRST  tit_Acr WHERE tit_acr.cod_estab             = tt-titulos.ttv-estab
                       AND   tit_Acr.cod_espec_docto        = tt-titulos.ttv-especie
                       AND   tit_Acr.cod_ser_docto          = tt-titulos.ttv-serie
                       AND   tit_Acr.cod_tit_acr            = tt-titulos.ttv-titulo
                       and   substring(tit_acr.cod_parcela,1,1) <> "r"            
                       NO-ERROR.
        if avail tit_acr then do:
        ASSIGN v_serie = int(tit_Acr.cod_ser_docto).
        end.
    end.
        
    



end procedure.

