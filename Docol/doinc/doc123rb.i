ASSIGN dt-refer = DATE(MONTH(da-aux),1,YEAR(da-aux))
       dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.

FOR EACH {1}.movto-estoq USE-INDEX data-conta NO-LOCK
   WHERE {1}.movto-estoq.dt-trans  = da-aux:

    RUN pi-acompanhar IN h-acomp ("Movto. Estoque: " + STRING(da-aux,"99/99/9999")).
    
    FIND FIRST tt-ccusto WHERE
               tt-ccusto.cod_empresa      = c-cod-emp  AND
               tt-ccusto.cod_plano_ccusto = c-plano-cc AND
               tt-ccusto.cod_ccusto       = {1}.movto-estoq.sc-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-ccusto THEN NEXT.
    
    ASSIGN de-valor-movto = 0
           de-valor-movto = {1}.movto-estoq.valor-mat-m[1] + {1}.movto-estoq.valor-mob-m[1] + {1}.movto-estoq.valor-ggf-m[1]
           de-valor-fixo  = {1}.movto-estoq.valor-ggf-m[1].
    
    IF de-valor-movto = 0 THEN DO:
        FIND FIRST movind.item-estab NO-LOCK
             WHERE movind.item-estab.it-codigo   = {1}.movto-estoq.it-codigo
               AND movind.item-estab.cod-estabel = {1}.movto-estoq.cod-estabel NO-ERROR.
        ASSIGN de-valor-movto = (movind.item-estab.val-unit-mat-m[1] + movind.item-estab.val-unit-mob-m[1] + movind.item-estab.val-unit-ggf-m[1]) * {1}.movto-estoq.quantidade.
    END.
    
    IF {1}.movto-estoq.nat-oper <> "" THEN DO:
        IF {1}.movto-estoq.nat-oper > "5" THEN DO:
            FIND tt-nota-fiscal
                WHERE tt-nota-fiscal.data        = dt-refer
                AND   tt-nota-fiscal.ct-codigo   = {1}.movto-estoq.ct-codigo
                AND   tt-nota-fiscal.sc-codigo   = {1}.movto-estoq.sc-codigo
                AND   tt-nota-fiscal.cod-estabel = {1}.movto-estoq.cod-estabel
                AND   tt-nota-fiscal.serie       = {1}.movto-estoq.serie-docto
                AND   tt-nota-fiscal.nr-nota-fis = {1}.movto-estoq.nro-docto NO-ERROR.
            IF NOT AVAIL tt-nota-fiscal THEN DO:
                CREATE tt-nota-fiscal.
                ASSIGN tt-nota-fiscal.cod-estabel  = {1}.movto-estoq.cod-estabel
                       tt-nota-fiscal.serie        = {1}.movto-estoq.serie-docto
                       tt-nota-fiscal.nr-nota-fis  = {1}.movto-estoq.nro-docto  
                       tt-nota-fiscal.cod-emitente = {1}.movto-estoq.cod-emitente
                       tt-nota-fiscal.nat-operacao = {1}.movto-estoq.nat-operacao
                       tt-nota-fiscal.data         = dt-refer
                       tt-nota-fiscal.ct-codigo    = {1}.movto-estoq.ct-codigo
                       tt-nota-fiscal.sc-codigo    = {1}.movto-estoq.sc-codigo.
            END.
            ASSIGN tt-nota-fiscal.valor    = tt-nota-fiscal.valor + IF {1}.movto-estoq.tipo-trans = 2
                                                                        THEN  de-valor-movto           
                                                                        ELSE (de-valor-movto * -1)
                   tt-nota-fiscal.val-fixo = tt-nota-fiscal.val-fixo + (IF {1}.movto-estoq.tipo-trans = 2
                                                                               THEN  de-valor-fixo
                                                                               ELSE (de-valor-fixo * -1)).
    
            IF {1}.movto-estoq.esp-docto = 28 /* REQ */ THEN DO:
                FIND FIRST dc-it-requisicao NO-LOCK WHERE
                           dc-it-requisicao.nr-requisicao = INT({1}.movto-estoq.nro-docto) AND
                           dc-it-requisicao.it-codigo     = {1}.movto-estoq.it-codigo      NO-ERROR.
                IF AVAIL dc-it-requisicao THEN
                    FIND FIRST {1}.it-requisicao NO-LOCK WHERE
                               {1}.it-requisicao.nr-requisicao = dc-it-requisicao.nr-requisicao AND
                               {1}.it-requisicao.sequencia     = dc-it-requisicao.sequencia     AND
                               {1}.it-requisicao.it-codigo     = dc-it-requisicao.it-codigo     NO-ERROR.
                ELSE
                    RELEASE {1}.it-requisicao NO-ERROR.
            END.
            ELSE DO:
                RELEASE dc-it-requisicao NO-ERROR.
                RELEASE {1}.it-requisicao NO-ERROR.
            END.
                
            CREATE tt-movto-estoq.
            ASSIGN tt-movto-estoq.ct-codigo         = {1}.movto-estoq.ct-codigo
                   tt-movto-estoq.sc-codigo         = {1}.movto-estoq.sc-codigo
                   tt-movto-estoq.data              = {1}.movto-estoq.dt-trans
                   tt-movto-estoq.cod-estab         = {1}.movto-estoq.cod-estabel
                   tt-movto-estoq.nr-trans          = {1}.movto-estoq.nr-trans
                   tt-movto-estoq.gm-codigo         = IF AVAIL dc-it-requisicao THEN dc-it-requisicao.gm-codigo ELSE ""
                   tt-movto-estoq.val-movto         = IF {1}.movto-estoq.tipo-trans = 2
                                                          THEN  de-valor-movto
                                                          ELSE (de-valor-movto * -1)
                   tt-movto-estoq.val-fixo          = IF {1}.movto-estoq.tipo-trans = 2
                                                        THEN  de-valor-fixo
                                                        ELSE (de-valor-fixo * -1)
                   tt-movto-estoq.cod-emitente      = {1}.movto-estoq.cod-emitente
                   tt-movto-estoq.serie-docto       = {1}.movto-estoq.serie-docto
                   tt-movto-estoq.nro-docto         = {1}.movto-estoq.nro-docto
                   tt-movto-estoq.nat-operacao      = {1}.movto-estoq.nat-operacao
                   tt-movto-estoq.esp-docto         = {1}.movto-estoq.esp-docto
                   tt-movto-estoq.it-codigo         = {1}.movto-estoq.it-codigo
                   tt-movto-estoq.quantidade        = {1}.movto-estoq.quantidade
                   tt-movto-estoq.usuario           = {1}.movto-estoq.usuario
                   tt-movto-estoq.nome-abrev-requis = IF AVAIL {1}.it-requisicao THEN {1}.it-requisicao.nome-abrev ELSE "".
    
            IF  {1}.movto-estoq.numero-ordem <> 0 THEN DO:
                 FIND {1}.ordem-compra NO-LOCK WHERE {1}.ordem-compra.numero-ordem = {1}.movto-estoq.numero-ordem NO-ERROR.
                 IF AVAIL {1}.ordem-compra THEN
                     ASSIGN tt-movto-estoq.usuario  = {1}.ordem-compra.requisitante.
            END.
    
            FIND FIRST mgcad.emitente NO-LOCK
                 WHERE mgcad.emitente.cod-emitente = {1}.movto-estoq.cod-emitente NO-ERROR.
            IF AVAIL mgcad.emitente THEN
                ASSIGN tt-movto-estoq.nome-abrev = emitente.nome-abrev.
    
            FIND ITEM NO-LOCK WHERE ITEM.it-codigo = {1}.movto-estoq.it-codigo NO-ERROR.
    
            ASSIGN tt-movto-estoq.descricao = item.desc-item + " " + REPLACE(TRIM({1}.movto-estoq.descricao-db),CHR(10)," ").
        END.
        ELSE DO:
            FIND tt-docum-est
                WHERE tt-docum-est.data          = {1}.movto-estoq.dt-trans
                AND   tt-docum-est.ct-codigo     = {1}.movto-estoq.ct-codigo
                AND   tt-docum-est.sc-codigo     = {1}.movto-estoq.sc-codigo
                AND   tt-docum-est.cod-estabel   = {1}.movto-estoq.cod-estabel
                AND   tt-docum-est.serie-docto   = {1}.movto-estoq.serie-docto
                AND   tt-docum-est.nro-docto     = {1}.movto-estoq.nro-docto
                AND   tt-docum-est.nat-operacao  = {1}.movto-estoq.nat-operacao
                AND   tt-docum-est.cod-emitente  = {1}.movto-estoq.cod-emitente NO-ERROR.
            IF NOT AVAIL tt-docum-est THEN DO:
                CREATE tt-docum-est.
                ASSIGN tt-docum-est.data          = {1}.movto-estoq.dt-trans
                       tt-docum-est.ct-codigo     = {1}.movto-estoq.ct-codigo      
                       tt-docum-est.sc-codigo     = {1}.movto-estoq.sc-codigo      
                       tt-docum-est.cod-estabel   = {1}.movto-estoq.cod-estabel 
                       tt-docum-est.serie-docto   = {1}.movto-estoq.serie-docto 
                       tt-docum-est.nro-docto     = {1}.movto-estoq.nro-docto   
                       tt-docum-est.nat-operacao  = {1}.movto-estoq.nat-operacao
                       tt-docum-est.cod-emitente  = {1}.movto-estoq.cod-emitente.
            END.
            ASSIGN tt-docum-est.valor = tt-docum-est.valor + IF {1}.movto-estoq.tipo-trans = 2
                                                                   THEN  de-valor-movto           
                                                                   ELSE (de-valor-movto * -1)
                   tt-docum-est.val-fixo = tt-docum-est.val-fixo + IF {1}.movto-estoq.tipo-trans = 2
                                                                           THEN  de-valor-fixo          
                                                                           ELSE (de-valor-fixo * -1).
    
            IF {1}.movto-estoq.esp-docto = 28 /* REQ */ THEN DO:
                FIND FIRST dc-it-requisicao NO-LOCK WHERE
                           dc-it-requisicao.nr-requisicao = INT({1}.movto-estoq.nro-docto) AND
                           dc-it-requisicao.it-codigo     = {1}.movto-estoq.it-codigo      NO-ERROR.
                IF AVAIL dc-it-requisicao THEN
                    FIND FIRST {1}.it-requisicao NO-LOCK WHERE
                               {1}.it-requisicao.nr-requisicao = dc-it-requisicao.nr-requisicao AND
                               {1}.it-requisicao.sequencia     = dc-it-requisicao.sequencia     AND
                               {1}.it-requisicao.it-codigo     = dc-it-requisicao.it-codigo     NO-ERROR.
                ELSE 
                    RELEASE {1}.it-requisicao NO-ERROR.
            END.
            ELSE DO:
                RELEASE dc-it-requisicao NO-ERROR.
                RELEASE {1}.it-requisicao NO-ERROR.
            END.
    
            CREATE tt-movto-estoq.
            ASSIGN tt-movto-estoq.ct-codigo         = {1}.movto-estoq.ct-codigo
                   tt-movto-estoq.sc-codigo         = {1}.movto-estoq.sc-codigo
                   tt-movto-estoq.data              = {1}.movto-estoq.dt-trans
                   tt-movto-estoq.cod-estab         = {1}.movto-estoq.cod-estabel
                   tt-movto-estoq.nr-trans          = {1}.movto-estoq.nr-trans
                   tt-movto-estoq.gm-codigo         = IF AVAIL dc-it-requisicao THEN dc-it-requisicao.gm-codigo ELSE ""
                   tt-movto-estoq.val-movto         = IF {1}.movto-estoq.tipo-trans = 2
                                                          THEN  de-valor-movto
                                                          ELSE (de-valor-movto * -1)
                   tt-movto-estoq.val-fixo          = IF {1}.movto-estoq.tipo-trans = 2
                                                        THEN  de-valor-fixo
                                                        ELSE (de-valor-fixo * -1)
                   tt-movto-estoq.cod-emitente      = {1}.movto-estoq.cod-emitent
                   tt-movto-estoq.serie-docto       = {1}.movto-estoq.serie-docto
                   tt-movto-estoq.nro-docto         = {1}.movto-estoq.nro-docto
                   tt-movto-estoq.nat-operacao      = {1}.movto-estoq.nat-operacao
                   tt-movto-estoq.esp-docto         = {1}.movto-estoq.esp-docto
                   tt-movto-estoq.it-codigo         = {1}.movto-estoq.it-codigo
                   tt-movto-estoq.quantidade        = {1}.movto-estoq.quantidade
                   tt-movto-estoq.usuario           = {1}.movto-estoq.usuario
                   tt-movto-estoq.nome-abrev-requis = IF AVAIL {1}.it-requisicao THEN {1}.it-requisicao.nome-abrev ELSE "".
    
            IF  {1}.movto-estoq.numero-ordem <> 0 THEN DO:
                 FIND {1}.ordem-compra NO-LOCK WHERE {1}.ordem-compra.numero-ordem = {1}.movto-estoq.numero-ordem NO-ERROR.
                 IF AVAIL {1}.ordem-compra THEN
                     ASSIGN tt-movto-estoq.usuario  = {1}.ordem-compra.requisitante.
            END.
    
            FIND FIRST mgcad.emitente NO-LOCK
                 WHERE mgcad.emitente.cod-emitente = {1}.movto-estoq.cod-emitente NO-ERROR.
            IF AVAIL mgcad.emitente THEN
               ASSIGN tt-movto-estoq.nome-abrev = emitente.nome-abrev.
    
            ASSIGN tt-movto-estoq.descricao = REPLACE(TRIM({1}.movto-estoq.descricao-db),CHR(10)," ").
        END.
    END.
    ELSE DO:
        FIND FIRST tt-movto-estoq
             WHERE tt-movto-estoq.sc-codigo       = {1}.movto-estoq.sc-codigo
               AND tt-movto-estoq.ct-codigo       = {1}.movto-estoq.ct-codigo
               AND tt-movto-estoq.data            = {1}.movto-estoq.dt-trans
               AND tt-movto-estoq.cod-estabel     = {1}.movto-estoq.cod-estabel
               AND tt-movto-estoq.it-codigo       = {1}.movto-estoq.it-codigo
               AND tt-movto-estoq.esp-docto       = {1}.movto-estoq.esp-docto
               AND tt-movto-estoq.nro-docto       = {1}.movto-estoq.nro-docto
               AND tt-movto-estoq.usuario         = {1}.movto-estoq.usuario
               AND tt-movto-estoq.nr-trans        = 0 NO-ERROR.
        IF NOT AVAIL tt-movto-estoq THEN DO:
            FIND ITEM WHERE ITEM.it-codigo = {1}.movto-estoq.it-codigo NO-LOCK NO-ERROR.
            
            IF {1}.movto-estoq.esp-docto = 28 /* REQ */ THEN DO:
                FIND FIRST dc-it-requisicao NO-LOCK WHERE
                           dc-it-requisicao.nr-requisicao = INT({1}.movto-estoq.nro-docto) AND
                           dc-it-requisicao.it-codigo     = {1}.movto-estoq.it-codigo      NO-ERROR.
                IF AVAIL dc-it-requisicao THEN
                    FIND FIRST {1}.it-requisicao NO-LOCK WHERE
                               {1}.it-requisicao.nr-requisicao = dc-it-requisicao.nr-requisicao AND
                               {1}.it-requisicao.sequencia     = dc-it-requisicao.sequencia     AND
                               {1}.it-requisicao.it-codigo     = dc-it-requisicao.it-codigo     NO-ERROR.
                ELSE
                    RELEASE {1}.it-requisicao NO-ERROR.
            END.
            ELSE DO:
                RELEASE dc-it-requisicao NO-ERROR.
                RELEASE {1}.it-requisicao NO-ERROR.
            END.
            
            CREATE tt-movto-estoq.
            ASSIGN tt-movto-estoq.sc-codigo         = {1}.movto-estoq.sc-codigo  
                   tt-movto-estoq.gm-codigo         = IF AVAIL dc-it-requisicao THEN dc-it-requisicao.gm-codigo ELSE ""
                   tt-movto-estoq.ct-codigo         = {1}.movto-estoq.ct-codigo  
                   tt-movto-estoq.data              = {1}.movto-estoq.dt-trans    
                   tt-movto-estoq.cod-estabel       = {1}.movto-estoq.cod-estabel 
                   tt-movto-estoq.it-codigo         = {1}.movto-estoq.it-codigo
                   tt-movto-estoq.esp-docto         = {1}.movto-estoq.esp-docto
                   tt-movto-estoq.nro-docto         = {1}.movto-estoq.nro-docto
                   tt-movto-estoq.nr-trans          = 0
                   tt-movto-estoq.descricao         = " Esp " + STRING({1}.movto-estoq.esp-docto) +
                                                      " Item " + {1}.movto-estoq.it-codigo + " - " + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "")
                   
                   tt-movto-estoq.usuario           = {1}.movto-estoq.usuario
                   tt-movto-estoq.nome-abrev-requis = IF AVAIL {1}.it-requisicao THEN {1}.it-requisicao.nome-abrev ELSE "".
            
            IF  {1}.movto-estoq.numero-ordem <> 0 THEN DO:
                FIND {1}.ordem-compra NO-LOCK WHERE {1}.ordem-compra.numero-ordem = {1}.movto-estoq.numero-ordem NO-ERROR.
                IF AVAIL {1}.ordem-compra THEN
                    ASSIGN tt-movto-estoq.usuario  = {1}.ordem-compra.requisitante.
            END.
            
            IF {1}.movto-estoq.nr-ord-produ <> 0 THEN DO:
                FIND {1}.ord-prod NO-LOCK WHERE {1}.ord-prod.nr-ord-produ = {1}.movto-estoq.nr-ord-produ NO-ERROR.
                IF AVAIL {1}.ord-prod THEN
                    ASSIGN tt-movto-estoq.descricao = replace(ord-prod.narrativa,CHR(10)," ").
            END.
        END.
        ASSIGN tt-movto-estoq.val-movto  = tt-movto-estoq.val-movto + IF {1}.movto-estoq.tipo-trans = 2 THEN  
                                                                         de-valor-movto
                                                                      ELSE 
                                                                         (de-valor-movto * -1)
               tt-movto-estoq.val-fixo  = tt-movto-estoq.val-fixo + IF {1}.movto-estoq.tipo-trans = 2 THEN  
                                                                       de-valor-fixo
                                                                    ELSE 
                                                                       (de-valor-fixo * -1)
               tt-movto-estoq.quantidade = tt-movto-estoq.quantidade + {1}.movto-estoq.quantidade.
    END.

    FIND FIRST tt-resumo-movto-estoq
        WHERE tt-resumo-movto-estoq.cod-estabel = tt-movto-estoq.cod-estabel
        AND   tt-resumo-movto-estoq.ct-codigo   = tt-movto-estoq.ct-codigo
        AND   tt-resumo-movto-estoq.sc-codigo   = tt-movto-estoq.sc-codigo
        AND   tt-resumo-movto-estoq.modulo      = "CEP"
        AND   tt-resumo-movto-estoq.data        = dt-refer NO-ERROR.
    IF NOT AVAIL tt-resumo-movto-estoq THEN DO:
        CREATE tt-resumo-movto-estoq.
        ASSIGN tt-resumo-movto-estoq.cod-estabel = tt-movto-estoq.cod-estabel
               tt-resumo-movto-estoq.ct-codigo   = tt-movto-estoq.ct-codigo
               tt-resumo-movto-estoq.sc-codigo   = tt-movto-estoq.sc-codigo
               tt-resumo-movto-estoq.modulo      = "CEP"
               tt-resumo-movto-estoq.data        = dt-refer.
    END.
    ASSIGN tt-resumo-movto-estoq.val-movto = tt-resumo-movto-estoq.val-movto + IF {1}.movto-estoq.tipo-trans = 2
                                                                                 THEN  de-valor-movto
                                                                                 ELSE (de-valor-movto * -1)
           tt-resumo-movto-estoq.val-fixo  = tt-resumo-movto-estoq.val-fixo + IF {1}.movto-estoq.tipo-trans = 2
                                                                                 THEN  de-valor-fixo
                                                                                 ELSE (de-valor-fixo * -1).
END.
