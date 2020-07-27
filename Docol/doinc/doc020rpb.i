/*******************************************************************************
** Include: doc020rpb.i
**  Fun‡Æo: Confere valores de contabiliza‡Æo dos encargos
*******************************************************************************/
  
def temp-table tt-mov-enc field cdn-encargo   like rh-encargo.cdn-encargo
                          field cod-rh-ccusto like rh-mov-encarg.cod-rh-ccusto
                          field i-func        as i  format ">,>>9"         label "Funcs"
                          field vl-base       as de format ">>,>>>,>>9.99" label "Valor Base"
                          field vl-encargo    as de format ">,>>>,>>9.99"  label "Valor Encargo".

for each tt-mov-enc.
   delete tt-mov-enc.
end.

run pi-acompanhar in h-acomp ("Montando Valores dos Encargos").  

for each rh-encargo no-lock
   where rh-encargo.tipo        <> "Estorno"
     and rh-encargo.cdn-encargo >= i-encarg-ini
     and rh-encargo.cdn-encargo <= i-encarg-fim:
   for each rh-mov-encarg no-lock
      where rh-mov-encarg.cdn-empresa    = INT(trad_org_ext.cod_unid_organ_ext)
        and rh-mov-encarg.ano            = i-ano
        and rh-mov-encarg.mes            = i-mes
        and rh-mov-encarg.cdn-encargo    = rh-encargo.cdn-encargo
        and rh-mov-encarg.cod-rh-ccusto >= c-ccusto-ini
        and rh-mov-encarg.cod-rh-ccusto <= c-ccusto-fim:

      find first tt-mov-enc no-lock  
           where tt-mov-enc.cdn-encargo   = rh-mov-encarg.cdn-encargo
             and tt-mov-enc.cod-rh-ccusto = rh-mov-encarg.cod-rh-ccusto
             no-error.
      if not avail tt-mov-enc then do:
         create tt-mov-enc.
         assign tt-mov-enc.cdn-encargo   = rh-mov-encarg.cdn-encargo
                tt-mov-enc.cod-rh-ccusto = rh-mov-encarg.cod-rh-ccusto.
      end.
   
      assign tt-mov-enc.vl-base   = tt-mov-enc.vl-base   + rh-mov-encarg.vl-base-encarg
             tt-mov-enc.vl-encarg = tt-mov-enc.vl-encarg + rh-mov-encarg.vl-encarg
             tt-mov-enc.i-func    = tt-mov-enc.i-func    + (if rh-encargo.tipo = "Beneficio" 
                                                               then rh-mov-encarg.vl-estorno
                                                               else 0).
   end.
end.   
  
  
put unformatted 
    skip(1)
    "Mes: " c-mes[i-mes] "/" i-ano skip(1).
 
for each rh-encargo no-lock,
    each tt-mov-enc no-lock
   where tt-mov-enc.cdn-encargo = rh-encargo.cdn-encargo
   break by rh-encargo.cdn-encargo 
         by tt-mov-enc.cod-rh-ccusto:
           
   find first rh_ccusto no-lock
        where rh_ccusto.cdn_empresa   = trad_org_ext.cod_unid_organ_ext
          and rh_ccusto.cod_rh_ccusto = tt-mov-enc.cod-rh-ccusto no-error.
          
   accumulate tt-mov-enc.vl-base   (total by rh-encargo.cdn-encargo).
   accumulate tt-mov-enc.i-func    (total by rh-encargo.cdn-encargo).
   accumulate tt-mov-enc.vl-encarg (total by rh-encargo.cdn-encargo).
   
   IF l-abre-ccusto THEN DO:
      disp rh-encargo.cdn-encargo   when first-of(rh-encargo.cdn-encargo)
           rh-encargo.des-encargo   when first-of(rh-encargo.cdn-encargo)
           rh-encargo.perc-encarg   when first-of(rh-encargo.cdn-encargo)
           rh-encargo.tipo          when first-of(rh-encargo.cdn-encargo)
           tt-mov-enc.cod-rh-ccusto  
           rh_ccusto.des_rh_ccusto when avail rh_ccusto format "x(25)"
           tt-mov-enc.vl-base
           tt-mov-enc.i-func
           tt-mov-enc.vl-encarg
           with width 150 no-box stream-io down frame f-ccusto.
      down with frame f-ccusto.
   END.
   
   if last-of(rh-encargo.cdn-encargo) then do:
      IF l-abre-ccusto THEN
         UNDERLINE tt-mov-enc.vl-base
                   tt-mov-enc.i-func   
                   tt-mov-enc.vl-encarg WITH FRAME f-ccusto.
      disp rh-encargo.cdn-encargo
           rh-encargo.des-encargo
           rh-encargo.perc-encarg
           rh-encargo.tipo
           "TOTAL"                                                      @ rh_ccusto.des_rh_ccusto
           (ACCUM TOTAL BY rh-encargo.cdn-encargo tt-mov-enc.vl-base)   @ tt-mov-enc.vl-base 
           (ACCUM TOTAL BY rh-encargo.cdn-encargo tt-mov-enc.i-func)    @ tt-mov-enc.i-func
           (ACCUM TOTAL BY rh-encargo.cdn-encargo tt-mov-enc.vl-encarg) @ tt-mov-enc.vl-encarg
           with frame f-ccusto.
      down with frame f-ccusto.
   end.
end.

/* doc020rpb.i */
