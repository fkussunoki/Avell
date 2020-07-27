RUN dop/doc010dev.p (INPUT  c-cod-empresa       , 
                     INPUT  c-lista-cod-estab   , 
                     INPUT  dt-periodo-ini      , 
                     INPUT  dt-periodo-fin      , 
                     INPUT  c-ct-cpv-orcam-db   , 
                     INPUT  c-ct-cpv-orcam-cr   , 
                     INPUT  c-ct-cpv-var        , 
                     INPUT  c-ct-cpv-fixo       , 
                     INPUT  c-ct-recomp-cpv-var , 
                     INPUT  c-ct-recomp-cpv-fixo, 
                     OUTPUT TABLE tt-detalhe,
                     OUTPUT TABLE tt-contabiliza).



/********************************************************************************
 ** colocado em comentario - porque a logica est† no programa dop/doc010dev.p 
 ********************************************************************************

/* Bloco Principal */
FIND FIRST plano_cta_ctbl NO-LOCK
    WHERE plano_cta_ctbl.dat_inic_valid        <= TODAY          
      AND plano_cta_ctbl.dat_fim_valid         >= TODAY 
      AND plano_cta_ctbl.ind_tip_plano_cta_ctbl = 'Prim†rio' NO-ERROR.
   
IF AVAIL plano_cta_ctbl THEN DO:
   FIND FIRST empresa NO-LOCK USE-INDEX empresa_id
       WHERE empresa.cod_empresa = c-cod-empresa NO-ERROR.
   IF AVAIL empresa THEN DO:
      FIND FIRST plano_ccusto NO-LOCK USE-INDEX plnccst_id
           WHERE plano_ccusto.cod_empresa      = empresa.cod_empresa 
             AND plano_ccusto.dat_inic_valid  <= TODAY
             AND plano_ccusto.dat_fim_valid   >= TODAY NO-ERROR.

      FIND FIRST histor_finalid_econ NO-LOCK 
           WHERE histor_finalid_econ.cod_finalid_econ       = 'Corrente' 
             AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
             AND histor_finalid_econ.dat_fim_valid_finalid  >= TODAY NO-ERROR.
       
      FOR EACH estabelecimento NO-LOCK USE-INDEX stblcmnt_id
         WHERE estabelecimento.cod_empresa = c-cod-empresa
           AND LOOKUP(estabelecimento.cod_estab,c-lista-cod-estab) <> 0:

          FIND FIRST dc-orc-param NO-LOCK
               WHERE dc-orc-param.cod-empresa        = empresa.cod_empresa
                 AND dc-orc-param.cod-estabel        = estabelecimento.cod_estab
                 AND dc-orc-param.cod-plano-cta-ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
                 AND dc-orc-param.cod-plano-ccusto   = plano_ccusto.cod_plano_ccusto
                 AND dc-orc-param.dt-inic-valid      <= TODAY
                 AND dc-orc-param.dt-fin-valid       >= TODAY NO-ERROR.
          IF AVAIL dc-orc-param THEN DO:
             FOR EACH docum-est NO-LOCK USE-INDEX dt-tp-estab 
                WHERE docum-est.dt-trans   >= dt-periodo-ini   
                  AND docum-est.dt-trans   <= dt-periodo-fin
                  AND docum-est.cod-estabel = estabelecimento.cod_estab
                BREAK BY docum-est.dt-trans:

                IF FIRST-OF(docum-est.dt-trans) THEN
                   RUN pi-acompanhar IN h-acomp ('Lendo Dia ' + string(docum-est.dt-trans,'99/99/9999')).
                   
                FIND FIRST natur-oper NO-LOCK 
                     WHERE natur-oper.nat-operacao = docum-est.nat-operacao 
                       AND natur-oper.tipo         = 1
                       AND natur-oper.especie-doc = "NFD"
                       AND NOT natur-oper.emite-duplic NO-ERROR.
                IF AVAIL natur-oper THEN DO:
                   FIND FIRST dc-natur-oper OF natur-oper NO-LOCK
                        WHERE dc-natur-oper.lg-devolucao = YES NO-ERROR.
                   IF AVAIL dc-natur-oper THEN DO:
                      FIND FIRST emitente NO-LOCK
                           WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
                      FOR EACH item-doc-est OF docum-est NO-LOCK
                         WHERE item-doc-est.it-codigo <> ''
                         BREAK BY item-doc-est.serie-docto
                               BY item-doc-est.nro-docto
                               BY item-doc-est.cod-emitente
                               BY item-doc-est.nat-operacao
                               BY item-doc-est.sequencia:

                         ASSIGN ccusto-debito = ''.
                         FIND FIRST nota-fiscal NO-LOCK 
                              WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel 
                                AND nota-fiscal.serie       = item-doc-est.serie-comp
                                AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp  NO-ERROR.

                         IF AVAIL nota-fiscal THEN DO:
                            ASSIGN i-cod-rep = nota-fiscal.cod-rep.

                            RUN dop/dft000.p (INPUT nota-fiscal.cod-estabel,
                                              INPUT nota-fiscal.serie,
                                              INPUT nota-fiscal.nr-nota-fis,
                                              OUTPUT c-mercado,
                                              OUTPUT c-tipo-mercado,
                                              OUTPUT ccusto-debito,
                                              OUTPUT c-nome-ab-reg).

