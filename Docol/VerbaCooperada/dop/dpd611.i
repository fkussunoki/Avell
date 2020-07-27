def temp-table tt_xml_input_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq??ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist?ncia" column-label "Inconsist?ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .

def temp-table tt-amkt-solic-vl-bonific-tit-acr like amkt-solic-vl-bonific-tit-acr.


 
DEFINE TEMP-TABLE tt-titulos-acr NO-UNDO
FIELD ttv-estab         AS char
FIELD ttv-esp           AS CHAR
FIELD ttv-cod-tit-acr    AS char
FIELD ttv-cod-serie     AS char
FIELD ttv-parcela       AS char
FIELD ttv-cdn-cliente    AS INTEGER
FIELD ttv-nom-abrev     AS char
FIELD ttv-dt-emissao    AS DATE
FIELD ttv-dt-vcto       AS DATE
FIELD ttv-dias-carencia AS INTEGER
FIELD ttv-juros         AS DEC FORMAT ">>.999999"
FIELD ttv-vlr-sdo       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99"
FIELD ttv-portador      AS char
FIELD ttv-carteira      AS char
FIELD ttv-dt-trans      AS DATE
FIELD ttv-recid         AS recid
INDEX tt-primary 
ttv-estab ASCENDING
ttv-cdn-cliente ASCENDING
ttv-dt-emissao ASCENDING
ttv-esp ASCENDING.


DEF VAR v_hdl_program AS HANDLE NO-UNDO.

def new global shared var v_cod_usuar_corren
as character
format "x(12)"
label "Usuÿrio Corrente"
column-label "Usuÿrio Corrente"
no-undo.
def new global shared var v_rec_tit_acr
as recid
format ">>>>>>9":U
initial ?
no-undo.

DEF NEW GLOBAL SHARED VAR V_COD_EMPRES_USUAR AS CHAR NO-UNDO.

DEFINE VAR v_referencia AS char.

DEFINE VAR v_log AS LONGCHAR NO-UNDO.
DEFINE VAR v_log2 AS LONGCHAR NO-UNDO.

DEF VAR v_total AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" NO-UNDO.
DEF VAR v_matriz AS CHAR NO-UNDO.


def temp-table tt_alter_tit_acr_base_5 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa¯?o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Refer¬ncia" column-label "Refer¬ncia"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tðtulo" column-label "Saldo Tðtulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Altera¯?o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¬ncia Cobran¯a" column-label "Ag¬ncia Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num Tðtulo Banco" column-label "Num Tðtulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss?o" column-label "Dt Emiss?o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida¯?o" column-label "Prev Liquida¯?o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa¯?o Tðtulo" column-label "Situa¯?o Tðtulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi¯?o Cobran¯a" column-label "Cond Cobran¯a"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N?o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran¯a" column-label "Tipo Cobran¯a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere¯o Cobran¯a" column-label "Endere¯o Cobran¯a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Lðquido" column-label "Vl Lðquido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N?o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist«rico Padr?o" column-label "Hist«rico Padr?o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist«rico" column-label "Hist«rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran¯a" column-label "Obs Cobran¯a"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¬ncia" column-label "Sequ¬ncia"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi¯?o Pagto" column-label "Condi¯?o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¬ncia" column-label "Dias Car¬ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N?o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N?o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Crýdito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Crýdito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N?o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta¯?o" column-label "Processo Exporta¯?o"
    field ttv_log_estorn_impto_retid       as logical format "Sim/N?o" initial yes
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.


def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¬ncia Banc ria" column-label "Ag¬ncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss?o" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "Previs?o Apresent" column-label "Previs?o Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "Previs?o Crýdito" column-label "Previs?o Crýdito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/N?o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep«sito" label "Destino Cheque" column-label "Destino Cheque"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren_bco           ascending
          tta_num_cheque                   ascending.

def temp-table tt_alter_tit_acr_cobr_espec_2 no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¬ncia" column-label "Sequ¬ncia"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C«digo Cart?o" column-label "C«digo Cart?o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C«d Prý-Autoriza¯?o" column-label "C«d Prý-Autoriza¯?o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart?o" column-label "Validade Cart?o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¬ncia Banc ria" column-label "Ag¬ncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "Dðgito Cta Corrente" column-label "Dðgito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist«rico" column-label "Hist«rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/N?o" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situa¯?o Tðtulo" column-label "Situa¯?o Tðtulo"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_val_tot_sdo_tit_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Val Total Parcelas" column-label "Val Total Parcelas"
    field tta_cod_autoriz_bco_emissor      as character format "x(6)" label "Autorizacao Venda" column-label "Autorizacao Venda"
    field tta_cod_lote_origin              as character format "x(7)" label "Lote OrigVenda" column-label "Lote OrigVenda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_comis_1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
