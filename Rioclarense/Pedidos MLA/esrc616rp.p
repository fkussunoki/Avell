
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
    FIELD dt-emiss-ini         AS date
    FIELD dt-emiss-fim         AS date
    FIELD cod-estab-ini        AS char
    FIELD cod-estab-fim        AS char.



/* def temp-table tt-raw-digita                  */
/*         field raw-digita    as raw.           */
/* /* recebimento de parmetros */               */
/* def input parameter raw-param as raw no-undo. */
/* def input parameter TABLE for tt-raw-digita.  */
/* create tt-param.                              */
/* RAW-TRANSFER raw-param to tt-param.           */


CREATE tt-param.
ASSIGN tt-param.dt-emiss-ini = 01/01/2019
       tt-param.dt-emiss-fim = 03/31/2019
       tt-param.cod-estab-ini = "101"
       tt-param.cod-estab-fim = "103".


DEFINE VAR h-prog AS HANDLE.
DEFINE BUFFER b-emitente FOR emitente.


DEFINE TEMP-TABLE tt-pedidos 
    FIELD ttv-num-pedido AS INTEGER
    FIELD ttv-num-emitente AS INTEGER
    FIELD ttv-it-codigo AS CHARACTER
    FIELD ttv-dt-emiss  AS date
    FIELD ttv-cod-establ AS char
    FIELD ttv-cod-empresa AS char
    INDEX PRIMARY ttv-num-pedido.

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
/* {office/office.i Excel chExcel}                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*        chExcel:sheetsinNewWorkbook = 2.                                                                      */
/*        chWorkbook = chExcel:Workbooks:ADD().                                                                 */
/*        chworksheet=chWorkBook:sheets:item(1).                                                                */
/*        chworksheet:name="Saidas". /* Nome que ser¿ criada a Pasta da Planilha */                             */
/*        m-linha = 2.                                                                                          */
/*        chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */                        */
/*        chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */              */
/*        chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */                                   */
/*        chworksheet:range("A1:q1"):SetValue("ICMS ST").                                                       */
/*        chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */                         */
/*        chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */               */
/*      /* Cria os titulos para as colunas do relat÷rio */                                                      */
/*            chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */ */
/*            chworksheet:range("A" + STRING(m-linha)):SetValue("NF").                                          */
/*            chworksheet:range("b" + STRING(m-linha)):SetValue("Serie").                                       */
/*            chworksheet:range("c" + STRING(m-linha)):SetValue("Natur Oper").                                  */
/*            chworksheet:range("d" + STRING(m-linha)):SetValue("Cod.Emitente").                                */
/*            chworksheet:range("e" + STRING(m-linha)):SetValue("Descricao").                                   */
/*            chworksheet:range("f" + STRING(m-linha)):SetValue("It-Codigo").                                   */
/*            chworksheet:range("g" + STRING(m-linha)):SetValue("Descricao").                                   */
/*            chworksheet:range("h" + STRING(m-linha)):SetValue("Dt. Transacao").                               */
/*            chworksheet:range("i" + STRING(m-linha)):SetValue("Dt. Emissao").                                 */
/*            chworksheet:range("j" + STRING(m-linha)):SetValue("Pedido").                                      */
/*            chworksheet:range("k" + STRING(m-linha)):SetValue("Aprovado MLA").                                */
/*            chworksheet:range("l" + STRING(m-linha)):SetValue("Aprovador").                                   */
/*            chworksheet:range("m" + STRING(m-linha)):SetValue("Vlr. Item").                                   */
/*            ASSIGN m-linha = m-linha + 1.                                                                     */

           RUN utp/ut-acomp.p PERSISTENT SET h-prog.


OUTPUT TO c:\desenv\recebimento.txt.          
PUT UNFORMATTED "NF | Serie | NaturOper | CodEmitente | Descricao | ItCodigo | Descricao | Dt.Trans | Dt. Emissao | Pedido | Aprovador MLA | Aprovador | Vlr Item" SKIP.
RUN pi-recebimento.
OUTPUT CLOSE.

OUTPUT TO c:\desenv\pedidos.txt.          
RUN pi-pedidos.
OUTPUT CLOSE.

          RUN pi-finalizar IN h-prog.


