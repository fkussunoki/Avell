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
    FIELD ttv-cfop              AS char
    INDEX TTA-CONCATENA
    ttv-concatena ASCENDING.

DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.

DEF VAR m-linha AS INTEGER.
def var h-prog as handle.

{office/office.i Excel chExcel}
    
    chExcel:sheetsinNewWorkbook = 2.
    chWorkbook = chExcel:Workbooks:ADD().


DEF VAR c-cfop-icms AS CHAR.
DEF VAR c-cfop-ipi  AS char.
DEF VAR c-cfop-pis  AS char.
DEF VAR c-cfop-cofins AS char.
DEF VAR c-cfop        AS CHAR.
DEF BUFFER b-natur-oper FOR natur-oper.

    RUN utp/ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Gerando").

    run pi-faturamento.
    run pi-memoria.
    run pi-finalizar in h-prog.
chexcel:VISIBLE = YES.

procedure pi-memoria:
    chworksheet=chWorkBook:sheets:item(2).
    chworksheet:name="Memoria de Caculo". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:E1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:E1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:E1"):SetValue("MEMORIA DE CALCULO").
    chWorkSheet:Range("A1:E1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:E1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("A2:y2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):SetValue("Estab").
        chworksheet:range("B" + STRING(m-linha)):SetValue("Serie").
        chworksheet:range("C" + STRING(m-linha)):SetValue("NF").
        chworksheet:range("d" + STRING(m-linha)):SetValue("Nom.Abrev.Cli").
        chworksheet:range("e" + STRING(m-linha)):SetValue("Codigo Item").
        chworksheet:range("f" + STRING(m-linha)):SetValue("Grupo de Estoque").
        chworksheet:range("g" + STRING(m-linha)):SetValue("Qtde").
        chworksheet:range("h" + STRING(m-linha)):SetValue("Vlr mercadoria").
        chworksheet:range("i" + STRING(m-linha)):SetValue("PIS").
        chworksheet:range("j" + STRING(m-linha)):SetValue("COFINS").
        chworksheet:range("k" + STRING(m-linha)):SetValue("IPI").
        chworksheet:range("l" + STRING(m-linha)):SetValue("ICMS").
        chworksheet:range("m" + STRING(m-linha)):SetValue("CFOP").

    

        assign m-linha = m-linha  + 1.


        for each tt-faturamento:
        RUN pi-acompanhar in h-prog (input "Nota " + tt-faturamento.ttv-nr-nota-fis).
            chworksheet:range("A" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cod-estabel).
            chworksheet:range("B" + STRING(m-linha)):SetValue(tt-faturamento.ttv-serie).       
            chworksheet:range("C" + STRING(m-linha)):SetValue(tt-faturamento.ttv-nr-nota-fis). 
            chworksheet:range("d" + STRING(m-linha)):SetValue(tt-faturamento.ttv-nome-ab-cli). 
            chworksheet:range("e" + STRING(m-linha)):SetValue(tt-faturamento.ttv-it-codigo).   
            chworksheet:range("f" + STRING(m-linha)):SetValue(tt-faturamento.ttv-ge-codigo).   
            chworksheet:range("g" + STRING(m-linha)):SetValue(tt-faturamento.ttv-quantidade).      
            chworksheet:range("h" + STRING(m-linha)):SetValue(tt-faturamento.ttv-vlr-mercadoria).  
            chworksheet:range("i" + STRING(m-linha)):SetValue(tt-faturamento.ttv-vlr-PIS).         
            chworksheet:range("j" + STRING(m-linha)):SetValue(tt-faturamento.ttv-vlr-COFINS).      
            chworksheet:range("k" + STRING(m-linha)):SetValue(tt-faturamento.ttv-vlr-ipi).         
            chworksheet:range("l" + STRING(m-linha)):SetValue(tt-faturamento.ttv-vlr-icms). 
            chworksheet:range("l" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cfop).

        assign m-linha = m-linha + 1.



        end.




end procedure.

