/*************************************************************************************************
**
**   Procedimento..........: dabgc201
**   Programa..............: dabgc201a
**   Nome Externo..........: bgc/dabgc201a.p
**   Descricao.............: Consulta Or‡amento Detalhe Espec¡fico
**   Criado por............: Gran Systems
**   Criado em.............: 20/11/2009
**   VersÆo em.............: 10/02/2016 - 12.00.01.000 - Corrigida a leitura dos Centros de Custos;
**                           05/05/2016 - 12.00.02.000 - Acerto na leitura do empenhado;
**                           09/05/2016 - 12.00.03.000 - Acerto na leitura do empenhado;
**
**************************************************************************************************/

FUNCTION fn-narrativa RETURNS CHARACTER(p-string AS CHAR) FORWARD.

FUNCTION fn-tipo-movto RETURNS CHARACTER(pi-num_orig_movto_empenh AS INT, pr-orig_movto_empenh AS RECID) FORWARD.

/* Verifica Instala‡Æo */
DEF VAR v_log_instal AS LOG NO-UNDO.
FOR EACH estabelecimento NO-LOCK WHERE
         estabelecimento.cod_estab >= "":
    IF ENTRY (1, estabelecimento.cod_livre_2) = "05L2014"
    AND ENTRY (2, estabelecimento.cod_livre_2) = "14/03/2014" THEN DO:
        ASSIGN v_log_instal = YES.
        leave.       
    END.
    ELSE
        ASSIGN v_log_instal = YES.
END.
IF v_log_instal = NO THEN DO:
    MESSAGE "Procedimento nÆo liberado para este ambiente!" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

DEF VAR wh_w_program         as WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_focus          as WIDGET-HANDLE NO-UNDO.
def var v_wgh_current_browse as WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_current_menu   AS WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_current_window AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER usuar_mestre FOR emsfnd.usuar_mestre.
DEF BUFFER unid_negoc   FOR emsuni.unid_negoc.

DEF NEW GLOBAL SHARED VAR gr-movto-estoq    as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-requisicao     as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-ordem-compra   as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-doc-i-ap       as rowid no-undo.
DEF NEW GLOBAL SHARED VAR rw-tit            as rowid no-undo.
DEF NEW GLOBAL SHARED VAR rw-mov-ap         as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-movto-banco    as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-mov-pef-pend   as rowid no-undo.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren      as char no-undo.
DEF NEW GLOBAL SHARED VAR v_rec_antecip_pef_pend  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_lancto_ctbl       AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_lote_impl_tit_ap  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_movto_cta_corren  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_movto_tit_ap      AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_orig_movto_empenh AS RECID NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_rec_proces_prestac_cta_eec AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_tit_ap            AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_item_lancto_ctbl  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_usuar_mestre      AS RECID NO-UNDO.

/* e-mail */
DEF VAR v_des_para                AS CHAR FORMAT "x(200)" NO-UNDO.
DEF VAR v_des_copia               AS CHAR FORMAT "x(200)" NO-UNDO.

/* Temp-table da API BTB916ZA */
DEF NEW SHARED TEMP-TABLE tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro                     as character format "x(10)" column-label "Cod Erro"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_arquivo                  as character format "x(255)"
    .

def temp-table tt_mail_fax no-undo
    field ttv_nom_servid                   as character format "x(30)"
    field ttv_num_porta_servid             as integer format ">>>>9"
    field ttv_log_exchange                 as logical format "Sim/NÆo" initial no
    field ttv_nom_from                     as character format "x(50)"
    field ttv_nom_to                       as character format "x(50)" label "To"
    field ttv_nom_cc                       as character format "x(50)" label "Cc"
    field ttv_nom_subject                  as character format "x(30)"
    field ttv_nom_message                  as character format "x(50)"
    field ttv_nom_attachfile               as character format "x(30)"
    field ttv_num_imptcia                  as integer format "9"
    field ttv_log_envda                    as logical format "Sim/NÆo" initial no
    field ttv_log_lida                     as logical format "Sim/NÆo" initial no
    field ttv_cod_format_mail              as character format "x(8)" initial "Texto"
    .

DEF VAR v_log_repeat              AS LOG NO-UNDO.

DEF NEW SHARED TEMP-TABLE tt_orig_movto_empenh_aux NO-UNDO
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_row_id_movto                 as Rowid
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_ccusto                   as character format "x(20)" label "Centro de Custo" column-label "Centro de Custo"
    field tta_num_orig_movto_empenh        as integer format ">9" initial 0 label "Origem Movto Empen" column-label "Origem Movto Empen"
    field ttv_des_orig_movto_bgc           as character format "x(30)" label "Origem Movimento" column-label "Origem Movimento"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field ttv_dat_empenh                   as date format "99/99/9999" label "Data Empenho"
    field tta_cod_unid_orctaria            as character format "x(8)" label "Unid Or»amentÿria" column-label "Unid Or»amentÿria"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_des_contdo_movto             as character format "x(200)" label "Conteudo Movimento" column-label "Conteudo Movimento"
    .

def temp-table tt_orig_aprop_ctbl_ap no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_ind_trans_ap                 as character format "X(26)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_val_aprop_ctbl_apl           as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    .

def temp-table tt_orig_movto_estoq no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_cod_pedido                   as character format "x(12)"
    field ttv_num_ordem                    as integer format ">>>,>>>,>>9"
    field ttv_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field ttv_cod_natur_operac_2           as character format "x(6)" label "Natur Operac" column-label "Nat Opera‡Æo"
    field ttv_cod_serie                    as character format "x(5)"
    field ttv_cod_docto_ems2               as character format "x(16)" column-label "Documento"
    field ttv_cod_item_dw                  as character format "x(16)" label "Item" column-label "Item"
    field ttv_des_item_estoq               as character format "x(60)"
    field ttv_qtd_movto                    as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_val_movto                    as decimal format "->,>>>,>>>,>>9.99" decimals 2 label "Movimento" column-label "Valor Movto"
    .

def temp-table tt_orig_requisicao no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_num_req_2                    as integer format ">>>,>>>,>>9"
    field ttv_num_seq_item                 as integer format ">>>9" label "Sequˆncia" column-label "Sequˆncia"
    field ttv_cod_tip_req                  as character format "x(30)"
    field ttv_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abrev"
    field ttv_cod_item_dw                  as character format "x(16)" label "Item" column-label "Item"
    field ttv_num_ord_req                  as integer format "zzzzz9,99"
    field ttv_qtd_reqtdo                   as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_item                     as decimal format ">>>>>>,>>>,>>9.99" decimals 2
    .

def temp-table tt_orig_requisicao_mi no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_num_req                      as integer format ">>>,>>9"
    field ttv_num_seq_item                 as integer format ">>>9" label "Sequˆncia" column-label "Sequˆncia"
    field ttv_cod_tip_req                  as character format "x(30)"
    field ttv_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abrev"
    field ttv_cod_item_dw                  as character format "x(16)" label "Item" column-label "Item"
    field ttv_num_ord_req                  as integer format "zzzzz9,99"
    field ttv_qtd_reqtdo                   as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_item                     as decimal format ">>>>>>,>>>,>>9.99" decimals 2
    field ttv_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field ttv_num_ord_produc               as integer format ">>>,>>>,>>9" label "Ordem Manutencao" column-label "Ordem Manutencao"
    field ttv_cod_eqpto_2                  as character format "x(16)" label "Equipamento" column-label "Equipamento"
    .

def temp-table tt_orig_aprop_ctbl_pend_ap no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    .

def temp-table tt_orig_lin_i_ap no-undo
    field ttv_rec_orig_movto_empenh        as recid format '>>>>>>9'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_num_empres_ems2              as integer format '>>>>,>>9'
    &ELSE
    field ttv_num_empres_ems2              as char format 'x(3)'
    &ENDIF
    field ttv_cod_refer                    as character format 'x(10)' label 'Referˆncia' column-label 'Referˆncia'
    field ttv_num_seq                      as integer format '>>>,>>9' label 'Seqˆncia' column-label 'Seq'
    field ttv_num_seq_import               as integer format '>>>>>9'
    .

def temp-table tt_orig_tit_ap no-undo
    field ttv_rec_orig_movto_empenh        as recid format '>>>>>>9'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_num_empres_ems2              as integer format '>>>>,>>9'
    &ELSE
    field ttv_num_empres_ems2              as char format 'x(3)'
    &ENDIF
    field ttv_num_fornec                   as integer format '>>>,>>>,>>9' initial 0 label 'Fornecedor' column-label 'Fornecedor'
    field ttv_cod_estab                    as character format 'x(3)' label 'Estabelecimento' column-label 'Estabelecimento'
    field ttv_cod_espec_ems2               as character format 'x(2)'
    field ttv_cod_serie                    as character format 'x(5)'
    field ttv_cod_docto_ems2               as character format 'x(16)' column-label "Documento" /*l_documento*/ 
    field ttv_cod_parcela                  as character format 'x(02)' label 'Parcela' column-label 'Parc'
    .

def temp-table tt_orig_ordem_compra no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_num_ord_req                  as integer format "zzzzz9,99"
    field ttv_num_parc_compra              as integer format ">>>>,>>9"
    field ttv_cod_item_dw                  as character format "x(16)" label "Item" column-label "Item"
    field ttv_qtd_movto                    as decimal format "->>>>,>>9.9999" decimals 4
    .

def temp-table tt_orig_proces_prestac_cta no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field tta_cdn_func_financ              as Integer format ">>>>>>>9" initial 0 label "Funcion rio" column-label "Funcion rio"
    field tta_cdn_prestac_cta              as Integer format ">>>,>>9" initial 0 label "Processo" column-label "Processo"
    field tta_dat_abert_prestac_cta_eec    as date format "99/99/9999" initial ? label "Data Abertura" column-label "Data Abertura"
    field tta_ind_sit_proces               as character format "X(25)" initial "Digita‡Æo Adto" label "Situa‡Æo Processo" column-label "Situa‡Æo Processo"
    field tta_cod_usuar_aprvdor_proces     as character format "x(12)" label "Usu rio Aprovador" column-label "Usuario Aprovador Pr"
    field tta_cod_tip_proces_eec           as character format "x(15)" label "Tipo Processo" column-label "C¢digo"
    .

def temp-table tt_orig_contrat no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_num_contrat                  as integer format ">>>>>>>>9"
    field ttv_cod_contrat_ext              as character format "x(16)" label "Cod Contrato Ext" column-label "Cod Contrato Ext"
    field ttv_num_seq_item                 as integer format ">>>9" label "Sequˆncia" column-label "Sequˆncia"
    field ttv_num_ord_contrat              as integer format "zzzzz9,99"
    field ttv_num_parc_contrat             as integer format ">>>>9"
    .

def temp-table tt_orig_contrat_medicao no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_num_contrat                  as integer format ">>>>>>>>9"
    field ttv_cod_contrat_ext              as character format "x(16)" label "Cod Contrato Ext" column-label "Cod Contrato Ext"
    field ttv_num_seq_item                 as integer format ">>>9" label "Sequˆncia" column-label "Sequˆncia"
    field ttv_num_ord_contrat              as integer format "zzzzz9,99"
    field ttv_num_seq_event_contrat        as integer format ">,>>9"
    field ttv_num_seq_medic                as integer format ">,>>9"
    .

def temp-table tt_orig_mcb no-undo
    field ttv_rec_orig_movto_empenh        as recid format '>>>>>>9'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_num_empres_ems2              as integer format '>>>>,>>9'
    &ELSE
    field ttv_num_empres_ems2              as char format 'x(3)'
    &ENDIF
    field ttv_num_bco_ems2                 as integer format '>>9' label 'Banco' column-label 'Banco'
    field ttv_cod_agenc_ems2               as character format 'x(8)' label 'Agˆncia' column-label 'Agˆncia'
    field ttv_cod_cta_corren_ems2          as character format 'x(20)' label 'Conta Corrente' column-label 'Conta Corrente'
    field ttv_cod_docto_ems2               as character format 'x(16)' column-label "Documento" /*l_documento*/ 
    field ttv_cod_docto_empres_ems2        as character format 'x(16)' label 'Documento Emp' column-label 'Documento Emp'
    field ttv_dat_movto                    as date format '99/99/9999' label 'Data Movimento' column-label 'Data Movimento'
    field ttv_num_portador                 as integer format '>>>>9' label 'Portador'
    field ttv_num_modalid                  as integer format '>9' initial 0
    .

def temp-table tt_orig_movto_mat_mi no-undo
    field ttv_rec_orig_movto_empenh        as recid format ">>>>>>9"
    field ttv_cod_pedido                   as character format "x(12)"
    field ttv_num_ordem                    as integer format ">>>,>>>,>>9"
    field ttv_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field ttv_cod_natur_operac_2           as character format "x(6)" label "Natur Operac" column-label "Nat Opera‡Æo"
    field ttv_cod_serie                    as character format "x(5)"
    field ttv_cod_docto_ems2               as character format "x(16)" column-label "Documento"
    field ttv_cod_item_dw                  as character format "x(16)" label "Item" column-label "Item"
    field ttv_des_item_estoq               as character format "x(60)"
    field ttv_qtd_movto                    as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_val_movto                    as decimal format "->,>>>,>>>,>>9.99" decimals 2 label "Movimento" column-label "Valor Movto"
    field ttv_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field ttv_num_ord_produc               as integer format ">>>,>>>,>>9" label "Ordem Manutencao" column-label "Ordem Manutencao"
    field ttv_cod_eqpto_2                  as character format "x(16)" label "Equipamento" column-label "Equipamento"
    .

