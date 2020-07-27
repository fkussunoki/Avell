{utp/utapi013.i} 


DEF TEMP-TABLE tt-faturamento
    FIELD ttv-cod-estabel       AS char
    FIELD ttv-dt-emissao        AS date
    FIELD ttv-serie             AS char
    FIELD ttv-nr-nota-fis       AS char
    FIELD ttv-nome-ab-cli       AS CHar
    FIELD ttv-cgc               AS char
    FIELD ttv-ie                AS char
    FIELD ttv-uf                AS CHar
    FIELD ttv-it-codigo         AS char
    FIELD ttv-descricao         AS char
    FIELD ttv-ncm               AS char
    FIELD ttv-cst-pis           AS char
    FIELD ttv-cst-cofins        AS char
    FIELD ttv-cst-icms          AS char
    FIELD ttv-cst-ipi           AS CHAR
    FIELD tt-lista              AS char
    FIELD ttv-ge-codigo         AS CHAR
    FIELD ttv-fm-codigo         AS CHAR
    FIELD ttv-concatena         AS char
    FIELD ttv-quantidade        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-mercadoria    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-PIS           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-COFINS        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-ipi           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-vlr-icms          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-estab-pedido      AS CHAR
    FIELD ttv-tipo              AS char
    FIELD ttv-natur-oper        AS char
    FIELD ttv-natur-oper-desc   AS CHAR
    
    INDEX TTA-CONCATENA
    ttv-concatena ASCENDING.

DEF VAR h-prog AS HANDLE.
DEF VAR i-linha AS INTEGER.


os-delete value("c:\temp\esrc770.xlsx").

empty temp-table tt-configuracao2.
empty temp-table tt-planilha2.
empty temp-table tt-dados.

run utp/utapi013.p persistent set h-utapi013.

CREATE tt-configuracao2.
ASSIGN tt-configuracao2.versao-integracao   = 1
       tt-configuracao2.arquivo-num         = 1
       tt-configuracao2.arquivo             = "c:\temp\esrc770.xlsx"
       tt-configuracao2.total-planilha      = 2
       tt-configuracao2.exibir-construcao   = no
       tt-configuracao2.abrir-excel-termino = yes
       tt-configuracao2.imprimir = no
       tt-configuracao2.orientacao = 2.

CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num   = 1
       tt-planilha2.planilha-num  = 1
       tt-planilha2.planilha-nome = "Plan 1"
       tt-planilha2.linhas-grade  = no
       tt-planilha2.largura-coluna = 12.50
       tt-planilha2.formatar-planilha = NO
       tt-planilha2.formatar-faixa = YES.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Periodo"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = /*string(tt-param.dt-periodo-ini) + " a " + STRING(tt-param.dt-periodo-fim)*/ ""
       tt-dados.celula-fonte-negrito = yes.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string("APURACAO DE PIS / COFINS NAS ENTRADAS - NORMAL")
       tt-dados.celula-fonte-negrito = yes.


ASSIGN i-linha = 3.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Estab"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Data"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CNPJ"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 4
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "IE"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 5
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "UF"
       tt-dados.celula-fonte-negrito = yes.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 6
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Docto"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 7
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Item"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 8
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "NCM"
       tt-dados.celula-fonte-negrito = yes.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 9
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Emitente"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 10
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CFOP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 11
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Natureza"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 12
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Descricao CFOP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 13
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. Contabil"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 14
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "B. Calc. PIS"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 15
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "B. Calc. COFINS"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 16
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. ICMS"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 17
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. IPI"
       tt-dados.celula-fonte-negrito = yes.





CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 18
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. PIS/PASEP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 19
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. COFINS"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 20
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CST PIS"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 21
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CST COFINS"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 22
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CST ICMS"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 23
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CST IPI"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 24
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Tipo"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 25
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Lista"
       tt-dados.celula-fonte-negrito = yes.
assign i-linha = i-linha + 1.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").

