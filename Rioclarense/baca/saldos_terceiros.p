OUTPUT TO c:\desenv\saldo-terc.txt.

PUT UNFORMATTED "DtEmiss|Estab|Serie|Docto|NatOper|Emitente|Nome|Item|Descricao|Qtde|Data_Retorno|Lote|TipoSaldo|Qtde|SaldoIni|Vlr"
    SKIP.


FOR EACH saldo-terc NO-LOCK:

    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = saldo-terc.cod-emitente NO-ERROR.

    FIND FIRST ITEM WHERE item.it-codigo = saldo-terc.it-codigo NO-ERROR.

    FIND FIRST doc-fiscal NO-LOCK WHERE doc-fiscal.cod-estabel = saldo-terc.cod-estabel
                                  AND   doc-fiscal.serie       = saldo-terc.serie-docto
                                  AND   doc-fiscal.nr-doc-fis  = saldo-terc.nro-docto
                                  AND   doc-fiscal.cod-emitente = saldo-terc.cod-emitente NO-ERROR.

    PUT UNFORMATTED doc-fiscal.dt-emis-doc  "|"
                    saldo-terc.cod-estabel  "|"
                    saldo-terc.serie-docto  "|"
                    saldo-terc.nro-docto    "|"
                    saldo-terc.nat-operacao "|"
                    saldo-terc.cod-emitente "|"
                    emitente.nome-abrev     "|"
                    saldo-terc.it-codigo    "|"
                    item.descricao-1        "|"
                    saldo-terc.quantidade   "|"
                    saldo-terc.dt-retorno   "|"
                    saldo-terc.lote         "|".
    RUN utp/ut-liter.p (INPUT {ininc/i01in404.i 04 saldo-terc.tipo-sal-terc},
                        INPUT "",
                        INPUT "").
                    PUT UNFORMATTED TRIM(RETURN-VALUE) "|". 
                    PUT unformatted saldo-terc.qtd-ini      "|"
                                    (saldo-terc.sald-ini-mat + saldo-terc.sald-ini-mob) "|"
                                    (saldo-terc.valor-mat-m[1] + saldo-terc.valor-mob-m[1] + saldo-terc.valor-ggf-m[1]) 
                                    SKIP.
                    

                

END.