def temp-table tt_orig_movto_mob_mi no-undo
    field ttv_rec_orig_movto_empenh        as recid format '>>>>>>9'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_cdn_empres                   as Integer format '>>9' label 'Empresa' column-label 'Empresa'
    &ELSE
    field ttv_cdn_empres                   as char format 'x(3)' label 'Empresa' column-label 'Empresa'
    &ENDIF
    field ttv_cod_estab                    as character format 'x(3)' label 'Estabelecimento' column-label 'Estabelecimento'
    field ttv_cod_conta                    as character format 'x(17)'
    field ttv_dat_movto                    as date format '99/99/9999' label 'Data Movimento' column-label 'Data Movimento'
    field ttv_val_movto                    as decimal format '->,>>>,>>>,>>9.99' decimals 2 label 'Movimento' column-label 'Valor Movto'
    field ttv_qtd_movto                    as decimal format '->>>>,>>9.9999' decimals 4
    field ttv_cod_unid_negoc               as character format 'x(3)' label 'Unid Neg¢cio' column-label 'Un Neg'
    field ttv_num_ord_produc               as integer format '>>>,>>>,>>9' label 'Ordem Manutencao' column-label 'Ordem Manutencao'
    field ttv_cod_eqpto_2                  as character format 'x(16)' label 'Equipamento' column-label 'Equipamento'
    field ttv_cod_tec_1                    as character format '99999-9' label 'C¢digo T‚cnico'
    field ttv_cod_cc_cod                   as character format 'x(8)' label 'Centro Custo' column-label 'Centro Custo'
    field ttv_cod_mdo_dir_1                as character format 'x(5)' label 'C¢digo Mob Direta'
    .

def temp-table tt_orig_movto_ggf_mi no-undo
    field ttv_rec_orig_movto_empenh        as recid format '>>>>>>9'
    &IF '{&emsfin_version}' < '5.07A' &THEN
    field ttv_cdn_empres                   as Integer format '>>9' label 'Empresa' column-label 'Empresa'
    &ELSE
    field ttv_cdn_empres                   as char format 'x(3)' label 'Empresa' column-label 'Empresa'
    &ENDIF
    field ttv_cod_estab                    as character format 'x(3)' label 'Estabelecimento' column-label 'Estabelecimento'
    field ttv_cod_conta                    as character format 'x(17)'
    field ttv_dat_movto                    as date format '99/99/9999' label 'Data Movimento' column-label 'Data Movimento'
    field ttv_val_movto                    as decimal format '->,>>>,>>>,>>9.99' decimals 2 label 'Movimento' column-label 'Valor Movto'
    field ttv_qtd_movto                    as decimal format '->>>>,>>9.9999' decimals 4
    field ttv_cod_unid_negoc               as character format 'x(3)' label 'Unid Neg¢cio' column-label 'Un Neg'
    field ttv_num_ord_produc               as integer format '>>>,>>>,>>9' label 'Ordem Manutencao' column-label 'Ordem Manutencao'
    field ttv_cod_eqpto_2                  as character format 'x(16)' label 'Equipamento' column-label 'Equipamento'
    field ttv_cod_tec_1                    as character format '99999-9' label 'C¢digo T‚cnico'
    field ttv_cod_cc_cod                   as character format 'x(8)' label 'Centro Custo' column-label 'Centro Custo'
    field ttv_cod_mdo_dir_1                as character format 'x(5)' label 'C¢digo Mob Direta'
    .

def temp-table tt_movto_espec_cmg no-undo
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_num_seq_movto_cta_corren     as integer format ">>>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_ind_tip_movto_cta_corren     as character format "X(2)" initial "RE" label "Tipo Movimento" column-label "Tipo Movto"
    field tta_ind_fluxo_movto_cta_corren   as character format "X(3)" initial "ENT" label "Fluxo Movimento" column-label "Fluxo Movto"
    field tta_cod_tip_trans_cx             as character format "x(8)" label "Tipo Transa‡Æo Caixa" column-label "Tipo Transa‡Æo Caixa"
    field tta_des_histor_movto_cta_corren  as character format "x(2000)" label "Hist¢rico Movimento" column-label "Hist¢rico Movimento"
    field ttv_rec_movto_cta_corren         as recid format ">>>>>>9" initial ?
    field tta_des_contdo_movto             as character format "x(200)" label "Conteudo Movimento" column-label "Conteudo Movimento"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    .

DEF SHARED TEMP-TABLE tt_orcto_real
    FIELD cod_empresa        LIKE sdo_orcto_ctbl_bgc.cod_empresa
    FIELD cod_plano_ccusto   LIKE sdo_orcto_ctbl_bgc.cod_plano_ccusto
    FIELD cod_ccusto         LIKE sdo_orcto_ctbl_bgc.cod_ccusto
    FIELD cod_plano_cta_ctbl LIKE sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE sdo_orcto_ctbl_bgc.cod_cta_ctbl
    FIELD cod_cenar_ctbl     LIKE sdo_orcto_ctbl_bgc.cod_cenar_ctbl
    FIELD cod_exerc_ctbl     LIKE sdo_orcto_ctbl_bgc.cod_exerc_ctbl
    FIELD num_period_ctbl    LIKE sdo_orcto_ctbl_bgc.num_period_ctbl
    FIELD cod_cta_ctbl_pai   LIKE estrut_cta_ctbl.cod_cta_ctbl_pai
    FIELD cod_finalid_econ   LIKE sdo_ctbl.cod_finalid_econ
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD log_estrut         AS LOG
    FIELD des_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl FORMAT "X(70)"
    FIELD val_ctbl           LIKE sdo_ctbl.val_sdo_ctbl_db
    FIELD val_ctbl_emp       LIKE sdo_ctbl.val_sdo_ctbl_db
    FIELD val_ctbl_sdo       LIKE sdo_ctbl.val_sdo_ctbl_fim
    FIELD val_orcado         like sdo_orcto_ctbl_bgc.val_orcado
    FIELD val_orcado_sdo     LIKE sdo_orcto_ctbl_bgc.val_orcado_sdo
    FIELD val_perc           AS DEC
    FIELD val_perc_sdo       AS DEC
    FIELD des_period_bloq    AS CHAR
    FIELD dat_inicial        AS DATE
    FIELD dat_final          AS DATE
    INDEX tt_orcto_real_id   IS UNIQUE PRIMARY
          cod_plano_ccusto
          cod_ccusto
          cod_plano_cta_ctbl
          cod_cta_ctbl
          cod_cenar_ctbl
          cod_exerc_ctbl
          num_period_ctbl.

DEF TEMP-TABLE tt_realiz
    field rec_id                       as recid format ">>>>>>9"
    FIELD num_seq                      AS INT
    FIELD ind_tip_movto                AS CHAR FORMAT "x(10)"
    field cod_empresa                  as char format "x(3)" label "Empresa" column-label "Emp"
    field cod_cenar_ctbl               as char format "x(8)" label "Cenÿrio Contÿbil" column-label "Cenÿrio Contÿbil"
    field cod_finalid_econ             as char format "x(10)" label "Finalidade" column-label "Finalidade"  
    field cod_plano_cta_ctbl           as char format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field cod_cta_ctbl                 as char format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field cod_plano_ccusto             as char format "x(08)" label "Plano Ccusto" column-label "Plano Ccusto"
    field cod_ccusto                   as char format "x(11)" label "Ccusto" column-label "Ccusto"                 
    field cod_estab                    as char format "x(3)" label "Estabelecimento" column-label "Estab"
    field cod_unid_negoc               as char format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field dat_movto                     as date format "99/99/9999" initial ? label "Data Lan»amento" column-label "Data Lan»to"
    FIELD cod_modul_dtsul              AS CHAR FORMAT "x(03)"
    FIELD movimento                    AS CHAR FORMAT "X(40)" COLUMN-LABEL "Movimento"
    field val_movto                    as dec  format "->>>>,>>>,>>9.99" decimals 2 label "Val Movto"
    field des_contdo_movto             as char format "x(200)" label "Conteudo Movimento" column-label "Conteudo Movimento"
    field rec_orig_movto_empenh        as recid format ">>>>>>9"
    FIELD narrativa                    AS CHAR FORMAT "X(200)" LABEL "Narrativa do Item" COLUMN-LABEL "Narrativa do Item"
    index tt_razao_id                  is primary unique
          rec_id 
          num_seq
          ind_tip_movto
          cod_empresa                  
          cod_finalid_econ             
          cod_cenar_ctbl               
          cod_plano_cta_ctbl           
          cod_cta_ctbl
          cod_estab
          cod_unid_negoc
          cod_plano_ccusto
          cod_ccusto
          dat_movto.

DEF INPUT PARAM p_rec_tt_orcto_real AS RECID NO-UNDO.
DEF INPUT PARAM p_cod_unid_orctaria AS CHAR NO-UNDO.

DEF INPUT PARAM p_cod_estab_ini        LIKE estabelecimento.cod_estab             NO-UNDO.
DEF INPUT PARAM p_cod_estab_fim        LIKE estabelecimento.cod_estab INIT "ZZZ"  NO-UNDO.
DEF INPUT PARAM p_cod_unid_negoc_ini   LIKE unid_negoc.cod_unid_negoc             NO-UNDO.
DEF INPUT PARAM p_cod_unid_negoc_fim   LIKE unid_negoc.cod_unid_negoc INIT "ZZZ"  NO-UNDO.
DEF INPUT PARAM p_cod_format_cta_ctbl  LIKE plano_cta_ctbl.cod_format_cta_ctbl    NO-UNDO.
DEF INPUT PARAM p_log_acum             AS LOG NO-UNDO.

DEF VAR rs_tip_movto as int initial 3
     view-as radio-set Horizontal
     radio-buttons "Ambos",3,"Empenhado",1,"Realizado",2
     bgcolor 8 no-undo.

def rectangle rt_param
    size 125 by 17.60
    edge-pixels 2.

def rectangle rt_cxft 
    size 125 by 1.50 
    edge-pixels 2.

def rectangle rt_003 
    size 37 by 1.50 
    edge-pixels 2. 

def button bt_can
    label "&Cancela"
    tooltip "Cancela"
    size 10 by 1
    auto-endkey.

def button bt_ok
    label "&OK"
    tooltip "OK"
    size 10 by 1
    auto-go.

DEF VAR v_cod_cta_ctbl           like cta_ctbl.cod_cta_ctbl    no-undo.
DEF VAR v_cod_ccusto             like emsuni.ccusto.cod_ccusto no-undo.

DEF VAR v_des_lista_orig         AS CHAR NO-UNDO.
DEF VAR v_arq_email              AS CHAR NO-UNDO.
DEF VAR v_arq_plan               AS CHAR NO-UNDO.
DEF VAR v_val_tot_movto          as dec format "->>>,>>>,>>9.99" no-undo.

def button bt_pri
    label "Imp"
    tooltip "Imprime"
    image-up file "image/im-pri"
    image-insensitive file "image/ii-pri.bmp"
    size 4.50 by 1.3.
def button bt_send
    label "Enc"
    tooltip "Encaminha"
    image-up file "image/im-send"
    image-insensitive file "image/ii-send"
    size 4.50 by 1.3.

DEF QUERY qr_realiz FOR tt_realiz.

DEF BROWSE br_realiz QUERY qr_realiz 
    display tt_realiz.dat_movto          COLUMN-LABEL "Data"
            tt_realiz.cod_modul_dtsul    COLUMN-LABEL "Mod"  FORMAT "x(05)"
            tt_realiz.ind_tip_movto      COLUMN-LABEL "Tipo" FORMAT "x(12)"
            STRING (tt_realiz.cod_cta_ctbl, p_cod_format_cta_ctbl) COLUMN-LABEL "Cta Ctbl" FORMAT "X(14)"
            tt_realiz.cod_ccusto         COLUMN-LABEL "Ccusto"
            tt_realiz.cod_estab          COLUMN-LABEL "Est"  FORMAT "x(04)"
            tt_realiz.cod_unid_negoc     COLUMN-LABEL "UNeg" FORMAT "x(04)"
            tt_realiz.movimento          COLUMN-LABEL "Movimento" FORMAT "X(40)"
            tt_realiz.val_movto          COLUMN-LABEL "Val Movto"
            tt_realiz.des_contdo_movto   COLUMN-LABEL "Conte£do Movimento" FORMAT "X(200)"
            tt_realiz.narrativa          COLUMN-LABEL "Narrativa do Item" FORMAT "X(200)"
            with size 121.5 by 13.60 separators font 1 bgcolor 15.
   
DEF FRAME f_det
     rt_param
        at row 01.13 col 1.00 colon-aligned 
        fgcolor ? bgcolor 17
     rt_003 
        at row 01.58 col 04.50 
     " Tipo Movto " view-as text 
        at row 01.32 col 06.50 bgcolor 17
     rs_tip_movto
        at row 02.05 col 08.50 no-label 
        bgcolor 17
     bt_pri
        at row 01.68 col 44.14 font ?
        help "Imprime"
     bt_send
        at row 01.68 col 49.14 font ?
        help "Encaminha"
     rt_cxft
        at row 19.10 col 1.00 colon-aligned 
        fgcolor ? bgcolor 18
     br_realiz at row 03.60 col 04.50
     v_val_tot_movto
        at row 17.50 col 49.20 LABEL "Totais"
        view-as fill-in SIZE 12 BY 0.88
        fgcolor ? bgcolor 15 font 1
     bt_ok       at row 19.38 col 04.00 bgcolor 8 help "Fecha" 
     bt_can      at row 19.38 col 14.50 bgcolor 8 help "Cancela"     
     with 1 down side-labels no-validate keep-tab-order three-d 
          size-char 130.00 by 21.00 
          at row 01.13 col 01.00 
          font 1 fgcolor ? bgcolor 17 
          //VIEW-AS DIALOG-BOX - Chamado 90242 - Fazia abrir duas janelas
          title "Detalhe Movimentos Empenhados e Realizados - 12.00.03.000".

ON CHOOSE OF bt_can IN FRAME f_det DO:

    run pi_close_program.
    
END.

ON CHOOSE OF bt_ok IN FRAME f_det DO:

    run pi_close_program.

END.

