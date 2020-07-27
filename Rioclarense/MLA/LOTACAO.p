INPUT FROM c:\temp\lotacoes.txt.

DEFINE TEMP-TABLE tt-lotacoes
    FIELD cod-lotacao AS char
    FIELD desc-lotacao AS char.


REPEAT:
    CREATE tt-lotacoes.
    IMPORT DELIMITER ";" tt-lotacoes.
END.


FOR EACH tt-lotacoes:

    CREATE mla-lotacao.
    ASSIGN mla-lotacao.cod-lotacao = tt-lotacoes.cod-lotacao
           mla-lotacao.desc-lotacao = tt-lotacoes.desc-lotacao.
END.

MESSAGE "concluido" VIEW-AS ALERT-BOX.