FOR EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.dt-emis-nota >= 12/01/2018
                              AND   it-nota-fisc.dt-emis-nota <= 12/31/2018
                              
                              
                             :

    FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                   AND   nota-fiscal.serie       = it-nota-fisc.serie
                                   AND   nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                   AND   nota-fiscal.nome-ab-cli = it-nota-fisc.nome-ab-cli
                                   AND   nota-fiscal.nat-operacao = it-nota-fisc.nat-operacao
                                   AND   nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR. /* uso autorizado */

    IF AVAIL nota-fiscal THEN DO:

        FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.


/*         FIND FIRST movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel = nota-fiscal.cod-estabel           */
/*                                        AND   movto-estoq.it-codigo   = it-nota-fisc.it-codigo            */
/*                                        AND   movto-estoq.serie-docto = nota-fiscal.serie                 */
/*                                        AND   movto-estoq.nro-docto   = nota-fiscal.nr-nota-fis           */
/*                                        AND   movto-estoq.cod-emitente = emitente.cod-emitente NO-ERROR.  */
/*                                                                                                          */
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



        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        FIND FIRST ext-item NO-LOCK WHERE ext-item.it-codigo = ITEM.it-codigo NO-ERROR.

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
          
       

        CREATE tt-faturamento.
        ASSIGN
        tt-faturamento.ttv-cod-estabel                    = it-nota-fisc.cod-estabel 
        tt-faturamento.ttv-dt-emissao                     = it-nota-fisc.dt-emis-nota
        tt-faturamento.ttv-serie                          = it-nota-fisc.serie
        tt-faturamento.ttv-nr-nota-fis                    = string(it-nota-fisc.nr-nota-fis)
        tt-faturamento.ttv-nome-ab-cli                    = it-nota-fisc.nome-ab-cli
        tt-faturamento.ttv-cgc                            = emitente.cgc
        tt-faturamento.ttv-ie                             = emitente.ins-estadual
        tt-faturamento.ttv-uf                             = emitente.estado
        tt-faturamento.ttv-it-codigo                      = it-nota-fisc.it-codigo
        tt-faturamento.ttv-descricao                      = ITEM.descricao-1
        tt-faturamento.ttv-ncm                            = item.class-fiscal
        tt-faturamento.ttv-cst-pis                        = SUBSTRING(it-nota-fisc.char-2, 96, 1)
        tt-faturamento.ttv-cst-cofins                     = SUBSTRING(it-nota-fisc.char-2, 97, 1)
        tt-faturamento.ttv-cst-icms                       = string(it-nota-fisc.cd-trib-icm)
        tt-faturamento.ttv-cst-ipi                        = string(it-nota-fisc.cd-trib-ipi).
         
        IF ext-item.lista = 0 THEN  

        ASSIGN  tt-faturamento.tt-lista                              = "Positiva". 


        IF ext-item.lista = 1 THEN  

        ASSIGN  tt-faturamento.tt-lista                              = "Negativa".



        IF ext-item.lista = 2 THEN  

        ASSIGN  tt-faturamento.tt-lista                   = "Neutra". 
        ASSIGN  tt-faturamento.ttv-ge-codigo              = string(ITEM.ge-codigo)
        tt-faturamento.ttv-fm-codigo                      = string(ITEM.fm-codigo)
        tt-faturamento.ttv-concatena                      = ""
        tt-faturamento.ttv-quantidade                     = it-nota-fisc.qt-faturada[1]
        tt-faturamento.ttv-vlr-mercadoria                 = it-nota-fisc.vl-tot-item
        tt-faturamento.ttv-vlr-PIS                        = it-nota-fisc.vl-tot-item * DECIMAL(substring(it-nota-fisc.char-2,81,5)) / 100  /*movto-estoq.valor-pis*/
        tt-faturamento.ttv-vlr-COFINS                     = it-nota-fisc.vl-tot-item * DECIMAL(substring(it-nota-fisc.char-2,76,5)) / 100 /* movto-estoq.val-cofins */
        tt-faturamento.ttv-vlr-ipi                        = it-nota-fisc.vl-ipi-it
        tt-faturamento.ttv-vlr-icms                       = it-nota-fisc.vl-icms-it
        tt-faturamento.ttv-tipo                           = "Saida"
        tt-faturamento.ttv-natur-oper                     = it-nota-fisc.nat-operacao
        tt-faturamento.ttv-natur-oper-desc                = natur-oper.denominacao.

        
  END.

