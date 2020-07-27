for each mla-hierarquia-faixa:

    find first mla-perm-lotacao where mla-perm-lotacao.cod-lotacao = mla-hierarquia-faixa.cod-lotacao
                                and   mla-perm-lotacao.cod-usuar   = mla-hierarquia-faixa.cod-usuar
                                and   mla-perm-lotacao.ep-codigo   = mla-hierarquia-faixa.ep-codigo
                                no-error.

                                if not avail mla-perm-lotacao then do:

                                    create mla-perm-lotacao.
                                    assign mla-perm-lotacao.ep-codigo = mla-hierarquia-faixa.ep-codigo
                                           mla-perm-lotacao.validade-fim = 12/31/9999
                                           mla-perm-lotacao.validade-ini = 01/01/0001
                                           mla-perm-lotacao.cod-lotacao  = mla-hierarquia-faixa.cod-lotacao
                                           mla-perm-lotacao.cod-usuar    = mla-hierarquia-faixa.cod-usuar
                                           .
                                end.
                            end. 