define temp-table tt_integr_acr_renegoc no-undo
    field  tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field  tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field  tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field  tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field  tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field  tta_cod_cond_pagto               as character format "x(8)" label "Condi‡Æo Pagamento" column-label "Condi‡Æo Pagamento"
    field  tta_val_renegoc_cobr_acr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field  tta_num_id_renegoc_cobr_acr      as integer format ">>>>,>>9" initial 0 label "Id Renegocia‡Æo" column-label "Id Reneg"
    field  tta_val_perc_juros_renegoc       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Perc Juros" column-label "Perc Juros"
    field  tta_ind_tip_renegoc_acr          as character format "X(15)" initial "Prorroga" label "Tipo Renegocia‡Æo" column-label "Tipo Renegocia‡Æo"
    field  tta_log_renegoc_acr_estordo      as logical format "Sim/NÆo" initial no label "Reneg Estornada" column-label "Renegoc Estornada"
    field  tta_cod_indic_econ_val_pres      as character format "x(8)" label "Öndice Reajuste" column-label "Öndice Reaj"
    field  tta_val_perc_val_pres            as decimal format ">>9.99" decimals 2 initial 0 label "%" column-label "%"
    field  tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field  tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field  tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field  tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field  tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field  tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field  tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_log_consid_juros_renegoc     as logical format "Sim/NÆo" initial yes label "Considera Juros" column-label "Consid Juros"
    field  tta_log_consid_multa_renegoc     as logical format "Sim/NÆo" initial yes label "Considera Multa" column-label "Considera Multa"
    field  tta_log_consid_abat_renegoc      as logical format "Sim/NÆo" initial no label "Considera Abatimento" column-label "Consid Abatimento"
    field  tta_log_consid_desc_renegoc      as logical format "Sim/NÆo" initial no label "Considera Desconto" column-label "Consid Desconto"
    field  tta_val_perc_reaj_renegoc        as decimal format ">>9.99" decimals 2 initial 0 label "Reajuste" column-label "Reaj"
    field  tta_val_juros_renegoc_calcul     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Calculado" column-label "Juros Calc"
    field  tta_val_juros_renegoc_infor      as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Informado" column-label "Juros Inform"
    field  tta_val_multa_renegoc_calcul     as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Calculada" column-label "Multa Calcul"
    field  tta_val_multa_renegoc_infor      as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Informada" column-label "Multa Informada"
    field  tta_val_tot_reaj_renegoc         as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Reajuste" column-label "Total Reajuste"
    field  tta_val_tot_ajust_renegoc        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Ajuste" column-label "Total Ajuste"
    field  tta_ind_sit_renegoc_acr          as character format "X(10)" initial "Pendente" label "Situa‡Æo" column-label "Situa‡Æo"
    field  tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field  tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field  tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field  tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field  tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field  tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field  tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field  tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field  tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field  tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field  tta_ind_base_calc_reaj           as character format "X(17)" initial "Principal" label "Base Calculo" column-label "Base Calculo"
    field  tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field  tta_qtd_parc_renegoc             as decimal format ">9" initial 1 label "Qtd Parcelas" column-label "Qtd Parcelas"
    field  tta_ind_vencto_renegoc           as character format "X(10)" initial "Di ria" label "Periodicidade Vencto" column-label "Vencimento"
    field  tta_num_dia_mes_base_vencto      as integer format ">9" initial 0 label "Dia Base Vencto" column-label "Dia Base Ven"
    field  tta_num_dias_vencto_renegoc      as integer format ">9" initial 0 label "Dias Vencimentto" column-label "Dias Vencimento"
    field  tta_cod_indic_econ_reaj_renegoc  as character format "x(8)" label "Ind Reajuste" column-label "Öndice Reaj"
    field  tta_dat_primei_vencto_renegoc    as date format "99/99/9999" initial ? label "Primeiro Vencto" column-label "Primeiro Vencto"
    field  tta_ind_calc_juros_desc          as character format "X(08)" label "Calculo Juros" column-label "Calculo Juros"
    field  tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field  tta_log_juros_param_estab_reaj   as logical format "Sim/NÆo" initial yes label "Consid Juros PadrÆo" column-label "Juros Pad"
    field  ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field  ttv_log_atualiza_salario_admit   as logical format "Sim/NÆo" initial No
    field  ttv_log_atualiza_renegoc         as logical format "Sim/NÆo" initial no
    field  ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
    field  tta_log_soma_movto_cobr          as logical format "Sim/NÆo" initial no label "Soma Movtos Cobr" column-label "Soma Movtos Cobr"
    field  tta_val_acresc_parc              as decimal format ">>9.99" decimals 2 initial 0 label "Acrescimo Parcela" column-label "Acrescimo Parcela"
        index tt_rngccr_id                     is primary unique
              tta_cod_estab                    ascending
              tta_num_renegoc_cobr_acr         ascending.

