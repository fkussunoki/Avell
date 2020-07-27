/************************************************************************************************************
** Include: dcr015rp2.i
**  Funá∆o: Alterar T°tulos
************************************************************************************************************/

FIND FIRST tit_acr OF tt-lp NO-LOCK NO-ERROR.

IF NOT AVAIL tit_acr THEN DO:
   DISP tt-lp.
END.

FOR EACH tt_alter_tit_acr_base:          DELETE tt_alter_tit_acr_base.          END.
FOR EACH tt_alter_tit_acr_rateio:        DELETE tt_alter_tit_acr_rateio.        END.
FOR EACH tt_alter_tit_acr_ped_vda:       DELETE tt_alter_tit_acr_ped_vda.       END.
FOR EACH tt_alter_tit_acr_comis:         DELETE tt_alter_tit_acr_comis.         END.
FOR EACH tt_alter_tit_acr_cheq:          DELETE tt_alter_tit_acr_cheq.          END.
FOR EACH tt_alter_tit_acr_iva:           DELETE tt_alter_tit_acr_iva.           END.
FOR EACH tt_alter_tit_acr_impto_retid:   DELETE tt_alter_tit_acr_impto_retid.   END.
FOR EACH tt_alter_tit_acr_cobr_especial: DELETE tt_alter_tit_acr_cobr_especial. END.
FOR EACH tt_alter_tit_acr_rat_desp_rec:  DELETE tt_alter_tit_acr_rat_desp_rec.  END.
FOR EACH tt_log_erros_alter_tit_acr:     DELETE tt_log_erros_alter_tit_acr.     END.

ASSIGN l-erro = NO.

CREATE  tt_alter_tit_acr_base.
ASSIGN  tt_alter_tit_acr_base.tta_cod_refer                   = fi-sugestao-referencia().
ASSIGN  tt_alter_tit_acr_base.tta_cod_estab                   = tit_acr.cod_estab
        tt_alter_tit_acr_base.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
        tt_alter_tit_acr_base.tta_dat_transacao               = dat-liquidac
        tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_imp = ?
        tt_alter_tit_acr_base.tta_val_sdo_tit_acr             = 0 /* Zera T°tulo */
        tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_alt = ""
        tt_alter_tit_acr_base.ttv_ind_motiv_acerto_val        = "Liquidaá∆o" /* SSI 025/05 */
        tt_alter_tit_acr_base.tta_cod_portador                = ?
        tt_alter_tit_acr_base.tta_cod_cart_bcia               = ?
        tt_alter_tit_acr_base.tta_val_despes_bcia             = ?
        tt_alter_tit_acr_base.tta_cod_agenc_cobr_bcia         = ?
        tt_alter_tit_acr_base.tta_cod_tit_acr_bco             = tit_acr.cod_tit_acr_bco
        tt_alter_tit_acr_base.tta_dat_emis_docto              = 01/01/0001
        tt_alter_tit_acr_base.tta_dat_vencto_tit_acr          = 01/01/0001
        tt_alter_tit_acr_base.tta_dat_prev_liquidac           = 01/01/0001
        tt_alter_tit_acr_base.tta_dat_fluxo_tit_acr           = 01/01/0001
        tt_alter_tit_acr_base.tta_ind_sit_tit_acr             = ?
        tt_alter_tit_acr_base.tta_cod_cond_cobr               = ?
        tt_alter_tit_acr_base.tta_log_tip_cr_perda_dedut_tit  = ?
        tt_alter_tit_acr_base.tta_dat_abat_tit_acr            = 01/01/0001
        tt_alter_tit_acr_base.tta_val_abat_tit_acr            = ?
        tt_alter_tit_acr_base.tta_dat_desconto                = 01/01/0001
        tt_alter_tit_acr_base.tta_val_perc_desc               = ?
        tt_alter_tit_acr_base.tta_val_desc_tit_acr            = ?
        tt_alter_tit_acr_base.tta_qtd_dias_carenc_juros_acr   = ?
        tt_alter_tit_acr_base.tta_val_perc_juros_dia_atraso   = ?
        tt_alter_tit_acr_base.tta_val_perc_multa_atraso       = ?
        tt_alter_tit_acr_base.tta_qtd_dias_carenc_multa_acr   = ?
        tt_alter_tit_acr_base.tta_ind_ender_cobr              = ?
        tt_alter_tit_acr_base.tta_nom_abrev_contat            = ?
        tt_alter_tit_acr_base.tta_val_liq_tit_acr             = ?
        tt_alter_tit_acr_base.tta_cod_instruc_bcia_1_movto    = ?
        tt_alter_tit_acr_base.tta_cod_instruc_bcia_2_movto    = ?
        tt_alter_tit_acr_base.ttv_des_text_histor             = ?
        tt_alter_tit_acr_base.tta_ind_tip_cobr_acr            = "Normal"
        tt_alter_tit_acr_base.tta_log_tit_acr_destndo         = ?
        tt_alter_tit_acr_base.tta_des_obs_cobr                = ?
        tt_alter_tit_acr_base.tta_val_perc_abat_acr           = ?.


