/* temp-tables ---------------------------- */
    DEFINE {1} SHARED TEMP-TABLE tt-filiais NO-UNDO
        FIELD log-matriz            AS   LOGICAL    FORMAT 'Sim/NÆo' COLUMN-LABEL 'Matr'
        FIELD nom_abrev             LIKE emsuni.cliente.nom_abrev
        FIELD cod_id_federal        LIKE pessoa_jurid.cod_id_feder
        FIELD cod_format_id_feder   LIKE emsuni.pais.cod_format_id_feder_fisic 
        FIELD cod_empresa           LIKE emsuni.cliente.cod_empresa
        FIELD cdn_cliente           LIKE emsuni.cliente.cdn_cliente
        FIELD nom_pessoa            LIKE emsuni.cliente.nom_pessoa
        FIELD lim-credito           AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'Lim Cr‚dito'
        FIELD lim-credito-pend      AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'NovoLC!Pend'
        FIELD dt-lim-cred           AS   DATE       FORMAT '99/99/9999'     COLUMN-LABEL 'Data lim Cr‚dito'
        FIELD dt-ult-alter          AS   DATE       FORMAT '99/99/9999'     COLUMN-LABEL 'Dt Ult Alter'    
        FIELD c-finalid-econ        AS   CHAR                               COLUMN-LABEL 'Finalidade'
        FIELD log-principal         AS   LOGICAL
        FIELD nom_cidade            LIKE emsuni.pessoa_jurid.nom_cidade
        FIELD cod_unid_federac      LIKE emsuni.pessoa_jurid.cod_unid_federac
        FIELD ind-abrange-aval      AS CHAR                                 COLUMN-LABEL 'Abr Aval'
        FIELD ind-cre-cli           AS CHAR FORMAT "x(12)"                  COLUMN-LABEL 'Tipo!Aval'
        FIElD ind_alert_lc_pend     AS CHAR FORMAT "x(01)"
        FIELD tot-saldo-aberto      AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'SdoAbert!CReceber'
        FIELD tot-ped-aprov         AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'Pedidos!Aprovador'
        FIELD de-tot-ped            AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'Total!Pedidos'
        FIELD de-lc-sugerido        AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'LC!Sugerido'        
        INDEX nom_abrev             log-matriz nom_abrev
        INDEX log-principal         log-principal.
                        
    DEFINE TEMP-TABLE tt-tit_acr NO-UNDO
        FIELD ind_tip               AS   CHARACTER  /*Vencidos/A Vencer/Vendor*/
        FIELD sit-renegoc           AS   CHARACTER    FORMAT "X(20)"              LABEL "Situa‡Æo"
        FIELD cdn_cliente           LIKE tit_acr.cdn_cliente
        FIELD cod_empresa           LIKE tit_acr.cod_empresa
        FIELD cod_estab             LIKE tit_acr.cod_estab
        FIELD cod_espec_docto       LIKE tit_acr.cod_espec_docto
        FIELD cod_ser_docto         LIKE tit_acr.cod_ser_docto
        FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
        FIELD cod_parcela           LIKE tit_acr.cod_parcela
        FIELD val_sdo_tit_acr       LIKE tit_acr.val_sdo_tit_acr
        FIELD dat_vencto_tit_acr    LIKE tit_acr.dat_vencto_tit_acr
        FIELD val_origin_tit_acr    LIKE tit_acr.val_origin_tit_acr
        FIELD dat_emis_docto        LIKE tit_acr.dat_emis_docto
        FIELD cod_portador          LIKE tit_acr.cod_portador
        FIELD cod_cart_bcia         LIKE tit_acr.cod_cart_bcia
        FIELD cod_tit_acr_bco       LIKE tit_acr.cod_tit_acr_bco
        FIELD cdn_repres            LIKE tit_acr.cdn_repres
        FIELD LOG_tip_cr_perda_dedut_tit LIKE tit_acr.LOG_tip_cr_perda_dedut_tit
        FIELD chq-devolvido         AS CHAR
        FIELD recid-tit_acr         AS   RECID
        FIElD ind_alert_av_pend     AS CHAR FORMAT "x(01)"
        INDEX dat_vencto_tit_acr    ind_tip dat_vencto_tit_acr
        INDEX val_sdo_tit_acr       ind_tip val_sdo_tit_acr.

    DEFINE TEMP-TABLE tt_estatis_clien_detalhe NO-UNDO
        FIELD ttv_num_cont_aux              AS INTEGER
        FIELD ttv_cod_periodo               AS CHARACTER    COLUMN-LABEL 'Per¡odo'      FORMAT 'x(8)'
        FIELD ttv_val_atraso_med_clien_2    AS DECIMAL      COLUMN-LABEL 'ATM'          FORMAT '->>9'
        FIELD ttv_val_praz_med_2            AS DECIMAL      COLUMN-LABEL 'PMR'          FORMAT '->>9'
        FIELD ttv_praz_titulos              AS DECIMAL
        FIELD ttv_titulos                   AS INT
        FIELD ttv_val_vendas_2              AS DECIMAL      COLUMN-LABEL 'Vendas'       FORMAT '->>>,>>>,>>9.99'
        FIELD ttv_val_sdo_clien_mes         AS DECIMAL
        FIELD ttv_val_devol_per             AS DECIMAL
        FIELD ano                           AS INTEGER.

    DEFINE TEMP-TABLE tt-pedido NO-UNDO
        FIELD rw-ped-venda      AS   ROWID
        FIELD cod_empresa       LIKE emsuni.empresa.cod_empresa
        FIELD cdn_cliente       LIKE emsuni.cliente.cdn_cliente
        FIELD nom_abrev         LIKE emsuni.cliente.nom_abrev
        FIELD nr-pedcli         AS   CHARACTER  FORMAT "X(12)" COLUMN-LABEL "Nr PedCli"
        FIELD nr-pedido         AS   INTEGER    FORMAT ">>>,>>>,>>9" COLUMN-LABEL "Nr Pedido"
        FIELD dt-implant        AS   DATE       FORMAT "99/99/9999" COLUMN-LABEL "Dt Implanta‡Æo"
        FIELD no-ab-reppri      AS   CHARACTER  FORMAT "X(12)" COLUMN-LABEL "Representante"
        FIELD vl-tot-ped        AS   DECIMAL    FORMAT ">,>>>,>>>,>>9.99" COLUMN-LABEL "Valor Total Pedido"
        FIELD cod-sit-aval      AS   INTEGER    FORMAT "99"     COLUMN-LABEL "Sit Cre"
        FIELD cod-sit-ped       AS   INTEGER    FORMAT "99"     COLUMN-LABEL "Sit Ped"
        FIELD desc-sit-aval     AS   CHARACTER  FORMAT "X(10)"  COLUMN-LABEL "Sit Cr‚dito"
        FIELD desc-sit-ped      AS   CHARACTER  FORMAT "X(10)"  COLUMN-LABEL "Sit Pedido"
        FIELD desc-bloq         AS   CHARACTER  FORMAT "X(76)"  COLUMN-LABEL "Descri‡Æo Bloqueio"
        FIELD completo          AS   LOGICAL    FORMAT "Sim/NÆo" COLUMN-LABEL "Completo"
        FIELD vl-liq-abe        LIKE ped-venda.vl-liq-abe
        FIELD ind_visualiz      AS   LOG
        FIELD c-anexo           AS   CHAR       .
           
    DEFINE {1} SHARED TEMP-TABLE tt-cotacao NO-UNDO
        FIELD cod_finalid_econ_base     LIKE finalid_econ.cod_finalid_econ
        FIELD cod_indic_econ_base       LIKE indic_econ.cod_indic_econ
        FIELD mo-codigo-base            AS   INTEGE /*LIKE moeda.mo-codigo*/
        FIELD tax_conversao             AS   DECIMAL.
    DEFINE {1} SHARED TEMP-TABLE tt-Limit_Cred_Sugerid NO-UNDO
        FIELD cod_empresa           LIKE emsuni.cliente.cod_empresa
        FIELD nom_abrev             LIKE emsuni.empresa.nom_abrev
        FIELD de-lc-sugerido        AS   DECIMAL    FORMAT '>>>,>>>,>>9.99' COLUMN-LABEL 'LC!Sugerido'
        INDEX pk_ttLimitCredSugerid IS PRIMARY UNIQUE
              cod_empresa.

