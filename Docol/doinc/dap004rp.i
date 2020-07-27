/***********************************************************************************************************
** Include.: doap004rp.i
** Fun‡Æo..: Pesquisar dados e imprimir relat¢rio
************************************************************************************************************/

DEF TEMP-TABLE tt-movto-ap NO-UNDO
                           FIELD cod_grp_fornec     AS INT
                           FIELD cod_espec_docto    LIKE espec_docto_financ.cod_espec_docto
                           FIELD cdn_fornecedor     LIKE movto_tit_ap.cdn_fornecedor
                           FIELD nom_abrev          LIKE emsuni.fornecedor.nom_abrev
                           FIELD cod_estab          LIKE movto_tit_ap.cod_estab
                           FIELD cod_portador       LIKE movto_tit_ap.cod_portador
                           FIELD ind_trans_ap_abrev LIKE movto_tit_ap.ind_trans_ap_abrev
                           FIELD dat_transacao      LIKE movto_tit_ap.dat_transacao
                           FIELD val_movto_ap       LIKE movto_tit_ap.val_movto_ap
                           FIELD log-tit_ap         AS LOG
                           FIELD cod_ser_docto      LIKE tit_ap.cod_ser_docto 
                           FIELD cod_tit_ap         LIKE tit_ap.cod_tit_ap    
                           FIELD cod_parcela        LIKE tit_ap.cod_parcela   
                           FIELD dat_emis_docto     LIKE tit_ap.dat_emis_docto
                           FIELD dat_vencto_tit_ap  LIKE tit_ap.dat_vencto_tit_ap
                           INDEX grupo-espec cod_grp_fornec 
                                             cod_espec_docto
                                             dat_transacao
                                             cdn_fornecedor.

DEF TEMP-TABLE tt-grf-esp NO-UNDO
                          FIELD cod-gr-forn      AS CHAR FORMAT 'x(04)' LABEL 'Grupo'
                          FIELD cod-esp          AS CHAR FORMAT 'x(03)' LABEL 'Esp'
                          FIELD de-implan        AS DEC
                          FIELD de-baixas        AS DEC
                          FIELD de-prz-cp        AS DEC
                          FIELD de-prz-pg        AS DEC
                          FIELD de-atr-pg        AS DEC.

DEF VAR de-ger-prz-cp   AS DEC                         NO-UNDO.
DEF VAR de-ger-prz-pg   AS DEC                         NO-UNDO.
DEF VAR de-ger-atr-pg   AS DEC                         NO-UNDO.
DEF VAR de-ger-implan   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-ger-baixas   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-grf-prz-cp   AS DEC                         NO-UNDO.
DEF VAR de-grf-prz-pg   AS DEC                         NO-UNDO.
DEF VAR de-grf-atr-pg   AS DEC                         NO-UNDO.
DEF VAR de-grf-implan   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-grf-baixas   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-esp-prz-cp   AS DEC                         NO-UNDO.
DEF VAR de-esp-implan   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-esp-atr-pg   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-esp-baixas   as DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR de-res-prz-c    AS DEC                         NO-UNDO.
DEF VAR de-res-prz-p    AS DEC                         NO-UNDO.
DEF VAR de-res-atr-p    AS DEC                         NO-UNDO.
DEF VAR c-pipe          AS CHAR FORMAT "x" EXTENT 3    NO-UNDO.
DEF VAR l-imp-grf       AS LOG                         NO-UNDO.
DEF VAR l-prim-grup     AS LOG INIT YES                NO-UNDO.
DEF VAR l-imp-esp       AS LOG                         NO-UNDO.
DEF VAR de-esp-prz-pg   AS DEC FORMAT "->>,>>>,>>9.99" NO-UNDO.

DEF VAR c-espec-validas AS CHAR                        NO-UNDO.

DEF VAR da-emis-docto   AS DATE                        NO-UNDO.
DEF VAR c-lista-origem  AS CHAR                        NO-UNDO.

DEF BUFFER b-movto-sbnd FOR movto_tit_ap.
DEF BUFFER b-movto-bxsb FOR movto_tit_ap.
DEF BUFFER b-tit-bxsb   FOR tit_ap.

FORM HEADER
     "+---------------------------+-----------------------------------------+" AT 62
     "|      IMPLANTA€åES         |                   BAIXAS                |" AT 62
     "+---------------------------+-----------------------------------------+" AT 62      
     WITH WIDTH 150 PAGE-TOP STREAM-IO NO-LABELS NO-BOX FRAME f-topo-resumo.

IF rs-tipo-relatorio = 1 THEN
   VIEW FRAME f-topo-resumo.

ASSIGN c-espec-validas = "".
FOR EACH espec_docto_financ NO-LOCK USE-INDEX spcdctfa_id
   WHERE LOOKUP(espec_docto_financ.cod_espec_docto,c-lista-cod-esp-ax) <> 0,
   FIRST emsuni.espec_docto OF espec_docto_financ
   WHERE emsuni.espec_docto.ind_tip_espec_docto <> 'Antecipa‡Æo':
   ASSIGN c-espec-validas = c-espec-validas + emsuni.espec_docto.cod_espec_docto + ",".
END.

