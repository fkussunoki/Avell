DEFINE VAR d-valor AS DECIMAL FORMAT  "->>>,>>>,>>>,>>>,>>>,>>>.99" NO-UNDO.

DEF VAR h-acomp AS HANDLE.


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Transpondo").
FOR EACH doc-pend-aprov WHERE doc-pend-aprov.ind-situacao = 2
                        AND   doc-pend-aprov.dt-geracao >= 01/01/2018
                        AND   doc-pend-aprov.dt-geracao <= 10/31/2018 : /* Busca pedidos aprovados */

    FOR EACH ordem-compra NO-LOCK WHERE ordem-compra.num-pedido = doc-pend-aprov.num-pedido
                                  AND    ordem-compra.situacao  = 2 BREAK BY ordem-compra.num-pedido: /* Busca ordens aprovadas. */

        RUN pi-acompanhar IN h-acomp (INPUT " Pedido: " + string(ordem-compra.num-pedido)).
        
        FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:

            ASSIGN d-valor = d-valor + (cotacao-item.preco-fornec * ordem-compra.qt-solic).

            IF LAST-OF(ordem-compra.num-pedido) THEN DO:
                


    CREATE mla-doc-pend-aprov.
    ASSIGN mla-doc-pend-aprov.cod-tip-doc = 8
           mla-doc-pend-aprov.chave-doc   = string(doc-pend-aprov.num-pedido)
           mla-doc-pend-aprov.nr-trans    = doc-pend-aprov.nr-trans
           mla-doc-pend-aprov.ind-situacao = 2
           mla-doc-pend-aprov.cod-usuar    = doc-pend-aprov.cod-aprov
           mla-doc-pend-aprov.dt-geracao   = doc-pend-aprov.dt-geracao
           mla-doc-pend-aprov.dt-aprova    = doc-pend-aprov.dt-aprova
           mla-doc-pend-aprov.dt-rejeita   = doc-pend-aprov.dt-rejeita
           mla-doc-pend-aprov.dt-reaprova  = doc-pend-aprov.dt-reaprova
           mla-doc-pend-aprov.narrativa-apr = doc-pend-aprov.narrativa-apr
           mla-doc-pend-aprov.cod-lotacao-trans = doc-pend-aprov.sc-codigo
           mla-doc-pend-aprov.valor-doc     = d-valor
           mla-doc-pend-aprov.cod-usuar-doc = doc-pend-aprov.cod-usuario
           mla-doc-pend-aprov.cod-usuar-trans = doc-pend-aprov.cod-usuario
           mla-doc-pend-aprov.mo-codigo = 0
           mla-doc-pend-aprov.cod-lotacao-doc = doc-pend-aprov.sc-codigo
           mla-doc-pend-aprov.it-codigo       = doc-pend-aprov.it-codigo
           mla-doc-pend-aprov.cod-estabel     = doc-pend-aprov.cod-estabel
           mla-doc-pend-aprov.ep-codigo       = SUBSTRING(doc-pend-aprov.cod-estabel, 1, 1).
            END.

        END.

     END.

END.

RUN pi-finalizar IN h-acomp.


