
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

CREATE tt-param.
ASSIGN tt-param.cod-estab-ini       = ""
       tt-param.cod-estab-fim       = "zzzzz"
       tt-param.cod-emitente-ini    = 0
       tt-param.cod-emitente-fim    = 99999999
       tt-param.it-codigo-ini       = ""
       tt-param.it-codigo-fim        = "zzzzzzzzzzz"
       tt-param.natur-oper-ini      = ""
       tt-param.natur-oper-fim      = "zzzzzzzzz"
       tt-param.dt-emiss-ini        = 03/01/2019
       tt-param.dt-emiss-fim        = 03/31/2019.

/* def temp-table tt-raw-digita                  */
/*         field raw-digita    as raw.           */
/* /* recebimento de parmetros */               */
/* def input parameter raw-param as raw no-undo. */
/* def input parameter TABLE for tt-raw-digita.  */
/* create tt-param.                              */
/* RAW-TRANSFER raw-param to tt-param.           */



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

DEFINE TEMP-TABLE TT-SAIDAS
    FIELD TTV-CFOP          AS CHAR FORMAT 'X(6)'
    FIELD TTV-UF-ORIGEM     AS CHAR FORMAT 'X(2)'
    FIELD TTV-COD-ESTAB     AS CHAR FORMAT 'X(5)'
    FIELD TTV-NOME-ESTAB    AS CHAR FORMAT 'X(40)'
    FIELD TTV-CDN-CLIENTE   AS INTEGER FORMAT '>>>,>>>,>>9'
    FIELD TTV-NOME-CLIENTE  AS CHAR FORMAT 'X(40)'
    FIELD TTV-UF-DESTINO    AS CHAR FORMAT 'X(2)'
    FIELD TTV-CONTRIBUINTE  AS LOGICAL
    FIELD TTV-IT-CODIGO     AS CHAR FORMAT 'X(8)'
    FIELD TTV-DESCRICAO     AS CHAR FORMAT 'X(40)'
    FIELD TTV-VLR-ORIGINAL  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-BASE-ICMS     AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-ALIQUOTA      AS DEC FORMAT ">>>.99"
    FIELD TTV-BASE-ICMS-ST  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS-ST   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-QTDE          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-NR-NF         AS CHAR FORMAT '9999999'
    FIELD TTV-DT-EMISSAO    AS DATE
    FIELD TTV-ORIGEM        AS CHAR
    FIELD TTV-NATUR-OPER    AS CHAR.


DEFINE TEMP-TABLE TT-ENTRADAS
    FIELD TTV-CFOP              AS CHAR FORMAT 'X(6)'
    FIELD TTV-UF-ORIGEM         AS CHAR FORMAT 'X(2)'
    FIELD TTV-COD-ESTAB         AS CHAR FORMAT 'X(5)'
    FIELD TTV-NOME-ESTAB        AS CHAR FORMAT 'X(40)'
    FIELD TTV-CDN-FORNEC        AS INTEGER FORMAT '>>>,>>>,>>9'
    FIELD TTV-NOME-FOREC        AS CHAR FORMAT 'X(40)'
    FIELD TTV-UF-DESTINO        AS CHAR FORMAT 'X(2)'
    FIELD TTV-CONTRIBUINTE      AS LOGICAL
    FIELD TTV-IT-CODIGO         AS CHAR FORMAT 'X(8)'
    FIELD TTV-DESCRICAO         AS CHAR FORMAT 'X(40)'
    FIELD TTV-VLR-ORIGINAL      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-BASE-ICMS         AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-ALIQUOTA          AS DEC FORMAT ">>>.99"
    FIELD TTV-BASE-ICMS-ST      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS-ST       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-QTDE              AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-NR-NF             AS CHAR FORMAT '9999999'
    FIELD TTV-DT-EMISSAO        AS DATE
    FIELD TTV-ORIGEM            AS CHAR
    FIELD TTV-LOTE              AS CHARACTER
    FIELD TTV-CDN-CLIENTE       AS INTEGER FORMAT '>>>,>>>,>>9'
    FIELD TTV-NF-SAIDA          AS CHAR FORMAT '9999999'
    FIELD TTV-SERIE             AS CHAR
    FIELD TTV-VLR-ICMS-ST-SAI   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-QTDE-SAI          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".