ON CHOOSE OF bt_pri IN FRAME f_det DO:
        
    /*RUN btb/btb944za.p (INPUT wh_w_program).*/
    DEF VAR v_des_data AS CHAR NO-UNDO.
    
    FIND tt_orcto_real NO-LOCK
        WHERE RECID (tt_orcto_real) = p_rec_tt_orcto_real NO-ERROR.
    IF AVAIL tt_orcto_real THEN DO:
        ASSIGN v_des_data  = STRING (YEAR (TODAY), "9999")
                           + STRING (MONTH (TODAY), "99")
                           + STRING (DAY (TODAY), "99")
                           + "_" 
                           + STRING (TIME, "hh:mm")
               v_des_data  = REPLACE (v_des_data, ":", "")
               v_arq_email = SESSION:TEMP-DIR 
                           + TRIM (tt_orcto_real.cod_ccusto) 
                           + TRIM (tt_orcto_real.cod_cta_ctbl)
                           + TRIM (tt_orcto_real.cod_exerc_ctbl)
                           + STRING (tt_orcto_real.num_period_ctbl, "99")
                           + "_"
                           + v_des_data
                           + ".xlsx".
    END.
    ELSE
        RETURN NO-APPLY.

    IF SEARCH (v_arq_email) <> ? THEN
       OS-DELETE VALUE (v_arq_email).

    IF CAN-FIND (FIRST tt_orcto_real) THEN DO:
        APPLY "CTRL-ALT-E" TO wh_w_program.
        ASSIGN v_arq_plan  = SESSION:TEMP-DIR + "gotoexcel_" + TRIM (v_cod_usuar_corren) + ".xlsx".           
        IF SEARCH (v_arq_plan) <> ? THEN DO:
            IF SEARCH (v_arq_email) <> ? THEN
                OS-DELETE VALUE (v_arq_email).
            OS-COPY VALUE (v_arq_plan) VALUE (v_arq_email).
        END.
    END.
    ELSE
        RETURN.

END.

ON CHOOSE OF bt_send IN FRAME f_det DO:

    APPLY "CHOOSE" TO bt_pri IN FRAME f_det.

    IF SEARCH (v_arq_email) <> ? THEN
        RUN pi_email.

END.

on value-changed of rs_tip_movto in frame f_det do:

   ASSIGN input frame f_det rs_tip_movto.
   close query qr_realiz.
   
   if v_cod_ccusto <> "" then
       RUN pi_criar_tt_realiz.
   else
       run pi_criar_tt_realiz_obz.
   
   CASE rs_tip_movto:
       when 1 then do:
           OPEN QUERY qr_realiz
              FOR EACH tt_realiz
                   WHERE tt_realiz.ind_tip_movto = "Empenhado"
                      BY tt_realiz.dat_movto
                      BY tt_realiz.num_seq.
       end.
       when 2 then do:
           OPEN QUERY qr_realiz
              FOR EACH tt_realiz
                  WHERE tt_realiz.ind_tip_movto = "Realizado"
                     BY tt_realiz.dat_movto
                     BY tt_realiz.num_seq.
       end.
       when 3 then do:
           OPEN QUERY qr_realiz
              FOR EACH tt_realiz
                    BY tt_realiz.dat_movto
                    BY tt_realiz.num_seq.
       end.                      
   end.
   DISPLAY v_val_tot_movto
           WITH FRAME f_det.
  
end.

