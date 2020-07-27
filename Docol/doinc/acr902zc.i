def temp-table tt_integr_acr_renegoc no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field ttv_log_atualiza_renegoc         as logical format "Sim/NÆo" initial no
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_qtd_parc_renegoc             as decimal format ">9" initial 1 label "Qtd Parcelas" column-label "Qtd Parcelas"
    field tta_ind_vencto_renegoc           as character format "X(10)" initial "Di ria" label "Periodicidade Vencto" column-label "Vencimento"
    field tta_num_dias_vencto_renegoc      as integer format ">9" initial 0 label "Dias Vencimentto" column-label "Dias Vencimento"
    field tta_num_dia_mes_base_vencto      as integer format ">9" initial 0 label "Dia Base Vencto" column-label "Dia Base Ven"
    field tta_dat_primei_vencto_renegoc    as date format "99/99/9999" initial ? label "Primeiro Vencto" column-label "Primeiro Vencto"
    field tta_log_juros_param_estab_reaj   as logical format "Sim/NÆo" initial yes label "Consid Juros PadrÆo" column-label "Juros Pad"
    field tta_cod_indic_econ_reaj_renegoc  as character format "x(8)" label "Ind Reajuste" column-label "Öndice Reaj"
    field tta_val_perc_reaj_renegoc        as decimal format ">>9.99" decimals 2 initial 0 label "Reajuste" column-label "Reaj"
    field tta_val_acresc_parc              as decimal format ">>9.99" decimals 2 initial 0 label "Acrescimo Parcela" column-label "Acrescimo Parcela"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    field tta_log_soma_movto_cobr          as logical format "Sim/NÆo" initial no label "Soma Movtos Cobr" column-label "Soma Movtos Cobr"
    field ttv_log_bxo_estab_tit_2          as logical format "Sim/NÆo" initial no label "Liq no Estab T¡tulo" column-label "Liq no Estab T¡tulo"
    field ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a".

def temp-table tt_integr_acr_item_renegoc no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field tta_cod_estab_tit_acr            as character format "x(8)" label "Estab T¡tulo ACR" column-label "Estab T¡tulo ACR"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    index tt_rec_index                    
          ttv_rec_renegoc_acr              ascending.

def temp-table tt_integr_acr_item_renegoc_new no-undo
    field ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field ttv_rec_renegoc_acr_novo         as recid format ">>>>>>9"
    field ttv_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito PIS" column-label "Vl Cred PIS/PASEP"
    field ttv_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito COFINS" column-label "Credito COFINS"
    field ttv_val_cr_csll                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cr‚dito CSLL" column-label "Credito CSLL"
    field tta_val_base_calc_impto          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calculo Impto" column-label "Base Calculo Impto"
    field tta_log_retenc_impto_impl        as logical format "Sim/NÆo" initial no label "Ret Imposto Impl" column-label "Ret Imposto Impl"
    field tta_log_val_fix_parc             as logical format "Sim/NÆo" initial no label "Fixa Valor Parcela" column-label "Fixa Valor Parcela"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo".    

def temp-table tt_integr_acr_fiador_renegoc no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field tta_ind_testem_fiador            as character format "X(08)" label "Testem/Fiador" column-label "Testem/Fiador"
    field tta_ind_tip_pessoa               as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field ttv_rec_renegoc_acr              as recid format ">>>>>>9" initial ?
    field ttv_rec_pessoa_fisic_jurid       as recid format ">>>>>>9"
    index tt_rec_renegoc_id               
          ttv_rec_renegoc_acr              ascending.

def temp-table tt_log_erros_renegoc no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_renegoc_cobr_acr         as integer format ">>>>,>>9" initial 0 label "Num. Renegoc" column-label "Renegocia‡Æo"
    field tta_num_seq_item_renegoc_acr     as integer format ">>>>,>>9" initial 0 label "Sequˆncia Item" column-label "Sequˆncia Item"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_fiador                   as character format "x(8)" label "Fiador" column-label "Fiador"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_num_mensagem                 as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg                      as character format "x(40)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    index tt_num_mensagem                  is primary
          tta_num_mensagem                 ascending.