PROCEDURE pi-recebimento:
           FIND FIRST tt-param NO-ERROR.

           RUN pi-inicializar IN h-prog (INPUT "Recebimento").
           
           FOR EACH docum-est NO-LOCK WHERE docum-est.dt-trans >= tt-param.dt-emiss-ini
                                      AND   docum-est.dt-trans <= tt-param.dt-emiss-fim
                                      AND   docum-est.ap-atual = YES
                                      AND   docum-est.cod-estabel >= tt-param.cod-estab-ini
                                      AND   docum-est.cod-estabel <= tt-param.cod-estab-fim,
               EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
                                         AND   item-doc-est.nro-docto    = docum-est.nro-docto
                                         AND   item-doc-est.serie-docto  = docum-est.serie-docto BREAK BY docum-est.cod-estabel BY docum-est.dt-trans
                                         :
               RUN pi-acompanhar IN h-prog(INPUT "Estab " + docum-est.cod-estabel + " Docto " + docum-est.nro-docto + " Data " + string(docum-est.dt-trans)).

               FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
               FIND FIRST mla-doc-pend-aprov NO-LOCK WHERE mla-doc-pend-aprov.chave-doc = string(item-doc-est.num-pedido) NO-ERROR.
               FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


               FIND FIRST pedido-compr NO-LOCK WHERE pedido-compr.num-pedido = item-doc-est.num-pedido
                                               AND   pedido-compr.cod-emitente = item-doc-est.cod-emitente
                                               NO-ERROR.

               IF NOT avail pedido-compr THEN next.

               ELSE DO:

                   
                   
               

               FIND FIRST tt-pedidos NO-LOCK WHERE tt-pedidos.ttv-num-pedido    =   item-doc-est.num-pedido
                                             AND   tt-pedidos.ttv-num-emitente = item-doc-est.cod-emitente
                                             AND   tt-pedidos.ttv-it-codigo    = item-doc-est.it-codigo NO-ERROR.

               IF NOT AVAIL tt-pedidos THEN DO:
                   CREATE tt-pedidos.
                   ASSIGN tt-pedidos.ttv-num-pedido      = item-doc-est.num-pedido
                          tt-pedidos.ttv-num-emitente    = item-doc-est.cod-emitente
                          tt-pedidos.ttv-it-codigo       = item-doc-est.it-codigo
                          tt-pedidos.ttv-dt-emiss        = pedido-compr.data-pedido
                          tt-pedidos.ttv-cod-estab       = docum-est.cod-estabel
                          tt-pedidos.ttv-cod-empresa     = SUBSTRING(docum-est.cod-estabel, 1, 1).
                          
                          .
               END.
            END.

               PUT UNFORMATTED docum-est.nro-docto "|"
                               docum-est.serie-docto "|"
                               docum-est.nat-operacao "|"
                               docum-est.cod-emitente "|"
                               emitente.nome-emit     "|"
                               item-doc-est.it-codigo "|"
                               ITEM.descricao-1       "|"
                               docum-est.dt-trans     "|"
                               docum-est.dt-emissao   "|"
                               item-doc-est.num-pedido "|".


/*                chworksheet:range("A" + STRING(m-linha)):SetValue(docum-est.nro-docto).      */
/*                chworksheet:range("b" + STRING(m-linha)):SetValue(docum-est.serie-docto).    */
/*                chworksheet:range("c" + STRING(m-linha)):SetValue(docum-est.nat-operacao).   */
/*                chworksheet:range("d" + STRING(m-linha)):SetValue(docum-est.cod-emitente).   */
/*                chworksheet:range("e" + STRING(m-linha)):SetValue(emitente.nome-emit).       */
/*                chworksheet:range("f" + STRING(m-linha)):SetValue(item-doc-est.it-codigo).   */
/*                chworksheet:range("g" + STRING(m-linha)):SetValue(ITEM.descricao-1).         */
/*                chworksheet:range("h" + STRING(m-linha)):SetValue(docum-est.dt-trans).       */
/*                chworksheet:range("i" + STRING(m-linha)):SetValue(docum-est.dt-emissao).     */
/*                chworksheet:range("j" + STRING(m-linha)):SetValue(item-doc-est.num-pedido).  */
/*                                                                                             */
               IF AVAIL mla-doc-pend-aprov THEN DO:
                   
               PUT UNFORMATTED mla-doc-pend-aprov.dt-aprova "|"
                               mla-doc-pend-aprov.cod-usuar "|".

/*                chworksheet:range("k" + STRING(m-linha)):SetValue(mla-doc-pend-aprov.dt-aprova).  */
/*                chworksheet:range("l" + STRING(m-linha)):SetValue(mla-doc-pend-aprov.cod-usuar).  */
                END.

                ELSE DO:

                     PUT UNFORMATTED "Sem informacao | Nao informado |".

/*                 chworksheet:range("k" + STRING(m-linha)):SetValue("Sem informacao").  */
/*                 chworksheet:range("l" + STRING(m-linha)):SetValue("Nao informado").   */
                    
                END.
/*                    chworksheet:range("m" + STRING(m-linha)):SetValue(item-doc-est.preco-total[1]).  */

                   PUT UNFORMATTED item-doc-est.preco-total[1]
                       SKIP.


                   ASSIGN m-linha = m-linha + 1.
           END.
END PROCEDURE.

