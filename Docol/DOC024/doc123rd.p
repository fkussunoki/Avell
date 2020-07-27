/*****************************************************************************
**       PROGRAMA: doc123rd.p
**       DATA....: Maráo de 2014
**       OBJETIVO: Carrega as temp-tables Oráado x Realizado
**       VERSAO..: 2.06.00.000 
******************************************************************************/

{utp/ut-glob504.i}

DEF TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_empresa      LIKE estrut_ccusto.cod_empresa
    FIELD cod_plano_ccusto LIKE estrut_ccusto.cod_plano_ccusto
    FIELD cod_ccusto       LIKE estrut_ccusto.cod_ccusto_filho
    INDEX codigo IS PRIMARY UNIQUE cod_empresa     
                                   cod_plano_ccusto 
                                   cod_ccusto.
DEF TEMP-TABLE tt-estab      NO-UNDO
    FIELD cod-estabel        LIKE estabelec.cod-estabel         
    FIELD cod-emp-ems2       LIKE estabelec.ep-codigo
    FIELD cod-emp-rh         LIKE estrut_ccusto.cod_empresa
    FIELD cod-emp-ems5       LIKE estrut_ccusto.cod_empresa
    FIELD cc-plano           LIKE plano_ccusto.cod_plano_ccusto
    INDEX codigo cod-estabel         
                 cod-emp-ems2
                 cod-emp-ems5.

DEF TEMP-TABLE tt-cta-pesq NO-UNDO
    FIELD cod_estab          LIKE criter_distrib_cta_ctbl.cod_estab         
    FIELD cod_plano_cta_ctbl LIKE criter_distrib_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE criter_distrib_cta_ctbl.cod_cta_ctbl
    INDEX codigo cod_estab         
                 cod_plano_cta_ctbl
                 cod_cta_ctbl.

DEFINE TEMP-TABLE tt-func-hra-extra NO-UNDO
    FIELD cdn_empresa       AS INT
    FIELD cdn_estab         AS INT
    FIELD cdn_funcionario   AS INT
    FIELD nom_pessoa        AS CHAR
    FIELD cod_rh_ccusto     AS CHAR
    FIELD cod_tip_mdo       AS CHAR
    FIELD cdn_event_fp      AS CHAR
    FIELD qtd_horas_extras  AS DEC
    FIELD val_horas_extras  AS DEC
    FIELD cod_cta_ctbl_db   AS CHAR
    FIELD origem            AS CHAR
    INDEX ch-prim IS PRIMARY UNIQUE cdn_empresa
                                    cdn_estab
                                    cdn_funcionario
                                    cdn_event_fp.

DEFINE TEMP-TABLE tt-resumo-hra-extra NO-UNDO
    FIELD cdn_empresa       AS CHAR
    FIELD cod_rh_ccusto     AS CHAR
    FIELD cod_cta_ctbl      AS CHAR
    FIELD qtd_horas_extras  AS DEC
    FIELD val_horas_extras  AS DEC
    INDEX ch-prim IS PRIMARY UNIQUE cod_rh_ccusto
                                    cod_cta_ctbl.

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

DEFINE TEMP-TABLE tt-ordem-manut NO-UNDO
    FIELD data         AS DATE
    FIELD cod_estab    AS CHAR
    FIELD nr-ord-produ AS INTEGER
    FIELD ct-desp      AS CHARACTER
    FIELD sc-desp      AS CHARACTER
    FIELD narrativa    AS CHARACTER
    FIELD valor-mat    AS DECIMAL
    FIELD valor-ggf    AS DECIMAL
    INDEX ordem IS PRIMARY UNIQUE 
        data
        nr-ord-produ.

DEFINE TEMP-TABLE tt-detalhe-ordem NO-UNDO
    FIELD data          AS DATE
    FIELD nr-ord-produ  AS INTEGER
    FIELD esp-docto     AS INTEGER
    FIELD ct-desp       AS CHARACTER
    FIELD sc-desp       AS CHARACTER
    FIELD it-codigo     AS CHARACTER
    FIELD nro-docto     AS CHARACTER
    FIELD valor-mat     AS DECIMAL
    FIELD valor-ggf     AS DECIMAL
    INDEX ord-item  AS PRIMARY UNIQUE
          data
          nr-ord-produ
          it-codigo
          esp-docto.

DEF TEMP-TABLE tt-ferr-movto NO-UNDO
    FIELD nr-ord-produ   like movind.movto-estoq.nr-ord-prod
    FIELD num-ord-des    like movind.movto-estoq.num-ord-des 
    FIELD it-codigo      like movind.movto-estoq.it-codigo  
    FIELD tipo-trans     like movind.movto-estoq.tipo-trans 
    FIELD esp-docto      like movind.movto-estoq.esp-docto  
    FIELD quantidade     like movind.movto-estoq.quantidade 
    FIELD valor-mat-m    like movind.movto-estoq.valor-mat-m
    FIELD valor-ggf-m    like movind.movto-estoq.valor-ggf-m
    FIELD valor-mob-m    like movind.movto-estoq.valor-mob-m
    FIELD conta-contabil LIKE movind.movto-estoq.conta-contabil
    FIELD sc-codigo      LIKE movind.movto-estoq.sc-codigo
    FIELD ct-codigo      LIKE movind.movto-estoq.ct-codigo
    FIELD data           AS DATE
    FIELD cod-estabel    LIKE movind.movto-estoq.cod-estabel
    FIELD narrativa      AS CHAR
    INDEX ch-chave IS PRIMARY nr-ord-produ.

DEF TEMP-TABLE tt-devolucao
    FIELD ep-codigo             LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel           LIKE estabelecimento.cod_estab
    FIELD dt-trans              AS DATE 
    FIELD cc-codigo             LIKE ccusto-debito
    FIELD nome-ab-reg           LIKE regiao.nome-ab-reg
    FIELD cod-emit              LIKE emitente.cod-emitente
    FIELD serie-docto           LIKE mgcad.docum-est.serie-docto
    FIELD nro-docto             LIKE mgcad.docum-est.nro-docto
    FIELD nat-operacao          LIKE nota-fiscal.nat-operacao
    FIELD log-dev-recompr       AS LOG
    FIELD rec-devol             AS DECIMAL 
    FIELD vl-cpv-var            AS DECIMAL 
    FIELD vl-cpv-cif            AS DECIMAL 
    FIELD vl-icms               AS DECIMAL
    FIELD vl-icms-st            AS DECIMAL
    FIELD ct-debito-devol       AS CHAR
    FIELD sc-debito-devol       AS CHAR
    FIELD ct-credito-devol      AS CHAR
    FIELD sc-credito-devol      AS CHAR
    FIELD vl-contab-devol       AS DEC
    FIELD ct-debito-fixo        AS CHAR
    FIELD sc-debito-fixo        AS CHAR
    FIELD ct-credito-fixo       AS CHAR
    FIELD sc-credito-fixo       AS CHAR
    FIELD vl-contab-fixo        AS DEC 
    FIELD ct-debito-var         AS CHAR
    FIELD sc-debito-var         AS CHAR
    FIELD ct-credito-var        AS CHAR
    FIELD sc-credito-var        AS CHAR
    FIELD vl-contab-var         AS DEC 
    FIELD ct-debito-icms        AS CHAR
    FIELD sc-debito-icms        AS CHAR
    FIELD ct-credito-icms       AS CHAR
    FIELD sc-credito-icms       AS CHAR
    FIELD vl-contab-icms        AS DEC 
    INDEX ch-principal is unique primary
                       ep-codigo    ascending
                       cod-estabel  ascending
                       dt-trans     ascending
                       cc-codigo    ascending
                       cod-emit     ascending
                       serie-docto  ascending
                       nro-docto    ascending
                       nat-operacao ASCENDING.

DEF TEMP-TABLE tt-contabiliza
    FIELD cod-empresa        LIKE emsuni.empresa.cod_empresa 
    FIELD cod-estab          LIKE estabelecimento.cod_estab
    FIELD unid-neg           LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_ccusto         LIKE emsuni.ccusto.cod_ccusto
    FIELD cod_indic_econ     LIKE aprop_ctbl_acr.cod_indic_econ
    FIELD cod_finalid_econ   LIKE finalid_econ.cod_finalid_econ
    FIELD movto              AS CHAR 
    FIELD valor              AS DEC FORMAT '>>>>,>>>,>>9.9999'
    FIELD vl-orcamento       AS DEC FORMAT '>>>>,>>>,>>9.9999'
    FIELD data               AS DATE.

DEF TEMP-TABLE tt-movto
    FIELD cod-empresa        LIKE emsuni.empresa.cod_empresa 
    FIELD nome-empresa       LIKE emsuni.empresa.nom_razao_social
    FIELD cod-estab          LIKE estabelecimento.cod_estab
    FIELD nome-estab         LIKE estabelecimento.nom_pessoa
    FIELD ccusto             LIKE dc-repres.cod_ccusto
    FIELD cod_cta_ctbl-db    LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD cod_cta_ctbl-cr    LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD ccusto-db          LIKE dc-repres.cod_ccusto
    FIELD ccusto-cr          LIKE dc-repres.cod_ccusto
    FIELD desc-ccusto        LIKE emsuni.ccusto.des_tit_ctbl
    FIELD unid-neg           LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD cod-espec          LIKE tit_acr.cod_espec_docto
    FIELD cod-tit-acr        LIKE tit_acr.cod_tit_acr
    FIELD cod-parcela        LIKE tit_acr.cod_parcela
    FIELD cod_ser_docto      LIKE tit_acr.cod_ser_docto     
    FIELD dat_emis_docto     LIKE tit_acr.dat_emis_docto    
    FIELD dat_vencto_tit_acr LIKE tit_acr.dat_vencto_tit_acr
    FIELD dat_transacao      LIKE movto_tit_acr.dat_transacao
    FIELD cod-cliente        LIKE emsuni.cliente.cdn_cliente
    FIELD nome-cliente       LIKE emsuni.cliente.nom_pessoa
    FIELD vl-abatimento      LIKE tit_acr.val_sdo_tit_acr
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl 
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto  
    FIELD cod_indic_econ     LIKE aprop_ctbl_acr.cod_indic_econ
    FIELD cod_finalid_econ   LIKE finalid_econ.cod_finalid_econ 
    INDEX codigo cod-empresa
                 cod-estab
                 ccusto
                 cod-tit-acr
                 unid-neg.

DEF TEMP-TABLE tt-resumo-movto
    FIELD cod_empresa           LIKE emsuni.empresa.cod_empresa 
    FIELD cod_estab             LIKE estabelecimento.cod_estab
    FIELD cod_plano_cta_ctbl    LIKE plano_cta_ctbl.cod_plano_cta_ctbl 
    FIELD cod_cta_ctbl          LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD cod_plano_ccusto      LIKE plano_ccusto.cod_plano_ccusto  
    FIELD cod_ccusto            LIKE emsuni.ccusto.cod_ccusto
    FIELD cod_unid_negoc        LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD data                  LIKE movto_tit_acr.dat_transacao
    FIELD movto                 AS CHAR
    FIELD vl-abatimento         LIKE tit_acr.val_sdo_tit_acr
    INDEX codigo cod_empresa
                 cod_estab
                 cod_cta_ctbl
                 cod_ccusto
                 cod_unid_negoc
                 movto
                 data.

def temp-table tt-detalhe-cpv
    FIELD ep-codigo       LIKE emsuni.empresa.cod_empresa    
    FIELD cod-estabel     LIKE estabelec.cod-estabel  
    FIELD ct-codigo       LIKE conta-contab.ct-codigo  
    FIELD cc-codigo       LIKE dc-repres.cod_ccusto    
    FIELD serie           LIKE nota-fiscal.serie   
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis  
    FIELD it-codigo       LIKE movind.movto-estoq.it-codigo
    FIELD desc-item       AS CHAR FORMAT 'X(18)' LABEL 'Descriá∆o  do Item'
    FIELD cod-emitente    LIKE emitente.cod-emitente
    FIELD data            AS DATE
    FIELD vl-mat          as decimal format "->>>,>>>,>>9.99"
    FIELD vl-mob          as decimal format "->>>,>>>,>>9.99"
    FIELD vl-impostos     as decimal format "->>>,>>>,>>9.99"
    INDEX ch-principal is unique primary
          ep-codigo       ascending
          cod-estabel     ascending
          ct-codigo       ascending
          cc-codigo       ascending
          serie           ascending 
          nr-nota-fis     ascending
          it-codigo       ascending
          cod-emitente    ascending.

def temp-table tt-resumo-cpv
    FIELD ep-codigo    LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD ct-codigo    LIKE conta-contab.ct-codigo
    FIELD cc-codigo    LIKE dc-repres.cod_ccusto
    FIELD data         AS DATE
    FIELD vl-mat       as decimal format "->>>>>,>>>,>>9.99"
    FIELD vl-mob       as decimal format "->>>>>,>>>,>>9.99"
    FIELD vl-impostos  AS decimal format "->>>>>,>>>,>>9.99"
    INDEX ch-empresa is unique primary
          ep-codigo   ascending
          cod-estabel ascending
          ct-codigo   ascending
          cc-codigo   ascending.

DEF TEMP-TABLE tt-cont-cpv
    FIELD cod-empresa        LIKE emsuni.empresa.cod_empresa 
    FIELD cod-estab          LIKE estabelecimento.cod_estab
    FIELD unid-neg           LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_ccusto         LIKE emsuni.ccusto.cod_ccusto
    FIELD cod_indic_econ     LIKE aprop_ctbl_acr.cod_indic_econ
    FIELD cod_finalid_econ   LIKE finalid_econ.cod_finalid_econ
    FIELD movto              AS CHAR 
    FIELD data               AS DATE
    FIELD valor              AS DEC FORMAT '>>>>,>>>,>>9.9999'.

