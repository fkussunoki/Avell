/*****************************************************************************
**       PROGRAMA: doc123rb.p
**       DATA....: Maio de 2013
**       OBJETIVO: Leitura da Movto Estoq
**       VERSAO..: 2.06.00.000 
******************************************************************************/

DEF TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_empresa      LIKE estrut_ccusto.cod_empresa
    FIELD cod_plano_ccusto LIKE estrut_ccusto.cod_plano_ccusto
    FIELD cod_ccusto       LIKE estrut_ccusto.cod_ccusto_filho
    INDEX codigo IS PRIMARY UNIQUE cod_empresa     
                                   cod_plano_ccusto 
                                   cod_ccusto.

DEFINE TEMP-TABLE tt-movto-estoq NO-UNDO
    FIELD ct-codigo         AS CHAR
    FIELD sc-codigo         AS CHAR
    FIELD cod-estabel       AS CHAR
    FIELD nr-trans          AS INT
    FIELD data              AS DATE
    FIELD serie-docto       AS CHAR
    FIELD nro-docto         AS CHAR
    FIELD cod-emitente      AS INT
    FIELD nome-abrev        AS CHAR
    FIELD nat-operacao      AS CHAR
    FIELD it-codigo         AS CHAR
    FIELD esp-docto         AS INT
    FIELD descricao         AS CHAR
    FIELD val-movto         AS DEC
    FIELD val-fixo          AS DEC
    FIELD val-impostos      AS DEC
    FIELD quantidade        AS DEC
    FIELD usuario           AS CHAR
    FIELD gm-codigo         AS CHAR
    FIELD nome-abrev-requis AS CHAR
    INDEX codigo sc-codigo  
                 ct-codigo  
                 data       
                 cod-estabel
                 it-codigo  
                 esp-docto
                 nro-docto
                 nr-trans.

DEFINE TEMP-TABLE tt-resumo-movto-estoq NO-UNDO
    FIELD cod-estabel   AS CHAR
    FIELD ct-codigo     AS CHAR
    FIELD sc-codigo     AS CHAR
    FIELD data          AS DATE
    FIELD modulo        AS CHAR
    FIELD val-movto     AS DEC
    FIELD val-fixo      AS DEC
    INDEX codigo cod-estabel
                 ct-codigo  
                 sc-codigo  
                 modulo     
                 data.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD data          AS DATE
    FIELD cod-estabel   AS CHARACTER
    FIELD serie         AS CHARACTER
    FIELD nr-nota-fis   AS CHARACTER
    FIELD cod-emitente  AS INTEGER
    FIELD nat-operacao  AS CHARACTER
    FIELD ct-codigo     AS CHARACTER
    FIELD sc-codigo     AS CHARACTER
    FIELD valor         AS DECIMAL
    FIELD val-fixo      AS DECIMAL
    FIELD val-impostos  AS DEC
    INDEX codigo data
                 ct-codigo
                 sc-codigo
                 cod-estabel
                 serie
                 nr-nota-fis.

DEFINE TEMP-TABLE tt-docum-est NO-UNDO
    FIELD data          AS DATE
    FIELD cod-estabel   AS CHARACTER
    FIELD serie-docto   AS CHARACTER
    FIELD esp-docto     AS INT
    FIELD nro-docto     AS CHARACTER
    FIELD nat-operacao  AS CHARACTER
    FIELD cod-emitente  AS INTEGER
    FIELD ct-codigo     AS CHARACTER
    FIELD sc-codigo     AS CHARACTER
    FIELD valor         AS DECIMAL
    FIELD val-fixo      AS DECIMAL
    INDEX codigo data
                 ct-codigo   
                 sc-codigo
                 cod-estabel
                 serie-docto
                 nro-docto
                 cod-emitente
                 nat-operacao.

DEF INPUT  PARAM p-dt-ini         AS DATE   NO-UNDO.
DEF INPUT  PARAM p-dt-fim         AS DATE   NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-ccusto.
DEF OUTPUT PARAM TABLE FOR tt-movto-estoq.
DEF OUTPUT PARAM TABLE FOR tt-resumo-movto-estoq.
                              
DEF VAR da-aux                          AS DATE   NO-UNDO.  
DEF VAR de-valor-fixo                   AS DEC    NO-UNDO.
DEF VAR de-valor-movto                  AS DEC    NO-UNDO.
DEF VAR dt-refer                        AS DATE   NO-UNDO.
DEF VAR de-impostos                     AS DEC    NO-UNDO.
DEF VAR c-conta-icms-ft                 AS CHAR   NO-UNDO.
DEF VAR c-conta-ipi-ft                  AS CHAR   NO-UNDO.
DEF VAR c-conta-pis-ft                  AS CHAR   NO-UNDO.
DEF VAR c-conta-cofins-ft               AS CHAR   NO-UNDO.
DEF VAR de-pis                          AS DEC    NO-UNDO.
DEF VAR de-cofins                       AS DEC    NO-UNDO.