PROCEDURE pi-pedidos:


    PUT UNFORMATTED "Pedido | Item | Descricao | DtEmissao | DtAprovacao | Aprovador | UsuarDocto | UsuarTrans| SitPedido |CtContabil | CCusto | NF | Serie | Emitente" SKIP.

/*     chworksheet=chWorkBook:sheets:item(2).                                                                 */
/*     chworksheet:name="Pedidos". /* Nome que ser¿ criada a Pasta da Planilha */                             */
/*     m-linha = 2.                                                                                           */
/*     chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */                         */
/*     chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */               */
/*     chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */                                    */
/*     chworksheet:range("A1:q1"):SetValue("Pedidos").                                                        */
/*     chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */                          */
/*     chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */                */
/*   /* Cria os titulos para as colunas do relat÷rio */                                                       */
/*         chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */  */
/*         chworksheet:range("A" + STRING(m-linha)):SetValue("Pedido").                                       */
/*         chworksheet:range("b" + STRING(m-linha)):SetValue("Item").                                         */
/*         chworksheet:range("c" + STRING(m-linha)):SetValue("Descricao").                                    */
/*         chworksheet:range("d" + STRING(m-linha)):SetValue("Dt. Emissao").                                  */
/*         chworksheet:range("e" + STRING(m-linha)):SetValue("Dt. Aprovacao").                                */
/*         chworksheet:range("f" + STRING(m-linha)):SetValue("Aprovador").                                    */
/*         chworksheet:range("g" + STRING(m-linha)):SetValue("Situacao Pedido").                              */
/*         chworksheet:range("h" + STRING(m-linha)):SetValue("NF").                                           */
/*         chworksheet:range("i" + STRING(m-linha)):SetValue("Serie").                                        */
/*         chworksheet:range("j" + STRING(m-linha)):SetValue("Emitente").                                     */
/*         ASSIGN m-linha = m-linha + 1.                                                                      */

        RUN pi-inicializar IN h-prog(INPUT "Pedidos").
        FIND FIRST tt-param NO-ERROR.


        FOR EACH mla-doc-pend-aprov NO-LOCK WHERE mla-doc-pend-aprov.ind-situacao = 2
                                            AND   mla-doc-pend-aprov.dt-geracao   >= tt-param.dt-emiss-ini
                                            AND   mla-doc-pend-aprov.dt-geracao   <= tt-param.dt-emiss-fim
                                            AND   mla-doc-pend-aprov.cod-estabel  >= tt-param.cod-estab-ini
                                            AND   mla-doc-pend-aprov.cod-estabel  <= tt-param.cod-estab-fim
                                            AND   mla-doc-pend-aprov.cod-tip-doc   = 8
                                            AND   mla-doc-pend-aprov.ep-codigo    >= SUBSTRING(tt-param.cod-estab-ini, 1, 1)
                                            AND   mla-doc-pend-aprov.ep-codigo    <= SUBSTRIN(tt-param.cod-estab-fim, 1, 1)
                                            BREAK BY mla-doc-pend-aprov.chave-doc:

            IF LAST-OF(mla-doc-pend-aprov.chave-doc) THEN DO:
                
            

            FIND FIRST pedido-compr NO-LOCK WHERE pedido-compr.num-pedido = INT(mla-doc-pend-aprov.chave-doc)
                                            NO-ERROR.


            FOR EACH ordem-compra NO-LOCK WHERE ordem-compra.num-pedido     = pedido-compr.num-pedido
                                            AND   ordem-compra.data-pedido  = pedido-compr.data-pedido
                                            AND   ordem-compra.cod-emitente = pedido-compr.cod-emitente
                                            AND   ordem-compra.situacao     <> 4:
                                            
                                            /*                      FIND FIRST ordem-compra NO-LOCK WHERE ordem-compra.it-codigo     = tt-pedidos.ttv-it-codigo  */
/*                                                 AND   ordem-compra.num-pedido    = tt-pedidos.ttv-num-pedido      */
/*                                                 AND   ordem-compra.cod-emitente  = tt-pedidos.ttv-num-emitente    */
/*                                                 AND   ordem-compra.data-pedido   = tt-pedidos.ttv-dt-emiss        */
/*                                                 AND   ordem-compra.situacao      <> 4 NO-ERROR.                   */
/*                                                                                                                   */
/*                                                                                                                   */

            RUN pi-acompanhar IN h-prog(INPUT "Pedido " + string(mla-doc-pend-aprov.chave-doc)).
