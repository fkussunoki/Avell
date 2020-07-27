/*-------------------------------------------------------------------------------------------------
 * Objetivo: Lancar para fins de Orcamentos os Valores
 *           de Servicos (M∆o-de-Obra de Terceiros)
 *
 * Em conversa com a Sra Marilza (custos) os valores de Servico 
 * que contabilizam contra a Ordem de Produá∆o devem
 * aparecer no Balancete nas Contas de Orcamento.
 * => Alguns valores de Servicos s∆o lancados pelo Recebimento contra
 *    a Ordem de Produá∆o
 * => Alguns valores de Servicos s∆o lancados numa conta de Despesa e depois
 *    s∆o rateados pelo programa DRE013R (Rotina Especifica para Tratamento da M∆o-Obra do CRT)
 *
 * Estes dois tipos de lancamentos devem ser contabilizados
 * Eduardo da Silva
 *
 *-----------------------------------------------------------------------------------------------*/
DEF VAR l-movto AS LOG INITIAL NO.

IF tg-gera-contabil THEN DO:
    FIND FIRST plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.dat_inic_valid        <= TODAY          
          AND plano_cta_ctbl.dat_fim_valid         >= TODAY 
          AND plano_cta_ctbl.ind_tip_plano_cta_ctbl = 'Prim†rio' NO-ERROR.
    FIND FIRST histor_finalid_econ NO-LOCK 
        WHERE histor_finalid_econ.cod_finalid_econ       = 'Corrente' 
          AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
          AND histor_finalid_econ.dat_fim_valid_finalid  >= TODAY NO-ERROR.
    FIND FIRST plano_ccusto NO-LOCK USE-INDEX plnccst_id
        WHERE plano_ccusto.cod_empresa      = empresa.cod_empresa 
        AND   plano_ccusto.dat_inic_valid  <= TODAY
        AND   plano_ccusto.dat_fim_valid   >= TODAY NO-ERROR.
END.

/* Movimentos Contabilizados pelo programa dre013rp.p */
RUN pi-acompanhar IN h-acomp ('Lendo movtos gerados pelo DRE013R').

FOR EACH movto-estoq NO-LOCK
   WHERE movto-estoq.dt-trans                           = dt-periodo-fin
     AND movto-estoq.ct-codigo                          = ct-deb-despesa
     AND movto-estoq.sc-codigo                          = sc-deb-despesa
    /* AND movto-estoq.conta-contabil                     = STRING(ct-deb-despesa + sc-deb-despesa) */
     AND movto-estoq.esp-docto                          = 6    /*  DIV   */ 
     AND movto-estoq.cod-depos                          = "DD"
  /* AND movto-estoq.serie-docto                        = "TERC"  */
     AND movto-estoq.serie-docto BEGINS "TER"
     AND LOOKUP(movto-estoq.cod-estabel,c-lista-cod-estab) <> 0.

   FIND tt-resumido EXCLUSIVE-LOCK 
        WHERE tt-resumido.cod_empresa = v_cod_empres_usuar
          AND tt-resumido.cod-estabel = movto-estoq.cod-estabel               
          AND tt-resumido.ct-codigo   = ct-deb-despesa         
          AND tt-resumido.cc-codigo   = sc-deb-despesa no-error.
   IF NOT AVAIL tt-resumido THEN DO:
      CREATE tt-resumido.
      ASSIGN tt-resumido.cod_empresa = v_cod_empres_usuar
             tt-resumido.cod-estabel = movto-estoq.cod-estabel          
             tt-resumido.ct-codigo   = ct-deb-despesa            
             tt-resumido.cc-codigo   = sc-deb-despesa.
   END.
   if movto-estoq.tipo-trans = 1 then
      assign tt-resumido.total-nota = tt-resumido.total-nota + movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1].
   else
      ASSIGN tt-resumido.total-nota = tt-resumido.total-nota - movto-estoq.valor-mat-m[1] - movto-estoq.valor-mob-m[1] - movto-estoq.valor-ggf-m[1].
   
   if rt-tipo-relat = 2 then do:
      create tt-desp.
      assign tt-desp.ep-codigo    = v_cod_empres_usuar
             tt-desp.cod-estabel  = movto-estoq.cod-estabel
             tt-desp.ct-codigo    = ct-deb-despesa    
             tt-desp.sc-codigo    = sc-deb-despesa
             tt-desp.dt-trans     = movto-estoq.dt-trans
             tt-desp.nr-ord-prod  = int(movto-estoq.nro-docto)
             tt-desp.nro-docto    = 'DRE013R'
             tt-desp.valor-mat    =  if movto-estoq.tipo-trans = 1
                                        then (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1])  
                                        else (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) * - 1.
   END.
