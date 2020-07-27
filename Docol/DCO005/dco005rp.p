/*****************************************************************************
** Programa.........: dco005rp.p
** Descricao .......: Relat¢rio de Comiss∆o
** Versao...........: 01.001
** Nome Externo.....: dop/dco005rp.p
** Autor............: Ivan Marcelo Silveira e Diomar Muhlmann
** Criado...........: 23/10/2003
******************************************************************************/
&GLOBAL-DEFINE programa dco005

{include/i-prgvrs504.i {&programa} 5.05.00.001}
{utp/ut-glob504.i}
{include/i-rpvar504.i}
{doinc/acr711zf.i} /* Temp-tables Alteraá∆o */

{dop/dbt901.i1 mgcad,movdis}

{cdp/cdcfgmat.i}

/* Definiáao de Variaveis de Processamento do Relat¢rio */
DEF VAR i-cont                          AS INTEGER                              NO-UNDO.
DEF VAR i-param-posicao                 AS INTEGER                              NO-UNDO.
DEF VAR c-param-variavel                AS CHARACTER                            NO-UNDO.
DEF VAR c-param-campos                  AS CHARACTER                            NO-UNDO.
DEF VAR c-param-tipos                   AS CHARACTER                            NO-UNDO.
DEF VAR c-param-dados                   AS CHARACTER                            NO-UNDO.

DEF VAR c-cidade                        LIKE pessoa_jurid.nom_cidade            NO-UNDO FORMAT 'x(20)'.
DEF VAR c-uf                            LIKE pessoa_jurid.cod_unid_federac      NO-UNDO FORMAT 'x(2)'.
DEF VAR c-categoria                     AS CHAR                                 NO-UNDO.
DEF VAR de-val-sdo-tit-acr              AS DEC                                  NO-UNDO DECIMALS 2.

DEF VAR de-vinculada                    AS DEC                                  NO-UNDO.
DEF VAR de-base-comis                   AS DEC                                  NO-UNDO.

DEF VAR de-vincul-lqrn                  AS DEC                                  NO-UNDO.
DEF VAR de-base-comis-lqrn              AS DEC                                  NO-UNDO.

DEF VAR l-escritural-nao-confirmada     AS LOG NO-UNDO.
DEF VAR i-transacao                     LIKE dc-comis-trans.cod_transacao       NO-UNDO.
DEF VAR de-comis-carteira               AS DECIMAL                              NO-UNDO.
DEF VAR de-val-ccusto                   AS DECIMAL                              NO-UNDO.
DEF VAR c-cod_ccusto                    LIKE dc-repres.cod_ccusto               NO-UNDO.
DEF VAR de-lancamento                   AS DECIMAL                              NO-UNDO.
DEF VAR de-orig-lancamento              AS DECIMAL                              NO-UNDO.
DEF VAR l-erro                          AS LOG                                  NO-UNDO.
DEF VAR de-val-credi                    AS DECIMAL      FORMAT '->>>>,>>9.99'   NO-UNDO.
DEF VAR de-base-calc-comis              AS DECIMAL                              NO-UNDO DECIMALS 2.
DEF VAR de-cli-base                     AS DECIMAL                              NO-UNDO.
DEF VAR de-cli-comis                    AS DECIMAL                              NO-UNDO.
DEF VAR de-cli-estor                    AS DECIMAL                              NO-UNDO.
DEF VAR de-cli-vincu                    AS DECIMAL                              NO-UNDO.
DEF VAR de-rep-base                     AS DECIMAL                              NO-UNDO.
DEF VAR de-rep-comis                    AS DECIMAL                              NO-UNDO.
DEF VAR de-rep-estor                    AS DECIMAL                              NO-UNDO.
DEF VAR de-rep-vincu                    AS DECIMAL      FORMAT '->>>>,>>9.99'   NO-UNDO.
DEF VAR de-tot-total                    AS DECIMAL      FORMAT '->>>>,>>9.99'   NO-UNDO.
DEF VAR de-tot-total-prox               AS DECIMAL      FORMAT '->>>>,>>9.99'   NO-UNDO.
DEF VAR da-emis-nota                    AS DATE                                 NO-UNDO.
DEF VAR de-tot-liq                      AS DEC                                  NO-UNDO.
DEF VAR de-tot-dev                      AS DEC                                  NO-UNDO.
DEF VAR de-tot-des                      AS DEC                                  NO-UNDO.
DEF VAR de-tot-lucr-perdas              AS DEC                                  NO-UNDO.

DEF VAR c-espec-abat                    AS CHAR                                 NO-UNDO.
DEF VAR i-num-id-tit-acr                AS INT                                  NO-UNDO.
DEF VAR de-val-abat-desc-avmn           AS DEC                                  NO-UNDO.
DEF VAR de-val-liquido                  LIKE tit_acr.val_liq_tit_acr            NO-UNDO.
DEF VAR de-val-original                 LIKE tit_acr.val_origin_tit_acr         NO-UNDO.
DEF VAR de-val-estorno                  AS DEC                                  NO-UNDO DECIMALS 2.
DEF VAR de-val-liq-base                 AS DEC                                  NO-UNDO.
DEF VAR c-cod_tip_repres                AS CHAR                                 NO-UNDO.
DEF VAR de-perc-comis-exp               AS DEC                                  NO-UNDO.
DEF VAR c-cod-refer-ren                 AS CHAR                                 NO-UNDO.
DEF VAR de-val-tot-ren                  AS DEC                                  NO-UNDO.
DEF VAR de-tot-cheques-baixa            AS DEC                                  NO-UNDO.
DEF VAR i-cheques-da-baixa              AS INT                                  NO-UNDO.
DEF VAR de-val-movto-cheque             AS DEC                                  NO-UNDO.
DEF VAR de-orig-perc-comis-emis         AS DEC                                  NO-UNDO.

DEF VAR c-meses                 AS CHARACTER    EXTENT 12           NO-UNDO
    INITIAL ["janeiro","fevereiro","marco",   "abril",  "maio",    "junho",
             "julho",  "agosto",   "setembro","outubro","novembro","dezembro"].
DEF VAR c-periodo                       AS CHAR FORMAT 'x(6)'                   NO-UNDO.
DEF VAR c-periodo-atu                   AS CHAR FORMAT 'x(6)'                   NO-UNDO.
DEF VAR c-periodo-prox                  AS CHAR FORMAT 'x(6)'                   NO-UNDO.
DEF VAR dt-fechamento-ini               AS DATE                                 NO-UNDO.
DEF VAR dt-fechamento-fim               AS DATE                                 NO-UNDO.

DEF VAR l-rep-fecha-ant                 AS LOG                                  NO-UNDO.
DEF VAR l-cliente-home-center           AS LOG                                  NO-UNDO.

DEF TEMP-TABLE tt-repres-202 NO-UNDO
    FIELD cod_empresa      LIKE representante.cod_empresa
    FIELD cdn_repres       LIKE representante.cdn_repres
    FIELD de-tot-pg-emiss  AS DECIMAL
    FIELD de-tot-pg-baixa  AS DECIMAL
    FIELD de-tot-vinc-mes  AS DECIMAL
    FIELD de-tot-pg-estor  AS DECIMAL
    INDEX codigo IS PRIMARY UNIQUE cod_empresa cdn_repres.

DEF TEMP-TABLE tt-estabelecimento NO-UNDO
    FIELD cod_estab                     LIKE estabelecimento.cod_estab
    FIELD cod_empresa                   LIKE estabelecimento.cod_empresa.
                                        
DEF TEMP-TABLE tt-empresa NO-UNDO
    FIELD cod_empresa                   LIKE tt-estabelecimento.cod_empresa.

DEF TEMP-TABLE tt-movto NO-UNDO
    FIELD cdn_repres                    LIKE repres_tit_acr.cdn_repres
    FIELD num_id_tit_acr                LIKE movto_comis_repres.num_id_tit_acr
    FIELD num_seq_movto_comis           LIKE movto_comis_repres.num_seq_movto_comis
    FIELD nom_pessoa                    LIKE representante.nom_pessoa
    FIELD cdn_cliente                   LIKE tit_acr.cdn_cliente
    FIELD nom_cliente                   LIKE emsuni.cliente.nom_pessoa
    FIELD cod_empresa                   LIKE tit_acr.cod_empresa
    FIELD cod_estab                     LIKE tit_acr.cod_estab
    FIELD cod_espec_docto               LIKE tit_acr.cod_espec_docto
    FIELD cod_ser_docto                 LIKE tit_acr.cod_ser_docto
    FIELD cod_tit_acr                   LIKE tit_acr.cod_tit_acr                    FORMAT 'x(8)'
    FIELD cod_parcela                   LIKE tit_acr.cod_parcela
    FIELD cod_ccusto                    LIKE emsuni.ccusto.cod_ccusto
    FIELD dat_emis_docto                LIKE tit_acr.dat_emis_docto
    FIELD dat_vencto_tit_acr            LIKE tit_acr.dat_vencto_tit_acr
    FIELD dat_liquidac_tit_acr          LIKE tit_acr.dat_liquidac_tit_acr
    FIELD val_perc_comis_repres         LIKE repres_tit_acr.val_perc_comis_repres
    FIELD val_perc_comis_repres_emis    LIKE repres_tit_acr.val_perc_comis_repres_emis
    FIELD val_base_calc_comis           LIKE movto_comis_repres.val_base_calc_comis FORMAT '>,>>>,>>9.99' DECIMALS 2
    FIELD val_movto_comis               LIKE movto_comis_repres.val_movto_comis     FORMAT '>>>>,>>9.99'  DECIMALS 2
    FIELD val_movto_estorno             LIKE movto_comis_repres.val_movto_comis     FORMAT '>>>>,>>9.99'  DECIMALS 2
    FIELD val_movto_vincul              LIKE movto_comis_repres.val_movto_comis     FORMAT '>>>>,>>9.99'  DECIMALS 2
    FIELD val_movto_vincul_mes          LIKE movto_comis_repres.val_movto_comis     FORMAT '>>>>,>>9.99'  DECIMALS 2
/*     FIELD log_movto_implant             AS   LOGICAL */
    FIELD val_perc_comis                AS   DECIMAL    FORMAT '>9.99'
    FIELD vincul-no-mes                 AS   CHAR       FORMAT "x"
    FIELD periodo                       AS   CHAR       FORMAT "x(6)"
    FIELD log_relatorio                 AS   LOG   INIT NO
    INDEX cdn_cliente                   cdn_repres              cdn_cliente
                                        cod_estab               cod_espec_docto
                                        cod_ser_docto           cod_tit_acr
                                        cod_parcela
    INDEX nom_cliente                   cdn_repres              nom_cliente
                                        cod_estab               cod_espec_docto
                                        cod_ser_docto           cod_tit_acr
                                        cod_parcela
    INDEX cod_ccusto                    cod_ccusto
    INDEX cod_empresa                   cod_empresa             cod_estab
                                        cdn_repres.

DEF TEMP-TABLE tt-repres NO-UNDO
    FIELD cod_empresa                   LIKE representante.cod_empresa
    FIELD cdn_repres                    LIKE representante.cdn_repres
    FIELD cod_ccusto                    LIKE dc-repres.cod_ccusto
    FIELD log_ativo                     AS LOG
    FIELD cod_tip_repres                LIKE dc-repres.cod_tip_repres
    FIELD nom_abrev                     LIKE representante.nom_abrev
    FIELD nom_pessoa                    LIKE representante.nom_pessoa
    FIELD de-tot-pg-emiss               AS DECIMAL      FORMAT '>>>>,>>9.99'  DECIMALS 2 EXTENT 2
    FIELD de-tot-pg-baixa               AS DECIMAL      FORMAT '>>>>,>>9.99'  DECIMALS 2 EXTENT 2
    FIELD de-tot-pg-lp-lm               AS DECIMAL      FORMAT '>>>>,>>9.99'  DECIMALS 2 EXTENT 2
    FIELD de-tot-pg-estor               AS DECIMAL      FORMAT '>>>>,>>9.99'  DECIMALS 2 EXTENT 2
    FIELD de-tot-vinc-mes               AS DECIMAL      FORMAT '>>>>,>>9.99'  DECIMALS 2 EXTENT 2
    FIELD de-tot-vincul                 AS DECIMAL      FORMAT '->>>>,>>9.99' DECIMALS 2 EXTENT 2.

DEF TEMP-TABLE tt-ped-venda NO-UNDO
    FIELD nome-abrev                    AS CHAR
    FIELD nr-pedcli                     AS CHAR
    FIELD vl-base                       AS DEC
    FIELD vl-comissao                   AS DEC
    FIELD perc-comis                    AS DEC
    FIELD comis-emis                    AS DEC.

DEF TEMP-TABLE tt-abat-desc-avmn NO-UNDO
    FIELD cod_empresa    LIKE repres_tit_acr.cod_empresa
    FIELD cod_estab      LIKE tit_acr.cod_estab     
    FIELD num_id_tit_acr LIKE tit_acr.num_id_tit_acr
    FIELD cdn_repres     LIKE repres_tit_acr.cdn_repres
    FIELD dat_transacao  LIKE tit_acr.dat_transacao
    FIELD val-estorno    AS DEC.

DEF BUFFER b-movto-comis         FOR movto_comis_repres.

DEF BUFFER b-movto-antecip       FOR movto_tit_acr.

DEF BUFFER b-movto-cheque        FOR movto_tit_acr.
DEF BUFFER b-tit-cheque          FOR tit_acr.

DEF BUFFER b-movto_tit_acr       FOR movto_tit_acr.
DEF BUFFER b-tit_acr             FOR tit_acr.

DEF BUFFER b-movto-ve            FOR movto_tit_acr.
DEF BUFFER b-tit-ve              FOR tit_acr.

DEF BUFFER b-movto-ren           FOR movto_tit_acr.
DEF BUFFER b-movto-lqrn          FOR movto_tit_acr.
DEF BUFFER b-tit-lqrn            FOR tit_acr.

DEF BUFFER b-tt-movto            FOR tt-movto.
                                 
DEF BUFFER b-dc-comis-trans      FOR dc-comis-trans.
DEF BUFFER b-dc-comis-movto      FOR dc-comis-movto.
DEF BUFFER b-dc-orig-comis-movto FOR dc-orig-comis-movto.

DEF BUFFER bb-dc-comis-trans      FOR dc-comis-trans.
DEF BUFFER bb-dc-comis-movto      FOR dc-comis-movto.
DEF BUFFER bb-dc-orig-comis-movto FOR dc-orig-comis-movto.


DEF BUFFER b-relacto_cheq_acr    FOR relacto_cheq_acr.

/* Vari†veis a serem recuperados pela DWB - set list param */
/* ======================================================= */
    /* provenientes da p†gina de impress∆o */
    DEF VAR c-arquivo           AS CHAR     NO-UNDO.
    DEF VAR i-qtd-linhas        AS INTEGER  NO-UNDO.
    DEF VAR c-destino           AS CHAR     NO-UNDO.
    DEF VAR l-imp-param         AS LOGICAL  NO-UNDO.
    /* provenientes da p†gina de seleá∆o */
    DEF VAR c-lista-cdn-repres  AS CHAR     NO-UNDO.
    DEF VAR c-lista-cod-esp     AS CHAR     NO-UNDO.
    DEF VAR c-lista-cod-estab   AS CHAR     NO-UNDO.
    DEF VAR i-ini-cliente       AS INTEGER  NO-UNDO.
    DEF VAR i-fim-cliente       AS INTEGER  NO-UNDO.
    DEF VAR i-ini-perc-comis    AS INTEGER  NO-UNDO.
    DEF VAR i-fim-perc-comis    AS INTEGER  NO-UNDO.
    DEF VAR dt-ini-periodo      AS DATE     NO-UNDO.
    DEF VAR dt-fim-periodo      AS DATE     NO-UNDO.
    DEF VAR c-ini-referencia    AS CHAR     NO-UNDO.
    DEF VAR c-fim-referencia    AS CHAR     NO-UNDO.
    /* provenientes da p†gina de classificaá∆o */
    DEF VAR rs-classif          AS INTEGER  NO-UNDO.
    DEF VAR c-des-rs-classif    AS CHAR     NO-UNDO.
    /* provenientes da p†gina de parÉmetros */
    DEF VAR tg-gera-movto-comis AS LOGICAL  NO-UNDO.
    DEF VAR tg-imp-comissoes    AS LOGICAL  NO-UNDO.
    DEF VAR tg-imp-resumo       AS LOGICAL  NO-UNDO.
    DEF VAR rs-data             AS CHAR     NO-UNDO.
    DEF VAR tg-rescisao         AS LOG      NO-UNDO.
    DEF VAR tg-paga-vinculada   AS LOG      NO-UNDO.
    DEF VAR tg-paga-carteira    AS LOG      NO-UNDO.
    /* provenientes da p†gina de digitaá∆o */
    DEFINE TEMP-TABLE tt-digita NO-UNDO
        FIELD ordem             AS INTEGER   FORMAT ">>>>9"
        FIELD exemplo           AS CHARACTER FORMAT "x(30)"
        INDEX id ordem.
    
    IF  v_cod_dwb_user = "" then
        ASSIGN  v_cod_dwb_user = v_cod_usuar_corren.
    IF  v_cod_dwb_user BEGINS 'es_' THEN
        ASSIGN  v_cod_dwb_user = ENTRY(2, v_cod_dwb_user, "_").
    
    /* modo de execuá∆o   ( RPW ou On-line ) */
    IF  v_num_ped_exec_corren > 0 THEN DO: /* RPW */
        FIND FIRST ped_exec_param NO-LOCK
             WHERE ped_exec_param.num_ped_exec = v_num_ped_exec_corren NO-ERROR.
        IF  AVAIL ped_exec_param THEN DO: 
            ASSIGN  c-param-dados   = ped_exec_param.cod_dwb_parameters
                    /*pagina de impress∆o*/
                    l-imp-param     = ped_exec_param.log_dwb_print_parameters
                    c-destino       = ped_exec_param.cod_dwb_output
                    c-impressora    = ped_exec_param.nom_dwb_printer
                    c-layout        = ped_exec_param.cod_dwb_print_layout
                    c-arquivo       = ped_exec_param.cod_dwb_file
                    i-qtd-linhas    = ped_exec_param.qtd_dwb_line.
            
            FIND FIRST ped_exec_param_aux OF ped_exec_param NO-LOCK NO-ERROR.
            IF  AVAIL ped_exec_param_aux THEN 
                DO  i-cont = 1 TO NUM-ENTRIES(ped_exec_param_aux.cod_dwb_parameters, chr(10)):
                    CREATE  tt-digita.
                    ASSIGN  tt-digita.ordem   = INT(ENTRY(i-cont, ped_exec_param_aux.cod_dwb_parameters, chr(10)))
                            i-cont            = i-cont + 1
                            tt-digita.exemplo = ENTRY(i-cont, ped_exec_param_aux.cod_dwb_parameters, chr(10)).
                END.
        END.
    END.
    ELSE DO: /* On-line */
        FIND FIRST dwb_set_list_param NO-LOCK
             WHERE dwb_set_list_param.cod_dwb_program = "{&programa}"
               AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
        IF  AVAIL dwb_set_list_param THEN DO:
            ASSIGN  c-param-dados   = dwb_set_list_param.cod_dwb_parameters
                    /*pagina de impress∆o*/
                    l-imp-param     = dwb_set_list_param.log_dwb_print_parameters
                    c-destino       = dwb_set_list_param.cod_dwb_output
                    c-impressora    = dwb_set_list_param.nom_dwb_printer
                    c-layout        = dwb_set_list_param.cod_dwb_print_layout
                    c-arquivo       = dwb_set_list_param.cod_dwb_file
                    i-qtd-linhas    = dwb_set_list_param.qtd_dwb_line.
            
            FIND FIRST dwb_set_list_param_aux NO-LOCK
                 WHERE dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
                   AND dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user NO-ERROR.
            IF  AVAIL dwb_set_list_param_aux THEN 
                DO  i-cont = 1 TO NUM-ENTRIES(dwb_set_list_param_aux.cod_dwb_parameters, chr(10)):
                    CREATE  tt-digita.
                    ASSIGN  tt-digita.ordem   = INT(ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, chr(10)))
                            i-cont            = i-cont + 1
                            tt-digita.exemplo = ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, chr(10)).
                END.
        END.
    END.    

    ASSIGN  c-param-campos  = ENTRY(1, c-param-dados, CHR(13))
            c-param-tipos   = ENTRY(2, c-param-dados, CHR(13))
            c-param-dados   = ENTRY(3, c-param-dados, CHR(13)).

    {include/i-openpar504.i CHARACTER c-lista-cdn-repres 
                                      c-lista-cod-esp    
                                      c-lista-cod-estab 
                                      c-des-rs-classif 
                                      c-ini-referencia 
                                      c-fim-referencia 
                                      rs-data}
    {include/i-openpar504.i DECIMAL   }
    {include/i-openpar504.i DATE      dt-ini-periodo     
                                      dt-fim-periodo     }
    {include/i-openpar504.i INTEGER   i-ini-cliente      
                                      i-fim-cliente      
                                      i-ini-perc-comis   
                                      i-fim-perc-comis 
                                      rs-classif}
    {include/i-openpar504.i LOGICAL   tg-gera-movto-comis 
                                      tg-imp-comissoes   
                                      tg-imp-resumo 
                                      tg-rescisao 
                                      tg-paga-vinculada 
                                      tg-paga-carteira}

/* ============================================================ */
/* Fim da busca dos parÉmetros gravados no DWB - set list param */

ASSIGN  c-programa     = "{&programa}"
        c-versao       = "1.00"
        c-revisao      = "001"
        c-titulo-relat = "Relat¢rio de Comiss∆o"
        c-sistema      = "CO".
FIND FIRST emsuni.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF  AVAIL empresa THEN 
    ASSIGN  c-empresa = empresa.nom_razao_social.

FORM 
    "SELEÄ«O"           AT      03                          SKIP(1)
    c-lista-cod-estab   COLON   25  FORMAT "X(90)"          LABEL "Lista Estabelec"
    c-lista-cod-esp     COLON   25  VIEW-AS EDITOR SIZE 90 BY 2 LABEL "Lista Especie"
    c-lista-cdn-repres  COLON   25  VIEW-AS EDITOR SIZE 90 BY 2 LABEL "Lista Represent"
    i-ini-cliente       COLON   25                          LABEL "Cliente"
    "|<  >|"            AT      40
    i-fim-cliente       AT      48                          NO-LABEL
    i-ini-perc-comis    COLON   25                          LABEL "%Comis Emissao"
    "|<  >|"            AT      40
    i-fim-perc-comis    AT      48                          NO-LABEL
    dt-ini-periodo      COLON   25  FORMAT '99/99/9999'     LABEL "Comissao Periodo"
    "|<  >|"            AT      40
    dt-fim-periodo      AT      48  FORMAT '99/99/9999'     NO-LABEL
    c-ini-referencia    COLON   25                          LABEL "Referencia"
    "|<  >|"            AT      40
    c-fim-referencia    AT      48                          NO-LABEL
    SKIP(2)
    "CLASSIFICAÄ«O"     AT      03                          SKIP(1)
    c-des-rs-classif    COLON   25  FORMAT "X(40)"          NO-LABEL
    SKIP(2)
    "PAR∂METROS"        AT      03                          SKIP(1)
    tg-imp-comissoes    COLON   25  FORMAT 'Sim/N∆o'        LABEL "Imp. Comiss‰es"
    tg-imp-resumo       COLON   25  FORMAT 'Sim/N∆o'        LABEL "Imp. Resumido"
    tg-rescisao         COLON   25  FORMAT 'Sim/N∆o'        LABEL "Rescis∆o"
    tg-paga-vinculada   COLON   25  FORMAT 'Sim/N∆o'        LABEL "Paga Comiss∆o Vinculada"
    tg-paga-carteira    COLON   25  FORMAT 'Sim/N∆o'        LABEL "Paga Comiss∆o Ped Cart"
    rs-data             COLON   25  FORMAT 'x(10)'          LABEL "Data Pesquisa"
    SKIP(2)
    "IMPRESS«O"         AT      03                          SKIP(1)
    c-destino           COLON   25  FORMAT "X(12)"          LABEL "Destino"
    c-arquivo           AT      40  FORMAT "X(70)"          NO-LABEL
    v_cod_usuar_corren  COLON   25  FORMAT "X(20)"          LABEL "Usu†rio"
    WITH FRAME f-selecao NO-BOX STREAM-IO WIDTH 132 SIDE-LABELS.

