{include/itbuni.i}

DEFINE INPUT PARAMETER rs-unidade AS INT NO-UNDO.

DEF SHARED VAR whNumPedido AS WIDGET-HANDLE          NO-UNDO.

DEF VAR v_arq_temp		   AS CHAR                   NO-UNDO.
DEF VAR c-arq-logo         AS CHAR                   NO-UNDO.
DEF VAR c-diretorio		   AS CHAR                   NO-UNDO.
DEF VAR vRow			   AS INT                    NO-UNDO.
DEF VAR i_cont_pdf	       AS INT                    NO-UNDO.
DEF VAR c-linha	           AS CHAR FORMAT "x(162)"   NO-UNDO.
DEF VAR deMargem           AS DEC INIT 20            NO-UNDO.
DEF VAR cFornecedor        AS CHAR FORMAT "x(50)"    NO-UNDO.
DEF VAR cFone              AS CHAR                   NO-UNDO.
DEF VAR cCidade            AS CHAR                   NO-UNDO.
DEF VAR iNrItens           AS INT                    NO-UNDO.
DEF VAR deValorTotal       AS DEC                    NO-UNDO.
DEF VAR cQtdeItem          AS CHAR                   NO-UNDO.
DEF VAR cDescCondPagto     LIKE cond-pagto.descricao NO-UNDO.
DEF VAR cResponsavel       AS CHAR FORMAT "x(40)"    NO-UNDO.
DEF VAR cTipoFrete         AS CHAR FORMAT "x(3)"     NO-UNDO.
DEF VAR cDeptoCompras      AS CHAR                   NO-UNDO.
DEF VAR i                  AS INT                    NO-UNDO.
DEF VAR h_TT               AS HANDLE                 NO-UNDO.
DEF VAR h-acomp            AS HANDLE                 NO-UNDO.
DEF VAR cFoneEstab         AS CHAR FORMAT "x(40)"    NO-UNDO.
DEF VAR cEmailNFe          LIKE cont-emit.e-mail     NO-UNDO.
DEF VAR cEmailAgendamento  LIKE cont-emit.observacao NO-UNDO.

DEF VAR de-preco-unit      LIKE ordem-compra.preco-unit NO-UNDO.
DEF VAR de-qt-solic        LIKE ordem-compra.qt-solic   NO-UNDO.
DEF VAR c-un               LIKE ITEM.un                 NO-UNDO.
DEF VAR deFator            AS   DEC                     NO-UNDO.

DEFINE TEMP-TABLE tt-item-un-venda
    FIELD it-codigo   LIKE item-unid-venda.it-codigo
    FIELD un          LIKE item-unid-venda.un
    FIELD fator       AS   DECIMAL
    INDEX id-fator IS UNIQUE fator un it-codigo.

DEF TEMP-TABLE ttOrdemCompra
    FIELD it-codigo    LIKE ordem-compra.it-codigo
    FIELD qt-solic     AS INT FORMAT ">>>,>>>,>>9"
    FIELD un           LIKE ITEM.un
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD cdn-fabrican AS CHAR
    FIELD preco-unit   AS DEC FORMAT ">>>,>>9.99999"
    FIELD vl-total     AS DEC FORMAT ">>,>>>,>>9.99"
    INDEX id-item it-codigo preco-unit.

{include/pdf_inc.i }

ASSIGN c-diretorio = session:TEMP-DIR
       c-linha = FILL ("_", 110).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Preparando a Impress∆o do Pedido de Compra").


FIND FIRST mla-doc-pend-aprov NO-LOCK WHERE mla-doc-pend-aprov.cod-tip-doc = 8
                                      AND   entry(1, mla-doc-pend-aprov.chave-doc, "|")   = whNumPedido:SCREEN-VALUE
                                      NO-ERROR.

IF AVAIL mla-doc-pend-aprov THEN

    RUN pi-aprov-mla.

ELSE 
    RUN pi-aprov-compras.


PROCEDURE pi-aprov-compras:

FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = INT (whNumPedido:SCREEN-VALUE) NO-LOCK NO-ERROR.
IF AVAIL pedido-compr THEN
DO:
    FIND FIRST estabelec OF pedido-compr NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN LEAVE.


    /*Verifica se o pedido de compra est† aprovado*/
    FIND FIRST doc-pend-aprov OF pedido-compr NO-LOCK
         WHERE (doc-pend-aprov.ind-tip-doc = 4 OR doc-pend-aprov.ind-tip-doc = 6)
         AND   doc-pend-aprov.ind-situacao = 2 
         NO-ERROR.
    IF AVAIL doc-pend-aprov THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Pedido Compra: " + STRING(pedido-compr.num-pedido)).

        ASSIGN cFornecedor    = ''
               cCidade        = ''
               cDescCondPagto = ''
               cResponsavel   = ''
               iNrItens       = 0
               deValorTotal   = 0.

        FIND FIRST emitente OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN cFornecedor = TRIM (emitente.nome-emit) + " (" + STRING (emitente.cod-emitente, "999999") + ")" + "   Fone: " + emitente.telefone[1]
                   cCidade     = emitente.cidade + "/" + emitente.estado.  
    
        FIND FIRST cond-pagto OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL cond-pagto THEN
        DO i = 1 TO cond-pagto.num-parcelas:
            IF i = 1 THEN ASSIGN cDescCondPagto = STRING (cond-pagto.prazos[i]).
                     ELSE ASSIGN cDescCondPagto = cDescCondPagto + "/" + STRING (cond-pagto.prazos[i]).
        END.
 
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = pedido-compr.responsavel NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN ASSIGN cResponsavel = usuar_mestre.nom_usuar.
    
        EMPTY TEMP-TABLE ttOrdemCompra.

        FOR EACH ordem-compra OF pedido-compr NO-LOCK
           WHERE ordem-compra.situacao = 2, /* Confirmada */
           FIRST ITEM OF ordem-compra NO-LOCK:
    
            RUN pi-acompanhar  IN h-acomp (INPUT "Gerando Itens do Pedido " + STRING(pedido-compr.num-pedido)).
    
            FIND FIRST ext-item OF ITEM NO-LOCK NO-ERROR.

            ASSIGN de-preco-unit = ordem-compra.preco-unit
                   de-qt-solic = ordem-compra.qt-solic
                   c-un = ITEM.un.
            IF rs-unidade = 2 THEN RUN pi-converter-maior-unid(INPUT-OUTPUT de-preco-unit, INPUT-OUTPUT de-qt-solic, INPUT-OUTPUT c-un).
        
            FIND FIRST ttOrdemCompra EXCLUSIVE-LOCK
                 WHERE ttOrdemCompra.it-codigo = ordem-compra.it-codigo
                 AND   ttOrdemCompra.preco-unit = de-preco-unit /*ordem-compra.preco-unit*/
                 NO-ERROR.
            IF NOT AVAIL ttOrdemCompra THEN DO:
                CREATE ttOrdemCompra.
                ASSIGN ttOrdemCompra.it-codigo    = ordem-compra.it-codigo
                       ttOrdemCompra.preco-unit   = de-preco-unit /*ordem-compra.preco-unit*/
                       ttOrdemCompra.un           = c-un /*ITEM.un*/
                       ttOrdemCompra.desc-item    = ITEM.desc-item
                       ttOrdemCompra.cdn-fabrican = IF AVAIL ext-item THEN ext-item.cod-fabricante ELSE ""
                       ttOrdemCompra.qt-solic     = 0
                       ttOrdemCompra.vl-total     = 0
                       iNrItens = iNrItens + 1.
            END.
            ASSIGN ttOrdemCompra.qt-solic     = ttOrdemCompra.qt-solic + INT(de-qt-solic) /*INT(ordem-compra.qt-solic)*/
                   ttOrdemCompra.vl-total     = ttOrdemCompra.vl-total + (de-qt-solic * de-preco-unit) /*(ordem-compra.qt-solic * ordem-compra.preco-unit)*/
                   deValorTotal               = deValorTotal           + (de-qt-solic * de-preco-unit) /*(ordem-compra.qt-solic * ordem-compra.preco-unit)*/.
        END.
    
        IF iNrItens > 1 THEN ASSIGN cQtdeItem = STRING(iNrItens) + " Itens".
                        ELSE ASSIGN cQtdeItem = STRING(iNrItens) + " Item".

        IF pedido-compr.frete = 1 THEN ASSIGN cTipoFrete = "CIF" /*Pago*/.
                                  ELSE ASSIGN cTipoFrete = "FOB" /*Ö Pagar*/.

        ASSIGN c-arq-logo        = '\\ccrrctotvs01\totvs\erp11\especifico\fnd\logo\E' + TRIM(STRING(INT(estabelec.ep-codigo),'999')) + '_Logo.jpg'
            /* c-arq-logo        = '\\ccrrctotvs01\datasul\ems\rioclarense\ofi\206\logo\E' + TRIM(STRING(estabelec.ep-codigo,'999')) + '_Logo.jpg' */
               cDeptoCompras     = 'Depto de Compras - ' + TRIM(estabelec.nome)
               cFoneEstab        = ''
               cEmailNFe         = ''
               cEmailAgendamento = ''.
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cgc = estabelec.cgc,
            FIRST cont-emit NO-LOCK
            WHERE cont-emit.cod-emitente = emitente.cod-emitente
              AND cont-emit.area = 'PEDIDOCOMPRA':
            ASSIGN cFoneEstab = cont-emit.telefone + " / " + cont-emit.telefax
                   cEmailNFe  = cont-emit.e-mail
