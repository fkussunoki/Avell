/****************************************************************************
 PROGRAMA: RE1005AX.P
 OBJETIVO: FAZER AS VALIDACOES VERIFICANDO SE HA DIVERGENCIA, 
           A NIVEL DE ITENS A NOTA E A NIVEL DE DUPLICATA DA NOTA
 AUTORES:  GISELE C. SEIDEMANN / DIOMAR MUHLMANN
 DATA:     03/04/2000
           14/05/2001 - Verifica divergencia de vencimentos para documentos de
                        beneficiamento - Luciane/Gisele
           30/07/2001 - Rotina para fornecedores de beneficiamento que estao 
                        fora do padrao de datas de vencimento a cada decendio
                        - Luciane Heidrich (Planner) 
           25/10/2002 - Convertido para EMS204 por ABConsult - Vitor M. Gunther
***************************************************************************/
/* Tabela de Divergàncias
   1 Valor n∆o Confere
   2 Quantidade(s) n∆o Confere(m)
   3 Antecipaá∆o T°tulo 
   4 Vencimento da Parcela n∆o Confere
   5 Valor Nota Frete n∆o Confere
   6 Valor Desp Acess n∆o Confere 
*/ 

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

{include/i-epc200.i} /* Definiá∆o tt-EPC */

DEF INPUT PARAM  p-ind-event AS CHAR  NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.
    
DEF VAR eh-devol       AS   LOGICAL.
DEF VAR w-preco-nota   AS   DEC.    
def var de-preco-conv  like ordem-compra.preco-unit
                       format ">>>,>>>,>>9.9999" decimals 8 no-undo.

def var de-preco-total as decimal format ">>>,>>>,>>9.9999"
                       decimals 8 no-undo.

def var de-preco-calc  like de-preco-total.
def var de-ipi         as decimal format ">>>>>>,>>9.9999" decimals 8.
def var de-ipi-max     as decimal format ">>>>>>,>>9.9999" decimals 8.
def var de-ipi-min     as decimal format ">>>>>>,>>9.9999" decimals 8.
def var de-preco       like ordem-compra.preco-unit.
def var de-desc        as decimal format ">>>>>>,>>9.9999".
def var q-saldo        like prazo-compra.quantidade.
def var de-tot-item     as decimal format ">,>>>,>>>,>>9.99"   decimals 8.
def var de-tot-item-max as decimal format ">,>>>,>>>,>>9.99"   decimals 8.
def var de-tot-item-min as decimal format ">,>>>,>>>,>>9.99"   decimals 8.
def var d-toler        like prazo-compra.quantidade.
def var i-diverg       like dc-diverg-dp.cod-diverg.
def var acum-valor     as decimal format ">,>>>,>>>,>>9.99"   decimals 2.
def var tot-antecip    as decimal format ">>>,>>9.99"         decimals 2.
def var w-parc         as integer.
def var da-data        as da extent 12 format 99/99/9999.
def var da-partida     like dupli-apagar.dt-emissao. 
def var i-cond         like cond-pagto.cod-vencto.
def var i-cond-pagto   like cond-pagto.cod-cond-pag.
def var i-num-parc     like cond-pagto.num-parcelas.
def var i-ind          as integer.
def var i-xxx-avanco   as integer no-undo.
def var n-dias         as INTEGER.
def var d-data-venc    as date.
def var l-terceiros    like dc-diverg-it.terceiros INIT NO.
DEF VAR de-tot-duplicatas  LIKE dupli-apagar.vl-a-pagar.

DEF VAR w-num-pedido   LIKE ordem-compra.num-pedido.
DEF VAR w-numero-ordem LIKE ordem-compra.numero-ordem.
DEF VAR w-parcela      LIKE prazo-compra.parcela.
DEF VAR w-quantidade   LIKE item-doc-est.quantidade.
DEF VAR l-tab-preco-div    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-tb-preco AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-aliq-ipi AS DECIMAL     NO-UNDO.

DEF VAR de-indice AS DEC.

def TEMP-TABLE tt-pedido 
    field num-pedido like pedido-compr.num-pedido
    INDEX a num-pedido.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param-compra NO-LOCK NO-ERROR.

DEF VAR l-contrato-supply-house    AS LOG.
DEF VAR l-ultrapassou-supply-house AS LOG.
DEF VAR de-salario-minimo          AS DEC.

DEFINE VARIABLE dt-cotacao-ini AS DATE            NO-UNDO.
DEFINE VARIABLE dt-cotacao-fim AS DATE            NO-UNDO.
DEFINE VARIABLE dt-cotacao-aux AS DATE            NO-UNDO.
DEFINE VARIABLE i-num-cotacao  AS INTEGER         NO-UNDO.
DEFINE VARIABLE de-cotacao-tot AS DEC DECIMALS 10 NO-UNDO.

DEFINE VARIABLE l-contrato-medicao    AS LOGICAL NO-UNDO.
DEFINE VARIABLE de-lim-variacao-valor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-lim-var-quant  AS DECIMAL     NO-UNDO.

DEF BUFFER b-item-doc-est FOR item-doc-est.

