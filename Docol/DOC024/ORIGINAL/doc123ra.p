/*****************************************************************************
**       PROGRAMA: doc123ra.p
**       DATA....: Maio de 2013
**       OBJETIVO: Leitura de Horas Extras
**       VERSAO..: 2.10.000 
******************************************************************************/

ON FIND OF histor_sal_func OVERRIDE DO:
END.
ON FIND OF cta_mdo_efp OVERRIDE DO:
END.
ON FIND OF efp_par_marcac_ptoelet OVERRIDE DO:
END.
ON FIND OF par_marcac_ptoelet OVERRIDE DO:
END.
ON FIND OF func_ccusto OVERRIDE DO:
END.
ON FIND OF func_tip_mdo OVERRIDE DO:
END.
ON FIND OF categ_sal OVERRIDE DO:
END.
ON FIND OF movto_calcul_func OVERRIDE DO:
END.
ON FIND OF habilit_calc_fp OVERRIDE DO:
END.



DEFINE TEMP-TABLE tt-func-hra-extra NO-UNDO
    FIELD cdn_empresa       AS INT
    FIELD cdn_estab         AS INT
    FIELD cdn_funcionario   AS INT
    FIELD nom_pessoa        AS CHAR
    FIELD cod_rh_ccusto     AS CHAR
    FIELD cod_tip_mdo       AS CHAR
    FIELD cdn_event_fp      AS CHAR
    FIELD qtd_horas_extras  AS DEC
    FIELD val_horas_extras  AS DEC
    FIELD cod_cta_ctbl_db   AS CHAR
    FIELD origem            AS CHAR
    INDEX ch-prim IS PRIMARY UNIQUE cdn_empresa
                                    cdn_estab
                                    cdn_funcionario
                                    cdn_event_fp.

DEFINE TEMP-TABLE tt-resumo-hra-extra NO-UNDO
    FIELD cdn_empresa       AS CHAR
    FIELD cod_rh_ccusto     AS CHAR
    FIELD cod_cta_ctbl      AS CHAR
    FIELD qtd_horas_extras  AS DEC
    FIELD val_horas_extras  AS DEC
    INDEX ch-prim IS PRIMARY UNIQUE cod_rh_ccusto
                                    cod_cta_ctbl
    .

DEFINE INPUT PARAMETER pAno    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pMes    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-func-hra-extra.
DEFINE OUTPUT PARAMETER TABLE FOR tt-resumo-hra-extra.

DEFINE VARIABLE c-origem        AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-periodo-ini  AS DATE      NO-UNDO.
DEFINE VARIABLE dt-periodo-fim  AS DATE      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE    NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Buscando informa‡äes de Horas Extras ").

FIND FIRST param_empres_rh NO-LOCK
    WHERE param_empres_rh.cdn_empresa = "2" NO-ERROR.

IF pAno = 0 THEN
    ASSIGN pAno = param_empres_rh.num_ano_refer_calc_efetd.

IF pMes = 0 THEN
    ASSIGN pMes = param_empres_rh.num_mes_refer_calc_efetd.

/* Verifica se a folha est  calculada para o per¡odo informado */
FIND FIRST habilit_calc_fp NO-LOCK
    WHERE habilit_calc_fp.cdn_empresa = "2"
    AND   habilit_calc_fp.cdn_estab   = "1"
    AND   habilit_calc_fp.num_ano_refer_fp_calcula = pAno
    AND   habilit_calc_fp.num_mes_refer_fp_calcula = pMes
    AND   habilit_calc_fp.idi_tip_fp               = 1 /* Normal */
    AND   habilit_calc_fp.qti_parc_habilit_calc_fp = 9 /* Parcela Final */ NO-ERROR.

/* Define a origem da informa‡Æo ocnforme a habilita‡Æo do c lculo da folha */
IF AVAIL habilit_calc_fp AND habilit_calc_fp.idi_sit_calc_fp = 3 /* Calculado */ THEN
    ASSIGN c-origem = "MFP".
ELSE
    ASSIGN c-origem = "MPE".

