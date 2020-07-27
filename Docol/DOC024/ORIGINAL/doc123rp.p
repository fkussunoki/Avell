/*****************************************************************************
**       PROGRAMA: doc123rp
**       DATA....: Abril de 2013
**       OBJETIVO: Carga Oráamento x Realizado - Odilon Cachoeira
**                 - Horas Extras
**       VERSAO..: 2.06.000 
******************************************************************************/
{include/i-prgvrs.i DOC123RP 1.00.00.000}

{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
define temp-table tt-param no-undo
    field ep-codigo-usuario  AS CHAR FORMAT "x(03)"
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)"
    field modelo-rtf         as char format "x(35)"
    field l-habilitaRtf      as LOG
    FIELD c-custo-ini        AS CHAR
    FIELD c-custo-fim        AS CHAR
    FIELD l-gera-periodo-aut AS LOG
    FIELD dt-periodo-ini     AS DATE
    FIELD dt-periodo-fim     AS DATE
    FIELD l-imp-param        AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita as raw.

DEF TEMP-TABLE tt-estab      NO-UNDO
    FIELD cod-estabel        LIKE estabelec.cod-estabel         
    FIELD cod-emp-ems2       LIKE estabelec.ep-codigo
    FIELD cod-emp-rh         LIKE estrut_ccusto.cod_empresa
    FIELD cod-emp-ems5       LIKE estrut_ccusto.cod_empresa
    FIELD cc-plano           LIKE plano_ccusto.cod_plano_ccusto
    INDEX codigo cod-estabel         
                 cod-emp-ems2
                 cod-emp-ems5.

DEF TEMP-TABLE tt-ferr-movto NO-UNDO
    FIELD nr-ord-produ   like movto-estoq.nr-ord-prod
    FIELD num-ord-des    like movto-estoq.num-ord-des 
    FIELD it-codigo      like movto-estoq.it-codigo  
    FIELD tipo-trans     like movto-estoq.tipo-trans 
    FIELD esp-docto      like movto-estoq.esp-docto  
    FIELD quantidade     like movto-estoq.quantidade 
    FIELD valor-mat-m    like movto-estoq.valor-mat-m
    FIELD valor-ggf-m    like movto-estoq.valor-ggf-m
    FIELD valor-mob-m    like movto-estoq.valor-mob-m
    FIELD conta-contabil LIKE movto-estoq.conta-contabil
    FIELD sc-codigo      LIKE movto-estoq.sc-codigo
    FIELD ct-codigo      LIKE movto-estoq.ct-codigo
    FIELD data           AS DATE
    FIELD cod-estabel    LIKE movto-estoq.cod-estabel
    FIELD narrativa      AS CHAR
    INDEX ch-chave IS PRIMARY nr-ord-produ.

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

def temp-table tt-detalhe-cpv
    FIELD ep-codigo       LIKE emsuni.empresa.cod_empresa    
    FIELD cod-estabel     LIKE estabelec.cod-estabel  
    FIELD ct-codigo       LIKE conta-contab.ct-codigo  
    FIELD cc-codigo       LIKE dc-repres.cod_ccusto    
    FIELD serie           LIKE nota-fiscal.serie   
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis  
    FIELD it-codigo       LIKE movto-estoq.it-codigo
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

DEF TEMP-TABLE tt-devolucao
    FIELD ep-codigo             LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel           LIKE estabelecimento.cod_estab
    FIELD dt-trans              AS DATE 
    FIELD cc-codigo             LIKE ccusto-debito
    FIELD nome-ab-reg           LIKE regiao.nome-ab-reg
    FIELD cod-emit              LIKE emitente.cod-emitente
    FIELD serie-docto           LIKE docum-est.serie-docto
    FIELD nro-docto             LIKE docum-est.nro-docto
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


DEF TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_empresa      LIKE estrut_ccusto.cod_empresa
    FIELD cod_plano_ccusto LIKE estrut_ccusto.cod_plano_ccusto
    FIELD cod_ccusto       LIKE estrut_ccusto.cod_ccusto_filho
    INDEX codigo IS PRIMARY UNIQUE cod_empresa     
                                   cod_plano_ccusto 
                                   cod_ccusto.
                                 
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
                                    cod_cta_ctbl
    .

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

def new global shared var v_cod_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.

DEF VAR cc-plano AS CHAR NO-UNDO.
def var c-empresa-ems5       as char                       no-undo.
def var c-empresa-rh         as char                       no-undo.

{doinc/dsg998.i} /* Sugest∆o cc-custo conforme empresa */
    
/************* Definiáao de Variaveis de Processamento do Relat¢rio *********************/
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

EMPTY TEMP-TABLE tt-estab.