/*                             FIND FIRST ped-venda NO-LOCK                                      */
/*                                  WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli         */
/*                                    AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR. */
/*                             IF AVAIL ped-venda THEN DO:                                       */
/*                                FIND FIRST grupo-ped NO-LOCK                                   */
/*                                     WHERE grupo-ped.tp-pedido = ped-venda.tp-pedido           */
/*                                       AND grupo-ped.cod-grupo = cod-grupo-sat NO-ERROR.       */
/*                                IF AVAIL grupo-ped THEN                                        */
/*                                   ASSIGN ccusto-debito = c-cc-gr-ped.                         */
/*                             END.                                                              */
                         END.
                         ELSE DO:
                            IF emitente.cod-rep = 1 THEN 
                               ASSIGN i-cod-rep = 98.
                            ELSE
                               ASSIGN i-cod-rep = emitente.cod-rep.
                         END.

                         ASSIGN  log-dev-recompr  = IF natur-oper.cod-esp = "NR" /* Recompra */
                                                       THEN NO
                                                       ELSE YES
                                 de-vl-devolucao  = item-doc-est.preco-total[1] - item-doc-est.valor-icm[1] -
                                                    item-doc-est.desconto[1]    + item-doc-est.despesas[1].
                         
                         IF ccusto-debito = ''    OR
                            ccusto-debito = '0' THEN DO:

                            ASSIGN c-mercado      = ""
                                   c-tipo-mercado = ""
                                   c-nome-ab-reg  = "".

                            IF docum-est.nat-operacao BEGINS "3" OR emitente.cod-gr-cli = 98 THEN 
                               ASSIGN c-mercado = "EXTERNO".
                            ELSE
                               ASSIGN c-mercado = "INTERNO".
                            
                            FIND FIRST dc-repres NO-LOCK 
                                 WHERE dc-repres.cod_empresa = c-cod-empresa  
                                   AND dc-repres.cdn_repres  = i-cod-rep NO-ERROR.

                            IF c-mercado = "INTERNO" AND
                               AVAIL dc-repres      THEN DO:
                               
                               IF  LOOKUP(TRIM(emitente.categoria),"I,O,S,D,Z,L") > 0 THEN
                                   ASSIGN c-tipo-mercado = "ICC".
                               ELSE
                                   ASSIGN c-tipo-mercado = "REVENDA".

                               FIND FIRST regiao-cliente NO-LOCK
                                    WHERE regiao-cliente.nome-matriz = emitente.nome-matriz NO-ERROR.
                               IF AVAIL regiao-cliente THEN DO:
                                  ASSIGN c-nome-ab-reg = regiao-cliente.nome-ab-reg.
                               END.
                               ELSE DO:
                                  FIND FIRST repres NO-LOCK
                                       WHERE repres.cod-rep = i-cod-rep NO-ERROR.
                                  IF AVAIL repres THEN DO:
                                     ASSIGN c-nome-ab-reg = repres.nome-ab-reg.
                                  END.
                               END.
 
                               /* Troca Regi∆o (Gestor) para Vendas de ICC com separaá∆o total entre gest∆o Revenda e ICC */
                               FIND FIRST dc-regiao NO-LOCK 
                                    WHERE dc-regiao.nome-ab-reg = c-nome-ab-reg NO-ERROR.
                               IF AVAIL dc-regiao AND dc-regiao.cod-gestor <> "" AND c-tipo-mercado = "ICC" THEN DO:
                                  ASSIGN c-nome-ab-reg = dc-regiao.cod-gestor.
                               END.          
                               /* FIM-Troca Regi∆o (Gestor) para Vendas de ICC com separaá∆o total entre gest∆o Revenda e ICC */
 
                               FIND FIRST dc-regiao NO-LOCK
                                    WHERE dc-regiao.nome-ab-reg = c-nome-ab-reg NO-ERROR.
                               IF AVAIL dc-regiao THEN DO:
                                  IF c-tipo-mercado = "REVENDA" THEN
                                     ASSIGN ccusto-debito = dc-regiao.cod-ccusto-revenda.
                                  IF c-tipo-mercado = "ICC" THEN
                                     ASSIGN ccusto-debito = dc-regiao.cod-ccusto-icc.
                               END.
                            END.

                            IF ccusto-debito = "" AND AVAIL dc-repres THEN
                               ASSIGN ccusto-debito = dc-repres.cod_ccusto.

                         END.

                         IF rt-tipo-relat = 2 THEN DO: /* Detalhado */
                            FIND tt-detalhe USE-INDEX ch-principal 
                                 WHERE tt-detalhe.ep-codigo     = empresa.cod_empresa              
                                   AND tt-detalhe.cod-estabel   = docum-est.cod-estabel  
                                   AND tt-detalhe.dt-trans      = docum-est.dt-trans     
                                   AND tt-detalhe.cc-codigo     = ccusto-debito            
                                   AND tt-detalhe.cod-emit      = docum-est.cod-emitente 
                                   AND tt-detalhe.serie-docto   = docum-est.serie-docto  
                                   AND tt-detalhe.nro-docto     = docum-est.nro-docto 
                                   AND tt-detalhe.nat-operacao  = docum-est.nat-operacao NO-ERROR.
   
                            IF NOT AVAIL tt-detalhe THEN DO:
                               CREATE tt-detalhe.
                               ASSIGN tt-detalhe.ep-codigo    = empresa.cod_empresa
                                      tt-detalhe.cod-estabel  = docum-est.cod-estabel
                                      tt-detalhe.dt-trans     = docum-est.dt-trans
                                      tt-detalhe.cc-codigo    = ccusto-debito
                                      tt-detalhe.cod-emit     = docum-est.cod-emitente
                                      tt-detalhe.serie-docto  = docum-est.serie-docto
                                      tt-detalhe.nro-docto    = docum-est.nro-docto
                                      tt-detalhe.nat-operacao = docum-est.nat-operacao.
                            END.
   
                            ASSIGN tt-detalhe.rec-devol = tt-detalhe.rec-devol + de-vl-devolucao.
                         END. /* if rt-tipo-relat */
   
                         FIND tt-resumo 
                              WHERE tt-resumo.ep-codigo   = empresa.cod_empresa
                                AND tt-resumo.cod-estabel = docum-est.cod-estabel  
                                AND tt-resumo.cc-codigo   = ccusto-debito NO-ERROR.
   
                         IF NOT AVAIL tt-resumo THEN DO:
                            CREATE tt-resumo.
                            ASSIGN tt-resumo.ep-codigo   = empresa.cod_empresa
                                   tt-resumo.cod-estabel = docum-est.cod-estabel
                                   tt-resumo.cc-codigo   = ccusto-debito.
                         END. 
                                   
                         ASSIGN tt-resumo.vl-total = tt-resumo.vl-total + de-vl-devolucao.

                         ASSIGN de-vl-cpv-var  = 0
                                de-vl-cpv-fixo = 0
                                de-vl-icms     = 0
                                de-vl-icms-st  = 0.

                         /* Custo Vari†vel e Fixo */
                         FOR EACH movto-estoq NO-LOCK
                            WHERE movto-estoq.cod-emitente = docum-est.cod-emitente
                              AND movto-estoq.cod-estabel  = docum-est.cod-estabel
                              AND movto-estoq.nro-docto    = docum-est.nro-docto
                              AND movto-estoq.serie-docto  = docum-est.serie-docto
                              AND movto-estoq.nat-operacao = docum-est.nat-operacao
                              AND movto-estoq.it-codigo    = item-doc-est.it-codigo
                              AND movto-estoq.sequen-nf    = item-doc-est.sequencia
                              AND movto-estoq.dt-trans     = docum-est.dt-trans
                              AND movto-estoq.tipo-trans   = 1:
                           ASSIGN de-vl-cpv-var  = de-vl-cpv-var  + movto-estoq.valor-mat-m[1]
                                  de-vl-cpv-fixo = de-vl-cpv-fixo + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1].
                         END. /* Custo Vari†vel e Fixo */

                         IF rt-tipo-relat = 2 THEN DO: /* Detalhado */
                            ASSIGN tt-detalhe.vl-cpv-var = tt-detalhe.vl-cpv-var + de-vl-cpv-var
                                   tt-detalhe.vl-cpv-cif = tt-detalhe.vl-cpv-cif + de-vl-cpv-fixo.
                         END. /* if rt-tipo-relat */

                         ASSIGN tt-resumo.vl-cpv-var = tt-resumo.vl-cpv-var + de-vl-cpv-var
                                tt-resumo.vl-cpv-cif = tt-resumo.vl-cpv-cif + de-vl-cpv-fixo.

                         /* Valores de ICMS est∆o a n°vel de nota, n∆o de item */
                         /* Se n∆o ler desta forma, multiplicar† os valores de ICMS pela quantidade de itens da nota */
                         IF FIRST-OF(item-doc-est.nat-operacao) THEN DO:
                            /* ICMS Normal */
                            FOR EACH movto-estoq NO-LOCK
                               WHERE movto-estoq.cod-emitente = docum-est.cod-emitente
                                 AND movto-estoq.cod-estabel  = docum-est.cod-estabel
                                 AND movto-estoq.nro-docto    = docum-est.nro-docto
                                 AND movto-estoq.serie-docto  = docum-est.serie-docto
                                 AND movto-estoq.nat-operacao = docum-est.nat-operacao
                                 AND movto-estoq.dt-trans     = docum-est.dt-trans
                                 AND movto-estoq.esp-docto    = 20
                                 AND movto-estoq.referencia   = "ICMS"
                                 AND movto-estoq.tipo-trans   = 1:
                              ASSIGN de-vl-icms = de-vl-icms + movto-estoq.valor-mat-m[1].
                            END. /* ICMS Normal */
    
                            /* ICMS ST */
                            FOR EACH movto-estoq NO-LOCK
                               WHERE movto-estoq.cod-emitente = docum-est.cod-emitente
                                 AND movto-estoq.cod-estabel  = docum-est.cod-estabel
                                 AND movto-estoq.nro-docto    = docum-est.nro-docto
                                 AND movto-estoq.serie-docto  = docum-est.serie-docto
                                 AND movto-estoq.nat-operacao = docum-est.nat-operacao
                                 AND movto-estoq.dt-trans     = docum-est.dt-trans
                                 AND movto-estoq.esp-docto    = 32
                                 AND movto-estoq.tipo-trans   = 1:
                              ASSIGN de-vl-icms-st = de-vl-icms-st + movto-estoq.valor-mat-m[1].
                            END. /* ICMS ST */

                            IF rt-tipo-relat = 2 THEN DO: /* Detalhado */
                               ASSIGN tt-detalhe.vl-icms    = tt-detalhe.vl-icms    + de-vl-icms
                                      tt-detalhe.vl-icms-st = tt-detalhe.vl-icms-st + de-vl-icms-st.
                            END. /* if rt-tipo-relat */
    
                            ASSIGN tt-resumo.vl-icms    = tt-resumo.vl-icms    + de-vl-icms
                                   tt-resumo.vl-icms-st = tt-resumo.vl-icms-st + de-vl-icms-st.
                         END.

                         IF tg-gera-contabil THEN
                            RUN pi-cria-movto (INPUT 'DOC',
                                               INPUT 100).

                      END. /* for each item-doc-est */
                   END. /* if avail dc-natur-oper */
                END. /* if avail natur-oper*/
             END. /* for each docum-est */
          END. /* if avail dc-orc-param */
      END. /* for each eEstabelecimento */
   END. /* if avail Empresa*/
