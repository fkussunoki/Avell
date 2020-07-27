/***********************************************************************
**  Programa.: UPC-BODI135CANCEL.P
**  Autor...: STOUT / SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: UPC do programa de Cancelamento de Nota Fiscal
**            Tratamento necess rio aos pedidos lou‡a (Levum)
************************************************************************/
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

{include/i-epc200.i bodi135cancel}

{utp/ut-glob.i}
{include/i_dbvers.i}
{method/dbotterr.i}

DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc. 

    /* variaveis para realizacao de empenho  - FKIS 12/01/2020 */
    DEFINE VARIABLE h-cd9500    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE r-conta-ft  AS ROWID       NO-UNDO.
    DEFINE VARIABLE i-cod-canal AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cod_unid_negoc AS CHAR   NO-UNDO.
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



                         
/* Projeto Levum - SCM */
DEFINE NEW GLOBAL SHARED VARIABLE wgh-reabre-pedido-ft2200-upc   AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE h-dlevapi003 AS HANDLE      NO-UNDO.

IF p-ind-event = "onvalidatecancel" THEN DO: /* valida‡Æo ft2200 */
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "Table-Rowid":
    END.

    IF VALID-HANDLE(wgh-reabre-pedido-ft2200-upc) THEN
        ASSIGN wgh-reabre-pedido-ft2200-upc:SENSITIVE = NO.

    IF NOT AVAIL tt-epc THEN
        RETURN "OK".

    FOR FIRST nota-fiscal NO-LOCK
        WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter):
    END.

    IF NOT AVAIL nota-fiscal THEN
        RETURN "OK".

    FOR FIRST lev-param NO-LOCK
        WHERE lev-param.cod-estabel = nota-fiscal.cod-estabel:
    END.

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
          AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli:

        IF AVAIL lev-param
        AND LOOKUP(ped-venda.tp-pedido,lev-param.tp-pedido,",") > 0 THEN
            ASSIGN wgh-reabre-pedido-ft2200-upc:SENSITIVE = YES.
        ELSE
            ASSIGN wgh-reabre-pedido-ft2200-upc:CHECKED = NO.
    END.
END.
/* Fim Projeto Levum - SCM */


