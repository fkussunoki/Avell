DEFINE VAR h-prog AS HANDLE.
DEFINE VAR i-tot AS INTEGER.


DEFINE TEMP-TABLE tt-documentos
    FIELD cod-estabel   AS char
    FIELD serie         AS char
    FIELD nr-doc-fis    AS char
    FIELD cod-emitente  AS INTEGER
    FIELD it-codigo     AS char
    FIELD dt-emis-doc   AS DATE
    FIELD cfop          AS char
    field vl-bicms      like it-doc-fisc.vl-bicms-it
    field vl-icms       like it-doc-fisc.vl-icms-it
    field vl-bsubs      like it-doc-fisc.vl-bsubs-it
    field vl-icmsub     like it-doc-fisc.vl-icmsub-it
    field vl-icms-nt    like it-doc-fisc.vl-icmsnt-it
    field vl-icms-ou    like it-doc-fisc.vl-icmsou-it
    FIELD vl-total      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD cod-sit       AS CHAR.

DEFINE VAR m-linha AS INTEGER.

DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}


       chExcel:sheetsinNewWorkbook = 1.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="ICMS". /* Nome que ser‰ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:m1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:m1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:m1"):SetValue("ICMS").
       chWorkSheet:Range("A1:m1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:m1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat¸rio */
           chworksheet:range("A2:y2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("Estab").
           chworksheet:range("b" + STRING(m-linha)):SetValue("Serie").
           chworksheet:range("c" + STRING(m-linha)):SetValue("Nota").
           chworksheet:range("D" + STRING(m-linha)):SetValue("Emitente").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Item").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Dt.Emis").
           chworksheet:range("g" + STRING(m-linha)):SetValue("CFOP").
           chworksheet:range("h" + STRING(m-linha)):SetValue("Vlr.Base ICMS").
           chworksheet:range("i" + STRING(m-linha)):SetValue("Vlr.ICMS").
           chworksheet:range("j" + STRING(m-linha)):SetValue("Vlr.Base Subst").
           chworksheet:range("k" + STRING(m-linha)):SetValue("Vlr. ICMS").
           chworksheet:range("l" + STRING(m-linha)):SetValue("Vlr. Outros").
           chworksheet:range("m" + STRING(m-linha)):SetValue("Situacao").

        m-linha = m-linha + 1.

run utp/ut-acomp.p persistent set h-prog.


run pi-inicializar in h-prog(input "Gerando Dados").
FOR EACH doc-fiscal WHERE doc-fiscal.cod-estabel >= ""
                    AND   doc-fiscal.cod-estabel <= "zzzzzz"
                    AND   doc-fiscal.dt-emis-doc >= 01/01/2011
                    AND   doc-fiscal.dt-emis-doc <= 12/31/2011 BREAK BY doc-fiscal.cod-estabel
                                                                     BY doc-fiscal.dt-emis-doc
                                                                     BY doc-fiscal.nr-doc-fis:

    run pi-acompanhar in h-prog(input string("Estab: "  + doc-fiscal.cod-estabel + " " + string(doc-fiscal.dt-emis-doc) + " " + doc-fiscal.nr-doc-fis)).

    FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.cod-estabel = doc-fiscal.cod-estabel
                                 AND   it-doc-fisc.serie       = doc-fiscal.serie
                                 AND   it-doc-fisc.nr-doc-fis  = doc-fiscal.nr-doc-fis
                                 AND   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
                                 :

             CREATE tt-documentos.
             ASSIGN tt-documentos.cod-estabel            = it-doc-fisc.cod-estabel
                    tt-documentos.serie                  = it-doc-fisc.serie
                    tt-documentos.nr-doc-fis             = it-doc-fisc.nr-doc-fis
                    tt-documentos.cod-emitente           = it-doc-fisc.cod-emitente
                    tt-documentos.it-codigo              = it-doc-fisc.it-codigo
                    tt-documentos.dt-emis-doc            = doc-fiscal.dt-emis-doc
                    tt-documentos.cfop                   = doc-fiscal.cod-cfop
                    tt-documentos.vl-bicms               = it-doc-fisc.vl-bicms-it
                    tt-documentos.vl-icms                = it-doc-fisc.vl-icms-it
                    tt-documentos.vl-bsubs               = it-doc-fisc.vl-bsubs-it
                    tt-documentos.vl-icmsub              = it-doc-fisc.vl-icmsub-it
                    tt-documentos.vl-icms-nt             = it-doc-fisc.vl-icmsnt-it
                    tt-documentos.vl-icms-ou             = it-doc-fisc.vl-icmsou-it
                    tt-documentos.vl-total               = it-doc-fisc.vl-icms-it + it-doc-fisc.vl-icmsub-it  + it-doc-fisc.vl-icmsnt-it +  it-doc-fisc.vl-icmsou-it
                    .


             CASE it-doc-fisc.cd-trib-icm:

                 WHEN 1 THEN
                     ASSIGN tt-documentos.cod-sit = "Tributado".
                 WHEN 2 THEN
                     ASSIGN tt-documentos.cod-sit = "Isento".
                 WHEN 3 THEN
                     ASSIGN tt-documentos.cod-sit = "Outros".
                 WHEN 4 THEN
                     ASSIGN tt-documentos.cod-sit = "Reduzido".
                 WHEN 5 THEN
                     ASSIGN tt-documentos.cod-sit = "Diferido".


             END CASE.



    END.

END.

run pi-finalizar in h-prog.



FOR EACH tt-documentos WHERE tt-documentos.vl-total = 0:



    chworksheet:range("A" + STRING(m-linha)):SetValue(tt-documentos.cod-estabel).
    chworksheet:range("b" + STRING(m-linha)):SetValue(tt-documentos.serie).
    chworksheet:range("c" + STRING(m-linha)):SetValue(tt-documentos.nr-doc-fis).
    chworksheet:range("d" + STRING(m-linha)):SetValue(tt-documentos.cod-emitente).
    chworksheet:range("e" + STRING(m-linha)):SetValue(tt-documentos.it-codigo).
    chworksheet:range("f" + STRING(m-linha)):SetValue(tt-documentos.dt-emis-doc).
    chworksheet:range("g" + STRING(m-linha)):SetValue(tt-documentos.cfop).
    chworksheet:range("h" + STRING(m-linha)):SetValue(tt-documentos.vl-icms).
    chworksheet:range("i" + STRING(m-linha)):SetValue(tt-documentos.vl-bsubs).
    chworksheet:range("j" + STRING(m-linha)):SetValue(tt-documentos.vl-icmsub).
    chworksheet:range("k" + STRING(m-linha)):SetValue(tt-documentos.vl-icms-nt).
    chworksheet:range("l" + STRING(m-linha)):SetValue(tt-documentos.vl-icms-ou).
    chworksheet:range("m" + STRING(m-linha)):SetValue(tt-documentos.cod-sit).

    m-linha = m-linha + 1.



END.


   chExcel:Visible = true.

