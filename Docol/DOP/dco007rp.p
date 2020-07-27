/***********************************************************************************************************
** Programa.........: dco007
** Descricao .......: Demonstrativo Cont†bil de Comiss‰es (magnus docr113)
** Versao...........: 01.001
** Nome Externo.....: dop/dco007.w
** Autor............: Ivan Silveira
** Criado...........: 17/11/2003
************************************************************************************************************/
&GLOBAL-DEFINE programa dco007 /*nome_do_programa Exemplo: rel_clientes */

{include/i-prgvrs504.i {&programa} 5.05.00.000}
{utp/ut-glob504.i}
{include/i-rpvar504.i}
{doinc/fgl900zh.i} /* temp-tables */

DEF TEMP-TABLE tt_log_erro  NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER      FORMAT ">>>>,>>9"   LABEL "N£mero"          COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda AS CHARACTER    FORMAT "x(40)"      LABEL "Mensagem Ajuda"  COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro  AS CHARACTER    FORMAT "x(60)"      LABEL "Mensagem Erro"   COLUMN-LABEL "Inconsistància". 

{include/tt-edit.i}
{include/pi-edit.i}

/* Definiáao de Variaveis de Processamento do Relat¢rio */

DEF VAR i-cont                  AS INTEGER                          NO-UNDO.
DEF VAR i-param-posicao         AS INTEGER                          NO-UNDO.
DEF VAR c-param-variavel        AS CHARACTER                        NO-UNDO.
DEF VAR c-param-campos          AS CHARACTER                        NO-UNDO.
DEF VAR c-param-tipos           AS CHARACTER                        NO-UNDO.
DEF VAR c-param-dados           AS CHARACTER                        NO-UNDO.
    
DEF VAR de-tot-positivo         AS DECIMAL                          NO-UNDO.
DEF VAR de-tot-negativo         AS DECIMAL                          NO-UNDO.
DEF VAR i_num_lote_ctbl         AS INTEGER                          NO-UNDO.
DEF VAR de-tot-cred             AS DECIMAL                          NO-UNDO.
DEF VAR de-tot-deb              AS DECIMAL                          NO-UNDO.
DEF VAR i-seq_lancto_ctbl       AS INTEGER                          NO-UNDO.

DEF TEMP-TABLE tt-lancto-ctbl
    FIELD cod_tipo_lancto           AS   CHARACTER /* DB / CR */
    FIELD cod_unid_negoc            LIKE repres_financ.cod_unid_negoc
    FIELD cod_transacao             LIKE dc-comis-trans.cod_transacao
    FIELD val_lancto_ctbl           LIKE tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
    FIELD cod_plano_cta_ctbl        LIKE dc-comis-trans.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl              LIKE dc-comis-trans.cod_cta_ctbl      
    FIELD cod_plano_ccusto          LIKE dc-comis-trans.cod_plano_ccusto  
    FIELD cod_ccusto                LIKE dc-comis-trans.cod_ccusto        
    FIELD num_seq_lancto_ctbl       LIKE tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl
    FIELD num_seq_lancto_ctbl_cpart LIKE tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart
    INDEX cod_transacao             IS PRIMARY cod_tipo_lancto cod_transacao cod_unid_negoc.
DEF BUFFER b-tt-lancto-ctbl FOR tt-lancto-ctbl.

DEF TEMP-TABLE tt-erro              NO-UNDO
    FIELD cdn_repres                LIKE representante.cdn_repres
    FIELD des_erro                  AS   CHARACTER      FORMAT 'x(80)'
    INDEX cdn_repres                IS   PRIMARY cdn_repres.

DEF TEMP-TABLE tt-demon 
    FIELD cod_plano_cta_ctbl        LIKE dc-comis-movto.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl              LIKE dc-comis-movto.cod_cta_ctbl 
    FIELD cod_plano_ccusto          LIKE dc-comis-movto.cod_plano_ccusto
    FIELD cod_ccusto                LIKE dc-comis-movto.cod_ccusto
    FIELD dat_transacao             LIKE dc-comis-movto.dat_transacao
    FIELD cod_transacao             LIKE dc-comis-movto.cod_transacao
    FIELD des_transacao             LIKE dc-comis-movto.des_transacao 
    FIELD cdn_repres                LIKE dc-comis-movto.cdn_repres
    FIELD nom_abrev                 LIKE representante.nom_abrev
    FIELD cod_unid_negoc            LIKE repres_financ.cod_unid_negoc
    FIELD val-debito                LIKE dc-comis-movto.val_movto 
    FIELD val-credito               LIKE dc-comis-movto.val_movto
    FIELD ind_origin_movto          LIKE dc-comis-movto.ind_origin_movto.

DEF BUFFER b-tt-demon FOR tt-demon.

DEF TEMP-TABLE tt-rec-dc-comis-movto
    FIELD rec-dc-comis-movto        AS   RECID
    FIELD contabiliza               AS   LOGICAL
    FIELD criado                    AS   LOGICAL.

/* Vari†veis a serem recuperados pela DWB - set list param */
/* ======================================================= */
/* Provenientes da p†gina de impress∆o */
DEF VAR c-arquivo                   AS CHAR         NO-UNDO.
DEF VAR i-qtd-linhas                AS INTEGER      NO-UNDO.
DEF VAR c-destino                   AS CHAR         NO-UNDO.
DEF VAR l-imp-param                 AS LOGICAL      NO-UNDO.
/* Provenientes da p†gina de seleá∆o */
DEF VAR c-cod-empresa               AS CHAR         NO-UNDO.
DEF VAR dt-trans-ini                AS DATE         NO-UNDO.
DEF VAR dt-trans-fim                AS DATE         NO-UNDO.
DEF VAR c-cta-ini                   AS CHAR         NO-UNDO.
DEF VAR c-cta-fim                   AS CHAR         NO-UNDO.
DEF VAR c-ccusto-ini                AS CHAR         NO-UNDO.
DEF VAR c-ccusto-fim                AS CHAR         NO-UNDO.
DEF VAR i-cdn-repres-ini            AS INT          NO-UNDO.
DEF VAR i-cdn-repres-fim            AS INT          NO-UNDO.

/* Provenientes da p†gina de parÉmetros */
DEF VAR rs-operacao                 AS CHARACTER    NO-UNDO.

IF  v_cod_dwb_user = "" then
    ASSIGN  v_cod_dwb_user = v_cod_usuar_corren.
IF  v_cod_dwb_user BEGINS 'es_' THEN
    ASSIGN  v_cod_dwb_user = ENTRY(2, v_cod_dwb_user, "_").

/* Modo de execuá∆o   ( RPW ou On-line ) */
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
    END.
END.    

ASSIGN  c-param-campos  = ENTRY(1, c-param-dados, CHR(13))
        c-param-tipos   = ENTRY(2, c-param-dados, CHR(13))
        c-param-dados   = ENTRY(3, c-param-dados, CHR(13)).
  