END.
/* FIM-Movimentos Contabilizados pelo programa dre013rp.p */

FOR EACH emsuni.estabelecimento NO-LOCK
    WHERE emsuni.estabelecimento.cod_empresa = c-cod-empresa 
      AND LOOKUP(emsuni.estabelecimento.cod_estab,c-lista-cod-estab) > 0:   

    IF tg-gera-contabil THEN
        FIND FIRST plano_ccusto NO-LOCK USE-INDEX plnccst_id
             WHERE plano_ccusto.cod_empresa      = emsuni.estabelecimento.cod_empresa 
               AND plano_ccusto.dat_inic_valid  <= TODAY
               AND plano_ccusto.dat_fim_valid   >= TODAY NO-ERROR.

    RUN pi-acompanhar IN h-acomp (INPUT 'Lendo NFE Estabelecimento ' + emsuni.estabelecimento.cod_estab).

    FOR EACH docum-est 
       WHERE docum-est.dt-trans     >= dt-periodo-ini
         AND docum-est.dt-trans     <= dt-periodo-fin
         AND docum-est.cod-estabel   = estabelecimento.cod_estab
         AND docum-est.nat-operacao >= c-natureza-ini
         AND docum-est.nat-operacao <= c-natureza-fin
         AND docum-est.ce-atual use-index est-origem no-lock:

/*        L‡GICA SUBSTITUIDA PELA LEITURA DO MOVTO-ESTOQ GERADO PELO PROGRAMA DRE013R (ACIMA )       */
/*                                                                                                   */
/*        find first crt-processo-ben                                                                */
/*             where crt-processo-ben.serie-docto    = docum-est.serie-docto                         */
/*               AND crt-processo-ben.nro-docto      = docum-est.nro-docto                           */
/*               AND crt-processo-ben.cod-emit       = docum-est.cod-emit                            */
/*               AND crt-processo-ben.nat-operacao   = docum-est.nat-operacao                        */
/*               AND crt-processo-ben.estoq-atual    = yes   no-lock no-error.                       */
/*                                                                                                   */
/*        IF AVAIL crt-processo-ben then do:                                                         */
/*           FIND tt-resumido EXCLUSIVE-LOCK                                                         */
/*                WHERE tt-resumido.cod_empresa = emsuni.estabelecimento.cod_empresa                 */
/*                  AND tt-resumido.cod-estabel = docum-est.cod-estabel                              */
/*                  AND tt-resumido.ct-codigo   = ct-deb-despesa                                     */
/*                  AND tt-resumido.cc-codigo   = sc-deb-despesa no-error.                           */
/*           IF NOT AVAIL tt-resumido THEN DO:                                                       */
/*              CREATE tt-resumido.                                                                  */
/*              ASSIGN tt-resumido.cod_empresa = emsuni.estabelecimento.cod_empresa                  */
/*                     tt-resumido.cod-estabel = docum-est.cod-estabel                               */
/*                     tt-resumido.ct-codigo   = ct-deb-despesa                                      */
/*                     tt-resumido.cc-codigo   = sc-deb-despesa.                                     */
/*           END.                                                                                    */
/*                                                                                                   */
/*           ASSIGN tt-resumido.total-nota = tt-resumido.total-nota + crt-processo-ben.vl-ord-prod.  */
/*        END.                                                                                       */

       for each item-doc-est of docum-est 
          where item-doc-est.nr-ord-prod ne 0 no-lock:
          for each movto-estoq
             where movto-estoq.it-codigo    = item-doc-est.it-codigo
               and movto-estoq.cod-estabel  = docum-est.cod-estabel 
               and movto-estoq.dt-trans     = docum-est.dt-trans    
               and movto-estoq.cod-emitente = docum-est.cod-emitente
               and movto-estoq.nat-operacao = docum-est.nat-operacao
               and movto-estoq.cod-depos    = item-doc-est.cod-depos
               and movto-estoq.serie-docto  = docum-est.serie-docto
               and movto-estoq.nro-docto    = docum-est.nro-docto
               and movto-estoq.sequen-nf    = item-doc-est.sequencia
               and movto-estoq.tipo-trans   = 2 no-lock:

             find item where item.it-codigo = movto-estoq.it-codigo no-lock.

             FIND tt-resumido EXCLUSIVE-LOCK 
                  WHERE tt-resumido.cod_empresa = emsuni.estabelecimento.cod_empresa                 
                    AND tt-resumido.cod-estabel = movto-estoq.cod-estabel               
                    AND tt-resumido.ct-codigo   = ct-deb-despesa         
                    AND tt-resumido.cc-codigo   = sc-deb-despesa no-error.
             IF NOT AVAIL tt-resumido THEN DO:
                CREATE tt-resumido.
                ASSIGN tt-resumido.cod_empresa = emsuni.estabelecimento.cod_empresa            
                       tt-resumido.cod-estabel = movto-estoq.cod-estabel          
                       tt-resumido.ct-codigo   = ct-deb-despesa            
                       tt-resumido.cc-codigo   = sc-deb-despesa.
             END.
             if movto-estoq.tipo-trans = 2 then
                assign tt-resumido.total-nota = tt-resumido.total-nota + movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1].
             else
                ASSIGN tt-resumido.total-nota = tt-resumido.total-nota - movto-estoq.valor-mat-m[1] - movto-estoq.valor-mob-m[1] - movto-estoq.valor-ggf-m[1].
                       
             if rt-tipo-relat = 2 then do:
                create tt-desp.
                assign tt-desp.ep-codigo    = estabelecimento.cod_empresa
                       tt-desp.cod-estabel  = movto-estoq.cod-estabel
                       tt-desp.ct-codigo    = ct-deb-despesa    
                       tt-desp.sc-codigo    = sc-deb-despesa
                       tt-desp.cod-emit     = movto-estoq.cod-emit 
                       tt-desp.serie-docto  = movto-estoq.serie-docto
                       tt-desp.dt-trans     = movto-estoq.dt-trans
                       tt-desp.nr-ord-prod  = item-doc-est.nr-ord-prod
                       tt-desp.nat-operacao = movto-estoq.nat-operacao
                       tt-desp.nro-docto    = movto-estoq.nro-docto
                       tt-desp.valor-mat    =  if movto-estoq.tipo-trans = 2
                                                  then (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1])  
                                                  else (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) * - 1.
             end.
          end. /* movto-estoq */
       end. /* item-doc-est */
    end. /* docum-est */
