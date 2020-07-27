
define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    FIELD cod-estab-ini        AS char
    FIELD cod-estab-fim        AS char
    FIELD cod-emitente-ini     AS INTEGER 
    FIELD cod-emitente-fim     AS INTEGER
    FIELD it-codigo-ini        AS CHAR
    FIELD it-codigo-fim        AS char
    FIELD natur-oper-ini       AS CHAR
    FIELD natur-oper-fim       AS char
    FIELD dt-emiss-ini         AS date
    FIELD dt-emiss-fim         AS date.



def temp-table tt-raw-digita
        field raw-digita    as raw.
/* recebimento de parmetros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.



DEFINE VAR h-prog AS HANDLE.
DEFINE BUFFER b-emitente FOR emitente.


DEFINE TEMP-TABLE tt-resumo
    FIELD ttv-uf             AS char
    FIELD ttv-origem         AS char
    FIELD ttv-vlr-original   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-base-icms  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-icms       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-base-st    AS dec FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-icms-st    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-natur-oper     AS char.


DEFINE VARIABLE  m-linha      AS INTEGER.
DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}


       chExcel:sheetsinNewWorkbook = 3.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="Saidas". /* Nome que ser¿ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:q1"):SetValue("ICMS ST").
       chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat÷rio */
           chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("CFOP").
           chworksheet:range("b" + STRING(m-linha)):SetValue("UF").
           chworksheet:range("c" + STRING(m-linha)):SetValue("Emissor").
           chworksheet:range("d" + STRING(m-linha)):SetValue("Descricao").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Cliente").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Descricao").
           chworksheet:range("g" + STRING(m-linha)):SetValue("UF").
           chworksheet:range("h" + STRING(m-linha)):SetValue("Contribuinte ICMS").
           chworksheet:range("i" + STRING(m-linha)):SetValue("Cod.Item").
           chworksheet:range("j" + STRING(m-linha)):SetValue("Descricao").
           chworksheet:range("k" + STRING(m-linha)):SetValue("Vlr. Original").
           chworksheet:range("l" + STRING(m-linha)):SetValue("Base ICMS").
           chworksheet:range("m" + STRING(m-linha)):SetValue("Vlr. ICMS").
           chworksheet:range("n" + STRING(m-linha)):SetValue("Aliquota ICMS").
           chworksheet:range("o" + STRING(m-linha)):SetValue("Base ICMS ST").
           chworksheet:range("p" + STRING(m-linha)):SetValue("Vlr. ICMS ST").
           chworksheet:range("q" + STRING(m-linha)):SetValue("Qtde").
           chworksheet:range("r" + STRING(m-linha)):SetValue("Nr. NF").
           chworksheet:range("s" + STRING(m-linha)):SetValue("Estabelecimento").
           chworksheet:range("t" + STRING(m-linha)):SetValue("Dt. Emissao").
           chworksheet:range("u" + STRING(m-linha)):SetValue("Origem").
           chworksheet:range("v" + STRING(m-linha)):SetValue("Natur.Oper").

          

           ASSIGN m-linha = m-linha + 1.

           RUN utp/ut-acomp.p PERSISTENT SET h-prog.
           RUN pi-saidas.
           RUN pi-entradas.
           RUN pi-resumo.
           RUN pi-finalizar IN h-prog.


           chexcel:VISIBLE = YES.

