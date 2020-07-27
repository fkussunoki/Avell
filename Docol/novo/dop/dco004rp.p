/**********************************************************************************************************
** Programa.........: dco004  (magnus docr111)
** Descricao .......: Movimento de Estono de Comiss∆o  na Emiss∆o
** Versao...........: 01.001
** Nome Externo.....: dop/dco004rp.p
** Autor............: Ivan Marcelo Silveira
** Criado...........: 25/11/2002
**********************************************************************************************************/
&GLOBAL-DEFINE programa dco004 /*nome_do_programa Exemplo: rel_clientes */

{include/i-prgvrs504.i {&programa} 5.04.01.001}
{utp/ut-glob504.i}
{include/i-rpvar504.i}
{doinc/acr711zf.i}      /* Temp-tables Alteraá∆o */
DEF VAR l-erro AS LOG NO-UNDO.

/************* Definiáao de Variaveis de Processamento do Relat¢rio *********************/
DEF BUFFER b-dc-orig-movto FOR dc-orig-comis-movto.

DEF VAR i-cont              AS INT       NO-UNDO.
DEF VAR i-param-posicao     AS INTEGER   NO-UNDO.
DEF VAR c-param-variavel    AS CHARACTER NO-UNDO.
DEF VAR c-param-campos      AS CHARACTER NO-UNDO.
DEF VAR c-param-tipos       AS CHARACTER NO-UNDO.
DEF VAR c-param-dados       AS CHARACTER NO-UNDO.
DEF VAR c-cod-plano-ccusto  AS CHARACTER NO-UNDO.
DEF VAR c-cod-ccusto        AS CHARACTER NO-UNDO.
DEF VAR de-val-estorno      AS DECIMAL   NO-UNDO.

DEF VAR de-tot-repres       AS DECIMAL   NO-UNDO.
DEF VAR de-tot-transacao    AS DECIMAL   NO-UNDO.
DEF VAR de-tot-dt-transacao AS DECIMAL   NO-UNDO.
DEF VAR de-valor            AS DECIMAL   NO-UNDO.

/* Vari†veis a serem recuperados pela DWB - set list param */
/* ======================================================= */
/*provenientes da p†gina de impress∆o*/
DEF VAR c-arquivo           AS CHAR     NO-UNDO.
DEF VAR i-qtd-linhas        AS INTEGER  NO-UNDO.
DEF VAR c-destino           AS CHAR     NO-UNDO.
DEF VAR l-imp-param         AS LOGICAL  NO-UNDO.
/*provenientes da p†gina de seleá∆o*/
DEFINE VARIABLE c-lista-cdn-repres          AS CHARACTER FORMAT "X(80)" NO-UNDO.
DEFINE VARIABLE c-lista-cod-estab           AS CHARACTER FORMAT "X(80)" NO-UNDO.
DEFINE VARIABLE c-cod-espec                 AS CHARACTER FORMAT "X(3)"  NO-UNDO.
DEFINE VARIABLE c-cod-empresa               AS CHARACTER FORMAT "X(15)":U LABEL "Empresa" NO-UNDO.
DEFINE VARIABLE dt-fim-periodo              AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999  NO-UNDO.
DEFINE VARIABLE i-transacao                 AS INT NO-UNDO.
/*provenientes da p†gina de classificaá∆o*/
/*provenientes da p†gina de parÉmetros*/
/*provenientes da p†gina de digitaá∆o*/
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

{include/i-openpar504.i CHARACTER c-lista-cdn-repres c-lista-cod-estab c-cod-empresa c-cod-espec}
{include/i-openpar504.i DECIMAL   }  
{include/i-openpar504.i DATE      dt-fim-periodo}
{include/i-openpar504.i INTEGER   i-transacao}
{include/i-openpar504.i LOGICAL   } 

/* ============================================================ */
/* Fim da busca dos parÉmetros gravados no DWB - set list param */


ASSIGN  c-programa     = "{&programa}"
        c-versao       = "1.00"
        c-revisao      = "000"
        c-titulo-relat = "Estorno de Comiss‰es"
        c-sistema      = "CO".
