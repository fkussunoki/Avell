
    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)"
        field modelo-rtf       as char format "x(35)"
        field l-habilitaRtf    as LOG
        FIELD ttv-estab-ini    AS CHAR
        FIELD ttv-estab-fim    AS CHAR
        FIELD ttv-dt-ini       AS DATE
        FIELD ttv-dt-fim       AS DATE
        FIELD ttv-rs           AS INTEGER.



DEFINE INPUT PARAM TABLE FOR tt-param.



DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.

DEF VAR m-linha AS INTEGER.
def var h-prog as handle.

{office/office.i Excel chExcel}
    
    chExcel:sheetsinNewWorkbook = 2.
    chWorkbook = chExcel:Workbooks:ADD().


    DEF TEMP-TABLE tt-compras
        FIELD ttv-cod-estabel       AS char
        FIELD ttv-serie             AS char
        FIELD ttv-nr-nota-fis       AS char
        FIELD ttv-nome-fornec       AS CHar
        FIELD ttv-it-codigo         AS char
        FIELD ttv-ge-codigo         AS CHAR
        FIELD ttv-fm-codigo         AS CHAR
        FIELD ttv-concatena         AS char
        FIELD ttv-concatena1        AS CHAR
        FIELD ttv-quantidade        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-vlr-mercadoria    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-vlr-PIS           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-vlr-COFINS        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-vlr-ipi           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-vlr-icms          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-base-icms         AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-base-cofins       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-estab-pedido      AS char

        INDEX TTA-CONCATENA
        ttv-concatena ASCENDING.
    RUN utp/ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Temp-table").

    run pi-compras.
    RUN pi-memoria.
    RUN pi-finalizar in h-prog.
    chExcel:visible = yes.
    

