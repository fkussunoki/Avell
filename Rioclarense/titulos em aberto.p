OUTPUT TO c:\desenv\tit_aberto.txt.

DEFINE VAR h-prog AS HANDLE.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Imprimindo").
    
FOR EACH tit_ap USE-INDEX titap_id NO-LOCK WHERE tit_ap.log_sdo_tit_ap = YES
    AND   tit_ap.log_tit_ap_estordo = NO:

    RUN pi-acompanhar IN h-prog (INPUT string(tit_ap.dat_emis_docto) + " " + tit_ap.cod_estab).


    FIND FIRST movto_tit_ap NO-LOCK WHERE movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                    AND   movto_tit_ap.ind_trans_ap_abrev = "impl" 
                                    and   movto_tit_ap.cod_estab     = tit_ap.cod_estab NO-ERROR.
                                    
                                    if avail movto_tit_ap then do:



                                        FOR EACH aprop_ctbl_ap NO-LOCK WHERE aprop_ctbl_ap.cod_empresa = movto_tit_ap.cod_empresa
                                                                       AND   aprop_ctbl_ap.cod_estab   = movto_tit_ap.cod_estab
                                                                       AND   aprop_ctbl_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                                                                       AND   aprop_ctbl_ap.ind_tip_aprop_ctbl = "SALDO"
                                                                       :


    PUT UNFORMATTED tit_ap.cod_estab ";"
                    tit_ap.cod_espec_docto ";"
                    tit_ap.cod_ser_docto ";"
                    tit_ap.cdn_fornecedor ";"
                    tit_ap.cod_tit_ap ";"
                    tit_ap.val_origin_tit_ap ";"
                    tit_ap.val_sdo_tit_ap ";"
                    tit_ap.dat_transacao ";"
                    tit_ap.dat_emis_docto ";"
                    tit_ap.dat_vencto_tit_ap ";"
                    movto_tit_ap.cod_usuario ";"
                    movto_tit_ap.log_ctbz_aprop_ctbl ";"    
                    movto_tit_ap.log_aprop_ctbl_ctbzda ";"
                    aprop_ctbl_ap.cod_cta_ctbl
                    SKIP.
                   

          end.          
    END.
END.
RUN pi-finalizar IN h-prog.