DEFINE VARIABLE v-base-st   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEFINE VARIABLE v-vlr-st    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEFINE VARIABLE v-qtde      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEFINE VARIABLE m-linha     AS INTEGER NO-UNDO.
{utp/utapi013.i}
run utp/utapi013.p persistent set h-utapi013.
/*SYSTEM-DIALOG PRINTER-SETUP.*/
os-delete value("c:\temp\teste_utapi013.xls").

CREATE tt-configuracao2.
ASSIGN tt-configuracao2.versao-integracao   = 1
       tt-configuracao2.arquivo-num         = 1
       tt-configuracao2.arquivo             = "c:\temp\teste_utapi013.xls"
       tt-configuracao2.total-planilha      = 3
       tt-configuracao2.exibir-construcao   = no
       tt-configuracao2.abrir-excel-termino = yes
       tt-configuracao2.imprimir = no
       tt-configuracao2.orientacao = 2.

CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num   = 1
       tt-planilha2.planilha-num  = 1
       tt-planilha2.planilha-nome = "Entradas"
       tt-planilha2.linhas-grade  = NO       
       tt-planilha2.formatar-planilha = NO
       tt-planilha2.formatar-faixa = YES.
          
CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num   = 1
       tt-planilha2.planilha-num  = 2
       tt-planilha2.planilha-nome = "Saidas"
       tt-planilha2.linhas-grade  = NO       
       tt-planilha2.formatar-planilha = NO
       tt-planilha2.formatar-faixa = YES.

CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num   = 1
       tt-planilha2.planilha-num  = 3
       tt-planilha2.planilha-nome = "Resumo"
       tt-planilha2.linhas-grade  = NO       
       tt-planilha2.formatar-planilha = NO
       tt-planilha2.formatar-faixa = YES.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CFOP".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "UF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "EMISSOR".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 4
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DESCRICAO".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 5
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CLIENTE".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 6
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "RAZAO SOCIAL".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 7
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "UF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 8
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CONTRIBUINTE ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 9
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ITEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 10
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DESCRICAO ITEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 11
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR.ORIGINAL".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 12
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "BASE ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 13
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 14
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ALQ ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 15
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "BASE ICMS ST".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 16
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR.ICMS ST".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 17
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "QTDE".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 18
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NR.NF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 19
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DT.EMISSAO".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 20
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ORIGEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 21
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NAT.OPER".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 22
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NCM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 23
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CLINICA VETERINARIA".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 24
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DISTRIBUIDOR".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 25
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "PORTARIA CAT".


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CFOP".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "UF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "EMISSOR".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 4
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DESCRICAO".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 5
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CLIENTE".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 6
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "RAZAO SOCIAL".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 7
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "UF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 8
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CONTRIBUINTE ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 9
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ITEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 10
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DESCRICAO ITEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 11
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR.ORIGINAL".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 12
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "BASE ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 13
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 14
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ALQ ICMS".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 15
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "BASE ICMS ST".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 16
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "VLR.ICMS ST".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 17
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "QTDE".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 18
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NR.NF".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 19
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DT.EMISSAO".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 20
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "ORIGEM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 21
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NAT.OPER".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 22
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "NCM".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 23
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "CLINICA VETERINARIA".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 24
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "DISTRIBUIDOR".

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 2
       tt-dados.celula-coluna = 25
       tt-dados.celula-linha  = 1
       tt-dados.celula-valor  = "PORTARIA CAT".



           ASSIGN m-linha = m-linha + 1.

           RUN utp/ut-acomp.p PERSISTENT SET h-prog.
           RUN pi-saidas.
           RUN pi-entradas.
           RUN pi-resumo.
           RUN pi-excel.
           RUN pi-finalizar IN h-prog.

RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                               INPUT-OUTPUT TABLE tt-planilha2,
                               INPUT-OUTPUT TABLE tt-dados,
                               INPUT-OUTPUT TABLE tt-formatar,
                               INPUT-OUTPUT TABLE tt-grafico2,
                               INPUT-OUTPUT TABLE tt-erros).


