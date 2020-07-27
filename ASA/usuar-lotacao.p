input from c:\desenv\usuar-lotacao.txt.

define temp-table tt-lotacao
field ttv-cod-lotacao as char
field ttv-faixa-1     as integer
field ttv-usuar-1     as char
field ttv-faixa-2     as integer
field ttv-usuar-2     as char
field ttv-faixa-3     as integer
field ttv-usuar-3     as char
field ttv-faixa-4     as integer
field ttv-usuar-4     as char
field ttv-faixa-5     as integer
field ttv-usuar-5     as char.

repeat:
    create tt-lotacao.
    import delimiter ";" tt-lotacao.
end.

for each tt-lotacao:
    create mla-hierarquia-faixa.
    assign mla-hierarquia-faixa.ep-codigo = "1"
           mla-hierarquia-faixa.log-depend = no
           mla-hierarquia-faixa.num-faixa  = tt-lotacao.ttv-faixa-1
           mla-hierarquia-faixa.seq-aprov  = 10
           mla-hierarquia-faixa.cod-estabel = "001"
           mla-hierarquia-faixa.cod-lotacao = tt-lotacao.ttv-cod-lotacao
           mla-hierarquia-faixa.cod-tip-doc = 24
           mla-hierarquia-faixa.cod-usuar   = tt-lotacao.ttv-usuar-1
           .
           create mla-hierarquia-faixa.
           assign mla-hierarquia-faixa.ep-codigo = "1"
                  mla-hierarquia-faixa.log-depend = no
                  mla-hierarquia-faixa.num-faixa  = tt-lotacao.ttv-faixa-2
                  mla-hierarquia-faixa.seq-aprov  = 10
                  mla-hierarquia-faixa.cod-estabel = "001"
                  mla-hierarquia-faixa.cod-lotacao = tt-lotacao.ttv-cod-lotacao
                  mla-hierarquia-faixa.cod-tip-doc = 24
                  mla-hierarquia-faixa.cod-usuar   = tt-lotacao.ttv-usuar-2
                  .           

                  create mla-hierarquia-faixa.
                  assign mla-hierarquia-faixa.ep-codigo = "1"
                         mla-hierarquia-faixa.log-depend = no
                         mla-hierarquia-faixa.num-faixa  = tt-lotacao.ttv-faixa-3
                         mla-hierarquia-faixa.seq-aprov  = 10
                         mla-hierarquia-faixa.cod-estabel = "001"
                         mla-hierarquia-faixa.cod-lotacao = tt-lotacao.ttv-cod-lotacao
                         mla-hierarquia-faixa.cod-tip-doc = 24
                         mla-hierarquia-faixa.cod-usuar   = tt-lotacao.ttv-usuar-3
                         .                  
                create mla-hierarquia-faixa.
                assign mla-hierarquia-faixa.ep-codigo = "1"
                    mla-hierarquia-faixa.log-depend = no
                    mla-hierarquia-faixa.num-faixa  = tt-lotacao.ttv-faixa-4
                    mla-hierarquia-faixa.seq-aprov  = 10
                    mla-hierarquia-faixa.cod-estabel = "001"
                    mla-hierarquia-faixa.cod-lotacao = tt-lotacao.ttv-cod-lotacao
                    mla-hierarquia-faixa.cod-tip-doc = 24
                    mla-hierarquia-faixa.cod-usuar   = tt-lotacao.ttv-usuar-4
                    .                  
                    create mla-hierarquia-faixa.
                    assign mla-hierarquia-faixa.ep-codigo = "1"
                           mla-hierarquia-faixa.log-depend = no
                           mla-hierarquia-faixa.num-faixa  = tt-lotacao.ttv-faixa-5
                           mla-hierarquia-faixa.seq-aprov  = 10
                           mla-hierarquia-faixa.cod-estabel = "001"
                           mla-hierarquia-faixa.cod-lotacao = tt-lotacao.ttv-cod-lotacao
                           mla-hierarquia-faixa.cod-tip-doc = 24
                           mla-hierarquia-faixa.cod-usuar   = tt-lotacao.ttv-usuar-5
                           .                  

end.
  
       