FOR EACH emsuni.fornecedor NO-LOCK
   WHERE emsuni.fornecedor.cod_empresa                           >= c-empresa-ini-ax
     AND emsuni.fornecedor.cod_empresa                           <= c-empresa-fin-ax
     AND int(emsuni.fornecedor.cod_grp_fornec)                   >= c-cod-grupo-ini-ax
     AND int(emsuni.fornecedor.cod_grp_fornec)                   <= c-cod-grupo-fin-ax
     AND emsuni.fornecedor.cdn_fornecedor                        >= i-cdn_fornecedor-ini-ax
     AND emsuni.fornecedor.cdn_fornecedor                        <= i-cdn_fornecedor-fin-ax:

    IF  v_num_ped_exec_corren = 0 THEN
        RUN pi-acompanhar IN h-acomp ("Lendos Movimentos do Fornecedor: " + STRING(emsuni.fornecedor.cdn_fornecedor)).

   FOR EACH movto_tit_ap NO-LOCK USE-INDEX mvtttp_razao 
      WHERE movto_tit_ap.cod_empresa                              = emsuni.fornecedor.cod_empresa
        AND movto_tit_ap.cdn_fornecedor                           = emsuni.fornecedor.cdn_fornecedor
        AND movto_tit_ap.dat_transacao                            > dat_transacao-ini-ax - 1 
        AND movto_tit_ap.dat_transacao                            < dat_transacao-fin-ax + 1
        AND LOOKUP(movto_tit_ap.cod_estab,c-cod_estab-ax)        <> 0
        AND LOOKUP(movto_tit_ap.cod_espec_docto,c-espec-validas) <> 0
        AND NOT movto_tit_ap.log_movto_estordo :

      IF NOT l-vinc-antecipacao-ax                  AND 
         movto_tit_ap.log_bxa_contra_antecip = YES THEN 
         NEXT.

      IF movto_tit_ap.ind_trans_ap_abrev <> "BXA"   AND
         movto_tit_ap.ind_trans_ap_abrev <> "PEF"   AND
         movto_tit_ap.ind_trans_ap_abrev <> "IMPL"  AND
         movto_tit_ap.ind_trans_ap_abrev <> "PEC"  THEN 
         NEXT.

      IF LOOKUP(STRING(movto_tit_ap.cod_portador,"99999"),c-portador-descon) <> 0 AND 
        (movto_tit_ap.ind_trans_ap_abrev = "BXA"  OR movto_tit_ap.ind_trans_ap_abrev = "PEF") THEN 
         NEXT.

      FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
      IF AVAIL tit_ap THEN DO:

         ASSIGN da-emis-docto  = tit_ap.dat_emis_docto
                c-lista-origem = tit_ap.ind_origin_tit_ap.

         IF movto_tit_ap.ind_trans_ap_abrev <> "IMPL" THEN DO:
            FIND FIRST b-movto-sbnd OF tit_ap NO-LOCK NO-ERROR.
            IF b-movto-sbnd.ind_trans_ap_abrev = "SBND" THEN DO: /* Verifica se t¡tulo baixado ‚ substituto de outros */
               FOR EACH b-movto-bxsb NO-LOCK
                  WHERE b-movto-bxsb.cod_estab          = b-movto-sbnd.cod_estab
                    AND b-movto-bxsb.cod_refer          = b-movto-sbnd.cod_refer
                    AND b-movto-bxsb.ind_trans_ap_abrev = "BXSB":
                  FIND FIRST b-tit-bxsb OF b-movto-bxsb NO-LOCK NO-ERROR.
                  IF AVAIL b-tit-bxsb THEN DO:
                     IF b-tit-bxsb.dat_emis_docto < da-emis-docto THEN
                        ASSIGN da-emis-docto = b-tit-bxsb.dat_emis_docto. /* Busca Data de EmissÆo mais Antiga dos t¡tulos substitu¡dos */
                     IF LOOKUP(b-tit-bxsb.ind_origin_tit_ap,c-lista-origem) = 0 THEN
                        ASSIGN c-lista-origem = c-lista-origem + "," + b-tit-bxsb.ind_origin_tit_ap. /* Listas das Origens dos T¡tulos Substitu¡dos */
                  END.
               END.

            END.
         END.

         IF LOOKUP(c-origem,c-lista-origem) = 0 AND c-origem <> "Todos" THEN 
            NEXT.
         IF tit_ap.cod_ser_docto     < c-cod_ser_docto-ini-ax   OR tit_ap.cod_ser_docto     > c-cod_ser_docto-fin-ax   OR
            tit_ap.cod_tit_ap        < c-cod_tit_ap-ini-ax      OR tit_ap.cod_tit_ap        > c-cod_tit_ap-fin-ax      OR
            tit_ap.cod_parcela       < c-cod_parcela-ini-ax     OR tit_ap.cod_parcela       > c-cod_parcela-fin-ax     OR
            da-emis-docto            < dat_emis_docto-ini-ax    OR da-emis-docto            > dat_emis_docto-fin-ax    OR
            tit_ap.dat_vencto_tit_ap < dat_vencto_tit_ap-ini-ax OR tit_ap.dat_vencto_tit_ap > dat_vencto_tit_ap-fin-ax THEN 
            NEXT.
      END.

      CREATE tt-movto-ap.
      ASSIGN tt-movto-ap.cod_grp_fornec     = INT(emsuni.fornecedor.cod_grp_fornec)
             tt-movto-ap.cod_espec_docto    = movto_tit_ap.cod_espec_docto     
             tt-movto-ap.cdn_fornecedor     = movto_tit_ap.cdn_fornecedor            
             tt-movto-ap.nom_abrev          = emsuni.fornecedor.nom_abrev            
             tt-movto-ap.cod_estab          = movto_tit_ap.cod_estab                 
             tt-movto-ap.cod_portador       = movto_tit_ap.cod_portador              
             tt-movto-ap.ind_trans_ap_abrev = movto_tit_ap.ind_trans_ap_abrev        
             tt-movto-ap.dat_transacao      = movto_tit_ap.dat_transacao             
             tt-movto-ap.val_movto_ap       = movto_tit_ap.val_movto_ap
             tt-movto-ap.log-tit_ap         = AVAIL tit_ap.

      IF AVAIL tit_ap THEN DO:
         ASSIGN tt-movto-ap.cod_ser_docto      = tit_ap.cod_ser_docto
                tt-movto-ap.cod_tit_ap         = tit_ap.cod_tit_ap
                tt-movto-ap.cod_parcela        = tit_ap.cod_parcela
                tt-movto-ap.dat_emis_docto     = da-emis-docto
                tt-movto-ap.dat_vencto_tit_ap  = tit_ap.dat_vencto_tit_ap.
      END.
   END.
