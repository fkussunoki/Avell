for each mla-hierarquia-faixa:

    find first mla-perm-aprov where mla-perm-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar
                              and   mla-perm-aprov.ep-codigo = mla-hierarquia-faixa.ep-codigo
                              and   mla-perm-aprov.cod-tip-doc = mla-hierarquia-faixa.cod-tip-doc
                              and   mla-perm-aprov.cod-estabel = mla-hierarquia-faixa.cod-estabel no-error.

                              if not avail mla-perm-aprov then do:



                                create mla-perm-aprov.
                                assign mla-perm-aprov.cod-estabel = mla-hierarquia-faixa.cod-estabel
                                       mla-perm-aprov.cod-tip-doc = mla-hierarquia-faixa.cod-tip-doc
                                       mla-perm-aprov.cod-usuar   = mla-hierarquia-faixa.cod-usuar
                                       mla-perm-aprov.ep-codigo   = mla-hierarquia-faixa.ep-codigo
                                       mla-perm-aprov.limite-aprov = 99999999.99
                                       mla-perm-aprov.validade-fim = 12/31/9999
                                       mla-perm-aprov.validade-ini = 01/01/0001
                                       mla-perm-aprov.aprova-auto-aprov = no
                                       .
                              end.
                            end. 