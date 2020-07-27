/******************************************************************************
**  Include...: esof0520F.I
**  Objetivo..: Display da coluna de observacao 
******************************************************************************/


    if  ((  c-estado = "SP"
         or c-estado = "MG"
         or c-estado = "PE"
         or c-estado = "RS")
    and doc-fiscal.vl-icms-com > 0) then do:
        if  l-prim-txt = yes then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-difaliqicms AS CHARACTER FORMAT "X(16)" NO-UNDO.
            {utp/ut-liter.i "Dif.Aliq.ICMS" *}
            ASSIGN c-lbl-liter-difaliqicms = TRIM(RETURN-VALUE).
            put c-lbl-liter-difaliqicms + "=" at i-posicao[8].
            assign l-prim-txt = no.
        end.
        else
            if  l-prim-vlr = yes then do:
                put "(" at i-posicao[8]
                    doc-fiscal.vl-icms-com format ">>>>>,>>9.99"
                    ")".
                assign l-prim-vlr = no.
            end.
    end.
put skip.
/* esof0520f.i */
