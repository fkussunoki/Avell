/************************************************************************************************************
** Include: dcr015rp.i
**  Fun‡Æo: Baixar T¡tulos
************************************************************************************************************/

IF FIRST-OF(tt-lp.cod_estab) THEN DO:
   FOR EACH tt_integr_acr_lote_impl:        DELETE tt_integr_acr_lote_impl.        END.
   FOR EACH tt_integr_acr_item_lote_impl_3: DELETE tt_integr_acr_item_lote_impl_3. END.
   FOR EACH tt_integr_acr_aprop_ctbl_pend:  DELETE tt_integr_acr_aprop_ctbl_pend.  END.
   FOR EACH tt_integr_acr_repres_pend.      DELETE tt_integr_acr_repres_pend.      END.
   FOR EACH tt_log_erros_atualiz:           DELETE tt_log_erros_atualiz.           END.
   
   CREATE tt_integr_acr_lote_impl. 
   ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa                = c-cod-empresa
          tt_integr_acr_lote_impl.tta_cod_estab                  = tt-lp.cod_estab
          tt_integr_acr_lote_impl.tta_cod_refer                  = {1} + STRING(MONTH(dat-base),'99') + STRING(YEAR(dat-base))
          tt_integr_acr_lote_impl.tta_dat_transacao              = dat-liquidac
          tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr  = 0 
          tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr = 0
          tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr           = "Normal"
          v_rec_lote                                             = RECID(tt_integr_acr_lote_impl)
          i-sequencia                                            = 0
          l-erro                                                 = NO.

END.

FIND FIRST tit_acr OF tt-lp NO-LOCK NO-ERROR.

IF NOT AVAIL tit_acr THEN DO:
   DISP tt-lp.
   NEXT.
END.

FIND FIRST val_tit_acr    OF tit_acr NO-LOCK NO-ERROR.
FIND FIRST movto_tit_acr  OF tit_acr NO-LOCK NO-ERROR.
FIND FIRST aprop_ctbl_acr OF movto_tit_acr NO-LOCK NO-ERROR.

ASSIGN i-sequencia = i-sequencia + 10.

CREATE tt_integr_acr_item_lote_impl_3.
ASSIGN tt_integr_acr_item_lote_impl_3.ttv_rec_lote_impl_tit_acr       = v_rec_lote 
       tt_integr_acr_item_lote_impl_3.tta_num_seq_refer              = i-sequencia
       tt_integr_acr_item_lote_impl_3.tta_cdn_cliente                = tit_acr.cdn_cliente   
       tt_integr_acr_item_lote_impl_3.tta_cod_espec_docto            = tt-lp.cod_espec_doc
       tt_integr_acr_item_lote_impl_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
       tt_integr_acr_item_lote_impl_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
       tt_integr_acr_item_lote_impl_3.tta_cod_parcela                = tit_acr.cod_parcela
       tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ_ext       = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ           = 'Corrente'
       tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ_ext       = '' 
       tt_integr_acr_item_lote_impl_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
       tt_integr_acr_item_lote_impl_3.tta_cod_portador               = tit_acr.cod_portador
       tt_integr_acr_item_lote_impl_3.tta_cod_portad_ext             = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_cart_bcia              = tit_acr.cod_cart_bcia
       tt_integr_acr_item_lote_impl_3.tta_cdn_repres                 = tit_acr.cdn_repres
       tt_integr_acr_item_lote_impl_3.tta_dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
       tt_integr_acr_item_lote_impl_3.tta_dat_prev_liquidac          = tit_acr.dat_prev_liquidac
       tt_integr_acr_item_lote_impl_3.tta_dat_desconto               = ?
       tt_integr_acr_item_lote_impl_3.tta_dat_emis_docto             = tit_acr.dat_emis_docto
       tt_integr_acr_item_lote_impl_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
       tt_integr_acr_item_lote_impl_3.tta_val_desconto               = 0  
       tt_integr_acr_item_lote_impl_3.tta_val_perc_desc              = 0 /* tit_acr.val_perc_desc - Causa Problema 5.06 se for informado sem data de desconto */
       tt_integr_acr_item_lote_impl_3.tta_val_perc_juros_dia_atraso  = tit_acr.val_perc_juros_dia_atraso 
       tt_integr_acr_item_lote_impl_3.tta_des_text_histor            = 'Lucros e Perdas ' + tit_acr.cod_estab + '-' + tit_acr.cod_espec_docto + '-' + tit_acr.cod_ser_docto + '-' + tit_acr.cod_tit_acr + '-' + tit_acr.cod_parcela
       tt_integr_acr_item_lote_impl_3.tta_cod_instruc_bcia_1_movto   = tit_acr.cod_instruc_bcia_1_acr 
       tt_integr_acr_item_lote_impl_3.tta_cod_instruc_bcia_2_movto   = tit_acr.cod_instruc_bcia_2_acr
       tt_integr_acr_item_lote_impl_3.tta_qtd_dias_carenc_juros_acr  = tit_acr.qtd_dias_carenc_juros_acr 
       tt_integr_acr_item_lote_impl_3.tta_val_liq_tit_acr            = tit_acr.val_liq_tit_acr * tit_acr.val_sdo_tit_acr / tit_acr.val_origin_tit_acr
       tt_integr_acr_item_lote_impl_3.tta_ind_tip_espec_docto        = tit_acr.ind_tip_espec_docto
       tt_integr_acr_item_lote_impl_3.tta_cod_agenc_cobr_bcia        = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_tit_acr_bco            = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_cartcred               = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_mes_ano_valid_cartao   = ''
       tt_integr_acr_item_lote_impl_3.tta_dat_compra_cartao_cr       = ?
       tt_integr_acr_item_lote_impl_3.tta_cod_conces_telef           = ''
       tt_integr_acr_item_lote_impl_3.tta_num_ddd_localid_conces     = 0
       tt_integr_acr_item_lote_impl_3.tta_num_prefix_localid_conces  = 0
       tt_integr_acr_item_lote_impl_3.tta_num_milhar_localid_conces  = 0
       tt_integr_acr_item_lote_impl_3.tta_cod_banco                  = tit_acr.cod_banco    
       tt_integr_acr_item_lote_impl_3.tta_cod_agenc_bcia             = tit_acr.cod_agenc_bcia
       tt_integr_acr_item_lote_impl_3.tta_cod_cta_corren_bco         = tit_acr.cod_cta_corren_bco 
       tt_integr_acr_item_lote_impl_3.tta_cod_digito_cta_corren      = tit_acr.cod_digito_cta_corren
       tt_integr_acr_item_lote_impl_3.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_3)
       tt_integr_acr_item_lote_impl_3.tta_cod_motiv_movto_tit_acr    = ''
       tt_integr_acr_item_lote_impl_3.tta_log_liquidac_autom         = NO
       tt_integr_acr_item_lote_impl_3.tta_cod_cartcred               = ''
       tt_integr_acr_item_lote_impl_3.tta_cod_mes_ano_valid_cartao   = ''
       tt_integr_acr_item_lote_impl_3.ttv_cod_comprov_vda            = ''
       tt_integr_acr_item_lote_impl_3.ttv_num_parc_cartcred          = 0.

