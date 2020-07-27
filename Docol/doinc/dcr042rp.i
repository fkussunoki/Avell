{dop/dcr037.i} /* Temp-tables de Trabalho */
{doinc/acr901zc.i}
{doinc/acr900ze.i}
{prgfin/cmg/cmg719ze.i}

/**********************************************************/
DEF VAR l-erro                      AS LOG INITIAL NO.
DEF VAR c-referencia                AS CHAR.
DEF VAR l-referencia                AS LOG.
DEF VAR c-parcela                   LIKE tit_acr.cod_parcela.
DEF VAR v_cont                      AS INTEGER.
DEF VAR v_rec_lote                  AS RECID NO-UNDO.
DEF VAR i-contador                  AS INT.
DEF BUFFER b-tit_acr                FOR  tit_acr.
DEF BUFFER bb-tit_acr               FOR  tit_acr.
DEF VAR c-cod_cta_corren-ax         LIKE portad_finalid_econ.cod_cta_corren.
DEF VAR c-cod-tip-fluxo-financ      LIKE tip_trans_cx.cod_tip_fluxo_financ_saida.
DEF VAR i-num-seq-movto-cta-corren  AS INTEGER      NO-UNDO.
DEF VAR l-controle                  AS LOG INITIAL NO.
DEF VAR dc-val-movto-cmg            LIKE tit_acr.val_sdo_tit_acr.
DEF STREAM s-implant.
DEF STREAM s-liquid.
DEF STREAM s_1.
/**********************************************************/

FIND LAST param_geral_cmg NO-LOCK NO-ERROR.

FIND FIRST vendor_param NO-LOCK
   WHERE vendor_param.cod_empresa   = v_cod_empres_usuar
     AND vendor_param.cod_estabel   = v_cod_estab_usuar
     AND vendor_param.dt_inic_valid <= TODAY
     AND vendor_param.dt_fin_valid  >= TODAY NO-ERROR.
   
FOR EACH tt-digita NO-LOCK USE-INDEX codigo
    BREAK BY tt-digita.num-id-tit-acr:

    FIND FIRST tit_acr NO-LOCK USE-INDEX titacr_token
         WHERE tit_acr.cod_estab      = tt-digita.cod-estab
           AND tit_acr.num_id_tit_acr = tt-digita.num-id-tit-acr NO-ERROR.

    IF AVAIL tit_acr THEN DO:

        IF FIRST(tt-digita.num-id-tit-acr) THEN DO:
           RUN pi-implanta-titulo(INPUT 'capa-lote').
           RUN pi-liquida-titulo('capa-lote-liq').
        END.

        ASSIGN l-controle = NO.
        RUN pi-acompanhar IN h-acomp (INPUT 'Implantando T¡tulo..' + tit_acr.cod_tit_acr).
        RUN pi-implanta-titulo(INPUT 'lote').
        ASSIGN l-controle = YES.
        RUN pi-implanta-titulo(INPUT 'lote').
        
        RUN pi-acompanhar IN h-acomp (INPUT 'Baixando T¡tulo..' + tit_acr.cod_tit_acr).
        RUN pi-liquida-titulo('lote-liq').

        IF param_geral_cmg.log_agrup_movto_cta_corren THEN DO:
            ASSIGN dc-val-movto-cmg = dc-val-movto-cmg + tt-digita.vl-debito.
        END.
        ELSE DO:
            ASSIGN dc-val-movto-cmg = tt-digita.vl-debito.
            RUN pi-geracao ('todos').
        END.

        IF LAST(tt-digita.num-id-tit-acr) THEN DO:
            RUN pi-geracao ('last').
        END. /*transaction*/
        
    END.        
END. /*For each tt-digita*/
    
IF VALID-HANDLE(h-acomp) THEN 
    RUN pi-finalizar IN h-acomp.