procedure pi-faturamento:

    chworksheet=chWorkBook:sheets:item(1).
    chworksheet:name="APURACAO". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:E1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:E1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:E1"):SetValue("FATURAMENTO MATRIZ E FILIAL").
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



ASSIGN c-cfop      = "5101,5122,5102,5910,5911,6101,6102,6107,6122,6910".
ASSIGN c-cfop-icms = "5101,5102,5910,5911,6101,6102,6107,6122,6910".
ASSIGN c-cfop-ipi  = "5101,5102,5911,6101,6102,6107,6122,6910".
ASSIGN c-cfop-pis  = "5101,5122,5102,5911,6101,6102,6107,6122,6910".
ASSIGN c-cfop-cofins = "5101,5122,5102,5911,6101,6102,6107,6122,6910".


/* FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.dt-emis-doc >= 11/01/2018   */
/*                              AND   it-doc-fisc.dt-emis-doc <= 11/30/2018:  */


FOR EACH natur-oper WHERE LOOKUP(trim(natur-oper.cod-cfop), c-cfop) <> 0:
FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota >= 03/01/2019
                              AND   it-nota-fisc.dt-emis-nota <= 03/31/2019
                              AND   it-nota-fisc.nat-operacao = natur-oper.nat-operacao
                              
                             :

    FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                   AND   nota-fiscal.serie       = it-nota-fisc.serie
                                   AND   nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                   AND   nota-fiscal.nome-ab-cli = it-nota-fisc.nome-ab-cli
/*                                    AND   nota-fiscal.nat-operacao = it-nota-fisc.nat-operacao */
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
        ASSIGN tt-faturamento.ttv-cod-estabel               = it-nota-fisc.cod-estabel
               tt-faturamento.ttv-serie                     = it-nota-fisc.serie
               tt-faturamento.ttv-nr-nota-fis               = it-nota-fisc.nr-nota-fis
               tt-faturamento.ttv-nome-ab-cli               = it-nota-fisc.nome-ab-cli
               tt-faturamento.ttv-it-codigo                 = it-nota-fisc.it-codigo
               tt-faturamento.ttv-ge-codigo                 = string(ITEM.ge-codigo)
               tt-faturamento.ttv-fm-codigo                 = string(ITEM.fm-cod-com)
               tt-faturamento.ttv-quantidade                = it-nota-fisc.qt-faturada[1]
               tt-faturamento.ttv-vlr-mercadoria            = it-nota-fisc.vl-tot-item.


        FIND FIRST b-natur-oper NO-LOCK WHERE LOOKUP(trim(b-natur-oper.cod-cfop), c-cfop-ipi) <> 0 NO-ERROR.
        IF AVAIL b-natur-oper THEN
            ASSIGN tt-faturamento.ttv-vlr-ipi                   = if it-nota-fisc.cd-trib-ipi = 1 then it-nota-fisc.vl-ipi-it else 0.
        ELSE
            ASSIGN tt-faturamento.ttv-vlr-ipi                   = 0.
            FIND FIRST b-natur-oper NO-LOCK WHERE LOOKUP(trim(b-natur-oper.cod-cfop), c-cfop-icms) <> 0 NO-ERROR.
        IF AVAIL b-natur-oper THEN
            ASSIGN tt-faturamento.ttv-vlr-icms                  = if it-nota-fisc.cd-trib-icm = 1 then it-nota-fisc.vl-icms-it else 0.
        ELSE 
            ASSIGN tt-faturamento.ttv-vlr-icms                  = 0.
            FIND FIRST b-natur-oper NO-LOCK WHERE LOOKUP(trim(b-natur-oper.cod-cfop), c-cfop-cofins) <> 0 NO-ERROR.
        IF AVAIL b-natur-oper THEN
            ASSIGN tt-faturamento.ttv-vlr-cofins                = IF it-nota-fisc.cod-sit-tributar-cofins = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,81,5)) / 100) ELSE 0.
        ELSE tt-faturamento.ttv-vlr-cofins                      = 0.

             FIND FIRST b-natur-oper NO-LOCK WHERE LOOKUP(trim(b-natur-oper.cod-cfop), c-cfop-pis) <> 0 NO-ERROR.
         IF AVAIL b-natur-oper THEN
             ASSIGN tt-faturamento.ttv-vlr-pis                   = if it-nota-fisc.cod-sit-tributar-pis    = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,76,5)) / 100) ELSE 0.
         ELSE  tt-faturamento.ttv-vlr-pis                        = 0.     
         ASSIGN
               tt-faturamento.ttv-estab-pedido              = IF AVAIL ped-venda THEN ped-venda.cod-estabel ELSE it-nota-fisc.cod-estabel
               tt-faturamento.ttv-concatena                 = IF AVAIL ped-venda THEN ped-venda.cod-estabel ELSE it-nota-fisc.cod-estabel /* + string(item.fm-codigo) */.
         FIND FIRST b-natur-oper WHERE b-natur-oper.nat-oper = it-nota-fisc.nat-operacao NO-ERROR. 

             ASSIGN  tt-faturamento.ttv-cfop                      = b-natur-oper.cod-cfop.


    END.
  END.

