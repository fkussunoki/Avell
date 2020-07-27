DEFINE NEW GLOBAL SHARED TEMP-TABLE ttg-dpd607-sell-in
    FIELD numero   LIKE amkt-solicitacao-sell-in.numero
    FIELD ano      LIKE amkt-solicitacao-sell-in.ano
    FIELD tipo     AS INT
    FIELD des-tipo AS CHAR FORMAT "x(12)"
    FIELD vl-tipo  LIKE amkt-solicitacao-sell-in.vl-faturamento
    INDEX id-tt-sell-in IS UNIQUE
          numero
          ano
          tipo.
