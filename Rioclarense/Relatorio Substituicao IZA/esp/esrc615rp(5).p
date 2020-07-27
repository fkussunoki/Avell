
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


DEFINE TEMP-TABLE tt-controle 
    FIELD ttv-cod-estab     AS char
    FIELD ttv-it-codigo     AS char
    FIELD ttv-lote          AS char
    FIELD ttv-cod-emitente  AS INTEGER
    FIELD ttv-nr-nota-fis   AS char
    FIELD ttv-serie         AS CHAR
    field ttv-vl-bsubs-it   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"  
    field ttv-vl-icmsub-it  AS dec FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"  
    field ttv-qtde          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".  

DEFINE VARIABLE v-base-st   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEFINE VARIABLE v-vlr-st    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEFINE VARIABLE v-qtde      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".

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



          FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel            >= tt-param.cod-estab-ini
                                       AND   nota-fiscal.cod-estabel            <= tt-param.cod-estab-fim
                                       AND   nota-fiscal.cod-emitente           >= tt-param.cod-emitente-ini
                                       AND   nota-fiscal.cod-emitente           <= tt-param.cod-emitente-fim
                                       AND   nota-fiscal.nat-operacao           >= tt-param.natur-oper-ini
                                       AND   nota-fiscal.nat-operacao           <= tt-param.natur-oper-fim
                                       AND   nota-fiscal.dt-emis-nota           >= tt-param.dt-emiss-ini
                                       AND   nota-fiscal.dt-emis-nota           <= tt-param.dt-emiss-fim
                                       AND   nota-fiscal.idi-sit-nf-eletro      = 3 
                                       AND   nota-fiscal.ind-sit-nota           <> 4 BREAK BY nota-fiscal.cod-estabel BY nota-fiscal.dt-emis-nota:

              FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                            AND   it-nota-fisc.serie       = nota-fiscal.serie
                                            AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                                            AND   it-nota-fisc.cd-emitente = nota-fiscal.cod-emitente:


                  FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
                  FIND FIRST emitente  NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                  FIND FIRST ITEM      NO-LOCK WHERE ITEM.it-codigo        = it-nota-fisc.it-codigo NO-ERROR.

                  FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

                  IF (natur-oper.cod-cfop = "5403" 
                  OR natur-oper.cod-cfop = "6403") THEN DO:

                      FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel      = it-nota-fisc.cod-estabel
                                                     AND   movto-estoq.it-codigo      = it-nota-fisc.it-codigo
                                                     AND   movto-estoq.nro-docto      = it-nota-fisc.nr-nota-fis
                                                     AND   movto-estoq.serie-docto    = it-nota-fisc.serie
                                                     AND   movto-estoq.cod-emitente   = it-nota-fisc.cd-emitente
                                                     AND   movto-estoq.dt-trans       = it-nota-fisc.dt-emis-nota
                                                     AND   movto-estoq.nat-operacao   = it-nota-fisc.nat-operacao
                                                     AND   movto-estoq.esp-docto      = 22:

                      RUN pi-acompanhar IN h-prog (INPUT "Movto Estoq " + string(movto-estoq.dt-trans) + " It-codigo " + movto-estoq.it-codigo + " Estab " + movto-estoq.cod-estabel).
                                                     
                      
                      FIND FIRST tt-controle WHERE tt-controle.ttv-cod-estab     = movto-estoq.cod-estabel
                                             AND   tt-controle.ttv-it-codigo     = movto-estoq.it-codigo
                                             AND   tt-controle.ttv-lote          = movto-estoq.lote
                                             AND   tt-controle.ttv-cod-emitente  = movto-estoq.cod-emitente
                                             AND   tt-controle.ttv-nr-nota-fis   = movto-estoq.nro-docto
                                             AND   tt-controle.ttv-serie         = movto-estoq.serie-docto NO-ERROR.

                      IF NOT AVAIL tt-controle THEN DO:
                          
                      
                      
                      CREATE tt-controle.
                      ASSIGN tt-controle.ttv-cod-estab          = movto-estoq.cod-estabel
                             tt-controle.ttv-it-codigo          = movto-estoq.it-codigo
                             tt-controle.ttv-lote               = movto-estoq.lote
                             tt-controle.ttv-cod-emitente       = movto-estoq.cod-emitente
                             tt-controle.ttv-nr-nota-fis        = movto-estoq.nro-docto
                             tt-controle.ttv-serie              = movto-estoq.serie-docto
                             tt-controle.ttv-vl-bsubs-it        = it-nota-fisc.vl-bsubs-it
                             tt-controle.ttv-vl-icmsub-it       = it-nota-fisc.vl-icmsub-it
                             tt-controle.ttv-qtde               = (it-nota-fisc.qt-faturada[1]).



                  END.
            END.
          END.

          RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(nota-fiscal.dt-emis-nota) + " Estab " + nota-fiscal.cod-estabel + " NF " + nota-fiscal.nr-nota-fis).


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
        chworksheet:range("e" + STRING(m-linha)):SetValue("Fornec").
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
        chworksheet:range("w" + STRING(m-linha)):SetValue("Lote").
        chworksheet:range("x" + STRING(m-linha)):SetValue("Cliente").
        chworksheet:range("y" + STRING(m-linha)):SetValue("NF").
        chworksheet:range("z" + STRING(m-linha)):SetValue("Vlr ST").
        chworksheet:range("aa" + STRING(m-linha)):SetValue("Qtde").


        ASSIGN m-linha = m-linha + 1.

    RUN pi-inicializar IN h-prog (INPUT "Entradas").


    FOR EACH tt-controle BREAK BY tt-controle.ttv-cod-estab +     
                                  tt-controle.ttv-it-codigo +     
                                  tt-controle.ttv-lote           
        : 

        ACCUMULATE ttv-vl-bsubs-it (SUB-TOTAL BY tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote). 
        ACCUMULATE ttv-vl-icmsub-it(SUB-TOTAL BY tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote).  
        ACCUMULATE ttv-qtde        (SUB-TOTAL BY tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote).


        IF FIRST-OF (tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote) THEN DO:
        ASSIGN v-base-st = 0
               v-vlr-st  = 0
               v-qtde    = 0.
        END.

        IF LAST-OF (tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote) THEN DO:

            ASSIGN v-base-st = ACCUM SUB-TOTAL BY (tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote) ttv-vl-bsubs-it
                   v-vlr-st  = ACCUM SUB-TOTAL BY (tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote) ttv-vl-icmsub-it 
                   v-qtde    = ACCUM SUB-TOTAL BY (tt-controle.ttv-cod-estab + tt-controle.ttv-it-codigo + tt-controle.ttv-lote) ttv-qtde. 

        FIND FIRST movto-estoq NO-LOCK WHERE movto-estoq.it-codigo = tt-controle.ttv-it-codigo
                                     AND   movto-estoq.lote      = tt-controle.ttv-lote
                                     AND   movto-estoq.esp-docto = 21 NO-ERROR.
                                     

            RUN pi-acompanhar IN h-prog (INPUT "Movto Estoq " + string(movto-estoq.dt-trans) + " It-codigo " + movto-estoq.it-codigo + " Estab " + movto-estoq.cod-estabel).

    
            FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = movto-estoq.cod-emitente                       
                                          AND   item-doc-est.nro-docto    = movto-estoq.nro-docto                         
                                          AND   item-doc-est.serie-docto  = movto-estoq.serie-docto
                                          AND   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                          AND   item-doc-est.it-codigo    = movto-estoq.it-codigo
                                          AND   item-doc-est.lote         = movto-estoq.lote
                                          :

                RUN pi-acompanhar IN h-prog (INPUT "It-codigo " + item-doc-est.it-codigo + " Emitente " + string(item-doc-est.cod-emitente) + " NF " + item-doc-est.nro-docto + " Serie " + item-doc-est.serie-docto).


            FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-ERROR.

            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente   = movto-estoq.cod-emitente NO-ERROR.

            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

            ASSIGN v-vlr-st = v-vlr-st - item-doc-est.vl-subs[1]
                   v-qtde   = v-qtde   - item-doc-est.quantidade.


        chworksheet:range("A" + STRING(m-linha)):SetValue(item-doc-est.nat-operacao).
        chworksheet:range("b" + STRING(m-linha)):SetValue(estabelec.estado).
        chworksheet:range("c" + STRING(m-linha)):SetValue(estabelec.cod-estabel).
        chworksheet:range("d" + STRING(m-linha)):SetValue(estabelec.nome).
        chworksheet:range("e" + STRING(m-linha)):SetValue(item-doc-est.cod-emitente).
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
        chworksheet:range("s" + STRING(m-linha)):SetValue(estabelec.cod-estabel).
        chworksheet:range("t" + STRING(m-linha)):SetValue(movto-estoq.dt-trans).
        chworksheet:range("u" + STRING(m-linha)):SetValue("Recebimento").
        chworksheet:range("v" + STRING(m-linha)):SetValue(tt-controle.ttv-lote).
        chworksheet:range("w" + STRING(m-linha)):SetValue(tt-controle.ttv-cod-emitente).   
        chworksheet:range("x" + STRING(m-linha)):SetValue(tt-controle.ttv-nr-nota-fis).    
        chworksheet:range("y" + STRING(m-linha)):SetValue(tt-controle.ttv-serie).          
        chworksheet:range("z" + STRING(m-linha)):SetValue(v-vlr-st).          
        chworksheet:range("aa" + STRING(m-linha)):SetValue(v-qtde).          



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



