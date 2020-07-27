

    
/* include de controle de versÊo */
{include/i-prgvrs.i ESPACR001 1.00.00.001}
/* definiôÊo das temp-tables para recebimento de parÏmetros */
/******Definicao de Temp-tables***********/


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD dt-ini               AS date
    FIELD dt-fim               AS date
    FIELD estab-ini        AS CHAR
    FIELD estab-fim                AS CHAR
    FIELD esp-docto-ini    AS CHar
    FIELD esp-docto-fim    AS char
    FIELD DOcto-ini        AS char
    FIELD DOcto-fim        AS char
    FIELD NOme-abrev-ini   AS CHAR
    FIELD NOme-abrev-fim   AS char
    FIELD ser-docto-ini    AS CHAR
    FIELD ser-docto-fim    AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.
/* Transfer Definitions */



def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.


def temp-table tt_alter_tit_acr_base_5 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T­tulo" column-label "Saldo T­tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" initial "Altera»’o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag¼ncia Cobran»a" column-label "Ag¼ncia Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T­tulo Banco" column-label "Num T­tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida»’o" column-label "Prev Liquida»’o"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi»’o Cobran»a" column-label "Cond Cobran»a"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N’o" initial no label "Credito com Garantia" column-label "Cred Garant"
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
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran»a" column-label "Tipo Cobran»a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L­quido" column-label "Vl L­quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/N’o" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran»a" column-label "Obs Cobran»a"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Sequ¼ncia"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>,>>>,>>9" initial 0 label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" initial "0" label "Condi»’o Pagto" column-label "Condi»’o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" initial today label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N’o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N’o" initial no
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito COFINS" column-label "Credito COFINS"
    field tta_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr²dito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/N’o" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta»’o" column-label "Processo Exporta»’o"
    field ttv_log_estorn_impto_retid       as logical format "Sim/N’o" initial yes
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.


def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Banc ria" column-label "Ag¼ncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss’o" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "Previs’o Apresent" column-label "Previs’o Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "Previs’o Cr²dito" column-label "Previs’o Cr²dito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/N’o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep½sito" label "Destino Cheque" column-label "Destino Cheque"
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
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Sequ¼ncia"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C½digo Cart’o" column-label "C½digo Cart’o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C½d Pr²-Autoriza»’o" column-label "C½d Pr²-Autoriza»’o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart’o" column-label "Validade Cart’o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Banc ria" column-label "Ag¼ncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/N’o" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situa»’o T­tulo" column-label "Situa»’o T­tulo"
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
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.08" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% ComissÆo" column-label "% ComissÆo"
&ENDIF
&IF "{&emsfin_version}" >= "5.08" AND "{&emsfin_version}" < "9.99" &THEN
    field tta_val_perc_comis_repres        as decimal format ">>9.9999" decimals 4 initial 0 label "% ComissÆo" column-label "% ComissÆo"
&ENDIF
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis EmissÆo" column-label "% Comis EmissÆo"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/NÆo" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo ComissÆo" column-label "Tipo ComissÆo"
    field ttv_ind_tip_comis_ext            as character format "X(15)" initial "Nenhum" label "Tipo de ComissÆo" column-label "Tipo de ComissÆo"
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
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera»’o"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Al­quota" column-label "Aliq"
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
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 INITIAL 0.00 label "Al­quota" column-label "Aliq"
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
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/N’o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    index tt_relac_tit_acr               
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.
 

def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria»’o" column-label "Tipo Apropria»’o"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropria»’o" column-label "Id Apropria»’o"
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
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
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

DEFINE BUFFER b-repres_tit_acr FOR repres_tit_acr.
 
def var v_hdl_program as Handle no-undo.
DEF VAR V_COD_REFER AS CHAR NO-UNDO.
DEF VAR h-prog AS HANDLE NO-UNDO.
DEF VAR i-tot AS INTEGER.


DEFINE STREAM f_1.
DEFINE STREAM f_2.

	
DEFINE STREAM s_1.


{include/i-rpvar.i}






