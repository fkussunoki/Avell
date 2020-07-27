DEF TEMP-TABLE tt-faturamento
    FIELD ttv-cod-estabel       AS char
    FIELD ttv-serie             AS char
    FIELD ttv-nr-nota-fis       AS char
    FIELD ttv-nome-ab-cli       AS CHar
    FIELD ttv-it-codigo         AS char
    FIELD ttv-ge-codigo         AS CHAR
    FIELD ttv-fm-codigo         AS CHAR
    FIELD ttv-concatena         AS char
    FIELD ttv-quantidade        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-mercadoria    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-PIS           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-COFINS        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-ipi           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-icms          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-estab-pedido      AS char
    FIELD ttv-nat-oper          AS char
    FIELD ttv-base-calc         AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    
    INDEX TTA-CONCATENA
    ttv-concatena ASCENDING.


DEF VAR c-cfop AS CHAR.

DEF VAR h-prog AS HANDLE.


ASSIGN c-cfop = "5101,5102,5910,5911,6101,6102,6107,6122,6910,5122".

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").

FOR EACH natur-oper NO-LOCK WHERE LOOKUP(natur-oper.cod-cfop, c-cfop) <> 0:

FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.dt-emis-doc >= 11/01/2018
                             AND   it-doc-fisc.dt-emis-doc <= 11/30/2018
                             AND   it-doc-fisc.nat-operacao = natur-oper.nat-operacao:


    FIND FIRST it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = it-doc-fisc.cod-estabel
                                    AND   it-nota-fisc.serie       = it-doc-fisc.serie
                                    AND   it-nota-fisc.nr-nota-fis = it-doc-fisc.nr-doc-fis
                                    AND   it-nota-fisc.it-codigo   = it-doc-fisc.it-codigo NO-ERROR.

/* FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota >= 11/01/2018 */
/*                               AND   it-nota-fisc.dt-emis-nota <= 11/30/2018 */
/*                                                                             */
/*                                                                             */
/*                              :                                              */

    FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                   AND   nota-fiscal.serie       = it-nota-fisc.serie
                                   AND   nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                   AND   nota-fiscal.nome-ab-cli = it-nota-fisc.nome-ab-cli
/*                                 AND   nota-fiscal.nat-operacao = it-nota-fisc.nat-operacao */
                                   AND   nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR. /* uso autorizado */

    IF AVAIL nota-fiscal THEN DO:
        
    

RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(it-nota-fisc.dt-emis-nota)).
/*     FIND FIRST fat-duplic NO-LOCK WHERE fat-duplic.serie            = it-nota-fisc.serie                  */
/*                                   AND   fat-duplic.nome-ab-cli      = it-nota-fisc.nome-ab-cli            */
/*                                   AND   fat-duplic.nr-fatura        = it-nota-fisc.nr-nota-fis            */
/* /*                                   AND   fat-duplic.nat-operacao     = it-nota-fisc.nat-operacao  */    */
/*                                   AND   fat-duplic.cod-estabel      = it-nota-fisc.cod-estabel NO-ERROR.  */
/*                                                                                                           */
/*     IF AVAIL fat-duplic THEN DO:                                                                          */
/*                                                                                                           */
/*                                                                                                           */

    FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nome-abrev  = it-nota-fisc.nome-ab-cli
                                 AND   ped-venda.nr-pedido   = it-nota-fisc.nr-pedido
                                 NO-ERROR.
                            



        FIND FIRST ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.


        CREATE tt-faturamento.
        ASSIGN tt-faturamento.ttv-cod-estabel               = it-doc-fisc.cod-estabel
               tt-faturamento.ttv-serie                     = it-doc-fisc.serie
               tt-faturamento.ttv-nr-nota-fis               = it-doc-fisc.nr-doc-fis
               tt-faturamento.ttv-nome-ab-cli               = string(it-doc-fisc.cod-emitente)
               tt-faturamento.ttv-it-codigo                 = it-doc-fisc.it-codigo + " " + string(item.incentivado)
               tt-faturamento.ttv-ge-codigo                 = string(ITEM.ge-codigo)
               tt-faturamento.ttv-fm-codigo                 = string(ITEM.fm-cod-com)
               tt-faturamento.ttv-quantidade                = it-doc-fisc.quantidade
               tt-faturamento.ttv-vlr-mercadoria            = it-doc-fisc.vl-tot-item
               tt-faturamento.ttv-vlr-ipi                   = it-doc-fisc.vl-ipi-it
               tt-faturamento.ttv-vlr-icms                  = it-doc-fisc.vl-icms-it
               tt-faturamento.ttv-vlr-cofins                = IF it-nota-fisc.cod-sit-tributar-cofins = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,81,5)) / 100) ELSE 0
               tt-faturamento.ttv-vlr-pis                   = if it-nota-fisc.cod-sit-tributar-pis    = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,76,5)) / 100) ELSE 0
               tt-faturamento.ttv-estab-pedido              = IF AVAIL ped-venda THEN ped-venda.cod-estabel ELSE it-nota-fisc.cod-estabel
               tt-faturamento.ttv-concatena                 = it-nota-fisc.cod-estabel + it-nota-fisc.nat-operacao
               tt-faturamento.ttv-nat-oper                  = natur-oper.cod-cfop
               tt-faturamento.ttv-base-calc                 = it-doc-fisc.vl-bicms-it.


    END.

  END.