ON DEFAULT-ACTION OF br_realiz IN FRAME f_det DO:

    DEF VAR v_wgh_child          AS WIDGET-HANDLE NO-UNDO.
    DEF VAR v_wgh_current_menu   AS WIDGET-HANDLE NO-UNDO.
    DEF VAR v_wgh_current_window AS WIDGET-HANDLE NO-UNDO.
    DEF VAR v_wgh_child_2        AS widget-handle NO-UNDO.

    DEF VAR v_cod_name           AS CHAR NO-UNDO.

    ASSIGN v_wgh_focus = br_realiz:HANDLE IN FRAME f_det.

    IF AVAIL tt_realiz THEN DO:
        IF tt_realiz.ind_tip_movto = "Empenhado" THEN DO:

            // Chamado 84058
            FIND FIRST tt_orig_movto_empenh_aux WHERE
                       tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh = tt_realiz.rec_id NO-ERROR.

            IF  tt_orig_movto_empenh_aux.ttv_rec_id       = ?
            AND tt_orig_movto_empenh_aux.ttv_row_id_movto = ? 
            AND NOT tt_orig_movto_empenh_aux.ttv_des_orig_movto_bgc BEGINS CHR (187) THEN DO:
                /* Movimento de Origem inexistente */
                RUN pi_message (input "show",
                                input 13417,
                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13417*/.
                RETURN NO-APPLY.
            END.
        END.

        assign v_wgh_current_window        = current-window
               v_wgh_current_menu          = current-window:menubar
               current-window:window-state = 2
               v_wgh_child                 = current-window:first-child
               current-window:visible      = no.
        if  v_wgh_current_menu <> ? then do:
            assign v_wgh_current_menu:sensitive = no.
        END.

        assign v_wgh_child_2 = v_wgh_child
               v_cod_name = (if v_wgh_child_2 <> ? then v_wgh_child_2:name else "").

        desab:
        DO WHILE v_wgh_child_2 <> ?:
            assign v_wgh_child_2 = v_wgh_child_2:next-sibling.
            if  v_wgh_child_2 <> ?
            and v_wgh_child_2:name = v_cod_name then
                assign v_wgh_child = v_wgh_child_2.
        END.
        if  v_wgh_child <> ? then
            assign v_wgh_child:sensitive = no.

        IF tt_realiz.ind_tip_movto = "Empenhado" THEN DO:
            RUN pi_consulta_movto_orig.
        END.
        ELSE DO:
            ASSIGN v_rec_item_lancto_ctbl = tt_realiz.rec_id.
            FIND item_lancto_ctbl NO-LOCK
                WHERE RECID (item_lancto_ctbl) = v_rec_item_lancto_ctbl NO-ERROR.
            IF AVAIL item_lancto_ctbl THEN DO:
                IF SEARCH ("prgfin/fgl/fgl206aa.r") = ? AND SEARCH ("prgfin/fgl/fgl206aa.p") = ? THEN DO:
                     MESSAGE "Programa execut vel nÆo foi encontrado:"  " prgfin/fgl/fgl206aa.p"
                             VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                     RETURN.
                END.
                ELSE
                    RUN prgfin/fgl/fgl206aa.p.
            END.
        END.

        assign current-window              = v_wgh_current_window.
        assign v_wgh_child                 = current-window:first-child
               current-window:window-state = 3
               current-window:visible      = yes.
        if  v_wgh_current_menu <> ?
        then do:
            assign v_wgh_current_menu:sensitive = yes.
        end.

        assign v_wgh_child_2 = v_wgh_child
               v_cod_name = (if v_wgh_child_2 <> ? then v_wgh_child_2:name else "").

        habil:
        do while v_wgh_child_2 <> ?:
            assign v_wgh_child_2 = v_wgh_child_2:next-sibling.
            if  v_wgh_child_2 <> ?
            and v_wgh_child_2:name = v_cod_name then
                assign v_wgh_child = v_wgh_child_2.
        END.

        IF v_wgh_child <> ? THEN
            ASSIGN v_wgh_child:SENSITIVE = YES.

    END.
    
    ENABLE ALL WITH FRAME f_det.
    APPLY "ENTRY" TO v_wgh_focus.

END.

create window wh_w_program
    assign row                  = 01.00
           col                  = 01.00
           height-chars         = 01.00
           width-chars          = 01.00
           min-width-chars      = 01.00
           min-height-chars     = 01.00
           max-width-chars      = 01.00
           max-height-chars     = 01.00
           virtual-width-chars  = 300.00
           virtual-height-chars = 200.00
           title                = "Program"
           resize               = no
           scroll-bars          = no
           status-area          = yes
           status-area-font     = ?
           message-area         = no
           message-area-font    = ?
           fgcolor              = ?
           bgcolor              = ?.

{include/i_fclwin.i wh_w_program}

/*--- Main Code ---*/
assign wh_w_program:title            = frame f_det:title
       frame f_det:title             = ?
       wh_w_program:width-chars      = frame f_det:width-chars
       wh_w_program:height-chars     = frame f_det:height-chars - 0.85
       frame f_det:row               = 1
       frame f_det:col               = 1
       wh_w_program:col              = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row              = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window                = wh_w_program
       v_wgh_current_menu            = current-window:MENUBAR
       v_wgh_current_window          = wh_w_program.

pause 0 before-hide.
ASSIGN v_log_repeat = YES
       v_wgh_focus = bt_ok:HANDLE IN FRAME f_det.

RUN pi_lista_origem.

FIND tt_orcto_real NO-LOCK
    WHERE RECID (tt_orcto_real) = p_rec_tt_orcto_real NO-ERROR.
IF NOT AVAIL tt_orcto_real THEN
    RETURN.
    
assign v_cod_ccusto = tt_orcto_real.cod_ccusto.

main_block:
REPEAT WHILE v_log_repeat = yes on endkey undo main_block, leave main_block
   ON ERROR UNDO main_block, retry main_block with frame f_det:
   ASSIGN v_log_repeat = NO.
   VIEW FRAME f_det.
   ENABLE ALL WITH FRAME f_det.
   DISPLAY rs_tip_movto
           br_realiz
           v_val_tot_movto
           WITH FRAME f_det.
   DISABLE v_val_tot_movto 
           WITH FRAME f_det.
   APPLY "value-changed" to rs_tip_movto in frame f_det.
   
   IF VALID-HANDLE (v_wgh_focus) THEN DO:
      WAIT-FOR GO OF FRAME f_det FOCUS v_wgh_focus.
   END.
   ELSE DO:
       WAIT-FOR GO OF FRAME f_det.
   END.
END.

HIDE FRAME f_det NO-PAUSE.

PROCEDURE pi_criar_tt_realiz:

    DEF VAR v_dat_aux     AS DATE NO-UNDO.
    DEF VAR v_dat_inicial AS DATE NO-UNDO.

    EMPTY TEMP-TABLE tt_orig_movto_empenh_aux.
    EMPTY TEMP-TABLE tt_realiz.

    FIND tt_orcto_real NO-LOCK
        WHERE RECID (tt_orcto_real) = p_rec_tt_orcto_real NO-ERROR.
    IF NOT AVAIL tt_orcto_real THEN
        RETURN.

    ASSIGN v_val_tot_movto = 0.

    IF p_log_acum = YES THEN
        ASSIGN v_dat_inicial = DATE (01, 01, YEAR (tt_orcto_real.dat_inicial)).
    ELSE
        ASSIGN v_dat_inicial = tt_orcto_real.dat_inicial.
    
    /*IF rs_tip_movto <> 2 THEN DO:*/
        /* Empenhado */
        FOR EACH orig_movto_empenh NO-LOCK
            WHERE orig_movto_empenh.cod_empresa        = tt_orcto_real.cod_empresa
              AND orig_movto_empenh.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
              AND orig_movto_empenh.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
              AND orig_movto_empenh.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
              AND orig_movto_empenh.cod_ccusto         = tt_orcto_real.cod_ccusto
              AND orig_movto_empenh.cod_finalid_econ   = tt_orcto_real.cod_finalid_econ
              AND orig_movto_empenh.dat_sdo_ctbl      >= v_dat_inicial
              AND orig_movto_empenh.dat_sdo_ctbl      <= tt_orcto_real.dat_final:
            IF orig_movto_empenh.num_ult_funcao = 3 /* Realizado */ 
            /*OR orig_movto_empenh.num_ult_funcao = 5*/ THEN
                NEXT.                                                
            IF orig_movto_empenh.cod_estab < p_cod_estab_ini 
            OR orig_movto_empenh.cod_estab > p_cod_estab_fim THEN 
                NEXT.
            IF orig_movto_empenh.cod_unid_negoc < p_cod_unid_negoc_ini 
            OR orig_movto_empenh.cod_unid_negoc > p_cod_unid_negoc_fim THEN
                NEXT.
            CREATE tt_orig_movto_empenh_aux.
            ASSIGN tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh = RECID (orig_movto_empenh)
                   tt_orig_movto_empenh_aux.ttv_num_seq               = orig_movto_empenh.num_seq_orig_movto
                   tt_orig_movto_empenh_aux.tta_cod_cta_ctbl          = orig_movto_empenh.cod_cta_ctbl
                   tt_orig_movto_empenh_aux.tta_cod_ccusto            = orig_movto_empenh.cod_ccusto
                   tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = orig_movto_empenh.num_orig_movto_empenh
                   tt_orig_movto_empenh_aux.ttv_des_orig_movto_bgc    = STRING(ENTRY(orig_movto_empenh.num_orig_movto_empenh, v_des_lista_orig))
                   tt_orig_movto_empenh_aux.tta_val_movto_empenh      = orig_movto_empenh.val_movto_empenh
                   tt_orig_movto_empenh_aux.ttv_dat_empenh            = DATE (ENTRY (2, orig_movto_empenh.cod_livre_1, CHR(10)))
                   tt_orig_movto_empenh_aux.tta_cod_unid_orctaria     = p_cod_unid_orctaria
                   tt_orig_movto_empenh_aux.tta_cod_unid_negoc        = orig_movto_empenh.cod_unid_negoc
                   tt_orig_movto_empenh_aux.tta_cod_estab             = orig_movto_empenh.cod_estab
                   tt_orig_movto_empenh_aux.tta_cod_proj_financ       = orig_movto_empenh.cod_proj_financ
                   tt_orig_movto_empenh_aux.tta_des_contdo_movto      = orig_movto_empenh.des_contdo_movto.

            FIND tt_realiz 
                WHERE tt_realiz.rec_id              = RECID (orig_movto_empenh)
                  AND tt_realiz.num_seq             = tt_orig_movto_empenh_aux.ttv_num_seq
                  AND tt_realiz.ind_tip_movto       = "Empenhado"
                  AND tt_realiz.cod_empresa         = tt_orcto_real.cod_empresa
                  AND tt_realiz.cod_finalid_econ    = tt_orcto_real.cod_finalid_econ         
                  AND tt_realiz.cod_cenar_ctbl      = tt_orcto_real.cod_cenar_ctbl
                  AND tt_realiz.cod_plano_cta_ctbl  = tt_orcto_real.cod_plano_cta_ctbl         
                  AND tt_realiz.cod_cta_ctbl        = tt_orcto_real.cod_cta_ctbl
                  AND tt_realiz.cod_estab           = orig_movto_empenh.cod_estab
                  AND tt_realiz.cod_unid_negoc      = orig_movto_empenh.cod_unid_negoc
                  AND tt_realiz.cod_plano_ccusto    = tt_orcto_real.cod_plano_ccusto
                  AND tt_realiz.cod_ccusto          = tt_orcto_real.cod_ccusto
                  AND tt_realiz.dat_movto           = orig_movto_empenh.dat_sdo_ctbl NO-ERROR.
            IF NOT AVAIL tt_realiz THEN DO:
                CREATE tt_realiz.
                ASSIGN tt_realiz.rec_id                   = RECID (orig_movto_empenh)
                       tt_realiz.rec_orig_movto_empenh    = RECID (tt_orig_movto_empenh_aux)
                       tt_realiz.num_seq                  = tt_orig_movto_empenh_aux.ttv_num_seq
                       tt_realiz.ind_tip_movto            = "Empenhado"

                       tt_realiz.movimento                = STRING(orig_movto_empenh.num_orig_movto_empenh) + "-" + STRING(ENTRY(orig_movto_empenh.num_orig_movto_empenh, v_des_lista_orig))
                       tt_realiz.cod_empresa              = tt_orcto_real.cod_empresa
                       tt_realiz.cod_cenar_ctbl           = tt_orcto_real.cod_cenar_ctbl
                       tt_realiz.cod_finalid_econ         = tt_orcto_real.cod_finalid_econ
                       tt_realiz.cod_plano_cta_ctbl       = tt_orcto_real.cod_plano_cta_ctbl
                       tt_realiz.cod_cta_ctbl             = tt_orcto_real.cod_cta_ctbl
                       tt_realiz.cod_plano_ccusto         = tt_orcto_real.cod_plano_ccusto
                       tt_realiz.cod_ccusto               = tt_orcto_real.cod_ccusto
                       tt_realiz.cod_estab                = orig_movto_empenh.cod_estab
                       tt_realiz.cod_unid_negoc           = orig_movto_empenh.cod_unid_negoc
                       tt_realiz.dat_movto                = orig_movto_empenh.dat_sdo_ctbl
                       tt_realiz.cod_modul_dtsul          = ""
                       tt_realiz.des_contdo_movto         = orig_movto_empenh.des_contdo_movto
                       tt_realiz.val_movto                = orig_movto_empenh.val_movto_empenh
                       v_val_tot_movto                    = v_val_tot_movto
                                                          + orig_movto_empenh.val_movto_empenh.
            END.
        END.
        RUN pi_busca_orig_movto_empenh.
        FOR EACH tt_realiz:
            FIND tt_orig_movto_empenh_aux 
                WHERE RECID (tt_orig_movto_empenh_aux) = tt_realiz.rec_orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_movto_empenh_aux THEN DO:
                ASSIGN tt_realiz.des_contdo_movto = tt_orig_movto_empenh_aux.tta_des_contdo_movto
                       tt_realiz.narrativa        = fn-narrativa(tt_realiz.des_contdo_movto).
                case tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh:
                    when 1 /* T¡tulo APB Pendente */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "APB"
                               tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 2 /* T¡tulo APB */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "APB"
                               tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 4 /* T¡tulo AP Pendente */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 5 /* T¡tulo AP */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 6 /* Atendimento de Requisi‡Æo */      or
                    when 8 /* Transa‡äes Diversas */            or
                    when 20 /* Requisi‡Æo de Materiais */       or
                    when 13 /* Entrada NF */                    or
                    when 14 /* Devolu‡Æo NF */                  or 
                    when 33 /* Req./Devol. Material MI */       or 
                    when 34 /* Atend.Req./Solic. Material MI */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCE".                        

                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                        

                    end.
                    when 7 /* Requisi‡Æo/Solicita‡Æo de Compras */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCC".                        
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 18 /* Aprova‡Æo Cota‡Æo */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCC".
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 3  or
                    when 21 or
                    when 22 or
                    when 23 or
                    when 24 or 
                    when 25 then do: /* EEC */
                        ASSIGN tt_realiz.cod_modul_dtsul = "EEC".
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 26 then do: /* FGL */
                        ASSIGN tt_realiz.cod_modul_dtsul = "FGL".
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 10 /* C. Compra sem Matriz */ or
                    when 11 /* C. Compra com Matriz */ or
                    when 12 /* C. Compra por Medi‡Æo */ then do: /* CNP */
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 32 /* Movto Conta Corrente 2.0 */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 35 /* Req./Solic. Material MI*/ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 36 /* MOB MI */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 37 /* GGF MI */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.    
                    when 38 /* Movto Cta Corrente 5.0 */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                        ASSIGN tt_realiz.cod_modul_dtsul = "CMG".
                    end.    
                END.
            END.            
        END.
    /*END.*/
    /*IF rs_tip_movto <> 1 THEN DO: */
        DO v_dat_aux = v_dat_inicial TO tt_orcto_real.dat_final:
            FOR EACH item_lancto_ctbl NO-LOCK
                WHERE item_lancto_ctbl.cod_empresa         = tt_orcto_real.cod_empresa
                  AND item_lancto_ctbl.cod_plano_cta_ctbl  = tt_orcto_real.cod_plano_cta_ctbl
                  AND item_lancto_ctbl.cod_cta_ctbl        = tt_orcto_real.cod_cta_ctbl
                  AND item_lancto_ctbl.cod_plano_ccusto    = tt_orcto_real.cod_plano_ccusto
                  AND item_lancto_ctbl.cod_ccusto          = tt_orcto_real.cod_ccusto
                  AND item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"
                  AND item_lancto_ctbl.dat_lancto_ctbl     = v_dat_aux:
                FIND lancto_ctbl OF item_lancto_ctbl NO-LOCK NO-ERROR.
                IF NOT AVAIL lancto_ctbl THEN
                    NEXT.
                IF lancto_ctbl.cod_cenar_ctbl <> "" AND lancto_ctbl.cod_cenar_ctbl <> tt_orcto_real.cod_cenar_ctbl THEN
                    NEXT.
                IF item_lancto_ctbl.cod_estab < p_cod_estab_ini 
                OR item_lancto_ctbl.cod_estab > p_cod_estab_fim THEN 
                    NEXT.
                IF item_lancto_ctbl.cod_unid_negoc < p_cod_unid_negoc_ini 
                OR item_lancto_ctbl.cod_unid_negoc > p_cod_unid_negoc_fim THEN
                    NEXT.
                FIND aprop_lancto_ctbl OF item_lancto_ctbl NO-LOCK
                    WHERE aprop_lancto_ctbl.cod_finalid_econ   = tt_orcto_real.cod_finalid_econ NO-ERROR.
                IF AVAIL aprop_lancto_ctbl THEN DO:
                    FIND tt_realiz 
                        WHERE tt_realiz.rec_id              = RECID (item_lancto_ctbl)
                          AND tt_realiz.num_seq             = item_lancto_ctbl.num_seq_lancto_ctbl
                          AND tt_realiz.ind_tip_movto       = "Realizado"
                          AND tt_realiz.cod_empresa         = item_lancto_ctbl.cod_empresa         
                          AND tt_realiz.cod_finalid_econ    = aprop_lancto_ctbl.cod_finalid_econ         
                          AND tt_realiz.cod_cenar_ctbl      = item_lancto_ctbl.cod_cenar_ctbl
                          AND tt_realiz.cod_plano_cta_ctbl  = item_lancto_ctbl.cod_plano_cta_ctbl         
                          AND tt_realiz.cod_cta_ctbl        = item_lancto_ctbl.cod_cta_ctbl
                          AND tt_realiz.cod_estab           = item_lancto_ctbl.cod_estab
                          AND tt_realiz.cod_unid_negoc      = item_lancto_ctbl.cod_unid_negoc
                          AND tt_realiz.cod_plano_ccusto    = item_lancto_ctbl.cod_plano_ccusto
                          AND tt_realiz.cod_ccusto          = item_lancto_ctbl.cod_ccusto
                          AND tt_realiz.dat_movto           = item_lancto_ctbl.dat_lancto_ctbl NO-ERROR.
                    IF NOT AVAIL tt_realiz THEN DO:
                        CREATE tt_realiz.
                        ASSIGN tt_realiz.rec_id                   = RECID (item_lancto_ctbl)
                               tt_realiz.num_seq                  = item_lancto_ctbl.num_seq_lancto_ctbl
                               tt_realiz.ind_tip_movto            = "Realizado"
                               tt_realiz.cod_empresa              = item_lancto_ctbl.cod_empresa
                               tt_realiz.cod_cenar_ctbl           = item_lancto_ctbl.cod_cenar_ctbl
                               tt_realiz.cod_finalid_econ         = aprop_lancto_ctbl.cod_finalid_econ
                               tt_realiz.cod_plano_cta_ctbl       = item_lancto_ctbl.cod_plano_cta_ctbl
                               tt_realiz.cod_cta_ctbl             = item_lancto_ctbl.cod_cta_ctbl
                               tt_realiz.cod_plano_ccusto         = item_lancto_ctbl.cod_plano_ccusto
                               tt_realiz.cod_ccusto               = item_lancto_ctbl.cod_ccusto
                               tt_realiz.cod_estab                = item_lancto_ctbl.cod_estab
                               tt_realiz.cod_unid_negoc           = item_lancto_ctbl.cod_unid_negoc
                               tt_realiz.dat_movto                = v_dat_aux
                               tt_realiz.cod_modul_dtsul          = lancto_ctbl.cod_modul_dtsul
                               tt_realiz.val_movto                = IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" THEN aprop_lancto_ctbl.val_lancto_ctbl
                                                                    ELSE aprop_lancto_ctbl.val_lancto_ctbl * -1
                               tt_realiz.des_contdo_movto         = item_lancto_ctbl.des_histor_lancto_ctbl
                               v_val_tot_movto                    = v_val_tot_movto
                                                                  + tt_realiz.val_movto. 
                    END.
                END.
            END.
        END.
    /*END.*/

END.

PROCEDURE pi_criar_tt_realiz_obz:

    DEF VAR v_dat_aux     AS DATE NO-UNDO.
    DEF VAR v_dat_inicial AS DATE NO-UNDO.

    EMPTY TEMP-TABLE tt_orig_movto_empenh_aux.
    EMPTY TEMP-TABLE tt_realiz.

    ASSIGN v_val_tot_movto = 0.
    FIND tt_orcto_real NO-LOCK
        WHERE RECID (tt_orcto_real) = p_rec_tt_orcto_real NO-ERROR.
    IF NOT AVAIL tt_orcto_real THEN
        RETURN.

    IF p_log_acum = YES THEN
        ASSIGN v_dat_inicial = DATE (01, 01, YEAR (tt_orcto_real.dat_inicial)).
    ELSE
        ASSIGN v_dat_inicial = tt_orcto_real.dat_inicial.
    
    /*IF rs_tip_movto <> 2 THEN DO:*/
        /* Empenhado */
        FOR EACH orig_movto_empenh NO-LOCK
            WHERE orig_movto_empenh.cod_empresa        = tt_orcto_real.cod_empresa
              AND orig_movto_empenh.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
              AND orig_movto_empenh.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
              /*AND orig_movto_empenh.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
              AND orig_movto_empenh.cod_ccusto         = tt_orcto_real.cod_ccusto*/
              AND orig_movto_empenh.cod_finalid_econ   = tt_orcto_real.cod_finalid_econ
              AND orig_movto_empenh.dat_sdo_ctbl      >= v_dat_inicial
              AND orig_movto_empenh.dat_sdo_ctbl      <= tt_orcto_real.dat_final:
            IF orig_movto_empenh.num_ult_funcao = 3 /* Realizado */ 
            /*OR orig_movto_empenh.num_ult_funcao = 5*/ THEN
                NEXT.
            IF orig_movto_empenh.cod_estab < p_cod_estab_ini 
            OR orig_movto_empenh.cod_estab > p_cod_estab_fim THEN 
                NEXT.
            IF orig_movto_empenh.cod_unid_negoc < p_cod_unid_negoc_ini 
            OR orig_movto_empenh.cod_unid_negoc > p_cod_unid_negoc_fim THEN
                NEXT.
            CREATE tt_orig_movto_empenh_aux.
            ASSIGN tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh = RECID (orig_movto_empenh)
                   tt_orig_movto_empenh_aux.ttv_num_seq               = orig_movto_empenh.num_seq_orig_movto
                   tt_orig_movto_empenh_aux.tta_cod_cta_ctbl          = orig_movto_empenh.cod_cta_ctbl
                   /*tt_orig_movto_empenh_aux.tta_cod_ccusto            = orig_movto_empenh.cod_ccusto*/
                   tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = orig_movto_empenh.num_orig_movto_empenh
                   tt_orig_movto_empenh_aux.ttv_des_orig_movto_bgc    = STRING (ENTRY (orig_movto_empenh.num_orig_movto_empenh, v_des_lista_orig))
                   tt_orig_movto_empenh_aux.tta_val_movto_empenh      = orig_movto_empenh.val_movto_empenh
                   tt_orig_movto_empenh_aux.ttv_dat_empenh            = DATE (ENTRY (2, orig_movto_empenh.cod_livre_1, CHR(10)))
                   tt_orig_movto_empenh_aux.tta_cod_unid_orctaria     = p_cod_unid_orctaria
                   tt_orig_movto_empenh_aux.tta_cod_unid_negoc        = orig_movto_empenh.cod_unid_negoc
                   tt_orig_movto_empenh_aux.tta_cod_estab             = orig_movto_empenh.cod_estab
                   tt_orig_movto_empenh_aux.tta_cod_proj_financ       = orig_movto_empenh.cod_proj_financ
                   tt_orig_movto_empenh_aux.tta_des_contdo_movto      = orig_movto_empenh.des_contdo_movto.

            FIND tt_realiz 
                WHERE tt_realiz.rec_id              = RECID (orig_movto_empenh)
                  AND tt_realiz.num_seq             = tt_orig_movto_empenh_aux.ttv_num_seq
                  AND tt_realiz.ind_tip_movto       = "Empenhado"
                  AND tt_realiz.cod_empresa         = tt_orcto_real.cod_empresa
                  AND tt_realiz.cod_finalid_econ    = tt_orcto_real.cod_finalid_econ         
                  AND tt_realiz.cod_cenar_ctbl      = tt_orcto_real.cod_cenar_ctbl
                  AND tt_realiz.cod_plano_cta_ctbl  = tt_orcto_real.cod_plano_cta_ctbl         
                  AND tt_realiz.cod_cta_ctbl        = tt_orcto_real.cod_cta_ctbl
                  AND tt_realiz.cod_estab           = orig_movto_empenh.cod_estab
                  AND tt_realiz.cod_unid_negoc      = orig_movto_empenh.cod_unid_negoc
                  /*AND tt_realiz.cod_plano_ccusto    = tt_orcto_real.cod_plano_ccusto
                  AND tt_realiz.cod_ccusto          = tt_orcto_real.cod_ccusto*/
                  // Chamado 84058
                  AND tt_realiz.cod_plano_ccusto    = orig_movto_empenh.cod_plano_ccusto
                  AND tt_realiz.cod_ccusto          = orig_movto_empenh.cod_ccusto

                  AND tt_realiz.dat_movto           = orig_movto_empenh.dat_sdo_ctbl NO-ERROR.
            IF NOT AVAIL tt_realiz THEN DO:
                CREATE tt_realiz.
                ASSIGN tt_realiz.rec_id                   = RECID (orig_movto_empenh)
                       tt_realiz.rec_orig_movto_empenh    = RECID (tt_orig_movto_empenh_aux)
                       tt_realiz.num_seq                  = tt_orig_movto_empenh_aux.ttv_num_seq
                       tt_realiz.ind_tip_movto            = "Empenhado"

                       tt_realiz.movimento                = STRING(orig_movto_empenh.num_orig_movto_empenh) + "-" + STRING(ENTRY(orig_movto_empenh.num_orig_movto_empenh, v_des_lista_orig))
                       tt_realiz.cod_empresa              = tt_orcto_real.cod_empresa
                       tt_realiz.cod_cenar_ctbl           = tt_orcto_real.cod_cenar_ctbl
                       tt_realiz.cod_finalid_econ         = tt_orcto_real.cod_finalid_econ
                       tt_realiz.cod_plano_cta_ctbl       = tt_orcto_real.cod_plano_cta_ctbl
                       tt_realiz.cod_cta_ctbl             = tt_orcto_real.cod_cta_ctbl
                       /*tt_realiz.cod_plano_ccusto         = tt_orcto_real.cod_plano_ccusto
                       tt_realiz.cod_ccusto               = tt_orcto_real.cod_ccusto*/
                       // Chamado 84058
                       tt_realiz.cod_plano_ccusto         = orig_movto_empenh.cod_plano_ccusto
                       tt_realiz.cod_ccusto               = orig_movto_empenh.cod_ccusto

                       tt_realiz.cod_estab                = orig_movto_empenh.cod_estab
                       tt_realiz.cod_unid_negoc           = orig_movto_empenh.cod_unid_negoc
                       tt_realiz.dat_movto                = orig_movto_empenh.dat_sdo_ctbl
                       tt_realiz.cod_modul_dtsul          = ""
                       tt_realiz.des_contdo_movto         = orig_movto_empenh.des_contdo_movto
                       tt_realiz.narrativa                = fn-narrativa(orig_movto_empenh.des_contdo_movto)
                       tt_realiz.val_movto                = orig_movto_empenh.val_movto_empenh
                       v_val_tot_movto                    = v_val_tot_movto
                                                          + orig_movto_empenh.val_movto_empenh.
            END.
        END.
        RUN pi_busca_orig_movto_empenh.
        FOR EACH tt_realiz:
            FIND tt_orig_movto_empenh_aux 
                WHERE RECID (tt_orig_movto_empenh_aux) = tt_realiz.rec_orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_movto_empenh_aux THEN DO:
                ASSIGN tt_realiz.des_contdo_movto = tt_orig_movto_empenh_aux.tta_des_contdo_movto
                       tt_realiz.narrativa        = fn-narrativa(tt_realiz.des_contdo_movto).
                case tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh:
                    when 1 /* T¡tulo APB Pendente */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "APB"
                               tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 2 /* T¡tulo APB */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "APB"
                               tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 4 /* T¡tulo AP Pendente */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 5 /* T¡tulo AP */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 6 /* Atendimento de Requisi‡Æo */      or
                    when 8 /* Transa‡äes Diversas */            or
                    when 20 /* Requisi‡Æo de Materiais */       or
                    when 13 /* Entrada NF */                    or
                    when 14 /* Devolu‡Æo NF */                  or 
                    when 33 /* Req./Devol. Material MI */       or 
                    when 34 /* Atend.Req./Solic. Material MI */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCE".                        

                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".

                    end.
                    when 7 /* Requisi‡Æo/Solicita‡Æo de Compras */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCC".                        
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 18 /* Aprova‡Æo Cota‡Æo */ then do:
                        ASSIGN tt_realiz.cod_modul_dtsul = "MCC".
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 3  or
                    when 21 or
                    when 22 or
                    when 23 or
                    when 24 or 
                    when 25 then do: /* EEC */
                        ASSIGN tt_realiz.cod_modul_dtsul = "EEC".
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 26 then do: /* FGL */
                        ASSIGN tt_realiz.cod_modul_dtsul = "FGL".
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 10 /* C. Compra sem Matriz */ or
                    when 11 /* C. Compra com Matriz */ or
                    when 12 /* C. Compra por Medi‡Æo */ then do: /* CNP */
                        ASSIGN tt_realiz.ind_tip_movto   = "Empenhado".
                    end.
                    when 32 /* Movto Conta Corrente 2.0 */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 35 /* Req./Solic. Material MI*/ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 36 /* MOB MI */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.
                    when 37 /* GGF MI */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                    end.    
                    when 38 /* Movto Cta Corrente 5.0 */ then do:
                        ASSIGN tt_realiz.ind_tip_movto   = "Realizado".
                        ASSIGN tt_realiz.cod_modul_dtsul = "CMG".
                    end.    
                END.
            END.            
        END.
    /*END.
    IF rs_tip_movto <> 1 THEN DO: */
        DO v_dat_aux = v_dat_inicial TO tt_orcto_real.dat_final:
            FOR EACH item_lancto_ctbl NO-LOCK
                WHERE item_lancto_ctbl.cod_empresa         = tt_orcto_real.cod_empresa
                  AND item_lancto_ctbl.cod_plano_cta_ctbl  = tt_orcto_real.cod_plano_cta_ctbl
                  AND item_lancto_ctbl.cod_cta_ctbl        = tt_orcto_real.cod_cta_ctbl
                  /*AND item_lancto_ctbl.cod_plano_ccusto    = tt_orcto_real.cod_plano_ccusto
                  AND item_lancto_ctbl.cod_ccusto          = tt_orcto_real.cod_ccusto*/
                  AND item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"
                  AND item_lancto_ctbl.dat_lancto_ctbl     = v_dat_aux:
                FIND lancto_ctbl OF item_lancto_ctbl NO-LOCK NO-ERROR.
                IF NOT AVAIL lancto_ctbl THEN
                    NEXT.
                IF lancto_ctbl.cod_cenar_ctbl <> "" AND lancto_ctbl.cod_cenar_ctbl <> tt_orcto_real.cod_cenar_ctbl THEN
                    NEXT.
                IF item_lancto_ctbl.cod_estab < p_cod_estab_ini 
                OR item_lancto_ctbl.cod_estab > p_cod_estab_fim THEN 
                    NEXT.
                IF item_lancto_ctbl.cod_unid_negoc < p_cod_unid_negoc_ini 
                OR item_lancto_ctbl.cod_unid_negoc > p_cod_unid_negoc_fim THEN
                    NEXT.
                FIND aprop_lancto_ctbl OF item_lancto_ctbl NO-LOCK
                    WHERE aprop_lancto_ctbl.cod_finalid_econ   = tt_orcto_real.cod_finalid_econ NO-ERROR.
                IF AVAIL aprop_lancto_ctbl THEN DO:
                    FIND tt_realiz 
                        WHERE tt_realiz.rec_id              = RECID (item_lancto_ctbl)
                          AND tt_realiz.num_seq             = item_lancto_ctbl.num_seq_lancto_ctbl
                          AND tt_realiz.ind_tip_movto       = "Realizado"
                          AND tt_realiz.cod_empresa         = item_lancto_ctbl.cod_empresa         
                          AND tt_realiz.cod_finalid_econ    = aprop_lancto_ctbl.cod_finalid_econ         
                          AND tt_realiz.cod_cenar_ctbl      = item_lancto_ctbl.cod_cenar_ctbl
                          AND tt_realiz.cod_plano_cta_ctbl  = item_lancto_ctbl.cod_plano_cta_ctbl         
                          AND tt_realiz.cod_cta_ctbl        = item_lancto_ctbl.cod_cta_ctbl
                          AND tt_realiz.cod_estab           = item_lancto_ctbl.cod_estab
                          AND tt_realiz.cod_unid_negoc      = item_lancto_ctbl.cod_unid_negoc
                          /*AND tt_realiz.cod_plano_ccusto    = item_lancto_ctbl.cod_plano_ccusto
                          AND tt_realiz.cod_ccusto          = item_lancto_ctbl.cod_ccusto*/
                          // Chamado 84058
                          AND tt_realiz.cod_plano_ccusto    = item_lancto_ctbl.cod_plano_ccusto
                          AND tt_realiz.cod_ccusto          = item_lancto_ctbl.cod_ccusto

                          AND tt_realiz.dat_movto           = item_lancto_ctbl.dat_lancto_ctbl NO-ERROR.
                    IF NOT AVAIL tt_realiz THEN DO:
                        CREATE tt_realiz.
                        ASSIGN tt_realiz.rec_id                   = RECID (item_lancto_ctbl)
                               tt_realiz.num_seq                  = item_lancto_ctbl.num_seq_lancto_ctbl
                               tt_realiz.ind_tip_movto            = "Realizado"
                               tt_realiz.cod_empresa              = item_lancto_ctbl.cod_empresa
                               tt_realiz.cod_cenar_ctbl           = item_lancto_ctbl.cod_cenar_ctbl
                               tt_realiz.cod_finalid_econ         = aprop_lancto_ctbl.cod_finalid_econ
                               tt_realiz.cod_plano_cta_ctbl       = item_lancto_ctbl.cod_plano_cta_ctbl
                               tt_realiz.cod_cta_ctbl             = item_lancto_ctbl.cod_cta_ctbl
                               /*tt_realiz.cod_plano_ccusto         = item_lancto_ctbl.cod_plano_ccusto
                               tt_realiz.cod_ccusto               = item_lancto_ctbl.cod_ccusto*/
                               // Chamado 84058
                               tt_realiz.cod_plano_ccusto         = item_lancto_ctbl.cod_plano_ccusto
                               tt_realiz.cod_ccusto               = item_lancto_ctbl.cod_ccusto

                               tt_realiz.cod_estab                = item_lancto_ctbl.cod_estab
                               tt_realiz.cod_unid_negoc           = item_lancto_ctbl.cod_unid_negoc
                               tt_realiz.dat_movto                = v_dat_aux
                               tt_realiz.cod_modul_dtsul          = lancto_ctbl.cod_modul_dtsul
                               tt_realiz.val_movto                = IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" THEN aprop_lancto_ctbl.val_lancto_ctbl
                                                                    ELSE aprop_lancto_ctbl.val_lancto_ctbl * -1
                               tt_realiz.des_contdo_movto         = item_lancto_ctbl.des_histor_lancto_ctbl
                               v_val_tot_movto                    = v_val_tot_movto
                                                                  + tt_realiz.val_movto. 
                    END.
                END.
            END.
        END.
    /*END. */

END.

PROCEDURE pi_busca_orig_movto_empenh:

    for each tt_orig_movto_empenh_aux
        where tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh <> ?
        and   (tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 1
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 2
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 3
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 21
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 22
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 23
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 24
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 25
               &IF DEFINED (BF_FIN_INTEGR_FGL_BGC) &THEN
               or tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 26
               &ENDIF ):
        CASE tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh:

            WHEN 1 /* T¡tulo APB Pendente */ THEN DO:
                RUN pi_busca_orig_aprop_ctbl_pend_ap.                
            END.
            WHEN 2 /* T¡tulo APB */ THEN DO:
                run pi_busca_orig_aprop_ctbl_ap.                
            END.                
            WHEN 3  or
            when 21 or
            when 22 or
            when 23 or
            when 24 or 
            when 25 THEN DO:
                RUN pi_busca_orig_prestac_cta.
                ASSIGN tt_realiz.cod_modul_dtsul = "EEC".
            END.                
            when 26 then do:
                ASSIGN tt_realiz.cod_modul_dtsul = "FGL".
                find first item_lancto_ctbl no-lock
                    where item_lancto_ctbl.num_lote_ctbl       = int(entry(1, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10)))
                      and item_lancto_ctbl.num_lancto_ctbl     = int(entry(2, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10)))
                      and item_lancto_ctbl.num_seq_lancto_ctbl = int(entry(3, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))) no-error.
                if avail item_lancto_ctbl then
                    assign tt_orig_movto_empenh_aux.ttv_rec_id           = RECID (item_lancto_ctbl)                                        
                           tt_orig_movto_empenh_aux.tta_des_contdo_movto = "Lote:" /*l_LOTE:*/  + ' ' + string(item_lancto_ctbl.num_lote_ctbl) + '  ' +
                                                                           "Lancto:" /*l_lancto:*/  + ' ' + string(item_lancto_ctbl.num_lancto_ctbl) + '  ' + 
                                                                           "Seq:" /*l_SEQ:*/  + ' ' + string(item_lancto_ctbl.num_seq_lancto_ctbl).
            end.
            when 38 /* Movto Cta Corrente 5.0 */ then do:
                ASSIGN tt_realiz.cod_modul_dtsul = "CMG".
            end.
        end case.
    end.

    IF CAN-FIND (first tt_orig_movto_empenh_aux
                where tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 6 
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 8 
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 20 
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 13 
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 14) THEN DO:
        RUN cdp/cdapi560.p (OUTPUT TABLE tt_orig_movto_estoq).
    END.        

    IF CAN-FIND (first tt_orig_movto_empenh_aux
                where tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 7
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 18
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 10
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 11
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 12) THEN DO:        
        run cdp/cdapi561.p (output table tt_orig_requisicao,
                            output table tt_orig_ordem_compra,
                            output table tt_orig_contrat,
                            output table tt_orig_contrat_medicao).        
    END.

    if can-find( first tt_orig_movto_empenh_aux
                where tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 4
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 5
                or    tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 32) THEN DO:
        run cdp/cdapi562.p (output table tt_orig_lin_i_ap,
                            output table tt_orig_tit_ap,
                            output table tt_orig_mcb).
    END.

