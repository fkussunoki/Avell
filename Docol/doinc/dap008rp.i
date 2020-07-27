/**********************************************************************************************************
** Include: dap008rp.i
** Autor..: Diomar Muhlmann
** Fun‡Æo.: Pesquisar Dados e montar temp-tables
***********************************************************************************************************/

/* Monta temp-table com relacionamentos conta saldo */
FOR EACH tt-cta-saldo:
   DELETE tt-cta-saldo.
END.
FOR EACH cta_grp_fornec NO-LOCK
   WHERE cta_grp_fornec.cod_empresa          = v_cod_empres_usuar
     AND cta_grp_fornec.ind_finalid_ctbl    = "Saldo"
/*      AND cta_grp_fornec.cod_finalid_econ    = "Corrente"  */
     AND cta_grp_fornec.dat_inic_valid      <= dat-posicao
     AND cta_grp_fornec.dat_fim_valid       >= dat-posicao
     AND cta_grp_fornec.ind_tip_espec_docto = "Nenhum":

   FIND FIRST tt-cta-saldo
        WHERE tt-cta-saldo.cod_empresa    = cta_grp_fornec.cod_empresa    
          AND tt-cta-saldo.cod_espec_doc  = cta_grp_fornec.cod_espec_doc
          AND tt-cta-saldo.cod_grp_fornec = cta_grp_fornec.cod_grp_fornec NO-ERROR.

   IF NOT AVAIL tt-cta-saldo THEN DO:
      CREATE tt-cta-saldo.
      ASSIGN tt-cta-saldo.cod_empresa    = cta_grp_fornec.cod_empresa
             tt-cta-saldo.cod_espec_doc  = cta_grp_fornec.cod_espec_doc
             tt-cta-saldo.cod_grp_fornec = cta_grp_fornec.cod_grp_fornec
             tt-cta-saldo.cod_cta_ctbl   = cta_grp_fornec.cod_cta_ctbl
             tt-cta-saldo.cod_ccusto     = cta_grp_fornec.cod_ccusto.
   END.
END.
FOR EACH cta_grp_fornec NO-LOCK
   WHERE cta_grp_fornec.cod_empresa          = v_cod_empres_usuar
     AND cta_grp_fornec.ind_finalid_ctbl    = "Saldo"
/*      AND cta_grp_fornec.cod_finalid_econ    = "Corrente"  */
     AND cta_grp_fornec.dat_inic_valid      <= dat-posicao
     AND cta_grp_fornec.dat_fim_valid       >= dat-posicao
     AND cta_grp_fornec.ind_tip_espec_docto <> "Nenhum":
   FOR EACH emsuni.espec_docto NO-LOCK
      WHERE emsuni.espec_docto.ind_tip_espec_docto = cta_grp_fornec.ind_tip_espec_docto,
      FIRST espec_docto_financ OF emsuni.espec_docto NO-LOCK:
      FIND FIRST tt-cta-saldo
           WHERE tt-cta-saldo.cod_empresa    = cta_grp_fornec.cod_empresa    
             AND tt-cta-saldo.cod_espec_doc  = espec_docto_financ.cod_espec_docto
             AND tt-cta-saldo.cod_grp_fornec = cta_grp_fornec.cod_grp_fornec NO-ERROR.
      IF NOT AVAIL tt-cta-saldo THEN DO:
         CREATE tt-cta-saldo.
         ASSIGN tt-cta-saldo.cod_empresa    = cta_grp_fornec.cod_empresa
                tt-cta-saldo.cod_espec_doc  = cta_grp_fornec.cod_espec_doc
                tt-cta-saldo.cod_grp_fornec = cta_grp_fornec.cod_grp_fornec
                tt-cta-saldo.cod_cta_ctbl   = cta_grp_fornec.cod_cta_ctbl
                tt-cta-saldo.cod_ccusto     = cta_grp_fornec.cod_ccusto.

      END.
   END.
END.
/* Fim monta temp-table com relacionamentos conta saldo */

DEF BUFFER b-tt-cta-saldo FOR tt-cta-saldo.

