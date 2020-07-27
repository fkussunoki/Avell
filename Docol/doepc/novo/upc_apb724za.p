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




IF  p-ind-event = "Atz Status Bord" THEN DO:
    
    FOR EACH tt-epc NO-LOCK WHERE tt-epc.cod-event = 'Atz Status Bord'
                            AND   tt-epc.cod-parameter = 'Recid bord_ap':

        FIND FIRST param-global NO-LOCK NO-ERROR.

        FOR EACH bord_ap NO-LOCK WHERE recid(bord_ap) = INT(tt-epc.val-parameter),
            EACH item_bord_ap NO-LOCK WHERE item_bord_ap.cod_empresa = bord_ap.cod_empresa
                                          AND   item_bord_ap.cod_estab_bord = bord_ap.cod_estab_bord
                                          AND   item_bord_ap.cod_portador   = bord_ap.cod_portador
                                          AND   item_bord_ap.num_bord_ap    = bord_ap.num_bord_ap
                                          :
            
    
                 FIND FIRST antecip_pef_pend NO-LOCK WHERE antecip_pef_pend.cod_empresa     = item_bord_ap.cod_empresa
                                                     AND   antecip_pef_pend.cod_estab       = item_bord_ap.cod_estab
                                                     AND   antecip_pef_pend.cod_espec_docto = item_bord_ap.cod_espec_docto
                                                     AND   antecip_pef_pend.cod_refer       = item_bord_ap.cod_refer_antecip_pef
                                                     AND   antecip_pef_pend.cod_ser_docto   = item_bord_ap.cod_ser_docto
                                                     AND   antecip_pef_pend.cdn_fornecedor  = item_bord_ap.cdn_fornecedor
                                                     AND   antecip_pef_pend.cod_tit_ap      = item_bord_ap.cod_tit_ap
                                                     AND   antecip_pef_pend.cod_parcela     = item_bord_ap.cod_parcela
                                           NO-ERROR.

                 IF antecip_pef_pend.cod_espec_docto = "VC" THEN DO:
                     
                 
                
                     FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = antecip_pef_pend.cdn_fornecedor NO-ERROR.

                     IF AVAIL antecip_pef_pend THEN DO:

                         FIND FIRST param-global NO-LOCK NO-ERROR.

                         FIND FIRST cta_grp_fornec NO-LOCK WHERE cta_grp_fornec.cod_empresa      = antecip_pef_pend.cod_empresa
                                                           AND   cta_grp_fornec.cod_espec_docto  = antecip_pef_pend.cod_espec_docto
                                                           AND   cta_grp_fornec.cod_grp_fornec   = string(emitente.cod-gr-forn) 
                                                           AND   cta_grp_fornec.ind_finalid_ctbl = "SALDO" 
                                                           AND   cta_grp_fornec.dat_fim_valid   >= TODAY NO-ERROR.

                         FIND FIRST aprop_ctbl_pend_ap NO-LOCK WHERE aprop_ctbl_pend_ap.cod_empresa = cta_grp_fornec.cod_empresa
                                                               AND   aprop_ctbl_pend_ap.cod_estab   = antecip_pef_pend.cod_estab
                                                               AND   aprop_ctbl_pend_ap.cod_refer   = antecip_pef_pend.cod_refer
                                                               NO-ERROR.
                     
         
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Fun‡Æo"
                                tt_xml_input_1.tt_des_conteudo    = "Estorna"
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Empresa"
                                tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Conta Cont bil"
                                tt_xml_input_1.tt_des_conteudo    = STRING(cta_grp_fornec.cod_cta_ctbl)
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                                tt_xml_input_1.tt_des_conteudo    = antecip_pef_pend.cod_estab
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                                tt_xml_input_1.tt_des_conteudo   = STRING(bord_ap.dat_transacao)
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                                tt_xml_input_1.tt_des_conteudo   = "0"
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                                tt_xml_input_1.tt_des_conteudo   = STRING(antecip_pef_pend.val_tit_ap)
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
                                tt_xml_input_1.tt_des_conteudo   = "Estab: " + antecip_pef_pend.cod_estab + " Esp: " + antecip_pef_pend.cod_espec_docto + " Serie: " + antecip_pef_pend.cod_ser_docto + " Titulo: " + antecip_pef_pend.cod_tit_ap + " Parcela: " + antecip_pef_pend.cod_parcela
                                                                   + " Fornec: " + string(antecip_pef_pend.cdn_fornecedor)
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                                tt_xml_input_1.tt_des_conteudo   = aprop_ctbl_pend_ap.cod_unid_negoc
                                tt_xml_input_1.tt_num_seq_1_xml  = 1
                                tt_xml_input_1.tt_num_seq_2_xml  = 0.
                 
                         create tt_xml_input_1.
                         assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                                tt_xml_input_1.tt_des_conteudo    = STRING(aprop_ctbl_pend_ap.cod_ccusto)
                                tt_xml_input_1.tt_num_seq_1_xml   = 1
                                tt_xml_input_1.tt_num_seq_2_xml   = 0.
                 
                         RUN prgfin/bgc/bgc700za.py (input 1,
                                                     input table tt_xml_input_1,
                                                     output table tt_log_erros) .  
                 
                 
                     END.
         
                 END.
         
             END.       
    END. 
END.


    
