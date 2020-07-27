OUTPUT TO c:\desenv\cta_mdo_efp.txt.

FOR EACH cta_mdo_efp NO-LOCK:

    FIND FIRST event_fp NO-LOCK WHERE event_fp.cdn_event_fp = cta_mdo_efp.cdn_event_fp NO-ERROR.

    PUT UNFORMATTED cta_mdo_efp.cdn_empresa ";"
                    cta_mdo_efp.cdn_estab   ";"
                    cta_mdo_efp.cdn_event_fp ";"
                    event_fp.des_event_fp ";"
                    cta_mdo_efp.cod_tip_mdo ";"
                    cta_mdo_efp.cod_rh_cta_ctbl_db ";"
                    cta_mdo_efp.cod_rh_ccusto_db ";"
                    cta_mdo_efp.cod_rh_cta_ctbl_cr ";"
                    cta_mdo_efp.cod_rh_ccusto_cr
                    SKIP.
                    
                    
                    
                    
                    
                    
                    SKIP.

END.
