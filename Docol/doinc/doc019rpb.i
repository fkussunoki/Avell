/*******************************************************************************
** Include: doc019rpb.i
**  Fun‡Æo: Montar demonstrativo para contabiliza‡Æo
*******************************************************************************/

def temp-table tt-demonst field cdn-encargo like rh-encargo.cdn-encargo
                          field especie     as c
                          field c-ct-contab as c
                          field c-ccusto    as c
                          field lancamen    as log  format "DB/CR"
                          field valor       as de   format "->>,>>>,>>9.99"
                          field tipo        as l    format "Aberto/Fechado"
                          index ch-prim  cdn-encargo
                                         especie
                                         c-ct-contab
                                         c-ccusto
                                         lancamen
                          index ch-conta c-ct-contab
                                         c-ccusto
                                         especie
                                         cdn-encargo                                                                    
                                         lancamen.
                                         
def temp-table tt-diret   field diretoria   as c  format "x(3)"
                          field cdn-encargo as i
                          field especie     as c  format "x(9)"
                          field de-debito   as de format "->>,>>>,>>9.99"
                          field de-credito  as de format "->>,>>>,>>9.99"
                          index ch-prim diretoria
                                        cdn-encargo
                                        especie.

def var c-ccusto          as c                         no-undo.
def var de-debito         as de format ">>,>>>,>>9.99" no-undo.
def var de-credito        as de format ">>,>>>,>>9.99" no-undo.
def var de-ctacc-db       as de format ">>,>>>,>>9.99" no-undo.
def var de-ctacc-cr       as de format ">>,>>>,>>9.99" no-undo.
def var de-conta-db       as de format ">>,>>>,>>9.99" no-undo.
def var de-conta-cr       as de format ">>,>>>,>>9.99" no-undo.
def var de-total-db       as de format ">>,>>>,>>9.99" no-undo.
def var de-total-cr       as de format ">>,>>>,>>9.99" no-undo.
def var c-historico       as c  format "x(50)"         no-undo.

for each rh-ct-encargo NO-LOCK WHERE
         rh-ct-encargo.cdn-encargo >= 0,
   first rh-encargo of rh-ct-encargo no-lock:
   
   run pi-acompanhar in h-acomp ("Encargo " + string(rh-encargo.cdn-encargo) + "-" + rh-encargo.des-encargo + " - " + rh-ct-encargo.cod-tip-mdo).
   
   for each rh-mov-encarg no-lock
      where rh-mov-encarg.cdn-empresa = INT(trad_org_ext.cod_unid_organ_ext)
        and rh-mov-encarg.mes-fp      = i-mes
        and rh-mov-encarg.ano-fp      = i-ano
        and rh-mov-encarg.cdn-encargo = rh-ct-encargo.cdn-encargo
        and rh-mov-encarg.cod-tip-mdo = rh-ct-encargo.cod-tip-mdo:

      if rh-mov-encarg.vl-encargo <> 0 then do:
         /* Debito Encargo */
         if rh-ct-encargo.sc-encarg-db = "xxxxxx" then 
            assign c-ccusto = rh-mov-encarg.cod-rh-ccusto.
         else
            assign c-ccusto = rh-ct-encargo.sc-encarg-db.
   
         find first tt-demonst no-lock
              where tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                and tt-demonst.especie     = rh-encargo.tipo
                and tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-db)
                and tt-demonst.c-ccusto    = c-ccusto
                and tt-demonst.lancamen no-error.
         if not avail tt-demonst then do:
            create tt-demonst.
            assign tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                   tt-demonst.especie     = rh-encargo.tipo
                   tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-db)
                   tt-demonst.c-ccusto    = c-ccusto
                   tt-demonst.lancamen    = yes /* DB */
                   tt-demonst.tipo        = no  /* Fechado */.
         end.
         assign tt-demonst.valor = tt-demonst.valor + rh-mov-encarg.vl-encargo.

         /* Credito Encargo */
         if rh-ct-encargo.sc-encarg-cr = "xxxxxx" then 
            assign c-ccusto = rh-mov-encarg.cod-rh-ccusto.
         else
            assign c-ccusto = rh-ct-encargo.sc-encarg-cr.

         find first tt-demonst no-lock
              where tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                and tt-demonst.especie     = rh-encargo.tipo
                and tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-cr)
                and tt-demonst.c-ccusto    = c-ccusto
                and not tt-demonst.lancamen no-error.
          if not avail tt-demonst then do:
            create tt-demonst.
            assign tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                   tt-demonst.especie     = rh-encargo.tipo
                   tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-cr)
                   tt-demonst.c-ccusto    = c-ccusto
                   tt-demonst.lancamen    = no  /* CR */
                   tt-demonst.tipo        = yes /* Aberto */ . 
         end.
         assign tt-demonst.valor = tt-demonst.valor + rh-mov-encarg.vl-encargo.
      end.
    
      if rh-encargo.estorna-fgts-inss   and
         rh-mov-encarg.vl-estorno <> 0 then do:
 
         /* Debito Estorno */
         if rh-ct-encargo.sc-encarg-cr = "xxxxxx" then 
            assign c-ccusto = rh-mov-encarg.cod-rh-ccusto.
         else
            assign c-ccusto = rh-ct-encargo.sc-encarg-cr.

         find first tt-demonst no-lock
              where tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                and tt-demonst.especie     = "Estorno"
                and tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-cr)
                and tt-demonst.c-ccusto    = c-ccusto
                and tt-demonst.lancamen no-error.
         if not avail tt-demonst then do:
            create tt-demonst.
            assign tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                   tt-demonst.especie     = "Estorno"
                   tt-demonst.c-ct-contab = string(rh-ct-encargo.ct-encarg-cr)
                   tt-demonst.c-ccusto    = c-ccusto
                   tt-demonst.lancamen    = yes /* DB */
                   tt-demonst.tipo        = yes /* Aberto */.
         end.
         assign tt-demonst.valor = tt-demonst.valor + rh-mov-encarg.vl-estorno.

         /* Credito Estorno */
   
         find first tt-demonst no-lock
              where tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                and tt-demonst.especie     = "Estorno"
                and tt-demonst.c-ct-contab = string(rh-encargo.ct-estorno)
                and tt-demonst.c-ccusto    = string(rh-encargo.sc-estorno)
                and not tt-demonst.lancamen no-error.
         if not avail tt-demonst then do:
            create tt-demonst.
            assign tt-demonst.cdn-encargo = rh-ct-encargo.cdn-encargo
                   tt-demonst.especie     = "Estorno"
                   tt-demonst.c-ct-contab = string(rh-encargo.ct-estorno)
                   tt-demonst.c-ccusto    = string(rh-encargo.sc-estorno)
                   tt-demonst.lancamen    = no  /* CR */
                   tt-demonst.tipo        = yes /* Aberto */.
         end.
         assign tt-demonst.valor = tt-demonst.valor + rh-mov-encarg.vl-estorno.
      end.   
   end.