end. /* estabel */

IF rt-tipo-relat = 2 THEN DO: /*Detalhado*/   
   HIDE FRAME f-f-laberes.
   FOR EACH tt-desp NO-LOCK
      BREAK BY tt-desp.ep-codigo 
            BY tt-desp.cod-estabel 
            BY tt-desp.cod-emit   
            BY tt-desp.serie-docto 
            BY tt-desp.nro-docto
            BY tt-desp.nat-operacao
            BY tt-desp.nr-ord-prod:

      DISP tt-desp.ep-codigo      
           tt-desp.cod-estabel    
           tt-desp.ct-codigo      
           tt-desp.sc-codigo      
           tt-desp.cod-emit       
           tt-desp.serie-docto    
           tt-desp.nro-docto 
           tt-desp.nat-operacao
           tt-desp.dt-trans
           tt-desp.nr-ord-prod
           tt-desp.valor-mat      COLUMN-LABEL "Valor Desp." FORMAT "->>>,>>>,>>9.99" WITH STREAM-IO FRAME f-detalhado.
      DOWN WITH FRAME f-detalhado.
       
      ACCUMULATE tt-desp.valor-mat (TOTAL BY tt-desp.ep-codigo BY tt-desp.cod-estabel BY tt-desp.cod-emit).

      IF LAST-OF(tt-desp.cod-emit) THEN DO:
         UNDERLINE tt-desp.valor-mat WITH FRAME f-detalhado.
         DOWN WITH FRAME f-detalhado.
         DISP "Total Emitente" @ tt-desp.sc-codigo (ACCUM TOTAL BY tt-desp.cod-emit  tt-desp.valor-mat) @ tt-desp.valor-mat               
              WITH FRAME f-detalhado.
         DOWN WITH FRAME f-detalhado.
      END.

      IF LAST-OF(tt-desp.cod-estabel) THEN DO: /* ultimo Estabel. */
         UNDERLINE tt-desp.valor-mat WITH FRAME f-detalhado.
         DOWN WITH FRAME f-detalhado.
         DISP "Total Est." @ tt-desp.sc-codigo (ACCUM TOTAL BY tt-desp.cod-estabel tt-desp.valor-mat) @ tt-desp.valor-mat            
              WITH FRAME f-detalhado.
         DOWN WITH FRAME f-detalhado.
      END.

      IF LAST-OF(tt-desp.ep-codigo) THEN DO: /* ultima Empresa */
         UNDERLINE tt-desp.valor-mat WITH FRAME f-detalhado.
         DOWN WITH FRAME f-detalhado.
         DISP "Total Emp." @ tt-desp.sc-codigo (ACCUM TOTAL BY tt-desp.ep-codigo tt-desp.valor-mat) @ tt-desp.valor-mat 
              WITH FRAME f-detalhado.
      END.
   END. /* for each tt-desp ... */
