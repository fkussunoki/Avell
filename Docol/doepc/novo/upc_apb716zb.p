{include/i-epc200.i apb760.py}
{cdp/cdcfgdis.i}

DEFINE INPUT        PARAMETER p-ind-event AS  CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

    def temp-table tt_xml_input_1 no-undo 
        field tt_cod_label      as char    format "x(20)" 
        field tt_des_conteudo   as char    format "x(40)" 
        field tt_num_seq_1_xml  as integer format ">>9"
        field tt_num_seq_2_xml  as integer format ">>9".

    def temp-table tt_log_erros no-undo
        field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
        field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
        field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
        field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".




IF  p-ind-event = "Fim Baixa do Titulo" THEN DO:
    
    FOR EACH tt-epc NO-LOCK WHERE tt-epc.cod-event = 'Fim Baixa do Titulo'
                            AND   tt-epc.cod-parameter = 'Parametros':

        FIND FIRST param-global NO-LOCK NO-ERROR.


        FIND FIRST tit_ap WHERE string(ROWID(tit_ap)) = entry(1, tt-epc.val-parameter, CHR(10)) NO-ERROR.

        FIND FIRST movto_tit_ap NO-LOCK WHERE movto_tit_ap.cod_estab = entry(2, tt-epc.val-parameter, CHR(10))
                                        AND   movto_tit_ap.cod_refer = entry(4, tt-epc.val-parameter, CHR(10))
                                        AND   movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap
                                        NO-ERROR.

        FIND FIRST aprop_ctbl_ap NO-LOCK WHERE aprop_ctbl_ap.cod_empresa = movto_tit_ap.cod_empresa
                                         AND   aprop_ctbl_ap.cod_estab   = movto_tit_ap.cod_estab
                                         AND   aprop_ctbl_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                                         AND   aprop_ctbl_ap.ind_tip_aprop_ctbl = "saldo"
                                         NO-ERROR.
                     
         
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Fun‡Æo"
                                tt_xml_input_1.tt_des_conteudo    = "Realiza"
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Empresa"
                                tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Conta Cont bil"
                                tt_xml_input_1.tt_des_conteudo    = STRING(aprop_ctbl_ap.cod_cta_ctbl)
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                                tt_xml_input_1.tt_des_conteudo    = movto_tit_ap.cod_estab
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                                tt_xml_input_1.tt_des_conteudo   = STRING(movto_tit_ap.dat_gerac_movto)
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                                tt_xml_input_1.tt_des_conteudo   = "0"
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                                tt_xml_input_1.tt_des_conteudo   = STRING(movto_tit_ap.val_movto_ap)
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                                tt_xml_input_1.tt_des_conteudo   = "1"
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                                tt_xml_input_1.tt_des_conteudo   = "92"
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                                tt_xml_input_1.tt_des_conteudo   = "Estab: " + tit_ap.cod_estab + " Esp: " + tit_ap.cod_espec_docto + " Serie: " + tit_ap.cod_ser_docto + " Titulo: " + tit_ap.cod_tit_ap + " Parcela: " + tit_ap.cod_parcela
                                                                   + " Fornec: " + string(tit_ap.cdn_fornecedor)
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                                tt_xml_input_1.tt_des_conteudo   = aprop_ctbl_ap.cod_unid_negoc
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                                tt_xml_input_1.tt_des_conteudo    = STRING(aprop_ctbl_ap.cod_ccusto)
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         RUN prgfin/bgc/bgc700za.py (input 1,
                                                     input table tt_xml_input_1,
                                                     output table tt_log_erros) .  
                 
                 
                     END.
         
         
END.


    