END. /* if avail plano_cta_ctbl */
**** (fim) ****/


FOR EACH tt-detalhe:
    FIND tt-resumo 
         WHERE tt-resumo.ep-codigo   = tt-detalhe.ep-codigo  
           AND tt-resumo.cod-estabel = tt-detalhe.cod-estabel  
           AND tt-resumo.cc-codigo   = tt-detalhe.cc-codigo   NO-ERROR.
   
    IF NOT AVAIL tt-resumo THEN DO:
       CREATE tt-resumo.
       ASSIGN tt-resumo.ep-codigo   = tt-detalhe.ep-codigo  
              tt-resumo.cod-estabel = tt-detalhe.cod-estabel
              tt-resumo.cc-codigo   = tt-detalhe.cc-codigo.
    END. 
    ASSIGN tt-resumo.vl-total   = tt-resumo.vl-total   + tt-detalhe.rec-devol
           tt-resumo.vl-cpv-var = tt-resumo.vl-cpv-var + tt-detalhe.vl-cpv-var
           tt-resumo.vl-cpv-cif = tt-resumo.vl-cpv-cif + tt-detalhe.vl-cpv-cif
           tt-resumo.vl-icms    = tt-resumo.vl-icms    + tt-detalhe.vl-icms   
           tt-resumo.vl-icms-st = tt-resumo.vl-icms-st + tt-detalhe.vl-icms-st.
