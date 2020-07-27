
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


              
          FOR EACH natur-oper WHERE natur-oper.tipo = 2
                               AND  natur-oper.nat-operacao              >= tt-param.natur-oper-ini
                               AND  natur-oper.nat-operacao              <= tt-param.natur-oper-fim:
          FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota  >= tt-param.dt-emiss-ini                         
                                        AND   it-nota-fisc.dt-emis-nota  <= tt-param.dt-emiss-fim                         
                                        AND   it-nota-fisc.nat-operacao  =  natur-oper.nat-operacao                        
                                        AND   it-nota-fisc.cod-estabel   >= tt-param.cod-estab-ini                        
                                        AND   it-nota-fisc.cod-estabel   <= tt-param.cod-estab-fim                        
                                        AND   it-nota-fisc.it-codigo     >= tt-param.it-codigo-ini                        
                                        AND   it-nota-fisc.it-codigo     <= tt-param.it-codigo-fim                        
                                        AND   it-nota-fisc.cd-emitente   >= tt-param.cod-emitente-ini                     
                                        AND   it-nota-fisc.cd-emitente   <= tt-param.cod-emitente-fim:                    
                                                                                                                         

              FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                             AND   nota-fiscal.serie       = it-nota-fisc.serie
                                             AND   nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                             AND   nota-fiscal.nome-ab-cli = it-nota-fisc.nome-ab-cli
          /*                                    AND   nota-fiscal.nat-operacao = it-nota-fisc.nat-operacao */
                                             AND   nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR. /* uso autorizado */

              IF AVAIL nota-fiscal THEN DO:

                  FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
                  FIND FIRST emitente  NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                  FIND FIRST ITEM      NO-LOCK WHERE ITEM.it-codigo        = it-nota-fisc.it-codigo NO-ERROR.



          RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(it-nota-fisc.dt-emis-nota)).


              chworksheet:range("A" + STRING(m-linha)):SetValue(it-nota-fisc.nat-operacao).
              chworksheet:range("b" + STRING(m-linha)):SetValue(estabelec.estado).
              chworksheet:range("c" + STRING(m-linha)):SetValue(it-nota-fisc.cod-estabel).
              chworksheet:range("d" + STRING(m-linha)):SetValue(estabelec.nome).
              chworksheet:range("e" + STRING(m-linha)):SetValue(nota-fiscal.cod-emitente).
              chworksheet:range("f" + STRING(m-linha)):SetValue(emitente.nome-abrev).
              chworksheet:range("g" + STRING(m-linha)):SetValue(emitente.estado).
              chworksheet:range("h" + STRING(m-linha)):SetValue(emitente.contrib-icms).
              chworksheet:range("i" + STRING(m-linha)):SetValue(it-nota-fisc.it-codigo).
              chworksheet:range("j" + STRING(m-linha)):SetValue(item.descricao-1).
              chworksheet:range("k" + STRING(m-linha)):SetValue(it-nota-fisc.vl-tot-item).
              chworksheet:range("l" + STRING(m-linha)):SetValue(it-nota-fisc.vl-bicms-it).
              chworksheet:range("m" + STRING(m-linha)):SetValue(it-nota-fisc.vl-icms-it).
              chworksheet:range("n" + STRING(m-linha)):SetValue(it-nota-fisc.aliquota-icm).
              chworksheet:range("o" + STRING(m-linha)):SetValue(it-nota-fisc.vl-bsubs-it).
              chworksheet:range("p" + STRING(m-linha)):SetValue(it-nota-fisc.vl-icmsub-it).
              chworksheet:range("q" + STRING(m-linha)):SetValue(it-nota-fisc.qt-faturada[1]).
              chworksheet:range("r" + STRING(m-linha)):SetValue(it-nota-fisc.nr-nota-fis).
              chworksheet:range("s" + STRING(m-linha)):SetValue(it-nota-fisc.cod-estabel).
              chworksheet:range("t" + STRING(m-linha)):SetValue(nota-fiscal.dt-emis-nota).
              chworksheet:range("u" + STRING(m-linha)):SetValue("Faturamento").
              chworksheet:range("v" + STRING(m-linha)):SetValue(it-nota-fisc.nat-operacao).



              CREATE tt-resumo.
              ASSIGN tt-resumo.ttv-uf                   = emitente.estado
                     tt-resumo.ttv-origem               = "Faturamento"
                     tt-resumo.ttv-vlr-original         = it-nota-fisc.vl-tot-item
                     tt-resumo.ttv-vlr-base-icms        = it-nota-fisc.vl-bicms-it
                     tt-resumo.ttv-vlr-icms             = it-nota-fisc.vl-icms-it
                     tt-resumo.ttv-vlr-base-st          = it-nota-fisc.vl-bsubs-it
                     tt-resumo.ttv-vlr-icms-st          = it-nota-fisc.vl-bsubs-it
                     tt-resumo.ttv-natur-oper           = it-nota-fisc.nat-operacao.

              ASSIGN m-linha = m-linha + 1.

          END.