end.

/* Relatorio */ 
IF l-demonstrativo THEN DO:
   for each tt-demonst use-index ch-conta
      break by tt-demonst.c-ct-contab
            by tt-demonst.c-ccusto:
      find first rh-encargo 
           where rh-encargo.cdn-encargo = tt-demonst.cdn-encargo no-error.
      
      if first-of(tt-demonst.c-ccusto) then do:
         run pi-acompanhar in h-acomp ("Conta cont bil " + tt-demonst.c-ct-contab + "." + tt-demonst.c-ccusto).
         find first cta_ctbl no-lock
              where cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
                and cta_ctbl.cod_cta_ctbl       = tt-demonst.c-ct-contab no-error.
         put unformatted
             skip(1)
             "Conta Contabil: " 
             tt-demonst.c-ct-contab.
         if tt-demonst.c-ccusto <> "" then do:
            put unformatted 
                "."
                tt-demonst.c-ccusto.
         end.
             
         if avail cta_ctbl then
            put unformatted 
                " - " cta_ctbl.des_tit_ctbl.
                
         find first emsuni.ccusto no-lock
              where emsuni.ccusto.cod_empresa      = trad_org_ext.cod_unid_organ
                and emsuni.ccusto.cod_plano_ccusto = cc-plano
                and emsuni.ccusto.cod_ccusto       = tt-demonst.c-ccusto no-error.
         if avail emsuni.ccusto then    
            put unformatted 
                " - " ccusto.des_tit_ctbl.
         put skip(1).
      end.
      
      if tt-demonst.lancamen then
         assign de-debito   = tt-demonst.valor
                de-ctacc-db = de-ctacc-db + tt-demonst.valor
                de-credito  = 0.
      else
         assign de-debito   = 0
                de-credito  = tt-demonst.valor
                de-ctacc-cr = de-ctacc-cr + tt-demonst.valor.
        
      find first rh-encargo no-lock
           where rh-encargo.cdn-encargo = tt-demonst.cdn-encargo no-error.
      assign c-historico = tt-demonst.especie + " referente " +
                           rh-encargo.des-encargo.
                
      disp da-corte     column-label "Dt Trans"
           c-historico  column-label "Historico"
           de-debito    column-label "Debito"
           de-credito   column-label "Credito"
           with down width 132 no-box stream-io frame f-corpo.
      down with frame f-corpo.     
   
      /* Resumo por Diretoria */
      if tt-demonst.c-ccusto <> "" then do:
         find first tt-diret 
              where tt-diret.diretoria   = 
                    substr(string(tt-demonst.c-ccusto,"99999"),1,1)
                and tt-diret.cdn-encargo = tt-demonst.cdn-encargo
                and tt-diret.especie     = tt-demonst.especie no-error.
         if not avail tt-diret then do:
            create tt-diret.
            assign tt-diret.diretoria   = 
                   substr(string(tt-demonst.c-ccusto,"99999"),1,1)
                   tt-diret.cdn-encargo = tt-demonst.cdn-encargo
                   tt-diret.especie     = tt-demonst.especie.
         end.
         if tt-demonst.lancamen then
            assign tt-diret.de-debito  = tt-diret.de-debito  + tt-demonst.valor.
         else
            assign tt-diret.de-credito = tt-diret.de-credito + tt-demonst.valor.
      end.
      /* Fim Resumo por Diretoria */   
      
      if last-of(tt-demonst.c-ccusto) then do:
         underline de-debito
                   de-credito
                   with frame f-corpo.
         disp "Total da Conta/CC" @ c-historico
              de-ctacc-db     @ de-debito
              de-ctacc-cr     @ de-credito
              with frame f-corpo.
         down with frame f-corpo.
         assign de-conta-db = de-conta-db + de-ctacc-db
                de-conta-cr = de-conta-cr + de-ctacc-cr
                de-ctacc-db = 0
                de-ctacc-cr = 0.
      end.

      IF LAST-OF(tt-demonst.c-ct-conta) THEN DO:
         underline de-debito
                   de-credito
                   with frame f-corpo.
         disp "Total da Conta Cont bil" @ c-historico
              de-conta-db               @ de-debito
              de-conta-cr               @ de-credito
              with frame f-corpo.
         down with frame f-corpo.
         assign de-total-db = de-total-db + de-conta-db
                de-total-cr = de-total-cr + de-conta-cr
                de-conta-db = 0
                de-conta-cr = 0.
      END.

      if last(tt-demonst.c-ccusto) then do:
         underline de-debito
                   de-credito
                   with frame f-corpo.
         disp "Total Geral"    @ c-historico
              de-total-db     @ de-debito
              de-total-cr     @ de-credito
              with frame f-corpo.
         down with frame f-corpo.
         assign de-total-db = 0
                de-total-cr = 0.
      end.
   end.
   
   page.