FORM 
    tt-movto.cod_estab          COLUMN-LABEL 'Est'
    tt-movto.cod_espec_docto    COLUMN-LABEL 'Esp'
    tt-movto.cod_ser_docto      COLUMN-LABEL 'SÇr'
    tt-movto.cod_tit_acr        
    tt-movto.cod_parcela        COLUMN-LABEL 'Pa'
    tt-movto.dat_emis_docto
    tt-movto.dat_vencto_tit_acr
    tt-movto.dat_liquidac_tit_acr   
    tt-movto.val_base_calc_comis    COLUMN-LABEL 'Base C†lculo'   
    tt-movto.val_perc_comis         COLUMN-LABEL 'Perc'
    tt-movto.val_movto_comis        COLUMN-LABEL 'Comiss∆o'
    tt-movto.val_movto_estorno      COLUMN-LABEL 'Estorno'
    de-val-credi                    COLUMN-LABEL 'Creditado' 
    tt-movto.val_movto_vincul       COLUMN-LABEL 'Vinculado'
    tt-movto.vincul-no-mes                NO-LABEL
    tt-movto.periodo                COLUMN-LABEL 'Per°od'
    WITH FRAME f-movto NO-BOX STREAM-IO WIDTH 320 DOWN.

FORM 
    'Representante:  '
    tt-movto.cdn_repres     NO-LABEL '-'
    tt-movto.nom_pessoa     NO-LABEL SKIP
    '      Periodo: ' dt-ini-periodo FORMAT '99/99/9999' NO-LABEL ' ate ' dt-fim-periodo FORMAT '99/99/9999' NO-LABEL
    SKIP(1)
    WITH FRAME f-repres WIDTH 132 SIDE-LABELS STREAM-IO NO-BOX.

FORM 
    'Cliente:  ' 
    tt-movto.cdn_cliente    NO-LABEL  '-'
    tt-movto.nom_cliente    NO-LABEL  '-'
    c-cidade                NO-LABEL  '-'
    c-uf                    NO-LABEL
    WITH FRAME f-cliente WIDTH 132 SIDE-LABELS NO-BOX.

/* Prepara o cabeáalho e seta saida para terminal, impressora ou arquivo */
{include/i-rpcab504.i}
{include/rp-output504.i} 

FUNCTION fi-sugestao-referencia RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
    DEF VAR v_des_dat                       AS CHARACTER        NO-UNDO. /*local*/
    DEF VAR v_num_aux                       AS INTEGER          NO-UNDO. /*local*/
    DEF VAR v_num_aux_2                     AS INTEGER          NO-UNDO. /*local*/
    DEF VAR v_num_cont                      AS INTEGER          NO-UNDO. /*local*/
    DEF VAR p_cod_refer                     AS CHARACTER        NO-UNDO.

    ASSIGN  v_des_dat   = STRING(TODAY,"99999999")
            p_cod_refer = SUBSTRING(v_des_dat,7,2) + 
                          SUBSTR(STRING(TIME),2,4) + 'R'
            v_num_aux_2 = INTEGER(THIS-PROCEDURE:handle).

    DO  v_num_cont = 1 to 3:
        ASSIGN  v_num_aux   = (RANDOM(0,v_num_aux_2) mod 26) + 97
                p_cod_refer = p_cod_refer + chr(v_num_aux).
    END.
    RETURN p_cod_refer.
END FUNCTION.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEFINE VAR h-acomp AS HANDLE NO-UNDO.

IF  v_num_ped_exec_corren = 0 THEN DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio").
END.

FOR EACH estabelecimento NO-LOCK
   WHERE LOOKUP(estabelecimento.cod_estab,c-lista-cod-estab) > 0
   BREAK BY estabelecimento.cod_empresa:
    CREATE  tt-estabelecimento.
    ASSIGN  tt-estabelecimento.cod_estab    = estabelecimento.cod_estab
            tt-estabelecimento.cod_empresa  = estabelecimento.cod_empresa.
    IF  FIRST-OF(estabelecimento.cod_empresa) THEN DO:
        CREATE  tt-empresa.
        ASSIGN  tt-empresa.cod_empresa = tt-estabelecimento.cod_empresa.
    END.
END.

IF tg-gera-movto-comis THEN DO:

   /* Estorno comiss∆o paga na emiss∆o quando o t°tulo sofrer Desconto, */
   /* Abatimento ou Acerto de Valor a Menor (AVMN)                      */
   
   IF  v_num_ped_exec_corren = 0 THEN DO:
       RUN pi-acompanhar IN h-acomp ("Verificando Abatim, Desconto e AVMN...").
   END.

   ASSIGN c-espec-abat = "".
   FOR EACH espec_docto_financ_acr NO-LOCK
      WHERE LOOKUP(espec_docto_financ_acr.cod_espec_docto,c-lista-cod-esp) <> 0,
      FIRST emsuni.espec_docto OF espec_docto_financ_acr NO-LOCK
      WHERE emsuni.espec_docto.ind_tip_espec_docto = "Normal".
      ASSIGN c-espec-abat = c-espec-abat + emsuni.espec_docto.cod_espec_docto + ",".
   END.

   FOR EACH tt-abat-desc-avmn.
       DELETE tt-abat-desc-avmn.
   END.

   estorno-abat-desc-avmn:
   FOR EACH tt-estabelecimento NO-LOCK,
       EACH movto_tit_acr NO-LOCK
      WHERE movto_tit_acr.cod_estab                               = tt-estabelecimento.cod_estab
        AND movto_tit_acr.dat_transacao                          >= dt-ini-periodo
        AND movto_tit_acr.dat_transacao                          <= dt-fim-periodo
        AND LOOKUP(movto_tit_acr.cod_espec_docto,c-espec-abat)   <> 0
        AND LOOKUP(movto_tit_acr.ind_trans_acr_abrev,"LIQ,AVMN") <> 0
        AND NOT movto_tit_acr.LOG_movto_estordo WITH FRAME f-f.
   
      IF movto_tit_acr.ind_trans_acr_abrev = "LIQ"   AND (movto_tit_acr.val_abat_tit_acr <> 0 OR movto_tit_acr.val_desconto <> 0) OR
         movto_tit_acr.ind_trans_acr_abrev = "AVMN" THEN DO:

         ASSIGN i-num-id-tit-acr      = 0
                de-val-abat-desc-avmn = 0.
      
         FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
         IF NOT AVAIL tit_acr                      OR
            tit_acr.cdn_cliente    < i-ini-cliente OR
            tit_acr.cdn_cliente    > i-fim-cliente THEN 
            NEXT estorno-abat-desc-avmn.

         IF movto_tit_acr.cod_espec_doc = 'VD' THEN DO:
            FIND FIRST dc-tit_acr OF tit_acr NO-LOCK NO-ERROR.
            FIND FIRST b-movto-ve NO-LOCK /* VE */
                 WHERE b-movto-ve.cod_estab           = movto_tit_acr.cod_estab
                   AND b-movto-ve.cod_refer           = dc-tit_acr.vend-cod-refer
                   AND b-movto-ve.ind_trans_acr_abrev = 'LQRN' 
                   AND NOT b-movto-ve.log_movto_estordo NO-ERROR.
            IF AVAIL b-movto-ve THEN DO:
               FIND FIRST b-tit-ve OF b-movto-ve NO-LOCK NO-ERROR.
               ASSIGN i-num-id-tit-acr = b-movto-ve.num_id_tit_acr
                      de-val-liquido   = b-tit-ve.val_liq_tit_acr
                      de-val-original  = b-tit-ve.val_origin_tit_acr.
            END.
         END. /* VD */
         ELSE DO:

            ASSIGN i-num-id-tit-acr = movto_tit_acr.num_id_tit_acr
                   de-val-liquido   = tit_acr.val_liq_tit_acr
                   de-val-original  = tit_acr.val_origin_tit_acr.
         END.

         IF movto_tit_acr.ind_trans_acr_abrev = "LIQ" THEN 
            ASSIGN de-val-abat-desc-avmn = movto_tit_acr.val_abat_tit_acr + movto_tit_acr.val_desconto.
         ELSE
            ASSIGN de-val-abat-desc-avmn = movto_tit_acr.val_movto_tit_acr.

         ASSIGN de-val-abat-desc-avmn = de-val-abat-desc-avmn.

         repres-estorno-ada:
         FOR EACH repres_tit_acr NO-LOCK
            WHERE repres_tit_acr.cod_estab                                     = movto_tit_acr.cod_estab
              AND repres_tit_acr.num_id_tit_acr                                = i-num-id-tit-acr
              AND LOOKUP(STRING(repres_tit_acr.cdn_repres),c-lista-cdn-repres) > 0
              AND repres_tit_acr.val_perc_comis_repres                        <> 0
              AND repres_tit_acr.val_perc_comis_repres_emis                   <> 0:

            /* SSI 071/06 */ 
            FIND FIRST dc-repres NO-LOCK
                 WHERE dc-repres.cod_empresa = repres_tit_acr.cod_empresa
                   AND dc-repres.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.
            IF AVAIL dc-repres                   AND 
               dc-repres.cod_tip_repres = "EXP" THEN  /* Se representante de exportaá∆o    */
               NEXT repres-estorno-ada.               /* e t°tulo <> EX n∆o haver† estorno */
            /* FIM-SSI 071/06 */ 

            ASSIGN  de-val-liq-base  = (de-val-abat-desc-avmn * de-val-liquido)  / de-val-original
                    de-val-estorno   = de-val-liq-base                                  * 
                                      (repres_tit_acr.val_perc_comis_repres      / 100) * 
                                      (repres_tit_acr.val_perc_comis_repres_emis / 100).

            IF de-val-estorno <> 0 THEN DO:
               FIND FIRST tt-abat-desc-avmn NO-LOCK
                    WHERE tt-abat-desc-avmn.cod_empresa    = repres_tit_acr.cod_empresa
                      AND tt-abat-desc-avmn.cod_estab      = tit_acr.cod_estab
                      AND tt-abat-desc-avmn.num_id_tit_acr = tit_acr.num_id_tit_acr
                      AND tt-abat-desc-avmn.cdn_repres     = repres_tit_acr.cdn_repres
                      AND tt-abat-desc-avmn.dat_transacao  = movto_tit_acr.dat_transacao NO-ERROR.
               IF NOT AVAIL tt-abat-desc-avmn THEN DO:
                  CREATE tt-abat-desc-avmn.
                  ASSIGN tt-abat-desc-avmn.cod_empresa    = repres_tit_acr.cod_empresa
                         tt-abat-desc-avmn.cod_estab      = tit_acr.cod_estab     
                         tt-abat-desc-avmn.num_id_tit_acr = tit_acr.num_id_tit_acr
                         tt-abat-desc-avmn.cdn_repres     = repres_tit_acr.cdn_repres
                         tt-abat-desc-avmn.dat_transacao  = movto_tit_acr.dat_transacao.
               END.
               ASSIGN tt-abat-desc-avmn.val-estorno = tt-abat-desc-avmn.val-estorno + de-val-estorno.
            END. /* if de-val-estorno */
         END. /* for each repres_tit_acr */
      END. /* Liq com Abatimento, Desconto ou AVMN */
   END. /* for each tt-estabelecimento */

   FOR EACH tt-abat-desc-avmn NO-LOCK.
      RUN dop/dco005a.p (tt-abat-desc-avmn.cod_empresa   ,
                         tt-abat-desc-avmn.cdn_repres    ,
                         tt-abat-desc-avmn.cod_estab            ,
                         tt-abat-desc-avmn.num_id_tit_acr       ,
                         OUTPUT c-cod_ccusto          ).
      FIND LAST dc-comis-trans NO-LOCK
          WHERE dc-comis-trans.cod_transacao = 37 NO-ERROR. /* Estorno Comiss∆o Abatimento */
      IF AVAIL dc-comis-trans THEN DO:
         FIND FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab      = tt-abat-desc-avmn.cod_estab
                AND tit_acr.num_id_tit_acr = tt-abat-desc-avmn.num_id_tit_acr NO-ERROR.
         FIND FIRST dc-comis-movto NO-LOCK
              WHERE dc-comis-movto.cod_empresa              = tt-abat-desc-avmn.cod_empresa
                AND dc-comis-movto.cdn_repres               = tt-abat-desc-avmn.cdn_repres
                AND dc-comis-movto.cod_transacao            = dc-comis-trans.cod_transacao
                AND dc-comis-movto.dat_transacao            = tt-abat-desc-avmn.dat_transacao
                AND dc-comis-movto.des_transacao            MATCHES STRING('*' + tit_acr.cod_estab       + '-' + 
                                                                                 tit_acr.cod_espec_docto + '-' + 
                                                                                 tit_acr.cod_ser_docto   + '-' + 
                                                                                 tit_acr.cod_tit_acr     + '-' + 
                                                                                 tit_acr.cod_parcela     + '*') NO-ERROR.
         IF NOT AVAIL dc-comis-movto THEN DO:
            CREATE dc-comis-movto.
            ASSIGN dc-comis-movto.cod_empresa              = tt-abat-desc-avmn.cod_empresa
                   dc-comis-movto.cdn_repres               = tt-abat-desc-avmn.cdn_repres
                   dc-comis-movto.cod_transacao            = dc-comis-trans.cod_transacao
                   dc-comis-movto.dat_transacao            = tt-abat-desc-avmn.dat_transacao
                   dc-comis-movto.des_transacao            = dc-comis-trans.descricao +  ' ' + tit_acr.cod_estab       + '-' + 
                                                                                               tit_acr.cod_espec_docto + '-' + 
                                                                                               tit_acr.cod_ser_docto   + '-' + 
                                                                                               tit_acr.cod_tit_acr     + '-' + 
                                                                                               tit_acr.cod_parcela
                   dc-comis-movto.cod_plano_cta_ctbl       = dc-comis-trans.cod_plano_cta_ctbl
                   dc-comis-movto.cod_cta_ctbl             = dc-comis-trans.cod_cta_ctbl
                   dc-comis-movto.cod_plano_ccusto         = dc-comis-trans.cod_plano_ccusto
                   dc-comis-movto.cod_ccusto               = c-cod_ccusto
                   dc-comis-movto.ind_origin_movto         = "dco005"
                   dc-comis-movto.val_movto                = tt-abat-desc-avmn.val-estorno.
            CREATE dc-orig-comis-movto.
            ASSIGN dc-orig-comis-movto.num_id_comis_movto  = dc-comis-movto.num_id_comis_movto
                   dc-orig-comis-movto.cod_empresa         = dc-comis-movto.cod_empresa
                   dc-orig-comis-movto.cdn_repres          = dc-comis-movto.cdn_repres
                   dc-orig-comis-movto.num_seq_movto_comis = 10
                   dc-orig-comis-movto.cod_estab           = tit_acr.cod_estab
                   dc-orig-comis-movto.num_id_tit_acr      = tit_acr.num_id_tit_acr
                   dc-orig-comis-movto.dat_transacao       = dc-comis-movto.dat_transacao
                   dc-orig-comis-movto.val_movto_comis     = dc-comis-movto.val_movto.
         END. /* if not avail dc-comis-movto */
      END. /* if dc-comis-trans */
   END.  /* FOR EACH tt-abat-desc-avmn */
   
   /* FIM                                                               */
   /* Estorno comiss∆o paga na emiss∆o quando o t°tulo sofrer Desconto, */
   /* Abatimento ou Acerto de Valor a Menor (AVMN)                      */
END. /* IF tg-gera-movto-comis */

DEF TEMP-TABLE tt-repres-tit-acr NO-UNDO
       FIELD cod_empresa LIKE repres_tit_acr.cod_empresa 
       FIELD cod_estab   LIKE repres_tit_acr.cod_estab   
       FIELD cdn_repres  LIKE repres_tit_acr.cdn_repres  
       FIELD r-rowid     AS rowid
       INDEX prim cod_empresa
                  cod_estab
                  cdn_repres.

DEF VAR i-num-tit-acr-orig AS INT NO-UNDO.
DEF BUFFER b-rep-tit-orig FOR repres_tit_acr.

