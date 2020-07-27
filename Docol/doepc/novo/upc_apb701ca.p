/*******************************************************************************
**  Cliente  : Docol
**  Sistema  : EMS - 5.06
**  Programa : upc_apb701ca
**  Objetivo : Empenho de adiantamentos de verbas cooperadas
**  Data     : 12/01/2020
**  Autor    : Flavio Kussunoki - Consultor / Desenvolvedor
**  Versao   : 1.00.000
*******************************************************************************/

DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID         NO-UNDO.

/*** Defini‡Æo de Vari veis Locais ***/
DEFINE VARIABLE wh-objeto          AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-frame           AS WIDGET-HANDLE NO-UNDO.

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


IF p-ind-event = "Assign"
AND p-cod-table = "antecip_pef_pend" THEN DO:

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST param_integr_ems NO-LOCK 
        WHERE param_integr_ems.ind_param_integr_ems = "PERÖODOS CONTµBEIS 2.00" NO-ERROR.

    FIND FIRST trad_org_ext NO-LOCK WHERE trad_org_ext.cod_unid_organ_ext = param-global.empresa-prin
                                    AND   trad_org_ext.cod_matriz_trad_org_ext = param_integr_ems.des_contdo_param_integr_ems NO-ERROR.

    FIND FIRST antecip_pef_pend NO-LOCK WHERE recid(antecip_pef_pend) = p-rec-table 
                                        AND   antecip_pef_pend.cod_espec_docto = "VC" NO-ERROR.

    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = antecip_pef_pend.cdn_fornecedor NO-ERROR.
        
    IF AVAIL antecip_pef_pend THEN DO:

        FIND FIRST cta_grp_fornec NO-LOCK WHERE cta_grp_fornec.cod_empresa      = trad_org_ext.cod_unid_organ
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
               tt_xml_input_1.tt_des_conteudo    = "Verifica"
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
               tt_xml_input_1.tt_des_conteudo   = STRING(antecip_pef_pend.dat_emis_docto)
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


        find first tt_log_erros no-lock no-error.
        if  avail tt_log_erros then do: 

                   RUN dop/MESSAGE.p (INPUT "Pedido Bloqueado!",
                                       INPUT "Motivo: " + tt_log_erros.ttv_des_ajuda).

                   RETURN 'nok'.

        END.


        ELSE DO:
        FIND FIRST tt_xml_input_1 WHERE tt_xml_input_1.tt_cod_label       = "Funcao" NO-ERROR.
        ASSIGN  tt_xml_input_1.tt_des_conteudo = "Atualiza".

        RUN prgfin/bgc/bgc700za.py (input 1,
                                    input table tt_xml_input_1,
                                    output table tt_log_erros) .  

        END.


    END.


END.