IF p-ind-event = "Fim_CancelaNotaFiscal" THEN DO:

    FOR EACH tt-epc
       WHERE tt-epc.cod-event     = "Fim_CancelaNotaFiscal"
         AND tt-epc.cod-parameter = "notafiscal-rowid":

         FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
         IF AVAIL nota-fiscal THEN DO:

             FIND sat-remessa-nota exclusive-lock
                 WHERE sat-remessa-nota.cod-estab   = nota-fiscal.cod-estabel
                 AND   sat-remessa-nota.serie       = nota-fiscal.serie
                 AND   sat-remessa-nota.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
             IF AVAIL sat-remessa-nota THEN DO:
                 FOR EACH it-nota-fisc no-lock
                    WHERE it-nota-fisc.cod-estab = nota-fiscal.cod-estabel
                     AND  it-nota-fisc.serie     = nota-fiscal.serie
                     AND  it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:

                     find sat-remessa-nota exclusive-lock
                         where sat-remessa-nota.cod-estab   = it-nota-fisc.cod-estab
                         and   sat-remessa-nota.serie       = it-nota-fisc.serie
                         and   sat-remessa-nota.nr-nota-fis = it-nota-fisc.nr-nota-fis
                         and   sat-remessa-nota.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                         and   sat-remessa-nota.it-codigo   = it-nota-fisc.it-codigo no-error.
                     if avail sat-remessa-nota then do:
                        DELETE sat-remessa-nota.
                     end.
                 END.
             END. /* if avail sat-remessa-nota ... */

            /*----- EXPORTACAO -----*/
            IF nota-fiscal.nr-proc-exp <> "" THEN DO:
                FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                               AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
              FOR EACH ex-tipo-desc-cli 
                 WHERE ex-tipo-desc-cli.cod-emitente  = nota-fiscal.cod-emit,
                  EACH ex-desc-proforma 
                 WHERE ex-desc-proforma.sequen-dig    = ex-tipo-desc-cli.sequen-dig
                   AND ex-desc-proforma.nr-pedcli     = nota-fiscal.nr-pedcli,
                  EACH ex-desc-fatura 
                 WHERE ex-desc-fatura.sequen-proforma = ex-desc-proforma.sequen-proforma
                   AND ex-desc-fatura.nr-proc-exp     = nota-fiscal.nr-proc-exp
                   AND ex-desc-fatura.nr-nota-fis     = nota-fiscal.nr-nota-fis:
                 ASSIGN ex-desc-proforma.vl-saldo-fatura = ex-desc-proforma.vl-saldo-fatura + ex-desc-fatura.valor 
                        ex-tipo-desc-cli.vl-saldo-fatura = ex-tipo-desc-cli.vl-saldo-fatura + ex-desc-fatura.valor.
                 DELETE ex-desc-fatura.
              END. /* ex-tipo-desc-cli ... */
            END.
            /*----- (fim) EXPORTACAO -----*/

         END.

         /*Cancelamento de empenho de verba cooperada - FKIS */
         IF AVAIL nota-fiscal THEN DO:
             IF NOT VALID-HANDLE(h-cd9500) THEN
                 RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

             FIND FIRST param-global NO-ERROR.
             EMPTY TEMP-TABLE tt_xml_input_1.

             FIND FIRST conta-ft NO-LOCK
                  WHERE conta-ft.cod-estabel = ped-venda.cod-estabel
                    AND conta-ft.nat-oper    = ped-venda.nat-oper
                    AND conta-ft.cod-canal   = i-cod-canal NO-ERROR.
             IF NOT AVAIL conta-ft THEN DO: //TRANSACTION
                 ASSIGN i-cod-canal = 0. /* Se nao zerar o canal de venda busca a conta errada no faturamento */
             END.

             FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

             FIND FIRST usuar_grp_usuar NO-LOCK WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-ERROR.

             FIND FIRST estabelecimento NO-LOCK WHERE estabelecimento.cod_estab = ped-venda.cod-estabel NO-ERROR.
             FOR EACH  unid-negoc-grp-usuar NO-LOCK
                 WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
                 EACH  unid-negoc-estab NO-LOCK
                 WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
                   AND unid-negoc-estab.cod-estabel     = estabelecimento.cod_estab
                   AND unid-negoc-estab.dat-inic-valid <= TODAY
                   AND unid-negoc-estab.dat-fim-valid  >= TODAY:

                 ASSIGN v_cod_unid_negoc = unid-negoc-estab.cod-unid-negoc.
             END.



             /* Busca dados de Conta e Centro de Custo */
             RUN pi-cd9500 IN h-cd9500(INPUT  ped-venda.cod-estabel,
                                       INPUT  emitente.cod-gr-cli,
                                       INPUT  ?,
                                       INPUT  ped-venda.nat-operacao,
                                       INPUT  ?,
                                       INPUT  "",
                                       INPUT  i-cod-canal,
                                       OUTPUT r-conta-ft).

             FOR FIRST conta-ft 
                 WHERE ROWID(conta-ft) = r-conta-ft no-lock:


                 IF conta-ft.ct-cusven = "435362" THEN DO:



                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label       = "Fun‡Æo"
                            tt_xml_input_1.tt_des_conteudo    = "Estorna Realiza‡Æo"
                            tt_xml_input_1.tt_num_seq_1_xml   = 1
                            tt_xml_input_1.tt_num_seq_2_xml   = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label       = "Empresa"
                            tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
                            tt_xml_input_1.tt_num_seq_1_xml   = 1
                            tt_xml_input_1.tt_num_seq_2_xml   = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label       = "Conta Cont bil"
                            tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.ct-cusven)
                            tt_xml_input_1.tt_num_seq_1_xml   = 1
                            tt_xml_input_1.tt_num_seq_2_xml   = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                            tt_xml_input_1.tt_des_conteudo    = ped-venda.cod-estabel
                            tt_xml_input_1.tt_num_seq_1_xml   = 1
                            tt_xml_input_1.tt_num_seq_2_xml   = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                            tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.dt-entrega)
                            tt_xml_input_1.tt_num_seq_1_xml  = 1
                            tt_xml_input_1.tt_num_seq_2_xml  = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                            tt_xml_input_1.tt_des_conteudo   = "0"
                            tt_xml_input_1.tt_num_seq_1_xml  = 1
                            tt_xml_input_1.tt_num_seq_2_xml  = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                            tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.vl-liq-ped)
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
                            tt_xml_input_1.tt_des_conteudo   = "Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
                            tt_xml_input_1.tt_num_seq_1_xml  = 1
                            tt_xml_input_1.tt_num_seq_2_xml  = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                            tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                            tt_xml_input_1.tt_num_seq_1_xml  = 1
                            tt_xml_input_1.tt_num_seq_2_xml  = 0.

                     create tt_xml_input_1.
                     assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                            tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.sc-cusven)
                            tt_xml_input_1.tt_num_seq_1_xml   = 1
                            tt_xml_input_1.tt_num_seq_2_xml   = 0.

                     RUN prgfin/bgc/bgc700za.py (input 1,
                                                 input table tt_xml_input_1,
                                                 output table tt_log_erros) .  
                 END.
             END.
                 IF VALID-HANDLE(h-cd9500) THEN
                  DELETE WIDGET h-cd9500.

         END.



    END. /* for each tt-epc ... */
    
    /* Projeto Levum - SCM */
    IF VALID-HANDLE(wgh-reabre-pedido-ft2200-upc)
    AND wgh-reabre-pedido-ft2200-upc:SENSITIVE THEN
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event
              AND tt-epc.cod-parameter = "notafiscal-rowid":
            RUN dop/dlevapi003.p PERSISTENT SET h-dlevapi003.
            RUN alocaPedidoNF IN h-dlevapi003 (INPUT TO-ROWID(tt-epc.val-parameter),
                                               INPUT YES,
                                               INPUT wgh-reabre-pedido-ft2200-upc:CHECKED).
            DELETE PROCEDURE h-dlevapi003 NO-ERROR.
        END.
END.

/* upc-bodi135cancel.p */