/*                    cEmailAgendamento = IF cont-emit.observacao <> '' THEN (' ou pelo e-mail: ' + TRIM(cont-emit.observacao)) ELSE ''. */
                   cEmailAgendamento = IF cont-emit.observacao <> '' THEN TRIM(cont-emit.observacao) ELSE ''.
        END.

        RUN piCriaArquivo.
        RUN piCabec.
        RUN piCorpoPedido.
        RUN piFecha.

        RUN piAlteraSituacao (INPUT ROWID(pedido-compr)).

        OS-COMMAND NO-WAIT VALUE(v_arq_temp).

    END. /* IF AVAIL doc-pend-aprov THEN DO: */
    ELSE DO:

        RUN utp/ut-msgs.p (INPUT 'show':U, INPUT 17006,
                           INPUT 'Aprovaá∆o do Pedido de Compra!~~O Pedido de Compra ainda n∆o foi aprovado. A impress∆o do pedido n∆o ser† poss°vel.').
    END.
END.

run pi-finalizar in h-acomp.

RETURN 'OK':U.

END PROCEDURE.


PROCEDURE pi-aprov-mla:

FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = INT (whNumPedido:SCREEN-VALUE) NO-LOCK NO-ERROR.
IF AVAIL pedido-compr THEN
DO:
    FIND FIRST estabelec OF pedido-compr NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN LEAVE.


    /*Verifica se o pedido de compra est† aprovado*/
    FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.cod-tip-doc = 8
                                  AND   entry(1 , mla-doc-pend-aprov.chave-doc, "|")    
                                  AND   mla-doc-pend-aprov.ind-situacao = 2 NO-ERROR.
    IF AVAIL mla-doc-pend-aprov THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Pedido Compra: " + STRING(pedido-compr.num-pedido)).

        ASSIGN cFornecedor    = ''
               cCidade        = ''
               cDescCondPagto = ''
               cResponsavel   = ''
               iNrItens       = 0
               deValorTotal   = 0.

        FIND FIRST emitente OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN cFornecedor = TRIM (emitente.nome-emit) + " (" + STRING (emitente.cod-emitente, "999999") + ")" + "   Fone: " + emitente.telefone[1]
                   cCidade     = emitente.cidade + "/" + emitente.estado.  
    
        FIND FIRST cond-pagto OF pedido-compr NO-LOCK NO-ERROR.
        IF AVAIL cond-pagto THEN
        DO i = 1 TO cond-pagto.num-parcelas:
            IF i = 1 THEN ASSIGN cDescCondPagto = STRING (cond-pagto.prazos[i]).
                     ELSE ASSIGN cDescCondPagto = cDescCondPagto + "/" + STRING (cond-pagto.prazos[i]).
        END.
 
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = pedido-compr.responsavel NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN ASSIGN cResponsavel = usuar_mestre.nom_usuar.
    
        EMPTY TEMP-TABLE ttOrdemCompra.

        FOR EACH ordem-compra OF pedido-compr NO-LOCK
           WHERE ordem-compra.situacao = 2, /* Confirmada */
           FIRST ITEM OF ordem-compra NO-LOCK:
    
            RUN pi-acompanhar  IN h-acomp (INPUT "Gerando Itens do Pedido " + STRING(pedido-compr.num-pedido)).
    
            FIND FIRST ext-item OF ITEM NO-LOCK NO-ERROR.

            ASSIGN de-preco-unit = ordem-compra.preco-unit
                   de-qt-solic = ordem-compra.qt-solic
                   c-un = ITEM.un.
            IF rs-unidade = 2 THEN RUN pi-converter-maior-unid(INPUT-OUTPUT de-preco-unit, INPUT-OUTPUT de-qt-solic, INPUT-OUTPUT c-un).
        
            FIND FIRST ttOrdemCompra EXCLUSIVE-LOCK
                 WHERE ttOrdemCompra.it-codigo = ordem-compra.it-codigo
                 AND   ttOrdemCompra.preco-unit = de-preco-unit /*ordem-compra.preco-unit*/
                 NO-ERROR.
            IF NOT AVAIL ttOrdemCompra THEN DO:
                CREATE ttOrdemCompra.
                ASSIGN ttOrdemCompra.it-codigo    = ordem-compra.it-codigo
                       ttOrdemCompra.preco-unit   = de-preco-unit /*ordem-compra.preco-unit*/
                       ttOrdemCompra.un           = c-un /*ITEM.un*/
                       ttOrdemCompra.desc-item    = ITEM.desc-item
                       ttOrdemCompra.cdn-fabrican = IF AVAIL ext-item THEN ext-item.cod-fabricante ELSE ""
                       ttOrdemCompra.qt-solic     = 0
                       ttOrdemCompra.vl-total     = 0
                       iNrItens = iNrItens + 1.
            END.
            ASSIGN ttOrdemCompra.qt-solic     = ttOrdemCompra.qt-solic + INT(de-qt-solic) /*INT(ordem-compra.qt-solic)*/
                   ttOrdemCompra.vl-total     = ttOrdemCompra.vl-total + (de-qt-solic * de-preco-unit) /*(ordem-compra.qt-solic * ordem-compra.preco-unit)*/
                   deValorTotal               = deValorTotal           + (de-qt-solic * de-preco-unit) /*(ordem-compra.qt-solic * ordem-compra.preco-unit)*/.
        END.
    
        IF iNrItens > 1 THEN ASSIGN cQtdeItem = STRING(iNrItens) + " Itens".
                        ELSE ASSIGN cQtdeItem = STRING(iNrItens) + " Item".

        IF pedido-compr.frete = 1 THEN ASSIGN cTipoFrete = "CIF" /*Pago*/.
                                  ELSE ASSIGN cTipoFrete = "FOB" /*Ö Pagar*/.

        ASSIGN c-arq-logo        = '\\ccrrctotvs01\totvs\erp11\especifico\fnd\logo\E' + TRIM(STRING(INT(estabelec.ep-codigo),'999')) + '_Logo.jpg'
            /* c-arq-logo        = '\\ccrrctotvs01\datasul\ems\rioclarense\ofi\206\logo\E' + TRIM(STRING(estabelec.ep-codigo,'999')) + '_Logo.jpg' */
               cDeptoCompras     = 'Depto de Compras - ' + TRIM(estabelec.nome)
               cFoneEstab        = ''
               cEmailNFe         = ''
               cEmailAgendamento = ''.
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cgc = estabelec.cgc,
            FIRST cont-emit NO-LOCK
            WHERE cont-emit.cod-emitente = emitente.cod-emitente
              AND cont-emit.area = 'PEDIDOCOMPRA':
            ASSIGN cFoneEstab = cont-emit.telefone + " / " + cont-emit.telefax
                   cEmailNFe  = cont-emit.e-mail