PROCEDURE pi-saidas:


          FIND FIRST tt-param NO-ERROR.

          RUN pi-inicializar IN h-prog (INPUT "Saidas").
          FOR EACH doc-fiscal FIELDS(doc-fiscal.cod-estabel doc-fiscal.cod-emitente doc-fiscal.nat-operacao doc-fiscal.dt-emis-doc) NO-LOCK WHERE doc-fiscal.cod-estabel  >= tt-param.cod-estab-ini
                                      AND   doc-fiscal.cod-estabel  <= tt-param.cod-estab-fim
                                      AND   doc-fiscal.cod-emitente >= tt-param.cod-emitente-ini
                                      AND   doc-fiscal.cod-emitente <= tt-param.cod-emitente-fim
                                      AND   doc-fiscal.nat-operacao >= tt-param.natur-oper-ini
                                      AND   doc-fiscal.nat-operacao <= tt-param.natur-oper-fim
                                      AND   doc-fiscal.dt-emis-doc  >= tt-param.dt-emiss-ini
                                      AND   doc-fiscal.dt-emis-doc  <= tt-param.dt-emiss-fim
                                      AND   doc-fiscal.ind-ori-doc  = 1 , //faturamento
              EACH it-doc-fisc FIELDS(it-doc-fisc.it-codigo it-doc-fisc.vl-merc-liq it-doc-fisc.vl-bicms-it it-doc-fisc.vl-icms-it it-doc-fisc.aliquota-icm
                                      it-doc-fisc.vl-bsubs-it it-doc-fisc.vl-icmsub-it it-doc-fisc.quantidade it-doc-fisc.nr-doc-fis
                                      it-doc-fisc.nat-operacao)NO-LOCK WHERE it-doc-fisc.cod-estabel    = doc-fiscal.cod-estabel
                                       AND   it-doc-fisc.serie          = doc-fiscal.serie
                                       AND   it-doc-fisc.cod-emitente   = doc-fiscal.cod-emitente
                                       AND   it-doc-fisc.nr-doc-fis     = doc-fiscal.nr-doc-fis
                                       :
                            

                   RUN pi-acompanhar IN h-prog (INPUT "NF " + doc-fiscal.nr-doc-fis + " Estab: " + doc-fiscal.cod-estabel + " Dt.Docto " + string(doc-fiscal.dt-emis-doc)).

                  FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = doc-fiscal.cod-estabel NO-ERROR.

                  FIND FIRST b-emitente WHERE b-emitente.cod-emitente   = doc-fiscal.cod-emitente NO-ERROR.

                  FIND FIRST ITEM WHERE ITEM.it-codigo = it-doc-fisc.it-codigo NO-ERROR.
              

              chworksheet:range("A" + STRING(m-linha)):SetValue(it-doc-fisc.nat-operacao).
              chworksheet:range("b" + STRING(m-linha)):SetValue(estabelec.estado).
              chworksheet:range("c" + STRING(m-linha)):SetValue(estabelec.cod-estabel).
              chworksheet:range("d" + STRING(m-linha)):SetValue(estabelec.nome).
              chworksheet:range("e" + STRING(m-linha)):SetValue(b-emitente.cod-emitente).
              chworksheet:range("f" + STRING(m-linha)):SetValue(b-emitente.nome-emit).
              chworksheet:range("g" + STRING(m-linha)):SetValue(b-emitente.estado).
              chworksheet:range("h" + STRING(m-linha)):SetValue(b-emitente.contrib-icms).
              chworksheet:range("i" + STRING(m-linha)):SetValue(it-doc-fisc.it-codigo).
              chworksheet:range("j" + STRING(m-linha)):SetValue(item.descricao-1).
              chworksheet:range("k" + STRING(m-linha)):SetValue(it-doc-fisc.vl-merc-liq).
              chworksheet:range("l" + STRING(m-linha)):SetValue(it-doc-fisc.vl-bicms-it).
              chworksheet:range("m" + STRING(m-linha)):SetValue(it-doc-fisc.vl-icms-it).
              chworksheet:range("n" + STRING(m-linha)):SetValue(it-doc-fisc.aliquota-icm).
              chworksheet:range("o" + STRING(m-linha)):SetValue(it-doc-fisc.vl-bsubs-it).
              chworksheet:range("p" + STRING(m-linha)):SetValue(it-doc-fisc.vl-icmsub-it).
              chworksheet:range("q" + STRING(m-linha)):SetValue(it-doc-fisc.quantidade).
              chworksheet:range("r" + STRING(m-linha)):SetValue(it-doc-fisc.nr-doc-fis).
              chworksheet:range("s" + STRING(m-linha)):SetValue(doc-fiscal.cod-estabel).
              chworksheet:range("t" + STRING(m-linha)):SetValue(doc-fiscal.dt-emis-doc).
              chworksheet:range("u" + STRING(m-linha)):SetValue("Faturamento").
              chworksheet:range("v" + STRING(m-linha)):SetValue(it-doc-fisc.nat-operacao).



              CREATE tt-resumo.
              ASSIGN tt-resumo.ttv-uf                   = b-emitente.estado
                     tt-resumo.ttv-origem               = "Faturamento"
                     tt-resumo.ttv-vlr-original         = it-doc-fisc.vl-merc-liq
                     tt-resumo.ttv-vlr-base-icms        = it-doc-fisc.vl-bicms-it
                     tt-resumo.ttv-vlr-icms             = it-doc-fisc.vl-icms-it
                     tt-resumo.ttv-vlr-base-st          = it-doc-fisc.vl-bsubs-it
                     tt-resumo.ttv-vlr-icms-st          = it-doc-fisc.vl-icmsub-it
                     tt-resumo.ttv-natur-oper           = it-doc-fisc.nat-operacao.

              ASSIGN m-linha = m-linha + 1.

          END.

