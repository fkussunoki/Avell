{dop/dpd611.i}
define input param p-documento           as char no-undo.
define input param p-cod-ccusto          as char no-undo.
define input param p-cta-ctbl            as char no-undo.
define input param p-cod_estab           as char no-undo.
define input param p-cod_espec_docto     as char no-undo.  
define input param p-cod_ser_docto       as char no-undo.   
define input param p-cod_tit_acr         as char no-undo.     
define input param p-cod_parcela         as char no-undo.    
define input param p-valor               as dec  no-undo.    
define input param p-dt-trans            as date no-undo.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erros_alter_tit_acr.
def var p_log_integr_cmg                 as logical no-undo.

run prgfin/acr/acr711zv.py persistent set v_hdl_program .

def var v_cod_refer as char no-undo.

empty temp-table tt_alter_tit_acr_base_5.
empty temp-table tt_alter_tit_acr_rateio.
run pi_retorna_sugestao_referencia (Input "T" /*l_l*/,
                                    Input today,
                                    output v_cod_refer) /*pi_retorna_sugestao_referencia*/.

            find first tit_acr no-lock where tit_acr.cod_estab       = p-cod_estab
                                        and   tit_acr.cod_espec_docto = p-cod_espec_docto
                                        and   tit_acr.cod_ser_docto   = p-cod_ser_docto
                                        and   tit_acr.cod_tit_acr     = p-cod_tit_acr
                                        and   tit_acr.cod_parcela     = p-cod_parcela no-error.

            find first movto_tit_acr no-lock where movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                             and   movto_tit_acr.cod_estab      = tit_acr.cod_estab
                                             and   movto_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto no-error.

            find first aprop_ctbl_acr no-lock where aprop_ctbl_acr.cod_estab            = movto_tit_acr.cod_estab
                                              and   aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr no-error.

            find first rat_movto_tit_acr no-lock where rat_movto_tit_acr.cod_estab      = aprop_ctbl_acr.cod_estab
                                                 and   rat_movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr no-error.

            find last plano_ccusto no-lock where plano_ccusto.dat_fim_valid >= today
                                           and   plano_ccusto.cod_empresa   = v_cod_empres_usuar no-error.


                                        CREATE tt_alter_tit_acr_base_5.
                                        ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                              = tit_acr.cod_estab
                                               tt_alter_tit_acr_base_5.tta_num_id_tit_acr                         = tit_acr.num_id_tit_acr
                                               tt_alter_tit_acr_base_5.tta_dat_transacao                          = p-dt-trans   
                                               tt_alter_tit_acr_base_5.tta_cod_refer                              = v_cod_refer
                                               tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr                        = abs(tit_acr.val_sdo_tit_acr - p-valor)
                                               tt_alter_tit_acr_base_5.tta_cod_portador                           = tit_acr.cod_portador
                                               tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco                        = tit_acr.cod_tit_acr_bco
                                               tt_alter_tit_acr_base_5.tta_cod_cart_bcia                          = tit_acr.cod_cart_bcia
                                               tt_alter_tit_acr_base_5.tta_dat_emis_docto                         = tit_acr.dat_emis_docto
                                               tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr                     = tit_acr.dat_vencto_tit_acr
                                               tt_alter_tit_acr_base_5.tta_dat_prev_liquidac                      = tit_acr.dat_prev_liquidac
                                               tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr                      = tit_acr.dat_fluxo_tit_acr
                                               tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr                        = tit_acr.ind_sit_tit_acr
                                               tt_alter_tit_acr_base_5.tta_cod_cond_cobr                          = tit_acr.cod_cond_cobr
                                               //tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr                       = tit_acr.dat_abat_tit_acr
                                               //tt_alter_tit_acr_base_5.tta_val_perc_abat_acr                      = tit_acr.val_perc_abat_acr
                                               //tt_alter_tit_acr_base_5.tta_val_abat_tit_acr                       = tit_acr.val_abat_tit_acr
                                               //tt_alter_tit_acr_base_5.tta_dat_desconto                           = tit_acr.dat_desconto
                                               //tt_alter_tit_acr_base_5.tta_val_perc_desc                          = tit_acr.val_perc_desc
                                               //tt_alter_tit_acr_base_5.tta_val_desc_tit_acr                       = tit_acr.val_desc_tit_acr
                                               //tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr              = tit_acr.qtd_dias_carenc_juros_acr
                                               //tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso              = tit_acr.val_perc_juros_dia_atraso
                                               //tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr              = tit_acr.qtd_dias_carenc_multa_acr
                                               //tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso                  = tit_acr.val_perc_multa_atraso
                                               //tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr                       = tit_acr.ind_tip_cobr_acr
                                               tt_alter_tit_acr_base_5.tta_ind_ender_cobr                         = tit_acr.ind_ender_cobr
                                               tt_alter_tit_acr_base_5.tta_nom_abrev_contat                       = tit_acr.nom_abrev_contat
                                               tt_alter_tit_Acr_base_5.ttv_des_text_histor                        = p-documento + "|" + string(p-dt-trans) + "|" + string(p-valor) + "|" + v_cod_refer
                                               //tt_alter_tit_acr_base_5.tta_val_liq_tit_acr                        = abs(tit_acr.val_liq_tit_acr - p-valor)
                                               tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo                    = tit_acr.log_tit_acr_destndo
                                               tt_alter_tit_acr_base_5.tta_cdn_repres                             = tit_acr.cdn_repres
                                               tt_alter_tit_acr_base_5.ttv_log_vendor                             = NO
                                               tt_alter_tit_acr_base_5.ttv_num_planilha_vendor                    = 0
                                               tt_alter_tit_acr_base_5.ttv_cod_cond_pagto_vendor                  = "0"
                                               tt_alter_tit_acr_base_5.ttv_val_cotac_tax_vendor_clien             = 0
                                               tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor                 = ?
                                               tt_alter_tit_acr_base_5.ttv_qti_dias_carenc_fechto                 = 0.
                                                                            
                                        create tt_alter_tit_acr_rateio.
                                        assign tt_alter_tit_acr_rateio.tta_cod_estab                              = tit_acr.cod_estab
                                               tt_alter_tit_acr_rateio.tta_num_id_tit_acr                         = tit_acr.num_id_tit_acr 
                                               tt_alter_tit_acr_rateio.tta_cod_refer                              = v_cod_refer
                                               tt_alter_tit_acr_rateio.tta_num_seq_refer                          = 10 
                                               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl                     = aprop_ctbl_acr.cod_plano_cta_ctbl 
                                               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                           = p-cta-ctbl 
                                               tt_alter_tit_acr_rateio.tta_cod_unid_negoc                         = "DOC" 
                                               tt_alter_tit_acr_rateio.tta_cod_plano_ccusto                       = plano_ccusto.cod_plano_ccusto
                                               tt_alter_tit_acr_rateio.tta_cod_ccusto                             = p-cod-ccusto 
                                               tt_alter_tit_acr_rateio.tta_cod_tip_fluxo_financ                   = rat_movto_tit_acr.cod_tip_fluxo_financ
                                               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr            = 10 
                                               tt_alter_tit_acr_rateio.tta_val_aprop_ctbl                         = p-valor
                                               tt_alter_tit_acr_rateio.tta_dat_transacao                          =  p-dt-trans
                                               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr                    = '2'.


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
                                             Input  p_log_integr_cmg,
                                             Input  table tt_alter_tit_acr_cobr_esp_2_c,
                                             Input  table tt_params_generic_api).

      

Delete procedure v_hdl_program.

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