END.



FOR EACH tt-faturamento where tt-faturamento.ttv-cod-estabel = "mtz"
    BREAK BY tt-faturamento.ttv-concatena:


/*     EXPORT DELIMITER "|" TT-FATURAMENTO.  */


    RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(tt-faturamento.ttv-concatena)).
    ACCUMULATE tt-faturamento.ttV-vlr-mercadoria (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-ipi        (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-icms       (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttV-concatena).

 

    IF LAST-OF(tt-faturamento.ttv-concatena) THEN DO:
        chworksheet:range("A" + STRING(m-linha)):SetValue("Pedidos " + tt-faturamento.ttv-concatena).
        chworksheet:range("B" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-quantidade).
        chworksheet:range("C" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-mercadoria).

        assign m-linha = m-linha + 1.
    end.
end.

FOR EACH tt-faturamento where tt-faturamento.ttv-cod-estabel = "fba"
    BREAK BY tt-faturamento.ttv-concatena:


/*     EXPORT DELIMITER "|" TT-FATURAMENTO.  */


    RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(tt-faturamento.ttv-concatena)).
    ACCUMULATE tt-faturamento.ttV-vlr-mercadoria (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-ipi        (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-icms       (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
    ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttV-concatena).



    IF LAST-OF(tt-faturamento.ttv-concatena) THEN DO:
        chworksheet:range("A" + STRING(m-linha)):SetValue("Pedidos " + tt-faturamento.ttv-concatena).
        chworksheet:range("B" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-quantidade).
        chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-mercadoria).

        assign m-linha = m-linha + 1.
    end.
end.

assign m-linha = 3.
FOR EACH tt-faturamento
    BREAK BY tt-faturamento.ttv-cod-estabel:
    RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(tt-faturamento.ttv-concatena)).
    ACCUMULATE tt-faturamento.ttV-vlr-mercadoria (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).
    ACCUMULATE tt-faturamento.ttV-vlr-ipi        (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).
    ACCUMULATE tt-faturamento.ttV-vlr-icms       (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).
    ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).
    ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).
    ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttv-cod-estabel).

    if last-of(tt-faturamento.ttv-cod-estabel) then do:
        chworksheet:range("g" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cod-estabel).
        chworksheet:range("h" + STRING(m-linha)):SetValue((accum SUB-TOTAL BY tt-faturamento.ttv-cod-estabel tt-faturamento.ttv-vlr-IPI) + (ACCUM SUB-TOTAL BY tt-faturamento.ttv-cod-estabel tt-faturamento.ttv-vlr-ICMS)).
        chworksheet:range("i" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cod-estabel).
        chworksheet:range("j" + STRING(m-linha)):SetValue((ACCUM SUB-TOTAL BY tt-faturamento.ttv-cod-estabel tt-faturamento.ttv-vlr-pis) + (ACCUM SUB-TOTAL BY tt-faturamento.ttv-cod-estabel tt-faturamento.ttv-vlr-cofins)).
        assign m-linha = m-linha + 1.


    end.


END.





end procedure.