ASSIGN dt-periodo-ini = DATE(pMes,1,pAno)
       dt-periodo-fim = ADD-INTERVAL(dt-periodo-ini,1,"month") - 1.

EMPTY TEMP-TABLE tt-func-hra-extra.
EMPTY TEMP-TABLE tt-resumo-hra-extra.

CASE c-origem:
    WHEN "MFP" THEN RUN pi-carrega-folha.
    WHEN "MPE" THEN RUN pi-carrega-ponto.
END CASE.

RUN pi-finalizar IN h-acomp.

/*
OUTPUT TO c:\spool\ver.txt CONVERT TARGET 'iso8859-1'.
FOR EACH tt-func-hra-extra:
    DISP tt-func-hra-extra.cdn_empresa     
         tt-func-hra-extra.cdn_estab       
         tt-func-hra-extra.cdn_funcionario FORMAT '>>>>>>>>9'
         tt-func-hra-extra.nom_pessoa      FORMAT 'x(60)'
         tt-func-hra-extra.cod_rh_ccusto   FORMAT 'x(8)'
         tt-func-hra-extra.cod_cta_ctbl_db FORMAT 'x(8)'
         tt-func-hra-extra.cod_tip_mdo     
         tt-func-hra-extra.cdn_event_fp    FORMAT 'x(3)'
         tt-func-hra-extra.qtd_horas_extras (TOTAL) FORMAT '>>>,>>>,>>9.99'
         tt-func-hra-extra.val_horas_extras (TOTAL) FORMAT '>>>,>>>,>>9.99'
         tt-func-hra-extra.origem
        WITH STREAM-IO WIDTH 450.
END.
PUT SKIP(3).
FOR EACH tt-resumo-hra-extra:
    DISP tt-resumo-hra-extra.cod_rh_ccusto   
         tt-resumo-hra-extra.cod_cta_ctbl    
         tt-resumo-hra-extra.qtd_horas_extras (TOTAL) FORMAT '>>>,>>>,>>9.99'
         tt-resumo-hra-extra.val_horas_extras (TOTAL) FORMAT '>>>,>>>,>>9.99'
        WITH STREAM-IO.
END.

OUTPUT CLOSE.
*/

