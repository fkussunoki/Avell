/******************************************************************************
**  Include...: esof0540F.I
**  Objetivo..: Display da coluna de observacao 
******************************************************************************/
 
assign c-observa = substring(c-obs-total,i-inicio,12).

if  c-observa <> "" 
and i-inicio < 56 then do:
    put c-observa     at 146    format "x(12)".  /*110*/
    assign i-inicio  = i-inicio + 12.
end.
else
    if  ((  c-estado = "SP":U
/*         or c-estado = "MG"        [ALTERADO PARA INCLUDE esof0540f.i2]      */
         or c-estado = "PE":U
         OR c-estado = "RS":U
         OR c-estado = "RJ":U)
    and doc-fiscal.vl-icms-com > 0 AND l-imp-dif-aliq) then do:
        if  l-prim-txt = yes then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Dif.Ali.ICMS" *}
            put TRIM(RETURN-VALUE) FORMAT "X(12)" at 146.
            assign l-prim-txt = no.
        end.
        else
            if  l-prim-vlr = yes then do:
                put doc-fiscal.vl-icms-com AT 146 format ">>>>>,>>9.99".
                assign l-prim-vlr = no.
            end.
    end.

IF  doc-fiscal.tipo-nat = 3 THEN DO:
    if l-prim-txt = yes then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Serv.Tribut" *}
       put TRIM(RETURN-VALUE) + "." FORMAT "X(12)" at 146 skip.
       if  (LINE-COUNTER + 1 - 1) > page-size then 
           run pi-verifica-linhas in h-esof0540e (line-counter,1,0).
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Pelo_ISSQN" *}
       PUT TRIM(RETURN-VALUE) FORMAT "X(10)" AT 146 SKIP.
       if  (LINE-COUNTER + 1 - 1) > page-size then 
           run pi-verifica-linhas in h-esof0540e (line-counter,1,0).
       put "(" at 146
            doc-fiscal.vl-iss format ">>>,>>9.99" ")".
       
        assign l-prim-txt = no.
    end.
END.

put skip.

/* esof0540f.i */