END.

PROCEDURE pi_busca_orig_aprop_ctbl_pend_ap:

    find aprop_ctbl_pend_ap no-lock
        where aprop_ctbl_pend_ap.cod_estab            = entry(1, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_refer            = entry(2, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.num_seq_refer        = int(entry(3, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10)))
        and   aprop_ctbl_pend_ap.cod_estab_aprop_ctbl = entry(4, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_plano_cta_ctbl   = entry(5, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_cta_ctbl         = entry(6, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_unid_negoc       = entry(7, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_plano_ccusto     = entry(8, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_ccusto           = entry(9, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))
        and   aprop_ctbl_pend_ap.cod_tip_fluxo_financ = entry(10, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10)) no-error.
    if avail aprop_ctbl_pend_ap then do:
        find item_lote_impl_ap no-lock
            where item_lote_impl_ap.cod_estab     = aprop_ctbl_pend_ap.cod_estab
            and   item_lote_impl_ap.cod_refer     = aprop_ctbl_pend_ap.cod_refer
            and   item_lote_impl_ap.num_seq_refer = aprop_ctbl_pend_ap.num_seq_refer no-error.
         if avail item_lote_impl_ap then do:
             find lote_impl_tit_ap no-lock
                 where lote_impl_tit_ap.cod_estab = item_lote_impl_ap.cod_estab
                 and   lote_impl_tit_ap.cod_refer = item_lote_impl_ap.cod_refer no-error.
             if avail lote_impl_tit_ap then do:
                 create tt_orig_aprop_ctbl_pend_ap.
                 assign tt_orig_aprop_ctbl_pend_ap.ttv_rec_orig_movto_empenh = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                        tt_orig_aprop_ctbl_pend_ap.tta_cod_estab             = lote_impl_tit_ap.cod_estab
                        tt_orig_aprop_ctbl_pend_ap.tta_cod_refer             = lote_impl_tit_ap.cod_refer
                        tt_orig_aprop_ctbl_pend_ap.tta_num_seq_refer         = item_lote_impl_ap.num_seq_refer
                        tt_orig_movto_empenh_aux.ttv_rec_id                  = recid(lote_impl_tit_ap)
                        tt_orig_movto_empenh_aux.tta_des_contdo_movto        = "Estab:" /*l_estab:*/  + ' ' + tt_orig_aprop_ctbl_pend_ap.tta_cod_estab + '  ' +
                                                                               "Refer:" /*l_refer:*/  + ' ' + tt_orig_aprop_ctbl_pend_ap.tta_cod_refer + '  ' +
                                                                               "Seq:" /*l_SEQ:*/    + ' ' + string(tt_orig_aprop_ctbl_pend_ap.tta_num_seq_refer).
             end.
         end.
         else do:
             find first antecip_pef_pend no-lock
                 where antecip_pef_pend.cod_estab = aprop_ctbl_pend_ap.cod_estab
                 and   antecip_pef_pend.cod_refer = aprop_ctbl_pend_ap.cod_refer no-error.
             if avail antecip_pef_pend then do:
                 create tt_orig_aprop_ctbl_pend_ap.
                 assign tt_orig_aprop_ctbl_pend_ap.ttv_rec_orig_movto_empenh = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                        tt_orig_aprop_ctbl_pend_ap.tta_cod_estab             = antecip_pef_pend.cod_estab
                        tt_orig_aprop_ctbl_pend_ap.tta_cod_refer             = antecip_pef_pend.cod_refer
                        tt_orig_movto_empenh_aux.ttv_rec_id                  = recid(antecip_pef_pend)
                        tt_orig_movto_empenh_aux.tta_des_contdo_movto        = "Estab:" /*l_estab:*/  + ' ' + tt_orig_aprop_ctbl_pend_ap.tta_cod_estab + '  ' +
                                                                               "Refer:" /*l_refer:*/  + ' ' + tt_orig_aprop_ctbl_pend_ap.tta_cod_refer.         
             end.
         end.
    end.

END.

PROCEDURE pi_busca_orig_aprop_ctbl_ap:

    find aprop_ctbl_ap no-lock
        where aprop_ctbl_ap.cod_estab            = string(entry(1, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10)))
        and   aprop_ctbl_ap.num_id_aprop_ctbl_ap = int(entry(2, tt_orig_movto_empenh_aux.tta_des_contdo_movto, chr(10))) no-error.
    if avail aprop_ctbl_ap then do:
        find movto_tit_ap no-lock
            where movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
            and   movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap no-error.
        if avail movto_tit_ap then do:
            find tit_ap no-lock
                where tit_ap.cod_estab     = movto_tit_ap.cod_estab
                and   tit_ap.num_id_tit_ap = movto_tit_ap.num_id_tit_ap no-error.
            if avail tit_ap then do:
                create tt_orig_aprop_ctbl_ap.
                assign tt_orig_aprop_ctbl_ap.ttv_rec_orig_movto_empenh = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                       tt_orig_aprop_ctbl_ap.tta_cod_estab             = tit_ap.cod_estab
                       tt_orig_aprop_ctbl_ap.tta_cdn_fornecedor        = tit_ap.cdn_fornecedor
                       tt_orig_aprop_ctbl_ap.tta_cod_espec_docto       = tit_ap.cod_espec_docto
                       tt_orig_aprop_ctbl_ap.tta_cod_ser_docto         = tit_ap.cod_ser_docto
                       tt_orig_aprop_ctbl_ap.tta_cod_tit_ap            = tit_ap.cod_tit_ap
                       tt_orig_aprop_ctbl_ap.tta_cod_parcela           = tit_ap.cod_parcela
                       tt_orig_aprop_ctbl_ap.tta_ind_trans_ap          = movto_tit_ap.ind_trans_ap
                       tt_orig_aprop_ctbl_ap.tta_cod_refer             = movto_tit_ap.cod_refer
                       tt_orig_aprop_ctbl_ap.tta_val_aprop_ctbl_ap     = aprop_ctbl_ap.val_aprop_ctbl
                       tt_orig_movto_empenh_aux.ttv_rec_id             = recid(tit_ap)
                       tt_orig_movto_empenh_aux.tta_des_contdo_movto   = "Estab:" /*l_estab:*/  + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_estab       + '  ' +
                                                                         "Fornec" /*l_fornec*/  + ': ' + string(tt_orig_aprop_ctbl_ap.tta_cdn_fornecedor) + '  ' +
                                                                         "Esp" /*l_esp*/     + ': ' + tt_orig_aprop_ctbl_ap.tta_cod_espec_docto + '  ' +
                                                                         "S‚rie" /*l_serie*/   + ': ' + tt_orig_aprop_ctbl_ap.tta_cod_ser_docto   + '  ' +
                                                                         "T¡t:" /*l_tit:*/    + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_tit_ap      + '  ' +
                                                                         "Parc" /*l_parc*/    + ': ' + tt_orig_aprop_ctbl_ap.tta_cod_parcela     + '  ' +
                                                                         "Trans" /*l_trans*/   + ': ' + tt_orig_aprop_ctbl_ap.tta_ind_trans_ap    + '  ' +
                                                                         "Refer:" /*l_refer:*/  + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_refer.                   
            end.
            else do:
                create tt_orig_aprop_ctbl_ap.
                assign tt_orig_aprop_ctbl_ap.ttv_rec_orig_movto_empenh = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                       tt_orig_aprop_ctbl_ap.tta_cod_tit_ap            = "PEF" /*l_pef*/ 
                       tt_orig_aprop_ctbl_ap.tta_ind_trans_ap          = movto_tit_ap.ind_trans_ap
                       tt_orig_aprop_ctbl_ap.tta_val_aprop_ctbl_ap     = aprop_ctbl_ap.val_aprop_ctbl
                       tt_orig_movto_empenh_aux.ttv_rec_id             = recid(movto_tit_ap)
                       tt_orig_aprop_ctbl_ap.tta_cod_estab             = movto_tit_ap.cod_estab
                       tt_orig_aprop_ctbl_ap.tta_cod_refer             = movto_tit_ap.cod_refer
                       tt_orig_movto_empenh_aux.tta_des_contdo_movto   = "Estab:" /*l_estab:*/  + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_estab       + '  ' +
                                                                         "T¡t:" /*l_tit:*/    + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_tit_ap      + '  ' +
                                                                         "Trans" /*l_trans*/   + ': ' + tt_orig_aprop_ctbl_ap.tta_ind_trans_ap    + '  ' +
                                                                         "Refer:" /*l_refer:*/  + ' '  + tt_orig_aprop_ctbl_ap.tta_cod_refer.                   
            end.                   
        end.
    end.
END.

PROCEDURE pi_busca_orig_prestac_cta:

    DEF VAR v_num_id_proces_prestac_cta AS INT  no-undo.

    case tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh:
        when 3 or        /* Adiantamento de Viagem  - N’o estÿ sendo mais utilizado */ 
        when 21 or       /* Adiantamento */
        when 22 then do: /* Acerto de Contas */
            /* Neste caso o campo conterÿ somente o Num_id do Processo  */
            assign v_num_id_proces_prestac_cta = int( tt_orig_movto_empenh_aux.tta_des_contdo_movto).    
        end.
        when 23  or       /* Despesa de Hospedagem */
        when 24  then do: /* Despesa de Passagem   */
            /* Neste caso o campo conterÿ Num_id do Processo + H (Hospedagem)  ou P (Passagem)*/
            assign v_num_id_proces_prestac_cta = int(substring(tt_orig_movto_empenh_aux.tta_des_contdo_movto, 1, length(tt_orig_movto_empenh_aux.tta_des_contdo_movto) - 1)).    
        end.
        when 25  then do: /* Outras Despesas Faturaveis */
            /* Neste caso o campo conterÿ Num_id do Processo + DF( Despesas Faturaveis) */
            assign v_num_id_proces_prestac_cta = int(substring(tt_orig_movto_empenh_aux.tta_des_contdo_movto, 1, length(tt_orig_movto_empenh_aux.tta_des_contdo_movto) - 2)).    
        end.
    end case.

    if  tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 3
    or  tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh = 21 then do:
        find first adiant_prestac_cta_eec no-lock
            where adiant_prestac_cta_eec.num_id_adiant_eec = v_num_id_proces_prestac_cta no-error.
        if  avail adiant_prestac_cta_eec then do:
            find proces_prestac_cta_eec no-lock
                 where proces_prestac_cta_eec.num_id_proces_prestac = adiant_prestac_cta_eec.num_id_proces_prestac no-error.
            if  avail proces_prestac_cta_eec then do:
                create tt_orig_proces_prestac_cta.
                assign tt_orig_proces_prestac_cta.ttv_rec_orig_movto_empenh     = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                       tt_orig_proces_prestac_cta.tta_cdn_func_financ           = proces_prestac_cta_eec.cdn_func_financ
                       tt_orig_proces_prestac_cta.tta_cdn_prestac_cta           = proces_prestac_cta_eec.cdn_prestac_cta
                       tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec = proces_prestac_cta_eec.dat_abert_prestac_cta_eec
                       tt_orig_proces_prestac_cta.tta_ind_sit_proces            = proces_prestac_cta_eec.ind_sit_proces
                       tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces  = proces_prestac_cta_eec.cod_usuar_aprvdor_proces
                       tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec        = proces_prestac_cta_eec.cod_tip_proces_eec.
                assign tt_orig_movto_empenh_aux.ttv_rec_id           = recid(proces_prestac_cta_eec)
                       tt_orig_movto_empenh_aux.tta_des_contdo_movto = "Func:" /*l_func:*/          + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_func_financ)           + '  ' +
                                                                       "Processo:" /*l_processo_eec*/   + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_prestac_cta)           + '  ' +
                                                                       'Parcela:'          + ' ' + string(adiant_prestac_cta_eec.cod_parcela)                       + '  ' +
                                                                       "Data Abertura:" /*l_data_abertura*/  + ' ' + string(tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec) + '  ' +
                                                                       "Situa‡Æo:" /*l_situacao:*/      + ' ' + tt_orig_proces_prestac_cta.tta_ind_sit_proces                    + '  ' +
                                                                       "Aprovador:" /*l_aprovador:*/     + ' ' + tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces          + '  ' +
                                                                       "Tipo:" /*l_tipo:*/          + ' ' + tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec.
            end.
        end.
        else do:
            find proces_prestac_cta_eec no-lock
                where proces_prestac_cta_eec.num_id_proces_prestac = v_num_id_proces_prestac_cta no-error.
            if  avail proces_prestac_cta_eec then do:
                create tt_orig_proces_prestac_cta.
                assign tt_orig_proces_prestac_cta.ttv_rec_orig_movto_empenh     = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                       tt_orig_proces_prestac_cta.tta_cdn_func_financ           = proces_prestac_cta_eec.cdn_func_financ
                       tt_orig_proces_prestac_cta.tta_cdn_prestac_cta           = proces_prestac_cta_eec.cdn_prestac_cta
                       tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec = proces_prestac_cta_eec.dat_abert_prestac_cta_eec
                       tt_orig_proces_prestac_cta.tta_ind_sit_proces            = proces_prestac_cta_eec.ind_sit_proces
                       tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces  = proces_prestac_cta_eec.cod_usuar_aprvdor_proces
                       tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec        = proces_prestac_cta_eec.cod_tip_proces_eec.
                assign tt_orig_movto_empenh_aux.ttv_rec_id           = recid(proces_prestac_cta_eec)
                       tt_orig_movto_empenh_aux.tta_des_contdo_movto = "Func:" /*l_func:*/          + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_func_financ)           + '  ' +
                                                                       "Processo:" /*l_processo_eec*/   + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_prestac_cta)           + '  ' +
                                                                       "Data Abertura:" /*l_data_abertura*/  + ' ' + string(tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec) + '  ' +
                                                                       "Situa‡Æo:" /*l_situacao:*/      + ' ' + tt_orig_proces_prestac_cta.tta_ind_sit_proces                    + '  ' +
                                                                       "Aprovador:" /*l_aprovador:*/     + ' ' + tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces          + '  ' +
                                                                       "Tipo:" /*l_tipo:*/          + ' ' + tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec.
            end.
        end.
    end.
    else do:
        find proces_prestac_cta_eec no-lock
            where proces_prestac_cta_eec.num_id_proces_prestac = v_num_id_proces_prestac_cta no-error.

        if  avail proces_prestac_cta_eec then do:
            create tt_orig_proces_prestac_cta.
            assign tt_orig_proces_prestac_cta.ttv_rec_orig_movto_empenh     = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
                   tt_orig_proces_prestac_cta.tta_cdn_func_financ           = proces_prestac_cta_eec.cdn_func_financ
                   tt_orig_proces_prestac_cta.tta_cdn_prestac_cta           = proces_prestac_cta_eec.cdn_prestac_cta
                   tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec = proces_prestac_cta_eec.dat_abert_prestac_cta_eec
                   tt_orig_proces_prestac_cta.tta_ind_sit_proces            = proces_prestac_cta_eec.ind_sit_proces
                   tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces  = proces_prestac_cta_eec.cod_usuar_aprvdor_proces
                   tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec        = proces_prestac_cta_eec.cod_tip_proces_eec.
            assign tt_orig_movto_empenh_aux.ttv_rec_id           = recid(proces_prestac_cta_eec)
                   tt_orig_movto_empenh_aux.tta_des_contdo_movto = "Func:" /*l_func:*/          + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_func_financ)           + '  ' +
                                                                   "Processo:" /*l_processo_eec*/   + ' ' + string(tt_orig_proces_prestac_cta.tta_cdn_prestac_cta)           + '  ' +
                                                                   "Data Abertura:" /*l_data_abertura*/  + ' ' + string(tt_orig_proces_prestac_cta.tta_dat_abert_prestac_cta_eec) + '  ' +
                                                                   "Situa‡Æo:" /*l_situacao:*/      + ' ' + tt_orig_proces_prestac_cta.tta_ind_sit_proces                    + '  ' +
                                                                   "Aprovador:" /*l_aprovador:*/     + ' ' + tt_orig_proces_prestac_cta.tta_cod_usuar_aprvdor_proces          + '  ' +
                                                                   "Tipo:" /*l_tipo:*/          + ' ' + tt_orig_proces_prestac_cta.tta_cod_tip_proces_eec.
        end.
    end.

