DEF TEMP-TABLE tt-portador 
    FIELD cod-port     LIKE tit_acr.cod_portador
    FIELD vl-original  LIKE tit_acr.val_origin_tit_acr
    FIELD vl-saldo     LIKE tit_acr.val_sdo_tit_acr
    FIELD vl-prestacao LIKE dc-tit_acr.vend-vl-prestacao.

DEF VAR de-saldo LIKE tit_acr.val_sdo_tit_acr.
DEF VAR i-cont-estab AS INT.
DEF VAR c-erro AS CHAR.

REPEAT i-cont-estab = 1 TO NUM-ENTRIES(c-cod-estab):
    FIND FIRST vendor_param NO-LOCK
        WHERE vendor_param.cod_empresa   = c-empresa-ini
          AND vendor_param.cod_estabel   = ENTRY(i-cont-estab,c-cod-estab)
          AND vendor_param.dt_inic_valid <= TODAY
          AND vendor_param.dt_fin_valid  >= TODAY NO-ERROR.
    IF AVAIL vendor_param THEN DO:
        
        FOR EACH estabelecimento NO-LOCK USE-INDEX stblcmnt_id
            WHERE estabelecimento.cod_empresa = c-empresa-ini
             AND LOOKUP(estabelecimento.cod_estab,c-cod-estab) <> 0:
             /*IF INDEX(cod-estab,estabelecimento.cod_estab) <= 0 THEN
                NEXT.*/
                                           
            FOR EACH vendor-lote NO-LOCK USE-INDEX codigo
                WHERE vendor-lote.cod-empresa    = estabelecimento.cod_empresa
                  AND vendor-lote.cod-estab      = estabelecimento.cod_estab
                  AND vendor-lote.num-lote      >= num-lote-ini
                  AND vendor-lote.num-lote      <= num-lote-fin
                  AND vendor-lote.dt-fechamento >= dt-fechamento-ini
                  AND vendor-lote.dt-fechamento <= dt-fechamento-fin
                  AND vendor-lote.cod-portador  >= c-portador-ini
                  AND vendor-lote.cod-portador  <= c-portador-fin
                  AND vendor-lote.cod-carteira  >= c-carteira-ini
                  AND vendor-lote.cod-carteira  <= c-carteira-fin:
        
                RUN pi-acompanhar IN h-acomp ('Empresa.. ' + empresa.cod_empresa + ' Estab.. ' + estabelecimento.cod_estab + ' Lote.. ' + STRING(vendor-lote.num-lote) ).
                
                FOR EACH dc-tit_acr NO-LOCK USE-INDEX lote
                    WHERE dc-tit_acr.cod-empresa         = empresa.cod_empresa
                      AND dc-tit_acr.cod_estab           = estabelecimento.cod_estab
                      AND dc-tit_acr.vend-num-lote       = vendor-lote.num-lote
                      AND dc-tit_acr.vend-vendor-fechado = YES,
                   FIRST tit_acr NO-LOCK USE-INDEX titacr_token
                        WHERE tit_acr.cod_estab             = dc-tit_acr.cod_estab
                            AND tit_acr.num_id_tit_acr      = dc-tit_acr.num_id_tit_acr 
                            AND tit_acr.cod_espec_docto     = vendor_param.cod_espec_docto_neg
                            AND tit_acr.cdn_cliente        >= i-ini-cdn-cliente
                            AND tit_acr.cdn_cliente        <= i-fim-cdn-cliente 
                            AND tit_acr.dat_emis_docto     >= dt-emiss-ini 
                            AND tit_acr.dat_emis_docto     <= dt-emiss-fin 
                            AND tit_acr.dat_vencto_tit_acr >= dt-vencto-ini
                            AND tit_acr.dat_vencto_tit_acr <= dt-vencto-fin
                    BREAK BY tit_acr.cod_empresa
                          BY tit_acr.dat_vencto_tit_acr
                          BY tit_acr.cod_portador. 
    
                    FIND FIRST emsuni.cliente NO-LOCK USE-INDEX cliente_id
                         WHERE cliente.cod_empresa = empresa.cod_empresa
                           AND cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
        
                    IF AVAIL tit_acr THEN DO:
        
                        RUN pi-acompanhar IN h-acomp ('Cliente..' + string(tit_acr.cdn_cliente) +
                                                      ' T¡tulo..' + tit_acr.cod_tit_acr         +
                                                      ' / '       + tit_acr.cod_parcela         +
                                                      ' S‚rie..'  + tit_acr.cod_ser_docto).
        
                        ASSIGN de-saldo = tit_acr.val_sdo_tit_acr.
    
                        FOR EACH movto_tit_acr OF tit_acr NO-LOCK
                            WHERE movto_tit_acr.dat_transacao <= dt-movto-posicao:

                            CASE movto_tit_acr.ind_trans_acr_abrev:
                                WHEN 'AVMN' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'LIQ' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'LQEC' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'LQPD' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'LQRN' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'LQTE' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'EVMA' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'DEV' THEN
                                    RUN pi-adiciona-movto.
                                WHEN 'AVMA' THEN
                                    RUN pi-subtrai-movto.                            
                                WHEN 'EVMN' THEN
                                    RUN pi-subtrai-movto.
                                WHEN 'ELIQ' THEN
                                    RUN pi-subtrai-movto.
                                WHEN 'ELQR' THEN
                                    RUN pi-subtrai-movto.                            
                                WHEN 'ELQT' THEN
                                    RUN pi-subtrai-movto.
                            END CASE.
                        END.
    
                        /*rs-titulos 1- Em aberto 2- Todos*/
                        IF rs-titulos = 1 AND 
                           de-saldo   <= 0 THEN 
                            NEXT. 
    
                        DISP tit_acr.cdn_cliente
                             cliente.nom_abrev             WHEN AVAIL cliente FORMAT 'x(11)' COLUMN-LABE 'Nome Abrev'
                             estabelecimento.cod_estab
                             tit_acr.cod_tit_acr
                             tit_acr.cod_parcela           COLUMN-LABEL "P"
                             tit_acr.cod_portador
                             tit_acr.dat_emis_docto        
                             tit_acr.dat_vencto_tit_acr    
                             tit_acr.val_origin_tit_acr   (TOTAL BY tit_acr.cod_portador)
                             de-saldo                     (TOTAL BY tit_acr.cod_portador)
                             dc-tit_acr.vend-vl-prestacao (TOTAL BY tit_acr.cod_portador)
                             COLUMN-LABEL "Valor Prestacao"
                             WITH WIDTH 132 STREAM-IO.
    
                       FIND FIRST tt-portador
                           WHERE tt-portador.cod-port = tit_acr.cod_portador NO-ERROR.
                       IF NOT AVAIL tt-portador THEN DO:
                           
                           CREATE tt-portador.
                           ASSIGN tt-portador.cod-port = tit_acr.cod_portador.
                       END.
    
                       ASSIGN tt-portador.vl-original  = tt-portador.vl-original  + 
                                                         tit_acr.val_origin_tit_acr
                              tt-portador.vl-saldo     = tt-portador.vl-saldo     + 
                                                         de-saldo
                              tt-portador.vl-prestacao = tt-portador.vl-prestacao + 
                                                         dc-tit_acr.vend-vl-prestacao.    
                    END. /*Avail tit_acr*/
                END. /*dc-tit_acr*/            
            END. /*For each vendor-lote*/
        END. /*For each estabelec*/
    END.
    ELSE DO:
        ASSIGN c-erro = c-erro + ENTRY(i-cont-estab,cod-estab) + ','.
    END.