bloco-principal:
FOR EACH tt-empresa NO-LOCK,

    EACH tt-estabelecimento NO-LOCK
   WHERE tt-estabelecimento.cod_empresa = tt-empresa.cod_empresa:

   /* Chamado 5.858 */
   IF  v_num_ped_exec_corren = 0 THEN DO:
       RUN pi-acompanhar IN h-acomp ("Corrigindo % Comiss∆o Pbello...").
   END.

   FOR EACH tit_acr NO-LOCK
      WHERE tit_acr.cod_estab             = tt-estabelecimento.cod_estab
        AND tit_acr.cdn_repres            = 96 /* Cliente AmÇrica Latina */
        AND tit_acr.dat_liquidac_tit_acr >= dt-ini-periodo
        AND tit_acr.log_tit_acr_estordo   = NO
        AND NOT tit_acr.ind_orig_tit_acr BEGINS "FAT",
       EACH repres_tit_acr NO-LOCK
      WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
        AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
        AND repres_tit_acr.cdn_repres     = 843 /* Representante Pbello */:

      ASSIGN i-num-tit-acr-orig = 0.

      RUN pi-busca-tit-original (INPUT tit_acr.cod_estab,
                                 INPUT tit_acr.num_id_tit_acr).

      IF i-num-tit-acr-orig = 0 THEN NEXT.

      FIND FIRST b-rep-tit-orig NO-LOCK
           WHERE b-rep-tit-orig.cod_empresa    = repres_tit_acr.cod_empresa
             AND b-rep-tit-orig.cod_estab      = repres_tit_acr.cod_estab
             AND b-rep-tit-orig.num_id_tit_acr = i-num-tit-acr-orig
             AND b-rep-tit-orig.cdn_repres     = repres_tit_acr.cdn_repres NO-ERROR.

      IF AVAIL b-rep-tit-orig                                                                                                            AND 
        (repres_tit_acr.val_perc_comis_repres <> b-rep-tit-orig.val_perc_comis_repres                                                     OR
        (repres_tit_acr.val_perc_comis_renegoc <> 0 AND repres_tit_acr.val_perc_comis_renegoc <> b-rep-tit-orig.val_perc_comis_repres)) THEN DO:

         /* Considera confirmaá∆o de entrada para permitir a alteraá∆o de t°tulo */
         ASSIGN l-escritural-nao-confirmada = NO.
         FIND FIRST movto_ocor_bcia OF tit_acr
              WHERE movto_ocor_bcia.ind_ocor_bcia_remes_ret = 'Remessa'
                AND movto_ocor_bcia.ind_tip_ocor_bcia       = 'Implantaá∆o' NO-ERROR.
         IF AVAIL movto_ocor_bcia                           AND 
            NOT movto_ocor_bcia.log_confir_movto_envdo_bco THEN DO:
            ASSIGN l-escritural-nao-confirmada                = YES
                   movto_ocor_bcia.log_confir_movto_envdo_bco = YES.
         END.

         ASSIGN de-orig-perc-comis-emis = repres_tit_acr.val_perc_comis_repres_emis. /* Guarda % Comiss∆o na Emiss∆o Original para n∆o zerar no momento do acerto do % de comiss∆o */

         /* Passo 1 - Elimina comiss∆o do t°tulo para que o campo repres_tit_acr.val_perc_comis_renegoc seja eliminado -  */
         /*           N∆o Ç poss°vel fazer isto via alteraá∆o - tt_alter_tit_acr_comis.ttv_num_tip_operac = 0             */

         EMPTY TEMP-TABLE tt_alter_tit_acr_base      NO-ERROR.
         EMPTY TEMP-TABLE tt_alter_tit_acr_comis     NO-ERROR.
         EMPTY TEMP-TABLE tt_log_erros_alter_tit_acr NO-ERROR.

         CREATE tt_alter_tit_acr_base.
         ASSIGN tt_alter_tit_acr_base.tta_cod_refer                   = fi-sugestao-referencia().
         ASSIGN tt_alter_tit_acr_base.tta_cod_estab                   = tit_acr.cod_estab
                tt_alter_tit_acr_base.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                tt_alter_tit_acr_base.tta_dat_transacao               = dt-fim-periodo
                tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_imp = ?
                tt_alter_tit_acr_base.tta_val_sdo_tit_acr             = ?           
                tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_alt = ?
                tt_alter_tit_acr_base.ttv_ind_motiv_acerto_val        = ?           
                tt_alter_tit_acr_base.tta_cod_portador                = ?           
                tt_alter_tit_acr_base.tta_cod_cart_bcia               = ?           
                tt_alter_tit_acr_base.tta_val_despes_bcia             = ?
                tt_alter_tit_acr_base.tta_cod_agenc_cobr_bcia         = ?           
                tt_alter_tit_acr_base.tta_cod_tit_acr_bco             = ?           
                tt_alter_tit_acr_base.tta_dat_emis_docto              = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_vencto_tit_acr          = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_prev_liquidac           = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_fluxo_tit_acr           = 01/01/0001  
                tt_alter_tit_acr_base.tta_ind_sit_tit_acr             = ?
                tt_alter_tit_acr_base.tta_cod_cond_cobr               = ?           
                tt_alter_tit_acr_base.tta_log_tip_cr_perda_dedut_tit  = ?           
                tt_alter_tit_acr_base.tta_dat_abat_tit_acr            = 01/01/0001
                tt_alter_tit_acr_base.tta_val_perc_abat_acr           = ?           
                tt_alter_tit_acr_base.tta_val_abat_tit_acr            = ?           
                tt_alter_tit_acr_base.tta_dat_desconto                = 01/01/0001
                tt_alter_tit_acr_base.tta_val_perc_desc               = ?           
                tt_alter_tit_acr_base.tta_val_desc_tit_acr            = ?           
                tt_alter_tit_acr_base.tta_qtd_dias_carenc_juros_acr   = ?           
                tt_alter_tit_acr_base.tta_val_perc_juros_dia_atraso   = ?           
                tt_alter_tit_acr_base.tta_qtd_dias_carenc_multa_acr   = ?           
                tt_alter_tit_acr_base.tta_val_perc_multa_atraso       = ?           
                tt_alter_tit_acr_base.ttv_cod_portador_mov            = ?
                tt_alter_tit_acr_base.tta_ind_tip_cobr_acr            = ?           
                tt_alter_tit_acr_base.tta_ind_ender_cobr              = ?           
                tt_alter_tit_acr_base.tta_nom_abrev_contat            = ?           
                tt_alter_tit_acr_base.tta_val_liq_tit_acr             = ?           
                tt_alter_tit_acr_base.tta_cod_instruc_bcia_1_movto    = ?
                tt_alter_tit_acr_base.tta_cod_instruc_bcia_2_movto    = ?
                tt_alter_tit_acr_base.tta_log_tit_acr_destndo         = ?           
                tt_alter_tit_acr_base.tta_cod_histor_padr             = ?
                tt_alter_tit_acr_base.ttv_des_text_histor             = ?
                tt_alter_tit_acr_base.tta_des_obs_cobr                = ?           
                tt_alter_tit_acr_base.ttv_wgh_lista                   = ?.

         CREATE tt_alter_tit_acr_comis.
         ASSIGN tt_alter_tit_acr_comis.tta_cod_empresa                  = tit_acr.cod_empresa
                tt_alter_tit_acr_comis.tta_cod_estab                    = tit_acr.cod_estab
                tt_alter_tit_acr_comis.tta_num_id_tit_acr               = tit_acr.num_id_tit_acr
                tt_alter_tit_acr_comis.ttv_num_tip_operac               = 2 /* Eliminar */
                tt_alter_tit_acr_comis.tta_cdn_repres                   = b-rep-tit-orig.cdn_repres.
         
         ASSIGN l-erro = NO.
         
         RUN prgfin/acr/acr711zf.py( INPUT  1,
                                     INPUT  TABLE tt_alter_tit_acr_base,
                                     INPUT  TABLE tt_alter_tit_acr_rateio,
                                     INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                     INPUT  TABLE tt_alter_tit_acr_comis,
                                     INPUT  TABLE tt_alter_tit_acr_cheq,
                                     INPUT  TABLE tt_alter_tit_acr_iva,
                                     INPUT  TABLE tt_alter_tit_acr_impto_retid,
                                     INPUT  TABLE tt_alter_tit_acr_cobr_especial,
                                     INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                     OUTPUT TABLE tt_log_erros_alter_tit_acr).
    
         FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK NO-ERROR.
         IF AVAIL tt_log_erros_alter_tit_acr THEN DO:
            ASSIGN l-erro = YES.
         END.
         IF l-erro THEN DO:
            FOR EACH tt_log_erros_alter_tit_acr:
               DISP tt_log_erros_alter_tit_acr.tta_cod_estab             
                    tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
                    tit_acr.cod_ser_docto   WHEN AVAIL tit_acr
                    tit_acr.cod_espec_docto WHEN AVAIL tit_acr
                    tit_acr.cod_tit_acr     WHEN AVAIL tit_acr
                    tit_acr.cod_parcela     WHEN AVAIL tit_acr
                    tt_log_erros_alter_tit_acr.ttv_num_mensagem          
                    tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb       
                    tt_log_erros_alter_tit_acr.ttv_des_msg_erro FORMAT "x(280)"         
                    substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,1,280) FORMAT "x(280)"
                    substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,281,280) FORMAT "x(280)"
                    WITH WIDTH 300 1 COL.      
            END. /* for each tt_log_erros_alter_tit_acr */
         END. /* if l-erro */
         /* FIM-Passo 1 */

         /* Passo 2 - Incluir comiss∆o para o representante 843 - Pbello com o mesmo % do t°tulo original */

         EMPTY TEMP-TABLE tt_alter_tit_acr_base      NO-ERROR.
         EMPTY TEMP-TABLE tt_alter_tit_acr_comis     NO-ERROR.
         EMPTY TEMP-TABLE tt_log_erros_alter_tit_acr NO-ERROR.

         CREATE tt_alter_tit_acr_base.
         ASSIGN tt_alter_tit_acr_base.tta_cod_refer                   = fi-sugestao-referencia().
         ASSIGN tt_alter_tit_acr_base.tta_cod_estab                   = tit_acr.cod_estab
                tt_alter_tit_acr_base.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                tt_alter_tit_acr_base.tta_dat_transacao               = dt-fim-periodo
                tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_imp = ?
                tt_alter_tit_acr_base.tta_val_sdo_tit_acr             = ?           
                tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_alt = ?
                tt_alter_tit_acr_base.ttv_ind_motiv_acerto_val        = ?           
                tt_alter_tit_acr_base.tta_cod_portador                = ?           
                tt_alter_tit_acr_base.tta_cod_cart_bcia               = ?           
                tt_alter_tit_acr_base.tta_val_despes_bcia             = ?
                tt_alter_tit_acr_base.tta_cod_agenc_cobr_bcia         = ?           
                tt_alter_tit_acr_base.tta_cod_tit_acr_bco             = ?           
                tt_alter_tit_acr_base.tta_dat_emis_docto              = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_vencto_tit_acr          = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_prev_liquidac           = 01/01/0001  
                tt_alter_tit_acr_base.tta_dat_fluxo_tit_acr           = 01/01/0001  
                tt_alter_tit_acr_base.tta_ind_sit_tit_acr             = ?
                tt_alter_tit_acr_base.tta_cod_cond_cobr               = ?           
                tt_alter_tit_acr_base.tta_log_tip_cr_perda_dedut_tit  = ?           
                tt_alter_tit_acr_base.tta_dat_abat_tit_acr            = 01/01/0001
                tt_alter_tit_acr_base.tta_val_perc_abat_acr           = ?           
                tt_alter_tit_acr_base.tta_val_abat_tit_acr            = ?           
                tt_alter_tit_acr_base.tta_dat_desconto                = 01/01/0001
                tt_alter_tit_acr_base.tta_val_perc_desc               = ?           
                tt_alter_tit_acr_base.tta_val_desc_tit_acr            = ?           
                tt_alter_tit_acr_base.tta_qtd_dias_carenc_juros_acr   = ?           
                tt_alter_tit_acr_base.tta_val_perc_juros_dia_atraso   = ?           
                tt_alter_tit_acr_base.tta_qtd_dias_carenc_multa_acr   = ?           
                tt_alter_tit_acr_base.tta_val_perc_multa_atraso       = ?           
                tt_alter_tit_acr_base.ttv_cod_portador_mov            = ?
                tt_alter_tit_acr_base.tta_ind_tip_cobr_acr            = ?           
                tt_alter_tit_acr_base.tta_ind_ender_cobr              = ?           
                tt_alter_tit_acr_base.tta_nom_abrev_contat            = ?           
                tt_alter_tit_acr_base.tta_val_liq_tit_acr             = ?           
                tt_alter_tit_acr_base.tta_cod_instruc_bcia_1_movto    = ?
                tt_alter_tit_acr_base.tta_cod_instruc_bcia_2_movto    = ?
                tt_alter_tit_acr_base.tta_log_tit_acr_destndo         = ?           
                tt_alter_tit_acr_base.tta_cod_histor_padr             = ?
                tt_alter_tit_acr_base.ttv_des_text_histor             = ?
                tt_alter_tit_acr_base.tta_des_obs_cobr                = ?           
                tt_alter_tit_acr_base.ttv_wgh_lista                   = ?.

         CREATE tt_alter_tit_acr_comis.
         ASSIGN tt_alter_tit_acr_comis.tta_cod_empresa                  = tit_acr.cod_empresa
                tt_alter_tit_acr_comis.tta_cod_estab                    = tit_acr.cod_estab
                tt_alter_tit_acr_comis.tta_num_id_tit_acr               = tit_acr.num_id_tit_acr
                tt_alter_tit_acr_comis.ttv_num_tip_operac               = 1 /* Incluir */
                tt_alter_tit_acr_comis.tta_cdn_repres                   = b-rep-tit-orig.cdn_repres
                tt_alter_tit_acr_comis.tta_val_perc_comis_repres        = b-rep-tit-orig.val_perc_comis_repres
                tt_alter_tit_acr_comis.tta_val_perc_comis_repres_emis   = de-orig-perc-comis-emis
                tt_alter_tit_acr_comis.tta_val_perc_comis_abat          = 0
                tt_alter_tit_acr_comis.tta_val_perc_comis_desc          = 0
                tt_alter_tit_acr_comis.tta_val_perc_comis_juros         = 0
                tt_alter_tit_acr_comis.tta_val_perc_comis_multa         = 0
                tt_alter_tit_acr_comis.tta_val_perc_comis_acerto_val    = 0
                tt_alter_tit_acr_comis.tta_log_comis_repres_proporc     = YES
                tt_alter_tit_acr_comis.tta_ind_tip_comis                = b-rep-tit-orig.ind_tip_comis.
    
         ASSIGN l-erro = NO.
         
         RUN prgfin/acr/acr711zf.py( INPUT  1,
                                     INPUT  TABLE tt_alter_tit_acr_base,
                                     INPUT  TABLE tt_alter_tit_acr_rateio,
                                     INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                     INPUT  TABLE tt_alter_tit_acr_comis,
                                     INPUT  TABLE tt_alter_tit_acr_cheq,
                                     INPUT  TABLE tt_alter_tit_acr_iva,
                                     INPUT  TABLE tt_alter_tit_acr_impto_retid,
                                     INPUT  TABLE tt_alter_tit_acr_cobr_especial,
                                     INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                     OUTPUT TABLE tt_log_erros_alter_tit_acr).
    
         FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK NO-ERROR.
         IF AVAIL tt_log_erros_alter_tit_acr THEN DO:
            ASSIGN l-erro = YES.
         END.
         IF l-erro THEN DO:
            FOR EACH tt_log_erros_alter_tit_acr:
               DISP tt_log_erros_alter_tit_acr.tta_cod_estab             
                    tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
                    tit_acr.cod_ser_docto   WHEN AVAIL tit_acr
                    tit_acr.cod_espec_docto WHEN AVAIL tit_acr
                    tit_acr.cod_tit_acr     WHEN AVAIL tit_acr
                    tit_acr.cod_parcela     WHEN AVAIL tit_acr
                    tt_log_erros_alter_tit_acr.ttv_num_mensagem          
                    tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb       
                    tt_log_erros_alter_tit_acr.ttv_des_msg_erro FORMAT "x(280)"         
                    substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,1,280) FORMAT "x(280)"
                    substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,281,280) FORMAT "x(280)"
                    WITH WIDTH 300 1 COL.      
            END. /* for each tt_log_erros_alter_tit_acr */
         END. /* if l-erro */
         /* FIM-Passo 2 */
         
         IF l-escritural-nao-confirmada THEN DO:
            ASSIGN movto_ocor_bcia.log_confir_movto_envdo_bco = NO.
         END.
         
      END.
   END.
   /* FIM-Chamado 5.858 */

   IF  v_num_ped_exec_corren = 0 THEN DO:
       RUN pi-acompanhar IN h-acomp ("Selecionando T°tulos Estab " + tt-estabelecimento.cod_estab).
   END.

   EMPTY TEMP-TABLE tt-repres-tit-acr NO-ERROR.
   
   FOR EACH tit_acr USE-INDEX titacr_liquidac NO-LOCK
      WHERE tit_acr.cod_estab              = tt-estabelecimento.cod_estab
        AND tit_acr.dat_liquidac_tit_acr  >= dt-ini-periodo.
      FOR EACH repres_tit_acr NO-LOCK
         WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
           AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.

         IF LOOKUP(STRING(repres_tit_acr.cdn_repres),c-lista-cdn-repres) = 0 THEN NEXT.

         CREATE tt-repres-tit-acr.
         ASSIGN tt-repres-tit-acr.cod_empresa = repres_tit_acr.cod_empresa
                tt-repres-tit-acr.cod_estab   = repres_tit_acr.cod_estab
                tt-repres-tit-acr.cdn_repres  = repres_tit_acr.cdn_repres
                tt-repres-tit-acr.r-rowid     = rowid(repres_tit_acr).
      END.
   END.
   
   IF  v_num_ped_exec_corren = 0 THEN DO:
       RUN pi-acompanhar IN h-acomp ("Selecionando Cheques Estab " + tt-estabelecimento.cod_estab).
   END.

   FOR EACH emsuni.espec_docto NO-LOCK
      WHERE emsuni.espec_docto.ind_tip_espec_docto = 'Cheques Recebidos':  
      FOR EACH b-tit-cheque NO-LOCK
         WHERE b-tit-cheque.cod_espec_doc              = emsuni.espec_docto.cod_espec_docto
           AND b-tit-cheque.cod_estab                  = tt-estabelecimento.cod_estab
           AND b-tit-cheque.dat_liquidac_tit_acr       > dt-fim-periodo.
    
         IF b-tit-cheque.cod_indic_econ <> "Real" THEN NEXT.

         FIND FIRST cheq_acr OF b-tit-cheque NO-LOCK NO-ERROR.
         IF AVAIL cheq_acr THEN DO:
            FOR EACH relacto_cheq_acr OF cheq_acr NO-LOCK.
               FIND FIRST movto_tit_acr NO-LOCK
                    WHERE movto_tit_acr.cod_estab            = relacto_cheq_acr.cod_estab
                      AND movto_tit_acr.num_id_movto_tit_acr = relacto_cheq_acr.num_id_movto_tit_acr NO-ERROR.
               IF NOT AVAIL movto_tit_acr THEN NEXT.
               FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
               IF AVAIL tit_acr THEN DO:
                  FOR EACH repres_tit_acr NO-LOCK
                     WHERE repres_tit_acr.cod_estab      = tit_acr.cod_estab
                       AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.

                     IF LOOKUP(STRING(repres_tit_acr.cdn_repres),c-lista-cdn-repres) = 0 THEN NEXT.

                     FIND FIRST tt-repres-tit-acr NO-LOCK
                          WHERE tt-repres-tit-acr.cod_empresa = repres_tit_acr.cod_empresa
                            AND tt-repres-tit-acr.cod_estab   = repres_tit_acr.cod_estab
                            AND tt-repres-tit-acr.cdn_repres  = repres_tit_acr.cdn_repres 
                            AND tt-repres-tit-acr.r-rowid     = rowid(repres_tit_acr) NO-ERROR.

                     IF NOT AVAIL tt-repres-tit-acr THEN DO:
                        CREATE tt-repres-tit-acr.
                        ASSIGN tt-repres-tit-acr.cod_empresa = repres_tit_acr.cod_empresa
                               tt-repres-tit-acr.cod_estab   = repres_tit_acr.cod_estab
                               tt-repres-tit-acr.cdn_repres  = repres_tit_acr.cdn_repres
                               tt-repres-tit-acr.r-rowid     = rowid(repres_tit_acr).
                     END.
                  END.
               END.
            END.
         END.
      END.
   END.

   FOR EACH representante NO-LOCK
      WHERE representante.cod_empresa  = tt-empresa.cod_empresa
        AND LOOKUP(STRING(representante.cdn_repres),c-lista-cdn-repres) > 0:

       FIND FIRST dc-repres OF representante NO-LOCK NO-ERROR.
    
       /* SSI 071/06 */ 
    /*    IF dc-repres.cod_tip_repres = "EXP" THEN  */
    /*       NEXT bloco-principal.                  */
       /* FIM-SSI 071/06 */ 
    
       /* Verifica se representante est† em Rescis∆o */
       FIND FIRST dc-comis-movto NO-LOCK
            WHERE dc-comis-movto.cod_empresa    = representante.cod_empresa
              AND dc-comis-movto.cdn_repres     = representante.cdn_repres
              AND dc-comis-movto.cod_transacao  = 6 NO-ERROR.
       IF NOT AVAIL dc-comis-movto THEN
          FIND FIRST dc-comis-movto NO-LOCK
               WHERE dc-comis-movto.cod_empresa    = representante.cod_empresa
                 AND dc-comis-movto.cdn_repres     = representante.cdn_repres
                 AND dc-comis-movto.cod_transacao  = 11 NO-ERROR.
       IF AVAIL dc-comis-movto THEN NEXT.
    
       FIND FIRST tt-repres
            WHERE tt-repres.cod_empresa     = representante.cod_empresa
              AND tt-repres.cdn_repres      = representante.cdn_repres NO-ERROR.
       IF  NOT AVAIL tt-repres THEN DO:
           CREATE  tt-repres.
           ASSIGN  tt-repres.cod_empresa    = representante.cod_empresa
                   tt-repres.cdn_repres     = representante.cdn_repres
                   tt-repres.nom_pessoa     = representante.nom_pessoa
                   tt-repres.nom_abrev      = representante.nom_abrev
                   tt-repres.cod_ccusto     = IF AVAIL dc-repres 
                                                 THEN dc-repres.cod_ccusto
                                                 ELSE ""
                   tt-repres.log_ativo      = IF AVAIL dc-repres 
                                                 THEN dc-repres.log_ativo
                                                 ELSE NO
                   tt-repres.cod_tip_repres = IF AVAIL dc-repres 
                                                 THEN dc-repres.cod_tip_repres
                                                 ELSE "".
       END.

       FIND FIRST tt-repres-202
             WHERE tt-repres-202.cod_empresa     = representante.cod_empresa
               AND tt-repres-202.cdn_repres      = representante.cdn_repres NO-ERROR.
        IF  NOT AVAIL tt-repres-202 THEN DO:
            CREATE  tt-repres-202.
            ASSIGN  tt-repres-202.cod_empresa    = representante.cod_empresa
                    tt-repres-202.cdn_repres     = representante.cdn_repres.
        END.
    
       IF  v_num_ped_exec_corren = 0 THEN DO:
           RUN pi-acompanhar IN h-acomp ("Lendo Representante " + STRING(representante.cdn_repres)).
       END.
    
       FOR EACH tt-repres-tit-acr NO-LOCK
          WHERE tt-repres-tit-acr.cod_empresa = representante.cod_empresa   
            AND tt-repres-tit-acr.cdn_repres  = representante.cdn_repres    
            AND tt-repres-tit-acr.cod_estab   = tt-estabelecimento.cod_estab,
          FIRST repres_tit_acr NO-LOCK
          WHERE rowid(repres_tit_acr)                      = tt-repres-tit-acr.r-rowid
            AND repres_tit_acr.val_perc_comis_repres      <> 0
            AND repres_tit_acr.val_perc_comis_repres_emis >= i-ini-perc-comis
            AND repres_tit_acr.val_perc_comis_repres_emis <= i-fim-perc-comis,
          
          FIRST tit_acr NO-LOCK
          WHERE tit_acr.cod_estab       = repres_tit_acr.cod_estab
            AND tit_acr.num_id_tit_acr  = repres_tit_acr.num_id_tit_acr
            AND LOOKUP(TRIM(tit_acr.cod_espec_docto),c-lista-cod-esp) > 0
            AND tit_acr.cdn_cliente    >= i-ini-cliente
            AND tit_acr.cdn_cliente    <= i-fim-cliente
            AND tit_acr.cod_refer      >= c-ini-referencia 
            AND tit_acr.cod_refer      <= c-fim-referencia 
            AND tit_acr.dat_emis_docto <= dt-fim-periodo,
          
          FIRST emsuni.cliente NO-LOCK
          WHERE cliente.cod_empresa     = tit_acr.cod_empresa
            AND cliente.cdn_cliente     = tit_acr.cdn_cliente:
    
          RUN dop/dco005a.p (repres_tit_acr.cod_empresa   ,
                             repres_tit_acr.cdn_repres    ,
                             tit_acr.cod_estab            , 
                             tit_acr.num_id_tit_acr       , 
                             OUTPUT c-cod_ccusto          ).
          
          /*
          /* Chamado 6.262 - A partir da definiá∆o de que as verbas cooperadas de home-centers ser∆o implantadas no m¢dulo de
                             Contas a pagar e os t°tulos do Contas a Receber destes clientes ser∆o liquidados por encontro 
                             de contas contra estes pagamentos, todas as liquidaá‰es por encontro de contas n∆o estornar∆o 
                             as comiss‰es dos representantes */
          IF tt-repres.cod_tip_repres <> "EXP" THEN DO: /* SSI 071/06 - N∆o estorno LQEC para Exportaá∆o */ 
             lqec:
             FOR EACH movto_tit_acr OF tit_acr NO-LOCK /* Encontro de Contas */
                WHERE movto_tit_acr.dat_transacao      >= dt-ini-periodo
                  AND movto_tit_acr.dat_transacao      <= dt-fim-periodo
                  AND movto_tit_acr.ind_trans_acr_abrev = 'LQEC'
                  AND NOT movto_tit_acr.log_movto_estordo.
        
                 FIND FIRST movto_comis_repres EXCLUSIVE-LOCK
                      WHERE movto_comis_repres.cod_estab            = movto_tit_acr.cod_estab
                        AND movto_comis_repres.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                        AND movto_comis_repres.dat_transacao        = movto_tit_acr.dat_transacao 
                        AND movto_comis_repres.ind_trans_acr        = 'Liquidaá∆o Enctro Ctas' 
                        AND movto_comis_repres.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
        
                 IF AVAIL movto_comis_repres THEN DO:
                    IF movto_comis_repres.ind_sit_movto_comis = 'Estornado' THEN NEXT lqec.
           
                    ASSIGN c-categoria = ''.
                    RUN dop/dco005d.p (emsuni.cliente.cdn_cliente,
                                       OUTPUT c-categoria).
                    IF c-categoria <> '' AND c-categoria <> 'T'  THEN DO: /* Assistentes TÇcnicos */
                       /* N∆o paga comiss∆o de liquidaá∆o por encontro de contas de clientes que n∆o sejam assistentes tÇcnicos */
                       ASSIGN movto_comis_repres.ind_sit_movto_comis = 'Estornado'.
                    END. /* IF AVAIL movto_comis_repres */
                 END.
                 IF tg-gera-movto-comis                             AND
                    repres_tit_acr.val_perc_comis_repres_emis <> 0 THEN DO:
                    FIND LAST dc-comis-trans NO-LOCK
                        WHERE dc-comis-trans.cod_transacao = 60 NO-ERROR.
                    IF AVAIL dc-comis-trans THEN DO:
        
                       FIND FIRST dc-comis-movto NO-LOCK
                            WHERE dc-comis-movto.cod_empresa              = tit_acr.cod_empresa                                                                                                                                                       
                              AND dc-comis-movto.cdn_repres               = repres_tit_acr.cdn_repres                                                                                                                                                 
                              AND dc-comis-movto.cod_transacao            = dc-comis-trans.cod_transacao                                                                                                                                              
                              AND dc-comis-movto.dat_transacao            = movto_tit_acr.dat_transacao                                                                                                                                               
                              AND dc-comis-movto.des_transacao            MATCHES STRING('*' + tit_acr.cod_estab       + '-' + 
                                                                                               tit_acr.cod_espec_docto + '-' + 
                                                                                               tit_acr.cod_ser_docto   + '-' + 
                                                                                               tit_acr.cod_tit_acr     + '-' + 
                                                                                               tit_acr.cod_parcela     + '*') NO-ERROR.
                       IF NOT AVAIL dc-comis-movto THEN DO:
                          CREATE dc-comis-movto.
                          ASSIGN dc-comis-movto.cod_empresa              = tit_acr.cod_empresa
                                 dc-comis-movto.cdn_repres               = repres_tit_acr.cdn_repres
                                 dc-comis-movto.cod_transacao            = dc-comis-trans.cod_transacao
                                 dc-comis-movto.dat_transacao            = movto_tit_acr.dat_transacao
                                 dc-comis-movto.des_transacao            = dc-comis-trans.descricao +  ' ' + tit_acr.cod_estab       + '-' + 
                                                                                                             tit_acr.cod_espec_docto + '-' + 
                                                                                                             tit_acr.cod_ser_docto   + '-' + 
                                                                                                             tit_acr.cod_tit_acr     + '-' + 
                                                                                                             tit_acr.cod_parcela
                                 dc-comis-movto.cod_plano_cta_ctbl       = dc-comis-trans.cod_plano_cta_ctbl
                                 dc-comis-movto.cod_cta_ctbl             = dc-comis-trans.cod_cta_ctbl
                                 dc-comis-movto.cod_plano_ccusto         = dc-comis-trans.cod_plano_ccusto  
                                 dc-comis-movto.cod_ccusto               = c-cod_ccusto
                                 dc-comis-movto.ind_origin_movto         = "dco005"
        
                                 de-val-liq-base                         = (movto_tit_acr.val_movto_tit_acr  * 
                                                                            tit_acr.val_liq_tit_acr)     / 
                                                                            tit_acr.val_origin_tit_acr
        
                                 dc-comis-movto.val_movto                =   de-val-liq-base                                  * 
                                                                            (repres_tit_acr.val_perc_comis_repres      / 100) * 
                                                                            (repres_tit_acr.val_perc_comis_repres_emis / 100).
                          CREATE dc-orig-comis-movto.
                          ASSIGN dc-orig-comis-movto.num_id_comis_movto  = dc-comis-movto.num_id_comis_movto
                                 dc-orig-comis-movto.cod_empresa         = dc-comis-movto.cod_empresa
                                 dc-orig-comis-movto.cdn_repres          = dc-comis-movto.cdn_repres
                                 dc-orig-comis-movto.num_seq_movto_comis = 10
                                 dc-orig-comis-movto.cod_estab           = tit_acr.cod_estab
                                 dc-orig-comis-movto.num_id_tit_acr      = tit_acr.num_id_tit_acr     
                                 dc-orig-comis-movto.dat_transacao       = dc-comis-movto.dat_transacao
                                 dc-orig-comis-movto.val_movto_comis     = dc-comis-movto.val_movto.
                       END.
                    END.
                 END. /* Estorno da comiss∆o paga na emiss∆o */
             END. /* Movimentos Liquidaá∆o por Encontro de Contas */
          END. /* IF tt-repres.cod_tip_repres <> "EXP" */
          
          /* Fim Chamado 6.262 */
          */
          
          realizado:
          FOR  EACH movto_comis_repres NO-LOCK
              WHERE movto_comis_repres.cod_estab      = tit_acr.cod_estab
                AND movto_comis_repres.cdn_repres     = repres_tit_acr.cdn_repres
                AND movto_comis_repres.num_id_tit_acr = tit_acr.num_id_tit_acr
                AND movto_comis_repres.ind_tip_movto  = 'REALIZADO':
    
              FIND FIRST movto_tit_acr NO-LOCK
                   WHERE movto_tit_acr.cod_estab            = tit_acr.cod_estab
                     AND movto_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                     AND movto_tit_acr.num_id_movto_tit_acr = movto_comis_repres.num_id_movto_tit_acr NO-ERROR.
              
              /* Desconsidera Estorno de Liquidaá∆o e Estorno de Acerto de Valor */
              IF movto_comis_repres.ind_trans_acr BEGINS 'Estorno de Liquid' OR
                (movto_comis_repres.ind_trans_acr BEGINS 'Liquid' AND movto_tit_acr.log_movto_estordo) OR 
                (movto_comis_repres.ind_trans_acr BEGINS 'Acerto Valor' AND movto_tit_acr.log_movto_estordo) OR 
                (movto_comis_repres.ind_trans_acr BEGINS 'Estorno Acerto Val') THEN
                 NEXT realizado.
              /* FIM-Desconsidera Estorno de Liquidaá∆o */

              IF  AVAIL movto_tit_acr THEN DO:
                  IF repres_tit_acr.val_perc_comis_repres_emis = 100                  OR 
                     movto_comis_repres.ind_trans_comis        = "Comiss∆o Emiss∆o" THEN DO:
    
                     /* Chamado 3.882 */
                     /* L¢gica para evitar que as comiss‰es dos t°tulos VD relativos Ös notas fiscais com
                        condiá∆o de pagamento 847 sejam pagos em duplicidade.
                        Em Julho/2010, notas fiscais com esta condiá∆o de pagamento foram faturadas com
                        % de comiss∆o na emiss∆o igual a 0 (zero)
                        No dia 10/08/2010 foi executado procedimento excepcional para creditar o valor
                        n∆o pago em Julho/2010 na transaá∆o 1 de alguns representantes */
                     IF dt-fim-periodo <= 08/31/2010 THEN DO:
                        FIND  LAST dc-comis-movto USE-INDEX ch-prim NO-LOCK
                             WHERE dc-comis-movto.cod_empresa    = repres_tit_acr.cod_empresa
                               AND dc-comis-movto.cdn_repres     = repres_tit_acr.cdn_repres
                               AND dc-comis-movto.cod_transacao  = 1
                               AND dc-comis-movto.dat_transacao >= dt-ini-periodo
                               AND dc-comis-movto.dat_transacao <= dt-fim-periodo NO-ERROR.
                        IF AVAIL dc-comis-movto THEN DO:
                           FIND FIRST dc-orig-comis-movto OF dc-comis-movto NO-LOCK
                                WHERE dc-orig-comis-movto.cod_estab      = tit_acr.cod_estab
                                  AND dc-orig-comis-movto.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
                           IF AVAIL dc-orig-comis-movto THEN
                              NEXT realizado.
                        END.
                     END.
                     /* FIM-Chamado 3.882 */
    
                     IF tit_acr.dat_emis_doc < dt-ini-periodo OR
                        tit_acr.dat_emis_doc > dt-fim-periodo THEN 
                        NEXT realizado.
                  END. /* Comiss∆o na Emiss∆o */
                  ELSE DO:
                     IF movto_tit_acr.dat_transacao >= 09/01/2005 THEN DO: /* N∆o paga comiss∆o de liquidaá‰es com cheque a partir */
                        FIND FIRST relacto_cheq_acr NO-LOCK                /* de 01/09/2005                                        */
                             WHERE relacto_cheq_acr.cod_estab            = movto_tit_acr.cod_estab
                               AND relacto_cheq_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                        IF AVAIL relacto_cheq_acr THEN 
                           NEXT realizado. /* N∆o considera liquidaá‰es com cheque para pagamento */
                     END.
                     IF movto_tit_acr.dat_liquidac_tit_acr <> ? THEN DO:
                        IF (rs-data = 'Baixa'                                      AND
                           (movto_tit_acr.dat_liquidac_tit_acr  < dt-ini-periodo    OR 
                            movto_tit_acr.dat_liquidac_tit_acr  > dt-fim-periodo))  OR
                           (rs-data = 'Credito'                                    AND 
                           (movto_tit_acr.dat_cr_movto_tit_acr  < dt-ini-periodo    OR 
                            movto_tit_acr.dat_cr_movto_tit_acr  > dt-fim-periodo))  THEN 
                            NEXT realizado.
                     END.
                     ELSE DO:
                        IF  movto_comis_repres.dat_transacao   < dt-ini-periodo OR
                            movto_comis_repres.dat_transacao   > dt-fim-periodo THEN 
                            NEXT realizado.
                     END.
                  END. /* Comiss∆o na Liquidaá∆o */
              END.
              ELSE IF  movto_comis_repres.dat_transacao   < dt-ini-periodo OR
                       movto_comis_repres.dat_transacao   > dt-fim-periodo THEN 
                       NEXT realizado.
    
              IF LOOKUP(tit_acr.cod_espec_docto,"LP,LM")  = 0                            OR
                (LOOKUP(tit_acr.cod_espec_docto,"LP,LM") <> 0 AND tt-repres.log_ativo) THEN DO: /*  SSI 025/05 */
    
                 IF movto_comis_repres.ind_trans_comis = 'Comiss∆o sobre Abatimento' OR 
                    movto_comis_repres.ind_trans_comis = 'Comiss∆o sobre Desconto' THEN DO:
                    FIND FIRST b-movto-comis EXCLUSIVE-LOCK
                         WHERE rowid(b-movto-comis) = rowid(movto_comis_repres) NO-ERROR.
                    ASSIGN b-movto-comis.ind_sit_movto_comis = "Estornado"
                           b-movto-comis.val_movto_comis     = b-movto-comis.val_base_calc_comis * 
                                                              (repres_tit_acr.val_perc_comis_repres / 100).
                 END.
    
                 CREATE  tt-movto.
                 ASSIGN  tt-movto.num_id_tit_acr             = movto_comis_repres.num_id_tit_acr        
                         tt-movto.num_seq_movto_comis        = movto_comis_repres.num_seq_movto_comis   
                         tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                         tt-movto.nom_pessoa                 = representante.nom_pessoa
                         tt-movto.cdn_cliente                = tit_acr.cdn_cliente
                         tt-movto.nom_cliente                = cliente.nom_pessoa
                         tt-movto.cod_empresa                = tit_acr.cod_empresa
                         tt-movto.cod_estab                  = tit_acr.cod_estab
                         tt-movto.cod_espec_docto            = tit_acr.cod_espec_docto
                         tt-movto.cod_ser_docto              = tit_acr.cod_ser_docto
                         tt-movto.cod_tit_acr                = tit_acr.cod_tit_acr
                         tt-movto.cod_parcela                = tit_acr.cod_parcela
                         tt-movto.dat_emis_docto             = tit_acr.dat_emis_docto
                         tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                         tt-movto.dat_liquidac_tit_acr       = (IF  AVAIL movto_tit_acr 
                                                                    THEN (IF  rs-data = 'Baixa' 
                                                                              THEN movto_tit_acr.dat_liquidac_tit_acr 
                                                                              ELSE movto_tit_acr.dat_cr_movto_tit_acr) 
                                                                    ELSE tit_acr.dat_ult_liquidac_tit_acr)
                         tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                         tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                         tt-movto.val_base_calc_comis        = movto_comis_repres.val_base_calc_comis
                         tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                         tt-movto.cod_ccusto                 = c-cod_ccusto.
              
                 IF  movto_comis_repres.ind_natur_lancto_ctbl = 'CR' THEN DO: 
                     ASSIGN  tt-movto.val_movto_comis   = tt-movto.val_movto_comis   + movto_comis_repres.val_movto_comis.
                     
                     IF  movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o" THEN DO:
                          ASSIGN  tt-repres.de-tot-pg-emiss[1]  = tt-repres.de-tot-pg-emiss[1] + movto_comis_repres.val_movto_comis.
                          IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN 
                             ASSIGN  tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + movto_comis_repres.val_movto_comis
                                     tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1]     + movto_comis_repres.val_movto_comis
                                     tt-movto.vincul-no-mes          = "*".
                     END. /* if Comiss∆o Emiss∆o */
                     ELSE DO: /* Comiss∆o na Liquidaá∆o */

                         /* Incluido teste para movimento em lp que foi estornado o que gerava deduá∆o indevida no valor devido ao representante */
                         IF LOOKUP(tit_acr.cod_espec_docto,"LP,LM") <> 0 AND movto_comis_repres.ind_sit_movto_comis <> "Estornado" THEN DO: /*  SSI 025/05 */
                            IF tt-repres.log_ativo THEN 
                               ASSIGN  tt-repres.de-tot-pg-lp-lm[1]  = tt-repres.de-tot-pg-lp-lm[1] + movto_comis_repres.val_movto_comis.
                         END.
                         ELSE DO:
                            ASSIGN  tt-repres.de-tot-pg-baixa[1]  = tt-repres.de-tot-pg-baixa[1] + movto_comis_repres.val_movto_comis.
                         END.
                            
                         IF tt-movto.dat_emis_docto >= dt-ini-periodo  AND /* Comiss∆o Vinculada */
                            tt-movto.dat_emis_docto <= dt-fim-periodo THEN DO:
       
                            IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN DO:
                               ASSIGN tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + movto_comis_repres.val_movto_comis
                                      tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1]     + movto_comis_repres.val_movto_comis
                                      tt-movto.vincul-no-mes          = "*".
                            END. /* N∆o Ç VD ou VE */
                            ELSE DO:
                               ASSIGN da-emis-nota = 12/31/9999.
                               RUN dop/dco005e.p (INPUT tit_acr.cod_estab,
                                                  INPUT tit_acr.cod_ser_doc,
                                                  INPUT tit_acr.cod_tit_acr,
                                                  OUTPUT da-emis-nota).
                               IF da-emis-nota >= dt-ini-periodo  AND     /* Considera Vinculada no Per°odo VD e VE se a nota estiver */
                                  da-emis-nota <= dt-fim-periodo THEN DO: /* dentro da faixa de datas do relat¢rio                    */
                                  ASSIGN tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + movto_comis_repres.val_movto_comis
                                         tt-repres.de-tot-vinc-mes[1]    = tt-repres.de-tot-vinc-mes[1] + movto_comis_repres.val_movto_comis
                                         tt-movto.vincul-no-mes          = "*".
                               END. /* if da-emis-nota dentro da faixa de datas do relat¢rio */
                            END. /* Trata-se de VD ou VE */
       
                         END. /* Data de emiss∆o do titulo dentro das faixas do relat¢rio */
                     END. /* Comiss∆o na Liquidaá∆o */
       
                     IF  movto_comis_repres.ind_sit_movto_comis = "Estornado" THEN DO:
                         ASSIGN tt-movto.val_movto_estorno = tt-movto.val_movto_estorno + movto_comis_repres.val_movto_comis
                                tt-repres.de-tot-pg-estor[1]  = tt-repres.de-tot-pg-estor[1]  + movto_comis_repres.val_movto_comis.
                     END.
                 END.
                 ELSE ASSIGN  tt-movto.val_movto_estorno = tt-movto.val_movto_estorno + movto_comis_repres.val_movto_comis
                              tt-repres.de-tot-pg-estor[1]  = tt-repres.de-tot-pg-estor[1]  + movto_comis_repres.val_movto_comis.
              END. /* if lookup(tit_acr.cod_espec_docto,"LP,LM")  = 0 */
          END. /* for each movto_comis_repres */
    
          FOR EACH movto_comis_repres NO-LOCK
             WHERE movto_comis_repres.cod_estab              = tit_acr.cod_estab
               AND movto_comis_repres.cdn_repres             = repres_tit_acr.cdn_repres
               AND movto_comis_repres.num_id_tit_acr         = tit_acr.num_id_tit_acr
               AND movto_comis_repres.ind_tip_movto          = 'N«O REALIZADO'
               AND movto_comis_repres.ind_natur_lancto_ctbl <> 'CR' :
             CREATE  tt-movto.
             ASSIGN  tt-movto.num_id_tit_acr             = tit_acr.num_id_tit_acr        
                     tt-movto.num_seq_movto_comis        = 0
                     tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                     tt-movto.nom_pessoa                 = representante.nom_pessoa
                     tt-movto.cdn_cliente                = tit_acr.cdn_cliente
                     tt-movto.nom_cliente                = cliente.nom_pessoa
                     tt-movto.cod_empresa                = tit_acr.cod_empresa
                     tt-movto.cod_estab                  = tit_acr.cod_estab
                     tt-movto.cod_espec_docto            = tit_acr.cod_espec_docto
                     tt-movto.cod_ser_docto              = tit_acr.cod_ser_docto
                     tt-movto.cod_tit_acr                = tit_acr.cod_tit_acr
                     tt-movto.cod_parcela                = tit_acr.cod_parcela
                     tt-movto.dat_emis_docto             = tit_acr.dat_emis_docto
                     tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                     tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                     tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                     tt-movto.val_base_calc_comis        = movto_comis_repres.val_base_calc_comis
                     tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                     tt-movto.cod_ccusto                 = c-cod_ccusto.
    
             ASSIGN  tt-movto.val_movto_estorno = tt-movto.val_movto_estorno + movto_comis_repres.val_movto_comis.

             &if "{&bf_mat_versao_ems}" = "2.062" &then
             /* EMS206 */
             ASSIGN  tt-repres.de-tot-vincul[1] = tt-repres.de-tot-vincul[1]    - movto_comis_repres.val_movto_comis.
             &else

             /* totvs 11 */
             assign tt-repres.de-tot-pg-estor[1]  = tt-repres.de-tot-pg-estor[1]  + movto_comis_repres.val_movto_comis   /* upgrade tovs 11 */
                    tt-movto.val_movto_comis   = tt-movto.val_movto_comis   + movto_comis_repres.val_movto_comis.        /* upgrade tovs 11 */

             IF  movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o" THEN DO:
                  ASSIGN  tt-repres.de-tot-pg-emiss[1]  = tt-repres.de-tot-pg-emiss[1] + movto_comis_repres.val_movto_comis.
             END. /* if Comiss∆o Emiss∆o */
             ELSE DO: /* Comiss∆o na Liquidaá∆o */
                 IF LOOKUP(tit_acr.cod_espec_docto,"LP,LM") <> 0 THEN DO: /*  SSI 025/05 */
                    IF tt-repres.log_ativo THEN 
                       ASSIGN  tt-repres.de-tot-pg-lp-lm[1]  = tt-repres.de-tot-pg-lp-lm[1] + movto_comis_repres.val_movto_comis.
                 END.
                 ELSE DO:
                    ASSIGN  tt-repres.de-tot-pg-baixa[1]  = tt-repres.de-tot-pg-baixa[1] + movto_comis_repres.val_movto_comis.
                 END.
             END.
             /* totvs 11 */

             &endif

             IF  tt-movto.dat_emis_docto >= dt-ini-periodo    AND /* Comiss∆o Vinculada no Màs */
                 tt-movto.dat_emis_docto <= dt-fim-periodo   THEN DO:
                 IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN DO:
                    ASSIGN  tt-movto.val_movto_vincul_mes  = tt-movto.val_movto_vincul_mes + movto_comis_repres.val_movto_comis
                            tt-repres.de-tot-vinc-mes[1]      = tt-repres.de-tot-vinc-mes[1] + movto_comis_repres.val_movto_comis
                            tt-movto.vincul-no-mes         = "*".
                 END. /* N∆o Ç VD ou VE */
                 ELSE DO:
                    ASSIGN da-emis-nota = 12/31/9999.
                    RUN dop/dco005e.p (INPUT tit_acr.cod_estab,
                                       INPUT tit_acr.cod_ser_doc,
                                       INPUT tit_acr.cod_tit_acr,
                                       OUTPUT da-emis-nota).
                    IF da-emis-nota >= dt-ini-periodo  AND     /* Considera Vinculada no Per°odo VD e VE se a nota estiver */
                       da-emis-nota <= dt-fim-periodo THEN DO: /* dentro da faixa de datas do relat¢rio                    */
                       ASSIGN tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + movto_comis_repres.val_movto_comis
                              tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1]     + movto_comis_repres.val_movto_comis
                              tt-movto.vincul-no-mes          = "*".
                    END. /* if da-emis-nota dentro da faixa de datas do relat¢rio */
                 END. /* Trata-se de VD ou VE */
             END. /* T°tulo com Data de Emiss∆o dentro da Faixa de Datas */
          END. /* Movimento de Comiss∆o n∆o Realizado */
    
          /* Comiss∆o Vinculada Final do Per°odo */
          FIND FIRST emsuni.espec_docto NO-LOCK
               WHERE emsuni.espec_docto.cod_espec_doc = tit_acr.cod_espec_doc NO-ERROR.
          IF LOOKUP(tit_acr.cod_espec_docto,"LP,LM") = 0       AND /* SSI 025/05 */
             emsuni.espec_docto.ind_tip_espec_docto <> 'Antecipaá∆o' THEN DO:
             
             ASSIGN de-vinculada = 0.
             RUN dop/dcr001a.p (tit_acr.cod_estab        , 
                                tit_acr.num_id_tit_acr   ,
                                dt-fim-periodo           ,
                                ""                       , /* Saldo do T°tulo na sua moeda original */
                                OUTPUT de-val-sdo-tit-acr).
    
             /* Recomp‰e Saldo do T°tulo com as Baixas de Cheques prÇ-datados n∆o liquidados */
             recomp-liq-cheque:
             FOR EACH movto_tit_acr OF tit_acr NO-LOCK
                WHERE movto_tit_acr.dat_transacao <= dt-fim-periodo
                  AND movto_tit_acr.log_ctbz_aprop_ctbl.
                IF dt-ini-periodo < 09/01/2005 THEN  /* N∆o recomp‰e saldo de liquidaá‰es com cheque se relat¢rio */
                   NEXT recomp-liq-cheque.           /* com Data inferior a 01/09/2005                            */
                FOR EACH relacto_cheq_acr NO-LOCK
                   WHERE relacto_cheq_acr.cod_estab            = movto_tit_acr.cod_estab
                     AND relacto_cheq_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr.

                   FIND FIRST cheq_acr OF relacto_cheq_acr NO-LOCK NO-ERROR.
                   FIND FIRST b-tit-cheque OF cheq_acr NO-LOCK NO-ERROR.

                   ASSIGN de-val-movto-cheque = IF movto_tit_acr.val_movto_tit_acr < relacto_cheq_acr.val_vincul_cheq_acr
                                                   THEN movto_tit_acr.val_movto_tit_acr
                                                   ELSE relacto_cheq_acr.val_vincul_cheq_acr.
                   IF AVAIL b-tit-cheque                                                                         AND
                     (b-tit-cheque.LOG_sdo_tit_acr                                                                OR 
                     (NOT b-tit-cheque.LOG_sdo_tit_acr AND b-tit-cheque.dat_liquidac_tit_acr > dt-fim-periodo)) THEN DO:
                      /* Neste caso os t°tulos continuar∆o na conta vinculada para acerto manual */
                      ASSIGN de-val-sdo-tit-acr = de-val-sdo-tit-acr + de-val-movto-cheque /* Chamado 5.404 */.  
                   END.
                END.
             END.
             /* FIM-Recomp‰e Saldo do T°tulo com as Baixas de Cheques prÇ-datados n∆o liquidados */
    
             IF tit_acr.cod_indic_econ = "Real" THEN DO:
                ASSIGN de-val-liq-base =  de-val-sdo-tit-acr * tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr
                       de-vinculada    =  de-val-liq-base                                             *
                                         (repres_tit_acr.val_perc_comis_repres                 / 100) *
                                        ((100 - repres_tit_acr.val_perc_comis_repres_emis)     / 100)
                       de-base-comis   =  de-vinculada / (repres_tit_acr.val_perc_comis_repres / 100).
             END.
             ELSE DO:
                FOR EACH movto_comis_repres NO-LOCK
                   WHERE movto_comis_repres.cod_estab              = tit_acr.cod_estab
                     AND movto_comis_repres.cdn_repres             = repres_tit_acr.cdn_repres
                     AND movto_comis_repres.num_id_tit_acr         = tit_acr.num_id_tit_acr
                     AND movto_comis_repres.ind_tip_movto          = 'N«O REALIZADO'
                     AND movto_comis_repres.ind_sit_movto_comis    = 'Liberado'
                     AND movto_comis_repres.ind_natur_lancto_ctbl  = 'CR':
                   ASSIGN de-vinculada  = de-vinculada  + movto_comis_repres.val_movto_comis
                          de-base-comis = de-base-comis + movto_comis_repres.val_base_calc_comis.
                END.
             END.
             
             IF de-vinculada <> 0 THEN DO:
                IF tit_acr.cod_indic_econ = "Real" THEN DO:
                   CREATE  tt-movto.
                   ASSIGN  tt-movto.cod_estab                  = tit_acr.cod_estab
                           tt-movto.num_id_tit_acr             = tit_acr.num_id_tit_acr        
                           tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                           tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                           tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                           tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                           tt-movto.cod_ccusto                 = c-cod_ccusto
                           tt-movto.num_seq_movto_comis        = 0
                           tt-movto.nom_pessoa                 = representante.nom_pessoa
                           tt-movto.cdn_cliente                = tit_acr.cdn_cliente
                           tt-movto.nom_cliente                = cliente.nom_pessoa
                           tt-movto.cod_empresa                = tit_acr.cod_empresa
                           tt-movto.cod_espec_docto            = tit_acr.cod_espec_docto
                           tt-movto.cod_ser_docto              = tit_acr.cod_ser_docto
                           tt-movto.cod_tit_acr                = tit_acr.cod_tit_acr
                           tt-movto.cod_parcela                = tit_acr.cod_parcela
                           tt-movto.dat_emis_docto             = tit_acr.dat_emis_docto
                           tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                           tt-movto.val_base_calc_comis        = de-base-comis.
        
                   ASSIGN  tt-movto.val_movto_vincul    = tt-movto.val_movto_vincul    + de-vinculada
                           tt-repres.de-tot-vincul[1]      = tt-repres.de-tot-vincul[1]      + de-vinculada.
        
                   IF  tt-movto.dat_emis_docto >= dt-ini-periodo    AND /* Comiss∆o Vinculada no Màs */
                       tt-movto.dat_emis_docto <= dt-fim-periodo   THEN DO:
                       IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN DO:
                           ASSIGN  tt-movto.val_movto_vincul_mes  = tt-movto.val_movto_vincul_mes + de-vinculada
                                   tt-repres.de-tot-vinc-mes[1]      = tt-repres.de-tot-vinc-mes[1]     + de-vinculada
                                   tt-movto.vincul-no-mes         = "*".
                       END. /* N∆o e VD ou VE */
                       ELSE DO:
                           ASSIGN da-emis-nota = 12/31/9999.
                           RUN dop/dco005e.p (INPUT tit_acr.cod_estab,
                                              INPUT tit_acr.cod_ser_doc,
                                              INPUT tit_acr.cod_tit_acr,
                                              OUTPUT da-emis-nota).
                           IF da-emis-nota >= dt-ini-periodo  AND     /* Considera Vinculada no Per°odo VD e VE se a nota estiver */
                              da-emis-nota <= dt-fim-periodo THEN DO: /* dentro da faixa de datas do relat¢rio                    */
                                                                      
                              ASSIGN tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + de-vinculada
                                     tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1]     + de-vinculada
                                     tt-movto.vincul-no-mes          = "*".
                           END. /* if da-emis-nota dentro da faixa de datas do relat¢rio */
                       END. /* Trata-se de VD ou VE */
                   END. /* T°tulo com Data de Emiss∆o dentro da faixa de datas do relat¢rio */
                END. /* if tit_acr.cod_indic_econ = "Real" */
                ELSE DO: /* SSI 071/06 */
                   FIND FIRST b-movto-ren OF tit_acr NO-LOCK 
                        WHERE b-movto-ren.ind_trans_acr_abrev = "REN" 
                          AND NOT b-movto-ren.log_movto_estordo NO-ERROR.
                   IF AVAIL b-movto-ren THEN DO:
                      ASSIGN c-cod-refer-ren = b-movto-ren.cod_refer
                             de-val-tot-ren  = 0.
                      FOR EACH b-movto-ren NO-LOCK 
                         WHERE b-movto-ren.cod_estab           = tit_acr.cod_estab
                           AND b-movto-ren.cod_refer           = c-cod-refer-ren
                           AND b-movto-ren.ind_trans_acr_abrev = "REN" 
                           AND NOT b-movto-ren.log_movto_estordo:
                         ASSIGN de-val-tot-ren = de-val-tot-ren + b-movto-ren.val_movto_tit_acr.
                      END.
    
                      FOR EACH b-movto-lqrn NO-LOCK
                         WHERE b-movto-lqrn.cod_estab           = tit_acr.cod_estab
                           AND b-movto-lqrn.cod_refer           = c-cod-refer-ren
                           AND b-movto-lqrn.ind_trans_acr_abrev = "LQRN"
                           AND NOT b-movto-lqrn.log_movto_estordo,
                         FIRST b-tit-lqrn OF b-movto-lqrn NO-LOCK.
    
                         ASSIGN de-vincul-lqrn     = ((de-vinculada   * b-movto-lqrn.val_movto_tit_acr) / de-val-tot-ren)
                               de-base-comis-lqrn = (de-vincul-lqrn / (repres_tit_acr.val_perc_comis_repres / 100)).

                         FIND FIRST tt-movto NO-LOCK
                              WHERE tt-movto.cod_estab      = b-tit-lqrn.cod_estab
                                AND tt-movto.num_id_tit_acr = b-tit-lqrn.num_id_tit_acr NO-ERROR.
                         IF NOT AVAIL tt-movto THEN DO:
                            CREATE  tt-movto.
                            ASSIGN  tt-movto.cod_estab                  = b-tit-lqrn.cod_estab
                                    tt-movto.num_id_tit_acr             = b-tit-lqrn.num_id_tit_acr
                                    tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                                    tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                                    tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                                    tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                                    tt-movto.cod_ccusto                 = c-cod_ccusto
                                    tt-movto.num_seq_movto_comis        = 0
                                    tt-movto.nom_pessoa                 = representante.nom_pessoa
                                    tt-movto.cdn_cliente                = b-tit-lqrn.cdn_cliente
                                    tt-movto.nom_cliente                = cliente.nom_pessoa
                                    tt-movto.cod_empresa                = b-tit-lqrn.cod_empresa
                                    tt-movto.cod_espec_docto            = b-tit-lqrn.cod_espec_docto
                                    tt-movto.cod_ser_docto              = b-tit-lqrn.cod_ser_docto
                                    tt-movto.cod_tit_acr                = b-tit-lqrn.cod_tit_acr
                                    tt-movto.cod_parcela                = b-tit-lqrn.cod_parcela
                                    tt-movto.dat_emis_docto             = b-tit-lqrn.dat_emis_docto
                                    tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr.
                         END.
        
                         ASSIGN  tt-movto.val_movto_vincul    = tt-movto.val_movto_vincul    + de-vincul-lqrn
                                 tt-repres.de-tot-vincul[1]      = tt-repres.de-tot-vincul[1]      + de-vincul-lqrn.
    
                         IF  tt-movto.dat_emis_docto >= dt-ini-periodo    AND /* Comiss∆o Vinculada no Màs */            
                             tt-movto.dat_emis_docto <= dt-fim-periodo   THEN DO:                                        
                             ASSIGN  tt-movto.val_movto_vincul_mes  = tt-movto.val_movto_vincul_mes + de-vincul-lqrn
                                     tt-repres.de-tot-vinc-mes[1]      = tt-repres.de-tot-vinc-mes[1]     + de-vincul-lqrn
                                     tt-movto.vincul-no-mes         = "*".                                           
                         END.
                      END. /* for each b-movto-lqrn */
                   END. /* if avail b-movto-ren */
                   ELSE DO: /* N∆o foi renegociada */ 
                      CREATE  tt-movto.
                      ASSIGN  tt-movto.cod_estab                  = tit_acr.cod_estab
                              tt-movto.num_id_tit_acr             = tit_acr.num_id_tit_acr
                              tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                              tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                              tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                              tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                              tt-movto.cod_ccusto                 = c-cod_ccusto
                              tt-movto.num_seq_movto_comis        = 0
                              tt-movto.nom_pessoa                 = representante.nom_pessoa
                              tt-movto.cdn_cliente                = tit_acr.cdn_cliente
                              tt-movto.nom_cliente                = cliente.nom_pessoa
                              tt-movto.cod_empresa                = tit_acr.cod_empresa
                              tt-movto.cod_espec_docto            = tit_acr.cod_espec_docto
                              tt-movto.cod_ser_docto              = tit_acr.cod_ser_docto
                              tt-movto.cod_tit_acr                = tit_acr.cod_tit_acr
                              tt-movto.cod_parcela                = tit_acr.cod_parcela
                              tt-movto.dat_emis_docto             = tit_acr.dat_emis_docto
                              tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                              tt-movto.val_base_calc_comis        = de-base-comis-lqrn.
    
                      ASSIGN  tt-movto.val_movto_vincul    = tt-movto.val_movto_vincul    + de-vinculada
                              tt-repres.de-tot-vincul[1]      = tt-repres.de-tot-vincul[1]      + de-vinculada.
    
                      IF  tt-movto.dat_emis_docto >= dt-ini-periodo    AND /* Comiss∆o Vinculada no Màs */            
                          tt-movto.dat_emis_docto <= dt-fim-periodo   THEN DO:                                        
                          ASSIGN  tt-movto.val_movto_vincul_mes  = tt-movto.val_movto_vincul_mes + de-vinculada
                                  tt-repres.de-tot-vinc-mes[1]      = tt-repres.de-tot-vinc-mes[1]     + de-vinculada
                                  tt-movto.vincul-no-mes         = "*".                                           
                      END.
                   END. /* FIM-N∆o foi renegociada */
                END. /* tit_acr.cod_indic_econ <> "Real" */
                /* FIM-SSI 071/06 */
             END. /* if de-vinculada <> 0 */
          END. /* if <> antecipaá∆o */
          /* FIM-Comiss∆o Vinculada Final do Per°odo */
       END. /* for each repres_tit_acr */
    
       /* Abre os Valores de Comiss‰es nos t°tulos originais - n∆o renegociados - SSI 071/06 */
       IF tt-repres.cod_tip_repres = "EXP" THEN DO:
          /* Chamado 489 */
          FOR EACH tt-movto USE-INDEX cod_empresa
             WHERE tt-movto.cod_empresa      = tt-estabelecimento.cod_empresa
               AND tt-movto.cod_estab        = tt-estabelecimento.cod_estab
               AND tt-movto.cdn_repres       = tt-repres.cdn_repres
               AND tt-movto.cod_espec_docto  = "CR": /* Cambiais Recebidas substituem a DM */
    
             FIND FIRST tit_acr NO-LOCK
                  WHERE tit_acr.cod_estab       = tt-movto.cod_estab
                    AND tit_acr.cod_espec_docto = tt-movto.cod_espec_docto
                    AND tit_acr.cod_ser_docto   = tt-movto.cod_ser_docto
                    AND tit_acr.cod_tit_acr     = tt-movto.cod_tit_acr
                    AND tit_acr.cod_parcela     = tt-movto.cod_parcela NO-ERROR.
    
             FIND FIRST b-movto-ren OF tit_acr NO-LOCK 
                  WHERE b-movto-ren.ind_trans_acr_abrev = "REN" 
                    AND NOT b-movto-ren.log_movto_estordo NO-ERROR.
    
             IF AVAIL b-movto-ren THEN DO:
                FOR EACH b-movto-lqrn NO-LOCK                                        
                   WHERE b-movto-lqrn.cod_estab           = tt-movto.cod_estab
                     AND b-movto-lqrn.cod_refer           = b-movto-ren.cod_refer
                     AND b-movto-lqrn.ind_trans_acr_abrev = "LQRN"
                     AND NOT b-movto-lqrn.log_movto_estordo,                  
                   FIRST b-tit-lqrn OF b-movto-lqrn NO-LOCK.                         
    
                   FIND FIRST emsuni.cliente NO-LOCK 
                        WHERE emsuni.cliente.cod_empresa = b-tit-lqrn.cod_empresa 
                          AND emsuni.cliente.cdn_cliente = b-tit-lqrn.cdn_cliente NO-ERROR.
    
                   FIND FIRST b-tt-movto NO-LOCK
                        WHERE b-tt-movto.cod_estab                  = b-tit-lqrn.cod_estab
                          AND b-tt-movto.num_id_tit_acr             = b-tit-lqrn.num_id_tit_acr NO-ERROR.
    
                   IF NOT AVAIL b-tt-movto THEN DO:
                      CREATE  b-tt-movto.
                      ASSIGN  b-tt-movto.cod_estab                  = b-tit-lqrn.cod_estab
                              b-tt-movto.num_id_tit_acr             = b-tit-lqrn.num_id_tit_acr
                              b-tt-movto.cod_empresa                = b-tit-lqrn.cod_empresa
                              b-tt-movto.cod_espec_docto            = b-tit-lqrn.cod_espec_docto
                              b-tt-movto.cod_ser_docto              = b-tit-lqrn.cod_ser_docto
                              b-tt-movto.cod_tit_acr                = b-tit-lqrn.cod_tit_acr
                              b-tt-movto.cod_parcela                = b-tit-lqrn.cod_parcela
                              b-tt-movto.dat_emis_docto             = b-tit-lqrn.dat_emis_docto
        
                              b-tt-movto.cdn_cliente                = b-tit-lqrn.cdn_cliente
                              b-tt-movto.nom_pessoa                 = tt-movto.nom_pessoa
                              b-tt-movto.nom_cliente                = emsuni.cliente.nom_pessoa
        
                              b-tt-movto.cdn_repres                 = tt-movto.cdn_repres
                              b-tt-movto.val_perc_comis             = tt-movto.val_perc_comis_repres
                              b-tt-movto.val_perc_comis_repres      = tt-movto.val_perc_comis_repres
                              b-tt-movto.val_perc_comis_repres_emis = tt-movto.val_perc_comis_repres_emis
                              b-tt-movto.cod_ccusto                 = tt-movto.cod_ccusto
                              b-tt-movto.num_seq_movto_comis        = tt-movto.num_seq_movto_comis
                              b-tt-movto.dat_vencto_tit_acr         = tt-movto.dat_vencto_tit_acr.
                   END.
    
                   ASSIGN b-tt-movto.val_movto_comis            = b-tt-movto.val_movto_comis      + ((tt-movto.val_movto_comis      * b-tit-lqrn.val_origin_tit_acr) / tit_acr.val_origin_tit_acr)
                          b-tt-movto.val_movto_estorno          = b-tt-movto.val_movto_estorno    + ((tt-movto.val_movto_estorno    * b-tit-lqrn.val_origin_tit_acr) / tit_acr.val_origin_tit_acr)
                          b-tt-movto.val_movto_vincul           = b-tt-movto.val_movto_vincul     + ((tt-movto.val_movto_vincul     * b-tit-lqrn.val_origin_tit_acr) / tit_acr.val_origin_tit_acr)
                          b-tt-movto.val_movto_vincul_mes       = b-tt-movto.val_movto_vincul_mes + ((tt-movto.val_movto_vincul_mes * b-tit-lqrn.val_origin_tit_acr) / tit_acr.val_origin_tit_acr)
                          b-tt-movto.val_base_calc_comis        = b-tt-movto.val_base_calc_comis  + ((tt-movto.val_base_calc_comis  * b-tit-lqrn.val_origin_tit_acr) / tit_acr.val_origin_tit_acr).
                   
                END. /* FOR EACH b-movto-lqrn */
                DELETE tt-movto.
             END. /* IF AVAIL b-movto-ren */
          END.
          /* FIM-Chamado 489 */
    
          FOR EACH tt-movto USE-INDEX cod_empresa
             WHERE tt-movto.cod_empresa      = tt-estabelecimento.cod_empresa
               AND tt-movto.cod_estab        = tt-estabelecimento.cod_estab
               AND tt-movto.cdn_repres       = tt-repres.cdn_repres
               AND tt-movto.val_movto_vincul = 0.
    
             FIND FIRST tit_acr NO-LOCK
                  WHERE tit_acr.cod_estab       = tt-movto.cod_estab
                    AND tit_acr.cod_espec_docto = tt-movto.cod_espec_docto
                    AND tit_acr.cod_ser_docto   = tt-movto.cod_ser_docto
                    AND tit_acr.cod_tit_acr     = tt-movto.cod_tit_acr
                    AND tit_acr.cod_parcela     = tt-movto.cod_parcela NO-ERROR.
    
             FIND FIRST b-movto-ren OF tit_acr NO-LOCK 
                  WHERE b-movto-ren.ind_trans_acr_abrev = "REN" 
                    AND NOT b-movto-ren.log_movto_estordo NO-ERROR.
    
             /* Chamado 1264 */
             /* N∆o considera renegociaá‰es com origem na espÇcie CR */
             IF AVAIL b-movto-ren THEN
                FIND FIRST b-movto-lqrn NO-LOCK
                     WHERE b-movto-lqrn.cod_estab           = tt-movto.cod_estab
                       AND b-movto-lqrn.cod_refer           = b-movto-ren.cod_refer
                       AND b-movto-lqrn.ind_trans_acr_abrev = "LQRN"
                       AND b-movto-lqrn.cod_espec_docto     = "CR" /* Cambiais Recebidas */
                       AND NOT b-movto-lqrn.log_movto_estordo NO-ERROR.
             
             IF AVAIL b-movto-ren       AND 
                NOT AVAIL b-movto-lqrn THEN DO: /* FIM- Chamado 1264 */
    
                ASSIGN c-cod-refer-ren = b-movto-ren.cod_refer
                       de-val-tot-ren  = 0.
                FOR EACH b-movto-ren NO-LOCK 
                   WHERE b-movto-ren.cod_estab           = tt-movto.cod_estab
                     AND b-movto-ren.cod_refer           = c-cod-refer-ren
                     AND b-movto-ren.ind_trans_acr_abrev = "REN" 
                     AND NOT b-movto-ren.log_movto_estordo:
                   ASSIGN de-val-tot-ren = de-val-tot-ren + b-movto-ren.val_movto_tit_acr.
                END.
    
                FOR EACH b-movto-lqrn NO-LOCK                                        
                   WHERE b-movto-lqrn.cod_estab           = tt-movto.cod_estab
                     AND b-movto-lqrn.cod_refer           = c-cod-refer-ren
                     AND b-movto-lqrn.ind_trans_acr_abrev = "LQRN"
                     AND NOT b-movto-lqrn.log_movto_estordo,                  
                   FIRST b-tit-lqrn OF b-movto-lqrn NO-LOCK.                         
                                                                                     
                   FIND FIRST emsuni.cliente NO-LOCK 
                        WHERE emsuni.cliente.cod_empresa = b-tit-lqrn.cod_empresa 
                          AND emsuni.cliente.cdn_cliente = b-tit-lqrn.cdn_cliente NO-ERROR.
    
                   FIND FIRST b-tt-movto NO-LOCK
                        WHERE b-tt-movto.cod_estab                  = b-tit-lqrn.cod_estab
                          AND b-tt-movto.num_id_tit_acr             = b-tit-lqrn.num_id_tit_acr NO-ERROR.
    
                   IF NOT AVAIL b-tt-movto THEN DO:
                      CREATE  b-tt-movto.
                      ASSIGN  b-tt-movto.cod_estab                  = b-tit-lqrn.cod_estab
                              b-tt-movto.num_id_tit_acr             = b-tit-lqrn.num_id_tit_acr
                              b-tt-movto.cod_empresa                = b-tit-lqrn.cod_empresa
                              b-tt-movto.cod_espec_docto            = b-tit-lqrn.cod_espec_docto
                              b-tt-movto.cod_ser_docto              = b-tit-lqrn.cod_ser_docto
                              b-tt-movto.cod_tit_acr                = b-tit-lqrn.cod_tit_acr
                              b-tt-movto.cod_parcela                = b-tit-lqrn.cod_parcela
                              b-tt-movto.dat_emis_docto             = b-tit-lqrn.dat_emis_docto
        
                              b-tt-movto.cdn_cliente                = b-tit-lqrn.cdn_cliente
                              b-tt-movto.nom_pessoa                 = tt-movto.nom_pessoa
                              b-tt-movto.nom_cliente                = emsuni.cliente.nom_pessoa
        
                              b-tt-movto.cdn_repres                 = tt-movto.cdn_repres
                              b-tt-movto.val_perc_comis             = tt-movto.val_perc_comis_repres
                              b-tt-movto.val_perc_comis_repres      = tt-movto.val_perc_comis_repres
                              b-tt-movto.val_perc_comis_repres_emis = tt-movto.val_perc_comis_repres_emis
                              b-tt-movto.cod_ccusto                 = tt-movto.cod_ccusto
                              b-tt-movto.num_seq_movto_comis        = tt-movto.num_seq_movto_comis
                              b-tt-movto.dat_vencto_tit_acr         = tt-movto.dat_vencto_tit_acr
                              b-tt-movto.vincul-no-mes              = IF b-tit-lqrn.dat_emis_docto >= dt-ini-periodo AND
                                                                         b-tit-lqrn.dat_emis_docto <= dt-fim-periodo 
                                                                         THEN "*"
                                                                         ELSE "".
                   END.
    
                   ASSIGN b-tt-movto.val_movto_comis            = b-tt-movto.val_movto_comis      + ((tt-movto.val_movto_comis      * b-tit-lqrn.val_origin_tit_acr) / de-val-tot-ren)
                          b-tt-movto.val_movto_estorno          = b-tt-movto.val_movto_estorno    + ((tt-movto.val_movto_estorno    * b-tit-lqrn.val_origin_tit_acr) / de-val-tot-ren)
                          b-tt-movto.val_movto_vincul_mes       = b-tt-movto.val_movto_vincul_mes + ((tt-movto.val_movto_vincul_mes * b-tit-lqrn.val_origin_tit_acr) / de-val-tot-ren)
                          b-tt-movto.val_base_calc_comis        = b-tt-movto.val_base_calc_comis  + ((tt-movto.val_base_calc_comis  * b-tit-lqrn.val_origin_tit_acr) / de-val-tot-ren).
    
                END. /* FOR EACH b-movto-lqrn */
                DELETE tt-movto.
             END. /* IF AVAIL b-movto-ren */
          END. /* FOR EACH tt-movto */
       END. /* IF tt-repres.cod_tip_repres = "EXP" */
       /* FIM-Abre os Valores de Comiss‰es nos t°tulos originais - n∆o renegociados - SSI 071/06 */
   END.