/*                    cEmailAgendamento = IF cont-emit.observacao <> '' THEN (' ou pelo e-mail: ' + TRIM(cont-emit.observacao)) ELSE ''. */
                   cEmailAgendamento = IF cont-emit.observacao <> '' THEN TRIM(cont-emit.observacao) ELSE ''.
        END.

        RUN piCriaArquivo.
        RUN piCabec.
        RUN piCorpoPedido.
        RUN piFecha.

        RUN piAlteraSituacao (INPUT ROWID(pedido-compr)).

        OS-COMMAND NO-WAIT VALUE(v_arq_temp).

    END. /* IF AVAIL doc-pend-aprov THEN DO: */
    ELSE DO:

        RUN utp/ut-msgs.p (INPUT 'show':U, INPUT 17006,
                           INPUT 'Aprovaá∆o do Pedido de Compra!~~O Pedido de Compra ainda n∆o foi aprovado. A impress∆o do pedido n∆o ser† poss°vel.').
    END.
END.

run pi-finalizar in h-acomp.

RETURN 'OK':U.


PROCEDURE piCriaArquivo:
   /* criar arquivo */
   ASSIGN v_arq_temp = c-diretorio + "PedidoCompra.PDF".

   IF SEARCH(v_arq_temp) NE ? THEN OS-DELETE VALUE(v_arq_temp).

   RUN pdf_new IN h_PDFinc ("Spdf",v_arq_temp).
   /* RUN pdf_set_parameter IN h_PDFinc("Spdf","Compress","TRUE"). */

   RUN pdf_set_parameter IN h_PDFinc ("Spdf","AllowPrint","true").
   /* RUN pdf_load_image IN h_PDFinc ("Spdf","Logo","\\192.168.0.175\datasul\programas\ems\rioclarense\tst\206\image\Logo_ofi.jpg"). */
   /* RUN pdf_load_image IN h_PDFinc ("Spdf","Logo","\\ccrrctotvs01\datasul\ems\rioclarense\tst\206\image\Logo_ofi.jpg"). */
   IF c-arq-logo <> '' AND
      SEARCH(c-arq-logo) NE ? THEN RUN pdf_load_image IN h_PDFinc ("Spdf","Logo",c-arq-logo).
   RUN pdf_new_page2   IN h_PDFinc ("Spdf","landscape"). /**/
   RUN pdf_set_LeftMargin IN h_PDFinc ("Spdf",50).

   pdf_PageFooter ("Spdf", THIS-PROCEDURE:HANDLE, "PageFooter"). 

