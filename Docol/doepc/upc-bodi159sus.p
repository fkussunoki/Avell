/*****************************************************************
***
*** 20.09.2019 - Flavio Kussunoki
*** UPC criada com o intuito de estornar execucao orcamentaria
*** dos pedidos de expositores, quando suspensos pelo PD40000
*****************************************************************/

{utp/ut-glob.i}
{include/i-epc200.i bodi159}

DEF VAR v-handle AS HANDLE.
DEFINE VARIABLE h-cd9500    AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-conta-ft  AS ROWID       NO-UNDO.
DEFINE VARIABLE i-cod-canal AS INTEGER     NO-UNDO.



DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
DEF VAR v_cod_unid_negoc LIKE emsuni.unid_negoc.cod_unid_negoc.               
/* Include com defini»’o da temp-table RowErrors */


DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE RowObject NO-UNDO LIKE ped-venda
    FIELD r-Rowid AS ROWID.

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



DEF INPUT PARAM  p-ind-event AS  CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.


IF p-ind-event = 'AfterSuspensionOrder' THEN DO:
                  
                    
    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "rowid-ped-venda":
        FOR FIRST ped-venda NO-LOCK
            WHERE ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter)
            AND   ped-venda.tp-pedido = "71":
        END.
    END.

    IF AVAIL ped-venda THEN

    RUN pi-execucao-orctaria.
    RETURN "OK".

END.


PROCEDURE pi-execucao-orctaria:

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
           tt_xml_input_1.tt_des_conteudo   = "90"
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


END PROCEDURE.



/* fim epc */