END.

FOR EACH tt-movto-ap NO-LOCK
   BREAK BY tt-movto-ap.cod_grp_fornec
         BY tt-movto-ap.cod_espec_docto
         BY tt-movto-ap.dat_transacao
         BY tt-movto-ap.cdn_fornecedor.

   IF c-tipo-relat = 'Detalhado' THEN DO: /* Detalhado */
      IF FIRST-OF(tt-movto-ap.cod_grp_fornec) THEN DO:
         FIND FIRST grp_fornec NO-LOCK
              WHERE grp_fornec.cod_grp_fornec = string(tt-movto-ap.cod_grp_fornec) NO-ERROR.
         IF NOT FIRST(tt-movto-ap.cod_grp_fornec) THEN PAGE.
         DISP "Grupo Fornecedor:"
              grp_fornec.cod_grp_fornec "-"
              grp_fornec.des_grp_fornec SKIP(1)
              WITH NO-LABELS NO-BOX STREAM-IO FRAME f-grf.
      END.
    
      IF FIRST-OF(tt-movto-ap.cod_espec_docto) THEN DO:
         FIND FIRST emsuni.espec_docto NO-LOCK
              WHERE emsuni.espec_docto.cod_espec_docto = string(tt-movto-ap.cod_espec_docto) NO-ERROR.
         DISP "Esp‚cie:"
              emsuni.espec_docto.cod_espec_docto "-"
              emsuni.espec_docto.des_espec_docto SKIP(1)
              WITH NO-LABELS NO-BOX STREAM-IO FRAME f-esp.
      END.
   END.

   IF tt-movto-ap.log-tit_ap THEN DO:
      IF tt-movto-ap.ind_trans_ap_abrev = "BXA" OR
         tt-movto-ap.ind_trans_ap_abrev = "PEF" THEN
         ASSIGN de-esp-prz-pg = de-esp-prz-pg + ((tt-movto-ap.dat_transacao - tt-movto-ap.dat_emis_docto)    * tt-movto-ap.val_movto_ap)
                de-esp-atr-pg = de-esp-atr-pg + ((tt-movto-ap.dat_transacao - tt-movto-ap.dat_vencto_tit_ap) * tt-movto-ap.val_movto_ap)
                de-esp-baixas = de-esp-baixas + tt-movto-ap.val_movto_ap.
      ELSE
         ASSIGN de-esp-prz-cp = de-esp-prz-cp + ((tt-movto-ap.dat_vencto_tit_ap - tt-movto-ap.dat_emis_docto) * tt-movto-ap.val_movto_ap)
                de-esp-implan = de-esp-implan + tt-movto-ap.val_movto_ap.
   END.


   IF c-tipo-relat = 'Detalhado' THEN DO: /* Detalhado */
      DISP tt-movto-ap.cdn_fornecedor
           tt-movto-ap.nom_abrev
           tt-movto-ap.cod_grp_fornec                                                           COLUMN-LABEL "Grp"
           tt-movto-ap.cod_estab                                                                COLUMN-LABEL 'Est'
           tt-movto-ap.cod_ser_docto                                                            COLUMN-LABEL "Ser"      WHEN tt-movto-ap.log-tit_ap
           tt-movto-ap.cod_tit_ap                                                               COLUMN-LABEL "Docto"    WHEN tt-movto-ap.log-tit_ap
           tt-movto-ap.cod_parcela                                                              COLUMN-LABEL "P"        WHEN tt-movto-ap.log-tit_ap
           tt-movto-ap.cod_portador                                                             COLUMN-LABEL "Port"
           tt-movto-ap.ind_trans_ap_abrev                                                       COLUMN-LABEL "Tra"
           tt-movto-ap.dat_transacao                                      FORMAT '99/99/99'     COLUMN-LABEL "Transa‡Æo"
           tt-movto-ap.dat_emis_docto                                     FORMAT '99/99/99'     COLUMN-LABEL "EmissÆo"  WHEN tt-movto-ap.log-tit_ap 
           tt-movto-ap.dat_vencto_tit_ap                                  FORMAT '99/99/99'     COLUMN-LABEL "Vencimen" WHEN tt-movto-ap.log-tit_ap
          (tt-movto-ap.dat_vencto_tit_ap - tt-movto-ap.dat_emis_docto)    FORMAT "->>>9"        COLUMN-LABEL "Pr Com"   WHEN (tt-movto-ap.ind_trans_ap_abrev = "IMPL" OR tt-movto-ap.ind_trans_ap_abrev = "PEC") AND tt-movto-ap.log-tit_ap
          (tt-movto-ap.dat_transacao     - tt-movto-ap.dat_emis_docto)    FORMAT "->>>9"        COLUMN-LABEL "Pr Pag"   WHEN (tt-movto-ap.ind_trans_ap_abrev = "BXA"  OR tt-movto-ap.ind_trans_ap_abrev = "PEF") AND tt-movto-ap.log-tit_ap
          (tt-movto-ap.dat_transacao     - tt-movto-ap.dat_vencto_tit_ap) FORMAT "->>>9"        COLUMN-LABEL "At Pag"   WHEN (tt-movto-ap.ind_trans_ap_abrev = "BXA"  OR tt-movto-ap.ind_trans_ap_abrev = "PEF") AND tt-movto-ap.log-tit_ap
           tt-movto-ap.val_movto_ap                                       FORMAT "->>>>,>>9.99" COLUMN-LABEL "Valor Mov"  
           WITH WIDTH 150 DOWN NO-BOX STREAM-IO FRAME f-corpo.
      DOWN WITH FRAME f-corpo.
   END.   

   IF LAST-OF(tt-movto-ap.cod_espec_docto) THEN DO:

      IF  v_num_ped_exec_corren = 0 THEN
          RUN pi-acompanhar in h-acomp ("Listando Grupo: " + string(tt-movto-ap.cod_grp_fornec) + " Esp‚cie: " + tt-movto-ap.cod_espec_docto).

      IF de-esp-baixas  > 0 OR de-esp-implan > 0 THEN DO:
         IF c-tipo-relat = 'Resumido' THEN DO:
            FIND FIRST tt-grf-esp
                 WHERE tt-grf-esp.cod-gr-forn  = string(tt-movto-ap.cod_grp_fornec)
                   AND tt-grf-esp.cod-esp      = tt-movto-ap.cod_espec_docto NO-ERROR.
            IF NOT AVAIL tt-grf-esp THEN DO:
               CREATE tt-grf-esp.
               ASSIGN tt-grf-esp.cod-gr-forn  = string(tt-movto-ap.cod_grp_fornec)   
                      tt-grf-esp.cod-esp      = tt-movto-ap.cod_espec_docto.
            END.
            ASSIGN tt-grf-esp.de-implan    = tt-grf-esp.de-implan + de-esp-implan
                   tt-grf-esp.de-baixas    = tt-grf-esp.de-baixas + de-esp-baixas
                   tt-grf-esp.de-prz-cp    = tt-grf-esp.de-prz-cp + de-esp-prz-cp
                   tt-grf-esp.de-prz-pg    = tt-grf-esp.de-prz-pg + de-esp-prz-pg
                   tt-grf-esp.de-atr-pg    = tt-grf-esp.de-atr-pg + de-esp-atr-pg.
         END.
         ELSE DO:
            DISP SKIP(1)
                 "............................." AT 01 SPACE(0)
                 "............................... Totais Esp‚cie"
                 tt-movto-ap.cod_espec_docto
                 "--->"
                 "Valor das Implanta‡äes:"           AT 90
                 de-esp-implan
                 "Prz Medio Implanta‡äes:"           AT 90 SPACE(4)
                 de-esp-prz-cp / de-esp-implan FORMAT '->>9.99' "dias"
                 "      Valor das Baixas:"           AT 90
                 de-esp-baixas
                 "      Prz Medio Baixas:"           AT 90 SPACE(4)
                 de-esp-prz-pg / de-esp-baixas FORMAT '->>9.99' "dias"
                 "   Atraso M‚dio Baixas:"           AT 90 SPACE(4)
                 de-esp-atr-pg / de-esp-baixas FORMAT '->>9.99' "dias"
                 WITH WIDTH 150 NO-LABELS NO-BOX STREAM-IO FRAME f-tt-esp.
            PUT FILL("-",132) FORMAT "x(132)"       AT 01.
             
            ASSIGN de-grf-prz-cp = de-grf-prz-cp + de-esp-prz-cp
                   de-grf-implan = de-grf-implan + de-esp-implan
                   de-grf-prz-pg = de-grf-prz-pg + de-esp-prz-pg
                   de-grf-atr-pg = de-grf-atr-pg + de-esp-atr-pg 
                   de-grf-baixas = de-grf-baixas + de-esp-baixas.
         END.
    
         ASSIGN de-esp-prz-cp    = 0
                de-esp-implan    = 0
                de-esp-prz-pg    = 0
                de-esp-atr-pg    = 0
                de-esp-baixas    = 0.
      END.
   END. /* IF LAST-OF(tt-movto-ap.cod_espec_docto) */

   IF LAST-OF(tt-movto-ap.cod_grp_fornec) THEN DO:
      IF (de-grf-implan > 0 OR de-grf-baixas > 0) AND c-tipo-relat = 'Detalhado' THEN DO:
         DISP SKIP(1)
              "..................................." AT 01 space(0)
              ".......................... Totais Grupo"
              string(tt-movto-ap.cod_grp_fornec)
              "--->"
              "Valor das Implanta‡äes:"                 AT 90
              de-grf-implan 
              "Prz Medio Implanta‡äes:"                 AT 90 space(4)
              de-grf-prz-cp / de-grf-implan FORMAT "->>9.99" "dias"
              "      Valor das Baixas:"                 AT 90
              de-grf-baixas
              "      Prz M‚dio Baixas:"                 AT 90 space(4)
              de-grf-prz-pg / de-grf-baixas FORMAT "->>9.99" "dias"
              "   Atraso M‚dio Baixas:"                 AT 90 space(4)
              de-grf-atr-pg / de-grf-baixas FORMAT "->>9.99" "dias"
              WITH WIDTH 150 NO-LABELS NO-BOX STREAM-IO FRAME f-tt-grf.
         PUT FILL("-",132) FORMAT "x(132)"              AT 01.
    
         ASSIGN de-ger-prz-cp = de-ger-prz-cp + de-grf-prz-cp
                de-ger-implan = de-ger-implan + de-grf-implan
                de-ger-prz-pg = de-ger-prz-pg + de-grf-prz-pg
                de-ger-atr-pg = de-ger-atr-pg + de-grf-atr-pg
                de-ger-baixas = de-ger-baixas + de-grf-baixas
                de-grf-prz-cp = 0
                de-grf-implan = 0
                de-grf-prz-pg = 0
                de-grf-atr-pg = 0
                de-grf-baixas = 0.
    
      END. /* if  */
   END. /* IF LAST-OF(tt-movto-ap.cod_grp_fornec) */