FIND FIRST emsuni.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF  AVAIL empresa THEN 
    ASSIGN  c-empresa = empresa.nom_razao_social.

FORM 
    "SELEÄ«O"           AT      03                          SKIP(1)
    c-cod-empresa       COLON   25  
    c-lista-cod-estab   COLON   25                          LABEL 'Lista Estabel'
    c-cod-espec         COLON   25                          LABEL 'EspÇcie'
    c-lista-cdn-repres  COLON   25                          LABEL 'Lista Repres'
    dt-fim-periodo      COLON   25                          LABEL 'Vencimento atÇ'
    i-transacao         COLON   25                          LABEL 'Transaá∆o'
    SKIP(2)
    "IMPRESS«O"         AT      03                          SKIP(1)
    c-destino           COLON   25  FORMAT "X(12)"          LABEL "Destino"
    c-arquivo           AT      40  FORMAT "X(70)"          NO-LABEL
    v_cod_usuar_corren  COLON   25  FORMAT "X(20)"          LABEL "Usu†rio"
    WITH FRAME f-selecao NO-BOX STREAM-IO WIDTH 132 SIDE-LABELS.

FORM 
    representante.cdn_repres
    representante.nom_abrev
    tit_acr.cod_estab      
    tit_acr.cod_espec_docto
    tit_acr.cod_ser_docto  
    tit_acr.cod_tit_acr    
    tit_acr.cod_parcela    
    tit_acr.dat_vencto_tit_acr
    tit_acr.val_sdo_tit_acr
    de-val-estorno                FORMAT '>>>,>>9.99'  COLUMN-LABEL 'Vl Comiss∆o'
    WITH FRAME f-titulos STREAM-IO WIDTH 132 DOWN NO-BOX.

/* Prepara o cabeáalho e seta saida para terminal, impressora ou arquivo */
{include/i-rpcab504.i}
{include/rp-output504.i} 

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEFINE VAR h-acomp AS HANDLE NO-UNDO.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio").

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

FIND FIRST dc-comis-trans NO-LOCK 
     WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.

