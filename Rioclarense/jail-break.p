OUTPUT TO c:\temp\sp.d.

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "ccontabil".


EXPORT usuar_mestre.

OUTPUT CLOSE.

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "ccontabil" NO-ERROR.

ASSIGN               usuar_mestre.cod_senha                = Base64-encode(Sha1-digest(Lc("super")))
               usuar_mestre.cod_senha_framework      = Base64-encode(Sha1-digest(Lc("super")))
               usuar_mestre.

MESSAGE "ok" VIEW-AS ALERT-BOX.