END.

/*
FOR EACH estabelecimento NO-LOCK USE-INDEX stblcmnt_id
   WHERE estabelecimento.cod_empresa                      >= c-empresa-ini-ax
     AND estabelecimento.cod_empresa                      <= c-empresa-fin-ax
     AND LOOKUP(estabelecimento.cod_estab,c-cod_estab-ax) <> 0:

   FOR EACH grp_fornec NO-LOCK USE-INDEX grpfrnc_id
      WHERE int(grp_fornec.cod_grp_fornec) >= c-cod-grupo-ini-ax
        AND int(grp_fornec.cod_grp_fornec) <= c-cod-grupo-fin-ax
      BREAK BY int(grp_fornec.cod_grp_fornec):

      IF FIRST-OF(int(grp_fornec.cod_grp_fornec)) THEN 
         l-imp-grf = NO.
    
      FOR EACH espec_docto_financ NO-LOCK USE-INDEX spcdctfa_id
         WHERE LOOKUP(espec_docto_financ.cod_espec_docto,c-lista-cod-esp-ax) <> 0,
         FIRST emsuni.espec_docto OF espec_docto_financ
         WHERE emsuni.espec_docto.ind_tip_espec_docto <> 'Antecipa‡Æo'
         BREAK BY espec_docto_financ.cod_espec_docto:

         IF FIRST-OF(espec_docto_financ.cod_espec_docto) THEN l-imp-esp = NO.   

         IF  v_num_ped_exec_corren = 0 THEN
             RUN pi-acompanhar IN h-acomp (INPUT ' Estab: '  + estabelecimento.cod_estab          +
                                                 ', Grupo: ' + grp_fornec.cod_grp_fornec          +
                                                 ', Esp: '   + espec_docto_financ.cod_espec_docto).
               
         FOR EACH movto_tit_ap USE-INDEX mvtttp_log_integr_cfl NO-LOCK 
            WHERE movto_tit_ap.cod_estab             = estabelecimento.cod_estab
              AND movto_tit_ap.cod_espec_docto       = espec_docto_financ.cod_espec_docto
              AND movto_tit_ap.log_integr_cfl_atlzdo <> ?
              AND movto_tit_ap.dat_transacao         > dat_transacao-ini-ax - 1 
              AND movto_tit_ap.dat_transacao         < dat_transacao-fin-ax + 1:

            IF NOT l-vinc-antecipacao-ax                  AND 
               movto_tit_ap.log_bxa_contra_antecip = YES THEN 
               NEXT.

            IF movto_tit_ap.ind_trans_ap_abrev <> "BXA"   AND
               movto_tit_ap.ind_trans_ap_abrev <> "PEF"   AND
               movto_tit_ap.ind_trans_ap_abrev <> "IMPL"  AND
               movto_tit_ap.ind_trans_ap_abrev <> "PEC"  THEN 
               NEXT.

            IF LOOKUP(STRING(movto_tit_ap.cod_portador,"99999"),c-portador-descon) <> 0 AND 
              (movto_tit_ap.ind_trans_ap_abrev = "BXA"  OR movto_tit_ap.ind_trans_ap_abrev = "PEF") THEN 
               NEXT.

            FIND FIRST fornecedor NO-LOCK
                 WHERE fornecedor.cod_empresa     = estabelecimento.cod_empresa
                   AND fornecedor.cdn_fornecedor  = movto_tit_ap.cdn_fornecedor NO-ERROR.
            IF int(fornecedor.cod_grp_fornec) <> int(grp_fornec.cod_grp_fornec) THEN NEXT.
            
            FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
            IF AVAIL tit_ap THEN DO:
               IF tit_ap.ind_origin_tit_ap <> c-origem AND c-origem <> "Todos" THEN 
                  NEXT.
               IF tit_ap.cod_ser_docto     < c-cod_ser_docto-ini-ax   OR tit_ap.cod_ser_docto     > c-cod_ser_docto-fin-ax   OR
                  tit_ap.cod_tit_ap        < c-cod_tit_ap-ini-ax      OR tit_ap.cod_tit_ap        > c-cod_tit_ap-fin-ax      OR
                  tit_ap.cod_parcela       < c-cod_parcela-ini-ax     OR tit_ap.cod_parcela       > c-cod_parcela-fin-ax     OR
                  tit_ap.dat_emis_docto    < dat_emis_docto-ini-ax    OR tit_ap.dat_emis_docto    > dat_emis_docto-fin-ax    OR
                  tit_ap.dat_vencto_tit_ap < dat_vencto_tit_ap-ini-ax OR tit_ap.dat_vencto_tit_ap > dat_vencto_tit_ap-fin-ax THEN 
                  NEXT.
            END.
            
            IF c-tipo-relat = 'Detalhado' THEN DO: /* Detalhado */
               IF NOT l-imp-grf THEN DO:
                  IF NOT l-prim-grup THEN 
                     PAGE.
                  ELSE
                     ASSIGN l-prim-grup = no.
        
                  DISP "Grupo Fornecedor:"
                       grp_fornec.cod_grp_fornec "-"
                       grp_fornec.des_grp_fornec 
                       WITH NO-LABELS NO-BOX STREAM-IO FRAME f-grf.
        
                  ASSIGN l-imp-grf = yes.
               END.
        
               IF NOT l-imp-esp THEN DO:
                  DISP SKIP(1)
                       "Esp‚cie:"
                       espec_docto_financ.cod_espec_docto "-"
                       emsuni.espec_docto.des_espec_docto SKIP(1)
                       WITH NO-LABELS NO-BOX STREAM-IO FRAME f-esp.
                  ASSIGN l-imp-esp = yes.
               END.
            END.
        
            IF AVAIL tit_ap THEN DO:
               IF movto_tit_ap.ind_trans_ap_abrev = "BXA" OR
                  movto_tit_ap.ind_trans_ap_abrev = "PEF" THEN
                  ASSIGN de-esp-prz-pg = de-esp-prz-pg       + ((movto_tit_ap.dat_transacao - tit_ap.dat_emis_docto) * movto_tit_ap.val_movto_ap)
                         de-esp-atr-pg = de-esp-atr-pg       + ((movto_tit_ap.dat_transacao - tit_ap.dat_vencto_tit_ap) * movto_tit_ap.val_movto_ap)
                         de-esp-baixas = de-esp-baixas       + movto_tit_ap.val_movto_ap.
               ELSE
                  ASSIGN de-esp-prz-cp = de-esp-prz-cp       + ((tit_ap.dat_vencto_tit_ap  - tit_ap.dat_emis_docto)  * movto_tit_ap.val_movto_ap)
                         de-esp-implan = de-esp-implan       + movto_tit_ap.val_movto_ap.
            END.
                       
            IF c-tipo-relat = 'Detalhado' THEN DO: /* Detalhado */
               DISP movto_tit_ap.cdn_fornecedor
                    fornecedor.nom_abrev
                    fornecedor.cod_grp_fornec                                                    COLUMN-LABEL "Grp"
                    movto_tit_ap.cod_estab                                                       COLUMN-LABEL 'Est'
                    tit_ap.cod_ser_docto                                                         COLUMN-LABEL "Ser"      WHEN AVAIL tit_ap
                    tit_ap.cod_tit_ap                                                            COLUMN-LABEL "Docto"    WHEN AVAIL tit_ap
                    tit_ap.cod_parcela                                                           COLUMN-LABEL "P"        WHEN AVAIL tit_ap
                    movto_tit_ap.cod_portador                                                    COLUMN-LABEL "Port"
                    movto_tit_ap.ind_trans_ap_abrev                                              COLUMN-LABEL "Tra"
                    movto_tit_ap.dat_transacao                             FORMAT '99/99/99'     COLUMN-LABEL "Transa‡Æo"
                    tit_ap.dat_emis_docto                                  FORMAT '99/99/99'     COLUMN-LABEL "EmissÆo"  WHEN AVAIL tit_ap 
                    tit_ap.dat_vencto_tit_ap                               FORMAT '99/99/99'     COLUMN-LABEL "Vencimen" WHEN AVAIL tit_ap 
                   (tit_ap.dat_vencto_tit_ap   - tit_ap.dat_emis_docto)    FORMAT "->>>9"        COLUMN-LABEL "Pr Com"   WHEN (movto_tit_ap.ind_trans_ap_abrev = "IMPL" OR movto_tit_ap.ind_trans_ap_abrev = "PEC") AND AVAIL tit_ap
                   (movto_tit_ap.dat_transacao - tit_ap.dat_emis_docto)    FORMAT "->>>9"        COLUMN-LABEL "Pr Pag"   WHEN (movto_tit_ap.ind_trans_ap_abrev = "BXA"  OR movto_tit_ap.ind_trans_ap_abrev = "PEF") AND AVAIL tit_ap
                   (movto_tit_ap.dat_transacao - tit_ap.dat_vencto_tit_ap) FORMAT "->>>9"        COLUMN-LABEL "At Pag"   WHEN (movto_tit_ap.ind_trans_ap_abrev = "BXA"  OR movto_tit_ap.ind_trans_ap_abrev = "PEF") AND AVAIL tit_ap
                    movto_tit_ap.val_movto_ap                              FORMAT "->>>>,>>9.99" COLUMN-LABEL "Valor Mov"  
                    WITH WIDTH 150 DOWN NO-BOX STREAM-IO FRAME f-corpo.
               DOWN WITH FRAME f-corpo.
            END.                                          
         END. /* for each movto_tit_ap */                
        
         IF de-esp-baixas  > 0 OR de-esp-implan > 0 THEN DO:
            IF c-tipo-relat = 'Resumido' THEN DO:
               FIND FIRST tt-grf-esp
                    WHERE tt-grf-esp.cod-gr-forn  = grp_fornec.cod_grp_fornec
                      AND tt-grf-esp.cod-esp      = espec_docto_financ.cod_espec_docto NO-ERROR.
               IF NOT AVAIL tt-grf-esp THEN DO:
                  CREATE tt-grf-esp.
                  ASSIGN tt-grf-esp.cod-gr-forn  = grp_fornec.cod_grp_fornec
                         tt-grf-esp.cod-esp      = espec_docto_financ.cod_espec_docto.
               END.
               ASSIGN tt-grf-esp.de-implan    = tt-grf-esp.de-implan + de-esp-implan
                      tt-grf-esp.de-baixas    = tt-grf-esp.de-baixas + de-esp-baixas
                      tt-grf-esp.de-prz-cp    = tt-grf-esp.de-prz-cp + de-esp-prz-cp
                      tt-grf-esp.de-prz-pg    = tt-grf-esp.de-prz-pg + de-esp-prz-pg
                      tt-grf-esp.de-atr-pg    = tt-grf-esp.de-atr-pg + de-esp-atr-pg.
            END.
            ELSE DO:
               DISP SKIP(1)
                    "............................." AT 01 SPACE(0)
                    "............................... Totais Esp‚cie"
                    espec_docto_financ.cod_espec_docto
                    "--->"
                    "Valor das Implanta‡äes:"           AT 90
                    de-esp-implan
                    "Prz Medio Implanta‡äes:"           AT 90 SPACE(4)
                    de-esp-prz-cp / de-esp-implan FORMAT '->>9.99' "dias"
                    "      Valor das Baixas:"           AT 90
                    de-esp-baixas
                    "      Prz Medio Baixas:"           AT 90 SPACE(4)
                    de-esp-prz-pg / de-esp-baixas FORMAT '->>9.99' "dias"
                    "   Atraso M‚dio Baixas:"           AT 90 SPACE(4)
                    de-esp-atr-pg / de-esp-baixas FORMAT '->>9.99' "dias"
                    WITH WIDTH 150 NO-LABELS NO-BOX STREAM-IO FRAME f-tt-esp.
               PUT FILL("-",132) FORMAT "x(132)"       AT 01.
                
               ASSIGN de-grf-prz-cp = de-grf-prz-cp + de-esp-prz-cp
                      de-grf-implan = de-grf-implan + de-esp-implan
                      de-grf-prz-pg = de-grf-prz-pg + de-esp-prz-pg
                      de-grf-atr-pg = de-grf-atr-pg + de-esp-atr-pg 
                      de-grf-baixas = de-grf-baixas + de-esp-baixas.
            END.
    
            ASSIGN de-esp-prz-cp    = 0
                   de-esp-implan    = 0
                   de-esp-prz-pg    = 0
                   de-esp-atr-pg    = 0
                   de-esp-baixas    = 0.
         END. /* if */
      END. /* for each espec_docto_financ */
   
    
      IF (de-grf-implan > 0 OR de-grf-baixas > 0) AND c-tipo-relat = 'Detalhado' THEN DO:
         DISP SKIP(1)
              "..................................." AT 01 space(0)
              ".......................... Totais Grupo"
              grp_fornec.cod_grp_fornec
              "--->"
              "Valor das Implanta‡äes:"                 AT 90
              de-grf-implan 
              "Prz Medio Implanta‡äes:"                 AT 90 space(4)
              de-grf-prz-cp / de-grf-implan FORMAT "->>9.99" "dias"
              "      Valor das Baixas:"                 AT 90
              de-grf-baixas
              "      Prz M‚dio Baixas:"                 AT 90 space(4)
              de-grf-prz-pg / de-grf-baixas FORMAT "->>9.99" "dias"
              "   Atraso M‚dio Baixas:"                 AT 90 space(4)
              de-grf-atr-pg / de-grf-baixas FORMAT "->>9.99" "dias"
              WITH WIDTH 150 NO-LABELS NO-BOX STREAM-IO FRAME f-tt-grf.
         PUT FILL("-",132) FORMAT "x(132)"              AT 01.
    
         ASSIGN de-ger-prz-cp = de-ger-prz-cp + de-grf-prz-cp
                de-ger-implan = de-ger-implan + de-grf-implan
                de-ger-prz-pg = de-ger-prz-pg + de-grf-prz-pg
                de-ger-atr-pg = de-ger-atr-pg + de-grf-atr-pg
                de-ger-baixas = de-ger-baixas + de-grf-baixas
                de-grf-prz-cp = 0
                de-grf-implan = 0
                de-grf-prz-pg = 0
                de-grf-atr-pg = 0
                de-grf-baixas = 0.
    
      END. /* if  */
   END. /* for each grupo-fornec */