/* include padr’o para output de relat½rios */
{include/i-rpout.i &STREAM="stream str-rp"}
/* include com a definiÎ’o da frame de cabeÎalho e rodap' */
/* bloco principal do programa */
assign c-programa 	= "ESPACR001"
	c-versao	= "1.00"
	c-revisao	= ".00.000"
	c-empresa 	= "Fobras"
	c-sistema	= "ACR"
	c-titulo-relat = "Comissoes".
view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.
    
     
FORM HEADER
    SKIP(1)
    "Estab   Emitente                 Esp   Serie   Docto          Parcela  Observacao "
    "----    -----------------------  ----  -----   -------------- ------   -----------"
    SKIP(1)
    WITH FRAME f-cabec NO-ATTR NO-BOX PAGE-TOP STREAM-IO WIDTH 120 NO-LABEL.
 
FIND FIRST tt-param NO-ERROR.


RUN utp/ut-perc.p PERSISTENT SET h-prog.
FOR EACH fat-duplic NO-LOCK WHERE fat-duplic.dt-emissao >= tt-param.dt-ini
                            AND   fat-duplic.dt-emissao <= tt-param.dt-fim
                            AND   fat-duplic.cod-estabel >= tt-param.estab-ini
                            AND   fat-duplic.cod-estabel <= tt-param.estab-fim
                            AND   fat-duplic.cod-esp     >= tt-param.esp-docto-ini
                            AND   fat-duplic.cod-esp     <= tt-param.esp-docto-fim
                            AND   fat-duplic.nr-fatura   >= tt-param.DOcto-ini
                            AND   fat-duplic.nr-fatura   <= tt-param.DOcto-fim
                            AND   fat-duplic.nome-ab-cli >= tt-param.NOme-abrev-ini
                            AND   fat-duplic.nome-ab-cli <= tt-param.NOme-abrev-fim
                            AND   fat-duplic.serie       >= tt-param.ser-docto-ini
                            AND   fat-duplic.serie       <= tt-param.ser-docto-fim:
ASSIGN i-tot = i-tot + 1.
END.


RUN pi-inicializar IN h-prog (INPUT "Verificando comissoes", i-tot).
FOR EACH fat-duplic NO-LOCK WHERE fat-duplic.dt-emissao >= tt-param.dt-ini
                            AND   fat-duplic.dt-emissao <= tt-param.dt-fim
                            AND   fat-duplic.cod-estabel >= tt-param.estab-ini
                            AND   fat-duplic.cod-estabel <= tt-param.estab-fim
                            AND   fat-duplic.cod-esp     >= tt-param.esp-docto-ini
                            AND   fat-duplic.cod-esp     <= tt-param.esp-docto-fim
                            AND   fat-duplic.nr-fatura   >= tt-param.DOcto-ini
                            AND   fat-duplic.nr-fatura   <= tt-param.DOcto-fim
                            AND   fat-duplic.nome-ab-cli >= tt-param.NOme-abrev-ini
                            AND   fat-duplic.nome-ab-cli <= tt-param.NOme-abrev-fim
                            AND   fat-duplic.serie       >= tt-param.ser-docto-ini
                            AND   fat-duplic.serie       <= tt-param.ser-docto-fim:

RUN pi-acompanhar IN h-prog.
FIND FIRST tit_acr WHERE tit_acr.cod_estab =       fat-duplic.cod-estabel
                   AND   tit_acr.cod_ser_docto =   fat-duplic.serie
                   AND   tit_acr.cod_parcela =     fat-duplic.parcela
                   AND   tit_acr.cod_tit_acr =     fat-duplic.nr-fatura
                   AND   tit_acr.cod_espec_docto = fat-duplic.cod-esp
                   AND   tit_acr.nom_abrev       = fat-duplic.nome-ab-cli NO-ERROR.

