/***********************************************************************************
**  Programa     : twp-pr-it-per.p                                                **
***********************************************************************************/

DEFINE PARAMETER BUFFER p-table     FOR pr-it-per.
DEFINE PARAMETER BUFFER p-table-Old FOR pr-it-per.

DEFINE VAR d-valorTot AS DECIMAL NO-UNDO.
DEFINE VAR d-saldoTot AS DECIMAL NO-UNDO.

DEFINE VAR d-novoSaldo       AS DECIMAL NO-UNDO.
DEFINE VAR d-precoMedio AS DECIMAL     NO-UNDO.

DEFINE BUFFER bu-movto FOR movto-estoq.
                     
/*  BUSCA O ÈLTIMO MêDIO CALCULADO MENSAL, ANTERIOR A DATA BASE */
FIND LAST ext-pr-it-per WHERE ext-pr-it-per.periodo     < p-table.periodo
                          AND ext-pr-it-per.it-codigo   = p-table.it-codigo
                          AND ext-pr-it-per.cod-estabel = p-table.cod-estabel NO-LOCK NO-ERROR.        

/****** PROCESSO PARA QUANDO EXISTIR CUSTO MêDIO CALCULADO PARA O ITEM *******/    
IF AVAIL ext-pr-it-per THEN DO:
    
    /* SETA O VALOR DO ÈLTIMO MêDIDO CALCULADO */
    ASSIGN d-saldoTot  = ext-pr-it-per.quantidade
           d-valorTot  = ext-pr-it-per.valor
           d-novoSaldo = d-saldoTot.
    
    /* BUSCA OS MOVIMENTOS DE ENTRADA E SAIDA ATê A DATA BASE E QUE POSSUEM VALOR */
    FOR EACH bu-movto FIELDS (it-codigo cod-estabel dt-trans nat-operacao tipo-trans tipo-valor quantidade esp-docto nro-docto serie-docto cod-emitente valor-mat-m valor-mob-m valor-ggf-m base-calculo)
                       WHERE bu-movto.it-codigo    = ext-pr-it-per.it-codigo 
                         AND bu-movto.cod-estabel  = ext-pr-it-per.cod-estabel
                         AND bu-movto.dt-trans     > ext-pr-it-per.periodo
                         AND bu-movto.dt-trans    <= p-table.periodo NO-LOCK.

        /* CALCULA NOVA QUANTIDADE INICIAL */
        ASSIGN d-novoSaldo = IF bu-movto.tipo-trans = 1 THEN (d-novoSaldo + bu-movto.quantidade) ELSE (d-novoSaldo - bu-movto.quantidade).

        /* DESCONSIDERA MOVIMENTOS QUE N«O EST«O NA BASE DO MêDIO */
        IF bu-movto.base-calculo = 0 THEN NEXT.
                                                 
        /* MOVIMENTOS SEM VALOR, N«O SER«O CONSIDERADOS PARA O CµLCULO DO PREÄO MêDIO */
        IF bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1] = 0 THEN NEXT.
        
        IF bu-movto.tipo-trans = 1 THEN DO: /* ENTRADA */
            ASSIGN d-saldoTot = d-saldoTot + bu-movto.quantidade.

            /* N«O CONSIDERA OS VALORES DA BONIFICAÄ«O */
            IF NOT(bu-movto.nat-operacao BEGINS '1910') AND NOT(bu-movto.nat-operacao BEGINS '2910') THEN
                ASSIGN d-valorTot = d-valorTot + (bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1]).
        END.
        ELSE DO: /* SAIDA */
            ASSIGN d-saldoTot = d-saldoTot - bu-movto.quantidade.

            /* N«O CONSIDERA OS VALORES DA BONIFICAÄ«O */
            IF NOT(bu-movto.nat-operacao BEGINS '1910') AND NOT(bu-movto.nat-operacao BEGINS '2910') THEN
                ASSIGN d-valorTot = d-valorTot - (bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1]).
        END.
    END.