END. /* for each estabelecimento */
*/

IF (de-ger-implan > 0 OR de-ger-baixas > 0) AND c-tipo-relat = 'Detalhado' THEN DO:
   DISP SKIP(1)
        ".........................................." at 01 space(0)
        "....................... TOTAIS GERAIS"
        "--->"
        "Valor das Implanta‡äes:"                    at 90
        de-ger-implan
        "Prz M‚dio Implanta‡äes:"                    at 90 space(4)
        de-ger-prz-cp / de-ger-implan format "->>9.99" "dias"
        "      Valor das Baixas:"                    at 90
        de-ger-baixas
        "      Prz M‚dio Baixas:"                    at 90 space(4)
        de-ger-prz-pg / de-ger-baixas format "->>9.99" "dias"
        "   Atraso M‚dio Baixas:"                    at 90 space(4)
        de-ger-atr-pg / de-ger-baixas format "->>9.99" "dias"
        WITH WIDTH 150 NO-LABELS NO-BOX STREAM-IO FRAME f-tt-ger.
   PUT FILL("-",132) FORMAT "x(132)"                 at 01.
   PAGE.

   ASSIGN de-ger-prz-cp = 0
          de-ger-implan = 0
          de-ger-prz-pg = 0
          de-ger-atr-pg = 0
          de-ger-baixas = 0.