FOR EACH b-tt-cta-saldo NO-LOCK
   WHERE b-tt-cta-saldo.cod_empresa     = v_cod_empres_usuar
     AND LOOKUP(TRIM(b-tt-cta-saldo.cod_cta_ctbl),c-lista-cta-saldo) <> 0
     AND b-tt-cta-saldo.cod_grp_fornec >= c-grp-forn-ini
     AND b-tt-cta-saldo.cod_grp_fornec <= c-grp-forn-fin
   BREAK BY int(b-tt-cta-saldo.cod_grp_fornec):

   IF FIRST-OF(int(b-tt-cta-saldo.cod_grp_fornec)) THEN DO:

      FOR EACH emsuni.fornecedor NO-LOCK 
         WHERE emsuni.fornecedor.cod_empresa     = v_cod_empres_usuar
           AND emsuni.fornecedor.cod_grp_forn    = b-tt-cta-saldo.cod_grp_fornec
           AND emsuni.fornecedor.cdn_fornecedor >= i-cdn-forn-ini
           AND emsuni.fornecedor.cdn_fornecedor <= i-cdn-forn-fin.
         
         FIND FIRST tit_ap NO-LOCK
              WHERE tit_ap.cod_empresa         = v_cod_empres_usuar
                AND tit_ap.cdn_fornecedor      = fornecedor.cdn_fornecedor 
                AND tit_ap.dat_transacao       < dat-posicao + 1 
                AND tit_ap.dat_liquidac_tit_ap > dat-posicao NO-ERROR.
         IF NOT AVAIL tit_ap THEN NEXT.
      
         IF  v_num_ped_exec_corren = 0 THEN
             RUN pi-acompanhar IN h-acomp (INPUT "Grupo: " + fornecedor.cod_grp_fornec + " - Fornecedor: " + STRING(fornecedor.cdn_fornecedor)).
         
         FOR EACH estabelecimento NO-LOCK
            WHERE lookup(trim(estabelecimento.cod_estab),cod-estab) <> 0,
             EACH tit_ap NO-LOCK
            WHERE tit_ap.cod_estab            = estabelecimento.cod_estab 
              AND tit_ap.cdn_fornecedor       = fornecedor.cdn_fornecedor
              AND tit_ap.dat_liquidac_tit_ap  > dat-posicao
              AND lookup(trim(tit_ap.cod_espec_doc),c-lista-cod-esp) <> 0.
             
             IF tit_ap.cod_tit_ap < c-cod-tit-ap-ini OR
                tit_ap.cod_tit_ap > c-cod-tit-ap-fin THEN NEXT.

             IF tit_ap.cod_indic_econ < c-moeda-ini OR
                tit_ap.cod_indic_econ > c-moeda-fim THEN NEXT.

             FIND FIRST tt-cta-saldo NO-LOCK
                  WHERE tt-cta-saldo.cod_empresa    = tit_ap.cod_empresa
                    AND tt-cta-saldo.cod_grp_fornec = fornecedor.cod_grp_fornec
                    AND tt-cta-saldo.cod_espec_doc  = tit_ap.cod_espec_doc NO-ERROR.
             
             IF NOT AVAIL tt-cta-saldo THEN DO:
                CREATE tt-cta-saldo.
                ASSIGN tt-cta-saldo.cod_empresa    = tit_ap.cod_empresa
                       tt-cta-saldo.cod_espec_doc  = tit_ap.cod_espec_doc
                       tt-cta-saldo.cod_grp_fornec = fornecedor.cod_grp_fornec
                       tt-cta-saldo.cod_cta_ctbl   = tit_ap.cod_empresa + '-' + tit_ap.cod_espec_doc + '-' + fornecedor.cod_grp_fornec.
             END.

             IF LOOKUP(TRIM(tt-cta-saldo.cod_cta_ctbl),c-lista-cta-saldo) = 0 THEN NEXT.