END. /* for each tt-detalhe ... */




{doinc/doc010rp2.i}

IF tg-gera-contabil THEN DO:
    FOR EACH tt-contabiliza NO-LOCK
       BREAK BY tt-contabiliza.cod-empresa
             BY tt-contabiliza.cod-estab  
             BY tt-contabiliza.unid-neg:
    
       ASSIGN i-sequencia = i-sequencia + 10.
    
       IF FIRST-OF(tt-contabiliza.cod-estab) THEN DO:
           RUN pi-gera-contabilizacao(INPUT 'lote', 
                                      INPUT '',
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT 0).        
            
           RUN pi-gera-contabilizacao(INPUT 'lancto', 
                                      INPUT '',
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT 0).
       END.
    
       RUN pi-gera-contabilizacao(INPUT 'itens', 
                                  INPUT tt-contabiliza.movto,
                                  INPUT tt-contabiliza.cod_cta_ctbl,
                                  INPUT tt-contabiliza.cod_ccusto,
                                  INPUT tt-contabiliza.valor).
    END.
    
    RUN pi-gera-contabilizacao(INPUT 'executa', 
                               INPUT '',
                               INPUT 0,
                               INPUT 0,
                               INPUT 0). 
END.


PROCEDURE pi-cria-movto:
    DEF INPUT PARAMETER p-cod-unid-neg  AS CHAR.
    DEF INPUT PARAMETER p-perc-unid-neg AS INT.

    DEF VAR c-ct-dev-recompr-db       AS CHAR NO-UNDO.
    DEF VAR c-ct-dev-recompr-cr       AS CHAR NO-UNDO.
    DEF VAR c-sc-dev-recompr-cr       AS CHAR NO-UNDO.
    DEF VAR c-ct-dev-recompr-cpv-var  AS CHAR NO-UNDO.
    DEF VAR c-ct-dev-recompr-cpv-fixo AS CHAR NO-UNDO.

    IF log-dev-recompr THEN DO:
       ASSIGN c-ct-dev-recompr-db       = dc-orc-param.ct-devol-db
              c-ct-dev-recompr-cr       = dc-orc-param.ct-devol-cr
              c-sc-dev-recompr-cr       = dc-orc-param.sc-devol-cr
              c-ct-dev-recompr-cpv-var  = c-ct-cpv-var
              c-ct-dev-recompr-cpv-fixo = c-ct-cpv-fixo.
    END.
    ELSE DO:
       ASSIGN c-ct-dev-recompr-db       = dc-orc-param.ct-recompra-db
              c-ct-dev-recompr-cr       = dc-orc-param.ct-recompra-cr
              c-sc-dev-recompr-cr       = dc-orc-param.sc-recompra-cr
              c-ct-dev-recompr-cpv-var  = c-ct-recomp-cpv-var
              c-ct-dev-recompr-cpv-fixo = c-ct-recomp-cpv-fixo.
    END.

    /* Contabilizaá∆o da Devoluá∆o Oráamento */
    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = emsuni.empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-dev-recompr-db
           AND tt-contabiliza.cod_ccusto      = ccusto-debito
           AND tt-contabiliza.movto           = 'DB' NO-ERROR.
    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-dev-recompr-db
              tt-contabiliza.cod_ccusto       = ccusto-debito
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'DB'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-devolucao + de-vl-icms /* + de-vl-icms-st - Chamado 5.584 */.

    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-dev-recompr-cr
           AND tt-contabiliza.cod_ccusto      = c-sc-dev-recompr-cr
           AND tt-contabiliza.movto           = 'CR' NO-ERROR.

    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-dev-recompr-cr 
              tt-contabiliza.cod_ccusto       = c-sc-dev-recompr-cr 
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'CR'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-devolucao + de-vl-icms /* + de-vl-icms-st - Chamado 5.584 */.
    /* Fim Contabilizaá∆o da Devoluá∆o */
    
    /* Expurgo do Estorno de CPV Fixo do CPV Vari†vel */
    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-dev-recompr-cpv-fixo
           AND tt-contabiliza.cod_ccusto      = ''
           AND tt-contabiliza.movto           = 'CR' NO-ERROR.
    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-dev-recompr-cpv-fixo
              tt-contabiliza.cod_ccusto       = ''
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'CR'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-cpv-fixo.

    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-dev-recompr-cpv-var
           AND tt-contabiliza.cod_ccusto      = ''
           AND tt-contabiliza.movto           = 'DB' NO-ERROR.

    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-dev-recompr-cpv-var
              tt-contabiliza.cod_ccusto       = ''
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'DB'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-cpv-fixo.
    /* Fim Expurgo Estorno CPV Fixo do Vari†vel */

    /* Contabilizaá∆o do CPV Vari†vel da Devoluá∆o Oráamento */
    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-cpv-orcam-db
           AND tt-contabiliza.cod_ccusto      = ''
           AND tt-contabiliza.movto           = 'DB' NO-ERROR.
    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-cpv-orcam-db
              tt-contabiliza.cod_ccusto       = ''
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'DB'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-cpv-var.

    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = c-ct-cpv-orcam-cr
           AND tt-contabiliza.cod_ccusto      = ccusto-debito
           AND tt-contabiliza.movto           = 'CR' NO-ERROR.

    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = c-ct-cpv-orcam-cr
              tt-contabiliza.cod_ccusto       = ccusto-debito
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'CR'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-cpv-var.
    /* Fim Contabilizaá∆o do CPV Vari†vel da Devoluá∆o */

    /* Contabiliza ICMS Normal - NDS 7.211 */
    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = emsuni.empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = dc-orc-param.ct-icms-cr 
           AND tt-contabiliza.cod_ccusto      = dc-orc-param.sc-icms-cr 
           AND tt-contabiliza.movto           = 'DB' NO-ERROR.
    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = dc-orc-param.ct-icms-cr  
              tt-contabiliza.cod_ccusto       = dc-orc-param.sc-icms-cr  
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'DB'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-icms.

    FIND FIRST tt-contabiliza EXCLUSIVE-LOCK
         WHERE tt-contabiliza.cod-empresa     = empresa.cod_empresa
           AND tt-contabiliza.cod-estab       = estabelecimento.cod_estab
           AND tt-contabiliza.unid-neg        = p-cod-unid-neg
           AND tt-contabiliza.cod_cta_ctbl    = dc-orc-param.ct-icms-db 
           AND tt-contabiliza.cod_ccusto      = ccusto-debito           
           AND tt-contabiliza.movto           = 'CR' NO-ERROR.

    IF NOT AVAIL tt-contabiliza THEN DO:
       CREATE tt-contabiliza.
       ASSIGN tt-contabiliza.cod-empresa     = empresa.cod_empresa
              tt-contabiliza.cod-estab        = estabelecimento.cod_estab  
              tt-contabiliza.unid-neg         = p-cod-unid-neg             
              tt-contabiliza.cod_cta_ctbl     = dc-orc-param.ct-icms-db  
              tt-contabiliza.cod_ccusto       = ccusto-debito            
              tt-contabiliza.cod_indic_econ   = histor_finalid_econ.cod_indic_econ   
              tt-contabiliza.cod_finalid_econ = 'Corrente'
              tt-contabiliza.movto            = 'CR'.
    END.
    ASSIGN tt-contabiliza.valor = tt-contabiliza.valor + de-vl-icms.
    /* FIM-Contabiliza ICMS Normal - NDS 7.211 */
    