FOR EACH estabelec NO-LOCK
    WHERE estabelec.ep-codigo = tt-param.ep-codigo-usuario:
    find first trad_org_ext no-lock where trad_org_ext.cod_matriz_trad_org_ext = "EMS2"
                                    and trad_org_ext.cod_tip_unid_organ = "998" /*empresa*/
                                    and trad_org_ext.cod_unid_organ_ext = estabelec.ep-codigo no-error.
    assign c-empresa-ems5 = trad_org_ext.cod_unid_organ. 
    
    find first trad_org_ext no-lock where trad_org_ext.cod_matriz_trad_org_ext = "HR"
                                    and trad_org_ext.cod_tip_unid_organ = "998" /*empresa*/
                                    and trad_org_ext.cod_unid_organ = c-empresa-ems5 no-error.    
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

    CREATE tt-estab. 
    ASSIGN tt-estab.cod-estabel   = estabelec.cod-estabel     
           tt-estab.cod-emp-ems2  = estabelec.ep-codigo
           tt-estab.cod-emp-ems5  = c-empresa-ems5 
           tt-estab.cod-emp-rh    = c-empresa-rh 
           tt-estab.cc-plano      = cc-plano.
END.

FORM 
    "SELEÄ«O"            AT    03  SKIP(1)
    tt-param.l-gera-periodo-aut   COLON 25  FORMAT "Sim/N∆o" LABEL "Per°odo Autom†tico"
    tt-param.c-custo-ini          COLON 25  LABEL 'C Custo'
    "|<  >|"             AT    40  
    tt-param.c-custo-fim          AT    48  NO-LABEL  
    tt-param.dt-periodo-ini       COLON 25  LABEL 'Periodo'  
    "|<  >|"             AT    40  
    tt-param.dt-periodo-fim       AT    48  NO-LABEL  SKIP(2)              

    "IMPRESS«O"         AT     03  SKIP(1)
    tt-param.arquivo           AT     40  NO-LABEL        FORMAT "X(70)" 
    v_cod_usuar_corren  COLON  25  LABEL "Usu†rio" FORMAT "X(20)" 
    WITH FRAME f-selecao NO-BOX STREAM-IO WIDTH 132 SIDE-LABELS.

/* Prepara o cabeáalho e seta saida para terminal, impressora ou arquivo */

DEF STREAM s-log.

{include/i-rpcab.i}
{include/i-rpout.i} 

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Buscando informaá‰es").
RUN pi-acompanhar IN h-acomp ("Aguarde...").
/* CARGA DE CENTRO DE CUSTO */

PUT UNFORMATTED "In°cio da execuá∆o: " STRING(TIME,"HH:MM:SS") SKIP.
PUT UNFORMATTED "Carregando CC.....: " STRING(TIME,"HH:MM:SS") SKIP.

FOR EACH tt-estab
    BREAK BY tt-estab.cod-emp-ems5:
    IF  FIRST-OF(tt-estab.cod-emp-ems5) THEN
        FOR EACH estrut_ccusto
            WHERE estrut_ccusto.cod_empresa      = tt-estab.cod-emp-ems5 /*"DOC"*/
            AND   estrut_ccusto.cod_plano_ccusto = tt-estab.cc-plano /*"CCDOCOL"*/
            AND   estrut_ccusto.cod_ccusto_filho >= tt-param.c-custo-ini
            AND   estrut_ccusto.cod_ccusto_filho <= tt-param.c-custo-fim:
        
            FIND tt-ccusto 
                WHERE tt-ccusto.cod_empresa      = estrut_ccusto.cod_empresa     
                AND   tt-ccusto.cod_plano_ccusto = estrut_ccusto.cod_plano_ccusto
                AND   tt-ccusto.cod_ccusto       = estrut_ccusto.cod_ccusto_filho NO-ERROR.
            IF NOT AVAIL tt-ccusto THEN DO:
                CREATE tt-ccusto.
                ASSIGN  tt-ccusto.cod_empresa      = estrut_ccusto.cod_empresa     
                        tt-ccusto.cod_plano_ccusto = estrut_ccusto.cod_plano_ccusto
                        tt-ccusto.cod_ccusto       = estrut_ccusto.cod_ccusto_filho.
            END.
        END.
END.
/* (FIM) CARGA DE CENTRO DE CUSTO */

PUT UNFORMATTED "Carregando Contas.: " STRING(TIME,"HH:MM:SS") SKIP.

/* --- CARGA DE CONTAS --------- */
FOR EACH tt-ccusto,
    EACH item_lista_ccusto OF tt-ccusto NO-LOCK
    WHERE item_lista_ccusto.cod_empresa = tt-ccusto.cod_empresa:
    FOR EACH mapa_distrib_ccusto OF item_lista_ccust NO-LOCK:
        FOR EACH criter_distrib_cta_ctbl OF mapa_distrib_ccusto NO-LOCK.
            FIND FIRST tt-cta-pesq NO-LOCK
                 WHERE tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab         
                   AND tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
                   AND tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl NO-ERROR.
            IF NOT AVAIL tt-cta-pesq THEN DO:
                CREATE tt-cta-pesq.
                ASSIGN tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab          
                       tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl 
                       tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl.
            END.
        END.
    END.