/* vari veis ------------------------------ */

DEF {1} SHARED VAR c-cod_finalid_econ_apres  AS CHARACTER    NO-UNDO.
DEF {1} SHARED VAR c-cod_indic_econ_apres    AS CHARACTER    NO-UNDO.
DEF {1} SHARED VAR i-mo-codigo-apres         AS INTEGER      NO-UNDO.
DEF {1} SHARED VAR dt-cotacao                AS DATE         NO-UNDO.
DEF {1} SHARED VAR i-mes                     AS INTEGER      NO-UNDO.
DEF {1} SHARED VAR i-ano                     AS INTEGER      NO-UNDO.

/*sele‡Æo de t¡tulos dcr010h1*/
DEF {1} SHARED VAR c-ini-cod_empresa        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-fim-cod_empresa        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-ini-cod_estab          AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-fim-cod_estab          AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-lista-cod_espec_docto  AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-ini-cod_tit_acr        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-fim-cod_tit_acr        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-ini-cod_parcela        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-fim-cod_parcela        AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR c-lista-cdn_cliente      AS CHARACTER        NO-UNDO.
DEF {1} SHARED VAR dt-ini-emissao           AS DATE             NO-UNDO.
DEF {1} SHARED VAR dt-fim-emissao           AS DATE             NO-UNDO.
DEF {1} SHARED VAR dt-ini-vencto            AS DATE             NO-UNDO.
DEF {1} SHARED VAR dt-fim-vencto            AS DATE             NO-UNDO.
DEF {1} SHARED VAR i-ini-cdn_repres         AS INTEGER          NO-UNDO.
DEF {1} SHARED VAR i-fim-cdn_repres         AS INTEGER          NO-UNDO.
DEF {1} SHARED VAR de-ini-val_sdo           AS DECIMAL          NO-UNDO.
DEF {1} SHARED VAR de-fim-val_sdo           AS DECIMAL          NO-UNDO.