END.

RUN pi-finalizar IN h-prog.




RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").

FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.dt-docto >= 12/01/2018
                             AND   it-doc-fisc.dt-docto <= 12/31/2018:


    FIND FIRST doc-fiscal NO-LOCK WHERE doc-fiscal.cod-estabel = it-doc-fisc.cod-estabel
                                  AND   doc-fiscal.serie       = it-doc-fisc.serie
                                  AND   doc-fiscal.nr-doc-fis  = it-doc-fisc.nr-doc-fis
                                  AND   doc-fiscal.cod-emitente = it-doc-fisc.cod-emitente
                                  AND   doc-fiscal.dt-emis-doc = it-doc-fisc.dt-emis-doc
                                  NO-ERROR.

    IF AVAIL doc-fiscal THEN DO:


/*         FIND FIRST movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel = doc-fiscal.cod-estabel             */
/*                                        AND   movto-estoq.it-codigo   = it-doc-fisc.it-codigo              */
/*                                        AND   movto-estoq.serie-docto = doc-fiscal.serie                   */
/*                                        AND   movto-estoq.nro-docto   = doc-fiscal.nr-doc-fis              */
/*                                        AND   movto-estoq.cod-emitente = doc-fiscal.cod-emitente NO-ERROR. */
        

        RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(it-doc-fisc.dt-emis-doc) + string(it-doc-fisc.nr-doc-fis)).


        FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = it-doc-fisc.cod-emitente NO-ERROR.


            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-doc-fisc.it-codigo NO-ERROR.

            FIND FIRST ext-item NO-LOCK WHERE ext-item.it-codigo = ITEM.it-codigo NO-ERROR.

            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao NO-ERROR.


            CREATE tt-faturamento.
            ASSIGN
            tt-faturamento.ttv-cod-estabel                    = it-doc-fisc.cod-estabel 
            tt-faturamento.ttv-dt-emissao                     = it-doc-fisc.dt-emis-doc
            tt-faturamento.ttv-serie                          = it-doc-fisc.serie
            tt-faturamento.ttv-nr-nota-fis                    = string(it-doc-fisc.nr-doc-fis)
            tt-faturamento.ttv-nome-ab-cli                    = emitente.nome-abrev
            tt-faturamento.ttv-cgc                            = emitente.cgc
            tt-faturamento.ttv-ie                             = emitente.ins-estadual
            tt-faturamento.ttv-uf                             = emitente.estado
            tt-faturamento.ttv-it-codigo                      = it-doc-fisc.it-codigo
            tt-faturamento.ttv-descricao                      = ITEM.descricao-1
            tt-faturamento.ttv-ncm                            = item.class-fiscal.

            RUN utp/ut-liter.p (INPUT {diinc/i01di084.i 04 it-doc-fisc.cd-trib-pis},
                                                                                INPUT "",
                                                                                INPUT "").

            tt-faturamento.ttv-cst-pis                        = TRIM(RETURN-VALUE). /* demanda */

            RUN utp/ut-liter.p (INPUT {diinc/i01di084.i 04 it-doc-fisc.cd-trib-cofins},
                                                                                INPUT "",
                                                                                INPUT "").

            tt-faturamento.ttv-cst-cofins                        = TRIM(RETURN-VALUE). /* demanda */


            RUN utp/ut-liter.p (INPUT {diinc/i01di084.i 04 it-doc-fisc.cd-trib-ipi},
                                                                                INPUT "",
                                                                                INPUT "").

            tt-faturamento.ttv-cst-ipi                        = TRIM(RETURN-VALUE). /* demanda */

            RUN utp/ut-liter.p (INPUT {diinc/i01di084.i 04 cd-trib-icm},
                                                                                INPUT "",
                                                                                INPUT "").

            tt-faturamento.ttv-cst-icms                        = TRIM(RETURN-VALUE). /* demanda */


            IF ext-item.lista = 1 THEN  

            ASSIGN  tt-faturamento.tt-lista                              = "Positiva". 


            IF ext-item.lista = 2 THEN  

            ASSIGN  tt-faturamento.tt-lista                              = "Negativa".



            IF ext-item.lista = 3 THEN  

            ASSIGN  tt-faturamento.tt-lista                   = "Neutra". 
            ASSIGN  tt-faturamento.ttv-ge-codigo              = string(ITEM.ge-codigo)
            tt-faturamento.ttv-fm-codigo                      = string(ITEM.fm-codigo)
            tt-faturamento.ttv-concatena                      = ""
            tt-faturamento.ttv-quantidade                     = it-doc-fisc.quantidade
            tt-faturamento.ttv-vlr-mercadoria                 = it-doc-fisc.vl-tot-item
            tt-faturamento.ttv-vlr-PIS                        = it-doc-fisc.val-pis
            tt-faturamento.ttv-vlr-COFINS                     = it-doc-fisc.val-cofins
            tt-faturamento.ttv-vlr-ipi                        = it-doc-fisc.vl-ipi-it
            tt-faturamento.ttv-vlr-icms                       = it-doc-fisc.vl-icms-it
            tt-faturamento.ttv-tipo                           = "Entrada"
            tt-faturamento.ttv-natur-oper                     = it-doc-fisc.nat-operacao
            tt-faturamento.ttv-natur-oper-desc                = natur-oper.denominacao.





    END.