END PROCEDURE.

PROCEDURE pi-gera-contabilizacao:
    DEF INPUT PARAMETER p-table  AS CHAR.
    DEF INPUT PARAMETER p-movto  AS CHAR.
    DEF INPUT PARAMETER p-conta  LIKE tt-contabiliza.cod_cta_ctbl.
    DEF INPUT PARAMETER p-ccusto LIKE tt-contabiliza.cod_ccusto.
    DEF INPUT PARAMETER p-valor  LIKE tt-contabiliza.valor.
    
    CASE p-table:
        WHEN 'lote' THEN DO:
            CREATE  tt_integr_lote_ctbl.
            ASSIGN  tt_integr_lote_ctbl.tta_cod_modul_dtsul    = 'FGL' 
                tt_integr_lote_ctbl.tta_num_lote_ctbl          = 1
                tt_integr_lote_ctbl.tta_des_lote_ctbl          = 'Devoluá‰es por Centro de Custo ' + STRING(month(dt-periodo-fin),'99') + '/' + string(YEAR(dt-periodo-fin))
                tt_integr_lote_ctbl.tta_cod_empresa            = emsuni.empresa.cod_empresa
                tt_integr_lote_ctbl.tta_dat_lote_ctbl          = dt-periodo-fin
                tt_integr_lote_ctbl.ttv_ind_erro_valid         = "N∆o"
                tt_integr_lote_ctbl.tta_log_integr_ctbl_online = YES. 
        END. /*Lote*/

        WHEN 'lancto' THEN DO:
            CREATE  tt_integr_lancto_ctbl.
            ASSIGN  tt_integr_lancto_ctbl.tta_cod_cenar_ctbl            = 'Fiscal'
                    tt_integr_lancto_ctbl.tta_log_lancto_conver         = NO
                    tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo  = NO 
                    tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl      = RECID(tt_integr_lote_ctbl)
                    tt_integr_lancto_ctbl.tta_num_lancto_ctbl           = i-sequencia
                    tt_integr_lancto_ctbl.ttv_ind_erro_valid            = "N∆o" 
                    tt_integr_lancto_ctbl.tta_dat_lancto_ctbl           = dt-periodo-fin.
        END. /*lancto*/
    
        WHEN 'itens' THEN DO:        
            CREATE  tt_integr_item_lancto_ctbl.
            ASSIGN  tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = RECID(tt_integr_lancto_ctbl)
                    tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-sequencia
                    tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = p-movto  
                    tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = 'PCDOCOL'
                    tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = p-conta  
                    tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = IF p-ccusto <> '' THEN plano_ccusto.cod_plano_ccusto ELSE ''
                    tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = p-ccusto
                    tt_integr_item_lancto_ctbl.tta_cod_estab                    = v_cod_estab_usuar
                    tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = tt-contabiliza.unid-neg
                    tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = 'Devoluá∆o por Centro de Custo ' + STRING(MONTH(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin))
                    tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = tt-contabiliza.cod_indic_econ
                    tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-periodo-fin
                    tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = p-valor
                    tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = i-sequencia
                    tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "N∆o" .

            CREATE  tt_integr_aprop_lancto_ctbl.
            ASSIGN  tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = tt-contabiliza.cod_finalid_econ
                    tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                    tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                    tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                    tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
                    tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                    tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                    tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = dt-periodo-fin
                    tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                    tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "N∆o" 
                    tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
        END. /*Item*/
    
        WHEN  'executa' THEN DO:
            RUN pi-acompanhar IN h-acomp ('Contabilizando Lanáamentos...').
            RUN prgfin/fgl/fgl900zh.py (3            , 
                                        "Aborta Tudo",
                                        NO           ,   
                                        NO           , 
                                        "Apropriaá∆o", 
                                        "Com Erro"   , 
                                        YES          , 
                                        YES          ).

            RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros dos Lanáamentos...').

            FOR EACH tt_integr_ctbl_valid NO-LOCK:
                RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                 INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                CREATE  tt-erro.
                ASSIGN  tt-erro.des_erro    = 'CR:' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
                                               RETURN-VALUE + CHR(10) + tt_integr_ctbl_valid.ttv_ind_pos_erro.