PROCEDURE pi-saidas:


          FIND FIRST tt-param NO-ERROR.

          RUN pi-inicializar IN h-prog (INPUT "Saidas").


          FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel            >= tt-param.cod-estab-ini
                                       AND   nota-fiscal.cod-estabel            <= tt-param.cod-estab-fim
                                       AND   nota-fiscal.cod-emitente           >= tt-param.cod-emitente-ini
                                       AND   nota-fiscal.cod-emitente           <= tt-param.cod-emitente-fim
                                       AND   nota-fiscal.dt-emis-nota           >= tt-param.dt-emiss-ini
                                       AND   nota-fiscal.dt-emis-nota           <= tt-param.dt-emiss-fim
                                       AND   nota-fiscal.idi-sit-nf-eletro      = 3 
                                       AND   nota-fiscal.ind-sit-nota           <> 4
                                       AND   nota-fiscal.emite-duplic           = YES
                                       AND   nota-fiscal.esp-docto              = 22,
               EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                            AND   it-nota-fisc.serie       = nota-fiscal.serie
                                            AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                                            AND   it-nota-fisc.cd-emitente = nota-fiscal.cod-emitente  BREAK BY nota-fiscal.cod-estabel BY nota-fiscal.dt-emis-nota:


                  FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
                  FIND FIRST emitente  NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                  FIND FIRST ITEM      NO-LOCK WHERE ITEM.it-codigo        = it-nota-fisc.it-codigo NO-ERROR.



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
          RUN pi-acompanhar IN h-prog (INPUT "Data: " + string(nota-fiscal.dt-emis-nota) + " Estab " + nota-fiscal.cod-estabel + " NF " + nota-fiscal.nr-nota-fis).

          CREATE TT-SAIDAS.
          ASSIGN TT-SAIDAS.TTV-CFOP                = it-nota-fisc.nat-operacao  
                 TT-SAIDAS.TTV-UF-ORIGEM           = estabelec.estado           
                 TT-SAIDAS.TTV-COD-ESTAB           = it-nota-fisc.cod-estabel   
                 TT-SAIDAS.TTV-NOME-ESTAB          = estabelec.nome             
                 TT-SAIDAS.TTV-CDN-CLIENTE         = nota-fiscal.cod-emitente   
                 TT-SAIDAS.TTV-NOME-CLIENTE        = emitente.nome-abrev        
                 TT-SAIDAS.TTV-UF-DESTINO          = emitente.estado            
                 TT-SAIDAS.TTV-CONTRIBUINTE        = emitente.contrib-icms      
                 TT-SAIDAS.TTV-IT-CODIGO           = it-nota-fisc.it-codigo     
                 TT-SAIDAS.TTV-DESCRICAO           = item.descricao-1           
                 TT-SAIDAS.TTV-VLR-ORIGINAL        = it-nota-fisc.vl-tot-item   
                 TT-SAIDAS.TTV-BASE-ICMS           = it-nota-fisc.vl-bicms-it   
                 TT-SAIDAS.TTV-VLR-ICMS            = it-nota-fisc.vl-icms-it    
                 TT-SAIDAS.TTV-ALIQUOTA            = it-nota-fisc.aliquota-icm  
                 TT-SAIDAS.TTV-BASE-ICMS-ST        = it-nota-fisc.vl-bsubs-it   
                 TT-SAIDAS.TTV-VLR-ICMS-ST         = it-nota-fisc.vl-icmsub-it  
                 TT-SAIDAS.TTV-QTDE                = it-nota-fisc.qt-faturada[1]
                 TT-SAIDAS.TTV-NR-NF               = it-nota-fisc.nr-nota-fis   
                 TT-SAIDAS.TTV-DT-EMISSAO          = nota-fiscal.dt-emis-nota  
                 TT-SAIDAS.TTV-ORIGEM              = "Faturamento"              
                 TT-SAIDAS.TTV-NATUR-OPER          = it-nota-fisc.nat-operacao.  
                                                       


              CREATE tt-resumo.
              ASSIGN tt-resumo.ttv-uf                   = emitente.estado
                     tt-resumo.ttv-origem               = "Faturamento"
                     tt-resumo.ttv-vlr-original         = it-nota-fisc.vl-tot-item
                     tt-resumo.ttv-vlr-base-icms        = it-nota-fisc.vl-bicms-it
                     tt-resumo.ttv-vlr-icms             = it-nota-fisc.vl-icms-it
                     tt-resumo.ttv-vlr-base-st          = it-nota-fisc.vl-bsubs-it
                     tt-resumo.ttv-vlr-icms-st          = it-nota-fisc.vl-bsubs-it
                     tt-resumo.ttv-natur-oper           = it-nota-fisc.nat-operacao.

    END.