END.
ELSE DO:
    /* BUSCA OS MOVIMENTOS DE ENTRADA E SAIDA ATê A DATA BASE E QUE POSSUEM VALOR */
    FOR EACH bu-movto FIELDS (it-codigo cod-estabel dt-trans nat-operacao tipo-trans tipo-valor quantidade esp-docto nro-docto serie-docto cod-emitente valor-mat-m valor-mob-m valor-ggf-m base-calculo)
                       WHERE bu-movto.it-codigo    = p-table.it-codigo 
                         AND bu-movto.cod-estabel  = p-table.cod-estabel
                         AND bu-movto.dt-trans    <= p-table.periodo NO-LOCK.

        /* CALCULA NOVA QUANTIDADE INICIAL */
        ASSIGN d-novoSaldo = IF bu-movto.tipo-trans = 1 THEN (d-novoSaldo + bu-movto.quantidade) ELSE (d-novoSaldo - bu-movto.quantidade).

        /* DESCONSIDERA MOVIMENTOS QUE N«O EST«O NA BASE DO MêDIO */
        IF bu-movto.base-calculo = 0 THEN NEXT.
        
        /* MOVIMENTOS SEM VALOR, N«O SER«O CONSIDERADOS PARA O CµLCULO DO PREÄO MêDIO */
        IF bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1] = 0 THEN NEXT.

        IF bu-movto.tipo-trans = 1 THEN DO: /* ENTRADA */
            ASSIGN d-saldoTot = d-saldoTot + bu-movto.quantidade.

            /* N«O CONSIDERA OS VALORES DA BONIFICAÄ«O */
            IF NOT(bu-movto.nat-operacao BEGINS '1910') AND NOT(bu-movto.nat-operacao BEGINS '2910') THEN
                ASSIGN d-valorTot = d-valorTot + (bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1]).
        END.
        ELSE DO: /* SAIDA */
            ASSIGN d-saldoTot = d-saldoTot - bu-movto.quantidade.

            /* N«O CONSIDERA OS VALORES DA BONIFICAÄ«O */
            IF NOT(bu-movto.nat-operacao BEGINS '1910') AND NOT(bu-movto.nat-operacao BEGINS '2910') THEN
                ASSIGN d-valorTot = d-valorTot - (bu-movto.valor-mat-m[1] + bu-movto.valor-mob-m[1] + bu-movto.valor-ggf-m[1]).
        END.
    END.
END.

/* PREÄO DE CUSTO MêDIO DO ITEM */
ASSIGN d-precoMedio = IF (d-valorTot / d-saldoTot) <> ? THEN ROUND(d-valorTot / d-saldoTot,4) ELSE 0.

/* SE O PREÄO MêDIO FOR ZERO, BUSCA O VALOR MêDIO NAS TABELAS DE PREÄO ANTERIORES  */
IF d-precoMedio <= 0 THEN DO:
    FIND LAST ext-pr-it-per WHERE ext-pr-it-per.periodo     < p-table.periodo
                              AND ext-pr-it-per.it-codigo   = p-table.it-codigo
                              AND ext-pr-it-per.cod-estabel = p-table.cod-estabel NO-LOCK NO-ERROR. 
    IF NOT AVAIL ext-pr-it-per THEN DO:
        /* PREÄO DE CUSTO MêDIO DO ITEM */
        ASSIGN d-precoMedio = (p-table.val-unit-mat-m[1] + p-table.val-unit-mob-m[1] + p-table.val-unit-ggf-m[1]).
    END.
    ELSE DO:
        /* PREÄO DE CUSTO MêDIO DO ITEM */
        ASSIGN d-precoMedio = ext-pr-it-per.preco-medio.
    END.
END.             


/* GRAVA VALORES */
FIND FIRST ext-pr-it-per WHERE ext-pr-it-per.periodo     = p-table.periodo
                           AND ext-pr-it-per.it-codigo   = p-table.it-codigo
                           AND ext-pr-it-per.cod-estabel = p-table.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL ext-pr-it-per THEN DO:
    CREATE ext-pr-it-per.
    ASSIGN ext-pr-it-per.periodo     = p-table.periodo               
           ext-pr-it-per.it-codigo   = p-table.it-codigo      
           ext-pr-it-per.cod-estabel = p-table.cod-estabel.
END.

ASSIGN ext-pr-it-per.quantidade  = d-novoSaldo
       ext-pr-it-per.valor       = d-novoSaldo * d-precoMedio
       ext-pr-it-per.preco-medio = d-precoMedio.

RETURN "OK".