{include/i-openpar504.i CHARACTER c-cod-empresa c-cta-ini c-cta-fim c-ccusto-ini c-ccusto-fim rs-operacao}
{include/i-openpar504.i DECIMAL   }  
{include/i-openpar504.i DATE      dt-trans-ini dt-trans-fim}
{include/i-openpar504.i INTEGER   i-cdn-repres-ini i-cdn-repres-fim}
{include/i-openpar504.i LOGICAL} 

/* ============================================================ */
/* Fim da busca dos parÉmetros gravados no DWB - set list param */

ASSIGN  c-programa     = "{&programa}"
        c-versao       = "1.00"
        c-revisao      = "000"
        c-titulo-relat = "Demonstrativo Cont†bil de Comiss‰es"
        c-sistema      = "CO".
FIND FIRST emsuni.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF  AVAIL empresa THEN 
    ASSIGN  c-empresa = empresa.nom_razao_social.

FORM 
    "SELEÄ«O"                       AT      03                          SKIP(1)
    c-cod-empresa                   COLON   25  FORMAT "X(3)"           LABEL "Empresa" 
    dt-trans-ini                    COLON   25  FORMAT "99/99/9999"     LABEL "Data Transaá∆o" "  < >"
    dt-trans-fim                    COLON   50  FORMAT "99/99/9999"  NO-LABEL
    c-cta-ini                       COLON   25  FORMAT "x(12)"          LABEL "Conta Cont†bil" "< >"
    c-cta-fim                       COLON   50  FORMAT "x(12)"       NO-LABEL
    c-ccusto-ini                    COLON   25  FORMAT "x(12)"          LABEL "Centro de Custo" "< >"
    c-ccusto-fim                    COLON   50  FORMAT "x(12)"       NO-LABEL 
    i-cdn-repres-ini                COLON   25  FORMAT ">>>,>>9"        LABEL "Representante"   "< >"
    i-cdn-repres-fim                COLON   50  FORMAT ">>>,>>9"     NO-LABEL SKIP(1)
                                    
    "PAR∂METROS"                    AT      03                          SKIP(1)
    rs-operacao                     COLON   25  FORMAT "X(20)"          LABEL "Operaá∆o"
    SKIP(2)                         
    "IMPRESS«O"                     AT      03                          SKIP(1)
    c-destino                       COLON   25  FORMAT "X(12)"          LABEL "Destino"
    c-arquivo                       AT      40  FORMAT "X(70)"          NO-LABEL
    v_cod_usuar_corren              COLON   25  FORMAT "X(20)"          LABEL "Usu†rio"
    WITH FRAME f-selecao NO-BOX STREAM-IO WIDTH 132 SIDE-LABELS.

FORM 
    representante.cdn_repres    COLUMN-LABEL 'C¢d'
    representante.nom_pessoa    COLUMN-LABEL 'Representante'        FORMAT 'x(30)'
    tt-erro.des_erro            COLUMN-LABEL 'Descriá∆o do Erro'    FORMAT 'x(93)'
    WITH NO-BOX WIDTH 132 FRAME f-erro DOWN STREAM-IO.

FUNCTION fi-taxa-ir RETURNS DECIMAL 
   (INPUT i-num_pessoa              AS INTEGER  ,
    INPUT de-vl-tit                 AS DECIMAL  )   FORWARD.

/* Prepara o cabeáalho e seta saida para terminal, impressora ou arquivo */
{include/i-rpcab504.i}
{include/rp-output504.i} 

DEF NEW SHARED STREAM s_1.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEFINE VAR h-acomp AS HANDLE NO-UNDO.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio").

/* Parametrizaá∆o */
FIND FIRST empresa NO-LOCK
     WHERE empresa.cod_empresa  = c-cod-empresa NO-ERROR.
FIND FIRST param_estab_comis NO-LOCK 
     WHERE param_estab_comis.cod_empresa                = c-cod-empresa
       AND param_estab_comis.dat_inic_valid            <= TODAY
       AND param_estab_comis.dat_fim_valid             >= TODAY NO-ERROR.
FIND FIRST dc-param_estab_comis NO-LOCK
     WHERE dc-param_estab_comis.cod_empresa             = param_estab_comis.cod_empresa
       AND dc-param_estab_comis.cod_comis_vda_estab     = param_estab_comis.cod_comis_vda_estab
       AND dc-param_estab_comis.num_seq_param_comis_vda = param_estab_comis.num_seq_param_comis_vda NO-ERROR.
/* FIM - parametrizaá∆o */

/* Atualizaá∆o */
ASSIGN  i_num_lote_ctbl     = 0.

FOR EACH tt-demon:              DELETE  tt-demon.               END.
FOR EACH tt-rec-dc-comis-movto: DELETE  tt-rec-dc-comis-movto.  END.
FOR EACH tt_log_erro:           DELETE  tt_log_erro.            END.
    
/* Criaá∆o lote cont†bil */
RUN pi-acompanhar IN h-acomp ('Criando Lote Cont†bil...').

FIND FIRST finalid_econ NO-LOCK
     WHERE finalid_econ.cod_finalid_econ = param_estab_comis.cod_finalid_econ NO-ERROR.
IF  NOT AVAIL finalid_econ THEN
    FIND FIRST finalid_econ NO-LOCK
         WHERE finalid_econ.cod_finalid_econ = 'corrente' NO-ERROR.
FIND FIRST histor_finalid_econ NO-LOCK
     WHERE histor_finalid_econ.cod_finalid_econ        = finalid_econ.cod_finalid_econ
       AND histor_finalid_econ.dat_fim_valid_finalid  >= TODAY
       AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY NO-ERROR.
        
IF  rs-operacao = 'Contabiliza' THEN DO:
END.
/* FIM - criaá∆o lote contabil */
 
RUN pi-acompanhar IN h-acomp ('Verificando Representantes... ').

bloco-representante:
FOR EACH representante  NO-LOCK
   WHERE representante.cod_empresa  = c-cod-empresa
     AND representante.cdn_repres  >= i-cdn-repres-ini
     AND representante.cdn_repres  <= i-cdn-repres-fim:

    FIND FIRST dc-comis-movto NO-LOCK
         WHERE dc-comis-movto.cod_empresa    = representante.cod_empresa
           AND dc-comis-movto.cdn_repres     = representante.cdn_repres
           AND dc-comis-movto.dat_transacao >= dt-trans-ini
           AND dc-comis-movto.dat_transacao <= dt-trans-fim NO-ERROR.
    IF  NOT AVAIL dc-comis-movto THEN NEXT.

    FIND FIRST repres_financ NO-LOCK
         WHERE repres_financ.cod_empresa    = representante.cod_empresa
           AND repres_financ.cdn_repres     = representante.cdn_repres NO-ERROR.
    IF  NOT AVAIL repres_financ THEN DO: 
        CREATE  tt-erro.
        ASSIGN  tt-erro.cdn_repres  = representante.cdn_repres
                tt-erro.des_erro    = 'REP - Representante Financeiro n∆o encontrado'.
        NEXT bloco-representante.
    END.

    RUN pi-acompanhar IN h-acomp ('Lendo Representante ' + STRING(representante.cdn_repres) + "-" + representante.nom_abrev).

    ASSIGN  de-tot-positivo     = 0
            de-tot-negativo     = 0.
        
    IF  rs-operacao = 'Contabiliza' OR 
        rs-operacao = 'Relat¢rio' THEN DO:
        RUN pi-contabiliza.
    END.
    IF  rs-operacao = 'descontabiliza' THEN DO:
        FIND FIRST dc-comis-movto NO-LOCK
             WHERE dc-comis-movto.cod_empresa       = representante.cod_empresa
               AND dc-comis-movto.cdn_repres        = representante.cdn_repres
               AND dc-comis-movto.cod_transacao     = 90
               AND dc-comis-movto.dat_transacao    >= dt-trans-ini
               AND dc-comis-movto.dat_transacao    <= dt-trans-fim
               AND dc-comis-movto.flag-contabilizou   NO-ERROR.
        IF  AVAIL dc-comis-movto THEN
            ASSIGN  i_num_lote_ctbl = dc-comis-movto.num_lote_ctbl.
    END.