END PROCEDURE.


PROCEDURE pi-entradas:


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
                                          AND   item-doc-est.it-codigo    = movto-estoq.it-codigo
                                          :

                RUN pi-acompanhar IN h-prog (INPUT "It-codigo " + item-doc-est.it-codigo + " Emitente " + string(item-doc-est.cod-emitente) + " NF " + item-doc-est.nro-docto + " Serie " + item-doc-est.serie-docto).


            FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-ERROR.

            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente   = movto-estoq.cod-emitente NO-ERROR.

            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

            ASSIGN v-vlr-st = v-vlr-st - item-doc-est.vl-subs[1]
                   v-qtde   = v-qtde   - item-doc-est.quantidade.


            CREATE tt-entradas.
            ASSIGN tt-entradas.TTV-CFOP                   = item-doc-est.nat-operacao                            
                   tt-entradas.TTV-UF-ORIGEM              = estabelec.estado                                     
                   tt-entradas.TTV-COD-ESTAB              = estabelec.cod-estabel                                
                   tt-entradas.TTV-NOME-ESTAB             = estabelec.nome                                       
                   tt-entradas.TTV-CDN-FORNEC             = item-doc-est.cod-emitente                            
                   tt-entradas.TTV-NOME-FOREC             = emitente.nome-emit                                   
                   tt-entradas.TTV-UF-DESTINO             = emitente.estado                                      
                   tt-entradas.TTV-CONTRIBUINTE           = emitente.contrib-icms                              
                   tt-entradas.TTV-IT-CODIGO              = item-doc-est.it-codigo                               
                   tt-entradas.TTV-DESCRICAO              = item.descricao-1                                     
                   tt-entradas.TTV-VLR-ORIGINAL           = (item-doc-est.preco-unit[1] * item-doc-est.quantidade)
                   tt-entradas.TTV-BASE-ICMS              = item-doc-est.base-icm[1]                             
                   tt-entradas.TTV-VLR-ICMS               = item-doc-est.valor-icm[1]                            
                   tt-entradas.TTV-ALIQUOTA               = item-doc-est.aliquota-icm                            
                   tt-entradas.TTV-BASE-ICMS-ST           = item-doc-est.base-subs[1]                            
                   tt-entradas.TTV-VLR-ICMS-ST            = item-doc-est.vl-subs[1]                              
                   tt-entradas.TTV-QTDE                   = item-doc-est.quantidade                              
                   tt-entradas.TTV-NR-NF                  = item-doc-est.nro-docto                               
                   tt-entradas.TTV-DT-EMISSAO             = movto-estoq.dt-trans                                        
                   tt-entradas.TTV-ORIGEM                 = "Recebimento"                                        
                   tt-entradas.TTV-LOTE                   = tt-controle.ttv-lote                                 
                   tt-entradas.TTV-CDN-CLIENTE            = tt-controle.ttv-cod-emitente                         
                   tt-entradas.TTV-NF-SAIDA               = tt-controle.ttv-nr-nota-fis                          
                   tt-entradas.TTV-SERIE                  = tt-controle.ttv-serie                                
                   tt-entradas.TTV-VLR-ICMS-ST-SAI        = v-vlr-st                                             
                   tt-entradas.TTV-QTDE-SAI               = (v-qtde).                                              
                                                                                     




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

