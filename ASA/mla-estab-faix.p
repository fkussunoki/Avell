def buffer b-mla-faixa-aprov for mla-faixa-aprov.

for each estabelec where estabelec.ep-codigo = "1":

for each b-mla-faixa-aprov no-lock where b-mla-faixa-aprov.cod-tip-doc = 24
                                   and   b-mla-faixa-aprov.cod-estabel = "001":

                                    find first mla-faixa-aprov where mla-faixa-aprov.cod-estabel = estabelec.cod-estabel
                                                               and   mla-faixa-aprov.cod-lotacao = b-mla-faixa-aprov.cod-lotacao
                                                               and   mla-faixa-aprov.cod-tip-doc = b-mla-faixa-aprov.cod-tip-doc
                                                               and   mla-faixa-aprov.ep-codigo   = b-mla-faixa-aprov.ep-codigo
                                                               and   mla-faixa-aprov.num-faixa   = b-mla-faixa-aprov.num-faixa no-error.

                                                               if not avail mla-faixa-aprov then do:

                                                                create mla-faixa-aprov.
                                                                assign mla-faixa-aprov.num-faixa = b-mla-faixa-aprov.num-faixa
                                                                       mla-faixa-aprov.cod-estabel = estabelec.cod-estabel
                                                                       mla-faixa-aprov.cod-lotacao = b-mla-faixa-aprov.cod-lotacao
                                                                       mla-faixa-aprov.cod-tip-doc = b-mla-faixa-aprov.cod-tip-doc
                                                                       mla-faixa-aprov.des-faixa   = b-mla-faixa-aprov.des-faixa
                                                                       mla-faixa-aprov.ep-codigo   = b-mla-faixa-aprov.ep-codigo
                                                                       mla-faixa-aprov.limite-fim  = b-mla-faixa-aprov.limite-fim
                                                                       mla-faixa-aprov.limite-ini  = b-mla-faixa-aprov.limite-ini.
                                                               end.
                                                            end.
                                                        end.