def temp-table tt_integr_acr_item_renegoc no-undo
    field  tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field  tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field  tta_cod_estab_tit_acr            as character format "x(8)" label "Estab T¡tulo ACR" column-label "Estab T¡tulo ACR"
    field  tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field  tta_dat_novo_vencto_tit_acr      as date format "99/99/9999" initial ? label "Novo Vencimento" column-label "Novo Vencimento"
    field  tta_val_juros_renegoc_tit_acr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field  tta_val_multa_renegoc_tit_acr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field  tta_val_juros_renegoc_calcul     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Juros Calculado" column-label "Juros Calc"
    field  tta_val_multa_renegoc_calcul     as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Multa Calculada" column-label "Multa Calcul"
    field  tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field  tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field  tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field  tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field  tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field  tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field  ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
        index tt_rec_index                    
              ttv_rec_renegoc_acr              ascending.

def temp-table tt_integr_acr_fiador_renegoc no-undo
    field  tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field  tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field  tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field  tta_ind_testem_fiador            as character format "X(08)" label "Testem/Fiador" column-label "Testem/Fiador"
    field  tta_ind_tip_pessoa               as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field  tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field  tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field  tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field  tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field  tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field  tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field  tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field  tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field  tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field  tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field  ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field  ttv_rec_pessoa_fisic_jurid       as recid format ">>>>>>9"
        index tt_rec_renegoc_id               
              ttv_rec_renegoc_acr              ascending.

def temp-table tt_pessoa_fisic_integr no-undo
    field  tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field  tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field  tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field  tta_cod_id_estad_fisic           as character format "x(20)" initial ? label "ID Estadual F¡sica" column-label "ID Estadual F¡sica"
    field  tta_cod_orgao_emis_id_estad      as character format "x(10)" label "àrgÆo Emissor" column-label "àrgÆo Emissor"
    field  tta_cod_unid_federac_emis_estad  as character format "x(3)" label "Estado EmissÆo" column-label "UF Emis"
    field  tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field  tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field  tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field  tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field  tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field  tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field  tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field  tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field  tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field  tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field  tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field  tta_cod_ramal                    as character format "x(7)" label "Ramal" column-label "Ramal"
    field  tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field  tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field  tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field  tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field  tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field  tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field  tta_dat_nasc_pessoa_fisic        as date format "99/99/9999" initial ? label "Nascimento" column-label "Data Nasc"
    field  ttv_cod_pais_ext_nasc            as character format "x(20)" label "Pa¡s Ext Nascimento" column-label "Pa¡s Ext Nascimento"
    field  ttv_cod_pais_nasc                as character format "x(3)" label "Pa¡s Nascimento" column-label "Pa¡s Nasc"
    field  tta_cod_unid_federac_nasc        as character format "x(3)" label "Estado Nascimento" column-label "UF Nasc"
    field  tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field  tta_nom_mae_pessoa               as character format "x(40)" label "MÆe Pessoa" column-label "MÆe Pes"
    field  tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field  tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field  ttv_num_tip_operac               as integer format ">9"
    field  ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
        index tt_pssfsca_id                    is primary unique
              tta_num_pessoa_fisic             ascending
              tta_cod_id_feder                 ascending
              tta_cod_pais_ext                 ascending
        index tt_pssfsca_identpes             
              tta_nom_pessoa                   ascending
              tta_cod_id_estad_fisic           ascending
              tta_cod_unid_federac_emis_estad  ascending
              tta_dat_nasc_pessoa_fisic        ascending
              tta_nom_mae_pessoa               ascending
        index tt_pssfsca_nom_pessoa_word      
              tta_nom_pessoa                   ascending
        index tt_pssfsca_unid_federac         
              tta_cod_pais_ext                 ascending
              tta_cod_unid_federac             ascending.

