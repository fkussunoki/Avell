def temp-table tt-planilha no-undo
FIELD ttv-estabel                   AS CHAR
field ttv-status                    as char
field ttv-localizacao-de            as char
field ttv-localizacao-para          as char
field ttv-cta-pat                   as char
field ttv-descricao                 as char
field ttv-cta-pat-para              as char
field ttv-bem-de                    as char
field ttv-inc-de                    as char
field ttv-foto                      as char
field ttv-desmembrar                as LOGICAL INITIAL NO
field ttv-bem-para                  as char
field ttv-inc-para                  as char
field ttv-cc-de                     as char
field ttv-cc-para                   as char
field ttv-dt-aquisicao              as date
field ttv-descricao1                as char
field ttv-descricao-de              as char
field ttv-descricao-para            as char
field ttv-local-de                  as char
field ttv-local-para                as char
field ttv-ps                        as char
field ttv-cod-especie               as char
field ttv-des-especie               as char
field ttv-taxa-conta                as char
field ttv-vlr-original              as char
field ttv-vlr-original-corr         as char
field ttv-depreciacao               as char
field ttv-situacao                  as char
field ttv-nf                        as char
field ttv-fornecedor                as char
field ttv-dt-base-arquivo           as date
field ttv-taxa-societaria           as char
field ttv-residual                  as CHAR
FIELD ttv-tratamento                AS CHAR
FIELD ttv-concatena-de              AS CHAR
field ttv-concatena-para            as char.

for each tt-planilha no-lock:

    find first bem_pat no-lock where bem_pat.cod_cta_pat      = tt-planilha.ttv-cta-pat
                               and   bem_pat.num_bem_pat      = int(tt-planilha.ttv-bem-de)
                               and   bem_pat.num_seq_bem_pat  = int(tt-planilha.ttv-inc-de) no-error.

    if avail bem_pat then do:

    assign tt-planilha.ttv-estabel = bem_pat.cod_estab
           tt-planilha.ttv-concatena-de =   (bem_pat.cod_estab) + "|" + string(bem_pat.cod_cta_pat)          + "|" + string(bem_pat.num_bem_pat)      + "|" + string(bem_pat.num_seq_bem_pat)
           tt-planilha.ttv-concatena-para = (bem_pat.cod_estab) + "|" + string(tt-planilha.ttv-cta-pat-para) + "|" + string(tt-planilha.ttv-bem-para) + "|" + string(tt-planilha.ttv-inc-para).

    end.

    ELSE ASSIGN tt-planilha.ttv-tratamento = "INEXISTENTE NO ATIVO".

end.

for each tt-planilha:

    if entry(1, tt-planilha.ttv-concatena-de, "|") + entry(2, tt-planilha.ttv-concatena-de, "|")  + entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|")
    =  entry(1, tt-planilha.ttv-concatena-para, "|") + entry(2, tt-planilha.ttv-concatena-para, "|")  + entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|")
    then 
    assign tt-planilha.ttv-tratamento = "ALTERACAO".

    if entry(1, tt-planilha.ttv-concatena-de, "|")    +  entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|")
    =  entry(1, tt-planilha.ttv-concatena-para, "|")  +  entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|")
    and entry(2, tt-planilha.ttv-concatena-de, "|")  <> entry(2, tt-planilha.ttv-concatena-para, "|") then
    assign tt-planilha.ttv-tratamento = "RECLASSIFICAR".

    IF entry(1, tt-planilha.ttv-concatena-de, "|")    +  entry(3, tt-planilha.ttv-concatena-de, "|") + entry(4, tt-planilha.ttv-concatena-de, "|") <> 
    entry(1, tt-planilha.ttv-concatena-para, "|")  +  entry(3, tt-planilha.ttv-concatena-para, "|") + entry(4, tt-planilha.ttv-concatena-para, "|") then
    assign tt-planilha.ttv-tratamento = "REIMPLANTAR".

    IF tt-planilha.ttv-desmembrar then
    assign tt-planilha.ttv-tratamento = "DESMEMBRAR".

END.

