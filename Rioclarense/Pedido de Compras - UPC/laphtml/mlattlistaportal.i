DEFINE TEMP-TABLE tt-lista-portal NO-UNDO
    FIELD situacao-doc                  LIKE mla-doc-pend-aprov.ind-situacao   
    FIELD situacao-doc-desc             AS CHARACTER FORMAT "x(15)"
    FIELD nr-trans                      AS INT
    FIELD alternativo                   AS LOGICAL
    FIELD mestre                        AS LOGICAL
    FIELD cod-usuar                     LIKE mla-doc-pend-aprov.cod-usuar
    FIELD mla-doc-pend-aprov-valor-doc  AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>>,>>9.99"
    FIELD chave-doc                     LIKE mla-doc-pend-aprov.chave-doc
    FIELD chave-doc-formatada           AS CHARACTER FORMAT "X(70)"
    FIELD mla-ep-codigo                 LIKE mla-doc-pend-aprov.ep-codigo
    FIELD mla-cod-estabel               LIKE mla-doc-pend-aprov.cod-estabel
    FIELD mla-desc-cod-estabel          LIKE estabelec.nome
    FIELD mla-desc-ep-codigo            LIKE empresa.nome
    FIELD mla-nome-usuar                LIKE mla-usuar-aprov.nome-usuar.                                                             .
