ASSIGN ccusto-debito  = dc-orc-param-cpv.ccusto-debito 
       ccusto-credito = dc-orc-param-cpv.ccusto-credito.

FIND FIRST ITEM NO-LOCK      
     WHERE item.it-codigo = c-it-codigo NO-ERROR.

FIND FIRST nota-fiscal NO-LOCK 
     WHERE nota-fiscal.cod-estabel = c-cod-estab 
       AND nota-fiscal.serie       = c-serie 
       AND nota-fiscal.nr-nota-fis = c-nota-fis   NO-ERROR.
IF NOT AVAIL nota-fiscal THEN DO:
   FIND FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = c-serie
          AND item-doc-est.nro-docto    = c-nota-fis
          AND item-doc-est.cod-emitente = i-emit
          AND item-doc-est.nat-operacao = c-nat-oper
          AND item-doc-est.sequencia    = i-seq-nf NO-ERROR.
   IF AVAIL item-doc-est THEN DO:
      FIND FIRST it-nota-fisc NO-LOCK /* Verifica se ‚ nota de devolu‡Æo */
           WHERE it-nota-fisc.cod-estabel  = c-cod-estab
             AND it-nota-fisc.serie        = item-doc-est.serie-comp
             AND it-nota-fisc.nr-nota-fis  = item-doc-est.nro-comp
             AND it-nota-fisc.nr-seq-fat   = item-doc-est.seq-comp NO-ERROR.
      IF AVAIL it-nota-fisc THEN DO:
         FIND FIRST nota-fiscal OF it-nota-fisc NO-ERROR.
         IF AVAIL nota-fiscal THEN
            ASSIGN i-cod-rep = nota-fiscal.cod-rep.
      END.
   END.
END.

IF AVAIL nota-fiscal THEN DO:
    FIND FIRST dc-orc-param-rec NO-LOCK
         WHERE dc-orc-param-rec.cod-empresa  = dc-orc-param.cod-empresa
           AND dc-orc-param-rec.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
    IF AVAIL dc-orc-param-rec                 AND
       dc-orc-param-rec.cod_ccusto_cr <> ?    AND
       dc-orc-param-rec.cod_ccusto_cr <> '0'  AND
       dc-orc-param-rec.cod_ccusto_cr <> ''  THEN
       ASSIGN ccusto-debito = dc-orc-param-rec.cod_ccusto_cr.
    ASSIGN i-cod-rep = nota-fiscal.cod-rep. 
END.

IF i-cod-rep = 0 THEN DO:
   FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = i-emit 
          AND emitente.identific   <> 2 NO-ERROR.
   IF AVAIL emitente THEN
      ASSIGN i-cod-rep = emitente.cod-rep.
   ELSE
      ASSIGN i-cod-rep = cod-repres.
END.

IF ccusto-debito = ?  OR 
   ccusto-debito = '' THEN DO:

   RUN dop/dft000.p (INPUT c-cod-estab,
                     INPUT c-serie,
                     INPUT c-nota-fis,
                     OUTPUT c-mercado,
                     OUTPUT c-tipo-mercado,
                     OUTPUT ccusto-debito,
                     OUTPUT c-nome-ab-reg).

/*    FIND FIRST ped-venda NO-LOCK                                      */
/*         WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli         */
/*           AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR. */
/*    IF AVAIL ped-venda THEN DO:                                       */
/*       FIND FIRST grupo-ped NO-LOCK                                   */
/*            WHERE grupo-ped.tp-pedido = ped-venda.tp-pedido           */
/*              AND grupo-ped.cod-grupo = cod-grupo-sat NO-ERROR.       */
/*       IF AVAIL grupo-ped THEN                                        */
/*          ASSIGN ccusto-debito = c-cc-gr-ped.                         */
/*    END.                                                              */
/*    IF ccusto-debito = ? OR                                           */
/*       ccusto-debito = '' THEN DO:                                    */
/*       FIND FIRST dc-repres NO-LOCK                                   */
/*            WHERE dc-repres.cod_empresa = c-cod-empresa               */
/*              AND dc-repres.cdn_repres  = i-cod-rep NO-ERROR.         */
/*       IF AVAIL dc-repres THEN                                        */
/*           ASSIGN ccusto-debito = dc-repres.cod_ccusto.               */
/*       ELSE                                                           */
/*           ASSIGN ccusto-debito = '0'.                                */
/*    END.                                                              */
   IF ccusto-debito = ? or
      ccusto-debito = '' THEN DO:
      FIND FIRST dc-repres NO-LOCK 
           WHERE dc-repres.cod_empresa = c-cod-empresa  
             AND dc-repres.cdn_repres  = i-cod-rep NO-ERROR.
      IF AVAIL dc-repres THEN
          ASSIGN ccusto-debito = dc-repres.cod_ccusto.
      ELSE
          ASSIGN ccusto-debito = '0'.
   END.
END.

ASSIGN i-cc-codigo   = ccusto-debito
       tot-perc-nota = 0
       l-ok-unid     = NO.


FOR EACH unid-neg-fat OF nota-fiscal NO-LOCK:
   ASSIGN l-ok-unid     = YES
          tot-perc-nota = tot-perc-nota + unid-neg-fat.perc-unid-neg.

   RUN pi-cria-movto(INPUT unid-neg-fat.cod_unid_negoc, 
                     INPUT unid-neg-fat.perc-unid-neg).
