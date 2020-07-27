ASSIGN dt-calc = dt-corte - DAY(dt-corte) + 1
       dt-calc = dt-calc + 40
       dt-calc = dt-calc - DAY(dt-calc).

IF dt-corte <> dt-calc THEN
    ASSIGN data-saldo = dt-corte.
ELSE
    ASSIGN data-saldo = dt-corte + 1.

FOR EACH cta_pat NO-LOCK
   WHERE cta_pat.cod_empresa = c-cod-empresa 
     AND LOOKUP(cta_pat.cod_cta_pat,c-list-cta-patrimonial) <> 0:

   RUN pi-acompanhar IN h-acomp(INPUT 'Conta Patrimonial ' + string(cta_pat.cod_cta_pat)).

   FOR EACH bem_pat OF cta_pat NO-LOCK
      WHERE bem_pat.cod_estab    >= c-estabel-ini             /* Estabelecimento  */
        AND bem_pat.cod_estab    <= c-estabel-fin:
            
      IF bem_pat.dat_aquis_bem_pat > dt-corte THEN NEXT.

      FIND FIRST movto_bem_pat OF bem_pat NO-LOCK USE-INDEX mvtbmpt_id  NO-ERROR.
      IF AVAIL movto_bem_pat                         AND 
         movto_bem_pat.dat_movto_bem_pat > dt-corte THEN NEXT.

      FIND LAST sdo_bem_pat OF bem_pat NO-LOCK  /* Saldo do Bem */
          WHERE sdo_bem_pat.num_seq_incorp_bem_pat = 0
            AND sdo_bem_pat.cod_cenar_ctbl         = c-cenar-contab
            AND sdo_bem_pat.cod_finalid_econ       = c-cod-finalid
            AND sdo_bem_pat.dat_sdo_bem_pat       <= data-saldo NO-ERROR.

      IF AVAIL sdo_bem_pat THEN DO:
         {doinc/dpt011rp.i2}
      END. 

      /* Saldos das Incorpora‡äes */
      FOR EACH incorp_bem_pat OF bem_pat NO-LOCK
         WHERE incorp_bem_pat.cod_cenar_ctbl         = c-cenar-contab
           AND incorp_bem_pat.dat_incorp_bem_pat     <= data-saldo.

         IF incorp_bem_pat.dat_incorp_bem_pat > dt-corte THEN NEXT.

         FIND LAST sdo_bem_pat OF bem_pat NO-LOCK  /* Saldo da Incorpora‡Æo */
             WHERE sdo_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
               AND sdo_bem_pat.cod_cenar_ctbl         = c-cenar-contab
               AND sdo_bem_pat.cod_finalid_econ       = c-cod-finalid
               AND sdo_bem_pat.dat_sdo_bem_pat       <= data-saldo NO-ERROR.
         IF AVAIL sdo_bem_pat THEN DO:
            {doinc/dpt011rp.i2}
         END.
      END. /* FIM-Saldos das Incorpora‡äes */
      
   END. /* for each bem_pat */
END. /* for each cta_pat */
    
FIND FIRST plano_cta_ctbl NO-LOCK
     WHERE plano_cta_ctbl.dat_inic_valid        <= TODAY          
       AND plano_cta_ctbl.dat_fim_valid         >= TODAY 
       AND plano_cta_ctbl.ind_tip_plano_cta_ctbl = 'Prim rio' NO-ERROR.
        
/* Saldo Imobilizado */

PUT "CUSTO CORRIGIDO"         AT 01 SKIP(1).