END.

PUT SKIP(1)
    FILL("-",132) FORMAT "x(132)"                   AT 01 SKIP(1)
    "R E S U M O   P O R   P O R T A D O R"         AT 20
    "- - - - - -   - - -   - - - - - - - -"         AT 20.

FOR EACH tt-portador.

    FIND FIRST emsfin.portador NO-LOCK
        WHERE  portador.cod_portador = tt-portador.cod-port NO-ERROR.

   DISP tt-portador.cod-port     AT 20
        portador.nom_abrev      WHEN AVAIL portador
        tt-portador.vl-original (TOTAL)
        tt-portador.vl-saldo    (TOTAL)
        tt-portador.vl-prestacao(TOTAL) 
       WITH WIDTH 132 STREAM-IO.
END.

PROCEDURE pi-adiciona-movto:
    ASSIGN de-saldo = de-saldo + movto_tit_acr.val_movto_tit_acr 
                               + movto_tit_acr.val_abat_tit_acr  
                               + movto_tit_acr.val_desconto     
                               - movto_tit_acr.val_juros 
                               - movto_tit_acr.val_multa_tit_acr.
END.
PROCEDURE pi-subtrai-movto:
    ASSIGN de-saldo = de-saldo - movto_tit_acr.val_movto_tit_acr 
                               - movto_tit_acr.val_abat_tit_acr  
                               - movto_tit_acr.val_desconto     
                               + movto_tit_acr.val_juros 
                               + movto_tit_acr.val_multa_tit_acr.
END.