END.

PROCEDURE pi_lista_origem:

    ASSIGN v_des_lista_orig = "T¡tulo AP Pendente 5.0"        + "," +
                              "T¡tulo AP 5.0"                 + "," +
                              "Adiantamento de Viagem"        + "," +
                              "T¡tulo AP Pendente 2.0"        + "," +
                              "T¡tulo AP 2.0"                 + "," +
                              "Atendimento Requisi‡Æo"        + "," +
                              "Requisi‡Æo/Solicita‡Æo Compra" + "," +
                              "Transa‡äes Diversas"           + "," +
                              "Pedido"                        + "," +
                              "C.Compra sem Matriz"           + "," +
                              "C.Compra com Matriz"           + "," +
                              "C.Compra por Medi‡Æo"          + "," +
                              "Entrada NF"                    + "," +
                              "Devolu‡Æo NF"                  + "," +
                              "Requisi‡Æo OM"                 + "," +
                              "Investimento"                  + "," +
                              "Contabiliza‡Æo Estoque"        + "," +
                              "Aprova‡Æo Cota‡Æo"             + "," +
                              "NF Transferˆncia"              + "," +
                              "Requis/Devol Mater"            + "," + 
                              "Adiantamento"                  + "," +
                              "Acerto de Contas"              + "," +
                              "Hospedagem"                    + "," +
                              "Passagem" .

    ASSIGN v_des_lista_orig = v_des_lista_orig + ",".

    &IF DEFINED (BF_FIN_INTEGR_FGL_BGC) &THEN
        assign v_des_lista_orig = v_des_lista_orig     + "," + 
                                               "Lan‡amento Ctbl 5.0".
        assign v_des_lista_orig = v_des_lista_orig + ",,,,,," + "Movto Conta Corrente 2.0".
    &ELSE
        assign v_des_lista_orig = v_des_lista_orig + ",,,,,,," + "Movto Conta Corrente 2.0".
    &ENDIF

    assign v_des_lista_orig = v_des_lista_orig   + "," + 
                                         "Req./Devol. Material MI"         + "," +
                                         "Atend. Req./Solic. Material MI"  + "," +
                                         "Req./Solic. Material MI"         + "," +
                                         "MÆo de Obra MI"                  + "," +
                                         "Gastos Gerais Fabrica‡Æo MI".
    &IF DEFINED (BF_FIN_INTEGR_CMG_BGC) &THEN
        assign v_des_lista_orig = v_des_lista_orig + "," + "Movto Conta Corrente 5.0".
    &ENDIF