PROCEDURE pi-implanta-titulo:          /* IMPLANTA€ÇO */

    DEF INPUT PARAMETER p-cria AS CHAR.

    CASE p-cria:

        WHEN 'capa-lote' THEN DO:

            RUN pi-del-tt-implanta.


            ASSIGN c-referencia = fi-sugestao-referencia()
                   l-referencia = YES.

            DO WHILE l-referencia:
               FIND FIRST b-movto_tit_acr NO-LOCK
                    WHERE b-movto_tit_acr.cod_estab = tit_acr.cod_estab
                      AND b-movto_tit_acr.cod_refer = c-referencia NO-ERROR.
               IF NOT AVAIL b-movto_tit_acr THEN
                  ASSIGN l-referencia = NO.
               ELSE
                  ASSIGN c-referencia = fi-sugestao-referencia().
            END.

            CREATE tt_integr_acr_lote_impl. 
            ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa                = v_cod_empres_usuar 
                   tt_integr_acr_lote_impl.tta_cod_estab                  = v_cod_estab_usuar
                   tt_integr_acr_lote_impl.tta_cod_refer                  = c-referencia
                   tt_integr_acr_lote_impl.tta_dat_transacao              = dt-transacao
                   tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr  = 0 
                   tt_integr_acr_lote_impl.tta_val_tot_lote_infor_tit_acr = 0
                   tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr           = "normal" /*'Juros Vendor'*/
                   v_rec_lote                                             = RECID(tt_integr_acr_lote_impl).
        END.

        WHEN 'lote' THEN DO:
            
            ASSIGN c-parcela = tit_acr.cod_parcela
                   v_cont    = v_cont + 10.

            FIND FIRST b-tit_acr NO-LOCK
                WHERE b-tit_acr.cod_estab       = tit_acr.cod_estab      
                  AND b-tit_acr.cod_espec_docto = vendor_param.cod_espec_docto_neg /*'VD'*/
                  AND b-tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto  
                  AND b-tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr    
                  AND b-tit_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            IF AVAIL b-tit_acr THEN 
                IF b-tit_acr.log_tit_acr_estordo = YES THEN DO:
                    ASSIGN i-cont    = 0                                         
                           c-parcela = ''.                                                                     

                    REPEAT ON STOP UNDO,RETRY:
                        ASSIGN i-cont    = i-cont + 1
                               c-parcela = b-tit_acr.cod_parcela + CHR((ASC("A")) - 1 + i-cont).
                        FIND FIRST bb-tit_acr NO-LOCK
                            WHERE bb-tit_acr.cod_estab       = tit_acr.cod_estab      
                              AND bb-tit_acr.cod_espec_docto = vendor_param.cod_espec_docto_neg /*'VD'*/ 
                              AND bb-tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto  
                              AND bb-tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr    
                              AND bb-tit_acr.cod_parcela     = c-parcela NO-ERROR.
                        IF NOT AVAIL bb-tit_acr THEN 
                            STOP.
                    END.
                END.

            FIND FIRST val_tit_acr    OF tit_acr NO-LOCK NO-ERROR.
            FIND FIRST movto_tit_acr  OF tit_acr NO-LOCK NO-ERROR.
            FIND FIRST aprop_ctbl_acr OF movto_tit_acr NO-LOCK NO-ERROR.

            CREATE tt_integr_acr_item_lote_impl_3.
            ASSIGN tt_integr_acr_item_lote_impl_3.ttv_rec_lote_impl_tit_acr      = v_rec_lote 
                   tt_integr_acr_item_lote_impl_3.tta_num_seq_refer              = v_cont
                   tt_integr_acr_item_lote_impl_3.tta_cdn_cliente                = tit_acr.cdn_cliente   
                   tt_integr_acr_item_lote_impl_3.tta_cod_espec_docto            = IF l-controle THEN
                                                                                      vendor_param.cod_espec_docto_jur_vend
                                                                                   ELSE
                                                                                       vendor_param.cod_espec_docto_venc
                   tt_integr_acr_item_lote_impl_3.tta_cod_ser_docto              = vendor_param.cod_ser_docto_venc 
                   tt_integr_acr_item_lote_impl_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
                   tt_integr_acr_item_lote_impl_3.tta_cod_parcela                = c-parcela 
                   tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ_ext       = ""
                   tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ           = "corrente"
                   tt_integr_acr_item_lote_impl_3.tta_cod_finalid_econ_ext       = "" 
                   tt_integr_acr_item_lote_impl_3.tta_cod_indic_econ             = "real"
                   tt_integr_acr_item_lote_impl_3.tta_cod_portador               = tt-digita.cod-portador-movto  
                   tt_integr_acr_item_lote_impl_3.tta_cod_portad_ext             = ""
                   tt_integr_acr_item_lote_impl_3.tta_cod_cart_bcia              = tt-digita.cod-cart-movot
                   tt_integr_acr_item_lote_impl_3.tta_cdn_repres                 = tit_acr.cdn_repres        
                   tt_integr_acr_item_lote_impl_3.tta_dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                   tt_integr_acr_item_lote_impl_3.tta_dat_prev_liquidac          = tit_acr.dat_prev_liquidac
                   tt_integr_acr_item_lote_impl_3.tta_dat_desconto               = tit_acr.dat_desconto
                   tt_integr_acr_item_lote_impl_3.tta_dat_emis_docto             = tit_acr.dat_emis_docto
                   tt_integr_acr_item_lote_impl_3.tta_val_tit_acr                = IF l-controle THEN 
                                                                                       tt-digita.vl-juros
                                                                                   ELSE 
                                                                                       tt-digita.vl-debito
                   tt_integr_acr_item_lote_impl_3.tta_val_desconto               = 0  
                   tt_integr_acr_item_lote_impl_3.tta_val_perc_desc              = tit_acr.val_perc_desc
                   tt_integr_acr_item_lote_impl_3.tta_val_perc_juros_dia_atraso  = tit_acr.val_perc_juros_dia_atraso 
                   tt_integr_acr_item_lote_impl_3.tta_des_text_histor            = "Vendor Vencido" 
                   tt_integr_acr_item_lote_impl_3.tta_cod_instruc_bcia_1_movto   = tit_acr.cod_instruc_bcia_1_acr 
                   tt_integr_acr_item_lote_impl_3.tta_cod_instruc_bcia_2_movto   = tit_acr.cod_instruc_bcia_2_acr
                   tt_integr_acr_item_lote_impl_3.tta_qtd_dias_carenc_juros_acr  = tit_acr.qtd_dias_carenc_juros_acr 
                   tt_integr_acr_item_lote_impl_3.tta_val_liq_tit_acr            = IF l-controle THEN
                                                                                       tt-digita.vl-juros
                                                                                   ELSE 
                                                                                       tt-digita.vl-debito
                   tt_integr_acr_item_lote_impl_3.tta_ind_tip_espec_docto        = tit_acr.ind_tip_espec_docto
                   tt_integr_acr_item_lote_impl_3.tta_cod_agenc_cobr_bcia        = tit_acr.cod_agenc_cobr_bcia
                   tt_integr_acr_item_lote_impl_3.tta_cod_tit_acr_bco            = tit_acr.cod_tit_acr_bco
                   tt_integr_acr_item_lote_impl_3.tta_cod_cartcred               = ""
                   tt_integr_acr_item_lote_impl_3.tta_cod_mes_ano_valid_cartao   = ""
                   tt_integr_acr_item_lote_impl_3.tta_dat_compra_cartao_cr       = ?
                   tt_integr_acr_item_lote_impl_3.tta_cod_conces_telef           = ""
                   tt_integr_acr_item_lote_impl_3.tta_num_ddd_localid_conces     = 0
                   tt_integr_acr_item_lote_impl_3.tta_num_prefix_localid_conces  = 0
                   tt_integr_acr_item_lote_impl_3.tta_num_milhar_localid_conces  = 0
                   tt_integr_acr_item_lote_impl_3.tta_cod_banco                  = tit_acr.cod_banco    
                   tt_integr_acr_item_lote_impl_3.tta_cod_agenc_bcia             = tit_acr.cod_agenc_bcia
                   tt_integr_acr_item_lote_impl_3.tta_cod_cta_corren_bco         = tit_acr.cod_cta_corren_bco 
                   tt_integr_acr_item_lote_impl_3.tta_cod_digito_cta_corren      = tit_acr.cod_digito_cta_corren
                   tt_integr_acr_item_lote_impl_3.ttv_rec_item_lote_impl_tit_acr = recid(tt_integr_acr_item_lote_impl_3)
                   tt_integr_acr_item_lote_impl_3.tta_cod_motiv_movto_tit_acr    = ""
                   tt_integr_acr_item_lote_impl_3.tta_log_liquidac_autom         = NO
                   tt_integr_acr_item_lote_impl_3.tta_cod_cartcred               = ""
                   tt_integr_acr_item_lote_impl_3.tta_cod_mes_ano_valid_cartao   = ""
                   tt_integr_acr_item_lote_impl_3.ttv_cod_comprov_vda            = ""
                   tt_integr_acr_item_lote_impl_3.ttv_num_parc_cartcred          = 0.

            /* Apropria‡Æo cont bil do t¡tulo  */
            CREATE tt_integr_acr_aprop_ctbl_pend. 
            ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = recid(tt_integr_acr_item_lote_impl_3) 
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = vendor_param.cta_ctbl_trans_deb_vend
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = val_tit_acr.cod_tip_fluxo_financ 
                   tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = IF l-controle THEN 
                                                                                      tt-digita.vl-juros
                                                                                  ELSE 
                                                                                      /*aprop_ctbl_acr.val_aprop_ctbl   */
                                                                                      tt-digita.vl-debito
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = aprop_ctbl_acr.cod_unid_negoc
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = aprop_ctbl_acr.cod_plano_cta_ctbl
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = aprop_ctbl_acr.cod_plano_ccusto
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = vendor_param.ccusto_trans_deb_vend.
        END.

        WHEN 'acr900ze' THEN DO:
                
            FIND FIRST tt_integr_acr_lote_impl NO-LOCK NO-ERROR.
            FIND FIRST tt_integr_acr_item_lote_impl_3 NO-LOCK NO-ERROR.
            FIND FIRST tt_integr_acr_aprop_ctbl_pend NO-LOCK NO-ERROR.
            FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR. 

            RUN prgfin/acr/acr900ze.py (INPUT 5,
                                        INPUT "",
                                        INPUT YES,
                                        INPUT NO,
                                        INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_3). 

            FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erros_atualiz THEN DO:
                RUN MESSAGE.p(INPUT 'Ocorrenram Erros durante a Implanta‡Æo!',
                              INPUT 'Ocorrenram Erros durante a Implanta‡Æo dos T¡tulos no ACR' + CHR(13) +
                                    'Ser  gerado um arquivo de error no C:\Temp\ErrosImplantacaoACR.txt !').                
                ASSIGN l-erro = YES.
            END.
            IF l-erro THEN DO:
                OUTPUT STREAM s-implant TO VALUE(SESSION:TEMP-DIRECTORY + "ErrosImplantacoaACR.txt") CONVERT TARGET "iso8859-1" APPEND.
                    FOR EACH tt_log_erros_atualiz NO-LOCK:
                        DISP STREAM s-implant
                             tt_log_erros_atualiz.tta_cod_refer  
                             tt_log_erros_atualiz.tta_num_seq_refer 
                             tt_log_erros_atualiz.tta_cod_estab 
                             tt_log_erros_atualiz.ttv_num_mensagem 
                             tt_log_erros_atualiz.ttv_des_msg_erro 
                             tt_log_erros_atualiz.ttv_des_msg_ajuda  WITH 1 COL WIDTH 300.      
                    END.
                 OUTPUT STREAM s-implant CLOSE.                 
            END.           
        END.
    END CASE.

