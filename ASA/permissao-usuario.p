define buffer b-mla-hierarquia-faixa for mla-hierarquia-faixa.
for each estabelec where estabelec.ep-codigo = "1":

    for each b-mla-hierarquia-faixa where b-mla-hierarquia-faixa.cod-estabel = "001"
                                  and     b-mla-hierarquia-faixa.cod-tip-doc = 24:

                                    find first mla-hierarquia-faixa where mla-hierarquia-faixa.cod-tip-doc = b-mla-hierarquia-faixa.cod-tip-doc
                                                                    and   mla-hierarquia-faixa.cod-lotacao = b-mla-hierarquia-faixa.cod-lotacao
                                                                    and   mla-hierarquia-faixa.cod-estabel = estabelec.cod-estabel
                                                                    and   mla-hierarquia-faixa.num-faixa   = b-mla-hierarquia-faixa.num-faixa no-error.

                                                                    if not avail mla-hierarquia-faixa then do:

                                                                        create mla-hierarquia-faixa.
                                                                        assign mla-hierarquia-faixa.num-faixa = b-mla-hierarquia-faixa.num-faixa
                                                                               mla-hierarquia-faixa.seq-aprov = b-mla-hierarquia-faixa.seq-aprov
                                                                               mla-hierarquia-faixa.cod-estabel = estabelec.cod-estabel
                                                                               mla-hierarquia-faixa.cod-lotacao = b-mla-hierarquia-faixa.cod-lotacao
                                                                               mla-hierarquia-faixa.cod-tip-doc = 24
                                                                               mla-hierarquia-faixa.cod-usuar   = b-mla-hierarquia-faixa.cod-usuar
                                                                               mla-hierarquia-faixa.ep-codigo   = estabelec.ep-codigo
                                                                               mla-hierarquia-faixa.log-depend  = no.
                                                                    end.
                                                                end.
                                                            end.