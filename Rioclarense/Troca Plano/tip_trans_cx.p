    OUTPUT TO c:\desenv\tp_trans_cx.txt.
    FOR EACH tip_trans_cx_cta_ctbl NO-LOCK:

        FIND FIRST tip_trans_cx NO-LOCK WHERE tip_trans_cx.cod_tip_trans_cx = tip_trans_cx_cta_ctbl.cod_tip_trans_cx NO-ERROR.

        PUT UNFORMATTED tip_trans_cx_cta_ctbl.cod_tip_trans_cx ";"
                        tip_trans_cx.des_tip_trans_cx ";"
                        tip_trans_cx_cta_ctbl.cod_cta_corren ";"
                        tip_trans_cx_cta_ctbl.cod_cta_ctbl
                        SKIP.
                        


    END.
