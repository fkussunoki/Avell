def buffer b-mla-hierarquia-faixa for mla-hierarquia-faixa.

for each b-mla-hierarquia-faixa where b-mla-hierarquia-faixa.cod-tip-doc = 24
                                and   b-mla-hierarquia-faixa.ep-codigo   = "1":

                                    create mla-hierarquia-faixa.
                                    assign mla-hierarquia-faixa.ep-codigo = "1"
                                           mla-hierarquia-faixa.log-depend = no
                                           mla-hierarquia-faixa.num-faixa  = b-mla-hierarquia-faixa.num-faixa
                                           mla-hierarquia-faixa.seq-aprov  = b-mla-hierarquia-faixa.seq-aprov
                                           mla-hierarquia-faixa.cod-estabel = b-mla-hierarquia-faixa.cod-estabel
                                           mla-hierarquia-faixa.cod-lotacao = b-mla-hierarquia-faixa.cod-lotacao
                                           mla-hierarquia-faixa.cod-tip-doc = 25
                                           mla-hierarquia-faixa.cod-usuar   = b-mla-hierarquia-faixa.cod-usuar
                                           .
                                end. 