ASSIGN m-linha = m-linha + 1.
    END.
END.
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

    FOR EACH natur-oper NO-LOCK WHERE natur-oper.tipo = 1:
    
        FOR EACH docum-est NO-LOCK WHERE docum-est.dt-trans >= tt-param.dt-emiss-ini                                                     
                                   AND   docum-est.dt-trans <= tt-param.dt-emiss-fim                                                     
                                   AND   docum-est.nat-operacao = natur-oper.nat-operacao                                 
                                   AND   docum-est.cod-estabel >= tt-param.cod-estab-ini                                              
                                   AND   docum-est.cod-estabel <= tt-param.cod-estab-fim
                                   AND   docum-est.cod-emitente >= tt-param.cod-emitente-ini
                                   AND   docum-est.cod-emitente <= tt-param.cod-emitente-fim
                                   :                                                                                       
                                                                                                                           
            FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = docum-est.cod-emitente                       
                                          AND   item-doc-est.nro-docto    = docum-est.nro-docto                         
                                          AND   item-doc-est.serie-docto  = docum-est.serie-docto
                                          AND   item-doc-est.nat-operacao = docum-est.nat-operacao
                                          AND   item-doc-est.it-codigo    >= tt-param.it-codigo-ini  
                                          AND   item-doc-est.it-codigo    <= tt-param.it-codigo-fim 
                                          :

                RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(docum-est.dt-emissao)).




        RUN pi-acompanhar IN h-prog (INPUT "NF " + docum-est.nro-docto + " Estab: " + docum-est.cod-estabel + " Dt.Docto " + string(docum-est.dt-emissao)).


            FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.

            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente   = docum-est.cod-emitente NO-ERROR.

            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


        chworksheet:range("A" + STRING(m-linha)):SetValue(item-doc-est.nat-operacao).
        chworksheet:range("b" + STRING(m-linha)):SetValue(estabelec.estado).
        chworksheet:range("c" + STRING(m-linha)):SetValue(estabelec.cod-estabel).
        chworksheet:range("d" + STRING(m-linha)):SetValue(estabelec.nome).
        chworksheet:range("e" + STRING(m-linha)):SetValue(docum-est.cod-emitente).
        chworksheet:range("f" + STRING(m-linha)):SetValue(emitente.nome-emit).
        chworksheet:range("g" + STRING(m-linha)):SetValue(emitente.estado).
        chworksheet:range("h" + STRING(m-linha)):SetValue(emitente.contrib-icms).
        chworksheet:range("i" + STRING(m-linha)):SetValue(item-doc-est.it-codigo).
        chworksheet:range("j" + STRING(m-linha)):SetValue(item.descricao-1).
        chworksheet:range("k" + STRING(m-linha)):SetValue(item-doc-est.preco-unit[1] * item-doc-est.quantidade).
        chworksheet:range("l" + STRING(m-linha)):SetValue(item-doc-est.base-icm[1]).
        chworksheet:range("m" + STRING(m-linha)):SetValue(item-doc-est.valor-icm[1]).
        chworksheet:range("n" + STRING(m-linha)):SetValue(item-doc-est.aliquota-icm).
        chworksheet:range("o" + STRING(m-linha)):SetValue(item-doc-est.base-subs[1]).
        chworksheet:range("p" + STRING(m-linha)):SetValue(item-doc-est.vl-subs[1]).
        chworksheet:range("q" + STRING(m-linha)):SetValue(item-doc-est.quantidade).
        chworksheet:range("r" + STRING(m-linha)):SetValue(item-doc-est.nro-docto).
        chworksheet:range("s" + STRING(m-linha)):SetValue(docum-est.cod-estabel).
        chworksheet:range("t" + STRING(m-linha)):SetValue(docum-est.dt-emissao).
        chworksheet:range("u" + STRING(m-linha)):SetValue("Recebimento").

        CREATE tt-resumo.
        ASSIGN tt-resumo.ttv-uf                   = emitente.estado
               tt-resumo.ttv-origem               = "Recebimento"
               tt-resumo.ttv-vlr-original         = (item-doc-est.preco-unit[1] * item-doc-est.quantidade)
               tt-resumo.ttv-vlr-base-icms        = item-doc-est.base-icm[1]
               tt-resumo.ttv-vlr-icms             = item-doc-est.valor-icm[1]
               tt-resumo.ttv-vlr-base-st          = item-doc-est.base-subs[1]
               tt-resumo.ttv-vlr-icms-st          = item-doc-est.vl-subs[1]
               tt-resumo.ttv-natur-oper           = item-doc-est.nat-operacao.


        ASSIGN m-linha = m-linha + 1.

        END.
    END.
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



