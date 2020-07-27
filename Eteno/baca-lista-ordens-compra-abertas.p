OUTPUT TO c:\desenv\pedidos_abertos.txt.

PUT UNFORMATTED "Situacao; Pedido; Dt Pedido; Num Ordem; Dt Emiss; Item; Descricao; Parcela; Saldo; Dt. Entrega"
    SKIP.

FOR EACH ordem-compra NO-LOCK WHERE ordem-compra.situacao <= 3
                              AND   ordem-compra.data-emissao <= 12/31/2019
                              ,
    EACH prazo-compra NO-LOCK WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                              AND   prazo-compra.situacao <= 3:


    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = ordem-compra.usuario NO-ERROR.


    PUT UNFORMATTED {ininc/i02in274.i 04 ordem-compra.situacao} ";"
                    ordem-compra.num-pedido ";"
                    ordem-compra.data-pedido ";"
                    ordem-compra.numero-ordem ";"
                    ordem-compra.data-emissao ";"
                    ordem-compra.it-codigo ";"
                    item.it-codigo ";"
                    prazo-compra.parcela ";"
                    prazo-compra.quant-saldo ";"
                    prazo-compra.data-entrega
                    SKIP.



END.
