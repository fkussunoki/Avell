DEF VAR h-prog AS HANDLE.
DEF BUFFER b_compos FOR compos_demonst_ctbl.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.


RUN pi-inicializar IN h-prog (INPUT "Gerando").



FOR EACH compos_demonst_ctbl WHERE compos_demonst_ctbl.cod_demonst_ctbl = "Adm_fin"
                             AND   compos_demonst_ctbl.cod_unid_organ = "blz"
                             //AND   compos_demonst_ctbl.cod_plano_ccusto <> ""
                             :
RUN pi-acompanhar IN h-prog (INPUT string(compos_demonst_ctbl.num_seq_demonst_ctbl) + " " + string(compos_demonst_ctbl.num_seq_compos_demonst)).

    /* ASSIGN compos_demonst_ctbl.cod_ccusto_inic = "0000" */

           /* compos_demonst_ctbl.cod_ccusto_fim = "9999". */

CREATE b_compos.
ASSIGN b_compos.cod_demonst_ctbl            = compos_demonst_ctbl.cod_demonst_ctbl
       b_compos.num_seq_demonst_ctbl        = compos_demonst_ctbl.num_seq_demonst_ctbl 
       b_compos.num_seq_compos_demonst      = compos_demonst_ctbl.num_seq_compos_demonst + 5
       b_compos.cod_unid_organ              = "mae"
       b_compos.cod_estab_inic              = compos_demonst_ctbl.cod_estab_inic
       b_compos.cod_estab_fim               = compos_demonst_ctbl.cod_estab_fim
       b_compos.cod_unid_negoc_inic         = compos_demonst_ctbl.cod_unid_negoc_inic
       b_compos.cod_unid_negoc_fim          = compos_demonst_ctbl.cod_unid_negoc_fim
       b_compos.cod_plano_cta_ctbl          = compos_demonst_ctbl.cod_plano_cta_ctbl
       b_compos.cod_cta_ctbl_inic           = compos_demonst_ctbl.cod_cta_ctbl_inic
       b_compos.cod_cta_ctbl_fim            = compos_demonst_ctbl.cod_cta_ctbl_fim
       b_compos.cod_cta_ctbl_pfixa          = compos_demonst_ctbl.cod_cta_ctbl_pfixa
       b_compos.cod_cta_ctbl_excec          = compos_demonst_ctbl.cod_cta_ctbl_excec
       b_compos.ind_espec_cta_ctbl_consid   = compos_demonst_ctbl.ind_espec_cta_ctbl_consid
       b_compos.cod_plano_ccusto            = compos_demonst_ctbl.cod_plano_ccusto
       b_compos.cod_ccusto_inic             = compos_demonst_ctbl.cod_ccusto_inic
       b_compos.cod_ccusto_fim              = compos_demonst_ctbl.cod_ccusto_fim
       b_compos.cod_ccusto_pfixa            = compos_demonst_ctbl.cod_ccusto_pfixa
       b_compos.cod_ccusto_excec            = compos_demonst_ctbl.cod_ccusto_excec
       b_compos.log_ccusto_sint             = compos_demonst_ctbl.log_ccusto_sint
       b_compos.log_inverte_val             = compos_demonst_ctbl.log_inverte_val
       b_compos.des_formul_ctbl             = compos_demonst_ctbl.des_formul_ctbl
       b_compos.cod_unid_organ_fim          = "mae"
       b_compos.cod_proj_financ_inic        = compos_demonst_ctbl.cod_proj_financ_inic
       b_compos.cod_proj_financ_fim         = compos_demonst_ctbl.cod_proj_financ_fim
       b_compos.cod_proj_financ_pfixa       = compos_demonst_ctbl.cod_proj_financ_pfixa
       b_compos.cod_proj_financ_excec       = compos_demonst_ctbl.cod_proj_financ_excec
       b_compos.cod_proj_financ_inicial     = compos_demonst_ctbl.cod_proj_financ_inicial
       b_compos.ind_tip_ccusto_consid       = compos_demonst_ctbl.ind_tip_ccusto_consid.

END.


RUN pi-finalizar IN h-prog.
