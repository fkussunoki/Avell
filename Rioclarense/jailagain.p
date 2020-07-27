DEFINE TEMP-TABLE tt-usuario LIKE usuar_mestre.

INPUT FROM c:\temp\sp.d.

REPEAT:
    CREATE tt-usuario.
    IMPORT tt-usuario.
END.

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "ccontabil" NO-ERROR.

ASSIGN               usuar_mestre.cod_senha                = tt-usuario.cod_senha
                     usuar_mestre.cod_senha_framework      = tt-usuario.cod_senha_framework.

MESSAGE "ok" VIEW-AS ALERT-BOX.