END PROCEDURE.

PROCEDURE piCabec:

   RUN pdf_place_image IN h_PDFinc ("Spdf","Logo",10,75,110,060). /*Posicao y, posicao x, largura, altura */
/*    RUN pdf_set_font    IN h_PDFinc ("Spdf","Helvetica-bold",13.0).             */
/*    RUN pdf_text_xy     IN h_PDFInc ("Spdf","RIOCLARENSE ", deMargem + 45,580). */
   RUN pdf_set_font    IN h_PDFinc ("Spdf","Helvetica-bold",16.0).
   RUN pdf_text_xy     IN h_PDFInc ("Spdf","AUTORIZAÄ«O DE FORNECIMENTO No. " + STRING (pedido-compr.num-pedido, "999999"), deMargem + 350,580).
   RUN pdf_set_font    IN h_PDFinc ("Spdf","Helvetica-bold",10.0).
   RUN pdf_text_xy     IN h_PDFInc ("Spdf","Data de Emiss∆o da AF: " + STRING (pedido-compr.data-pedido), deMargem + 560,565).

   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica",8.0).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",estabelec.nome, deMargem + 110,585).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","CNPJ: " + STRING (estabelec.cgc, '99.999.999/9999-99'), deMargem + 110,575).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","Filial: " + estabelec.cidade + " / " + estabelec.estado, deMargem + 110,565).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",estabelec.endereco, deMargem + 110,555).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("Fone: " + TRIM(cFoneEstab)), deMargem + 110,545).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","O n£mero acima deve constar em toda correspondància, documentaá∆o ou faturas pertinentes Ö esse pedido. ", deMargem + 350,545).

   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica",6.0).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","OBSERVAÄÂES IMPORTANTES : ", deMargem, 500).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","Enviar juntamente com a mercadoria e Nota Fiscal:", deMargem, 490).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","    - Laudo de Controle de Qualidade de cada lote fornecido sendo original ou c¢pia autenticada.",deMargem,480).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",'    - Enviar as mercadorias com "VENDA PROIBIDA AO COMêRCIO".',deMargem,470).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","    - Nota Fiscal: Havendo falta do produto, est† autorizado o faturamento parcial. Caso necess†rio, poder† ser faturado v†rios pedidos em uma £nica Nota Fiscal.",deMargem,460).
   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica-bold",7.0). 
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("Conforme o ajuste SINIEF 07/05 Ç obrigat¢rio o envio do arquivo XML para o endereáo eletrìnico: " + TRIM(LC(cEmailNFe))), deMargem,440).
   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica",6.0).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("N∆o autorizamos negociaá∆o de t°tulos emitidos contra a " + TRIM(estabelec.nome) + " em Factoring."), deMargem,430).
   
   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica",6.0).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","ATENÄ«O!",deMargem,410).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","    - Somente receberemos mercadorias com validade de, no m°nimo, 80% ou superior Ö 18 meses e preáos iguais Ö este pedido.",deMargem,400).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","    - Destacar no corpo da Nota Fiscal: DISTRIBUIDOR HOSPITALAR - Of°cio DF PC/0002/09 e validade dos lotes dos produtos faturados, sob o risco das notas que n∆o constarem esta observaá∆o serem devolvidas no ato do recebimento.",deMargem,390).