END. /* if detalhado */
ELSE DO: /*Resumido*/    
   FOR EACH tt-resumido
      BREAK BY tt-resumido.cod_empresa
            BY tt-resumido.cod-estabel
            BY tt-resumido.cc-codigo
            BY tt-resumido.ct-codigo:

      DISP tt-resumido.cod_empresa
           tt-resumido.cod-estabel               
           tt-resumido.cc-codigo
           tt-resumido.total-nota WITH STREAM-IO FRAME f-resumido. 
      DOWN WITH FRAME f-resumido.
   END.
END. /* else do: if Resumido */

IF tg-gera-contabil THEN DO:
   FOR EACH tt-resumido NO-LOCK
      BREAK BY tt-resumido.cod_empresa
            BY tt-resumido.cod-estabel  
            BY tt-resumido.cc-codigo:
    
      IF FIRST-OF(tt-resumido.cod-estabel) THEN 
          RUN pi-gera-contabilizacao(INPUT 'lote', INPUT '').
          
      IF  FIRST-OF(tt-resumido.cc-codigo) THEN DO:
          ASSIGN i-sequencia = i-sequencia + 10.
          RUN pi-gera-contabilizacao(INPUT 'itens',INPUT 'CR').
          ASSIGN i-sequencia = i-sequencia + 10.
          RUN pi-gera-contabilizacao(INPUT 'itens',INPUT 'DB').
      END.    
      IF LAST(tt-resumido.cod-estabel)  THEN
          RUN pi-gera-contabilizacao(INPUT 'executa',INPUT '').
   END. 
END.

PROCEDURE pi-gera-contabilizacao:
    DEF INPUT PARAMETER p-table AS CHAR.
    DEF INPUT PARAMETER p-movto AS CHAR.
    
    CASE p-table:
        WHEN 'lote' THEN DO:
            CREATE tt_integr_lote_ctbl.
            ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul    = 'FGL' 
                   tt_integr_lote_ctbl.tta_num_lote_ctbl          = 1
                   tt_integr_lote_ctbl.tta_des_lote_ctbl          = 'Despesas com Terceirizaá∆o ' + STRING(month(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin))
                   tt_integr_lote_ctbl.tta_cod_empresa            = tt-resumido.cod_empresa
                   tt_integr_lote_ctbl.tta_dat_lote_ctbl          = dt-periodo-fin
                   tt_integr_lote_ctbl.ttv_ind_erro_valid         = "N∆o"
                    tt_integr_lote_ctbl.tta_log_integr_ctbl_online = YES. 
        
            CREATE tt_integr_lancto_ctbl.
            ASSIGN tt_integr_lancto_ctbl.tta_cod_cenar_ctbl            = 'Fiscal'
                   tt_integr_lancto_ctbl.tta_log_lancto_conver         = NO
                   tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo  = NO 
                   tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl      = RECID(tt_integr_lote_ctbl)
                   tt_integr_lancto_ctbl.tta_num_lancto_ctbl           = 10
                   tt_integr_lancto_ctbl.ttv_ind_erro_valid            = "N∆o" 
                   tt_integr_lancto_ctbl.tta_dat_lancto_ctbl           = dt-periodo-fin.
        END. /* Lote */
    
        WHEN 'itens' THEN DO:        
            CREATE  tt_integr_item_lancto_ctbl.
            ASSIGN  tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = RECID(tt_integr_lancto_ctbl)
                    tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-sequencia
                    tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = IF p-movto = 'CR' THEN 'CR' ELSE 'DB' 
                    tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = cod-plano-cta-ctbl
                    tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = IF p-movto = 'CR ' THEN 
                                                                                      ct-cred-despesa  
                                                                                  ELSE
                                                                                      ct-deb-despesa
                    tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = IF p-movto = 'CR' THEN
                                                                                      IF sc-cred-despesa <> '' 
                                                                                         THEN plano_ccusto.cod_plano_ccusto
                                                                                         ELSE ''
                                                                                  ELSE
                                                                                      IF sc-deb-despesa <> '' 
                                                                                         THEN plano_ccusto.cod_plano_ccusto
                                                                                         ELSE ''
                   tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = IF p-movto = 'CR' 
                                                                                    THEN sc-cred-despesa 
                                                                                    ELSE sc-deb-despesa
                    tt_integr_item_lancto_ctbl.tta_cod_estab                    = tt-resumido.cod-estabel
                    tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = v_cod_empres_usuar /*Mario Fleith - Projeto Mekal*/
                    tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = 'Despesas com Terceirizaá∆o ' + STRING(month(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin))
                    tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = histor_finalid_econ.cod_indic_econ
                    tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-periodo-fin
                    tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = tt-resumido.total-nota
                    tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = i-sequencia
                    tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "N∆o" .

            CREATE  tt_integr_aprop_lancto_ctbl.
            ASSIGN  tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = histor_finalid_econ.cod_finalid_econ
                    tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                    tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                    tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                    tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
                    tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                    tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                    tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = dt-periodo-fin
                    tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                    tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "N∆o" 
                    tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
        END. /*Item*/
    
        WHEN  'executa' THEN DO:
        
            RUN pi-acompanhar IN h-acomp ('Contabilizando Lanáamentos...').
            RUN prgfin/fgl/fgl900zh.py (3            , 
                                        "Aborta Tudo",
                                        NO           ,   
                                        NO           , 
                                        "Apropriaá∆o", 
                                        "Com Erro"   , 
                                        YES          , 
                                        YES          ).

            RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros dos Lanáamentos ...').

            FOR EACH tt_integr_ctbl_valid NO-LOCK:
                RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                 INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                CREATE  tt-erro.
                ASSIGN  tt-erro.des_erro    = 'FGL:' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
                                               RETURN-VALUE + CHR(10) + tt_integr_ctbl_valid.ttv_ind_pos_erro.

                CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:
                    WHEN 'ITEM' THEN DO:
                        FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                             WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
                        IF  AVAIL tt_integr_item_lancto_ctbl THEN DO:
                            ASSIGN  tt-erro.des_erro = tt-erro.des_erro + 
                                  ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl) + 
                                    ' Nat:' + tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl    +
                                    ' PCT:' + tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl       +
                                    ' CTA:' + tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl             +
                                    ' PCC:' + tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto         +
                                    ' CCU:' + tt_integr_item_lancto_ctbl.tta_cod_ccusto               + 
                                    ' EST:' + tt_integr_item_lancto_ctbl.tta_cod_estab                + 
                                    ' UNG:' + tt_integr_item_lancto_ctbl.tta_cod_unid_negoc           +
                                    ' HIS:' + tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl   +
                                    ' IEC:' + tt_integr_item_lancto_ctbl.tta_cod_indic_econ           +
                                    ' DAT:' + STRING(tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl)  +
                                    ' VAL:' + STRING(tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl)  + 
                                    ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart) .
                        END.

                    END.
                END CASE.
            END.
        END.
    END CASE.