END PROCEDURE. /*Impla‡Æo de T¡tulos*/

PROCEDURE pi-liquida-titulo:
    DEF INPUT PARAMETER p-acao AS CHAR.

        CASE p-acao:

            WHEN 'capa-lote-liq' THEN DO:

                RUN pi-del-tt-liquida.

                ASSIGN i-contador = i-contador + 1.
                IF i-contador > 9 THEN
                    ASSIGN i-contador = 1.
                ASSIGN c-refer-liqd = "L" + STRING(i-contador) + STRING(MONTH(TODAY)) +
                                            STRING(DAY(TODAY))   +
                                            SUBSTRING(STRING(TIME),2,4).

                CREATE tt_integr_acr_liquidac_lote.
                ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = tit_acr.cod_empresa 
                       tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = tit_acr.cod_estab   
                       tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren
                       tt_integr_acr_liquidac_lote.tta_cod_portador                = tt-digita.cod-portador-movto
                       tt_integr_acr_liquidac_lote.tta_cod_cart_bcia               = tt-digita.cod-cart-movot   
                       tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = dt-transacao        
                       tt_integr_acr_liquidac_lote.tta_dat_transacao               = dt-transacao 
                       tt_integr_acr_liquidac_lote.tta_val_tot_lote_liquidac_infor = 0 
                       tt_integr_acr_liquidac_lote.tta_val_tot_lote_liquidac_efetd = 0  
                       tt_integr_acr_liquidac_lote.tta_val_tot_despes_bcia         = 0     /*1*/
                       tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "autom tica"
                       tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digita‡Æo"
                       tt_integr_acr_liquidac_lote.tta_nom_arq_movimen_bcia        = ""
                       tt_integr_acr_liquidac_lote.tta_cdn_cliente                 = 0 
                       tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO   
                       tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES  
                       tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO
                       tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
                       tt_integr_acr_liquidac_lote.tta_cod_refer                   = c-refer-liqd.
                       /*tt_integr_acr_liquidac_lote.ttv_cod_indic_econ              = "real"  
                       l-liquida-tit                                               = YES*/ 
            END.

            WHEN 'lote-liq' THEN DO:

                CREATE tt_integr_acr_liq_item_lote.       
                ASSIGN tt_integr_acr_liq_item_lote.tta_cod_empresa                = tit_acr.cod_empresa
                       tt_integr_acr_liq_item_lote.tta_cod_estab                  = tit_acr.cod_estab
                       tt_integr_acr_liq_item_lote.tta_cod_espec_docto            = tit_acr.cod_espec_docto
                       tt_integr_acr_liq_item_lote.tta_cod_ser_docto              = tit_acr.cod_ser_docto
                       tt_integr_acr_liq_item_lote.tta_cod_tit_acr                = tit_acr.cod_tit_acr
                       tt_integr_acr_liq_item_lote.tta_cod_parcela                = tit_acr.cod_parcela
                       tt_integr_acr_liq_item_lote.tta_cdn_cliente                = tit_acr.cdn_cliente
                       tt_integr_acr_liq_item_lote.tta_cod_portad_ext             = ""
                       tt_integr_acr_liq_item_lote.tta_cod_modalid_ext            = ""
                       tt_integr_acr_liq_item_lote.tta_cod_portador               = tt-digita.cod-portador-movto 
                       tt_integr_acr_liq_item_lote.tta_cod_cart_bcia              = tt-digita.cod-cart-movot  
                       tt_integr_acr_liq_item_lote.tta_cod_finalid_econ           = "corrente"
                       tt_integr_acr_liq_item_lote.tta_cod_indic_econ             = tit_acr.cod_indic_econ
                       tt_integr_acr_liq_item_lote.tta_val_tit_acr                = tit_acr.val_liq_tit_acr
                       tt_integr_acr_liq_item_lote.tta_val_liquidac_tit_acr       = tit_acr.val_sdo_tit_acr
                       tt_integr_acr_liq_item_lote.tta_dat_cr_liquidac_tit_acr    = dt-transacao 
                       tt_integr_acr_liq_item_lote.tta_dat_liquidac_tit_acr       = dt-transacao
                       tt_integr_acr_liq_item_lote.tta_cod_autoriz_bco            = ""
                       tt_integr_acr_liq_item_lote.tta_val_abat_tit_acr           = 0
                       tt_integr_acr_liq_item_lote.tta_val_despes_bcia            = 0
                       tt_integr_acr_liq_item_lote.tta_val_multa_tit_acr          = 0
                       tt_integr_acr_liq_item_lote.tta_val_juros                  = 0
                       tt_integr_acr_liq_item_lote.tta_val_cm_tit_acr             = 0
                       tt_integr_acr_liq_item_lote.tta_val_liquidac_orig          = 0
                       tt_integr_acr_liq_item_lote.tta_val_desc_tit_acr_orig      = 0  
                       tt_integr_acr_liq_item_lote.tta_val_abat_tit_acr_orig      = 0 
                       tt_integr_acr_liq_item_lote.tta_val_despes_bcia_orig       = 0
                       tt_integr_acr_liq_item_lote.tta_val_multa_tit_acr_origin   = 0
                       tt_integr_acr_liq_item_lote.tta_val_juros_tit_acr_orig     = 0
                       tt_integr_acr_liq_item_lote.tta_val_cm_tit_acr_orig        = 0
                       tt_integr_acr_liq_item_lote.tta_val_nota_db_orig           = 0
                       tt_integr_acr_liq_item_lote.tta_log_gera_antecip           = NO
                       tt_integr_acr_liq_item_lote.tta_des_text_histor            = "Vendor Vencido"
                       tt_integr_acr_liq_item_lote.tta_ind_sit_item_lote_liquidac = ""
                       tt_integr_acr_liq_item_lote.tta_log_gera_avdeb             = NO
                       tt_integr_acr_liq_item_lote.tta_cod_indic_econ_avdeb       = ""
                       tt_integr_acr_liq_item_lote.tta_cod_portad_avdeb           = ""
                       tt_integr_acr_liq_item_lote.tta_cod_cart_bcia_avdeb        = "" 
                       tt_integr_acr_liq_item_lote.tta_dat_vencto_avdeb           = ?
                       tt_integr_acr_liq_item_lote.tta_val_perc_juros_avdeb       = 0
                       tt_integr_acr_liq_item_lote.tta_val_avdeb                  = 0
                       tt_integr_acr_liq_item_lote.tta_log_movto_comis_estordo    = NO
                       tt_integr_acr_liq_item_lote.tta_ind_tip_item_liquidac_acr  = "Pagamento"
                       tt_integr_acr_liq_item_lote.tta_ind_tip_calc_juros         = "Compostos"
                       tt_integr_acr_liq_item_lote.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
                       tt_integr_acr_liq_item_lote.ttv_rec_item_lote_liquidac_acr = RECID(tt_integr_acr_liq_item_lote).

            END.

            WHEN 'acr901zc' THEN DO:

                RUN prgfin\acr\acr901zc.py(INPUT 1,
                                           INPUT TABLE tt_integr_acr_liquidac_lote,
                                           INPUT TABLE tt_integr_acr_liq_item_lote,
                                           INPUT TABLE tt_integr_acr_abat_antecip,
                                           INPUT TABLE tt_integr_acr_abat_prev,
                                           INPUT TABLE tt_integr_acr_cheq,
                                           INPUT TABLE tt_integr_acr_liquidac_impto,
                                           INPUT TABLE tt_integr_acr_rel_pend_cheq,
                                           INPUT TABLE tt_integr_acr_liq_aprop_ctbl,
                                           INPUT TABLE tt_integr_acr_liq_desp_rec,
                                           INPUT TABLE tt_integr_acr_aprop_liq_antec,
                                           INPUT "",
                                           OUTPUT TABLE tt_log_erros_import_liquidac).

                FIND FIRST tt_log_erros_import_liquidac NO-LOCK NO-ERROR.
                IF AVAIL tt_log_erros_import_liquidac THEN DO:
                    RUN MESSAGE.p(INPUT 'Ocorrenram Erros durante a Liquida‡Æo!',
                                  INPUT 'Ocorrenram Erros durante a Liquida‡Æo dos T¡tulos no ACR' + CHR(13) +
                                        'Ser  gerado um arquivo de error no C:\Temp\ErrosLiquidacaoACR.txt !').                
                    ASSIGN l-erro = YES.
                END.
                IF l-erro THEN DO:
                    OUTPUT STREAM s-liquid TO VALUE(SESSION:TEMP-DIRECTORY + "ErrosLiquidacaoACR.txt") CONVERT TARGET "iso8859-1" APPEND.
                        FOR EACH tt_log_erros_import_liquidac:
                            DISP STREAM s-liquid
                                 tt_log_erros_import_liquidac.tta_num_seq            
                                 tt_log_erros_import_liquidac.tta_cod_estab          
                                 tt_log_erros_import_liquidac.tta_cod_refer          
                                 tt_log_erros_import_liquidac.tta_cod_espec_docto    
                                 tt_log_erros_import_liquidac.tta_cod_ser_docto      
                                 tt_log_erros_import_liquidac.tta_cod_tit_acr        
                                 tt_log_erros_import_liquidac.tta_cod_parcela        
                                 tt_log_erros_import_liquidac.ttv_nom_abrev_clien    
                                 tt_log_erros_import_liquidac.ttv_num_erro_log       
                                 tt_log_erros_import_liquidac.ttv_des_msg_erro     WITH 1 COL.      
                        END.
                    OUTPUT STREAM s-liquid CLOSE.
                END.
            END.

        END CASE.