procedure pi-memoria:

    chworksheet=chWorkBook:sheets:item(2).
    chworksheet:name="Memoria de Calculo". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:m1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:m1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:m1"):SetValue("COMPRAS MATRIZ E FILIAL").
    chWorkSheet:Range("A1:m1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:m1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
    chworksheet:range("A2:m2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
    chworksheet:range("A" + STRING(m-linha)):SetValue("Estab").
    chworksheet:range("B" + STRING(m-linha)):SetValue("Serie").
    chworksheet:range("C" + STRING(m-linha)):SetValue("Nr.NF").
    chworksheet:range("d" + STRING(m-linha)):SetValue("Fornecedor").
    chworksheet:range("e" + STRING(m-linha)):SetValue("Item").
    chworksheet:range("f" + STRING(m-linha)):SetValue("Gr. Estoque").
    chworksheet:range("g" + STRING(m-linha)):SetValue("Familia").
    chworksheet:range("h" + STRING(m-linha)):SetValue("Qtde").
    chworksheet:range("i" + STRING(m-linha)):SetValue("Vlr. Mercadoria").
    chworksheet:range("j" + STRING(m-linha)):SetValue("PIS").
    chworksheet:range("k" + STRING(m-linha)):SetValue("COFINS").
    chworksheet:range("l" + STRING(m-linha)):SetValue("IPI").
    chworksheet:range("m" + STRING(m-linha)):SetValue("ICMS").

    assign m-linha = m-linha + 1.

    for each tt-compras:
    RUN pi-acompanhar IN h-prog(INPUT "Data " + string(tt-compras.ttv-cod-estabel)).
        chworksheet:range("A" + STRING(m-linha)):SetValue(ttv-cod-estabel)   .
        chworksheet:range("B" + STRING(m-linha)):SetValue(ttv-serie)         .
        chworksheet:range("C" + STRING(m-linha)):SetValue(ttv-nr-nota-fis)   .
        chworksheet:range("d" + STRING(m-linha)):SetValue(ttv-nome-fornec)   .
        chworksheet:range("e" + STRING(m-linha)):SetValue(ttv-it-codigo)     .
        chworksheet:range("f" + STRING(m-linha)):SetValue(ttv-ge-codigo)    .
        chworksheet:range("g" + STRING(m-linha)):SetValue(ttv-fm-codigo)     .
        chworksheet:range("h" + STRING(m-linha)):SetValue(ttv-quantidade)      .
        chworksheet:range("i" + STRING(m-linha)):SetValue(ttv-vlr-mercadoria)  .
        chworksheet:range("j" + STRING(m-linha)):SetValue(ttv-vlr-PIS)         .
        chworksheet:range("k" + STRING(m-linha)):SetValue(ttv-vlr-COFINS)      .
        chworksheet:range("l" + STRING(m-linha)):SetValue(ttv-vlr-ipi)         .
        chworksheet:range("m" + STRING(m-linha)):SetValue(ttv-vlr-icms)        .



        assign m-linha = m-linha + 1.



    end.


end procedure.


PROCEDURE pi-compras:


    chworksheet=chWorkBook:sheets:item(1).
    chworksheet:name="APURACAO". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:E1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:E1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:E1"):SetValue("COMPRAS MATRIZ E FILIAL").
    chWorkSheet:Range("A1:E1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:E1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("A2:y2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):SetValue("TIPO").
        chworksheet:range("B" + STRING(m-linha)):SetValue("QTDE").
        chworksheet:range("C" + STRING(m-linha)):SetValue("MATRIZ").
        chworksheet:range("d" + STRING(m-linha)):SetValue("SALVADOR").
        chworksheet:range("e" + STRING(m-linha)):SetValue("TOTAL").

        chworksheet:range("g" + STRING(m-linha)):SetValue("Local").
        chworksheet:range("h" + STRING(m-linha)):SetValue("ICMS / IPI").
        chworksheet:range("i" + STRING(m-linha)):SetValue("Local").
        chworksheet:range("j" + STRING(m-linha)):SetValue("PIS / COFINS").

assign m-linha = m-linha  + 1.
DEF VAR c-cfop AS char.

ASSIGN c-cfop = "1101,1102,2101,2102".

FIND FIRST tt-param NO-ERROR.

FOR EACH natur-oper NO-LOCK WHERE LOOKUP(trim(natur-oper.cod-cfop), c-cfop) <> 0.


FOR EACH docum-est NO-LOCK WHERE docum-est.dt-trans >= tt-param.ttv-dt-ini
                           AND   docum-est.dt-trans <= tt-param.ttv-dt-fim
                           AND   docum-est.cod-estabel >= tt-param.ttv-estab-ini
                           AND   docum-est.cod-estabel <= tt-param.ttv-estab-fim
                           AND   docum-est.nat-operacao = natur-oper.nat-operacao
                           :

    FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
                                  AND   item-doc-est.nro-docto    = docum-est.nro-docto
                                  AND   item-doc-est.serie-docto  = docum-est.serie-docto
                                  AND   item-doc-est.nat-operacao = docum-est.nat-operacao
                                  
                                  :

        RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(docum-est.dt-emissao)).



        FIND FIRST ITEM WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

        FIND FIRST grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-ERROR.

        FIND FIRST familia NO-LOCK WHERE familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

        FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
        
        if grup-estoque.ge-codigo = 50 then next.
        

        CREATE tt-compras.
        ASSIGN tt-compras.ttv-cod-estabel           = docum-est.cod-estabel
               tt-compras.ttv-serie                 = docum-est.serie-docto
               tt-compras.ttv-nr-nota-fis           = docum-est.nro-docto
               tt-compras.ttv-nome-fornec           = emitente.nome-abrev
               tt-compras.ttv-it-codigo             = item-doc-est.it-codigo
               tt-compras.ttv-ge-codigo             = string(grup-estoque.descricao)
               tt-compras.ttv-fm-codigo             = ITEM.fm-codigo
               tt-compras.ttv-concatena             = docum-est.cod-estabel + " " + grup-estoque.descricao
               tt-compras.ttv-quantidade            = item-doc-est.quantidade
               tt-compras.ttv-vlr-mercadoria        = (item-doc-est.preco-total[1]) + item-doc-est.valor-ipi[1]
               tt-compras.ttv-vlr-PIS               = item-doc-est.valor-pis
               tt-compras.ttv-vlr-COFINS            = item-doc-est.val-cofins
               tt-compras.ttv-vlr-ipi               = item-doc-est.valor-ipi[1]
               tt-compras.ttv-vlr-icms              = item-doc-est.valor-icm[1]
               tt-compras.ttv-estab-pedido          = docum-est.cod-estabel 
               tt-compras.ttv-base-icms             = item-doc-est.base-icm[1]
               tt-compras.ttv-base-cofins          =  item-doc-est.base-pis.



        END.

    END.

END.



FOR EACH tt-compras WHERE tt-compras.ttv-cod-estabel = "MTZ" BREAK BY tt-compras.ttv-concatena:

    accumulate tt-compras.ttv-vlr-mercadoria   (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-quantidade       (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-base-icms        (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-base-cofins       (SUB-TOTAL BY tt-compras.ttv-concatena).




    RUN pi-acompanhar IN h-prog(INPUT "Data " + string(tt-compras.ttv-concatena)).


    IF LAST-OF(tt-compras.ttv-concatena) THEN DO:

    chworksheet:range("A" + STRING(m-linha)):SetValue("Compras " + tt-compras.ttv-concatena).
    chworksheet:range("B" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-quantidade).
    chworksheet:range("C" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-mercadoria).

    ASSIGN m-linha = m-linha + 1.

    END.
END.

FOR EACH tt-compras WHERE tt-compras.ttv-cod-estabel = "FBA" BREAK BY tt-compras.ttv-concatena:

    accumulate tt-compras.ttv-vlr-mercadoria   (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-quantidade       (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-base-icms        (SUB-TOTAL BY tt-compras.ttv-concatena).
    accumulate tt-compras.ttv-base-cofins       (SUB-TOTAL BY tt-compras.ttv-concatena).




    RUN pi-acompanhar IN h-prog(INPUT "Data " + string(tt-compras.ttv-concatena)).


    IF LAST-OF(tt-compras.ttv-concatena) THEN DO:

    chworksheet:range("A" + STRING(m-linha)):SetValue("Compras " + tt-compras.ttv-concatena).
    chworksheet:range("b" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-quantidade).
    chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-mercadoria).

    ASSIGN m-linha = m-linha + 1.

    END.
END.

assign m-linha = 3.
FOR EACH tt-compras BREAK BY tt-compras.ttv-cod-estabel:

    accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-cod-estabel).
    accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-cod-estabel).
    accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-cod-estabel).
    accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-cod-estabel).





    IF LAST-OF(tt-compras.ttv-cod-estabel) THEN DO:

    chworksheet:range("g" + STRING(m-linha)):SetValue(tt-compras.ttv-cod-estabel).
    chworksheet:range("h" + STRING(m-linha)):SetValue((accum SUB-TOTAL BY tt-compras.ttv-cod-estabel tt-compras.ttv-vlr-icms) + (ACCUM SUB-TOTAL BY tt-compras.ttv-cod-estabel tt-compras.ttv-vlr-ipi) ).
    chworksheet:range("i" + STRING(m-linha)):SetValue(tt-compras.ttv-cod-estabel).
    chworksheet:range("j" + STRING(m-linha)):SetValue((accum SUB-TOTAL BY tt-compras.ttv-cod-estabel tt-compras.ttv-vlr-pis) + (ACCUM SUB-TOTAL BY tt-compras.ttv-cod-estabel tt-compras.ttv-vlr-cofins) ).

    ASSIGN m-linha = m-linha + 1.

    END.
END.





/*     accumulate tt-compras.ttv-vlr-mercadoria   (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-quantidade       (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-base-icms        (SUB-TOTAL BY tt-compras.ttv-concatena).                */
/*     accumulate tt-compras.ttv-base-cofins       (SUB-TOTAL BY tt-compras.ttv-concatena).               */
/*                                                                                                        */
/*                                                                                                        */
/*     IF LAST-OF(tt-compras.ttv-concatena) THEN DO:                                                      */
/*                                                                                                        */
/*                                                                                                        */
/*         PUT UNFORMATTED tt-compras.ttv-cod-estabel "|"                                                 */
/*                         tt-compras.ttv-concatena   "|".                                                */
/*                                                                                                        */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-mercadoria "|". */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-pis "|".        */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-cofins "|".     */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-ipi "|".        */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-vlr-icms "|".       */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-quantidade "|".     */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-base-icms  "|".     */
/*         PUT UNFORMATTED ACCUM SUB-TOTAL BY tt-compras.ttv-concatena tt-compras.ttv-base-cofins "|"     */
/*                                                                                                        */
/*             SKIP.                                                                                      */
/*                                                                                                        */
/*                                                                                                        */
/*     END.                                                                                               */
/*                                                                                                        */
/*                                                                                                        */






END PROCEDURE.