DEF VAR v_conta_expositor       AS CHAR INITIAL "435374" NO-UNDO.
DEF VAR v_conta_metais_exp      AS CHAR INITIAL "435375" NO-UNDO.


def new global shared var v_cdn_empres_usuar    like mguni.empresa.ep-codigo          no-undo.

DEF VAR h-acomp                         AS HANDLE NO-UNDO.

{cdp/cdcfgmat.i}

{dop/dfgl001.i}

RUN pi-busca-info IN h-dfgl001 (INPUT TODAY,
                                OUTPUT c-cod-emp,
                                OUTPUT c-plano-cta,
                                OUTPUT c-plano-cc).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Buscando informa‡äes do Estoque").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

IF cdn_empres_usuar = 'doc' THEN
    ASSIGN v_cdn_empres_usuar  = "2".

IF cdn_empres_usuar = '10' THEN
    ASSIGN v_cdn_empres_usuar  = "10".


DO da-aux = p-dt-ini TO p-dt-fim:
    {doinc/doc123rb.i "hisind"}
    {doinc/doc123rb.i "movind"}
    {doinc/doc123rb.i2 "movdis"}
END.

/* Busca valor dos impostos para as notas referentes a expositeres e metais */
FOR EACH tt-nota-fiscal
    WHERE tt-nota-fiscal.ct-codigo = v_conta_expositor OR 
          tt-nota-fiscal.ct-codigo = v_conta_metais_exp,
    EACH nota-fiscal OF tt-nota-fiscal NO-LOCK:

     RUN pi-acompanhar IN h-acomp ("Nota Fiscal: " + nota-fiscal.nr-nota-fis).

     ASSIGN de-impostos = 0.

     FOR EACH sumar-ft NO-LOCK
        WHERE sumar-ft.cod-estabel = nota-fiscal.cod-estabel
          AND sumar-ft.dt-movto    = nota-fiscal.dt-emis-nota
          AND sumar-ft.ct-conta    = tt-nota-fiscal.ct-codigo  
          AND sumar-ft.sc-conta    = tt-nota-fiscal.sc-codigo
          AND sumar-ft.serie       = nota-fiscal.serie
          AND sumar-ft.nr-nota-fis = nota-fiscal.nr-nota-fis.
          ASSIGN de-impostos = de-impostos + sumar-ft.vl-contab.
     END.

     /* Tenta calcular o valor aproximado de impostos que cairÆo na conta quando nÆo existir sumar-ft */
     IF de-impostos = 0 THEN DO:

         FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

             FIND ITEM OF it-nota-fisc NO-LOCK NO-ERROR.

             ASSIGN c-conta-icms-ft   = ""
                    c-conta-ipi-ft    = ""
                    c-conta-pis-ft    = ""
                    c-conta-cofins-ft = "".
             
             ASSIGN de-pis    = dec(substr(it-nota-fisc.char-2,76,5))
                    de-cofins = dec(substr(it-nota-fisc.char-2,81,5)).
             
             FIND FIRST conta-ft 
                  WHERE conta-ft.cod-estabel = nota-fiscal.cod-estabel
                    AND conta-ft.cod-canal   = nota-fiscal.cod-canal
                    AND conta-ft.nat-oper    = it-nota-fisc.nat-oper 
                    AND conta-ft.fm-codigo   = item.fm-codigo NO-ERROR.
             IF NOT AVAIL conta-ft THEN
                 FIND FIRST conta-ft 
                      WHERE conta-ft.cod-estabel = nota-fiscal.cod-estabel
                        AND conta-ft.cod-canal   = nota-fiscal.cod-canal
                        AND conta-ft.nat-oper    = it-nota-fisc.nat-oper 
                        AND conta-ft.fm-codigo   = ? NO-ERROR.
             IF NOT AVAIL conta-ft THEN
                 FIND FIRST conta-ft 
                      WHERE conta-ft.cod-estabel = nota-fiscal.cod-estabel
                        AND conta-ft.nat-oper    = it-nota-fisc.nat-oper 
                        AND conta-ft.fm-codigo   = item.fm-codigo NO-ERROR.
             IF NOT AVAIL conta-ft THEN
                 FIND FIRST conta-ft 
                      WHERE conta-ft.cod-estabel = nota-fiscal.cod-estabel
                        AND conta-ft.nat-oper    = it-nota-fisc.nat-oper 
                        AND conta-ft.fm-codigo   = ? NO-ERROR.
             IF AVAIL conta-ft THEN DO:
                &if "{&bf_mat_versao_ems}" = "2.062" &then
                    ASSIGN c-conta-icms-ft   = conta-ft.ct-icms-ft
                           c-conta-ipi-ft    = conta-ft.ct-ipi-ft
                           c-conta-pis-ft    = conta-ft.ct-icms-ft
                           c-conta-cofins-ft = conta-ft.ct-icms-ft.
                &else
                    ASSIGN c-conta-icms-ft   = conta-ft.ct-icms-ft + conta-ft.sc-icms-ft
                           c-conta-ipi-ft    = conta-ft.ct-ipi-ft  + conta-ft.sc-ipi-ft
                           c-conta-pis-ft    = conta-ft.ct-icms-ft + conta-ft.sc-icms-ft
                           c-conta-cofins-ft = conta-ft.ct-icms-ft + conta-ft.sc-icms-ft.
                &endif
             END.

             IF (it-nota-fisc.cd-trib-ipi = 1 OR it-nota-fisc.cd-trib-ipi = 4) AND 
                 c-conta-ipi-ft          = tt-nota-fiscal.ct-codigo + tt-nota-fiscal.sc-codigo AND 
                 it-nota-fisc.vl-ipi-it   > 0                                  THEN DO:
                 ASSIGN de-impostos = de-impostos - it-nota-fisc.vl-ipi-it.
             END.                 
             
             IF (it-nota-fisc.cd-trib-icm = 1 OR it-nota-fisc.cd-trib-icm = 4) AND 
                 c-conta-icms-ft         = tt-nota-fiscal.ct-codigo + tt-nota-fiscal.sc-codigo AND 
                 it-nota-fisc.vl-icms-it  > 0                                  THEN DO:
                 ASSIGN de-impostos = de-impostos - (it-nota-fisc.vl-icms-it + it-nota-fisc.vl-icmsub-it).
             END.

             IF (substring(it-nota-fisc.char-2,96,1) = "1" OR substring(it-nota-fisc.char-2,96,1) = "4") AND 
                 c-conta-pis-ft         = tt-nota-fiscal.ct-codigo + tt-nota-fiscal.sc-codigo AND 
                 de-pis  > 0                                                   THEN DO:
                 ASSIGN de-impostos = de-impostos - de-pis.
             END.

             IF (substring(it-nota-fisc.char-2,97,1) = "1" OR substring(it-nota-fisc.char-2,97,1) = "4") AND 
                 c-conta-cofins-ft         = tt-nota-fiscal.ct-codigo + tt-nota-fiscal.sc-codigo AND 
                 de-cofins  > 0                                  THEN DO:
                 ASSIGN de-impostos = de-impostos - de-cofins.
             END.
         END.
     END.

     IF de-impostos <> 0 THEN DO:
         ASSIGN tt-nota-fiscal.val-impostos = de-impostos * -1.

         CREATE tt-movto-estoq.
         ASSIGN tt-movto-estoq.ct-codigo    = tt-nota-fiscal.ct-codigo
                tt-movto-estoq.sc-codigo    = tt-nota-fiscal.sc-codigo
                tt-movto-estoq.data         = tt-nota-fiscal.data
                tt-movto-estoq.cod-estab    = tt-nota-fiscal.cod-estab
                tt-movto-estoq.val-movto    = 0
                tt-movto-estoq.val-fixo     = 0
                tt-movto-estoq.val-impostos = tt-nota-fiscal.val-impostos
                tt-movto-estoq.cod-emitente = tt-nota-fiscal.cod-emitente
                tt-movto-estoq.serie-docto  = tt-nota-fiscal.serie
                tt-movto-estoq.nro-docto    = tt-nota-fiscal.nr-nota-fis
                tt-movto-estoq.nat-operacao = tt-nota-fiscal.nat-operacao.

         FIND FIRST mgcad.emitente NO-LOCK
              WHERE mgcad.emitente.cod-emitente = tt-movto-estoq.cod-emitente NO-ERROR.
         IF AVAIL mgcad.emitente THEN
            ASSIGN tt-movto-estoq.nome-abrev = emitente.nome-abrev.

         ASSIGN tt-movto-estoq.descricao = "Impostos".
     END.    
END.

DELETE PROCEDURE h-dfgl001.

RUN pi-finalizar IN h-acomp.

/* FIM */