END PROCEDURE.

PROCEDURE pi-geracao:

    DEF INPUT PARAMETER p-registro AS CHAR.

    DO TRANSACTION ON ERROR UNDO,RETRY:

        IF p-registro = 'last' THEN DO:
        
            RUN pi-implanta-titulo(INPUT 'acr900ze').
                                          
            IF NOT l-erro THEN
                RUN pi-liquida-titulo('acr901zc').
            ELSE
                RETURN ERROR.          
        
            IF param_geral_cmg.log_agrup_movto_cta_corren THEN DO:
            
                IF l-erro = NO THEN DO:
                    RUN pi-movto-conta-corrente(INPUT 'DEB').
        
                    IF l-erro THEN DO:
                        IF VALID-HANDLE(h-acomp) THEN
                            RUN pi-finalizar IN h-acomp.
                        RETURN ERROR.
                    END.
                END.
            END.
        END.
        ELSE DO:
                
            RUN pi-movto-conta-corrente(INPUT 'DEB').
                
            IF l-erro THEN DO:
                   
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-finalizar IN h-acomp.
                RETURN ERROR.
            END.
        END.
        
    END.
END PROCEDURE.

PROCEDURE pi-movto-conta-corrente:

    FIND FIRST portador NO-LOCK
        WHERE portador.cod_portador = tt-digita.cod-portador-movto NO-ERROR.
    IF AVAIL portador THEN
        FIND FIRST portad_finalid_econ OF portador NO-LOCK NO-ERROR.
        IF AVAIL portad_finalid_econ THEN
            ASSIGN c-cod_cta_corren-ax = portad_finalid_econ.cod_cta_corren.
    
    RUN pi-acompanhar IN h-acomp (INPUT 'CMG/DEB Conta Corrente...' + STRING(c-cod_cta_corren-ax)).

    DEF VAR c-tipo-movto AS CHAR.
    DEF VAR c-fluxo AS CHAR.
    DEF VAR c-cod_tip_trans_cx AS CHAR.
    DEF VAR num_id_movto_cta_corren_nreal AS CHAR.
    DEF VAR num_id_movto_cta_corren_real  AS CHAR.
    DEF INPUT PARAMETER p-movto AS CHAR.

    FOR EACH tt_movto_cta_corren_import.
        DELETE tt_movto_cta_corren_import.
    END.
    FOR EACH tt_aprop_ctbl_cmg_import.
        DELETE tt_aprop_ctbl_cmg_import.
    END.
    FOR EACH tt_rat_financ_cmg_import.
        DELETE tt_rat_financ_cmg_import.
    END.
    ASSIGN c-tipo-movto = IF i-cod-movimento = 1 THEN 'RE' ELSE "NR".

    FIND FIRST cta_corren NO-LOCK
        WHERE cta_corren.cod_cta_corren = c-cod_cta_corren-ax NO-ERROR.

    FIND FIRST plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.dat_inic_valid        <= dt-transacao          
          AND plano_cta_ctbl.dat_fim_valid         >= dt-transacao 
          AND plano_cta_ctbl.ind_tip_plano_cta_ctbl = 'Prim rio' NO-ERROR.

    FIND FIRST plano_ccusto NO-LOCK 
        WHERE plano_ccusto.dat_inic_valid <= dt-transacao  
          AND plano_ccusto.dat_fim_valid  >= dt-transacao NO-ERROR.  

    FIND LAST movto_cta_corren NO-LOCK USE-INDEX mvtctcrr_id
        WHERE movto_cta_corren.cod_cta_corren       = c-cod_cta_corren-ax
          AND movto_cta_corren.dat_movto_cta_corren = dt-transacao         NO-ERROR.
    IF  AVAIL movto_cta_corren THEN 
        ASSIGN  i-num-seq-movto-cta-corren = movto_cta_corren.num_seq_movto_cta_corren + 1.

    ELSE 
        ASSIGN  i-num-seq-movto-cta-corren = 1.

    CASE p-movto:
        WHEN 'DEB' THEN DO:
            ASSIGN c-fluxo                    = 'Sai' 
                c-cod_tip_trans_cx            = vendor_param.tipo-trans-deb-vend. 
                
                FIND FIRST tip_trans_cx NO-LOCK
                     WHERE tip_trans_cx.cod_tip_trans_cx = c-cod_tip_trans_cx NO-ERROR.
                IF  AVAIL tip_trans_cx THEN DO:
                    IF  c-fluxo = 'Ent' THEN 
                        ASSIGN  c-cod-tip-fluxo-financ = tip_trans_cx.cod_tip_fluxo_financ_entr.
                    ELSE 
                        ASSIGN  c-cod-tip-fluxo-financ = tip_trans_cx.cod_tip_fluxo_financ_saida.
                END.
                ELSE 
                    ASSIGN  c-cod-tip-fluxo-financ = ''.

                    CREATE  tt_movto_cta_corren_import.                                  
                    ASSIGN  tt_movto_cta_corren_import.tta_cod_cta_corren               = c-cod_cta_corren-ax
                            tt_movto_cta_corren_import.tta_dat_movto_cta_corren         = dt-transacao
                            tt_movto_cta_corren_import.tta_num_seq_movto_cta_corren     = i-num-seq-movto-cta-corren
                            tt_movto_cta_corren_import.tta_ind_tip_movto_cta_corren     = c-tipo-movto  /*'RE' "NR"*/
                            tt_movto_cta_corren_import.tta_cod_tip_trans_cx             = c-cod_tip_trans_cx  /*DEB*/
                            tt_movto_cta_corren_import.tta_ind_fluxo_movto_cta_corren   = c-fluxo /*c-cod-tip-fluxo-financ*/ /*c-fluxo /*Entrada Saida*/*/
                            tt_movto_cta_corren_import.tta_cod_cenar_ctbl               = '' 
                            tt_movto_cta_corren_import.tta_cod_histor_padr              = ''
                            tt_movto_cta_corren_import.tta_val_movto_cta_corren         = dc-val-movto-cmg 
                            tt_movto_cta_corren_import.tta_cod_docto_movto_cta_bco      = ''
                            tt_movto_cta_corren_import.tta_cod_modul_dtsul              = 'CMG'
                            tt_movto_cta_corren_import.ttv_ind_erro_valid               = 'NÆo'
                            tt_movto_cta_corren_import.tta_des_histor_padr              = 'Vendor Vencido' + '( ' + c-cod_tip_trans_cx + ' )'
                            tt_movto_cta_corren_import.ttv_rec_movto_cta_corren         = RECID(tt_movto_cta_corren_import).

                    CREATE  tt_aprop_ctbl_cmg_import.
                    ASSIGN  tt_aprop_ctbl_cmg_import.ttv_rec_movto_cta_corren  = RECID(tt_movto_cta_corren_import)
                            tt_aprop_ctbl_cmg_import.tta_ind_natur_lancto_ctbl = 'DB'
                            tt_aprop_ctbl_cmg_import.tta_cod_plano_cta_ctbl    = plano_cta_ctbl.cod_plano_cta_ctbl 
                            tt_aprop_ctbl_cmg_import.tta_cod_cta_ctbl          = vendor_param.cta_ctbl_trans_deb_vend
                            tt_aprop_ctbl_cmg_import.tta_cod_estab             = v_cod_estab_usuar
                            tt_aprop_ctbl_cmg_import.tta_cod_unid_negoc        = cta_corren.cod_unid_negoc
                            tt_aprop_ctbl_cmg_import.tta_cod_plano_ccusto      = plano_ccusto.cod_plano_ccusto
                            tt_aprop_ctbl_cmg_import.tta_cod_ccusto            = vendor_param.ccusto_trans_deb_vend
                            tt_aprop_ctbl_cmg_import.ttv_val_aprop             = dc-val-movto-cmg.

                    CREATE  tt_rat_financ_cmg_import.
                    ASSIGN  tt_rat_financ_cmg_import.ttv_rec_movto_cta_corren = RECID(tt_movto_cta_corren_import)
                            tt_rat_financ_cmg_import.tta_cod_estab            = tt_aprop_ctbl_cmg_import.tta_cod_estab
                            tt_rat_financ_cmg_import.tta_cod_unid_negoc       = tt_aprop_ctbl_cmg_import.tta_cod_unid_negoc
                            tt_rat_financ_cmg_import.tta_cod_tip_fluxo_financ = c-cod-tip-fluxo-financ
                            tt_rat_financ_cmg_import.tta_val_movto_cta_corren = tt_aprop_ctbl_cmg_import.ttv_val_aprop.
        END.
    END CASE.

        OUTPUT STREAM s_1 TO VALUE(SESSION:TEMP-DIRECTORY + "MovtoCaixaBancos.txt.") CONVERT TARGET "iso8859-1" APPEND.

        RUN prgfin/cmg/cmg719ze.py (INPUT 1,
                                    INPUT NO,
                                    INPUT YES,
                                    INPUT-OUTPUT TABLE tt_movto_cta_corren_import,
                                    INPUT TABLE tt_aprop_ctbl_cmg_import,
                                    INPUT TABLE tt_rat_financ_cmg_import,
                                    OUTPUT TABLE tt_import_movto_valid_cmg).

        FIND FIRST tt_movto_cta_corren_import NO-LOCK
            WHERE tt_movto_cta_corren_import.ttv_ind_erro_valid = "Sim" NO-ERROR.

        IF AVAIL tt_movto_cta_corren_import THEN 

            FIND FIRST tt_import_movto_valid_cmg NO-LOCK
                WHERE tt_import_movto_valid_cmg.ttv_rec_movto_cta_corren = tt_movto_cta_corren_import.ttv_rec_movto_cta_corren NO-ERROR.

            IF AVAIL tt_import_movto_valid_cmg THEN DO:

                MESSAGE 'Ocorreram Erros no CMG'                                          SKIP
                        'Ser  Gerado um arquivo no c:\temp\MovtoCaixaBancos.txt'          SKIP(1)
                        'Recid       ' tt_import_movto_valid_cmg.ttv_rec_movto_cta_corren SKIP       
                        'N§ Mensagem ' tt_import_movto_valid_cmg.ttv_num_mensagem         SKIP
                        'Descri‡Æo   ' tt_import_movto_valid_cmg.ttv_des_mensagem         SKIP
                        'Descri‡Æo   ' tt_import_movto_valid_cmg.ttv_des_msg_erro         SKIP
                        'Perƒmetro   ' tt_import_movto_valid_cmg.ttv_cod_parameters       VIEW-AS ALERT-BOX ERROR TITLE ' Erros no CMG'.
                ASSIGN l-erro = YES.
            END.

            FOR EACH tt_movto_cta_corren_import NO-LOCK
                WHERE tt_movto_cta_corren_import.ttv_ind_erro_valid = "Sim":

                FOR EACH tt_import_movto_valid_cmg NO-LOCK
                    WHERE tt_import_movto_valid_cmg.ttv_rec_movto_cta_corren = tt_movto_cta_corren_import.ttv_rec_movto_cta_corren:

                    DISP STREAM s_1
                         tt_import_movto_valid_cmg
                         WITH 1 COL WIDTH 300.
                END.
            END.
        OUTPUT STREAM s_1 CLOSE.

        FOR EACH tt_movto_cta_corren_import:
            DELETE tt_movto_cta_corren_import.
        END.