END. /* for each repres */

IF  rs-operacao     = 'descontabiliza'  AND 
    i_num_lote_ctbl = 0                 THEN DO:
    CREATE  tt-erro.
    ASSIGN  tt-erro.des_erro    = 'COM Imposs°vel descontabilizar, n∆o foi encontrado ' + 
                                   'nenhuma comiss∆o contabilizada no per°odo informado.'.
END.

/* Demonstrativo */
FIND FIRST tt-demon NO-ERROR.
IF AVAIL tt-demon THEN
   RUN pi-acompanhar IN h-acomp ('Imprimindo Demonstrativo...').

FOR EACH tt-demon NO-LOCK
   WHERE tt-demon.cod_cta_ctbl >= c-cta-ini
     AND tt-demon.cod_cta_ctbl <= c-cta-fim
     AND tt-demon.cod_ccusto   >= c-ccusto-ini
     AND tt-demon.cod_ccusto   <= c-ccusto-fim
    BREAK BY tt-demon.cod_plano_cta_ctbl
          BY tt-demon.cod_cta_ctbl
          BY tt-demon.cod_transacao
          BY tt-demon.des_transacao
          BY tt-demon.cdn_repres
          BY tt-demon.dat_transacao:

    FORM tt-demon.cod_transacao            COLUMN-LABEL 'Tran'
         tt-demon.des_transacao            
         tt-demon.cdn_repres
         tt-demon.nom_abrev
         tt-demon.cod_ccusto               COLUMN-LABEL 'CCusto'
         tt-demon.dat_transacao            COLUMN-LABEL 'Dt Transac'
         tt-demon.ind_origin_movto         
         tt-demon.val-debito               COLUMN-LABEL "Valor DB"
         tt-demon.val-credito              COLUMN-LABEL "Valor CR"
         WITH NO-BOX STREAM-IO WIDTH 132 FRAME f-demon DOWN.

    ACCUM tt-demon.val-debito  (TOTAL BY tt-demon.cod_transacao BY tt-demon.cod_cta_ctbl).
    ACCUM tt-demon.val-credito (TOTAL BY tt-demon.cod_transacao BY tt-demon.cod_cta_ctbl).

    IF  FIRST-OF(tt-demon.cod_cta_ctbl) THEN DO:
        FIND FIRST cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_plano_cta_ctbl  = tt-demon.cod_plano_cta_ctbl
               AND cta_ctbl.cod_cta_ctbl        = tt-demon.cod_cta_ctbl NO-ERROR.
        DISPLAY "Conta Cont†bil: " 
               (tt-demon.cod_plano_cta_ctbl + " - " + tt-demon.cod_cta_ctbl +  " - " +
               (IF  AVAIL cta_ctbl THEN cta_ctbl.des_tit_ctbl ELSE '')) FORMAT 'x(70)' SKIP(1)
                WITH FRAME f-extra-cta NO-LABEL NO-BOX WIDTH 132.
        ASSIGN  de-tot-cred = 0
                de-tot-deb  = 0.
    END.

    IF  FIRST-OF(tt-demon.cod_transacao) THEN DO:
        DISPLAY tt-demon.cod_transacao
                tt-demon.des_transacao WITH FRAME f-demon.
    END.

    DISPLAY tt-demon.cdn_repres
            tt-demon.nom_abrev
            tt-demon.cod_ccusto
            tt-demon.dat_transacao
            tt-demon.ind_origin_movto
            tt-demon.val-debito  WHEN tt-demon.val-debito <> 0
            tt-demon.val-credito WHEN tt-demon.val-credito <> 0
            WITH FRAME f-demon.
    DOWN WITH FRAME f-demon.

    IF  LAST-OF(tt-demon.cod_transacao) THEN DO:
        UNDERLINE tt-demon.val-debito
                  tt-demon.val-credito WITH FRAME f-demon.
        DOWN WITH FRAME f-demon.
        DISP string("Total da Transacao " + STRING(tt-demon.cod_transacao)) @ tt-demon.des_transacao
             ACCUM TOTAL BY tt-demon.cod_transacao tt-demon.val-debito      @ tt-demon.val-debito
             ACCUM TOTAL BY tt-demon.cod_transacao tt-demon.val-credito     @ tt-demon.val-credito WITH FRAME f-demon.
        DOWN WITH FRAME f-demon.
        PUT SKIP(1).
    END.

    IF  LAST-OF(tt-demon.cod_cta_ctbl) THEN DO:
        UNDERLINE tt-demon.val-debito
                  tt-demon.val-credito WITH FRAME f-demon.
        DOWN WITH FRAME f-demon.
        DISP string("Total da Conta " + STRING(tt-demon.cod_cta_ctbl)) @ tt-demon.des_transacao
             ACCUM TOTAL BY tt-demon.cod_cta_ctbl tt-demon.val-debito  @ tt-demon.val-debito
             ACCUM TOTAL BY tt-demon.cod_cta_ctbl tt-demon.val-credito @ tt-demon.val-credito WITH FRAME f-demon.
        DOWN WITH FRAME f-demon.
        PUT FILL("-",132) FORMAT "x(132)" AT 01.
    END.

    IF  LAST(tt-demon.cod_plano_cta_ctbl) THEN DO:
        DISP "Total do Lote:"                 @ tt-demon.des_transacao
             ACCUM TOTAL tt-demon.val-debito  @ tt-demon.val-debito
             ACCUM TOTAL tt-demon.val-credito @ tt-demon.val-credito WITH FRAME f-demon.
        DOWN WITH FRAME f-demon.
        PUT FILL("-",132) FORMAT "x(132)" AT 01 SKIP(1).
    END.

END. /* FOR EACH tt-demon */
/* FIM - Demonstrativo */