&ENDIF
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera?’o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.08" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss’o" column-label "% Comiss’o"
&ENDIF
&IF "{&emsfin_version}" >= "5.08" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% Comiss’o" column-label "% Comiss’o"
&ENDIF
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss’o" column-label "% Comis Emiss’o"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/N’o" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss’o" column-label "Tipo Comiss’o"
    field ttv_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo de Comiss’o" column-label "Tipo de Comiss’o"
    field ttv_ind_liber_pagto_comis        as character format "X(20)" initial "Nenhum" label "Lib Pagto Comis" column-label "Lib Comis"
    field ttv_ind_sit_comis_ext            as character format "X(10)" initial "Nenhum" label "Sit Comis Ext" column-label "Sit Comis Ext"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr               
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.


def temp-table tt_alter_tit_acr_impto_retid_2 no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_pais                     as character format "x(3)" label "Paðs" column-label "Paðs"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa¯?o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera¯?o"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Alðquota" column-label "Aliq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_impto_refer_tit_acr      ascending.

def temp-table tt_alter_tit_acr_iva no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_refer                    as character format "x(10)" label "Refer¬ncia" column-label "Refer¬ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¬ncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Paðs" column-label "Paðs"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa¯?o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¬ncia" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Alðquota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending.
 


def temp-table tt_alter_tit_acr_ped_vda no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_ped_vda                  ascending.


def temp-table tt_alter_tit_acr_rateio no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_ind_tip_rat_tit_acr          as character format "X(12)" label "Tipo Rateio" column-label "Tipo Rateio"
    field tta_cod_refer                    as character format "x(10)" label "Refer¬ncia" column-label "Refer¬ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¬ncia" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg«cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/N?o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Paðs" column-label "Paðs"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa¯?o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa¯?o" column-label "Dat Transac"
    index tt_relac_tit_acr               
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.
 

def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg«cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria¯?o" column-label "Tipo Apropria¯?o"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropria¯?o" column-label "Id Apropria¯?o"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    index tt_aprpdspa_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_num_id_aprop_despes_recta    ascending
    index tt_aprpdspa_token                is unique
          tta_cod_estab                    ascending
          tta_num_id_aprop_despes_recta    ascending.
 

def temp-table tt_log_erros_alter_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist?ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    index tt_relac_tit_acr               
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          ttv_num_mensagem                 ascending.

def temp-table tt_alter_tit_acr_cobr_esp_2_c no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_band                     as character format "x(10)" label "Bandeira" column-label "Bandeira"
    field tta_cod_tid                      as character format "x(10)" label "TID" column-label "TID"
    field tta_cod_terminal                 as character format "x(8)" label "Nr Terminal" column-label "Nr Terminal".
 

Def temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending.


def temp-table tt_input_estorno no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq??ncia" column-label "Seq"
    index tt_primario                      is primary
        ttv_num_seq                        ascending.     
        
def temp-table tt_log_erros_estorn_cancel no-undo
field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist?ncia"
field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
index tt_relac_tit_acr               
        tta_cod_estab                    ascending
        tta_num_id_tit_acr               ascending
        tta_num_id_movto_tit_acr         ascending
        ttv_num_mensagem                 ascending.        

def temp-table tt_tit_ap_alteracao_base_aux_3 no-undo
field ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
field ttv_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Data Transa‡Æo"
field ttv_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Altera‡Æo" label "Motivo Altera‡Æo" column-label "Motivo Altera‡Æo"
field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
field ttv_log_gera_ocor_alter_valores  as logical format "Sim/NÆo" initial no
field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
field tta_des_histor_padr              as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo Hist¢rico PadrÆo"
field tta_ind_sit_tit_ap               as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/NÆo" initial no
index tt_titap_id                    
        tta_cod_estab                    ascending
        tta_cdn_fornecedor               ascending
        tta_cod_espec_docto              ascending
        tta_cod_ser_docto                ascending
        tta_cod_tit_ap                   ascending
        tta_cod_parcela                  ascending
.
def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field ttv_ind_tip_rat                  as character format "X(08)"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_aprop_ctbl_ap         as integer format "9999999999" initial 0 label "Id Aprop Ctbl AP" column-label "Id Aprop Ctbl AP"
    index tt_aprpctba_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
          ttv_rec_tit_ap                   ascending
    .
    def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda_1              as character format "x(360)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    .