/*    RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("    - N∆o receberemos entregas sem prÇvio agendamento. Favor agendar entrega em " + TRIM(estabelec.cidade) + " pelo fone " + TRIM(cFoneEstab)) + " " + TRIM(cEmailAgendamento), deMargem,380).*/
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("    - N∆o receberemos entregas sem prÇvio agendamento. Favor agendar entrega em " + TRIM(estabelec.cidade) + " " + TRIM(cEmailAgendamento)), deMargem,380).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("    - Em caso de descumprimento do prazo de entrega acordado, a " + TRIM(estabelec.nome) + " se guarda o direito de em 30 dias ap¢s o prazo acordado cancelar a(s) pendància(s) ou programaá∆o(‰es)."), deMargem,370).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",STRING("    - Tais cancelamentos, ser∆o de direito £nico e exclusivo da " + TRIM(estabelec.nome) + ", eis que n∆o implica na obrigatoriedade de ocorrer."), deMargem,360).

   RUN pdf_set_font IN h_PDFinc ("Spdf","Helvetica-bold",8.0).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","A(o) :  ", deMargem, 340).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",cFornecedor, deMargem, 330). 
   RUN pdf_text_xy  IN h_PDFInc ("Spdf",cCidade, deMargem, 320).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","A/C Depto de Vendas: ", deMargem, 310).
   RUN pdf_text_xy  IN h_PDFInc ("Spdf","Prazo de Pagamento : " + cDescCondPagto + " Dias" + "            FRETE: " + cTipoFrete, deMargem, 290).
  
END PROCEDURE.

PROCEDURE piCorpoPedido:
    /*Tabela*/
   /* Don't want the table to be going until the end of the page or too near the side */
    RUN pdf_set_LeftMargin IN h_PDFinc ("Spdf",20).
    RUN pdf_set_BottomMargin IN h_PDFinc ("Spdf",45).

    RUN pdf_skipn IN h_PDFinc ("Spdf",36).
    
    /* Link the Temp-Table to the PDF */
    h_TT = TEMP-TABLE ttOrdemCompra:HANDLE.
    RUN pdf_tool_add IN h_PDFinc ("Spdf","ListaItens", "TABLE", h_TT).

    RUN pdf_set_tool_parameter IN h_PDFinc("Spdf","ListaItens","MaxY",0,10).
    RUN pdf_set_tool_parameter IN h_PDFinc("Spdf","ListaItens","MaxX",0,10).
    
    /* Now Setup some Parameters for the Table */
    /* comment out this section to see what the default Table looks like */
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","Outline",0,".5").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","HeaderFont",0,"Helvetica-Bold").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","HeaderFontSize",0,"8").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","HeaderBGColor",0,"255,255,255").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","HeaderTextColor",0,"0,0,0").
    
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","DetailBGColor",0,"200,200,200").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","DetailTextColor",0,"0,0,0").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","DetailFont",0,"Helvetica").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","DetailFontSize",0,"8").
    /* end of section */
    
    /* Define Table Column Headers */
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",1,"CODIGO").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",2,"QUANTIDADE").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",3,"UNID").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",4,"PRODUTO").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",5,"FABRICANTE").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",6,"       $ UNIT").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnHeader",7,"       $ TOTAL").
    
    /* Define Table Column Widths */
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",1,"7").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",2,"13").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",3,"4").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",4,"59").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",5,"13").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",6,"13").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","ColumnWidth",7,"15").
  
    /* Now produce the table */
    RUN pdf_tool_create IN h_PDFinc ("Spdf","ListaItens").
    RUN pdf_set_tool_parameter IN h_PDFinc ("Spdf","ListaItens","Outline",0,"0").

END.