bloco_estabelecimento:
FOR EACH estabelecimento NO-LOCK
   WHERE LOOKUP(estabelecimento.cod_estab,c-lista-cod-estab) > 0
     AND estabelecimento.cod_empresa = c-cod-empresa:
    
    FIND FIRST dc-comis-trans-ctb WHERE dc-comis-trans-ctb.cod_transacao  = dc-comis-trans.cod_transacao
                                    AND dc-comis-trans-ctb.dat_inic_valid = dc-comis-trans.dat_inic_valid 
                                    AND dc-comis-trans-ctb.cod_empresa    = estabelecimento.cod_empresa NO-LOCK NO-ERROR.
    
    RUN pi-acompanhar IN h-acomp (STRING(i-cont) + "-Analisando Estabelecimento " + estabelecimento.cod_estab + "...").

    FOR EACH tit_acr NO-LOCK 
       WHERE tit_acr.cod_estab                         = estabelecimento.cod_estab
         AND lookup(tit_acr.cod_espec_doc,c-cod-espec) <> 0
         AND tit_acr.dat_vencto_tit_acr                <= dt-fim-periodo
         AND tit_acr.val_sdo_tit_acr                   > 0:

       repres_tit_acr:
       FOR EACH repres_tit_acr NO-LOCK 
          WHERE repres_tit_acr.cod_estab                   = tit_acr.cod_estab
            AND repres_tit_acr.num_id_tit_acr              = tit_acr.num_id_tit_acr
            AND repres_tit_acr.val_perc_comis_repres      <> 0
            AND repres_tit_acr.val_perc_comis_repres_emis <> 0 TRANSACTION:
          
          IF  INDEX(c-lista-cdn-repres, STRING(repres_tit_acr.cdn_repres)) = 0 THEN NEXT.

          RUN pi-acompanhar IN h-acomp ("T°tulos Vencidos em " + STRING(tit_acr.dat_vencto_tit_acr, '99/99/9999')).

          FIND FIRST representante NO-LOCK
               WHERE representante.cod_empresa = tit_acr.cod_empresa
                 AND representante.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.

          ASSIGN  de-val-estorno    = (repres_tit_acr.val_perc_comis_repres / 100) * tit_acr.val_liq_tit_acr * tit_acr.val_sdo_tit_acr / tit_acr.val_origin_tit_acr.

          DISPLAY representante.cdn_repres
                  representante.nom_abrev
                  tit_acr.cod_estab      
                  tit_acr.cod_espec_docto
                  tit_acr.cod_ser_docto  
                  tit_acr.cod_tit_acr    
                  tit_acr.cod_parcela    
                  tit_acr.dat_vencto_tit_acr
                  tit_acr.val_sdo_tit_acr
                  de-val-estorno 
                  WITH FRAME f-titulos .
          DOWN WITH FRAME f-titulos.

          FOR EACH dc-orig-comis-movto OF tit_acr NO-LOCK.
             FIND FIRST dc-comis-movto OF dc-orig-comis-movto EXCLUSIVE-LOCK
                  WHERE dc-comis-movto.cod_transacao = i-transacao NO-ERROR.
             IF AVAIL dc-comis-movto THEN DO:
                IF dc-comis-movto.flag-contabilizou THEN DO:
                   PUT "Movimento " AT 01 dc-comis-movto.num_id_comis_movto space(1)
                                          dc-comis-movto.cod_transacao      SPACE(1)
                                          dc-comis-movto.des_transacao      SPACE(1)
                                          " j† foi contabilizado. N∆o ser† gerado novo movimento de estorno".
                   NEXT repres_tit_acr.
                END.
                FOR EACH b-dc-orig-movto OF dc-comis-movto EXCLUSIVE-LOCK.
                   DELETE b-dc-orig-movto.
                END.
                DELETE dc-comis-movto.
             END.
          END.

          CREATE dc-comis-movto.
          ASSIGN dc-comis-movto.cod_empresa        = tit_acr.cod_empresa
                 dc-comis-movto.cdn_repres         = repres_tit_acr.cdn_repres
                 dc-comis-movto.cod_transacao      = i-transacao
                 dc-comis-movto.dat_transacao      = IF tit_acr.dat_vencto_tit_acr > dt-fim-periodo - DAY(dt-fim-periodo) THEN tit_acr.dat_vencto_tit_acr
                                                     ELSE dt-fim-periodo
                 dc-comis-movto.des_transacao      = dc-comis-trans.descricao + "-" + tit_acr.cod_espec_docto + "-" + tit_acr.cod_tit_acr + "-" + tit_acr.cod_parcela
                 dc-comis-movto.cod_plano_cta_ctbl = dc-comis-trans-ctb.cod_plano_cta_ctbl
                 dc-comis-movto.cod_cta_ctbl       = dc-comis-trans-ctb.cod_cta_ctbl
                 dc-comis-movto.cod_plano_ccusto   = dc-comis-trans-ctb.cod_plano_ccusto  
                 dc-comis-movto.cod_ccusto         = dc-comis-trans-ctb.cod_ccusto 
                 dc-comis-movto.ind_origin_movto   = "dco004"
                 dc-comis-movto.val_movto          = de-val-estorno.

          FIND FIRST movto_comis_repres NO-LOCK
               WHERE movto_comis_repres.cod_estab       = tit_acr.cod_estab
                 AND movto_comis_repres.num_id_tit_acr  = tit_acr.num_id_tit_acr
                 AND movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o" NO-ERROR.

          CREATE dc-orig-comis-movto.
          ASSIGN dc-orig-comis-movto.num_id_comis_movto  = dc-comis-movto.num_id_comis_movto
                 dc-orig-comis-movto.cod_empresa         = dc-comis-movto.cod_empresa
                 dc-orig-comis-movto.cdn_repres          = dc-comis-movto.cdn_repres  
                 dc-orig-comis-movto.num_seq_movto_comis = IF AVAIL movto_comis_repres THEN movto_comis_repres.num_seq_movto_comis
                                                           ELSE 0
                 dc-orig-comis-movto.cod_estab           = tit_acr.cod_estab
                 dc-orig-comis-movto.num_id_tit_acr      = tit_acr.num_id_tit_acr     
                 dc-orig-comis-movto.dat_transacao       = IF AVAIL movto_comis_repres THEN movto_comis_repres.dat_transacao
                                                           ELSE ?
                 dc-orig-comis-movto.val_base_comis      = tit_acr.val_liq_tit_acr * tit_acr.val_sdo_tit_acr / tit_acr.val_origin_tit_acr
                 dc-orig-comis-movto.val_movto_comis     = de-val-estorno
                 dc-orig-comis-movto.ind_tip_movto       = IF AVAIL movto_comis_repres THEN movto_comis_repres.ind_tip_movto
                                                           ELSE "Realizado"
                 dc-orig-comis-movto.dat_vencto_tit_acr  = tit_acr.dat_vencto_tit_acr.

          FOR EACH tt_alter_tit_acr_base:      DELETE  tt_alter_tit_acr_base.      END.
          FOR EACH tt_alter_tit_acr_comis:     DELETE  tt_alter_tit_acr_comis.     END.
          FOR EACH tt_log_erros_alter_tit_acr. DELETE  tt_log_erros_alter_tit_acr. END.
          ASSIGN l-erro = NO.

          CREATE tt_alter_tit_acr_base.
          ASSIGN tt_alter_tit_acr_base.tta_cod_refer                     = fi-sugestao-referencia().
          ASSIGN tt_alter_tit_acr_base.tta_cod_estab                     = tit_acr.cod_estab
                 tt_alter_tit_acr_base.tta_num_id_tit_acr                = tit_acr.num_id_tit_acr
                 tt_alter_tit_acr_base.tta_dat_transacao                 = TODAY
                 tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_imp   = ?
                 tt_alter_tit_acr_base.tta_val_sdo_tit_acr               = ?           
                 tt_alter_tit_acr_base.ttv_cod_motiv_movto_tit_acr_alt   = ?
                 tt_alter_tit_acr_base.ttv_ind_motiv_acerto_val          = ?           
                 tt_alter_tit_acr_base.tta_cod_portador                  = ?           
                 tt_alter_tit_acr_base.tta_cod_cart_bcia                 = ?           
                 tt_alter_tit_acr_base.tta_val_despes_bcia               = ?
                 tt_alter_tit_acr_base.tta_cod_agenc_cobr_bcia           = ?           
                 tt_alter_tit_acr_base.tta_cod_tit_acr_bco               = ?           
                 tt_alter_tit_acr_base.tta_dat_emis_docto                = 01/01/0001  
                 tt_alter_tit_acr_base.tta_dat_vencto_tit_acr            = 01/01/0001  
                 tt_alter_tit_acr_base.tta_dat_prev_liquidac             = 01/01/0001  
                 tt_alter_tit_acr_base.tta_dat_fluxo_tit_acr             = 01/01/0001  
                 tt_alter_tit_acr_base.tta_ind_sit_tit_acr               = ?
                 tt_alter_tit_acr_base.tta_cod_cond_cobr                 = ?           
                 tt_alter_tit_acr_base.tta_log_tip_cr_perda_dedut_tit    = ?           
                 tt_alter_tit_acr_base.tta_dat_abat_tit_acr              = ?           
                 tt_alter_tit_acr_base.tta_val_perc_abat_acr             = ?           
                 tt_alter_tit_acr_base.tta_val_abat_tit_acr              = ?           
                 tt_alter_tit_acr_base.tta_dat_desconto                  = ?           
                 tt_alter_tit_acr_base.tta_val_perc_desc                 = ?           
                 tt_alter_tit_acr_base.tta_val_desc_tit_acr              = ?           
                 tt_alter_tit_acr_base.tta_qtd_dias_carenc_juros_acr     = ?           
                 tt_alter_tit_acr_base.tta_val_perc_juros_dia_atraso     = ?           
                 tt_alter_tit_acr_base.tta_qtd_dias_carenc_multa_acr     = ?           
                 tt_alter_tit_acr_base.tta_val_perc_multa_atraso         = ?           
                 tt_alter_tit_acr_base.ttv_cod_portador_mov              = ?
                 tt_alter_tit_acr_base.tta_ind_tip_cobr_acr              = ?           
                 tt_alter_tit_acr_base.tta_ind_ender_cobr                = ?           
                 tt_alter_tit_acr_base.tta_nom_abrev_contat              = ?           
                 tt_alter_tit_acr_base.tta_val_liq_tit_acr               = ?           
                 tt_alter_tit_acr_base.tta_cod_instruc_bcia_1_movto      = ?
                 tt_alter_tit_acr_base.tta_cod_instruc_bcia_2_movto      = ?
                 tt_alter_tit_acr_base.tta_log_tit_acr_destndo           = ?           
                 tt_alter_tit_acr_base.tta_cod_histor_padr               = ?
                 tt_alter_tit_acr_base.ttv_des_text_histor               = ?
                 tt_alter_tit_acr_base.tta_des_obs_cobr                  = ?           
                 tt_alter_tit_acr_base.ttv_wgh_lista                     = ?.

          CREATE tt_alter_tit_acr_comis.
          ASSIGN tt_alter_tit_acr_comis.tta_cod_empresa                  = repres_tit_acr.cod_empresa
                 tt_alter_tit_acr_comis.tta_cod_estab                    = repres_tit_acr.cod_estab
                 tt_alter_tit_acr_comis.tta_num_id_tit_acr               = repres_tit_acr.num_id_tit_acr
                 tt_alter_tit_acr_comis.ttv_num_tip_operac               = 0
                 tt_alter_tit_acr_comis.tta_cdn_repres                   = repres_tit_acr.cdn_repres
                 tt_alter_tit_acr_comis.tta_val_perc_comis_repres        = repres_tit_acr.val_perc_comis_repres
                 tt_alter_tit_acr_comis.tta_val_perc_comis_repres_emis   = 0
                 tt_alter_tit_acr_comis.tta_val_perc_comis_abat          = repres_tit_acr.val_perc_comis_abat        
                 tt_alter_tit_acr_comis.tta_val_perc_comis_desc          = repres_tit_acr.val_perc_comis_desc        
                 tt_alter_tit_acr_comis.tta_val_perc_comis_juros         = repres_tit_acr.val_perc_comis_juros       
                 tt_alter_tit_acr_comis.tta_val_perc_comis_multa         = repres_tit_acr.val_perc_comis_multa       
                 tt_alter_tit_acr_comis.tta_val_perc_comis_acerto_val    = repres_tit_acr.val_perc_comis_acerto_val  
                 tt_alter_tit_acr_comis.tta_log_comis_repres_proporc     = repres_tit_acr.log_comis_repres_proporc   
                 tt_alter_tit_acr_comis.tta_ind_tip_comis                = repres_tit_acr.ind_tip_comis.
          
          RUN prgfin\acr\acr711zf.py( INPUT  1,
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
             END.
             UNDO repres_tit_acr, NEXT repres_tit_acr.
          END.
       END. /* FOR EACH repres_tit_acr NO-LOCK */
    END. /* FOR EACH tit_acr NO-LOCK */
END. /* FOR EACH estabelecimento NO-LOCK */


IF  l-imp-param THEN DO:
    PAGE.
    DISPLAY c-cod-empresa 
            c-lista-cod-estab           c-lista-cdn-repres  
            c-cod-espec                 dt-fim-periodo  
            c-destino                   c-arquivo
            i-transacao
            v_cod_usuar_corren  
            WITH FRAME f-selecao.
END.

RUN pi-finalizar IN h-acomp.

OUTPUT CLOSE.

/* fim relat¢rio */