END.
ELSE DO:
   for each tt-demonst:
      /* Resumo por Diretoria */
      if tt-demonst.c-ccusto <> "" then do:
         find first tt-diret 
              where tt-diret.diretoria   = 
                    substr(string(tt-demonst.c-ccusto,"99999"),1,1)
                and tt-diret.cdn-encargo = tt-demonst.cdn-encargo
                and tt-diret.especie     = tt-demonst.especie no-error.
         if not avail tt-diret then do:
            create tt-diret.
            assign tt-diret.diretoria   = 
                   substr(string(tt-demonst.c-ccusto,"99999"),1,1)
                   tt-diret.cdn-encargo = tt-demonst.cdn-encargo
                   tt-diret.especie     = tt-demonst.especie.
         end.
         if tt-demonst.lancamen then
            assign tt-diret.de-debito  = tt-diret.de-debito  + tt-demonst.valor.
         else
            assign tt-diret.de-credito = tt-diret.de-credito + tt-demonst.valor.
      end.
      /* Fim Resumo por Diretoria */   
   END.
END.

IF l-res-diretoria THEN DO:
   put skip(1)
       "Resumo por Diretoria" skip(1).
   
   for each tt-diret
      WHERE (tt-diret.especie = "Encargo"   AND l-res-encarg)
         OR (tt-diret.especie = "Beneficio" AND l-res-benef)
         OR (tt-diret.especie = "Estorno"   AND l-res-estorn)
      break by tt-diret.diretoria
            by tt-diret.especie
            by tt-diret.cdn-encargo.
      find first rh-encargo no-lock
           where rh-encargo.cdn-encargo = tt-diret.cdn-encargo no-error.
    
      disp tt-diret.diretoria when first-of(tt-diret.diretoria)
                                   column-label "Diretoria"
           tt-diret.especie        column-label "Especie"
           tt-diret.cdn-encargo    column-label "Encargo"
           rh-encargo.des-encargo  column-label "Descricao"
           tt-diret.de-debito (total by tt-diret.diretoria
                                     by tt-diret.especie)  column-label "Debito"
           tt-diret.de-credito(total by tt-diret.diretoria
                                     by tt-diret.especie)  column-label "Credito"
           with width 132 no-box stream-io down.
      down.     
   end.
END.

/* doc019rpb.i */