END. /* for each tt_empresa */

IF  v_num_ped_exec_corren = 0 THEN DO:
    RUN pi-acompanhar IN h-acomp (INPUT "Verificando Cheques Recebidos").
END.

bloco-cheques:
FOR EACH tt-empresa NO-LOCK,
    EACH emsuni.espec_docto NO-LOCK
   WHERE emsuni.espec_docto.ind_tip_espec_docto = 'Cheques Recebidos',
    EACH tt-estabelecimento NO-LOCK
   WHERE tt-estabelecimento.cod_empresa = tt-empresa.cod_empresa:

   IF tg-gera-movto-comis THEN DO:
      /* Estorna Comiss∆o dos T°tulos pagos com Cheque que n∆o foram baixados */
      cheque-em-aberto: /* Pesquisa Cheques em Aberto */
      FOR EACH b-tit-cheque NO-LOCK
         WHERE b-tit-cheque.cod_espec_doc              = emsuni.espec_docto.cod_espec_docto
           AND b-tit-cheque.cod_estab                  = tt-estabelecimento.cod_estab
           AND b-tit-cheque.LOG_sdo_tit_acr.
         
         /* Somente trata l¢gica de cheques para t°tulos em Real */
         IF b-tit-cheque.cod_indic_econ <> "Real" THEN NEXT cheque-em-aberto.

         FIND FIRST cheq_acr OF b-tit-cheque NO-LOCK NO-ERROR.
         IF AVAIL cheq_acr THEN DO:
            FOR EACH relacto_cheq_acr OF cheq_acr NO-LOCK.
               FIND FIRST movto_tit_acr NO-LOCK
                    WHERE movto_tit_acr.cod_estab            = relacto_cheq_acr.cod_estab
                      AND movto_tit_acr.num_id_movto_tit_acr = relacto_cheq_acr.num_id_movto_tit_acr NO-ERROR.

               /* Chamado 5.404 - N∆o Ç poss°vel estornar liquidaá‰es com cheque pagas se v†rios cheques foram usados para apenas uma liquidaá∆o */
               ASSIGN i-cheques-da-baixa = 0.
               FOR EACH b-relacto_cheq_acr NO-LOCK
                  WHERE b-relacto_cheq_acr.cod_estab            = movto_tit_acr.cod_estab
                    AND b-relacto_cheq_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr.
                  ASSIGN i-cheques-da-baixa = i-cheques-da-baixa + 1.
               END.
               IF i-cheques-da-baixa > 1 THEN NEXT.
               /* FIM-Chamado 5.404 - N∆o Ç poss°vel estornar liquidaá‰es com cheque pagas se v†rios cheques foram usados para apenas uma liquidaá∆o */

               IF AVAIL movto_tit_acr THEN DO:
                  FOR EACH movto_comis_repres NO-LOCK
                     WHERE movto_comis_repres.cod_estab            = movto_tit_acr.cod_estab
                       AND movto_comis_repres.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                       AND movto_comis_repres.dat_transacao        = movto_tit_acr.dat_transacao
                       AND movto_comis_repres.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr.
                     FOR EACH dc-orig-comis-movto NO-LOCK
                        WHERE dc-orig-comis-movto.cod_empresa         = movto_comis_repres.cod_empresa
                          AND dc-orig-comis-movto.cdn_repres          = movto_comis_repres.cdn_repres
                          AND dc-orig-comis-movto.num_seq_movto_comis = movto_comis_repres.num_seq_movto_comis
                          AND dc-orig-comis-movto.ind_tip_movto      <> "Estornado",
                        FIRST dc-comis-movto OF dc-orig-comis-movto NO-LOCK.
                        FIND FIRST dc-comis-trans NO-LOCK
                             WHERE dc-comis-trans.cod_transacao   = dc-comis-movto.cod_transacao
                               AND dc-comis-trans.dat_inic_valid <= dc-comis-movto.dat_transacao
                               AND dc-comis-trans.dat_fim_valid  >= dc-comis-movto.dat_transacao NO-ERROR.
                        IF dc-comis-trans.ind_incid_liquido = "Positivo" THEN DO:
                           FIND LAST b-dc-comis-trans NO-LOCK
                               WHERE b-dc-comis-trans.cod_transacao = 35 NO-ERROR. /* Estorno Comiss∆o com cheque */
                           IF AVAIL b-dc-comis-trans THEN DO:
                              FIND FIRST tit_acr OF dc-orig-comis-movto NO-LOCK NO-ERROR.
                              ASSIGN c-cod_ccusto = ''.
                              IF b-dc-comis-trans.cod_ccusto = ? THEN DO:
                                 FIND FIRST dc-repres NO-LOCK 
                                      WHERE dc-repres.cod_empresa = dc-comis-movto.cod_empresa 
                                        AND dc-repres.cdn_repres  = dc-comis-movto.cdn_repres NO-ERROR.
                                 IF AVAIL dc-repres THEN
                                    ASSIGN c-cod_ccusto = dc-repres.cod_ccusto.
                              END.
                              ELSE
                                 ASSIGN c-cod_ccusto = b-dc-comis-trans.cod_ccusto.
                              CREATE b-dc-comis-movto.
                              ASSIGN b-dc-comis-movto.cod_empresa              = dc-comis-movto.cod_empresa
                                     b-dc-comis-movto.cdn_repres               = dc-comis-movto.cdn_repres
                                     b-dc-comis-movto.cod_transacao            = b-dc-comis-trans.cod_transacao
                                     b-dc-comis-movto.dat_transacao            = dt-fim-periodo
                                     b-dc-comis-movto.des_transacao            = b-dc-comis-trans.descricao +
                                                                                 ' ' + tit_acr.cod_estab       + '-' + 
                                                                                       tit_acr.cod_espec_docto + '-' + 
                                                                                       tit_acr.cod_ser_docto   + '-' + 
                                                                                       tit_acr.cod_tit_acr     + '-' + 
                                                                                       tit_acr.cod_parcela
                                     b-dc-comis-movto.cod_plano_cta_ctbl       = b-dc-comis-trans.cod_plano_cta_ctbl
                                     b-dc-comis-movto.cod_cta_ctbl             = b-dc-comis-trans.cod_cta_ctbl
                                     b-dc-comis-movto.cod_plano_ccusto         = b-dc-comis-trans.cod_plano_ccusto  
                                     b-dc-comis-movto.cod_ccusto               = c-cod_ccusto
                                     b-dc-comis-movto.ind_origin_movto         = "dco005"
                                     b-dc-comis-movto.val_movto                = dc-orig-comis-movto.val_movto.
                              CREATE b-dc-orig-comis-movto.
                              BUFFER-COPY dc-orig-comis-movto EXCEPT dat_transacao num_id_comis_movto TO b-dc-orig-comis-movto.
                              ASSIGN b-dc-orig-comis-movto.num_id_comis_movto  = b-dc-comis-movto.num_id_comis_movto
                                     b-dc-orig-comis-movto.dat_transacao       = b-dc-comis-movto.dat_transacao.
    
                              FIND FIRST b-dc-orig-comis-movto EXCLUSIVE-LOCK 
                                   WHERE b-dc-orig-comis-movto.num_id_comis_movto  = dc-orig-comis-movto.num_id_comis_movto
                                     AND b-dc-orig-comis-movto.num_seq_movto_comis = dc-orig-comis-movto.num_seq_movto_comis NO-ERROR.
                              ASSIGN b-dc-orig-comis-movto.ind_tip_movto  = "Estornado".
    
                           END. /* if avail b-dc-comis-trans */
                        END. /* if dc-comis-trans.ind_incid_liquido */
                     END. /* for each dc-orig-comis-movto */
                  END. /* for each movto_comis_repres */
               END. /* if avail movto_tit_acr */
            END. /* for each relacto_cheq_acr */
         END. /* if avail cheq_acr */
      END. /* for each b-tit-cheque */
   END. /* if tg-gera-movto-comis */

   /* Credita Comiss‰es de Cheques PrÇ-datados Liquidados */
   cheque-liquidado: /* Pesquisa Cheques totalmente liquidados no per°odo */
   FOR EACH b-tit-cheque NO-LOCK
      WHERE b-tit-cheque.cod_espec_doc         = emsuni.espec_docto.cod_espec_docto
        AND b-tit-cheque.cod_estab             = tt-estabelecimento.cod_estab
        AND b-tit-cheque.dat_liquidac_tit_acr >= dt-ini-periodo
        AND b-tit-cheque.dat_liquidac_tit_acr <= dt-fim-periodo
        AND NOT b-tit-cheque.LOG_sdo_tit_acr.

      /* Somente trata l¢gica de cheques para t°tulos em Real */
      IF b-tit-cheque.cod_indic_econ <> "Real" THEN NEXT cheque-liquidado.

      ASSIGN de-tot-liq         = 0
             de-tot-dev         = 0
             de-tot-des         = 0
             de-tot-lucr-perdas = 0.

      {doinc/dco005rp.i5}