FOR EACH tt-dados NO-LOCK USE-INDEX ind-fin
   WHERE tt-dados.ind_finalid_ctbl = 'Saldo Imobilizado'
   BREAK BY tt-dados.cod_cta_ctbl_cr
         BY tt-dados.cod_cta_pat:
    
   ASSIGN vl-acum-cta-pat = vl-acum-cta-pat + tt-dados.vl-cta-pat. /*Soma todos os valores da mesma Conta em todos os Bens*/

   IF LAST-OF(tt-dados.cod_cta_ctbl_cr) THEN DO:
      
      FIND FIRST cta_ctbl NO-LOCK 
           WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             AND cta_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl_cr NO-ERROR.

      FIND  LAST sdo_ctbl NO-LOCK  /*CONTA*/
           WHERE sdo_ctbl.cod_empresa        = tt-dados.cod_empresa       
             AND sdo_ctbl.cod_finalid_econ   = c-cod-finalid
             AND sdo_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             AND sdo_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl_cr        
             AND sdo_ctbl.cod_plano_ccusto   = ''
             AND sdo_ctbl.cod_ccusto         = ''        
             AND sdo_ctbl.cod_proj_financ    = ''   
             AND sdo_ctbl.cod_cenar_ctbl     = c-cenar-contab
             AND sdo_ctbl.cod_estab          = v_cod_estab_usuar
             AND sdo_ctbl.cod_unid_negoc     = v_cod_unid_negoc_usuar
             AND sdo_ctbl.dat_sdo_ctbl      <= data-saldo NO-ERROR.
      IF AVAIL sdo_ctbl THEN
         ASSIGN tt-dados.vl-cta-ctbl = sdo_ctbl.val_sdo_ctbl_fim.

      ASSIGN tt-dados.vl-dif    = tt-dados.vl-cta-ctbl - vl-acum-cta-pat.

      DISP tt-dados.cod_cta_ctbl_cr
           cta_ctbl.des_tit_ctbl WHEN AVAIL cta_ctbl
           tt-dados.vl-cta-ctbl
           vl-acum-cta-pat @ tt-dados.vl-cta-pat
           tt-dados.vl-dif     
           WITH FRAME f-imobilizado.
      DOWN WITH FRAME f-imobilizado.

      IF tg-lista-cta-patrimo THEN DO:

         FOR EACH b-tt-dados NO-LOCK
            WHERE b-tt-dados.cod_empresa      = tt-dados.cod_empresa
              AND b-tt-dados.cod_cta_ctbl_cr  = tt-dados.cod_cta_ctbl_cr
              AND b-tt-dados.ind_finalid_ctbl = 'Saldo Imobilizado':
            PUT UNFORMATTED
                b-tt-dados.cod_cta_pat  AT 22
                '-'
                b-tt-dados.des_cta_pat.
            PUT b-tt-dados.vl-cta-pat   AT 81.
         END.
         PUT SKIP(1).

      END.

      ASSIGN sub-geral-fas     = sub-geral-fas   + vl-acum-cta-pat  
             sub-geral-fgl     = sub-geral-fgl   + tt-dados.vl-cta-ctbl
             sub-geral-dif     = sub-geral-dif   + tt-dados.vl-dif
             vl-acum-cta-pat  = 0.       
   END. /* last-of(tt-dados.cod_cta_ctbl_cr) */

   IF LAST(tt-dados.cod_cta_ctbl_cr) THEN DO:
      PUT SKIP(1)
          '----------------- ----------------- -----------------' AT 63
          'Total Custo Corrigido'                                 AT 40 
           sub-geral-fgl                                          TO 79 
           sub-geral-fas                                          TO 97 
           sub-geral-dif                                          TO 115
           SKIP(1).
      ASSIGN tot-geral-fas = tot-geral-fas   + sub-geral-fas  
             tot-geral-fgl = tot-geral-fgl   + sub-geral-fgl
             tot-geral-dif = tot-geral-dif   + sub-geral-dif
             sub-geral-fas    = 0
             sub-geral-fgl    = 0
             sub-geral-dif    = 0.
   END.
END.

/* Fim Saldo Imobilizado */

PUT SKIP(1)
    FILL("-",132) FORMAT "x(132)" AT 01 SKIP(1)
    "DEPRECIA€ÇO"                 AT 01 SKIP(1).

/* Deprecia‡Æo */