/*     chworksheet=chWorkBook:sheets:item(3).                                                                                                                */
/*     chworksheet:name="Resumo". /* Nome que ser¿ criada a Pasta da Planilha */                                                                             */
/*     m-linha = 2.                                                                                                                                          */
/*     chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */                                                                        */
/*     chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */                                                              */
/*     chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */                                                                                   */
/*     chworksheet:range("A1:q1"):SetValue("ICMS ST").                                                                                                       */
/*     chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */                                                                         */
/*     chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */                                                               */
/*   /* Cria os titulos para as colunas do relat÷rio */                                                                                                      */
/*         chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */                                                 */
/*         chworksheet:range("A" + STRING(m-linha)):SetValue("Origem").                                                                                      */
/*         chworksheet:range("b" + STRING(m-linha)):SetValue("UF").                                                                                          */
/*         chworksheet:range("c" + STRING(m-linha)):SetValue("Nat.Oper").                                                                                    */
/*         chworksheet:range("d" + STRING(m-linha)):SetValue("Vlr.Original").                                                                                */
/*         chworksheet:range("e" + STRING(m-linha)):SetValue("Vlr. Base ICMS").                                                                              */
/*         chworksheet:range("f" + STRING(m-linha)):SetValue("Vlr. ICMS").                                                                                   */
/*         chworksheet:range("g" + STRING(m-linha)):SetValue("Vlr. Base ICMS ST").                                                                           */
/*         chworksheet:range("h" + STRING(m-linha)):SetValue("Vlr. ICMS ST").                                                                                */
/*         ASSIGN m-linha = m-linha + 1.                                                                                                                     */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*         RUN pi-inicializar IN h-prog (INPUT "Resumo").                                                                                                    */
/*     FOR EACH tt-resumo BREAK BY ttv-origem + ttv-uf + ttv-natur-oper:                                                                                     */
/*                                                                                                                                                           */
/*         RUN pi-acompanhar IN h-prog(INPUT tt-resumo.ttv-origem + " UF " + tt-resumo.ttv-uf).                                                              */
/*         ACCUMULATE tt-resumo.ttv-vlr-original  (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).                                             */
/*         ACCUMULATE tt-resumo.ttv-vlr-base-icms (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).                                             */
/*         ACCUMULATE tt-resumo.ttv-vlr-icms      (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).                                             */
/*         ACCUMULATE tt-resumo.ttv-vlr-base-st   (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).                                             */
/*         ACCUMULATE tt-resumo.ttv-vlr-icms-st   (SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper).                                             */
/*                                                                                                                                                           */
/*     IF LAST-OF(tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper) THEN DO:                                                                                   */
/*                                                                                                                                                           */
/*         chworksheet:range("A" + STRING(m-linha)):SetValue(tt-resumo.ttv-origem).                                                                          */
/*         chworksheet:range("b" + STRING(m-linha)):SetValue(tt-resumo.ttv-uf).                                                                              */
/*         chworksheet:range("c" + STRING(m-linha)):SetValue(tt-resumo.ttv-natur-oper).                                                                      */
/*         chworksheet:range("d" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-original).  */
/*         chworksheet:range("e" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-base-icms). */
/*         chworksheet:range("f" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-icms).      */
/*         chworksheet:range("g" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-base-st).   */
/*         chworksheet:range("h" + STRING(m-linha)):SetValue(ACCUM SUB-TOTAL BY tt-resumo.ttv-origem + ttv-uf + ttv-natur-oper tt-resumo.ttv-vlr-icms-st).   */
/* ASSIGN m-linha = m-linha + 1.                                                                                                                             */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*     END.                                                                                                                                                  */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*     END.                                                                                                                                                  */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
/*                                                                                                                                                           */
END PROCEDURE.

