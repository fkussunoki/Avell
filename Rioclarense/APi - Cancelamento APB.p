def temp-table tt_cancelamento_estorno_apb no-undo
    field ttv_ind_niv_operac_apb           as character format "X(10)"
    field ttv_ind_tip_operac_apb           as character format "X(12)"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_histor                   as character format "x(40)" label "Cont²m" column-label "Hist½rico"
    field ttv_ind_tip_estorn               as character format "X(10)"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol            as character format "x(8)"
    field ttv_log_reaber_item              as logical format "Sim/N’o" initial yes
    field ttv_log_reembol                  as logical format "Sim/N’o" initial yes
    field ttv_log_estorn_impto_retid       as logical format "Sim/N’o" initial yes
    .

def temp-table tt_cancelamento_estorno_apb_1 no-undo
    field ttv_ind_niv_operac_apb           as character format "X(10)"
    field ttv_ind_tip_operac_apb           as character format "X(12)"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_histor                   as character format "x(40)" label "Cont²m" column-label "Hist½rico"
    field ttv_ind_tip_estorn               as character format "X(10)"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol            as character format "x(8)"
    field ttv_log_reaber_item              as logical format "Sim/N’o" initial yes
    field ttv_log_reembol                  as logical format "Sim/N’o" initial yes
    field ttv_log_estorn_impto_retid       as logical format "Sim/N’o" initial yes
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    .

def temp-table tt_estornar_agrupados no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_estab_pagto              as character format "x(3)" label "Estab Pagto" column-label "Estab Pagto"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_pagto                    as date format "99/99/9999" initial today label "Data Pagamento" column-label "Data Pagto"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_movto_ap                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Movimento" column-label "Valor Movto"
    field tta_ind_modo_pagto               as character format "X(10)" label "Modo  Pagamento" column-label "Modo Pagto"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field ttv_num_seq_abrev                as integer format ">>>9" label "Sq" column-label "Seq"
    field tta_ind_trans_ap_abrev           as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field ttv_rec_compl_movto_pagto        as recid format ">>>>>>9"
    field ttv_rec_movto_tit_ap             as recid format ">>>>>>9"
    field ttv_rec_item_cheq_ap             as recid format ">>>>>>9"
    field ttv_rec_item_bord_ap             as recid format ">>>>>>9"
    field ttv_rec_item_lote_pagto          as recid format ">>>>>>9"
    index tt_ind_modo                     
          tta_ind_modo_pagto               ascending
    .

def temp-table tt_estorna_tit_imptos no-undo
    field ttv_cod_refer_imp                as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_estab_imp                as character format "x(3)" label "Estabelec. Impto." column-label "Estab. Imp."
    field ttv_cdn_fornecedor_imp           as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto_imp          as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto_imp            as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field ttv_cod_tit_ap_imp               as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field ttv_cod_parcela_imp              as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap_imp               as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap_imp           as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap_imp            as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_estab_2                  as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cdn_fornecedor               as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto                as character format "x(3)" label "S²rie Docto" column-label "S²rie"
    field ttv_cod_tit_ap                   as character format "x(10)" label "T­tulo Ap" column-label "T­tulo Ap"
    field ttv_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap                as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_ind_trans_ap_abrev           as character format "X(04)" label "Transa»’o" column-label "Transa»’o"
    field ttv_cod_refer_2                  as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_num_order                    as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_val_tot_comprtdo             as decimal format "->>>,>>>,>>9.99" decimals 2
    index tt_idimpto                      
          ttv_cod_estab_imp                ascending
          ttv_cdn_fornecedor_imp           ascending
          ttv_cod_espec_docto_imp          ascending
          ttv_cod_ser_docto_imp            ascending
          ttv_cod_tit_ap_imp               ascending
          ttv_cod_parcela_imp              ascending
    index tt_idimpto_pgef                 
          ttv_cod_estab                    ascending
          ttv_cod_refer                    ascending
    index tt_idtit_refer                  
          ttv_cod_estab_2                  ascending
          ttv_cdn_fornecedor               ascending
          ttv_cod_espec_docto              ascending
          ttv_cod_ser_docto                ascending
          ttv_cod_tit_ap                   ascending
          ttv_cod_parcela                  ascending
          ttv_cod_refer_2                  ascending
    index tt_numsg                        
          ttv_num_mensagem                 ascending
    index tt_order                        
          ttv_num_order                    ascending
    .

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .

def temp-table tt_log_erros_estorn_cancel_apb no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_mensagem                 as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    .

def temp-table tt_trad_org_ext no-undo like trad_org_ext
    .

DEF STREAM s1.
DEF STREAM s2.


DEFINE TEMP-TABLE tt-titulos
    FIELD ttv_cod_estabel                AS char
    FIELD ttv_cod_espec                  AS CHAR
    FIELD ttv_serie                      AS char
    FIELD ttv_cdn_fornecedor             AS INTEGER
    FIELD ttv_cod_tit_ap                 AS CHAR
    FIELD ttv_cod_parcela                AS CHAR.
DEF VAR v_hdl_api AS HANDLE.
DEF VAR v_cod_refer AS char.
DEF VAR h-prog AS HANDLE.
  run prgfin/apb/apb768ze.py persistent set v_hdl_api.

INPUT FROM c:/desenv/folha.txt.

             REPEAT:
                 CREATE tt-titulos.
                 IMPORT DELIMITER ";" tt-titulos.
             END.

             INPUT CLOSE.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "gerando").