def temp-table tt_pessoa_jurid_integr no-undo
    field  tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field  tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field  tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field  tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field  tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field  tta_cod_id_previd_social         as character format "x(20)" label "Id Previdˆncia" column-label "Id Previdˆncia"
    field  tta_log_fins_lucrat              as logical format "Sim/NÆo" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
    field  tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    field  tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field  tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field  tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field  tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field  tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field  tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field  tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field  tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field  tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field  tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field  tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field  tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field  tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field  tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field  tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field  tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field  tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field  tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field  tta_ind_tip_pessoa_jurid         as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field  tta_ind_tip_capit_pessoa_jurid   as character format "X(13)" label "Tipo Capital" column-label "Tipo Capital"
    field  tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field  tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field  ttv_num_tip_operac               as integer format ">9"
    field  tta_num_pessoa_jurid_cobr        as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica Cobr" column-label "Pessoa Jur¡dica Cobr"
    field  tta_nom_ender_cobr               as character format "x(40)" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field  tta_nom_ender_compl_cobr         as character format "x(10)" label "Complemento" column-label "Complemento"
    field  tta_nom_bairro_cobr              as character format "x(20)" label "Bairro Cobran‡a" column-label "Bairro Cobran‡a"
    field  tta_nom_cidad_cobr               as character format "x(32)" label "Cidade Cobran‡a" column-label "Cidade Cobran‡a"
    field  tta_nom_condad_cobr              as character format "x(32)" label "Condado Cobran‡a" column-label "Condado Cobran‡a"
    field  tta_cod_unid_federac_cobr        as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field  ttv_cod_pais_ext_cob             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field  ttv_cod_pais_cobr                as character format "x(3)" label "Pa¡s Cobran‡a" column-label "Pa¡s Cobran‡a"
    field  tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran‡a" column-label "CEP Cobran‡a"
    field  tta_cod_cx_post_cobr             as character format "x(20)" label "Caixa Postal Cobran‡" column-label "Caixa Postal Cobran‡"
    field  tta_num_pessoa_jurid_pagto       as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jurid Pagto" column-label "Pessoa Jurid Pagto"
    field  tta_nom_ender_pagto              as character format "x(40)" label "Endere‡o Pagamento" column-label "Endere‡o Pagamento"
    field  tta_nom_ender_compl_pagto        as character format "x(10)" label "Complemento" column-label "Complemento"
    field  tta_nom_bairro_pagto             as character format "x(20)" label "Bairro Pagamento" column-label "Bairro Pagamento"
    field  tta_nom_cidad_pagto              as character format "x(32)" label "Cidade Pagamento" column-label "Cidade Pagamento"
    field  tta_nom_condad_pagto             as character format "x(32)" label "Condado Pagamento" column-label "Condado Pagamento"
    field  tta_cod_unid_federac_pagto       as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field  ttv_cod_pais_ext_pag             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field  ttv_cod_pais_pagto               as character format "x(3)" label "Pa¡s Pagamento" column-label "Pa¡s Pagamento"
    field  tta_cod_cep_pagto                as character format "x(20)" label "CEP Pagamento" column-label "CEP Pagamento"
    field  tta_cod_cx_post_pagto            as character format "x(20)" label "Caixa Postal Pagamen" column-label "Caixa Postal Pagamen"
    field  ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
        index tt_pssjrda_cobranca             
              tta_num_pessoa_jurid_cobr        ascending
        index tt_pssjrda_id                    is primary unique
              tta_num_pessoa_jurid             ascending
              tta_cod_id_feder                 ascending
              tta_cod_pais_ext                 ascending
        index tt_pssjrda_id_previd_social     
              tta_cod_pais_ext                 ascending
              tta_cod_id_previd_social         ascending
        index tt_pssjrda_matriz               
              tta_num_pessoa_jurid_matriz      ascending
        index tt_pssjrda_nom_pessoa_word      
              tta_nom_pessoa                   ascending
        index tt_pssjrda_pagto                
              tta_num_pessoa_jurid_pagto       ascending
        index tt_pssjrda_razao_social         
              tta_nom_pessoa                   ascending
        index tt_pssjrda_unid_federac         
              tta_cod_pais_ext                 ascending
              tta_cod_unid_federac             ascending.

def temp-table tt_log_erros_renegoc_acr no-undo
    field  tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field  tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field  tta_num_seq_item_renegoc_acr     as integer format ">>>>,>>9" initial 0 label "Sequˆncia Item" column-label "Sequˆncia Item"
    field  tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field  tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field  tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field  tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field  tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field  tta_cod_fiador                   as character format "x(8)" label "Fiador" column-label "Fiador"
    field  tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field  tta_num_mensagem                 as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field  ttv_des_msg                      as character format "x(40)".