/*       /* Se soma das liquidaá‰es, devoluá∆o e descontos n∆o fechar com o valor original do t°tulo desconsidera */  */
/*       /* Neste caso os t°tulos continuar∆o na conta vinculada para acerto manual                               */  */
/*       IF b-tit-cheque.val_origin_tit_acr <> de-tot-liq + de-tot-dev + de-tot-des THEN                              */
/*          NEXT cheque-liquidado.                                                                                    */

      FIND FIRST cheq_acr OF b-tit-cheque NO-LOCK NO-ERROR.
      IF AVAIL cheq_acr THEN DO:
         relacto_cheq_acr:
         FOR EACH relacto_cheq_acr OF cheq_acr NO-LOCK.
            FIND FIRST b-movto_tit_acr NO-LOCK
                 WHERE b-movto_tit_acr.cod_estab            = relacto_cheq_acr.cod_estab
                   AND b-movto_tit_acr.num_id_movto_tit_acr = relacto_cheq_acr.num_id_movto_tit_acr NO-ERROR.
            IF AVAIL b-movto_tit_acr THEN DO:

/*                IF b-movto_tit_acr.dat_transacao < 09/01/2005 THEN /* Liquidaá‰es com cheque inferiores a 01/09/2005 foram todas  */  */
/*                   NEXT relacto_cheq_acr.                          /* pagas aos representantes na liquidaá∆o do t°tulo original   */  */

               FIND FIRST movto_comis_repres USE-INDEX  mvtcmsrp_titacr NO-LOCK
                    WHERE movto_comis_repres.cod_estab            = b-movto_tit_acr.cod_estab
                      AND movto_comis_repres.num_id_tit_acr       = b-movto_tit_acr.num_id_tit_acr
                      AND movto_comis_repres.dat_transacao        = b-movto_tit_acr.dat_transacao
                      AND movto_comis_repres.num_id_movto_tit_acr = b-movto_tit_acr.num_id_movto_tit_acr
                      AND movto_comis_repres.val_movto_comis     <> 0 NO-ERROR.

               IF NOT AVAIL movto_comis_repres THEN 
                  NEXT relacto_cheq_acr.
               IF LOOKUP(STRING(movto_comis_repres.cdn_repres),c-lista-cdn-repres) = 0 THEN 
                  NEXT relacto_cheq_acr.

               FIND FIRST b-tit_acr OF b-movto_tit_acr NO-LOCK NO-ERROR.

               IF LOOKUP(TRIM(b-tit_acr.cod_espec_docto),c-lista-cod-esp) = 0 OR
                  b-tit_acr.cdn_cliente < i-ini-cliente                       OR
                  b-tit_acr.cdn_cliente > i-fim-cliente                       OR
                  b-tit_acr.cod_refer   < c-ini-referencia                    OR
                  b-tit_acr.cod_refer   > c-fim-referencia                  THEN
                  NEXT relacto_cheq_acr.

               FIND FIRST repres_tit_acr NO-LOCK
                    WHERE repres_tit_acr.cod_estab                   = b-tit_acr.cod_estab     
                      AND repres_tit_acr.num_id_tit_acr              = b-tit_acr.num_id_tit_acr
                      AND repres_tit_acr.cdn_repres                  = movto_comis_repres.cdn_repres 
                      AND repres_tit_acr.val_perc_comis_repres      <> 0               
                      AND repres_tit_acr.val_perc_comis_repres_emis >= i-ini-perc-comis
                      AND repres_tit_acr.val_perc_comis_repres_emis <= i-fim-perc-comis NO-ERROR.
               IF NOT AVAIL repres_tit_acr THEN
                  NEXT relacto_cheq_acr.

               FIND FIRST tt-repres
                    WHERE tt-repres.cod_empresa = tt-empresa.cod_empresa
                      AND tt-repres.cdn_repres  = movto_comis_repres.cdn_repres NO-ERROR.
               IF NOT AVAIL tt-repres THEN
                  NEXT relacto_cheq_acr.

               IF LOOKUP(b-tit_acr.cod_espec_docto,"LP,LM")  = 0                            OR
                 (LOOKUP(b-tit_acr.cod_espec_docto,"LP,LM") <> 0 AND tt-repres.log_ativo) THEN DO: /*  SSI 025/05 */

                  FIND FIRST emsuni.cliente NO-LOCK
                       WHERE cliente.cod_empresa = b-tit_acr.cod_empresa
                         AND cliente.cdn_cliente = b-tit_acr.cdn_cliente NO-ERROR.
    
                  RUN dop/dco005a.p (repres_tit_acr.cod_empresa   ,
                                     repres_tit_acr.cdn_repres    ,
                                     b-tit_acr.cod_estab          , 
                                     b-tit_acr.num_id_tit_acr     , 
                                     OUTPUT c-cod_ccusto          ).

                  /* Chamado 5.404 - Problema de um liquidaá∆o com v†rios cheques estava pagando a comiss∆o integral do t°tulo para cada cheque usado na baixa */
                  ASSIGN de-tot-cheques-baixa = 0
                         i-cheques-da-baixa   = 0.
                  FOR EACH b-relacto_cheq_acr NO-LOCK
                     WHERE b-relacto_cheq_acr.cod_estab            = b-movto_tit_acr.cod_estab
                       AND b-relacto_cheq_acr.num_id_movto_tit_acr = b-movto_tit_acr.num_id_movto_tit_acr.
                     ASSIGN de-tot-cheques-baixa = de-tot-cheques-baixa + b-relacto_cheq_acr.val_vincul_cheq_acr
                            i-cheques-da-baixa   = i-cheques-da-baixa   + 1.
                  END.
                  /* FIM - Chamado 5.404 */

                  /* Somente Ç poss°vel fazer esta verificaá∆o baixas com apenas 1 cheque - Problema fechamento 05/09/20111 */
                  IF i-cheques-da-baixa = 1 THEN DO:
                     FOR EACH dc-orig-comis-movto NO-LOCK
                        WHERE dc-orig-comis-movto.cod_empresa         = movto_comis_repres.cod_empresa
                          AND dc-orig-comis-movto.cdn_repres          = movto_comis_repres.cdn_repres
                          AND dc-orig-comis-movto.num_seq_movto_comis = movto_comis_repres.num_seq_movto_comis
                          AND dc-orig-comis-movto.ind_tip_movto      <> "Estornado",
                        FIRST dc-comis-movto OF dc-orig-comis-movto NO-LOCK
                        WHERE dc-comis-movto.flag-contabilizou.
                        FIND FIRST dc-comis-trans NO-LOCK
                             WHERE dc-comis-trans.cod_transacao   = dc-comis-movto.cod_transacao
                               AND dc-comis-trans.dat_inic_valid <= dc-comis-movto.dat_transacao
                               AND dc-comis-trans.dat_fim_valid  >= dc-comis-movto.dat_transacao NO-ERROR.
                        IF tg-gera-movto-comis                            AND
                           dc-comis-trans.ind_incid_liquido = "Positivo" THEN /* Desconsidera se comiss∆o j† tiver sido paga */
                           NEXT relacto_cheq_acr.
                     END.
                  END.
                  /* FIM-Somente Ç poss°vel fazer esta verificaá∆o baixas com apenas 1 cheque */

                  CREATE  tt-movto.
                  ASSIGN  tt-movto.num_id_tit_acr             = movto_comis_repres.num_id_tit_acr        
                          tt-movto.num_seq_movto_comis        = movto_comis_repres.num_seq_movto_comis   
                          tt-movto.cdn_repres                 = repres_tit_acr.cdn_repres
                          tt-movto.nom_pessoa                 = tt-repres.nom_pessoa
                          tt-movto.cdn_cliente                = b-tit_acr.cdn_cliente
                          tt-movto.nom_cliente                = emsuni.cliente.nom_pessoa
                          tt-movto.cod_empresa                = b-tit_acr.cod_empresa
                          tt-movto.cod_estab                  = b-tit_acr.cod_estab
                          tt-movto.cod_espec_docto            = b-tit_acr.cod_espec_docto
                          tt-movto.cod_ser_docto              = b-tit_acr.cod_ser_docto
                          tt-movto.cod_tit_acr                = b-tit_acr.cod_tit_acr
                          tt-movto.cod_parcela                = b-tit_acr.cod_parcela
                          tt-movto.dat_emis_docto             = b-tit_acr.dat_emis_docto
                          tt-movto.dat_vencto_tit_acr         = b-tit_acr.dat_vencto_tit_acr
                          tt-movto.dat_liquidac_tit_acr       = b-tit-cheque.dat_liquidac_tit_acr
                          tt-movto.val_perc_comis_repres      = repres_tit_acr.val_perc_comis_repres
                          tt-movto.val_perc_comis_repres_emis = repres_tit_acr.val_perc_comis_repres_emis
                          tt-movto.val_base_calc_comis        = movto_comis_repres.val_base_calc_comis
                          tt-movto.val_perc_comis             = repres_tit_acr.val_perc_comis_repres
                          tt-movto.cod_ccusto                 = c-cod_ccusto.

                  IF i-cheques-da-baixa > 1 THEN /* Chamado 5.404 */
                     ASSIGN tt-movto.val_movto_comis          = ((de-tot-liq + de-tot-dev + de-tot-des + de-tot-lucr-perdas) * movto_comis_repres.val_movto_comis) / 
                                                                  de-tot-cheques-baixa.
                  ELSE
                     ASSIGN tt-movto.val_movto_comis          = ((de-tot-liq + de-tot-dev + de-tot-des + de-tot-lucr-perdas) * movto_comis_repres.val_movto_comis) / 
                                                                  b-tit-cheque.val_origin_tit_acr.
                  /* FIM - Chamado 5.404 */
                  

                  IF LOOKUP(b-tit_acr.cod_espec_docto,"LP,LM") <> 0 THEN DO: /*  SSI 025/05 */
                     IF tt-repres.log_ativo THEN
                        ASSIGN  tt-repres.de-tot-pg-lp-lm[1] = tt-repres.de-tot-pg-lp-lm[1] + movto_comis_repres.val_movto_comis.
                  END.
                  ELSE DO:
                     ASSIGN tt-repres.de-tot-pg-baixa[1] = tt-repres.de-tot-pg-baixa[1] + tt-movto.val_movto_comis.
                  END.

                  IF de-tot-dev + de-tot-des + de-tot-lucr-perdas <> 0 THEN /* de-tot-lucr-perdas - Chamado 1523 */
                     ASSIGN  tt-movto.val_movto_estorno       = ((de-tot-dev + de-tot-des + de-tot-lucr-perdas) * movto_comis_repres.val_movto_comis) / 
                                                                  b-tit-cheque.val_origin_tit_acr
                             tt-repres.de-tot-pg-estor[1]        =   tt-repres.de-tot-pg-estor[1]  + tt-movto.val_movto_estorno.
    
                  IF tt-movto.dat_emis_docto >= dt-ini-periodo    AND /* Comiss∆o Vinculada no Màs */
                     tt-movto.dat_emis_docto <= dt-fim-periodo   THEN DO:
                     IF LOOKUP(b-tit_acr.cod_espec_docto,"VD,VV") = 0 THEN DO:
                         ASSIGN  tt-movto.val_movto_vincul_mes  = tt-movto.val_movto_vincul_mes + de-vinculada
                                 tt-repres.de-tot-vinc-mes[1]      = tt-repres.de-tot-vinc-mes[1] + de-vinculada
                                 tt-movto.vincul-no-mes         = "*".
                     END. /* N∆o e VD ou VE */
                     ELSE DO:
                         ASSIGN da-emis-nota = 12/31/9999.
                         RUN dop/dco005e.p (INPUT b-tit_acr.cod_estab,
                                            INPUT b-tit_acr.cod_ser_doc,
                                            INPUT b-tit_acr.cod_tit_acr,
                                            OUTPUT da-emis-nota).
                         IF da-emis-nota >= dt-ini-periodo  AND     /* Considera Vinculada no Per°odo VD e VE se a nota estiver */
                            da-emis-nota <= dt-fim-periodo THEN DO: /* dentro da faixa de datas do relat¢rio                    */
                            ASSIGN tt-movto.val_movto_vincul_mes   = tt-movto.val_movto_vincul_mes + de-vinculada
                                   tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1]     + de-vinculada
                                   tt-movto.vincul-no-mes          = "*".
                         END. /* if da-emis-nota dentro da faixa de datas do relat¢rio */
                     END. /* Trata-se de VD ou VE */
                  END. /* T°tulo com Data de Emiss∆o dentro da faixa de datas do relat¢rio */
               END. /* Dif LP ou LM or Rep Ativo */
            END. /* if avail b-movto_tit_acr */
         END. /* for each relacto_cheq_acr */
      END. /* if avail cheq_acr */
   END. /* for each b-tit-cheque */