FIND FIRST tt-erro NO-LOCK NO-ERROR.
IF  NOT AVAIL tt-erro THEN DO:
    bloco-transacao:
    DO  TRANSACTION ON ERROR UNDO bloco-transacao, LEAVE:

        IF  rs-operacao = 'contabiliza' THEN DO:
            /* Lote Contabilidade */
            CREATE  tt_integr_lote_ctbl.
            ASSIGN  tt_integr_lote_ctbl.tta_cod_modul_dtsul             = 'FGL' 
                    tt_integr_lote_ctbl.tta_num_lote_ctbl               = CURRENT-VALUE(seq_lote_ctbl) + 1
                    tt_integr_lote_ctbl.tta_des_lote_ctbl               = 'Movto Comiss‰es ' + STRING(dt-trans-ini,'99/99/9999') + ' Ö ' + STRING(dt-trans-fim,'99/99/9999')
                    tt_integr_lote_ctbl.tta_cod_empresa                 = c-cod-empresa
                    tt_integr_lote_ctbl.tta_dat_lote_ctbl               = dt-trans-fim
                    tt_integr_lote_ctbl.ttv_ind_erro_valid              = "N∆o"
                    tt_integr_lote_ctbl.tta_log_integr_ctbl_online      = YES. 
            CREATE  tt_integr_lancto_ctbl.
            ASSIGN  tt_integr_lancto_ctbl.tta_cod_cenar_ctbl            = 'Fiscal'
                    tt_integr_lancto_ctbl.tta_log_lancto_conver         = NO
                    tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo  = NO 
                    tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl      = RECID(tt_integr_lote_ctbl)
                    tt_integr_lancto_ctbl.tta_num_lancto_ctbl           = 1
                    tt_integr_lancto_ctbl.ttv_ind_erro_valid            = "N∆o" 
                    tt_integr_lancto_ctbl.tta_dat_lancto_ctbl           = dt-trans-fim.
            /* FIM - lote Contabilidade */

            FIND FIRST finalid_econ NO-LOCK
                 WHERE finalid_econ.cod_finalid_econ = param_estab_comis.cod_finalid_econ NO-ERROR.
            IF  NOT AVAIL finalid_econ THEN
                FIND FIRST finalid_econ NO-LOCK
                     WHERE finalid_econ.cod_finalid_econ = 'corrente' NO-ERROR.
            FIND FIRST histor_finalid_econ NO-LOCK
                 WHERE histor_finalid_econ.cod_finalid_econ        = finalid_econ.cod_finalid_econ
                   AND histor_finalid_econ.dat_fim_valid_finalid  >= TODAY
                   AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY NO-ERROR.
    
            RUN pi-acompanhar IN h-acomp ('Gerando Itens de Implantaá∆o FGL...').
            
            FOR EACH tt-lancto-ctbl NO-LOCK:
                CREATE  tt_integr_item_lancto_ctbl.
                ASSIGN  tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = RECID(tt_integr_lancto_ctbl)
                        tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = tt-lancto-ctbl.num_seq_lancto_ctbl
                        tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = tt-lancto-ctbl.cod_tipo_lancto
                        tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = tt-lancto-ctbl.cod_plano_cta_ctbl
                        tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = tt-lancto-ctbl.cod_cta_ctbl
                        tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = tt-lancto-ctbl.cod_plano_ccusto  
                        tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = tt-lancto-ctbl.cod_ccusto
                        tt_integr_item_lancto_ctbl.tta_cod_estab                    = v_cod_estab_usuar
                        tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = tt-lancto-ctbl.cod_unid_negoc
                        tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = tt_integr_lote_ctbl.tta_des_lote_ctbl
                        tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = histor_finalid_econ.cod_indic_econ
                        tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-trans-fim
                        tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = tt-lancto-ctbl.val_lancto_ctbl
                        tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = tt-lancto-ctbl.num_seq_lancto_ctbl_cpart
                        tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "N∆o" .
                
                CREATE  tt_integr_aprop_lancto_ctbl.
                ASSIGN  tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = finalid_econ.cod_finalid_econ
                        tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                        tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                        tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                        tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
                        tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                        tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                        tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = dt-trans-fim
                        tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                        tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "N∆o" 
                        tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
            END. /* FOR EACH tt-lancto-ctbl */
            RUN pi-acompanhar IN h-acomp ('Integrando Lanáamentos ao FGL...').

            RUN prgfin/fgl/fgl900zh.py (3               ,  "Aborta Tudo"        ,
                                        NO              ,   NO                  ,
                                        "Apropriaá∆o"   ,   "Com Erro"          ,
                                        YES             ,   YES                 ).
            
            RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros FGL...').
    
            FIND FIRST tt_integr_ctbl_valid NO-LOCK NO-ERROR.
            IF  AVAIL tt_integr_ctbl_valid THEN DO:
                /* Elimina dc-comis-movto criados */
                FOR EACH tt-rec-dc-comis-movto:
    
                    FIND FIRST dc-comis-movto
                         WHERE RECID(dc-comis-movto) = tt-rec-dc-comis-movto.rec-dc-comis-movto NO-ERROR.
    
                    IF  tt-rec-dc-comis-movto.criado THEN 
                        DELETE  dc-comis-movto.
                    IF  tt-rec-dc-comis-movto.contabiliza THEN
                        ASSIGN  dc-comis-movto.num_lote_ctbl        = 0
                                dc-comis-movto.flag-contabilizou    = NO.
                END. /*FOR EACH tt-rec-dc-comis-movto*/
    
                FOR EACH tt_integr_ctbl_valid NO-LOCK:
                    RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                     INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                    CREATE  tt-erro.
                    ASSIGN  tt-erro.des_erro    = 'FGL ' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
                                                   RETURN-VALUE + CHR(10) + tt_integr_ctbl_valid.ttv_ind_pos_erro.
        
                    CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:
                        WHEN 'ITEM' THEN DO:
                            FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                                 WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
                            IF  AVAIL tt_integr_item_lancto_ctbl THEN DO:
                               ASSIGN  tt-erro.des_erro = tt-erro.des_erro + 
                                       ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl)  + 
                                       ' Nat:' + tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl          +
                                       ' PCT:' + tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl             +
                                       ' CTA:' + tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                   +
                                       ' PCC:' + tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto               +
                                       ' CCU:' + IF tt_integr_item_lancto_ctbl.tta_cod_ccusto = ? THEN 'N∆o Informado' ELSE tt_integr_item_lancto_ctbl.tta_cod_ccusto + 
                                       ' EST:' + tt_integr_item_lancto_ctbl.tta_cod_estab                      + 
                                       ' UNG:' + tt_integr_item_lancto_ctbl.tta_cod_unid_negoc                 +
                                       ' HIS:' + tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl         +
                                       ' IEC:' + tt_integr_item_lancto_ctbl.tta_cod_indic_econ                 +
                                       ' DAT:' + STRING(tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl)        +
                                       ' VAL:' + STRING(tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl)        + 
                                       ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart) .
                            END.
                        END.
                    END CASE.
                END. /* FOR EACH tt_integr_ctbl_valid */
            END.   /* IF  AVAIL tt_integr_ctbl_valid */
            ELSE DO:
                FOR EACH tt-rec-dc-comis-movto 
                   WHERE tt-rec-dc-comis-movto.contabiliza.
                   /* Seta Movimentos como Contabilizados */
                   FIND FIRST dc-comis-movto
                        WHERE RECID(dc-comis-movto) = tt-rec-dc-comis-movto.rec-dc-comis-movto NO-ERROR.
                   IF  AVAIL dc-comis-movto THEN
                       ASSIGN  dc-comis-movto.num_lote_ctbl        = tt_integr_lote_ctbl.tta_num_lote_ctbl
                               dc-comis-movto.flag-contabilizou    = YES.
                END. /* for each tt-rec-dc-comis-movto */
            END.   /* else                           */
        END.     /*contabiliza                      */
    
        /* Descontabiliza */
        IF  rs-operacao = 'descontabiliza' THEN DO:
            RUN pi-acompanhar IN h-acomp ('Descontabilizando FGL... ').
            RUN prgfin/fgl/fgl201za.py (INPUT 1,
                                        INPUT i_num_lote_ctbl,
                                        INPUT 0,
                                        INPUT 'Eliminar',
                                        OUTPUT TABLE tt_log_erro).
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.

            IF  AVAIL tt_log_erro THEN DO:
                RUN MESSAGE.p ('Erro na Descontabilizaá∆o!',
                               'Ocorreu erro na descontabilizaá∆o, verifique mensagens de erro no arquivo.').
                FOR EACH tt_log_erro NO-LOCK:
                    CREATE  tt-erro.
                    ASSIGN  tt-erro.des_erro    = 'FGL Erro: ' + STRING(tt_log_erro.ttv_num_cod_erro) + 
                                                   '  Ajuda: ' + tt_log_erro.ttv_des_msg_ajuda + 
                                                   ' Mensag: ' + tt_log_erro.ttv_des_msg_erro.
                END.
            END.
            ELSE DO:
                FOR EACH dc-comis-movto 
                   WHERE dc-comis-movto.cod_empresa     = c-cod-empresa
                    AND  dc-comis-movto.dat_transacao  >= dt-trans-ini:

                    IF  dc-comis-movto.ind_origin_movto = "dco007"                                                     AND 
                       (dc-comis-movto.cod_transacao    = 4                                                             OR 
                       (dc-comis-movto.cod_transacao    = 900 AND NOT dc-comis-movto.flag-integrou-apb)                 OR 
                       (dc-comis-movto.cod_transacao    = 5   AND dc-comis-movto.num_lote_ctbl   <> i_num_lote_ctbl)) THEN DO:
                        DELETE dc-comis-movto.
                    END.
                    ELSE DO:
                       IF dc-comis-movto.num_lote_ctbl = i_num_lote_ctbl THEN DO:
                          ASSIGN  dc-comis-movto.num_lote_ctbl        = 0
                                  dc-comis-movto.flag-contabilizou    = NO.
                       END.
                    END.
                END. /* for each dc-comis-movto */
            END. /* Else do */
        END. /* Descontabiliza */
    END.   /* Do Transaction */
