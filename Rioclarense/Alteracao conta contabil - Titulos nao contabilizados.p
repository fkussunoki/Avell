def temp-table tt_tit_ap_alteracao_base_aux_3 no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usuÿrio Corrente" column-label "Usuÿrio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Data Transa»’o"
    field ttv_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data ‚ltimo Pagto" column-label "Data ‚ltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Vl Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/N’o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap½lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp²cie" column-label "Tipo Esp²cie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Altera»’o" label "Motivo Altera»’o" column-label "Motivo Altera»’o"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/N’o" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field tta_des_histor_padr              as character format "x(40)" label "Descri»’o" column-label "Descri»’o Hist½rico Padr’o"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situa»’o" column-label "Situa»’o"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T­tulo Banco Cobdor" column-label "T­tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field ttv_ind_tip_trans_1099_tt        as character format "X(50)" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/N’o" initial no
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field ttv_ind_tip_rat                  as character format "X(08)"
    field tta_num_id_tit_ap                as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_aprop_ctbl_ap         as integer format "9999999999" initial 0 label "Id Aprop Ctbl AP" column-label "Id Aprop Ctbl AP"
    index tt_aprpctba_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
          ttv_rec_tit_ap                   ascending
    .


def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda_1              as character format "x(170)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    .

def temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending.


DEFINE TEMP-TABLE tt-titulos
    FIELD ttv_cod_estabel                AS char
    FIELD ttv_cod_espec                  AS CHAR
    FIELD ttv_serie                      AS char
    FIELD ttv_cdn_fornecedor             AS INTEGER
    FIELD ttv_cod_tit_ap                 AS char
    field ttv_cod_parcela                as char.

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .



DEF VAR v_hdl_aux AS HANDLE.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.

DEF VAR i-counter AS INTEGER.
DEF VAR h-prog AS HANDLE.
DEF VAR v_cod_refer AS CHAR.
DEF STREAM s1.
DEF STREAM s2.
def stream s3.
def var i-data as integer.
def var c-data as char.

DEF BUFFER b_movto_tit_ap FOR movto_tit_ap.

ASSIGN i-counter = 10.



INPUT FROM c:/desenv/zerar1.txt.

             REPEAT:
                 CREATE tt-titulos.
                 IMPORT DELIMITER ";" tt-titulos.
             END.

             INPUT CLOSE.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

OUTPUT STREAM s1 TO c:/desenv/atualiz1.txt.
OUTPUT STREAM s2 TO c:/desenv/erros1.txt.
output stream s3 to c:/desenv/certo_ok1.txt.


RUN pi-inicializar IN h-prog(INPUT "Gerado").
 FOR EACH tt-titulos:
 
  assign i-data  = random(1,26).
 
 
 case i-data:
 
when 1 then assign c-data = "a".
when 2 then assign c-data = "b".

when 3 then assign c-data = "c".

when 4 then assign c-data = "d".

when 5 then assign c-data = "e".

when 6 then assign c-data = "f".

when 7 then assign c-data = "g".

when 8 then assign c-data = "h".

when 9 then assign c-data = "i".

when 10 then assign c-data = "j".
when 11 then assign c-data = "k".
when 12 then assign c-data = "l".

when 13 then assign c-data = "m".

when 14 then assign c-data = "n".

when 15 then assign c-data = "o".

when 16 then assign c-data = "p".

when 17 then assign c-data = "q".

when 18 then assign c-data = "r".

when 19 then assign c-data = "s".
when 20 then assign c-data = "t".

when 21 then assign c-data = "u".
when 22 then assign c-data = "v".

when 23 then assign c-data = "x".

when 24 then assign c-data = "y".

when 25 then assign c-data = "w".

when 26 then assign c-data = "z".

end case.

run prgfin/apb/apb767zf.py persistent set v_hdl_aux.


     EMPTY TEMP-TABLE tt_log_erros_atualiz.
     EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
     EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_3.
     empty TEMP-TABLE tt_tit_ap_alteracao_rateio.



    run pi_referencia (Input c-data,
                     Input today,
                     output v_cod_refer) .


FIND FIRST tit_ap NO-LOCK WHERE tit_ap.cod_tit_ap = tt-titulos.ttv_cod_tit_ap
                         AND   tit_ap.cod_estab  =  tt-titulos.ttv_cod_Estabel
                         AND   tit_ap.cod_espec_docto = tt-titulos.ttv_cod_espec
                         AND   tit_ap.cdn_fornecedor = tt-titulos.ttv_cdn_fornecedor 
                         AND   tit_ap.cod_ser_docto  = tt-titulos.ttv_serie 
                         and   tit_ap.cod_parcela    = tt-titulos.ttv_cod_parcela NO-ERROR.

