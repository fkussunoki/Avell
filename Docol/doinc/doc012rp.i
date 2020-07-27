FOR EACH dc-repres NO-LOCK 
    WHERE dc-repres.cod_empresa >= c-cod-empresa-ini  
      AND dc-repres.cod_empresa <= c-cod-empresa-fin
      AND dc-repres.cdn_repres  >= cod-repres-ini
      AND dc-repres.cdn_repres  <= cod-repres-fin
      AND dc-repres.cod_ccusto  >= c-custo-ini
      AND dc-repres.cod_ccusto  <= c-custo-fin,
    FIRST repres NO-LOCK WHERE repres.cod-rep     = dc-repres.cdn_repres,
    FIRST regiao NO-LOCK WHERE regiao.nome-ab-reg = repres.nome-ab-reg
    BREAK BY dc-repres.cod_empresa
          BY regiao.nome-ab-reg
          BY repres.cod-rep:

    RUN pi-acompanhar IN h-acomp (INPUT 'Emp ' + dc-repres.cod_empresa + ' Estab ' + dc-repres.cod_estab +
                                        ' Repres ' + STRING(dc-repres.cdn_repres) + ' CCusto ' + dc-repres.cod_ccusto).
    
    DISP dc-repres.cod_empresa
         regiao.nome-ab-reg COLUMN-LABEL 'RegiÆo'
         dc-repres.cdn_repres
         repres.nome-abrev
         dc-repres.cod_ccusto WITH DOWN FRAME f-rel STREAM-IO.
    IF LAST-OF(regiao.nome-ab-reg) THEN 
        DOWN 1.
    IF LAST-OF(dc-repres.cod_empresa) THEN 
       PAGE.
END.