PROCEDURE piFinal:
		 RUN pdf_new_page2  IN h_PDFinc ("Spdf","Landscape").
         RUN piCabec.
         ASSIGN vRow = 420.
		 ASSIGN i_cont_pdf = 0.
END.

PROCEDURE piFecha:
    /*Total*/
    RUN pdf_skipn   IN h_PDFinc ("Spdf",2).
    RUN pdf_text_at IN h_PDFInc ("Spdf",cQtdeItem, 5).
    RUN pdf_text_at IN h_PDFInc ("Spdf","TOTAL GERAL " + STRING (deValorTotal,">>>,>>>,>>9.99"), 280).

    RUN pdf_skipn IN h_PDFinc ("Spdf",3).

/*     RUN pdf_text  IN h_PDFInc ("Spdf", "Prazo de Pagamento : " + cDescCondPagto + " Dias"). */
/*     RUN pdf_skipn IN h_PDFinc ("Spdf",2).                                                   */
/*                                                                                             */
/*     RUN pdf_text  IN h_PDFInc ("Spdf", "FRETE : " + cTipoFrete).                            */
/*     RUN pdf_skipn IN h_PDFinc ("Spdf",2).                                                   */
    
    RUN pdf_text  IN h_PDFInc ("Spdf","Atenciosamente,").
    RUN pdf_skipn IN h_PDFinc ("Spdf",3).  
    RUN pdf_text  IN h_PDFInc ("Spdf",cResponsavel).
    RUN pdf_skip  IN h_PDFinc ("Spdf"). 
    RUN pdf_text  IN h_PDFinc ("Spdf","___________________________________________________________").
    RUN pdf_skip  IN h_PDFinc ("Spdf").
    RUN pdf_text  IN h_PDFInc ("Spdf",cDeptoCompras).

	RUN pdf_close IN h_PDFinc ("Spdf").

END PROCEDURE.

PROCEDURE PageFooter: 
    RUN pdf_set_font   ("Spdf","Courier-Bold",8.0).  
    RUN pdf_text_color ("Spdf",0.0,.0,.0). 
    RUN pdf_skip       ("Spdf"). 
    RUN pdf_set_dash   ("Spdf",3,0). 
    RUN pdf_line       ("Spdf", pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") - 5, 1). 
    RUN pdf_skip       ("Spdf"). 
    RUN pdf_skip       ("Spdf"). 
    RUN pdf_text_to    ("Spdf",  "Page: " + STRING(pdf_page("Spdf")) + " de " + pdf_TotalPages("Spdf"), 171). 
END. 

PROCEDURE piAlteraSituacao:
    DEFINE INPUT PARAMETER pRowId AS ROWID NO-UNDO.
    FIND FIRST pedido-compr EXCLUSIVE-LOCK WHERE ROWID (pedido-compr) = pRowId NO-ERROR.
    IF AVAIL pedido-compr AND pedido-compr.situacao = 2 /*Nao impresso*/
        THEN ASSIGN pedido-compr.situacao = 1.
END.

PROCEDURE pi-converter-maior-unid:
    DEFINE INPUT-OUTPUT PARAMETER p_de-preco-unit LIKE ordem-compra.preco-unit NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_de-qt-solic   LIKE ordem-compra.qt-solic   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_c-un          LIKE ITEM.un                 NO-UNDO.

    FOR EACH tt-item-un-venda:
        DELETE tt-item-un-venda.
    END.
    FOR EACH item-unid-venda NO-LOCK
       WHERE item-unid-venda.it-codigo = ordem-compra.it-codigo:
        CREATE tt-item-un-venda.
        ASSIGN tt-item-un-venda.it-codigo = item-unid-venda.it-codigo
               tt-item-un-venda.un        = item-unid-venda.un
               tt-item-un-venda.fator     = item-unid-venda.fator-conversao / (EXP(10,item-unid-venda.num-casa-dec)).
    END.
    FIND FIRST tt-item-un-venda NO-LOCK NO-ERROR.
    IF AVAIL tt-item-un-venda
        THEN ASSIGN deFator = tt-item-un-venda.fator
                    p_c-un  = tt-item-un-venda.un.
        ELSE ASSIGN deFator = 1.
    ASSIGN p_de-preco-unit = p_de-preco-unit / deFator
           p_de-qt-solic   = p_de-qt-solic * deFator.

    RETURN 'OK':U.
END PROCEDURE. /* PROCEDURE pi-converter-maior-unid: */
