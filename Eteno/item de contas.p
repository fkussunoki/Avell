OUTPUT TO c:\desenv\itens.txt.




    FOR EACH saldo-estoq NO-LOCK WHERE saldo-estoq.qtidade-fin > 0:


        FIND FIRST ITEM WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-ERROR.

        FIND FIRST grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-ERROR.


        FIND FIRST contabiliza NO-LOCK WHERE contabiliza.ge-codigo = ITEM.ge-codigo
                                       AND   contabiliza.cod-depos = saldo-estoq.cod-depos
                                       AND   contabiliza.cod-estabel = saldo-estoq.cod-estabel
                                       NO-ERROR.


        PUT UNFORMATTED saldo-estoq.cod-estabel ";"
                        saldo-estoq.cod-depos ";"
                        saldo-estoq.lote      ";"
                        saldo-estoq.it-codigo ";"
                        saldo-estoq.qtidade-fin ";"
                        item.descricao-1      ";"
                        item.ge-codigo        ";"
                        grup-estoque.descricao ";"
                        contabiliza.ct-codigo
                        SKIP.




    END.