PROCEDURE pi-carrega-folha:

    DEFINE VARIABLE i-cont-evt  AS INTEGER NO-UNDO.
    DEFINE VARIABLE c-origem-info AS CHARACTER NO-UNDO.

    RUN pi-seta-titulo IN h-acomp ("Lendo movimentos da Folha").

    ASSIGN c-origem-info = "Horas Extras - Folha de Pagamento (" + STRING(pMes,"99") + "/" + STRING(pAno) + ")".
    FOR EACH tt-estab:
    
        FOR EACH habilit_calc_fp NO-LOCK
            WHERE habilit_calc_fp.cdn_empresa = tt-estab.cod-emp-rh
            AND   habilit_calc_fp.cdn_estab   = tt-estab
            AND   habilit_calc_fp.num_ano_refer_fp_calcula = pAno
            AND   habilit_calc_fp.num_mes_refer_fp_calcula = pMes
            AND   habilit_calc_fp.idi_tip_fp               = 1 /* Normal */
            AND   habilit_calc_fp.qti_parc_habilit_calc_fp = 9 /* Parcela Final */:
    
            FOR EACH movto_calcul_func NO-LOCK
                WHERE movto_calcul_func.cdn_empresa              = habilit_calc_fp.cdn_empresa
                AND   movto_calcul_func.cdn_estab                = habilit_calc_fp.cdn_estab
                AND   movto_calcul_func.cdn_categ_sal            = habilit_calc_fp.cdn_categ_sal
                AND   movto_calcul_func.num_ano_refer_fp         = habilit_calc_fp.num_ano_refer_fp_calcula
                AND   movto_calcul_func.num_mes_refer_fp         = habilit_calc_fp.num_mes_refer_fp_calcula
                AND   movto_calcul_func.idi_tip_fp               = habilit_calc_fp.idi_tip_fp
                AND   movto_calcul_func.qti_parc_habilit_calc_fp = habilit_calc_fp.qti_parc_habilit_calc_fp:
    
                RUN pi-acompanhar IN h-acomp ("Movto Calc Func: " + STRING(movto_calcul_func.cdn_funcionario)).
    
                FIND funcionario OF movto_calcul_func NO-LOCK NO-ERROR.
                FIND LAST func_tip_mdo OF funcionario NO-LOCK
                    WHERE func_tip_mdo.dat_inic_lotac_func <= dt-periodo-fim NO-ERROR.
                
                DO i-cont-evt = 1 TO movto_calcul_func.qti_efp:
                    FIND event_fp NO-LOCK
                        WHERE event_fp.cdn_empresa = "*"
                        AND   event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i-cont-evt] NO-ERROR.
                    IF AVAIL event_fp AND (event_fp.val_tax_multcao_val_unit > 1 OR event_fp.cdn_event_fp = "154" /* Hrs Suplementar Noturna */) THEN DO:
                        CREATE tt-func-hra-extra.
                        ASSIGN tt-func-hra-extra.cdn_empresa      = INT(funcionario.cdn_empresa)
                               tt-func-hra-extra.cdn_estab        = INT(funcionario.cdn_estab)
                               tt-func-hra-extra.cdn_funcionario  = funcionario.cdn_funcionario
                               tt-func-hra-extra.nom_pessoa       = funcionario.nom_pessoa
                               tt-func-hra-extra.cod_rh_ccusto    = movto_calcul_func.cod_rh_ccusto
                               tt-func-hra-extra.cod_tip_mdo      = func_tip_mdo.cod_tip_mdo
                               tt-func-hra-extra.cdn_event_fp     = event_fp.cdn_event_fp
                               tt-func-hra-extra.qtd_horas_extras = movto_calcul_func.qtd_unid_event_fp[i-cont-evt]
                               tt-func-hra-extra.val_horas_extras = movto_calcul_func.val_calcul_efp[i-cont-evt]
                               tt-func-hra-extra.origem           = c-origem-info.
                    END.
                END.
                
            END.
    
        END.

    RUN pi-seta-titulo IN h-acomp ("Sumarizando contas").

    FOR EACH tt-func-hra-extra:

        RUN pi-acompanhar IN h-acomp ("Funcionario: " + STRING(tt-func-hra-extra.cdn_funcionario) + " Evento: " + tt-func-hra-extra.cdn_event_fp).

        FIND FIRST cta_mdo_efp NO-LOCK
            WHERE cta_mdo_efp.cdn_empresa  = string(tt-func-hra-extra.cdn_empresa)
            AND   cta_mdo_efp.cdn_estab    = string(tt-func-hra-extra.cdn_estab)
            AND   cta_mdo_efp.cdn_event_fp = tt-func-hra-extra.cdn_event_fp
            AND   cta_mdo_efp.cod_tip_mdo  = tt-func-hra-extra.cod_tip_mdo NO-ERROR.
        IF NOT AVAIL cta_mdo_efp THEN
            FIND FIRST cta_mdo_efp NO-LOCK
                WHERE cta_mdo_efp.cdn_empresa  = string(tt-func-hra-extra.cdn_empresa)
                AND   cta_mdo_efp.cdn_estab    = "*"
                AND   cta_mdo_efp.cdn_event_fp = tt-func-hra-extra.cdn_event_fp
                AND   cta_mdo_efp.cod_tip_mdo  = tt-func-hra-extra.cod_tip_mdo NO-ERROR.
        IF AVAIL cta_mdo_efp THEN
            ASSIGN tt-func-hra-extra.cod_cta_ctbl_db = cta_mdo_efp.cod_rh_cta_ctbl_db.

        /* Cria um registro resumido por centro de custo e conta */
        FIND tt-resumo-hra-extra
            WHERE tt-resumo-hra-extra.cdn_empresa   = STRING(tt-func-hra-extra.cdn_empresa)
            AND   tt-resumo-hra-extra.cod_rh_ccusto = tt-func-hra-extra.cod_rh_ccusto
            AND   tt-resumo-hra-extra.cod_cta_ctbl  = tt-func-hra-extra.cod_cta_ctbl_db NO-ERROR.
        IF NOT AVAIL tt-resumo-hra-extra THEN DO:
            CREATE tt-resumo-hra-extra.
            ASSIGN tt-resumo-hra-extra.cdn_empresa   = STRING(tt-func-hra-extra.cdn_empresa)
                   tt-resumo-hra-extra.cod_rh_ccusto = tt-func-hra-extra.cod_rh_ccusto
                   tt-resumo-hra-extra.cod_cta_ctbl  = tt-func-hra-extra.cod_cta_ctbl_db.
        END.
        ASSIGN tt-resumo-hra-extra.qtd_horas_extras = tt-resumo-hra-extra.qtd_horas_extras + tt-func-hra-extra.qtd_horas_extras
               tt-resumo-hra-extra.val_horas_extras = tt-resumo-hra-extra.val_horas_extras + tt-func-hra-extra.val_horas_extras.
    END.

