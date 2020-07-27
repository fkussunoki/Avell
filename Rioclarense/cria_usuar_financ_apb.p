DEFINE BUFFER b_usuar FOR usuar_financ_estab_apb.

FOR EACH b_usuar NO-LOCK WHERE b_usuar.cod_estab = "101":

    FIND FIRST usuar_financ_estab_apb NO-LOCK WHERE usuar_financ_estab_apb.cod_estab = "105"
                                              AND   usuar_financ_estab_apb.cod_usuario = b_usuar.cod_usuario NO-ERROR.

    IF NOT avail usuar_financ_estab_apb THEN DO:
        
        CREATE usuar_financ_estab_apb.
        ASSIGN usuar_financ_estab_apb.cod_empresa = b_usuar.cod_empresa
               usuar_financ_estab_apb.cod_usuario = b_usuar.cod_usuario
               usuar_financ_estab_apb.cod_estab   = "105"
               usuar_financ_estab_apb.log_habilit_impl_tit_ap = b_usuar.log_habilit_impl_tit_ap
               usuar_financ_estab_apb.log_habilit_prepar_tit_ap = b_usuar.log_habilit_prepar_tit_ap
               usuar_financ_estab_apb.log_habilit_liber_tit_ap = b_usuar.log_habilit_liber_tit_ap
               usuar_financ_estab_apb.log_habilit_pagto_tit_ap = b_usuar.log_habilit_pagto_tit_ap
               usuar_financ_estab_apb.log_habilit_impr_docto   = b_usuar.log_habilit_impr_docto
               usuar_financ_estab_apb.log_habilit_confir_tit_ap = b_usuar.log_habilit_confir_tit_ap
               usuar_financ_estab_apb.log_habilit_ctbz_apb      = b_usuar.log_habilit_ctbz_apb
               usuar_financ_estab_apb.log_habilit_transf_tit_ap = b_usuar.log_habilit_transf_tit_ap
               usuar_financ_estab_apb.log_habilit_correc_tit_ap = b_usuar.log_habilit_correc_tit_ap
               usuar_financ_estab_apb.log_habilit_estorn_ap     = b_usuar.log_habilit_estorn_ap
               usuar_financ_estab_apb.log_habilit_alter_tit_ap  = b_usuar.log_habilit_alter_tit_ap
               usuar_financ_estab_apb.log_habilit_enctro_cta    = b_usuar.log_habilit_enctro_cta
               usuar_financ_estab_apb.log_habilit_cancel_tit_ap = b_usuar.log_habilit_cancel_tit_ap
               usuar_financ_estab_apb.log_habilit_mutuo_pagto   = b_usuar.log_habilit_mutuo_pagto
               usuar_financ_estab_apb.val_lim_liber_usuar_movto = b_usuar.val_lim_liber_usuar_movto
               usuar_financ_estab_apb.val_lim_liber_usuar_mes   = b_usuar.val_lim_liber_usuar_mes
               usuar_financ_estab_apb.val_lim_pagto_usuar_movto = b_usuar.val_lim_pagto_usuar_movto
               usuar_financ_estab_apb.val_lim_pagto_usuar_mes   = b_usuar.val_lim_pagto_usuar_mes
               usuar_financ_estab_apb.log_habilita_unid_organ   = b_usuar.log_habilita_unid_organ
               usuar_financ_estab_apb.log_habilita_cta_ctbl     = b_usuar.log_habilita_cta_ctbl
               usuar_financ_estab_apb.log_habilita_ccusto       = b_usuar.log_habilita_ccusto
               usuar_financ_estab_apb.log_habilita_tip_fluxo    = b_usuar.log_habilita_tip_fluxo
               usuar_financ_estab_apb.log_habilita_estab        = b_usuar.log_habilita_estab
               usuar_financ_estab_apb.log_habilit_alter_juros   = b_usuar.log_habilit_alter_juros
               usuar_financ_estab_apb.log_habilit_alter_vencto  = b_usuar.log_habilit_alter_vencto
               usuar_financ_estab_apb.log_habilit_alter_sdo     = b_usuar.log_habilit_alter_sdo.
    END.

END.
