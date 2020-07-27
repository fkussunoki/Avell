/*******************************************************************************
** Include: doc019rpa.i
**  Fun‡Æo: Gera base de contabiliza‡Æo dos encargos
*******************************************************************************/

ON FIND OF funcionario OVERRIDE DO:
END.
   
DEFINE VARIABLE de-fgts                AS DEC  NO-UNDO. 
DEFINE VARIABLE de-332                 AS DEC  NO-UNDO. 
DEFINE VARIABLE de-base-encarg         AS DEC  NO-UNDO.
DEFINE VARIABLE de-base-est-inss       AS DEC  NO-UNDO.
DEFINE VARIABLE de-base-est-fgts       AS DEC  NO-UNDO.
DEFINE VARIABLE i-tot-funcion          AS INT  NO-UNDO.
DEFINE VARIABLE de-base-benef          AS DEC  NO-UNDO.
DEFINE VARIABLE de-total-benef         AS DEC  NO-UNDO.

DEF TEMP-TABLE tt-cc-mdo NO-UNDO
                          FIELD cod-rh-ccusto AS CHAR
                          FIELD cod-tip-mdo   AS CHAR
                          FIELD qtd-func      AS INT
                          FIELD tot-salar-nom AS DEC
                          INDEX prim cod-rh-ccusto
                                     cod-tip-mdo.

DEF TEMP-TABLE tt-eventos NO-UNDO
                          FIELD cod-rh-ccusto AS CHAR
                          FIELD cod-tip-mdo   AS CHAR
                          FIELD cdn-event-fp  AS CHAR
                          FIELD valor-evento  AS DEC
                          FIELD base-inss     AS DEC
                          FIELD base-fgts     AS DEC
                          INDEX prim cod-rh-ccusto
                                     cod-tip-mdo
                                     cdn-event-fp
                          INDEX evento cdn-event-fp.