END.
IF l-ok-unid = NO THEN DO:
  FOR EACH unid-neg-item OF ITEM NO-LOCK:
      ASSIGN l-ok-unid = YES.
      RUN pi-cria-movto (INPUT unid-neg-item.cod_unid_negoc,
                         INPUT unid-neg-item.perc-unid-neg).
  END.
  IF l-ok-unid = NO THEN DO:
        /* Busca Unidade de Neg¢cio do Estabelecimento */
        FIND FIRST estab_unid_negoc 
             WHERE estab_unid_negoc.cod_estab = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

        IF AVAIL estab_unid_negoc  THEN DO:
            ASSIGN l-ok-unid = YES.
            RUN pi-cria-movto(INPUT estab_unid_negoc.cod_unid_negoc,  
                              INPUT 100).
        END.
        ELSE DO:
            FIND LAST para-dis NO-LOCK NO-ERROR.
            IF AVAIL para-dis THEN DO:
                ASSIGN l-ok-unid = YES.
                RUN pi-cria-movto(INPUT para-dis.char-1,  
                                  INPUT 100).
            END.
        END.
  END.
END.
ELSE DO:
  IF tot-perc-nota < 100  THEN
     ASSIGN c-mensagem  =  'Percentual das Unidades neg¢cio incompleto!'
            c-msg-ajuda =  'A soma dos percentuais das Unidades de neg¢cio' + CHR(13) + 
                           'dos Itens da Nota est  incompleto!            ' + CHR(13) +
                           'Estabel ' + c-cod-estab                         + CHR(13) +
                           'Docto   ' + c-nota-fis                          + CHR(13) +
                           'S‚rie'    + c-serie                             + CHR(13) +
                           'Dt Trans' + string(dt-trans)                    + CHR(13) +
                           'Emitente' + STRING(i-emit)                      + CHR(13) +
                           'Valor   ' + string(de-valor-nota)               + CHR(13) +
                           'Verifique no Ems204 - Man Inf Unidade de Neg¢cio da Nota FT0907.w'.
END.


FIND FIRST tt-resumo 
     WHERE tt-resumo.ep-codigo     = c-cod-empresa                 
       AND tt-resumo.cod-estabel   = c-cod-estab   
       AND tt-resumo.ct-codigo     = c-mov-ct-codigo     
       AND tt-resumo.cc-codigo     = i-cc-codigo
       AND tt-resumo.data          = dt-refer     NO-ERROR.
IF NOT AVAIL tt-resumo THEN DO:
   CREATE tt-resumo.
   ASSIGN tt-resumo.ep-codigo      = c-cod-empresa
          tt-resumo.cod-estabel    = c-cod-estab
          tt-resumo.ct-codigo      = c-mov-ct-codigo 
          tt-resumo.cc-codigo      = i-cc-codigo
          tt-resumo.data           = dt-refer.
END.

IF i-tipo-trans = 2 THEN      
    ASSIGN tt-resumo.vl-mat      = tt-resumo.vl-mat      + (de-movto-mat + de-movto-mob)
           tt-resumo.vl-mob      = tt-resumo.vl-mob      + (de-movto-ggf)
           tt-resumo.vl-impostos = tt-resumo.vl-impostos +  de-movto-impostos.
ELSE 
    ASSIGN tt-resumo.vl-mat      = tt-resumo.vl-mat      - (de-movto-mat + de-movto-mob)
           tt-resumo.vl-mob      = tt-resumo.vl-mob      - (de-movto-ggf)
           tt-resumo.vl-impostos = tt-resumo.vl-impostos -  de-movto-impostos.

FIND FIRST tt-detalhe NO-LOCK
    WHERE tt-detalhe.ep-codigo    = c-cod-empresa               
      AND tt-detalhe.cod-estabel  = c-cod-estab 
      AND tt-detalhe.ct-codigo    = c-mov-ct-codigo   
      AND tt-detalhe.cc-codigo    = i-cc-codigo             
      AND tt-detalhe.serie        = c-serie 
      AND tt-detalhe.nr-nota-fis  = c-nota-fis   
      AND tt-detalhe.it-codigo    = c-it-codigo 
      AND tt-detalhe.cod-emitente = i-emit NO-ERROR.
IF NOT AVAIL tt-detalhe THEN DO:
    CREATE tt-detalhe.
    ASSIGN tt-detalhe.ep-codigo    = c-cod-empresa
           tt-detalhe.cod-estabel  = c-cod-estab
           tt-detalhe.ct-codigo    = c-mov-ct-codigo
           tt-detalhe.cc-codigo    = i-cc-codigo
           tt-detalhe.serie        = c-serie
           tt-detalhe.nr-nota-fis  = c-nota-fis
           tt-detalhe.it-codigo    = c-it-codigo
           tt-detalhe.desc-item    = ITEM.desc-item
           tt-detalhe.cod-emitente = i-emit
           tt-detalhe.data         = dt-for.
END.
IF i-tipo-trans = 2 THEN             
    ASSIGN tt-detalhe.vl-mat      = tt-detalhe.vl-mat      + (de-movto-mat + de-movto-mob)
           tt-detalhe.vl-mob      = tt-detalhe.vl-mob      + (de-movto-ggf)
           tt-detalhe.vl-impostos = tt-detalhe.vl-impostos +  de-movto-impostos.        
ELSE 
    ASSIGN tt-detalhe.vl-mat      = tt-detalhe.vl-mat      - (de-movto-mat + de-movto-mob)
           tt-detalhe.vl-mob      = tt-detalhe.vl-mob      - (de-movto-ggf)
           tt-detalhe.vl-impostos = tt-detalhe.vl-impostos -  de-movto-impostos.        
  