DEF INPUT PARAM dt-periodo-ini AS DATE.
DEF INPUT PARAM dt-periodo-fim AS DATE.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-estab.  
DEF INPUT-OUTPUT PARAM TABLE FOR tt-ccusto.  
DEF INPUT-OUTPUT PARAM TABLE FOR tt-cta-pesq. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-func-hra-extra. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-resumo-hra-extra. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-movto-estoq. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-resumo-movto-estoq. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-ordem-manut. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-detalhe-ordem. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-ferr-movto. 
DEF INPUT-OUTPUT PARAM TABLE FOR tt-devolucao.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-contabiliza.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-movto.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-resumo-movto.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-detalhe-cpv.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-resumo-cpv.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-cont-cpv.

DEF VAR h-acomp              AS HANDLE                     NO-UNDO.
DEF VAR v_cdn_empresa        AS CHAR INITIAL "DOC"         NO-UNDO.
DEF VAR v_cod_plano_ccusto   AS CHAR INITIAL "CCDOCOL"     NO-UNDO.
DEF VAR v_cod_plano_cta_ctbl AS CHAR INITIAL "PCDOCOL" NO-UNDO.
DEF VAR dt-refer             AS DATE                       NO-UNDO.
DEF VAR lc-det-previsto      AS LONGCHAR                   NO-UNDO.
DEF VAR lc-det-realizado     AS LONGCHAR                   NO-UNDO.
DEF VAR dt-aux               AS DATE                       NO-UNDO.
DEF VAR v_conta_expositor    AS CHAR INITIAL "435374".
DEF VAR v_conta_metais_exp   AS CHAR INITIAL "435375".
DEF VAR c-mensagem           AS CHAR                       NO-UNDO.
DEF VAR c-msg-ajuda          AS CHAR                       NO-UNDO.
DEF VAR i-periodo            AS INTEGER                    NO-UNDO.
def var c-empresa-ems5       as char                       no-undo.
def var c-empresa-rh         as char                       no-undo.

DEF VAR c-cod-estab            AS CHAR                       NO-UNDO.
DEF VAR cc-plano             AS CHAR                       NO-UNDO.

DEF VAR v_cod_unid_orctaria  AS CHAR                       NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Buscando informaá‰es").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

def new global shared var v_cod_empres_usuar   as character format "x(3)":U  label "Empresa" column-label "Empresa" no-undo.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario  like param-global.empresa-prin NO-UNDO.

/* Fabiano
{doinc/dsg999.i} /* Sugest∆o c-cod-estab conforme empresa */
{doinc/dsg998.i} /* Sugest∆o cc-plano conforme empresa */

IF v_cod_empres_usuar <> "DOC" THEN
    ASSIGN v_cdn_empresa        = v_cod_empres_usuar
           v_cod_plano_ccusto   = cc-plano.

EMPTY TEMP-TABLE tt-estab.
*/

FOR EACH tt-estab:
  
    find first trad_org_ext no-lock where trad_org_ext.cod_matriz_trad_org_ext = "EMS2"
                                    and trad_org_ext.cod_tip_unid_organ = "998" /*empresa*/
                                    and trad_org_ext.cod_unid_organ = tt-estab.cod-emp-ems5 no-error.
    assign c-empresa-ems5 = trad_org_ext.cod_unid_organ. 
    
    find first trad_org_ext no-lock where trad_org_ext.cod_matriz_trad_org_ext = "HR"
                                    and trad_org_ext.cod_tip_unid_organ = "998" /*empresa*/
                                    and trad_org_ext.cod_unid_organ = c-empresa-ems5  no-error.    
    assign c-empresa-rh = trad_org_ext.cod_unid_organ. 

    FIND FIRST plano_ccusto
           WHERE plano_ccusto.cod_empresa = c-empresa-ems5 
           AND   plano_ccusto.dat_inic_valid <= today
           and   plano_ccusto.dat_fim_valid  >= today
           NO-LOCK NO-ERROR.
    
    IF AVAIL plano_ccusto THEN
        ASSIGN cc-plano = plano_ccusto.cod_plano_ccusto.
    ELSE
        ASSIGN cc-plano = 'CCDOCOL'. 
END.




PUT SKIP(1) "Per°odo " STRING(dt-periodo-ini,'99/99/9999') " - " STRING(dt-periodo-fim,'99/99/9999') SKIP(1).
         
/* --- PREVIS«O DE DESPESAS - ORDENS DE COMPRA --------- */
/* Zera os registros do per°odo que ser† apurado */
FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo     = "Previsto"
    AND   dc-orc-realizado.data       <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:

    IF dt-periodo-ini > TODAY AND
       dc-orc-realizado.data < dt-periodo-ini THEN
        NEXT.

    ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
           dc-orc-realizado.hra-ult-atualiza  = ?
           dc-orc-realizado.usario-atualiza   = ""
           dc-orc-realizado.det-previsto      = ""
           dc-orc-realizado.det-realizado     = ""
           dc-orc-realizado.valor-orcto       = 0
           dc-orc-realizado.valor-previsto    = 0
           dc-orc-realizado.valor-realizado   = 0.
END.

RUN pi-seta-titulo IN h-acomp ("Buscando Valor Previsto").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

IF dt-periodo-ini >= DATE(MONTH(TODAY),01,YEAR(TODAY)) THEN DO: /*** Calcular previs∆o apenas se Periodo de execuá∆o for maior ou igual ao atual ***/

    PUT UNFORMATTED "Previsto..........: " STRING(TIME,"HH:MM:SS") SKIP.
    
    PUT SKIP(1)
        "CARGA DO VALOR PREVISTO" SKIP
        "-----------------------" SKIP(2).
    
    
    FOR EACH prazo-compra NO-LOCK
       WHERE prazo-compra.data-entrega <= dt-periodo-fim
         AND prazo-compra.situacao      = 2
         AND prazo-compra.quant-saldo   > 0,
        EACH ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem
         AND ordem-compra.ct-codigo    <> ""
         AND ordem-compra.sc-codigo    <> ""
         AND ordem-compra.situacao      = 2,
        FIRST tt-estab NO-LOCK
        WHERE tt-estab.cod-estabel       = ordem-compra.cod-estabel,
        EACH tt-ccusto
        WHERE tt-ccusto.cod_empresa      = tt-estab.cod-emp-ems5
        AND   tt-ccusto.cod_plano_ccusto = tt-estab.cc-plano
        AND   tt-ccusto.cod_ccusto       = ordem-compra.sc-codigo,
        EACH tt-cta-pesq
        WHERE tt-cta-pesq.cod_estab          = ordem-compra.cod-estabel
        AND   tt-cta-pesq.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        AND   tt-cta-pesq.cod_cta_ctbl       = ordem-compra.ct-codigo:
    
        ASSIGN dt-refer = DATE(MONTH(dt-periodo-fim),1,YEAR(dt-periodo-fim))
               dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.
    
        FIND emsuni.ccusto NO-LOCK
            WHERE emsuni.ccusto.cod_empresa      = tt-estab.cod-emp-ems5
            AND   emsuni.ccusto.cod_plano_ccusto = tt-estab.cc-plano
            AND   emsuni.ccusto.cod_ccusto       = ordem-compra.sc-codigo NO-ERROR.
        IF NOT AVAIL ccusto THEN
            NEXT.
    
        IF dt-periodo-ini >= ADD-INTERVAL(DATE(MONTH(TODAY), 01, YEAR(TODAY)),1,'month') AND
           (YEAR(dt-periodo-ini) <> YEAR(prazo-compra.data-entrega) OR
            MONTH(dt-periodo-ini) <> MONTH(prazo-compra.data-entrega)) THEN
            NEXT.
    
        RUN pi-acompanhar IN h-acomp ("Ordem Compra: " + STRING(ordem-compra.numero-ordem,"zzzzz9,99")).
        
        FIND FIRST dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.cod_empresa      = tt-estab.cod-emp-ems5
            AND   dc-orc-realizado.cod_estab        = ordem-compra.cod-estabel
            AND   dc-orc-realizado.cod_plano_ctbl   = v_cod_plano_cta_ctbl
            AND   dc-orc-realizado.cod_cta_ctbl     = ordem-compra.ct-codigo
            AND   dc-orc-realizado.cod_plano_ccusto = tt-estab.cc-plano
            AND   dc-orc-realizado.cod_ccusto       = ordem-compra.sc-codigo
            AND   dc-orc-realizado.modulo           = "Previsto"
            AND   dc-orc-realizado.data             = dt-refer NO-ERROR.
        IF NOT AVAIL dc-orc-realizado THEN DO:
            CREATE dc-orc-realizado.
            ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
                   dc-orc-realizado.cod_estab         = ordem-compra.cod-estabel
                   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
                   dc-orc-realizado.cod_cta_ctbl      = ordem-compra.ct-codigo
                   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano
                   dc-orc-realizado.cod_ccusto        = ordem-compra.sc-codigo
                   dc-orc-realizado.modulo            = "Previsto"
                   dc-orc-realizado.data              = dt-refer
                   dc-orc-realizado.descricao         = "Resumo Previsto (" + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) + ")"
                   .
        END.
    
        COPY-LOB dc-orc-realizado.det-previsto TO lc-det-previsto.
        IF lc-det-previsto = "" OR lc-det-previsto = ? THEN
            ASSIGN lc-det-previsto = "CCusto;Dt Entrega;Pedido   ;Ordem Compra;Requisitante;Item            ;Quantidade;Valor         ;Descriá∆o".
    
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        ASSIGN lc-det-previsto = lc-det-previsto + CHR(10)                            + 
                                 ordem-compra.sc-codigo                         + ";" +
                                 STRING(prazo-compra.data-entrega,"99/99/9999") + ";" +
                                 STRING(ordem-compra.num-pedido,">>>>>,>>9")    + ";" +
                                 STRING(ordem-compra.numero-ordem,"zzzzz9,99")  + ";" +
                                 ordem-compra.requisitante                      + ";" +
                                 ordem-compra.it-codigo                         + ";" +
                                 STRING(prazo-compra.quant-saldo,">>>,>>9.99")  + ";" +
                                 STRING(ordem-compra.preco-unit * prazo-compra.quant-saldo,">>>,>>>,>>9.99") + ";" +
                                 (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + " - " + REPLACE(ordem-compra.narrativa,CHR(10)," ").
    
        COPY-LOB lc-det-previsto TO dc-orc-realizado.det-previsto.
        
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
               dc-orc-realizado.hra-ult-atualiza  = TIME
               dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
               dc-orc-realizado.valor-previsto    = dc-orc-realizado.valor-previsto + ordem-compra.preco-unit * prazo-compra.quant-saldo.
        
    END.

    /* Ferramentaria */
    FOR EACH prazo-compra NO-LOCK
       WHERE prazo-compra.data-entrega <= dt-periodo-fim
         AND prazo-compra.situacao      = 2
         AND prazo-compra.quant-saldo   > 0,
        EACH ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem
         AND ordem-compra.ct-codigo    <> ""
         AND ordem-compra.sc-codigo     = ""
         AND ordem-compra.situacao      = 2
         AND ordem-compra.ordem-servic  > 700000000,
        FIRST tt-estab NO-LOCK
        WHERE tt-estab.cod-estabel       = ordem-compra.cod-estabel:
    
        ASSIGN dt-refer = DATE(MONTH(dt-periodo-fim),1,YEAR(dt-periodo-fim))
               dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.

        FIND FIRST al-res-op
             WHERE al-res-op.nr-ord-produ = ordem-compra.ordem-servic NO-LOCK NO-ERROR.

        IF NOT AVAIL al-res-op THEN NEXT.

        /* Busca Ordem Pai */
        FIND FIRST dc-rtp-ord-prod
             WHERE dc-rtp-ord-prod.nr-ord-prod = al-res-op.nr-ord-res NO-LOCK NO-ERROR.

        IF NOT AVAIL dc-rtp-ord-prod OR dc-rtp-ord-prod.sc-aplicacao = "" THEN NEXT.
    
        FIND FIRST emsuni.ccusto NO-LOCK
             WHERE emsuni.ccusto.cod_empresa      = tt-estab.cod-emp-ems5
               AND emsuni.ccusto.cod_plano_ccusto = tt-estab.cc-plano
               AND emsuni.ccusto.cod_ccusto       = dc-rtp-ord-prod.sc-aplicacao NO-ERROR.

        IF NOT AVAIL ccusto THEN NEXT.
    
        IF dt-periodo-ini >= ADD-INTERVAL(DATE(MONTH(TODAY), 01, YEAR(TODAY)),1,'month') AND
           (YEAR(dt-periodo-ini) <> YEAR(prazo-compra.data-entrega) OR
            MONTH(dt-periodo-ini) <> MONTH(prazo-compra.data-entrega)) THEN
            NEXT.
    
        RUN pi-acompanhar IN h-acomp ("Ordem Compra: " + STRING(ordem-compra.numero-ordem,"zzzzz9,99")).
        
        FIND FIRST dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.cod_empresa      = tt-estab.cod-emp-ems5
            AND   dc-orc-realizado.cod_estab        = ordem-compra.cod-estabel
            AND   dc-orc-realizado.cod_plano_ctbl   = v_cod_plano_cta_ctbl
            AND   dc-orc-realizado.cod_cta_ctbl     = dc-rtp-ord-prod.ct-aplicacao
            AND   dc-orc-realizado.cod_plano_ccusto = tt-estab.cc-plano
            AND   dc-orc-realizado.cod_ccusto       = dc-rtp-ord-prod.sc-aplicacao
            AND   dc-orc-realizado.modulo           = "Previsto"
            AND   dc-orc-realizado.data             = dt-refer NO-ERROR.
        IF NOT AVAIL dc-orc-realizado THEN DO:
            CREATE dc-orc-realizado.
            ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
                   dc-orc-realizado.cod_estab         = ordem-compra.cod-estabel
                   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
                   dc-orc-realizado.cod_cta_ctbl      = dc-rtp-ord-prod.ct-aplicacao
                   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano
                   dc-orc-realizado.cod_ccusto        = dc-rtp-ord-prod.sc-aplicacao
                   dc-orc-realizado.modulo            = "Previsto"
                   dc-orc-realizado.data              = dt-refer
                   dc-orc-realizado.descricao         = "Resumo Previsto (" + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) + ")"
                   .
        END.
    
        COPY-LOB dc-orc-realizado.det-previsto TO lc-det-previsto.
        IF lc-det-previsto = "" OR lc-det-previsto = ? THEN
            ASSIGN lc-det-previsto = "CCusto;Dt Entrega;Pedido   ;Ordem Compra;Requisitante;Item            ;Quantidade;Valor         ;Descriá∆o".
    
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        ASSIGN lc-det-previsto = lc-det-previsto + CHR(10)                            + 
                                 ordem-compra.sc-codigo                         + ";" +
                                 STRING(prazo-compra.data-entrega,"99/99/9999") + ";" +
                                 STRING(ordem-compra.num-pedido,">>>>>,>>9")    + ";" +
                                 STRING(ordem-compra.numero-ordem,"zzzzz9,99")  + ";" +
                                 ordem-compra.requisitante                      + ";" +
                                 ordem-compra.it-codigo                         + ";" +
                                 STRING(prazo-compra.quant-saldo,">>>,>>9.99")  + ";" +
                                 STRING(ordem-compra.preco-unit * prazo-compra.quant-saldo,">>>,>>>,>>9.99") + ";" +
                                 (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + " - " + REPLACE(ordem-compra.narrativa,CHR(10)," ").
    
        COPY-LOB lc-det-previsto TO dc-orc-realizado.det-previsto.
        
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
               dc-orc-realizado.hra-ult-atualiza  = TIME
               dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
               dc-orc-realizado.valor-previsto    = dc-orc-realizado.valor-previsto + ordem-compra.preco-unit * prazo-compra.quant-saldo.
        
    END.

    /* Projeto Verba Cooperada - Carregamento do Previsto*/
    /* Somente ser† carregado como DOCOL, visto que n∆o possui estabelecimento na amkt-solicitacao, para funcionar para a Mekal ser† necess†rio alterar as tabelas */
    IF v_cod_empres_usuar = 'DOC' THEN DO:
    
        FOR EACH amkt-solicitacao NO-LOCK WHERE
                 amkt-solicitacao.dt-validade-final <= dt-periodo-fim AND
                 amkt-solicitacao.numero            >= 0:
        
            IF amkt-solicitacao.cod-situacao <> "Pendente de Aprovaá∆o" AND
               amkt-solicitacao.cod-situacao <> "Solicitaá∆o Aprovada"  THEN NEXT.
        
            IF amkt-solicitacao.log-encerra = YES OR
               amkt-solicitacao.log-cancela = YES THEN NEXT.
        
            ASSIGN dt-refer = DATE(MONTH(dt-periodo-fim),1,YEAR(dt-periodo-fim))
                   dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.
        
            FIND FIRST repres NO-LOCK WHERE
                       repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.
            IF NOT AVAIL repres THEN NEXT.
        
            FIND FIRST emitente NO-LOCK WHERE
                       emitente.cod-emitente = amkt-solicitacao.cod-emitente NO-ERROR.
            IF NOT AVAIL emitente THEN NEXT.
        
            FIND FIRST sgv-seg-mercado NO-LOCK WHERE
                       sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
            IF NOT AVAIL sgv-seg-mercado THEN NEXT.
        
            FIND FIRST dc-repres-gestor NO-LOCK WHERE
                       dc-repres-gestor.cod-rep     = repres.cod-rep              AND
                       dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
            IF NOT AVAIL dc-repres-gestor THEN NEXT.
        
            FIND FIRST dc-regiao NO-LOCK WHERE
                       dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.
            IF NOT AVAIL dc-regiao THEN NEXT.
        
            FIND FIRST dc-orc-realizado EXCLUSIVE-LOCK
                WHERE dc-orc-realizado.cod_empresa      = "DOC"  /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                AND   dc-orc-realizado.cod_estab        = "9"    /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                AND   dc-orc-realizado.cod_plano_ctbl   = v_cod_plano_cta_ctbl
                AND   dc-orc-realizado.cod_cta_ctbl     = "435362"
                AND   dc-orc-realizado.cod_plano_ccusto = "CCDOCOL" /*v_cod_plano_ccusto*/  /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                AND   dc-orc-realizado.cod_ccusto       =  dc-regiao.cod-ccusto
                AND   dc-orc-realizado.modulo           = "Previsto"
                AND   dc-orc-realizado.data             = dt-refer NO-ERROR.
            IF NOT AVAIL dc-orc-realizado THEN DO:
                CREATE dc-orc-realizado.
                ASSIGN dc-orc-realizado.cod_empresa       = "DOC"  /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                       dc-orc-realizado.cod_estab         = "9"    /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                       dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
                       dc-orc-realizado.cod_cta_ctbl      = "435362"
                       dc-orc-realizado.cod_plano_ccusto  = "CCDOCOL" /*v_cod_plano_ccusto*/ /* fixo devido a esta informaá∆o ser exclusiva da Docol */
                       dc-orc-realizado.cod_ccusto        = dc-regiao.cod-ccusto
                       dc-orc-realizado.modulo            = "Previsto"
                       dc-orc-realizado.data              = dt-refer
                       dc-orc-realizado.descricao         = "Resumo Previsto (" + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) + ")"
                       .
            END.
        
            COPY-LOB dc-orc-realizado.det-previsto TO lc-det-previsto.
            IF lc-det-previsto = "" OR lc-det-previsto = ? THEN
                ASSIGN lc-det-previsto = "CCusto;Data      ;Solicit Mkt;Rep  ;Cliente  ;Valor".
        
            ASSIGN lc-det-previsto = lc-det-previsto + CHR(10)
                                   + dc-regiao.cod-ccusto
                                   + ";" + STRING(amkt-solicitacao.dt-validade-final,"99/99/9999")
                                   + ";" + STRING(amkt-solicitacao.numero, ">>>,>>>,>>9")
                                   + ";" + STRING(amkt-solicitacao.cod-rep, ">>>>9")
                                   + ";" + STRING(amkt-solicitacao.cod-emitente, ">>>>>>>>9")
                                   + ";" + STRING(amkt-solicitacao.vl-solicitacao,">>>,>>>,>>9.99").
        
            COPY-LOB lc-det-previsto TO dc-orc-realizado.det-previsto.
            
            ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
                   dc-orc-realizado.hra-ult-atualiza  = TIME
                   dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
                   dc-orc-realizado.valor-previsto    = dc-orc-realizado.valor-previsto + amkt-solicitacao.vl-solicitacao.
        END. /* EACH amkt-solicitacao*/
    END. // V_cod_empres_usuar

    PUT SKIP(1)
            " * * * Carga de Valor Previsto realizada com sucesso! " SKIP(3).
    
    /* --- (FIM) PREVIS«O DE DESPESAS - ORDENS DE COMPRA --- */
