/*******************************************************************************
**  Cliente  : RioClarense
**  Sistema  : EMS - 5.06
**  Programa : upc_acr240aa.p
**  Objetivo : Atualizar informa‡äes nas Colunas inseridas no Browse.
**  Data     : 10/2014
**  Autor    : Joao Tagliatti - Tauil Consultoria
**  Versao   : 5.06.000
*******************************************************************************/
{upc\upc_acr240aa.i}

DEFINE NEW GLOBAL SHARED VAR whQryBrTable_506         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColUF_BrT_506          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPort_BrT_506        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColCodRep_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoPgto_BrT_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColTipoEntrega_BrT_506 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColEmpenho_BrT_506       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColPedTotvs_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcLicita_BrT_506    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColLicitacao_BrT_506     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColProcesso_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPedido_BrT_506      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColVlTotPendente_BrT_506      AS WIDGET-HANDLE NO-UNDO.

DEFINE VAR h_buffer_table AS HANDLE NO-UNDO.
DEFINE VAR v_uf           AS CHAR   NO-UNDO INIT ''.
DEFINE VAR v_tipoPgto     AS CHAR   NO-UNDO INIT ''.
DEFINE VAR v_port         AS CHAR   NO-UNDO INIT ''.
DEFINE VAR v_cod_rep      AS INT    NO-UNDO INIT 0.
DEFINE VAR v_situacao     AS char   NO-UNDO INIT ''.
DEFINE VAR v_proc_licitacao    AS char   NO-UNDO INIT ''.
DEFINE VAR v_licitacao     AS char   NO-UNDO INIT ''.
DEFINE VAR v_empenho      AS char   NO-UNDO INIT ''.
DEFINE VAR v_pedido       AS char   NO-UNDO INIT ''.
DEFINE VAR v_processo     AS char   NO-UNDO INIT ''.
DEFINE VAR v_total           AS DEC    NO-UNDO INIT 0 FORMAT "->>>,>>>,>>>,>>>.9".
DEFINE VAR v_total_pendente  AS DEC   NO-UNDO INIT 0 FORMAT "->>>,>>>,>>>,>>>.9".


IF VALID-HANDLE (whQryBrTable_506) THEN DO TRANS:
    whQryBrTable_506:GET-CURRENT().
    
    ASSIGN h_buffer_table = whQryBrTable_506:GET-BUFFER-HANDLE(1).

    IF VALID-HANDLE(whColUF_BrT_506) THEN DO:
        /*IF fncNumerico(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE) THEN DO:*/
            FIND emitente NO-LOCK
                 WHERE emitente.cod-emitente = INT(h_buffer_table:BUFFER-FIELD("tta_cdn_cliente"):BUFFER-VALUE)
                 NO-ERROR.
            IF AVAIL emitente THEN ASSIGN v_uf = emitente.estado.

            FIND ext-emit NO-LOCK
                WHERE ext-emit.cod-emitente = INT(h_buffer_table:BUFFER-FIELD("tta_cdn_cliente"):BUFFER-VALUE) NO-ERROR.
            IF AVAIL ext-emit THEN ASSIGN v_tipoPgto = IF ext-emit.int-1 = 2 THEN "Total" ELSE "Parcial".
       /* END.*/
        ASSIGN whColUF_BrT_506:SCREEN-VALUE       = v_uf
               whColTipoPgto_BrT_506:SCREEN-VALUE = v_tipoPgto.
    END.

    IF VALID-HANDLE(whColCodRep_BrT_506) THEN DO:
       /* IF fncNumerico(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE) THEN DO:*/
            FOR FIRST tit_acr NO-LOCK
                WHERE tit_acr.cod_estab = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)
                  AND tit_acr.cod_espec_docto = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_espec_docto"):BUFFER-VALUE)
                  AND tit_acr.cod_ser_docto = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                  AND tit_acr.cod_tit_acr = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE)
                  AND tit_acr.cod_parcela = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE),
                FIRST clien_financ NO-LOCK
                WHERE clien_financ.cod_empresa = tit_acr.cod_empresa
                  AND clien_financ.cdn_cliente = INT(tit_acr.cdn_cliente):
                ASSIGN v_cod_rep = clien_financ.cdn_repres.
            END.
       /* END.*/
        ASSIGN whColCodRep_BrT_506:SCREEN-VALUE = STRING(v_cod_rep).
    END.

    IF VALID-HANDLE(whColPort_BrT_506) THEN DO:
        /*IF fncNumerico(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE) THEN DO:*/
            FOR FIRST tit_acr NO-LOCK
                WHERE tit_acr.cod_estab = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)
                  AND tit_acr.cod_espec_docto = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_espec_docto"):BUFFER-VALUE)
                  AND tit_acr.cod_ser_docto = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                  AND tit_acr.cod_tit_acr = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE)
                  AND tit_acr.cod_parcela = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE):
                ASSIGN v_port = tit_acr.cod_portador.
            END.
        /*END.*/
        ASSIGN whColPort_BrT_506:SCREEN-VALUE = STRING(v_port).
    END.

