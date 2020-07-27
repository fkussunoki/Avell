def buffer b-mla-faixa-aprov for mla-faixa-aprov.

for each b-mla-faixa-aprov where b-mla-faixa-aprov.ep-codigo = "1"
                           and   b-mla-faixa-aprov.cod-tip-doc = 24
                           :

                            create mla-faixa-aprov.
                            assign mla-faixa-aprov.cod-tip-doc = 25
                                   mla-faixa-aprov.des-faixa   = b-mla-faixa-aprov.des-faixa
                                   mla-faixa-aprov.ep-codigo   = "1"
                                   mla-faixa-aprov.limite-fim  = b-mla-faixa-aprov.limite-fim
                                   mla-faixa-aprov.limite-ini  = b-mla-faixa-aprov.limite-ini
                                   mla-faixa-aprov.num-faixa   = b-mla-faixa-aprov.num-faixa
                                   mla-faixa-aprov.cod-estabel = b-mla-faixa-aprov.cod-estabel
                                   mla-faixa-aprov.cod-lotacao = b-mla-faixa-aprov.cod-lotacao.
                           end.