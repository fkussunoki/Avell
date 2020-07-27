/*****************************************************************************
**  Include.: doap002rp.i
**  Autor...: Reginaldo Leandro 
**  Data....: Julho 2002
**  Objetivo: EmissÆo de Relat¢rio Acerto Divergˆncias dos T¡tulos 
*****************************************************************************/

DEF TEMP-TABLE tt-pedido 
    FIELD num-pedido AS INT FORMAT '>>>>>,>>9' /*LIKE item-doc-est.num-pedido*/
INDEX codigo IS PRIMARY num-pedido .
DEF BUFFER b-tit_ap FOR tit_ap.

DEF VAR c-diverg AS CHAR FORMAT "x(15)" EXTENT 6 INIT
["DIV VALOR",
 "DIV QUANTIDADE",
 "DIV ANTECIPACAO",
 "DIV VENCIMENTO",
 "DIV NOTA FRETE",
 "DIV DESP ACES"].

DEF VAR c-libera  AS char format "x(14)" no-undo.
DEF VAR i-cont-ax AS INT no-undo.
DEF VAR l-diverg  AS LOGICAL no-undo.

FORM
    tit_ap.dat_vencto_tit_ap FORMAT '99/99/99' AT 2
    tit_ap.cod_estab         COLUMN-LABEL 'Est'
    tit_ap.cod_espec_docto   COLUMN-LABEL 'Esp'
    tit_ap.cod_ser_docto     COLUMN-LABEL "Ser"
    tit_ap.cod_tit_ap        COLUMN-LABEL "Docto"
    tit_ap.cod_parcela       COLUMN-LABEL "P"
    tit_ap.cdn_fornecedor 
    c-diverg[1]              COLUMN-LABEL "Divergencia"
    tit_ap.val_sdo_tit_ap    COLUMN-LABEL "Vl Duplicata"
                             FORMAT "->>>>,>>>,>>9.99"
    dc-diverg-dp.val-libera     COLUMN-LABEL "Vl Liberado"
                             FORMAT "->>>>,>>>,>>9.99"
    tit_ap.dat_vencto_tit_ap COLUMN-LABEL "Venc Dupl"
    dc-diverg-dp.venc-libera    FORMAT '99/99/99'     COLUMN-LABEL "Venc Lib"
    dc-diverg-dp.usu-libera     COLUMN-LABEL "Usuario" format "x(8)"
    c-libera                 COLUMN-LABEL "Dt/Hr Lib"
    WITH DOWN NO-BOX STREAM-IO WIDTH 132 FRAME f-docum.

    FOR EACH estabelecimento NO-LOCK USE-INDEX stblcmnt_id
        WHERE LOOKUP(estabelecimento.cod_estab,c-cod_estab-ax) <> 0:

        /*IF INDEX(c-cod_estab-ax,estabelecimento.cod_estab) <= 0 THEN
            NEXT.*/

        FOR EACH tit_ap NO-LOCK USE-INDEX titap_id
            WHERE tit_ap.cod_empresa     = c-cod-empresa /*v_cod_empres_usuar*/
              AND tit_ap.cod_estab       = estabelecimento.cod_estab
              AND tit_ap.cdn_fornecedor  >= i-cdn_fornecedor-ini-ax  
              AND tit_ap.cdn_fornecedor  <= i-cdn_fornecedor-fin-ax  
              AND tit_ap.cod_espec_docto >= c-cod_espec_docto-ini-ax 
              AND tit_ap.cod_espec_docto <= c-cod_espec_docto-fin-ax 
              AND tit_ap.cod_ser_docto   >= c-cod_ser_docto-ini-ax   
              AND tit_ap.cod_ser_docto   <= c-cod_ser_docto-fin-ax   
              AND tit_ap.cod_tit_ap      >= c-cod_tit_ap-ini-ax      
              AND tit_ap.cod_tit_ap      <= c-cod_tit_ap-fin-ax      
              AND tit_ap.cod_parcela     >= c-cod_parcela-ini-ax     
              AND tit_ap.cod_parcela     <= c-cod_parcela-fin-ax     
            BREAK BY tit_ap.cod_empresa
                  BY tit_ap.dat_vencto_tit_ap:
    
            IF tit_ap.val_sdo_tit_ap = 0 AND NOT l-pagos-ax THEN 
                NEXT.             
    
            IF tit_ap.dat_emis_docto < dat_emis_docto-ini-ax OR  
               tit_ap.dat_emis_docto > dat_emis_docto-fin-ax THEN
                NEXT.
    
            IF tit_ap.dat_vencto_tit_ap < dat_vencto_tit_ap-ini-ax OR
               tit_ap.dat_vencto_tit_ap > dat_vencto_tit_ap-fin-ax THEN
                NEXT.
    
            IF tit_ap.ind_tip_espec_docto = 'Antecipa‡Æo' THEN
                NEXT.
    
            ASSIGN l-diverg = NO.
    
            IF l-pendente-ax THEN DO:
    
                FIND FIRST dc-diverg-dp OF tit_ap NO-LOCK 
                    WHERE dc-diverg-dp.data-libera = ? NO-ERROR.
                IF AVAIL dc-diverg-dp THEN
                    ASSIGN l-diverg = YES.
            END.   
    
            IF l-liberados-ax THEN DO:
                FIND FIRST dc-diverg-dp OF tit_ap NO-LOCK 
                    WHERE dc-diverg-dp.data-libera <> ? NO-ERROR.
                IF AVAIL dc-diverg-dp THEN
                    ASSIGN l-diverg = YES.
            END.        
            IF l-diverg THEN DO:

                RUN pi-acompanhar IN h-acomp (INPUT "T¡tulo..." + tit_ap.cod_tit_ap + ' / ' + tit_ap.cod_parcela).

                /*PUT SKIP(1).*/
                DISP tit_ap.dat_vencto_tit_ap
                     tit_ap.cod_estab
                     tit_ap.cod_espec_docto
                     tit_ap.cod_ser_docto
                     tit_ap.cod_tit_ap
                     tit_ap.cod_parcela
                     tit_ap.cdn_fornecedor WITH FRAME f-docum.
    
                FOR EACH dc-diverg-dp OF tit_ap NO-LOCK USE-INDEX ch-prim:
                
                    RUN pi-acompanhar IN h-acomp (INPUT "Divergˆncia..." + dc-diverg-dp.cod_tit_ap + ' / ' + dc-diverg-dp.cod_parcela).
                                                             
                    ASSIGN c-libera = "".
    
                    IF dc-diverg-dp.data-libera <>  ?   THEN
                        ASSIGN c-libera = string(dc-diverg-dp.data-libera,"99/99/99") 
                                    + "-"
                                    + substr(dc-diverg-dp.hora-libera,1,5).
    
                    DISP c-diverg[dc-diverg-dp.cod-diverg] @ c-diverg[1] WITH FRAME f-docum.
                
                    IF dc-diverg-dp.cod-diverg <> 4 THEN
                        DISP tit_ap.val_sdo_tit_ap
                             dc-diverg-dp.val-libera WITH FRAME f-docum.
                    ELSE
                        DISP dc-diverg-dp.venc-libera WITH FRAME f-docum.
    
                    DISP dc-diverg-dp.usu-libera 
                         c-libera
                         WITH FRAME f-docum.
                    DOWN with frame f-docum.
    
                    DO i-cont-ax = 1 to 3:
                        IF dc-diverg-dp.justif-libera[i-cont-ax] <> "" THEN DO:

                            IF i-cont-ax = 1 THEN
                                PUT "Justific: "                   AT 44.

                            PUT dc-diverg-dp.justif-libera[i-cont-ax] AT 55.
                        END.
                    END.
                     
                    IF dc-diverg-dp.cod-diverg = 3 THEN DO:
                        FOR EACH tt-pedido.
                            DELETE tt-pedido.
                        END.
                        
                        FOR EACH item-doc-est NO-LOCK USE-INDEX documento
                            WHERE item-doc-est.serie-docto  = dc-diverg-dp.cod_ser_docto
                              AND item-doc-est.nro-docto    = dc-diverg-dp.cod_tit_ap 
                              AND item-doc-est.cod-emitente = dc-diverg-dp.cdn_fornecedor
                              AND item-doc-est.nat-operacao = dc-diverg-dp.nat-operacao:
                          
                            FIND FIRST dc-antecip-ped NO-LOCK    
                                WHERE dc-antecip-ped.num-pedido = item-doc-est.num-pedido NO-ERROR.
                          
                            IF AVAIL dc-antecip-ped THEN DO:
                             
                                FIND FIRST tt-pedido NO-LOCK
                                    WHERE tt-pedido.num-pedido = item-doc-est.num-pedido NO-ERROR.
    
                                IF NOT AVAIL tt-pedido THEN DO:
                                    
                                    CREATE tt-pedido.
                                    ASSIGN tt-pedido.num-pedido = item-doc-est.num-pedido.
                                END.   
                            END.
                        END.
                        
                        FOR EACH tt-pedido USE-INDEX codigo
                            BREAK BY tt-pedido.num-pedido:
    
                            IF FIRST(tt-pedido.num-pedido) THEN
                                PUT "*--------------------- ANTECIPA€ÇO " AT 44 "----------------------*"
                                    "Est Esp Ser    Docto P   Vl Antec"   AT 44
                                    " Ped            Vl Saldo"
                                    "--- --- --- -------- -- ---------"   AT 44
                                    "---- -------------------".
    
                             FIND FIRST b-tit_ap NO-LOCK
                                WHERE b-tit_ap.cod_empresa     = dc-antecip-ped.cod_empresa  
                                  AND b-tit_ap.cod_estab       = dc-antecip-ped.cod-estabel
                                  AND b-tit_ap.cdn_fornecedor  = dc-antecip-ped.cod-fornec 
                                  AND b-tit_ap.cod_espec_docto = dc-antecip-ped.cod-esp    
                                  AND b-tit_ap.cod_ser_docto   = dc-antecip-ped.serie      
                                  AND b-tit_ap.cod_tit_ap      = dc-antecip-ped.nr-docto   
                                  AND b-tit_ap.cod_parcela     = dc-antecip-ped.parcela NO-ERROR.   
                            
                                PUT dc-antecip-ped.cod-estabel   AT 44
                                    dc-antecip-ped.cod-esp       AT 48
                                    dc-antecip-ped.serie         AT 52
                                    dc-antecip-ped.nr-docto      TO 63
                                    dc-antecip-ped.parcela       AT 65
                                    dc-antecip-ped.vl-ant-pedido TO 80.
    
                            IF AVAIL b-tit_ap THEN
                                PUT b-tit_ap.val_sdo_tit_ap   TO 100.
    
                        END. /*-- for each tt-pedido ----------*/           
    
                    END. /*-- if dc-diverg-dp.cod-diverg = 3 -------*/
    
                    IF dc-diverg-dp.data-libera <> ? THEN
                        PUT SKIP(1).
    
                END. /*-- for each dc-diverg-dp ---------------------*/
    
            END. /*-- if avail dc-diverg-dp ------------------------*/   
    
        END. /*-- for each tit_ap -----------------------------*/
    END.

