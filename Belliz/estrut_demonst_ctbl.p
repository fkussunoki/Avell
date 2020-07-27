DEF VAR h-prog AS HANDLE.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").


FOR EACH ITEM_demonst_ctbl WHERE ITEM_demonst_ctbl.cod_demonst_ctbl >= "1000"
                           AND   ITEM_demonst_ctbl.cod_demonst_ctbl >= "6999"
                           AND   ITEM_demonst_ctbl.ind_tip_compos_demonst <> "F¢rmula":

    RUN pi-acompanhar IN h-prog (INPUT "Demonst " + ITEM_demonst_ctbl.cod_demonst_ctbl + " seq " + string(ITEM_demonst_ctbl.num_seq_demonst_ctbl)).

    FIND FIRST estrut_visualiz_ctbl NO-LOCK WHERE estrut_visualiz_ctbl.cod_demonst_ctbl = ITEM_demonst_ctbl.cod_demonst_ctbl
                                            AND   estrut_visualiz_ctbl.num_seq_demonst_ctbl = ITEM_demonst_ctbl.num_seq_demonst_ctbl NO-ERROR.

    IF NOT avail estrut_visualiz_ctbl THEN DO:
        

        CREATE estrut_visualiz_ctbl.
        ASSIGN estrut_visualiz_ctbl.cod_demonst_ctbl = ITEM_demonst_ctbl.cod_demonst_ctbl
               estrut_visualiz_ctbl.num_seq_demonst_ctbl = ITEM_demonst_ctbl.num_seq_demonst_ctbl
               estrut_visualiz_ctbl.num_seq_estrut_visualiz = 1
               estrut_visualiz_ctbl.ind_inform_estrut_visualiz = "Conta Cont bil"
               estrut_visualiz_ctbl.log_tot_inform_demonst_ctbl = no
               estrut_visualiz_ctbl.log_descr_inform_demonst = YES.
    END.




END.

RUN pi-finalizar IN h-prog.