END. /* for each tt-empresa */
/* FIM-Credita Comiss‰es de Cheques PrÇ-datados Liquidados */

/* Tem que somar os t°tulos que foram jogados na transaá∆o 202 para o màs atual */
FIND dc-comis-trans NO-LOCK WHERE dc-comis-trans.cod_transacao = 202 NO-ERROR.
FOR EACH dc-comis-movto NO-LOCK
    WHERE dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao
    AND   dc-comis-movto.dat_transacao = dt-ini-periodo
    AND   LOOKUP(STRING(dc-comis-movto.cdn_repres),c-lista-cdn-repres) > 0:

    /* Verifica se representante est† em Rescis∆o */
    FIND FIRST b-dc-comis-movto NO-LOCK
         WHERE b-dc-comis-movto.cod_empresa    = dc-comis-movto.cod_empresa
           AND b-dc-comis-movto.cdn_repres     = dc-comis-movto.cdn_repres
           AND b-dc-comis-movto.cod_transacao  = 6 NO-ERROR.
    IF NOT AVAIL b-dc-comis-movto THEN
       FIND FIRST b-dc-comis-movto NO-LOCK
            WHERE b-dc-comis-movto.cod_empresa    = dc-comis-movto.cod_empresa
              AND b-dc-comis-movto.cdn_repres     = dc-comis-movto.cdn_repres
              AND b-dc-comis-movto.cod_transacao  = 11 NO-ERROR.
    IF AVAIL b-dc-comis-movto THEN NEXT.

    FOR EACH dc-orig-comis-movto OF dc-comis-movto NO-LOCK:

        FIND tit_acr OF dc-orig-comis-movto NO-LOCK NO-ERROR.

        FIND FIRST movto_comis_repres OF dc-orig-comis-movto NO-LOCK
             WHERE movto_comis_repres.ind_tip_movto         = "REALIZADO"
               AND movto_comis_repres.ind_natur_lancto_ctbl = "CR" NO-ERROR.

        /* Problema de perda de referencia para movimento de comiss∆o.
           Isto acontece quando Ç executado a geraá∆o batch de comiss‰es para um per°odo j† fechado */
        IF NOT AVAIL movto_comis_repres THEN DO ON ERROR UNDO, LEAVE:
            FIND FIRST movto_comis_repres NO-LOCK
                 WHERE movto_comis_repres.cod_estab             = tit_acr.cod_estab     
                   AND movto_comis_repres.num_id_tit_acr        = tit_acr.num_id_tit_acr
                   AND movto_comis_repres.ind_tip_movto         = "REALIZADO"
                   AND movto_comis_repres.ind_natur_lancto_ctbl = "CR"
                   AND movto_comis_repres.val_movto_comis       = dc-orig-comis-movto.val_movto_comis NO-ERROR.
            IF AVAIL movto_comis_repres THEN DO:
                FIND b-dc-orig-comis-movto EXCLUSIVE-LOCK WHERE ROWID(b-dc-orig-comis-movto) = ROWID(dc-orig-comis-movto) NO-ERROR.
                IF AVAIL b-dc-orig-comis-movto THEN
                    ASSIGN b-dc-orig-comis-movto.num_seq_movto_comis = movto_comis_repres.num_seq_movto_comis.
            END.
        END.

        /* N∆o vai localizar o movimento se por um acaso tiver sido alterado valor do movimento original.
           Neste caso ser† necess†rio intervená∆o direta no registro da dc-orig-movto-comis pela TIC (campo num_seq_movto_comis) */
        IF NOT AVAIL movto_comis_repres THEN DO:
            PUT "Erro ao localizar movimento da transacao 202. Estab: " tit_acr.cod_estab 
                                                             " Espec: " tit_acr.cod_espec_docto
                                                             " Serie: " tit_acr.cod_ser_docto
                                                            " Titulo: " tit_acr.cod_tit_acr
                                                                " /P: " tit_acr.cod_parcela SKIP.
        END.
        
        FIND FIRST movto_tit_acr NO-LOCK
             WHERE movto_tit_acr.cod_estab            = tit_acr.cod_estab
               AND movto_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
               AND movto_tit_acr.num_id_movto_tit_acr = movto_comis_repres.num_id_movto_tit_acr NO-ERROR.
    
        FIND representante NO-LOCK
            WHERE representante.cod_empresa = dc-orig-comis-movto.cod_empresa
            AND   representante.cdn_repres  = dc-orig-comis-movto.cdn_repres NO-ERROR.
    
        FIND FIRST emsuni.cliente NO-LOCK
              WHERE cliente.cod_empresa     = tit_acr.cod_empresa
                AND cliente.cdn_cliente     = tit_acr.cdn_cliente NO-ERROR.
        
        RUN dop/dco005a.p (dc-orig-comis-movto.cod_empresa   ,
                           dc-orig-comis-movto.cdn_repres    ,
                           dc-orig-comis-movto.cod_estab     , 
                           dc-orig-comis-movto.num_id_tit_acr, 
                           OUTPUT c-cod_ccusto                ).
        
        CREATE  tt-movto.
        ASSIGN  tt-movto.num_id_tit_acr             = dc-orig-comis-movto.num_id_tit_acr        
                tt-movto.num_seq_movto_comis        = dc-orig-comis-movto.num_seq_movto_comis   
                tt-movto.cdn_repres                 = dc-orig-comis-movto.cdn_repres
                tt-movto.nom_pessoa                 = representante.nom_pessoa
                tt-movto.cdn_cliente                = tit_acr.cdn_cliente
                tt-movto.nom_cliente                = cliente.nom_pessoa
                tt-movto.cod_empresa                = tit_acr.cod_empresa
                tt-movto.cod_estab                  = tit_acr.cod_estab
                tt-movto.cod_espec_docto            = tit_acr.cod_espec_docto
                tt-movto.cod_ser_docto              = tit_acr.cod_ser_docto
                tt-movto.cod_tit_acr                = tit_acr.cod_tit_acr
                tt-movto.cod_parcela                = tit_acr.cod_parcela
                tt-movto.dat_emis_docto             = tit_acr.dat_emis_docto
                tt-movto.dat_vencto_tit_acr         = tit_acr.dat_vencto_tit_acr
                tt-movto.dat_liquidac_tit_acr       = (IF  AVAIL movto_tit_acr 
                                                           THEN movto_tit_acr.dat_cr_movto_tit_acr
                                                           ELSE tit_acr.dat_ult_liquidac_tit_acr)
                tt-movto.val_perc_comis_repres      = dc-orig-comis-movto.val_perc_comis_repres
                tt-movto.val_perc_comis_repres_emis = dc-orig-comis-movto.val_perc_comis_repres_emis
                tt-movto.val_base_calc_comis        = dc-orig-comis-movto.val_base_comis
                tt-movto.val_perc_comis             = dc-orig-comis-movto.val_perc_comis_repres
                tt-movto.val_movto_comis            = dc-orig-comis-movto.val_movto_comis
                tt-movto.cod_ccusto                 = c-cod_ccusto
                tt-movto.LOG_relatorio              = YES.

        FIND FIRST tt-repres-202
             WHERE tt-repres-202.cod_empresa     = representante.cod_empresa
               AND tt-repres-202.cdn_repres      = representante.cdn_repres NO-ERROR.
        IF  NOT AVAIL tt-repres-202 THEN DO:
            CREATE  tt-repres-202.
            ASSIGN  tt-repres-202.cod_empresa    = representante.cod_empresa
                    tt-repres-202.cdn_repres     = representante.cdn_repres.
        END.

        IF  movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o" THEN DO:
            ASSIGN  tt-repres-202.de-tot-pg-emiss  = tt-repres-202.de-tot-pg-emiss + movto_comis_repres.val_movto_comis.
            IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN 
               ASSIGN  tt-repres-202.de-tot-vinc-mes = tt-repres-202.de-tot-vinc-mes + movto_comis_repres.val_movto_comis.
        END. /* if Comiss∆o Emiss∆o */
        ELSE DO: /* Comiss∆o na Liquidaá∆o */
           ASSIGN  tt-repres-202.de-tot-pg-baixa  = tt-repres-202.de-tot-pg-baixa + movto_comis_repres.val_movto_comis.
        END.

    END.