END PROCEDURE.

PROCEDURE pi_messages:

    DEF INPUT PARAM c_action    AS CHAR    NO-UNDO.
    DEF INPUT PARAM i_msg       AS INTEGER NO-UNDO.
    DEF INPUT PARAM c_param     AS CHAR    NO-UNDO.

    def var c_prg_msg           AS CHAR    NO-UNDO.

    ASSIGN  c_prg_msg = "messages/":U
                      + STRING(TRUNC(i_msg / 1000,0),"99":U)
                      + "/msg":U
                      + STRING(i_msg, "99999":U).

    IF  SEARCH(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "n∆o encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.
END PROCEDURE.  /* pi_messages */

/*Listagem de erros*/
    IF  CAN-FIND(FIRST tt-erro) THEN DO:
        RUN pi-acompanhar IN h-acomp ('Imprimindo listagem de erros ...').
        PAGE.
        HIDE FRAME f-labdet.
        PUT SKIP(2)
            "Listagem de ERROS e INCONSIST“NCIAS" AT 20
            "-----------------------------------" AT 20
            SKIP(2).
        FOR EACH tt-erro NO-LOCK
           BREAK BY tt-erro.cdn_repres:
            IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:
                FIND FIRST representante NO-LOCK
                     WHERE representante.cdn_repres = tt-erro.cdn_repres NO-ERROR.
                IF  AVAIL representante THEN
                    DISPLAY representante.cdn_repres
                            representante.nom_pessoa
                            WITH FRAME f-erro WIDTH 132.
            END. /*IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:*/
            
            FOR EACH tt-editor:     DELETE  tt-editor.      END.
            RUN pi-print-editor (tt-erro.des_erro,  82).
            
            FOR EACH tt-editor:
                DISPLAY tt-editor.conteudo @ tt-erro.des_erro WITH FRAME f-erro WIDTH 132 NO-LABEL.
                DOWN WITH FRAME f-erro.
            END. /*FOR EACH tt-editor*/
            DOWN WITH FRAME f-erro.
        END.
    END.
/*FIM - Listagem de erros*/
 