IF AVAIL tit_ap THEN DO:
    


 RUN pi-acompanhar IN h-prog (INPUT "Titulos " + tt-titulos.ttv_cod_tit_ap).
FIND LAST movto_tit_ap NO-LOCK WHERE movto_tit_ap.cod_empresa = tit_ap.cod_empresa
                                AND   movto_tit_ap.cod_estab   = tit_ap.cod_estab
                                AND   movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                NO-ERROR.

FIND FIRST b_movto_tit_ap NO-LOCK WHERE b_movto_tit_ap.cod_empresa = tit_ap.cod_empresa
                                AND     b_movto_tit_ap.cod_estab   = tit_ap.cod_estab
                                AND     b_movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                AND     b_movto_tit_ap.ind_trans_ap_abrev = "IMPL"
                                NO-ERROR.

FIND FIRST emsbas.espec_docto NO-LOCK WHERE espec_docto.cod_espec_docto = movto_tit_ap.cod_espec_docto NO-ERROR.

FIND FIRST rat_movto_tit_ap NO-LOCK WHERE rat_movto_tit_ap.cod_estab = b_movto_tit_ap.cod_estab
                                    AND   rat_movto_tit_ap.num_id_movto_tit_ap = b_movto_tit_ap.num_id_movto_tit_ap
                                    NO-ERROR.

FIND FIRST aprop_ctbl_ap NO-LOCK WHERE aprop_ctbl_ap.cod_empresa = b_movto_tit_ap.cod_empresa
                                 AND   aprop_ctbl_ap.cod_estab   = b_movto_tit_ap.cod_estab
                                 AND   aprop_ctbl_ap.num_id_movto_tit_ap = b_movto_tit_ap.num_id_movto_tit_ap
                                 NO-ERROR.

CREATE tt_tit_ap_alteracao_base_aux_3.
ASSIGN tt_tit_ap_alteracao_base_aux_3.ttv_cod_usuar_corren                  = v_cod_usuar_corren
       tt_tit_ap_alteracao_base_aux_3.tta_cod_empresa                       = tit_ap.cod_empresa
       tt_tit_ap_alteracao_base_aux_3.tta_cod_estab                         = tit_ap.cod_estab
       tt_tit_ap_alteracao_base_aux_3.tta_num_id_tit_ap                     = tit_ap.num_id_tit_ap
       tt_tit_ap_alteracao_base_aux_3.ttv_rec_tit_ap                        = recid(tt_tit_ap_alteracao_base_aux_3)
       tt_tit_ap_alteracao_base_aux_3.tta_cdn_fornecedor                    = tit_ap.cdn_fornecedor
       tt_tit_ap_alteracao_base_aux_3.tta_cod_espec_docto                   = tit_ap.cod_espec_docto
       tt_tit_ap_alteracao_base_aux_3.tta_cod_ser_docto                     = tit_ap.cod_ser_docto
       tt_tit_ap_alteracao_base_aux_3.tta_cod_tit_ap                        = tit_ap.cod_tit_ap
       tt_tit_ap_alteracao_base_aux_3.tta_cod_parcela                       = tit_ap.cod_parcela
       tt_tit_ap_alteracao_base_aux_3.ttv_dat_transacao                     = movto_tit_ap.dat_transacao
       tt_tit_ap_alteracao_base_aux_3.ttv_cod_refer                         = v_cod_refer
       tt_tit_ap_alteracao_base_aux_3.tta_val_sdo_tit_ap                    = 0
       tt_tit_ap_alteracao_base_aux_3.tta_dat_emis_docto                    = tit_ap.dat_emis_docto
       tt_tit_ap_alteracao_base_aux_3.tta_dat_vencto_tit_ap                 = tit_ap.dat_vencto_tit_ap
       tt_tit_ap_alteracao_base_aux_3.tta_dat_prev_pagto                    = tit_ap.dat_prev_pagto
       tt_tit_ap_alteracao_base_aux_3.tta_dat_ult_pagto                     = tit_ap.dat_ult_pagto
       tt_tit_ap_alteracao_base_aux_3.tta_cod_portador                      = ""
       tt_tit_ap_alteracao_base_aux_3.ttv_cod_portador_mov                  = ""
       tt_tit_ap_alteracao_base_aux_3.tta_log_pagto_bloqdo                  = NO
       tt_tit_ap_alteracao_base_aux_3.tta_ind_tip_espec_docto               = espec_docto.ind_tip_espec_docto
       tt_tit_ap_alteracao_base_aux_3.tta_cod_indic_econ                    = "corrente"
       tt_tit_ap_alteracao_base_aux_3.tta_num_seq_refer                     = i-counter
       tt_tit_ap_alteracao_base_aux_3.ttv_ind_motiv_alter_val_tit_ap        = "Alteração"
       tt_tit_ap_alteracao_base_aux_3.tta_des_histor_padr                   = "Cadatro eletronico"
       tt_tit_ap_alteracao_base_aux_3.tta_ind_sit_tit_ap                    = "Liberado"
       tt_tit_ap_alteracao_base_aux_3.tta_cod_forma_pagto                   =  tit_ap.cod_forma_pagto