IF AVAIL tit_acr THEN DO:

    FIND FIRST repres_tit_acr       NO-LOCK WHERE repres_tit_acr.cod_empresa = tit_acr.cod_empresa
                                            AND  repres_tit_acr.cod_estab   = tit_acr.cod_estab
                                            AND  repres_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                                            NO-ERROR.

    FIND FIRST repres_financ NO-LOCK WHERE repres_financ.cod_empresa = repres_tit_acr.cod_empresa
                                     AND   repres_financ.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.


        run pi_retorna_sugestao_referencia (Input "T" /*l_l*/,
                                        Input today,
                                        output v_cod_refer) /*pi_retorna_sugestao_referencia*/.

        CREATE b-repres_tit_acr.
        ASSIGN b-repres_tit_acr.cod_empresa                 = repres_tit_acr.cod_empresa
               b-repres_tit_acr.cod_estab                   = repres_tit_acr.cod_estab
               b-repres_tit_acr.cod_comis_vda_estab         = repres_tit_acr.cod_comis_vda_estab
               b-repres_tit_acr.cod_espec_docto             = repres_tit_acr.cod_espec_docto
               b-repres_tit_acr.num_id_tit_acr              = repres_tit_acr.num_id_tit_acr
               b-repres_tit_acr.cdn_repres                  = repres_financ.cdn_repres_indir
               b-repres_tit_acr.cdn_cliente                 = repres_tit_acr.cdn_cliente
               b-repres_tit_acr.val_perc_comis_repres       = repres_financ.val_perc_comis_repres_indir
               b-repres_tit_acr.val_perc_comis_repres_emis  = repres_financ.val_perc_comis_repres_emis
               b-repres_tit_acr.log_comis_repres_proporc    = repres_tit_acr.log_comis_repres_proporc
               b-repres_tit_acr.ind_sit_comis_vda           = repres_tit_acr.ind_sit_comis_vda
               b-repres_tit_acr.ind_tip_comis               = repres_tit_acr.ind_tip_comis
               b-repres_tit_acr.ind_forma_pagto_comis       = repres_tit_acr.ind_forma_pagto_comis
               b-repres_tit_acr.log_sdo_tit_acr             = repres_tit_acr.log_sdo_tit_acr
               b-repres_tit_acr.dat_ult_liquidac_tit_acr    = repres_tit_acr.dat_ult_liquidac_tit_acr
               b-repres_tit_acr.val_base_calc_comis         = repres_tit_acr.val_base_calc_comis.