IF CONNECTED('dthrpyc') THEN DO:

   RUN pi-inicializar IN h-acomp (INPUT "Lendo Informa‡äes dos Funcion rios").
    
   ASSIGN i-tot-funcion = 0.
   
   FOR EACH funcionario NO-LOCK
      WHERE funcionario.cdn_empresa = trad_org_ext.cod_unid_organ_ext:

      IF funcionario.idi_orig_contratac_func <> 1 THEN NEXT.
      IF funcionario.idi_tip_func             = 2 THEN NEXT. /* Estagi rio */
      IF funcionario.idi_tip_func             = 7 THEN NEXT. /* Aprendizes */


      IF funcionario.dat_admis_func     > da-corte THEN NEXT.

      IF funcionario.dat_desligto_func  = ?          OR 
         funcionario.dat_desligto_func  >= date(month(da-corte),1,year(da-corte)) THEN DO:

         FIND LAST func_ccusto OF funcionario NO-LOCK
              WHERE func_ccusto.dat_inic_lotac_func <= da-corte NO-ERROR.
         IF NOT AVAIL func_ccusto THEN NEXT.
         FIND LAST func_tip_mdo OF funcionario NO-LOCK
              WHERE func_tip_mdo.dat_inic_lotac_func <= da-corte NO-ERROR.
         IF NOT AVAIL func_tip_mdo THEN NEXT.
         FIND LAST histor_sal_func OF funcionario NO-LOCK
             WHERE histor_sal_func.dat_liber_sal <= da-corte NO-ERROR.

         RUN pi-acompanhar IN h-acomp ("Funcion rio " + STRING(funcionario.cdn_funcionario)).
              
         FIND FIRST tt-cc-mdo USE-INDEX prim
              WHERE tt-cc-mdo.cod-rh-ccusto = func_ccusto.cod_rh_ccusto
                AND tt-cc-mdo.cod-tip-mdo   = func_tip_mdo.cod_tip_mdo NO-ERROR.
         IF NOT AVAIL tt-cc-mdo THEN DO:
            CREATE tt-cc-mdo.
            ASSIGN tt-cc-mdo.cod-rh-ccusto = func_ccusto.cod_rh_ccusto
                   tt-cc-mdo.cod-tip-mdo   = func_tip_mdo.cod_tip_mdo.
         END.

         /* Chamado 57563 - Foi movido o if abaixo para este ponto para que a tabela tt-cc-mdo fosse criada para 
                            os centros de custo que ficaram sem nenhum funcionario ativo. Nestes casos estava
                            dando diferen‡a no valor do encargo, visto que o programa ignorava estes funcion rios 
                            na hora de gerar a base */
         IF funcionario.dat_desligto_func  = ?          OR 
            funcionario.dat_desligto_func  > da-corte THEN DO:
             ASSIGN tt-cc-mdo.qtd-func = tt-cc-mdo.qtd-func + 1
                    i-tot-funcion           = i-tot-funcion           + 1
                    tt-cc-mdo.tot-salar-nom = tt-cc-mdo.tot-salar-nom + histor_sal_func.val_salario_mensal.
         END.
      END.
      

      
      ASSIGN de-fgts = 0
             de-332  = 0.

      FOR EACH movto_calcul_func OF funcionario NO-LOCK
         WHERE movto_calcul_func.num_mes_refer_fp         = i-mes
           AND movto_calcul_func.num_ano_refer_fp         = i-ano
           AND movto_calcul_func.idi_tip_fp               = 1
           AND movto_calcul_func.qti_parc_habilit_calc_fp = 9.

         DO i-cont = 1 TO movto_calcul_func.qti_efp:  
            FIND FIRST event_fp NO-LOCK
                 WHERE event_fp.cdn_empresa  = '*'
                 AND   event_fp.cdn_event_fp = string(movto_calcul_func.cdn_event_fp[i-cont]) NO-ERROR.
            FIND FIRST tt-eventos USE-INDEX prim
                 WHERE tt-eventos.cod-rh-ccusto = funcionario.cod_rh_ccusto
                   AND tt-eventos.cod-tip-mdo   = funcionario.cod_tip_mdo
                   AND tt-eventos.cdn-event-fp  = movto_calcul_func.cdn_event_fp[i-cont] NO-ERROR.
      
            IF NOT AVAIL tt-eventos THEN DO:
               CREATE tt-eventos.
               ASSIGN tt-eventos.cod-rh-ccusto = funcionario.cod_rh_ccusto
                      tt-eventos.cod-tip-mdo   = funcionario.cod_tip_mdo
                      tt-eventos.cdn-event-fp  = movto_calcul_func.cdn_event_fp[i-cont].
            END.
            ASSIGN tt-eventos.valor-evento     = tt-eventos.valor-evento + movto_calcul_func.val_calcul_efp[i-cont].
      
            /* Verifica se existe base FGTS ou
                        se existe evento de gratificacao 
                        (caso de rescisao com gratificacao) */
            IF LOOKUP(STRING(movto_calcul_func.cdn_event_fp[i-cont]),"531,532,533,534,535,536,542,543,544,551,552") <> 0 THEN
               ASSIGN de-fgts = de-fgts + movto_calcul_func.val_calcul_efp[i-cont].
            IF movto_calcul_func.cdn_event_fp[i-cont]    = "332" THEN
               ASSIGN de-332 = movto_calcul_func.val_calcul_efp[i-cont].
            /* Fim Verifica base FGTS */

            IF event_fp.idi_tip_inciden_inss = 1     OR
               event_fp.cdn_event_fp         = "161" THEN /* Sal Mater INSS */
               ASSIGN tt-eventos.base-inss = tt-eventos.base-inss + movto_calcul_func.val_calcul_efp[i-cont].
            IF event_fp.idi_tip_inciden_inss = 2   THEN
               ASSIGN tt-eventos.base-inss = tt-eventos.base-inss - movto_calcul_func.val_calcul_efp[i-cont].
         END.   
      END. 
      
      /* Base FGTS */

      IF de-fgts = 0 AND de-332 = 0 THEN NEXT.
       
      FOR EACH movto_calcul_func OF funcionario NO-LOCK
         WHERE movto_calcul_func.num_mes_refer_fp         = i-mes
           AND movto_calcul_func.num_ano_refer_fp         = i-ano
           AND movto_calcul_func.idi_tip_fp               = 1
           AND movto_calcul_func.qti_parc_habilit_calc_fp = 9.

         DO i-cont = 1 TO movto_calcul_func.qti_efp:  

            FIND FIRST event_fp NO-LOCK
                 WHERE event_fp.cdn_empresa  = '*'
                 AND   event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i-cont] NO-ERROR.
            
            FIND FIRST tt-eventos USE-INDEX prim
                 WHERE tt-eventos.cod-rh-ccusto = funcionario.cod_rh_ccusto
                   AND tt-eventos.cod-tip-mdo   = funcionario.cod_tip_mdo
                   AND tt-eventos.cdn-event-fp  = movto_calcul_func.cdn_event_fp[i-cont] NO-ERROR.
            
            IF event_fp.idi_tip_inciden_fgts           > 2      OR
              (de-fgts                                 = 0     AND
               movto_calcul_func.cdn_event_fp[i-cont] <> "332") THEN NEXT.
                       
            IF event_fp.idi_tip_inciden_fgts = 1 THEN
               ASSIGN tt-eventos.base-fgts = tt-eventos.base-fgts + movto_calcul_func.val_calcul_efp[i-cont].
            IF event_fp.idi_tip_inciden_fgts = 2 THEN
               ASSIGN tt-eventos.base-fgts = tt-eventos.base-fgts - movto_calcul_func.val_calcul_efp[i-cont].
         END.
      END.                     
   END.

   /* Gerar Base de Encargos */
   FOR EACH rh-encargo NO-LOCK WHERE
            rh-encargo.cdn-encargo >= 0:
      RUN pi-acompanhar IN h-acomp ("Gerando Base Encargo " + rh-encargo.des-encargo).

      IF rh-encargo.tipo = "Beneficio" AND
         rh-encargo.log-tipo-valor     AND
         rh-encargo.perc-encarg <> 0  THEN DO: /* Percentual */
         ASSIGN de-base-benef  = 0
                de-total-benef = 0.
         FOR EACH estrut_efp NO-LOCK
            WHERE estrut_efp.cod_event_sint = string(rh-encargo.cdn-base-encarg),
             EACH tt-eventos NO-LOCK
            WHERE tt-eventos.cdn-event-fp  = estrut_efp.cdn_efp_det.
            ASSIGN de-base-benef = de-base-benef + tt-eventos.valor-evento.
         END.
         IF rh-encargo.log-sal-nom-base THEN DO:
            FOR EACH tt-cc-mdo NO-LOCK.
                ASSIGN de-base-benef = de-base-benef + tt-cc-mdo.tot-salar-nom.
            END.
         END.
         ASSIGN de-total-benef = de-base-benef * rh-encargo.perc-encarg / 100.
      END.

      FOR EACH tt-cc-mdo.
         IF rh-encargo.log-tipo-valor THEN DO: /* Percentual */
            ASSIGN de-base-encarg = 0.
            FOR EACH estrut_efp NO-LOCK
               WHERE estrut_efp.cod_event_sint = string(rh-encargo.cdn-base-encarg),
               FIRST tt-eventos NO-LOCK
               WHERE tt-eventos.cod-rh-ccusto = tt-cc-mdo.cod-rh-ccusto
                 AND tt-eventos.cod-tip-mdo   = tt-cc-mdo.cod-tip-mdo
                 AND tt-eventos.cdn-event-fp  = estrut_efp.cdn_efp_det.
               ASSIGN de-base-encarg = de-base-encarg + tt-eventos.valor-evento.
            END.
            IF rh-encargo.perc-encarg <> 0 THEN DO:
               IF rh-encargo.tipo <> "Beneficio" THEN DO:
                  IF rh-encargo.log-sal-nom-base THEN
                     ASSIGN de-base-encarg = de-base-encarg + tt-cc-mdo.tot-salar-nom.
                  CREATE rh-mov-encarg.
                  ASSIGN rh-mov-encarg.cdn-empresa     = INT(trad_org_ext.cod_unid_organ_ext)
                         rh-mov-encarg.mes-fp          = i-mes
                         rh-mov-encarg.ano-fp          = i-ano
                         rh-mov-encarg.cod-rh-ccusto   = tt-cc-mdo.cod-rh-ccusto
                         rh-mov-encarg.cod-tip-mdo     = tt-cc-mdo.cod-tip-mdo
                         rh-mov-encarg.cdn-encargo     = rh-encargo.cdn-encargo
                         rh-mov-encarg.vl-base-encarg  = de-base-encarg
                         rh-mov-encarg.vl-encarg       = rh-mov-encarg.vl-base-encarg * rh-encargo.perc-encarg / 100.
               END. /* if rh-encargo.tipo <> "Beneficio" */
               ELSE DO:
                   /* Tratamento para quando o centro de custo estiver sem nenhum funcion rio ativo , mas precisar ratear o valor dos encargos */
                   IF tt-cc-mdo.qtd-func > 0 THEN DO:
                      CREATE rh-mov-encarg.
                      ASSIGN rh-mov-encarg.cdn-empresa    = INT(trad_org_ext.cod_unid_organ_ext)
                             rh-mov-encarg.mes-fp         = i-mes
                             rh-mov-encarg.ano-fp         = i-ano
                             rh-mov-encarg.cod-rh-ccusto  = tt-cc-mdo.cod-rh-ccusto
                             rh-mov-encarg.cod-tip-mdo    = tt-cc-mdo.cod-tip-mdo
                             rh-mov-encarg.cdn-encargo    = rh-encargo.cdn-encargo
                             rh-mov-encarg.vl-base-encarg = de-base-encarg
                             rh-mov-encarg.vl-encarg      = de-total-benef / i-tot-funcion * tt-cc-mdo.qtd-func
                             rh-mov-encarg.vl-estorno     = tt-cc-mdo.qtd-func.
                   END.
               END. /* if rh-encargo.tipo = "Beneficio" */
            END. /* if rh-encargo.perc-encarg <> 0 */
         END. /* Percentual */
         ELSE DO: /* Unitario */
            IF rh-encargo.vl-un-encarg <> 0 AND tt-cc-mdo.qtd-func > 0 /* Tratamento para quando o centro de custo estiver sem nenhum funcion rio ativo , mas precisar ratear o valor dos encargos */ THEN DO:
               CREATE rh-mov-encarg.
               ASSIGN rh-mov-encarg.cdn-empresa   = INT(trad_org_ext.cod_unid_organ_ext)
                      rh-mov-encarg.mes-fp        = i-mes
                      rh-mov-encarg.ano-fp        = i-ano
                      rh-mov-encarg.cod-rh-ccusto = tt-cc-mdo.cod-rh-ccusto
                      rh-mov-encarg.cod-tip-mdo   = tt-cc-mdo.cod-tip-mdo
                      rh-mov-encarg.cdn-encargo   = rh-encargo.cdn-encargo
                      rh-mov-encarg.vl-encarg     = rh-encargo.vl-un-encarg * tt-cc-mdo.qtd-func
                      rh-mov-encarg.vl-estorno    = tt-cc-mdo.qtd-func.
            END. /* if rh-encargo.vl-un-encarg <> 0 */
         END. /* Unit rio */

         IF rh-encargo.estorna-fgts-inss THEN DO:
            ASSIGN de-base-est-fgts = 0
                   de-base-est-inss = 0.
            FOR EACH estrut_efp NO-LOCK
               WHERE estrut_efp.cod_event_sint = string(rh-encargo.cdn-base-estorn),
               FIRST tt-eventos NO-LOCK
               WHERE tt-eventos.cod-rh-ccusto = tt-cc-mdo.cod-rh-ccusto
                 AND tt-eventos.cod-tip-mdo   = tt-cc-mdo.cod-tip-mdo
                 AND tt-eventos.cdn-event-fp  = estrut_efp.cdn_efp_det.
               ASSIGN de-base-est-fgts = de-base-est-fgts + tt-eventos.base-fgts
                      de-base-est-inss = de-base-est-inss + tt-eventos.base-inss.  
            END. /* for each estrut_efp */
            FIND FIRST rh-mov-encarg
                 WHERE rh-mov-encarg.cdn-empresa     = INT(trad_org_ext.cod_unid_organ_ext)
                   AND rh-mov-encarg.mes-fp          = i-mes
                   AND rh-mov-encarg.ano-fp          = i-ano
                   AND rh-mov-encarg.cod-rh-ccusto   = tt-cc-mdo.cod-rh-ccusto
                   AND rh-mov-encarg.cod-tip-mdo     = tt-cc-mdo.cod-tip-mdo
                   AND rh-mov-encarg.cdn-encargo     = rh-encargo.cdn-encargo NO-ERROR.
            IF NOT AVAIL rh-mov-encarg THEN DO:
               CREATE rh-mov-encarg.
               ASSIGN rh-mov-encarg.cdn-empresa     = INT(trad_org_ext.cod_unid_organ_ext)
                      rh-mov-encarg.mes-fp          = i-mes
                      rh-mov-encarg.ano-fp          = i-ano
                      rh-mov-encarg.cod-rh-ccusto   = tt-cc-mdo.cod-rh-ccusto
                      rh-mov-encarg.cod-tip-mdo     = tt-cc-mdo.cod-tip-mdo
                      rh-mov-encarg.cdn-encargo     = rh-encargo.cdn-encargo.
            END.
            ASSIGN rh-mov-encarg.vl-base-inss    = de-base-est-inss
                   rh-mov-encarg.vl-base-fgts    = de-base-est-fgts
                   rh-mov-encarg.vl-estorno      = (rh-mov-encarg.vl-base-inss * rh-encargo.perc-est-inss / 100) +
                                                   (rh-mov-encarg.vl-base-fgts * rh-encargo.perc-est-fgts / 100).
         END. /* if rh-encargo.estorna-fgts-inss */
      END. /* for each tt-cc-mdo */
   END. /* for each rh-encargo */
   &if "{&bf_mat_versao_ems}" = "2.062" &then
       DISCON dthrpyc no-error.
   &endif
END.

/* doc019rpa.i */