END.
 
PUT UNFORMATTED "Recursos Humanos..: " STRING(TIME,"HH:MM:SS") SKIP.

/* --- HORAS EXTRAS --------- */
/*IF NOT CONNECTED("dthrpyc") THEN 
   CONNECT -pf scripts/dthrpyc.pf NO-ERROR.
IF NOT CONNECTED("dthrtma") THEN 
   CONNECT -pf scripts/dthrtma.pf NO-ERROR.*/
IF CONNECTED("dthrpyc") AND CONNECTED("dthrtma") THEN DO ON ERROR UNDO, LEAVE
                                                         ON STOP UNDO, LEAVE:

    RUN pi-seta-titulo IN h-acomp ("Extraindo informaá‰es do HCM").

    RUN pi-acompanhar IN h-acomp ("Limpando dados...").
    
    FOR EACH tt-estab:
    
        /* Zera os registros do per°odo que ser† apurado */
        FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.modulo     = "HCM"
            AND   dc-orc-realizado.data       >= dt-periodo-ini
            AND   dc-orc-realizado.data       <= dt-periodo-fim
            AND   dc-orc-realizado.cod_empresa = tt-estab.cod-emp-ems5,
            EACH tt-ccusto OF dc-orc-realizado:
            
            ASSIGN dc-orc-realizado.dt-ult-atualiza  = ?
                   dc-orc-realizado.hra-ult-atualiza = ?
                   dc-orc-realizado.usario-atualiza  = ""
                   dc-orc-realizado.det-previsto     = ""
                   dc-orc-realizado.det-realizado    = ""
                   dc-orc-realizado.valor-orcto      = 0
                   dc-orc-realizado.valor-previsto   = 0
                   dc-orc-realizado.valor-realizado  = 0.
        END.
    END.

    PUT SKIP(1)
        "CARGA DE HORAS EXTRAS" SKIP
        "---------------------" SKIP(2).

    ASSIGN dt-aux = DATE(MONTH(dt-periodo-ini),1,YEAR(dt-periodo-ini)).
    DO WHILE dt-aux <= dt-periodo-fim:

        ASSIGN dt-refer = ADD-INTERVAL(dt-aux,1,'month') - 1.

        PUT UNFORMATTED " - Carga de Horas Extras do per°odo: " + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) SKIP.

        RUN pi-acompanhar IN h-acomp ("Dados de Horas Extras do per°odo: " + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer))).
        //fabiano
        RUN dop/doc123ra.p (INPUT YEAR(dt-refer),
                            INPUT MONTH(dt-refer),
                            //  INPUT tt-estab,
                            OUTPUT TABLE tt-func-hra-extra,
                            OUTPUT TABLE tt-resumo-hra-extra).

        FOR EACH tt-resumo-hra-extra,
            FIRST tt-estab NO-LOCK
            WHERE tt-estab.cod-emp-rh         = tt-resumo-hra-extra.cdn_empresa,
            EACH tt-ccusto
            WHERE tt-ccusto.cod_empresa       = tt-estab.cod-emp-ems5
            AND   tt-ccusto.cod_plano_ccusto  = tt-estab.cc-plano
            AND   tt-ccusto.cod_ccusto        = tt-resumo-hra-extra.cod_rh_ccusto:

            RUN pi-acompanhar IN h-acomp ("Horas Extras CC: " + tt-resumo-hra-extra.cod_rh_ccusto + " Conta: " + tt-resumo-hra-extra.cod_cta_ctbl).
    
            FIND dc-orc-realizado EXCLUSIVE-LOCK
                WHERE dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
                AND   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel   /*"9"*/
                AND   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano
                AND   dc-orc-realizado.cod_ccusto        = tt-resumo-hra-extra.cod_rh_ccusto
                AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
                AND   dc-orc-realizado.cod_cta_ctbl      = tt-resumo-hra-extra.cod_cta_ctbl
                AND   dc-orc-realizado.modulo            = "HCM"
                AND   dc-orc-realizado.data              = dt-refer NO-ERROR.
            IF NOT AVAIL dc-orc-realizado THEN DO:
                CREATE dc-orc-realizado.
                ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
                       dc-orc-realizado.cod_estab         = tt-estab.cod-estabel   /*"9"*/
                       dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano    
                       dc-orc-realizado.cod_ccusto        = tt-resumo-hra-extra.cod_rh_ccusto
                       dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
                       dc-orc-realizado.cod_cta_ctbl      = tt-resumo-hra-extra.cod_cta_ctbl
                       dc-orc-realizado.data              = dt-refer
                       dc-orc-realizado.modulo            = "HCM".
            END.
            
            ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
                   dc-orc-realizado.hra-ult-atualiza  = TIME
                   dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
                   dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + tt-resumo-hra-extra.val_horas_extras.

            FIND FIRST tt-func-hra-extra
                WHERE tt-func-hra-extra.cod_rh_ccusto = tt-resumo-hra-extra.cod_rh_ccusto
                AND   tt-func-hra-extra.cod_cta_ctbl  = tt-resumo-hra-extra.cod_cta_ctbl NO-ERROR.
            IF AVAIL tt-func-hra-extra THEN
                ASSIGN dc-orc-realizado.descricao = tt-func-hra-extra.origem.

            /* Coloca no detalhe a origem da informaá∆o MFE ou MFP e per°odo */
            ASSIGN dc-orc-realizado.det-realizado = "CCusto;Matr°cula;Nome                                         ;     Qtd Horas;         Valor".
            FOR EACH tt-func-hra-extra
                WHERE tt-func-hra-extra.cod_rh_ccusto = tt-resumo-hra-extra.cod_rh_ccusto
                AND   tt-func-hra-extra.cod_cta_ctbl  = tt-resumo-hra-extra.cod_cta_ctbl
                BREAK BY tt-func-hra-extra.cod_rh_ccusto
                      BY tt-func-hra-extra.cod_cta_ctbl 
                      BY tt-func-hra-extra.cdn_funcionario:

                ACCUMULATE tt-func-hra-extra.qtd_horas_extras (TOTAL BY tt-func-hra-extra.cdn_funcionario).
                ACCUMULATE tt-func-hra-extra.val_horas_extras (TOTAL BY tt-func-hra-extra.cdn_funcionario).

                IF LAST-OF(tt-func-hra-extra.cdn_funcionario) THEN
                    /* Monta uma lista separada por ; (ponto e v°rgula) com os funcion†rios que realizaram as horas extras */
                    ASSIGN lc-det-realizado               = dc-orc-realizado.det-realizado
                           lc-det-realizado               = lc-det-realizado + CHR(10) +
                                                            tt-func-hra-extra.cod_rh_ccusto            + ";" +
                                                            STRING(tt-func-hra-extra.cdn_funcionario)  + ";" +
                                                            tt-func-hra-extra.nom_pessoa               + ";" +
                                                            STRING(ACCUM TOTAL BY tt-func-hra-extra.cdn_funcionario tt-func-hra-extra.qtd_horas_extras,">>>,>>>,>>9.99") + ";" +
                                                            STRING(ACCUM TOTAL BY tt-func-hra-extra.cdn_funcionario tt-func-hra-extra.val_horas_extras,">>>,>>>,>>9.99")
                           dc-orc-realizado.det-realizado = lc-det-realizado.

            END.
    
        END.

        ASSIGN dt-aux = ADD-INTERVAL(dt-aux,1,'month').
    END.

    /*DISCONNECT dthrpyc.
    DISCONNECT dthrtma.*/

    PUT SKIP(1)
        " * * * Carga de Horas Extras realizada com sucesso!" SKIP(3).