END.

IF c-tipo-relat = 'Resumido' THEN DO WITH FRAME f-resumo:
   FOR EACH tt-grf-esp,
      FIRST grp_fornec NO-LOCK
      WHERE grp_fornec.cod_grp_fornec = tt-grf-esp.cod-gr-forn,
      FIRST espec_docto_financ NO-LOCK
      WHERE espec_docto_financ.cod_espec_docto = tt-grf-esp.cod-esp
      BREAK BY int(tt-grf-esp.cod-gr-forn)
            BY tt-grf-esp.cod-esp:
      FIND FIRST emsuni.espec_docto OF espec_docto_financ NO-ERROR.

      ASSIGN de-grf-prz-cp = de-grf-prz-cp       + tt-grf-esp.de-prz-cp
             de-grf-implan = de-grf-implan       + tt-grf-esp.de-implan
             de-grf-prz-pg = de-grf-prz-pg       + tt-grf-esp.de-prz-pg
             de-grf-atr-pg = de-grf-atr-pg       + tt-grf-esp.de-atr-pg
             de-grf-baixas = de-grf-baixas       + tt-grf-esp.de-baixas
             de-res-prz-c  = tt-grf-esp.de-prz-cp / tt-grf-esp.de-implan
             de-res-prz-p  = tt-grf-esp.de-prz-pg / tt-grf-esp.de-baixas
             de-res-atr-p  = tt-grf-esp.de-atr-pg / tt-grf-esp.de-baixas.
      
      DISP tt-grf-esp.cod-gr-forn                      when first-of(int(tt-grf-esp.cod-gr-forn))
           grp_fornec.des_grp_fornec   format "x(29)" when first-of(int(tt-grf-esp.cod-gr-forn))
           tt-grf-esp.cod-esp                          /* when first-of(tt-grf-esp.cod-esp)      */
           emsuni.espec_docto.des_espec_docto format "x(20)" /* when first-of(tt-grf-esp.cod-esp)      */
