/******************************************************************************
**  Include...: OF0520G.I
**  Objetivo..: Grava variavel c-cfop 
******************************************************************************/ 
    
IF NOT AVAIL natur-oper
OR natur-oper.nat-operacao <> {1} then
    FOR FIRST natur-oper 
        WHERE natur-oper.nat-operacao = {1} NO-LOCK:
    END.

ASSIGN i-formato-cfop  = if  substr(natur-oper.char-2,78,10) <> " "
                        then length(trim(replace(substr(natur-oper.char-2,78,10),".","")))
                        else 3
       c-formato-cfop  = if  substr(natur-oper.char-2,78,10) <> " "
                        then trim(substring(natur-oper.char-2,78,10))
                        else "9.99".
IF AVAIL doc-fiscal THEN
  ASSIGN c-cfop = {cdp/cd0620.i2 "doc-fiscal" doc-fiscal.dt-docto "'9.999XX'" c-formato-cfop}.
ELSE 
  ASSIGN c-cfop = {cdp/cd0620.i2 "natur-oper" da-est-ini "'9.999XX'" c-formato-cfop}.  


/* fim da include */