END.
/* --- (FIM) HORAS EXTRAS --- */

/* --- CARGA MOVTO ESTOQ --------- */

RUN pi-seta-titulo IN h-acomp ("Buscando informaá‰es do Estoque").

EMPTY TEMP-TABLE tt-movto-estoq.
EMPTY TEMP-TABLE tt-resumo-movto-estoq.

PUT UNFORMATTED "Movto Estoq.......: " STRING(TIME,"HH:MM:SS") SKIP.

PUT SKIP(1)
    "CARGA DE MOVIMENTO DE ESTOQUE" SKIP
    "-----------------------------" SKIP(2).

/*FIND FIRST con-bh-adm NO-LOCK 
   WHERE con-bh-adm.cd-banco = 'hisind' NO-ERROR.
IF AVAIL con-bh-adm THEN DO:
 IF NOT CONNECTED(con-bh-adm.cd-banco) THEN
    CONNECT -db VALUE(con-bh-adm.nm-fisico) -ld VALUE(con-bh-adm.cd-banco) -S VALUE(con-bh-adm.service) -H VALUE(con-bh-adm.host) VALUE(con-bh-adm.parametro) -RO NO-ERROR.
END.*/

IF NOT AVAIL param-global THEN
    FIND FIRST param-global NO-LOCK NO-ERROR.

find first bco_empres
     where bco_empres.cod_empresa   = param-global.empresa-prin
       and bco_empres.cod_bco_dados = "hisind" no-lock no-error.
if  avail bco_empres then do:
    if  not connected(bco_empres.cod_bco_dados) then
        connect -db value(bco_empres.cod_bco_fisic) -ld value(bco_empres.cod_bco_dados) value(bco_empres.cod_param_conex) -RO no-error.
end.

IF CONNECTED("hisind") THEN DO:
  RUN dop/doc123rb.p (INPUT dt-periodo-ini, 
                      INPUT dt-periodo-fim,
                      INPUT TABLE tt-ccusto,
                      INPUT TABLE tt-estab,
                      OUTPUT TABLE tt-movto-estoq,
                      OUTPUT TABLE tt-resumo-movto-estoq).

  DISCON "hisind".
END.

PUT UNFORMATTED "Zerando CEP.......: " STRING(TIME,"HH:MM:SS") SKIP.

/* Zera os registros do per°odo que ser† apurado */
FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo     = "CEP"
    AND   dc-orc-realizado.data       >= dt-periodo-ini
    AND   dc-orc-realizado.data       <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:
    ASSIGN dc-orc-realizado.dt-ult-atualiza  = ?
           dc-orc-realizado.hra-ult-atualiza = ?
           dc-orc-realizado.usario-atualiza  = ""
           dc-orc-realizado.det-previsto     = ""
           dc-orc-realizado.det-realizado    = ""
           dc-orc-realizado.valor-orcto      = 0
           dc-orc-realizado.valor-previsto   = 0
           dc-orc-realizado.valor-realizado  = 0.
END.

PUT UNFORMATTED "Carregando CEP....: " STRING(TIME,"HH:MM:SS") SKIP.

FOR EACH  tt-resumo-movto-estoq,
    FIRST tt-estab NO-LOCK
    WHERE tt-estab.cod-estabel       = tt-resumo-movto-estoq.cod-estabel:

    RUN pi-acompanhar IN h-acomp ("Movto Estoque CC: " + tt-resumo-movto-estoq.sc-codigo + " Conta: " + tt-resumo-movto-estoq.ct-codigo).

    FIND dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa       =  tt-estab.cod-emp-ems5
        AND   dc-orc-realizado.cod_estab         =  tt-estab.cod-estabel 
        AND   dc-orc-realizado.cod_plano_ccusto  =  tt-estab.cc-plano    
        AND   dc-orc-realizado.cod_ccusto        = tt-resumo-movto-estoq.sc-codigo
        AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
        AND   dc-orc-realizado.cod_cta_ctbl      = tt-resumo-movto-estoq.ct-codigo
        AND   dc-orc-realizado.modulo            = tt-resumo-movto-estoq.modulo
        AND   dc-orc-realizado.data              = tt-resumo-movto-estoq.data NO-ERROR.
    IF NOT AVAIL dc-orc-realizado THEN DO:
        CREATE dc-orc-realizado.
        ASSIGN dc-orc-realizado.cod_empresa       =  tt-estab.cod-emp-ems5
               dc-orc-realizado.cod_estab         =  tt-estab.cod-estabel  
               dc-orc-realizado.cod_plano_ccusto  =  tt-estab.cc-plano    
               dc-orc-realizado.cod_ccusto        = tt-resumo-movto-estoq.sc-codigo
               dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
               dc-orc-realizado.cod_cta_ctbl      = tt-resumo-movto-estoq.ct-codigo
               dc-orc-realizado.data              = tt-resumo-movto-estoq.data
               dc-orc-realizado.descricao         = "Lanáamentos Estoque (" + STRING(MONTH(tt-resumo-movto-estoq.data),"99") + "/" + STRING(YEAR(tt-resumo-movto-estoq.data)) + ")"
               dc-orc-realizado.modulo            = tt-resumo-movto-estoq.modulo.
    END.
    ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
           dc-orc-realizado.hra-ult-atualiza  = TIME
           dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
           dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + tt-resumo-movto-estoq.val-movto.

    /*** em comentario maráo/2019 referente ao chamado 84058: est† apresentando diferenáa nas comtas expositores, com programa DBGC201
    IF tt-resumo-movto-estoq.ct-codigo = v_conta_expositor  OR tt-resumo-movto-estoq.ct-codigo = v_conta_metais_exp THEN
        ASSIGN dc-orc-realizado.valor-realizado = dc-orc-realizado.valor-realizado - tt-resumo-movto-estoq.val-fixo.
    ***/
        
    COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
    ASSIGN lc-det-realizado = "CCusto;Grupo de Maquina;Dt Trans  ;Emit     ;Nome Abrev  ;Estab;SÇrie;Nro Docto;Nat Oper;Usu†rio     ;Requisitante;Item            ;Quantidade;Esp;Valor        ;Descriá∆o".

    FOR EACH tt-movto-estoq
        WHERE tt-movto-estoq.cod-estabel = tt-resumo-movto-estoq.cod-estabel
        AND   tt-movto-estoq.ct-codigo   = tt-resumo-movto-estoq.ct-codigo
        AND   tt-movto-estoq.sc-codigo   = tt-resumo-movto-estoq.sc-codigo
        AND   tt-movto-estoq.data       >= DATE(MONTH(tt-resumo-movto-estoq.data),1,YEAR(tt-resumo-movto-estoq.data))
        AND   tt-movto-estoq.data       <= tt-resumo-movto-estoq.data:
        
        /*** em comentario maráo/2019 referente ao chamado 84058: est† apresentando diferenáa nas comtas expositores, com programa DBGC201
        IF tt-movto-estoq.ct-codigo = v_conta_expositor  OR tt-movto-estoq.ct-codigo = v_conta_metais_exp THEN
            ASSIGN tt-movto-estoq.val-movto         = tt-movto-estoq.val-movto - tt-movto-estoq.val-fixo                    
                   dc-orc-realizado.valor-realizado = dc-orc-realizado.valor-realizado + tt-movto-estoq.val-impostos.
        ***/                       
        
        /* Monta uma lista separada por ; (ponto e v°rgula) com os funcion†rios que realizaram as horas extras */

        ASSIGN lc-det-realizado = lc-det-realizado + CHR(10) +
                                  tt-movto-estoq.sc-codigo                                                       + ";" +
                                  tt-movto-estoq.gm-codigo                                                       + ";" +
                                  STRING(tt-movto-estoq.data,"99/99/9999")                                       + ";" +
                                  STRING(tt-movto-estoq.cod-emitente,">>>>>>>>9")                                + ";" +
                                  tt-movto-estoq.nome-abrev                                                      + ";" +
                                  tt-movto-estoq.cod-estabel                                                     + ";" +
                                  tt-movto-estoq.serie-docto                                                     + ";" +
                                  tt-movto-estoq.nro-docto                                                       + ";" +
                                  tt-movto-estoq.nat-operacao                                                    + ";" +
                                  tt-movto-estoq.usuario                                                         + ";" +
                                  tt-movto-estoq.nome-abrev-requis                                               + ";" +
                                  tt-movto-estoq.it-codigo                                                       + ";" +
                                  STRING(tt-movto-estoq.quantidade,">>>,>>9.99")                                 + ";" +
                                  STRING(tt-movto-estoq.esp-docto)                                               + ";" +
                                  STRING(tt-movto-estoq.val-movto + tt-movto-estoq.val-impostos,"->>>>>,>>9.99") + ";" +
                                  tt-movto-estoq.descricao.
    END.        

    COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.

END.

PUT SKIP(1)
    " * * * Carga de Movimento de Estoque realizada com sucesso!" SKIP(3).

/* --- (FIM) CARGA MOVTO ESTOQ --- */

/* --- CARGA ORDENS DE MANUTENÄ«O --------- */

PUT UNFORMATTED "Manutená∆o........: " STRING(TIME,"HH:MM:SS") SKIP.

PUT SKIP(1)
    "CARGA DE MANUTENÄ«O/FERRAMENTARIA" SKIP
    "---------------------------------" SKIP(2).

RUN dop/doc123rc.p (INPUT dt-periodo-ini,
                    INPUT dt-periodo-fim,
                    OUTPUT TABLE tt-ordem-manut,
                    OUTPUT TABLE tt-detalhe-ordem,
                    OUTPUT TABLE tt-ferr-movto).

FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo           = "Manutená∆o"
    AND   dc-orc-realizado.data            >= dt-periodo-ini
    AND   dc-orc-realizado.data            <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:

    ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
           dc-orc-realizado.hra-ult-atualiza  = ?
           dc-orc-realizado.usario-atualiza   = ""
           dc-orc-realizado.det-previsto      = ""
           dc-orc-realizado.det-realizado     = ""
           dc-orc-realizado.valor-orcto       = 0
           dc-orc-realizado.valor-previsto    = 0
           dc-orc-realizado.valor-realizado   = 0.
END.

 
 
 

PUT UNFORMATTED "Carga Manutená∆o..: " STRING(TIME,"HH:MM:SS") SKIP.

FOR EACH tt-ordem-manut
    WHERE tt-ordem-manut.valor-mat > 0 
    OR    tt-ordem-manut.valor-ggf > 0,
    FIRST tt-estab NO-LOCK
    WHERE tt-estab.cod-estabel       = tt-ordem-manut.cod_estab,
    EACH tt-ccusto 
    WHERE tt-ccusto.cod_empresa      = v_cdn_empresa
    AND   tt-ccusto.cod_plano_ccusto = v_cod_plano_ccusto
    AND   tt-ccusto.cod_ccusto       = tt-ordem-manut.sc-desp:

    FIND dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5 
        AND   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel  
        AND   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano     
        AND   dc-orc-realizado.cod_ccusto        = tt-ordem-manut.sc-desp
        AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
        AND   dc-orc-realizado.cod_cta_ctbl      = tt-ordem-manut.ct-desp
        AND   dc-orc-realizado.modulo            = "Manutená∆o"
        AND   dc-orc-realizado.data              = tt-ordem-manut.data NO-ERROR.
    IF NOT AVAIL dc-orc-realizado THEN DO:
        CREATE dc-orc-realizado.
        ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5 
               dc-orc-realizado.cod_estab         = tt-estab.cod-estabel     
               dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano        
               dc-orc-realizado.cod_ccusto        = tt-ordem-manut.sc-desp
               dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl       
               dc-orc-realizado.cod_cta_ctbl      = tt-ordem-manut.ct-desp
               dc-orc-realizado.data              = tt-ordem-manut.data
               dc-orc-realizado.modulo            = "Manutená∆o"
               dc-orc-realizado.descricao         = "Lanáamentos de Manutená∆o (" + STRING(MONTH(tt-ordem-manut.data),"99") + "/" + STRING(YEAR(tt-ordem-manut.data)) + ")".
    END.

     ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
            dc-orc-realizado.hra-ult-atualiza  = TIME
            dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
            dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + tt-ordem-manut.valor-mat + tt-ordem-manut.valor-ggf.

    COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
    IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
        ASSIGN lc-det-realizado = "CCusto;Dt Trans  ;Nr Ord Prod;Valor         ;Narrativa".

    ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                                     +
                              tt-ordem-manut.sc-desp                                                         + ";" +
                              STRING(tt-ordem-manut.data,"99/99/9999")                                       + ";" +
                              STRING(tt-ordem-manut.nr-ord-produ,">>>,>>>,>>9" )                             + ";" +
                              STRING(tt-ordem-manut.valor-mat + tt-ordem-manut.valor-ggf,">>>,>>>,>>9.99") + ";" +
                              tt-ordem-manut.narrativa.

    COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
    