IF p-ind-event = 'End-tax-calculation':U THEN DO:

    FIND FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = 'ROWID(DOCUM-EST)':U.
    
    FIND docum-est NO-LOCK WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter).
    IF NOT avail docum-est THEN NEXT.
    
    FIND FIRST estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
    
    ASSIGN l-ultrapassou-supply-house = NO.
    
    /* Elimina dc-diverg-dp no caso de o documento estar sendo atualizado novamente */
    FOR EACH dc-diverg-dp
       where dc-diverg-dp.cod-emitente  = docum-est.cod-emitente
         and dc-diverg-dp.serie-docto   = docum-est.serie-docto
         and dc-diverg-dp.nro-docto     = docum-est.nro-docto
         and dc-diverg-dp.nat-operacao  = docum-est.nat-operacao:

        /*
        FOR EACH dc-diverg-dp
           where dc-diverg-dp.cdn_fornecedor  = docum-est.cod-emitente
             and dc-diverg-dp.cod_ser_docto   = docum-est.serie-docto
             and dc-diverg-dp.cod_tit_ap      = docum-est.nro-docto
             and dc-diverg-dp.nat-operacao    = docum-est.nat-operacao:
        */
        DELETE dc-diverg-dp.
    END.

    /* Elimina dc-diverg-it no caso de o documento estar sendo atualizado novamente */
    FOR EACH dc-diverg-it 
       WHERE dc-diverg-it.cod-emitente  = docum-est.cod-emitente 
         AND dc-diverg-it.serie         = docum-est.serie        
         AND dc-diverg-it.nro-docto     = docum-est.nro-docto    
         AND dc-diverg-it.nat-operacao  = docum-est.nat-operacao:

        FIND FIRST item-doc-est NO-LOCK 
            WHERE item-doc-est.cod-emitente  = docum-est.cod-emitente 
              AND item-doc-est.serie-docto   = docum-est.serie-docto
              AND item-doc-est.nro-docto     = docum-est.nro-docto    
              AND item-doc-est.nat-operacao  = docum-est.nat-operacao
              AND item-doc-est.sequencia     = dc-diverg-it.sequencia NO-ERROR.

       IF AVAIL item-doc-est THEN
           FIND FIRST ordem-compra NO-LOCK WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-ERROR.

       IF AVAIL ordem-compra THEN 
           FIND FIRST gcv-param-usuar-re NO-LOCK WHERE gcv-param-usuar-re.cod_usuario = ordem-compra.cod-comprado NO-ERROR.

       IF AVAIL gcv-param-usuar-re AND gcv-param-usuar-re.log-valida-item-re THEN DO:
            /*RUN MESSAGE3.p ("Item da nota com quantidade ou valor fora da variaá∆o permitida",
                           "Quantidade digitada: " + STRING(dc-diverg-it.quantidade-rec) + CHR(13) + 
                           "Quantidade esperada: " + STRING(dc-diverg-it.quantidade-ped) + CHR(13) + 
                           /*"Variaá∆o quantidade: " + STRING(familia-mat.var-qtd-re) + '%' + CHR(13) +*/
                           "Valor digitado.....: " + STRING(dc-diverg-it.valor-item-rec) + CHR(13) + 
                           "Valor esperado.....: " + STRING(dc-diverg-it.valor-item-ped) + CHR(13) /* + 
                           "Variaá∆o Permitida.: " + STRING(familia-mat.lim-var-valor)*/ ).
            RETURN 'nok'.*/
       END.
       ELSE DELETE dc-diverg-it.
    END.

    FIND FIRST emitente WHERE emitente.cod-emit = docum-est.cod-emit NO-ERROR.
    IF emitente.natureza = 3 /* 1- Pessoa Fisica, 2-Pessoa Juridica, 3-Estrangeiro. 4-Tradding */ THEN NEXT.
    
    /*-----------------------------------------------------------------------------------------
     * Rotina para verificar divergància de Beneficiamento de Materia-Prima
     * 1) O Usuario (Renato) imprime a Ordem de Produá∆o como Pedido de Compra (dcc059r.w)
     * 1.1) Os Valores do Pedido e Condiá∆o de Pagamento s∆o baseados na Tabela de Preáo Ativa 
     *----------------------------------------------------------------------------------------*/
    
    /*------- (fim) rotina beneficimaneto materia-prima ------------*/
    
    /*  A partir daqui trata as notas de compra,  apenas   */
    for each item-doc-est 
       WHERE item-doc-est.serie-docto  = docum-est.serie-docto  
         AND item-doc-est.nro-docto    = docum-est.nro-docto    
         AND item-doc-est.cod-emitente = docum-est.cod-emitente 
         AND item-doc-est.nat-operacao = docum-est.nat-operacao no-lock:

        /*-- Acessa Pedido  e  Ordem de Compra do Item para Calculo do 
            Valor do Pedido -----------------------------------------*/

        ASSIGN w-num-pedido    =  0
               w-numero-ordem  =  0
               w-parcela       =  0
               l-tab-preco-div =  NO
               c-tb-preco      =  ""
               d-aliq-ipi      =  0.

        IF item-doc-est.num-pedido > 0 THEN DO:
            ASSIGN w-num-pedido    =  item-doc-est.num-pedido
                   w-numero-ordem  =  item-doc-est.numero-ordem
                   w-parcela       =  item-doc-est.parcela
                   w-quantidade    =  item-doc-est.quantidade.

            FOR EACH b-item-doc-est NO-LOCK WHERE
                     b-item-doc-est.serie-docto  = item-doc-est.serie-docto  AND
                     b-item-doc-est.nro-docto    = item-doc-est.nro-docto    AND
                     b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                     b-item-doc-est.nat-operacao = item-doc-est.nat-operacao AND
                     b-item-doc-est.numero-ordem = item-doc-est.numero-ordem AND
                     b-item-doc-est.sequencia    < item-doc-est.sequencia:
                ASSIGN w-quantidade = w-quantidade + b-item-doc-est.quantidade.
            END.
        END.
        ELSE DO:  /*  se nao tem no item-doc-tes, procura no arquivo Recebimento **/
            FIND FIRST recebimento 
                 where recebimento.data-movto     = docum-est.dt-trans
                   and recebimento.numero-nota    = item-doc-est.nro-docto
                   and recebimento.serie-nota     = item-doc-est.serie-docto
                   AND recebimento.cod-emitente   = item-doc-est.cod-emitente
                   AND recebimento.nat-operacao   = item-doc-est.nat-operacao
                   AND recebimento.it-codigo      = item-doc-est.it-codigo
                   AND recebimento.quant-receb    = item-doc-est.quantidade NO-LOCK NO-ERROR.

            IF AVAIL recebimento THEN
                ASSIGN w-num-pedido    = recebimento.num-pedido
                       w-numero-ordem  = recebimento.numero-ordem
                       w-parcela       = recebimento.parcela
                       w-quantidade    = recebimento.quant-receb.
            ELSE DO:         /***  Se nao tiver no Recebimento,  procura no rat-ordem:   FIFO   ****/
                FIND FIRST  rat-ordem WHERE rat-ordem.serie-docto = item-doc-est.serie-docto   AND
                                            rat-ordem.nro-docto = item-doc-est.nro-docto       AND
                                            rat-ordem.cod-emitente = item-doc-est.cod-emitente  AND
                                            rat-ordem.nat-operacao = item-doc-est.nat-operacao  AND
                                            rat-ordem.sequencia    = item-doc-est.sequencia   NO-LOCK  NO-ERROR.
                IF AVAIL rat-ordem  THEN
                    ASSIGN w-num-pedido    = rat-ordem.num-pedido
                           w-numero-ordem  = rat-ordem.numero-ordem
                           w-parcela       = rat-ordem.parcela
                           w-quantidade    = rat-ordem.quantidade.
            END.
        END.

        find pedido-compr WHERE pedido-compr.num-pedido = w-num-pedido no-lock no-error.

        if item-doc-est.num-pedido > 0 then do:
            find first tt-pedido NO-LOCK where tt-pedido.num-pedido = w-num-pedido no-error.
            if not avail tt-pedido then do:
                create tt-pedido. 
                assign tt-pedido.num-pedido = w-num-pedido.
            end.
        end.

        IF w-numero-ordem = 0 THEN NEXT.
        find first ordem-compra WHERE ordem-compra.numero-ordem = w-numero-ordem no-lock no-error.    
        /* Quando nao ha ordem de compra nao ha com que consistir  */
        if not avail ordem-compra then next.

        /* Procura o prazo de compras, quando a nota nao for devolucao */
        eh-devol = NO.
        FIND natur-oper WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK.
        IF natur-oper.denominacao BEGINS "devol" THEN
            ASSIGN eh-devol = YES.

        find first prazo-compra 
             WHERE prazo-compra.numero-ordem = w-numero-ordem 
               AND prazo-compra.parcela      = w-parcela NO-LOCK NO-ERROR.

        /*******************   rever...... gigi
        IF NOT AVAIL prazo-compra AND  NOT  eh-devol  THEN DO:
           MESSAGE "Prazo compra nao encontrado,  ordem: " w-numero-ordem VIEW-AS ALERT-BOX.
           NEXT.
        END.                *****************/

        ASSIGN de-preco-conv = ordem-compra.preco-fornec.
        FIND emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        IF ordem-compra.mo-codigo > 0 THEN DO:

            /*-----------------------------------------------------------------------------------------------
            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                              input 0,
                              input ordem-compra.preco-fornec,
                              input pedido-compr.data-pedido,
                              output de-preco-conv).
            ------------------------------------------------------------------------------------------------*/
            
            /*----------------------------------------------------------------------------------------------------------------------------------------------------------------
             Eduardo, bom dia.
             Conforme conversamos segue o novo Contrato de Fornecimento de ABS com o preáo baseado em USD. Preciso que o sistema entenda no ato da entrada da NF que o d¢lar a ser considerado Ç o D¢lar MÇdio Màs anterior. Esse processo j† foi validado com o Ricardo. 
             Esse contrato passa a ser valido no pr¢ximo dia 01/04. Vou acompanhar esse processo incialmente para evitarmos maiores problemas. 
             Atenciosamente,
             Mayara Sombrio Mafra 
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------*
             Alterada Data de Transaá∆o para Data de Emiss∆o conforme solicitaá∆od a Mayara - 10/10/2013
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

            /*
            ASSIGN dt-cotacao = docum-est.dt-emissao - DAY(docum-est.dt-emissao).

            FIND FIRST cotacao NO-LOCK
                 WHERE cotacao.mo-codigo   = ordem-compra.mo-codigo
                   AND cotacao.ano-periodo = STRING(YEAR(dt-cotacao),"9999") + STRING(MONTH(dt-cotacao),"99") NO-ERROR.
            IF AVAIL cotacao THEN DO:
                ASSIGN de-preco-conv = ordem-compra.preco-fornec * cotacao.cota-media.
            END.
            if de-preco-conv = 0 OR de-preco-conv = ? then
                de-preco-conv = ordem-compra.preco-fornec.            
            */

            ASSIGN dt-cotacao-fim = docum-est.dt-emissao - DAY(docum-est.dt-emissao)
                   dt-cotacao-ini = dt-cotacao-fim - DAY(dt-cotacao-fim) + 1.
            
            FIND FIRST cotacao NO-LOCK WHERE
                       cotacao.mo-codigo   = ordem-compra.mo-codigo AND
                       cotacao.ano-periodo = STRING(YEAR(dt-cotacao-fim),"9999") + STRING(MONTH(dt-cotacao-fim),"99") NO-ERROR.

            ASSIGN de-cotacao-tot = 0
                   i-num-cotacao  = 0.

            DO dt-cotacao-aux = dt-cotacao-ini TO dt-cotacao-fim:
                FIND FIRST calen-coml NO-LOCK WHERE
                           calen-coml.ep-codigo   = estabelec.ep-codigo /*param-global.empresa-prin*/ AND
                           calen-coml.cod-estabel = docum-est.cod-estabel     AND
                           calen-coml.data        = dt-cotacao-aux            NO-ERROR.
                IF NOT AVAIL calen-coml                   THEN NEXT.
                IF calen-coml.tipo-dia = 3 /* Feriado */ AND
                   NOT (MONTH(calen-coml.data) = 3 AND DAY(calen-coml.data) = 9) /* Feriado Municipal Joinville */ THEN NEXT.

                /* Obs: Para alguns dias que a Docol n∆o trabalha na F†brica o usu†rio (Gisele) est† parametrizando o dia como Final de Semana, 
                         porÇm Ç necess†rio considerar neste c†lculo */
                IF calen-coml.tipo-dia = 2 /* Final de Semana */ THEN DO: 
                   IF WEEKDAY(calen-coml.data) = 7 /* Sabado  */ THEN NEXT.
                   IF WEEKDAY(calen-coml.data) = 1 /* Domingo */ THEN NEXT.
                END.
                ASSIGN de-cotacao-tot = de-cotacao-tot + cotacao.cotacao[DAY(dt-cotacao-aux)]
                       i-num-cotacao  = i-num-cotacao + 1.
            END.
            ASSIGN de-preco-conv = de-cotacao-tot / i-num-cotacao * ordem-compra.preco-fornec.

            IF de-preco-conv = 0 OR
               de-preco-conv = ? THEN
               ASSIGN de-preco-conv = ordem-compra.preco-fornec.            

        END.

        ASSIGN de-indice = 1.
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.cod-emitente = ordem-compra.cod-emitente
               AND item-fornec.it-codigo    = ordem-compra.it-codigo NO-ERROR.
        ASSIGN de-indice = if avail item-fornec THEN item-fornec.fator-conver / if  item-fornec.num-casa-dec = 0 then 1 else exp(10, item-fornec.num-casa-dec) else 1.                           

        ASSIGN de-preco-conv = de-preco-conv * de-indice. /* retirar ap¢s ativar acima */
        assign de-desc       = 0
               de-preco      = 0
               de-preco-calc = 0
               de-ipi        = 0.

        IF param-compra.ipi-sobre-preco = 1 THEN DO:
            if ordem-compra.perc-descto > 0 then 
                assign de-desc = round(de-preco-conv * ordem-compra.perc-descto / 100,4). /* 4 casas por Gisele */

            if ordem-compra.taxa-financ = no then do:
                assign de-preco = de-preco-conv - de-desc.
                run ccp/cc9020.p (input yes,
                                  input ordem-compra.cod-cond-pag,
                                  input ordem-compra.valor-taxa,
                                  input ordem-compra.nr-dias-taxa,
                                  input de-preco,
                                  output de-preco-calc).

                assign de-preco = round(de-preco-calc - de-preco,4).
            end.
            ELSE assign de-preco-calc = de-preco-conv - de-desc.

            if ordem-compra.aliquota-ipi > 0  and 
               ordem-compra.codigo-ipi   = no then
                assign de-ipi = de-preco-calc * ordem-compra.aliquota-ipi / 100 * item-doc-est.quantidade.
        end.
        else do:
            if ordem-compra.taxa-financ = no then do:
                run ccp/cc9020.p (input yes,
                                  input ordem-compra.cod-cond-pag,
                                  input ordem-compra.valor-taxa,
                                  input ordem-compra.nr-dias-taxa,
                                  input de-preco-conv,
                                  output de-preco-calc).
                assign de-preco = round(de-preco-calc - de-preco-conv,8).
            end.
            ELSE assign de-preco-calc = de-preco-conv.
    
            if ordem-compra.aliquota-ipi > 0  and 
               ordem-compra.codigo-ipi   = no then
                assign de-ipi = de-preco-calc * ordem-compra.aliquota-ipi / 100 * item-doc-est.quantidade.
    
            if ordem-compra.perc-descto > 0 then
                assign de-desc = round((de-preco-calc + de-ipi) * ordem-compra.perc-descto / 100,2).
        end.
    
        /** Calcula o saldo do momento da parcela, que ja foi baixado */
        IF AVAIL prazo-compra THEN
            ASSIGN q-saldo = prazo-compra.quantidade.
    
        for each recebimento no-lock 
           where recebimento.data-movto  <= docum-est.dt-trans
             and recebimento.num-pedido   = w-num-pedido
             and recebimento.numero-ordem = w-numero-ordem
             AND recebimento.parcela      = w-parcela:
    
            /* desconsiderar nota vigente */
            if recebimento.numero-nota = docum-est.nro-docto      and
               recebimento.serie-nota  = item-doc-est.serie-docto then next.
    
            IF recebimento.cod-movto = 1 /* recebimento */ THEN
                ASSIGN q-saldo = q-saldo - recebimento.quant-receb  +  recebimento.quant-rejeit.
            ELSE  /* devolucao */
                ASSIGN q-saldo = q-saldo + recebimento.quant-receb  +  recebimento.quant-rejeit.
        end. 
    
        assign de-preco-total = de-preco-conv + de-preco - de-desc
               de-tot-item    = if item-doc-est.quantidade  =  0 then
                                    de-preco-total
                                else
                                    de-preco-total * item-doc-est.quantidade.
    
        /* VALIDACOES QUE GERAM DIVERGENCIAS A NIVEL DE ITEM  */
        /* Quantidade: 
           Compara o saldo da parcela com a quantidade da nota,
           nao pode ultrapassar   10 %  da quantidade total   */

        IF AVAIL prazo-compra THEN
           d-toler = prazo-compra.quantidade  *  0.10.
        
        if w-quantidade > q-saldo + d-toler then do:
            assign i-diverg = 2.
            {doinc/re1005ax.i1}
        end.    
    
        ASSIGN l-contrato-supply-house = NO
               l-contrato-medicao      = NO.

        IF ordem-compra.nr-contrato > 0 THEN DO:
            FIND FIRST contrato-for NO-LOCK WHERE
                       contrato-for.nr-contrato = ordem-compra.nr-contrato NO-ERROR.
            FIND FIRST item-contrat NO-LOCK WHERE
                       item-contrat.nr-contrato  = ordem-compra.nr-contrato  AND
                       item-contrat.num-seq-item = ordem-compra.num-seq-item NO-ERROR.
            IF AVAIL item-contrat AND item-contrat.ind-tipo-control = 1 THEN /* Mediá∆o*/
                ASSIGN l-contrato-medicao = YES. /* Chamado 59742*/
            IF AVAIL contrato-for THEN DO: 
                FIND tipo-contrat WHERE tipo-contrat.cod-tipo-contr = contrato-for.cod-tipo-contr NO-ERROR.
                IF  contrato-for.cod-tipo-contr = 11 /* Supply House (1/2 Salario) */ 
                OR  contrato-for.cod-tipo-contr = 12 /* Supply House (1 Salario) */   
                OR  contrato-for.cod-tipo-contr = 14 /* Supply House (OC<=R$100,00) */
                OR  contrato-for.cod-tipo-contr = 15 /* Supply House (OC<=R$200,00) */ THEN
                    ASSIGN l-contrato-supply-house = YES
                           de-salario-minimo       = tipo-contrat.dec-2. /* Maior que 1/2 Sal†rio 380 */.
            END.
        END. /* if ordem-compra.nr-contrato > 0 */
    
        /*------------------------------------------------------------------------------------------------------------------------------* 
            28/03/2007 - Solicitante: Marcelo/Graziela - SSI 009/07 - PROJETO LEAN COMPRAS
         *------------------------------------------------------------------------------------------------------------------------------*
            Nos contratos Supply House as Ordens de Compra est∆o com o Valor de R$ 0,01.           
           (Existe um item generico que ser† utilizado para comprar v†rios itens de manutená∆o com preáos diferentes porÇm baixos. Se fossemos cadastrar todas as opá‰es de itens/preáo seria inviavel pelo volume de dados e manutená∆o).
            O sistema dever†r:
              - Validar SE O VALOR TOTAL DE CADA ITEM DA NOTA dever† ser menor que 1/2 SALµRIO M÷NIMO. (Hoje = R$ 350,00)
              - Atualizar o saldo em valor do contrato, pois o valor atualizado pelo programa da Datasul foi baseado no valor da Ordem de Compra e n∆o da Nota.
          *----------------------------------------------------------------------------------------------------------------------------------------------------*/    

        IF NOT l-contrato-medicao THEN DO:
            IF l-contrato-supply-house THEN DO:
                IF docum-est.cod-observ <> 2 THEN 
                    ASSIGN de-ipi = item-doc-est.valor-ipi[1].
                ELSE
                    ASSIGN de-ipi = 0.
        
                ASSIGN de-tot-item    = (item-doc-est.preco-total[1] - item-doc-est.desconto[1])
                       de-preco-total = de-tot-item / item-doc-est.quantidade.
        
                FIND item-contrat WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato
                                    AND item-contrat.num-seq-item = ordem-compra.num-seq-item NO-ERROR.
                IF AVAIL item-contrat THEN DO:
                    IF item-contrat.sld-val-receb > item-contrat.sld-val THEN
                        ASSIGN item-contrat.sld-val = item-contrat.sld-val-receb.
                    IF item-contrat.val-total < item-contrat.sld-val-receb THEN DO:
                        ASSIGN l-ultrapassou-supply-house = YES.
                    END.
                END.
        
                /* Maior que 1/2 Sal†rio ou 1 Salario*/
                IF (de-tot-item) > de-salario-minimo THEN DO:
                    ASSIGN de-tot-item    = de-salario-minimo
                           de-preco-total = de-tot-item / item-doc-est.quantidade
                           de-ipi         = 0.
        
                    ASSIGN i-diverg = 1.
                    {doinc/re1005ax.i1}
                END.
            END. /* if l-contrato-supply-house */
            ELSE DO:
                ASSIGN l-tab-preco-div = NO
                       de-tot-item-max = 0
                       de-tot-item-min = 0.
    /*gustavo inicio*/
                /* iniciar a vaslidaá∆o de bloqueio de recebimento  de NF por diferena de valor da OC (NDS 62340 ) */

                /* Busca Pedido de compra para identificar a condiá∆o de pagamento */
                FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = item-doc-est.num-pedido NO-LOCK NO-ERROR.
                IF AVAIL pedido-compr THEN DO:
    
                    /* NDS 32837 - Criaá∆o de Diverg“ncias a partir de Tabela de preáo importada via DCC104.w */
                    blk-tb-pr:
                    FOR EACH dc-tb-pr-cc NO-LOCK 
                       WHERE dc-tb-pr-cc.cod-emitente = docum-est.cod-emitente 
                         AND dc-tb-pr-cc.cdn-fabrican = 0 
                         AND dc-tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag 
                         AND dc-tb-pr-cc.dt-inicio    <= docum-est.dt-emissao     : /* Busca tabela de preáo do per°odo do faturamento */
    
                        IF dc-tb-pr-cc.consid-diverg AND dc-tb-pr-cc.natureza = pedido-compr.natureza THEN DO:
    
                            FIND FIRST tb-pr-cc OF dc-tb-pr-cc NO-LOCK NO-ERROR.
    
                            /* Somente permite se a data de termino da validade da tabela de preáo estiver dentro da faixa */
                            IF tb-pr-cc.dt-termino   >= docum-est.dt-emissao THEN DO:
                            
                                /* Somente tabela de preáo Ativa */
                                IF AVAIL tb-pr-cc AND tb-pr-cc.situacao = 1 THEN DO:
    
                                    FOR FIRST item-tab OF tb-pr-cc
                                        WHERE item-tab.it-codigo = item-doc-est.it-codigo NO-LOCK:
    
                                        /* Valida Preáo da tabela com IPI x Quantidade contra Item Nota + IPI */
                                        /* ACRESCENTA E DIMINUI 1 CENTAVO PARA VARIAÄÂES NO CµLCULO */
                                        ASSIGN de-tot-item     = item-tab.pr-item * item-doc-est.quantidade
                                               de-tot-item-max = ROUND((item-tab.pr-item /*+ 0.01 Chamado 54616 */ ) * item-doc-est.quantidade,2)
                                               de-tot-item-min = ROUND((item-tab.pr-item /*- 0.01 Chamado 54616 */ ) * item-doc-est.quantidade,2)
                                               l-tab-preco-div = YES
                                               d-aliq-ipi      = item-tab.aliquota-ipi.
    
                                        /* SE IPI INCLUSO ENTAO VALOR "0" SENAO CALCULA */ 
                                        IF tb-pr-cc.codigo-ipi THEN
                                            ASSIGN de-ipi = 0.
                                        ELSE
                                            ASSIGN de-ipi = ROUND(de-tot-item * (item-tab.aliquota-ipi / 100),2)
                                                   de-ipi-max = ROUND(de-tot-item-max * (item-tab.aliquota-ipi / 100),2)
                                                   de-ipi-min = ROUND(de-tot-item-min * (item-tab.aliquota-ipi / 100),2).
    
                                        /* Calcula preco total que deveria ter vindo */
                                        ASSIGN de-preco-total = de-tot-item / item-doc-est.quantidade /* Chamado 58470 - retirado ROUND com duas casas*/
                                               c-tb-preco     = tb-pr-cc.nr-tab.
    
                                        LEAVE blk-tb-pr.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.

                FIND FIRST item-mat NO-LOCK WHERE item-mat.it-codigo = item-doc-est.it-codigo NO-ERROR.
                ASSIGN de-lim-variacao-valor = 0. 
                       de-per-lim-var-quant  = 0.

                IF AVAIL item-mat THEN 
                    ASSIGN de-per-lim-var-quant  = item-mat.var-qtd-re
                           de-lim-variacao-valor = item-mat.lim-var-valor.

                IF de-lim-variacao-valor = 0 THEN ASSIGN de-lim-variacao-valor = 0.01.
                IF de-per-lim-var-quant  = 0 THEN ASSIGN de-per-lim-var-quant  = 10.

                IF l-tab-preco-div THEN DO:
    
                    /* Preco do Item COM IPI da Nota e Preáo da tabela com IPI */
                    /* Chamado 45397 */
                    IF (item-doc-est.preco-total[1] - item-doc-est.desconto[1] /* + item-doc-est.valor-ipi[1]*/ ) > (de-tot-item-max + de-ipi-max + de-lim-variacao-valor)  /* Comentario em 11/12: solicitado por Graziela. Nao criar divergencia quando preco da nota com IPI for menor que o preco da tabela com IPI.
                     OR (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + item-doc-est.valor-ipi[1]) < (de-tot-item-min + de-ipi-min - de-lim-variacao-valor)*/ THEN DO: /* Chamado 58641 - incluidos os + 0.01 e - 0.01*/
    
                        ASSIGN i-diverg = 1.
                        {doinc/re1005ax.i1}
                        /* GRAVA TABELA DE PREÄO E ALIQUOTA DE IPI COMO MEMORIA DE CµLCULO */
                        ASSIGN dc-diverg-it.tb-preco          = c-tb-preco
                               dc-diverg-it.tb-preco-aliq-ipi = d-aliq-ipi.
                    END.
    
                END.

    /*gustavo fim  */

                ELSE DO:
    
                    /* Valor:  Compara preco da nota liquido com preco do pedido de compra  */
                    if (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) > (de-tot-item  + de-lim-variacao-valor) OR
                       (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) < (de-tot-item - de-lim-variacao-valor) then do:
                        assign i-diverg = 1.
                        {doinc/re1005ax.i1}
                    end.  
                    ELSE DO:

                        /* Valor:  Compara preco da nota com ipi,  com preco do pedido de compra, com IPI  */
                        IF docum-est.cod-observ <> 2 THEN     /**  Comercio - Nota nao soma o IPI no Total */
                            ASSIGN w-preco-nota = (item-doc-est.preco-total[1] - item-doc-est.desconto[1] /*+ item-doc-est.valor-ipi[1])*/ .
                        ELSE
                            ASSIGN w-preco-nota = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) /*+ item-doc-est.valor-ipi[1]) Alterado confome chamado Divergencia NF x Pedido */ . 
            
                        if w-preco-nota > (de-tot-item  + de-ipi + de-lim-variacao-valor) /* Comentario em 11/12: solicitado por Graziela. Nao criar divergencia quando preco da nota com IPI for menor que o preco do pedido com IPI.
                        OR w-preco-nota < (de-tot-item  + de-ipi - de-lim-variacao-valor)*/ then do:
                            assign i-diverg = 1.
                            {doinc/re1005ax.i1}

                            ASSIGN dc-diverg-it.valor-item-rec = w-preco-nota / item-doc-est.quantidade
                                   dc-diverg-it.vl-ipi         = 0
                                   dc-diverg-it.valor-item-ped = ((de-tot-item /*+ de-ipi*/ ) / item-doc-est.quantidade).
                        end.
                    END.
                END.
            END.
        END. /* NOT l-contrato-medicao*/
    
        /* Variavel para acumular o valor de todos os itens calculados  */
        /* AcrÇscimo do valor de despesa, pois n∆o estava sendo considerada no valor,  por Gisele, em 01/06/2007  */
        assign acum-valor  =  acum-valor  +  de-tot-item  + de-ipi  +  docum-est.despesa-nota + item-doc-est.vl-subs[1].
           
    end. /*-- for each item-doc-est --------------------------------*/

    /* 
    /* Chamado 60849 - N∆o estava considerando valor de ST -> Chamado 71749 e 74395 (havia perdido a vers∆o do 71749) - estava somando ST no local incorreto. movido para ASSIGN da acum-valor acima, Ö nivel de item. somente se chegar ao final da leitura (e existir ordem de compra)*/
    ASSIGN acum-valor = acum-valor + docum-est.vl-subs.
    */
    
    assign tot-antecip = 0.
    for each tt-pedido:
        for each dc-antecip-ped 
           where dc-antecip-ped.num-pedido = tt-pedido.num-pedido no-lock:
            assign tot-antecip = tot-antecip + dc-antecip-ped.vl-ant-pedido.
        end.
    end.
    
    /* VALIDACOES A NIVEL DE DOCUMENTO / DUPLICATA */
    
    assign w-parc = 0.
           de-tot-duplicatas = 0.
    
    for each dupli-apagar of docum-est no-lock:
    
        /* Retirada Condicao de Especie 24/04/2001 Diomar/Gisele 
        if dupli-apagar.cod-esp <> "DP"  and
           dupli-apagar.cod-esp <> "DS"  and
           dupli-apagar.cod-esp <> "AF" then next.
        */
         
        /* Para cada divergencia de item, deve ser criada divergencia
           em TODAS as duplicatas correspondentes com tipo =  1 valor ou tipo  =  2 quantidade  */
        
        assign w-parc = w-parc + 1
               de-tot-duplicatas = de-tot-duplicatas + dupli-apagar.vl-a-pagar.
        
        for each dc-diverg-it 
           where dc-diverg-it.cod-emitente  = docum-est.cod-emitente   
             and dc-diverg-it.serie         = docum-est.serie          
             and dc-diverg-it.nro-docto     = docum-est.nro-docto      
             and dc-diverg-it.nat-operacao  = docum-est.nat-operacao   
             and dc-diverg-it.cod-diverg    < 3 no-lock:
    
            find first dc-diverg-dp
                 where dc-diverg-dp.cod_empresa     = estabelec.ep-codigo /*string(param-global.empresa-prin)*/
                   AND dc-diverg-dp.cod_estab       = docum-est.cod-estabel
                   and dc-diverg-dp.cod_espec_docto = dupli-apagar.cod-esp
                   and dc-diverg-dp.cod_ser_docto   =  dc-diverg-it.serie
                   and dc-diverg-dp.cod_tit_ap      =  dc-diverg-it.nro-docto
                   and dc-diverg-dp.cod_parcela     = dupli-apagar.parcela
                   and dc-diverg-dp.cdn_fornecedor  =  dc-diverg-it.cod-emitente
                   and dc-diverg-dp.nat-operacao    =  dc-diverg-it.nat-operacao
                   and dc-diverg-dp.cod-diverg      =  dc-diverg-it.cod-diverg no-error.

            if not avail dc-diverg-dp then do:       
                create dc-diverg-dp.
                assign dc-diverg-dp.cod_empresa     = estabelec.ep-codigo /*string(param-global.empresa-prin)*/
                       dc-diverg-dp.cod_estab       =  docum-est.cod-estabel
                       dc-diverg-dp.cod_espec_docto =  dupli-apagar.cod-esp
                       dc-diverg-dp.cod_ser_docto   =  dupli-apagar.serie
                       dc-diverg-dp.cod_tit_ap      =  dupli-apagar.nro-docto
                       dc-diverg-dp.cod_parcela     =  dupli-apagar.parcela
                       dc-diverg-dp.cdn_fornecedor  =  dupli-apagar.cod-emitente
                       dc-diverg-dp.nat-operacao    =  dupli-apagar.nat-operacao
                       dc-diverg-dp.cod-diverg      =   dc-diverg-it.cod-diverg
                       dc-diverg-dp.data-bloqueio   =  today
                       dc-diverg-dp.hora-bloqueio   =  string(time,"hh:mm:ss")
                       dc-diverg-dp.serie           = docum-est.serie          
                       dc-diverg-dp.cod-emitente    = docum-est.cod-emitente    
                       dc-diverg-dp.nro-docto       = docum-est.nro-docto.
                
                /* Comprador fixo quando nota de terceiros */
                if dc-diverg-it.terceiros  then do:
                    if dc-diverg-dp.nat-operacao  =  "113c"   then
                        assign dc-diverg-dp.cod-comprado  =   "luizca".
    
                    if dc-diverg-dp.nat-operacao = "213a"   or
                       dc-diverg-dp.nat-operacao = "113072" then
                        assign dc-diverg-dp.cod-comprado  =  "ricardoz".
                end.
            end.
            /*
            IF dc-diverg-it.cod-diverg = 1 THEN 
                ASSIGN dc-diverg-dp.valor-ped = dc-diverg-dp.valor-ped + (dc-diverg-it.valor-item-ped * dc-diverg-it.quantidade-ped)
                       dc-diverg-dp.valor-rec = dc-diverg-dp.valor-rec + (dc-diverg-it.valor-item-rec * dc-diverg-it.quantidade-rec).
            ELSE 
                ASSIGN dc-diverg-dp.valor-ped = dc-diverg-dp.valor-ped + dc-diverg-it.quantidade-ped
                       dc-diverg-dp.valor-rec = dc-diverg-dp.valor-rec + dc-diverg-it.quantidade-rec.
            */
        end.
    
        if tot-antecip > 0 then do:
            create dc-diverg-dp.
            assign dc-diverg-dp.cod_empresa     = estabelec.ep-codigo /* string(param-global.empresa-prin)*/
                   dc-diverg-dp.cod_estab       =  docum-est.cod-estabel
                   dc-diverg-dp.cod_espec_docto =  dupli-apagar.cod-esp
                   dc-diverg-dp.cod_ser_docto   =  dupli-apagar.serie
                   dc-diverg-dp.cod_tit_ap      =  dupli-apagar.nro-docto
                   dc-diverg-dp.cod_parcela     =  dupli-apagar.parcela
                   dc-diverg-dp.cdn_fornecedor  =  dupli-apagar.cod-emitente
                   dc-diverg-dp.nat-operacao    =  dupli-apagar.nat-operacao
                   dc-diverg-dp.cod-diverg      =  3
                   dc-diverg-dp.data-bloqueio   =  today
                   dc-diverg-dp.serie           = docum-est.serie          
                   dc-diverg-dp.cod-emitente    = docum-est.cod-emitente    
                   dc-diverg-dp.nro-docto       = docum-est.nro-docto
                   dc-diverg-dp.hora-bloqueio   =  string(time,"hh:mm:ss").
            if tot-antecip <= dupli-apagar.vl-a-pagar THEN
                assign dc-diverg-dp.valor-rec = dupli-apagar.vl-a-pagar - tot-antecip
                       tot-antecip            = 0.
            else
                assign dc-diverg-dp.valor-rec = 0
                       tot-antecip            = tot-antecip - dupli-apagar.vl-a-pagar.
        end.
    
        find first item-doc-est of docum-est where item-doc-est.num-pedido > 0 no-lock no-error.
        if avail item-doc-est then do:
            find first pedido-compr where pedido-compr.num-pedido = item-doc-est.num-pedido no-lock.
            if avail pedido-compr then do:   /* terceiros nao tem pedido */
                find cond-pagto WHERE cond-pagto.cod-cond-pag  = pedido-compr.cod-cond-pag no-lock.
    
                assign da-data       = dupli-apagar.dt-emissao
                       da-partida    = dupli-apagar.dt-emissao    
                       i-cond        = cond-pagto.cod-vencto 
                       i-cond-pagto  = cond-pagto.cod-cond-pag
                       i-num-parc    = cond-pagto.num-parcelas.
    
                {doinc/re1005ax.i4 estabel.cod-estabel}                      
    
                /* Se data digitada, convertida para util, for maior que a calculada  +  2  dias, gerara DS */
                n-dias = 2.
                d-data-venc = dupli-apagar.dt-vencim.
    
                /* Transforma a data informada  na duplicata  
                   para o proximo dia util, desconsiderando feriados,
                   sabado e domingo, por Gisele, em 22/08/2001   **/
                repeat:
                    find first calen-coml
                         where calen-coml.ep-codigo   = estabelec.ep-codigo /*param-global.empresa-prin*/ 
                           AND calen-coml.cod-estabel = dupli-apagar.cod-estabel 
                           AND calen-coml.data        =  d-data-venc no-lock  no-error.
                    if calen-coml.tipo-dia <> 1 then
                        d-data-venc = d-data-venc + 1.
                    ELSE leave.
                end. 
    
                if d-data-venc + n-dias < da-data[w-parc] then do:
                    assign i-diverg = 4.
                    {doinc/re1005ax.i2}
                end.
            end.  /* if avail pedido-compr */
        end.  /* if avail item-doc-est */
    
        /* Caso existiu alguma divergencia, joga o valor total, por parcela */
        
        find first dc-diverg-dp 
             WHERE dc-diverg-dp.cod_empresa     = estabelec.ep-codigo /*param-global.empresa-prin*/
               AND dc-diverg-dp.cod_estab       = dupli-apagar.cod-estabel  
               AND dc-diverg-dp.cod_espec_docto = dupli-apagar.cod-esp      
               AND dc-diverg-dp.cod_ser_docto   = dupli-apagar.serie-docto  
               AND dc-diverg-dp.cod_tit_ap      = dupli-apagar.nro-docto    
               AND dc-diverg-dp.cod_parcela     = dupli-apagar.parcela      
               AND dc-diverg-dp.cdn_fornecedor  = dupli-apagar.cod-emitente
               AND dc-diverg-dp.nat-operacao    = dupli-apagar.nat-operacao 
               AND dc-diverg-dp.cod-diverg      < 3 no-error.
        if avail dc-diverg-dp  then do: 

            if avail cond-pagto THEN
                ASSIGN dc-diverg-dp.valor-ped = acum-valor * cond-pagto.per-pg-dup[w-parc] / 100
                       dc-diverg-dp.valor-rec = dupli-apagar.vl-a-pagar.
            ELSE
                ASSIGN dc-diverg-dp.valor-ped = acum-valor
                       dc-diverg-dp.valor-rec = dupli-apagar.vl-a-pagar.  /* sem pedido, terc  */
        end.
    end. /* for each dupli-apagar */  
    
    /***** Verifica se houve divergencia nos valores totais : pedido e duplicatas  
    Gera divergencia a nivel de duplicata         por Gisele / Eduardo em 03/12/2004  *****/
    IF de-tot-duplicatas > 0 AND
       acum-valor > 0        THEN DO:
    
        IF de-tot-duplicatas > (acum-valor + 1) OR
           l-ultrapassou-supply-house           THEN DO:
    
            find first item-doc-est of docum-est where item-doc-est.num-pedido > 0 no-lock no-error.
            if avail item-doc-est then do:           
                find first pedido-compr where pedido-compr.num-pedido = item-doc-est.num-pedido no-lock.
                if avail pedido-compr then do:   /* terceiros nao tem pedido */
                    find cond-pagto WHERE cond-pagto.cod-cond-pag  = pedido-compr.cod-cond-pag no-lock.
                END.
            END.

            /* Verifica se contrato Ç de mediá∆o*/
            ASSIGN l-contrato-medicao = NO.

            FOR EACH item-doc-est NO-LOCK WHERE
                     item-doc-est.serie-docto  = docum-est.serie-docto   AND
                     item-doc-est.nro-docto    = docum-est.nro-docto     AND
                     item-doc-est.cod-emitente = docum-est.cod-emitente  AND
                     item-doc-est.nat-operacao = docum-est.nat-operacao:

                ASSIGN w-num-pedido   = 0
                       w-numero-ordem = 0
                       w-parcela      = 0
                       w-quantidade   = 0.

                IF item-doc-est.num-pedido > 0 THEN
                    ASSIGN w-num-pedido    = item-doc-est.num-pedido
                           w-numero-ordem  = item-doc-est.numero-ordem
                           w-parcela       = item-doc-est.parcela
                           w-quantidade    = item-doc-est.quantidade.
                ELSE DO:  /*  se nao tem no item-doc-tes, procura no arquivo Recebimento **/
                    FIND FIRST recebimento NO-LOCK WHERE
                               recebimento.data-movto   = docum-est.dt-trans        AND
                               recebimento.numero-nota  = item-doc-est.nro-docto    AND
                               recebimento.serie-nota   = item-doc-est.serie-docto  AND
                               recebimento.cod-emitente = item-doc-est.cod-emitente AND
                               recebimento.nat-operacao = item-doc-est.nat-operacao AND
                               recebimento.it-codigo    = item-doc-est.it-codigo    AND
                               recebimento.quant-receb  = item-doc-est.quantidade   NO-ERROR.
                    IF AVAIL recebimento THEN
                        ASSIGN w-num-pedido   = recebimento.num-pedido
                               w-numero-ordem = recebimento.numero-ordem
                               w-parcela      = recebimento.parcela
                               w-quantidade   = recebimento.quant-receb.
                    ELSE DO: /***  Se nao tiver no Recebimento,  procura no rat-ordem:   FIFO   ****/
                        FIND FIRST rat-ordem NO-LOCK WHERE
                                   rat-ordem.serie-docto = item-doc-est.serie-docto   AND
                                   rat-ordem.nro-docto = item-doc-est.nro-docto       AND
                                   rat-ordem.cod-emitente = item-doc-est.cod-emitente AND
                                   rat-ordem.nat-operacao = item-doc-est.nat-operacao AND
                                   rat-ordem.sequencia    = item-doc-est.sequencia    NO-ERROR.
                        IF AVAIL rat-ordem THEN
                            ASSIGN w-num-pedido   = rat-ordem.num-pedido
                                   w-numero-ordem = rat-ordem.numero-ordem
                                   w-parcela      = rat-ordem.parcela
                                   w-quantidade   = rat-ordem.quantidade.
                    END.
                END.

                IF w-numero-ordem = 0 THEN NEXT.

                FIND FIRST ordem-compra NO-LOCK WHERE
                           ordem-compra.numero-ordem = w-numero-ordem NO-ERROR.

                FIND FIRST item-contrat NO-LOCK WHERE
                           item-contrat.nr-contrato  = ordem-compra.nr-contrato  AND
                           item-contrat.num-seq-item = ordem-compra.num-seq-item NO-ERROR.
                IF AVAIL item-contrat AND item-contrat.ind-tipo-control = 1 THEN DO: /* Mediá∆o*/
                    ASSIGN l-contrato-medicao = YES. /* Chamado 60400*/
                    LEAVE.
                END.
            END. /* EACH item-doc-est*/

            IF NOT l-contrato-medicao THEN DO:
                assign w-parc = 0.
                for each dupli-apagar of docum-est no-lock:
        
                    assign w-parc = w-parc + 1
                           i-diverg = 1.
                    {doinc/re1005ax.i2}
        
                    if avail dc-diverg-dp  then do:
                        if avail cond-pagto THEN 
                            ASSIGN dc-diverg-dp.valor-ped  = acum-valor * cond-pagto.per-pg-dup[w-parc] / 100
                                   dc-diverg-dp.valor-rec  = dupli-apagar.vl-a-pagar.
                        ELSE 
                            ASSIGN dc-diverg-dp.valor-ped  = acum-valor
                                   dc-diverg-dp.valor-rec  = dupli-apagar.vl-a-pagar.  /* sem pedido, terc  */
                    END.
                END.
            END. /* NOT l-contrato-medicao*/

        END. /* de-tot-duplicatas > (acum-valor + 1) OR l-ultrapassou-supply-house*/
    END. /* de-tot-duplicatas > 0 AND acum-valor > 0*/

END.

/* re1005ax.p */
