/*****************************************************************************
** Include: doc023.i
** Autor..: Diomar Mhlmann
** Data...: Agosto/2007
******************************************************************************/

DEF TEMP-TABLE dc-desp-ccusto NO-UNDO
    FIELD cod_ccusto                 AS char   FORMAT "X(12)"           LABEL "Centro Custo"           COLUMN-LABEL "CCusto"
    FIELD cod_cta_ctbl               AS char   FORMAT "X(12)"           LABEL "Conta Cont bil"         COLUMN-LABEL "Conta"
    FIELD dat_transacao              AS date   FORMAT "99/99/9999"      LABEL "Data Transa‡Æo"         COLUMN-LABEL "Data Transa‡Æo"
    FIELD cod_modul_dtsul            AS char   FORMAT "X(3)"            LABEL "M¢dulo"                 COLUMN-LABEL "Mod"               
    FIELD cod_estab                  AS char   FORMAT "X(3)"            LABEL "Estabelecimento"        COLUMN-LABEL "Estab"
    FIELD num_id_movto_tit_ap        AS inte   FORMAT "9999999999"      LABEL "Token movto_tit_ap"     COLUMN-LABEL "Token movto_tit_ap"
    FIELD nr-trans                   AS inte   FORMAT "->>>,>>>,>>9"    LABEL "Trans"                  COLUMN-LABEL "Trans"
    FIELD num_lote_ctbl              AS INTE   FORMAT ">>>,>>>,>>9"     LABEL "Lote Ctbl"              COLUMN-LABEL "Lote Ctbl"
    FIELD num_lancto_ctbl            AS INTE   FORMAT ">>,>>>,>>9"      LABEL "Lacto Ctbl"             COLUMN-LABEL "Lacto Ctbl"
    FIELD num_seq_lancto_ctbl        AS INTE   FORMAT ">>>>9"           LABEL "Seq"                    COLUMN-LABEL "Seq"
    FIELD descricao                  AS char   FORMAT "X(2000)"         LABEL "Descri‡Æo"              COLUMN-LABEL "Descri‡Æo"
    FIELD val-movto                  AS DECIM  FORMAT "->>>,>>>,>>9.99" LABEL "Valor Movto"            COLUMN-LABEL "Valor Movto"
    INDEX ch-ccusto-data cod_ccusto
                         dat_transacao.

DEF TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_ccusto LIKE emsuni.ccusto.cod_ccusto.

DEF TEMP-TABLE tt-cta NO-UNDO
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD val-orcado   AS DEC
    FIELD val-realiz   AS DEC
    FIELD val-variac   AS DEC.

DEF TEMP-TABLE tt-cta-pesq NO-UNDO
    FIELD cod_estab          LIKE criter_distrib_cta_ctbl.cod_estab         
    FIELD cod_plano_cta_ctbl LIKE criter_distrib_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE criter_distrib_cta_ctbl.cod_cta_ctbl.

DEF TEMP-TABLE tt-detalhe NO-UNDO
    FIELD cod_cta_ctbl        LIKE dc-desp-ccusto.cod_cta_ctbl
    FIELD cod_ccusto          LIKE dc-desp-ccusto.cod_ccusto
    FIELD dat_transacao       LIKE dc-desp-ccusto.dat_transacao
    FIELD cod_modul_dtsul     LIKE dc-desp-ccusto.cod_modul_dtsul
    FIELD cod_estab           LIKE dc-desp-ccusto.cod_estab
    FIELD num_id_movto_tit_ap LIKE dc-desp-ccusto.num_id_movto_tit_ap
    FIELD nr-trans            LIKE dc-desp-ccusto.nr-trans
    FIELD num_lote_ctbl       LIKE dc-desp-ccusto.num_lote_ctbl      
    FIELD num_lancto_ctbl     LIKE dc-desp-ccusto.num_lancto_ctbl    
    FIELD num_seq_lancto_ctbl LIKE dc-desp-ccusto.num_seq_lancto_ctbl
    FIELD val-movto           LIKE dc-desp-ccusto.val-movto
    FIELD descricao           AS CHAR
    INDEX cta                 cod_cta_ctbl
                              cod_ccusto
                              dat_transacao
                              val-movto DESC.

DEF TEMP-TABLE tt-ccusto-cta NO-UNDO
    FIELD cod_cta_ctbl        LIKE dc-desp-ccusto.cod_cta_ctbl
    FIELD cod_ccusto          LIKE dc-desp-ccusto.cod_ccusto
    FIELD des_tit_ctbl        LIKE emsuni.ccusto.des_tit_ctbl
    FIELD val-orcado          AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD val-movto           LIKE dc-desp-ccusto.val-movto
    INDEX cta-ccusto          cod_cta_ctbl
                              cod_ccusto.

/* doc023.i */