END.




OUTPUT TO c:\temp\testea.txt.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Temp-table").
FOR EACH tt-faturamento BREAK BY tt-faturamento.ttv-concatena:


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-cod-estabel
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.TTV-dt-emissao)
       tt-dados.celula-fonte-negrito = NO.
    
CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-cgc
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 4
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-ie
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 5
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-uf
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 6
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-NR-NOTA-FIS
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 7
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-IT-CODIGO
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 8
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-NCM
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 9
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.TTV-NOME-AB-CLI
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 10
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = substring(TT-FATURAMENTO.ttv-natur-oper, 1, 4)
       tt-dados.celula-fonte-negrito = no.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 11
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-natur-oper
       tt-dados.celula-fonte-negrito = no.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 12
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-natur-oper-desc
       tt-dados.celula-fonte-negrito = no.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 13
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-mercadoria)  
       tt-dados.celula-fonte-negrito = no.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 14
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-mercadoria)  
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 15
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-mercadoria)  
       tt-dados.celula-fonte-negrito = NO.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 16
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-icms) 
       tt-dados.celula-fonte-negrito = NO.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 17
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-ipi)
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 18
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-pis)
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 19
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(TT-FATURAMENTO.ttv-vlr-cofins)
       tt-dados.celula-fonte-negrito = NO.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 20
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-cst-pis
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 21
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-cst-cofins
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 22
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-cst-icms
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 23
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-cst-ipi
       tt-dados.celula-fonte-negrito = NO.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 24
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.ttv-tipo
       tt-dados.celula-fonte-negrito = NO.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 25
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = TT-FATURAMENTO.tt-lista
       tt-dados.celula-fonte-negrito = NO.


assign i-linha = i-linha + 1.

END.

RUN pi-execute2 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                               INPUT-OUTPUT TABLE tt-planilha2,
                               INPUT-OUTPUT TABLE tt-dados,
                               INPUT-OUTPUT TABLE tt-formatar-faixa,
                               INPUT-OUTPUT TABLE tt-grafico2,
                               INPUT-OUTPUT TABLE tt-erros).



RUN pi-finalizar IN h-prog.