ASSIGN m-linha = m-linha + 1.
END PROCEDURE.


PROCEDURE pi-entradas:

    chworksheet=chWorkBook:sheets:item(2).
    chworksheet:name="Entradas". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:q1"):SetValue("ICMS ST").
    chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):SetValue("CFOP").
        chworksheet:range("b" + STRING(m-linha)):SetValue("UF").
        chworksheet:range("c" + STRING(m-linha)):SetValue("Emissor").
        chworksheet:range("d" + STRING(m-linha)):SetValue("Descricao").
        chworksheet:range("e" + STRING(m-linha)):SetValue("Cliente").
        chworksheet:range("f" + STRING(m-linha)):SetValue("Descricao").
        chworksheet:range("g" + STRING(m-linha)):SetValue("UF").
        chworksheet:range("h" + STRING(m-linha)):SetValue("Contribuinte ICMS").
        chworksheet:range("i" + STRING(m-linha)):SetValue("Cod.Item").
        chworksheet:range("j" + STRING(m-linha)):SetValue("Descricao").
        chworksheet:range("k" + STRING(m-linha)):SetValue("Vlr. Original").
        chworksheet:range("l" + STRING(m-linha)):SetValue("Base ICMS").
        chworksheet:range("m" + STRING(m-linha)):SetValue("Vlr. ICMS").
        chworksheet:range("n" + STRING(m-linha)):SetValue("Aliquota ICMS").
        chworksheet:range("o" + STRING(m-linha)):SetValue("Base ICMS ST").
        chworksheet:range("p" + STRING(m-linha)):SetValue("Vlr. ICMS ST").
        chworksheet:range("q" + STRING(m-linha)):SetValue("Qtde").
        chworksheet:range("r" + STRING(m-linha)):SetValue("Nr. NF").
        chworksheet:range("s" + STRING(m-linha)):SetValue("Estabelecimento").
        chworksheet:range("t" + STRING(m-linha)):SetValue("Dt. Emissao").
        chworksheet:range("u" + STRING(m-linha)):SetValue("Origem").
        chworksheet:range("v" + STRING(m-linha)):SetValue("Natur.Oper").

        ASSIGN m-linha = m-linha + 1.

    FIND FIRST tt-param NO-ERROR.
    RUN pi-inicializar IN h-prog (INPUT "Entradas").

    FOR EACH doc-fiscal FIELDS(doc-fiscal.cod-estabel doc-fiscal.cod-emitente doc-fiscal.nat-operacao doc-fiscal.dt-emis-doc) NO-LOCK WHERE doc-fiscal.cod-estabel  >= tt-param.cod-estab-ini
                                AND   doc-fiscal.cod-estabel  <= tt-param.cod-estab-fim
                                AND   doc-fiscal.cod-emitente >= tt-param.cod-emitente-ini
                                AND   doc-fiscal.cod-emitente <= tt-param.cod-emitente-fim
                                AND   doc-fiscal.nat-operacao >= tt-param.natur-oper-ini
                                AND   doc-fiscal.nat-operacao <= tt-param.natur-oper-fim
                                AND   doc-fiscal.dt-emis-doc  >= tt-param.dt-emiss-ini
                                AND   doc-fiscal.dt-emis-doc  <= tt-param.dt-emiss-fim
                                AND   doc-fiscal.ind-ori-doc  = 2 , //recebimento
        EACH it-doc-fisc FIELDS(it-doc-fisc.it-codigo it-doc-fisc.vl-merc-liq it-doc-fisc.vl-bicms-it it-doc-fisc.vl-icms-it it-doc-fisc.aliquota-icm
                                it-doc-fisc.vl-bsubs-it it-doc-fisc.vl-icmsub-it it-doc-fisc.quantidade it-doc-fisc.nr-doc-fis
                                it-doc-fisc.nat-operacao)NO-LOCK WHERE it-doc-fisc.cod-estabel    = doc-fiscal.cod-estabel
                                 AND   it-doc-fisc.serie          = doc-fiscal.serie
                                 AND   it-doc-fisc.cod-emitente   = doc-fiscal.cod-emitente
                                 AND   it-doc-fisc.nr-doc-fis     = doc-fiscal.nr-doc-fis:


        RUN pi-acompanhar IN h-prog (INPUT "NF " + doc-fiscal.nr-doc-fis + " Estab: " + doc-fiscal.cod-estabel + " Dt.Docto " + string(doc-fiscal.dt-emis-doc)).


            FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = doc-fiscal.cod-estabel NO-ERROR.

            FIND FIRST b-emitente WHERE b-emitente.cod-emitente   = doc-fiscal.cod-emitente NO-ERROR.

            FIND FIRST ITEM WHERE ITEM.it-codigo = it-doc-fisc.it-codigo NO-ERROR.


        chworksheet:range("A" + STRING(m-linha)):SetValue(it-doc-fisc.nat-operacao).
        chworksheet:range("b" + STRING(m-linha)):SetValue(estabelec.estado).
        chworksheet:range("c" + STRING(m-linha)):SetValue(estabelec.cod-estabel).
        chworksheet:range("d" + STRING(m-linha)):SetValue(estabelec.nome).
        chworksheet:range("e" + STRING(m-linha)):SetValue(b-emitente.cod-emitente).
        chworksheet:range("f" + STRING(m-linha)):SetValue(b-emitente.nome-emit).
        chworksheet:range("g" + STRING(m-linha)):SetValue(b-emitente.estado).
        chworksheet:range("h" + STRING(m-linha)):SetValue(b-emitente.contrib-icms).
        chworksheet:range("i" + STRING(m-linha)):SetValue(it-doc-fisc.it-codigo).
        chworksheet:range("j" + STRING(m-linha)):SetValue(item.descricao-1).
        chworksheet:range("k" + STRING(m-linha)):SetValue(it-doc-fisc.vl-merc-liq).
        chworksheet:range("l" + STRING(m-linha)):SetValue(it-doc-fisc.vl-bicms-it).
        chworksheet:range("m" + STRING(m-linha)):SetValue(it-doc-fisc.vl-icms-it).
        chworksheet:range("n" + STRING(m-linha)):SetValue(it-doc-fisc.aliquota-icm).
        chworksheet:range("o" + STRING(m-linha)):SetValue(it-doc-fisc.vl-bsubs-it).
        chworksheet:range("p" + STRING(m-linha)):SetValue(it-doc-fisc.vl-icmsub-it).
        chworksheet:range("q" + STRING(m-linha)):SetValue(it-doc-fisc.quantidade).
        chworksheet:range("r" + STRING(m-linha)):SetValue(it-doc-fisc.nr-doc-fis).
        chworksheet:range("s" + STRING(m-linha)):SetValue(doc-fiscal.cod-estabel).
        chworksheet:range("t" + STRING(m-linha)):SetValue(doc-fiscal.dt-emis-doc).
        chworksheet:range("u" + STRING(m-linha)):SetValue("Recebimento").

        CREATE tt-resumo.
        ASSIGN tt-resumo.ttv-uf                   = b-emitente.estado
               tt-resumo.ttv-origem               = "Recebimento"
               tt-resumo.ttv-vlr-original         = it-doc-fisc.vl-merc-liq
               tt-resumo.ttv-vlr-base-icms        = it-doc-fisc.vl-bicms-it
               tt-resumo.ttv-vlr-icms             = it-doc-fisc.vl-icms-it
               tt-resumo.ttv-vlr-base-st          = it-doc-fisc.vl-bsubs-it
               tt-resumo.ttv-vlr-icms-st          = it-doc-fisc.vl-icmsub-it
               tt-resumo.ttv-natur-oper           = it-doc-fisc.nat-operacao.


        ASSIGN m-linha = m-linha + 1.

    END.