END.

PROCEDURE pi_consulta_movto_orig:

    DEF VAR v_log_epc AS LOG NO-UNDO.

    case tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh:
        when 1 /* T¡tulo APB Pendente */ then do:
            if can-find(first lote_impl_tit_ap no-lock
                        where recid(lote_impl_tit_ap) = tt_orig_movto_empenh_aux.ttv_rec_id) then do:
                assign v_rec_lote_impl_tit_ap = tt_orig_movto_empenh_aux.ttv_rec_id.
                if  search("prgfin/apb/apb704aa.r") = ? and search("prgfin/apb/apb704aa.p") = ? then do:
                     message "Programa execut vel nÆo foi encontrado:"  " prgfin/apb/apb704aa.p"
                             view-as alert-box error buttons ok.
                     return.
                end.
                else
                    run prgfin/apb/apb704aa.p.
            end.
            else do:
                assign v_log_epc = yes.

                if  v_log_epc and
                    can-find(first antecip_pef_pend no-lock
                             where recid(antecip_pef_pend) = tt_orig_movto_empenh_aux.ttv_rec_id) then do:
                    assign v_rec_antecip_pef_pend = tt_orig_movto_empenh_aux.ttv_rec_id.
                    if  search("prgfin/apb/apb702ia.r") = ? and search("prgfin/apb/apb702ia.p") = ? then do:
                         message "Programa execut vel nÆo foi encontrado:" " prgfin/apb/apb702ia.p"
                                 view-as alert-box error buttons ok.
                         return.
                    end.
                    else
                        run prgfin/apb/apb702ia.p.
                end.    
            end.    
        end.

        when 2 /* T¡tulo APB */ then do:
            if can-find(first tit_ap no-lock
                        where recid(tit_ap) = tt_orig_movto_empenh_aux.ttv_rec_id) then do:
                assign v_rec_tit_ap = tt_orig_movto_empenh_aux.ttv_rec_id.
                if search("prgfin/apb/apb222aa.r") = ? and search("prgfin/apb/apb222aa.p") = ? then do:
                    message "Programa execut vel nÆo foi encontrado:" " prgfin/apb/apb222aa.p"
                            view-as alert-box error buttons ok.
                    return.
                end.
                else
                    run prgfin/apb/apb222aa.p.
            end.
            else if can-find(first movto_tit_ap no-lock
                        where recid(movto_tit_ap) = tt_orig_movto_empenh_aux.ttv_rec_id) then do:
                    assign v_rec_movto_tit_ap = tt_orig_movto_empenh_aux.ttv_rec_id.
                    if search("prgfin/apb/apb227ia.r") = ? and search("prgfin/apb/apb227ia.p") = ? then do:
                        message "Programa execut vel nÆo foi encontrado:" " prgfin/apb/apb227ia.p"
                                 view-as alert-box error buttons ok.
                        return.
                    end.
                    else
                        run prgfin/apb/apb227ia.p.
            end.
        end.

        when 4 /* T¡tulo AP Pendente */ then do:
            if  tt_orig_movto_empenh_aux.tta_des_contdo_movto BEGINS "PEF"
            then do:
                assign gr-mov-pef-pend = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run app/ap0508.w.
            END.
            else do:
                assign gr-doc-i-ap = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run app/ap0501.w.
            end.
        end.

        when 5 /* T¡tulo AP */ then do:
            if  tt_orig_movto_empenh_aux.tta_des_contdo_movto BEGINS "PEF"
            then do:
                assign rw-mov-ap = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run app/ap0808.w.
            end /* if */.
            else do:
                assign rw-tit = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run app/ap0804f.w.
            end /* else */.     
        end.

        when 6 /* Atendimento de Requisi‡Æo */      or
        when 8 /* Transa‡äes Diversas */            or
        when 20 /* Requisi‡Æo de Materiais */       or
        when 13 /* Entrada NF */                    or
        when 14 /* Devolu‡Æo NF */                  or 
        when 33 /* Req./Devol. Material MI */       or 
        when 34 /* Atend.Req./Solic. Material MI */ then do:
            assign gr-movto-estoq = tt_orig_movto_empenh_aux.ttv_row_id_movto.
            run cdp/cd0710.w.
        end.

        when 7 /* Requisi‡Æo/Solicita‡Æo de Compras */ then do:
            assign gr-requisicao = tt_orig_movto_empenh_aux.ttv_row_id_movto.
            run cdp/cd1420.w.
        end.

        when 18 /* Aprova‡Æo Cota‡Æo */ then do:
            assign gr-ordem-compra = tt_orig_movto_empenh_aux.ttv_row_id_movto.
            run ccp/cc0511.w.
        end.

        when 3  or
        when 21 or
        when 22 or
        when 23 or
        when 24 or 
        when 25 then do:
            assign v_rec_proces_prestac_cta_eec = tt_orig_movto_empenh_aux.ttv_rec_id.
            if search("prgfin/eec/eec215aa.r") = ? and search("prgfin/eec/eec215aa.p") = ? then do:
                message "Programa execut vel nÆo foi encontrado:" " prgfin/eec/eec215aa.p"
                        view-as alert-box error buttons ok.
                return.
            end.
            else
                run prgfin/eec/eec215aa.p.
        end.

        &IF DEFINED (BF_FIN_INTEGR_FGL_BGC) &THEN
        when 26 then do:
            FIND FIRST ITEM_lancto_ctbl NO-LOCK
                WHERE recid(item_lancto_ctbl) = tt_orig_movto_empenh_aux.ttv_rec_id NO-ERROR.
            IF AVAIL ITEM_lancto_ctbl THEN DO:
                FIND FIRST lancto_ctbl NO-LOCK
                    WHERE lancto_ctbl.num_lote_ctbl   = item_lancto_ctbl.num_lote_ctbl  
                      AND lancto_ctbl.num_lancto_ctbl = item_lancto_ctbl.num_lancto_ctbl NO-ERROR.
                IF AVAIL lancto_ctbl THEN
                    ASSIGN v_rec_lancto_ctbl = RECID(lancto_ctbl).
                ELSE
                    ASSIGN v_rec_lancto_ctbl = ?.
            END.
        end.
        &ENDIF

        when 10 /* C. Compra sem Matriz */ or
        when 11 /* C. Compra com Matriz */ or
        when 12 /* C. Compra por Medi‡Æo */ then do:
            if search('cnp/cnapi561.r':U) = ? and search('cnp/cnapi561.p':U) = ? then do:
                message "Programa execut vel nÆo foi encontrado:" + ' cnp/cnapi561.p'
                        view-as alert-box error buttons ok.
                return.
            end.
            else
                run cnp/cnapi561.p (input tt_orig_movto_empenh_aux.tta_num_orig_movto_empenh,
                                    input tt_orig_movto_empenh_aux.ttv_row_id_movto,
                                    input tt_orig_movto_empenh_aux.tta_des_contdo_movto).
        end.

        when 32 /* Movto Conta Corrente 2.0 */ then do:
            assign gr-movto-banco = tt_orig_movto_empenh_aux.ttv_row_id_movto.
            find tt_orig_mcb
               where tt_orig_mcb.ttv_rec_orig_movto_empenh = tt_orig_movto_empenh_aux.ttv_rec_orig_movto_empenh
               no-lock no-error.
            if avail tt_orig_mcb then do:
                if tt_orig_mcb.ttv_num_bco_ems2 = 0 then
                    run cbp/cb1292a.w.  /* nÆo banc rio*/
                else
                    run cbp/cb0403b.w.  /* banc rio*/
            end.
        end.
        /*
        when 35 /* Req./Solic. Material MI*/ then do:
            if v_log_integr_mi then do:        
                assign gr-requisicao = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run cdp/cd1420.w.
            end.    
        end.
        when 36 /* MOB MI */ then do:
            if v_log_integr_mi then do:        
                assign v_row_movto_dir = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run csp/cs0603.w (input v_row_movto_dir,
                                  output v_log_ok).
            end.    
        end.
        when 37 /* GGF MI */ then do:
            if v_log_integr_mi then do:        
                assign v_row_movto_ggf = tt_orig_movto_empenh_aux.ttv_row_id_movto.
                run csp/cs0604.w (input v_row_movto_ggf,
                                  output v_log_ok).
            end.    
        end.    
        */
        WHEN 38 /* Movto Cta Corrente 5.0 */ then do:
            ASSIGN v_rec_movto_cta_corren = tt_orig_movto_empenh_aux.ttv_rec_id.
                RUN prgfin/cmg/cmg205aa.p.
        END.    
    END.

END.