END PROCEDURE.

PROCEDURE pi-carrega-ponto:

    DEFINE VARIABLE dt-ponto-ini    AS DATE NO-UNDO.
    DEFINE VARIABLE dt-ponto-fim    AS DATE NO-UNDO.
    DEFINE VARIABLE c-origem-info   AS CHARACTER NO-UNDO.

    /* Busca periodo ponto na categoria salarial */
    /* Mensal e Horista tem a mesma informa‡Æo   */
    FIND FIRST categ_sal NO-LOCK
        WHERE categ_sal.cdn_empresa   = "2"
        AND   categ_sal.cdn_estab     = "1"
        AND   categ_sal.cdn_categ_sal = 1 /* Mensal */ NO-ERROR.

    IF AVAIL categ_sal THEN DO:
        /* Se o periodo ‚ igual ao periodo ponto atual entÆo pega o pr¢prio periodo */
        IF DATE(categ_sal.num_livre_1,1,categ_sal.num_livre_2) = DATE(pMes,1,pAno) THEN
            ASSIGN dt-ponto-ini = ADD-INTERVAL(dt-periodo-ini,-1,'month')
                   dt-ponto-ini = DATE(MONTH(dt-ponto-ini),categ_sal.num_dia_inic_period_pto,YEAR(dt-ponto-ini))
                   dt-ponto-fim = DATE(MONTH(dt-periodo-ini),categ_sal.num_dia_fim_period_pto,YEAR(dt-periodo-ini)).
        ELSE /* Caso contr rio o programa est  buscando as informa‡äes do mˆs atual antes do encerramento do mˆs */
            ASSIGN dt-ponto-ini = ADD-INTERVAL(dt-periodo-ini,-1,'month')
                   dt-ponto-ini = DATE(MONTH(dt-ponto-ini),categ_sal.num_dia_fim_period_pto + 1,YEAR(dt-ponto-ini))
                   dt-ponto-fim = TODAY.
    END.

    RUN pi-seta-titulo IN h-acomp ("Lendo marca‡äes do Ponto").

    /* Busca a ultima marcacao de um funcionario ativo para verificar at‚ quando tem c lculo */
    ASSIGN c-origem-info = "Horas Extras - Controle de Frequˆncia".
    FIND FIRST funcionario NO-LOCK
       WHERE funcionario.cdn_empresa              = "2"
         AND funcionario.idi_orig_contratac_func  = 1 /* Empresa */
         AND funcionario.dat_admis_func           < dt-ponto-ini
         AND funcionario.dat_desligto_func        = ? NO-ERROR.
    IF AVAIL funcionario THEN DO:
        FIND LAST par_marcac_ptoelet OF funcionario NO-LOCK NO-ERROR.
        IF AVAIL par_marcac_ptoelet THEN
            ASSIGN c-origem-info = c-origem-info + " (" + STRING(dt-ponto-ini,"99/99/9999") + " - " + STRING(par_marcac_ptoelet.dat_proces_mpe,"99/99/9999") + ")".
    END.

    /* Busca as marca‡äes do ponto eletr“nico */
    FOR EACH funcionario NO-LOCK
       WHERE funcionario.cdn_empresa              = "2"
         AND funcionario.idi_orig_contratac_func  = 1 /* Empresa */,
        LAST func_tip_mdo OF funcionario NO-LOCK
       WHERE func_tip_mdo.dat_inic_lotac_func <= dt-periodo-fim,
        LAST func_ccusto OF funcionario NO-LOCK
       WHERE func_ccusto.dat_inic_lotac_func <= dt-periodo-fim,
        EACH par_marcac_ptoelet OF funcionario NO-LOCK
       WHERE par_marcac_ptoelet.dat_proces_mpe    > dt-ponto-ini - 1
         AND par_marcac_ptoelet.dat_proces_mpe    < dt-ponto-fim + 1
         AND (par_marcac_ptoelet.idi_tip_ocor_mpe = 3 OR
              par_marcac_ptoelet.idi_tip_ocor_mpe = 6):

        RUN pi-acompanhar IN h-acomp ("Funcionario: " + STRING(funcionario.cdn_funcionario) + " Data: " + STRING(par_marcac_ptoelet.dat_proces_mpe,"99/99/9999")).
    
       FOR EACH efp_par_marcac_ptoelet NO-LOCK
          WHERE efp_par_marcac_ptoelet.cdn_empresa                = par_marcac_ptoelet.cdn_empresa              
            AND efp_par_marcac_ptoelet.cdn_estab                  = par_marcac_ptoelet.cdn_estab                
            AND efp_par_marcac_ptoelet.cdn_funcionario            = par_marcac_ptoelet.cdn_funcionario          
            AND efp_par_marcac_ptoelet.dat_proces_mpe             = par_marcac_ptoelet.dat_proces_mpe           
            AND efp_par_marcac_ptoelet.num_horar_inic_proces_mpe >= par_marcac_ptoelet.num_horar_inic_proces_mpe
            AND efp_par_marcac_ptoelet.num_horar_fim_proces_mpe  <= par_marcac_ptoelet.num_horar_fim_proces_mpe:
           
          FIND FIRST tt-func-hra-extra NO-LOCK
               WHERE tt-func-hra-extra.cdn_empresa      = int(funcionario.cdn_empresa)
                 AND tt-func-hra-extra.cdn_estab        = int(funcionario.cdn_estab)
                 AND tt-func-hra-extra.cdn_funcionario  = funcionario.cdn_funcionario
                 AND tt-func-hra-extra.cdn_event_fp     = efp_par_marcac_ptoelet.cdn_efp NO-ERROR.
          IF NOT AVAIL tt-func-hra-extra THEN DO:
             CREATE tt-func-hra-extra.
             ASSIGN tt-func-hra-extra.cdn_empresa      = int(funcionario.cdn_empresa)
                    tt-func-hra-extra.cdn_estab        = int(funcionario.cdn_estab)
                    tt-func-hra-extra.cdn_funcionario  = funcionario.cdn_funcionario
                    tt-func-hra-extra.nom_pessoa       = funcionario.nom_pessoa
                    tt-func-hra-extra.cod_rh_ccusto    = func_ccusto.cod_rh_ccusto
                    tt-func-hra-extra.cod_tip_mdo      = func_tip_mdo.cod_tip_mdo
                    tt-func-hra-extra.cdn_event_fp     = efp_par_marcac_ptoelet.cdn_efp
                    tt-func-hra-extra.origem           = c-origem-info.
          END.
          ASSIGN tt-func-hra-extra.qtd_horas_extras = tt-func-hra-extra.qtd_horas_extras + efp_par_marcac_ptoelet.qti_hrs_marcac_ptoelet.
          
       END.
    END.

    RUN pi-seta-titulo IN h-acomp ("Sumarizando contas").

    FOR EACH tt-func-hra-extra:

        RUN pi-acompanhar IN h-acomp ("Funcionario: " + STRING(tt-func-hra-extra.cdn_funcionario) + " Evento: " + tt-func-hra-extra.cdn_event_fp).

        FIND FIRST cta_mdo_efp NO-LOCK
            WHERE cta_mdo_efp.cdn_empresa  = string(tt-func-hra-extra.cdn_empresa)
            AND   cta_mdo_efp.cdn_estab    = string(tt-func-hra-extra.cdn_estab)
            AND   cta_mdo_efp.cdn_event_fp = tt-func-hra-extra.cdn_event_fp
            AND   cta_mdo_efp.cod_tip_mdo  = tt-func-hra-extra.cod_tip_mdo NO-ERROR.
        IF NOT AVAIL cta_mdo_efp THEN
            FIND FIRST cta_mdo_efp NO-LOCK
                WHERE cta_mdo_efp.cdn_empresa  = string(tt-func-hra-extra.cdn_empresa)
                AND   cta_mdo_efp.cdn_estab    = "*"
                AND   cta_mdo_efp.cdn_event_fp = tt-func-hra-extra.cdn_event_fp
                AND   cta_mdo_efp.cod_tip_mdo  = tt-func-hra-extra.cod_tip_mdo NO-ERROR.
        IF AVAIL cta_mdo_efp THEN
            ASSIGN tt-func-hra-extra.cod_cta_ctbl_db = cta_mdo_efp.cod_rh_cta_ctbl_db.

        /* Valoriza o evento de hora extra conforme valor hora e taxa de multiplica‡Æo */
        FIND event_fp NO-LOCK 
            WHERE event_fp.cdn_empresa = "*"
            AND   event_fp.cdn_event_fp = tt-func-hra-extra.cdn_event_fp NO-ERROR.
        FIND funcionario NO-LOCK
            WHERE funcionario.cdn_empresa = STRING(tt-func-hra-extra.cdn_empresa)
            AND   funcionario.cdn_estab   = STRING(tt-func-hra-extra.cdn_estab)
            AND   funcionario.cdn_funcionario = tt-func-hra-extra.cdn_funcionario NO-ERROR.
        FIND LAST histor_sal_func OF funcionario NO-LOCK
             WHERE histor_sal_func.dat_liber_sal <= dt-periodo-fim NO-ERROR.
        ASSIGN tt-func-hra-extra.val_horas_extras = (tt-func-hra-extra.qtd_horas_extras / 3600) * histor_sal_func.val_salario_hora * event_fp.val_tax_multcao_val_unit
               tt-func-hra-extra.qtd_horas_extras = (tt-func-hra-extra.qtd_horas_extras / 3600) /* Acumula em horas e nÆo em segundos */.

        /* Cria um registro resumido por centro de custo e conta */
        FIND tt-resumo-hra-extra
            WHERE tt-resumo-hra-extra.cdn_empresa   = STRING(tt-func-hra-extra.cdn_empresa)
            AND   tt-resumo-hra-extra.cod_rh_ccusto = tt-func-hra-extra.cod_rh_ccusto
            AND   tt-resumo-hra-extra.cod_cta_ctbl  = tt-func-hra-extra.cod_cta_ctbl_db NO-ERROR.
        IF NOT AVAIL tt-resumo-hra-extra THEN DO:
            CREATE tt-resumo-hra-extra.
            ASSIGN tt-resumo-hra-extra.cdn_empresa   = STRING(tt-func-hra-extra.cdn_empresa)
                   tt-resumo-hra-extra.cod_rh_ccusto = tt-func-hra-extra.cod_rh_ccusto
                   tt-resumo-hra-extra.cod_cta_ctbl  = tt-func-hra-extra.cod_cta_ctbl_db.
        END.
        ASSIGN tt-resumo-hra-extra.qtd_horas_extras = tt-resumo-hra-extra.qtd_horas_extras + tt-func-hra-extra.qtd_horas_extras
               tt-resumo-hra-extra.val_horas_extras = tt-resumo-hra-extra.val_horas_extras + tt-func-hra-extra.val_horas_extras.
    END.

END PROCEDURE.
