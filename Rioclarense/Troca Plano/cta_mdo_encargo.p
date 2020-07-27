OUTPUT TO c:\desenv\cta_mdo_encargo.txt.

FOR EACH cta_mdo_encargo NO-LOCK:

    PUT UNFORMATTED cta_mdo_encargo.idi_tip_guia_encargo_social ";"
                    cta_mdo_encargo.cdn_encargo ";"
                    cta_mdo_encargo.cod_tip_mdo ";"
                    cta_mdo_encargo.cod_rh_cta_ctbl_db ";"
                    cta_mdo_encargo.cod_rh_ccusto_db ";"
                    cta_mdo_encargo.cod_rh_cta_ctbl_cr ";"
                    cta_mdo_encargo.cod_rh_ccusto_cr
                    SKIP.

END.
