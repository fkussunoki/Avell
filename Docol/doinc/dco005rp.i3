
CREATE dc-orig-comis-movto.
ASSIGN dc-orig-comis-movto.num_id_comis_movto         = dc-comis-movto.num_id_comis_movto
       dc-orig-comis-movto.cod_empresa                = tt-repres.cod_empresa
       dc-orig-comis-movto.cdn_repres                 = tt-repres.cdn_repres  
       dc-orig-comis-movto.num_seq_movto_comis        = tt-movto.num_seq_movto_comis
       dc-orig-comis-movto.cod_estab                  = tt-movto.cod_estab
       dc-orig-comis-movto.num_id_tit_acr             = tt-movto.num_id_tit_acr     
       dc-orig-comis-movto.dat_transacao              = if avail movto_comis_repres then 
                                                            movto_comis_repres.dat_transacao
                                                        else
                                                            tt-movto.dat_emis_docto
       dc-orig-comis-movto.val_perc_comis_repres      = tt-movto.val_perc_comis_repres      
       dc-orig-comis-movto.val_perc_comis_repres_emis = tt-movto.val_perc_comis_repres_emis
       dc-orig-comis-movto.val_base_comis             = tt-movto.val_base_calc_comis     
       dc-orig-comis-movto.val_movto_comis            = de-orig-lancamento
       dc-orig-comis-movto.ind_tip_movto              = if avail movto_comis_repres then 
                                                           movto_comis_repres.ind_tip_movto      
                                                        else
                                                           'NÆo Realizado'
       dc-orig-comis-movto.dat_vencto_tit_acr         = tt-movto.dat_vencto_tit_acr.
                                                      
