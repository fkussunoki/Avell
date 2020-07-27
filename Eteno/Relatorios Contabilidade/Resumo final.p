DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.

DEF VAR c-alfabet                   AS CHAR EXTENT 208                              NO-UNDO
    INIT ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
          "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ",
          "BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ",
          "CA","CB","CC","CD","CE","CF","CG","CH","CI","CJ","CK","CL","CM","CN","CO","CP","CQ","CR","CS","CT","CU","CV","CW","CX","CY","CZ",
          "DA","DB","DC","DD","DE","DF","DG","DH","DI","DJ","DK","DL","DM","DN","DO","DP","DQ","DR","DS","DT","DU","DV","DW","DX","DY","DZ",
          "EA","EB","EC","ED","EE","EF","EG","EH","EI","EJ","EK","EL","EM","EN","EO","EP","EQ","ER","ES","ET","EU","EV","EW","EX","EY","EZ",
          "FA","FB","FC","FD","FE","FF","FG","FH","FI","FJ","FK","FL","FM","FN","FO","FP","FQ","FR","FS","FT","FU","FV","FW","FX","FY","FZ",
          "GA","GB","GC","GD","GE","GF","GG","GH","GI","GJ","GK","GL","GM","GN","GO","GP","GQ","GR","GS","GT","GU","GV","GW","GX","GY","GZ"].

def buffer b-natur-oper for natur-oper.
DEF VAR m-linha AS INTEGER.
DEF VAR X-linha AS INTEGER.
DEF VAR marco   AS INTEGER.
def var h-prog as handle.
{office/office.i Excel chExcel}
    
    chExcel:sheetsinNewWorkbook = 2.
    chWorkbook = chExcel:Workbooks:ADD().

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
        field ttv-base-cofins       as dec FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
        FIELD ttv-estab-pedido      AS char
        FIELD ttv-cfop              AS char
        INDEX TTA-CONCATENA
        ttv-concatena ASCENDING.

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
        FIELD ttv-natureza          AS char

        INDEX TTA-CONCATENA
        ttv-concatena ASCENDING.


    RUN utp/ut-acomp.p PERSISTENT SET h-prog.

    RUN pi-inicializar IN h-prog (INPUT "Gerando").

    RUN pi-compras.
    RUN pi-faturamento.

    RUN pi-finalizar in h-prog.
    chexcel:VISIBLE = YES.


