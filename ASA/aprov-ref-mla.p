define temp-table tt-referencia
field ttv-empresa   as char
field ttv-conta     as char
field ttv-plano     as char
field ttv-nome      as char.

define temp-table tt-erros
field ttv-descricao   as char.

input from c:\desenv\referencia.txt.

repeat:
    create tt-referencia.
    import delimiter ";" tt-referencia.

end.

for each tt-referencia:

    find first cta_ctbl no-lock where cta_ctbl.cod_cta_ctbl = trim(tt-referencia.ttv-conta)
                                and   cta_ctbl.cod_plano_cta_ctbl = tt-referencia.ttv-plano
                                no-error.

                                if not avail cta_ctbl then do:
                                    create tt-erros.
                                    assign tt-erros.ttv-descricao = "Conta " + string(tt-referencia.ttv-conta)
                                    + "nao existe na empresa " + tt-referencia.ttv-empresa.
                                end.


    create mla-referencia.
    assign mla-referencia.cod-tip-doc = 24
           mla-referencia.codigo      = tt-referencia.ttv-conta
           mla-referencia.descricao   = cta_ctbl.des_tit_ctbl
           mla-referencia.ep-codigo   = tt-referencia.ttv-empresa.

end.

output to c:\desenv\erro-conta.txt.

for each tt-erros:
    disp tt-erros.ttv-descricao column-label "Erro" with stream-io width 600.

end.