DEFINE TEMP-TABLE tt-tratamento
    FIELD ttv-condicao    AS INTEGER
    FIELD ttv-it-codigo   AS CHAR
    FIELD ttv-quantidade  AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv-dt-entrega  AS DATE
    FIELD ttv-preco       AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv-deposito    AS CHAR
    FIELD ttv-un          AS CHARACTER
    FIELD ttv-linha       AS INTEGER
    FIELD ttv-coluna      AS INTEGER
    FIELD ttv-num-pedido  AS INTEGER
    .
{utp/utapi018.i}

DEF INPUT param TABLE FOR tt-tratamento.
DEFINE INPUT param p-planilha AS char.

CREATE tt-configuracao2.
ASSIGN tt-configuracao2.versao-integracao             = 1
              tt-configuracao2.arquivo-num            = 1
              tt-configuracao2.arquivo                = p-planilha
              tt-configuracao2.abrir-excel-termino    = no
              tt-configuracao2.imprimir               = no.



    FOR EACH tt-tratamento:

         CREATE tt-dados.
         ASSIGN tt-dados.arquivo-num   = 1
                       tt-dados.planilha-num   = 1
                       tt-dados.celula-coluna  = tt-tratamento.ttv-coluna - 2
                       tt-dados.celula-linha     = tt-tratamento.ttv-linha
                       tt-dados.celula-valor     = string(tt-tratamento.ttv-num-pedido).
            
    END.
        
RUN utp/utapi018.p PERSISTENT SET h-utapi018.

RUN pi-execute IN h-utapi018 (INPUT-OUTPUT TABLE tt-configuracao2, 
                                                  INPUT-OUTPUT TABLE tt-dados,
                                                  INPUT-OUTPUT TABLE tt-erros).



for each tt-erros: 
    disp tt-erros.cod-erro
            tt-erros.desc-erro with 1 col width 300. 
end.

delete procedure h-utapi018.