END.

IF  tg-imp-comissoes THEN DO:
    IF  rs-classif = 1 /*repres / c¢d.cliente*/ THEN DO:
        {doinc/dco005rp.i tt-movto.cdn_cliente}
    END. /*IF  rs-classif = 1 /*repres / c¢d.cliente*/ THEN DO:*/
    ELSE DO:
        {doinc/dco005rp.i tt-movto.nom_cliente}
    END.
END. /*IF  tg-imp-comissoes THEN DO:*/

IF  tg-imp-resumo THEN DO:
    IF  tg-imp-comissoes THEN PAGE.
    tt-repres:
    FOR EACH tt-repres NO-LOCK
        WHERE NOT(tt-repres.de-tot-pg-emiss[1] = 0 AND
              tt-repres.de-tot-pg-baixa[1] = 0 AND
              tt-repres.de-tot-pg-lp-lm[1] = 0 AND
              tt-repres.de-tot-pg-estor[1] = 0 AND
              tt-repres.de-tot-vincu[1]    = 0 AND 
              tt-repres.de-tot-pg-emiss[2] = 0 AND
              tt-repres.de-tot-pg-baixa[2] = 0 AND
              tt-repres.de-tot-pg-lp-lm[2] = 0 AND
              tt-repres.de-tot-pg-estor[2] = 0 AND
              tt-repres.de-tot-vincu[2]    = 0)
          BREAK BY tt-repres.cdn_repres:

        FIND FIRST tt-repres-202 OF tt-repres NO-ERROR.

/*         IF tt-repres.de-tot-pg-emiss[1] = 0 AND        */
/*            tt-repres.de-tot-pg-baixa[1] = 0 AND        */
/*            tt-repres.de-tot-pg-lp-lm[1] = 0 AND        */
/*            tt-repres.de-tot-pg-estor[1] = 0 AND        */
/*            tt-repres.de-tot-vincu[1]    = 0 AND        */
/*            tt-repres.de-tot-pg-emiss[2] = 0 AND        */
/*            tt-repres.de-tot-pg-baixa[2] = 0 AND        */
/*            tt-repres.de-tot-pg-lp-lm[2] = 0 AND        */
/*            tt-repres.de-tot-pg-estor[2] = 0 AND        */
/*            tt-repres.de-tot-vincu[2]    = 0 THEN NEXT. */

        ASSIGN  de-tot-total = tt-repres.de-tot-pg-emiss[1] + tt-repres-202.de-tot-pg-emis +
                               tt-repres.de-tot-pg-baixa[1] + tt-repres-202.de-tot-pg-baixa + 
                               tt-repres.de-tot-pg-lp-lm[1] - 
                               tt-repres.de-tot-pg-estor[1].

        ASSIGN  de-tot-total-prox = tt-repres.de-tot-pg-emiss[2] + 
                                    tt-repres.de-tot-pg-baixa[2] + 
                                    tt-repres.de-tot-pg-lp-lm[2] - 
                                     tt-repres.de-tot-pg-estor[2].

        ACCUMULATE tt-repres.de-tot-pg-emiss[1] + tt-repres-202.de-tot-pg-emis    (TOTAL).
        ACCUMULATE(tt-repres.de-tot-pg-baixa[1] + tt-repres-202.de-tot-pg-baixa + tt-repres.de-tot-pg-lp-lm[1])   (TOTAL).
        ACCUMULATE tt-repres.de-tot-pg-estor[1]                                   (TOTAL).
        ACCUMULATE de-tot-total                                                   (TOTAL).
        ACCUMULATE (tt-repres.de-tot-vinc-mes[1] + tt-repres-202.de-tot-vinc-mes) (TOTAL).
        ACCUMULATE tt-repres.de-tot-vincu[1]                                      (TOTAL).

        ACCUMULATE tt-repres.de-tot-pg-emiss[2]                                   (TOTAL).
        ACCUMULATE(tt-repres.de-tot-pg-baixa[2] + tt-repres.de-tot-pg-lp-lm[2])   (TOTAL).
        ACCUMULATE tt-repres.de-tot-pg-estor[2]                                   (TOTAL).
        ACCUMULATE de-tot-total-prox                                              (TOTAL).
        ACCUMULATE tt-repres.de-tot-vinc-mes[2]                                   (TOTAL).
        ACCUMULATE tt-repres.de-tot-vincu[2]                                      (TOTAL).

        DISPLAY tt-repres.cdn_repres 
                tt-repres.nom_abrev
                c-periodo-atu                                                                                 COLUMN-LABEL "Per°odo"
               (tt-repres.de-tot-pg-emiss[1] + tt-repres-202.de-tot-pg-emis)                                  COLUMN-LABEL "Pagto Emis"
               (tt-repres.de-tot-pg-baixa[1] + tt-repres-202.de-tot-pg-baixa + tt-repres.de-tot-pg-lp-lm[1])  COLUMN-LABEL "Pagto Baixa"
                tt-repres.de-tot-pg-estor[1]                                                                  COLUMN-LABEL "Estorno"
                de-tot-total                                                                                  COLUMN-LABEL "Total"
                (tt-repres.de-tot-vinc-mes[1] + tt-repres-202.de-tot-vinc-mes)                                COLUMN-LABEL "Vinc Màs"
                tt-repres.de-tot-vincu[1]                                                                     COLUMN-LABEL "Vinculado"
            WITH FRAME f-sintetico-nom WIDTH 170 NO-BOX STREAM-IO DOWN.
        
        PUT     c-periodo-prox                                                                      AT 31                                        
                tt-repres.de-tot-pg-emiss[2]                                   FORMAT '>>>>,>>9.99' AT 38 
               (tt-repres.de-tot-pg-baixa[2] + tt-repres.de-tot-pg-lp-lm[2])   FORMAT '>>>>>,>>9.99' SPACE
                tt-repres.de-tot-pg-estor[2]                                   FORMAT '>>>>,>>9.99' SPACE(2)
                de-tot-total-prox                                              FORMAT '>>>>,>>9.99' 
                tt-repres.de-tot-vinc-mes[2]                                   FORMAT '>>>>,>>9.99' SPACE
                tt-repres.de-tot-vincu[2]                                      FORMAT '->>>>,>>9.99'.

        DOWN WITH FRAME f-sintetico-nom.

        IF LAST(tt-repres.cdn_repres) THEN DO:

            PUT "----------  ---------- ----------- ------------ ---------- ------------" AT 39.

            PUT c-periodo-atu                                                                                   AT 31 
                (ACCUM TOTAL tt-repres.de-tot-pg-emiss[1] + tt-repres-202.de-tot-pg-emis ) FORMAT '>>>>,>>9.99' AT 38   
                (ACCUM TOTAL(tt-repres.de-tot-pg-baixa[1] + tt-repres-202.de-tot-pg-baixa + tt-repres.de-tot-pg-lp-lm[1])) FORMAT '>>>>>,>>9.99'   
                (ACCUM TOTAL tt-repres.de-tot-pg-estor[1]                                ) FORMAT '>>>>>,>>9.99' 
                (ACCUM TOTAL de-tot-total                                                ) FORMAT '>>>>>>,>>9.99' 
                (ACCUM TOTAL tt-repres.de-tot-vinc-mes[1] + tt-repres-202.de-tot-vinc-mes) FORMAT '>>>>,>>9.99' 
                (ACCUM TOTAL tt-repres.de-tot-vincu[1]                                   ) FORMAT '->>>>>,>>9.99'.   

            PUT c-periodo-prox                                                                                  AT 31 
                (ACCUM TOTAL tt-repres.de-tot-pg-emiss[2]                                ) FORMAT '>>>>,>>9.99' AT 38   
                (ACCUM TOTAL(tt-repres.de-tot-pg-baixa[2] + tt-repres.de-tot-pg-lp-lm[2])) FORMAT '>>>>>,>>9.99'   
                (ACCUM TOTAL tt-repres.de-tot-pg-estor[2]                                ) FORMAT '>>>>>,>>9.99' 
                (ACCUM TOTAL de-tot-total-prox                                           ) FORMAT '>>>>>>,>>9.99' 
                (ACCUM TOTAL tt-repres.de-tot-vinc-mes[2]                                ) FORMAT '>>>>,>>9.99' 
                (ACCUM TOTAL tt-repres.de-tot-vincu[2]                                   ) FORMAT '->>>>>,>>9.99'.       
                                                                                          
        END.

        IF tg-gera-movto-comis THEN DO: /* Gera Movimento de Comiss∆o */
           /*
           /* Comiss∆o na Emiss∆o */
           ASSIGN i-transacao = IF NOT tg-rescisao THEN 2
                                ELSE                   10.
           IF tt-repres.de-tot-pg-emiss <> 0 THEN DO: 
              FIND  LAST dc-comis-trans NO-LOCK 
                   WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.
              IF AVAIL dc-comis-trans THEN DO:
                 
                 ASSIGN de-lancamento = tt-repres.de-tot-pg-emis.
                 {doinc/dco005rp.i2}

                 FOR EACH tt-movto NO-LOCK
                    WHERE tt-movto.cdn_repres                = tt-repres.cdn_repres
                      AND tt-movto.val_movto_comis          <> 0,
                    FIRST movto_comis_repres OF tt-movto NO-LOCK
                    WHERE movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o"
                 BREAK BY tt-movto.cod_ccusto:
                     
                    ASSIGN de-orig-lancamento = tt-movto.val_movto_comis.
                    {doinc/dco005rp.i4 tt-movto.val_movto_comis}
                    {doinc/dco005rp.i3}
                 END.
              END. /* if avail dc-comis-trans */
           END. /* Fim Comiss∆o na Emiss∆o */
           */
           /* Comiss∆o na Emiss∆o e Liquidaá∆o */
           ASSIGN i-transacao = IF NOT tg-rescisao THEN 2
                                ELSE                   11.
           IF tt-repres.de-tot-pg-emiss[1] <> 0 OR tt-repres.de-tot-pg-emiss[2] <> 0 OR
              tt-repres.de-tot-pg-baixa[1] <> 0 OR tt-repres.de-tot-pg-baixa[2] <> 0 THEN DO: 
              FIND  LAST dc-comis-trans NO-LOCK 
                   WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.
              IF AVAIL dc-comis-trans THEN DO:

                 ASSIGN de-lancamento = tt-repres.de-tot-pg-baixa[1] + tt-repres.de-tot-pg-emiss[1] - tt-repres.de-tot-pg-estor[1] +
                                        tt-repres.de-tot-pg-baixa[2] + tt-repres.de-tot-pg-emiss[2] - tt-repres.de-tot-pg-estor[2].
                 {doinc/dco005rp.i2}
                  
                 FOR EACH tt-movto NO-LOCK
                    WHERE tt-movto.cdn_repres        = tt-repres.cdn_repres
                      AND lookup(tt-movto.cod_espec_docto,"LP,LM") = 0
                      AND tt-movto.val_movto_comis   <> 0
                      AND tt-movto.val_movto_estorno =  0
                      AND NOT tt-movto.log_relatorio
                    BREAK BY tt-movto.cod_ccusto:
                    FIND FIRST movto_comis_repres OF tt-movto NO-LOCK
                         WHERE movto_comis_repres.ind_tip_movto         = "REALIZADO"
                           AND movto_comis_repres.ind_natur_lancto_ctbl = "CR" NO-ERROR.
                    ASSIGN de-orig-lancamento = tt-movto.val_movto_comis.
                    {doinc/dco005rp.i4 tt-movto.val_movto_comis}
                    {doinc/dco005rp.i3}
                 END.
              END. /* if avail dc-comis-trans */
           END. /* Fim Comiss∆o na Liquidaá∆o */

           /* Comiss∆o na Liquidaá∆o LP e LM */ /* SSI 025/05 */
           ASSIGN i-transacao = 61.
           IF tt-repres.de-tot-pg-lp-lm[1] <> 0 OR tt-repres.de-tot-pg-lp-lm[2] <> 0 THEN DO: 
              FIND  LAST dc-comis-trans NO-LOCK 
                   WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.
              IF AVAIL dc-comis-trans THEN DO:

                 ASSIGN de-lancamento = tt-repres.de-tot-pg-lp-lm[1] + tt-repres.de-tot-pg-lp-lm[2].
                 {doinc/dco005rp.i2}
                  
                 FOR EACH tt-movto NO-LOCK
                    WHERE tt-movto.cdn_repres        = tt-repres.cdn_repres
                      AND lookup(tt-movto.cod_espec_docto,"LP,LM") <> 0
                      AND tt-movto.val_movto_comis   <> 0
                      AND tt-movto.val_movto_estorno =  0
                     AND NOT tt-movto.log_relatorio
                    BREAK BY tt-movto.cod_ccusto:
                    FIND FIRST movto_comis_repres OF tt-movto NO-LOCK
                         WHERE movto_comis_repres.ind_tip_movto         = "REALIZADO"
                           AND movto_comis_repres.ind_natur_lancto_ctbl = "CR" NO-ERROR.
                    ASSIGN de-orig-lancamento = tt-movto.val_movto_comis.
                    {doinc/dco005rp.i4 tt-movto.val_movto_comis}
                    {doinc/dco005rp.i3}
                 END.
              END. /* if avail dc-comis-trans */
           END. /* Fim Comiss∆o na Liquidaá∆o LP e LM */

           /* Comiss∆o Vinculada do Màs */
           IF tt-repres.de-tot-vinc-mes[1] <> 0 OR tt-repres.de-tot-vinc-mes[2] <> 0 THEN DO: 
              FIND  LAST dc-comis-trans NO-LOCK 
                   WHERE dc-comis-trans.cod_transacao = 90 NO-ERROR.
              IF AVAIL dc-comis-trans THEN DO:
                    
                 ASSIGN  de-lancamento = tt-repres.de-tot-vinc-mes[1] + tt-repres.de-tot-vinc-mes[2].
                 {doinc/dco005rp.i2}
                    
                 FOR EACH tt-movto NO-LOCK
                    WHERE tt-movto.cdn_repres         = tt-repres.cdn_repres
                      AND tt-movto.vincul-no-mes      = "*"
                      AND NOT tt-movto.log_relatorio
                    BREAK BY tt-movto.cod_ccusto:

                    FIND FIRST movto_comis_repres OF tt-movto NO-LOCK NO-ERROR.
                    
                    ASSIGN de-orig-lancamento = tt-movto.val_movto_vincul_mes.
                       
                    {doinc/dco005rp.i4 tt-movto.val_movto_vincul_mes}
                    {doinc/dco005rp.i3}
                 END.
              END. /* if avail dc-comis-trans */
           END. /* Fim Comiss∆o Vinculada do Màs */

           /* Estorno da Comiss∆o Vinculada */
           IF tt-repres.de-tot-pg-estor[1] <> 0 OR tt-repres.de-tot-pg-estor[2] <> 0 THEN DO: 
              FIND  LAST dc-comis-trans NO-LOCK 
                   WHERE dc-comis-trans.cod_transacao = 91 NO-ERROR.
              IF AVAIL dc-comis-trans THEN DO:
                  
                 ASSIGN de-lancamento = tt-repres.de-tot-pg-estor[1] + tt-repres.de-tot-pg-estor[2].
                 {doinc/dco005rp.i2}
                   
                 FOR EACH tt-movto NO-LOCK
                    WHERE tt-movto.cdn_repres         = tt-repres.cdn_repres
                      AND tt-movto.val_movto_estorno <> 0
                      AND NOT tt-movto.log_relatorio
                    BREAK BY tt-movto.cod_ccusto:
                    
                    FIND FIRST movto_comis_repres OF tt-movto NO-LOCK NO-ERROR.
    
                    ASSIGN de-orig-lancamento = tt-movto.val_movto_estorno.
                    {doinc/dco005rp.i4 tt-movto.val_movto_estorno}
                    {doinc/dco005rp.i3}
                 END.
              END. /* if avail dc-comis-trans */
           END. /* Fim estorno Comiss∆o Vinculada */
           
           IF NOT tg-rescisao THEN DO:
              /* Comiss∆o Vinculada Acumulada */
              IF tt-repres.de-tot-vincul[1] <> 0 OR tt-repres.de-tot-vincul[2] <> 0 THEN DO:
                 FIND  LAST dc-comis-trans NO-LOCK 
                      WHERE dc-comis-trans.cod_transacao = 92 NO-ERROR.
                 IF AVAIL dc-comis-trans THEN DO:
                    ASSIGN  de-lancamento = tt-repres.de-tot-vincul[1] + tt-repres.de-tot-vincul[2].
                    {doinc/dco005rp.i2}
                        
                    FOR EACH tt-movto NO-LOCK
                       WHERE tt-movto.cdn_repres         = tt-repres.cdn_repres
                         AND tt-movto.val_movto_vincul  <> 0
                         AND NOT tt-movto.log_relatorio
                       BREAK BY tt-movto.cod_ccusto:
                       
                       FIND FIRST movto_comis_repres OF tt-movto NO-LOCK NO-ERROR.
                        
                       ASSIGN de-orig-lancamento = tt-movto.val_movto_vincul.
                       {doinc/dco005rp.i4 tt-movto.val_movto_vincul}
                       {doinc/dco005rp.i3}
                    END.
                 END. /* if avail dc-comis-trans */
              END. /* Fim Comiss∆o Vinculada Acumulada */
           END. /* If not tg-rescisao */

           /* Rescis∆o */
           IF tg-rescisao THEN DO:
              /* Comiss∆o Vinculada  Total */
              IF (tt-repres.de-tot-vincul[1] <> 0 OR tt-repres.de-tot-vincul[2] <> 0) AND
                 tg-paga-vinculada           THEN DO:
                 FIND  LAST dc-comis-trans NO-LOCK 
                      WHERE dc-comis-trans.cod_transacao = 6 NO-ERROR.
                 IF AVAIL dc-comis-trans THEN DO:
                    
                    ASSIGN  de-lancamento = tt-repres.de-tot-vincul[1] + tt-repres.de-tot-vincul[2].
                    {doinc/dco005rp.i2}
                    
                    FOR EACH tt-movto NO-LOCK
                       WHERE tt-movto.cdn_repres         = tt-repres.cdn_repres
                         AND tt-movto.val_movto_vincul  <> 0
                         AND NOT tt-movto.log_relatorio
                       BREAK BY tt-movto.cod_ccusto:
                       
                       FIND FIRST movto_comis_repres OF tt-movto NO-LOCK NO-ERROR.
                    
                       ASSIGN de-orig-lancamento = tt-movto.val_movto_vincul.
                       {doinc/dco005rp.i4 tt-movto.val_movto_vincul}
                       {doinc/dco005rp.i3}
                    END.
                    /* Zera Comiss∆o dos T°tulos Pagos Vinculada */
                    FOR EACH dc-comis-movto NO-LOCK
                       WHERE dc-comis-movto.cod_empresa   = tt-repres.cod_empresa
                         AND dc-comis-movto.cdn_repres    = tt-repres.cdn_repres
                         AND dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao:
                       
                       FOR EACH dc-orig-comis-movto OF dc-comis-movto NO-LOCK.

                          FIND FIRST tit_acr OF dc-orig-comis-movto NO-LOCK NO-ERROR.

                          IF AVAIL tit_acr THEN DO:
                             /* Considera confirmaá∆o de entrada para permitir a alteraá∆o de t°tulo */
                             ASSIGN l-escritural-nao-confirmada = NO.
                             FIND FIRST movto_ocor_bcia OF tit_acr
                                  WHERE movto_ocor_bcia.ind_ocor_bcia_remes_ret = 'Remessa'
                                    AND movto_ocor_bcia.ind_tip_ocor_bcia       = 'Implantaá∆o' NO-ERROR.
                             IF AVAIL movto_ocor_bcia                           AND 
                                NOT movto_ocor_bcia.log_confir_movto_envdo_bco THEN DO:
                                ASSIGN l-escritural-nao-confirmada                = YES
                                       movto_ocor_bcia.log_confir_movto_envdo_bco = YES.
                             END.
                             
                             FOR EACH repres_tit_acr NO-LOCK
                                WHERE repres_tit_acr.cod_empresa    = tit_acr.cod_empresa
                                  AND repres_tit_acr.cod_estab      = tit_acr.cod_estab
                                  AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                  AND repres_tit_acr.cdn_repres     = dc-comis-movto.cdn_repres:

                                 FOR EACH tt_alter_tit_acr_base:      DELETE  tt_alter_tit_acr_base.      END.
                                 FOR EACH tt_alter_tit_acr_comis:     DELETE  tt_alter_tit_acr_comis.     END.
                                 FOR EACH tt_log_erros_alter_tit_acr. DELETE  tt_log_erros_alter_tit_acr. END.
                                 ASSIGN l-erro = NO.
    
                                 CREATE tt_alter_tit_acr_base.
                                 ASSIGN tt_alter_tit_acr_base.tta_cod_refer                   = fi-sugestao-referencia().
                                 ASSIGN tt_alter_tit_acr_base.tta_cod_estab                   = tit_acr.cod_estab
                                        tt_alter_tit_acr_base.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                                        tt_alter_tit_acr_base.tta_dat_transacao               = dt-fim-periodo
                                        tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_imp = ?
                                        tt_alter_tit_acr_base.tta_val_sdo_tit_acr             = ?           
                                        tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_alt = ?
                                        tt_alter_tit_acr_base.ttv_ind_motiv_acerto_val        = ?           
                                        tt_alter_tit_acr_base.tta_cod_portador                = ?           
                                        tt_alter_tit_acr_base.tta_cod_cart_bcia               = ?           
                                        tt_alter_tit_acr_base.tta_val_despes_bcia             = ?
                                        tt_alter_tit_acr_base.tta_cod_agenc_cobr_bcia         = ?           
                                        tt_alter_tit_acr_base.tta_cod_tit_acr_bco             = ?           
                                        tt_alter_tit_acr_base.tta_dat_emis_docto              = 01/01/0001  
                                        tt_alter_tit_acr_base.tta_dat_vencto_tit_acr          = 01/01/0001  
                                        tt_alter_tit_acr_base.tta_dat_prev_liquidac           = 01/01/0001  
                                        tt_alter_tit_acr_base.tta_dat_fluxo_tit_acr           = 01/01/0001  
                                        tt_alter_tit_acr_base.tta_ind_sit_tit_acr             = ?
                                        tt_alter_tit_acr_base.tta_cod_cond_cobr               = ?           
                                        tt_alter_tit_acr_base.tta_log_tip_cr_perda_dedut_tit  = ?           
                                        tt_alter_tit_acr_base.tta_dat_abat_tit_acr            = 01/01/0001
                                        tt_alter_tit_acr_base.tta_val_perc_abat_acr           = ?           
                                        tt_alter_tit_acr_base.tta_val_abat_tit_acr            = ?           
                                        tt_alter_tit_acr_base.tta_dat_desconto                = 01/01/0001
                                        tt_alter_tit_acr_base.tta_val_perc_desc               = ?           
                                        tt_alter_tit_acr_base.tta_val_desc_tit_acr            = ?           
                                        tt_alter_tit_acr_base.tta_qtd_dias_carenc_juros_acr   = ?           
                                        tt_alter_tit_acr_base.tta_val_perc_juros_dia_atraso   = ?           
                                        tt_alter_tit_acr_base.tta_qtd_dias_carenc_multa_acr   = ?           
                                        tt_alter_tit_acr_base.tta_val_perc_multa_atraso       = ?           
                                        tt_alter_tit_acr_base.ttv_cod_portador_mov            = ?
                                        tt_alter_tit_acr_base.tta_ind_tip_cobr_acr            = ?           
                                        tt_alter_tit_acr_base.tta_ind_ender_cobr              = ?           
                                        tt_alter_tit_acr_base.tta_nom_abrev_contat            = ?           
                                        tt_alter_tit_acr_base.tta_val_liq_tit_acr             = ?           
                                        tt_alter_tit_acr_base.tta_cod_instruc_bcia_1_movto    = ?
                                        tt_alter_tit_acr_base.tta_cod_instruc_bcia_2_movto    = ?
                                        tt_alter_tit_acr_base.tta_log_tit_acr_destndo         = ?           
                                        tt_alter_tit_acr_base.tta_cod_histor_padr             = ?
                                        tt_alter_tit_acr_base.ttv_des_text_histor             = ?
                                        tt_alter_tit_acr_base.tta_des_obs_cobr                = ?           
                                        tt_alter_tit_acr_base.ttv_wgh_lista                   = ?.

                                 CREATE tt_alter_tit_acr_comis.
                                 ASSIGN tt_alter_tit_acr_comis.tta_cod_empresa                  = repres_tit_acr.cod_empresa
                                        tt_alter_tit_acr_comis.tta_cod_estab                    = repres_tit_acr.cod_estab
                                        tt_alter_tit_acr_comis.tta_num_id_tit_acr               = repres_tit_acr.num_id_tit_acr
                                        tt_alter_tit_acr_comis.ttv_num_tip_operac               = 0
                                        tt_alter_tit_acr_comis.tta_cdn_repres                   = repres_tit_acr.cdn_repres
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_repres        = 0
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_repres_emis   = repres_tit_acr.val_perc_comis_repres_emis
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_abat          = repres_tit_acr.val_perc_comis_abat        
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_desc          = repres_tit_acr.val_perc_comis_desc        
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_juros         = repres_tit_acr.val_perc_comis_juros       
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_multa         = repres_tit_acr.val_perc_comis_multa       
                                        tt_alter_tit_acr_comis.tta_val_perc_comis_acerto_val    = repres_tit_acr.val_perc_comis_acerto_val  
                                        tt_alter_tit_acr_comis.tta_log_comis_repres_proporc     = repres_tit_acr.log_comis_repres_proporc   
                                        tt_alter_tit_acr_comis.tta_ind_tip_comis                = repres_tit_acr.ind_tip_comis.
    
                                 RUN prgfin/acr/acr711zf.py( INPUT  1,
                                                             INPUT  TABLE tt_alter_tit_acr_base,
                                                             INPUT  TABLE tt_alter_tit_acr_rateio,
                                                             INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                                             INPUT  TABLE tt_alter_tit_acr_comis,
                                                             INPUT  TABLE tt_alter_tit_acr_cheq,
                                                             INPUT  TABLE tt_alter_tit_acr_iva,
                                                             INPUT  TABLE tt_alter_tit_acr_impto_retid,
                                                             INPUT  TABLE tt_alter_tit_acr_cobr_especial,
                                                             INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                                             OUTPUT TABLE tt_log_erros_alter_tit_acr).
    
                                 FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK NO-ERROR.
                                 IF AVAIL tt_log_erros_alter_tit_acr THEN DO:
                                    ASSIGN l-erro = YES.
                                 END.
                                 IF l-erro THEN DO:
                                    FOR EACH tt_log_erros_alter_tit_acr:
                                       DISP tt_log_erros_alter_tit_acr.tta_cod_estab             
                                            tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
                                            tit_acr.cod_ser_docto   WHEN AVAIL tit_acr
                                            tit_acr.cod_espec_docto WHEN AVAIL tit_acr
                                            tit_acr.cod_tit_acr     WHEN AVAIL tit_acr
                                            tit_acr.cod_parcela     WHEN AVAIL tit_acr
                                            tt_log_erros_alter_tit_acr.ttv_num_mensagem          
                                            tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb       
                                            tt_log_erros_alter_tit_acr.ttv_des_msg_erro FORMAT "x(280)"         
                                            substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,1,280) FORMAT "x(280)"
                                            substr(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda,281,280) FORMAT "x(280)"
                                            WITH WIDTH 300 1 COL.      
                                    END. /* for each tt_log_erros_alter_tit_acr */
                                 END. /* if l-erro */
                             END. /* for each repres_tit_acr */
                             IF l-escritural-nao-confirmada THEN DO:
                                ASSIGN movto_ocor_bcia.log_confir_movto_envdo_bco = NO.
                             END.
                          END. /* if avail tit_acr */
                       END. /* for each dc-orig-comis-movto */
                    END. /* for each dc-comis-movto */
                    /* FIM-Zera Comiss∆o dos T°tulos Pagos em Carteira */
                 END. /* if avail dc-comis-trans */
              END.
              /* FIM-Comiss∆o Vinculada Total */

              /* Comiss∆o Carteira */
              IF tg-paga-carteira THEN DO:
                 FOR EACH tt-ped-venda. DELETE tt-ped-venda. END.
                 RUN dop/dco005b.p (INPUT tt-repres.cdn_repres,
                                    OUTPUT TABLE tt-ped-venda).

                 ASSIGN de-comis-carteira = 0.
                 FOR EACH tt-ped-venda.
                    ASSIGN de-comis-carteira = de-comis-carteira + tt-ped-venda.vl-comissao.
                 END.
                 IF de-comis-carteira <> 0 THEN DO:
                    FIND  LAST dc-comis-trans NO-LOCK 
                         WHERE dc-comis-trans.cod_transacao = 9 NO-ERROR.
                    IF AVAIL dc-comis-trans THEN DO:
                       FOR EACH dc-comis-movto EXCLUSIVE-LOCK
                          WHERE dc-comis-movto.cod_empresa   = tt-repres.cod_empresa       
                            AND dc-comis-movto.cdn_repres    = tt-repres.cdn_repres        
                            AND dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao
                            AND dc-comis-movto.dat_transacao = dt-fim-periodo:

                          IF dc-comis-movto.flag-contabilizou THEN DO:
                             PUT UNFORMATTED
                                 "Movimento de Comiss∆o "    AT 15
                                 dc-comis-movto.dat_transacao " - "
                                 dc-comis-movto.cod_transacao " - "
                                 dc-comis-movto.des_transacao " j† foi contabilizado."
                                 "Movimento nao foi gerado." AT 15 SKIP(1).
                             NEXT tt-repres.
                          END.
                          ELSE DO:
                             FOR EACH dc-orig-comis-movto OF dc-comis-movto EXCLUSIVE-LOCK.
                                DELETE dc-orig-comis-movto.
                             END.
                             DELETE dc-comis-movto.
                          END.
                       END.
                       CREATE dc-comis-movto.
                       ASSIGN dc-comis-movto.cod_empresa        = tt-repres.cod_empresa
                              dc-comis-movto.cdn_repres         = tt-repres.cdn_repres
                              dc-comis-movto.cod_transacao      = dc-comis-trans.cod_transacao
                              dc-comis-movto.dat_transacao      = dt-fim-periodo
                              dc-comis-movto.des_transacao      = dc-comis-trans.descricao
                              dc-comis-movto.cod_plano_cta_ctbl = dc-comis-trans.cod_plano_cta_ctbl
                              dc-comis-movto.cod_cta_ctbl       = dc-comis-trans.cod_cta_ctbl
                              dc-comis-movto.cod_plano_ccusto   = dc-comis-trans.cod_plano_ccusto  
                              dc-comis-movto.cod_ccusto         = IF dc-comis-trans.cod_ccusto = ? 
                                                                     THEN tt-repres.cod_ccusto
                                                                     ELSE dc-comis-trans.cod_ccusto
                              dc-comis-movto.ind_origin_movto   = "dco005"
                              dc-comis-movto.val_movto          = de-comis-carteira.
                       FOR EACH tt-ped-venda
                          WHERE tt-ped-venda.vl-comissao <> 0:
                          CREATE dc-orig-comis-movto.
                          ASSIGN dc-orig-comis-movto.num_id_comis_movto         = dc-comis-movto.num_id_comis_movto
                                 dc-orig-comis-movto.cod_empresa                = tt-repres.cod_empresa
                                 dc-orig-comis-movto.cdn_repres                 = tt-repres.cdn_repres  
                                 dc-orig-comis-movto.nome-abrev                 = tt-ped-venda.nome-abrev
                                 dc-orig-comis-movto.nr-pedcli                  = tt-ped-venda.nr-pedcli
                                 dc-orig-comis-movto.dat_transacao              = dt-fim-periodo
                                 dc-orig-comis-movto.val_perc_comis_repres      = tt-ped-venda.perc-comis
                                 dc-orig-comis-movto.val_perc_comis_repres_emis = tt-ped-venda.comis-emis
                                 dc-orig-comis-movto.val_base_comis             = tt-ped-venda.vl-base
                                 dc-orig-comis-movto.val_movto_comis            = tt-ped-venda.vl-comissao
                                 dc-orig-comis-movto.ind_tip_movto              = "N∆o Realizado".
                          /* Zera Comiss∆o nos Pedidos n∆o Faturados */
                          RUN dop/dco005c.p (INPUT tt-repres.cdn_repres,
                                             INPUT TABLE tt-ped-venda).
                          /* FIM-Zera Comiss∆o nos Pedidos n∆o Faturados */
                       END. /* for each tt-ped-venda  */
                    END.  /* if avail dc-comis-trans */
                    ELSE DO:
                       PUT UNFORMATTED 
                           "Representante: " AT 15
                           tt-repres.cdn_repres " possui "
                           de-comis-carteira FORMAT ">>>,>>9.99" " de comiss∆o em pedidos nao faturados"
                           "Comiss∆o n∆o gerada. Transacao 9 nao cadastrada " AT 15.
                       NEXT tt-repres.
                    END. /* else                            */
                 END. /* if de-comis-carteira            */
              END. /* if tg-paga-carteira              */
           END. /* FIM-Rescis∆o                     */

           /* Bloco para criaá∆o das transaá‰es 102 e 202 */
           FOR EACH dc-fechamento-rep NO-LOCK
               WHERE dc-fechamento-rep.cod-rep = tt-repres.cdn_repres,
               EACH dc-fechamento-periodo NO-LOCK
               WHERE dc-fechamento-periodo.cod-cenario = dc-fechamento-periodo.cod-cenario
               AND   dc-fechamento-periodo.periodo     = STRING(YEAR(dt-fim-periodo)) + STRING(MONTH(dt-fim-periodo),"99")
               AND   dc-fechamento-periodo.log-comissao = YES:

               IF NOT (dc-fechamento-periodo.dt-inicio <= dt-fim-periodo AND
                       dc-fechamento-periodo.dt-termino >= dt-fim-periodo) THEN DO:

                   /* Busca os movimentos j† existentes da transaá∆o 102 para eliminar caso n∆o esteja contabilizado */
                   FIND dc-comis-trans NO-LOCK WHERE dc-comis-trans.cod_transacao = 102 NO-ERROR.
                   IF AVAIL dc-comis-trans THEN DO:
                       FOR EACH dc-comis-movto EXCLUSIVE-LOCK
                          WHERE dc-comis-movto.cod_empresa   = tt-repres.cod_empresa       
                            AND dc-comis-movto.cdn_repres    = tt-repres.cdn_repres        
                            AND dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao
                            AND dc-comis-movto.dat_transacao = dt-fim-periodo:
                            
                          IF dc-comis-movto.flag-contabilizou THEN DO:
                             PUT UNFORMATTED
                                 "Movimento de Comiss∆o "    AT 15
                                 dc-comis-movto.dat_transacao " - "
                                 dc-comis-movto.cod_transacao " - "
                                 dc-comis-movto.des_transacao " j† foi contabilizado."
                                 "Movimento nao foi gerado." AT 15 SKIP(1).
                             NEXT tt-repres.
                          END.
                          ELSE DO:
                              FOR EACH dc-orig-comis-movto OF dc-comis-movto EXCLUSIVE-LOCK.
                                  DELETE dc-orig-comis-movto.
                              END.
                              DELETE dc-comis-movto.
                          END.
                       END.
                   END.

                   /* Busca os movimentos j† existentes da transaá∆o 202 para eliminar caso n∆o esteja contabilizado */
                   FIND dc-comis-trans NO-LOCK 
                        WHERE dc-comis-trans.cod_transacao = 202 NO-ERROR.
                   IF AVAIL dc-comis-trans THEN DO:
                       FOR EACH dc-comis-movto EXCLUSIVE-LOCK
                          WHERE dc-comis-movto.cod_empresa   = tt-repres.cod_empresa       
                            AND dc-comis-movto.cdn_repres    = tt-repres.cdn_repres        
                            AND dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao
                            AND dc-comis-movto.dat_transacao = dt-fim-periodo + 1:
                            
                          IF dc-comis-movto.flag-contabilizou THEN DO:
                             PUT UNFORMATTED
                                 "Movimento de Comiss∆o "    AT 15
                                 dc-comis-movto.dat_transacao " - "
                                 dc-comis-movto.cod_transacao " - "
                                 dc-comis-movto.des_transacao " j† foi contabilizado."
                                 "Movimento nao foi gerado." AT 15 SKIP(1).
                             NEXT tt-repres.
                          END.
                          ELSE DO:
                              FOR EACH dc-orig-comis-movto OF dc-comis-movto EXCLUSIVE-LOCK.
                                  DELETE dc-orig-comis-movto.
                              END.
                              DELETE dc-comis-movto.
                          END.
                       END.
                   END.
               
                   /* Busca as transaá‰es que precisam ser 'transferidas' para o pr¢ximo màs */
                   FOR EACH dc-comis-trans NO-LOCK
                       WHERE dc-comis-trans.cod_transacao = 2,
                       EACH dc-comis-movto NO-LOCK
                       WHERE dc-comis-movto.cod_empresa   = tt-repres.cod_empresa
                         AND dc-comis-movto.cdn_repres    = tt-repres.cdn_repres
                         AND dc-comis-movto.cod_transacao = dc-comis-trans.cod_transacao
                         AND dc-comis-movto.dat_transacao = dt-fim-periodo :

                        /* Cria a transaá∆o 102 para subtrair da comiss∆o do màs atual */
                        FIND b-dc-comis-trans NO-LOCK 
                            WHERE b-dc-comis-trans.cod_transacao = 102 NO-ERROR.
                        IF AVAIL b-dc-comis-trans THEN DO:
                            
                            CREATE b-dc-comis-movto.
                            ASSIGN b-dc-comis-movto.cod_empresa        = tt-repres.cod_empresa
                                   b-dc-comis-movto.cdn_repres         = tt-repres.cdn_repres
                                   b-dc-comis-movto.cod_transacao      = b-dc-comis-trans.cod_transacao
                                   b-dc-comis-movto.dat_transacao      = dt-fim-periodo
                                   b-dc-comis-movto.des_transacao      = b-dc-comis-trans.descricao
                                   b-dc-comis-movto.cod_plano_cta_ctbl = b-dc-comis-trans.cod_plano_cta_ctbl
                                   b-dc-comis-movto.cod_cta_ctbl       = b-dc-comis-trans.cod_cta_ctbl
                                   b-dc-comis-movto.cod_plano_ccusto   = b-dc-comis-trans.cod_plano_ccusto  
                                   b-dc-comis-movto.cod_ccusto         = b-dc-comis-trans.cod_ccusto 
                                   b-dc-comis-movto.ind_origin_movto   = "dco005"
                                   b-dc-comis-movto.val_movto          = 0.
                            
                        END.


                        /* Cria a transaá∆o 202 para somar no màs subsequente */
                        FIND bb-dc-comis-trans NO-LOCK 
                            WHERE bb-dc-comis-trans.cod_transacao = 202 NO-ERROR.
                        IF AVAIL bb-dc-comis-trans THEN DO:
                            
                            CREATE bb-dc-comis-movto.
                            ASSIGN bb-dc-comis-movto.cod_empresa        = tt-repres.cod_empresa
                                   bb-dc-comis-movto.cdn_repres         = tt-repres.cdn_repres
                                   bb-dc-comis-movto.cod_transacao      = bb-dc-comis-trans.cod_transacao
                                   bb-dc-comis-movto.dat_transacao      = dt-fim-periodo + 1
                                   bb-dc-comis-movto.des_transacao      = bb-dc-comis-trans.descricao
                                   bb-dc-comis-movto.cod_plano_cta_ctbl = bb-dc-comis-trans.cod_plano_cta_ctbl
                                   bb-dc-comis-movto.cod_cta_ctbl       = bb-dc-comis-trans.cod_cta_ctbl
                                   bb-dc-comis-movto.cod_plano_ccusto   = bb-dc-comis-trans.cod_plano_ccusto  
                                   bb-dc-comis-movto.cod_ccusto         = bb-dc-comis-trans.cod_ccusto 
                                   bb-dc-comis-movto.ind_origin_movto   = "dco005"
                                   bb-dc-comis-movto.val_movto          = 0.
                            
                        END.

                        /* Là todos os registros que s∆o posteriores ao final do per°odo */
                        FOR EACH dc-orig-comis-movto NO-LOCK
                            WHERE dc-orig-comis-movto.num_id_comis_movto = dc-comis-movto.num_id_comis_movto
                            AND   dc-orig-comis-movto.dat_transacao      > dc-fechamento-periodo.dt-termino
                            AND   dc-orig-comis-movto.dat_transacao      <= dt-fim-periodo:

                            /* --- Cliente HOME CENTER n∆o participam do projeto de fechamento antecipado --- */
                            FIND FIRST tit_acr NO-LOCK
                                WHERE tit_acr.cod_estab      = dc-orig-comis-movto.cod_estab
                                AND   tit_acr.num_id_tit_acr = dc-orig-comis-movto.num_id_tit_acr NO-ERROR.
                            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
                            FIND FIRST regiao-cliente NO-LOCK
                                 WHERE regiao-cliente.nome-matriz = emitente.nome-matriz NO-ERROR.
                            IF AVAIL regiao-cliente THEN NEXT.


                            CREATE b-dc-orig-comis-movto.
                            ASSIGN b-dc-orig-comis-movto.num_id_comis_movto         = b-dc-comis-movto.num_id_comis_movto
                                   b-dc-orig-comis-movto.cod_empresa                = dc-orig-comis-movto.cod_empresa               
                                   b-dc-orig-comis-movto.cdn_repres                 = dc-orig-comis-movto.cdn_repres                
                                   b-dc-orig-comis-movto.num_seq_movto_comis        = dc-orig-comis-movto.num_seq_movto_comis       
                                   b-dc-orig-comis-movto.cod_estab                  = dc-orig-comis-movto.cod_estab                 
                                   b-dc-orig-comis-movto.num_id_tit_acr             = dc-orig-comis-movto.num_id_tit_acr            
                                   b-dc-orig-comis-movto.dat_transacao              = dc-orig-comis-movto.dat_transacao             
                                   b-dc-orig-comis-movto.val_perc_comis_repres      = dc-orig-comis-movto.val_perc_comis_repres      
                                   b-dc-orig-comis-movto.val_perc_comis_repres_emis = dc-orig-comis-movto.val_perc_comis_repres_emis
                                   b-dc-orig-comis-movto.val_base_comis             = dc-orig-comis-movto.val_base_comis            
                                   b-dc-orig-comis-movto.val_movto_comis            = dc-orig-comis-movto.val_movto_comis           
                                   b-dc-orig-comis-movto.ind_tip_movto              = dc-orig-comis-movto.ind_tip_movto             
                                   b-dc-orig-comis-movto.dat_vencto_tit_acr         = dc-orig-comis-movto.dat_vencto_tit_acr.

                            ASSIGN b-dc-comis-movto.val_movto                       = b-dc-comis-movto.val_movto + dc-orig-comis-movto.val_movto_comis.

                            CREATE bb-dc-orig-comis-movto.
                            ASSIGN bb-dc-orig-comis-movto.num_id_comis_movto         = bb-dc-comis-movto.num_id_comis_movto
                                   bb-dc-orig-comis-movto.cod_empresa                = dc-orig-comis-movto.cod_empresa               
                                   bb-dc-orig-comis-movto.cdn_repres                 = dc-orig-comis-movto.cdn_repres                
                                   bb-dc-orig-comis-movto.num_seq_movto_comis        = dc-orig-comis-movto.num_seq_movto_comis       
                                   bb-dc-orig-comis-movto.cod_estab                  = dc-orig-comis-movto.cod_estab                 
                                   bb-dc-orig-comis-movto.num_id_tit_acr             = dc-orig-comis-movto.num_id_tit_acr            
                                   bb-dc-orig-comis-movto.dat_transacao              = dc-orig-comis-movto.dat_transacao             
                                   bb-dc-orig-comis-movto.val_perc_comis_repres      = dc-orig-comis-movto.val_perc_comis_repres      
                                   bb-dc-orig-comis-movto.val_perc_comis_repres_emis = dc-orig-comis-movto.val_perc_comis_repres_emis
                                   bb-dc-orig-comis-movto.val_base_comis             = dc-orig-comis-movto.val_base_comis            
                                   bb-dc-orig-comis-movto.val_movto_comis            = dc-orig-comis-movto.val_movto_comis           
                                   bb-dc-orig-comis-movto.ind_tip_movto              = dc-orig-comis-movto.ind_tip_movto             
                                   bb-dc-orig-comis-movto.dat_vencto_tit_acr         = dc-orig-comis-movto.dat_vencto_tit_acr.

                            ASSIGN bb-dc-comis-movto.val_movto                       = bb-dc-comis-movto.val_movto + dc-orig-comis-movto.val_movto_comis.

                        END.

                        /* Caso n∆o encontre nenhum valor elimina os movimentos criados */
                        IF b-dc-comis-movto.val_movto = 0 THEN
                            DELETE b-dc-comis-movto.
                        IF bb-dc-comis-movto.val_movto = 0 THEN
                            DELETE bb-dc-comis-movto.
                    END.
               END.
           END.
           /* Fim - Bloco para criaá∆o das transaá‰es 102 e 202 */

        END. /* if tg-gera-movto-comis           */
    END. /* FOR EACH tt-repres NO-LOCK       */