END.

FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo           = "Ferramentaria"
    AND   dc-orc-realizado.data            >= dt-periodo-ini
    AND   dc-orc-realizado.data            <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:

    ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
           dc-orc-realizado.hra-ult-atualiza  = ?
           dc-orc-realizado.usario-atualiza   = ""
           dc-orc-realizado.det-previsto      = ""
           dc-orc-realizado.det-realizado     = ""
           dc-orc-realizado.valor-orcto       = 0
           dc-orc-realizado.valor-previsto    = 0
           dc-orc-realizado.valor-realizado   = 0.
END.

PUT UNFORMATTED "Carga Ferramentar.: " STRING(TIME,"HH:MM:SS") SKIP.

FOR EACH tt-ferr-movto
    WHERE tt-ferr-movto.valor-mat-m[1] > 0 
    OR    tt-ferr-movto.valor-mob-m[1] > 0 
    OR    tt-ferr-movto.valor-ggf-m[1] > 0,
    FIRST tt-estab NO-LOCK
    WHERE tt-estab.cod-estabel       = tt-ferr-movto.cod-estabel,
    EACH tt-ccusto 
    WHERE tt-ccusto.cod_empresa      = v_cdn_empresa
    AND   tt-ccusto.cod_plano_ccusto = v_cod_plano_ccusto
    AND   tt-ccusto.cod_ccusto       = tt-ferr-movto.sc-codigo :
    FIND dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
        AND   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel 
        AND   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano    
        AND   dc-orc-realizado.cod_ccusto        = tt-ferr-movto.sc-codigo
        AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
        AND   dc-orc-realizado.cod_cta_ctbl      = tt-ferr-movto.ct-codigo
        AND   dc-orc-realizado.modulo            = "Ferramentaria"
        AND   dc-orc-realizado.data              = tt-ferr-movto.data NO-ERROR.
    IF NOT AVAIL dc-orc-realizado THEN DO:
        CREATE dc-orc-realizado.
        ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
               dc-orc-realizado.cod_estab         = tt-estab.cod-estabel 
               dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano      
               dc-orc-realizado.cod_ccusto        = tt-ferr-movto.sc-codigo
               dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl       
               dc-orc-realizado.cod_cta_ctbl      = tt-ferr-movto.ct-codigo
               dc-orc-realizado.data              = tt-ferr-movto.data
               dc-orc-realizado.modulo            = "Ferramentaria"
               dc-orc-realizado.descricao         = "Lanáamentos de Ferramentaria (" + STRING(MONTH(tt-ferr-movto.data),"99") + "/" + STRING(YEAR(tt-ferr-movto.data)) + ")".
    END.

     ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
            dc-orc-realizado.hra-ult-atualiza  = TIME
            dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
            dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + tt-ferr-movto.valor-mat-m[1] + tt-ferr-movto.valor-mob-m[1] + tt-ferr-movto.valor-ggf-m[1].

    COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
    IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
        ASSIGN lc-det-realizado = "CCusto;Dt Trans  ;Nr Ord Prod;Valor         ;Narrativa".

    ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                                                  +
                              tt-ferr-movto.sc-codigo                                                               + ";" +
                              STRING(tt-ferr-movto.data,"99/99/9999")                                               + ";" +
                              STRING(tt-ferr-movto.nr-ord-produ,">>>,>>>,>>9")                                      + ";" +
                              STRING(tt-ferr-movto.valor-mat-m[1] + tt-ferr-movto.valor-mob-m[1] + tt-ferr-movto.valor-ggf-m[1],">>>,>>>,>>9.99")  + ";" +
                              tt-ferr-movto.narrativa.

    COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
END.

PUT SKIP(1)
        " * * * Carga do Valor Realizado Manutená∆o/Ferramentaria realizada com sucesso!" SKIP(3).

/* --- (FIM) CARGA ORDENS DE MANUTENÄ«O --- */

PUT UNFORMATTED "Devoluá‰es........: " STRING(TIME,"HH:MM:SS") SKIP.

/* --- DEVOLUÄÂES/RECOMPRAS POR CENTRO DE CUSTO --------------------- */

PUT SKIP(1)
    "CARGA DE DEVOLUÄÂES/RECOMPRAS" SKIP
    "-----------------------------" SKIP(2).

FOR each tt-estab NO-LOCK:

    RUN dop/doc010dev.p (INPUT tt-estab.cod-emp-ems5       , /* c-cod-empresa        */
                         INPUT tt-estab.cod-estabel   /*"9"*/   , /* c-lista-cod-estab    */
                         INPUT dt-periodo-ini      , /* dt-periodo-ini       */
                         INPUT dt-periodo-fim      , /* dt-periodo-fin       */
                         INPUT "611700"            , /* c-ct-cpv-orcam-db    */
                         INPUT "612700"            , /* c-ct-cpv-orcam-cr    */
                         INPUT "416000"            , /* c-ct-cpv-var         */
                         INPUT "417000"            , /* c-ct-cpv-fixo        */
                         INPUT "418000"            , /* c-ct-recomp-cpv-var  */
                         INPUT "419000"            , /* c-ct-recomp-cpv-fixo */
                         OUTPUT TABLE tt-devolucao,
                         OUTPUT TABLE tt-contabiliza).
    
    FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa      = tt-estab.cod-emp-ems5
        AND   dc-orc-realizado.cod_estab        = tt-estab.cod-estabel 
        AND   dc-orc-realizado.modulo           = "Devoluá∆o"
        AND   dc-orc-realizado.data            >= dt-periodo-ini
        AND   dc-orc-realizado.data            <= dt-periodo-fim,
        EACH tt-ccusto OF dc-orc-realizado:
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
               dc-orc-realizado.hra-ult-atualiza  = ?
               dc-orc-realizado.usario-atualiza   = ""
               dc-orc-realizado.det-previsto      = ""
               dc-orc-realizado.det-realizado     = ""
               dc-orc-realizado.valor-orcto       = 0
               dc-orc-realizado.valor-previsto    = 0
               dc-orc-realizado.valor-realizado   = 0.
    END.
    
    PUT UNFORMATTED "Carga Devoluá‰es..: " STRING(TIME,"HH:MM:SS") SKIP.
    
    FOR EACH tt-contabiliza NO-LOCK,
        EACH tt-ccusto 
        WHERE tt-ccusto.cod_empresa      = tt-contabiliza.cod-empresa
        AND   tt-ccusto.cod_plano_ccusto = tt-estab.cc-plano
        AND   tt-ccusto.cod_ccusto       = tt-contabiliza.cod_ccusto :
    
        /* Ignora movimentos do oráamento */
        IF tt-contabiliza.movto = "" THEN NEXT.
    
        FIND dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
            AND   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel 
            AND   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano    
            AND   dc-orc-realizado.cod_ccusto        = tt-contabiliza.cod_ccusto
            AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
            AND   dc-orc-realizado.cod_cta_ctbl      = tt-contabiliza.cod_cta_ctbl
            AND   dc-orc-realizado.modulo            = "Devoluá∆o"
            AND   dc-orc-realizado.data              = tt-contabiliza.data NO-ERROR.
        IF NOT AVAIL dc-orc-realizado THEN DO:
            CREATE dc-orc-realizado.
            ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5 
                   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel  
                   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano     
                   dc-orc-realizado.cod_ccusto        = tt-contabiliza.cod_ccusto  
                   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl       
                   dc-orc-realizado.cod_cta_ctbl      = tt-contabiliza.cod_cta_ctbl
                   dc-orc-realizado.data              = tt-contabiliza.data
                   dc-orc-realizado.modulo            = "Devoluá∆o"
                   dc-orc-realizado.descricao         = "Lanáamentos de Devoluá∆o (" + STRING(MONTH(tt-contabiliza.data),"99") + "/" + STRING(YEAR(tt-contabiliza.data)) + ")".
        END.
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
               dc-orc-realizado.hra-ult-atualiza  = TIME
               dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
               dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + (IF tt-contabiliza.movto = "DB" THEN tt-contabiliza.valor ELSE tt-contabiliza.valor * -1).
    
        COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
        IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
            ASSIGN lc-det-realizado = "CCusto;Dt Trans  ;Estab;Emitente ;Nome Abrev  ;SÇrie;SÇrie;Documento       ;Nat Oper;Recompra;Valor Movto".
    
        /* Devoluá∆o */
        FOR EACH tt-devolucao
            WHERE tt-devolucao.ep-codigo       = tt-estab.cod-emp-ems5
            AND   tt-devolucao.cod-estabel     = tt-estab.cod-estabel 
            AND   tt-devolucao.sc-debito-devol = tt-contabiliza.cod_ccusto
            AND   tt-devolucao.ct-debito-devol = tt-contabiliza.cod_cta_ctbl
            AND   tt-devolucao.dt-trans >= DATE(MONTH(tt-contabiliza.data),1,YEAR(tt-contabiliza.data))
            AND   tt-devolucao.dt-trans <= tt-contabiliza.data:
    
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-devolucao.cod-emit NO-ERROR.
    
            ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                    +
                                      tt-devolucao.sc-debito-devol                            + ";" +
                                      STRING(tt-devolucao.dt-trans,'99/99/9999')              + ";" +
                                      tt-devolucao.cod-estabel                                + ";" +
                                      STRING(tt-devolucao.cod-emit,">>>>>>>>9")               + ";" +
                                      (IF AVAIL emitente THEN emitente.nome-abrev ELSE "")    + ";" +
                                      tt-devolucao.serie-docto                                + ";" +
                                      tt-devolucao.nro-docto                                  + ";" +
                                      tt-devolucao.nat-oper                                   + ";" +
                                      STRING(tt-devolucao.log-dev-recompr,"Sim/N∆o")          + ";" +
                                      STRING(tt-devolucao.vl-contab-devol,">>>,>>>,>>9.9999").
    
        END.
    
        /* CrÇdito CPV Var */
        FOR EACH tt-devolucao
            WHERE tt-devolucao.ep-codigo      = tt-estab.cod-emp-ems5
            AND   tt-devolucao.cod-estabel    = tt-estab.cod-estabel 
            AND   tt-devolucao.sc-credito-var = tt-contabiliza.cod_ccusto
            AND   tt-devolucao.ct-credito-var = tt-contabiliza.cod_cta_ctbl
            AND   tt-devolucao.dt-trans >= DATE(MONTH(tt-contabiliza.data),1,YEAR(tt-contabiliza.data))
            AND   tt-devolucao.dt-trans <= tt-contabiliza.data:
    
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-devolucao.cod-emit NO-ERROR.
    
            ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                    +
                                      tt-devolucao.sc-credito-var                             + ";" +
                                      STRING(tt-devolucao.dt-trans,'99/99/9999')              + ";" +
                                      tt-devolucao.cod-estabel                                + ";" +
                                      STRING(tt-devolucao.cod-emit,">>>>>>>>9")               + ";" +
                                      (IF AVAIL emitente THEN emitente.nome-abrev ELSE "")    + ";" +
                                      tt-devolucao.serie-docto                                + ";" +
                                      tt-devolucao.nro-docto                                  + ";" +
                                      tt-devolucao.nat-oper                                   + ";" +
                                      STRING(tt-devolucao.log-dev-recompr,"Sim/N∆o")          + ";" +
                                      STRING(tt-devolucao.vl-contab-var,">>>,>>>,>>9.9999").
    
        END.
    
        /* CrÇdito ICMS */
        FOR EACH tt-devolucao
            WHERE tt-devolucao.ep-codigo      = tt-estab.cod-emp-ems5
            AND   tt-devolucao.cod-estabel    = tt-estab.cod-estabel 
            AND   tt-devolucao.sc-debito-icms = tt-contabiliza.cod_ccusto
            AND   tt-devolucao.ct-debito-icms = tt-contabiliza.cod_cta_ctbl
            AND   tt-devolucao.dt-trans >= DATE(MONTH(tt-contabiliza.data),1,YEAR(tt-contabiliza.data))
            AND   tt-devolucao.dt-trans <= tt-contabiliza.data:
    
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-devolucao.cod-emit NO-ERROR.
    
            ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                    +
                                      tt-devolucao.sc-debito-icms                             + ";" +
                                      STRING(tt-devolucao.dt-trans,"99/99/9999")              + ";" +
                                      tt-devolucao.cod-estabel                                + ";" +
                                      STRING(tt-devolucao.cod-emit,">>>>>>>>9")               + ";" +
                                      (IF AVAIL emitente THEN emitente.nome-abrev ELSE "")    + ";" +
                                      tt-devolucao.serie-docto                                + ";" +
                                      tt-devolucao.nro-docto                                  + ";" +
                                      tt-devolucao.nat-oper                                   + ";" +
                                      STRING(tt-devolucao.log-dev-recompr,"Sim/N∆o")          + ";" +
                                      STRING(tt-devolucao.vl-contab-icms,">>>,>>>,>>9.9999").
    
        END.
    
        COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
    END.
END.

PUT SKIP(1)
        " * * * Carga do Valor Realizado Devoluá‰es/Recompras realizada com sucesso!" SKIP(3).