END. /* IF VALID-HANDLE (whQryBrTable_506) THEN DO: */

    IF VALID-HANDLE(whColTipoEntrega_BrT_506) THEN DO:
        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)
              AND nota-fiscal.serie = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
              AND nota-fiscal.nr-nota-fis = STRING(h_buffer_table:BUFFER-FIELD("tta_cod_tit_acr"):BUFFER-VALUE)
              AND nota-fiscal.cod-emitente = INT(h_buffer_table:BUFFER-FIELD("tta_cdn_cliente"):BUFFER-VALUE),
              FIRST ped-venda NO-LOCK WHERE ped-venda.cod-estabel = nota-fiscal.cod-estabel
                                         AND   ped-venda.nome-abrev  = nota-fiscal.nome-ab-cli
                                         AND   ped-venda.nr-pedcli   = nota-fiscal.nr-pedcli:

              FIND FIRST ped-venda-licitacao OF ped-venda NO-LOCK NO-ERROR.

              ASSIGN v_empenho = string(ped-venda.nr-pedcli)
                     v_pedido  = string(ped-venda.nr-pedido)
                     v_total = ped-venda.vl-tot-ped.
    
               FOR EACH ped-item OF ped-venda WHERE ped-venda.cod-sit-ped <= 2  NO-LOCK:
        
               ASSIGN v_total_pendente = v_total_pendente + ((ped-item.qt-pedida - ped-item.qt-atendida) * ped-item.vl-preuni).
        
        
               END.


                FIND FIRST licitacao NO-LOCK
                     WHERE licitacao.cod-estabel = ped-venda-licitacao.cod-estabel
                     AND   licitacao.nr-licitacao = ped-venda-licitacao.nr-licitacao
                     NO-ERROR.

                IF AVAIL licitacao THEN DO:
                    ASSIGN v_proc_licitacao  = IF licitacao.cod-licitacao = "" OR licitacao.cod-licitacao = ?  THEN string(licitacao.cod-processo) ELSE string(licitacao.cod-licitacao)
                           v_licitacao       = string(licitacao.nr-licitacao).
                END.

               FIND FIRST ext-ped-venda NO-LOCK
                     WHERE ext-ped-venda.nr-pedcli = ped-venda.nr-pedcli
                     AND   ext-ped-venda.nome-abrev = ped-venda.nome-abrev
                     NO-ERROR.
               IF AVAIL ext-ped-venda THEN DO:
                   
                   ASSIGN v_processo = ext-ped-venda.nr-processo.
               END.
                     


                
                CASE ped-venda.cod-sit-ped:

                    WHEN 1 THEN
                        ASSIGN v_situacao = "Aberto".
                    WHEN 2 THEN
                        ASSIGN v_situacao = "Atendido Parcial".
                    WHEN 3 THEN
                        ASSIGN v_situacao = "Atendido Total".
                    WHEN 4 THEN
                        ASSIGN v_situacao = "Pendente".
                    WHEN 5 THEN
                        ASSIGN v_situacao = "Suspenso".
                    WHEN 6 THEN
                        ASSIGN v_situacao = "Cancelado".
                    WHEN 7 THEN
                        ASSIGN v_situacao = "Fat.Balcao".
                END CASE.

            END.

        ASSIGN whColTipoEntrega_BrT_506:SCREEN-VALUE = string(v_situacao)
               whColEmpenho_BrT_506:SCREEN-VALUE     = string(v_empenho)     
               whColPedTotvs_BrT_506:SCREEN-VALUE    = string(v_pedido)    
               whColProcLicita_BrT_506:SCREEN-VALUE  = string(v_proc_licitacao)  
               whColLicitacao_BrT_506:SCREEN-VALUE   = STRING(v_licitacao)   
               whColProcesso_BrT_506:SCREEN-VALUE    = string(v_processo)
               whColVlTotPedido_BrT_506:SCREEN-VALUE = string(v_total)    
               whColVlTotPendente_BrT_506:SCREEN-VALUE = STRING(v_total_pendente).

    END.