.

FIND FIRST tt_tit_ap_alteracao_base_aux_3 NO-ERROR.

CREATE tt_tit_ap_alteracao_rateio.
ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap                           = tt_tit_ap_alteracao_base_aux_3.ttv_rec_tit_ap 
       tt_tit_ap_alteracao_rateio.tta_cod_estab                            = tit_ap.cod_estab
       tt_tit_ap_alteracao_rateio.tta_cod_refer                            = v_cod_refer
       tt_tit_ap_alteracao_rateio.tta_num_seq_refer                        = i-counter
       tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ                 = ""
       tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl                   = "PADRAO"
       tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl                         = "91201008"
       tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc                       = ""
       tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat                          = "Valor"
       tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl                       = tit_ap.val_sdo_tit_ap
       tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap                        = tt_tit_ap_alteracao_base_aux_3.tta_num_id_tit_ap
       .






run pi_main_code_api_integr_ap_alter_tit_ap_6 in v_hdl_aux (Input 1,
                                               Input "APB",
                                               Input "EMS2",
                                               input NO,
                                               input-output table tt_tit_ap_alteracao_base_aux_3,
                                               input-output table tt_tit_ap_alteracao_rateio,
                                               input-output table tt_params_generic_api, 
                                               output table tt_log_erros_tit_ap_alteracao).

                            FIND FIRST tt_log_erros_atualiz NO-ERROR.

                            IF AVAIL tt_log_erros_atualiz THEN DO:
                                PUT STREAM s1 UNFORMATTED tt_log_erros_atualiz.tta_cod_estab          ";"          
                                                          tt_log_erros_atualiz.tta_cod_refer          ";"    
                                                          tt_log_erros_atualiz.tta_num_seq_refer      ";"    
                                                          tt_log_erros_atualiz.ttv_num_mensagem       ";"    
                                                          tt_log_erros_atualiz.ttv_des_msg_erro       ";"    
                                                          tt_log_erros_atualiz.ttv_des_msg_ajuda      ";"    
                                                          tt_log_erros_atualiz.ttv_ind_tip_relacto    ";"    
                                                          tt_log_erros_atualiz.ttv_num_relacto        ";"
                                                          movto_tit_ap.cod_espec_docto                ";"
                                                          tit_ap.cod_ser_docto                        ";"
                                                          tit_ap.cod_tit_ap                           ";"
                                                          tit_ap.cod_parcela                          ";"       
                                                          movto_tit_ap.dat_transacao
                                                SKIP.

                            END.

                            FIND FIRST tt_log_erros_tit_ap_alteracao NO-ERROR.

                            IF  AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
                            PUT STREAM s2 UNFORMATTED     tt_log_erros_tit_ap_alteracao.tta_cod_estab            ";"        
                                tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor       ";"     
                                tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto      ";"     
                                tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto        ";"     
                                tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap           ";"     
                                tt_log_erros_tit_ap_alteracao.tta_cod_parcela          ";"     
                                tt_log_erros_tit_ap_alteracao.tta_num_id_tit_ap        ";"     
                                tt_log_erros_tit_ap_alteracao.ttv_num_mensagem         ";"     
                                tt_log_erros_tit_ap_alteracao.ttv_cod_tip_msg_dwb      ";"     
                                tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro         ";"     
                                tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda_1         
                                    SKIP.




                            END.
                            
                            
                            FIND FIRST tt_log_erros_tit_ap_alteracao NO-ERROR.

                            IF not AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
                            PUT STREAM s3 UNFORMATTED     movto_tit_ap.cod_espec_docto                ";"
                                                          tit_ap.cod_ser_docto                        ";"
                                                          tit_ap.cod_tit_ap                           ";"
                                                          tit_ap.cod_parcela                          ";"       
                                                          movto_tit_ap.dat_transacao
        
                                    SKIP.




                            END.

                            

           END.
           delete procedure v_hdl_aux.
END.



/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
*****************************************************************************/
PROCEDURE pi_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE. /* pi_retorna_sugestao_referencia */