CREATE tt_alter_tit_acr_base_5.
ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                              = tit_acr.cod_estab
       tt_alter_tit_acr_base_5.tta_num_id_tit_acr                         = tit_acr.num_id_tit_acr
       tt_alter_tit_acr_base_5.tta_dat_transacao                          = TODAY   
       tt_alter_tit_acr_base_5.tta_cod_refer                              = v_cod_refer
       tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr                        = tit_acr.val_sdo_tit_acr
       tt_alter_tit_acr_base_5.tta_cod_portador                           = tit_acr.cod_portador
       tt_alter_tit_acr_base_5.tta_cod_cart_bcia                          = tit_acr.cod_cart_bcia
       tt_alter_tit_acr_base_5.tta_dat_emis_docto                         = tit_acr.dat_emis_docto
       tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr                     = tit_acr.dat_vencto_tit_acr
       tt_alter_tit_acr_base_5.tta_dat_prev_liquidac                      = tit_acr.dat_prev_liquidac
       tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr                      = tit_acr.dat_fluxo_tit_acr
       tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr                        = tit_acr.ind_sit_tit_acr
       tt_alter_tit_acr_base_5.tta_cod_cond_cobr                          = tit_acr.cod_cond_cobr
       tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr                       = tit_acr.dat_abat_tit_acr
       tt_alter_tit_acr_base_5.tta_val_perc_abat_acr                      = tit_acr.val_perc_abat_acr
       tt_alter_tit_acr_base_5.tta_val_abat_tit_acr                       = tit_acr.val_abat_tit_acr
       tt_alter_tit_acr_base_5.tta_dat_desconto                           = tit_acr.dat_desconto
       tt_alter_tit_acr_base_5.tta_val_perc_desc                          = tit_acr.val_perc_desc
       tt_alter_tit_acr_base_5.tta_val_desc_tit_acr                       = tit_acr.val_desc_tit_acr
       tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr              = tit_acr.qtd_dias_carenc_juros_acr
       tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso              = tit_acr.val_perc_juros_dia_atraso
       tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr              = tit_acr.qtd_dias_carenc_multa_acr
       tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso                  = tit_acr.val_perc_multa_atraso
       tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr                       = tit_acr.ind_tip_cobr_acr
       tt_alter_tit_acr_base_5.tta_ind_ender_cobr                         = tit_acr.ind_ender_cobr
       tt_alter_tit_acr_base_5.tta_nom_abrev_contat                       = tit_acr.nom_abrev_contat
       tt_alter_tit_acr_base_5.tta_val_liq_tit_acr                        = tit_acr.val_liq_tit_acr
       tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo                    = tit_acr.log_tit_acr_destndo
       tt_alter_tit_acr_base_5.tta_cdn_repres                             = tit_acr.cdn_repres
       tt_alter_tit_acr_base_5.ttv_log_vendor                             = NO
       tt_alter_tit_acr_base_5.ttv_num_planilha_vendor                    = 0
       tt_alter_tit_acr_base_5.ttv_cod_cond_pagto_vendor                  = "0"
       tt_alter_tit_acr_base_5.ttv_val_cotac_tax_vendor_clien             = 0
       tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor                 = ?
       tt_alter_tit_acr_base_5.ttv_qti_dias_carenc_fechto                 = 0.

    CREATE tt_alter_tit_acr_comis_1.
    ASSIGN tt_alter_tit_acr_comis_1.tta_cod_empresa                         = tit_acr.cod_empresa
           tt_alter_tit_acr_comis_1.tta_cod_estab                           = tit_acr.cod_estab
           tt_alter_tit_acr_comis_1.tta_num_id_tit_acr                      = tit_acr.num_id_tit_acr
           tt_alter_tit_acr_comis_1.ttv_num_tip_operac                      = 0
           tt_alter_tit_acr_comis_1.tta_cdn_repres                          = repres_financ.cdn_repres_indir
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_repres               = repres_financ.val_perc_comis_repres_indir
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_repres_emis          = repres_tit_acr.val_perc_comis_repres_emis
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_abat                 = 100
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_desc                 = 100
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_juros                = repres_tit_acr.val_perc_comis_juros
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_multa                = repres_tit_acr.val_perc_comis_multa
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_acerto_val           = repres_tit_acr.val_perc_comis_acerto_val
           tt_alter_tit_acr_comis_1.tta_log_comis_repres_proporc            = repres_tit_acr.log_comis_repres_proporc
           tt_alter_tit_acr_comis_1.tta_ind_tip_comis                       = repres_tit_acr.ind_tip_comis
           tt_alter_tit_acr_comis_1.ttv_ind_tip_comis_ext                   = repres_tit_acr.ind_tip_comis_ext
           tt_alter_tit_acr_comis_1.ttv_ind_liber_pagto_comis               = repres_tit_acr.ind_liber_pagto_comis
           tt_alter_tit_acr_comis_1.ttv_ind_sit_comis_ext                   = repres_tit_acr.ind_sit_comis_ext
           tt_alter_tit_acr_comis_1.tta_val_base_calc_impto                 = 0
           .

    CREATE tt_alter_tit_acr_comis_1.
    ASSIGN tt_alter_tit_acr_comis_1.tta_cod_empresa                         = tit_acr.cod_empresa
           tt_alter_tit_acr_comis_1.tta_cod_estab                           = tit_acr.cod_estab
           tt_alter_tit_acr_comis_1.tta_num_id_tit_acr                      = tit_acr.num_id_tit_acr
           tt_alter_tit_acr_comis_1.ttv_num_tip_operac                      = 0
           tt_alter_tit_acr_comis_1.tta_cdn_repres                          = repres_tit_acr.cdn_repres
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_repres               = repres_tit_acr.val_perc_comis_repres
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_repres_emis          = repres_tit_acr.val_perc_comis_repres_emis
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_abat                 = 100
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_desc                 = 100
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_juros                = repres_tit_acr.val_perc_comis_juros
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_multa                = repres_tit_acr.val_perc_comis_multa
           tt_alter_tit_acr_comis_1.tta_val_perc_comis_acerto_val           = repres_tit_acr.val_perc_comis_acerto_val
           tt_alter_tit_acr_comis_1.tta_log_comis_repres_proporc            = repres_tit_acr.log_comis_repres_proporc
           tt_alter_tit_acr_comis_1.tta_ind_tip_comis                       = repres_tit_acr.ind_tip_comis
           tt_alter_tit_acr_comis_1.ttv_ind_tip_comis_ext                   = repres_tit_acr.ind_tip_comis_ext
           tt_alter_tit_acr_comis_1.ttv_ind_liber_pagto_comis               = repres_tit_acr.ind_liber_pagto_comis
           tt_alter_tit_acr_comis_1.ttv_ind_sit_comis_ext                   = repres_tit_acr.ind_sit_comis_ext
           tt_alter_tit_acr_comis_1.tta_val_base_calc_impto                 = 0
           .

  END.