/*                 CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:  */
/*                     WHEN 'ITEM' THEN DO:                     */
                        FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                             WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
                        IF  AVAIL tt_integr_item_lancto_ctbl THEN DO:
                            ASSIGN  tt-erro.des_erro = tt-erro.des_erro + 
                                  ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl) + 
                                    ' Nat:' + tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl    +
                                    ' PCT:' + tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl       +
                                    ' CTA:' + tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl             +
                                    ' PCC:' + tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto         +
                                    ' CCU:' + tt_integr_item_lancto_ctbl.tta_cod_ccusto               + 
                                    ' EST:' + tt_integr_item_lancto_ctbl.tta_cod_estab                + 
                                    ' UNG:' + tt_integr_item_lancto_ctbl.tta_cod_unid_negoc           +
                                    ' HIS:' + tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl   +
                                    ' IEC:' + tt_integr_item_lancto_ctbl.tta_cod_indic_econ           +
                                    ' DAT:' + STRING(tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl)  +
                                    ' VAL:' + STRING(tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl)  + 
                                    ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart) .
/*                         END.                                                                                      */
/*                                                                                                                   */
                    END.
/*                 END CASE.  */
            END.
        END.
    END CASE.
END PROCEDURE.

PROCEDURE pi_messages:
    DEF INPUT PARAM c_action    AS CHAR    NO-UNDO.
    DEF INPUT PARAM i_msg       AS INTEGER NO-UNDO.
    DEF INPUT PARAM c_param     AS CHAR    NO-UNDO.

    def var c_prg_msg           AS CHAR    NO-UNDO.

    ASSIGN  c_prg_msg = "messages/":U
                      + STRING(TRUNC(i_msg / 1000,0),"99":U)
                      + "/msg":U
                      + STRING(i_msg, "99999":U).

    IF  SEARCH(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "nío encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.
END PROCEDURE.  /* pi_messages */

/* Listagem de erros */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    RUN pi-acompanhar IN h-acomp ('Imprimindo listagem de erros ...').
    PAGE.
    PUT SKIP(2)
        "Listagem de ERROS e INCONSIST“NCIAS" AT 20
        "-----------------------------------" AT 20
        SKIP(2).

    FOR EACH tt-erro NO-LOCK
       BREAK BY tt-erro.cdn_repres:
        IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:
            FIND FIRST representante NO-LOCK
                 WHERE representante.cod_empresa = 'DOC'
                 AND   representante.cdn_repres = tt-erro.cdn_repres NO-ERROR.
            IF  AVAIL representante THEN
                DISPLAY representante.cdn_repres
                        representante.nom_pessoa
                        WITH FRAME f-erro.
        END. /*IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:*/

        FOR EACH tt-editor:     DELETE  tt-editor.      END.
        RUN pi-print-editor (tt-erro.des_erro,  92).
        
        FOR EACH tt-editor:
            DISPLAY tt-editor.conteudo @ tt-erro.des_erro WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
        END. /*FOR EACH tt-editor*/
        DOWN WITH FRAME f-erro.
    END.
END.
/* FIM - Listagem de erros */