/* Apropria‡Æo cont bil do t¡tulo  */
CREATE tt_integr_acr_aprop_ctbl_pend. 
ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_3) 
       tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = {2}
       tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = val_tit_acr.cod_tip_fluxo_financ 
       tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tit_acr.val_sdo_tit_acr
       tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = aprop_ctbl_acr.cod_unid_negoc
       tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = {3}
       tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = {4}
       tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = {5}.

FOR EACH repres_tit_acr NO-LOCK
   WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
     AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.
   CREATE tt_integr_acr_repres_pend.
   ASSIGN tt_integr_acr_repres_pend.ttv_rec_item_lote_impl_tit_acr   = recid(tt_integr_acr_item_lote_impl_3) 
          tt_integr_acr_repres_pend.tta_cdn_repres                   = repres_tit_acr.cdn_repres
          tt_integr_acr_repres_pend.tta_val_perc_comis_repres        = repres_tit_acr.val_perc_comis_repres
          tt_integr_acr_repres_pend.tta_val_perc_comis_repres_emis   = 0
          tt_integr_acr_repres_pend.tta_val_perc_comis_abat          = 0
          tt_integr_acr_repres_pend.tta_val_perc_comis_desc          = 0
          tt_integr_acr_repres_pend.tta_val_perc_comis_juros         = 0
          tt_integr_acr_repres_pend.tta_val_perc_comis_multa         = 0
          tt_integr_acr_repres_pend.tta_val_perc_comis_acerto_val    = 0
          tt_integr_acr_repres_pend.tta_log_comis_repres_proporc     = repres_tit_acr.log_comis_repres_proporc
          tt_integr_acr_repres_pend.tta_ind_tip_comis                = 'Valor L¡quido'.

END. /* for each repres_tit_acr */

IF LAST-OF(tt-lp.cod_estab) THEN DO:
   FIND FIRST tt_integr_acr_lote_impl NO-LOCK NO-ERROR.
   FIND FIRST tt_integr_acr_item_lote_impl_3 NO-LOCK NO-ERROR.
   FIND FIRST tt_integr_acr_aprop_ctbl_pend NO-LOCK NO-ERROR.
   FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR. 
   RUN prgfin/acr/acr900ze.py (INPUT 5,
                               INPUT '',
                               INPUT YES, /* Atualiza */
                               INPUT NO,
                               INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_3). 
   FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.
   IF AVAIL tt_log_erros_atualiz THEN
      ASSIGN l-erro = YES.
   IF l-erro THEN DO:
      OUTPUT TO c:\temp\erro-imp-lp.txt CONVERT TARGET 'iso8859-1' PAGE-SIZE 64.
      FOR EACH tt_log_erros_atualiz NO-LOCK:
         DISP tt_log_erros_atualiz.tta_cod_refer  
              tt_log_erros_atualiz.tta_num_seq_refer 
              tt_log_erros_atualiz.tta_cod_estab 
              tt_log_erros_atualiz.ttv_num_mensagem 
              tt_log_erros_atualiz.ttv_des_msg_erro  FORMAT 'x(70)'
              substr(tt_log_erros_atualiz.ttv_des_msg_ajuda,001,70) FORMAT 'x(70)' 
              substr(tt_log_erros_atualiz.ttv_des_msg_ajuda,071,70) FORMAT 'x(70)' 
              substr(tt_log_erros_atualiz.ttv_des_msg_ajuda,141,70) FORMAT 'x(70)' 
              substr(tt_log_erros_atualiz.ttv_des_msg_ajuda,211,70) FORMAT 'x(70)' 
              WITH 1 COL WIDTH 132.      
      END.
      OUTPUT CLOSE.
      RUN MESSAGE.p ('Erro no lote de implanta‡Æo de Lucros e Perdas',
                     'Ocorreu um erro no lote de implanta‡Æo de lucros e perdas, processo abortado. Verifique o arquivo c:\temp\erro-imp-lp.txt').
      UNDO LP.
   END.
END.

/* dcr015rp.i */