END.
FOR EACH tt-estab,
    EACH criter_distrib_cta_ctbl NO-LOCK
    WHERE criter_distrib_cta_ctbl.cod_empresa               = tt-estab.cod-emp-ems5 
      AND criter_distrib_cta_ctbl.cod_plano_cta_ctbl       >= ""
      AND criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos".
    FIND FIRST tt-cta-pesq NO-LOCK
         WHERE tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab         
           AND tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
           AND tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl NO-ERROR.
    IF NOT AVAIL tt-cta-pesq THEN DO:
       CREATE tt-cta-pesq.
       ASSIGN tt-cta-pesq.cod_estab          = criter_distrib_cta_ctbl.cod_estab          
              tt-cta-pesq.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl 
              tt-cta-pesq.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl.
    END.
END.

/* --- (FIM) CARGA DE CONTAS --- */

PUT UNFORMATTED "Fim Contas........: " STRING(TIME,"HH:MM:SS") SKIP.

IF tt-param.l-gera-periodo-aut THEN DO:

    IF DAY(TODAY) <= 10 THEN DO: 
        ASSIGN tt-param.dt-periodo-fim = DATE(MONTH(TODAY),1,YEAR(TODAY))
               tt-param.dt-periodo-fim = tt-param.dt-periodo-fim - 1
               tt-param.dt-periodo-ini = DATE(MONTH(tt-param.dt-periodo-fim),1,YEAR(tt-param.dt-periodo-fim)).

        RUN dop/doc123rd.p (INPUT tt-param.dt-periodo-ini,
                            INPUT tt-param.dt-periodo-fim,
                            INPUT-OUTPUT TABLE tt-estab,
                            INPUT-OUTPUT TABLE tt-ccusto,
                            INPUT-OUTPUT TABLE tt-cta-pesq,
                            INPUT-OUTPUT TABLE tt-func-hra-extra, 
                            INPUT-OUTPUT TABLE tt-resumo-hra-extra, 
                            INPUT-OUTPUT TABLE tt-movto-estoq, 
                            INPUT-OUTPUT TABLE tt-resumo-movto-estoq, 
                            INPUT-OUTPUT TABLE tt-ordem-manut, 
                            INPUT-OUTPUT TABLE tt-detalhe-ordem, 
                            INPUT-OUTPUT TABLE tt-ferr-movto, 
                            INPUT-OUTPUT TABLE tt-devolucao,
                            INPUT-OUTPUT TABLE tt-contabiliza,
                            INPUT-OUTPUT TABLE tt-movto,
                            INPUT-OUTPUT TABLE tt-resumo-movto,
                            INPUT-OUTPUT TABLE tt-detalhe-cpv,
                            INPUT-OUTPUT TABLE tt-resumo-cpv,
                            INPUT-OUTPUT TABLE tt-cont-cpv).
            
    END.

    ASSIGN tt-param.dt-periodo-ini = DATE(MONTH(TODAY),1,YEAR(TODAY))
           tt-param.dt-periodo-fim = ADD-INTERVAL(tt-param.dt-periodo-ini,1,"month") - 1.

END.

/*RUN pi-carga-orcto.*/  /* Esta procedure foi substitu°da pelo programa doc123rd.p para evitar erro de locktable overflow */

RUN dop/doc123rd.p (INPUT tt-param.dt-periodo-ini,
                    INPUT tt-param.dt-periodo-fim,
                    INPUT-OUTPUT TABLE tt-estab,
                    INPUT-OUTPUT TABLE tt-ccusto,
                    INPUT-OUTPUT TABLE tt-cta-pesq,
                    INPUT-OUTPUT TABLE tt-func-hra-extra, 
                    INPUT-OUTPUT TABLE tt-resumo-hra-extra, 
                    INPUT-OUTPUT TABLE tt-movto-estoq, 
                    INPUT-OUTPUT TABLE tt-resumo-movto-estoq, 
                    INPUT-OUTPUT TABLE tt-ordem-manut, 
                    INPUT-OUTPUT TABLE tt-detalhe-ordem, 
                    INPUT-OUTPUT TABLE tt-ferr-movto, 
                    INPUT-OUTPUT TABLE tt-devolucao,
                    INPUT-OUTPUT TABLE tt-contabiliza,
                    INPUT-OUTPUT TABLE tt-movto,
                    INPUT-OUTPUT TABLE tt-resumo-movto,
                    INPUT-OUTPUT TABLE tt-detalhe-cpv,
                    INPUT-OUTPUT TABLE tt-resumo-cpv,
                    INPUT-OUTPUT TABLE tt-cont-cpv).

RUN pi-finalizar IN h-acomp.
    
/*parametros do relat¢rio*/
IF tt-param.l-imp-param THEN DO:
    PAGE.
    DISP tt-param.l-gera-periodo-aut
         tt-param.c-custo-ini
         tt-param.c-custo-fim
         tt-param.dt-periodo-ini
         tt-param.dt-periodo-fim
         tt-param.arquivo
         v_cod_usuar_corren
        WITH FRAME f-selecao.
END.

{include/i-rpclo.i}