END.     /* IF  NOT AVAIL tt-erro */

/* Listagem de erros */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    RUN pi-acompanhar IN h-acomp ('Imprimindo listagem de erros...').
    PUT SKIP(2)
        "Listagem de ERROS e INCONSIST“NCIAS" AT 20
        "-----------------------------------" AT 20
        SKIP(2).

    FOR EACH tt-erro NO-LOCK
       BREAK BY tt-erro.cdn_repres:
        
        IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:
            FIND FIRST representante NO-LOCK
                 WHERE representante.cdn_repres = tt-erro.cdn_repres NO-ERROR.
            IF  AVAIL representante THEN
                DISPLAY representante.cdn_repres
                        representante.nom_pessoa
                        WITH FRAME f-erro.
        END. /*IF  FIRST-OF(tt-erro.cdn_repres) THEN */
        
        FOR EACH tt-editor:     DELETE  tt-editor.      END.
        RUN pi-print-editor (tt-erro.des_erro,  92).
        FOR EACH tt-editor:
            DISPLAY tt-editor.conteudo @ tt-erro.des_erro WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
        END. /* FOR EACH tt-editor*/
    END. /* FOR EACH tt-erro */
END.
/* FIM - Listagem de erros */

  
IF  l-imp-param THEN DO:
    PAGE.
    DISPLAY c-cod-empresa 
            dt-trans-ini
            dt-trans-fim
            c-cta-ini
            c-cta-fim
            c-ccusto-ini
            c-ccusto-fim
            i-cdn-repres-ini
            i-cdn-repres-fim
  
            rs-operacao

            c-destino                   c-arquivo
            v_cod_usuar_corren  
            WITH FRAME f-selecao.
END.

RUN pi-finalizar IN h-acomp.

OUTPUT CLOSE.
/* Fim relat¢rio */