END.

RUN pi-finalizar IN h-prog.

OUTPUT TO c:\temp\testea.txt.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Temp-table").


FOR EACH tt-faturamento:

    PUT UNFORMATTED tt-faturamento.ttv-cod-estabel         ";"
                    tt-faturamento.ttv-serie               ";"
                    tt-faturamento.ttv-nr-nota-fis         ";"
                    tt-faturamento.ttv-nome-ab-cli         ";"
                    tt-faturamento.ttv-it-codigo           ";"
                    tt-faturamento.ttv-ge-codigo           ";"
                    tt-faturamento.ttv-fm-codigo           ";"
                    tt-faturamento.ttv-concatena           ";"
                    tt-faturamento.ttv-quantidade          ";"
                    tt-faturamento.ttv-vlr-mercadoria      ";"
                    tt-faturamento.ttv-vlr-PIS             ";"
                    tt-faturamento.ttv-vlr-COFINS          ";"
                    tt-faturamento.ttv-vlr-ipi             ";"
                    tt-faturamento.ttv-vlr-icms             ";"
                    tt-faturamento.ttv-estab-pedido         ";"
                    tt-faturamento.ttv-nat-oper             ";"
                    tt-faturamento.ttv-base-calc      
        SKIP.


END.


/* FOR EACH tt-faturamento BREAK BY tt-faturamento.ttv-concatena:                                                                                                                          */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/* /*     EXPORT DELIMITER "|" TT-FATURAMENTO.  */                                                                                                                                         */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/*     RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(tt-faturamento.ttv-concatena)).                                                                                                */
/*     ACCUMULATE tt-faturamento.ttV-vlr-mercadoria (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*     ACCUMULATE tt-faturamento.ttV-vlr-ipi        (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*     ACCUMULATE tt-faturamento.ttV-vlr-icms       (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*     ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*     ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*     ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttV-concatena).                                                                                           */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/*     IF LAST-OF(tt-faturamento.ttv-concatena) THEN DO:                                                                                                                                   */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED tt-faturamento.ttv-cod-estabel ";"                                                                                                                              */
/*                         tt-faturamento.ttv-estab-pedido ";".                                                                                                                            */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED tt-faturamento.ttv-nat-oper ";".                                                                                                                                */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-quantidade ";".                                                                              */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-mercadoria ";".                                                                          */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-IPI ";".                                                                                 */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-ICMS ";".                                                                                */
/*                                                                                                                                                                                         */
/*         PUT UNFORMATTED (ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-pis) + (ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-cofins)  */
/*                                                                                                                                                                                         */
/*               SKIP.                                                                                                                                                                     */
/*                                                                                                                                                                                         */
/*                                                                                                                                                                                         */
/*     END.                                                                                                                                                                                */
/*                                                                                                                                                                                         */
/* END.                                                                                                                                                                                    */

RUN pi-finalizar IN h-prog.