/* SSI 025/05 */

/* FOR EACH repres_tit_acr NO-LOCK                                                 */
/*    WHERE repres_tit_acr.cod_estab                   = tit_acr.cod_estab         */
/*      AND repres_tit_acr.num_id_tit_acr              = tit_acr.num_id_tit_acr:   */
/*    CREATE tt_alter_tit_acr_comis.                                               */
/*    ASSIGN tt_alter_tit_acr_comis.tta_cod_empresa    = tit_acr.cod_empresa       */
/*           tt_alter_tit_acr_comis.tta_cod_estab      = tit_acr.cod_estab         */
/*           tt_alter_tit_acr_comis.tta_num_id_tit_acr = tit_acr.num_id_tit_acr    */
/*           tt_alter_tit_acr_comis.tta_cdn_repres     = repres_tit_acr.cdn_repres */
/*           tt_alter_tit_acr_comis.ttv_num_tip_operac = 2.                        */
/* END.                                                                            */

FIND FIRST val_tit_acr OF tit_acr NO-LOCK NO-ERROR.

CREATE tt_alter_tit_acr_rateio.                                
ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
       tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
       tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = 'Alteraá∆o'
       tt_alter_tit_acr_rateio.tta_cod_refer                   = tt_alter_tit_acr_base.tta_cod_refer
       tt_alter_tit_acr_rateio.tta_num_seq_refer               = 0
       tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = {1}
       tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = {2}
       tt_alter_tit_acr_rateio.tta_cod_unid_negoc              = tit_acr.cod_empresa
       tt_alter_tit_acr_rateio.tta_cod_plano_ccusto            = IF {4} = '' THEN '' ELSE {3}
       tt_alter_tit_acr_rateio.tta_cod_ccusto                  = {4}
       tt_alter_tit_acr_rateio.tta_cod_tip_fluxo_financ        = val_tit_acr.cod_tip_fluxo_financ
       tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 0
       tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tit_acr.val_sdo_tit_acr
       tt_alter_tit_acr_rateio.tta_dat_transacao               = tt_alter_tit_acr_base.tta_dat_transacao.

 RUN prgfin\acr\acr711zf.py( INPUT  1,
                             INPUT  TABLE tt_alter_tit_acr_base,
                             INPUT  TABLE tt_alter_tit_acr_rateio,
                             INPUT  TABLE tt_alter_tit_acr_ped_vda,
                             INPUT  TABLE tt_alter_tit_acr_comis,
                             INPUT  TABLE tt_alter_tit_acr_cheq,
                             INPUT  TABLE tt_alter_tit_acr_iva,
                             INPUT  TABLE tt_alter_tit_acr_impto_retid,
                             INPUT  TABLE tt_alter_tit_acr_cobr_especial,
                             INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                             OUTPUT TABLE tt_log_erros_alter_tit_acr).

FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK NO-ERROR.
IF AVAIL tt_log_erros_alter_tit_acr THEN
   ASSIGN l-erro = YES.
IF l-erro THEN DO:
   OUTPUT TO c:\temp\erro-alt-lp.txt CONVERT TARGET 'iso8859-1' PAGE-SIZE 64.
   FOR EACH tt_log_erros_alter_tit_acr NO-LOCK:
       DISP tit_acr.cod_estab
            tit_acr.cod_espec_doc
            tit_acr.cod_ser_doc
            tit_acr.cod_tit_acr
            tit_acr.cod_parcela
            "Desc.  : " tt_log_erros_alter_tit_acr.ttv_des_msg_erro  FORMAT 'x(70)'
            "Ajuda  : " tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda FORMAT 'x(70)'
            WITH 1 COL WIDTH 132 STREAM-IO.
   END.
   OUTPUT CLOSE.
   RUN MESSAGE.p ('Erro na alteraá∆o de Lucros e Perdas',
                  'Ocorreu um erro na alteraá∆o de um t°tulo de lucros e perdas, processo abortado. Verifique o arquivo c:\temp\erro-alt-lp.txt').
   UNDO lp, LEAVE.