FOR EACH tt-dados NO-LOCK USE-INDEX ind-fin
   WHERE tt-dados.ind_finalid_ctbl = 'Deprecia‡Æo'
   BREAK BY tt-dados.cod_cta_ctbl_cr
         BY tt-dados.cod_cta_pat:
    
   ASSIGN vl-acum-cta-pat = vl-acum-cta-pat + tt-dados.vl-cta-pat. /*Soma todos os valores da mesma Conta em todos os Bens*/

   IF LAST-OF(tt-dados.cod_cta_ctbl_cr) THEN DO:
      
      FIND FIRST cta_ctbl NO-LOCK 
           WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             AND cta_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl_cr NO-ERROR.

      FIND  LAST sdo_ctbl NO-LOCK  /*CONTA*/
           WHERE sdo_ctbl.cod_empresa        = tt-dados.cod_empresa       
             AND sdo_ctbl.cod_finalid_econ   = c-cod-finalid
             AND sdo_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             AND sdo_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl_cr        
             AND sdo_ctbl.cod_plano_ccusto   = ''
             AND sdo_ctbl.cod_ccusto         = ''        
             AND sdo_ctbl.cod_proj_financ    = ''   
             AND sdo_ctbl.cod_cenar_ctbl     = c-cenar-contab
             AND sdo_ctbl.cod_estab          = v_cod_estab_usuar
             AND sdo_ctbl.cod_unid_negoc     = v_cod_unid_negoc_usuar
             AND sdo_ctbl.dat_sdo_ctbl      <= data-saldo NO-ERROR.
      IF AVAIL sdo_ctbl THEN
         ASSIGN tt-dados.vl-cta-ctbl = sdo_ctbl.val_sdo_ctbl_fim.

      ASSIGN tt-dados.vl-dif    = tt-dados.vl-cta-ctbl - vl-acum-cta-pat.

      DISP tt-dados.cod_cta_ctbl_cr
           cta_ctbl.des_tit_ctbl WHEN AVAIL cta_ctbl
           tt-dados.vl-cta-ctbl
           vl-acum-cta-pat @ tt-dados.vl-cta-pat
           tt-dados.vl-dif     
           WITH FRAME f-imobilizado.
      DOWN WITH FRAME f-imobilizado.

      IF tg-lista-cta-patrimo THEN DO:

         PUT SKIP(1).
         FOR EACH b-tt-dados NO-LOCK
            WHERE b-tt-dados.cod_empresa      = tt-dados.cod_empresa
              AND b-tt-dados.cod_cta_ctbl_cr  = tt-dados.cod_cta_ctbl_cr
              AND b-tt-dados.ind_finalid_ctbl = 'Deprecia‡Æo':
            PUT UNFORMATTED
                b-tt-dados.cod_cta_pat  AT 22
                '-'
                b-tt-dados.des_cta_pat.
            PUT b-tt-dados.vl-cta-pat   AT 81.
         END.
         PUT SKIP(1).

      END.

      ASSIGN sub-geral-fas     = sub-geral-fas   + vl-acum-cta-pat  
             sub-geral-fgl     = sub-geral-fgl   + tt-dados.vl-cta-ctbl
             sub-geral-dif     = sub-geral-dif   + tt-dados.vl-dif
             vl-acum-cta-pat  = 0.       
   END. /* last-of(tt-dados.cod_cta_ctbl_cr) */

   IF LAST(tt-dados.cod_cta_ctbl_cr) THEN DO:
      PUT SKIP(1)
          '----------------- ----------------- -----------------' AT 63
          'Total Deprecia‡Æo'                                     AT 40 
           sub-geral-fgl                                          TO 79 
           sub-geral-fas                                          TO 97 
           sub-geral-dif                                          TO 115
           SKIP(1).
      ASSIGN tot-geral-fas = tot-geral-fas   + sub-geral-fas  
             tot-geral-fgl = tot-geral-fgl   + sub-geral-fgl
             tot-geral-dif = tot-geral-dif   + sub-geral-dif
             sub-geral-fas    = 0
             sub-geral-fgl    = 0
             sub-geral-dif    = 0.
   END.
END.

/* Fim Deprecia‡Æo */

PUT SKIP(1)
    '---------------- ----------------- -----------------' AT 63 
    'Total Geral '   AT 40 
     tot-geral-fgl   TO 79 
     tot-geral-fas   TO 97 
     tot-geral-dif   TO 115.

ASSIGN tot-geral-fgl = 0
       tot-geral-fas = 0
       tot-geral-dif = 0.

/* DPT011RP.I */
