for each tit_acr no-lock where tit_acr.cod_estab = ""
                        and    tit_acr.cod_tit_acr = ""
                        and    tit_acr.cod_parcela = ""
                        and    tit_acr.cod_ser_docto = "":


        for each movto_ocor_bcia no-lock where movto_ocor_bcia.cod_estab = tit_acr.cod_estab
                                        and    movto_ocor_bcia.num_id_tit_acr = tit_acr.num_id_tit_acr
                                        :

            message movto_ocor_bcia.num_id_movto_tit_acr
                    movto_ocor_bcia.num_id_movto_ocor_bcia.

                    for each movto-estoq where movto-estoq.esp-docto