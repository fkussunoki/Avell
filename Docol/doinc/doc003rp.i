CREATE  tt_integr_item_lancto_ctbl.
ASSIGN  tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = r-rec_integr_lote_ctbl
        tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = {&sequencia}
        tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = {&lancamento}
        tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = tt-resumo.cod-plano-cta
        tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = {&conta}
        tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = {&planoccusto}
        tt_integr_item_lancto_ctbl.tta_cod_estab                    = tt-resumo.cod_estab
        tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = v_cod_empres_usuar
        tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = {&tipo} + c-historico
        tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = c-cod_indic_econ
        tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-fim-dat-emis
        tt_integr_item_lancto_ctbl.tta_qtd_unid_lancto_ctbl         = 1
        tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = {&valor}
        tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = {&ccusto}.

CREATE  tt_integr_aprop_lancto_ctbl.
ASSIGN  tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = c-cod_finalid_econ
        tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
        tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
        tt_integr_aprop_lancto_ctbl.tta_qtd_unid_lancto_ctbl        = 1
        tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
        tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
        tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
        tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado"
        tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto.

/* doc003rp.i */
