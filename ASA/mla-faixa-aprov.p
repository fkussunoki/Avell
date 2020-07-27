define buffer b-mla-faixa-aprov for mla-faixa-aprov.

define temp-table tt-lotacao
field ttv-lotacao as char.

input from c:\desenv\lotacao.txt.

repeat:
    create tt-lotacao.
    import tt-lotacao.
end.

for each tt-lotacao:

    for each b-mla-faixa-aprov where b-mla-faixa-aprov.cod-estabel = "001"
                               and   b-mla-faixa-aprov.cod-lotacao = "11211"
                               and   b-mla-faixa-aprov.cod-tip-doc = 24:

                                find first mla-faixa-aprov no-lock where mla-faixa-aprov.cod-estabel = b-mla-faixa-aprov.cod-estabel
                                                                   and   mla-faixa-aprov.cod-lotacao = tt-lotacao.ttv-lotacao
                                                                   and   mla-faixa-aprov.num-faixa   = b-mla-faixa-aprov.num-faixa
                                                                   and   mla-faixa-aprov.cod-tip-doc = 24
                                                                   no-error.

                                                                   if not avail mla-faixa-aprov then do:


                                create mla-faixa-aprov.
                                assign mla-faixa-aprov.cod-tip-doc = 24
                                       mla-faixa-aprov.cod-estabel = b-mla-faixa-aprov.cod-estabel
                                       mla-faixa-aprov.cod-lotacao = tt-lotacao.ttv-lotacao
                                       mla-faixa-aprov.num-faixa   = b-mla-faixa-aprov.num-faixa
                                       mla-faixa-aprov.des-faixa   = b-mla-faixa-aprov.des-faixa
                                       mla-faixa-aprov.ep-codigo   = b-mla-faixa-aprov.ep-codigo
                                       mla-faixa-aprov.limite-fim  = b-mla-faixa-aprov.limite-fim
                                       mla-faixa-aprov.limite-ini  = b-mla-faixa-aprov.limite-ini.
                                                                   end.
                               end.
                            end.