/* --- (FIM) DEVOLUÄÂES/RECOMPRAS POR CENTRO DE CUSTO --------------- */

/* --- ABATIMENTOS POR CENTRO DE CUSTO --------------------- */

PUT SKIP(1)
    "CARGA DO ABATIMENTOS" SKIP
    "--------------------" SKIP(2).

RUN pi-seta-titulo IN h-acomp ("Buscando Abatimentos").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

FOR each tt-estab NO-LOCK:

    RUN dop/doc004abat.p (INPUT tt-estab.cod-emp-ems5        , /* c-cod-empresa        */
                          INPUT tt-estab.cod-estabel  /*"9"*/     , /* c-lista-cod-estab    */
                          INPUT dt-periodo-ini        , /* dt-periodo-ini       */
                          INPUT dt-periodo-fim        , /* dt-periodo-fin       */
                          INPUT YES                   , /* c-ct-cpv-orcam-db    */
                          OUTPUT TABLE tt-movto       ,
                          OUTPUT TABLE tt-resumo-movto,
                          OUTPUT c-mensagem).
    
    FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa      = tt-estab.cod-emp-ems5
        AND   dc-orc-realizado.cod_estab        = tt-estab.cod-estabel 
        AND   dc-orc-realizado.modulo           = "Abatimento"
        AND   dc-orc-realizado.data            >= dt-periodo-ini
        AND   dc-orc-realizado.data            <= dt-periodo-fim,
        EACH tt-ccusto OF dc-orc-realizado:
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
               dc-orc-realizado.hra-ult-atualiza  = ?
               dc-orc-realizado.usario-atualiza   = ""
               dc-orc-realizado.det-previsto      = ""
               dc-orc-realizado.det-realizado     = ""
               dc-orc-realizado.valor-orcto       = 0
               dc-orc-realizado.valor-previsto    = 0
               dc-orc-realizado.valor-realizado   = 0.
    END.
    
    PUT UNFORMATTED "Carga Abatimentos.: " STRING(TIME,"HH:MM:SS") SKIP.
    
    FOR EACH tt-resumo-movto NO-LOCK,
        EACH tt-ccusto 
        WHERE tt-ccusto.cod_empresa      = tt-resumo-movto.cod_empresa
        AND   tt-ccusto.cod_plano_ccusto = tt-resumo-movto.cod_plano_ccusto
        AND   tt-ccusto.cod_ccusto       = tt-resumo-movto.cod_ccusto :
    
        RUN pi-acompanhar IN h-acomp ("Abatimentos CC " + tt-ccusto.cod_ccusto ).
        
        FIND dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.cod_empresa       = tt-resumo-movto.cod_empresa
            AND   dc-orc-realizado.cod_estab         = tt-resumo-movto.cod_estab
            AND   dc-orc-realizado.cod_plano_ccusto  = tt-resumo-movto.cod_plano_ccusto
            AND   dc-orc-realizado.cod_ccusto        = tt-resumo-movto.cod_ccusto
            AND   dc-orc-realizado.cod_plano_ctbl    = tt-resumo-movto.cod_plano_cta
            AND   dc-orc-realizado.cod_cta_ctbl      = tt-resumo-movto.cod_cta_ctbl
            AND   dc-orc-realizado.modulo            = "Abatimento"
            AND   dc-orc-realizado.data              = tt-resumo-movto.data NO-ERROR.
        IF NOT AVAIL dc-orc-realizado THEN DO:
            CREATE dc-orc-realizado.
            ASSIGN dc-orc-realizado.cod_empresa       = tt-resumo-movto.cod_empresa     
                   dc-orc-realizado.cod_estab         = tt-resumo-movto.cod_estab       
                   dc-orc-realizado.cod_plano_ccusto  = tt-resumo-movto.cod_plano_ccusto
                   dc-orc-realizado.cod_ccusto        = tt-resumo-movto.cod_ccusto      
                   dc-orc-realizado.cod_plano_ctbl    = tt-resumo-movto.cod_plano_cta_ctbl
                   dc-orc-realizado.cod_cta_ctbl      = tt-resumo-movto.cod_cta_ctbl    
                   dc-orc-realizado.data              = tt-resumo-movto.data
                   dc-orc-realizado.modulo            = "Abatimento"
                   dc-orc-realizado.descricao         = "Lanáamentos de Abatimentos (" + STRING(MONTH(tt-resumo-movto.data),"99") + "/" + STRING(YEAR(tt-resumo-movto.data)) + ")".
        END.
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
               dc-orc-realizado.hra-ult-atualiza  = TIME
               dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
               dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + tt-resumo-movto.vl-abatimento.
    
        COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
        IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
            ASSIGN lc-det-realizado = "Espec;T°tulo    ;P/;Ser;Dt Emiss∆o;Dt Vencto ;Un ;Cliente    ;Nome Cliente                            ;Total Abatimento".
    
        /* Abatimentos */
        FOR EACH tt-movto
            WHERE tt-movto.ccusto          = tt-resumo-movto.cod_ccusto
            AND   tt-movto.cod_cta_ctbl-db = tt-resumo-movto.cod_cta_ctbl
            AND   tt-movto.dat_transacao >= DATE(MONTH(tt-resumo-movto.data),1,YEAR(tt-resumo-movto.data))
            AND   tt-movto.dat_transacao <= tt-resumo-movto.data:
    
            ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                    +
                                      tt-movto.cod-espec                               + ";" + 
                                      tt-movto.cod-tit-acr                             + ";" + 
                                      tt-movto.cod-parcela                             + ";" + 
                                      tt-movto.cod_ser_docto                           + ";" + 
                                      STRING(tt-movto.dat_emis_docto,"99/99/9999")     + ";" + 
                                      STRING(tt-movto.dat_vencto_tit_acr,"99/99/9999") + ";" + 
                                      tt-movto.unid-neg                                + ";" +
                                      STRING(tt-movto.cod-cliente,">>>,>>>,>>9")       + ";" +
                                      tt-movto.nome-cliente                            + ";" +
                                      STRING(tt-movto.vl-abatimento,">>>,>>>,>>9.99").
    
        END.
    
        COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
    END.
END.

PUT SKIP(1)
        " * * * Carga do Valor Realizado Abatimentos realizada com sucesso!" SKIP(3).

/* --- (FIM) ABATIMENTOS POR CENTRO DE CUSTO --------------- */

/* --- BONIFICAÄÂES POR CENTRO DE CUSTO --------------------- */

PUT SKIP(1)
    "CARGA DO BONIFICAÄÂES" SKIP
    "---------------------" SKIP(2).

RUN pi-seta-titulo IN h-acomp ("Buscando Bonificaá‰es").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

FOR each tt-estab NO-LOCK:

    RUN dop/doc009cpv.p (tt-estab.cod-emp-ems5,
                         tt-estab.cod-estabel   /*"9"*/ ,
                         "97",
                         dt-periodo-ini,
                         dt-periodo-fim,
                         YES,
                         "325000",
                         YES,
                         OUTPUT c-mensagem,
                         OUTPUT c-msg-ajuda,
                         OUTPUT TABLE tt-detalhe-cpv,
                         OUTPUT TABLE tt-resumo-cpv,
                         OUTPUT TABLE tt-cont-cpv).
    
    FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
        WHERE dc-orc-realizado.cod_empresa      = tt-estab.cod-emp-ems5
        AND   dc-orc-realizado.cod_estab        = tt-estab.cod-estabel 
        AND   dc-orc-realizado.modulo           = "Bonificaá∆o"
        AND   dc-orc-realizado.data            >= dt-periodo-ini
        AND   dc-orc-realizado.data            <= dt-periodo-fim,
        EACH tt-ccusto OF dc-orc-realizado:
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
               dc-orc-realizado.hra-ult-atualiza  = ?
               dc-orc-realizado.usario-atualiza   = ""
               dc-orc-realizado.det-previsto      = ""
               dc-orc-realizado.det-realizado     = ""
               dc-orc-realizado.valor-orcto       = 0
               dc-orc-realizado.valor-previsto    = 0
               dc-orc-realizado.valor-realizado   = 0.
    END.
    
    PUT UNFORMATTED "Carga Bonificaá∆o.: " STRING(TIME,"HH:MM:SS") SKIP.
    
    FOR EACH tt-cont-cpv NO-LOCK
        WHERE tt-cont-cpv.valor > 0,
        EACH tt-ccusto 
        WHERE tt-ccusto.cod_empresa      = tt-cont-cpv.cod-empresa
        AND   tt-ccusto.cod_plano_ccusto = tt-estab.cc-plano
        AND   tt-ccusto.cod_ccusto       = tt-cont-cpv.cod_ccusto :
    
        RUN pi-acompanhar IN h-acomp ("Bonificaá‰es CC " + tt-ccusto.cod_ccusto ).
        
        FIND dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
            AND   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel 
            AND   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano    
            AND   dc-orc-realizado.cod_ccusto        = tt-cont-cpv.cod_ccusto
            AND   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl
            AND   dc-orc-realizado.cod_cta_ctbl      = tt-cont-cpv.cod_cta_ctbl
            AND   dc-orc-realizado.modulo            = "Bonificaá∆o"
            AND   dc-orc-realizado.data              = tt-cont-cpv.data NO-ERROR.
        IF NOT AVAIL dc-orc-realizado THEN DO:
            CREATE dc-orc-realizado.
            ASSIGN dc-orc-realizado.cod_empresa       = tt-estab.cod-emp-ems5
                   dc-orc-realizado.cod_estab         = tt-estab.cod-estabel 
                   dc-orc-realizado.cod_plano_ccusto  = tt-estab.cc-plano      
                   dc-orc-realizado.cod_ccusto        = tt-cont-cpv.cod_ccusto
                   dc-orc-realizado.cod_plano_ctbl    = v_cod_plano_cta_ctbl                
                   dc-orc-realizado.cod_cta_ctbl      = tt-cont-cpv.cod_cta_ctbl
                   dc-orc-realizado.data              = tt-cont-cpv.data
                   dc-orc-realizado.modulo            = "Bonificaá∆o"
                   dc-orc-realizado.descricao         = "Lanáamentos de Bonificaá‰es (" + STRING(MONTH(tt-cont-cpv.data),"99") + "/" + STRING(YEAR(tt-cont-cpv.data)) + ")".
        END.
    
        ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
               dc-orc-realizado.hra-ult-atualiza  = TIME
               dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
               dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + IF tt-cont-cpv.movto = "DB" THEN tt-cont-cpv.valor ELSE (tt-cont-cpv.valor * -1).
    
        COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
        IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
            ASSIGN lc-det-realizado = "CCusto;Dt Trans  ;Est;SÇrie;Nr Nota     ;Emitente   ;Nome Abrev  ;Item       ;Descricao                                         ;Material       ;MOB            ;Impostos".
    
        /* Movimentos */
        FOR EACH tt-detalhe-cpv
            WHERE tt-detalhe-cpv.cc-codigo  = tt-cont-cpv.cod_ccusto
            AND   tt-detalhe-cpv.data      >= DATE(MONTH(tt-cont-cpv.data),1,YEAR(tt-cont-cpv.data))
            AND   tt-detalhe-cpv.data      <= tt-cont-cpv.data:
    
            IF (tt-cont-cpv.movto = "DB" AND (tt-detalhe-cpv.vl-mat + tt-detalhe-cpv.vl-mob + tt-detalhe-cpv.vl-impostos) < 0) OR 
               (tt-cont-cpv.movto = "CR" AND (tt-detalhe-cpv.vl-mat + tt-detalhe-cpv.vl-mob + tt-detalhe-cpv.vl-impostos) > 0) THEN NEXT.
    
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-detalhe-cpv.cod-emitente NO-ERROR.
    
            ASSIGN lc-det-realizado = lc-det-realizado + CHR(10)                                    +
                                      tt-detalhe-cpv.cc-codigo                                + ";" +
                                      STRING(tt-detalhe-cpv.data,"99/99/9999")                + ";" +
                                      tt-detalhe-cpv.cod-estabel                              + ";" +
                                      tt-detalhe-cpv.serie                                    + ";" +
                                      tt-detalhe-cpv.nr-nota-fis                              + ";" +
                                      STRING(tt-detalhe-cpv.cod-emitente,">>>,>>>,>>9")       + ";" +
                                      (IF AVAIL emitente THEN emitente.nome-abrev ELSE "")    + ";" +
                                      tt-detalhe-cpv.it-codigo                                + ";" +
                                      STRING(tt-detalhe-cpv.desc-item, "x(50)")               + ";" +
                                      STRING(tt-detalhe-cpv.vl-mat,"->>>,>>>,>>9.99")         + ";" +
                                      STRING(tt-detalhe-cpv.vl-mob,"->>>,>>>,>>9.99")         + ";" +
                                      STRING(tt-detalhe-cpv.vl-impostos,"->>>,>>>,>>9.99").
    
        END.
    
        COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
    END.
END.

PUT SKIP(1)
        " * * * Carga do Valor Realizado Bonificaá‰es realizada com sucesso!" SKIP(3).

/* --- (FIM) CPV POR CENTRO DE CUSTO --------------- */
  

/* --- CONTAS A PAGAR E LOTES DA CONTABILIDADE --------------- */

RUN pi-seta-titulo IN h-acomp ("Buscando Realizado - APB/FGL").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

PUT UNFORMATTED "APB e FGL.........: " STRING(TIME,"HH:MM:SS") SKIP.

PUT SKIP(1)
    "CARGA DO CONTAS A PAGAR E CONTABILIDADE" SKIP
    "---------------------------------------" SKIP(2).

FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo           = "FGL"
    AND   dc-orc-realizado.data            >= dt-periodo-ini
    AND   dc-orc-realizado.data            <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:

    ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
           dc-orc-realizado.hra-ult-atualiza  = ?
           dc-orc-realizado.usario-atualiza   = ""
           dc-orc-realizado.det-previsto      = ""
           dc-orc-realizado.det-realizado     = ""
           dc-orc-realizado.valor-orcto       = 0
           dc-orc-realizado.valor-previsto    = 0
           dc-orc-realizado.valor-realizado   = 0.
END.

FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.modulo           = "APB"
    AND   dc-orc-realizado.data            >= dt-periodo-ini
    AND   dc-orc-realizado.data            <= dt-periodo-fim,
    EACH tt-ccusto OF dc-orc-realizado:

    ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
           dc-orc-realizado.hra-ult-atualiza  = ?
           dc-orc-realizado.usario-atualiza   = ""
           dc-orc-realizado.det-previsto      = ""
           dc-orc-realizado.det-realizado     = ""
           dc-orc-realizado.valor-orcto       = 0
           dc-orc-realizado.valor-previsto    = 0
           dc-orc-realizado.valor-realizado   = 0.
END.

FOR EACH tt-ccusto:
    
    DO dt-aux = dt-periodo-ini TO dt-periodo-fim:

        RUN pi-acompanhar IN h-acomp ("Data: " + STRING(dt-aux,"99/99/9999") + " - " + tt-ccusto.cod_ccusto).

        ASSIGN dt-refer = DATE(MONTH(dt-aux),1,YEAR(dt-aux))
               dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.
        
        /* Contas a Pagar */
        FOR EACH tt-cta-pesq,
            EACH aprop_ctbl_ap USE-INDEX aprpctbl_estab_cta_ctbl_data NO-LOCK
           WHERE aprop_ctbl_ap.cod_estab          = tt-cta-pesq.cod_estab
             AND aprop_ctbl_ap.cod_plano_cta_ctbl = tt-cta-pesq.cod_plano_cta_ctbl
             AND aprop_ctbl_ap.cod_cta_ctbl       = tt-cta-pesq.cod_cta_ctbl
             AND aprop_ctbl_ap.dat_transacao      = dt-aux
             AND aprop_ctbl_ap.cod_unid_negoc     = tt-ccusto.cod_empresa
             AND aprop_ctbl_ap.cod_plano_ccusto   = tt-ccusto.cod_plano_ccusto
             AND aprop_ctbl_ap.cod_ccusto         = tt-ccusto.cod_ccusto,
           FIRST val_aprop_ctbl_ap OF aprop_ctbl_ap NO-LOCK
           WHERE val_aprop_ctbl_ap.cod_finalid_econ = 'Corrente',
           FIRST movto_tit_ap OF aprop_ctbl_ap NO-LOCK:
           
           IF  movto_tit_ap.log_movto_estordo AND 
               NOT movto_tit_ap.log_aprop_ctbl_ctbzda THEN NEXT.

            FIND dc-orc-realizado EXCLUSIVE-LOCK
                WHERE dc-orc-realizado.cod_empresa      = aprop_ctbl_ap.cod_empresa
                AND   dc-orc-realizado.cod_estab        = aprop_ctbl_ap.cod_estab
                AND   dc-orc-realizado.cod_plano_ctbl   = aprop_ctbl_ap.cod_plano_cta_ctbl
                AND   dc-orc-realizado.cod_cta_ctbl     = aprop_ctbl_ap.cod_cta_ctbl
                AND   dc-orc-realizado.cod_plano_ccusto = aprop_ctbl_ap.cod_plano_ccusto
                AND   dc-orc-realizado.cod_ccusto       = aprop_ctbl_ap.cod_ccusto
                AND   dc-orc-realizado.modulo           = "APB"
                AND   dc-orc-realizado.data             = dt-refer NO-ERROR.
            IF NOT AVAIL dc-orc-realizado THEN DO:
                CREATE dc-orc-realizado.
                ASSIGN dc-orc-realizado.cod_empresa       = aprop_ctbl_ap.cod_empresa
                       dc-orc-realizado.cod_estab         = aprop_ctbl_ap.cod_estab
                       dc-orc-realizado.cod_plano_ctbl    = aprop_ctbl_ap.cod_plano_cta_ctbl
                       dc-orc-realizado.cod_cta_ctbl      = aprop_ctbl_ap.cod_cta_ctbl
                       dc-orc-realizado.cod_plano_ccusto  = aprop_ctbl_ap.cod_plano_ccusto
                       dc-orc-realizado.cod_ccusto        = aprop_ctbl_ap.cod_ccusto
                       dc-orc-realizado.modulo            = "APB"
                       dc-orc-realizado.data              = dt-refer
                       dc-orc-realizado.descricao         = "Resumo Contas a Pagar (" + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) + ")"
                       .
            END.

            COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.
            
            IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
                ASSIGN lc-det-realizado               = "CCusto;Dt Trans  ;Emitente   ;Nome Abrev  ;Estab;Espec;SÇrie;Docto     ;P/;Valor            ;Hist¢rico" + CHR(10).

            ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
                   dc-orc-realizado.hra-ult-atualiza  = TIME
                   dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
                   dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + (IF aprop_ctbl_ap.ind_natur_lancto_ctbl = "DB" 
                                                                                            THEN  val_aprop_ctbl_ap.val_aprop_ctbl
                                                                                            ELSE (val_aprop_ctbl_ap.val_aprop_ctbl * -1)).

           ASSIGN lc-det-realizado = lc-det-realizado                                 + 
                                     aprop_ctbl_ap.cod_ccusto                         + ";" +
                                     STRING(aprop_ctbl_ap.dat_transacao,"99/99/9999") + ";".

           FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
           IF AVAIL tit_ap THEN DO:
              ASSIGN lc-det-realizado = lc-det-realizado + STRING(tit_ap.cdn_fornecedor,">>>,>>>,>>9") + ";".

              FIND FIRST emsuni.fornecedor OF tit_ap NO-LOCK NO-ERROR.
              IF AVAIL fornecedor THEN
                 ASSIGN lc-det-realizado = lc-det-realizado + fornecedor.nom_abrev + ";".
              ELSE
                  ASSIGN lc-det-realizado = lc-det-realizado + ";".

              ASSIGN lc-det-realizado = lc-det-realizado + TRIM(tit_ap.cod_estab)                      + ";" +
                                                           TRIM(tit_ap.cod_espec_docto)                + ";" +
                                                           TRIM(tit_ap.cod_ser_docto)                  + ";" +
                                                           TRIM(tit_ap.cod_tit_ap)                     + ";" +
                                                           TRIM(tit_ap.cod_parcela)                    + ";".
           END.
           ELSE
               ASSIGN lc-det-realizado = lc-det-realizado + ";;;;;;;".

           ASSIGN lc-det-realizado = lc-det-realizado + STRING(IF aprop_ctbl_ap.ind_natur_lancto_ctbl = "DB" 
                                                               THEN  val_aprop_ctbl_ap.val_aprop_ctbl
                                                               ELSE (val_aprop_ctbl_ap.val_aprop_ctbl * -1),"->>>>>,>>>,>>9.99") + ";".

           FIND FIRST histor_tit_movto_ap NO-LOCK
                WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                  AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap
                  AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap NO-ERROR.
           IF AVAIL histor_tit_movto_ap THEN
               ASSIGN lc-det-realizado = lc-det-realizado + REPLACE(histor_tit_movto_ap.des_text_histor,CHR(10)," ") + CHR(10).
           ELSE
               ASSIGN lc-det-realizado = lc-det-realizado + CHR(10).

           COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
        END.
        /* FIM-Contas a Pagar */
        
        /* Contabilidade */
        FOR EACH tt-cta-pesq,
            EACH item_lancto_ctbl NO-LOCK
           WHERE item_lancto_ctbl.cod_empresa        = tt-ccusto.cod_empresa
             AND item_lancto_ctbl.cod_plano_cta_ctbl = tt-cta-pesq.cod_plano_cta_ctbl
             AND item_lancto_ctbl.cod_cta_ctbl       = tt-cta-pesq.cod_cta_ctbl
             AND item_lancto_ctbl.cod_plano_ccusto   = tt-ccusto.cod_plano_ccusto
             AND item_lancto_ctbl.cod_ccusto         = tt-ccusto.cod_ccusto
             AND item_lancto_ctbl.cod_estab          = tt-cta-pesq.cod_estab
             AND item_lancto_ctbl.cod_unid_negoc     = tt-ccusto.cod_empresa /*v_cdn_empresa*/
             AND item_lancto_ctbl.cod_proj_financ    = ""
             AND item_lancto_ctbl.dat_lancto_ctbl    = dt-aux,
           FIRST lancto_ctbl OF ITEM_lancto_ctbl NO-LOCK
           WHERE lancto_ctbl.cod_modul_dtsul        <> "CEP"
             AND lancto_ctbl.cod_modul_dtsul        <> "APB"
             AND NOT lancto_ctbl.log_lancto_apurac_restdo
             AND (lancto_ctbl.cod_cenar_ctbl          = "Fiscal" OR
                  lancto_ctbl.cod_cenar_ctbl          = ""),
           FIRST aprop_lancto_ctbl OF item_lancto_ctbl NO-LOCK 
           WHERE aprop_lancto_ctbl.cod_finalid_econ  = "Corrente":

           FIND FIRST lote_ctbl OF lancto_ctbl NO-LOCK NO-ERROR.
           IF  AVAIL lote_ctbl 
               AND lote_ctbl.des_lote_ctbl BEGINS "MFP" /* Movimentos da folha */ THEN DO:
               
               /* Verifica se a conta j† possui valor realizado do HCM                 */
               FIND FIRST dc-orc-realizado NO-LOCK
                   WHERE dc-orc-realizado.cod_empresa        = item_lancto_ctbl.cod_empresa
                   AND   dc-orc-realizado.cod_estab          = item_lancto_ctbl.cod_estab
                   AND   dc-orc-realizado.cod_plano_ctbl     = item_lancto_ctbl.cod_plano_cta_ctbl 
                   AND   dc-orc-realizado.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl
                   AND   dc-orc-realizado.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
                   AND   dc-orc-realizado.cod_ccusto         = item_lancto_ctbl.cod_ccusto
                   AND   dc-orc-realizado.modulo             = "HCM"
                   AND   dc-orc-realizado.data               = dt-refer NO-ERROR.
               IF AVAIL dc-orc-realizado THEN NEXT.
           END.

           IF AVAIL lote_ctbl AND
              (lote_ctbl.des_lote_ctbl BEGINS "CPV por Centro de Custo" OR
               lote_ctbl.des_lote_ctbl BEGINS "Devoluá∆o por Centro de Custo" OR
               lote_ctbl.des_lote_ctbl BEGINS "Devoluá‰es por Centro de Custo")  THEN DO:

               
               /* Verifica se a conta j† possui valor realizado de Devoluá∆o                 */
               FIND FIRST dc-orc-realizado NO-LOCK
                   WHERE dc-orc-realizado.cod_empresa        = item_lancto_ctbl.cod_empresa
                   AND   dc-orc-realizado.cod_estab          = item_lancto_ctbl.cod_estab
                   AND   dc-orc-realizado.cod_plano_ctbl     = item_lancto_ctbl.cod_plano_cta_ctbl 
                   AND   dc-orc-realizado.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl
                   AND   dc-orc-realizado.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
                   AND   dc-orc-realizado.cod_ccusto         = item_lancto_ctbl.cod_ccusto
                   AND   dc-orc-realizado.modulo             = "Devoluá∆o"
                   AND   dc-orc-realizado.data               = dt-refer NO-ERROR.
               IF AVAIL dc-orc-realizado THEN NEXT.
           END.

           IF  AVAIL lote_ctbl 
               AND lote_ctbl.des_lote_ctbl BEGINS "CPV por Centro de Custo" /* Movimentos de CPV */ THEN DO:
               
               /* Verifica se a conta j† possui valor realizado de Bonificaá∆o                 */
               FIND FIRST dc-orc-realizado NO-LOCK
                   WHERE dc-orc-realizado.cod_empresa        = item_lancto_ctbl.cod_empresa
                   AND   dc-orc-realizado.cod_estab          = item_lancto_ctbl.cod_estab
                   AND   dc-orc-realizado.cod_plano_ctbl     = item_lancto_ctbl.cod_plano_cta_ctbl 
                   AND   dc-orc-realizado.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl
                   AND   dc-orc-realizado.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
                   AND   dc-orc-realizado.cod_ccusto         = item_lancto_ctbl.cod_ccusto
                   AND   dc-orc-realizado.modulo             = "Bonificaá∆o"
                   AND   dc-orc-realizado.data               = dt-refer NO-ERROR.
               IF AVAIL dc-orc-realizado THEN NEXT.
           END.

           IF  AVAIL lote_ctbl 
               AND lote_ctbl.des_lote_ctbl BEGINS "Abatimento por Centro de Custo" /* Movimentos de abatimento */ THEN DO:
               
               /* Verifica se a conta j† possui valor realizado de Abatimento                 */
               FIND FIRST dc-orc-realizado NO-LOCK
                   WHERE dc-orc-realizado.cod_empresa        = item_lancto_ctbl.cod_empresa
                   AND   dc-orc-realizado.cod_estab          = item_lancto_ctbl.cod_estab
                   AND   dc-orc-realizado.cod_plano_ctbl     = item_lancto_ctbl.cod_plano_cta_ctbl 
                   AND   dc-orc-realizado.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl
                   AND   dc-orc-realizado.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
                   AND   dc-orc-realizado.cod_ccusto         = item_lancto_ctbl.cod_ccusto
                   AND   dc-orc-realizado.modulo             = "Abatimento"
                   AND   dc-orc-realizado.data               = dt-refer NO-ERROR.
               IF AVAIL dc-orc-realizado THEN NEXT.
           END.

           /*** em comentario maráo/2019 referente ao chamado 84058: est† apresentando diferenáa nas comtas expositores, com programa DBGC201 
           IF  (item_lancto_ctbl.des_histor_lancto_ctbl BEGINS "Movto ref faturamento de" /* Impostos */ OR item_lancto_ctbl.des_histor_lancto_ctbl BEGINS "Contabilizaá∆o Sa°das Fixo" /* Fixo */)
               AND (item_lancto_ctbl.cod_cta_ctbl = v_conta_expositor OR item_lancto_ctbl.cod_cta_ctbl = v_conta_metais_exp) THEN DO:

               /* Verifica se a conta j† possui valor de Impostos e Fixo para contas de Metais e Expositores */
               FIND FIRST dc-orc-realizado NO-LOCK
                   WHERE dc-orc-realizado.cod_empresa        = item_lancto_ctbl.cod_empresa
                   AND   dc-orc-realizado.cod_estab          = item_lancto_ctbl.cod_estab
                   AND   dc-orc-realizado.cod_plano_ctbl     = item_lancto_ctbl.cod_plano_cta_ctbl 
                   AND   dc-orc-realizado.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl
                   AND   dc-orc-realizado.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
                   AND   dc-orc-realizado.cod_ccusto         = item_lancto_ctbl.cod_ccusto
                   AND   dc-orc-realizado.modulo             = "CEP"
                   AND   dc-orc-realizado.data               = dt-refer NO-ERROR.
               IF AVAIL dc-orc-realizado THEN NEXT.
           END.
           ***/
           
           FIND dc-orc-realizado EXCLUSIVE-LOCK
                WHERE dc-orc-realizado.cod_empresa      = item_lancto_ctbl.cod_empresa
                AND   dc-orc-realizado.cod_estab        = item_lancto_ctbl.cod_estab
                AND   dc-orc-realizado.cod_plano_ctbl   = item_lancto_ctbl.cod_plano_cta_ctbl
                AND   dc-orc-realizado.cod_cta_ctbl     = item_lancto_ctbl.cod_cta_ctbl
                AND   dc-orc-realizado.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                AND   dc-orc-realizado.cod_ccusto       = item_lancto_ctbl.cod_ccusto
                AND   dc-orc-realizado.modulo           = "FGL"
                AND   dc-orc-realizado.data             = dt-refer NO-ERROR.
            IF NOT AVAIL dc-orc-realizado THEN DO:
                CREATE dc-orc-realizado.
                ASSIGN dc-orc-realizado.cod_empresa       = item_lancto_ctbl.cod_empresa
                       dc-orc-realizado.cod_estab         = item_lancto_ctbl.cod_estab
                       dc-orc-realizado.cod_plano_ctbl    = item_lancto_ctbl.cod_plano_cta_ctbl
                       dc-orc-realizado.cod_cta_ctbl      = item_lancto_ctbl.cod_cta_ctbl
                       dc-orc-realizado.cod_plano_ccusto  = item_lancto_ctbl.cod_plano_ccusto
                       dc-orc-realizado.cod_ccusto        = item_lancto_ctbl.cod_ccusto
                       dc-orc-realizado.modulo            = "FGL"
                       dc-orc-realizado.data              = dt-refer
                       dc-orc-realizado.descricao         = "Lotes Contabilidade (" + STRING(MONTH(dt-refer),"99") + "/" + STRING(YEAR(dt-refer)) + ")"
                       .
            END.

            COPY-LOB dc-orc-realizado.det-realizado TO lc-det-realizado.

            IF lc-det-realizado = "" OR lc-det-realizado = ? THEN
                ASSIGN lc-det-realizado = "Lote       ;Lancto    ;Seq  ;Valor            ;Descriá∆o".

            ASSIGN lc-det-realizado                   = lc-det-realizado + CHR(10) +
                                                        TRIM(STRING(item_lancto_ctbl.num_lote_ctbl,">>>,>>>,>>9")) + ";" +
                                                        TRIM(STRING(item_lancto_ctbl.num_lancto_ctbl,">>,>>>,>>9")) + ";" +
                                                        TRIM(STRING(item_lancto_ctbl.num_seq_lancto_ctbl,">>>>9")) + ";" +
                                                        STRING(IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" 
                                                               THEN  aprop_lancto_ctbl.val_lancto_ctbl
                                                               ELSE (aprop_lancto_ctbl.val_lancto_ctbl * -1),"->>>>>,>>>,>>9.99") + ";" +
                                                        REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl,CHR(10)," ")
                   dc-orc-realizado.dt-ult-atualiza   = TODAY
                   dc-orc-realizado.hra-ult-atualiza  = TIME
                   dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
                   dc-orc-realizado.valor-realizado   = dc-orc-realizado.valor-realizado + (IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" 
                                                                                          THEN  aprop_lancto_ctbl.val_lancto_ctbl
                                                                                          ELSE (aprop_lancto_ctbl.val_lancto_ctbl * -1)).
            COPY-LOB lc-det-realizado TO dc-orc-realizado.det-realizado.
        END.
        /* FIM-Contabilidade */
    END.
