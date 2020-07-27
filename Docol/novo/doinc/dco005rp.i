/* DCO005RP.i */

FOR EACH tt-movto NO-LOCK
   BREAK BY tt-movto.cdn_repres
         BY {1}
         BY tt-movto.cod_estab
         BY tt-movto.cod_espec_docto
         BY tt-movto.cod_ser_docto
         BY tt-movto.cod_tit_acr
         BY tt-movto.cod_parcela:

    IF  FIRST-OF(tt-movto.cdn_repres) THEN DO:
        FIND FIRST tt-repres NO-LOCK
             WHERE tt-repres.cod_empresa    = tt-movto.cod_empresa
               AND tt-repres.cdn_repres     = tt-movto.cdn_repres NO-ERROR.

        DISPLAY tt-movto.cdn_repres     tt-movto.nom_pessoa 
                dt-ini-periodo          dt-fim-periodo WITH FRAME f-repres.
        ASSIGN  de-rep-base      = 0
                de-rep-comis     = 0
                de-rep-estor     = 0
                de-rep-vincu     = 0
                c-cod_tip_repres = tt-repres.cod_tip_repres.
        
        /* ----- L¢gica para o projeto de fechamento antecipado ---- */
        ASSIGN c-periodo-atu     = SUBSTRING(c-meses[MONTH(dt-fim-periodo)],1,3) + "/" + SUBSTRING(STRING(YEAR(dt-fim-periodo)),3,2)
               c-periodo-prox    = SUBSTRING(c-meses[MONTH(ADD-INTERVAL(dt-fim-periodo,1,"month"))],1,3) + "/" + SUBSTRING(STRING(YEAR(ADD-INTERVAL(dt-fim-periodo,1,"month"))),3,2)
               c-periodo         = c-periodo-atu
               dt-fechamento-ini = dt-ini-periodo
               dt-fechamento-fim = dt-fim-periodo
               l-rep-fecha-ant   = NO.

        FOR FIRST dc-fechamento-rep NO-LOCK
            WHERE dc-fechamento-rep.cod-rep = tt-movto.cdn_repres,
            EACH dc-fechamento-periodo NO-LOCK
            WHERE dc-fechamento-periodo.cod-cenario = dc-fechamento-rep.cod-cenario
            AND   dc-fechamento-periodo.periodo     = STRING(YEAR(dt-fim-periodo)) + STRING(MONTH(dt-fim-periodo),"99")
            AND   dc-fechamento-periodo.log-comis:
            ASSIGN dt-fechamento-ini = dc-fechamento-periodo.dt-inicio
                   dt-fechamento-fim = dc-fechamento-periodo.dt-termino
                   l-rep-fecha-ant   = YES.
        END.
        /* Fim ----- L¢gica para o projeto de fechamento antecipado ---- */

    END.

    ASSIGN l-cliente-home-center = NO.
    IF  FIRST-OF({1}) THEN DO:
        FIND FIRST emsuni.cliente NO-LOCK
             WHERE emsuni.cliente.cod_empresa = tt-movto.cod_empresa /*'DOC'*/
               AND emsuni.cliente.cdn_cliente = tt-movto.cdn_cliente NO-ERROR.
        IF emsuni.cliente.num_pessoa / 2 <> INT(emsuni.cliente.num_pessoa / 2) THEN DO:
           FIND FIRST pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emsuni.cliente.num_pessoa NO-ERROR.
           IF AVAIL pessoa_jurid THEN
              ASSIGN c-cidade = pessoa_jurid.nom_cidade
                     c-uf     = pessoa_jurid.cod_unid_federac.
           ELSE
              ASSIGN c-cidade = ''
                     c-uf     = ''.
        END.
        ELSE DO:
           FIND FIRST pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emsuni.cliente.num_pessoa NO-ERROR.
           IF AVAIL pessoa_fisic THEN
              ASSIGN c-cidade = pessoa_fisic.nom_cidade
                     c-uf     = pessoa_fisic.cod_unid_federac.
           ELSE
              ASSIGN c-cidade = ''
                     c-uf     = ''.
        END.

        ASSIGN l-cliente-home-center = NO.
        IF l-rep-fecha-ant THEN DO:
            /* --- Cliente HOME CENTER n∆o participam do projeto de fechamento antecipado --- */
            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = emsuni.cliente.cdn_cliente NO-ERROR.
            FIND FIRST regiao-cliente NO-LOCK
                 WHERE regiao-cliente.nome-matriz = emitente.nome-matriz NO-ERROR.
            IF AVAIL regiao-cliente THEN
                ASSIGN l-cliente-home-center = YES.
        END.

        DISPLAY tt-movto.cdn_cliente tt-movto.nom_cliente c-cidade c-uf
                WITH FRAME f-cliente.
        ASSIGN  de-cli-base     = 0
                de-cli-comis    = 0
                de-cli-estor    = 0
                de-cli-vincu    = 0.
    END.

    /* SSI 071/2006 */
    IF c-cod_tip_repres = "EXP" THEN DO:
       RUN dop/dco005f.p (INPUT tt-movto.cod_estab,  
                          INPUT tt-movto.cod_ser_doc,
                          INPUT tt-movto.cod_tit_acr,
                          INPUT tt-movto.cdn_repres,
                          OUTPUT de-perc-comis-exp).
       IF de-perc-comis-exp <> 0 THEN DO:
          FIND FIRST b-tt-movto EXCLUSIVE-LOCK
               WHERE RECID(b-tt-movto) = RECID(tt-movto) NO-ERROR.
          ASSIGN b-tt-movto.val_perc_comis = de-perc-comis-exp.
       END.
    END.
    /* FIM-SSI 071/2006 */

    IF tt-movto.cod_espec_docto = "VD" THEN DO: /* Vendor com Comiss∆o na Liquidaá∆o - Percentual com decimais em virtude do Valor L°quido da VD ser igual ao Valor Original em virtude da Renegociaá∆o */
       FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab       = tt-movto.cod_estab
              AND tit_acr.cod_espec_docto = tt-movto.cod_espec_docto
              AND tit_acr.cod_ser_docto   = tt-movto.cod_ser_docto
              AND tit_acr.cod_tit_acr     = tt-movto.cod_tit_acr
              AND tit_acr.cod_parcela     = tt-movto.cod_parcela NO-ERROR.

       IF AVAIL tit_acr THEN DO:
          FIND FIRST dc-tit_acr OF tit_acr NO-LOCK NO-ERROR.
          FIND FIRST b-movto-ve NO-LOCK /* VE */
               WHERE b-movto-ve.cod_estab           = tit_acr.cod_estab
                 AND b-movto-ve.cod_refer           = dc-tit_acr.vend-cod-refer
                 AND b-movto-ve.ind_trans_acr_abrev = 'LQRN' 
                 AND NOT b-movto-ve.log_movto_estordo NO-ERROR.

          IF AVAIL b-movto-ve THEN DO:
             FIND FIRST b-tit-ve OF b-movto-ve NO-LOCK NO-ERROR.
             IF AVAIL b-tit-ve THEN DO:
                FIND FIRST repres_tit_acr NO-LOCK
                     WHERE repres_tit_acr.cod_estab      = b-tit-ve.cod_estab
                       AND repres_tit_acr.num_id_tit_acr = b-tit-ve.num_id_tit_acr
                       AND repres_tit_acr.cdn_repres     = tt-movto.cdn_repres NO-ERROR.
                IF AVAIL repres_tit_acr                       AND
                   repres_tit_acr.val_perc_comis_repres <> 0 THEN DO:
                   FIND FIRST b-tt-movto EXCLUSIVE-LOCK
                        WHERE RECID(b-tt-movto) = RECID(tt-movto) NO-ERROR.
                   ASSIGN b-tt-movto.val_perc_comis = repres_tit_acr.val_perc_comis_repres. /* Busca percentual de comiss∆o original da VE */
                END.
             END.
          END.
       END.
    END. /* FIM-Vendor com Comiss∆o na Liquidaá∆o - Percentual com decimais em virtude do Valor L°quido da VD ser igual ao Valor Original em virtude da Renegociaá∆o */

    ASSIGN c-periodo = c-periodo-atu.

    IF l-rep-fecha-ant            AND 
       l-cliente-home-center = NO AND
       NOT tg-rescisao            THEN DO:
        /* Replica a mesma l¢gica para seleá∆o dos t°tulos que entram na transaá∆o 2 */
        IF  LOOKUP(tt-movto.cod_espec_docto,"LP,LM") = 0 AND 
            tt-movto.val_movto_comis   <> 0              AND
            tt-movto.val_movto_estorno =  0 THEN DO:
            FIND FIRST movto_comis_repres OF tt-movto NO-LOCK
                 WHERE movto_comis_repres.ind_tip_movto         = "REALIZADO"
                   AND movto_comis_repres.ind_natur_lancto_ctbl = "CR" NO-ERROR.
            IF (if avail movto_comis_repres then movto_comis_repres.dat_transacao else tt-movto.dat_emis_docto) > dt-fechamento-fim AND
               (if avail movto_comis_repres then movto_comis_repres.dat_transacao else tt-movto.dat_emis_docto) <= dt-fim-periodo THEN DO:
                ASSIGN c-periodo = c-periodo-prox.

                FIND FIRST tt-repres
                     WHERE tt-repres.cod_empresa    = tt-movto.cod_empresa
                       AND tt-repres.cdn_repres     = tt-movto.cdn_repres NO-ERROR.

                IF  movto_comis_repres.ind_trans_comis = "Comiss∆o Emiss∆o" THEN DO:
                    ASSIGN  tt-repres.de-tot-pg-emiss[1]  = tt-repres.de-tot-pg-emiss[1] - movto_comis_repres.val_movto_comis
                            tt-repres.de-tot-pg-emiss[2]  = tt-repres.de-tot-pg-emiss[2] + movto_comis_repres.val_movto_comis.
                    IF LOOKUP(tit_acr.cod_espec_docto,"VD,VV") = 0 THEN 
                       ASSIGN  tt-repres.de-tot-vinc-mes[1]       = tt-repres.de-tot-vinc-mes[1] - movto_comis_repres.val_movto_comis
                               tt-repres.de-tot-vinc-mes[2]       = tt-repres.de-tot-vinc-mes[2] + movto_comis_repres.val_movto_comis.
                END. /* if Comiss∆o Emiss∆o */
                ELSE DO: /* Comiss∆o na Liquidaá∆o */
                   ASSIGN  tt-repres.de-tot-pg-baixa[1]  = tt-repres.de-tot-pg-baixa[1] - movto_comis_repres.val_movto_comis
                           tt-repres.de-tot-pg-baixa[2]  = tt-repres.de-tot-pg-baixa[2] + movto_comis_repres.val_movto_comis.
                END.
            END.
        END.
    END.



    IF tt-movto.val_movto_vincul > 0 THEN
        ASSIGN c-periodo = ''.
        

        FIND FIRST classif_impto NO-LOCK WHERE classif_impto.cod_pais = "BRA"
                                         AND   classif_impto.cod_imposto = "26"
                                         AND   classif_impto.cod_classif_impto = "5979" NO-ERROR. /* PIS SOBRE SERVICOS */

            IF AVAIL classif_impto THEN

            ASSIGN de-perc-pis = classif_impto.val_aliq_impto.

            ELSE 

            ASSIGN de-perc-pis = 0.


        FIND FIRST classif_impto NO-LOCK WHERE classif_impto.cod_pais = "BRA"
                                         AND   classif_impto.cod_imposto = "27"
                                         AND   classif_impto.cod_classif_impto = "5960" NO-ERROR. /* cofins SOBRE SERVICOS */

            IF AVAIL classif_impto THEN

            ASSIGN de-perc-cofins = classif_impto.val_aliq_impto.

            ELSE 

            ASSIGN de-perc-cofins = 0.

            FIND FIRST representante NO-LOCK WHERE representante.cod_empresa = tt-movto.cod_empresa
                                             AND   representante.cdn_repres  = tt-movto.cdn_repres NO-ERROR.

            FIND FIRST funcionario NO-LOCK WHERE funcionario.cod_id_feder = representante.cod_id_feder NO-ERROR.

            IF NOT AVAIL funcionario THEN

            ASSIGN de-vlr-pis-cofins = tt-movto.val_movto_vincul *  ((de-perc-pis + de-perc-cofins) / 100)
                   de-vlr-liquido    = tt-movto.val_movto_vincul - de-vlr-pis-cofins.

            IF AVAIL funcionario THEN

                ASSIGN de-perc-pis = 0
                       de-perc-cofins = 0
                       de-vlr-pis-cofins = 0
                       de-vlr-liquido    = tt-movto.val_movto_vincul - de-vlr-pis-cofins.




    IF tt-movto.val_movto_vincul > 0 THEN
        ASSIGN c-periodo = ''.

    DISPLAY tt-movto.cod_estab         
            tt-movto.cod_espec_docto   
            tt-movto.cod_ser_docto     
            tt-movto.cod_tit_acr        
            tt-movto.cod_parcela       
            tt-movto.dat_emis_docto
            tt-movto.dat_vencto_tit_acr
            WITH FRAME f-movto.

    DISPLAY tt-movto.dat_liquidac_tit_acr   WHEN tt-movto.dat_liquidac_tit_acr <> 12/31/9999
            /* tt-movto.val_base_calc_comis    */
           ((tt-movto.val_movto_comis + tt-movto.val_movto_vincul) / (tt-movto.val_perc_comis / 100)) @ tt-movto.val_base_calc_comis
            tt-movto.val_perc_comis         
            tt-movto.val_movto_comis        
            tt-movto.val_movto_estorno      
           (tt-movto.val_movto_comis - tt-movto.val_movto_estorno)
            @ de-val-credi                  
            tt-movto.val_movto_vincul
            tt-movto.vincul-no-mes
            c-periodo @ tt-movto.periodo
            de-vlr-pis-cofins
            de-vlr-liquido
            WITH FRAME f-movto.
    DOWN WITH FRAME f-movto.

    ASSIGN  de-cli-base          = de-cli-base   + ((tt-movto.val_movto_comis + tt-movto.val_movto_vincul) / (tt-movto.val_perc_comis / 100))
            de-cli-comis         = de-cli-comis  + tt-movto.val_movto_comis
            de-cli-estor         = de-cli-estor  + tt-movto.val_movto_estorn
            de-cli-vincu         = de-cli-vincu  + tt-movto.val_movto_vincul
            de-cli-pis-cofins    = (de-cli-vincu  * ((de-perc-pis + de-perc-cofins) / 100))
            de-cli-vlr-liquido   = de-cli-vincu - de-cli-pis-cofins.          
        

    IF  LAST-OF({1}) THEN DO:
        DISPLAY '     Total' @ tt-movto.dat_emis_docto
                'Cliente...' @ tt-movto.dat_vencto_tit_acr
                '.........:' @ tt-movto.dat_liquidac_tit_acr
                de-cli-base  @ tt-movto.val_base_calc_comis
                de-cli-comis @ tt-movto.val_movto_comis
                de-cli-estor @ tt-movto.val_movto_estorno
                de-cli-comis -
                de-cli-estor @ de-val-credi
                de-cli-vincu @ tt-movto.val_movto_vincul
                de-cli-pis-cofins  @ de-vlr-pis-cofins
                de-cli-vlr-liquido @ de-vlr-liquido
            WITH FRAME f-movto.
        PUT SKIP(1).
        ASSIGN  de-rep-base          = de-rep-base   + de-cli-base  
                de-rep-comis         = de-rep-comis  + de-cli-comis 
                de-rep-estor         = de-rep-estor  + de-cli-estor 
                de-rep-vincu         = de-rep-vincu  + de-cli-vincu
                de-rep-pis-cofins    = de-rep-vincu * ((de-perc-pis + de-perc-cofins) / 100)        
                de-rep-vlr-liquido   = de-rep-vincu - de-rep-pis-cofins.          
            
            .
    END.

    IF  LAST-OF(tt-movto.cdn_repres) THEN DO:

        FIND FIRST tt-repres NO-LOCK
             WHERE tt-repres.cod_empresa    = tt-movto.cod_empresa
               AND tt-repres.cdn_repres     = tt-movto.cdn_repres NO-ERROR.

        FIND FIRST tt-repres-202 OF tt-repres NO-ERROR.

        ASSIGN  de-tot-total = tt-repres.de-tot-pg-emiss[1] + tt-repres.de-tot-pg-baixa[1] - tt-repres.de-tot-pg-estor[1] + tt-repres-202.de-tot-pg-emiss + tt-repres-202.de-tot-pg-baixa +
                               tt-repres.de-tot-pg-emiss[2] + tt-repres.de-tot-pg-baixa[2] - tt-repres.de-tot-pg-estor[2].

        DISPLAY '     Total'                @ tt-movto.dat_emis_docto
                'Repres....'                @ tt-movto.dat_vencto_tit_acr
                '.........:'                @ tt-movto.dat_liquidac_tit_acr
                de-rep-base                 @ tt-movto.val_base_calc_comis
                de-rep-comis                @ tt-movto.val_movto_comis
                de-rep-estor                @ tt-movto.val_movto_estorno
                de-rep-comis - de-rep-estor @ de-val-credi 
                de-rep-vincu                @ tt-movto.val_movto_vincul 
                de-rep-pis-cofins           @ de-vlr-pis-cofins
                de-rep-vlr-liquido          @ de-vlr-liquido WITH FRAME f-movto.
        PUT SKIP(2)
            "RESUMO DO REPRESENTANTE: " tt-movto.cdn_repres 
            "Pagto Emiss∆o ("           AT 035  c-periodo-atu ") " (tt-repres.de-tot-pg-emiss[1] + tt-repres-202.de-tot-pg-emiss) FORMAT '>>>>,>>9.99'
            "Pagto Baixa ("             AT 070  c-periodo-atu ") " (tt-repres.de-tot-pg-baixa[1] + tt-repres-202.de-tot-pg-baixa) FORMAT '>>>>,>>9.99'
            "Estorno ("                 AT 104  c-periodo-atu ") " tt-repres.de-tot-pg-estor[1] SKIP
            "Pagto Emiss∆o ("           AT 035  c-periodo-prox ") " tt-repres.de-tot-pg-emiss[2]
            "Pagto Baixa ("             AT 070  c-periodo-prox ") " tt-repres.de-tot-pg-baixa[2]
            "Estorno ("                 AT 104  c-periodo-prox ") " tt-repres.de-tot-pg-estor[2]
            "Total................: "   AT 035  de-tot-total FORMAT '>>>>,>>9.99' SKIP(1).
        PAGE.
    END.
END.

/* FIM DCO005RP.i */