OUTPUT STREAM s1 TO c:/desenv/atualiz.txt.
OUTPUT STREAM s2 TO c:/desenv/erros.txt.
 FOR EACH tt-titulos:


     EMPTY TEMP-TABLE tt_log_erros_atualiz.
     EMPTY TEMP-TABLE tt_log_erros_estorn_cancel_apb.
     EMPTY TEMP-TABLE tt_cancelamento_estorno_apb_1.
     

     run pi_referencia (Input "f",
                      Input today,
                      output v_cod_refer) .


 FIND FIRST tit_ap NO-LOCK WHERE tit_ap.cod_tit_ap = tt-titulos.ttv_cod_tit_ap
                          AND   tit_ap.cod_estab  =  tt-titulos.ttv_cod_Estabel
                          AND   tit_ap.cod_espec_docto = tt-titulos.ttv_cod_espec
                          AND   tit_ap.cdn_fornecedor = tt-titulos.ttv_cdn_fornecedor 
                          AND   tit_ap.cod_ser_docto  = tt-titulos.ttv_serie 
                          AND   tit_ap.cod_parcela    = tt-titulos.ttv_cod_parcela NO-ERROR.

 RUN pi-acompanhar IN h-prog (INPUT "Titulos " + tt-titulos.ttv_cod_tit_ap).
FIND LAST movto_tit_ap NO-LOCK WHERE movto_tit_ap.cod_empresa = tit_ap.cod_empresa
                                AND   movto_tit_ap.cod_estab   = tit_ap.cod_estab
                                AND   movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                NO-ERROR.

CREATE tt_cancelamento_estorno_apb_1.
ASSIGN tt_cancelamento_estorno_apb_1.ttv_ind_niv_operac_apb             = "T¡tulo"
       tt_cancelamento_estorno_apb_1.ttv_ind_tip_operac_apb             = "Estornar"
       tt_cancelamento_estorno_apb_1.tta_cod_estab                      = movto_tit_ap.cod_estab
       tt_cancelamento_estorno_apb_1.tta_num_id_tit_ap                  = movto_tit_ap.num_id_tit_ap
       tt_cancelamento_estorno_apb_1.tta_num_id_movto_tit_ap            = movto_tit_ap.num_id_movto_tit_ap
       tt_cancelamento_estorno_apb_1.tta_cod_refer                      = v_cod_refer
       tt_cancelamento_estorno_apb_1.tta_dat_transacao                  = movto_tit_ap.dat_transacao
       tt_cancelamento_estorno_apb_1.ttv_des_histor                     = "Estorno automatico"
       tt_cancelamento_estorno_apb_1.ttv_ind_tip_estorn                 = "Total" /* 1- parcial / 2 total */
       tt_cancelamento_estorno_apb_1.tta_cod_portador                   = movto_tit_ap.cod_portador
       tt_cancelamento_estorno_apb_1.ttv_log_reaber_item                = NO
       tt_cancelamento_estorno_apb_1.ttv_log_reembol                    = NO
       tt_cancelamento_estorno_apb_1.ttv_log_estorn_impto_retid         = NO
       tt_cancelamento_estorno_apb_1.ttv_rec_tit_ap                     = recid(tit_ap)
       tt_cancelamento_estorno_apb_1.tta_cdn_fornecedor                 = movto_tit_ap.cdn_fornecedor
       tt_cancelamento_estorno_apb_1.tta_cod_espec_docto                = movto_tit_ap.cod_espec_docto
       tt_cancelamento_estorno_apb_1.tta_cod_ser_docto                  = tit_ap.cod_ser_docto
       tt_cancelamento_estorno_apb_1.tta_cod_tit_ap                     = tit_ap.cod_tit_ap
       tt_cancelamento_estorno_apb_1.tta_cod_parcela                    = tit_ap.cod_parcela. 




  DEF VAR p_log_confir_estorn_cancel AS LOGICAL.








                            run pi_main_code_apb768ze    in v_hdl_api (input 1,
                                                                        input "APB",
                                                                        input "EMS2",
                                                                        input NO,
                                                                        input table tt_cancelamento_estorno_apb_1,
                                                                        input table tt_estornar_agrupados,
                                                                        output table tt_log_erros_atualiz,
                                                                        output table tt_log_erros_estorn_cancel_apb,
                                                                        output table tt_estorna_tit_imptos,
                                                                        output p_log_confir_estorn_cancel).

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

                            FIND FIRST tt_log_erros_estorn_cancel_apb NO-ERROR.

                            IF AVAIL tt_log_erros_estorn_cancel_apb THEN DO:

                                PUT STREAM s2 UNFORMATTED tt_log_erros_estorn_cancel_apb.tta_cod_estab          ";"  
                                                          tt_log_erros_estorn_cancel_apb.tta_cod_refer          ";"
                                                          tt_log_erros_estorn_cancel_apb.tta_num_mensagem       ";"
                                                          tt_log_erros_estorn_cancel_apb.ttv_des_msg_erro       ";"
                                                          tt_log_erros_estorn_cancel_apb.ttv_des_msg_ajuda      ";"
                                                          movto_tit_ap.cod_espec_docto                ";" 
                                                          tit_ap.cod_ser_docto                        ";" 
                                                          tit_ap.cod_tit_ap                           ";" 
                                                          tit_ap.cod_parcela                          ";" 
                                                          movto_tit_ap.dat_transacao      
                                                    SKIP.



                            END.



END.
RUN pi-finalizar IN h-prog.

delete procedure v_hdl_api.


OUTPUT TO c:\temp\atualiz.txt.
FOR EACH tt_log_erros_atualiz:

    EXPORT tt_log_erros_atualiz.

END.

OUTPUT CLOSE.

OUTPUT TO c:\temp\erros.txt.

FOR EACH tt_log_erros_estorn_cancel_apb:

    EXPORT tt_log_erros_estorn_cancel_apb.
END.

OUTPUT CLOSE.


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