ASSIGN m-linha = m-linha + 1.
END PROCEDURE.


PROCEDURE pi-resumo:

    chworksheet=chWorkBook:sheets:item(3).
    chworksheet:name="Resumo". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
    chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
    chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */
    chworksheet:range("A1:q1"):SetValue("ICMS ST").
    chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
    chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
  /* Cria os titulos para as colunas do relat÷rio */
        chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
        chworksheet:range("A" + STRING(m-linha)):SetValue("Origem").
        chworksheet:range("b" + STRING(m-linha)):SetValue("UF").
        chworksheet:range("c" + STRING(m-linha)):SetValue("Nat.Oper").
        chworksheet:range("d" + STRING(m-linha)):SetValue("Vlr.Original").
        chworksheet:range("e" + STRING(m-linha)):SetValue("Vlr. Base ICMS").
        chworksheet:range("f" + STRING(m-linha)):SetValue("Vlr. ICMS").
        chworksheet:range("g" + STRING(m-linha)):SetValue("Vlr. Base ICMS ST").
        chworksheet:range("h" + STRING(m-linha)):SetValue("Vlr. ICMS ST").
        ASSIGN m-linha = m-linha + 1.


        RUN pi-inicializar IN h-prog (INPUT "Resumo").
    FOR EACH tt-resumo BREAK BY ttv-origem + ttv-uf + ttv-natur-oper:

        RUN pi-acompanhar IN h-prog(INPUT tt-resumo.ttv-origem + " UF " + tt-resumo.ttv-uf).
        ACCUMULATE tt-resumo.ttv-vlr-original  (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).
        ACCUMULATE tt-resumo.ttv-vlr-base-icms (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).
        ACCUMULATE tt-resumo.ttv-vlr-icms      (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).
        ACCUMULATE tt-resumo.ttv-vlr-base-st   (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).
        ACCUMULATE tt-resumo.ttv-vlr-icms-st   (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).

    IF LAST-OF(tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper) THEN DO:
        
        chworksheet:range("A" + STRING(m-linha)):SetValue(tt-resumo.ttv-origem).
        chworksheet:range("b" + STRING(m-linha)):SetValue(tt-resumo.ttv-uf).
        chworksheet:range("c" + STRING(m-linha)):SetValue(tt-resumo.ttv-natur-oper).
        chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-original).
        chworksheet:range("e" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-base-icms).
        chworksheet:range("f" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-icms).
        chworksheet:range("g" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-base-st).
        chworksheet:range("h" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-icms-st).
ASSIGN m-linha = m-linha + 1.


    END.




    END.


    
END PROCEDURE.



