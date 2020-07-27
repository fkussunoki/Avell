/******************************************************************************
**  Include...: esof0520G.I
**  Objetivo..: Grava variavel c-cfop 
******************************************************************************/ 
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> {1} then
        for first natur-oper fields( nat-operacao char-2 cd-situacao emite-duplic )
            where natur-oper.nat-operacao = {1} no-lock:
        end.

       assign i-formato-cfop  = if  trim(substr(natur-oper.char-2,78,10)) <> " "
                                then length(trim(replace(substr(natur-oper.char-2,78,10),".","")))
                                else 3
              c-formato-cfop  = if  trim(substr(natur-oper.char-2,78,10)) <> " "
                                then trim(substring(natur-oper.char-2,78,10))
                                else "9.99"
              c-cfop          = {cdp/cd0620.i2 "doc-fiscal" doc-fiscal.dt-docto "'9.999XX'" c-formato-cfop}.   

  
/* fim da include */