END.

PUT SKIP(1)
        " * * * Carga do Valor Realizado APB e FGL realizada com sucesso !" SKIP(3).

/* --- (FIM) CONTAS A PAGAR E LOTES DA CONTABILIDADE --------- */



/* --- CARGA ORCAMENTO --------- */

PUT UNFORMATTED "Oráamento.........: " STRING(TIME,"HH:MM:SS") SKIP.

PUT SKIP(1)
    "CARGA DO VALOR ORÄADO" SKIP
    "---------------------" SKIP(2).

RUN pi-seta-titulo IN h-acomp ("Busca Carga Oráamento").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

    FIND FIRST tt-ccusto NO-LOCK NO-ERROR. 
    IF AVAIL tt-ccusto THEN DO:
        unid_blk:
        FOR EACH relacto_unid_orctaria NO-LOCK WHERE
                 relacto_unid_orctaria.cod_unid_orctaria   >= "" AND
                 relacto_unid_orctaria.num_tip_inform_organ = 1 /* Empresa */ AND
                 relacto_unid_orctaria.cod_inform_organ     = tt-ccusto.cod_empresa:
            FIND unid_orctaria OF relacto_unid_orctaria NO-LOCK NO-ERROR.
            //  IF AVAIL unid_orctaria AND unid_orctaria.log_bloq_exec_orctaria = YES THEN DO: 
                ASSIGN v_cod_unid_orctaria = unid_orctaria.cod_unid_orctaria.
                LEAVE unid_blk.
            // END.
        END.
    END.


FOR EACH tt-ccusto,
    EACH emsuni.ccusto NO-LOCK
    WHERE emsuni.ccusto.cod_empresa      = tt-ccusto.cod_empresa
      AND emsuni.ccusto.cod_plano_ccusto = tt-ccusto.cod_plano_ccusto
      AND emsuni.ccusto.cod_ccusto       = tt-ccusto.cod_ccusto:

    RUN pi-acompanhar IN h-acomp ("Buscando dados oráados CC - " + emsuni.ccusto.cod_ccusto).

    ASSIGN dt-aux = DATE(MONTH(dt-periodo-ini),1,YEAR(dt-periodo-ini)).
    DO WHILE dt-aux <= dt-periodo-fim:

        ASSIGN dt-refer = ADD-INTERVAL(dt-aux,1,'month') - 1
               i-periodo = MONTH(dt-refer).

        FOR EACH dc-orc-realizado EXCLUSIVE-LOCK
            WHERE dc-orc-realizado.MODULO = ""
            AND   dc-orc-realizado.data   = dt-refer
            AND   dc-orc-realizado.cod_empresa      = emsuni.ccusto.cod_empresa
            AND   dc-orc-realizado.cod_plano_ccusto = emsuni.ccusto.cod_plano_ccusto
            AND   dc-orc-realizado.cod_ccusto       = emsuni.ccusto.cod_ccusto:
            ASSIGN dc-orc-realizado.dt-ult-atualiza   = ?
                   dc-orc-realizado.hra-ult-atualiza  = ?
                   dc-orc-realizado.usario-atualiza   = ""
                   dc-orc-realizado.det-previsto      = ""
                   dc-orc-realizado.det-realizado     = ""
                   dc-orc-realizado.valor-orcto       = 0
                   dc-orc-realizado.valor-previsto    = 0
                   dc-orc-realizado.valor-realizado   = 0.
        END.
        
        /* Busca oráamento para as contas daquele centro de custo */
        /* L¢gica originalmente estava no DOC023                  */
        FOR EACH sdo_orcto_ctbl_bgc NO-LOCK
           WHERE sdo_orcto_ctbl_bgc.cod_empresa         = emsuni.ccusto.cod_empresa     
             AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = emsuni.ccusto.cod_plano_ccusto
             AND sdo_orcto_ctbl_bgc.cod_ccusto          = emsuni.ccusto.cod_ccusto
             AND sdo_orcto_ctbl_bgc.cod_cenar_orctario  = "Orc-" + STRING(YEAR(dt-refer))
             AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = v_cod_unid_orctaria
             AND sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl  = 1
             AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl BEGINS "1"
             AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = "Fiscal"
             AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = STRING(YEAR(dt-refer))
             AND sdo_orcto_ctbl_bgc.num_period_ctbl     = i-periodo
             AND sdo_orcto_ctbl_bgc.cod_cta_ctbl        < "7"
             AND NOT sdo_orcto_ctbl_bgc.cod_cta_ctbl BEGINS "4319" .
    
            IF sdo_orcto_ctbl_bgc.val_orcado = 0 THEN NEXT.
            
            FIND dc-orc-realizado EXCLUSIVE-LOCK 
                WHERE dc-orc-realizado.cod_empresa      = sdo_orcto_ctbl_bgc.cod_empresa
                AND   dc-orc-realizado.cod_estab        = sdo_orcto_ctbl_bgc.cod_estab
                AND   dc-orc-realizado.cod_plano_ctbl   = sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
                AND   dc-orc-realizado.cod_cta_ctbl     = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                AND   dc-orc-realizado.cod_plano_ccusto = sdo_orcto_ctbl_bgc.cod_plano_ccusto
                AND   dc-orc-realizado.cod_ccusto       = sdo_orcto_ctbl_bgc.cod_ccusto 
                AND   dc-orc-realizado.modulo           = "" 
                AND   dc-orc-realizado.data             = dt-refer 
                NO-ERROR.
            IF NOT AVAIL dc-orc-realizado THEN DO:
                CREATE dc-orc-realizado.
                ASSIGN dc-orc-realizado.cod_empresa      = sdo_orcto_ctbl_bgc.cod_empresa
                       dc-orc-realizado.cod_estab        = sdo_orcto_ctbl_bgc.cod_estab
                       dc-orc-realizado.cod_plano_ctbl   = sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
                       dc-orc-realizado.cod_cta_ctbl     = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                       dc-orc-realizado.cod_plano_ccusto = sdo_orcto_ctbl_bgc.cod_plano_ccusto
                       dc-orc-realizado.cod_ccusto       = sdo_orcto_ctbl_bgc.cod_ccusto
                       dc-orc-realizado.modulo           = ""
                       dc-orc-realizado.data             = dt-refer
                       dc-orc-realizado.descricao        = "Oráamento".
            END.
            ASSIGN dc-orc-realizado.dt-ult-atualiza   = TODAY
                   dc-orc-realizado.hra-ult-atualiza  = TIME
                   dc-orc-realizado.usario-atualiza   = v_cod_dwb_user
                   dc-orc-realizado.valor-orcto       = dc-orc-realizado.valor-orcto + sdo_orcto_ctbl_bgc.val_orcado.

        END.
        ASSIGN dt-aux = ADD-INTERVAL(dt-aux,1,'month').
    END.
END.

PUT SKIP(1)
        " * * * Carga do Valor Oráado realizada com sucesso!" SKIP(3).

/* --- (FIM) CARGA ORCAMENTO --- */

/* --- LIMPEZA DOS REGISTROS QUE FORAM ZERADOS DURANTE O PROCESSAMENTO --------- */

RUN pi-seta-titulo IN h-acomp ("Limpeza da Base").
RUN pi-acompanhar IN h-acomp ("Aguarde...").

PUT UNFORMATTED "Limpeza de dados..: " STRING(TIME,"HH:MM:SS") SKIP.

FOR EACH tt-ccusto,
    EACH dc-orc-realizado EXCLUSIVE-LOCK
    WHERE dc-orc-realizado.MODULO          >= ""
    AND   dc-orc-realizado.data            >= dt-periodo-ini
    AND   dc-orc-realizado.data            <= dt-periodo-fim
    AND   dc-orc-realizado.cod_empresa      = tt-ccusto.cod_empresa
    AND   dc-orc-realizado.cod_plano_ccusto = tt-ccusto.cod_plano_ccusto
    AND   dc-orc-realizado.cod_ccusto       = tt-ccusto.cod_ccusto
    AND   dc-orc-realizado.dt-ult-atualiza  = ?
    AND   dc-orc-realizado.hra-ult-atualiza = ?
    AND   dc-orc-realizado.usario-atualiza  = "":
    DELETE dc-orc-realizado.
END.

PUT UNFORMATTED "Fim da Execuá∆o...: " STRING(TIME,"HH:MM:SS") SKIP.

/* --- (FIM) LIMPEZA DOS REGISTROS QUE FORAM ZERADOS DURANTE O PROCESSAMENTO --- */
    
RUN pi-finalizar IN h-acomp.

