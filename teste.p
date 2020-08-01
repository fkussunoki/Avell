for each b-ext_roteiro_fechamento where ext_roteiro_fechamento.periodo = "062020":

    create ext_roteiro_fechamento.
    assign ext_roteiro_fechamento.periodo       = "072020"
           ext_roteiro_fechamento.periodicidade = b_ext_roteiro_fechamento.periodicidade
           ext_roteiro_fechamento.programa      = b_ext_roteiro_fechamento.programa
           ext_roteiro_fechamento.responsavel   = b_ext_roteiro_fechamento.responsavel
           ext_roteiro_fechamento.rotina        = b_ext_roteiro_fechamento.rotina
           ext_roteiro_fechamento.setor         = b_ext_roteiro_fechamento.setor.