/*            c-pipe[1]              column-label "|"  */
           tt-grf-esp.de-implan    column-label "Valor"        FORMAT "->>>,>>>,>>9.99"
           de-res-prz-c           column-label "Prazo M‚dio"  
           c-pipe[2]              column-label "|" 
           tt-grf-esp.de-baixas    column-label "Valor"        FORMAT "->>>,>>>,>>9.99"
           de-res-prz-p           column-label "Prazo M‚dio"
           de-res-atr-p           column-label "Atraso M‚dio" 
/*            c-pipe[3]              column-label "|"  */
           WITH WIDTH 150 DOWN NO-BOX STREAM-IO FRAME f-resumo.
      DOWN WITH FRAME f-resumo.

      IF LAST-OF(int(tt-grf-esp.cod-gr-forn)) THEN DO:
         UNDERLINE tt-grf-esp.de-implan
                   de-res-prz-c
                   tt-grf-esp.de-baixas
                   de-res-prz-p
                   de-res-atr-p
                   WITH FRAME f-resumo.
         DISP "TOTAIS DO GRUPO"             @ grp_fornec.des_grp_fornec
              de-grf-implan                 @ tt-grf-esp.de-implan
              de-grf-prz-cp / de-grf-implan @ de-res-prz-c
              de-grf-baixas                 @ tt-grf-esp.de-baixas
              de-grf-prz-pg / de-grf-baixas @ de-res-prz-p
              de-grf-atr-pg / de-grf-baixas @ de-res-atr-p 
              WITH STREAM-IO FRAME f-resumo.
         DOWN WITH FRAME f-resumo.

         PUT SKIP(1).

         ASSIGN de-ger-implan = de-ger-implan + de-grf-implan
                de-ger-prz-cp = de-ger-prz-cp + de-grf-prz-cp
                de-ger-baixas = de-ger-baixas + de-grf-baixas
                de-ger-prz-pg = de-ger-prz-pg + de-grf-prz-pg
                de-ger-atr-pg = de-ger-atr-pg + de-grf-atr-pg
                de-grf-implan = 0
                de-grf-prz-cp = 0
                de-grf-baixas = 0
                de-grf-prz-pg = 0
                de-grf-atr-pg = 0.
      END. /* if last-of */
   END.  /* for each tt-grf-esp */

   PUT FILL("-",132) FORMAT "x(132)"                 AT 01 SKIP(1).
     
   DISP "TOTAIS GERAIS"                @ grp_fornec.des_grp_fornec
         de-ger-implan                 @ tt-grf-esp.de-implan
         de-ger-prz-cp / de-ger-implan @ de-res-prz-c
         de-ger-baixas                 @ tt-grf-esp.de-baixas
         de-ger-prz-pg / de-ger-baixas @ de-res-prz-p
         de-ger-atr-pg / de-ger-baixas @ de-res-atr-p 
         WITH STREAM-IO FRAME f-resumo.
   DOWN WITH FRAME f-resumo.
     
   FOR EACH tt-grf-esp. 
      DELETE tt-grf-esp. 
   END.

   ASSIGN de-ger-implan = 0
          de-ger-prz-cp = 0
          de-ger-baixas = 0
          de-ger-prz-pg = 0
          de-ger-atr-pg = 0.
END. /* if c-tipo-relat = 'Resumido' */ 

/* dap004rp.i */
