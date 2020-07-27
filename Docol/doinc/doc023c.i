            FOR EACH {1}.movto-estoq USE-INDEX data-conta
               WHERE {1}.movto-estoq.dt-trans  = da-aux
                 AND {1}.movto-estoq.sc-codigo = p-ccusto:
       
               ASSIGN de-valor-movto = 0
                      de-valor-movto = {1}.movto-estoq.valor-mat-m[1] + {1}.movto-estoq.valor-mob-m[1] + {1}.movto-estoq.valor-ggf-m[1].
          
               IF de-valor-movto = 0 THEN DO:
                  FIND FIRST movind.item-estab NO-LOCK
                       WHERE movind.item-estab.it-codigo   = {1}.movto-estoq.it-codigo
                         AND movind.item-estab.cod-estabel = {1}.movto-estoq.cod-estabel NO-ERROR.
                  ASSIGN de-valor-movto = (movind.item-estab.val-unit-mat-m[1] + movind.item-estab.val-unit-mob-m[1] + movind.item-estab.val-unit-ggf-m[1]) * {1}.movto-estoq.quantidade.
               END.
          
               FIND FIRST {1}.docum-est OF {1}.movto-estoq NO-LOCK NO-ERROR.
          
               IF AVAIL {1}.docum-est THEN DO:
                  CREATE dc-desp-ccusto.
                  ASSIGN dc-desp-ccusto.cod_ccusto          = {1}.movto-estoq.sc-codigo
                         dc-desp-ccusto.cod_cta_ctbl        = {1}.movto-estoq.ct-codigo
                         dc-desp-ccusto.dat_transacao       = {1}.movto-estoq.dt-trans
                         dc-desp-ccusto.cod_modul_dtsul     = "CEP"
                         dc-desp-ccusto.cod_estab           = {1}.movto-estoq.cod-estabel
                         dc-desp-ccusto.nr-trans            = {1}.movto-estoq.nr-trans
                         dc-desp-ccusto.val-movto           = IF {1}.movto-estoq.tipo-trans = 2
                                                                 THEN  de-valor-movto
                                                                 ELSE (de-valor-movto * -1).
                  FIND FIRST mgcad.emitente NO-LOCK
                       WHERE mgcad.emitente.cod-emitente = {1}.docum-est.cod-emitente NO-ERROR.
                  IF AVAIL mgcad.emitente THEN
                     ASSIGN dc-desp-ccusto.descricao = dc-desp-ccusto.descricao + emitente.nome-abrev + " ".
    
                  ASSIGN dc-desp-ccusto.descricao = dc-desp-ccusto.descricao + "(" + STRING({1}.docum-est.cod-emitente) + "-"  + 
                                                                                     STRING({1}.docum-est.serie-docto)  + "-"  +  
                                                                                     STRING({1}.docum-est.nro-docto)    + "-"  +  
                                                                                     STRING({1}.docum-est.nat-operacao) + ") " +
                                                    REPLACE(TRIM({1}.movto-estoq.descricao-db),CHR(10)," ").
    
               END.
               ELSE DO:
                  FIND FIRST dc-desp-ccusto
                       WHERE dc-desp-ccusto.cod_ccusto      = {1}.movto-estoq.sc-codigo
                         AND dc-desp-ccusto.cod_cta_ctbl    = {1}.movto-estoq.ct-codigo
                         AND dc-desp-ccusto.cod_modul_dtsul = "CEP"
                         AND dc-desp-ccusto.dat_transacao   = {1}.movto-estoq.dt-trans
                         AND dc-desp-ccusto.cod_estab       = {1}.movto-estoq.cod-estabel
                         AND dc-desp-ccusto.nr-trans        = 0 NO-ERROR.
                  IF NOT AVAIL dc-desp-ccusto THEN DO:
                     CREATE dc-desp-ccusto.
                     ASSIGN dc-desp-ccusto.cod_ccusto       = {1}.movto-estoq.sc-codigo  
                            dc-desp-ccusto.cod_cta_ctbl     = {1}.movto-estoq.ct-codigo  
                            dc-desp-ccusto.cod_modul_dtsul  = "CEP"                   
                            dc-desp-ccusto.dat_transacao    = {1}.movto-estoq.dt-trans    
                            dc-desp-ccusto.cod_estab        = {1}.movto-estoq.cod-estabel 
                            dc-desp-ccusto.nr-trans         = 0
                            dc-desp-ccusto.descricao        = "Movimento Acumulado de Estoque do Dia " + STRING({1}.movto-estoq.dt-trans,"99/99/9999").
                  END.
                  ASSIGN dc-desp-ccusto.val-movto           = dc-desp-ccusto.val-movto + IF {1}.movto-estoq.tipo-trans = 2
                                                                                            THEN  de-valor-movto
                                                                                            ELSE (de-valor-movto * -1).
               END.
            END.