END. /* if tg-imp-resumo                 */

IF  l-imp-param THEN DO:
    PAGE.
    DISPLAY c-lista-cod-estab   c-lista-cod-esp
            c-lista-cdn-repres 
            i-ini-cliente       i-fim-cliente
            i-ini-perc-comis    i-fim-perc-comis
            dt-ini-periodo      dt-fim-periodo
            c-ini-referencia    c-fim-referencia
        
            c-des-rs-classif 
    
            tg-imp-comissoes    tg-imp-resumo
            rs-data             tg-imp-resumo
            tg-rescisao         tg-paga-vinculada
            tg-paga-carteira
        
            c-destino           c-arquivo
            v_cod_usuar_corren  
            WITH FRAME f-selecao.
END.

IF  v_num_ped_exec_corren = 0 THEN DO:
    RUN pi-finalizar IN h-acomp.
END.

OUTPUT CLOSE.

{dop/dbt901.i2}

RETURN 'OK'.

/* fim relat¢rio */

PROCEDURE pi-busca-tit-original:
   DEF INPUT PARAM p-estab       AS CHAR NO-UNDO.
   DEF INPUT PARAM p-num-tit-acr AS INT  NO-UNDO.

   FIND FIRST b-movto-ren NO-LOCK 
        WHERE b-movto-ren.cod_estab           = p-estab
          AND b-movto-ren.num_id_tit_acr      = p-num-tit-acr
          AND b-movto-ren.ind_trans_acr_abrev = "REN" 
          AND NOT b-movto-ren.log_movto_estordo NO-ERROR.

   IF AVAIL b-movto-ren THEN DO:
      FIND FIRST b-movto-lqrn NO-LOCK                                        
           WHERE b-movto-lqrn.cod_estab           = b-movto-ren.cod_estab
             AND b-movto-lqrn.cod_refer           = b-movto-ren.cod_refer
             AND b-movto-lqrn.ind_trans_acr_abrev = "LQRN"
             AND NOT b-movto-lqrn.log_movto_estordo NO-ERROR.
      
      FIND FIRST b-tit-lqrn OF b-movto-lqrn NO-LOCK NO-ERROR.
      IF AVAIL b-tit-lqrn THEN DO:
         IF b-tit-lqrn.ind_orig_tit_acr BEGINS "FAT" THEN DO:
            ASSIGN i-num-tit-acr-orig = b-tit-lqrn.num_id_tit_acr.
         END.
         ELSE DO:
            RUN pi-busca-tit-original (INPUT b-tit-lqrn.cod_estab,
                                       INPUT b-tit-lqrn.num_id_tit_acr).
         END.
      END.
   END.
END PROCEDURE.