PROCEDURE pi-faturamento:

    ASSIGN m-linha = m-linha + 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A" + string(m-linha) + ":" + "g" + string(m-linha)):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A" + string(m-linha) + ":" + "g" + string(m-linha)):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A" + string(m-linha) + ":" + "g" + string(m-linha)):SetValue("REGISTRO DE Saidas - Matriz").
    chWorkSheet:Range("A" + string(m-linha) + ":" + "g" + string(m-linha)):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A" + string(m-linha) + ":" + "g" + string(m-linha)):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
    chworksheet:range("i" + string(m-linha) + ":" + "o" + string(m-linha)):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("i" + string(m-linha) + ":" + "o" + string(m-linha)):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("i" + string(m-linha) + ":" + "o" + string(m-linha)):SetValue("REGISTRO DE Saidas - filial").
    chWorkSheet:Range("i" + string(m-linha) + ":" + "o" + string(m-linha)):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("i" + string(m-linha) + ":" + "o" + string(m-linha)):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
    chworksheet:range("i" + string(m-linha) + ":" + "o" + string(m-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
    
    ASSIGN m-linha = m-linha + 1.
    chworksheet:range("A" + string(m-linha) + ":" + "g" + string(m-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
    chworksheet:range("A" + STRING(m-linha)):SetValue("Saidas").
    chworksheet:range("B" + STRING(m-linha)):SetValue("Vlr. Contabil").
    chworksheet:range("C" + STRING(m-linha)):SetValue("IPI").
    chworksheet:range("d" + STRING(m-linha)):SetValue("ICMS").
    chworksheet:range("e" + STRING(m-linha)):SetValue("Base Calculo PIS/COFINS").
    chworksheet:range("f" + STRING(m-linha)):SetValue("PIS").
    chworksheet:range("g" + STRING(m-linha)):SetValue("COFINS").

  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("i" + STRING(m-linha)):SetValue("Saidas").
        chworksheet:range("j" + STRING(m-linha)):SetValue("Vlr. Contabil").
        chworksheet:range("k" + STRING(m-linha)):SetValue("IPI").
        chworksheet:range("l" + STRING(m-linha)):SetValue("ICMS").
        chworksheet:range("m" + STRING(m-linha)):SetValue("Base Calculo PIS/COFINS").
        chworksheet:range("n" + STRING(m-linha)):SetValue("PIS").
        chworksheet:range("o" + STRING(m-linha)):SetValue("COFINS").
        ASSIGN m-linha = m-linha + 1.
        ASSIGN marco   = m-linha.

        /* FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.dt-emis-doc >= 11/01/2018   */
        /*                              AND   it-doc-fisc.dt-emis-doc <= 11/30/2018:  */


        FOR EACH natur-oper NO-LOCK WHERE SUBSTRING(natur-oper.cod-cfop, 1, 3) >= "510"
                                    AND   SUBSTRING(natur-oper.cod-cfop, 1, 3) <= "699":
        FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota >= 10/01/2018
                                      AND   it-nota-fisc.dt-emis-nota <= 10/31/2018
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
                                     


                FIND FIRST b-natur-oper NO-LOCK WHERE substring(b-natur-oper.cod-cfop, 1, 3) >= "510" 
                                                and   substring(b-natur-oper.cod-cfop, 1, 3) <= "699" no-error.
                IF AVAIL b-natur-oper THEN
                    ASSIGN tt-faturamento.ttv-vlr-ipi                   = if it-nota-fisc.cd-trib-ipi = 1 then it-nota-fisc.vl-ipi-it else 0.
                ELSE
                    ASSIGN tt-faturamento.ttv-vlr-ipi                   = 0.
                    FIND FIRST b-natur-oper NO-LOCK WHERE substring(b-natur-oper.cod-cfop, 1, 3) >= "510" 
                                                    and   substring(b-natur-oper.cod-cfop, 1, 3) <= "699" no-error.
                IF AVAIL b-natur-oper THEN
                    ASSIGN tt-faturamento.ttv-vlr-icms                  = if it-nota-fisc.cd-trib-icm = 1 then it-nota-fisc.vl-icms-it else 0.
                ELSE 
                    ASSIGN tt-faturamento.ttv-vlr-icms                  = 0.
                    FIND FIRST b-natur-oper NO-LOCK WHERE substring(b-natur-oper.cod-cfop, 1, 3) >= "510" 
                                                    and   substring(b-natur-oper.cod-cfop, 1, 3) <= "699" no-error.
                IF AVAIL b-natur-oper THEN DO:
                ASSIGN tt-faturamento.ttv-vlr-cofins                = IF it-nota-fisc.cod-sit-tributar-cofins = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,81,5)) / 100) ELSE 0.
                ASSIGN tt-faturamento.ttv-base-cofins               = IF it-nota-fisc.cod-sit-tributar-cofins = "01" THEN (it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) ELSE 0.
                END.

                ELSE DO: 
                ASSIGN tt-faturamento.ttv-vlr-cofins                      = 0.
                ASSIGN tt-faturamento.ttv-base-cofins                     = 0.
                END.

                     FIND FIRST b-natur-oper NO-LOCK WHERE substring(b-natur-oper.cod-cfop, 1, 3) >= "510" 
                                                     and   substring(b-natur-oper.cod-cfop, 1, 3) <= "699" no-error.
                 IF AVAIL b-natur-oper THEN
                     ASSIGN tt-faturamento.ttv-vlr-pis                   = if it-nota-fisc.cod-sit-tributar-pis    = "01" THEN ((it-nota-fisc.vl-tot-item - it-nota-fisc.vl-icms-it - IF it-nota-fisc.cod-sit-tributar-ipi = "50" THEN it-nota-fisc.vl-ipi-it ELSE 0) * DECIMAL(substring(it-nota-fisc.char-2,76,5)) / 100) ELSE 0.
                 ELSE  tt-faturamento.ttv-vlr-pis                        = 0.     
                 ASSIGN
                       tt-faturamento.ttv-estab-pedido              = it-nota-fisc.cod-estabel
                       tt-faturamento.ttv-concatena                 = it-nota-fisc.cod-estabel  + natur-oper.cod-cfop /* + string(item.fm-codigo) */.
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
            accumulate tt-faturamento.ttv-base-cofins    (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttV-concatena).



            IF LAST-OF(tt-faturamento.ttv-concatena) THEN DO:
                chworksheet:range("A" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cfop).
                chworksheet:range("B" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-mercadoria).
                chworksheet:range("C" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-ipi).
                chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-icms).
                chworksheet:range("e" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-base-cofins).
                chworksheet:range("f" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-cofins).
                chworksheet:range("g" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-pis).

                assign m-linha = m-linha + 1.
            end.
        end.
        chworksheet:range("a" + string(m-linha) + ":" + "g" + string(m-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */

        chworksheet:range("a" + STRING(m-linha)):SetValue("Total").
        chworksheet:range("b" + STRING(m-linha)):SetValue("=sum(b" + STRING(marco) + ":" + "b" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("c" + STRING(m-linha)):SetValue("=sum(c" + STRING(marco) + ":" + "c" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("d" + STRING(m-linha)):SetValue("=sum(d" + string(marco) + ":" + "d" + string(m-linha - 1) + ")" ).
        chworksheet:range("e" + STRING(m-linha)):SetValue("=sum(e" + string(marco) + ":" + "e" + string(m-linha - 1) + ")" ).
        chworksheet:range("f" + STRING(m-linha)):SetValue("=sum(f" + string(marco) + ":" + "f" + string(m-linha - 1) + ")" ).
        chworksheet:range("g" + STRING(m-linha)):SetValue("=sum(g" + string(marco) + ":" + "g" + string(m-linha - 1) + ")" ).



        ASSIGN m-linha = marco.
        FOR EACH tt-faturamento where tt-faturamento.ttv-cod-estabel = "fba"
            BREAK BY tt-faturamento.ttv-concatena:


        /*     EXPORT DELIMITER "|" TT-FATURAMENTO.  */


            RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(tt-faturamento.ttv-concatena)).
            ACCUMULATE tt-faturamento.ttV-vlr-mercadoria (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-ipi        (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-icms       (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            accumulate tt-faturamento.ttv-base-cofins    (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-quantidade     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-cofins     (SUB-TOTAL BY tt-faturamento.ttV-concatena).
            ACCUMULATE tt-faturamento.ttV-vlr-pis        (SUB-TOTAL BY tt-faturamento.ttV-concatena).



            IF LAST-OF(tt-faturamento.ttv-concatena) THEN DO:
                chworksheet:range("i" + STRING(m-linha)):SetValue(tt-faturamento.ttv-cfop).
                chworksheet:range("j" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-mercadoria).
                chworksheet:range("k" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-ipi).
                chworksheet:range("l" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-icms).
                chworksheet:range("m" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-base-cofins).
                chworksheet:range("n" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-cofins).
                chworksheet:range("o" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-faturamento.ttv-concatena tt-faturamento.ttv-vlr-pis).

                assign m-linha = m-linha + 1.
            end.
        end.


        chworksheet:range("i" + string(m-linha) + ":" + "o" + string(m-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("i" + STRING(m-linha)):SetValue("Total").
        chworksheet:range("j" + STRING(m-linha)):SetValue("=sum(j" + STRING(marco) + ":" + "j" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("k" + STRING(m-linha)):SetValue("=sum(k" + STRING(marco) + ":" + "k" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("l" + STRING(m-linha)):SetValue("=sum(l" + string(marco) + ":" + "l" + string(m-linha - 1) + ")" ).
        chworksheet:range("m" + STRING(m-linha)):SetValue("=sum(m" + string(marco) + ":" + "m" + string(m-linha - 1) + ")" ).
        chworksheet:range("n" + STRING(m-linha)):SetValue("=sum(n" + string(marco) + ":" + "n" + string(m-linha - 1) + ")" ).
        chworksheet:range("o" + STRING(m-linha)):SetValue("=sum(o" + string(marco) + ":" + "o" + string(m-linha - 1) + ")" ).



END PROCEDURE.

PROCEDURE pi-compras:


    chworksheet=chWorkBook:sheets:item(1).
    chworksheet:name="APURACAO". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:g1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:g1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:g1"):SetValue("REGISTRO DE ENTRADAS - Matriz").
    chWorkSheet:Range("A1:g1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:g1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("A2:g2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):setvalue("Entradas").
        chworksheet:range("B" + STRING(m-linha)):SetValue("Vlr. Contabil").
        chworksheet:range("C" + STRING(m-linha)):SetValue("IPI").
        chworksheet:range("d" + STRING(m-linha)):SetValue("ICMS").
        chworksheet:range("e" + STRING(m-linha)):SetValue("Base Calculo PIS/COFINS").
        chworksheet:range("f" + STRING(m-linha)):SetValue("PIS").
        chworksheet:range("g" + STRING(m-linha)):SetValue("COFINS").

        chworksheet:range("i1:o1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
        chworksheet:range("i1:o1"):MergeCells = TRUE. /* Cria a Planilha */
        chworksheet:range("i1:o1"):SetValue("REGISTRO DE ENTRADAS - filial").
        chWorkSheet:Range("i1:o1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
        chWorkSheet:Range("i1:o1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
      /* Cria os titulos para as colunas do relat÷rio */
            chworksheet:range("i2:o2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
            chworksheet:range("i" + STRING(m-linha)):SetValue("Entradas").
            chworksheet:range("j" + STRING(m-linha)):SetValue("Vlr. Contabil").
            chworksheet:range("k" + STRING(m-linha)):SetValue("IPI").
            chworksheet:range("l" + STRING(m-linha)):SetValue("ICMS").
            chworksheet:range("m" + STRING(m-linha)):SetValue("Base Calculo PIS/COFINS").
            chworksheet:range("n" + STRING(m-linha)):SetValue("PIS").
            chworksheet:range("o" + STRING(m-linha)):SetValue("COFINS").


DEF VAR c-cfop AS char.

ASSIGN c-cfop = "1101,2101,2102".


FOR EACH natur-oper NO-LOCK WHERE SUBSTRING(natur-oper.cod-cfop, 1, 3) >= "110"
                            AND   SUBSTRING(natur-oper.cod-cfop, 1, 3) <= "299":


FOR EACH docum-est NO-LOCK WHERE docum-est.dt-trans >= 10/01/2018
                           AND   docum-est.dt-trans <= 10/31/2018
                           AND   docum-est.nat-operacao = natur-oper.nat-operacao
                           :

    FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
                                  AND   item-doc-est.nro-docto    = docum-est.nro-docto
                                  AND   item-doc-est.serie-docto  = docum-est.serie-docto
                                  AND   item-doc-est.nat-operacao = docum-est.nat-operacao
                                  
                                  :

        RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(docum-est.dt-emissao)).



        FIND FIRST ITEM WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

        FIND FIRST familia NO-LOCK WHERE familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

        FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.


        FIND FIRST grup-estoque NO-LOCK WHERE grup-estoq.GE-codigo = ITEM.ge-codigo NO-ERROR.

        CREATE tt-compras.
        ASSIGN tt-compras.ttv-cod-estabel           = docum-est.cod-estabel
               tt-compras.ttv-serie                 = docum-est.serie-docto
               tt-compras.ttv-nr-nota-fis           = docum-est.nro-docto
               tt-compras.ttv-nome-fornec           = emitente.nome-abrev
               tt-compras.ttv-it-codigo             = item-doc-est.it-codigo
               tt-compras.ttv-ge-codigo             = string(ITEM.ge-codigo)
               tt-compras.ttv-fm-codigo             = ITEM.fm-codigo
               tt-compras.ttv-concatena             = docum-est.cod-estabel + grup-estoque.descricao
               tt-compras.ttv-concatena1            = docum-est.cod-estabel + natur-oper.cod-cfop
               tt-compras.ttv-quantidade            = item-doc-est.quantidade
               tt-compras.ttv-vlr-mercadoria        = item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1]
               tt-compras.ttv-vlr-PIS               = item-doc-est.valor-pis
               tt-compras.ttv-vlr-COFINS            = item-doc-est.val-cofins
               tt-compras.ttv-vlr-ipi               = item-doc-est.valor-ipi[1]
               tt-compras.ttv-vlr-icms              = item-doc-est.valor-icm[1]
               tt-compras.ttv-estab-pedido          = docum-est.cod-estabel 
               tt-compras.ttv-base-icms             = item-doc-est.base-icm[1]
               tt-compras.ttv-base-cofins          =  item-doc-est.base-pis
               tt-compras.ttv-natureza              = natur-oper.cod-cfop.



        END.

    END.

END.


ASSIGN m-linha = 3.

FOR EACH tt-compras WHERE tt-compras.ttv-cod-estabel = "MTZ"  BREAK BY tt-compras.ttv-concatena1:

    accumulate tt-compras.ttv-vlr-mercadoria   (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-quantidade       (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-base-icms        (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-base-cofins       (SUB-TOTAL BY tt-compras.ttv-concatena1).



    RUN pi-acompanhar IN h-prog(INPUT "Data " + string(tt-compras.ttv-concatena)).



    IF LAST-OF(tt-compras.ttv-concatena1) THEN DO:

        chworksheet:range("A" + STRING(m-linha)):SetValue(tt-compras.ttv-natureza).
        chworksheet:range("B" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-mercadoria).
        chworksheet:range("C" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-ipi).
        chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-icms).
        chworksheet:range("e" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-base-cofins).
        chworksheet:range("f" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-cofins).
        chworksheet:range("g" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-pis).

        ASSIGN m-linha = m-linha + 1.





    END.
END.
       chworksheet:range("a" + string(m-linha) + ":" + "g" + string(m-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        
        chworksheet:range("a" + STRING(m-linha)):SetValue("Total").
        chworksheet:range("b" + STRING(m-linha)):SetValue("=sum(b3" + ":" + "b" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("c" + STRING(m-linha)):SetValue("=sum(c3" + ":" + "c" + STRING(m-linha - 1) + ")" ).
        chworksheet:range("d" + STRING(m-linha)):SetValue("=sum(d3" + ":" + "d" + string(m-linha - 1) + ")" ).
        chworksheet:range("e" + STRING(m-linha)):SetValue("=sum(e3" + ":" + "e" + string(m-linha - 1) + ")" ).
        chworksheet:range("f" + STRING(m-linha)):SetValue("=sum(f3" + ":" + "f" + string(m-linha - 1) + ")" ).
        chworksheet:range("g" + STRING(m-linha)):SetValue("=sum(g3" + ":" + "g" + string(m-linha - 1) + ")" ).



ASSIGN X-linha = 3.

FOR EACH tt-compras WHERE tt-compras.ttv-cod-estabel = "FBA"  BREAK BY tt-compras.ttv-concatena1:

    accumulate tt-compras.ttv-vlr-mercadoria   (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-PIS          (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-COFINS       (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-ipi          (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-vlr-icms         (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-quantidade       (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-base-icms        (SUB-TOTAL BY tt-compras.ttv-concatena1).
    accumulate tt-compras.ttv-base-cofins       (SUB-TOTAL BY tt-compras.ttv-concatena1).



    RUN pi-acompanhar IN h-prog(INPUT "Data " + string(tt-compras.ttv-concatena)).


    IF LAST-OF(tt-compras.ttv-concatena1) THEN DO:

        chworksheet:range("i" + STRING(X-linha)):SetValue(tt-compras.ttv-natureza).
        chworksheet:range("j" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-mercadoria).
        chworksheet:range("k" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-ipi).
        chworksheet:range("l" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-icms).
        chworksheet:range("m" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-base-cofins).
        chworksheet:range("n" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-cofins).
        chworksheet:range("o" + STRING(X-linha)):SetValue(ACCUM SUB-TOTAL BY tt-compras.ttv-concatena1 tt-compras.ttv-vlr-pis).

        ASSIGN X-linha = X-linha + 1.





    END.
END.    
        chworksheet:range("i" + string(x-linha) + ":" + "o" + string(x-linha)):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */

        chworksheet:range("i" + STRING(x-linha)):SetValue("Total").
        chworksheet:range("j" + STRING(x-linha)):SetValue("=sum(j3"  + ":" + "j" + STRING(x-linha - 1) + ")" ).
        chworksheet:range("k" + STRING(x-linha)):SetValue("=sum(k3"  + ":" + "k" + STRING(x-linha - 1) + ")" ).
        chworksheet:range("l" + STRING(x-linha)):SetValue("=sum(l3"  + ":" + "l" + string(x-linha - 1) + ")" ).
        chworksheet:range("m" + STRING(x-linha)):SetValue("=sum(m3"  + ":" + "m" + string(x-linha - 1) + ")" ).
        chworksheet:range("n" + STRING(x-linha)):SetValue("=sum(n3"  + ":" + "n" + string(x-linha - 1) + ")" ).
        chworksheet:range("o" + STRING(x-linha)):SetValue("=sum(o3"  + ":" + "o" + string(x-linha - 1) + ")" ).




END PROCEDURE.