PROCEDURE pi-excel:


    

        ASSIGN m-linha = 2.    
        FOR EACH tt-saidas:
            RUN pi-acompanhar IN h-prog(INPUT "Saidas Excel " + TT-SAIDAS.TTV-CFOP + " Data " + string(TT-SAIDAS.TTV-DT-EMISSAO) + " Docto " + TT-SAIDAS.TTV-NR-NF ).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 1
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-CFOP).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 2
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-UF-ORIGEM).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 3
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-COD-ESTAB).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 4
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-NOME-ESTAB).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 5
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-CDN-CLIENTE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 6
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-NOME-CLIENTE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 7
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-UF-DESTINO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 8
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-CONTRIBUINTE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 9
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-IT-CODIGO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 10
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-DESCRICAO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 11
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-VLR-ORIGINAL).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 12
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-BASE-ICMS).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 13
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-VLR-ICMS).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 14
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-ALIQUOTA).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 15
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-BASE-ICMS-ST).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 16
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-BASE-ICMS-ST).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 17
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-VLR-ICMS-ST).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 18
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-QTDE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 19
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-NR-NF).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 20
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-DT-EMISSAO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 21
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-ORIGEM).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 1
                   tt-dados.celula-coluna = 22
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(TT-SAIDAS.TTV-NATUR-OPER).

            ASSIGN m-linha = m-linha + 1.

        END.


        m-linha = 2.

            
        FOR EACH tt-entradas:

            RUN pi-acompanhar IN h-prog(INPUT "Entradas Excel " + tt-entradas.TTV-CFOP + " Data " + string(tt-entradas.TTV-DT-EMISSAO) + " Docto " + tt-entradas.TTV-NR-NF ).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 1                                                                          
                   tt-dados.celula-linha  = m-linha                                                                    
                   tt-dados.celula-valor  = string(tt-entradas.TTV-CFOP).                                                      
                                                                                                                       
            CREATE tt-dados.                                                                                           
            ASSIGN tt-dados.arquivo-num   = 1                                                                       
                   tt-dados.planilha-num  = 2                                                                       
                   tt-dados.celula-coluna = 2                                                                       
                   tt-dados.celula-linha  = m-linha                                                                 
                   tt-dados.celula-valor  = string(tt-entradas.TTV-UF-ORIGEM).                                            
                                                                                                                  
            CREATE tt-dados.                                                                                      
            ASSIGN tt-dados.arquivo-num   = 1                                                                     
                   tt-dados.planilha-num  = 2                                                                     
                   tt-dados.celula-coluna = 3                                                                     
                   tt-dados.celula-linha  = m-linha                                                               
                   tt-dados.celula-valor  = string(tt-entradas.TTV-COD-ESTAB).                                            
                                                                                                                  
            CREATE tt-dados.                                                                                      
            ASSIGN tt-dados.arquivo-num   = 1                                                                     
                   tt-dados.planilha-num  = 2                                                                     
                   tt-dados.celula-coluna = 4                                                                     
                   tt-dados.celula-linha  = m-linha                                                               
                   tt-dados.celula-valor  = string(tt-entradas.TTV-NOME-ESTAB).                                           
                                                                                                                  
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 5
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-CDN-fornec).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 6
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-NOME-FOREC).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 7
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-UF-DESTINO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 8
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-CONTRIBUINTE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 9
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-IT-CODIGO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2                                                                                
                   tt-dados.celula-coluna = 10                                                                               
                   tt-dados.celula-linha  = m-linha                                                                          
                   tt-dados.celula-valor  = string(tt-entradas.TTV-DESCRICAO).                                                       
                                                                                                                             
            CREATE tt-dados.                                                                                                 
            ASSIGN tt-dados.arquivo-num   = 1                                                                           
                   tt-dados.planilha-num  = 2                                                                           
                   tt-dados.celula-coluna = 11                                                                          
                   tt-dados.celula-linha  = m-linha                                                                     
                   tt-dados.celula-valor  = string(tt-entradas.TTV-VLR-ORIGINAL).                                                
                                                                                                                        
            CREATE tt-dados.                                                                                            
            ASSIGN tt-dados.arquivo-num   = 1                                                                           
                   tt-dados.planilha-num  = 2                                                                           
                   tt-dados.celula-coluna = 12                                                                          
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-BASE-ICMS).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 13
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-VLR-ICMS).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 14
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-ALIQUOTA).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 15
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-BASE-ICMS-ST).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 16
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-BASE-ICMS-ST).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 17
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-VLR-ICMS-ST).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 18
                   tt-dados.celula-linha  = m-linha                                                                  
                   tt-dados.celula-valor  = string(tt-entradas.TTV-QTDE).                                                      
                                                                                                                     
            CREATE tt-dados.                                                                                         
            ASSIGN tt-dados.arquivo-num   = 1                                                                        
                   tt-dados.planilha-num  = 2                                                                
                   tt-dados.celula-coluna = 19                                                               
                   tt-dados.celula-linha  = m-linha                                                          
                   tt-dados.celula-valor  = string(tt-entradaS.TTV-NR-NF).                                           
                                                                                                             
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 20
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-DT-EMISSAO).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 21
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-ORIGEM).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 22
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.ttv-lote).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 23
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-CDN-CLIENTE).


            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 24
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-NF-SAIDA).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 25
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-SERIE).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 26
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-VLR-ICMS-ST-SAI).

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num   = 1
                   tt-dados.planilha-num  = 2
                   tt-dados.celula-coluna = 27
                   tt-dados.celula-linha  = m-linha
                   tt-dados.celula-valor  = string(tt-entradas.TTV-QTDE-SAI).


            ASSIGN m-linha = m-linha + 1.


            END.

END PROCEDURE.