PROCEDURE pi-contabiliza:

    IF rs-operacao = "Contabiliza" THEN DO:
       /* APB - fechamento do màs */
       bloco-apb: DO:
           FOR EACH dc-comis-movto NO-LOCK
              WHERE dc-comis-movto.cod_empresa     = representante.cod_empresa
                AND dc-comis-movto.cdn_repres      = representante.cdn_repres
                AND dc-comis-movto.dat_transacao  >= dt-trans-ini
                AND dc-comis-movto.dat_transacao  <= dt-trans-fim,
              FIRST dc-comis-trans NO-LOCK 
              WHERE dc-comis-trans.cod_transacao   = dc-comis-movto.cod_transacao
                AND dc-comis-trans.dat_inic_valid <= dc-comis-movto.dat_transacao
                AND dc-comis-trans.dat_fim_valid  >= dc-comis-movto.dat_transacao
                AND dc-comis-trans.ind_incid_liquido <> 'N∆o incide' :
       
               IF  dc-comis-trans.ind_incid_liquido = 'Positivo' 
                   THEN ASSIGN  de-tot-positivo = de-tot-positivo + dc-comis-movto.val_movto.
                   ELSE ASSIGN  de-tot-negativo = de-tot-negativo + dc-comis-movto.val_movto.
           END.
       
           IF  de-tot-positivo < de-tot-negativo THEN DO:
               /* Zera as contas no màs atual */
               FIND FIRST dc-comis-trans NO-LOCK
                    WHERE dc-comis-trans.cod_transacao = 4 NO-ERROR.
               FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                               AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                               AND dc-comis-trans-ctb.cod_empresa    = representante.cod_empresa NO-LOCK NO-ERROR.
               find first dc-comis-movto
                    where dc-comis-movto.cod_empresa          = representante.cod_empresa
                      and dc-comis-movto.cdn_repres           = representante.cdn_repres
                      and dc-comis-movto.ind_origin_movto     = 'dco007'
                      and dc-comis-movto.dat_transacao        = dt-trans-fim
                      and dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao no-error.
               IF NOT AVAIL dc-comis-movto THEN DO:
                   CREATE  dc-comis-movto.
                   ASSIGN  dc-comis-movto.cod_empresa          = representante.cod_empresa
                           dc-comis-movto.cdn_repres           = representante.cdn_repres
                           dc-comis-movto.ind_origin_movto     = 'dco007'
                           dc-comis-movto.dat_transacao        = dt-trans-fim
                           dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao
                           dc-comis-movto.des_transacao        = dc-comis-trans.descricao
                           dc-comis-movto.cod_plano_cta_ctbl   = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_cta_ctbl else dc-comis-trans.cod_plano_cta_ctbl
                           dc-comis-movto.cod_cta_ctbl         = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_cta_ctbl       else dc-comis-trans.cod_cta_ctbl      
                           dc-comis-movto.cod_plano_ccusto     = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_ccusto   else dc-comis-trans.cod_plano_ccusto  
                           dc-comis-movto.cod_ccusto           = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_ccusto         else dc-comis-trans.cod_ccusto        
                           dc-comis-movto.val_movto            = de-tot-negativo - de-tot-positivo.
                      
                   /* Temp-table p/ depois de contabilizado o lote, atualizar o campo dc-comis-movto.num_lote_ctbl */
                   CREATE  tt-rec-dc-comis-movto.
                   ASSIGN  tt-rec-dc-comis-movto.rec-dc-comis-movto    = RECID(dc-comis-movto)
                           tt-rec-dc-comis-movto.criado                = YES.
           
                   /* Gera saldo negativo no pr¢ximo màs */
                   FIND FIRST dc-comis-trans NO-LOCK
                        WHERE dc-comis-trans.cod_transacao = 5 NO-ERROR.
                   FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                                   AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                                   AND dc-comis-trans-ctb.cod_empresa    = representante.cod_empresa NO-LOCK NO-ERROR.
                   find first dc-comis-movto
                       where dc-comis-movto.cod_empresa          = representante.cod_empresa
                         and dc-comis-movto.cdn_repres           = representante.cdn_repres
                         and dc-comis-movto.ind_origin_movto     = 'dco007'
                         and dc-comis-movto.dat_transacao        = dt-trans-fim
                         and dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao no-error.
                   IF NOT AVAIL dc-comis-movto THEN DO:
                      CREATE  dc-comis-movto.
                      ASSIGN  dc-comis-movto.cod_empresa          = representante.cod_empresa
                              dc-comis-movto.cdn_repres           = representante.cdn_repres
                              dc-comis-movto.ind_origin_movto     = 'dco007'
                              dc-comis-movto.dat_transacao        = dt-trans-fim + 1
                              dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao
                              dc-comis-movto.des_transacao        = dc-comis-trans.descricao
                              dc-comis-movto.cod_plano_cta_ctbl   = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_cta_ctbl else dc-comis-trans.cod_plano_cta_ctbl
                              dc-comis-movto.cod_cta_ctbl         = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_cta_ctbl       else dc-comis-trans.cod_cta_ctbl      
                              dc-comis-movto.cod_plano_ccusto     = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_ccusto   else dc-comis-trans.cod_plano_ccusto  
                              dc-comis-movto.cod_ccusto           = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_ccusto         else dc-comis-trans.cod_ccusto        
                              dc-comis-movto.val_movto            = de-tot-negativo - de-tot-positivo.
                   END.
                   
                   /* Temp-table p/ depois de contabilizado o lote, atualizar o campo dc-comis-movto.num_lote_ctbl */
                   CREATE  tt-rec-dc-comis-movto.
                   ASSIGN  tt-rec-dc-comis-movto.rec-dc-comis-movto    = RECID(dc-comis-movto)
                           tt-rec-dc-comis-movto.criado                = YES.
               END.
    
               ASSIGN  de-tot-positivo = de-tot-negativo.
    
           END. /* IF  de-tot-positivo < de-tot-negativo */
       
           /* Movimento total para APB */
           FIND FIRST dc-comis-movto NO-LOCK
                WHERE dc-comis-movto.cod_empresa   = representante.cod_empresa
                  AND dc-comis-movto.cdn_repres    = representante.cdn_repres
                  AND dc-comis-movto.cod_transacao = 6 NO-ERROR. /* Rescis∆o */
           IF NOT AVAIL dc-comis-movto THEN DO:
              find first dc-comis-movto
                   where dc-comis-movto.cod_empresa          = representante.cod_empresa
                     and dc-comis-movto.cdn_repres           = representante.cdn_repres
                     and dc-comis-movto.ind_origin_movto     = 'Rescisao'
                     and dc-comis-movto.dat_transacao        > dt-trans-ini
                     and dc-comis-movto.cod_transacao        = 900 no-error.
              IF NOT AVAIL dc-comis-movto THEN DO:
                 FIND FIRST dc-comis-trans NO-LOCK
                      WHERE dc-comis-trans.cod_transacao = 900 NO-ERROR.
                 FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                                 AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                                 AND dc-comis-trans-ctb.cod_empresa    = representante.cod_empresa NO-LOCK NO-ERROR.
       
                 find first dc-comis-movto
                      where dc-comis-movto.cod_empresa          = representante.cod_empresa
                        and dc-comis-movto.cdn_repres           = representante.cdn_repres
                        and dc-comis-movto.ind_origin_movto     = 'dco007'
                        and dc-comis-movto.dat_transacao        = dt-trans-fim
                        and dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao no-error.
                 IF NOT AVAIL dc-comis-movto THEN DO:
                     CREATE  dc-comis-movto.
                     ASSIGN  dc-comis-movto.cod_empresa          = representante.cod_empresa
                             dc-comis-movto.cdn_repres           = representante.cdn_repres
                             dc-comis-movto.ind_origin_movto     = 'dco007'
                             dc-comis-movto.dat_transacao        = dt-trans-fim
                             dc-comis-movto.cod_transacao        = dc-comis-trans.cod_transacao
                             dc-comis-movto.des_transacao        = dc-comis-trans.descricao
                             dc-comis-movto.cod_plano_cta_ctbl   = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_cta_ctbl else dc-comis-trans.cod_plano_cta_ctbl
                             dc-comis-movto.cod_cta_ctbl         = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_cta_ctbl       else dc-comis-trans.cod_cta_ctbl      
                             dc-comis-movto.cod_plano_ccusto     = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_plano_ccusto   else dc-comis-trans.cod_plano_ccusto  
                             dc-comis-movto.cod_ccusto           = if avail dc-comis-trans-ctb then dc-comis-trans-ctb.cod_ccusto         else dc-comis-trans.cod_ccusto        
                             dc-comis-movto.val_movto            = de-tot-positivo - de-tot-negativo.
                 END.
                 /* Temp-table p/ depois de contabilizado o lote, atualizar o campo dc-comis-movto.num_lote_ctbl */
                 CREATE  tt-rec-dc-comis-movto.
                 ASSIGN  tt-rec-dc-comis-movto.rec-dc-comis-movto    = RECID(dc-comis-movto)
                         tt-rec-dc-comis-movto.criado                = YES.

              END.
           END.
       END. /* Bloco-apb */
    END. /* IF rs-operacao = "Contabiliza" */
        
    /* FGL - contabilizaá∆o*/
    FIND FIRST dc-repres OF representante NO-LOCK NO-ERROR.

    IF  dc-repres.cod_cat_repres <> "T"   AND
        dc-repres.cod_tip_repres <> "TT" THEN DO:
        bloco-fgl: DO:
           FOR EACH dc-comis-movto
              WHERE dc-comis-movto.cod_empresa     = representante.cod_empresa
                AND dc-comis-movto.cdn_repres      = representante.cdn_repres
                AND dc-comis-movto.dat_transacao  >= dt-trans-ini
                AND dc-comis-movto.dat_transacao  <= dt-trans-fim
                AND (NOT dc-comis-movto.flag-contabilizou OR rs-operacao = "Relat¢rio"),
              FIRST dc-comis-trans NO-LOCK 
              WHERE dc-comis-trans.cod_transacao   = dc-comis-movto.cod_transacao
                AND dc-comis-trans.dat_inic_valid <= dc-comis-movto.dat_transacao
                AND dc-comis-trans.dat_fim_valid  >= dc-comis-movto.dat_transacao
                AND dc-comis-trans.log_contabiliza :

               IF dc-comis-movto.val_movto <= 0 THEN NEXT.
        
               /* Temp-table p/ depois de contabilizado o lote, atualizar o campo dc-comis-movto.num_lote_ctbl */
               CREATE  tt-rec-dc-comis-movto.
               ASSIGN  tt-rec-dc-comis-movto.rec-dc-comis-movto    = RECID(dc-comis-movto)
                       tt-rec-dc-comis-movto.contabiliza           = YES.
        
               IF  dc-comis-trans.ind_tip_movto /* DÇbito */
                   THEN ASSIGN  de-tot-deb  = de-tot-deb  + dc-comis-movto.val_movto.
                   ELSE ASSIGN  de-tot-cred = de-tot-cred + dc-comis-movto.val_movto.
    
               CREATE  tt-demon.
               ASSIGN  tt-demon.cod_plano_cta_ctbl = dc-comis-movto.cod_plano_cta_ctbl
                       tt-demon.cod_cta_ctbl       = dc-comis-movto.cod_cta_ctbl
                       tt-demon.cod_plano_ccusto   = dc-comis-movto.cod_plano_ccusto
                       tt-demon.cod_ccusto         = dc-comis-movto.cod_ccusto
                       tt-demon.ind_origin_movto   = dc-comis-movto.ind_origin_movto
                       tt-demon.cod_unid_negoc     = repres_financ.cod_unid_negoc
                       tt-demon.dat_transacao      = dc-comis-movto.dat_transacao 
                       tt-demon.cod_transacao      = dc-comis-movto.cod_transacao 
                       tt-demon.des_transacao      = dc-comis-movto.des_transacao
                       tt-demon.cdn_repres         = representante.cdn_repres
                       tt-demon.nom_abrev          = representante.nom_abrev
                       tt-demon.val-debito         = IF     dc-comis-trans.ind_tip_movto THEN dc-comis-movto.val_movto
                                                     ELSE                                     0 
                       tt-demon.val-credito        = IF NOT dc-comis-trans.ind_tip_movto THEN dc-comis-movto.val_movto
                                                     ELSE                                     0.
                       
               /* Contabilizaá∆o */
               /* Transaá∆o */
               FIND FIRST tt-lancto-ctbl
                    WHERE tt-lancto-ctbl.cod_transacao         = dc-comis-movto.cod_transacao 
                      AND tt-lancto-ctbl.cod_tipo_lancto       = STRING(dc-comis-trans.ind_tip_movto,'DB/CR')
                      AND tt-lancto-ctbl.cod_unid_negoc        = repres_financ.cod_unid_negoc
                      AND tt-lancto-ctbl.cod_plano_cta_ctbl    = dc-comis-movto.cod_plano_cta_ctbl    
                      AND tt-lancto-ctbl.cod_cta_ctbl          = dc-comis-movto.cod_cta_ctbl      
                      AND tt-lancto-ctbl.cod_plano_ccusto      = dc-comis-movto.cod_plano_ccusto  
                      AND tt-lancto-ctbl.cod_ccusto            = dc-comis-movto.cod_ccusto NO-ERROR.
               IF  NOT AVAIL tt-lancto-ctbl THEN DO:
                   CREATE  tt-lancto-ctbl.
                   ASSIGN  tt-lancto-ctbl.cod_transacao        = dc-comis-movto.cod_transacao
                           tt-lancto-ctbl.cod_tipo_lancto      = STRING(dc-comis-trans.ind_tip_movto,'DB/CR')
                           tt-lancto-ctbl.cod_unid_negoc       = repres_financ.cod_unid_negoc
                           tt-lancto-ctbl.cod_plano_cta_ctb    = dc-comis-movto.cod_plano_cta_ctbl    
                           tt-lancto-ctbl.cod_cta_ctbl         = dc-comis-movto.cod_cta_ctbl      
                           tt-lancto-ctbl.cod_plano_ccusto     = dc-comis-movto.cod_plano_ccusto  
                           tt-lancto-ctbl.cod_ccusto           = dc-comis-movto.cod_ccusto
                       
                           i-seq_lancto_ctbl                   = i-seq_lancto_ctbl + 10
                           tt-lancto-ctbl.num_seq_lancto_ctbl  = i-seq_lancto_ctbl.
               END.
               ASSIGN  tt-lancto-ctbl.val_lancto_ctbl      = tt-lancto-ctbl.val_lancto_ctbl + dc-comis-movto.val_movto.
               /* FIM - Transaá∆o */
        
               /* Vinculada */
               IF dc-comis-trans.ind_incid_liq = "N∆o Incide" THEN DO:
                   CREATE b-tt-demon.
                   BUFFER-COPY tt-demon EXCEPT cod_plano_cta_ctbl
                                               cod_cta_ctbl
                                               cod_plano_ccusto
                                               cod_ccusto 
                                               val-debito
                                               val-credito TO b-tt-demon.
    
                   ASSIGN b-tt-demon.cod_plano_cta_ctbl = dc-param_estab_comis.cod_plano_cta_ctbl
                          b-tt-demon.cod_cta_ctbl       = dc-param_estab_comis.cod_cta_ctbl
                          b-tt-demon.cod_plano_ccusto   = dc-param_estab_comis.cod_plano_ccusto
                          b-tt-demon.cod_ccusto         = dc-param_estab_comis.cod_ccusto
                          b-tt-demon.val-debito         = tt-demon.val-credito
                          b-tt-demon.val-credito        = tt-demon.val-debito. 
    
                   FIND FIRST b-tt-lancto-ctbl
                        WHERE b-tt-lancto-ctbl.cod_transacao         = dc-comis-movto.cod_transacao 
                          AND b-tt-lancto-ctbl.cod_tipo_lancto       = STRING(dc-comis-trans.ind_tip_movto,'CR/DB')
                          AND b-tt-lancto-ctbl.cod_unid_negoc        = repres_financ.cod_unid_negoc
                          AND b-tt-lancto-ctbl.cod_plano_cta_ctbl    = dc-param_estab_comis.cod_plano_cta_ctbl     
                          AND b-tt-lancto-ctbl.cod_cta_ctbl          = dc-param_estab_comis.cod_cta_ctbl       
                          AND b-tt-lancto-ctbl.cod_plano_ccusto      = dc-param_estab_comis.cod_plano_ccusto   
                          AND b-tt-lancto-ctbl.cod_ccusto            = dc-param_estab_comis.cod_ccusto NO-ERROR.
                   
                   IF  NOT AVAIL b-tt-lancto-ctbl THEN DO:
                       CREATE b-tt-lancto-ctbl.
                       ASSIGN b-tt-lancto-ctbl.cod_tipo_lancto    = STRING(dc-comis-trans.ind_tip_movto,'CR/DB')
                              b-tt-lancto-ctbl.cod_transacao      = dc-comis-movto.cod_transacao
                              b-tt-lancto-ctbl.cod_unid_negoc     = repres_financ.cod_unid_negoc
                              b-tt-lancto-ctbl.cod_plano_cta_ctbl = dc-param_estab_comis.cod_plano_cta_ctbl    
                              b-tt-lancto-ctbl.cod_cta_ctbl       = dc-param_estab_comis.cod_cta_ctbl      
                              b-tt-lancto-ctbl.cod_plano_ccusto   = dc-param_estab_comis.cod_plano_ccusto  
                              b-tt-lancto-ctbl.cod_ccusto         = dc-param_estab_comis.cod_ccusto
        
                              i-seq_lancto_ctbl                    = i-seq_lancto_ctbl + 10
                              b-tt-lancto-ctbl.num_seq_lancto_ctbl = i-seq_lancto_ctbl.
                   END.
                   
                   ASSIGN  b-tt-lancto-ctbl.val_lancto_ctbl    = b-tt-lancto-ctbl.val_lancto_ctbl + dc-comis-movto.val_movto.
               END. /* FIM - Vinculada*/
               /* Transit¢ria */
               ELSE DO:
    
                   CREATE b-tt-demon.
                   BUFFER-COPY tt-demon EXCEPT cod_plano_cta_ctbl
                                               cod_cta_ctbl
                                               cod_plano_ccusto
                                               cod_ccusto 
                                               val-debito
                                               val-credito TO b-tt-demon.
    
                   ASSIGN b-tt-demon.cod_plano_cta_ctbl = param_estab_comis.cod_plano_cta_ctbl 
                          b-tt-demon.cod_cta_ctbl       = param_estab_comis.cod_cta_ctbl       
                          b-tt-demon.cod_plano_ccusto   = param_estab_comis.cod_plano_ccusto   
                          b-tt-demon.cod_ccusto         = param_estab_comis.cod_ccusto         
                          b-tt-demon.val-debito         = tt-demon.val-credito
                          b-tt-demon.val-credito        = tt-demon.val-debito. 
    
                   FIND FIRST b-tt-lancto-ctbl
                        WHERE b-tt-lancto-ctbl.cod_transacao         = dc-comis-movto.cod_transacao 
                          AND b-tt-lancto-ctbl.cod_tipo_lancto       = STRING(dc-comis-trans.ind_tip_movto,'CR/DB')
                          AND b-tt-lancto-ctbl.cod_unid_negoc        = repres_financ.cod_unid_negoc
                          AND b-tt-lancto-ctbl.cod_plano_cta_ctbl    = param_estab_comis.cod_plano_cta_ctbl   
                          AND b-tt-lancto-ctbl.cod_cta_ctbl          = param_estab_comis.cod_cta_ctbl      
                          AND b-tt-lancto-ctbl.cod_plano_ccusto      = param_estab_comis.cod_plano_ccusto  
                          AND b-tt-lancto-ctbl.cod_ccusto            = param_estab_comis.cod_ccusto        NO-ERROR.
                   IF  NOT AVAIL b-tt-lancto-ctbl THEN DO:
                       CREATE b-tt-lancto-ctbl.
                       ASSIGN b-tt-lancto-ctbl.cod_tipo_lancto    = STRING(dc-comis-trans.ind_tip_movto,'CR/DB')
                              b-tt-lancto-ctbl.cod_transacao      = dc-comis-movto.cod_transacao
                              b-tt-lancto-ctbl.cod_unid_negoc     = repres_financ.cod_unid_negoc
                              b-tt-lancto-ctbl.cod_plano_cta_ctbl = param_estab_comis.cod_plano_cta_ctbl    
                              b-tt-lancto-ctbl.cod_cta_ctbl       = param_estab_comis.cod_cta_ctbl      
                              b-tt-lancto-ctbl.cod_plano_ccusto   = param_estab_comis.cod_plano_ccusto  
                              b-tt-lancto-ctbl.cod_ccusto         = param_estab_comis.cod_ccusto
        
                              i-seq_lancto_ctbl                    = i-seq_lancto_ctbl + 10
                              b-tt-lancto-ctbl.num_seq_lancto_ctbl = i-seq_lancto_ctbl.
                   END.
    
                   ASSIGN  b-tt-lancto-ctbl.val_lancto_ctbl    = b-tt-lancto-ctbl.val_lancto_ctbl + dc-comis-movto.val_movto.
               END. /* FIM - Transit¢ria */
        
               /* Amarraá∆o da Contrapartida */
               ASSIGN  tt-lancto-ctbl.num_seq_lancto_ctbl_cpart   = b-tt-lancto-ctbl.num_seq_lancto_ctbl
                       b-tt-lancto-ctbl.num_seq_lancto_ctbl_cpart = tt-lancto-ctbl.num_seq_lancto_ctbl.
               /* FIM - Amarraá∆o da Contrapartida */
           END. /* For each dc-comis-movto para somar variaveis */
        END. /* bloco_fgl */
    END. /* if dc-repres.cod_cat_repres */
    /* FGL - contabilizaá∆o*/
END PROCEDURE. /* pi-contabiliza*/

/* Procedures and functions */
PROCEDURE pi_messages:

    DEF INPUT PARAM c_action    AS CHAR    NO-UNDO.
    DEF INPUT PARAM i_msg       AS INTEGER NO-UNDO.
    DEF INPUT PARAM c_param     AS CHAR    NO-UNDO.

    def var c_prg_msg           AS CHAR    NO-UNDO.

    ASSIGN  c_prg_msg = "messages/":U
                      + STRING(TRUNC(i_msg / 1000,0),"99":U)
                      + "/msg":U
                      + STRING(i_msg, "99999":U).

    IF  SEARCH(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "n∆o encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.
END PROCEDURE.  /* pi_messages */

/* FIM dco007rp.p */