END PROCEDURE.

PROCEDURE pi-del-tt-liquida:

    FOR EACH tt_integr_acr_liquidac_lote EXCLUSIVE-LOCK:
            DELETE tt_integr_acr_liquidac_lote.
        END.

        FOR EACH tt_integr_acr_liq_item_lote EXCLUSIVE-LOCK:
            DELETE tt_integr_acr_liq_item_lote.
        END.
        FOR EACH tt_log_erros_import_liquidac EXCLUSIVE-LOCK:
            DELETE tt_log_erros_import_liquidac.
        END.

END PROCEDURE.

PROCEDURE pi-del-tt-implanta:

    FOR EACH tt_integr_acr_lote_impl EXCLUSIVE-LOCK: 
        DELETE tt_integr_acr_lote_impl.
    END.
    FOR EACH tt_integr_acr_item_lote_impl_3 EXCLUSIVE-LOCK:
        DELETE tt_integr_acr_item_lote_impl_3.
    END.
    FOR EACH tt_integr_acr_aprop_ctbl_pend EXCLUSIVE-LOCK: 
        DELETE tt_integr_acr_aprop_ctbl_pend.
    END.
    FOR EACH tt_log_erros_atualiz EXCLUSIVE-LOCK: 
        DELETE tt_log_erros_atualiz.
    END.

END PROCEDURE.



  