/*             FIND FIRST cotacao-item NO-LOCK WHERE cotacao-item.it-codigo = ordem-compra.it-codigo                                  */
/*                                             AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente                            */
/*                                             AND   cotacao-item.numero-ordem = ordem-compra.numero-ordem                            */
/*                                             AND    cotacao-item.cod-comprado = ordem-compra.cod-comprado                           */
/*                                             AND    cotacao-item.data-cotacao = ordem-compra.data-cotacao                           */
/*                                             NO-ERROR.                                                                              */
/*                                                                                                                                    */
/*             FIND FIRST mla-doc-pend-aprov NO-LOCK WHERE mla-doc-pend-aprov.chave-doc = string(tt-pedidos.ttv-num-pedido) NO-ERROR. */
            FIND FIRST ITEM  NO-LOCK WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR. 

/*             IF AVAIL mla-doc-pend-aprov THEN DO: */
                

                FIND FIRST ITEM-doc-est NO-LOCK WHERE ITEM-doc-est.num-pedido = ordem-compra.num-pedido
                                                AND   ITEM-doc-est.it-codigo  = ordem-compra.it-codigo
                                                AND   ITEM-doc-est.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

                PUT UNFORMATTED ordem-compra.num-pedido "|"
                                 ordem-compra.it-codigo         "|"
                                 ITEM.descricao-1               "|"
                                 ordem-compra.data-emissao "|"
                                 mla-doc-pend-aprov.dt-aprova "|"
                                 mla-doc-pend-aprov.cod-usuar  "|"
                                 mla-doc-pend-aprov.cod-usuar-doc "|"
                                 mla-doc-pend-aprov.cod-usuar-trans "|"
                                 mla-doc-pend-aprov.ind-situacao "|"
                                 ordem-compra.ct-codigo "|"
                                 ordem-compra.sc-codigo "|".

               

/*                 chworksheet:range("A" + STRING(m-linha)):SetValue(IF avail tt-pedidos THEN  string(tt-pedidos.ttv-num-pedido) ELSE mla-doc-pend-aprov.chave-doc).  */
/*                 chworksheet:range("b" + STRING(m-linha)):SetValue(IF avail tt-pedidos THEN  tt-pedidos.ttv-it-codigo ELSE mla-doc-pend-aprov.it-codigo).           */
/*                 chworksheet:range("c" + STRING(m-linha)):SetValue(item.descricao-1).                                                                               */
/*                 chworksheet:range("d" + STRING(m-linha)):SetValue(IF avail tt-pedidos THEN  tt-pedidos.ttv-dt-emiss ELSE mla-doc-pend-aprov.dt-aprova).            */

                IF AVAIL ITEM-doc-est THEN DO:
                    PUT UNFORMATTED ITEM-doc-est.nro-docto "|"
                                    ITEM-doc-est.serie-docto "|".


/*                     chworksheet:range("e" + STRING(m-linha)):SetValue(ITEM-doc-est.nro-docto).    */
/*                     chworksheet:range("f" + STRING(m-linha)):SetValue(ITEM-doc-est.serie-docto).  */
                    
                END.

                ELSE DO:

                    PUT UNFORMATTED "Nao entrou ainda | Nao entrou ainda |".
                    
                
/*                 chworksheet:range("e" + STRING(m-linha)):SetValue("Nao Entrou ainda").  */
/*                 chworksheet:range("f" + STRING(m-linha)):SetValue("Nao Entrou ainda").  */

                END.

/*                 CASE ordem-compra.situacao:                                               */
/*                                                                                           */
/*                 WHEN 1 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Nao confirmada").  */
/*                 WHEN 2 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Confirmada").      */
/*                 WHEN 3 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Cotada").          */
/*                 WHEN 4 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Eliminada").       */
/*                 WHEN 5 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Em cotacao").      */
/*                 WHEN 6 THEN                                                               */
/*                     chworksheet:range("g" + STRING(m-linha)):SetValue("Recebida").        */
/*                                                                                           */
/*                                                                                           */
/*                 END CASE.                                                                 */

                IF AVAIL ITEM-doc-est THEN DO:

                    PUT UNFORMATTED ITEM-doc-est.cod-emitente SKIP.
                    
                
/*                 chworksheet:range("h" + STRING(m-linha)):SetValue(ITEM-doc-est.nro-docto).     */
/*                 chworksheet:range("i" + STRING(m-linha)):SetValue(ITEM-doc-est.serie-docto).   */
/*                 chworksheet:range("j" + STRING(m-linha)):SetValue(ITEM-doc-est.cod-emitente).  */
               END.

               IF NOT AVAIL ITEM-doc-est THEN DO:

                   PUT UNFORMATTED "Nao recebido" SKIP.
               
/*                chworksheet:range("h" + STRING(m-linha)):SetValue("Nao recebido").  */
/*                chworksheet:range("i" + STRING(m-linha)):SetValue("Nao recebido").  */
/*                chworksheet:range("j" + STRING(m-linha)):SetValue("Nao recebido").  */
              END.
            END.
        END.
     END.


END PROCEDURE.