END.
ELSE DO: /* SSI 025/05 */ /* Estorna Comiss∆o */
   
   FIND LAST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
   
   FOR EACH repres_tit_acr NO-LOCK
      WHERE repres_tit_acr.cod_estab                  = tit_acr.cod_estab
        AND repres_tit_acr.num_id_tit_acr             = tit_acr.num_id_tit_ac
        AND repres_tit_acr.val_perc_comis_repres     <> 0
        AND repres_tit_acr.val_perc_comis_repres_emis = 0.
       
       &if "{&bf_mat_versao_ems}" = "2.062" &then
           FOR EACH tt_movto_comis_repres_geracao. DELETE tt_movto_comis_repres_geracao. END.
       &else
           FOR EACH tt_movto_comis_repres_geracao2. DELETE tt_movto_comis_repres_geracao2. END.
       &endif

       FOR EACH tt_movto_comis_erro.           DELETE tt_movto_comis_erro.           END.

       FIND FIRST movto_comis_repres NO-LOCK
            WHERE movto_comis_repres.cod_estab            = movto_tit_acr.cod_estab
              AND movto_comis_repres.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
              AND movto_comis_repres.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
              AND movto_comis_repres.cdn_repres           = repres_tit_acr.cdn_repres NO-ERROR.
       IF NOT AVAIL movto_comis_repres THEN DO:
          &if "{&bf_mat_versao_ems}" = "2.062" &then
              CREATE  tt_movto_comis_repres_geracao.
              ASSIGN  tt_movto_comis_repres_geracao.tta_cod_empresa            = repres_tit_acr.cod_empresa
                      tt_movto_comis_repres_geracao.tta_cdn_repres             = repres_tit_acr.cdn_repres
                      tt_movto_comis_repres_geracao.tta_num_id_tit_acr         = tit_acr.num_id_tit_acr
                      tt_movto_comis_repres_geracao.tta_num_id_movto_tit_acr   = movto_tit_acr.num_id_movto_tit_acr
                      tt_movto_comis_repres_geracao.tta_cod_estab              = tit_acr.cod_estab
                      tt_movto_comis_repres_geracao.tta_cod_espec_docto        = tit_acr.cod_espec_docto
                      tt_movto_comis_repres_geracao.tta_cod_ser_docto          = tit_acr.cod_ser_docto
                      tt_movto_comis_repres_geracao.tta_cod_tit_acr            = tit_acr.cod_tit_acr
                      tt_movto_comis_repres_geracao.tta_cod_parcela            = tit_acr.cod_parcela
                      tt_movto_comis_repres_geracao.tta_cod_refer              = movto_tit_acr.cod_refer
                      tt_movto_comis_repres_geracao.tta_cod_usuario            = v_cod_usuar_corren
                      tt_movto_comis_repres_geracao.tta_dat_transacao          = movto_tit_acr.dat_transacao
                      tt_movto_comis_repres_geracao.tta_ind_trans_acr          = movto_tit_acr.ind_trans_acr
                      tt_movto_comis_repres_geracao.tta_ind_sit_movto_comis    = "Liquidado"
                      tt_movto_comis_repres_geracao.tta_ind_tip_movto          = "Realizado"
                      tt_movto_comis_repres_geracao.tta_ind_natur_lancto_ctbl  = "CR"
                      tt_movto_comis_repres_geracao.tta_val_base_calc_comis    = tit_acr.val_liq_tit_acr * movto_tit_acr.val_movto_tit_acr / tit_acr.val_origin_tit_acr
                      tt_movto_comis_repres_geracao.tta_val_movto_comis        = (repres_tit_acr.val_perc_comis_repres / 100) * tt_movto_comis_repres_geracao.tta_val_base_calc_comis
                      tt_movto_comis_repres_geracao.tta_des_histor_movto_comis = "Estorno Comiss∆o T°tulo Lucros e Perdas"
                      tt_movto_comis_repres_geracao.tta_ind_trans_comis        = "Estorno Comiss∆o".
              RUN prgfin/acr/acr904za.py (1, INPUT  TABLE tt_movto_comis_repres_geracao,
                                             OUTPUT TABLE tt_movto_comis_erro).
          &else
              CREATE  tt_movto_comis_repres_geracao2.
              ASSIGN  tt_movto_comis_repres_geracao2.tta_cod_empresa            = repres_tit_acr.cod_empresa
                      tt_movto_comis_repres_geracao2.tta_cdn_repres             = repres_tit_acr.cdn_repres
                      tt_movto_comis_repres_geracao2.tta_num_id_tit_acr         = tit_acr.num_id_tit_acr
                      tt_movto_comis_repres_geracao2.tta_num_id_movto_tit_acr   = movto_tit_acr.num_id_movto_tit_acr
                      tt_movto_comis_repres_geracao2.tta_cod_estab              = tit_acr.cod_estab
                      tt_movto_comis_repres_geracao2.tta_cod_espec_docto        = tit_acr.cod_espec_docto
                      tt_movto_comis_repres_geracao2.tta_cod_ser_docto          = tit_acr.cod_ser_docto
                      tt_movto_comis_repres_geracao2.tta_cod_tit_acr            = tit_acr.cod_tit_acr
                      tt_movto_comis_repres_geracao2.tta_cod_parcela            = tit_acr.cod_parcela
                      tt_movto_comis_repres_geracao2.tta_cod_refer              = movto_tit_acr.cod_refer
                      tt_movto_comis_repres_geracao2.tta_cod_usuario            = v_cod_usuar_corren
                      tt_movto_comis_repres_geracao2.tta_dat_transacao          = movto_tit_acr.dat_transacao
                      tt_movto_comis_repres_geracao2.tta_ind_trans_acr          = movto_tit_acr.ind_trans_acr
                      tt_movto_comis_repres_geracao2.tta_ind_sit_movto_comis    = "Liquidado"
                      tt_movto_comis_repres_geracao2.tta_ind_tip_movto          = "Realizado"
                      tt_movto_comis_repres_geracao2.tta_ind_natur_lancto_ctbl  = "CR"
                      tt_movto_comis_repres_geracao2.tta_val_base_calc_comis    = tit_acr.val_liq_tit_acr * movto_tit_acr.val_movto_tit_acr / tit_acr.val_origin_tit_acr
                      tt_movto_comis_repres_geracao2.tta_val_movto_comis        = (repres_tit_acr.val_perc_comis_repres / 100) * tt_movto_comis_repres_geracao2.tta_val_base_calc_comis
                      tt_movto_comis_repres_geracao2.tta_des_histor_movto_comis = "Estorno Comiss∆o T°tulo Lucros e Perdas"
                      tt_movto_comis_repres_geracao2.tta_ind_trans_comis        = "Estorno Comiss∆o"
                      tt_movto_comis_repres_geracao2.ttv_log_consid_movto_pagto = YES  
                      tt_movto_comis_repres_geracao2.tta_dat_emis_docto         = tit_acr.dat_emis_docto
                      tt_movto_comis_repres_geracao2.tta_cdn_motiv_movto_comis  = 1004.

              run prgfin/acr/acr904zb.py persistent set v_hdl_programa.
              run pi_main_code_api_movto_comis_repres_geracao_c in v_hdl_programa (input 1,
                                                                                   input table tt_movto_comis_repres_geracao2,
                                                                                   output table tt_movto_comis_erro).
              DELETE procedure v_hdl_programa.
          &endif

          FIND FIRST tt_movto_comis_erro NO-LOCK NO-ERROR.
          IF AVAIL tt_movto_comis_erro THEN
             ASSIGN l-erro = YES.
          IF l-erro THEN DO:
             OUTPUT TO c:\temp\erro-alt-lp-comis.txt CONVERT TARGET 'iso8859-1' PAGE-SIZE 64.
             FOR EACH tt_movto_comis_erro NO-LOCK:
                 DISP tit_acr.cod_estab
                      tit_acr.cod_espec_doc
                      tit_acr.cod_ser_doc
                      tit_acr.cod_tit_acr
                      tit_acr.cod_parcela
                      "Desc.  : " tt_movto_comis_erro.ttv_des_mensagem  FORMAT 'x(70)'
                      "Ajuda  : " tt_movto_comis_erro.ttv_des_ajuda     FORMAT 'x(70)'
                      "         " substr(tt_movto_comis_erro.ttv_des_ajuda,71,120) FORMAT 'x(120)'
                      WITH 1 COL WIDTH 190 STREAM-IO.
             END.
             OUTPUT CLOSE.
             RUN MESSAGE.p ('Erro no estorno da comiss∆o de Lucros e Perdas',
                            'Ocorreu um erro no estorno de comiss∆o de um t°tulo de lucros e perdas, processo abortado. Verifique o arquivo c:\temp\erro-alt-lp-comis.txt').
             UNDO lp, LEAVE.
          END. /* FIM-Estorna Comiss∆o */ 
       END.
       FIND FIRST movto_comis_repres EXCLUSIVE-LOCK
            WHERE movto_comis_repres.cod_estab            = movto_tit_acr.cod_estab
              AND movto_comis_repres.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
              AND movto_comis_repres.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
              AND movto_comis_repres.cdn_repres           = repres_tit_acr.cdn_repres NO-ERROR.
       IF AVAIL movto_comis_repres THEN
          ASSIGN movto_comis_repres.ind_sit_movto_comis  = "Estornado".
   END.
END.

/* dcr015rp2.i */