PROCEDURE pi_email:

    def rectangle rt_key
        size 70 by 3.60
        edge-pixels 2.
    def rectangle rt_cxft 
        size 70 by 1.50 
        edge-pixels 2.
    def rectangle rt_cxft_1
        size 40 by 1.50 
        edge-pixels 2.
    
    def button bt_ok
        label "&Envia"
        tooltip "Envia e-mail"
        size 10 by 1
        auto-go.
    
    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.

    def button bt_zoo_para
        label "Zoom" tooltip "Zoom"
        image-up file "image/im-zoo"
        image-insensitive file "image/ii-zoo"
        size 4 by .88.
    def button bt_zoo_copia
        label "Zoom" tooltip "Zoom"
        image-up file "image/im-zoo"
        image-insensitive file "image/ii-zoo"
        size 4 by .88.

    DEF VAR v_wgh_foc                 AS  WIDGET-HANDLE NO-UNDO.
    DEF VAR v_log_sav                 AS LOG NO-UNDO.

    def frame f_email
        rt_key
            at row 01.63 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
        v_des_para
            at row 01.91 col 06.00 COLON-ALIGNED LABEL "Para"
            view-as fill-in
            size-chars 60.14 by .88
            fgcolor ? bgcolor 15 font 2
        bt_zoo_para
            at row 01.91 col 66.30 colon-aligned
        v_des_copia
            at row 02.91 COL 06.00 COLON-ALIGNED LABEL "Cc"
            view-as EDITOR 
            size-chars 60.14 by 2
            fgcolor ? bgcolor 15 font 2
        bt_zoo_copia
            at row 02.91 col 66.30 COLON-ALIGNED
        rt_cxft
            at row 05.50 col 1.00 colon-aligned 
            fgcolor ? BGCOLOR 18
        bt_ok   at row 05.73 col 04.00 bgcolor 8 help "Envia" 
        bt_can  at row 05.73 col 14.40 bgcolor 8 help "Cancela"     
        with 1 down side-labels no-validate keep-tab-order three-d 
             size-char 75.00 by 07.50 
             at row 01.13 col 01.00 
             font 1 fgcolor ? bgcolor 17 
             VIEW-AS DIALOG-BOX 
             title "Envia E-mail - 12.00.03.000".
    
    ON CHOOSE OF bt_zoo_para IN FRAME f_email 
    OR F5 OF v_des_para IN FRAME f_email DO:
        ASSIGN v_rec_usuar_mestre = ?
               INPUT FRAME f_email v_des_para.
        RUN sec/sec000ka.p.
        if v_rec_usuar_mestre <> ? then do:
            FIND usuar_mestre NO-LOCK
                WHERE RECID (usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
            IF v_des_para = "" THEN
                ASSIGN v_des_para:SCREEN-VALUE IN FRAME f_email = usuar_mestre.cod_e_mail_local.
            ELSE
                ASSIGN v_des_para:SCREEN-VALUE IN FRAME f_email = v_des_para + ";" + TRIM (usuar_mestre.cod_e_mail_local).
            APPLY "entry" to v_des_para in frame f_email.
        end.
    end.

    ON CHOOSE OF bt_zoo_copia IN FRAME f_email 
    OR F5 OF v_des_copia IN FRAME f_email DO:
        ASSIGN v_rec_usuar_mestre = ?
               INPUT FRAME f_email v_des_copia.
        RUN sec/sec000ka.
        if v_rec_usuar_mestre <> ? then do:
            FIND usuar_mestre NO-LOCK
                WHERE RECID (usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
            IF v_des_copia = "" THEN
                ASSIGN v_des_copia:SCREEN-VALUE IN FRAME f_email = usuar_mestre.cod_e_mail_local.
            ELSE
                ASSIGN v_des_copia:SCREEN-VALUE IN FRAME f_email = v_des_copia + ";" + TRIM (usuar_mestre.cod_e_mail_local).
            APPLY "entry" to v_des_copia in frame f_email.
        end.
    end.

    ASSIGN v_wgh_foc  = v_des_para:handle in frame f_email
           v_des_para = ""
           v_log_sav  = YES.

    main_block:
    REPEAT WHILE v_log_sav = yes on endkey undo main_block, leave main_block
       ON ERROR UNDO main_block, retry main_block with frame f_email:
       ASSIGN v_log_sav   = NO.
       ENABLE ALL
              WITH FRAME f_email.
       DISPLAY v_des_para
               v_des_copia
               WITH FRAME f_email.
       APPLY "entry" TO v_des_para IN FRAME f_email.
       IF VALID-HANDLE (v_wgh_foc) THEN DO:
          WAIT-FOR GO OF FRAME f_email FOCUS v_wgh_foc.
       END.
       ELSE DO:
          WAIT-FOR GO OF FRAME f_email.
       END.
       ASSIGN INPUT FRAME f_email v_des_para
              INPUT FRAME f_email v_des_copia.
       /*--- Valida E-mail ---*/
       /*RUN pi_vld_email.*/
       
    END.    
    
    HIDE FRAME f_email NO-PAUSE.

    RUN pi_envia_email (INPUT "Movimentos").

END.

PROCEDURE pi_envia_email:

    DEF INPUT PARAM p_ind_acao AS CHAR NO-UNDO.

    DEF VAR v_log_servid_exchange AS LOG  NO-UNDO.
    DEF VAR v_cod_servid_e_mail   AS CHAR NO-UNDO.
    DEF VAR v_num_porta           AS INT  NO-UNDO.


    DEF VAR v_num_seq_refer AS INT NO-UNDO.
    DEF VAR v_des_from     AS CHAR NO-UNDO.
    DEF VAR v_des_period   AS CHAR NO-UNDO.
    DEF VAR v_nom_subject  AS CHAR NO-UNDO.
    DEF VAR v_nom_message  AS CHAR NO-UNDO.
    DEF VAR v_num_mensagem AS INT NO-UNDO.
    DEF VAR v_ind_titulo   AS CHAR NO-UNDO.
            
    IF STRING (TIME, "HH:MM") < "12" THEN
        ASSIGN v_des_period = "Bom dia!".
    ELSE
        ASSIGN v_des_period = "Boa tarde!".

    FIND usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:
        ASSIGN v_des_from = usuar_mestre.cod_e_mail_local.
    END.

    CASE p_ind_acao:
        WHEN "Saldos" THEN DO:
            ASSIGN v_nom_subject = "Extrato Saldos Or‡ados X Realizados"
                   v_nom_message = '<HTML><BODY><font face="Times New Roman" size=3>' + '<h3><p><font color="black">' + v_des_period + '</font></p></h3>'
                                 + '<p5><p>Anexo o Extrato dos Saldos Or‡ados e Realizados.'
                                 + '<br>' 
                                 + '<p>Relat¢rio gerado atrav‚s da Consulta Espec¡fica: DABGC201.</p>'
                                 + '<p>Atenciosamente,</p>'
                                 + '<img src=http://imageshack.com/a/img903/7981/5noQ5b.jpg>'
                                 + '</BODY></HTML>'. 
        END.
        WHEN "Movimentos" THEN DO:
            ASSIGN v_nom_subject = "Extrato Movimentos Empenhados e Realizados"
                   v_nom_message = '<HTML><BODY><font face="Times New Roman" size=3>' + '<h3><p><font color="black">' + v_des_period + '</font></p></h3>'
                                 + '<p5><p>Anexo o Extrato dos Movimentos Empenhados e Realizados.'
                                 + '<br>' 
                                 + '<p>Relat¢rio gerado atrav‚s da Consulta Espec¡fica: DABGC201.</p>'
                                 + '<p>Atenciosamente,</p>'
                                 + '<img src=http://imageshack.com/a/img903/7981/5noQ5b.jpg>'
                                 + '</BODY></HTML>'. 
        END.
    END CASE.

    EMPTY TEMP-TABLE tt_mail_fax.
    EMPTY TEMP-TABLE tt_erros_mail_fax.

    &IF '{&emsfin_version}' < '5.07A' &THEN
    FIND FIRST param_geral_btb NO-LOCK  NO-ERROR.
    IF NOT AVAIL param_geral_btb THEN
        RETURN.
    ASSIGN v_log_servid_exchange = param_geral_btb.log_servid_exchange
           v_cod_servid_e_mail   = param_geral_btb.cod_ip_servid_mail
           v_num_porta           = param_geral_btb.num_porta_servid_mail.
    &ELSE
    FIND FIRST param_email NO-LOCK WHERE
               param_email.cod_servid_e_mail >= "" NO-ERROR.
    IF NOT AVAIL param_email THEN
        RETURN.
    ASSIGN v_log_servid_exchange = param_email.log_servid_exchange
           v_cod_servid_e_mail   = param_email.cod_servid_e_mail
           v_num_porta           = param_email.num_porta.
    &ENDIF

    CREATE tt_mail_fax.
    ASSIGN tt_mail_fax.ttv_log_exchange     = v_log_servid_exchange
           tt_mail_fax.ttv_nom_servid       = v_cod_servid_e_mail
           tt_mail_fax.ttv_num_porta_servid = v_num_porta
           tt_mail_fax.ttv_nom_from         = v_des_from
           tt_mail_fax.ttv_nom_to           = v_des_para
           tt_mail_fax.ttv_nom_cc           = v_des_copia
           tt_mail_fax.ttv_nom_subject      = v_nom_subject
           tt_mail_fax.ttv_nom_message      = v_nom_message
           tt_mail_fax.ttv_cod_format_mail  = "html"
           tt_mail_fax.ttv_nom_attachfile   = v_arq_email.

    run prgtec/btb/btb916za.p (input "1",
                               INPUT TABLE tt_mail_fax,
                               OUTPUT TABLE tt_erros_mail_fax).

    FOR EACH tt_erros_mail_fax NO-LOCK:       
        assign v_num_mensagem   = INT (tt_erros_mail_fax.ttv_cod_erro).
        create tt_log_erros_atualiz. 
        assign v_num_seq_refer = v_num_seq_refer + 1
               tt_log_erros_atualiz.tta_cod_estab       = "" 
               tt_log_erros_atualiz.tta_cod_refer       = tt_erros_mail_fax.ttv_cod_erro 
               tt_log_erros_atualiz.tta_num_seq_refer   = v_num_seq_refer 
               tt_log_erros_atualiz.ttv_ind_tip_relacto = "" 
               tt_log_erros_atualiz.ttv_num_relacto     = 0 
               tt_log_erros_atualiz.ttv_num_mensagem    = 0 
               tt_log_erros_atualiz.ttv_des_msg_erro    = tt_erros_mail_fax.ttv_des_erro
               tt_log_erros_atualiz.ttv_des_msg_ajuda   = tt_erros_mail_fax.ttv_des_erro.
    END.

END.

PROCEDURE pi_message :

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.
    
    DEF VAR c_prg_msg           as char    no-undo.
    
    assign c_prg_msg = "messages/"
                     + string(trunc(i_msg / 1000,0),"99")
                     + "/msg"
                     + string(i_msg, "99999").
    
    if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do:
        message "Mensagem nr. " i_msg "!!!" skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.
    
    run value(c_prg_msg + ".p") (input c_action, input c_param).
    return return-value.

END.

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes then do:
        delete procedure this-procedure.
    end.

END.

// Chamado 84058 - Cria‡Æo e utiliza‡Æo das duas fun‡äes abaixo, dentre outras altera‡äes
FUNCTION fn-narrativa RETURNS CHARACTER(p-des-contdo-movto AS CHAR):

    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.

    IF INDEX(p-des-contdo-movto, "Item:") = 0 THEN RETURN "".

    ASSIGN p-des-contdo-movto = SUBSTRING(p-des-contdo-movto, INDEX(p-des-contdo-movto, "Item:") + 5, LENGTH(p-des-contdo-movto)).
    ASSIGN p-des-contdo-movto = TRIM(p-des-contdo-movto).

    DO i-aux = 16 TO 1 BY -1:
        FIND FIRST ITEM NO-LOCK WHERE
                   ITEM.it-codigo = SUBSTRING(p-des-contdo-movto, 1, i-aux) AND
                   ITEM.it-codigo > ""                                      NO-ERROR.
        IF AVAIL ITEM THEN
            RETURN ITEM.narrativa.
    END.

    RETURN "".

END FUNCTION. // fn-narrativa

FUNCTION fn-tipo-movto RETURNS CHARACTER(pi-num_orig_movto_empenh AS INT, pr-orig_movto_empenh AS RECID):

    RELEASE ordem-compra NO-ERROR.

    CASE pi-num_orig_movto_empenh:
        WHEN 6  OR
        WHEN 8  OR
        WHEN 20 OR
        WHEN 13 OR
        WHEN 14 THEN DO:
            /*
            tt_orig_movto_estoq
            */
        END. // 6, 8, 20, 13 ou 14
        WHEN 7  OR
        WHEN 18 OR
        WHEN 10 OR
        WHEN 11 OR
        WHEN 12 THEN DO:
            FIND FIRST tt_orig_requisicao WHERE
                       tt_orig_requisicao.ttv_rec_orig_movto_empenh = pr-orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_requisicao THEN DO:
                /*FIND FIRST ordem-compra NO-LOCK WHERE
                           ordem-compra.numero-ordem = tt_orig_requisicao.ttv_num_ord_req NO-ERROR.*/
            END.

            FIND FIRST tt_orig_ordem_compra WHERE
                       tt_orig_ordem_compra.ttv_rec_orig_movto_empenh = pr-orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_ordem_compra THEN DO:
                FOR FIRST ordem-compra NO-LOCK WHERE
                          ordem-compra.numero-ordem = tt_orig_ordem_compra.ttv_num_ord_req,
                    EACH item-doc-est NO-LOCK WHERE
                         item-doc-est.num-pedido   = ordem-compra.num-pedido   AND
                         item-doc-est.numero-ordem = ordem-compra.numero-ordem AND
                         item-doc-est.parcela      = tt_orig_ordem_compra.ttv_num_parc_compra,
                    FIRST docum-est NO-LOCK WHERE
                          docum-est.serie-docto  = item-doc-est.serie-docto  AND
                          docum-est.nro-docto    = item-doc-est.nro-docto    AND
                          docum-est.cod-emitente = item-doc-est.cod-emitente AND
                          docum-est.nat-operacao = item-doc-est.nat-operacao AND
                          docum-est.ce-atual     = YES:

                    RETURN "Realizado".

                END. // FIRST ordem-compra, EACH item-doc-est, FIRST docum-est
            END.

            FIND FIRST tt_orig_contrat WHERE
                       tt_orig_contrat.ttv_rec_orig_movto_empenh = pr-orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_contrat THEN DO:
            END.

            FIND FIRST tt_orig_contrat_medicao WHERE
                       tt_orig_contrat_medicao.ttv_rec_orig_movto_empenh = pr-orig_movto_empenh NO-ERROR.
            IF AVAIL tt_orig_contrat_medicao THEN DO:
            END.
            
        END. // 7, 8, 10, 11 ou 12
        WHEN 4  OR
        WHEN 5  OR
        WHEN 32 THEN DO:
            /*
            tt_orig_lin_i_ap
            tt_orig_tit_ap
            tt_orig_mcb
            */
        END. // 4, 5 ou 32
    END CASE.

    RETURN "Empenhado".

END FUNCTION. // fn-tipo-movto