/*              IF NOT tit_ap.log_tit_ap_estordo        AND        */
/*                 tit_ap.dat_ult_pagto  < dat-posicao  AND        */
/*                 tit_ap.val_sdo_tit_ap = 0           THEN NEXT.  */
/*                                                                 */
             
             RUN dop/dap008a.p (INPUT tit_ap.cod_estab,
                                INPUT tit_ap.num_id_tit_ap,
                                INPUT dat-posicao,
                                OUTPUT de-sdo-tit-ap,
                                OUTPUT de-sdo-tit-ap-indic).
      
             IF RETURN-VALUE  = "NOK" THEN NEXT.
             IF de-sdo-tit-ap = 0     THEN NEXT.

             FIND FIRST tt-resumo NO-LOCK
                  WHERE tt-resumo.cod_cta_ctbl = tt-cta-saldo.cod_cta_ctbl
                    AND tt-resumo.cod_ccusto   = tt-cta-saldo.cod_ccusto NO-ERROR.
             IF NOT AVAIL tt-resumo THEN DO:
                CREATE tt-resumo.
                ASSIGN tt-resumo.cod_cta_ctbl = tt-cta-saldo.cod_cta_ctbl
                       tt-resumo.cod_ccusto   = tt-cta-saldo.cod_ccusto.
             END.

             FIND FIRST emsuni.espec_docto NO-LOCK
                  WHERE emsuni.espec_docto.cod_espec_docto = tit_ap.cod_espec_docto NO-ERROR.
      
             IF emsuni.espec_docto.ind_tip_espec_docto = "Antecipa‡Æo" THEN
                ASSIGN tt-resumo.de-sd-debito  = tt-resumo.de-sd-debito  + de-sdo-tit-ap.
             ELSE
                ASSIGN tt-resumo.de-sd-credito = tt-resumo.de-sd-credito + de-sdo-tit-ap.
      
             IF emsuni.espec_docto.ind_tip_espec_docto <> "Antecipa‡Æo" AND 
                l-resumo-ct-saldo                               THEN DO:
                IF tit_ap.dat_prev_pagto <= dat-posicao THEN 
                   IF dat-posicao - tit_ap.dat_prev_pagto < 30 THEN
                      ASSIGN tt-resumo.de-vn-at-30 = tt-resumo.de-vn-at-30 + de-sdo-tit-ap.
                   ELSE 
                      IF dat-posicao - tit_ap.dat_prev_pagto < 60 THEN
                         ASSIGN tt-resumo.de-vn-31-60 = tt-resumo.de-vn-31-60 + de-sdo-tit-ap.
                      ELSE 
                         IF dat-posicao - tit_ap.dat_prev_pagto < 90 THEN
                            ASSIGN tt-resumo.de-vn-61-90 = tt-resumo.de-vn-61-90 + de-sdo-tit-ap.
                         ELSE 
                            IF dat-posicao - tit_ap.dat_prev_pagto < 120 THEN
                               ASSIGN tt-resumo.de-vn-91-120 = tt-resumo.de-vn-91-120 + de-sdo-tit-ap.
                            ELSE
                               ASSIGN tt-resumo.de-vn-ma-120 = tt-resumo.de-vn-ma-120 + de-sdo-tit-ap.
                ELSE 
                   IF tit_ap.dat_prev_pagto - dat-posicao < 30 THEN
                      ASSIGN tt-resumo.de-av-at-30 = tt-resumo.de-av-at-30 + de-sdo-tit-ap.
                   ELSE 
                      IF tit_ap.dat_prev_pagto - dat-posicao < 60 THEN
                         ASSIGN tt-resumo.de-av-31-60 = tt-resumo.de-av-31-60 + de-sdo-tit-ap.
                      ELSE 
                         IF tit_ap.dat_prev_pagto - dat-posicao < 90 THEN
                            ASSIGN tt-resumo.de-av-61-90 = tt-resumo.de-av-61-90 + de-sdo-tit-ap.
                         ELSE 
                            IF tit_ap.dat_prev_pagto - dat-posicao < 120 THEN
                               ASSIGN tt-resumo.de-av-91-120 = tt-resumo.de-av-91-120 + de-sdo-tit-ap.
                            ELSE
                               ASSIGN tt-resumo.de-av-ma-120 = tt-resumo.de-av-ma-120 + de-sdo-tit-ap.
             END.
             
             FIND FIRST tt-moeda
                  WHERE tt-moeda.cod_cta_ctbl   = tt-cta-saldo.cod_cta_ctbl
                    AND tt-moeda.cod_ccusto     = tt-cta-saldo.cod_ccusto 
                    AND tt-moeda.cod_indic_econ = tit_ap.cod_indic_econ 
                    AND tt-moeda.lancamen       = IF emsuni.espec_docto.ind_tip_espec_docto = "Antecipa‡Æo" THEN "DB"
                                                                                                     ELSE "CR" NO-ERROR.
             IF NOT AVAIL tt-moeda THEN DO:
                CREATE tt-moeda.
                ASSIGN tt-moeda.cod_cta_ctbl   = tt-cta-saldo.cod_cta_ctbl
                       tt-moeda.cod_ccusto     = tt-cta-saldo.cod_ccusto
                       tt-moeda.cod_indic_econ = tit_ap.cod_indic_econ
                       tt-moeda.lancamen       = IF emsuni.espec_docto.ind_tip_espec_docto = "Antecipa‡Æo" THEN "DB"
                                                                                                    ELSE "CR".
             END.

             ASSIGN tt-moeda.de-sdo-indicad = tt-moeda.de-sdo-indicad + de-sdo-tit-ap.
      
             IF l-detalhado THEN DO:
                IF fornecedor.cod_pais <> "Bra"                                  OR /* Estrangeiro */
                  (fornecedor.num_pessoa / 2) = INT(fornecedor.num_pessoa / 2) THEN /* Pessoa F¡sica */
                   ASSIGN c-cod-id-feder = fornecedor.cod_id_feder.
                ELSE
                   ASSIGN c-cod-id-feder = SUBSTR(fornecedor.cod_id_feder,1,8).
                
                CREATE tt-titap.
                ASSIGN tt-titap.cod_cta_ctbl      = tt-resumo.cod_cta_ctbl
                       tt-titap.cod_ccusto        = tt-resumo.cod_ccusto
                       tt-titap.cod_id_feder      = c-cod-id-feder
                       tt-titap.nom_pessoa        = fornecedor.nom_pessoa
                       tt-titap.cdn_fornecedor    = fornecedor.cdn_fornecedor
                       tt-titap.nom_abrev         = fornecedor.nom_abrev
                       tt-titap.cod_estab         = tit_ap.cod_estab   
                       tt-titap.cod_espec_doc     = tit_ap.cod_espec_doc
                       tt-titap.cod_ser_doc       = tit_ap.cod_ser_doc
                       tt-titap.cod_tit_ap        = tit_ap.cod_tit_ap
                       tt-titap.cod_parcela       = tit_ap.cod_parcela
                       tt-titap.cod_refer         = tit_ap.cod_refer 
                       tt-titap.dat_transacao     = tit_ap.dat_transacao
                       tt-titap.dat_emis_docto    = tit_ap.dat_emis_docto
                       tt-titap.dat_vencto_tit_ap = tit_ap.dat_prev_pagto
                       tt-titap.val_origin_tit_ap = tit_ap.val_origin_tit_ap
                       tt-titap.log_pagto_bloqdo  = tit_ap.log_pagto_bloqdo
                       tt-titap.val_sdo_tit_ap    = de-sdo-tit-ap
                       tt-titap.val_sdo_tit_ap-indic = de-sdo-tit-ap-indic
                       tt-titap.lancamen          = IF emsuni.espec_docto.ind_tip_espec_docto = "Antecipa‡Æo" THEN "DB"
                                                                                                       ELSE "CR"
                       tt-titap.cod_indic_econ    = tit_ap.cod_indic_econ.
                

                FIND FIRST item_bord_ap NO-LOCK
                    WHERE ITEM_bord_ap.cod_estab = tit_ap.cod_estab
                    AND   ITEM_bord_ap.cod_espec_docto = tit_ap.cod_espec_docto
                    AND   ITEM_bord_ap.cod_ser_docto   = tit_ap.cod_ser_docto
                    AND  ITEM_bord_ap.cdn_fornecedor  = tit_ap.cdn_fornecedor
                    AND   ITEM_bord_ap.cod_tit_ap      = tit_ap.cod_tit_ap
                    AND   ITEM_bord_ap.cod_parcela     = tit_ap.cod_parcela NO-ERROR.

                IF AVAIL ITEM_bord_ap THEN
                    ASSIGN tt-titap.num_bord_ap = item_bord_ap.num_bord_ap.

                IF l-historico THEN DO:
                   FIND FIRST movto_tit_ap OF tit_ap NO-LOCK NO-ERROR.
                   FIND FIRST histor_tit_movto_ap NO-LOCK 
                        WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                          AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap
                          AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                          AND histor_tit_movto_ap.ind_orig_histor_ap  = 'movimento'  NO-ERROR.
                   IF AVAIL histor_tit_movto_ap THEN
                      ASSIGN tt-titap.historico = SUBSTR(REPLACE(histor_tit_movto_ap.des_text_histor,CHR(10)," "),1,120).
                END.

             END. /* if l-detalhado */
         END. /* for each tit_ap */
      END. /* for each fornecedor */
   END. /* if first-of(int(b-tt-cta-saldo.cod_grp_fornec)) */
END.

/* dap008rp.i */