END.
RUN pi-finalizar IN h-prog.



run prgfin/acr/acr711zv.py persistent set v_hdl_program.
 
run pi_main_code_integr_acr_alter_tit_acr_novo_14 in v_hdl_program
                                            (Input  14,
                                             Input  table tt_alter_tit_acr_base_5,
                                             Input  table tt_alter_tit_acr_rateio,
                                             Input  table tt_alter_tit_acr_ped_vda,
                                             Input  table tt_alter_tit_acr_comis_1,
                                             Input  table tt_alter_tit_acr_cheq,
                                             Input  table tt_alter_tit_acr_iva,
                                             Input  table tt_alter_tit_acr_impto_retid_2,                                                     
                                             Input  table tt_alter_tit_acr_cobr_espec_2,
                                             Input  table tt_alter_tit_acr_rat_desp_rec,
                                             Output table tt_log_erros_alter_tit_acr,
                                             Input  NO,
                                             Input  table tt_alter_tit_acr_cobr_esp_2_c,
                                             Input  table tt_params_generic_api).
 

Delete procedure v_hdl_program.



FIND FIRST   tt_log_erros_alter_tit_acr NO-ERROR.

IF AVAIL tt_log_erros_alter_tit_acr THEN DO:

    FOR EACH  tt_log_erros_alter_tit_acr:
         
        FIND FIRST tit_acr NO-LOCK WHERE tit_acr.num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
                                   AND   tit_acr.cod_estab      = tt_log_erros_alter_tit_acr.tta_cod_estab NO-ERROR.
        


 PUT STREAM str-rp  tt_log_erros_alter_tit_acr.tta_cod_estab AT 1 FORMAT "x(3)"
                    tit_acr.nom_abrev AT 9 FORMAT "x(20)"
                    tit_acr.cod_espec_docto AT 35 FORMAT "x(3)"
                    tit_acr.cod_ser_docto   AT 41 FORMAT "x(3)"
                    tit_acr.cod_tit_acr     AT 49 FORMAT "x(8)"
                    tit_acr.cod_parcela     AT 66 FORMAT "x(3)"
                    tt_log_erros_alter_tit_acr.ttv_des_msg_erro AT 75 FORMAT "x(60)"
     SKIP.

    END.

END.

IF NOT AVAIL tt_log_erros_alter_tit_acr THEN DO:

    FOR EACH tt_alter_tit_acr_base_5:

        FIND FIRST tit_acr NO-LOCK WHERE tit_acr.num_id_tit_acr =  tt_alter_tit_acr_base_5.tta_num_id_tit_acr 
                                   AND   tit_acr.cod_estab      =  tt_alter_tit_acr_base_5.tta_cod_estab NO-ERROR.

        PUT STREAM str-rp tit_acr.cod_estab AT 1 FORMAT "x(3)"
                          tit_acr.nom_abrev AT 9 FORMAT "x(20)"
                          tit_acr.cod_espec_docto AT 35 FORMAT "x(3)"
                          tit_acr.cod_ser_docto   AT 41 FORMAT "x(3)"
                          tit_acr.cod_tit_acr     AT 49 FORMAT "x(8)"
                          tit_acr.cod_parcela     AT 66 FORMAT "x(3)"
                          "Alterado com sucesso"  AT 75 FORMAT "x(20)"
            SKIP.
    END.
END.

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

